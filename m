Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1DUJvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:51:42 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59968 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab1DUJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:51:41 -0400
Date: Thu, 21 Apr 2011 11:51:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
        Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Russ Anderson <rja@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
        EDAC devel <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, MCE: Do not taint when handling correctable
 errors
Message-ID: <20110421095114.GB10263@aftab>
References: <1302857141-17580-1-git-send-email-bp@amd64.org>
 <66D9D2F0CDB5C9428E6166B01EC85EE162EF92B0F3@GVW0676EXC.americas.hpqcorp.net>
 <20110421093554.GB4262@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421093554.GB4262@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 05:35:54AM -0400, Ingo Molnar wrote:
> 
> * Chumbalkar, Nagananda <Nagananda.Chumbalkar@hp.com> wrote:
> 
> > Would it be okay to extend this reasoning and also remove the tainting 
> > caused by TM1/TM2 thermal events:
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > index 6f8c5e9..9f3b5ae 100644
> > --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > @@ -188,7 +188,6 @@ static int therm_throt_process(bool new_event, int event,
> > int level)
> >                                 level == CORE_LEVEL ? "Core" : "Package",
> >                                 state->count);
> > 
> > -               add_taint(TAINT_MACHINE_CHECK);
> >                 return 1;
> >         }
> >         if (old_event) {
> > @@ -393,7 +392,6 @@ static void unexpected_thermal_interrupt(void)
> > {
> >         printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
> >                         smp_processor_id());
> > -       add_taint(TAINT_MACHINE_CHECK);
> > }
> 
> Mind sending a proper patch, with changelog, signoff, acks, etc?

No need since this is part of 7b70bd3441437b7bc04fc9d321e17c8ed0e8f958
now which is in tip/x86/mce.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
