Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab1EONdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 09:33:22 -0400
Received: from londo.lunn.ch ([80.238.139.98]:45321 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab1EONdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 09:33:21 -0400
Date: Sun, 15 May 2011 15:33:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Pinmux subsystem
Message-ID: <20110515133312.GM4071@lunn.ch>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
 <20110503172712.GE6538@lunn.ch>
 <BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks

There was a question, how many different combinations would end up in
drivers/pinmux/pinmux-foo.c given the flexibility different devices
have?

It has been suggested there would be a drivers/pinmux/pinmux-orion.c
for all devices based around orion. That would be mach-kirkwood,
mach-dove, mach-loki, mach-mv78xx0, mach-orion5x. Currently loki and
dove have pin muxing code, but no board makes use of this. However
kirkwood, orion5x and mv78xx0 do have pin muxing in use.

With a bit of scripting, came to the following results. Each line is
on pinmux function description what would be needed in the driver. The
number at the front says how many boards would use it. In total there
are 33 descriptions needed. Of these, 18 are used only once. This to
me suggests the board needs to be able to specify a pin description
when there is no reuse with other boards.

      1 KIRKWOOD_MPP0_NF_IO2,KIRKWOOD_MPP1_NF_IO3,KIRKWOOD_MPP2_NF_IO4,KIRKWOOD_MPP3_NF_IO5,KIRKWOOD_MPP4_NF_IO6,KIRKWOOD_MPP5_NF_IO7,KIRKWOOD_MPP18_NF_IO0,KIRKWOOD_MPP19_NF_IO1,
      1 KIRKWOOD_MPP0_NF_IO2,KIRKWOOD_MPP4_NF_IO6,KIRKWOOD_MPP5_NF_IO7,KIRKWOOD_MPP18_NF_IO0,KIRKWOOD_MPP19_NF_IO1,
      1 KIRKWOOD_MPP12_SD_CLK,
      1 KIRKWOOD_MPP12_SD_CLK,KIRKWOOD_MPP13_SD_CMD,KIRKWOOD_MPP14_SD_D0,KIRKWOOD_MPP15_SD_D1,KIRKWOOD_MPP16_SD_D2,KIRKWOOD_MPP17_SD_D3,
      1 KIRKWOOD_MPP15_SATA0_ACTn,
      1 KIRKWOOD_MPP15_SATA0_ACTn,KIRKWOOD_MPP17_SATA0_PRESENTn,
      1 KIRKWOOD_MPP1_SPI_MOSI,KIRKWOOD_MPP2_SPI_SCK,KIRKWOOD_MPP3_SPI_MISO,KIRKWOOD_MPP7_SPI_SCn,
      1 KIRKWOOD_MPP33_GE1_TXCTL,
      1 KIRKWOOD_MPP39_AU_I2SBCLK,KIRKWOOD_MPP40_AU_I2SDO,KIRKWOOD_MPP43_AU_I2SDI,KIRKWOOD_MPP41_AU_I2SLRCLK,KIRKWOOD_MPP42_AU_I2SMCLK,
      1 KIRKWOOD_MPP4_NF_IO6,KIRKWOOD_MPP5_NF_IO7,
      1 KIRKWOOD_MPP4_NF_IO6,KIRKWOOD_MPP5_NF_IO7,KIRKWOOD_MPP18_NF_IO0,KIRKWOOD_MPP19_NF_IO1,
      1 KIRKWOOD_MPP4_SATA1_ACTn,
      1 KIRKWOOD_MPP5_SATA0_ACTn,
      1 MV78xx0_MPP0_GE1_TXCLK,MV78xx0_MPP1_GE1_TXCTL,MV78xx0_MPP2_GE1_RXCTL,MV78xx0_MPP3_GE1_RXCLK,MV78xx0_MPP4_GE1_TXD0,MV78xx0_MPP5_GE1_TXD1,MV78xx0_MPP6_GE1_TXD2,MV78xx0_MPP7_GE1_TXD3,MV78xx0_MPP8_GE1_RXD0,MV78xx0_MPP9_GE1_RXD1,MV78xx0_MPP10_GE1_RXD2,MV78xx0_MPP11_GE1_RXD3,
      1 MV78xx0_MPP13_SYSRST_OUTn,MV78xx0_MPP29_SYSRST_OUTn,
      1 MV78xx0_MPP14_SATA1_ACTn,MV78xx0_MPP48_SATA1_ACTn,
      1 MV78xx0_MPP15_SATA0_ACTn,MV78xx0_MPP49_SATA0_ACTn,
      1 ORION5X_MPP2_PCI_ARB,ORION5X_MPP3_PCI_ARB,ORION5X_MPP4_PCI_ARB,ORION5X_MPP5_PCI_ARB,
      2 KIRKWOOD_MPP16_SATA1_ACTn,
      2 KIRKWOOD_MPP20_SATA1_ACTn,
      2 KIRKWOOD_MPP7_PEX_RST_OUTn,
      2 ORION5X_MPP0_PCIE_RST_OUTn,
      2 ORION5X_MPP6_PCI_CLK,ORION5X_MPP7_PCI_CLK,
      3 KIRKWOOD_MPP13_UART1_TXD,KIRKWOOD_MPP14_UART1_RXD,
      3 KIRKWOOD_MPP20_GE1_TXD0,KIRKWOOD_MPP21_GE1_TXD1,KIRKWOOD_MPP22_GE1_TXD2,KIRKWOOD_MPP23_GE1_TXD3,KIRKWOOD_MPP24_GE1_RXD0,KIRKWOOD_MPP25_GE1_RXD1,KIRKWOOD_MPP26_GE1_RXD2,KIRKWOOD_MPP27_GE1_RXD3,KIRKWOOD_MPP30_GE1_RXCTL,KIRKWOOD_MPP31_GE1_RXCLK,KIRKWOOD_MPP32_GE1_TCLKOUT,KIRKWOOD_MPP33_GE1_TXCTL,
      3 KIRKWOOD_MPP21_SATA0_ACTn,
      3 ORION5X_MPP14_SATA_LED,ORION5X_MPP15_SATA_LED,
      7 KIRKWOOD_MPP0_SPI_SCn,KIRKWOOD_MPP1_SPI_MOSI,KIRKWOOD_MPP2_SPI_SCK,KIRKWOOD_MPP3_SPI_MISO,
      7 KIRKWOOD_MPP6_SYSRST_OUTn,
      7 ORION5X_MPP12_SATA_LED,ORION5X_MPP13_SATA_LED,ORION5X_MPP14_SATA_LED,ORION5X_MPP15_SATA_LED,
      8 KIRKWOOD_MPP10_UART0_TXD,KIRKWOOD_MPP11_UART0_RXD,
      8 KIRKWOOD_MPP8_TW0_SDA,KIRKWOOD_MPP9_TW0_SCK
