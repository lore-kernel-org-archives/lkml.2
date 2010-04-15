Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab0DOVEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 17:04:04 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:58955 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab0DOVEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 17:04:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZPrVRiOKRpAuDmy+dpzLHMrMGy51ew+OXGbKZawTUSGr1RgJep+ziMLLtE9veI+1ba
         VWOPWuMyQxaTTCTQSmq6ViCRu/Vm52cRp+2yCJDtXZ8X/rDL8HuLlpEXhvOjx7+u9J4+
         hhjibYro+MkpEWkZVhaOGxA/UXANEZBRefk88=
Date: Thu, 15 Apr 2010 23:03:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] Stop tracing on a schedule bug
Message-ID: <20100415210357.GG5069@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com> <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271262016-18650-3-git-send-email-chase.douglas@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 12:20:16PM -0400, Chase Douglas wrote:
> This change adds a tracing_off_event() call to stop tracing on schedule
> bugs unless tracing_off=none was specified on the commandline.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
>  kernel/sched.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6af210a..439f036 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3590,6 +3590,8 @@ static noinline void __schedule_bug(struct task_struct *prev)
>  {
>  	struct pt_regs *regs = get_irq_regs();
>  
> +	tracing_off_event(TRACE_EVENT_BUG);
> +
>  	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
>  		prev->comm, prev->pid, preempt_count());



I would rather call that a TRACE_EVENT_WARN as this is what happens: we
warn but we continue.

