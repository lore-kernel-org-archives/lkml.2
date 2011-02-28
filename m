Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1B1KJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:09:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33696 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1B1KJP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:09:15 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 28 Feb 2011 15:38:38 +0530
Subject: RE: [PATCH v4 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources
	used by PRUSS UIO driver
Thread-Topic: [PATCH v4 2/2] Defines DA850/AM18xx/OMAPL1-38 SOC resources
	used by PRUSS UIO driver
Thread-Index: AcvU4f49Fzg54d97ReeyVWHymX7IdgCHt6oAAAttnuA=
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024BF35C6E@dbde02.ent.ti.com>
References: <1298556402-26456-1-git-send-email-pratheesh@ti.com>
	<1298556402-26456-2-git-send-email-pratheesh@ti.com>
	<1298556402-26456-3-git-send-email-pratheesh@ti.com>
	<4D6796D6.5050008@mvista.com>
 <B85A65D85D7EB246BE421B3FB0FBB593024BF3591A@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BF3591A@dbde02.ent.ti.com>
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

Hi Pratheesh,

On Mon, Feb 28, 2011 at 10:16:18, TK, Pratheesh Gangadhar wrote:

> > > diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-
> > davinci/devices-da8xx.c
> > > index beda8a4..4ea3d1f 100644
> > > --- a/arch/arm/mach-davinci/devices-da8xx.c
> > > +++ b/arch/arm/mach-davinci/devices-da8xx.c
> > > @@ -725,3 +725,76 @@ int __init da8xx_register_cpuidle(void)
> > >
> > >   	return platform_device_register(&da8xx_cpuidle_device);
> > >   }
> > > +static struct resource pruss_resources[] = {
> > > +	[0] = {
> > > +		.start  = DA8XX_PRUSS_BASE,
> > > +		.end    = DA8XX_PRUSS_BASE + SZ_64K - 1,
> > > +		.flags  = IORESOURCE_MEM,
> > > +	},
> > > +	[1] = {
> > > +		.start  = DA8XX_L3RAM_BASE,
> > > +		.end    = DA8XX_L3RAM_BASE + SZ_128K - 1,
> > > +		.flags  = IORESOURCE_MEM,
> > > +	},
> > > +	[2] = {
> > > +		.start  = 0,
> > > +		.end    = SZ_256K - 1,
> > 
> >     Huh? I don't see where it's filled...
> > 
> The current use is only to indicate memory block size to the PRUSS UIO 
> driver when we allocate DDR memory using dma_alloc_coherent.

If the user/platform needs to specify the amount of memory that
will be allocated by the driver, it can be done though platform
data or (better) using module params.

> sram_alloc is changed to use L3_RAM (128KB) instead of ARM RAM (8KB) in 
> Mistral patch set - I need to follow the same convention for L3 RAM as well 
> if I need to align with that patch. Is there a better way to do this?

Yes, with that patch sram_alloc() will allocate from L3 RAM. You can make
calls to sram_alloc() in your driver. Again the size to be allocated can
be platform data or module params.

Thanks,
Sekhar

