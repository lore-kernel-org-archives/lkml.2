Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2LEXtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:49:55 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50765 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2LEXtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:49:53 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [linux-keystone] [PATCH v1 1/1] spi: davinci: add OF support for the spi controller
To: Murali Karicheri <m-karicheri2@ti.com>, rob.herring@calxeda.com,
        rob@landley.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-keystone@list.ti.com
Cc: Murali Karicheri <m-karicheri2@ti.com>
In-Reply-To: <1354559918-15105-2-git-send-email-m-karicheri2@ti.com>
References: <1354559918-15105-1-git-send-email-m-karicheri2@ti.com> <1354559918-15105-2-git-send-email-m-karicheri2@ti.com>
Date: Wed, 05 Dec 2012 23:49:46 +0000
Message-Id: <20121205234947.0EB3D3E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012 13:38:38 -0500, Murali Karicheri <m-karicheri2@ti.com> wrote:
> This adds OF support to DaVinci SPI controller to configure platform
> data through device bindings. Also replaces clk_enable() with
> of clk_prepare_enable() as well as clk_disable() with
> clk_disable_unprepare().
> 

Hi Murali.

Thanks for the patch. Comments below...

> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Reviewed-by : Grant Likely <grant.likely@secretlab.ca>
> ---
>  .../devicetree/bindings/spi/spi-davinci.txt        |   51 ++++++++++
>  drivers/spi/spi-davinci.c                          |  102 +++++++++++++++++---
>  2 files changed, 139 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi-davinci.txt
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi-davinci.txt b/Documentation/devicetree/bindings/spi/spi-davinci.txt
> new file mode 100644
> index 0000000..a2746c5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spi/spi-davinci.txt
> @@ -0,0 +1,51 @@
> +Davinci SPI controller device bindings
> +
> +Required properties:
> +- #address-cells: number of cells required to define a chip select
> +	address on the SPI bus. Should be set to 1.
> +- #size-cells: should be zero.
> +- compatible:
> +	- "ti,davinci-spi-v1" for SPI version 1.0
> +	- "ti,davinci-spi-v2" for SPI version 2.0

It's better to use a specific chip name than some anonymous "v1" or "v2"
(unless you can point me at some hardware documentation that actually
uses those names).

> +- reg: Offset and length of SPI controller register space
> +- ti,davinci-spi-num-cs: Number of chip selects

Simply "num-cs" is sufficient here. There is now a common binding for
the number of chip select lines.

Otherwise the patch and the binding look fine to me.

g.
