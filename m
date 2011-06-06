Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1FFJBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:01:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58908 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1FFJBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:01:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pcmcia@lists.infradead.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        "David S. Miller" <davem@davemloft.net>, Michael Buesch <mb@bu3sch.de>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Florian Fainelli <florian@openwrt.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] spi: reorganize drivers
Date: Mon, 6 Jun 2011 11:00:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
References: <20110605071725.26517.11573.stgit@ponder>
In-Reply-To: <20110605071725.26517.11573.stgit@ponder>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061100.38249.arnd@arndb.de>
X-Provags-ID: V02:K0:fpyC304fwcIaIkkYiuBNPzK42FLyFUr6L0Nbg0WWcXt
 OHH8FiATmdQ91DZvK/L327hf46obTHtuKQ+Ku4nlhSplVyUORi
 D/m6l1y7d9gU/44fbg7fm2IBhkI2YR93Tp1/xgw/Ym9wdW/DTI
 QaPYZqNeYSO+/9CxaVbigHq3mVS2gXXSWrySMt1istjOz1tRtl
 UuWGXNI/7kvj+8EDGVZvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 June 2011, Grant Likely wrote:
>  rename drivers/spi/{omap2_mcspi.c => spi_omap2_mcspi.c} (100%)
>  rename drivers/spi/{omap_spi_100k.c => spi_omap_100k.c} (100%)
>  rename drivers/spi/{omap_uwire.c => spi_omap_uwire.c} (100%)
>  rename drivers/spi/{orion_spi.c => spi_orion.c} (100%)
>  rename drivers/spi/{amba-pl022.c => spi_pl022.c} (100%)
>  rename drivers/spi/{pxa2xx_spi.c => spi_pxa2xx.c} (100%)
>  rename drivers/spi/{pxa2xx_spi_pci.c => spi_pxa2xx_pci.c} (100%)
>  rename drivers/spi/{ti-ssp-spi.c => spi_ti_ssp.c} (100%)
>  rename drivers/spi/{tle62x0.c => spi_tle62x0.c} (100%)
>  rename drivers/spi/{xilinx_spi.c => spi_xilinx.c} (100%)

I recently looked at the directory structure in drivers/ and found a lot
of bus drivers with very few files, plus a few bus drivers with a lot
of files in them besides directories for non-bus specific subsystems.

I think it would be good to move them into a deeper directory drivers/bus/
if we have support from the maintainers, and it's probably better if we
only have to move the files once to reduce the amount of churn on the
MAINTAINERS file and any out of tree patches.

Specifically, I'd like to do these moves:

drivers/{ => bus}/amba
drivers/{ => bus}/dio
drivers/{ => bus}/eisa
drivers/{ => bus}/firewire
drivers/{ => bus}/i2c
drivers/{ => bus}/mca
drivers/{ => bus}/nubus
drivers/{ => bus}/pcmcia
drivers/{ => bus}/rapidio
drivers/{ => bus}/sbus
drivers/{ => bus}/spi
drivers/{ => bus}/ssb
drivers/{ => bus}/tc
drivers/{ => bus}/uwb
drivers/{ => bus}/virtio
drivers/{ => bus}/vlync
drivers/{ => bus}/w1
drivers/{ => bus}/zorro

This leaves out the two most common buses, USB and PCI, mostly because
the directories contain a lot of stuff that is not really bus code
but actual drivers. It does include i2c and spi, which stick out by
being a lot larger than most others.

Opinions? Move or don't move?

	Arnd
