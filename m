Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab2JZMyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:54:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59403 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab2JZMyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:54:36 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: Linux DaVinci Kernel List 
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
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Subject: RE: [RFC PATCH v3 05/16] ARM: edma: add AM33XX crossbar event
 support
Thread-Topic: [RFC PATCH v3 05/16] ARM: edma: add AM33XX crossbar event
 support
Thread-Index: AQHNrTRk8DPjuwxuUU2Mf/0XNV2NRZfLll+A
Date: Fri, 26 Oct 2012 12:53:45 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EAB5BC7@DBDE01.ent.ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-6-git-send-email-mporter@ti.com>
In-Reply-To: <1350566815-409-6-git-send-email-mporter@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 18:56:44, Porter, Matt wrote:
> Adds support for the per-EDMA channel event mux. This is required
> for any peripherals using DMA crossbar mapped events.
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/common/edma.c             |   63 +++++++++++++++++++++++++++++++++++-
>  include/linux/platform_data/edma.h |    1 +
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 

..snip..
..snip..

> +
> +	for (i = 0; xbar_chans[i][0] != -1; i++) {
> +		shift = (xbar_chans[i][1] % 4) * 8;
> +		offset = xbar_chans[i][1] >> 2;
> +		offset <<= 2;
> +		mux = __raw_readl((void *)((u32)xbar + offset));
> +		mux &= (~(0xff << shift));
> +		mux |= (xbar_chans[i][0] << shift);
> +		__raw_writel(mux, (void *)((u32)xbar + offset));

This method of calculating Xbar Channel offset has a bug that
the code breaks with unaligned access trap error when requested 
channel to be mapped is odd.

This was fixed in Arago tree [1]. Kindly verify


> +	}
> +
> +	pdata->xbar_chans = xbar_chans;
> +
> +	return 0;
> +}
> +

..snip..
..snip..

[1]
http://arago-project.org/git/projects/?p=linux-am33x.git;a=commitdiff;
h=c08d3cb557adf71c79aeefb38888395455824e83

Regards, 
Gururaja
