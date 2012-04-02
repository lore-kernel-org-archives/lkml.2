Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab2DBH2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 03:28:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57094 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2DBH2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 03:28:12 -0400
Date: Mon, 2 Apr 2012 09:27:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Igor Mammedov <imammedo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: v3.4-rc1 s2ram regression
Message-ID: <20120402072759.GA23234@gmail.com>
References: <20120401132643.4922.79748.stgit@zurg>
 <20120401165354.GA18526@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120401165354.GA18526@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Sun, Apr 01, 2012 at 05:26:43PM +0400, Konstantin Khlebnikov wrote:
> > commit b74f05d61b73af584d0c39121980171389ecfaaa
> > ("x86: kvmclock: abstract save/restore sched_clock_state")
> > breaks s2ram for my notebook. It hangs (maybe panic) somewhere on resume stage
> > and blinks with all possible leds =) Screen is black, so I don't know what happened.
> > 
> > reverting or following patch helps
> > 
> > Bisected-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Cc: Avi Kivity <avi@redhat.com>
> > Cc: Igor Mammedov <imammedo@redhat.com>
> > ---
> >  arch/x86/power/cpu.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> > index 4793683..2bc5a82 100644
> > --- a/arch/x86/power/cpu.c
> > +++ b/arch/x86/power/cpu.c
> > @@ -231,8 +231,8 @@ static void __restore_processor_state(struct saved_context *ctxt)
> >  /* Needed by apm.c */
> >  void restore_processor_state(void)
> >  {
> > -	x86_platform.restore_sched_clock_state();
> >  	__restore_processor_state(&saved_context);
> > +	x86_platform.restore_sched_clock_state();
> >  }
> >  #ifdef CONFIG_X86_32
> >  EXPORT_SYMBOL(restore_processor_state);
> 
> The correct fix is in kvm.git (see below).
> 
> Ingo, can you please merge it through x86 tree while the
> kvm.git issues are resolved? It has been forward to you directly.
> 
>     x86: call restore_sched_clock_state after %gs is initialized
>     
>     restore_sched_clock_state methods use percpu data, therefore they
>     must run after %gs is initialized, but before mtrr_bp_restore (due to
>     lockstat using sched_clock).
>     
>     Move it to the correct place.
>     
>     Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
>     Signed-off-by: Avi Kivity <avi@redhat.com>

Ok, will queue it up.

Thanks,

	Ingo
