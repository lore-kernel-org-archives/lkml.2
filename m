Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946269Ab2EKWF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:05:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50134 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946233Ab2EKWF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:05:27 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-doc@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/3] of/spi/eeprom: Configure at25 from device tree and autoload its driver.
Date: Fri, 11 May 2012 15:05:20 -0700
Message-Id: <1336773923-17866-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

As per the Subject, given a device tree fragment like this:

	spi@1070000001000 {
		compatible = "cavium,octeon-3010-spi";
		reg = <0x10700 0x00001000 0x0 0x100>;
		interrupts = <0 58>;
		#address-cells = <1>;
		#size-cells = <0>;

		eeprom@0 {
			compatible = "st,m95256", "atmel,at25";
			reg = <0>;
			spi-max-frequency = <5000000>;
			spi-cpha;
			spi-cpol;

			pagesize = <64>;
			size = <32768>;
			address-width = <16>;
		};
	};

The at25 module is autoloaded and configured from the device tree data.

1/3) Make of_modalias_node() work better for auto loading drivers.

2/3) Use MODALIAS prefixed with "spi:" for SPI drivers so modprobe can
     find the proper driver module.

3/3) Use standard eeprom device tree binding to configure at25,
     convert MODULE_ALIAS(), to equivalent MODULE_DEVICE_TABLE().

David Daney (3):
  of: Add prefix parameter to of_modalias_node().
  spi: Use consistent MODALIAS values.
  eeprom/of: Add device tree bindings to at25.

 drivers/misc/eeprom/at25.c   |   61 +++++++++++++++++++++++++++++++++++++++---
 drivers/of/base.c            |   22 +++++++++++----
 drivers/of/of_i2c.c          |    2 +-
 drivers/of/of_spi.c          |    2 +-
 drivers/spi/spi.c            |   39 +++++++++++++++++++++++---
 include/linux/of.h           |    3 +-
 sound/soc/fsl/mpc8610_hpcd.c |    2 +-
 sound/soc/fsl/p1022_ds.c     |    2 +-
 8 files changed, 113 insertions(+), 20 deletions(-)

-- 
1.7.2.3

