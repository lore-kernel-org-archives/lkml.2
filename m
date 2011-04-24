Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab1DXDib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 23:38:31 -0400
Received: from mail.perches.com ([173.55.12.10]:4931 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493Ab1DXDiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 23:38:22 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH] treewide: Cleanup continuations and remove logging message whitespace
Date: Sat, 23 Apr 2011 20:38:19 -0700
Message-Id: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using C line continuation inside format strings is error prone.
Clean up the unintended whitespace introduced by misuse of \.
Neaten correctly used line continations as well for consistency.

drivers/scsi/arcmsr/arcmsr_hba.c has these errors as well,
but arcmsr needs a lot more work and the driver should likely be
moved to staging instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/plat-mxc/cpufreq.c                     |    4 +-
 drivers/dma/dmatest.c                           |    4 +-
 drivers/firmware/iscsi_ibft.c                   |    4 +-
 drivers/gpio/ab8500-gpio.c                      |    7 ++---
 drivers/media/video/usbvision/usbvision-video.c |    5 ++-
 drivers/message/fusion/mptbase.c                |   22 ++++++++----------
 drivers/misc/bh1780gli.c                        |    8 +++---
 drivers/misc/spear13xx_pcie_gadget.c            |    4 +-
 drivers/net/atlx/atl1.c                         |    5 ++-
 drivers/net/wireless/airo.c                     |   27 ++++++++++++-----------
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c    |    4 +-
 drivers/regulator/max8998.c                     |    4 +-
 drivers/tty/serial/bfin_sport_uart.c            |    3 +-
 drivers/tty/serial/mfd.c                        |    4 +-
 drivers/usb/host/uhci-hcd.c                     |    7 +++--
 drivers/usb/storage/ene_ub6250.c                |    4 +-
 17 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/arch/arm/plat-mxc/cpufreq.c b/arch/arm/plat-mxc/cpufreq.c
index 4268a2b..74aac96 100644
--- a/arch/arm/plat-mxc/cpufreq.c
+++ b/arch/arm/plat-mxc/cpufreq.c
@@ -153,8 +153,8 @@ static int __init mxc_cpufreq_init(struct cpufreq_policy *policy)
 	ret = cpufreq_frequency_table_cpuinfo(policy, imx_freq_table);
 
 	if (ret < 0) {
-		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq \
-				with error code %d\n", __func__, ret);
+		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq with error code %d\n",
+		       __func__, ret);
 		goto err;
 	}
 
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index e0888cb..8597ff2 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -56,8 +56,8 @@ MODULE_PARM_DESC(pq_sources,
 
 static int timeout = 3000;
 module_param(timeout, uint, S_IRUGO);
-MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), \
-		Pass -1 for infinite timeout");
+MODULE_PARM_DESC(timeout, "Transfer Timeout in msec (default: 3000), "
+		 "Pass -1 for infinite timeout");
 
 /*
  * Initialization patterns. All bytes in the source buffer has bit 7
diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 6148a1c..ce33f46 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -87,8 +87,8 @@
 #define IBFT_ISCSI_VERSION "0.5.0"
 #define IBFT_ISCSI_DATE "2010-Feb-25"
 
-MODULE_AUTHOR("Peter Jones <pjones@redhat.com> and \
-Konrad Rzeszutek <ketuzsezr@darnok.org>");
+MODULE_AUTHOR("Peter Jones <pjones@redhat.com> and "
+	      "Konrad Rzeszutek <ketuzsezr@darnok.org>");
 MODULE_DESCRIPTION("sysfs interface to BIOS iBFT information");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IBFT_ISCSI_VERSION);
diff --git a/drivers/gpio/ab8500-gpio.c b/drivers/gpio/ab8500-gpio.c
index e7b834d..970053c 100644
--- a/drivers/gpio/ab8500-gpio.c
+++ b/drivers/gpio/ab8500-gpio.c
@@ -482,8 +482,8 @@ static int __devexit ab8500_gpio_remove(struct platform_device *pdev)
 
 	ret = gpiochip_remove(&ab8500_gpio->chip);
 	if (ret < 0) {
-		dev_err(ab8500_gpio->dev, "unable to remove gpiochip:\
-				%d\n", ret);
+		dev_err(ab8500_gpio->dev, "unable to remove gpiochip: %d\n",
+			ret);
 		return ret;
 	}
 
@@ -516,7 +516,6 @@ static void __exit ab8500_gpio_exit(void)
 module_exit(ab8500_gpio_exit);
 
 MODULE_AUTHOR("BIBEK BASU <bibek.basu@stericsson.com>");
-MODULE_DESCRIPTION("Driver allows to use AB8500 unused pins\
-			to be used as GPIO");
+MODULE_DESCRIPTION("Driver allows to use AB8500 unused pins to be used as GPIO");
 MODULE_ALIAS("AB8500 GPIO driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 6083137..9855fbe 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -70,8 +70,9 @@
 #include "usbvision.h"
 #include "usbvision-cards.h"
 
-#define DRIVER_AUTHOR "Joerg Heckenbach <joerg@heckenbach-aw.de>, \
-Dwaine Garden <DwaineGarden@rogers.com>"
+#define DRIVER_AUTHOR					\
+	"Joerg Heckenbach <joerg@heckenbach-aw.de>, "	\
+	"Dwaine Garden <DwaineGarden@rogers.com>"
 #define DRIVER_NAME "usbvision"
 #define DRIVER_ALIAS "USBVision"
 #define DRIVER_DESC "USBVision USB Video Device Driver for Linux"
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index fa15e85..7956a10 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -83,19 +83,18 @@ MODULE_VERSION(my_VERSION);
 
 static int mpt_msi_enable_spi;
 module_param(mpt_msi_enable_spi, int, 0);
-MODULE_PARM_DESC(mpt_msi_enable_spi, " Enable MSI Support for SPI \
-		controllers (default=0)");
+MODULE_PARM_DESC(mpt_msi_enable_spi,
+		 " Enable MSI Support for SPI controllers (default=0)");
 
 static int mpt_msi_enable_fc;
 module_param(mpt_msi_enable_fc, int, 0);
-MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
-		controllers (default=0)");
+MODULE_PARM_DESC(mpt_msi_enable_fc,
+		 " Enable MSI Support for FC controllers (default=0)");
 
 static int mpt_msi_enable_sas;
 module_param(mpt_msi_enable_sas, int, 0);
-MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
-		controllers (default=0)");
-
+MODULE_PARM_DESC(mpt_msi_enable_sas,
+		 " Enable MSI Support for SAS controllers (default=0)");
 
 static int mpt_channel_mapping;
 module_param(mpt_channel_mapping, int, 0);
@@ -105,15 +104,14 @@ static int mpt_debug_level;
 static int mpt_set_debug_level(const char *val, struct kernel_param *kp);
 module_param_call(mpt_debug_level, mpt_set_debug_level, param_get_int,
 		  &mpt_debug_level, 0600);
-MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h \
-	- (default=0)");
+MODULE_PARM_DESC(mpt_debug_level,
+		 " debug level - refer to mptdebug.h - (default=0)");
 
 int mpt_fwfault_debug;
 EXPORT_SYMBOL(mpt_fwfault_debug);
 module_param(mpt_fwfault_debug, int, 0600);
-MODULE_PARM_DESC(mpt_fwfault_debug, "Enable detection of Firmware fault"
-	" and halt Firmware on fault - (default=0)");
-
+MODULE_PARM_DESC(mpt_fwfault_debug,
+		 "Enable detection of Firmware fault and halt Firmware on fault - (default=0)");
 
 static char	MptCallbacksName[MPT_MAX_PROTOCOL_DRIVERS][50];
 
diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index d07cd67..82fe2d0 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -49,8 +49,8 @@ static int bh1780_write(struct bh1780_data *ddata, u8 reg, u8 val, char *msg)
 	int ret = i2c_smbus_write_byte_data(ddata->client, reg, val);
 	if (ret < 0)
 		dev_err(&ddata->client->dev,
-			"i2c_smbus_write_byte_data failed error %d\
-			Register (%s)\n", ret, msg);
+			"i2c_smbus_write_byte_data failed error %d Register (%s)\n",
+			ret, msg);
 	return ret;
 }
 
@@ -59,8 +59,8 @@ static int bh1780_read(struct bh1780_data *ddata, u8 reg, char *msg)
 	int ret = i2c_smbus_read_byte_data(ddata->client, reg);
 	if (ret < 0)
 		dev_err(&ddata->client->dev,
-			"i2c_smbus_read_byte_data failed error %d\
-			 Register (%s)\n", ret, msg);
+			"i2c_smbus_read_byte_data failed error %d Register (%s)\n",
+			ret, msg);
 	return ret;
 }
 
diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index ec3b8c9..7aded90 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -787,8 +787,8 @@ static int __devinit spear_pcie_gadget_probe(struct platform_device *pdev)
 
 	status = request_irq(irq, spear_pcie_gadget_irq, 0, pdev->name, NULL);
 	if (status) {
-		dev_err(&pdev->dev, "pcie gadget interrupt IRQ%d already \
-				claimed\n", irq);
+		dev_err(&pdev->dev,
+			"pcie gadget interrupt IRQ%d already claimed\n", irq);
 		goto err_iounmap;
 	}
 
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index dffa691..d534492 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -83,8 +83,9 @@
 #include "atl1.h"
 
 #define ATLX_DRIVER_VERSION "2.1.3"
-MODULE_AUTHOR("Xiong Huang <xiong.huang@atheros.com>, \
-Chris Snook <csnook@redhat.com>, Jay Cliburn <jcliburn@gmail.com>");
+MODULE_AUTHOR("Xiong Huang <xiong.huang@atheros.com>, "
+	      "Chris Snook <csnook@redhat.com>, "
+	      "Jay Cliburn <jcliburn@gmail.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(ATLX_DRIVER_VERSION);
 
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 4e5c7a1..a70c512 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -242,9 +242,8 @@ static int airo_perm = 0555;
 static int proc_perm = 0644;
 
 MODULE_AUTHOR("Benjamin Reed");
-MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless ethernet \
-cards.  Direct support for ISA/PCI/MPI cards and support \
-for PCMCIA when used with airo_cs.");
+MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless ethernet cards.  "
+		   "Direct support for ISA/PCI/MPI cards and support for PCMCIA when used with airo_cs.");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_SUPPORTED_DEVICE("Aironet 4500, 4800 and Cisco 340/350");
 module_param_array(io, int, NULL, 0);
@@ -252,18 +251,20 @@ module_param_array(irq, int, NULL, 0);
 module_param_array(rates, int, NULL, 0);
 module_param_array(ssids, charp, NULL, 0);
 module_param(auto_wep, int, 0);
-MODULE_PARM_DESC(auto_wep, "If non-zero, the driver will keep looping through \
-the authentication options until an association is made.  The value of \
-auto_wep is number of the wep keys to check.  A value of 2 will try using \
-the key at index 0 and index 1.");
+MODULE_PARM_DESC(auto_wep,
+		 "If non-zero, the driver will keep looping through the authentication options until an association is made.  "
+		 "The value of auto_wep is number of the wep keys to check.  "
+		 "A value of 2 will try using the key at index 0 and index 1.");
 module_param(aux_bap, int, 0);
-MODULE_PARM_DESC(aux_bap, "If non-zero, the driver will switch into a mode \
-than seems to work better for older cards with some older buses.  Before \
-switching it checks that the switch is needed.");
+MODULE_PARM_DESC(aux_bap,
+		 "If non-zero, the driver will switch into a mode that seems to work better for older cards with some older buses.  "
+		 "Before switching it checks that the switch is needed.");
 module_param(maxencrypt, int, 0);
-MODULE_PARM_DESC(maxencrypt, "The maximum speed that the card can do \
-encryption.  Units are in 512kbs.  Zero (default) means there is no limit. \
-Older cards used to be limited to 2mbs (4).");
+MODULE_PARM_DESC(maxencrypt,
+		 "The maximum speed that the card can do encryption.  "
+		 "Units are in 512kbs.  "
+		 "Zero (default) means there is no limit.  "
+		 "Older cards used to be limited to 2mbs (4).");
 module_param(adhoc, int, 0);
 MODULE_PARM_DESC(adhoc, "If non-zero, the card will start in adhoc mode.");
 module_param(probe, int, 0);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
index 81d6a25..162d877 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
@@ -713,8 +713,8 @@ iwl4965_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 			iwl4965_find_first_chain(priv->cfg->valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
-			IWL_DEBUG_CALIB(priv, "All Tx chains are disconnected \
-					W/A - declare %d as connected\n",
+			IWL_DEBUG_CALIB(priv,
+					"All Tx chains are disconnected W/A - declare %d as connected\n",
 					first_chain);
 			break;
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 0f6bb9b..39d1e47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -817,8 +817,8 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 				find_first_chain(priv->cfg->valid_tx_ant);
 			data->disconn_array[first_chain] = 0;
 			active_chains |= BIT(first_chain);
-			IWL_DEBUG_CALIB(priv, "All Tx chains are disconnected \
-					W/A - declare %d as connected\n",
+			IWL_DEBUG_CALIB(priv,
+					"All Tx chains are disconnected W/A - declare %d as connected\n",
 					first_chain);
 			break;
 		}
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 4341026..f57e9c4 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -405,8 +405,8 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	switch (buck) {
 	case MAX8998_BUCK1:
 		dev_dbg(max8998->dev,
-			"BUCK1, i:%d, buck1_vol1:%d, buck1_vol2:%d\n\
-			 buck1_vol3:%d, buck1_vol4:%d\n",
+			"BUCK1, i:%d, buck1_vol1:%d, buck1_vol2:%d\n"
+			"buck1_vol3:%d, buck1_vol4:%d\n",
 			i, max8998->buck1_vol[0], max8998->buck1_vol[1],
 			max8998->buck1_vol[2], max8998->buck1_vol[3]);
 
diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index c3ec0a6..891d194 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -296,8 +296,7 @@ static int sport_startup(struct uart_port *port)
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
 			IRQF_DISABLED, "BFIN_SPORT_UART_CTS", up)) {
 			up->cts_pin = -1;
-			dev_info(port->dev, "Unable to attach BlackFin UART \
-				over SPORT CTS interrupt. So, disable it.\n");
+			dev_info(port->dev, "Unable to attach BlackFin UART over SPORT CTS interrupt. So, disable it.\n");
 		}
 	}
 	if (up->rts_pin >= 0)
diff --git a/drivers/tty/serial/mfd.c b/drivers/tty/serial/mfd.c
index c111f36..cab52f4 100644
--- a/drivers/tty/serial/mfd.c
+++ b/drivers/tty/serial/mfd.c
@@ -49,8 +49,8 @@
 
 static int hsu_dma_enable;
 module_param(hsu_dma_enable, int, 0);
-MODULE_PARM_DESC(hsu_dma_enable, "It is a bitmap to set working mode, if \
-bit[x] is 1, then port[x] will work in DMA mode, otherwise in PIO mode.");
+MODULE_PARM_DESC(hsu_dma_enable,
+		 "It is a bitmap to set working mode, if bit[x] is 1, then port[x] will work in DMA mode, otherwise in PIO mode.");
 
 struct hsu_dma_buffer {
 	u8		*buf;
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 83344d6..b921c56 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -53,9 +53,10 @@
 /*
  * Version Information
  */
-#define DRIVER_AUTHOR "Linus 'Frodo Rabbit' Torvalds, Johannes Erdfelt, \
-Randy Dunlap, Georg Acher, Deti Fliegl, Thomas Sailer, Roman Weissgaerber, \
-Alan Stern"
+#define DRIVER_AUTHOR							\
+	"Linus 'Frodo Rabbit' Torvalds, Johannes Erdfelt, "		\
+	"Randy Dunlap, Georg Acher, Deti Fliegl, Thomas Sailer, "	\
+	"Roman Weissgaerber, Alan Stern"
 #define DRIVER_DESC "USB Universal Host Controller Interface driver"
 
 /* for flakey hardware, ignore overcurrent indicators */
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 0e5aafd..31645af 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -715,8 +715,8 @@ static int ene_ub6250_probe(struct usb_interface *intf,
 
 	if (!(misc_reg03 & 0x01)) {
 		result = -ENODEV;
-		printk(KERN_NOTICE "ums_eneub6250: The driver only supports SD\
-		card. To use SM/MS card, please build driver/stagging/keucr\n");
+		printk(KERN_NOTICE "ums_eneub6250: The driver only supports SD card. "
+		       "To use SM/MS card, please build driver/staging/keucr\n");
 		usb_stor_disconnect(intf);
 	}
 
-- 
1.7.5.rc3.dirty

