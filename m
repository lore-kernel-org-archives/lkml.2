Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2LJXnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:43:22 -0500
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:45845 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2LJXnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:43:21 -0500
Date: Tue, 11 Dec 2012 00:43:18 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Matt Porter <mporter@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.7 does not boot on OMAP L137 with CONFIG_TI_EDMA=y
Message-ID: <20121210234318.GA8439@shrek.podlesie.net>
References: <20121210233129.GA18190@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210233129.GA18190@shrek.podlesie.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 12:31:29AM +0100, Krzysztof Mazur wrote:
> Hi,
> 
> commit c2dde5f8f2095d7c623ff3565c1462e190272273
> (dmaengine: add TI EDMA DMA engine driver)
> with new option CONFIG_TI_EDMA=y causes system hang after
> "Uncompressing Linux... done, booting the kernel."
> on OMAP L137.

The system board is probably also important. The problem
occurs on Spectrum Digital OMAP-L137 EVM. I used following
board-specific options:

CONFIG_ARCH_DAVINCI=y
CONFIG_CP_INTC=y
CONFIG_ARCH_DAVINCI_DA830=y
CONFIG_ARCH_DAVINCI_DA8XX=y
CONFIG_MACH_DAVINCI_DA830_EVM=y
CONFIG_DA830_UI_LCD=y
CONFIG_GPIO_PCA953X=y
CONFIG_DAVINCI_MUX=y
CONFIG_DAVINCI_RESET_CLOCKS=y

> 
> The same problem still exists in current v3.7-rc8-41-gcaf4919.
> 
> This causes some regressions, for instance the converted to new DMA engine
> SPI driver does not work without CONFIG_TI_EDMA=y:
> 
> spi_davinci spi_davinci.0: Runtime PM disabled, clock forced on.
> spi_davinci spi_davinci.0: request RX DMA channel failed
> Trying to free nonexistent resource <0000000001c41000-0000000001c41000>
> 
> By the way:
> 
> 1. It's possible to compile davinci SPI driver with
> CONFIG_DMADEVICES=n (and CONFIG_TI_EMDA=n), but it does work
> in that configuration (see error above).
> 
> 2. The "Trying to free nonexistent resource" seems to indicate some
> other error in SPI driver cleanup after error code.
> 

Krzysiek
