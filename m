Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1FEOhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:37:22 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38891 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab1FEOhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:37:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110605081331.GA3499@acer>
References: <20110605071725.26517.11573.stgit@ponder> <20110605081331.GA3499@acer>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 5 Jun 2011 08:37:00 -0600
X-Google-Sender-Auth: wjufURAuxQcigd8Jq2s_jno7Zis
Message-ID: <BANLkTin93sqhJ1hmefv0AqgEZvSEQYFiMg@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
To: Mika Westerberg <mika.westerberg@iki.fi>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 2:13 AM, Mika Westerberg <mika.westerberg@iki.fi> wrote:
> On Sun, Jun 05, 2011 at 01:18:14AM -0600, Grant Likely wrote:
>> [repost: I had a typo on the spi-devel-general mailing list address]
>>
>> Sort the SPI makefile and enforce the naming convention spi_*.c for
>> spi drivers.
>>
>> This change also rolls the contents of atmel_spi.h into the .c file
>> since there is only one user of that particular include file.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  drivers/spi/Makefile            |   80 ++++++++-----------
>>  drivers/spi/atmel_spi.h         |  167 ---------------------------------------
>>  drivers/spi/spi_ath79.c         |    0
>>  drivers/spi/spi_atmel.c         |  155 ++++++++++++++++++++++++++++++++++++
>>  drivers/spi/spi_au1550.c        |    0
>>  drivers/spi/spi_coldfire_qspi.c |    0
>>  drivers/spi/spi_davinci.c       |    0
>>  drivers/spi/spi_dw.c            |    2
>>  drivers/spi/spi_dw.h            |    0
>>  drivers/spi/spi_dw_mid.c        |    2
>>  drivers/spi/spi_dw_mmio.c       |    2
>>  drivers/spi/spi_dw_pci.c        |    2
>>  drivers/spi/spi_ep93xx.c        |    0
>>  drivers/spi/spi_mpc512x_psc.c   |    0
>>  drivers/spi/spi_mpc52xx.c       |    0
>>  drivers/spi/spi_mpc52xx_psc.c   |    0
>>  drivers/spi/spi_omap2_mcspi.c   |    0
>>  drivers/spi/spi_omap_100k.c     |    0
>>  drivers/spi/spi_omap_uwire.c    |    0
>>  drivers/spi/spi_orion.c         |    0
>>  drivers/spi/spi_pl022.c         |    0
>>  drivers/spi/spi_pxa2xx.c        |    0
>>  drivers/spi/spi_pxa2xx_pci.c    |    0
>>  drivers/spi/spi_ti_ssp.c        |    0
>>  drivers/spi/spi_tle62x0.c       |    0
>>  drivers/spi/spi_xilinx.c        |    0
>>  26 files changed, 192 insertions(+), 218 deletions(-)
>>  delete mode 100644 drivers/spi/atmel_spi.h
>>  rename drivers/spi/{ath79_spi.c => spi_ath79.c} (100%)
>>  rename drivers/spi/{atmel_spi.c => spi_atmel.c} (85%)
>>  rename drivers/spi/{au1550_spi.c => spi_au1550.c} (100%)
>>  rename drivers/spi/{coldfire_qspi.c => spi_coldfire_qspi.c} (100%)
>>  rename drivers/spi/{davinci_spi.c => spi_davinci.c} (100%)
>>  rename drivers/spi/{dw_spi.c => spi_dw.c} (99%)
>>  rename drivers/spi/{dw_spi.h => spi_dw.h} (100%)
>>  rename drivers/spi/{dw_spi_mid.c => spi_dw_mid.c} (99%)
>>  rename drivers/spi/{dw_spi_mmio.c => spi_dw_mmio.c} (99%)
>>  rename drivers/spi/{dw_spi_pci.c => spi_dw_pci.c} (99%)
>>  rename drivers/spi/{ep93xx_spi.c => spi_ep93xx.c} (100%)
>>  rename drivers/spi/{mpc512x_psc_spi.c => spi_mpc512x_psc.c} (100%)
>>  rename drivers/spi/{mpc52xx_spi.c => spi_mpc52xx.c} (100%)
>>  rename drivers/spi/{mpc52xx_psc_spi.c => spi_mpc52xx_psc.c} (100%)
>>  rename drivers/spi/{omap2_mcspi.c => spi_omap2_mcspi.c} (100%)
>>  rename drivers/spi/{omap_spi_100k.c => spi_omap_100k.c} (100%)
>>  rename drivers/spi/{omap_uwire.c => spi_omap_uwire.c} (100%)
>>  rename drivers/spi/{orion_spi.c => spi_orion.c} (100%)
>>  rename drivers/spi/{amba-pl022.c => spi_pl022.c} (100%)
>>  rename drivers/spi/{pxa2xx_spi.c => spi_pxa2xx.c} (100%)
>>  rename drivers/spi/{pxa2xx_spi_pci.c => spi_pxa2xx_pci.c} (100%)
>>  rename drivers/spi/{ti-ssp-spi.c => spi_ti_ssp.c} (100%)
>>  rename drivers/spi/{tle62x0.c => spi_tle62x0.c} (100%)
>>  rename drivers/spi/{xilinx_spi.c => spi_xilinx.c} (100%)
>
> We also have things like this in drivers/spi/Kconfig:
>
> config SPI_DAVINCI
>        ...
>
>        This driver can also be built as a module. The module will
>        be called davinci_spi <--- This is now wrong
>
> should these be converted as well?

yes.

g.
