Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0HaRkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 13:40:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:30655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab0HaRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 13:40:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,299,1280732400"; 
   d="scan'208";a="550433710"
Date: Tue, 31 Aug 2010 10:30:23 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>
Subject: Re: [Patch-next -v2]therm_throt.c: Trival fix for a unsuitable
	abbreviation  of thermal.
Message-ID: <20100831173022.GB30454@fenghua-desk.sc.intel.com>
References: <4C7B6358.3040703@np.css.fujitsu.com> <20100830095753.6724bc89@hyperion.delvare> <4C7C492D.5020704@np.css.fujitsu.com> <20100831085653.711c38eb@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100831085653.711c38eb@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 11:56:53PM -0700, Jean Delvare wrote:
> On Tue, 31 Aug 2010 09:13:33 +0900, Jin Dongming wrote:
> > In unexpected_thermal_interrupt(), "LVT TMR interrupt" is used
> > in error message.
> > 
> > I don't think TMR is a suitable abbreviation for thermal.
> >   1.TMR has been used in IA32 Architectures Software Developer's
> >     Manual, and is the abbreviation for Trigger Mode Register.
> >   2.There is not an standard abbreviation "TMR" defined for thermal
> >     in IA32 Architectures Software Developer's Manual.
> >   3.Though we could understand it as Thermal Monitor Register, it is
> >     easy to be misunderstood as a *TIMER* interrupt also.
> > 
> > I think this patch will fix it.
> > 
> > Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> 
> Reviewed-by: Jean Delvare <khali@linux-fr.org>
 Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
> 
> > ---
> >  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > index d9368ee..ba52598 100644
> > --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > @@ -349,7 +349,7 @@ static void intel_thermal_interrupt(void)
> >  
> >  static void unexpected_thermal_interrupt(void)
> >  {
> > -	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
> > +	printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
> >  			smp_processor_id());
> >  	add_taint(TAINT_MACHINE_CHECK);
> >  }
> 
> 
> -- 
> Jean Delvare
