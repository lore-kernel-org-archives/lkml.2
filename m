Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0IMC1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 22:27:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:12662 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0IMC1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 22:27:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,357,1280732400"; 
   d="scan'208";a="656590900"
Subject: Re: [RFC 6/6] x86, NMI, Remove do_nmi_callback logic
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100910161319.GI4879@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	 <1284087065-32722-6-git-send-email-ying.huang@intel.com>
	 <20100910161319.GI4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 10:27:16 +0800
Message-ID: <1284344836.3269.87.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 00:13 +0800, Don Zickus wrote:
> On Fri, Sep 10, 2010 at 10:51:05AM +0800, Huang Ying wrote:
> >  
> > +#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
> > +extern int nmi_watchdog_tick(struct pt_regs *regs);
> > +#else
> > +static inline int nmi_watchdog_tick(struct pt_regs *regs)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> >  extern atomic_t nmi_active;
> >  extern unsigned int nmi_watchdog;
> >  #define NMI_NONE	0
> 
> <snip>
> 
> > @@ -421,12 +429,8 @@ static notrace __kprobes void default_do
> >  	}
> >  	raw_spin_unlock(&nmi_reason_lock);
> >  
> > -#if defined(CONFIG_X86_LOCAL_APIC) && !defined(CONFIG_LOCKUP_DETECTOR)
> > -	if (nmi_watchdog_tick(regs, reason))
> > -		return;
> > -	if (do_nmi_callback(regs, smp_processor_id()))
> > +	if (nmi_watchdog_tick(regs))
> >  		return;
> > -#endif
> >  
> >  	if (notify_die(DIE_NMIUNKNOWN, "nmi_unknown", regs, reason, 2, SIGINT)
> >  	    == NOTIFY_STOP)
> 
> I wonder if these two chunks are going to confuse people when they read
> the code.  The old nmi watchdog exists in the arch/x86 area but the new
> nmi watchdog code is now in kernel/watchdog.c.
> 
> If someone sees nmi_watchdog_tick() here will they assume the nmi watchdog
> code is still inside arch/x86?
> 
> I would suggest keep it wrapped with CONFIG_LOCKUP_DETECTOR to make it
> obvious.  Thoughts?

Is it planned to remove old NMI watchdog implementation in near future?

If it is not, I think it is better to document/comment the two
implementation more explicitly, maybe in nmi_watchdog_tick() comments. I
suspect nmi_watchdog_tick() wrapped with "!
defined(CONFIG_LOCKUP_DETECTOR)" will make people more confused.

Best Regards,
Huang Ying


