Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab2CMTYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:24:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10177 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab2CMTYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:24:14 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=HIWqMhtmd3UA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=GSbZ7oTb3Y0OcxLniXsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1331666651.25686.665.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH-RT] preempt.h: Fix implicit declaration of
 'preempt_check_resched_rt'
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rt-users <linux-rt-users@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Date: Tue, 13 Mar 2012 15:24:11 -0400
In-Reply-To: <1331237591-4406-1-git-send-email-jkacur@redhat.com>
References: <1331237591-4406-1-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Can you apply this patch (with the fixed "tested-by") and push out a new
3.2-rt?

This bug is causing one of my "stable tests" to fail, and I wont push
out a new stable test until it passes. But I also wont add a fix that is
not in your tree. This means that 3.0-rt is being held back until this
gets applied.

Thanks,

-- Steve


On Thu, 2012-03-08 at 21:13 +0100, John Kacur wrote:
> When building a non-preempt kernel where CONFIG_PREEMPT_COUNT is not
> defined the following build break occurs.
> 
> /home/jkacur/linux-rt/block/blk-softirq.c: In function ‘trigger_softirq’:
> /home/jkacur/linux-rt/block/blk-softirq.c:54: error: implicit declaration of function ‘preempt_check_resched_rt’
> make[2]: *** [block/blk-softirq.o] Error 1
> make[1]: *** [block/blk-softirq.o] Error 2
> make: *** [sub-make] Error 2
> 
> This patch fixes the build error by adding a define to the
> !CONFIG_PREEMPT_COUNT section.
> 
> Signed-off-by: Clark Williams <williams@redhat.com>
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  include/linux/preempt.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/preempt.h b/include/linux/preempt.h
> index fa40695..58d8982 100644
> --- a/include/linux/preempt.h
> +++ b/include/linux/preempt.h
> @@ -107,6 +107,7 @@ do { \
>  #define preempt_disable_notrace()		do { } while (0)
>  #define preempt_enable_no_resched_notrace()	do { } while (0)
>  #define preempt_enable_notrace()		do { } while (0)
> +#define preempt_check_resched_rt()	do { } while (0)
>  
>  #endif /* CONFIG_PREEMPT_COUNT */
>  


