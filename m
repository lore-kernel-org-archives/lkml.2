Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2BHEAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 23:00:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59079 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab2BHEAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 23:00:39 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Michael Williamson <michael.williamson@criticallink.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: [PATCH v3 3/3] arm:davinci: move NAND and NOR devices as aemif
 MFD slaves
Thread-Topic: [PATCH v3 3/3] arm:davinci: move NAND and NOR devices as aemif
 MFD slaves
Thread-Index: AQHM5a1r+/D1oImEDU6E/C9RIZs36JYxSEKAgAEW7XA=
Date: Wed, 8 Feb 2012 04:00:13 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC31761D77@DBDE01.ent.ti.com>
References: <1328627513-30134-1-git-send-email-prakash.pm@ti.com>
 <1328627513-30134-4-git-send-email-prakash.pm@ti.com>
 <4F31552D.9060505@criticallink.com>
In-Reply-To: <4F31552D.9060505@criticallink.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, Feb 07, 2012 at 22:15:33, Michael Williamson wrote:
> Hello Prakash,
> 
> On 2/7/2012 10:11 AM, Manjunathappa, Prakash wrote:
> 
> > NAND and NOR device are made as aemif device slaves, hence all DaVinci
> > board NAND/NOR device registration achieved via aemif MFD driver.
> >
> > Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
> > ---
> > Since v2:
> > Make changes for all DaVinci boards in single patch.
> 
> 
> 
> [...]
> 
> > diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
> > index 672d820..bb29b7a 100644
> > --- a/arch/arm/mach-davinci/board-mityomapl138.c
> > +++ b/arch/arm/mach-davinci/board-mityomapl138.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/etherdevice.h>
> >  #include <linux/spi/spi.h>
> >  #include <linux/spi/flash.h>
> > +#include <linux/mfd/davinci_aemif.h>
> >  
> >  #include <asm/io.h>
> >  #include <asm/mach-types.h>
> > @@ -414,18 +415,35 @@ static struct resource mityomapl138_nandflash_resource[] = {
> >  	},
> >  };
> >  
> > -static struct platform_device mityomapl138_nandflash_device = {
> > -	.name		= "davinci_nand",
> > -	.id		= 1,
> > -	.dev		= {
> > -		.platform_data	= &mityomapl138_nandflash_data,
> > +static struct platform_device mityomapl138_emif_devices[] __initdata = {
> > +	{
> > +		.name		= "davinci_nand",
> > +		.id		= 0,
> 
> 
> 
> Pretty sure this still needs to be a 1.  The nand is on chip select 3,
> EMA_CS3, which I believe is the same as the da850 EVM.

Yes I could not test on this board. I will make id as 1.

Thanks,
Prakash

> 
> -Mike
> 
> 
> 

