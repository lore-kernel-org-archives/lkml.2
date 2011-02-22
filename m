Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1BVLiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:38:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49275 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab1BVLip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:38:45 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "hjk@linutronix.de" <hjk@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 22 Feb 2011 17:08:26 +0530
Subject: RE: [PATCH 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources used
 by PRUSS UIO driver
Thread-Topic: [PATCH 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources used
 by PRUSS UIO driver
Thread-Index: AcvR6nTp9F2lwVIeRSKbocXiKzTQ7wAmMedg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BD49121@dbde02.ent.ti.com>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
	<1298041530-26855-2-git-send-email-pratheesh@ti.com>
 <1298041530-26855-3-git-send-email-pratheesh@ti.com>
 <4D629C82.3080906@mvista.com>
In-Reply-To: <4D629C82.3080906@mvista.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sshtylyov@mvista.com]
> Sent: Monday, February 21, 2011 10:40 PM
> To: TK, Pratheesh Gangadhar
> Cc: davinci-linux-open-source@linux.davincidsp.com; gregkh@suse.de;
> Chatterjee, Amit; hjk@linutronix.de; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources used
> by PRUSS UIO driver
> 
> Hello.
> 
> Pratheesh Gangadhar wrote:
> 
> > Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> 
>     Signoff should follow the change log, not precede it. "From:" line may
> precede the change log.
Fixed this in the new version.
> 
> > This patch defines PRUSS, ECAP clocks, memory and IRQ resources
> > used by PRUSS UIO driver in DA850/AM18xx/OMAPL1-38 devices. UIO
> > driver exports 64K I/O region of PRUSS, 128KB L3 RAM and 256KB
> > DDR buffer to user space. PRUSS has 8 host event interrupt lines
> > mapped to IRQ_DA8XX_EVTOUT0..7 of ARM9 INTC.These in conjunction
> > with shared memory can be used to implement IPC between ARM9 and
> > PRUSS.
> 
> > diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-
> davinci/board-da850-evm.c
> > index 11f986b..ddcbac8 100644
> > --- a/arch/arm/mach-davinci/board-da850-evm.c
> > +++ b/arch/arm/mach-davinci/board-da850-evm.c
> > @@ -1077,6 +1077,10 @@ static __init void da850_evm_init(void)
> >  		pr_warning("da850_evm_init: i2c0 registration failed: %d\n",
> >  				ret);
> >
> > +	ret = da8xx_register_pruss();
> > +       if (ret)
> > +                pr_warning("da850_evm_init: pruss registration failed:
> %d\n",
> > +                                 ret);
> >
> >  	ret = da8xx_register_watchdog();
> >  	if (ret)
> 
>     I'd put this into a pacth of its own, to have the SoC level changes
> separated from board-level changes...

Ok. I will do this; I need to make this change for hawkboard as well.
> 
> > diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-
> davinci/da850.c
> > index 3443d97..0096d4f 100644
> > --- a/arch/arm/mach-davinci/da850.c
> > +++ b/arch/arm/mach-davinci/da850.c
> > @@ -238,6 +238,13 @@ static struct clk tptc2_clk = {
> >  	.flags		= ALWAYS_ENABLED,
> >  };
> >
> > +static struct clk pruss_clk = {
> > +	.name		= "pruss",
> > +	.parent		= &pll0_sysclk2,
> > +	.lpsc		= DA8XX_LPSC0_DMAX,
> 
>     We have patch submitted by TI that renames this #define to
> DA8XX_LPSC0_PRUSS...
> 
> > +	.flags		= ALWAYS_ENABLED,
> > +};
> > +
> 
>     We already have patch submitted by TI that defines this clock. It
> would be
> nice if you coordinated your efforts to avoid such conflicts.
>     Again, I'd put the part adding the clocks into a patch of its own.

I will try to sync with that patch. 
> 
> > diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-
> davinci/devices-da8xx.c
> > index beda8a4..4ea3d1f 100644
> > --- a/arch/arm/mach-davinci/devices-da8xx.c
> > +++ b/arch/arm/mach-davinci/devices-da8xx.c
> > @@ -725,3 +725,76 @@ int __init da8xx_register_cpuidle(void)
> >
> >  	return platform_device_register(&da8xx_cpuidle_device);
> >  }
> > +static struct resource pruss_resources[] = {
> > +	[0] = {
> > +		.start  = DA8XX_PRUSS_BASE,
> > +		.end    = DA8XX_PRUSS_BASE + SZ_64K - 1,
> > +		.flags  = IORESOURCE_MEM,
> > +	},
> > +	[1] = {
> > +		.start  = DA8XX_L3RAM_BASE,
> > +		.end    = DA8XX_L3RAM_BASE + SZ_128K - 1,
> > +		.flags  = IORESOURCE_MEM,
> 
>     Are you going to use all SRAM?
Its application dependent - we don't use more than 10KB at this point.
> 
> > +	},
> > +	[2] = {
> > +		.start  = 0,
> > +		.end    = SZ_256K - 1,
> > +		.flags  = IORESOURCE_MEM,
> > +	},
> > +
> > +	[3] = {
> > +		.start  = IRQ_DA8XX_EVTOUT0,
> > +		.end    = IRQ_DA8XX_EVTOUT0,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +	[4] = {
> > +		.start  = IRQ_DA8XX_EVTOUT1,
> > +		.end    = IRQ_DA8XX_EVTOUT1,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +	[5] = {
> > +		.start  = IRQ_DA8XX_EVTOUT2,
> > +		.end    = IRQ_DA8XX_EVTOUT2,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +	[6] = {
> > +		.start  = IRQ_DA8XX_EVTOUT3,
> > +		.end    = IRQ_DA8XX_EVTOUT3,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +	[7] = {
> > +		.start  = IRQ_DA8XX_EVTOUT4,
> > +		.end    = IRQ_DA8XX_EVTOUT4,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +	[8] = {
> > +		.start  = IRQ_DA8XX_EVTOUT5,
> > +		.end    = IRQ_DA8XX_EVTOUT5,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +	[9] = {
> > +		.start  = IRQ_DA8XX_EVTOUT6,
> > +		.end    = IRQ_DA8XX_EVTOUT6,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +	[10] = {
> > +		.start  = IRQ_DA8XX_EVTOUT7,
> > +		.end    = IRQ_DA8XX_EVTOUT7,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +static struct platform_device pruss_device = {
> > +	.name			= "pruss",
> > +	.id			= 0,
> > +	.num_resources		= ARRAY_SIZE(pruss_resources),
> > +	.resource		= pruss_resources,
> > +	.dev	 =	{
> > +		.coherent_dma_mask = 0xffffffff,
> > +	}
> > +};
> > +
> > +int __init da8xx_register_pruss()
> > +{
> > +	return platform_device_register(&pruss_device);
> > +}
> 
>     Again, there's TI patch that adds this device already...
I will check this.


Thanks,
Pratheesh


