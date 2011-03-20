Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1CTHOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 03:14:15 -0400
Received: from smtpbg52.qq.com ([64.71.138.43]:37353 "HELO smtpbg52.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751370Ab1CTHON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 03:14:13 -0400
X-QQ-mid: esmtp1t1300605132t306t27050
X-QQ-SSF: 00000000000000F0FF300F000000000
Date: Sun, 20 Mar 2011 15:23:23 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: cfq-iosched.c: panic in cfq_dispatch_requests
Message-ID: <201103201523220468314@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

I did some test with blkio weight policy these days. The kernel panic 
once in a while. 
	
>From the calltrace, It 's in func cfq_dispatch_requests(+0x058D).
And I caught a divide by zero error with system monitor tools.
	
The panic happens when I first set 100 weight to two IO pids, then 
change the weight to 200, and begin to perform IO. The kernel panic
accurately when the IO begin.

I try to find the divide 0 code in cfq_dispatch_requests. This function
call the cfq_select_queue to select a queue, and cfq_select_queue
call cfq_choose_cfqg, then choose_service_tree(). There is a expression
of division in choose_service_tree.
	
        slice = group_slice * count /
                max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
                      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));

I don't know whether this code divide 0. Can you take a look of this issue?

Thanks
Lina 



