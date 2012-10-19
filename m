Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab2JSLOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:14:40 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:64180 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2JSLOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:14:37 -0400
Date: Fri, 19 Oct 2012 07:15:58 -0400
From: Matt Porter <mporter@ti.com>
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
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
Subject: Re: [RFC PATCH v3 00/16] DMA Engine support for AM33XX
Message-ID: <20121019111558.GD25164@beef>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <B5906170F1614E41A8A28DE3B8D121433EBD29FC@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EBD29FC@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 10:26:20AM +0000, Bedia, Vaibhav wrote:
> Hi Matt,
> 
> On Thu, Oct 18, 2012 at 18:56:39, Porter, Matt wrote:
> > Changes since v2:
> > 	- Rebased on 3.7-rc1
> > 	- Fixed bug in DT/pdata parsing first found by Gururaja
> > 	  that turned out to be masked by some toolchains
> > 	- Dropped unused mach-omap2/devices.c hsmmc patch
> > 	- Added AM33XX crossbar DMA event mux support
> > 	- Added am335x-evm support
> > 
> > Changes since v1:
> > 	- Rebased on top of mainline from 12250d8
> > 	- Dropped the feature removal schedule patch
> > 	- Implemented dma_request_slave_channel_compat() and
> > 	  converted the mmc and spi drivers to use it
> > 	- Dropped unneeded #address-cells and #size-cells from
> > 	  EDMA DT support
> > 	- Moved private EDMA header to linux/platform_data/ and
> > 	  removed some unneeded definitions
> > 	- Fixed parsing of optional properties
> > 
> > TODO:
> > 	- Add dmaengine support for per-channel caps so the
> > 	  hack to set the maximum segments can be replaced with
> > 	  a query to the dmaengine driver
> > 
> > This series adds DMA Engine support for AM33xx, which uses
> > an EDMA DMAC. The EDMA DMAC has been previously supported by only
> > a private API implementation (much like the situation with OMAP
> > DMA) found on the DaVinci family of SoCs.
> > 
> > The series applies on top of 3.7-rc1 and the following patches:
> > 
> > 	- GPMC fails to reserve memory fix:
> > 	  http://www.spinics.net/lists/linux-omap/msg79675.html
> > 	- TPS65910 regulator fix:
> > 	  https://patchwork.kernel.org/patch/1593651/
> > 	- dmaengine DT support from Vinod's dmaengine_dt branch in
> > 	  git://git.infradead.org/users/vkoul/slave-dma.git since
> > 	  027478851791df751176398be02a3b1c5f6aa824
> > 
> > The approach taken is similar to how OMAP DMA is being converted to
> > DMA Engine support. With the functional EDMA private API already
> > existing in mach-davinci/dma.c, we first move that to an ARM common
> > area so it can be shared. Adding DT and runtime PM support to the
> > private EDMA API implementation allows it to run on AM33xx. AM33xx
> > *only* boots using DT so we leverage Jon's generic DT DMA helpers to
> > register EDMA DMAC with the of_dma framework and then add support
> > for calling the dma_request_slave_channel() API to both the mmc
> > and spi drivers.
> > 
> > With this series both BeagleBone and the AM335x EVM have working
> > MMC and SPI support.
> > 
> > This is tested on BeagleBone with a SPI framebuffer driver and MMC
> > rootfs. A trivial gpio DMA event misc driver was used to test the
> > crossbar DMA event support. It is also tested on the AM335x EVM
> > with the onboard SPI flash and MMC rootfs. The branch at
> > https://github.com/ohporter/linux/tree/edma-dmaengine-v3 has the
> > complete series, dependencies, and some test drivers/defconfigs.
> > 
> 
> I didn't see all the patches that you posted on edma-dmaengine-v3
> but I do seem them on edma-dmaengine-am33xx-v3 branch.

I see I referenced the wrong branch in the cover letter. Thanks for
testing and noticing this. Sorry to make you hunt for the correct
branch in that repo. ;) 

https://github.com/ohporter/linux/tree/edma-dmaengine-am33xx-v3
is indeed the correct branch for those wanting to pull this in or
grab some of the not-to-be-merged drivers I used for testing.

> I added a couple of patches to enable earlyprintk and build the DTB
> appended kernel image uImage-dtb.am335x-evm
> 
> Here's what i see
> 
> [...]

<snip>

> [    0.175354] edma: probe of 49000000.edma failed with error -16

I missed an uninitialized pdata case in the bug fixes mentioned in
the changelog and the folks previously failing the same way didn't
hit the case I suspect you are hitting. Can you try this and let me
know how it works?

Thanks,
Matt

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index b761b7a..b43b327 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1619,7 +1619,7 @@ static int __init edma_probe(struct platform_device *pdev)
 
 	if (node) {
 		pdata = devm_kzalloc(dev,
-				     sizeof(struct edma_soc_info),
+				     EDMA_MAX_CC*sizeof(struct edma_soc_info),
 				     GFP_KERNEL);
 		edma_of_parse_dt(dev, node, pdata);
 		info = &pdata;
