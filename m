Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0K3QU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0K3QU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:20:58 -0500
Date: Tue, 30 Nov 2010 11:20:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, yinghai@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, NMI: add back unknown_nmi_panic and
 nmi_watchdog sysctls
Message-ID: <20101130162044.GB18100@redhat.com>
References: <1291068437-5331-1-git-send-email-dzickus@redhat.com>
 <1291068437-5331-3-git-send-email-dzickus@redhat.com>
 <20101130131517.GA16372@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130131517.GA16372@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 04:15:17PM +0300, Cyrill Gorcunov wrote:
> On Mon, Nov 29, 2010 at 05:07:17PM -0500, Don Zickus wrote:
> > Originally adapted from Huang Ying's patch which moved the unknown_nmi_panic
> > to the traps.c file.  Because the old nmi watchdog was deleted before this
> > change happened, the unknown_nmi_panic sysctl was lost.  This re-adds it.
> > 
> > Also, the nmi_watchdog sysctl was re-implemented and its documentation
> > updated accordingly.
> > 
> > Patch-inspired-by: Huang Ying <ying.huang@intel.com>
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> 
> Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
> 
> (a 'thing' below which could be addressed later)
> ...
> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index d91b07d..140344d 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -733,6 +733,22 @@ static struct ctl_table kern_table[] = {
> >  		.extra1		= &zero,
> >  		.extra2		= &one,
> >  	},
> > +	{
> > +		.procname       = "nmi_watchdog",
> > +		.data           = &watchdog_enabled,
> > +		.maxlen         = sizeof (int),
> > +		.mode           = 0644,
> > +		.proc_handler   = proc_dowatchdog_enabled,
> > +	},
> > +#endif
> > +#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
> 
> This kinda wonders me -- do we have CONFIG_X86_LOCAL_APIC set _without_
> CONFIG_X86? I mean CONFIG_X86_LOCAL_APIC is per x86, no?

Probably, I was just copying-n-pasting what was there previously.  I can
chop it off.

Cheers,
Don
