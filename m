Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab1GHGRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 02:17:21 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:39339 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1GHGRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 02:17:18 -0400
X-ASG-Debug-ID: 1310105837-03d6a510a6130430001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E16A0EA.1030703@fusionio.com>
Date: Fri, 8 Jul 2011 08:17:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch]block: avoid building too big plug list
References: <1310090367.15392.263.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [patch]block: avoid building too big plug list
In-Reply-To: <1310090367.15392.263.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310105837
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68297
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-08 03:59, Shaohua Li wrote:
> When I test fio script with big I/O depth, I found the total throughput drops
> compared to some relative small I/O depth. The reason is the thread accumulates
> big requests in its plug list and causes some delays (surely this depends
> on CPU speed).
> I thought we'd better have a threshold for requests. When a threshold reaches,
> this means there is no request merge and queue lock contention isn't severe
> when pushing per-task requests to queue, so the main advantages of blk plug
> don't exist. We can force a plug list flush in this case.
> With this, my test throughput actually increases and almost equals to small
> I/O depth. Another side effect is irq off time decreases in blk_flush_plug_list()
> for big I/O depth.
> The BLK_MAX_REQUEST_COUNT is choosen arbitarily, but 16 is efficiently to
> reduce lock contention to me. But I'm open here, 32 is ok in my test too.

Thanks, I have wondered whether that would potentially cause an issue.
So this patch is quite fine with me, generally a good idea to cap it.
I'll queue it up with 16 for the max depth, that's still quite a decent
proportion of local to queued requests.

Thanks!

-- 
Jens Axboe

