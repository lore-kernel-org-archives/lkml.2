Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2IZI1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:27:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55174 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab2IZI1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:27:08 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH 00/13] DMA Engine support for AM33xx
Thread-Topic: [RFC PATCH 00/13] DMA Engine support for AM33xx
Thread-Index: AQHNlz4pAMb10R6XBUK0URnxVtmz6ZeUdpuwgABKvYCAB3kFcA==
Date: Wed, 26 Sep 2012 08:26:19 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA8FDA9@DBDE01.ent.ti.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1BAFE6F6C881BF42822005164F1491C33EA8A79D@DBDE01.ent.ti.com>
 <20120921182211.GE16522@beef>
In-Reply-To: <20120921182211.GE16522@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8Q8RPSI030388

On Fri, Sep 21, 2012 at 23:52:11, Porter, Matt wrote:
> On Fri, Sep 21, 2012 at 08:27:07AM +0000, Hebbar, Gururaja wrote:
> > On Thu, Sep 20, 2012 at 20:13:33, Porter, Matt wrote:
> > > This series adds DMA Engine support for AM33xx, which uses
> > > an EDMA DMAC. The EDMA DMAC has been previously supported by only
> > > a private API implementation (much like the situation with OMAP
> > > DMA) found on the DaVinci family of SoCs.
> > > 
> > > There are a mind-boggling number of dependencies for this series:
> > > 
> > > 	- Jon Hunter's OF DMA helpers series
> > > 	  https://patchwork.kernel.org/patch/1461061/
> > > 	  https://patchwork.kernel.org/patch/1461051/
> > > 	- Patch to address OF DMA helpers naming issues:
> > > 	  https://patchwork.kernel.org/patch/1477921/
> > > 	- EDMA DMA Engine wrapper driver in linux-next
> > > 	  c2dde5f8f2095d7c623ff3565c1462e190272273
> > > 	- EDMA DMA Engine wrapper driver bug fix:
> > > 	  https://patchwork.kernel.org/patch/1474411/  
> > > 	- A huge number of patches in linux-next for AM33xx boot
> > > 	  (too numerous to list)
> > > 
> > > The approach taken is similar to how OMAP DMA is being converted to
> > > DMA Engine support. With the functional EDMA private API already
> > > existing in mach-davinci/dma.c, we first move that to an ARM common
> > > area so it can be shared. Adding DT and runtime PM support to the
> > > private EDMA API implementation allows it to run on AM33xx. AM33xx
> > > *only* boots using DT so we leverage Jon's generic DT DMA helpers to
> > > register EDMA DMAC with the of_dma framework and then add support
> > > for calling the dma_request_slave_channel() API to both the mmc
> > > and spi drivers.
> > > 
> > > What works? Well, with this series we now have MMC and SPI support
> > > on AM33xx. The only caveat for MMC is that the mmc3 controller has
> > > its events on the crossbar and is not usable right now.
> > > 
> > > This is tested on BeagleBone with a SPI framebuffer driver and SD
> > > card.
> > > 
> > > After this series, the plan is to convert the last in-tree user
> > > of the private EDMA API (davinci-pcm/mcasp) and then eliminate
> > > the private EDMA API by folding its functionality into
> > > drivers/dma/edma.c.
> > > 
> > > TODO:
> > > 	add AM33xx crossbar support to the private EDMA API
> > > 	(any EDMA events on the crossbar are not supported)
> > > 
> > 
> > 
> > Can you please mention the base repo you have taken as starting point.
> > (repo + extra patches ...).
> 
> It's mainline 3.6-rc6 and you can see the complete set of patches
> at https://github.com/ohporter/linux/tree/edma-dmaengine-am33xx-rfc-v1
> after commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2
> 
> > This will help us to test the code.
> > 
> > This is because I looked at the patch 12/13 and I see that mmc
> > device-node is modified. But in mainline I donâ€™t see device 
> > node for mmc (yet).
> 
> Oops. You'll need e62a3333ae450bcdefbe22229d7bc277ae0ef645 and
> fe97304557d2c6f7d0aaf1ea028ea48ffca366a9 which I forgot to include
> in this series. I'll have them in for v2.

Yesterday I tested edma patches on latest linux-next/master + merge of 
linux-omap/for_3.7/dts_part2. Below are my observations

1. baseline = linux-next/master + merge of linux-omap/for_3.7/dts_part2
2. on top of above branch, I applied patches [1-9]/13 of your edma 
   patches
3. few patches required trivial changes before applying
4. Applied dma of patches as you mentioned
5. add custom patch (ARM: CUSTOM: Build a uImage with dtb already 
   appended)
   From https://github.com/hvaibhav/am335x-linux/commit/
        7e72f5ed4b702c9373d19f7626f07ae31a381d53#arch/arm/Makefile

6. Modified 9/13 patch to apply properly on latest am33xx.dtsi.
	a. Edma portion as it is
	b. mmc portion as below
		mmc1: mmc@48060000 {
			compatible = "ti,omap3-hsmmc";
			ti,hwmods = "mmc1";
			ti,dual-volt;
			ti,needs-special-reset;
			bus-width = <4>;
			vmmc-supply = <&vmmc_reg>;
			dmas = <&edma 24
				&edma 25>;
			dma-names = "tx", "rx";
		};
	c. added mmc pinmux as-well

7. make CROSS_COMPILE=arm-arago-linux-gnueabi- ARCH=arm distclean
   make CROSS_COMPILE=arm-arago-linux-gnueabi- ARCH=arm 
   omap2plus_defconfig

8. enabled TI_EDMA from menuconfig (since it was not enabled for 
   omap2plus_defconfig

9. make CROSS_COMPILE=arm-arago-linux-gnueabi- ARCH=arm uImage
   make CROSS_COMPILE=arm-arago-linux-gnueabi- ARCH=arm 
   uImage-dtb.am335x-evm

With above changes, edma probe was failing at request_mem_region() 
Inside linux-next/arch/arm/common/edma.c --> edma_probe()

I had to modify edma_probe as below


diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index f337f81..efe2673 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1589,11 +1589,11 @@ static int __init edma_probe(struct platform_device *pdev)
        for (j = 0; j < EDMA_MAX_CC; j++) {
                if (node) {
                        int err;
-                       err = of_address_to_resource(node, 0, &res[j]);
+                       err = of_address_to_resource(node, j, &res[j]);
                        if (err) {
                                dev_err(dev,
                                        "unable to find 'reg' property\n");
-                               return -EIO;
+                               //return -EIO;
                        }
                        r[j] = &res[j];



With this I was able to boot on am335x-evm and do a successful MMC 
copy-md5sum-compare test.

I believe you are looking into above issue in your v2 version.

> 
> -Matt
> 

...snip...
...snip...
...snip...


Regards, 
Gururaja
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
