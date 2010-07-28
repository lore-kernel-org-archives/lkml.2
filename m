Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0G1DQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:16:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60044 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab0G1DQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:16:05 -0400
Date: Wed, 28 Jul 2010 13:15:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nithish Mahalingam <nithish.mahalingam@intel.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the battery tree with the mips tree
Message-Id: <20100728131559.8b8ac475.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Today's linux-next merge of the battery tree got a conflict in
drivers/power/Kconfig drivers/power/Makefile between commit
0a5518307648808ce7d62cbfa6d7bdbb01c4e84a ("POWER: Add JZ4740 battery
driver") from the mips tree and commit
6721081b6b911a067fe6ca3d6f5534c4a11a9e59 ("Intel MID platform battery
driver") from the battery tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/Kconfig
index 1e5506b,d1d3c70..0000000
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@@ -142,15 -148,11 +148,22 @@@ config CHARGER_PCF5063
  	help
  	 Say Y to include support for NXP PCF50633 Main Battery Charger.
  
 +config BATTERY_JZ4740
 +	tristate "Ingenic JZ4740 battery"
 +	depends on MACH_JZ4740
 +	depends on MFD_JZ4740_ADC
 +	help
 +	  Say Y to enable support for the battery on Ingenic JZ4740 based
 +	  boards.
 +
 +	  This driver can be build as a module. If so, the module will be
 +	  called jz4740-battery.
 +
+ config BATTERY_INTEL_MID
+ 	tristate "Battery driver for Intel MID platforms"
+ 	depends on INTEL_SCU_IPC && SPI
+ 	help
+ 	  Say Y here to enable the battery driver on Intel MID
+ 	  platforms.
+ 
  endif # POWER_SUPPLY
diff --cc drivers/power/Makefile
index cf95009,705675a..0000000
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@@ -33,5 -33,6 +33,7 @@@ obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x0
  obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
  obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
  obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
+ obj-$(CONFIG_BATTERY_S3C_ADC)	+= s3c_adc_battery.o
  obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
 +obj-$(CONFIG_BATTERY_JZ4740)	+= jz4740-battery.o
+ obj-$(CONFIG_BATTERY_INTEL_MID)	+= intel_mid_battery.o
