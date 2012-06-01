Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693Ab2FASmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 14:42:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36089 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770Ab2FASmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 14:42:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6729"; a="194579993"
Date: Fri, 1 Jun 2012 11:42:12 -0700
From: David Brown <davidb@codeaurora.org>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [PATCH 05/20] hexagon: Do not call do_signal() with irqs disabled
Message-ID: <20120601184212.GB20460@codeaurora.org>
References: <1337983476-22081-1-git-send-email-richard@nod.at>
 <1337983476-22081-5-git-send-email-richard@nod.at>
 <20120601175459.GA23541@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120601175459.GA23541@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 12:54:59PM -0500, Richard Kuo wrote:
> On Sat, May 26, 2012 at 12:04:21AM +0200, Richard Weinberger wrote:
> > get_signal_to_deliver() calls try_to_freeze() which might sleep.
> > 
> > Cc: Richard Kuo <rkuo@codeaurora.org>
> > Cc: linux-hexagon@vger.kernel.org
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  arch/hexagon/kernel/signal.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/hexagon/kernel/signal.c b/arch/hexagon/kernel/signal.c
> > index 434866e..8403bfd 100644
> > --- a/arch/hexagon/kernel/signal.c
> > +++ b/arch/hexagon/kernel/signal.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/syscalls.h>
> >  #include <linux/freezer.h>
> >  #include <linux/tracehook.h>
> > +#include <linux/irqflags.h>
> >  #include <asm/registers.h>
> >  #include <asm/thread_info.h>
> >  #include <asm/unistd.h>
> > @@ -267,6 +268,8 @@ no_restart:
> >  
> >  void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
> >  {
> > +	local_irq_enable();
> > +
> >  	if (thread_info_flags & _TIF_SIGPENDING)
> >  		do_signal(regs);
> >  
> > -- 
> > 1.7.7.3
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Did you mean Acked-by?  Replying to an email with a Signed-off-by
doesn't mean anything.  If you're pulling the patch into your own
tree, add the SoB at that point.  If you want to reply that you've
accepted a patch, just say so in English.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
