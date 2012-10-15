Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942Ab2JOOUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:20:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JOOUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:20:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/2] mmc: core: Support all MMC capabilities when booting from Device Tree
Date: Mon, 15 Oct 2012 14:20:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Chris Ball <cjb@laptop.org>,
        Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
References: <1350306959-5843-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1350306959-5843-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210151420.29930.arnd@arndb.de>
X-Provags-ID: V02:K0:a6A7wZdKFkowTdr59BLSx/S5ZIQIFCuiXHgqX+5+/Qk
 jHOPEAq2R2iST8Y+rMEIulK0XALYSrSmDLEAVku3zVOXu6nU/S
 v7op+5X3dHSPVVCGnx+DmggGaOhYlNYa+3sWzn3KOrOkNOyFB9
 GBCQsZxlOG0Ox3ajCsqU8JMn7+gpKvfFGNViF+EL/jzyH3apLO
 81ZFoBSVAD5zzYDJz/qus77tz/Vsoc0Ko0KPCAzheBFqGAbjkw
 U1Htrm41aCUTULmeKGYRyIvYLpxqETD3WIhQAiy6364NQ/vr1E
 i09IwydPzETKeL/uQEL+80wa0CHpk5RziOIDOpmeOl+Qcz0Gm3
 Pgvtn68f4/FWYE+S+Vts=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012, Lee Jones wrote:
> Capabilities are an important part of the MMC subsystem. Much
> supported functionality would be lost if we didn't provide the
> same level of support when booting Device Tree as we currently
> do when the subsystem is passed capabilities via platform data.
> This patch supplies this support with one simple call to a
> DT parsing function.

We already document all the commonly used properties
in Documentation/devicetree/bindings/mmc/mmc.txt

Please don't add any duplicates or those that are not used
so far.

> +	if(of_property_read_bool(np, "mmc-cap-4-bit-data"))
> +		*caps |= MMC_CAP_4_BIT_DATA;

see "bus-width" property.

> +	if(of_property_read_bool(np, "mmc-cap-mmc-highspeed"))
> +		*caps |= MMC_CAP_MMC_HIGHSPEED;
> +	if(of_property_read_bool(np, "mmc-cap-sd-highspeed"))
> +		*caps |= MMC_CAP_SD_HIGHSPEED;

implied by "max-frequency" property.

> +	if(of_property_read_bool(np, "mmc-cap-sdio-irq"))
> +		*caps |= MMC_CAP_SDIO_IRQ;

implied by presence of SDIO irq property.

> +	if(of_property_read_bool(np, "mmc-cap-spi"))
> +		*caps |= MMC_CAP_SPI;

Only used by the mmc_spi driver, can be hardcoded there.

> +	if(of_property_read_bool(np, "mmc-cap-needs-poll"))
> +		*caps |= MMC_CAP_NEEDS_POLL;

implied by absence of irqs property.

> +	if(of_property_read_bool(np, "mmc-cap-8-bit-data"))
> +		*caps |= MMC_CAP_8_BIT_DATA;

see "bus-width" property.

> +	if(of_property_read_bool(np, "mmc-cap-nonremovable"))
> +		*caps |= MMC_CAP_NONREMOVABLE;

see "non-removable property.

> +	if(of_property_read_bool(np, "mmc-cap-wait-while-busy"))
> +		*caps |= MMC_CAP_WAIT_WHILE_BUSY;

This seems to be a linux device driver specific quirk that doesn't
belong into a hardware description.

> +	if(of_property_read_bool(np, "mmc-cap-erase"))
> +		*caps |= MMC_CAP_ERASE;

driver specific.

> ...

and so on. What are you actually missing in the properties that
are already there?

	Arnd
