Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab2JSMDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:03:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45207 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab2JSMD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:03:29 -0400
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
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
Subject: RE: [RFC PATCH v3 00/16] DMA Engine support for AM33XX
Thread-Topic: [RFC PATCH v3 00/16] DMA Engine support for AM33XX
Thread-Index: AQHNrTQZOLq9jfMJNk+iV4vTK/FhGJfAWwaQ///EmACAAGcAIA==
Date: Fri, 19 Oct 2012 12:02:42 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EBD2CE1@DBDE01.ent.ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <B5906170F1614E41A8A28DE3B8D121433EBD29FC@DBDE01.ent.ti.com>
 <20121019111558.GD25164@beef>
In-Reply-To: <20121019111558.GD25164@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.70]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 16:45:58, Porter, Matt wrote:
> On Fri, Oct 19, 2012 at 10:26:20AM +0000, Bedia, Vaibhav wrote:
[...]
> > 
> > I didn't see all the patches that you posted on edma-dmaengine-v3
> > but I do seem them on edma-dmaengine-am33xx-v3 branch.
> 
> I see I referenced the wrong branch in the cover letter. Thanks for
> testing and noticing this. Sorry to make you hunt for the correct
> branch in that repo. ;) 
> 

No problem.

> https://github.com/ohporter/linux/tree/edma-dmaengine-am33xx-v3
> is indeed the correct branch for those wanting to pull this in or
> grab some of the not-to-be-merged drivers I used for testing.
> 
> > I added a couple of patches to enable earlyprintk and build the DTB
> > appended kernel image uImage-dtb.am335x-evm
> > 
> > Here's what i see
> > 
> > [...]
> 
> <snip>
> 
> > [    0.175354] edma: probe of 49000000.edma failed with error -16
> 
> I missed an uninitialized pdata case in the bug fixes mentioned in
> the changelog and the folks previously failing the same way didn't
> hit the case I suspect you are hitting. Can you try this and let me
> know how it works?
> 

That doesn't help :(

Looking at the original crash log, I suspect something is not correct
with the irq portion, probably in the DT or the driver. 

"genirq: Flags mismatch irq 28. 00000000 (edma) vs. 00000000 (edma)"

The warning below that is coming due to fail case in edma_probe not tracking
the request_irq status properly and but IMO that's a separate issue.

BTW, I am trying this on the EVM.

Regards,
Vaibhav
