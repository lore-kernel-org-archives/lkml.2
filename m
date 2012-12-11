Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2LKJEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:04:20 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37586 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2LKJEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:04:12 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 2/3] mtd: devices: elm: Add support for ELM error correction
To: "Philip, Avinash" <avinashphilip@ti.com>, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, afzal@ti.com, tony@atomide.com,
        broonie@opensource.wolfsonmicro.com, rmk+kernel@arm.linux.org.uk,
        gregkh@linuxfoundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, ivan.djelic@parrot.com,
        "Philip, Avinash" <avinashphilip@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
In-Reply-To: <1354189595-12784-3-git-send-email-avinashphilip@ti.com>
References: <1354189595-12784-1-git-send-email-avinashphilip@ti.com> <1354189595-12784-3-git-send-email-avinashphilip@ti.com>
Date: Tue, 11 Dec 2012 09:03:56 +0000
Message-Id: <20121211090356.8D3D93E076D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 17:16:33 +0530, "Philip, Avinash" <avinashphilip@ti.com> wrote:
> The ELM hardware module can be used to speedup BCH 4/8/16 ECC scheme
> error correction.
> For now only 4 & 8 bit support is added
> 
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> ---
> Changes since v2:
> 	- Remove __devinit & __devexit annotations
> 
> Changes since v1:
> 	- Change build attribute to CONFIG_MTD_NAND_OMAP_BCH
> 	- Reduced indentation using by passing elm_info , offset
> 	  to elm_read & elm_write
> 	- Removed syndrome manipulation functions.
> 
> :000000 100644 0000000... b88ee83... A	Documentation/devicetree/bindings/mtd/elm.txt
> :100644 100644 395733a... 369a194... M	drivers/mtd/devices/Makefile
> :000000 100644 0000000... d2667f3... A	drivers/mtd/devices/elm.c
> :000000 100644 0000000... d4fce31... A	include/linux/platform_data/elm.h
>  Documentation/devicetree/bindings/mtd/elm.txt |   17 +
>  drivers/mtd/devices/Makefile                  |    4 +-
>  drivers/mtd/devices/elm.c                     |  418 +++++++++++++++++++++++++
>  include/linux/platform_data/elm.h             |   54 ++++
>  4 files changed, 493 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/elm.txt b/Documentation/devicetree/bindings/mtd/elm.txt
> new file mode 100644
> index 0000000..b88ee83
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/elm.txt
> @@ -0,0 +1,17 @@
> +Error location module
> +
> +Required properties:
> +- compatible: Must be "ti,elm"

Compatible string is too generic. Need to specify a specific SoC here.
ie: "ti,omap3430-elm"

Otherwise the binding looks fine. I haven't reviewed the code though.

g.

