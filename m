Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab1CVPeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:34:50 -0400
Received: from smtpbg55.qq.com ([64.71.138.44]:36309 "HELO smtpbg55.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753239Ab1CVPer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:34:47 -0400
X-QQ-mid: esmtp10t1300807965t827t02904
X-QQ-SSF: 00000000000000F0FF300F000000000
Date: Tue, 22 Mar 2011 23:32:47 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <201103201523220468314@foxmail.com>
Subject: Re: Re: cfq-iosched.c: panic in cfq_dispatch_requests
Message-ID: <201103222332465003523@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-21 22:08:19, Vivek Goyal wrote:
>On Sun, Mar 20, 2011 at 03:23:23PM +0800, Lina Lu wrote:
>> Hi Vivek,
>> 
>> I did some test with blkio weight policy these days. The kernel panic 
>> once in a while. 
>> 	
>> From the calltrace, It 's in func cfq_dispatch_requests(+0x058D).
>> And I caught a divide by zero error with system monitor tools.
>
>Hi Lina,
>
>Can you please paste the full backtrace here.
>
>> 	
>> The panic happens when I first set 100 weight to two IO pids, then 
>> change the weight to 200, and begin to perform IO. The kernel panic
>> accurately when the IO begin.
>
>So you notice this only if weights are changed otherwise not?

Hi Vivek

Thanks for this patch! I did objdump and find place that divide by zero.
It's in cfq_group_slice function, the st->total_weight is zero in my issue.
As described in the patch, this is because I change the weight when the
group on service tree. 

Thanks
Lina

>
>Recently Justin fixed a bug in CFQ where crash can happen when weights
>are changed. This fix in Jens's block tree. Can you please apply this
>patch and see if it resolves your issue too.
>
>commit 8184f93eced1e304721c2a55c00d87d5a14f8907
>Author: Justin TerAvest <teravest@google.com>
>Date:   Thu Mar 17 16:12:36 2011 +0100
>
>    cfq-iosched: Don't update group weights when on service tree
>
>Thanks
>Vivek
@
