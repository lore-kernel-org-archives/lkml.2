Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab2I0IOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:14:50 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:55693 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756194Ab2I0IOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:14:35 -0400
From: Nitin Dhingra <nitin.dhingra@stericsson.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>
Cc: <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Par-Gunnar HJALMDAHL <par-gunnar.hjalmdahl@stericsson.com>,
        Anurag GUPTA-1 <anurag.gupta@stericsson.com>,
        Ingvar PALSSON <ingvar.palsson@stericsson.com>,
        Nitin Dhingra <nitin.dhingra@stericsson.com>,
        Mridul Jain <mridul.jain@stericsson.com>
Subject: [PATCH] staging: Add ST-Ericsson CG2900 driver
Date: Thu, 27 Sep 2012 01:14:08 -0700
Message-ID: <1348733648-13769-1-git-send-email-nitin.dhingra@stericsson.com>
X-Mailer: git-send-email 1.6.6.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the ST-Ericsson CG2900
Connectivity Combo controller (Bluetooth, FM, GPS, ANT, NFC)

Signed-off-by: Nitin Dhingra <nitin.dhingra@stericsson.com>
Signed-off-by: Mridul Jain <mridul.jain@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/configs/u8500_defconfig                 |    8 +
 drivers/staging/Kconfig                          |    2 +
 drivers/staging/Makefile                         |    1 +
 drivers/staging/cg2900/Kconfig                   |   73 +
 drivers/staging/cg2900/Makefile                  |   10 +
 drivers/staging/cg2900/bluetooth/Makefile        |    9 +
 drivers/staging/cg2900/bluetooth/btcg2900.c      |  865 +++++
 drivers/staging/cg2900/bluetooth/cg2900_uart.c   | 2434 +++++++++++++
 drivers/staging/cg2900/bluetooth/hci_ldisc.c     |  645 ++++
 drivers/staging/cg2900/bluetooth/hci_uart.h      |  106 +
 drivers/staging/cg2900/include/cg2900.h          |  338 ++
 drivers/staging/cg2900/include/cg2900_audio.h    |  473 +++
 drivers/staging/cg2900/include/cg2900_hci.h      |   19 +
 drivers/staging/cg2900/mfd/Makefile              |   18 +
 drivers/staging/cg2900/mfd/cg2900_audio.c        | 3533 +++++++++++++++++++
 drivers/staging/cg2900/mfd/cg2900_char_devices.c |  802 +++++
 drivers/staging/cg2900/mfd/cg2900_chip.c         | 3986 ++++++++++++++++++++++
 drivers/staging/cg2900/mfd/cg2900_chip.h         |  608 ++++
 drivers/staging/cg2900/mfd/cg2900_core.c         |  730 ++++
 drivers/staging/cg2900/mfd/cg2900_core.h         |   52 +
 drivers/staging/cg2900/mfd/cg2900_lib.c          |  287 ++
 drivers/staging/cg2900/mfd/cg2900_lib.h          |   65 +
 drivers/staging/cg2900/mfd/cg2900_test.c         |  402 +++
 drivers/staging/cg2900/mfd/stlc2690_chip.c       | 1710 ++++++++++
 drivers/staging/cg2900/mfd/stlc2690_chip.h       |   47 +
 25 files changed, 17223 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/cg2900/Kconfig
 create mode 100644 drivers/staging/cg2900/Makefile
 create mode 100644 drivers/staging/cg2900/bluetooth/Makefile
 create mode 100755 drivers/staging/cg2900/bluetooth/btcg2900.c
 create mode 100755 drivers/staging/cg2900/bluetooth/cg2900_uart.c
 create mode 100644 drivers/staging/cg2900/bluetooth/hci_ldisc.c
 create mode 100644 drivers/staging/cg2900/bluetooth/hci_uart.h
 create mode 100644 drivers/staging/cg2900/include/cg2900.h
 create mode 100644 drivers/staging/cg2900/include/cg2900_audio.h
 create mode 100644 drivers/staging/cg2900/include/cg2900_hci.h
 create mode 100644 drivers/staging/cg2900/mfd/Makefile
 create mode 100755 drivers/staging/cg2900/mfd/cg2900_audio.c
 create mode 100755 drivers/staging/cg2900/mfd/cg2900_char_devices.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_chip.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_chip.h
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_core.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_core.h
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_lib.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_lib.h
 create mode 100755 drivers/staging/cg2900/mfd/cg2900_test.c
 create mode 100644 drivers/staging/cg2900/mfd/stlc2690_chip.c
 create mode 100644 drivers/staging/cg2900/mfd/stlc2690_chip.h

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index da68454..a00118b 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -32,6 +32,14 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 CONFIG_NETFILTER=y
 CONFIG_PHONET=y
+CONFIG_RADIO_CG2900=y
+CONFIG_CG2900=y
+CONFIG_CG2900_CHIP=y
+CONFIG_STLC2690_CHIP=y
+CONFIG_CG2900_UART=y
+CONFIG_CG2900_AUDIO=y
+CONFIG_CG2900_TEST=y
+CONFIG_BT_CG2900=y
 # CONFIG_WIRELESS is not set
 CONFIG_CAIF=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index e3402d5..246b8d0 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -136,4 +136,6 @@ source "drivers/staging/csr/Kconfig"
 
 source "drivers/staging/omap-thermal/Kconfig"
 
+source "drivers/staging/cg2900/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 3be59d0..5e9193f 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -60,3 +60,4 @@ obj-$(CONFIG_USB_G_CCG)		+= ccg/
 obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
 obj-$(CONFIG_CSR_WIFI)		+= csr/
 obj-$(CONFIG_OMAP_BANDGAP)	+= omap-thermal/
+obj-$(CONFIG_CG2900)            += cg2900/
diff --git a/drivers/staging/cg2900/Kconfig b/drivers/staging/cg2900/Kconfig
new file mode 100644
index 0000000..92046b9
--- /dev/null
+++ b/drivers/staging/cg2900/Kconfig
@@ -0,0 +1,73 @@
+#
+# CG2900
+#
+
+config CG2900
+	tristate "Support ST-Ericsson CG2900 main structure"
+	depends on NET && HAS_IOMEM
+	select MFD_CORE
+	help
+	  ST-Ericsson CG2900 Connectivity Combo controller main
+	  structure.
+	  Supports multiple functionalities muxed over a Bluetooth HCI H:4
+	  interface.
+	  CG2900 support Bluetooth, FM radio, and GPS.
+
+config CG2900_CHIP
+	tristate "Support CG2900 Connectivity controller"
+	depends on CG2900
+	help
+	  ST-Ericsson CG2900 Connectivity Controller chip handler.
+	  Contains chip handler performing driver initialization
+	  such as patchdownload and also instantiates the supported
+	  MFD devices.
+
+config STLC2690_CHIP
+	tristate "Support STLC2690 Connectivity controller"
+	depends on CG2900
+	help
+	  ST-Ericsson STLC2690 Connectivity Controller chip handler.
+	  Contains chip handler performing driver initialization
+	  such as patchdownload and also instantiates the supported
+	  MFD devices.
+
+config CG2900_UART
+	tristate "Support CG2900 UART transport"
+	depends on CG2900
+	select BT
+	select BT_HCIUART
+	help
+	  UART driver for ST-Ericsson CG2900 Connectivity Controller.
+	  Contains functions for setting baud rate and to transport
+	  data to and from the CG2900 controller over UART.
+	  Also handles low power handling for the CG2900 when using UART as
+	  transport.
+
+config CG2900_AUDIO
+	tristate "Support CG2900 audio interface"
+	depends on CG2900
+	help
+	  ST-Ericsson CG2900 Connectivity audio interface driver.
+	  Gives a module the ability to setup audio paths
+	  within the CG2900 controller.
+	  Supports both a normal function API and using character device
+	  from user space.
+
+config CG2900_TEST
+	tristate "Support CG2900 Test Char Device"
+	depends on CG2900
+	help
+	  ST-Ericsson CG2900 Test Character Device driver.
+	  Creates a character device which can be used by
+	  a test framework in user space to emulate a connected chip.
+	  Note that this is used to test the chip handler driver,
+	  not to test the connected chip.
+
+config BT_CG2900
+	tristate "ST-Ericsson CG2900 Bluetooth driver"
+	depends on CG2900 && BT
+	help
+	  Select if ST-Ericsson CG2900 Connectivity controller shall be used as
+	  Bluetooth controller for BlueZ.
+	  This driver registers to the Bluetooth stack and when opened,
+	  enables the CG2900 controller in a proper way.
diff --git a/drivers/staging/cg2900/Makefile b/drivers/staging/cg2900/Makefile
new file mode 100644
index 0000000..2e01758
--- /dev/null
+++ b/drivers/staging/cg2900/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for ST-Ericsson CG2900 connectivity combo controller
+#
+
+ccflags-y :=					\
+	-Idrivers/staging/cg2900/include \
+	-Iarch/arm/mach-ux500
+
+obj-$(CONFIG_CG2900)	+= 	mfd/
+obj-y			+= bluetooth/
diff --git a/drivers/staging/cg2900/bluetooth/Makefile b/drivers/staging/cg2900/bluetooth/Makefile
new file mode 100644
index 0000000..936a4a2
--- /dev/null
+++ b/drivers/staging/cg2900/bluetooth/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for ST-Ericsson CG2900 connectivity combo controller
+#
+
+ccflags-y :=					\
+	-Idrivers/staging/cg2900/include
+
+obj-$(CONFIG_BT_CG2900)		+= btcg2900.o
+obj-$(CONFIG_CG2900_UART)	+= cg2900_uart.o hci_ldisc.o
diff --git a/drivers/staging/cg2900/bluetooth/btcg2900.c b/drivers/staging/cg2900/bluetooth/btcg2900.c
new file mode 100755
index 0000000..4293007
--- /dev/null
+++ b/drivers/staging/cg2900/bluetooth/btcg2900.c
@@ -0,0 +1,865 @@
+/*
+ * Bluetooth driver for ST-Ericsson CG2900 connectivity controller.
+ *
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com)
+ * Henrik Possung (henrik.possung@stericsson.com)
+ * Josef Kindberg (josef.kindberg@stericsson.com)
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com)
+ * Kjell Andersson (kjell.k.andersson@stericsson.com)
+ *
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <asm/byteorder.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/platform_device.h>
+#include <linux/skbuff.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/mfd/core.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+#include <net/bluetooth/hci_core.h>
+
+#include "cg2900.h"
+
+#define BT_HEADER_LENGTH		0x03
+
+#define NAME				"BTCG2900 "
+
+/* Wait for 5 seconds for a response to our requests */
+#define RESP_TIMEOUT			5000
+
+/* Bluetooth error codes */
+#define HCI_ERR_NO_ERROR		0x00
+#define HCI_ERR_CMD_DISALLOWED		0x0C
+
+/**
+ * enum reset_state - RESET-states of the HCI driver.
+ *
+ * @RESET_IDLE:		No reset in progress.
+ * @RESET_ACTIVATED:	Reset in progress.
+ * @RESET_UNREGISTERED:	hdev is unregistered.
+ */
+
+enum reset_state {
+	RESET_IDLE,
+	RESET_ACTIVATED,
+	RESET_UNREGISTERED
+};
+
+/**
+ * struct btcg2900_info - Specifies HCI driver private data.
+ *
+ * This type specifies CG2900 HCI driver private data.
+ *
+ * @list:		list_head struct.
+ * @parent:		Parent to this BT device. All BT channels will have
+ *			common parent.
+ * @cmd:		Device structure for BT command channel.
+ * @evt:		Device structure for BT event channel.
+ * @acl:		Device structure for BT ACL channel.
+ * @pdev:		Device structure for platform device.
+ * @hdev:		Device structure for HCI device.
+ * @reset_state:	Device enum for HCI driver reset state.
+ */
+struct btcg2900_info {
+	struct list_head	list;
+	struct device		*parent;
+	struct device		*cmd;
+	struct device		*evt;
+	struct device		*acl;
+	struct hci_dev		*hdev;
+	enum reset_state	reset_state;
+};
+
+/**
+ * struct dev_info - Specifies private data used when receiving callbacks from CG2900 driver.
+ *
+ * @hci_data_type:	Type of data according to BlueZ.
+ */
+struct dev_info {
+	u8	hci_data_type;
+};
+
+/*
+ * hci_wait_queue - Main Wait Queue in HCI driver.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(hci_wait_queue);
+
+/*
+ * btcg2900_devices - List of active CG2900 BT devices.
+ */
+static LIST_HEAD(btcg2900_devices);
+
+/* Internal function declarations */
+static int register_bluetooth(struct btcg2900_info *info);
+
+/* Internal functions */
+
+/**
+ * close_bt_users() - Close all BT channels.
+ * @info:	HCI driver info structure.
+ */
+static void close_bt_users(struct btcg2900_info *info)
+{
+	struct cg2900_user_data *pf_data;
+
+	pf_data = dev_get_platdata(info->cmd);
+	if (pf_data->opened)
+		pf_data->close(pf_data);
+
+	pf_data = dev_get_platdata(info->acl);
+	if (pf_data->opened)
+		pf_data->close(pf_data);
+
+	pf_data = dev_get_platdata(info->evt);
+	if (pf_data->opened)
+		pf_data->close(pf_data);
+}
+
+/**
+ * handle_rx_evt() - Check if received data is response to internal command.
+ * @info:	Info structure.
+ * @skb:	Buffer with data coming from device.
+ *
+ * Returns:
+ *   true if data has been handled internally,
+ *   false otherwise.
+ */
+static bool handle_rx_evt(struct btcg2900_info *info, struct sk_buff *skb)
+{
+	struct hci_event_hdr *evt = (struct hci_event_hdr *)skb->data;
+	struct hci_ev_cmd_complete *cmd_complete;
+	struct hci_ev_cmd_status *cmd_status;
+	u16 op_code;
+	u8 status;
+	bool pkt_handled = false;
+
+	if (evt->evt == HCI_EV_CMD_COMPLETE) {
+		cmd_complete = (struct hci_ev_cmd_complete *)(evt + 1);
+		status = *((u8 *)(cmd_complete + 1));
+		op_code = le16_to_cpu(cmd_complete->opcode);
+	} else if (evt->evt == HCI_EV_CMD_STATUS) {
+		cmd_status = (struct hci_ev_cmd_status *)(evt + 1);
+		op_code = le16_to_cpu(cmd_status->opcode);
+		status = cmd_status->status;
+	}
+
+	if (pkt_handled)
+		kfree_skb(skb);
+
+	return pkt_handled;
+}
+
+/**
+ * hci_read_cb() - Callback for handling data received from CG2900 driver.
+ * @dev:	Device receiving data.
+ * @skb:	Buffer with data coming from device.
+ */
+static void hci_read_cb(struct cg2900_user_data *user, struct sk_buff *skb)
+{
+	int err = 0;
+	struct dev_info *dev_info;
+	struct btcg2900_info *info;
+
+	dev_info = cg2900_get_usr(user);
+	info = dev_get_drvdata(user->dev);
+
+	if (user->dev != info->evt || !handle_rx_evt(info, skb)) {
+		bt_cb(skb)->pkt_type = dev_info->hci_data_type;
+		skb->dev = (struct net_device *)info->hdev;
+		/* Update BlueZ stats */
+		info->hdev->stat.byte_rx += skb->len;
+		if (bt_cb(skb)->pkt_type == HCI_ACLDATA_PKT)
+			info->hdev->stat.acl_rx++;
+		else
+			info->hdev->stat.evt_rx++;
+
+		BT_DBG("Data receive %d bytes", skb->len);
+
+		/* Provide BlueZ with received frame*/
+		err = hci_recv_frame(skb);
+		/* If err, skb have been freed in hci_recv_frame() */
+		if (err)
+			BT_ERR(NAME "Failed in supplying packet to Bluetooth"\
+			       " stack (%d)", err);
+	}
+}
+
+/**
+ * hci_reset_cb() - Callback for handling reset from CG2900 driver.
+ * @dev:	CPD device resetting.
+ */
+static void hci_reset_cb(struct cg2900_user_data *dev)
+{
+	int err;
+	struct btcg2900_info *info;
+	struct cg2900_user_data *pf_data;
+
+	BT_INFO(NAME "hci_reset_cb");
+
+	info = dev_get_drvdata(dev->dev);
+
+	BT_DBG("New reset_state: RESET_ACTIVATED");
+	info->reset_state = RESET_ACTIVATED;
+
+	/*
+	 * Continue to deregister hdev if all channels has been reset else
+	 * return.
+	 */
+	pf_data = dev_get_platdata(info->acl);
+	if (pf_data->opened)
+		return;
+	pf_data = dev_get_platdata(info->cmd);
+	if (pf_data->opened)
+		return;
+	pf_data = dev_get_platdata(info->evt);
+	if (pf_data->opened)
+		return;
+
+	/*
+	 * Deregister HCI device. Close and Destruct functions should
+	 * in turn be called by BlueZ.
+	 */
+	BT_DBG("Deregister HCI device");
+	hci_unregister_dev(info->hdev);
+
+	wait_event_timeout(hci_wait_queue,
+			(RESET_UNREGISTERED == info->reset_state),
+			msecs_to_jiffies(RESP_TIMEOUT));
+	if (RESET_UNREGISTERED != info->reset_state)
+		/*
+		 * Now we are in trouble. Try to register a new hdev
+		 * anyway even though this will cost some memory.
+		 */
+		BT_ERR(NAME "Timeout expired. Could not deregister HCI device");
+
+	/* Init and register hdev */
+	BT_DBG("Register HCI device");
+	err = register_bluetooth(info);
+	if (err)
+		BT_ERR(NAME "HCI Device registration error (%d)", err);
+}
+
+/**
+ * btcg2900_open() - Open HCI interface.
+ * @hdev:	HCI device being opened.
+ *
+ * BlueZ callback function for opening HCI interface to device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL pointer is supplied.
+ *   -EOPNOTSUPP if supplied packet type is not supported.
+ *   -EBUSY if device is already opened.
+ *   -EACCES if opening of channels failed.
+ */
+static int btcg2900_open(struct hci_dev *hdev)
+{
+	struct btcg2900_info *info;
+	struct cg2900_user_data *pf_data;
+	int err;
+
+	BT_INFO("Open ST-Ericsson CG2900 driver");
+
+	if (!hdev) {
+		BT_ERR(NAME "NULL supplied for hdev");
+		return -EINVAL;
+	}
+
+	info = hci_get_drvdata(hdev);
+	if (!info) {
+		BT_ERR(NAME "NULL supplied for driver_data");
+		return -EINVAL;
+	}
+
+	if (test_and_set_bit(HCI_RUNNING, &(hdev->flags))) {
+		BT_ERR(NAME "Device already opened!");
+		return -EBUSY;
+	}
+
+	pf_data = dev_get_platdata(info->acl);
+	err = pf_data->open(pf_data);
+	if (err) {
+		BT_ERR("Couldn't open BT ACL channel (%d)", err);
+		goto handle_error;
+	}
+
+	pf_data = dev_get_platdata(info->cmd);
+	err = pf_data->open(pf_data);
+	if (err) {
+		BT_ERR("Couldn't open BT CMD channel (%d)", err);
+		goto handle_error;
+	}
+
+	pf_data = dev_get_platdata(info->evt);
+	err = pf_data->open(pf_data);
+	if (err) {
+		BT_ERR("Couldn't open BT EVT channel (%d)", err);
+		goto handle_error;
+	}
+
+	if (info->reset_state == RESET_ACTIVATED) {
+		BT_DBG("New reset_state: RESET_IDLE");
+		info->reset_state = RESET_IDLE;
+	}
+
+	return 0;
+
+handle_error:
+	close_bt_users(info);
+	clear_bit(HCI_RUNNING, &(hdev->flags));
+	return err;
+
+}
+
+/**
+ * btcg2900_close() - Close HCI interface.
+ * @hdev:	HCI device being closed.
+ *
+ * BlueZ callback function for closing HCI interface.
+ * It flushes the interface first.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL pointer is supplied.
+ *   -EOPNOTSUPP if supplied packet type is not supported.
+ *   -EBUSY if device is not opened.
+ */
+static int btcg2900_close(struct hci_dev *hdev)
+{
+	struct btcg2900_info *info = NULL;
+
+	BT_DBG("btcg2900_close");
+
+	if (!hdev) {
+		BT_ERR(NAME "NULL supplied for hdev");
+		return -EINVAL;
+	}
+
+	info = hci_get_drvdata(hdev);
+	if (!info) {
+		BT_ERR(NAME "NULL supplied for driver_data");
+		return -EINVAL;
+	}
+
+	if (!test_and_clear_bit(HCI_RUNNING, &(hdev->flags))) {
+		BT_ERR(NAME "Device already closed!");
+		return -EBUSY;
+	}
+
+	/* Do not do this if there is an reset ongoing */
+	if (info->reset_state == RESET_ACTIVATED)
+		goto remove_users;
+
+remove_users:
+	/* Finally deregister all users and free allocated data */
+	close_bt_users(info);
+	return 0;
+}
+
+/**
+ * btcg2900_send() - Send packet to device.
+ * @skb:	sk buffer to be sent.
+ *
+ * BlueZ callback function for sending sk buffer.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL pointer is supplied.
+ *   -EOPNOTSUPP if supplied packet type is not supported.
+ *   Error codes from cg2900_write.
+ */
+static int btcg2900_send(struct sk_buff *skb)
+{
+	struct hci_dev *hdev;
+	struct btcg2900_info *info;
+	struct cg2900_user_data *pf_data;
+	int err = 0;
+
+	if (!skb) {
+		BT_ERR(NAME "NULL supplied for skb");
+		return -EINVAL;
+	}
+
+	hdev = (struct hci_dev *)(skb->dev);
+	if (!hdev) {
+		BT_ERR(NAME "NULL supplied for hdev");
+		return -EINVAL;
+	}
+
+	info = hci_get_drvdata(hdev);
+	if (!info) {
+		BT_ERR(NAME "NULL supplied for info");
+		return -EINVAL;
+	}
+
+	/* Update BlueZ stats */
+	hdev->stat.byte_tx += skb->len;
+
+	BT_DBG("Data transmit %d bytes", skb->len);
+
+	switch (bt_cb(skb)->pkt_type) {
+	case HCI_COMMAND_PKT:
+		BT_DBG("Sending HCI_COMMAND_PKT");
+		pf_data = dev_get_platdata(info->cmd);
+		err = pf_data->write(pf_data, skb);
+		hdev->stat.cmd_tx++;
+		break;
+	case HCI_ACLDATA_PKT:
+		BT_DBG("Sending HCI_ACLDATA_PKT");
+		pf_data = dev_get_platdata(info->acl);
+		err = pf_data->write(pf_data, skb);
+		hdev->stat.acl_tx++;
+		break;
+	default:
+		BT_ERR(NAME "Trying to transmit unsupported packet type"\
+		       " (0x%.2X)", bt_cb(skb)->pkt_type);
+		err = -EOPNOTSUPP;
+		break;
+	};
+
+	return err;
+}
+
+/**
+ * get_info() - Return info structure for this device.
+ * @dev:	Current device.
+ *
+ * Returns:
+ *   Pointer to info struct if there is no error.
+ *   ERR_PTR(-ENOMEM) if allocation fails.
+ */
+static struct btcg2900_info *get_info(struct device *dev)
+{
+	struct list_head *cursor;
+	struct btcg2900_info *tmp;
+	struct btcg2900_info *info = NULL;
+
+	/* Find the info structure */
+	list_for_each(cursor, &btcg2900_devices) {
+		tmp = list_entry(cursor, struct btcg2900_info, list);
+		if (tmp->parent == dev->parent) {
+			info = tmp;
+			break;
+		}
+	}
+
+	if (info)
+		return info;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		BT_ERR("Could not allocate info struct");
+		return ERR_PTR(-ENOMEM);
+	}
+	info->parent = dev->parent;
+	list_add_tail(&info->list, &btcg2900_devices);
+	BT_DBG("CG2900 device added");
+	return info;
+}
+
+/**
+ * device_removed() - Remove device from list if there are no channels left.
+ * @info:	BTCG2900 info structure.
+ */
+static void device_removed(struct btcg2900_info *info)
+{
+	struct list_head *cursor;
+	struct btcg2900_info *tmp;
+
+	if (info->acl || info->cmd || info->evt)
+		/* There are still devices active */
+		return;
+
+	/* Find the info structure and delete it */
+	list_for_each(cursor, &btcg2900_devices) {
+		tmp = list_entry(cursor, struct btcg2900_info, list);
+		if (tmp == info) {
+			list_del(cursor);
+			break;
+		}
+	}
+	kfree(info);
+	BT_DBG("CG2900 device removed");
+}
+
+/**
+ * register_bluetooth() - Initialize module.
+ *
+ * Alloc, init, and register HCI device to BlueZ.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   Error codes from hci_register_dev.
+ */
+static int register_bluetooth(struct btcg2900_info *info)
+{
+	int err;
+	struct cg2900_user_data *pf_data;
+
+	/* Check if all channels have been probed */
+	if (!info->acl || !info->cmd || !info->evt)
+		return 0;
+
+	pf_data = dev_get_platdata(info->cmd);
+
+	info->hdev = hci_alloc_dev();
+	if (!info->hdev) {
+		BT_ERR("Could not allocate mem for CG2900 BT driver");
+		return -ENOMEM;
+	}
+
+	SET_HCIDEV_DEV(info->hdev, info->parent);
+	info->hdev->bus = pf_data->channel_data.bt_bus;
+	hci_set_drvdata(info->hdev, info);
+	info->hdev->open = btcg2900_open;
+	info->hdev->close = btcg2900_close;
+	info->hdev->send = btcg2900_send;
+
+	err = hci_register_dev(info->hdev);
+	if (err) {
+		BT_ERR("Can not register BTCG2900 HCI device (%d)", err);
+		hci_free_dev(info->hdev);
+		info->hdev = NULL;
+	}
+
+	BT_INFO("CG2900 registered");
+
+	BT_DBG("New reset_state: RESET_IDLE");
+	info->reset_state = RESET_IDLE;
+
+	return err;
+}
+
+/**
+ * probe_common() - Initialize channel and register to BT stack.
+ * @dev:		Current device.
+ * @info:		BTCG2900 info structure.
+ * @hci_data_type:	Data type of this channel, e.g. ACL.
+ *
+ * Allocate and initialize private data. Register to Bluetooth stack.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   Error codes from register_bluetooth.
+ */
+static int probe_common(struct platform_device *pdev,
+			struct btcg2900_info *info,
+			u8 hci_data_type)
+{
+	int err;
+	struct cg2900_user_data *pf_data;
+	struct dev_info *dev_info;
+	struct device *dev = &pdev->dev;
+
+	dev_info = kzalloc(sizeof(*dev_info), GFP_KERNEL);
+	if (!dev_info) {
+		BT_ERR("Could not allocate dev_info");
+		return -ENOMEM;
+	}
+
+	dev_set_drvdata(dev, info);
+
+	pf_data = dev_get_platdata(dev);
+	pf_data->dev = dev;
+	pf_data->read_cb = hci_read_cb;
+	pf_data->reset_cb = hci_reset_cb;
+
+	/* Init and register hdev */
+	err = register_bluetooth(info);
+	if (err) {
+		BT_ERR("HCI Device registration error (%d)", err);
+		kfree(dev_info);
+		return err;
+	}
+	dev_info->hci_data_type = hci_data_type;
+	cg2900_set_usr(pf_data, dev_info);
+
+	return 0;
+}
+
+/**
+ * btcg2900_cmd_probe() - Initialize command channel.
+ * @pdev:	Platform device.
+ *
+ * Allocate and initialize private data.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from get_info and probe_common.
+ */
+static int __devinit btcg2900_cmd_probe(struct platform_device *pdev)
+{
+	int err;
+	struct btcg2900_info *info;
+
+	BT_DBG("Starting CG2900 Command channel");
+
+	info = get_info(&pdev->dev);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->cmd = &pdev->dev;
+
+	err = probe_common(pdev, info, HCI_COMMAND_PKT);
+	if (err) {
+		BT_ERR("Failed to initialize channel");
+		info->cmd = NULL;
+		device_removed(info);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * btcg2900_acl_probe() - Initialize command channel.
+ * @pdev:	Platform device.
+ *
+ * Allocate and initialize private data.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from get_info and probe_common.
+ */
+static int __devinit btcg2900_acl_probe(struct platform_device *pdev)
+{
+	int err;
+	struct btcg2900_info *info;
+
+	BT_DBG("Starting CG2900 ACL channel");
+
+	info = get_info(&pdev->dev);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->acl = &pdev->dev;
+
+	err = probe_common(pdev, info, HCI_ACLDATA_PKT);
+	if (err) {
+		BT_ERR("Failed to initialize channel");
+		info->acl = NULL;
+		device_removed(info);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * btcg2900_evt_probe() - Initialize event channel.
+ * @pdev:	Platform device.
+ *
+ * Allocate and initialize private data.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from get_info and probe_common.
+ */
+static int __devinit btcg2900_evt_probe(struct platform_device *pdev)
+{
+	int err;
+	struct btcg2900_info *info;
+
+	BT_DBG("Starting CG2900 Event channel");
+
+	info = get_info(&pdev->dev);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->evt = &pdev->dev;
+
+	err = probe_common(pdev, info, HCI_EVENT_PKT);
+	if (err) {
+		BT_ERR("Failed to initialize channel");
+		info->evt = NULL;
+		device_removed(info);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * remove_common() - Remove channel.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from hci_unregister_dev.
+ */
+static int remove_common(struct platform_device *pdev,
+			 struct btcg2900_info *info)
+{
+	int err = 0;
+	struct cg2900_user_data *pf_data;
+	struct dev_info *dev_info;
+
+	pf_data = dev_get_platdata(&pdev->dev);
+	dev_info = cg2900_get_usr(pf_data);
+
+	kfree(dev_info);
+	cg2900_set_usr(pf_data, NULL);
+
+	if (!info->hdev)
+		goto finished;
+
+	BT_INFO("Unregistering CG2900");
+	hci_set_drvdata(info->hdev, NULL);
+	hci_unregister_dev(info->hdev);
+	hci_free_dev(info->hdev);
+	info->hdev = NULL;
+
+finished:
+	device_removed(info);
+	return err;
+}
+
+/**
+ * btcg2900_cmd_remove() - Remove command channel.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from remove_common.
+ */
+static int __devexit btcg2900_cmd_remove(struct platform_device *pdev)
+{
+	struct btcg2900_info *info;
+
+	BT_DBG("Removing CG2900 Command channel");
+
+	info = dev_get_drvdata(&pdev->dev);
+	info->cmd = NULL;
+	return remove_common(pdev, info);
+}
+
+/**
+ * btcg2900_acl_remove() - Remove ACL channel.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from remove_common.
+ */
+static int __devexit btcg2900_acl_remove(struct platform_device *pdev)
+{
+	struct btcg2900_info *info;
+
+	BT_DBG("Removing CG2900 ACL channel");
+
+	info = dev_get_drvdata(&pdev->dev);
+	info->acl = NULL;
+	return remove_common(pdev, info);
+}
+
+/**
+ * btcg2900_evt_remove() - Remove event channel.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from remove_common.
+ */
+static int __devexit btcg2900_evt_remove(struct platform_device *pdev)
+{
+	struct btcg2900_info *info;
+
+	BT_DBG("Removing CG2900 Event channel");
+
+	info = dev_get_drvdata(&pdev->dev);
+	info->evt = NULL;
+	return remove_common(pdev, info);
+}
+
+static struct platform_driver btcg2900_cmd_driver = {
+	.driver = {
+		.name	= "cg2900-btcmd",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= btcg2900_cmd_probe,
+	.remove	= __devexit_p(btcg2900_cmd_remove),
+};
+
+static struct platform_driver btcg2900_acl_driver = {
+	.driver = {
+		.name	= "cg2900-btacl",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= btcg2900_acl_probe,
+	.remove	= __devexit_p(btcg2900_acl_remove),
+};
+
+static struct platform_driver btcg2900_evt_driver = {
+	.driver = {
+		.name	= "cg2900-btevt",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= btcg2900_evt_probe,
+	.remove	= __devexit_p(btcg2900_evt_remove),
+};
+
+/**
+ * btcg2900_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init btcg2900_init(void)
+{
+	int err;
+
+	BT_DBG("btcg2900_init");
+
+	err = platform_driver_register(&btcg2900_cmd_driver);
+	if (err) {
+		BT_ERR("Failed to register cmd (%d)", err);
+		return err;
+	}
+	err = platform_driver_register(&btcg2900_acl_driver);
+	if (err) {
+		BT_ERR("Failed to register acl (%d)", err);
+		return err;
+	}
+	err = platform_driver_register(&btcg2900_evt_driver);
+	if (err) {
+		BT_ERR("Failed to register evt (%d)", err);
+		return err;
+	}
+	return err;
+}
+
+/**
+ * btcg2900_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit btcg2900_exit(void)
+{
+	BT_DBG("btcg2900_exit");
+	platform_driver_unregister(&btcg2900_cmd_driver);
+	platform_driver_unregister(&btcg2900_acl_driver);
+	platform_driver_unregister(&btcg2900_evt_driver);
+}
+
+module_init(btcg2900_init);
+module_exit(btcg2900_exit);
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_AUTHOR("Henrik Possung ST-Ericsson");
+MODULE_AUTHOR("Josef Kindberg ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux Bluetooth HCI H:4 Driver for ST-Ericsson controller");
diff --git a/drivers/staging/cg2900/bluetooth/cg2900_uart.c b/drivers/staging/cg2900/bluetooth/cg2900_uart.c
new file mode 100755
index 0000000..bcc5827
--- /dev/null
+++ b/drivers/staging/cg2900/bluetooth/cg2900_uart.c
@@ -0,0 +1,2434 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * Lukasz Rymanowski (lukasz.rymanowski@tieto.com) for ST-Ericsson.
+ * Hemant Gupta (hemant.gupta@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth UART Driver for ST-Ericsson CG2900 connectivity controller.
+ */
+#define NAME			"cg2900_uart"
+#define pr_fmt(fmt)		NAME ": " fmt "\n"
+
+#include <asm/byteorder.h>
+#include <linux/atomic.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/pm_qos.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/timer.h>
+#include <linux/regulator/consumer.h>
+#include <linux/tty.h>
+#include <linux/tty_ldisc.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include "cg2900.h"
+
+#include "hci_uart.h"
+
+#define MAIN_DEV		(uart_info->dev)
+
+/* Workqueues' names */
+#define UART_WQ_NAME		"cg2900_uart_wq"
+#define UART_NAME		"cg2900_uart"
+
+/*
+ * A BT command complete event without any parameters is the defined size plus
+ * 1 byte extra for the status field which is always present in a
+ * command complete event.
+ */
+#define HCI_BT_CMD_COMPLETE_LEN	(sizeof(struct hci_ev_cmd_complete) + 1)
+
+/* Timers used in milliseconds */
+#define UART_TX_TIMEOUT		100
+#define UART_RX_TIMEOUT		20
+#define UART_RESP_TIMEOUT	3000
+#define UART_RESUME_TIMEOUT	20
+/* Minimum time host should maintain the break */
+#define UART_MIN_BREAK_ON_TIME 5
+
+/* Timers used in microseconds */
+/* Minimum time required after sending the last data to apply break */
+#define UART_MIN_TIME_BEFORE_APPLYING_BREAK 900
+/* Minimum time required after exiting break condition */
+#define UART_MIN_BREAK_OFF_TIME 200
+
+/* Max latency in microseconds for PM QoS to achieve max throughput */
+#define CG2900_PM_QOS_LATENCY	30
+
+/* Number of bytes to reserve at start of sk_buffer when receiving packet */
+#define RX_SKB_RESERVE		8
+/* Max size of received packet (not including reserved bytes) */
+#define RX_SKB_MAX_SIZE		1024
+
+/* Size of the header in the different packets */
+#define HCI_BT_EVT_HDR_SIZE	2
+#define HCI_BT_ACL_HDR_SIZE	4
+#define HCI_NFC_HDR_SIZE	3
+#define HCI_ANT_CMD_HDR_SIZE	1
+#define HCI_ANT_DAT_HDR_SIZE	1
+#define HCI_FM_RADIO_HDR_SIZE	1
+#define HCI_GNSS_HDR_SIZE	3
+#define HCI_DEV_MGMT_HDR_SIZE	2
+
+/* Position of length field in the different packets */
+#define HCI_EVT_LEN_POS		2
+#define HCI_ACL_LEN_POS		3
+#define FM_RADIO_LEN_POS	1
+#define GNSS_LEN_POS		2
+
+/* Baud rate defines */
+#define ZERO_BAUD_RATE		0
+#define DEFAULT_BAUD_RATE	115200
+#define HIGH_BAUD_RATE		3250000
+
+#define BT_SIZE_OF_HDR				(sizeof(__le16) + sizeof(__u8))
+#define BT_PARAM_LEN(__pkt_len)			(__pkt_len - BT_SIZE_OF_HDR)
+
+/* Standardized Bluetooth H:4 channels */
+#define HCI_BT_CMD_H4_CHANNEL			0x01
+#define HCI_BT_ACL_H4_CHANNEL			0x02
+#define HCI_BT_SCO_H4_CHANNEL			0x03
+#define HCI_BT_EVT_H4_CHANNEL			0x04
+
+#define HCI_DEV_MGMT_H4_CHANNEL			0x80
+
+#define BT_BDADDR_SIZE				6
+
+/* Reserve 1 byte for the HCI H:4 header */
+#define HCI_H4_SIZE				1
+#define CG2900_SKB_RESERVE			HCI_H4_SIZE
+
+/* Default H4 channels which may change depending on connected controller */
+#define HCI_NFC_H4_CHANNEL			0x05
+#define HCI_ANT_CMD_H4_CHANNEL			0x0C
+#define HCI_ANT_DAT_H4_CHANNEL			0x0E
+#define HCI_FM_RADIO_H4_CHANNEL			0x08
+#define HCI_GNSS_H4_CHANNEL			0x09
+#define HCI_DEBUG_H4_CHANNEL			0x0B
+#define HCI_DEV_MGMT_CHANNEL_BIT	0x80
+
+/* Bluetooth error codes */
+#define HCI_BT_ERROR_NO_ERROR			0x00
+
+/* Bytes in the command Hci_Cmd_ST_Set_Uart_Baud_Rate */
+#define CG2900_BAUD_RATE_57600				0x03
+#define CG2900_BAUD_RATE_115200				0x02
+#define CG2900_BAUD_RATE_230400				0x01
+#define CG2900_BAUD_RATE_460800				0x00
+#define CG2900_BAUD_RATE_921600				0x20
+#define CG2900_BAUD_RATE_2000000			0x25
+#define CG2900_BAUD_RATE_3000000			0x27
+#define CG2900_BAUD_RATE_3250000			0x28
+#define CG2900_BAUD_RATE_4000000			0x2B
+#define CG2900_BAUD_RATE_4050000			0x59
+#define CG2900_BAUD_RATE_4800000			0x5A
+
+/* NFC: 1byte extra is recieved for checksum */
+#define NFC_CHECKSUM_DATA_LEN			0x01
+
+/* NFC */
+struct nfc_hci_hdr {
+	__u8	op_code;
+	__le16	plen;
+} __packed;
+
+/* ANT COMMAND HEADER */
+struct ant_cmd_hci_hdr {
+	__u8	plen;
+} __packed;
+
+/* ANT DATA HEADER */
+struct ant_dat_hci_hdr {
+	__u8	plen;
+} __packed;
+
+/**
+ * enum sleep_allowed_bits - bits indicating if sleep is allowed.
+ * @SLEEP_TTY_READY:	Bit for checking if break can be applied using tty.
+ * @SLEEP_CORE_READY:	Bit for checking if core is ready for sleep or not.
+ */
+enum sleep_allowed_bits {
+	SLEEP_TTY_READY,
+	SLEEP_CORE_READY
+};
+
+/* GNSS */
+struct gnss_hci_hdr {
+	__u8	op_code;
+	__le16	plen;
+} __packed;
+
+/* FM legacy command packet */
+struct fm_leg_cmd {
+	__u8	length;
+	__u8	opcode;
+	__u8	read_write;
+	__u8	fm_function;
+	union { /* Payload varies with function */
+		__le16	irqmask;
+		struct fm_leg_fm_cmd {
+			__le16	head;
+			__le16	data[];
+		} fm_cmd;
+	};
+} __packed;
+
+/* FM legacy command complete packet */
+struct fm_leg_cmd_cmpl {
+	__u8	param_length;
+	__u8	status;
+	__u8	opcode;
+	__u8	read_write;
+	__u8	cmd_status;
+	__u8	fm_function;
+	__le16	response_head;
+	__le16	data[];
+} __packed;
+
+/* FM legacy interrupt packet, PG2 style */
+struct fm_leg_irq_v2 {
+	__u8	param_length;
+	__u8	status;
+	__u8	opcode;
+	__u8	event_type;
+	__u8	event_id;
+	__le16	irq;
+} __packed;
+
+/* FM legacy interrupt packet, PG1 style */
+struct fm_leg_irq_v1 {
+	__u8	param_length;
+	__u8	opcode;
+	__u8	event_id;
+	__le16	irq;
+} __packed;
+
+union fm_leg_evt_or_irq {
+	__u8			param_length;
+	struct fm_leg_cmd_cmpl	evt;
+	struct fm_leg_irq_v2	irq_v2;
+	struct fm_leg_irq_v1	irq_v1;
+} __packed;
+
+/* BT VS SetBaudRate command */
+#define CG2900_BT_OP_VS_SET_BAUD_RATE			0xFC09
+struct bt_vs_set_baud_rate_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	baud_rate;
+} __packed;
+
+/**
+ * enum uart_rx_state - UART RX-state for UART.
+ * @W4_PACKET_TYPE:	Waiting for packet type.
+ * @W4_EVENT_HDR:	Waiting for BT event header.
+ * @W4_ACL_HDR:		Waiting for BT ACL header.
+ * @W4_NFC_HDR:		Waiting for NFC header.
+ * @W4_ANT_CMD_HDR:	Waiting for ANT command header.
+ * @W4_ANT_DAT_HDR:	Waiting for ANT data header.
+ * @W4_FM_RADIO_HDR:	Waiting for FM header.
+ * @W4_DBG_HDR:		Waiting for Debug header.
+ * @W4_GNSS_HDR:	Waiting for GNSS header.
+ * @W4_DATA:		Waiting for data in rest of the packet (after header).
+ */
+enum uart_rx_state {
+	W4_PACKET_TYPE,
+	W4_EVENT_HDR,
+	W4_ACL_HDR,
+	W4_NFC_HDR,
+	W4_ANT_CMD_HDR,
+	W4_ANT_DAT_HDR,
+	W4_FM_RADIO_HDR,
+	W4_GNSS_HDR,
+	W4_DBG_HDR,
+	W4_DEV_MGMT_HDR,
+	W4_DATA
+};
+
+/**
+  * enum sleep_state - Sleep-state for UART.
+  * @CHIP_AWAKE:  Chip is awake.
+  * @CHIP_FALLING_ASLEEP:  Chip is falling asleep.
+  * @CHIP_ASLEEP: Chip is asleep.
+  * @CHIP_SUSPENDED: Chip in suspend state.
+  * @CHIP_RESUMING: Chip is going back from suspend state.
+  * @CHIP_POWERED_DOWN: Chip is off.
+  */
+enum sleep_state {
+	CHIP_AWAKE,
+	CHIP_FALLING_ASLEEP,
+	CHIP_ASLEEP,
+	CHIP_SUSPENDED,
+	CHIP_RESUMING,
+	CHIP_POWERED_DOWN
+};
+
+/**
+ * enum baud_rate_change_state - Baud rate-state for UART.
+ * @BAUD_IDLE:		No baud rate change is ongoing.
+ * @BAUD_SENDING_RESET:	HCI reset has been sent. Waiting for command complete
+ *			event.
+ * @BAUD_START:		Set baud rate cmd scheduled for sending.
+ * @BAUD_SENDING:	Set baud rate cmd sending in progress.
+ * @BAUD_WAITING:	Set baud rate cmd sent, waiting for command complete
+ *			event.
+ * @BAUD_SUCCESS:	Baud rate change has succeeded.
+ * @BAUD_FAIL:		Baud rate change has failed.
+ */
+enum baud_rate_change_state {
+	BAUD_IDLE,
+	BAUD_SENDING_RESET,
+	BAUD_START,
+	BAUD_SENDING,
+	BAUD_WAITING,
+	BAUD_SUCCESS,
+	BAUD_FAIL
+};
+
+/**
+ * struct uart_work_struct - Work structure for UART module.
+ * @work:	Work structure.
+ * @data:	Pointer to private data.
+ *
+ * This structure is used to pack work for work queue.
+ */
+struct uart_work_struct {
+	struct work_struct	work;
+	void			*data;
+};
+
+/**
+ * struct uart_delayed_work_struct - Work structure for UART module.
+ * @delayed_work:	Work structure.
+ * @data:	Pointer to private data.
+ *
+ * This structure is used to pack work for work queue.
+ */
+struct uart_delayed_work_struct {
+	struct delayed_work	work;
+	void			*data;
+};
+
+/**
+ * struct uart_info - Main UART info structure.
+ * @rx_state:		Current RX state.
+ * @rx_count:		Number of bytes left to receive.
+ * @rx_skb:		SK_buffer to store the received data into.
+ * @tx_queue:		TX queue for sending data to chip.
+ * @rx_skb_lock	Spin lock to protect rx_skb.
+ * @hu:			Hci uart structure.
+ * @wq:			UART work queue.
+ * @baud_rate_state:	UART baud rate change state.
+ * @baud_rate:		Current baud rate setting.
+ * @sleep_state:	UART sleep state.
+ * @sleep_work:	Delayed sleep work struct.
+ * @wakeup_work:	Wake-up work struct.
+ * @restart_sleep_work:	Reschedule sleep_work and wake-up work struct.
+ * @sleep_state_lock:	Used to protect chip state.
+ * @sleep_flags:	Indicates whether sleep mode is allowed.
+ * @tx_in_progress:	Indicates data sending in progress.
+ * @rx_in_progress:	Indicates data receiving in progress.
+ * @transmission_lock:	Spin_lock to protect tx/rx_in_progress.
+ * @regulator:		Regulator.
+ * @regulator_enabled:	True if regulator is enabled.
+ * @dev:		Pointer to CG2900 uart device.
+ * @chip_dev:		Chip device for current UART transport.
+ * @cts_irq:		CTS interrupt for this UART.
+ * @cts_gpio:		CTS GPIO for this UART.
+ * @wakeup_lock:	Wake lock for keeping user space awake (for Android).
+ * @suspend_blocked:	True if suspend operation is blocked in the framework.
+ * @pm_qos_latency:	PM QoS structure.
+ */
+struct uart_info {
+	enum uart_rx_state		rx_state;
+	unsigned long			rx_count;
+	struct sk_buff			*rx_skb;
+	struct sk_buff_head		tx_queue;
+	spinlock_t			rx_skb_lock;
+
+	struct hci_uart			*hu;
+
+	struct workqueue_struct		*wq;
+	enum baud_rate_change_state	baud_rate_state;
+	int				baud_rate;
+	enum sleep_state		sleep_state;
+	struct uart_delayed_work_struct	sleep_work;
+	struct uart_work_struct		wakeup_work;
+	struct uart_work_struct		restart_sleep_work;
+	struct mutex			sleep_state_lock;
+	unsigned long			sleep_flags;
+	bool				tx_in_progress;
+	bool				rx_in_progress;
+	spinlock_t			transmission_lock;
+	struct	regulator		*regulator;
+	bool				regulator_enabled;
+	struct device			*dev;
+	struct cg2900_chip_dev		chip_dev;
+	int				cts_irq;
+	int				cts_gpio;
+	struct wakeup_source		wakeup_lock;
+	bool				suspend_blocked;
+	struct pm_qos_request		pm_qos_latency;
+};
+
+/* Module parameters */
+static int uart_default_baud = DEFAULT_BAUD_RATE;
+static int uart_high_baud = HIGH_BAUD_RATE;
+static int uart_debug;
+
+static DECLARE_WAIT_QUEUE_HEAD(uart_wait_queue);
+
+static void wake_up_chip(struct uart_info *uart_info);
+
+/**
+ * is_chip_flow_off() - Check if chip has set flow off.
+ * @tty:	Pointer to tty.
+ *
+ * Returns:
+ *   true - chip flows off.
+ *   false - chip flows on.
+ */
+static bool is_chip_flow_off(struct uart_info *uart_info)
+{
+	int lines = 0;
+
+	if (uart_info->hu)
+		lines = hci_uart_tiocmget(uart_info->hu);
+
+	if (lines & TIOCM_CTS)
+		return false;
+	else
+		return true;
+}
+
+/**
+ * create_work_item() - Create work item and add it to the work queue.
+ * @uart_info:	Main Uart structure.
+ * @work_func:	Work function.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EBUSY if not possible to queue work.
+ *   -ENOMEM if allocation fails.
+ */
+static int create_work_item(struct uart_info *uart_info,
+					work_func_t work_func)
+{
+	struct uart_work_struct *new_work;
+	int res;
+
+	new_work = kmalloc(sizeof(*new_work), GFP_ATOMIC);
+	if (!new_work) {
+		dev_err(MAIN_DEV,
+			"Failed to alloc memory for uart_work_struct\n");
+		return -ENOMEM;
+	}
+
+	new_work->data = uart_info;
+	INIT_WORK(&new_work->work, work_func);
+
+	res = queue_work(uart_info->wq, &new_work->work);
+	if (!res) {
+		dev_err(MAIN_DEV,
+			"Failed to queue work_struct because it's already "
+			"in the queue\n");
+		kfree(new_work);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/**
+ * handle_cts_irq() - Called to handle CTS interrupt in work context.
+ * @work:	work which needs to be done.
+ *
+ * The handle_cts_irq() function is a work handler called if interrupt on CTS
+ * occurred. It wakes up the transport.
+ */
+static void handle_cts_irq(struct work_struct *work)
+{
+	struct uart_work_struct *current_work =
+		container_of(work, struct uart_work_struct, work);
+	struct uart_info *uart_info = (struct uart_info *)current_work->data;
+
+	pm_qos_update_request(&uart_info->pm_qos_latency,
+			      CG2900_PM_QOS_LATENCY);
+
+	spin_lock_bh(&(uart_info->transmission_lock));
+	/* Mark that there is an ongoing transfer. */
+	uart_info->rx_in_progress = true;
+	spin_unlock_bh(&(uart_info->transmission_lock));
+
+	/* Cancel pending sleep work if there is any. */
+	cancel_delayed_work_sync(&uart_info->sleep_work.work);
+
+	mutex_lock(&(uart_info->sleep_state_lock));
+
+	if (uart_info->sleep_state == CHIP_SUSPENDED) {
+		dev_dbg(MAIN_DEV, "New sleep_state: CHIP_RESUMING\n");
+		uart_info->sleep_state = CHIP_RESUMING;
+		mutex_unlock(&(uart_info->sleep_state_lock));
+	} else {
+		mutex_unlock(&(uart_info->sleep_state_lock));
+		wake_up_chip(uart_info);
+	}
+
+	kfree(current_work);
+}
+
+/**
+ * cts_interrupt() - Called to handle CTS interrupt.
+ * @irq:	Interrupt that occurred.
+ * @dev_id:	Device ID where interrupt occurred.
+ *
+ * The cts_interrupt() function is called if interrupt on CTS occurred.
+ * It disables the interrupt and starts a new work thread to handle
+ * the interrupt.
+ */
+static irqreturn_t cts_interrupt(int irq, void *dev_id)
+{
+	struct uart_info *uart_info = dev_get_drvdata(dev_id);
+#ifdef CONFIG_PM
+	disable_irq_wake(irq);
+#endif
+	disable_irq_nosync(irq);
+	if (!uart_info->suspend_blocked) {
+		__pm_stay_awake(&uart_info->wakeup_lock);
+		uart_info->suspend_blocked = true;
+	}
+
+	/* Create work and leave IRQ context. */
+	(void)create_work_item(uart_info, handle_cts_irq);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * set_cts_irq() - Enable interrupt on CTS.
+ * @uart_info: Main Uart structure.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from request_irq and disable_uart.
+ */
+static int set_cts_irq(struct uart_info *uart_info)
+{
+	int err;
+	int cts_val = 0;
+
+	/* Set IRQ on CTS. */
+	err = request_irq(uart_info->cts_irq,
+			  cts_interrupt,
+			  IRQF_TRIGGER_FALLING,
+			  UART_NAME,
+			  uart_info->dev);
+	if (err) {
+		dev_err(MAIN_DEV, "Could not request CTS IRQ (%d)\n", err);
+		return err;
+	}
+
+	/*
+	 * It may happen that there was already an interrupt on CTS just before
+	 * the enable_irq() call above. If the CTS line is low now it means that
+	 * it's happened, so disable the CTS interrupt and return -ECANCELED.
+	 */
+	cts_val = gpio_get_value(uart_info->cts_gpio);
+	if (!cts_val) {
+		dev_dbg(MAIN_DEV, "Missed interrupt, going back to "\
+			"awake state\n");
+		free_irq(uart_info->cts_irq, uart_info->dev);
+		return -ECANCELED;
+	}
+
+#ifdef CONFIG_PM
+	enable_irq_wake(uart_info->cts_irq);
+#endif
+	return 0;
+}
+
+/**
+ * disable_uart_pins() - Disable the UART pins.
+ * @uart_info: Main Uart structure.
+ */
+static void disable_uart_pins(struct uart_info *uart_info)
+{
+	struct cg2900_platform_data *pf_data;
+
+	pf_data = dev_get_platdata(uart_info->dev);
+
+	if (pf_data->uart.disable_uart) {
+		int err = pf_data->uart.disable_uart(&uart_info->chip_dev);
+		if (err)
+			dev_err(MAIN_DEV,
+				"Unable to disable UART Hardware (%d)\n", err);
+	}
+}
+
+/**
+ * enable_uart_pins() - Enable the UART pins.
+ * @uart_info: Main Uart structure.
+ */
+static void enable_uart_pins(struct uart_info *uart_info)
+{
+	struct cg2900_platform_data *pf_data;
+
+	pf_data = dev_get_platdata(uart_info->dev);
+
+	if (pf_data->uart.enable_uart) {
+		int err = pf_data->uart.enable_uart(&uart_info->chip_dev);
+		if (err)
+			dev_err(MAIN_DEV,
+				"Unable to enable UART Hardware (%d)\n", err);
+	}
+}
+
+/**
+ * unset_cts_irq() - Disable interrupt on CTS.
+ * @uart_info: Main Uart structure.
+ */
+static void unset_cts_irq(struct uart_info *uart_info)
+{
+	/* Free CTS interrupt */
+	free_irq(uart_info->cts_irq, uart_info->dev);
+}
+
+/**
+ * get_sleep_timeout() - Get sleep timeout.
+ * @uart_info: Main Uart structure.
+ *
+ * Check all conditions for sleep and return sleep timeout.
+ * Return:
+ *	0: sleep not allowed.
+ *	other: Timeout value in jiffies.
+ */
+static unsigned long get_sleep_timeout(struct uart_info *uart_info)
+{
+	unsigned long timeout_jiffies = 0;
+	bool check_sleep = false;
+	if (uart_info->sleep_state == CHIP_FALLING_ASLEEP)
+		check_sleep = true;
+
+	timeout_jiffies = cg2900_get_sleep_timeout(check_sleep);
+
+	if (timeout_jiffies &&
+		uart_info->hu &&
+		uart_info->hu->fd &&
+		test_bit(SLEEP_TTY_READY, &uart_info->sleep_flags) &&
+		test_bit(SLEEP_CORE_READY, &uart_info->sleep_flags))
+		return timeout_jiffies;
+
+	return 0;
+}
+
+/**
+ * work_wake_up_chip() - Called to wake up of the transport in work context.
+ * @work:	work which needs to be done.
+ */
+static void work_wake_up_chip(struct work_struct *work)
+{
+	struct uart_work_struct *current_work =
+		container_of(work, struct uart_work_struct, work);
+	struct uart_info *uart_info = (struct uart_info *)current_work->data;
+
+	wake_up_chip(uart_info);
+}
+
+/**
+ * wake_up_chip() - Wakes up the chip and transport.
+ * @work:	pointer to a work struct if the function was called that way.
+ *
+ * Depending on the current sleep state it may wake up the transport.
+ */
+static void wake_up_chip(struct uart_info *uart_info)
+{
+	unsigned long timeout_jiffies = get_sleep_timeout(uart_info);
+
+	/* Resuming state is special. Need to get back chip to awake state. */
+	if (!timeout_jiffies && uart_info->sleep_state != CHIP_RESUMING)
+		return;
+
+	if (!uart_info->hu) {
+		dev_err(MAIN_DEV, "wake_up_chip: UART not open\n");
+		return;
+	}
+
+	mutex_lock(&(uart_info->sleep_state_lock));
+
+	/*
+	 * If chip is powered down we cannot wake it up here. It has to be woken
+	 * up through a call to uart_set_chip_power()
+	 */
+	if (CHIP_POWERED_DOWN == uart_info->sleep_state)
+		goto finished;
+
+	if (!uart_info->suspend_blocked) {
+		__pm_stay_awake(&uart_info->wakeup_lock);
+		uart_info->suspend_blocked = true;
+		pm_qos_update_request(&uart_info->pm_qos_latency,
+				      CG2900_PM_QOS_LATENCY);
+	}
+
+	/*
+	 * This function indicates data is transmitted.
+	 * Therefore see to that the chip is awake.
+	 */
+	if (CHIP_AWAKE == uart_info->sleep_state)
+		goto finished;
+
+	if (CHIP_ASLEEP == uart_info->sleep_state ||
+		CHIP_RESUMING == uart_info->sleep_state) {
+		/* Wait before disabling IRQ */
+		schedule_timeout_killable(
+				msecs_to_jiffies(UART_RESUME_TIMEOUT));
+
+		/* Disable IRQ only when it was enabled. */
+		unset_cts_irq(uart_info);
+		(void)hci_uart_set_baudrate(uart_info->hu,
+					    uart_info->baud_rate);
+
+		enable_uart_pins(uart_info);
+
+		/*
+		 * Wait before flowing on. Otherwise UART might not be ready in
+		 * time
+		 */
+		schedule_timeout_killable(
+				msecs_to_jiffies(UART_RESUME_TIMEOUT));
+
+		/* Set FLOW on. */
+		hci_uart_flow_ctrl(uart_info->hu, FLOW_ON);
+
+		/*
+		 * Add work so we will go to sleep, this will ensure
+		 * if some spurious CTS interrupt comes from UART
+		 * on wake up line, we go back to sleep.
+		 */
+		if (uart_info->rx_in_progress)
+			(void)queue_work(uart_info->wq,
+				&uart_info->restart_sleep_work.work);
+	}
+
+	/* Unset BREAK. */
+	dev_dbg(MAIN_DEV, "wake_up_chip: Clear break\n");
+	hci_uart_set_break(uart_info->hu, BREAK_OFF);
+	udelay(UART_MIN_BREAK_OFF_TIME);
+
+	dev_dbg(MAIN_DEV, "New sleep_state: CHIP_AWAKE\n");
+	uart_info->sleep_state = CHIP_AWAKE;
+
+finished:
+	mutex_unlock(&(uart_info->sleep_state_lock));
+}
+
+/**
+ * set_chip_sleep_mode() - Put the chip and transport to sleep mode.
+ * @work:	pointer to work_struct.
+ *
+ * The set_chip_sleep_mode() function is called if there are no ongoing data
+ * transmissions. It tries to put the chip in sleep mode.
+ *
+ */
+static void set_chip_sleep_mode(struct work_struct *work)
+{
+	int err = 0;
+	struct delayed_work *delayed_work =
+			container_of(work, struct delayed_work, work);
+	struct uart_delayed_work_struct *current_work =	container_of(
+			delayed_work, struct uart_delayed_work_struct, work);
+	struct uart_info *uart_info = (struct uart_info *)current_work->data;
+	unsigned long timeout_jiffies = get_sleep_timeout(uart_info);
+	int chars_in_buffer;
+
+	if (!timeout_jiffies)
+		return;
+
+	if (!uart_info->hu) {
+		dev_err(MAIN_DEV, "set_chip_sleep_mode: UART not open\n");
+		return;
+	}
+
+	if (uart_info->tx_in_progress || uart_info->rx_in_progress) {
+		dev_dbg(MAIN_DEV, "Not going to sleep, TX/RX in progress\n");
+		return;
+	}
+
+	mutex_lock(&(uart_info->sleep_state_lock));
+
+	switch (uart_info->sleep_state) {
+	case CHIP_FALLING_ASLEEP:
+		if (!is_chip_flow_off(uart_info)) {
+			dev_dbg(MAIN_DEV, "Chip flow is on, it's not ready to"\
+				"sleep yet\n");
+			hci_uart_set_break(uart_info->hu, BREAK_OFF);
+			udelay(UART_MIN_BREAK_OFF_TIME);
+
+			dev_dbg(MAIN_DEV, "New sleep_state: CHIP_AWAKE\n");
+			uart_info->sleep_state = CHIP_AWAKE;
+			goto schedule_sleep_work;
+		}
+
+		/* Flow OFF. */
+		hci_uart_flow_ctrl(uart_info->hu, FLOW_OFF);
+
+		disable_uart_pins(uart_info);
+
+		/*
+		 * Set baud zero.
+		 * This cause shut off UART clock as well.
+		 */
+		(void)hci_uart_set_baudrate(uart_info->hu, ZERO_BAUD_RATE);
+		err = set_cts_irq(uart_info);
+		if (err < 0) {
+			enable_uart_pins(uart_info);
+			(void)hci_uart_set_baudrate(uart_info->hu,
+						uart_info->baud_rate);
+			hci_uart_flow_ctrl(uart_info->hu, FLOW_ON);
+			hci_uart_set_break(uart_info->hu, BREAK_OFF);
+			udelay(UART_MIN_BREAK_OFF_TIME);
+
+			dev_dbg(MAIN_DEV, "New sleep_state: CHIP_AWAKE\n");
+			uart_info->sleep_state = CHIP_AWAKE;
+
+			if (err == -ECANCELED)
+				goto finished;
+			else {
+				dev_err(MAIN_DEV, "Can not set interrupt on "\
+						"CTS, err:%d\n", err);
+				goto error;
+			}
+		}
+
+		dev_dbg(MAIN_DEV, "New sleep_state: CHIP_ASLEEP\n");
+		uart_info->sleep_state = CHIP_ASLEEP;
+		if (uart_info->suspend_blocked) {
+			__pm_relax(&uart_info->wakeup_lock);
+			uart_info->suspend_blocked = false;
+			pm_qos_update_request(&uart_info->pm_qos_latency,
+					      PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE);
+		}
+		break;
+	case CHIP_AWAKE:
+		chars_in_buffer = hci_uart_chars_in_buffer(uart_info->hu);
+		if (chars_in_buffer) {
+			dev_dbg(MAIN_DEV, "sleep_timer_expired: "\
+					"tx not finished, stay awake and "\
+					"restart the sleep timer\n");
+			goto schedule_sleep_work;
+		}
+
+		dev_dbg(MAIN_DEV, "sleep_timer_expired: Set break\n");
+		udelay(UART_MIN_TIME_BEFORE_APPLYING_BREAK);
+		hci_uart_set_break(uart_info->hu, BREAK_ON);
+		schedule_timeout_killable(
+				msecs_to_jiffies(UART_MIN_BREAK_ON_TIME));
+
+		dev_dbg(MAIN_DEV, "New sleep_state: CHIP_FALLING_ASLEEP\n");
+		uart_info->sleep_state = CHIP_FALLING_ASLEEP;
+		goto schedule_sleep_work;
+
+	case CHIP_POWERED_DOWN:
+	case CHIP_SUSPENDED:
+	case CHIP_ASLEEP: /* Fallthrough. */
+	default:
+		dev_dbg(MAIN_DEV,
+			"Chip sleeps, is suspended or powered down\n");
+		break;
+	}
+
+	mutex_unlock(&(uart_info->sleep_state_lock));
+
+	return;
+
+finished:
+	mutex_unlock(&(uart_info->sleep_state_lock));
+	return;
+schedule_sleep_work:
+	mutex_unlock(&(uart_info->sleep_state_lock));
+	if (timeout_jiffies)
+		queue_delayed_work(uart_info->wq, &uart_info->sleep_work.work,
+				timeout_jiffies);
+	return;
+error:
+	/* Disable sleep mode.*/
+	dev_err(MAIN_DEV, "Disable sleep mode\n");
+	clear_bit(SLEEP_CORE_READY, &uart_info->sleep_flags);
+	mutex_unlock(&(uart_info->sleep_state_lock));
+}
+
+#ifdef CONFIG_PM
+/**
+ * cg2900_uart_suspend() - Called by Linux PM to put the device in a low power mode.
+ * @pdev:	Pointer to platform device.
+ * @state:	New state.
+ *
+ * In UART case, CG2900 driver does nothing on suspend.
+ *
+ * Returns:
+ *   0 - Success.
+ */
+static int cg2900_uart_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	int err = 0;
+	struct uart_info *uart_info = dev_get_drvdata(&pdev->dev);
+
+	mutex_lock(&(uart_info->sleep_state_lock));
+
+	if (uart_info->sleep_state == CHIP_POWERED_DOWN)
+		goto finished;
+
+	if (uart_info->sleep_state != CHIP_ASLEEP) {
+		err = -EBUSY;
+		goto finished;
+	}
+
+	dev_dbg(MAIN_DEV, "New sleep_state: CHIP_SUSPENDED\n");
+	uart_info->sleep_state = CHIP_SUSPENDED;
+
+finished:
+	mutex_unlock(&(uart_info->sleep_state_lock));
+	return err;
+}
+
+/**
+ * cg2900_uart_resume() - Called to bring a device back from a low power state.
+ * @pdev:	Pointer to platform device.
+ *
+ * In UART case, CG2900 driver does nothing on resume.
+ *
+ * Returns:
+ *   0 - Success.
+ */
+static int cg2900_uart_resume(struct platform_device *pdev)
+{
+	struct uart_info *uart_info = dev_get_drvdata(&pdev->dev);
+
+	mutex_lock(&(uart_info->sleep_state_lock));
+
+	if (uart_info->sleep_state == CHIP_RESUMING)
+		/* System resume because of trafic on UART. Lets wakeup.*/
+		(void)queue_work(uart_info->wq, &uart_info->wakeup_work.work);
+	else if (uart_info->sleep_state != CHIP_POWERED_DOWN) {
+		/* No need to wakeup chip. Go back to Asleep state.*/
+		dev_dbg(MAIN_DEV, "New sleep_state: CHIP_ASLEEP\n");
+		uart_info->sleep_state = CHIP_ASLEEP;
+	}
+
+	mutex_unlock(&(uart_info->sleep_state_lock));
+	return 0;
+}
+#endif /* CONFIG_PM */
+
+/**
+ * cg2900_enable_regulator() - Enable regulator.
+ * @uart_info: Main Uart structure.
+ *
+ * Returns:
+ *   0 - Success.
+ *   Error from regulator_get, regulator_enable.
+ */
+static int cg2900_enable_regulator(struct uart_info *uart_info)
+{
+#ifdef CONFIG_REGULATOR
+	int err;
+
+	/* Get and enable regulator. */
+	uart_info->regulator = regulator_get(uart_info->dev, "gbf_1v8");
+	if (IS_ERR(uart_info->regulator)) {
+		dev_err(MAIN_DEV, "Not able to find regulator\n");
+		err = PTR_ERR(uart_info->regulator);
+	} else {
+		err = regulator_enable(uart_info->regulator);
+		if (err)
+			dev_err(MAIN_DEV, "Not able to enable regulator\n");
+		else
+			uart_info->regulator_enabled = true;
+	}
+	return err;
+#else
+	return 0;
+#endif
+}
+
+/**
+ * cg2900_disable_regulator() - Disable regulator.
+ * @uart_info: Main Uart structure.
+ *
+ */
+static void cg2900_disable_regulator(struct uart_info *uart_info)
+{
+#ifdef CONFIG_REGULATOR
+	/* Disable and put regulator. */
+	if (uart_info->regulator && uart_info->regulator_enabled) {
+		regulator_disable(uart_info->regulator);
+		uart_info->regulator_enabled = false;
+	}
+	regulator_put(uart_info->regulator);
+	uart_info->regulator = NULL;
+#endif
+}
+
+/**
+ * is_set_baud_rate_cmd() - Checks if data contains set baud rate hci cmd.
+ * @data:	Pointer to data array to check.
+ *
+ * Returns:
+ *   true - if cmd found;
+ *   false - otherwise.
+ */
+static bool is_set_baud_rate_cmd(const char *data)
+{
+	struct hci_command_hdr *cmd;
+
+	cmd = (struct hci_command_hdr *)&data[1];
+	if (le16_to_cpu(cmd->opcode) == CG2900_BT_OP_VS_SET_BAUD_RATE &&
+	    cmd->plen == BT_PARAM_LEN(sizeof(struct bt_vs_set_baud_rate_cmd)))
+		return true;
+
+	return false;
+}
+
+/**
+ * is_bt_cmd_complete_no_param() - Checks if data contains command complete event for a certain command.
+ * @skb:	sk_buffer containing the data including H:4 header.
+ * @opcode:	Command op code.
+ * @status:	Command status.
+ *
+ * Returns:
+ *   true - If this is the command complete we were looking for;
+ *   false - otherwise.
+ */
+static bool is_bt_cmd_complete_no_param(struct sk_buff *skb, u16 opcode,
+					u8 *status, u8 h4_channel)
+{
+	struct hci_event_hdr *event;
+	struct hci_ev_cmd_complete *complete;
+	u8 *data = &(skb->data[0]);
+
+	if (h4_channel != *data)
+		return false;
+
+	data += HCI_H4_SIZE;
+	event = (struct hci_event_hdr *)data;
+	if (HCI_EV_CMD_COMPLETE != event->evt ||
+	    HCI_BT_CMD_COMPLETE_LEN != event->plen)
+		return false;
+
+	data += sizeof(*event);
+	complete = (struct hci_ev_cmd_complete *)data;
+	if (opcode != le16_to_cpu(complete->opcode))
+		return false;
+
+	if (status) {
+		/*
+		 * All command complete have the status field at first byte of
+		 * packet data.
+		 */
+		data += sizeof(*complete);
+		*status = *data;
+	}
+	return true;
+}
+
+/**
+ * alloc_rx_skb() - Alloc an sk_buff structure for receiving data from controller.
+ * @size:	Size in number of octets.
+ * @priority:	Allocation priority, e.g. GFP_KERNEL.
+ *
+ * Returns:
+ *   Pointer to sk_buff structure.
+ */
+static struct sk_buff *alloc_rx_skb(unsigned int size, gfp_t priority)
+{
+	struct sk_buff *skb;
+
+	/* Allocate the SKB and reserve space for the header */
+	skb = alloc_skb(size + RX_SKB_RESERVE, priority);
+	if (skb)
+		skb_reserve(skb, RX_SKB_RESERVE);
+
+	return skb;
+}
+
+/**
+ * finish_setting_baud_rate() - Handles sending the ste baud rate hci cmd.
+ * @hu:	Pointer to associated Hci uart structure.
+ *
+ * finish_setting_baud_rate() makes sure that the set baud rate cmd has
+ * been really sent out on the wire and then switches the tty driver to new
+ * baud rate.
+ */
+static void finish_setting_baud_rate(struct hci_uart *hu)
+{
+	struct uart_info *uart_info =
+			(struct uart_info *)dev_get_drvdata(hu->proto->dev);
+	/*
+	 * Give the tty driver time to send data and proceed. If it hasn't
+	 * been sent we can't do much about it anyway.
+	 */
+	schedule_timeout_killable(msecs_to_jiffies(UART_TX_TIMEOUT));
+
+	/*
+	 * Now set the termios struct to the new baudrate. Start by storing
+	 * the old termios.
+	 */
+	if (hci_uart_set_baudrate(hu, uart_info->baud_rate) < 0) {
+		/* Something went wrong.*/
+		dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_IDLE\n");
+		uart_info->baud_rate_state = BAUD_IDLE;
+	} else {
+		dev_dbg(MAIN_DEV, "Setting termios to new baud rate\n");
+		dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_WAITING\n");
+		uart_info->baud_rate_state = BAUD_WAITING;
+	}
+
+	hci_uart_flow_ctrl(hu, FLOW_ON);
+}
+
+/**
+ * alloc_set_baud_rate_cmd() - Allocates new sk_buff and fills in the change baud rate hci cmd.
+ * @uart_info:	Main Uart structure.
+ * @baud:	(in/out) Requested new baud rate. Updated to default baud rate
+ *		upon invalid value.
+ *
+ * Returns:
+ *   Pointer to allocated sk_buff if successful;
+ *   NULL otherwise.
+ */
+static struct sk_buff *alloc_set_baud_rate_cmd(struct uart_info *uart_info,
+							int *baud)
+{
+	struct sk_buff *skb;
+	u8 *h4;
+	struct bt_vs_set_baud_rate_cmd *cmd;
+
+	skb = alloc_skb(sizeof(*cmd) + CG2900_SKB_RESERVE, GFP_ATOMIC);
+	if (!skb) {
+		dev_err(MAIN_DEV,
+			"alloc_set_baud_rate_cmd: Failed to alloc skb\n");
+		return NULL;
+	}
+	skb_reserve(skb, CG2900_SKB_RESERVE);
+
+	cmd = (struct bt_vs_set_baud_rate_cmd *)skb_put(skb, sizeof(cmd));
+
+	/* Create the Hci_Cmd_ST_Set_Uart_Baud_Rate packet */
+	cmd->opcode = cpu_to_le16(CG2900_BT_OP_VS_SET_BAUD_RATE);
+	cmd->plen = BT_PARAM_LEN(sizeof(cmd));
+
+	switch (*baud) {
+	case 57600:
+		cmd->baud_rate = CG2900_BAUD_RATE_57600;
+		break;
+	case 115200:
+		cmd->baud_rate = CG2900_BAUD_RATE_115200;
+		break;
+	case 230400:
+		cmd->baud_rate = CG2900_BAUD_RATE_230400;
+		break;
+	case 460800:
+		cmd->baud_rate = CG2900_BAUD_RATE_460800;
+		break;
+	case 921600:
+		cmd->baud_rate = CG2900_BAUD_RATE_921600;
+		break;
+	case 2000000:
+		cmd->baud_rate = CG2900_BAUD_RATE_2000000;
+		break;
+	case 3000000:
+		cmd->baud_rate = CG2900_BAUD_RATE_3000000;
+		break;
+	case 3250000:
+		cmd->baud_rate = CG2900_BAUD_RATE_3250000;
+		break;
+	case 4000000:
+		cmd->baud_rate = CG2900_BAUD_RATE_4000000;
+		break;
+	case 4050000:
+		cmd->baud_rate = CG2900_BAUD_RATE_4050000;
+		break;
+	case 4800000:
+		cmd->baud_rate = CG2900_BAUD_RATE_4800000;
+		break;
+	default:
+		dev_err(MAIN_DEV,
+			"Invalid speed requested (%d), using 115200 bps "
+			"instead\n", *baud);
+		cmd->baud_rate = CG2900_BAUD_RATE_115200;
+		*baud = 115200;
+		break;
+	};
+
+	h4 = skb_push(skb, HCI_H4_SIZE);
+	if (use_device_channel_for_vs_cmd(
+			uart_info->chip_dev.chip.hci_revision)) {
+		*h4 = HCI_DEV_MGMT_H4_CHANNEL;
+	} else {
+		*h4 = HCI_BT_CMD_H4_CHANNEL;
+	}
+
+	return skb;
+}
+
+/**
+ * work_do_transmit() - Transmit data packet to connectivity controller over UART.
+ * @work:	Pointer to work info structure. Contains uart_info structure
+ *		pointer.
+ */
+static void work_do_transmit(struct work_struct *work)
+{
+	struct uart_work_struct *current_work =
+			container_of(work, struct uart_work_struct, work);
+	struct uart_info *uart_info = (struct uart_info *)current_work->data;
+
+	kfree(current_work);
+
+	if (!uart_info->hu) {
+		dev_err(MAIN_DEV, "work_do_transmit: UART not open\n");
+		return;
+	}
+
+	spin_lock_bh(&(uart_info->transmission_lock));
+	/* Mark that there is an ongoing transfer. */
+	uart_info->tx_in_progress = true;
+	spin_unlock_bh(&(uart_info->transmission_lock));
+
+	/* Cancel pending sleep work if there is any. */
+	cancel_delayed_work_sync(&uart_info->sleep_work.work);
+
+	/* Wake up the chip and transport. */
+	wake_up_chip(uart_info);
+
+	(void)hci_uart_tx_wakeup(uart_info->hu);
+}
+
+/**
+ * work_hw_deregistered() - Handle HW deregistered.
+ * @work: Reference to work data.
+ */
+static void work_hw_deregistered(struct work_struct *work)
+{
+	struct uart_work_struct *current_work;
+	struct uart_info *uart_info;
+	int err;
+	current_work = container_of(work, struct uart_work_struct, work);
+	uart_info = (struct uart_info *)current_work->data;
+
+	err = cg2900_deregister_trans_driver(&uart_info->chip_dev);
+	if (err)
+		dev_err(MAIN_DEV, "Could not deregister UART from Core (%d)\n",
+			err);
+
+	kfree(current_work);
+}
+
+/**
+ * set_baud_rate() - Sets new baud rate for the UART.
+ * @hu:		Pointer to hci_uart structure.
+ * @baud:	New baud rate.
+ *
+ * This function first sends the HCI command
+ * Hci_Cmd_ST_Set_Uart_Baud_Rate. It then changes the baud rate in HW, and
+ * finally it waits for the Command Complete event for the
+ * Hci_Cmd_ST_Set_Uart_Baud_Rate command.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EALREADY if baud rate change is already in progress.
+ *   -EFAULT if one or more of the UART related structs is not allocated.
+ *   -ENOMEM if skb allocation has failed.
+ *   -EPERM if setting the new baud rate has failed.
+ *   Errors from create_work_item.
+ */
+static int set_baud_rate(struct hci_uart *hu, int baud)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	int old_baud_rate;
+	struct uart_info *uart_info =
+			(struct uart_info *)dev_get_drvdata(hu->proto->dev);
+
+	dev_dbg(MAIN_DEV, "set_baud_rate (%d baud)\n", baud);
+
+	if (uart_info->baud_rate_state != BAUD_IDLE) {
+		dev_err(MAIN_DEV,
+			"Trying to set new baud rate before old setting "
+			   "is finished\n");
+		return -EALREADY;
+	}
+
+	if (!uart_info->hu) {
+		dev_err(MAIN_DEV, "set_baud_rate: UART not open\n");
+		return -EFAULT;
+	}
+
+	/*
+	 * Wait some time to be sure that any RX process has finished (which
+	 * flows on RTS in the end) before flowing off the RTS.
+	 */
+	schedule_timeout_killable(msecs_to_jiffies(UART_RX_TIMEOUT));
+	hci_uart_flow_ctrl(uart_info->hu, FLOW_OFF);
+
+	/*
+	 * Store old baud rate so that we can restore it if something goes
+	 * wrong.
+	 */
+	old_baud_rate = uart_info->baud_rate;
+
+	skb = alloc_set_baud_rate_cmd(uart_info, &baud);
+	if (!skb) {
+		dev_err(MAIN_DEV, "alloc_set_baud_rate_cmd failed\n");
+		return -ENOMEM;
+	}
+
+	dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_START\n");
+	uart_info->baud_rate_state = BAUD_START;
+	uart_info->baud_rate = baud;
+
+	/* Queue the sk_buffer... */
+	skb_queue_tail(&uart_info->tx_queue, skb);
+
+	/* ... and call the common UART TX function */
+	err = create_work_item(uart_info, work_do_transmit);
+	if (err) {
+		dev_err(MAIN_DEV,
+			"Failed to send change baud rate cmd, freeing skb\n");
+		skb = skb_dequeue_tail(&uart_info->tx_queue);
+		dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_IDLE\n");
+		uart_info->baud_rate_state = BAUD_IDLE;
+		uart_info->baud_rate = old_baud_rate;
+		kfree_skb(skb);
+		return err;
+	}
+
+	dev_dbg(MAIN_DEV, "Set baud rate cmd scheduled for sending\n");
+
+	/*
+	 * Now wait for the command complete.
+	 * It will come at the new baudrate.
+	 */
+	wait_event_timeout(uart_wait_queue,
+				((BAUD_SUCCESS == uart_info->baud_rate_state) ||
+				 (BAUD_FAIL    == uart_info->baud_rate_state)),
+				 msecs_to_jiffies(UART_RESP_TIMEOUT));
+	if (BAUD_SUCCESS == uart_info->baud_rate_state)
+		dev_info(MAIN_DEV, "Baud rate changed to %d baud\n", baud);
+	else {
+		dev_err(MAIN_DEV, "Failed to set new baud rate (%d)\n",
+			   uart_info->baud_rate_state);
+		err = -EPERM;
+	}
+
+	/* Finally flush the TTY so we are sure that is no bad data there */
+	hci_uart_flush_buffer(hu);
+	dev_dbg(MAIN_DEV, "Flushing TTY after baud rate change\n");
+	/* Finished. Set state to IDLE */
+	dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_IDLE\n");
+	uart_info->baud_rate_state = BAUD_IDLE;
+
+	return err;
+}
+
+/**
+ * uart_set_baud_rate() - External Interface for setting baud rate
+ * @dev:		Transport device information.
+ * @low_baud:	whether switch to low_baud or high.
+ *
+ * Returns:
+ *   none
+ */
+static void uart_set_baud_rate(struct cg2900_chip_dev *dev, bool low_baud)
+{
+	struct uart_info *uart_info = dev_get_drvdata(dev->dev);
+
+	if (!uart_info->hu) {
+		dev_err(MAIN_DEV, "uart_set_baud_rate: UART not open\n");
+		return;
+	}
+
+	if (low_baud) {
+		if (uart_info->baud_rate != uart_default_baud) {
+			dev_dbg(MAIN_DEV, "Changing BAUD now to : %d",
+					uart_default_baud);
+			set_baud_rate(uart_info->hu, uart_default_baud);
+		} else {
+			dev_dbg(MAIN_DEV, "BAUD is already set to :%d",
+					uart_default_baud);
+		}
+	} else {
+		if (uart_info->baud_rate != uart_high_baud) {
+			dev_dbg(MAIN_DEV, "Changing BAUD now to : %d",
+					uart_high_baud);
+			set_baud_rate(uart_info->hu, uart_high_baud);
+		} else {
+			dev_dbg(MAIN_DEV, "BAUD is already set to :%d",
+					uart_high_baud);
+		}
+	}
+}
+
+/**
+ * uart_write() - Transmit data to CG2900 over UART.
+ * @dev:	Transport device information.
+ * @skb:	SK buffer to transmit.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Errors from create_work_item.
+ */
+static int uart_write(struct cg2900_chip_dev *dev, struct sk_buff *skb)
+{
+	int err;
+	struct uart_info *uart_info = dev_get_drvdata(dev->dev);
+
+	if (uart_debug)
+		dev_dbg(MAIN_DEV, "uart_write: data len = %d\n", skb->len);
+
+	/* Queue the sk_buffer... */
+	skb_queue_tail(&uart_info->tx_queue, skb);
+
+	/* ...and start TX operation */
+
+	err = create_work_item(uart_info, work_do_transmit);
+	if (err)
+		dev_err(MAIN_DEV,
+			"Failed to create work item (%d) uart_tty_wakeup\n",
+			err);
+
+	return err;
+}
+
+/**
+ * uart_open() - Open the CG2900 UART for data transfers.
+ * @dev:	Transport device information.
+ *
+ * Returns:
+ *   0 if there is no error,
+ *   -EACCES if write to transport failed,
+ *   -EIO if chip did not answer to commands.
+ *   Errors from set_baud_rate.
+ */
+static int uart_open(struct cg2900_chip_dev *dev)
+{
+	u8 *h4;
+	struct sk_buff *skb;
+	struct hci_command_hdr *cmd;
+	struct uart_info *uart_info = dev_get_drvdata(dev->dev);
+
+	if (!uart_info->hu) {
+		dev_err(MAIN_DEV, "uart_open: UART not open\n");
+		return -EACCES;
+	}
+
+	uart_info->baud_rate = uart_default_baud;
+	/*
+	 * Chip has just been started up. It has a system to autodetect
+	 * exact baud rate and transport to use. There are only a few commands
+	 * it will recognize and HCI Reset is one of them.
+	 * We therefore start with sending that before actually changing
+	 * baud rate.
+	 *
+	 * Create the Hci_Reset packet
+	 */
+
+	skb = alloc_skb(sizeof(*cmd) + HCI_H4_SIZE, GFP_ATOMIC);
+	if (!skb) {
+		dev_err(MAIN_DEV, "Couldn't allocate sk_buff with length %zu\n",
+			     sizeof(*cmd));
+		return -EACCES;
+	}
+	skb_reserve(skb, HCI_H4_SIZE);
+	cmd = (struct hci_command_hdr *)skb_put(skb, sizeof(*cmd));
+	cmd->opcode = cpu_to_le16(HCI_OP_RESET);
+	cmd->plen = 0; /* No parameters for HCI reset */
+
+	h4 = skb_push(skb, HCI_H4_SIZE);
+	*h4 = HCI_BT_CMD_H4_CHANNEL;
+
+	dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_SENDING_RESET\n");
+	uart_info->baud_rate_state = BAUD_SENDING_RESET;
+	dev_dbg(MAIN_DEV, "Sending HCI reset before baud rate change\n");
+
+
+	/* Queue the sk_buffer... */
+	skb_queue_tail(&uart_info->tx_queue, skb);
+
+	(void)hci_uart_tx_wakeup(uart_info->hu);
+
+	/*
+	 * Wait for command complete. If error, exit without changing
+	 * baud rate.
+	 */
+	wait_event_timeout(uart_wait_queue,
+					BAUD_IDLE == uart_info->baud_rate_state,
+					msecs_to_jiffies(UART_RESP_TIMEOUT));
+	if (BAUD_IDLE != uart_info->baud_rate_state) {
+		dev_err(MAIN_DEV, "Failed to send HCI Reset\n");
+		dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_IDLE\n");
+		uart_info->baud_rate_state = BAUD_IDLE;
+		return -EIO;
+	}
+
+	/* Just return if there will be no change of baud rate */
+	if (uart_default_baud != uart_high_baud) {
+
+		/*
+		 * Don't change to high baud yet
+		 * as there is bug CG2905/10 PG1 that firmware d/l
+		 * has to take place at lower baud
+		 * after firmware d/l UART will be switched
+		 * to higher baud.
+		 */
+		if (CG2905_PG1_05_REV != dev->chip.hci_revision &&
+				CG2910_PG1_REV != dev->chip.hci_revision)
+			return set_baud_rate(uart_info->hu, uart_high_baud);
+	}
+
+	return 0;
+}
+
+/**
+ * uart_set_chip_power() - Enable or disable the CG2900.
+ * @chip_on:	true if chip shall be enabled, false otherwise.
+ */
+static void uart_set_chip_power(struct cg2900_chip_dev *dev, bool chip_on)
+{
+	int uart_baudrate = uart_default_baud;
+	struct cg2900_platform_data *pf_data;
+	struct uart_info *uart_info;
+
+	pf_data = dev_get_platdata(dev->dev);
+	uart_info = dev_get_drvdata(dev->dev);
+
+	dev_info(MAIN_DEV, "Set chip power: %s\n",
+		    (chip_on ? "ENABLE" : "DISABLE"));
+
+	/* Cancel any ongoing works.*/
+	cancel_work_sync(&uart_info->wakeup_work.work);
+	cancel_delayed_work_sync(&uart_info->sleep_work.work);
+
+	mutex_lock(&uart_info->sleep_state_lock);
+
+	if (!uart_info->hu) {
+		dev_err(MAIN_DEV, "Hci uart struct is not allocated\n");
+		goto unlock;
+	}
+
+	if (chip_on) {
+		if (!uart_info->suspend_blocked) {
+			__pm_stay_awake(&uart_info->wakeup_lock);
+			uart_info->suspend_blocked = true;
+			pm_qos_update_request(&uart_info->pm_qos_latency,
+					      CG2900_PM_QOS_LATENCY);
+		}
+		if (uart_info->sleep_state != CHIP_POWERED_DOWN) {
+			dev_err(MAIN_DEV, "Chip is already powered up (%d)\n",
+				uart_info->sleep_state);
+			goto unlock;
+		}
+
+		if (cg2900_enable_regulator(uart_info))
+			goto unlock;
+
+		if (pf_data->enable_chip) {
+			pf_data->enable_chip(dev);
+			dev_dbg(MAIN_DEV, "New sleep_state: CHIP_AWAKE\n");
+			uart_info->sleep_state = CHIP_AWAKE;
+		}
+
+		(void)hci_uart_set_baudrate(uart_info->hu, uart_baudrate);
+
+		hci_uart_flow_ctrl(uart_info->hu, FLOW_ON);
+		hci_uart_set_break(uart_info->hu, BREAK_OFF);
+		udelay(UART_MIN_BREAK_OFF_TIME);
+	} else {
+		/* Turn off the chip.*/
+		switch (uart_info->sleep_state) {
+		case CHIP_AWAKE:
+			break;
+		case CHIP_FALLING_ASLEEP:
+			hci_uart_set_break(uart_info->hu, BREAK_OFF);
+			udelay(UART_MIN_BREAK_OFF_TIME);
+			break;
+		case CHIP_SUSPENDED:
+		case CHIP_ASLEEP:
+			unset_cts_irq(uart_info);
+			enable_uart_pins(uart_info);
+			break;
+		case CHIP_POWERED_DOWN:
+			dev_err(MAIN_DEV, "Chip is already powered down (%d)\n",
+					uart_info->sleep_state);
+			goto unlock;
+		default:
+			break;
+		}
+
+		if (uart_info->suspend_blocked) {
+			__pm_relax(&uart_info->wakeup_lock);
+			uart_info->suspend_blocked = false;
+			pm_qos_update_request(&uart_info->pm_qos_latency,
+					      PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE);
+		}
+
+		if (pf_data->disable_chip) {
+			pf_data->disable_chip(dev);
+			dev_dbg(MAIN_DEV,
+				"New sleep_state: CHIP_POWERED_DOWN\n");
+			uart_info->sleep_state = CHIP_POWERED_DOWN;
+			/*
+			 * This is to ensure when chip is switched
+			 * on next time sleep_flags is again set with
+			 * SLEEP_CORE_READY when startup is done properly
+			 */
+			clear_bit(SLEEP_CORE_READY, &uart_info->sleep_flags);
+		}
+
+		cg2900_disable_regulator(uart_info);
+		/*
+		 * Setting baud rate to 0 will tell UART driver to shut off its
+		 * clocks.
+		 */
+		(void)hci_uart_set_baudrate(uart_info->hu, ZERO_BAUD_RATE);
+
+		spin_lock_bh(&uart_info->rx_skb_lock);
+		if (uart_info->rx_skb) {
+			/*
+			 * Reset the uart_info state so that
+			 * next packet can be handled
+			 * correctly by driver.
+			 */
+			dev_dbg(MAIN_DEV, "Power off in middle of receiving"\
+					" data? Reseting state machine.\n");
+			kfree_skb(uart_info->rx_skb);
+			uart_info->rx_skb = NULL;
+			uart_info->rx_state = W4_PACKET_TYPE;
+			uart_info->rx_count = 0;
+		}
+		spin_unlock_bh(&uart_info->rx_skb_lock);
+	}
+
+unlock:
+	mutex_unlock(&(uart_info->sleep_state_lock));
+}
+
+/**
+ * uart_chip_startup_finished() - CG2900 startup finished.
+ * @dev:	Transport device information.
+ */
+static void uart_chip_startup_finished(struct cg2900_chip_dev *dev)
+{
+	struct uart_info *uart_info = dev_get_drvdata(dev->dev);
+	unsigned long timeout_jiffies = get_sleep_timeout(uart_info);
+
+	/*
+	 * Chip startup is done, now chip is allowed
+	 * to go to sleep
+	 */
+	set_bit(SLEEP_CORE_READY, &uart_info->sleep_flags);
+	/* Schedule work to put the chip and transport to sleep. */
+	if (timeout_jiffies)
+		queue_delayed_work(uart_info->wq, &uart_info->sleep_work.work,
+				timeout_jiffies);
+}
+/**
+ * uart_close() - Close the CG2900 UART for data transfers.
+ * @dev:	Transport device information.
+ *
+ * Returns:
+ *   0 if there is no error.
+ */
+static int uart_close(struct cg2900_chip_dev *dev)
+{
+	/* The chip is already shut down. Power off the chip. */
+	uart_set_chip_power(dev, false);
+	return 0;
+}
+
+/**
+ * send_skb_to_core() - Sends packet received from UART to CG2900 Core.
+ * @skb:	Received data packet.
+ *
+ * This function checks if UART is waiting for Command complete event,
+ * see set_baud_rate.
+ * If it is waiting it checks if it is the expected packet and the status.
+ * If not is passes the packet to CG2900 Core.
+ */
+static void send_skb_to_core(struct uart_info *uart_info, struct sk_buff *skb)
+{
+	u8 status;
+
+	if (!skb) {
+		dev_err(MAIN_DEV, "send_skb_to_core: Received NULL as skb\n");
+		return;
+	}
+
+	if (BAUD_WAITING == uart_info->baud_rate_state) {
+		/*
+		 * Should only really be one packet received now:
+		 * the CmdComplete for the SetBaudrate command
+		 * Let's see if this is the packet we are waiting for.
+		 */
+		u8 h4_channel = HCI_BT_EVT_H4_CHANNEL;
+		if (use_device_channel_for_vs_cmd(
+				uart_info->chip_dev.chip.hci_revision)) {
+			h4_channel = HCI_DEV_MGMT_H4_CHANNEL;
+		}
+		if (!is_bt_cmd_complete_no_param(skb,
+				CG2900_BT_OP_VS_SET_BAUD_RATE, &status,
+				h4_channel)) {
+			/*
+			 * Received other event. Should not really happen,
+			 * but pass the data to CG2900 Core anyway.
+			 */
+			dev_dbg(MAIN_DEV, "Sending packet to CG2900 Core while"\
+				" waiting for BaudRate CmdComplete\n");
+			uart_info->chip_dev.c_cb.data_from_chip
+				(&uart_info->chip_dev, skb);
+			return;
+		}
+
+		/*
+		 * We have received complete event for our baud rate
+		 * change command
+		 */
+		if (HCI_BT_ERROR_NO_ERROR == status) {
+			dev_dbg(MAIN_DEV, "Received baud rate change complete"\
+				" event OK\n");
+			dev_dbg(MAIN_DEV,
+				"New baud_rate_state: BAUD_SUCCESS\n");
+			uart_info->baud_rate_state = BAUD_SUCCESS;
+		} else {
+			dev_err(MAIN_DEV,
+				"Received baud rate change complete event"\
+				" with status 0x%X\n", status);
+			dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_FAIL\n");
+			uart_info->baud_rate_state = BAUD_FAIL;
+		}
+		wake_up_all(&uart_wait_queue);
+		kfree_skb(skb);
+	} else if (BAUD_SENDING_RESET == uart_info->baud_rate_state) {
+		/*
+		 * Should only really be one packet received now:
+		 * the CmdComplete for the Reset command
+		 * Let's see if this is the packet we are waiting for.
+		 */
+		if (!is_bt_cmd_complete_no_param(skb, HCI_OP_RESET, &status,
+				HCI_BT_EVT_H4_CHANNEL)) {
+			/*
+			 * Received other event. Should not really happen,
+			 * but pass the data to CG2900 Core anyway.
+			 */
+			dev_dbg(MAIN_DEV, "Sending packet to CG2900 Core while"\
+				" waiting for Reset CmdComplete\n");
+			uart_info->chip_dev.c_cb.data_from_chip
+					(&uart_info->chip_dev, skb);
+			return;
+		}
+
+		/*
+		 * We have received complete event for our baud rate
+		 * change command
+		 */
+		if (HCI_BT_ERROR_NO_ERROR == status) {
+			dev_dbg(MAIN_DEV,
+				"Received HCI reset complete event OK\n");
+			/*
+			 * Go back to BAUD_IDLE since this was not really
+			 * baud rate change but just a preparation of the chip
+			 * to be ready to receive commands.
+			 */
+			dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_IDLE\n");
+			uart_info->baud_rate_state = BAUD_IDLE;
+		} else {
+			dev_err(MAIN_DEV,
+				"Received HCI reset complete event with "
+				"status 0x%X", status);
+			dev_dbg(MAIN_DEV, "New baud_rate_state: BAUD_FAIL\n");
+			uart_info->baud_rate_state = BAUD_FAIL;
+		}
+		wake_up_all(&uart_wait_queue);
+		kfree_skb(skb);
+	} else {
+		/* Just pass data to CG2900 Core */
+		uart_info->chip_dev.c_cb.data_from_chip
+						(&uart_info->chip_dev, skb);
+	}
+}
+
+/**
+ * check_data_len() - Check number of bytes to receive.
+ * @len:	Number of bytes left to receive.
+ */
+static void check_data_len(struct uart_info *uart_info, int len)
+{
+	/* First get number of bytes left in the sk_buffer */
+	register int room = skb_tailroom(uart_info->rx_skb);
+
+	if (!len) {
+		/* No data left to receive. Transmit to CG2900 Core */
+		send_skb_to_core(uart_info, uart_info->rx_skb);
+	} else if (len > room) {
+		dev_err(MAIN_DEV, "Data length is too large (%d > %d)\n",
+			len, room);
+		kfree_skb(uart_info->rx_skb);
+	} else {
+		/*
+		 * "Normal" case. Switch to data receiving state and store
+		 * data length.
+		 */
+		uart_info->rx_state = W4_DATA;
+		uart_info->rx_count = len;
+		return;
+	}
+
+	uart_info->rx_state = W4_PACKET_TYPE;
+	uart_info->rx_skb   = NULL;
+	uart_info->rx_count = 0;
+}
+
+/**
+ * work_restart_sleep() - Cancel pending sleep_work, wake-up driver and
+ * schedule new sleep_work in a work context.
+ * @work:	work which needs to be done.
+ */
+static void work_restart_sleep(struct work_struct *work)
+{
+	struct uart_work_struct *current_work =
+		container_of(work, struct uart_work_struct, work);
+	struct uart_info *uart_info = (struct uart_info *)current_work->data;
+	unsigned long timeout_jiffies = get_sleep_timeout(uart_info);
+
+	spin_lock_bh(&(uart_info->transmission_lock));
+	uart_info->rx_in_progress = false;
+	spin_unlock_bh(&(uart_info->transmission_lock));
+
+	/* Cancel pending sleep work if there is any. */
+	cancel_delayed_work_sync(&uart_info->sleep_work.work);
+
+	wake_up_chip(uart_info);
+
+	spin_lock_bh(&(uart_info->transmission_lock));
+	/*
+	 * If there are no ongoing transfers schedule the sleep work.
+	 */
+	if (!(uart_info->tx_in_progress) && timeout_jiffies)
+		queue_delayed_work(uart_info->wq,
+				&uart_info->sleep_work.work,
+				timeout_jiffies);
+	spin_unlock_bh(&(uart_info->transmission_lock));
+}
+
+/**
+ * cg2900_hu_receive() - Handles received UART data.
+ * @data:	Data received
+ * @count:	Number of bytes received
+ *
+ * The cg2900_hu_receive() function handles received UART data and puts it
+ * together to one complete packet.
+ *
+ * Returns:
+ *   Number of bytes not handled, i.e. 0 = no error.
+ */
+static int cg2900_hu_receive(struct hci_uart *hu,
+					void *data, int count)
+{
+	const u8 *r_ptr;
+	u8 *w_ptr;
+	int len;
+	struct hci_event_hdr	*evt;
+	struct hci_acl_hdr	*acl;
+	struct nfc_hci_hdr	*nfc;
+	struct ant_cmd_hci_hdr	*ant_cmd;
+	struct ant_dat_hci_hdr	*ant_dat;
+	union fm_leg_evt_or_irq	*fm;
+	struct gnss_hci_hdr	*gnss;
+	struct uart_info *uart_info = dev_get_drvdata(hu->proto->dev);
+	u8 *tmp;
+
+	r_ptr = (const u8 *)data;
+
+	spin_lock_bh(&(uart_info->transmission_lock));
+	/* Mark that there is an ongoing transfer. */
+	uart_info->rx_in_progress = true;
+	spin_unlock_bh(&(uart_info->transmission_lock));
+
+	/* Cancel pending sleep work if there is any. */
+	cancel_delayed_work(&uart_info->sleep_work.work);
+
+	if (uart_debug)
+		print_hex_dump_bytes(NAME " RX:\t", DUMP_PREFIX_NONE,
+				     data, count);
+
+	spin_lock_bh(&uart_info->rx_skb_lock);
+
+	/* Continue while there is data left to handle */
+	while (count) {
+		/*
+		 * If we have already received a packet we know how many bytes
+		 * there are left.
+		 */
+		if (!uart_info->rx_count)
+			goto check_h4_header;
+
+		/* First copy received data into the skb_rx */
+		len = min_t(unsigned int, uart_info->rx_count, count);
+		memcpy(skb_put(uart_info->rx_skb, len), r_ptr, len);
+		/* Update counters from the length and step the data pointer */
+		uart_info->rx_count -= len;
+		count -= len;
+		r_ptr += len;
+
+		if (uart_info->rx_count)
+			/*
+			 * More data to receive to current packet. Break and
+			 * wait for next data on the UART.
+			 */
+			break;
+
+		/* Handle the different states */
+		tmp = uart_info->rx_skb->data + CG2900_SKB_RESERVE;
+		switch (uart_info->rx_state) {
+		case W4_DATA:
+			/*
+			 * Whole data packet has been received.
+			 * Transmit it to CG2900 Core.
+			 */
+			send_skb_to_core(uart_info, uart_info->rx_skb);
+
+			uart_info->rx_state = W4_PACKET_TYPE;
+			uart_info->rx_skb = NULL;
+			continue;
+
+		case W4_DBG_HDR:
+		case W4_EVENT_HDR:
+			evt = (struct hci_event_hdr *)tmp;
+			check_data_len(uart_info, evt->plen);
+			/* Header read. Continue with next bytes */
+			continue;
+
+		case W4_ACL_HDR:
+			acl = (struct hci_acl_hdr *)tmp;
+			check_data_len(uart_info, le16_to_cpu(acl->dlen));
+			/* Header read. Continue with next bytes */
+			continue;
+
+		case W4_NFC_HDR:
+			nfc = (struct nfc_hci_hdr *)tmp;
+			/*
+			 * NFC Packet(s) have 1 extra byte for checksum.
+			 * This is not indicated by the byte length determined
+			 * from the received NFC Packet over HCI. So
+			 * length of received NFC packet should be updated
+			 * accordingly.
+			 */
+			check_data_len(uart_info, le16_to_cpu(nfc->plen) +
+					NFC_CHECKSUM_DATA_LEN);
+			/* Header read. Continue with next bytes */
+			continue;
+
+		case W4_ANT_CMD_HDR:
+			ant_cmd = (struct ant_cmd_hci_hdr *)tmp;
+			check_data_len(uart_info, ant_cmd->plen);
+			/* Header read. Continue with next bytes */
+			continue;
+
+		case W4_ANT_DAT_HDR:
+			ant_dat = (struct ant_dat_hci_hdr *)tmp;
+			check_data_len(uart_info, ant_dat->plen);
+			/* Header read. Continue with next bytes */
+			continue;
+
+		case W4_FM_RADIO_HDR:
+			fm = (union fm_leg_evt_or_irq *)tmp;
+			check_data_len(uart_info, fm->param_length);
+			/* Header read. Continue with next bytes */
+			continue;
+
+		case W4_GNSS_HDR:
+			gnss = (struct gnss_hci_hdr *)tmp;
+			check_data_len(uart_info, le16_to_cpu(gnss->plen));
+			/* Header read. Continue with next bytes */
+			continue;
+
+		case W4_DEV_MGMT_HDR:
+			/*
+			 * Device management events are similar to
+			 * BT HCI Header
+			 */
+			evt = (struct hci_event_hdr *)tmp;
+			check_data_len(uart_info, evt->plen);
+			/* Header read. Continue with next bytes */
+			continue;
+
+		default:
+			dev_err(MAIN_DEV,
+				"Bad state indicating memory overwrite "
+				"(0x%X)\n", (u8)(uart_info->rx_state));
+			break;
+		}
+
+check_h4_header:
+		/* Check which H:4 packet this is and update RX states */
+		if (*r_ptr == HCI_BT_EVT_H4_CHANNEL) {
+			uart_info->rx_state = W4_EVENT_HDR;
+			uart_info->rx_count = HCI_BT_EVT_HDR_SIZE;
+		} else if (*r_ptr == HCI_BT_ACL_H4_CHANNEL) {
+			uart_info->rx_state = W4_ACL_HDR;
+			uart_info->rx_count = HCI_BT_ACL_HDR_SIZE;
+		} else if (*r_ptr == HCI_NFC_H4_CHANNEL) {
+			uart_info->rx_state = W4_NFC_HDR;
+			uart_info->rx_count = HCI_NFC_HDR_SIZE;
+		} else if (*r_ptr == HCI_ANT_CMD_H4_CHANNEL) {
+			uart_info->rx_state = W4_ANT_CMD_HDR;
+			uart_info->rx_count = HCI_ANT_CMD_HDR_SIZE;
+		} else if (*r_ptr == HCI_ANT_DAT_H4_CHANNEL) {
+			uart_info->rx_state = W4_ANT_DAT_HDR;
+			uart_info->rx_count = HCI_ANT_DAT_HDR_SIZE;
+		} else if (*r_ptr == HCI_FM_RADIO_H4_CHANNEL) {
+			uart_info->rx_state = W4_FM_RADIO_HDR;
+			uart_info->rx_count = HCI_FM_RADIO_HDR_SIZE;
+		} else if (*r_ptr == HCI_GNSS_H4_CHANNEL) {
+			uart_info->rx_state = W4_GNSS_HDR;
+			uart_info->rx_count = HCI_GNSS_HDR_SIZE;
+		} else if (*r_ptr == HCI_DEBUG_H4_CHANNEL) {
+			uart_info->rx_state = W4_DBG_HDR;
+			uart_info->rx_count = HCI_BT_EVT_HDR_SIZE;
+		} else if (*r_ptr & HCI_DEV_MGMT_CHANNEL_BIT) {
+			uart_info->rx_state = W4_DEV_MGMT_HDR;
+			uart_info->rx_count = HCI_DEV_MGMT_HDR_SIZE;
+		} else {
+			dev_err(MAIN_DEV, "Unknown HCI packet type 0x%X\n",
+				(u8)*r_ptr);
+			r_ptr++;
+			count--;
+			continue;
+		}
+
+		/*
+		 * Allocate packet. We do not yet know the size and therefore
+		 * allocate max size.
+		 */
+		uart_info->rx_skb = alloc_rx_skb(RX_SKB_MAX_SIZE, GFP_ATOMIC);
+		if (!uart_info->rx_skb) {
+			dev_err(MAIN_DEV,
+				"Can't allocate memory for new packet\n");
+			uart_info->rx_state = W4_PACKET_TYPE;
+			uart_info->rx_count = 0;
+
+			spin_lock_bh(&(uart_info->transmission_lock));
+			uart_info->rx_in_progress = false;
+			spin_unlock_bh(&(uart_info->transmission_lock));
+
+			spin_unlock_bh(&uart_info->rx_skb_lock);
+			return 0;
+		}
+
+		/* Write the H:4 header first in the sk_buffer */
+		w_ptr = skb_put(uart_info->rx_skb, 1);
+		*w_ptr = *r_ptr;
+
+		/* First byte (H4 header) read. Goto next byte */
+		r_ptr++;
+		count--;
+	}
+
+	(void)queue_work(uart_info->wq, &uart_info->restart_sleep_work.work);
+
+	spin_unlock_bh(&uart_info->rx_skb_lock);
+	return count;
+}
+
+/**
+ * cg2900_hu_open() - Called when UART line discipline changed to N_HCI.
+ * @hu:	Pointer to associated Hci uart structure.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Errors from cg2900_register_trans_driver.
+ */
+static int cg2900_hu_open(struct hci_uart *hu)
+{
+	int err;
+	struct uart_info *uart_info = dev_get_drvdata(hu->proto->dev);
+
+	if (!uart_info)
+		return -EACCES;
+
+	dev_info(MAIN_DEV, "UART opened\n");
+
+	skb_queue_head_init(&uart_info->tx_queue);
+
+	uart_info->hu = hu;
+
+	/* Tell CG2900 Core that UART is connected */
+	err = cg2900_register_trans_driver(&uart_info->chip_dev);
+	if (err)
+		dev_err(MAIN_DEV, "Could not register transport driver (%d)\n",
+			err);
+
+	if (hu->tty->ops->tiocmget && hu->tty->ops->break_ctl)
+		set_bit(SLEEP_TTY_READY, &uart_info->sleep_flags);
+	else {
+		dev_err(MAIN_DEV, "Sleep mode not available\n");
+		clear_bit(SLEEP_TTY_READY, &uart_info->sleep_flags);
+	}
+
+	return err;
+
+}
+
+/**
+ * cg2900_hu_close() - Close UART tty.
+ * @hu:	Pointer to associated hci_uart structure.
+ *
+ * The uart_tty_close() function is called when the line discipline is changed
+ * to something else, the TTY is closed, or the TTY detects a hangup.
+ */
+static int cg2900_hu_close(struct hci_uart *hu)
+{
+	int err;
+	struct uart_info *uart_info = dev_get_drvdata(hu->proto->dev);
+
+
+	BUG_ON(!uart_info);
+	BUG_ON(!uart_info->wq);
+
+	clear_bit(SLEEP_TTY_READY, &uart_info->sleep_flags);
+
+	/* Purge any stored sk_buffers */
+	skb_queue_purge(&uart_info->tx_queue);
+
+	spin_lock_bh(&uart_info->rx_skb_lock);
+	if (uart_info->rx_skb) {
+		kfree_skb(uart_info->rx_skb);
+		uart_info->rx_skb = NULL;
+	}
+	spin_unlock_bh(&uart_info->rx_skb_lock);
+
+	dev_info(MAIN_DEV, "UART closed\n");
+	err = create_work_item(uart_info, work_hw_deregistered);
+	if (err)
+		dev_err(MAIN_DEV, "Failed to create work item (%d) "\
+			"work_hw_deregistered\n", err);
+
+	uart_info->hu = NULL;
+
+	return 0;
+}
+
+/**
+ * cg2900_hu_write() - Callback from UART for sending more data.
+ * @hu: Pointer to associated hci_uart structure.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Errors from create_work_item.
+ */
+static int cg2900_hu_write_callback(struct hci_uart *hu)
+{
+	int err;
+	struct uart_info *uart_info = dev_get_drvdata(hu->proto->dev);
+
+	/* start TX operation */
+	err = create_work_item(uart_info, work_do_transmit);
+	if (err)
+		dev_err(MAIN_DEV,
+			"Failed to create work item (%d) "
+			"cg2900_hu_write_callback\n",
+			err);
+
+	return err;
+}
+
+/**
+ * cg2900_hu_dequeue() - Get new skbuff.
+ * @hu: Pointer to associated hci_uart structure.
+ *
+ * The uart_tty_close() function is called when the line discipline is changed
+ * to something else, the TTY is closed, or the TTY detects a hangup.
+ */
+static struct sk_buff *cg2900_hu_dequeue(struct hci_uart *hu)
+{
+	struct sk_buff *skb;
+	struct uart_info *uart_info = dev_get_drvdata(hu->proto->dev);
+	unsigned long timeout_jiffies = get_sleep_timeout(uart_info);
+	unsigned long flags;
+
+	spin_lock_irqsave(&(uart_info->transmission_lock), flags);
+
+	skb = skb_dequeue(&uart_info->tx_queue);
+
+	if (!skb)
+		uart_info->tx_in_progress = false;
+
+	/*
+	 * If there are no ongoing transfers schedule the sleep work.
+	 */
+	if (!(uart_info->rx_in_progress) && timeout_jiffies && !skb)
+		queue_delayed_work(uart_info->wq,
+				&uart_info->sleep_work.work,
+				timeout_jiffies);
+
+	spin_unlock_irqrestore(&(uart_info->transmission_lock), flags);
+
+	if (BAUD_SENDING == uart_info->baud_rate_state && !skb)
+		finish_setting_baud_rate(hu);
+	/*
+	 * If it's set baud rate cmd set correct baud state and after
+	 * sending is finished inform the tty driver about the new
+	 * baud rate.
+	 */
+	if ((BAUD_START == uart_info->baud_rate_state) &&
+		skb && (is_set_baud_rate_cmd(skb->data))) {
+		dev_dbg(MAIN_DEV, "UART set baud rate cmd found\n");
+		uart_info->baud_rate_state = BAUD_SENDING;
+	}
+
+	if (uart_debug && skb)
+		print_hex_dump_bytes(NAME " TX:\t", DUMP_PREFIX_NONE,
+				     skb->data, skb->len);
+
+	return skb;
+}
+
+/**
+ * cg2900_hu_flush() - Flush buffers.
+ * @hu: Pointer to associated hci_uart structure.
+ *
+ */
+static int cg2900_hu_flush(struct hci_uart *hu)
+{
+	struct uart_info *uart_info = dev_get_drvdata(hu->proto->dev);
+
+	dev_dbg(MAIN_DEV, "ui %p", uart_info);
+	skb_queue_purge(&uart_info->tx_queue);
+	return 0;
+}
+
+/**
+ * cg2900_uart_probe() - Initialize CG2900 UART resources.
+ * @pdev:	Platform device.
+ *
+ * This function initializes the module and registers to the UART framework.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM for failed alloc or structure creation.
+ *   -ECHILD for failed work queue creation.
+ *   Error codes generated by tty_register_ldisc.
+ */
+static int __devinit cg2900_uart_probe(struct platform_device *pdev)
+{
+	int err = 0;
+	struct uart_info *uart_info;
+	struct hci_uart_proto *p;
+	struct resource *resource;
+	struct cg2900_platform_data *pf_data = dev_get_platdata(&pdev->dev);
+
+	pr_debug("cg2900_uart_probe");
+
+	uart_info = kzalloc(sizeof(*uart_info), GFP_KERNEL);
+	if (!uart_info) {
+		pr_err("Couldn't allocate uart_info");
+		return -ENOMEM;
+	}
+
+	uart_info->sleep_state = CHIP_POWERED_DOWN;
+	mutex_init(&(uart_info->sleep_state_lock));
+
+	spin_lock_init(&(uart_info->transmission_lock));
+	spin_lock_init(&(uart_info->rx_skb_lock));
+
+	uart_info->chip_dev.t_cb.open = uart_open;
+	uart_info->chip_dev.t_cb.close = uart_close;
+	uart_info->chip_dev.t_cb.write = uart_write;
+	uart_info->chip_dev.t_cb.set_chip_power = uart_set_chip_power;
+	uart_info->chip_dev.t_cb.chip_startup_finished =
+			uart_chip_startup_finished;
+	uart_info->chip_dev.t_cb.set_baud_rate =
+			uart_set_baud_rate;
+	uart_info->chip_dev.pdev = pdev;
+	uart_info->chip_dev.dev = &pdev->dev;
+	uart_info->chip_dev.t_data = uart_info;
+	wakeup_source_init(&uart_info->wakeup_lock, NAME);
+	uart_info->suspend_blocked = false;
+
+	pm_qos_add_request(&uart_info->pm_qos_latency, PM_QOS_CPU_DMA_LATENCY,
+			   PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE);
+
+	resource = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
+						"cts_irq");
+	if (!resource) {
+		dev_err(&pdev->dev, "CTS IRQ does not exist\n");
+		err = -EINVAL;
+		goto error_handling_free;
+	}
+	uart_info->cts_irq = resource->start;
+
+	if (pf_data->gpios.cts_gpio == -1) {
+		dev_err(&pdev->dev, "CTS GPIO does not exist\n");
+		err = -EINVAL;
+		goto error_handling_free;
+	}
+	uart_info->cts_gpio = pf_data->gpios.cts_gpio;
+
+	/* Init UART TX work queue */
+	uart_info->wq = create_singlethread_workqueue(UART_WQ_NAME);
+	if (!uart_info->wq) {
+		dev_err(MAIN_DEV, "Could not create workqueue\n");
+		err = -ECHILD; /* No child processes */
+		goto error_handling_free;
+	}
+
+	/* Initialize sleep work data */
+	uart_info->sleep_work.data = uart_info;
+	INIT_DELAYED_WORK(&uart_info->sleep_work.work, set_chip_sleep_mode);
+
+	/* Initialize wake-up work data */
+	uart_info->wakeup_work.data = uart_info;
+	INIT_WORK(&uart_info->wakeup_work.work, work_wake_up_chip);
+
+	/* Initialize after_receive work data */
+	uart_info->restart_sleep_work.data = uart_info;
+	INIT_WORK(&uart_info->restart_sleep_work.work, work_restart_sleep);
+
+	uart_info->dev = &pdev->dev;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		dev_err(MAIN_DEV, "cg2900_uart_probe: Could not allocate p\n");
+		goto error_handling_wq;
+	}
+
+	p->dev		= uart_info->dev;
+	p->id		= HCI_UART_STE;
+	p->open		= &cg2900_hu_open;
+	p->close	= &cg2900_hu_close;
+	p->recv		= &cg2900_hu_receive;
+	p->dequeue	= &cg2900_hu_dequeue;
+	p->send_callback = &cg2900_hu_write_callback;
+	p->flush	= &cg2900_hu_flush;
+
+	dev_set_drvdata(uart_info->dev, (void *)uart_info);
+
+	err = hci_uart_register_proto(p);
+	if (err) {
+		dev_err(MAIN_DEV, "cg2900_uart_probe: Can not register "\
+			"protocol\n");
+		kfree(p);
+		goto error_handling_wq;
+	}
+
+	goto finished;
+
+error_handling_wq:
+	destroy_workqueue(uart_info->wq);
+error_handling_free:
+	wakeup_source_trash(&uart_info->wakeup_lock);
+	kfree(uart_info);
+	uart_info = NULL;
+finished:
+	return err;
+}
+
+/**
+ * cg2900_uart_remove() - Release CG2900 UART resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   Error codes generated by tty_unregister_ldisc.
+ */
+static int __devexit cg2900_uart_remove(struct platform_device *pdev)
+{
+	struct uart_info *uart_info = dev_get_drvdata(&pdev->dev);
+
+	pr_debug("cg2900_uart_remove");
+
+	if (!uart_info)
+		return -ECHILD;
+
+	if (uart_info->hu)
+		hci_uart_unregister_proto(uart_info->hu->proto);
+
+	pm_qos_remove_request(&uart_info->pm_qos_latency);
+	wakeup_source_trash(&uart_info->wakeup_lock);
+	destroy_workqueue(uart_info->wq);
+
+	dev_info(MAIN_DEV, "CG2900 UART removed\n");
+	kfree(uart_info);
+	uart_info = NULL;
+	return 0;
+}
+
+static struct platform_driver cg2900_uart_driver = {
+	.driver = {
+		.name	= "cg2900-uart",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_uart_probe,
+	.remove	= __devexit_p(cg2900_uart_remove),
+#ifdef CONFIG_PM
+	.suspend = cg2900_uart_suspend,
+	.resume = cg2900_uart_resume
+#endif
+};
+
+
+/**
+ * cg2900_uart_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init cg2900_uart_init(void)
+{
+	pr_debug("cg2900_uart_init");
+	return platform_driver_register(&cg2900_uart_driver);
+}
+
+/**
+ * cg2900_uart_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit cg2900_uart_exit(void)
+{
+	pr_debug("cg2900_uart_exit");
+	platform_driver_unregister(&cg2900_uart_driver);
+}
+
+module_init(cg2900_uart_init);
+module_exit(cg2900_uart_exit);
+
+module_param(uart_default_baud, int, S_IRUGO);
+MODULE_PARM_DESC(uart_default_baud,
+		 "Default UART baud rate, e.g. 115200. If not set 115200 will "
+		 "be used.");
+
+module_param(uart_high_baud, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(uart_high_baud,
+		 "High speed UART baud rate, e.g. 4000000.  If not set 3000000 "
+		 "will be used.");
+
+module_param(uart_debug, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(uart_debug, "Enable/Disable debug. 0 means Debug disabled.");
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("ST-Ericsson CG2900 UART Driver");
diff --git a/drivers/staging/cg2900/bluetooth/hci_ldisc.c b/drivers/staging/cg2900/bluetooth/hci_ldisc.c
new file mode 100644
index 0000000..2204309
--- /dev/null
+++ b/drivers/staging/cg2900/bluetooth/hci_ldisc.c
@@ -0,0 +1,645 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * This file is a staging solution and shall be integrated into
+ * /drivers/bluetooth/hci_ldisc.c.
+ *
+ * Original hci_ldisc.c file:
+ *  Copyright (C) 2000-2001  Qualcomm Incorporated
+ *  Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
+ *  Copyright (C) 2004-2005  Marcel Holtmann <marcel@holtmann.org>
+ */
+
+#include <linux/module.h>
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/interrupt.h>
+#include <linux/ptrace.h>
+#include <linux/poll.h>
+
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/signal.h>
+#include <linux/ioctl.h>
+#include <linux/skbuff.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+
+#include "hci_uart.h"
+
+#define VERSION "2.3"
+
+#define TTY_BREAK_ON		(-1)
+#define TTY_BREAK_OFF		(0)
+
+static bool reset;
+
+static struct hci_uart_proto *hup[HCI_UART_MAX_PROTO];
+
+int cg2900_hci_uart_register_proto(struct hci_uart_proto *p)
+{
+	if (p->id >= HCI_UART_MAX_PROTO)
+		return -EINVAL;
+
+	if (hup[p->id])
+		return -EEXIST;
+
+	hup[p->id] = p;
+
+	return 0;
+}
+
+int cg2900_hci_uart_unregister_proto(struct hci_uart_proto *p)
+{
+	if (p->id >= HCI_UART_MAX_PROTO)
+		return -EINVAL;
+
+	if (!hup[p->id])
+		return -EINVAL;
+
+	hup[p->id] = NULL;
+
+	return 0;
+}
+
+static struct hci_uart_proto *hci_uart_get_proto(unsigned int id)
+{
+	if (id >= HCI_UART_MAX_PROTO)
+		return NULL;
+
+	return hup[id];
+}
+
+static inline void hci_uart_tx_complete(struct hci_uart *hu, int pkt_type)
+{
+	struct hci_dev *hdev = hu->hdev;
+
+	if (!hdev)
+		return;
+
+	/* Update HCI stat counters */
+	switch (pkt_type) {
+	case HCI_COMMAND_PKT:
+		hdev->stat.cmd_tx++;
+		break;
+
+	case HCI_ACLDATA_PKT:
+		hdev->stat.acl_tx++;
+		break;
+
+	case HCI_SCODATA_PKT:
+		hdev->stat.sco_tx++;
+		break;
+	}
+}
+
+static inline struct sk_buff *hci_uart_dequeue(struct hci_uart *hu)
+{
+	struct sk_buff *skb = hu->tx_skb;
+
+	if (!skb)
+		skb = hu->proto->dequeue(hu);
+	else
+		hu->tx_skb = NULL;
+
+	return skb;
+}
+
+int cg2900_hci_uart_tx_wakeup(struct hci_uart *hu)
+{
+	struct tty_struct *tty = hu->tty;
+	struct hci_dev *hdev = hu->hdev;
+	struct sk_buff *skb;
+
+	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
+		set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
+		return 0;
+	}
+
+	BT_DBG("");
+
+restart:
+	clear_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
+
+	while ((skb = hci_uart_dequeue(hu))) {
+		int len;
+
+		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+		len = tty->ops->write(tty, skb->data, skb->len);
+		if (hdev)
+			hdev->stat.byte_tx += len;
+
+		skb_pull(skb, len);
+		if (skb->len) {
+			hu->tx_skb = skb;
+			break;
+		}
+
+		hci_uart_tx_complete(hu, bt_cb(skb)->pkt_type);
+		kfree_skb(skb);
+	}
+
+	if (test_bit(HCI_UART_TX_WAKEUP, &hu->tx_state))
+		goto restart;
+
+	clear_bit(HCI_UART_SENDING, &hu->tx_state);
+	return 0;
+}
+
+int cg2900_hci_uart_set_break(struct hci_uart *hu, bool break_on)
+{
+	struct tty_struct *tty = hu->tty;
+	int state = TTY_BREAK_OFF;
+
+	if (break_on)
+		state = TTY_BREAK_ON;
+
+	if (tty->ops->break_ctl)
+		return tty->ops->break_ctl(tty, state);
+	else
+		return -EOPNOTSUPP;
+}
+
+void cg2900_hci_uart_flow_ctrl(struct hci_uart *hu, bool flow_on)
+{
+	if (flow_on)
+		tty_unthrottle(hu->tty);
+	else
+		tty_throttle(hu->tty);
+}
+
+int cg2900_hci_uart_set_baudrate(struct hci_uart *hu, int baud)
+{
+	struct ktermios old_termios;
+	struct tty_struct *tty = hu->tty;
+
+	if (!tty->ops->set_termios)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&(tty->termios_mutex));
+	/* Start by storing the old termios. */
+	memcpy(&old_termios, tty->termios, sizeof(old_termios));
+
+	tty_encode_baud_rate(tty, baud, baud);
+
+	/* Finally inform the driver */
+	tty->ops->set_termios(tty, &old_termios);
+
+	mutex_unlock(&(tty->termios_mutex));
+
+	return 0;
+}
+
+int cg2900_hci_uart_tiocmget(struct hci_uart *hu)
+{
+	struct tty_struct *tty = hu->tty;
+
+	if (!tty->ops->tiocmget ||  !hu->fd)
+		return -EOPNOTSUPP;
+
+	return tty->ops->tiocmget(tty);
+}
+
+void cg2900_hci_uart_flush_buffer(struct hci_uart *hu)
+{
+	tty_driver_flush_buffer(hu->tty);
+}
+
+int cg2900_hci_uart_chars_in_buffer(struct hci_uart *hu)
+{
+	return tty_chars_in_buffer(hu->tty);
+}
+
+/* ------- Interface to HCI layer ------ */
+/* Initialize device */
+static int hci_uart_open(struct hci_dev *hdev)
+{
+	BT_DBG("%s %p", hdev->name, hdev);
+
+	/* Nothing to do for UART driver */
+
+	set_bit(HCI_RUNNING, &hdev->flags);
+
+	return 0;
+}
+
+/* Reset device */
+static int hci_uart_flush(struct hci_dev *hdev)
+{
+	struct hci_uart *hu  = hci_get_drvdata(hdev);
+	struct tty_struct *tty = hu->tty;
+
+	BT_DBG("hdev %p tty %p", hdev, tty);
+
+	if (hu->tx_skb) {
+		kfree_skb(hu->tx_skb); hu->tx_skb = NULL;
+	}
+
+	/* Flush any pending characters in the driver and discipline. */
+	tty_ldisc_flush(tty);
+	tty_driver_flush_buffer(tty);
+
+	if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+		hu->proto->flush(hu);
+
+	return 0;
+}
+
+/* Close device */
+static int hci_uart_close(struct hci_dev *hdev)
+{
+	BT_DBG("hdev %p", hdev);
+
+	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
+		return 0;
+
+	hci_uart_flush(hdev);
+	hdev->flush = NULL;
+	return 0;
+}
+
+/* Send frames from HCI layer */
+static int hci_uart_send_frame(struct sk_buff *skb)
+{
+	struct hci_dev *hdev = (struct hci_dev *) skb->dev;
+	struct hci_uart *hu;
+
+	if (!hdev) {
+		BT_ERR("Frame for unknown device (hdev=NULL)");
+		return -ENODEV;
+	}
+
+	if (!test_bit(HCI_RUNNING, &hdev->flags))
+		return -EBUSY;
+
+	hu = hci_get_drvdata(hdev);
+
+	BT_DBG("%s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type,
+	       skb->len);
+
+	hu->proto->enqueue(hu, skb);
+
+	hci_uart_tx_wakeup(hu);
+
+	return 0;
+}
+
+/* ------ LDISC part ------ */
+/* hci_uart_tty_open
+ *
+ *     Called when line discipline changed to HCI_UART.
+ *
+ * Arguments:
+ *     tty    pointer to tty info structure
+ * Return Value:
+ *     0 if success, otherwise error code
+ */
+static int hci_uart_tty_open(struct tty_struct *tty)
+{
+	struct hci_uart *hu = (void *) tty->disc_data;
+
+	BT_DBG("tty %p", tty);
+
+	/* FIXME: This btw is bogus, nothing requires the old ldisc to clear
+	   the pointer */
+	if (hu)
+		return -EEXIST;
+
+	/* Error if the tty has no write op instead of leaving an exploitable
+	   hole */
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
+	hu = kzalloc(sizeof(struct hci_uart), GFP_KERNEL);
+	if (!hu) {
+		BT_ERR("Can't allocate control structure");
+		return -ENFILE;
+	}
+
+	tty->disc_data = hu;
+	hu->tty = tty;
+	tty->receive_room = 65536;
+
+	spin_lock_init(&hu->rx_lock);
+
+	/* Flush any pending characters in the driver and line discipline. */
+
+	/* FIXME: why is this needed. Note don't use ldisc_ref here as the
+	   open path is before the ldisc is referencable */
+
+	if (tty->ldisc->ops->flush_buffer)
+		tty->ldisc->ops->flush_buffer(tty);
+	tty_driver_flush_buffer(tty);
+
+	return 0;
+}
+
+/* hci_uart_tty_close()
+ *
+ *    Called when the line discipline is changed to something
+ *    else, the tty is closed, or the tty detects a hangup.
+ */
+static void hci_uart_tty_close(struct tty_struct *tty)
+{
+	struct hci_uart *hu = (void *)tty->disc_data;
+
+	BT_DBG("tty %p", tty);
+
+	/* Detach from the tty */
+	tty->disc_data = NULL;
+
+	if (hu) {
+		struct hci_dev *hdev = hu->hdev;
+
+		if (hdev)
+			hci_uart_close(hdev);
+
+		if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
+			hu->proto->close(hu);
+			if (hdev) {
+				hci_unregister_dev(hdev);
+				hci_free_dev(hdev);
+			}
+		}
+	}
+}
+
+/* hci_uart_tty_wakeup()
+ *
+ *    Callback for transmit wakeup. Called when low level
+ *    device driver can accept more send data.
+ *
+ * Arguments:        tty    pointer to associated tty instance data
+ * Return Value:    None
+ */
+static void hci_uart_tty_wakeup(struct tty_struct *tty)
+{
+	struct hci_uart *hu = (void *)tty->disc_data;
+
+	BT_DBG("");
+
+	if (!hu)
+		return;
+
+	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+
+	if (tty != hu->tty)
+		return;
+
+	if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+		hu->proto->send_callback(hu);
+}
+
+/* hci_uart_tty_receive()
+ *
+ *     Called by tty low level driver when receive data is
+ *     available.
+ *
+ * Arguments:  tty          pointer to tty isntance data
+ *             data         pointer to received data
+ *             flags        pointer to flags for data
+ *             count        count of received data in bytes
+ *
+ * Return Value:    None
+ */
+static void hci_uart_tty_receive(struct tty_struct *tty, const u8 *data,
+				 char *flags, int count)
+{
+	struct hci_uart *hu = (void *)tty->disc_data;
+
+	if (!hu || tty != hu->tty)
+		return;
+
+	if (!test_bit(HCI_UART_PROTO_SET, &hu->flags))
+		return;
+
+	spin_lock(&hu->rx_lock);
+	hu->proto->recv(hu, (void *) data, count);
+	if (hu->hdev)
+		hu->hdev->stat.byte_rx += count;
+	spin_unlock(&hu->rx_lock);
+
+	tty_unthrottle(tty);
+}
+
+static int hci_uart_register_dev(struct hci_uart *hu)
+{
+	struct hci_dev *hdev;
+
+	BT_DBG("");
+
+	/* Initialize and register HCI device */
+	hdev = hci_alloc_dev();
+	if (!hdev) {
+		BT_ERR("Can't allocate HCI device");
+		return -ENOMEM;
+	}
+
+	hu->hdev = hdev;
+
+	hdev->bus = HCI_UART;
+	hci_set_drvdata(hdev, hu);
+
+	hdev->open  = hci_uart_open;
+	hdev->close = hci_uart_close;
+	hdev->flush = hci_uart_flush;
+	hdev->send  = hci_uart_send_frame;
+
+	if (!reset)
+		set_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
+
+	if (test_bit(HCI_UART_RAW_DEVICE, &hu->hdev_flags))
+		set_bit(HCI_QUIRK_RAW_DEVICE, &hdev->quirks);
+
+	if (hci_register_dev(hdev) < 0) {
+		BT_ERR("Can't register HCI device");
+		hci_free_dev(hdev);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int hci_uart_set_proto(struct hci_uart *hu, int id)
+{
+	struct hci_uart_proto *p;
+	int err;
+
+	p = hci_uart_get_proto(id);
+	if (!p)
+		return -EPROTONOSUPPORT;
+
+	hu->proto = p;
+
+	err = p->open(hu);
+	if (err)
+		return err;
+
+	/*
+	 * Protocol might register hdev by itself.
+	 * In that case, there is no need to register it here.
+	 */
+	if (!hu->proto->register_hci_dev)
+		return 0;
+
+	err = hci_uart_register_dev(hu);
+	if (err) {
+		p->close(hu);
+		return err;
+	}
+
+	return 0;
+}
+
+/* hci_uart_tty_ioctl()
+ *
+ *    Process IOCTL system call for the tty device.
+ *
+ * Arguments:
+ *
+ *    tty        pointer to tty instance data
+ *    file       pointer to open file object for device
+ *    cmd        IOCTL command code
+ *    arg        argument for IOCTL call (cmd dependent)
+ *
+ * Return Value:    Command dependent
+ */
+static int hci_uart_tty_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	struct hci_uart *hu = (void *)tty->disc_data;
+	int err = 0;
+
+	BT_DBG("");
+
+	/* Verify the status of the device */
+	if (!hu)
+		return -EBADF;
+
+	switch (cmd) {
+	case HCIUARTSETPROTO:
+		if (!test_and_set_bit(HCI_UART_PROTO_SET, &hu->flags)) {
+			err = hci_uart_set_proto(hu, arg);
+			if (err) {
+				clear_bit(HCI_UART_PROTO_SET, &hu->flags);
+				return err;
+			}
+			/* Keep file descriptor.*/
+			hu->fd = file;
+		} else
+			return -EBUSY;
+		break;
+
+	case HCIUARTGETPROTO:
+		if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+			return hu->proto->id;
+		return -EUNATCH;
+
+	case HCIUARTGETDEVICE:
+		if (test_bit(HCI_UART_PROTO_SET, &hu->flags)) {
+			if (hu->hdev)
+				return hu->hdev->id;
+			else
+				return -ENOMSG;
+		}
+		return -EUNATCH;
+
+	case HCIUARTSETFLAGS:
+		if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+			return -EBUSY;
+		hu->hdev_flags = arg;
+		break;
+
+	case HCIUARTGETFLAGS:
+		return hu->hdev_flags;
+
+	default:
+		err = n_tty_ioctl_helper(tty, file, cmd, arg);
+		break;
+	};
+
+	return err;
+}
+
+/*
+ * We don't provide read/write/poll interface for user space.
+ */
+static ssize_t hci_uart_tty_read(struct tty_struct *tty, struct file *file,
+					unsigned char __user *buf, size_t nr)
+{
+	return 0;
+}
+
+static ssize_t hci_uart_tty_write(struct tty_struct *tty, struct file *file,
+					const unsigned char *data, size_t count)
+{
+	return 0;
+}
+
+static unsigned int hci_uart_tty_poll(struct tty_struct *tty,
+					struct file *filp, poll_table *wait)
+{
+	return 0;
+}
+
+static int __init cg2900_hci_uart_init(void)
+{
+	static struct tty_ldisc_ops hci_uart_ldisc;
+	int err;
+
+	BT_INFO("HCI UART driver ver %s", VERSION);
+
+	/* Register the tty discipline */
+
+	memset(&hci_uart_ldisc, 0, sizeof(hci_uart_ldisc));
+	hci_uart_ldisc.magic		= TTY_LDISC_MAGIC;
+	hci_uart_ldisc.name		= "n_cg2900_hci";
+	hci_uart_ldisc.open		= hci_uart_tty_open;
+	hci_uart_ldisc.close		= hci_uart_tty_close;
+	hci_uart_ldisc.read		= hci_uart_tty_read;
+	hci_uart_ldisc.write		= hci_uart_tty_write;
+	hci_uart_ldisc.ioctl		= hci_uart_tty_ioctl;
+	hci_uart_ldisc.poll		= hci_uart_tty_poll;
+	hci_uart_ldisc.receive_buf	= hci_uart_tty_receive;
+	hci_uart_ldisc.write_wakeup	= hci_uart_tty_wakeup;
+	hci_uart_ldisc.owner		= THIS_MODULE;
+
+	err = tty_register_ldisc(N_CG2900_HCI, &hci_uart_ldisc);
+	if (err) {
+		BT_ERR("HCI line discipline registration failed. (%d)", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static void __exit cg2900_hci_uart_exit(void)
+{
+	int err;
+
+	/* Release tty registration of line discipline */
+	err = tty_unregister_ldisc(N_CG2900_HCI);
+	if (err)
+		BT_ERR("Can't unregister HCI line discipline (%d)", err);
+}
+
+module_init(cg2900_hci_uart_init);
+module_exit(cg2900_hci_uart_exit);
+
+module_param(reset, bool, 0644);
+MODULE_PARM_DESC(reset, "Send HCI reset command on initialization");
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>");
+MODULE_DESCRIPTION("CG2900 Staging Bluetooth HCI UART driver ver " VERSION);
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_LDISC(N_CG2900_HCI);
diff --git a/drivers/staging/cg2900/bluetooth/hci_uart.h b/drivers/staging/cg2900/bluetooth/hci_uart.h
new file mode 100644
index 0000000..b8d6f0a
--- /dev/null
+++ b/drivers/staging/cg2900/bluetooth/hci_uart.h
@@ -0,0 +1,106 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * This file is a staging solution and shall be integrated into
+ * /drivers/bluetooth/hci_uart.h.
+ *
+ * Original hci_uart.h file:
+ *  Copyright (C) 2000-2001  Qualcomm Incorporated
+ *  Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
+ *  Copyright (C) 2004-2005  Marcel Holtmann <marcel@holtmann.org>
+ */
+
+/*
+ * Staging CG2900 Bluetooth HCI UART. Will be replaced by normal N_HCI when
+ * moved to normal driver folder.
+ */
+#ifndef N_CG2900_HCI
+#define N_CG2900_HCI		23
+#endif /* N_CG2900_HCI */
+
+/* Ioctls */
+#define HCIUARTSETPROTO		_IOW('U', 200, int)
+#define HCIUARTGETPROTO		_IOR('U', 201, int)
+#define HCIUARTGETDEVICE	_IOR('U', 202, int)
+#define HCIUARTSETFLAGS		_IOW('U', 203, int)
+#define HCIUARTGETFLAGS		_IOR('U', 204, int)
+
+/* UART protocols */
+#define HCI_UART_MAX_PROTO	7
+
+#define HCI_UART_H4	0
+#define HCI_UART_BCSP	1
+#define HCI_UART_3WIRE	2
+#define HCI_UART_H4DS	3
+#define HCI_UART_LL	4
+#define HCI_UART_ATH3K	5
+#define HCI_UART_STE	6
+
+#define HCI_UART_RAW_DEVICE	0
+
+/* UART break and flow control parameters */
+#define BREAK_ON		true
+#define BREAK_OFF		false
+#define FLOW_ON			true
+#define FLOW_OFF		false
+
+struct hci_uart;
+
+struct hci_uart_proto {
+	unsigned int id;
+	int (*open)(struct hci_uart *hu);
+	int (*close)(struct hci_uart *hu);
+	int (*flush)(struct hci_uart *hu);
+	int (*recv)(struct hci_uart *hu, void *data, int len);
+	int (*send_callback)(struct hci_uart *hu);
+	int (*enqueue)(struct hci_uart *hu, struct sk_buff *skb);
+	struct sk_buff *(*dequeue)(struct hci_uart *hu);
+	bool register_hci_dev;
+	struct device *dev;
+};
+
+struct hci_uart {
+	struct tty_struct	*tty;
+	struct hci_dev		*hdev;
+	unsigned long		flags;
+	unsigned long		hdev_flags;
+
+	struct hci_uart_proto	*proto;
+	void			*priv;
+
+	struct sk_buff		*tx_skb;
+	unsigned long		tx_state;
+	spinlock_t		rx_lock;
+
+	struct file		*fd;
+};
+
+/* HCI_UART proto flag bits */
+#define HCI_UART_PROTO_SET	0
+
+/* TX states  */
+#define HCI_UART_SENDING	1
+#define HCI_UART_TX_WAKEUP	2
+
+int cg2900_hci_uart_register_proto(struct hci_uart_proto *p);
+int cg2900_hci_uart_unregister_proto(struct hci_uart_proto *p);
+int cg2900_hci_uart_tx_wakeup(struct hci_uart *hu);
+int cg2900_hci_uart_set_baudrate(struct hci_uart *hu, int baud);
+int cg2900_hci_uart_set_break(struct hci_uart *hu, bool break_on);
+int cg2900_hci_uart_tiocmget(struct hci_uart *hu);
+void cg2900_hci_uart_flush_buffer(struct hci_uart *hu);
+void cg2900_hci_uart_flow_ctrl(struct hci_uart *hu, bool flow_on);
+int cg2900_hci_uart_chars_in_buffer(struct hci_uart *hu);
+
+#define hci_uart_register_proto cg2900_hci_uart_register_proto
+#define hci_uart_unregister_proto cg2900_hci_uart_unregister_proto
+#define hci_uart_tx_wakeup cg2900_hci_uart_tx_wakeup
+#define hci_uart_set_baudrate cg2900_hci_uart_set_baudrate
+#define hci_uart_set_break cg2900_hci_uart_set_break
+#define hci_uart_tiocmget cg2900_hci_uart_tiocmget
+#define hci_uart_flush_buffer cg2900_hci_uart_flush_buffer
+#define hci_uart_flow_ctrl cg2900_hci_uart_flow_ctrl
+#define hci_uart_chars_in_buffer cg2900_hci_uart_chars_in_buffer
diff --git a/drivers/staging/cg2900/include/cg2900.h b/drivers/staging/cg2900/include/cg2900.h
new file mode 100644
index 0000000..e49dc67
--- /dev/null
+++ b/drivers/staging/cg2900/include/cg2900.h
@@ -0,0 +1,338 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 connectivity
+ * controller.
+ */
+
+#ifndef _CG2900_H_
+#define _CG2900_H_
+
+#include <linux/types.h>
+
+/* Perform reset. No parameters used */
+#define CG2900_CHAR_DEV_IOCTL_RESET		_IOW('U', 210, int)
+/* Check for reset */
+#define CG2900_CHAR_DEV_IOCTL_CHECK4RESET	_IOR('U', 212, int)
+/* Retrieve revision info */
+#define CG2900_CHAR_DEV_IOCTL_GET_REVISION	_IOR('U', 213, \
+						     struct cg2900_rev_data)
+/* Sysclk3 - Clock Enable used for GPS */
+#define CG2900_CHAR_DEV_IOCTL_EXT_CLK_ENABLE    _IOR('U', 214, int)
+/* Sysclk3 - Clock Disable used for GPS */
+#define CG2900_CHAR_DEV_IOCTL_EXT_CLK_DISABLE   _IOR('U', 215, int)
+
+#define CG2900_CHAR_DEV_IOCTL_EVENT_IDLE	0
+#define CG2900_CHAR_DEV_IOCTL_EVENT_RESET	1
+
+/* Specific chip version data */
+#define STLC2690_REV			0x0600
+#define CG2900_PG1_REV			0x0101
+#define CG2900_PG2_REV			0x0200
+#define CG2900_PG1_SPECIAL_REV	0x0700
+#define CG2905_PG1_05_REV		0x1805
+#define CG2905_PG2_REV			0x1806
+#define CG2910_PG1_REV			0x1004
+#define CG2910_PG2_REV			0x1008
+
+/*
+ * There is an issue in OTP setting of a single bit in CG2905
+ */
+#define CG2905_PG1_05_REV_OTP_NOT_SET	0x1005
+#define CG2905_PG2_REV_OTP_NOT_SET	0x1006
+#define CG2905_SET_OTP			0x1800
+
+/**
+ * struct cg2900_rev_data - Contains revision data for the local controller.
+ * @revision:		Revision of the controller, e.g. to indicate that it is
+ *			a CG2900 controller.
+ * @sub_version:	Subversion of the controller, e.g. to indicate a certain
+ *			tape-out of the controller.
+ *
+ * The values to match retrieved values to each controller may be retrieved from
+ * the manufacturer.
+ */
+struct cg2900_rev_data {
+	u16 revision;
+	u16 sub_version;
+};
+
+#ifdef __KERNEL__
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/skbuff.h>
+
+/* Temporary solution while in staging directory */
+#include "cg2900_hci.h"
+
+/**
+ * struct cg2900_chip_rev_info - Chip info structure.
+ * @manufacturer:	Chip manufacturer.
+ * @hci_version:	Bluetooth version supported over HCI.
+ * @hci_revision:	Chip revision, i.e. which chip is this.
+ * @lmp_pal_version:	Bluetooth version supported over air.
+ * @hci_sub_version:	Chip sub-version, i.e. which tape-out is this.
+ *
+ * Note that these values match the Bluetooth Assigned Numbers,
+ * see http://www.bluetooth.org/
+ */
+struct cg2900_chip_rev_info {
+	u16	manufacturer;
+	u8	hci_version;
+	u16	hci_revision;
+	u8	lmp_pal_version;
+	u16	hci_sub_version;
+};
+
+struct cg2900_chip_dev;
+
+/**
+ * struct cg2900_id_callbacks - Chip handler identification callbacks.
+ * @check_chip_support:	Called when chip is connected. If chip is supported by
+ *			driver, return true and fill in @callbacks in @dev.
+ *
+ * Note that the callback may be NULL. It must always be NULL checked before
+ * calling.
+ */
+struct cg2900_id_callbacks {
+	bool (*check_chip_support)(struct cg2900_chip_dev *dev);
+};
+
+/**
+ * struct cg2900_chip_callbacks - Callback functions registered by chip handler.
+ * @data_from_chip:	Called when data shall be transmitted to user.
+ * @chip_removed:	Called when chip is removed.
+ *
+ * Note that some callbacks may be NULL. They must always be NULL checked before
+ * calling.
+ */
+struct cg2900_chip_callbacks {
+	void (*data_from_chip)(struct cg2900_chip_dev *dev,
+			       struct sk_buff *skb);
+	void (*chip_removed)(struct cg2900_chip_dev *dev);
+};
+
+/**
+ * struct cg2900_trans_callbacks - Callback functions registered by transport.
+ * @open:		CG2900 Core needs a transport.
+ * @close:		CG2900 Core does not need a transport.
+ * @write:		CG2900 Core transmits to the chip.
+ * @set_chip_power:	CG2900 Core enables or disables the chip.
+ * @chip_startup_finished:	CG2900 Chip startup finished notification.
+ *
+ * Note that some callbacks may be NULL. They must always be NULL checked before
+ * calling.
+ */
+struct cg2900_trans_callbacks {
+	int (*open)(struct cg2900_chip_dev *dev);
+	int (*close)(struct cg2900_chip_dev *dev);
+	int (*write)(struct cg2900_chip_dev *dev, struct sk_buff *skb);
+	void (*set_chip_power)(struct cg2900_chip_dev *dev, bool chip_on);
+	void (*chip_startup_finished)(struct cg2900_chip_dev *dev);
+	void (*set_baud_rate)(struct cg2900_chip_dev *dev, bool low_baud);
+};
+
+/**
+ * struct cg2900_chip_dev - Chip handler info structure.
+ * @dev:	Device associated with this chip.
+ * @pdev:	Platform device associated with this chip.
+ * @chip:	Chip info such as manufacturer.
+ * @c_cb:	Callback structure for the chip handler.
+ * @t_cb:	Callback structure for the transport.
+ * @c_data:	Arbitrary data set by chip handler.
+ * @t_data:	Arbitrary data set by transport.
+ * @b_data:	Arbitrary data set by board handler.
+ * @prv_data:	Arbitrary data set by CG2900 Core.
+ */
+struct cg2900_chip_dev {
+	struct device			*dev;
+	struct platform_device		*pdev;
+	struct cg2900_chip_rev_info	chip;
+	struct cg2900_chip_callbacks	c_cb;
+	struct cg2900_trans_callbacks	t_cb;
+	void				*c_data;
+	void				*t_data;
+	void				*b_data;
+	void				*prv_data;
+};
+
+/**
+ * struct cg2900_platform_data - Contains platform data for CG2900.
+ * @init:		Callback called upon system start.
+ * @exit:		Callback called upon system shutdown.
+ * @enable_chip:	Callback called for enabling CG2900 chip.
+ * @disable_chip:	Callback called for disabling CG2900 chip.
+ * @get_power_switch_off_cmd:	Callback called to retrieve
+ *				HCI VS_Power_Switch_Off command (command
+ *				HCI requires platform specific GPIO data).
+ * @regulator_id:	Id of the regulator that powers on the chip
+ * @bus:		Transport used, see @include/net/bluetooth/hci.h.
+ * @gpio_sleep:		Array of GPIO sleep settings.
+ * @enable_uart:	Callback called when switching from UART GPIO to
+ *			UART HW.
+ * @disable_uart:	Callback called when switching from UART HW to
+ *			UART GPIO.
+ * @n_uart_gpios:	Number of UART GPIOs.
+ * @uart_enabled:	Array of size @n_uart_gpios with GPIO setting for
+ *			enabling UART HW (switching from GPIO mode).
+ * @uart_disabled:	Array of size @n_uart_gpios with GPIO setting for
+ *			disabling UART HW (switching to GPIO mode).
+ * @uart:		Platform data structure for UART transport.
+ * @gpios:		GPIOs used in the platform. -1 indicates not used.
+ *
+ * Any callback may be NULL if not needed.
+ */
+struct cg2900_platform_data {
+	int (*init)(struct cg2900_chip_dev *dev);
+	void (*exit)(struct cg2900_chip_dev *dev);
+	void (*enable_chip)(struct cg2900_chip_dev *dev);
+	void (*disable_chip)(struct cg2900_chip_dev *dev);
+	struct sk_buff* (*get_power_switch_off_cmd)(struct cg2900_chip_dev *dev,
+						    u16 *op_code);
+
+	char *regulator_id;
+	__u8 bus;
+	enum cg2900_gpio_pull_sleep *gpio_sleep;
+
+	struct {
+		int (*enable_uart)(struct cg2900_chip_dev *dev);
+		int (*disable_uart)(struct cg2900_chip_dev *dev);
+		int n_uart_gpios;
+		unsigned long *uart_enabled;
+		unsigned long *uart_disabled;
+	} uart;
+
+	struct {
+		int gbf_ena_reset;
+		int bt_enable;
+		int cts_gpio;
+		int pmu_en;
+	} gpios;
+};
+
+/**
+ * struct cg2900_user_data - Contains platform data for CG2900 user.
+ * @dev:		Current device. Set by CG2900 user upon probe.
+ * @opened:		True if channel is opened.
+ * @user_data:		Data set and used by CG2900 user.
+ * @private_data:	Data set and used by CG2900 driver.
+ * @h4_channel:		H4 channel. Set by CG2900 driver.
+ * @is_audio:		True if this channel is an audio channel. Set by CG2900
+ *			driver.
+ * @is_clk_user:	whether enabling CG29XX was started external entity
+ *			for eg. WLAN.
+ * @chip_independent:	True if this channel does not require chip to be
+ *			powered. Set by CG2900 driver.
+ * @bt_bus:		Transport used, see @include/net/bluetooth/hci.h.
+ * @char_dev_name:	Name to be used for character device.
+ * @channel_data:	Input data specific to current device.
+ * @open:		Open device channel. Set by CG2900 driver.
+ * @close:		Close device channel. Set by CG2900 driver.
+ * @reset:		Reset connectivity controller. Set by CG2900 driver.
+ * @alloc_skb:		Alloc sk_buffer. Set by CG2900 driver.
+ * @write:		Write to device channel. Set by CG2900 driver.
+ * @get_local_revision:	Get revision data of conncected chip. Set by CG2900
+ *			driver.
+ * @read_cb:		Callback function called when data is received on the
+ *			device channel. Set by CG2900 user. Mandatory.
+ * @reset_cb:		Callback function called when the connectivity
+ *			controller has been reset. Set by CG2900 user.
+ *
+ * Any callback may be NULL if not needed.
+ */
+struct cg2900_user_data {
+	struct device *dev;
+	bool opened;
+
+	void *user_data;
+	void *private_data;
+
+	int	h4_channel;
+	bool	is_audio;
+	bool	is_clk_user;
+	bool	chip_independent;
+
+	union {
+		__u8 bt_bus;
+		char *char_dev_name;
+	} channel_data;
+
+	int (*open)(struct cg2900_user_data *user_data);
+	void (*close)(struct cg2900_user_data *user_data);
+	int (*reset)(struct cg2900_user_data *user_data);
+	struct sk_buff * (*alloc_skb)(unsigned int size, gfp_t priority);
+	int (*write)(struct cg2900_user_data *user_data, struct sk_buff *skb);
+	bool (*get_local_revision)(struct cg2900_user_data *user_data,
+				   struct cg2900_rev_data *rev_data);
+
+	void (*read_cb)(struct cg2900_user_data *user_data,
+			struct sk_buff *skb);
+	void (*reset_cb)(struct cg2900_user_data *user_data);
+};
+
+static inline void *cg2900_get_usr(struct cg2900_user_data *dev)
+{
+	if (dev)
+		return dev->user_data;
+	return NULL;
+}
+
+static inline void cg2900_set_usr(struct cg2900_user_data *dev, void *data)
+{
+	if (dev)
+		dev->user_data = data;
+}
+
+static inline void *cg2900_get_prv(struct cg2900_user_data *dev)
+{
+	if (dev)
+		return dev->private_data;
+	return NULL;
+}
+
+static inline void cg2900_set_prv(struct cg2900_user_data *dev, void *data)
+{
+	if (dev)
+		dev->private_data = data;
+}
+
+static inline bool check_chip_revision_support(u16 hci_revision)
+{
+	if (hci_revision != CG2900_PG1_SPECIAL_REV &&
+			hci_revision != CG2900_PG1_REV &&
+			hci_revision != CG2900_PG2_REV &&
+			hci_revision != CG2905_PG1_05_REV &&
+			hci_revision != CG2905_PG2_REV &&
+			hci_revision != CG2910_PG1_REV &&
+			hci_revision != CG2910_PG2_REV)
+		return false;
+
+	return true;
+}
+
+static inline bool use_device_channel_for_vs_cmd(u16 hci_revision)
+{
+	if (hci_revision == CG2905_PG1_05_REV ||
+			hci_revision == CG2905_PG2_REV ||
+			hci_revision == CG2910_PG1_REV ||
+			hci_revision == CG2910_PG2_REV)
+		return true;
+
+	return false;
+}
+
+extern int cg2900_register_chip_driver(struct cg2900_id_callbacks *cb);
+extern void cg2900_deregister_chip_driver(struct cg2900_id_callbacks *cb);
+extern int cg2900_register_trans_driver(struct cg2900_chip_dev *dev);
+extern int cg2900_deregister_trans_driver(struct cg2900_chip_dev *dev);
+extern unsigned long cg2900_get_sleep_timeout(bool check_sleep);
+
+#endif /* __KERNEL__ */
+#endif /* _CG2900_H_ */
diff --git a/drivers/staging/cg2900/include/cg2900_audio.h b/drivers/staging/cg2900/include/cg2900_audio.h
new file mode 100644
index 0000000..ff0f053
--- /dev/null
+++ b/drivers/staging/cg2900/include/cg2900_audio.h
@@ -0,0 +1,473 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth Audio Driver for ST-Ericsson controller.
+ */
+
+#ifndef _CG2900_AUDIO_H_
+#define _CG2900_AUDIO_H_
+
+#include <linux/types.h>
+
+/*
+ * Digital Audio Interface configuration types
+ */
+
+/** CG2900_A2DP_MAX_AVDTP_HDR_LEN - Max length of a AVDTP header.
+ * Max length of a AVDTP header for an A2DP packet.
+ */
+#define CG2900_A2DP_MAX_AVDTP_HDR_LEN		25
+
+/*
+ * Op codes used when writing commands to the audio interface from user space
+ * using the char device.
+ */
+#define CG2900_OPCODE_SET_DAI_CONF		0x01
+#define CG2900_OPCODE_GET_DAI_CONF		0x02
+#define CG2900_OPCODE_CONFIGURE_ENDPOINT	0x03
+#define CG2900_OPCODE_START_STREAM		0x04
+#define CG2900_OPCODE_STOP_STREAM		0x05
+
+/**
+ * enum cg2900_dai_dir - Contains the DAI port directions alternatives.
+ * @DAI_DIR_B_RX_A_TX: Port B as Rx and port A as Tx.
+ * @DAI_DIR_B_TX_A_RX: Port B as Tx and port A as Rx.
+ */
+enum cg2900_dai_dir {
+	DAI_DIR_B_RX_A_TX = 0x00,
+	DAI_DIR_B_TX_A_RX = 0x01
+};
+
+/**
+ * enum cg2900_dai_mode - DAI mode alternatives.
+ * @DAI_MODE_SLAVE: Slave.
+ * @DAI_MODE_MASTER: Master.
+ */
+enum cg2900_dai_mode {
+	DAI_MODE_SLAVE = 0x00,
+	DAI_MODE_MASTER = 0x01
+};
+
+/**
+ * enum cg2900_dai_stream_ratio - Voice stream ratio alternatives.
+ * @STREAM_RATIO_FM16_VOICE16:	FM 16kHz, Voice 16kHz.
+ * @STREAM_RATIO_FM16_VOICE8:	FM 16kHz, Voice 8kHz.
+ * @STREAM_RATIO_FM48_VOICE16:	FM 48kHz, Voice 16Khz.
+ * @STREAM_RATIO_FM48_VOICE8:	FM 48kHz, Voice 8kHz.
+ *
+ * Contains the alternatives for the voice stream ratio between the Audio stream
+ * sample rate and the Voice stream sample rate.
+ */
+enum cg2900_dai_stream_ratio {
+	STREAM_RATIO_FM16_VOICE16 = 0x01,
+	STREAM_RATIO_FM16_VOICE8 = 0x02,
+	STREAM_RATIO_FM48_VOICE16 = 0x03,
+	STREAM_RATIO_FM48_VOICE8 = 0x06
+};
+
+/**
+ * enum cg2900_dai_fs_duration - Frame sync duration alternatives.
+ * @SYNC_DURATION_8: 8 frames sync duration.
+ * @SYNC_DURATION_16: 16 frames sync duration.
+ * @SYNC_DURATION_24: 24 frames sync duration.
+ * @SYNC_DURATION_32: 32 frames sync duration.
+ * @SYNC_DURATION_48: 48 frames sync duration.
+ * @SYNC_DURATION_50: 50 frames sync duration.
+ * @SYNC_DURATION_64: 64 frames sync duration.
+ * @SYNC_DURATION_75: 75 frames sync duration.
+ * @SYNC_DURATION_96: 96 frames sync duration.
+ * @SYNC_DURATION_125: 125 frames sync duration.
+ * @SYNC_DURATION_128: 128 frames sync duration.
+ * @SYNC_DURATION_150: 150 frames sync duration.
+ * @SYNC_DURATION_192: 192 frames sync duration.
+ * @SYNC_DURATION_250: 250 frames sync duration.
+ * @SYNC_DURATION_256: 256 frames sync duration.
+ * @SYNC_DURATION_300: 300 frames sync duration.
+ * @SYNC_DURATION_384: 384 frames sync duration.
+ * @SYNC_DURATION_500: 500 frames sync duration.
+ * @SYNC_DURATION_512: 512 frames sync duration.
+ * @SYNC_DURATION_600: 600 frames sync duration.
+ * @SYNC_DURATION_768: 768 frames sync duration.
+ *
+ * This parameter sets the PCM frame sync duration. It is calculated as the
+ * ratio between the bit clock and the frame rate. For example, if the bit
+ * clock is 512 kHz and the stream sample rate is 8 kHz, the PCM frame sync
+ * duration is 512 / 8 = 64.
+ */
+enum cg2900_dai_fs_duration {
+	SYNC_DURATION_8   = 0,
+	SYNC_DURATION_16  = 1,
+	SYNC_DURATION_24  = 2,
+	SYNC_DURATION_32  = 3,
+	SYNC_DURATION_48  = 4,
+	SYNC_DURATION_50  = 5,
+	SYNC_DURATION_64  = 6,
+	SYNC_DURATION_75  = 7,
+	SYNC_DURATION_96  = 8,
+	SYNC_DURATION_125 = 9,
+	SYNC_DURATION_128 = 10,
+	SYNC_DURATION_150 = 11,
+	SYNC_DURATION_192 = 12,
+	SYNC_DURATION_250 = 13,
+	SYNC_DURATION_256 = 14,
+	SYNC_DURATION_300 = 15,
+	SYNC_DURATION_384 = 16,
+	SYNC_DURATION_500 = 17,
+	SYNC_DURATION_512 = 18,
+	SYNC_DURATION_600 = 19,
+	SYNC_DURATION_768 = 20
+};
+
+/**
+ * enum cg2900_dai_bit_clk - Bit Clock alternatives.
+ * @BIT_CLK_128:	128 Kbits clock.
+ * @BIT_CLK_256:	256 Kbits clock.
+ * @BIT_CLK_512:	512 Kbits clock.
+ * @BIT_CLK_768:	768 Kbits clock.
+ * @BIT_CLK_1024:	1024 Kbits clock.
+ * @BIT_CLK_1411_76:	1411.76 Kbits clock.
+ * @BIT_CLK_1536:	1536 Kbits clock.
+ * @BIT_CLK_2000:	2000 Kbits clock.
+ * @BIT_CLK_2048:	2048 Kbits clock.
+ * @BIT_CLK_2400:	2400 Kbits clock.
+ * @BIT_CLK_2823_52:	2823.52 Kbits clock.
+ * @BIT_CLK_3072:	3072 Kbits clock.
+ *
+ *  This parameter sets the bit clock speed. This is the clocking of the actual
+ *  data. A usual parameter for eSCO voice is 512 kHz.
+ */
+enum cg2900_dai_bit_clk {
+	BIT_CLK_128 = 0x00,
+	BIT_CLK_256 = 0x01,
+	BIT_CLK_512 = 0x02,
+	BIT_CLK_768 = 0x03,
+	BIT_CLK_1024 = 0x04,
+	BIT_CLK_1411_76 = 0x05,
+	BIT_CLK_1536 = 0x06,
+	BIT_CLK_2000 = 0x07,
+	BIT_CLK_2048 = 0x08,
+	BIT_CLK_2400 = 0x09,
+	BIT_CLK_2823_52 = 0x0A,
+	BIT_CLK_3072 = 0x0B
+};
+
+/**
+ * enum cg2900_dai_sample_rate - Sample rates alternatives.
+ * @SAMPLE_RATE_8:	8 kHz sample rate.
+ * @SAMPLE_RATE_16:	16 kHz sample rate.
+ * @SAMPLE_RATE_44_1:	44.1 kHz sample rate.
+ * @SAMPLE_RATE_48:	48 kHz sample rate.
+ */
+enum cg2900_dai_sample_rate {
+	SAMPLE_RATE_8    = 0,
+	SAMPLE_RATE_16   = 1,
+	SAMPLE_RATE_44_1 = 2,
+	SAMPLE_RATE_48   = 3
+};
+
+/**
+ * enum cg2900_dai_port_protocol - Port protocol alternatives.
+ * @PORT_PROTOCOL_PCM: Protocol PCM.
+ * @PORT_PROTOCOL_I2S: Protocol I2S.
+ */
+enum cg2900_dai_port_protocol {
+	PORT_PROTOCOL_PCM = 0x00,
+	PORT_PROTOCOL_I2S = 0x01
+};
+
+/**
+ * enum cg2900_dai_channel_sel - The channel selection alternatives.
+ * @CHANNEL_SELECTION_RIGHT: Right channel used.
+ * @CHANNEL_SELECTION_LEFT: Left channel used.
+ * @CHANNEL_SELECTION_BOTH: Both channels used.
+ */
+enum cg2900_dai_channel_sel {
+	CHANNEL_SELECTION_RIGHT = 0x00,
+	CHANNEL_SELECTION_LEFT = 0x01,
+	CHANNEL_SELECTION_BOTH = 0x02
+};
+
+/**
+ * struct cg2900_dai_conf_i2s_pcm - Port configuration structure.
+ * @mode:		Operational mode of the port configured.
+ * @i2s_channel_sel:	I2S channels used. Only valid if used in I2S mode.
+ * @slot_0_used:	True if SCO slot 0 is used.
+ * @slot_1_used:	True if SCO slot 1 is used.
+ * @slot_2_used:	True if SCO slot 2 is used.
+ * @slot_3_used:	True if SCO slot 3 is used.
+ * @slot_0_dir:		Direction of slot 0.
+ * @slot_1_dir:		Direction of slot 1.
+ * @slot_2_dir:		Direction of slot 2.
+ * @slot_3_dir:		Direction of slot 3.
+ * @slot_0_start:	Slot 0 start (relative to the PCM frame sync).
+ * @slot_1_start:	Slot 1 start (relative to the PCM frame sync)
+ * @slot_2_start:	Slot 2 start (relative to the PCM frame sync)
+ * @slot_3_start:	Slot 3 start (relative to the PCM frame sync)
+ * @ratio:		Voice stream ratio between the Audio stream sample rate
+ *			and the Voice stream sample rate.
+ * @protocol:		Protocol used on port.
+ * @duration:		Frame sync duration.
+ * @clk:		Bit clock.
+ * @sample_rate:	Sample rate.
+ */
+struct cg2900_dai_conf_i2s_pcm {
+	enum cg2900_dai_mode mode;
+	enum cg2900_dai_channel_sel i2s_channel_sel;
+	bool slot_0_used;
+	bool slot_1_used;
+	bool slot_2_used;
+	bool slot_3_used;
+	enum cg2900_dai_dir slot_0_dir;
+	enum cg2900_dai_dir slot_1_dir;
+	enum cg2900_dai_dir slot_2_dir;
+	enum cg2900_dai_dir slot_3_dir;
+	__u8 slot_0_start;
+	__u8 slot_1_start;
+	__u8 slot_2_start;
+	__u8 slot_3_start;
+	enum cg2900_dai_stream_ratio ratio;
+	enum cg2900_dai_port_protocol protocol;
+	enum cg2900_dai_fs_duration duration;
+	enum cg2900_dai_bit_clk clk;
+	enum cg2900_dai_sample_rate sample_rate;
+};
+
+/**
+ * enum cg2900_dai_half_period - Half period duration alternatives.
+ * @HALF_PER_DUR_8:	8 Bits.
+ * @HALF_PER_DUR_16:	16 Bits.
+ * @HALF_PER_DUR_24:	24 Bits.
+ * @HALF_PER_DUR_25:	25 Bits.
+ * @HALF_PER_DUR_32:	32 Bits.
+ * @HALF_PER_DUR_48:	48 Bits.
+ * @HALF_PER_DUR_64:	64 Bits.
+ * @HALF_PER_DUR_75:	75 Bits.
+ * @HALF_PER_DUR_96:	96 Bits.
+ * @HALF_PER_DUR_128:	128 Bits.
+ * @HALF_PER_DUR_150:	150 Bits.
+ * @HALF_PER_DUR_192:	192 Bits.
+ *
+ * This parameter sets the number of bits contained in each I2S half period,
+ * i.e. each channel slot. A usual value is 16 bits.
+ */
+enum cg2900_dai_half_period {
+	HALF_PER_DUR_8 = 0x00,
+	HALF_PER_DUR_16 = 0x01,
+	HALF_PER_DUR_24 = 0x02,
+	HALF_PER_DUR_25 = 0x03,
+	HALF_PER_DUR_32 = 0x04,
+	HALF_PER_DUR_48 = 0x05,
+	HALF_PER_DUR_64 = 0x06,
+	HALF_PER_DUR_75 = 0x07,
+	HALF_PER_DUR_96 = 0x08,
+	HALF_PER_DUR_128 = 0x09,
+	HALF_PER_DUR_150 = 0x0A,
+	HALF_PER_DUR_192 = 0x0B
+};
+
+/**
+ * enum cg2900_dai_word_width - Word width alternatives.
+ * @WORD_WIDTH_16: 16 bits words.
+ * @WORD_WIDTH_32: 32 bits words.
+ */
+enum cg2900_dai_word_width {
+	WORD_WIDTH_16 = 0x00,
+	WORD_WIDTH_32 = 0x01
+};
+
+/**
+ * struct cg2900_dai_conf_i2s - Port configuration struct for I2S.
+ * @mode:		Operational mode of the port.
+ * @half_period:	Half period duration.
+ * @channel_sel:	Channel selection.
+ * @sample_rate:	Sample rate.
+ * @word_width:		Word width.
+ */
+struct cg2900_dai_conf_i2s {
+	enum cg2900_dai_mode			mode;
+	enum cg2900_dai_half_period		half_period;
+	enum cg2900_dai_channel_sel		channel_sel;
+	enum cg2900_dai_sample_rate		sample_rate;
+	enum cg2900_dai_word_width		word_width;
+};
+
+/**
+ * union cg2900_dai_port_conf - DAI port configuration union.
+ * @i2s: The configuration struct for a port supporting only I2S.
+ * @i2s_pcm: The configuration struct for a port supporting both PCM and I2S.
+ */
+union cg2900_dai_port_conf {
+	struct cg2900_dai_conf_i2s i2s;
+	struct cg2900_dai_conf_i2s_pcm i2s_pcm;
+};
+
+/**
+ * enum cg2900_dai_ext_port_id - DAI external port id alternatives.
+ * @PORT_0_I2S: Port id is 0 and it supports only I2S.
+ * @PORT_1_I2S_PCM: Port id is 1 and it supports both I2S and PCM.
+ */
+enum cg2900_dai_ext_port_id {
+	PORT_0_I2S,
+	PORT_1_I2S_PCM
+};
+
+/**
+ * enum cg2900_audio_endpoint_id - Audio endpoint id alternatives.
+ * @ENDPOINT_PORT_0_I2S:	Internal audio endpoint of the external I2S
+ *				interface.
+ * @ENDPOINT_PORT_1_I2S_PCM:	Internal audio endpoint of the external I2S/PCM
+ *				interface.
+ * @ENDPOINT_SLIMBUS_VOICE:	Internal audio endpoint of the external Slimbus
+ *				voice interface. (Currently not supported)
+ * @ENDPOINT_SLIMBUS_AUDIO:	Internal audio endpoint of the external Slimbus
+ *				audio interface. (Currently not supported)
+ * @ENDPOINT_BT_SCO_INOUT:	Bluetooth SCO bidirectional.
+ * @ENDPOINT_BT_A2DP_SRC:	Bluetooth A2DP source.
+ * @ENDPOINT_BT_A2DP_SNK:	Bluetooth A2DP sink.
+ * @ENDPOINT_FM_RX:		FM receive.
+ * @ENDPOINT_FM_TX:		FM transmit.
+ * @ENDPOINT_ANALOG_OUT:	Analog out.
+ * @ENDPOINT_DSP_AUDIO_IN:	DSP audio in.
+ * @ENDPOINT_DSP_AUDIO_OUT:	DSP audio out.
+ * @ENDPOINT_DSP_VOICE_IN:	DSP voice in.
+ * @ENDPOINT_DSP_VOICE_OUT:	DSP voice out.
+ * @ENDPOINT_DSP_TONE_IN:	DSP tone in.
+ * @ENDPOINT_BURST_BUFFER_IN:	Burst buffer in.
+ * @ENDPOINT_BURST_BUFFER_OUT:	Burst buffer out.
+ * @ENDPOINT_MUSIC_DECODER:	Music decoder.
+ * @ENDPOINT_HCI_AUDIO_IN:	HCI audio in.
+ */
+enum cg2900_audio_endpoint_id {
+	ENDPOINT_PORT_0_I2S,
+	ENDPOINT_PORT_1_I2S_PCM,
+	ENDPOINT_SLIMBUS_VOICE,
+	ENDPOINT_SLIMBUS_AUDIO,
+	ENDPOINT_BT_SCO_INOUT,
+	ENDPOINT_BT_A2DP_SRC,
+	ENDPOINT_BT_A2DP_SNK,
+	ENDPOINT_FM_RX,
+	ENDPOINT_FM_TX,
+	ENDPOINT_ANALOG_OUT,
+	ENDPOINT_DSP_AUDIO_IN,
+	ENDPOINT_DSP_AUDIO_OUT,
+	ENDPOINT_DSP_VOICE_IN,
+	ENDPOINT_DSP_VOICE_OUT,
+	ENDPOINT_DSP_TONE_IN,
+	ENDPOINT_BURST_BUFFER_IN,
+	ENDPOINT_BURST_BUFFER_OUT,
+	ENDPOINT_MUSIC_DECODER,
+	ENDPOINT_HCI_AUDIO_IN
+};
+
+/**
+ * struct cg2900_dai_config - Configuration struct for Digital Audio Interface.
+ * @port: The port id to configure. Acts as a discriminator for @conf parameter
+ *	  which is a union.
+ * @conf: The configuration union that contains the parameters for the port.
+ */
+struct cg2900_dai_config {
+	enum cg2900_dai_ext_port_id	port;
+	union cg2900_dai_port_conf	conf;
+};
+
+/*
+ * Endpoint configuration types
+ */
+
+/**
+ * enum cg2900_endpoint_sample_rate - Audio endpoint configuration sample rate alternatives.
+ *
+ * This enum defines the same values as @cg2900_dai_sample_rate, but
+ * is kept to preserve the API.
+ *
+ * @ENDPOINT_SAMPLE_RATE_8_KHZ: 8 kHz sample rate.
+ * @ENDPOINT_SAMPLE_RATE_16_KHZ: 16 kHz sample rate.
+ * @ENDPOINT_SAMPLE_RATE_44_1_KHZ: 44.1 kHz sample rate.
+ * @ENDPOINT_SAMPLE_RATE_48_KHZ: 48 kHz sample rate.
+ */
+enum cg2900_endpoint_sample_rate {
+	ENDPOINT_SAMPLE_RATE_8_KHZ	= SAMPLE_RATE_8,
+	ENDPOINT_SAMPLE_RATE_16_KHZ	= SAMPLE_RATE_16,
+	ENDPOINT_SAMPLE_RATE_44_1_KHZ	= SAMPLE_RATE_44_1,
+	ENDPOINT_SAMPLE_RATE_48_KHZ	= SAMPLE_RATE_48
+};
+
+
+/**
+ * struct cg2900_endpoint_config_a2dp_src - A2DP source audio endpoint configurations.
+ * @sample_rate: Sample rate.
+ * @channel_count: Number of channels.
+ */
+struct cg2900_endpoint_config_a2dp_src {
+	enum cg2900_endpoint_sample_rate	sample_rate;
+	unsigned int				channel_count;
+};
+
+/**
+ * struct cg2900_endpoint_config_fm - Configuration parameters for an FM endpoint.
+ * @sample_rate: The sample rate alternatives for the FM audio endpoints.
+ */
+struct cg2900_endpoint_config_fm {
+	enum cg2900_endpoint_sample_rate	sample_rate;
+};
+
+
+/**
+ * struct cg2900_endpoint_config_sco_in_out - SCO audio endpoint configuration structure.
+ * @sample_rate: Sample rate, valid values are
+ *		 * ENDPOINT_SAMPLE_RATE_8_KHZ
+ *		 * ENDPOINT_SAMPLE_RATE_16_KHZ.
+ */
+struct cg2900_endpoint_config_sco_in_out {
+	enum cg2900_endpoint_sample_rate	sample_rate;
+};
+
+/**
+ * union cg2900_endpoint_config - Different audio endpoint configurations.
+ * @sco:	SCO audio endpoint configuration structure.
+ * @a2dp_src:	A2DP source audio endpoint configuration structure.
+ * @fm:		FM audio endpoint configuration structure.
+ */
+union cg2900_endpoint_config_union {
+	struct cg2900_endpoint_config_sco_in_out	sco;
+	struct cg2900_endpoint_config_a2dp_src		a2dp_src;
+	struct cg2900_endpoint_config_fm		fm;
+};
+
+/**
+ * struct cg2900_endpoint_config - Audio endpoint configuration.
+ * @endpoint_id:	Identifies the audio endpoint. Works as a discriminator
+ *			for the config union.
+ * @config:		Union holding the configuration parameters for
+ *			the endpoint.
+ */
+struct cg2900_endpoint_config {
+	enum cg2900_audio_endpoint_id		endpoint_id;
+	union cg2900_endpoint_config_union	config;
+};
+
+#ifdef __KERNEL__
+#include <linux/device.h>
+
+int cg2900_audio_get_devices(struct device *devices[], __u8 size);
+int cg2900_audio_open(unsigned int *session, struct device *parent);
+int cg2900_audio_close(unsigned int *session);
+int cg2900_audio_set_dai_config(unsigned int session,
+				struct cg2900_dai_config *config);
+int cg2900_audio_get_dai_config(unsigned int session,
+				struct cg2900_dai_config *config);
+int cg2900_audio_config_endpoint(unsigned int session,
+				 struct cg2900_endpoint_config *config);
+int cg2900_audio_start_stream(unsigned int session,
+			      enum cg2900_audio_endpoint_id ep_1,
+			      enum cg2900_audio_endpoint_id ep_2,
+			      unsigned int *stream_handle);
+int cg2900_audio_stop_stream(unsigned int session,
+			     unsigned int stream_handle);
+
+#endif /* __KERNEL__ */
+#endif /* _CG2900_AUDIO_H_ */
diff --git a/drivers/staging/cg2900/include/cg2900_hci.h b/drivers/staging/cg2900/include/cg2900_hci.h
new file mode 100644
index 0000000..e094a9d
--- /dev/null
+++ b/drivers/staging/cg2900/include/cg2900_hci.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * This file is a staging solution and shall be integrated into
+ * /include/net/bluetooth/hci.h.
+ */
+
+#ifndef __CG2900_HCI_H
+#define __CG2900_HCI_H
+
+#define HCI_EV_HW_ERROR			0x10
+struct hci_ev_hw_error {
+	__u8	hw_code;
+} __packed;
+
+#endif /* __CG2900_HCI_H */
diff --git a/drivers/staging/cg2900/mfd/Makefile b/drivers/staging/cg2900/mfd/Makefile
new file mode 100644
index 0000000..bdbd8de
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/Makefile
@@ -0,0 +1,18 @@
+#
+# Makefile for ST-Ericsson CG2900 connectivity combo controller
+#
+
+ccflags-y :=					\
+	-Idrivers/staging/cg2900/include
+
+obj-$(CONFIG_CG2900)	+= cg2900_core.o cg2900_lib.o
+export-objs			:= cg2900_core.o cg2900_lib.o
+
+obj-$(CONFIG_CG2900)	+= cg2900_char_devices.o
+
+obj-$(CONFIG_CG2900_TEST)	+= cg2900_test.o
+
+obj-$(CONFIG_CG2900_CHIP)	+= cg2900_chip.o
+obj-$(CONFIG_STLC2690_CHIP)	+= stlc2690_chip.o
+
+obj-$(CONFIG_CG2900_AUDIO)	+= cg2900_audio.o
diff --git a/drivers/staging/cg2900/mfd/cg2900_audio.c b/drivers/staging/cg2900/mfd/cg2900_audio.c
new file mode 100755
index 0000000..2382f50
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_audio.c
@@ -0,0 +1,3533 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * Hemant Gupta (hemant.gupta@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth Audio Driver for ST-Ericsson CG2900 controller.
+ */
+#define NAME					"cg2900_audio"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include "cg2900.h"
+#include "cg2900_audio.h"
+#include "cg2900_chip.h"
+
+#define MAX_NBR_OF_USERS			10
+#define FIRST_USER				1
+
+/*
+ * This is a default ACL handle. It is necessary to provide to the chip, but
+ * does not actually do anything.
+ */
+#define DEFAULT_ACL_HANDLE			0x0001
+
+/* Use a timeout of 5 seconds when waiting for a command response */
+#define RESP_TIMEOUT				5000
+
+#define BT_DEV					(info->dev_bt)
+#define FM_DEV					(info->dev_fm)
+
+/* FM Set control conversion macros for CG2905/10 */
+#define CG2910_FM_CMD_SET_CTRL_48000_HEX	0x12C0
+#define CG2910_FM_CMD_SET_CTRL_44100_HEX	0x113A
+
+/* Bluetooth error codes */
+#define HCI_BT_ERROR_NO_ERROR			0x00
+
+/* Used to select proper API, ignoring subrevisions etc */
+enum chip_revision {
+	CG2900_CHIP_REV_PG1,
+	CG2900_CHIP_REV_PG2,
+	CG2905_CHIP_REV_PG1_05,
+	CG2905_CHIP_REV_PG2,
+	CG2910_CHIP_REV_PG1,
+	CG2910_CHIP_REV_PG2
+};
+
+/**
+ * enum chip_resp_state - State when communicating with the CG2900 controller.
+ * @IDLE:		No outstanding packets to the controller.
+ * @WAITING:		Packet has been sent to the controller. Waiting for
+ *			response.
+ * @RESP_RECEIVED:	Response from controller has been received but not yet
+ *			handled.
+ */
+enum chip_resp_state {
+	IDLE,
+	WAITING,
+	RESP_RECEIVED
+};
+
+/**
+ * enum main_state - Main state for the CG2900 Audio driver.
+ * @OPENED:	Audio driver has registered to CG2900 Core.
+ * @CLOSED:	Audio driver is not registered to CG2900 Core.
+ * @RESET:	A reset of CG2900 Core has occurred and no user has re-opened
+ *		the audio driver.
+ */
+enum main_state {
+	OPENED,
+	CLOSED,
+	RESET
+};
+
+/**
+ * struct endpoint_list - List for storing endpoint configuration nodes.
+ * @ep_list:		Pointer to first node in list.
+ * @management_mutex:	Mutex for handling access to list.
+ */
+struct endpoint_list {
+	struct list_head	ep_list;
+	struct mutex		management_mutex;
+};
+
+/**
+ * struct endpoint_config_node - Node for storing endpoint configuration.
+ * @list:		list_head struct.
+ * @endpoint_id:	Endpoint ID.
+ * @config:		Stored configuration for this endpoint.
+ */
+struct endpoint_config_node {
+	struct list_head			list;
+	enum cg2900_audio_endpoint_id		endpoint_id;
+	union cg2900_endpoint_config_union	config;
+};
+
+/**
+ * struct audio_info - Main CG2900 Audio driver info structure.
+ * @list:			list_head struct.
+ * @state:			Current state of the CG2900 Audio driver.
+ * @revision:			Chip revision, used to select API.
+ * @misc_dev:			The misc device created by this driver.
+ * @misc_registered:		True if misc device is registered.
+ * @parent:			Parent device.
+ * @dev_bt:			Device registered by this driver for the BT
+ *				audio channel.
+ * @dev_fm:			Device registered by this driver for the FM
+ *				audio channel.
+ * @filp:			Current char device file pointer.
+ * @management_mutex:		Mutex for handling access to CG2900 Audio driver
+ *				management.
+ * @bt_mutex:			Mutex for handling access to BT audio channel.
+ * @fm_mutex:			Mutex for handling access to FM audio channel.
+ * @nbr_of_users_active:	Number of sessions open in the CG2900 Audio
+ *				driver.
+ * @i2s_config:			DAI I2S configuration.
+ * @i2s_pcm_config:		DAI PCM_I2S configuration.
+ * @i2s_config_known:		@true if @i2s_config has been set,
+ *				@false otherwise.
+ * @i2s_pcm_config_known:	@true if @i2s_pcm_config has been set,
+ *				@false otherwise.
+ * @endpoints:			List containing the endpoint configurations.
+ * @stream_ids:			Bitmask for in-use stream ids (only used with
+ *				CG2900 PG2 onwards chip API).
+ */
+struct audio_info {
+	struct list_head		list;
+	enum main_state			state;
+	enum chip_revision		revision;
+	struct miscdevice		misc_dev;
+	bool				misc_registered;
+	struct device			*parent;
+	struct device			*dev_bt;
+	struct device			*dev_fm;
+	struct file			*filp;
+	struct mutex			management_mutex;
+	struct mutex			bt_mutex;
+	struct mutex			fm_mutex;
+	int				nbr_of_users_active;
+	struct cg2900_dai_conf_i2s	i2s_config;
+	struct cg2900_dai_conf_i2s_pcm	i2s_pcm_config;
+	bool				i2s_config_known;
+	bool				i2s_pcm_config_known;
+	struct endpoint_list		endpoints;
+	u8				stream_ids[16];
+};
+
+/**
+ * struct audio_user - CG2900 audio user info structure.
+ * @session:	Stored session for the char device.
+ * @resp_state:	State for controller communications.
+ * @info:	CG2900 audio info structure.
+ */
+struct audio_user {
+	int			session;
+	enum chip_resp_state	resp_state;
+	struct audio_info	*info;
+};
+
+/**
+ * struct audio_cb_info - Callback info structure registered in @user_data.
+ * @user:	Audio user currently awaiting data on the channel.
+ * @wq:		Wait queue for this channel.
+ * @skb_queue:	Sk buffer queue.
+ */
+struct audio_cb_info {
+	struct audio_user	*user;
+	wait_queue_head_t	wq;
+	struct sk_buff_head	skb_queue;
+};
+
+/**
+ * struct char_dev_info - CG2900 character device info structure.
+ * @session:		Stored session for the char device.
+ * @stored_data:	Data returned when executing last command, if any.
+ * @stored_data_len:	Length of @stored_data in bytes.
+ * @management_mutex:	Mutex for handling access to char dev management.
+ * @rw_mutex:		Mutex for handling access to char dev writes and reads.
+ * @info:		CG2900 audio info struct.
+ * @rx_queue:		Data queue.
+ */
+struct char_dev_info {
+	int			session;
+	u8			*stored_data;
+	int			stored_data_len;
+	struct mutex		management_mutex;
+	struct mutex		rw_mutex;
+	struct audio_info	*info;
+	struct sk_buff_head	rx_queue;
+};
+
+/*
+ * cg2900_audio_devices - List of active CG2900 audio devices.
+ */
+LIST_HEAD(cg2900_audio_devices);
+
+/*
+ * cg2900_audio_sessions - Pointers to currently opened sessions (maps
+ *			   session ID to user info).
+ */
+static struct audio_user *cg2900_audio_sessions[MAX_NBR_OF_USERS];
+
+/*
+ *	Internal conversion functions
+ *
+ *	Since the CG2900 APIs uses several different ways to encode the
+ *	same parameter in different cases, we have to use translator
+ *	functions.
+ */
+
+/**
+ * session_config_sample_rate() - Convert sample rate to format used in VS_Set_SessionConfiguration.
+ * @rate: Sample rate in API encoding.
+ */
+static u8 session_config_sample_rate(enum cg2900_endpoint_sample_rate rate)
+{
+	static const u8 codes[] = {
+		[ENDPOINT_SAMPLE_RATE_8_KHZ]    = CG2900_BT_SESSION_RATE_8K,
+		[ENDPOINT_SAMPLE_RATE_16_KHZ]   = CG2900_BT_SESSION_RATE_16K,
+		[ENDPOINT_SAMPLE_RATE_44_1_KHZ] = CG2900_BT_SESSION_RATE_44_1K,
+		[ENDPOINT_SAMPLE_RATE_48_KHZ]   = CG2900_BT_SESSION_RATE_48K
+	};
+
+	return codes[rate];
+}
+
+/**
+ * mc_i2s_sample_rate() - Convert sample rate to format used in VS_Port_Config for I2S.
+ * @rate: Sample rate in API encoding.
+ */
+static u8 mc_i2s_sample_rate(enum cg2900_dai_sample_rate rate)
+{
+	static const u8 codes[] = {
+		[SAMPLE_RATE_8]    = CG2900_MC_I2S_SAMPLE_RATE_8,
+		[SAMPLE_RATE_16]   = CG2900_MC_I2S_SAMPLE_RATE_16,
+		[SAMPLE_RATE_44_1] = CG2900_MC_I2S_SAMPLE_RATE_44_1,
+		[SAMPLE_RATE_48]   = CG2900_MC_I2S_SAMPLE_RATE_48
+	};
+
+	return codes[rate];
+}
+
+/**
+ * mc_pcm_sample_rate() - Convert sample rate to format used in VS_Port_Config for PCM/I2S.
+ * @rate: Sample rate in API encoding.
+ */
+static u8 mc_pcm_sample_rate(enum cg2900_dai_sample_rate rate)
+{
+	static const u8 codes[] = {
+		[SAMPLE_RATE_8]    = CG2900_MC_PCM_SAMPLE_RATE_8,
+		[SAMPLE_RATE_16]   = CG2900_MC_PCM_SAMPLE_RATE_16,
+		[SAMPLE_RATE_44_1] = CG2900_MC_PCM_SAMPLE_RATE_44_1,
+		[SAMPLE_RATE_48]   = CG2900_MC_PCM_SAMPLE_RATE_48
+	};
+
+	return codes[rate];
+}
+
+/**
+ * mc_i2s_channel_select() - Convert channel selection to format used in VS_Port_Config.
+ * @sel: Channel selection in API encoding.
+ */
+static u8 mc_i2s_channel_select(enum cg2900_dai_channel_sel sel)
+{
+	static const u8 codes[] = {
+		[CHANNEL_SELECTION_RIGHT] = CG2900_MC_I2S_RIGHT_CHANNEL,
+		[CHANNEL_SELECTION_LEFT]  = CG2900_MC_I2S_LEFT_CHANNEL,
+		[CHANNEL_SELECTION_BOTH]  = CG2900_MC_I2S_BOTH_CHANNELS
+	};
+	return codes[sel];
+}
+
+/**
+ * get_fs_duration() - Convert framesync-enumeration to real value.
+ * @duration: Framsync duration (API encoding).
+ *
+ * Returns:
+ * Duration in bits.
+ */
+static u16 get_fs_duration(enum cg2900_dai_fs_duration duration)
+{
+	static const u16 values[] = {
+		[SYNC_DURATION_8] = 8,
+		[SYNC_DURATION_16] = 16,
+		[SYNC_DURATION_24] = 24,
+		[SYNC_DURATION_32] = 32,
+		[SYNC_DURATION_48] = 48,
+		[SYNC_DURATION_50] = 50,
+		[SYNC_DURATION_64] = 64,
+		[SYNC_DURATION_75] = 75,
+		[SYNC_DURATION_96] = 96,
+		[SYNC_DURATION_125] = 125,
+		[SYNC_DURATION_128] = 128,
+		[SYNC_DURATION_150] = 150,
+		[SYNC_DURATION_192] = 192,
+		[SYNC_DURATION_250] = 250,
+		[SYNC_DURATION_256] = 256,
+		[SYNC_DURATION_300] = 300,
+		[SYNC_DURATION_384] = 384,
+		[SYNC_DURATION_500] = 500,
+		[SYNC_DURATION_512] = 512,
+		[SYNC_DURATION_600] = 600,
+		[SYNC_DURATION_768] = 768
+	};
+	return values[duration];
+}
+
+/**
+ * mc_i2s_role() - Convert master/slave encoding to format for I2S-ports.
+ * @mode: Master/slave in API encoding.
+ */
+static u8 mc_i2s_role(enum cg2900_dai_mode mode)
+{
+	if (mode == DAI_MODE_SLAVE)
+		return CG2900_I2S_MODE_SLAVE;
+	else
+		return CG2900_I2S_MODE_MASTER;
+}
+
+/**
+ * mc_pcm_role() - Convert master/slave encoding to format for PCM/I2S-port.
+ * @mode: Master/slave in API encoding.
+ */
+static u8 mc_pcm_role(enum cg2900_dai_mode mode)
+{
+	if (mode == DAI_MODE_SLAVE)
+		return CG2900_PCM_MODE_SLAVE;
+	else
+		return CG2900_PCM_MODE_MASTER;
+}
+
+/**
+ * fm_get_conversion() - Convert sample rate to convert up/down used in X_Set_Control FM commands.
+ * @srate: Sample rate.
+ */
+static u16 fm_get_conversion(struct audio_info *info,
+		enum cg2900_endpoint_sample_rate srate)
+{
+	/*
+	 * For CG2910, Set the external sample rate (host side)
+	 * of the digital output in units of [10Hz]
+	 */
+	if (info->revision == CG2900_CHIP_REV_PG1 ||
+			info->revision == CG2900_CHIP_REV_PG2) {
+		if (srate >= ENDPOINT_SAMPLE_RATE_44_1_KHZ)
+			return CG2900_FM_CMD_SET_CTRL_CONV_UP;
+		else
+			return CG2900_FM_CMD_SET_CTRL_CONV_DOWN;
+	} else {
+		if (srate > ENDPOINT_SAMPLE_RATE_44_1_KHZ)
+			return CG2910_FM_CMD_SET_CTRL_48000_HEX;
+		else
+			return CG2910_FM_CMD_SET_CTRL_44100_HEX;
+	}
+}
+
+/**
+ * get_info() - Return info structure for this device.
+ * @dev:	Current device.
+ *
+ * This function returns the info structure on the following basis:
+ *	* If dev is NULL return first info struct found. If none is found return
+ *	  NULL.
+ *	* If dev is valid we will return corresponding info struct if dev is the
+ *	  parent of the info struct or if dev's parent is the parent of the info
+ *	  struct.
+ *	* If dev is valid and no info structure is found, a new info struct is
+ *	  allocated, initialized, and returned.
+ *
+ * Returns:
+ *   Pointer to info struct if there is no error.
+ *   NULL if NULL was supplied and no info structure exist.
+ *   ERR_PTR(-ENOMEM) if allocation fails.
+ */
+static struct audio_info *get_info(struct device *dev)
+{
+	struct list_head *cursor;
+	struct audio_info *tmp;
+	struct audio_info *info = NULL;
+
+	/*
+	 * Find the info structure for dev. If NULL is supplied for dev
+	 * just return first device found.
+	 */
+	list_for_each(cursor, &cg2900_audio_devices) {
+		tmp = list_entry(cursor, struct audio_info, list);
+		if (!dev || tmp->parent == dev->parent || tmp->parent == dev) {
+			info = tmp;
+			break;
+		}
+	}
+
+	if (!dev || info)
+		return info;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev, "Could not allocate info struct\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	info->parent = dev->parent;
+
+	/* Initiate the mutexes */
+	mutex_init(&(info->management_mutex));
+	mutex_init(&(info->bt_mutex));
+	mutex_init(&(info->fm_mutex));
+	mutex_init(&(info->endpoints.management_mutex));
+
+	/* Initiate the endpoint list */
+	INIT_LIST_HEAD(&info->endpoints.ep_list);
+
+	list_add_tail(&info->list, &cg2900_audio_devices);
+
+	dev_info(dev, "CG2900 device added\n");
+	return info;
+}
+
+/**
+ * flush_endpoint_list() - Deletes all stored endpoints in @list.
+ * @list:	List of endpoints.
+ */
+static void flush_endpoint_list(struct endpoint_list *list)
+{
+	struct list_head *cursor, *next;
+	struct endpoint_config_node *tmp;
+
+	mutex_lock(&list->management_mutex);
+	list_for_each_safe(cursor, next, &(list->ep_list)) {
+		tmp = list_entry(cursor, struct endpoint_config_node, list);
+		list_del(cursor);
+		kfree(tmp);
+	}
+	mutex_unlock(&list->management_mutex);
+}
+
+/**
+ * device_removed() - Remove device from list if there are no channels left.
+ * @info:	CG2900 audio info structure.
+ */
+static void device_removed(struct audio_info *info)
+{
+	struct list_head *cursor;
+	struct audio_info *tmp;
+
+	if (info->dev_bt || info->dev_fm)
+		/* There are still devices active */
+		return;
+
+	/* Find the stored info structure */
+	list_for_each(cursor, &cg2900_audio_devices) {
+		tmp = list_entry(cursor, struct audio_info, list);
+		if (tmp == info) {
+			list_del(cursor);
+			break;
+		}
+	}
+
+	flush_endpoint_list(&info->endpoints);
+
+	mutex_destroy(&info->management_mutex);
+	mutex_destroy(&info->bt_mutex);
+	mutex_destroy(&info->fm_mutex);
+	mutex_destroy(&info->endpoints.management_mutex);
+
+	kfree(info);
+	pr_info("CG2900 Audio device removed");
+}
+
+/**
+ * read_cb() - Handle data received from STE connectivity driver.
+ * @dev:	Device receiving data.
+ * @skb:	Buffer with data coming form device.
+ */
+static void read_cb(struct cg2900_user_data *dev, struct sk_buff *skb)
+{
+	struct audio_cb_info *cb_info;
+
+	cb_info = cg2900_get_usr(dev);
+
+	if (!(cb_info->user)) {
+		dev_err(dev->dev, "NULL supplied as cb_info->user\n");
+		return;
+	}
+
+	/* Mark that packet has been received */
+	dev_dbg(dev->dev, "New resp_state: RESP_RECEIVED");
+	cb_info->user->resp_state = RESP_RECEIVED;
+	skb_queue_tail(&cb_info->skb_queue, skb);
+	wake_up_all(&cb_info->wq);
+}
+
+/**
+ * reset_cb() - Reset callback function.
+ * @dev:	CG2900_Core device resetting.
+ */
+static void reset_cb(struct cg2900_user_data *dev)
+{
+	struct audio_info *info;
+
+	dev_dbg(dev->dev, "reset_cb\n");
+
+	info = dev_get_drvdata(dev->dev);
+	mutex_lock(&info->management_mutex);
+	info->nbr_of_users_active = 0;
+	info->state = RESET;
+	mutex_unlock(&info->management_mutex);
+}
+
+/**
+ * get_session_user() - Check that supplied session is within valid range.
+ * @session:	Session ID.
+ *
+ * Returns:
+ *   Audio_user if there is no error.
+ *   NULL for bad session ID.
+ */
+static struct audio_user *get_session_user(int session)
+{
+	struct audio_user *audio_user;
+
+	if (session < FIRST_USER || session >= MAX_NBR_OF_USERS) {
+		pr_err("Calling with invalid session %d", session);
+		return NULL;
+	}
+
+	audio_user = cg2900_audio_sessions[session];
+	if (!audio_user)
+		pr_err("Calling with non-opened session %d", session);
+	return audio_user;
+}
+
+/**
+ * del_endpoint_private() - Deletes an endpoint from @list.
+ * @endpoint_id:	Endpoint ID.
+ * @list:		List of endpoints.
+ *
+ * Deletes an endpoint from the supplied endpoint list.
+ * This function is not protected by any semaphore.
+ */
+static void del_endpoint_private(enum cg2900_audio_endpoint_id endpoint_id,
+				 struct endpoint_list *list)
+{
+	struct list_head *cursor, *next;
+	struct endpoint_config_node *tmp;
+
+	list_for_each_safe(cursor, next, &(list->ep_list)) {
+		tmp = list_entry(cursor, struct endpoint_config_node, list);
+		if (tmp->endpoint_id == endpoint_id) {
+			list_del(cursor);
+			kfree(tmp);
+		}
+	}
+}
+
+/**
+ * add_endpoint() - Add endpoint node to @list.
+ * @ep_config:	Endpoint configuration.
+ * @list:	List of endpoints.
+ *
+ * Add endpoint node to the supplied list and copies supplied config to node.
+ * If a node already exists for the supplied endpoint, the old node is removed
+ * and replaced by the new node.
+ */
+static void add_endpoint(struct cg2900_endpoint_config *ep_config,
+			 struct endpoint_list *list)
+{
+	struct endpoint_config_node *item;
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		pr_err("add_endpoint: Failed to alloc memory");
+		return;
+	}
+
+	/* Store values */
+	item->endpoint_id = ep_config->endpoint_id;
+	memcpy(&(item->config), &(ep_config->config), sizeof(item->config));
+
+	mutex_lock(&(list->management_mutex));
+
+	/*
+	 * Check if endpoint ID already exist in list.
+	 * If that is the case, remove it.
+	 */
+	if (!list_empty(&(list->ep_list)))
+		del_endpoint_private(ep_config->endpoint_id, list);
+
+	list_add_tail(&(item->list), &(list->ep_list));
+
+	mutex_unlock(&(list->management_mutex));
+}
+
+/**
+ * find_endpoint() - Finds endpoint identified by @endpoint_id in @list.
+ * @endpoint_id:	Endpoint ID.
+ * @list:		List of endpoints.
+ *
+ * Returns:
+ *   Endpoint configuration if there is no error.
+ *   NULL if no configuration can be found for @endpoint_id.
+ */
+static union cg2900_endpoint_config_union *
+find_endpoint(enum cg2900_audio_endpoint_id endpoint_id,
+	      struct endpoint_list *list)
+{
+	struct list_head *cursor, *next;
+	struct endpoint_config_node *tmp;
+	struct endpoint_config_node *ret_ep = NULL;
+
+	mutex_lock(&list->management_mutex);
+	list_for_each_safe(cursor, next, &(list->ep_list)) {
+		tmp = list_entry(cursor, struct endpoint_config_node, list);
+		if (tmp->endpoint_id == endpoint_id) {
+			ret_ep = tmp;
+			break;
+		}
+	}
+	mutex_unlock(&list->management_mutex);
+
+	if (ret_ep)
+		return &(ret_ep->config);
+	else
+		return NULL;
+}
+
+/**
+ * new_stream_id() - Allocate a new stream id.
+ * @info:	Current audio info struct.
+ *
+ * Returns:
+ *  0-127 new valid id.
+ *  -ENOMEM if no id is available.
+ */
+static s8 new_stream_id(struct audio_info *info)
+{
+	int r;
+
+	mutex_lock(&info->management_mutex);
+
+	r = find_first_zero_bit((const unsigned long *)info->stream_ids,
+				8 * sizeof(info->stream_ids));
+
+	if (r >= 8 * sizeof(info->stream_ids)) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	set_bit(r, (unsigned long int *)info->stream_ids);
+
+out:
+	mutex_unlock(&info->management_mutex);
+	return r;
+}
+
+/**
+ * release_stream_id() - Release a stream id.
+ * @info:	Current audio info struct.
+ * @id:		Stream to release.
+ */
+static void release_stream_id(struct audio_info *info, u8 id)
+{
+	if (id >= 8 * sizeof(info->stream_ids))
+		return;
+
+	mutex_lock(&info->management_mutex);
+	clear_bit(id, (unsigned long int *)info->stream_ids);
+	mutex_unlock(&info->management_mutex);
+}
+
+/**
+ * receive_fm_write_response() - Wait for and handle the response to an FM Legacy WriteCommand request.
+ * @audio_user:	Audio user to check for.
+ * @command:	FM command to wait for.
+ *
+ * This function first waits (up to 5 seconds) for a response to an FM
+ * write command and when one arrives, it checks that it is the one we
+ * are waiting for and also that no error has occurred.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -EIO for other errors.
+ */
+static int receive_fm_write_response(struct audio_user *audio_user,
+				     u16 command)
+{
+	int err = 0;
+	int res;
+	struct sk_buff *skb;
+	struct fm_leg_cmd_cmpl *pkt;
+	u16 rsp_cmd;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = audio_user->info;
+	pf_data = dev_get_platdata(info->dev_fm);
+	cb_info = cg2900_get_usr(pf_data);
+
+	/*
+	 * Wait for callback to receive command complete and then wake us up
+	 * again.
+	 */
+	res = wait_event_timeout(cb_info->wq,
+				 audio_user->resp_state == RESP_RECEIVED,
+				 msecs_to_jiffies(RESP_TIMEOUT));
+	if (!res) {
+		dev_err(FM_DEV, "Timeout while waiting for return packet\n");
+		return -ECOMM;
+	} else if (res < 0) {
+		dev_err(FM_DEV,
+			"Error %d occurred while waiting for return packet\n",
+			res);
+		return -ECOMM;
+	}
+
+	/* OK, now we should have received answer. Let's check it. */
+	skb = skb_dequeue_tail(&cb_info->skb_queue);
+	if (!skb) {
+		dev_err(FM_DEV, "No skb in queue when it should be there\n");
+		return -EIO;
+	}
+
+	pkt = (struct fm_leg_cmd_cmpl *)skb->data;
+
+	/* Check if we received the correct event */
+	if (pkt->opcode != CG2900_FM_GEN_ID_LEGACY) {
+		dev_err(FM_DEV,
+			"Received unknown FM packet. 0x%X %X %X %X %X\n",
+			skb->data[0], skb->data[1], skb->data[2],
+			skb->data[3], skb->data[4]);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	/* FM Legacy Command complete event */
+	rsp_cmd = cg2900_get_fm_cmd_id(le16_to_cpu(pkt->response_head));
+
+	if (pkt->fm_function != CG2900_FM_CMD_PARAM_WRITECOMMAND ||
+	    rsp_cmd != command) {
+		dev_err(FM_DEV,
+			"Received unexpected packet func 0x%X cmd 0x%04X\n",
+			pkt->fm_function, rsp_cmd);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	if (pkt->cmd_status != CG2900_FM_CMD_STATUS_COMMAND_SUCCEEDED) {
+		dev_err(FM_DEV, "FM Command failed (%d)\n", pkt->cmd_status);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+	/* Operation succeeded. We are now done */
+
+error_handling_free_skb:
+	kfree_skb(skb);
+	return err;
+}
+
+/**
+ * receive_bt_cmd_complete() - Wait for and handle an BT Command Complete event.
+ * @audio_user:	Audio user to check for.
+ * @rsp:	Opcode of BT command to wait for.
+ * @data:	Pointer to buffer if any received data should be stored (except
+ *		status).
+ * @data_len:	Length of @data in bytes.
+ *
+ * This function first waits for BT Command Complete event (up to 5 seconds)
+ * and when one arrives, it checks that it is the one we are waiting for and
+ * also that no error has occurred.
+ * If @data is supplied it also copies received data into @data.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -EIO for other errors.
+ */
+static int receive_bt_cmd_complete(struct audio_user *audio_user, u16 rsp,
+				   void *data, int data_len)
+{
+	int err = 0;
+	int res;
+	struct sk_buff *skb;
+	struct bt_cmd_cmpl_event *evt;
+	u16 opcode;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = audio_user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	/*
+	 * Wait for callback to receive command complete and then wake us up
+	 * again.
+	 */
+	res = wait_event_timeout(cb_info->wq,
+				 audio_user->resp_state == RESP_RECEIVED,
+				 msecs_to_jiffies(RESP_TIMEOUT));
+	if (!res) {
+		dev_err(BT_DEV, "Timeout while waiting for return packet\n");
+		return -ECOMM;
+	} else if (res < 0) {
+		/* We timed out or an error occurred */
+		dev_err(BT_DEV,
+			"Error %d occurred while waiting for return packet\n",
+			res);
+		return -ECOMM;
+	}
+
+	/* OK, now we should have received answer. Let's check it. */
+	skb = skb_dequeue_tail(&cb_info->skb_queue);
+	if (!skb) {
+		dev_err(BT_DEV, "No skb in queue when it should be there\n");
+		return -EIO;
+	}
+
+	evt = (struct bt_cmd_cmpl_event *)skb->data;
+	if (evt->eventcode != HCI_EV_CMD_COMPLETE) {
+		dev_err(BT_DEV,
+			"We did not receive the event we expected (0x%X)\n",
+			evt->eventcode);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	opcode = le16_to_cpu(evt->opcode);
+	if (opcode != rsp) {
+		dev_err(BT_DEV,
+			"Received cmd complete for unexpected command: "
+			"0x%04X\n", opcode);
+		err = -EIO;
+		goto error_handling_free_skb;
+	}
+
+	if (evt->status != HCI_BT_ERROR_NO_ERROR) {
+		dev_err(BT_DEV, "Received command complete with err %d\n",
+			evt->status);
+		err = -EIO;
+		/*
+		* In data there might be more detailed error code.
+		* Let's copy it.
+		*/
+	}
+
+	/*
+	 * Copy the rest of the parameters if a buffer has been supplied.
+	 * The caller must have set the length correctly.
+	 */
+	if (data)
+		memcpy(data, evt->data, data_len);
+
+	/* Operation succeeded. We are now done */
+
+error_handling_free_skb:
+	kfree_skb(skb);
+	return err;
+}
+
+/**
+ * send_vs_delete_stream() - Delete an audio stream defined by @stream_handle.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	Handle of the audio stream.
+ *
+ * This function is used to delete an audio stream defined by a stream
+ * handle.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   Errors from @cg2900_write.
+ *   -EIO for other errors.
+ */
+static int send_vs_delete_stream(struct audio_user *audio_user,
+			    unsigned int stream_handle)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	u16 opcode;
+	struct audio_info *info = audio_user->info;
+	struct cg2900_user_data *pf_data = dev_get_platdata(info->dev_bt);
+	struct audio_cb_info *cb_info = cg2900_get_usr(pf_data);
+
+	/* Now delete the stream - format command... */
+	if (info->revision == CG2900_CHIP_REV_PG1) {
+		struct bt_vs_reset_session_cfg_cmd *cmd;
+
+		dev_dbg(BT_DEV, "BT: HCI_VS_Reset_Session_Configuration\n");
+
+		skb = pf_data->alloc_skb(sizeof(*cmd), GFP_KERNEL);
+		if (!skb) {
+			dev_err(BT_DEV, "Could not allocate skb\n");
+			err = -ENOMEM;
+			return err;
+		}
+
+		cmd = (struct bt_vs_reset_session_cfg_cmd *)
+			skb_put(skb, sizeof(*cmd));
+
+		opcode = CG2900_BT_VS_RESET_SESSION_CONFIG;
+		cmd->opcode = cpu_to_le16(opcode);
+		cmd->plen   = BT_PARAM_LEN(sizeof(*cmd));
+		cmd->id     = (u8)stream_handle;
+	} else {
+		struct mc_vs_delete_stream_cmd *cmd;
+
+		dev_dbg(BT_DEV, "BT: HCI_VS_Delete_Stream\n");
+
+		skb = pf_data->alloc_skb(sizeof(*cmd), GFP_KERNEL);
+		if (!skb) {
+			dev_err(BT_DEV, "Could not allocate skb\n");
+			err = -ENOMEM;
+			return err;
+		}
+
+		cmd = (struct mc_vs_delete_stream_cmd *)
+			skb_put(skb, sizeof(*cmd));
+
+		opcode = CG2900_MC_VS_DELETE_STREAM;
+		cmd->opcode = cpu_to_le16(opcode);
+		cmd->plen   = BT_PARAM_LEN(sizeof(*cmd));
+		cmd->stream = (u8)stream_handle;
+	}
+
+	/* ...and send it */
+	cb_info->user = audio_user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	audio_user->resp_state = WAITING;
+
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		goto error_handling_free_skb;
+	}
+
+	/* wait for response */
+	if (info->revision == CG2900_CHIP_REV_PG1) {
+		err = receive_bt_cmd_complete(audio_user, opcode, NULL, 0);
+	} else {
+		u8 vs_err;
+
+		/* All commands on CG2900 PG2 onwards
+		 * API returns one byte extra status */
+		err = receive_bt_cmd_complete(audio_user, opcode,
+					      &vs_err, sizeof(vs_err));
+
+	if (err)
+		dev_err(BT_DEV,
+			"VS_DELETE_STREAM - failed with error 0x%02X\n",
+			vs_err);
+		else
+			release_stream_id(info, stream_handle);
+	}
+
+	return err;
+
+error_handling_free_skb:
+	kfree_skb(skb);
+	return err;
+}
+
+/**
+ * send_vs_session_ctrl() - Formats an sends a CG2900_BT_VS_SESSION_CTRL command.
+ * @user:		Audio user this command belongs to.
+ * @stream_handle:	Handle to stream.
+ * @command:		Command to execute on stream, should be one of
+ *			CG2900_BT_SESSION_START, CG2900_BT_SESSION_STOP,
+ *			CG2900_BT_SESSION_PAUSE, CG2900_BT_SESSION_RESUME.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_session_ctrl(struct audio_user *user,
+				u8 stream_handle, u8 command)
+{
+	int err = 0;
+	struct bt_vs_session_ctrl_cmd *pkt;
+	struct sk_buff *skb;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "BT: HCI_VS_Session_Control handle: %d cmd: %d\n",
+		stream_handle, command);
+
+	skb = pf_data->alloc_skb(sizeof(*pkt), GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV,
+			"send_vs_session_ctrl: Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	/* Enter data into the skb */
+	pkt = (struct bt_vs_session_ctrl_cmd *) skb_put(skb, sizeof(*pkt));
+
+	pkt->opcode  = cpu_to_le16(CG2900_BT_VS_SESSION_CTRL);
+	pkt->plen    = BT_PARAM_LEN(sizeof(*pkt));
+	pkt->id      = stream_handle;
+	pkt->control = command; /* Start/stop etc */
+
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	err = receive_bt_cmd_complete(user, CG2900_BT_VS_SESSION_CTRL,
+				      NULL, 0);
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_vs_session_config() - Formats an sends a CG2900_BT_VS_SESSION_CONFIG command.
+ * @user:		Audio user this command belongs to.
+ * @config_stream:	Custom function for configuring the stream.
+ * @priv_data:		Private data passed to @config_stream untouched.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * Space is allocated for one stream and a custom function is used to
+ * fill in the stream configuration.
+ *
+ * Returns:
+ *  0-255 stream handle if no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_session_config(struct audio_user *user,
+	void(*config_stream)(struct audio_info *, void *,
+			     struct session_config_stream *),
+	void *priv_data)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct bt_vs_session_config_cmd *pkt;
+	u8 session_id;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "BT: HCI_VS_Set_Session_Configuration\n");
+
+	skb = pf_data->alloc_skb(sizeof(*pkt), GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV,
+			"send_vs_session_config: Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	pkt = (struct bt_vs_session_config_cmd *)skb_put(skb, sizeof(*pkt));
+	/* zero the packet so we don't have to set all reserved fields */
+	memset(pkt, 0, sizeof(*pkt));
+
+	/* Common parameters */
+	pkt->opcode    = cpu_to_le16(CG2900_BT_VS_SET_SESSION_CONFIG);
+	pkt->plen      = BT_PARAM_LEN(sizeof(*pkt));
+	pkt->n_streams = 1; /* 1 stream configuration supplied */
+
+	/* Let the custom-function fill in the rest */
+	config_stream(info, priv_data, &pkt->stream);
+
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	err = receive_bt_cmd_complete(user,
+				      CG2900_BT_VS_SET_SESSION_CONFIG,
+				      &session_id, sizeof(session_id));
+	/* Return session id/stream handle if success */
+	if (!err)
+		err = session_id;
+
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_fm_write_1_param() - Formats and sends an FM legacy write command with one parameter.
+ * @user:	Audio user this command belongs to.
+ * @command:	Command.
+ * @param:	Parameter for command.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the fm_mutex held.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_fm_write_1_param(struct audio_user *user,
+				 u16 command, u16 param)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct fm_leg_cmd *cmd;
+	size_t len;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_fm);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(FM_DEV, "send_fm_write_1_param cmd 0x%X param 0x%X\n",
+		command, param);
+
+	/* base package + one parameter */
+	len = sizeof(*cmd) + sizeof(cmd->fm_cmd.data[0]);
+
+	skb = pf_data->alloc_skb(len, GFP_KERNEL);
+	if (!skb) {
+		dev_err(FM_DEV,
+			"send_fm_write_1_param: Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	cmd = (struct fm_leg_cmd *)skb_put(skb, len);
+
+	cmd->length      = CG2900_FM_CMD_PARAM_LEN(len);
+	cmd->opcode      = CG2900_FM_GEN_ID_LEGACY;
+	cmd->read_write  = CG2900_FM_CMD_LEG_PARAM_WRITE;
+	cmd->fm_function = CG2900_FM_CMD_PARAM_WRITECOMMAND;
+	/* one parameter - builtin assumption for this function */
+	cmd->fm_cmd.head    = cpu_to_le16(cg2900_make_fm_cmd_id(command, 1));
+	cmd->fm_cmd.data[0] = cpu_to_le16(param);
+
+	cb_info->user = user;
+	dev_dbg(FM_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(FM_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	err = receive_fm_write_response(user, command);
+finished:
+	dev_dbg(FM_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_vs_stream_ctrl() - Formats an sends a CG2900_MC_VS_STREAM_CONTROL command.
+ * @user:	Audio user this command belongs to.
+ * @stream:	Stream id.
+ * @command:	Start/stop etc.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * While the HCI command allows for multiple streams in one command,
+ * this function only handles one.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_stream_ctrl(struct audio_user *user, u8 stream, u8 command)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct mc_vs_stream_ctrl_cmd *cmd;
+	size_t len;
+	u8 vs_err;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "send_vs_stream_ctrl stream %d command %d\n", stream,
+		command);
+
+	/* basic length + one stream */
+	len = sizeof(*cmd) + sizeof(cmd->stream[0]);
+
+	skb = pf_data->alloc_skb(len, GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV, "send_vs_stream_ctrl:Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	cmd = (struct mc_vs_stream_ctrl_cmd *)skb_put(skb, len);
+
+	cmd->opcode  = cpu_to_le16(CG2900_MC_VS_STREAM_CONTROL);
+	cmd->plen    = BT_PARAM_LEN(len);
+	cmd->command = command;
+
+	/* one stream */
+	cmd->n_streams  = 1;
+	cmd->stream[0] = stream;
+
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	/* All commands on CG2900 PG2 onwards
+	 * API returns one byte extra status */
+	err = receive_bt_cmd_complete(user,
+				      CG2900_MC_VS_STREAM_CONTROL,
+				      &vs_err, sizeof(vs_err));
+	if (err)
+		dev_err(BT_DEV,
+			"VS_STREAM_CONTROL - failed with error 0x%02x\n",
+			vs_err);
+
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_vs_create_stream() - Formats an sends a CG2900_MC_VS_CREATE_STREAM command.
+ * @user:	Audio user this command belongs to.
+ * @inport:	Stream id.
+ * @outport:	Start/stop etc.
+ * @order:	Activation order.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_create_stream(struct audio_user *user, u8 inport,
+				 u8 outport, u8 order)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct mc_vs_create_stream_cmd *cmd;
+	s8 id;
+	u8 vs_err;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV,
+		"send_vs_create_stream inport %d outport %d order %d\n",
+		inport, outport, order);
+
+	id = new_stream_id(info);
+	if (id < 0) {
+		dev_err(BT_DEV, "No free stream id\n");
+		err = -EIO;
+		goto finished;
+	}
+
+	skb = pf_data->alloc_skb(sizeof(*cmd), GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV,
+			"send_vs_create_stream: Could not allocate skb\n");
+		err = -ENOMEM;
+		goto finished_release_id;
+	}
+
+	cmd = (struct mc_vs_create_stream_cmd *)skb_put(skb, sizeof(*cmd));
+
+	cmd->opcode  = cpu_to_le16(CG2900_MC_VS_CREATE_STREAM);
+	cmd->plen    = BT_PARAM_LEN(sizeof(*cmd));
+	cmd->id      = (u8)id;
+	cmd->inport  = inport;
+	cmd->outport = outport;
+	cmd->order   = order;
+
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished_release_id;
+	}
+
+	/* All commands on CG2900 PG2 onwards
+	 * API returns one byte extra status */
+	err = receive_bt_cmd_complete(user,
+				      CG2900_MC_VS_CREATE_STREAM,
+				      &vs_err, sizeof(vs_err));
+	if (err) {
+		dev_err(BT_DEV,
+			"VS_CREATE_STREAM - failed with error 0x%02x\n",
+			vs_err);
+		goto finished_release_id;
+	}
+
+	err = id;
+	goto finished;
+
+finished_release_id:
+	release_stream_id(info, id);
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * send_vs_port_cfg() - Formats an sends a CG2900_MC_VS_PORT_CONFIG command.
+ * @user:	Audio user this command belongs to.
+ * @port:	Port id to configure.
+ * @cfg:	Pointer to specific configuration.
+ * @cfglen:	Length of configuration.
+ *
+ * Packs and sends a command packet and waits for the response. Must
+ * be called with the bt_mutex held.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int send_vs_port_cfg(struct audio_user *user, u8 port,
+			    const void *cfg, size_t cfglen)
+{
+	int err = 0;
+	struct sk_buff *skb;
+	struct mc_vs_port_cfg_cmd *cmd;
+	void *ptr;
+	u8 vs_err;
+	struct audio_cb_info *cb_info;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data;
+
+	info = user->info;
+	pf_data = dev_get_platdata(info->dev_bt);
+	cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "send_vs_port_cfg len %d\n", (int)cfglen);
+
+	skb = pf_data->alloc_skb(sizeof(*cmd) + cfglen, GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV, "send_vs_port_cfg: Could not allocate skb\n");
+		return -ENOMEM;
+	}
+
+	/* Fill in common part */
+	cmd = (struct mc_vs_port_cfg_cmd *) skb_put(skb, sizeof(*cmd));
+	cmd->opcode = cpu_to_le16(CG2900_MC_VS_PORT_CONFIG);
+	cmd->plen = BT_PARAM_LEN(sizeof(*cmd) + cfglen);
+	cmd->type = port;
+
+	/* Copy specific configuration */
+	ptr = skb_put(skb, cfglen);
+	memcpy(ptr, cfg, cfglen);
+
+	/* Send */
+	cb_info->user = user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	user->resp_state = WAITING;
+
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		kfree_skb(skb);
+		goto finished;
+	}
+
+	/* All commands on CG2900 PG2 onwards
+	 * API returns one byte extra status */
+	err = receive_bt_cmd_complete(user, CG2900_MC_VS_PORT_CONFIG,
+				      &vs_err, sizeof(vs_err));
+	if (err)
+		dev_err(BT_DEV, "VS_PORT_CONFIG - failed with error 0x%02x\n",
+			vs_err);
+
+finished:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	user->resp_state = IDLE;
+	return err;
+}
+
+/**
+ * set_dai_config_pg1() - Internal implementation of @cg2900_audio_set_dai_config for PG1 hardware.
+ * @audio_user:	Pointer to audio user struct.
+ * @config:	Pointer to the configuration to set.
+ *
+ * Sets the Digital Audio Interface (DAI) configuration for PG1
+ * hardware. This is and internal function and basic
+ * argument-verification should have been done by the caller.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -EACCESS if port is not supported.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int set_dai_config_pg1(struct audio_user *audio_user,
+			      struct cg2900_dai_config *config)
+{
+	int err = 0;
+	struct cg2900_dai_conf_i2s_pcm *i2s_pcm;
+	struct sk_buff *skb = NULL;
+	struct bt_vs_set_hw_cfg_cmd_i2s *i2s_cmd;
+	struct bt_vs_set_hw_cfg_cmd_pcm *pcm_cmd;
+	struct audio_info *info = audio_user->info;
+	struct cg2900_user_data *pf_data = dev_get_platdata(info->dev_bt);
+	struct audio_cb_info *cb_info = cg2900_get_usr(pf_data);
+
+	dev_dbg(BT_DEV, "set_dai_config_pg1 port %d\n", config->port);
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any time on
+	 * each channel.
+	 */
+	mutex_lock(&info->bt_mutex);
+
+	/* Allocate the sk_buffer. The length is actually a max length since
+	 * length varies depending on logical transport.
+	 */
+	skb = pf_data->alloc_skb(CG2900_BT_LEN_VS_SET_HARDWARE_CONFIG,
+				 GFP_KERNEL);
+	if (!skb) {
+		dev_err(BT_DEV, "set_dai_config_pg1: Could not allocate skb\n");
+		err = -ENOMEM;
+		goto finished_unlock_mutex;
+	}
+
+	/* Fill in hci-command according to received configuration */
+	switch (config->port) {
+	case PORT_0_I2S:
+		i2s_cmd = (struct bt_vs_set_hw_cfg_cmd_i2s *)
+			skb_put(skb, sizeof(*i2s_cmd));
+
+		i2s_cmd->opcode = cpu_to_le16(CG2900_BT_VS_SET_HARDWARE_CONFIG);
+		i2s_cmd->plen   = BT_PARAM_LEN(sizeof(*i2s_cmd));
+
+		i2s_cmd->vp_type = PORT_PROTOCOL_I2S;
+		i2s_cmd->port_id = 0x00; /* First/only I2S port */
+		i2s_cmd->half_period = config->conf.i2s.half_period;
+
+		i2s_cmd->master_slave = mc_i2s_role(config->conf.i2s.mode);
+
+		/* Store the new configuration */
+		mutex_lock(&info->management_mutex);
+		memcpy(&info->i2s_config, &config->conf.i2s,
+		       sizeof(config->conf.i2s));
+		info->i2s_config_known = true;
+		mutex_unlock(&info->management_mutex);
+		break;
+
+	case PORT_1_I2S_PCM:
+		pcm_cmd = (struct bt_vs_set_hw_cfg_cmd_pcm *)
+			skb_put(skb, sizeof(*pcm_cmd));
+
+		pcm_cmd->opcode = cpu_to_le16(CG2900_BT_VS_SET_HARDWARE_CONFIG);
+		pcm_cmd->plen   = BT_PARAM_LEN(sizeof(*pcm_cmd));
+
+		i2s_pcm = &config->conf.i2s_pcm;
+
+		/*
+		 * CG2900 PG1 chips don't support I2S over the PCM/I2S bus,
+		 * and CG2900 PG2 onwards chips don't use this command
+		 */
+		if (i2s_pcm->protocol != PORT_PROTOCOL_PCM) {
+			dev_err(BT_DEV,
+				"I2S not supported over the PCM/I2S bus\n");
+			err = -EACCES;
+			goto error_handling_free_skb;
+		}
+
+		pcm_cmd->vp_type = PORT_PROTOCOL_PCM;
+		pcm_cmd->port_id = 0x00; /* First/only PCM port */
+
+		HWCONFIG_PCM_SET_MODE(pcm_cmd, mc_pcm_role(i2s_pcm->mode));
+
+		HWCONFIG_PCM_SET_DIR(pcm_cmd, 0, i2s_pcm->slot_0_dir);
+		HWCONFIG_PCM_SET_DIR(pcm_cmd, 1, i2s_pcm->slot_1_dir);
+		HWCONFIG_PCM_SET_DIR(pcm_cmd, 2, i2s_pcm->slot_2_dir);
+		HWCONFIG_PCM_SET_DIR(pcm_cmd, 3, i2s_pcm->slot_3_dir);
+
+		pcm_cmd->bit_clock = i2s_pcm->clk;
+		pcm_cmd->frame_len =
+			cpu_to_le16(get_fs_duration(i2s_pcm->duration));
+
+		/* Store the new configuration */
+		mutex_lock(&info->management_mutex);
+		memcpy(&info->i2s_pcm_config, &config->conf.i2s_pcm,
+		       sizeof(config->conf.i2s_pcm));
+		info->i2s_pcm_config_known = true;
+		mutex_unlock(&info->management_mutex);
+		break;
+
+	default:
+		dev_err(BT_DEV, "Unknown port configuration %d\n",
+			config->port);
+		err = -EACCES;
+		goto error_handling_free_skb;
+	};
+
+	cb_info->user = audio_user;
+	dev_dbg(BT_DEV, "New resp_state: WAITING\n");
+	audio_user->resp_state = WAITING;
+
+	/* Send packet to controller */
+	err = pf_data->write(pf_data, skb);
+	if (err) {
+		dev_err(BT_DEV, "Error %d occurred while transmitting skb\n",
+			err);
+		goto error_handling_free_skb;
+	}
+
+	err = receive_bt_cmd_complete(audio_user,
+				      CG2900_BT_VS_SET_HARDWARE_CONFIG,
+				      NULL, 0);
+
+	goto finished_unlock_mutex;
+
+error_handling_free_skb:
+	kfree_skb(skb);
+finished_unlock_mutex:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	return err;
+}
+
+/**
+ * set_dai_config_pg2() - Internal implementation of
+ * cg2900_audio_set_dai_config for CG2900 PG2 onwards hardware.
+ * @audio_user:	Pointer to audio user struct.
+ * @config:	Pointer to the configuration to set.
+ *
+ * Sets the Digital Audio Interface (DAI) configuration for
+ * CG2900 PG2 onwards hardware. This is an internal function
+ * and basic argument-verification should have been
+ * done by the caller.
+ *
+ * Returns:
+ *  0 if there is no error.
+ *  -EACCESS if port is not supported.
+ *  -ENOMEM if not possible to allocate packet.
+ *  -ECOMM if no response was received.
+ *  -EIO for other errors.
+ */
+static int set_dai_config_pg2(struct audio_user *audio_user,
+			      struct cg2900_dai_config *config)
+{
+	int err = 0;
+	struct cg2900_dai_conf_i2s *i2s;
+	struct cg2900_dai_conf_i2s_pcm *i2s_pcm;
+
+	struct mc_vs_port_cfg_i2s i2s_cfg;
+	struct mc_vs_port_cfg_pcm_i2s pcm_cfg;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(BT_DEV, "set_dai_config_pg2 port %d\n", config->port);
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any time on
+	 * each channel.
+	 */
+	mutex_lock(&info->bt_mutex);
+
+	switch (config->port) {
+	case PORT_0_I2S:
+		i2s = &config->conf.i2s;
+
+		memset(&i2s_cfg, 0, sizeof(i2s_cfg)); /* just to be safe  */
+
+		/* master/slave */
+		PORTCFG_I2S_SET_ROLE(i2s_cfg, mc_i2s_role(i2s->mode));
+
+		PORTCFG_I2S_SET_HALFPERIOD(i2s_cfg, i2s->half_period);
+		PORTCFG_I2S_SET_CHANNELS(i2s_cfg,
+			mc_i2s_channel_select(i2s->channel_sel));
+		PORTCFG_I2S_SET_SRATE(i2s_cfg,
+			mc_i2s_sample_rate(i2s->sample_rate));
+		switch (i2s->word_width) {
+		case WORD_WIDTH_16:
+			PORTCFG_I2S_SET_WORDLEN(i2s_cfg, CG2900_MC_I2S_WORD_16);
+			break;
+		case WORD_WIDTH_32:
+			PORTCFG_I2S_SET_WORDLEN(i2s_cfg, CG2900_MC_I2S_WORD_32);
+			break;
+		}
+
+		/* Store the new configuration */
+		mutex_lock(&info->management_mutex);
+		memcpy(&(info->i2s_config), &(config->conf.i2s),
+		       sizeof(config->conf.i2s));
+		info->i2s_config_known = true;
+		mutex_unlock(&info->management_mutex);
+
+		/* Send */
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_I2S,
+				       &i2s_cfg, sizeof(i2s_cfg));
+		break;
+
+	case PORT_1_I2S_PCM:
+		i2s_pcm = &config->conf.i2s_pcm;
+
+		memset(&pcm_cfg, 0, sizeof(pcm_cfg)); /* just to be safe  */
+
+		/* master/slave */
+		PORTCFG_PCM_SET_ROLE(pcm_cfg, mc_pcm_role(i2s_pcm->mode));
+
+		/* set direction for all 4 slots */
+		PORTCFG_PCM_SET_DIR(pcm_cfg, 0, i2s_pcm->slot_0_dir);
+		PORTCFG_PCM_SET_DIR(pcm_cfg, 1, i2s_pcm->slot_1_dir);
+		PORTCFG_PCM_SET_DIR(pcm_cfg, 2, i2s_pcm->slot_2_dir);
+		PORTCFG_PCM_SET_DIR(pcm_cfg, 3, i2s_pcm->slot_3_dir);
+
+		/* set used SCO slots, other use cases not supported atm */
+		PORTCFG_PCM_SET_SCO_USED(pcm_cfg, 0, i2s_pcm->slot_0_used);
+		PORTCFG_PCM_SET_SCO_USED(pcm_cfg, 1, i2s_pcm->slot_1_used);
+		PORTCFG_PCM_SET_SCO_USED(pcm_cfg, 2, i2s_pcm->slot_2_used);
+		PORTCFG_PCM_SET_SCO_USED(pcm_cfg, 3, i2s_pcm->slot_3_used);
+
+		/* slot starts */
+		pcm_cfg.slot_start[0] = i2s_pcm->slot_0_start;
+		pcm_cfg.slot_start[1] = i2s_pcm->slot_1_start;
+		pcm_cfg.slot_start[2] = i2s_pcm->slot_2_start;
+		pcm_cfg.slot_start[3] = i2s_pcm->slot_3_start;
+
+		/* audio/voice sample-rate ratio */
+		PORTCFG_PCM_SET_RATIO(pcm_cfg, i2s_pcm->ratio);
+
+		/* PCM or I2S mode */
+		PORTCFG_PCM_SET_MODE(pcm_cfg, i2s_pcm->protocol);
+
+		pcm_cfg.frame_len = i2s_pcm->duration;
+
+		PORTCFG_PCM_SET_BITCLK(pcm_cfg, i2s_pcm->clk);
+		PORTCFG_PCM_SET_SRATE(pcm_cfg,
+			mc_pcm_sample_rate(i2s_pcm->sample_rate));
+
+		/* Store the new configuration */
+		mutex_lock(&info->management_mutex);
+		memcpy(&(info->i2s_pcm_config), &(config->conf.i2s_pcm),
+		       sizeof(config->conf.i2s_pcm));
+		info->i2s_pcm_config_known = true;
+		mutex_unlock(&info->management_mutex);
+
+		/* Send */
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_PCM_I2S,
+				       &pcm_cfg, sizeof(pcm_cfg));
+		break;
+
+	default:
+		dev_err(BT_DEV, "Unknown port configuration %d\n",
+			config->port);
+		err = -EACCES;
+	};
+
+	mutex_unlock(&info->bt_mutex);
+	return err;
+}
+
+/**
+ * struct i2s_fm_stream_config_priv - Helper struct for stream i2s-fm streams.
+ * @fm_config:	FM endpoint configuration.
+ * @rx:		true for FM-RX, false for FM-TX.
+ */
+struct i2s_fm_stream_config_priv {
+	struct cg2900_endpoint_config_fm	*fm_config;
+	bool					rx;
+
+};
+
+/**
+ * config_i2s_fm_stream() - Callback for @send_vs_session_config.
+ * @info:	Audio info structure.
+ * @_priv:	Pointer to a @i2s_fm_stream_config_priv struct.
+ * @cfg:	Pointer to stream config block in command packet.
+ *
+ * Fills in stream configuration for I2S-FM RX/TX.
+ */
+
+static void config_i2s_fm_stream(struct audio_info *info, void *_priv,
+				 struct session_config_stream *cfg)
+{
+	struct i2s_fm_stream_config_priv *priv = _priv;
+	struct session_config_vport *fm;
+	struct session_config_vport *i2s;
+
+	cfg->media_type = CG2900_BT_SESSION_MEDIA_TYPE_AUDIO;
+
+	if (info->i2s_config.channel_sel == CHANNEL_SELECTION_BOTH)
+		SESSIONCFG_SET_CHANNELS(cfg, CG2900_BT_MEDIA_CONFIG_STEREO);
+	else
+		SESSIONCFG_SET_CHANNELS(cfg, CG2900_BT_MEDIA_CONFIG_MONO);
+
+	SESSIONCFG_I2S_SET_SRATE(cfg,
+		session_config_sample_rate(priv->fm_config->sample_rate));
+
+	cfg->codec_type = CG2900_CODEC_TYPE_NONE;
+	/* codec mode and parameters not used  */
+
+	if (priv->rx) {
+		fm  = &cfg->inport;  /* FM is input */
+		i2s = &cfg->outport; /* I2S is output */
+	} else {
+		i2s = &cfg->inport;  /* I2S is input */
+		fm  = &cfg->outport; /* FM is output */
+	}
+
+	fm->type = CG2900_BT_VP_TYPE_FM;
+
+	i2s->type = CG2900_BT_VP_TYPE_I2S;
+	i2s->i2s.index   = CG2900_BT_SESSION_I2S_INDEX_I2S;
+	i2s->i2s.channel = info->i2s_config.channel_sel;
+}
+
+/**
+ * conn_start_i2s_to_fm_rx() - Start an audio stream connecting FM RX to I2S.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	[out] Pointer where to store the stream handle.
+ *
+ * This function sets up an FM RX to I2S stream.
+ * It does this by first setting the output mode and then the configuration of
+ * the External Sample Rate Converter.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   -EIO for other errors.
+ */
+static int conn_start_i2s_to_fm_rx(struct audio_user *audio_user,
+				   unsigned int *stream_handle)
+{
+	int err = 0;
+	union cg2900_endpoint_config_union *fm_config;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(FM_DEV, "conn_start_i2s_to_fm_rx\n");
+
+	fm_config = find_endpoint(ENDPOINT_FM_RX, &info->endpoints);
+	if (!fm_config) {
+		dev_err(FM_DEV, "FM RX not configured before stream start\n");
+		return -EIO;
+	}
+
+	if (!(info->i2s_config_known)) {
+		dev_err(FM_DEV,
+			"I2S DAI not configured before stream start\n");
+		return -EIO;
+	}
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any
+	 * time on each channel.
+	 */
+	mutex_lock(&info->fm_mutex);
+	mutex_lock(&info->bt_mutex);
+
+	/*
+	 * Now set the output mode of the External Sample Rate Converter by
+	 * sending HCI_Write command with AUP_EXT_SetMode.
+	 */
+	err = send_fm_write_1_param(audio_user,
+				    CG2900_FM_CMD_ID_AUP_EXT_SET_MODE,
+				    CG2900_FM_CMD_AUP_EXT_SET_MODE_PARALLEL);
+	if (err)
+		goto finished_unlock_mutex;
+
+	/*
+	 * Now configure the External Sample Rate Converter by sending
+	 * HCI_Write command with AUP_EXT_SetControl.
+	 */
+	err = send_fm_write_1_param(
+		audio_user, CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL,
+		fm_get_conversion(info, fm_config->fm.sample_rate));
+	if (err)
+		goto finished_unlock_mutex;
+
+	/* Set up the stream */
+	if (info->revision == CG2900_CHIP_REV_PG1) {
+		struct i2s_fm_stream_config_priv stream_priv;
+
+		/* Now send HCI_VS_Set_Session_Configuration command */
+		stream_priv.fm_config = &fm_config->fm;
+		stream_priv.rx = true;
+		err = send_vs_session_config(audio_user, config_i2s_fm_stream,
+					     &stream_priv);
+	} else {
+		struct mc_vs_port_cfg_fm fm_cfg;
+
+		memset(&fm_cfg, 0, sizeof(fm_cfg));
+
+		/* Configure port FM RX */
+		/* Expects 0-3 - same as user API - so no conversion needed */
+		PORTCFG_FM_SET_SRATE(fm_cfg, (u8)fm_config->fm.sample_rate);
+
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_FM_RX_1,
+				       &fm_cfg, sizeof(fm_cfg));
+		if (err)
+			goto finished_unlock_mutex;
+
+		/* CreateStream */
+		err = send_vs_create_stream(audio_user,
+					    CG2900_MC_PORT_FM_RX_1,
+					    CG2900_MC_PORT_I2S,
+					    0); /* chip doesn't care */
+	}
+
+	if (err < 0)
+		goto finished_unlock_mutex;
+
+	/* Store the stream handle (used for start and stop stream) */
+	*stream_handle = (u8)err;
+	dev_dbg(FM_DEV, "stream_handle set to %d\n", *stream_handle);
+
+	/* Now start the stream */
+	if (info->revision == CG2900_CHIP_REV_PG1)
+		err = send_vs_session_ctrl(audio_user, *stream_handle,
+					   CG2900_BT_SESSION_START);
+	else
+		err = send_vs_stream_ctrl(audio_user, *stream_handle,
+					  CG2900_MC_STREAM_START);
+	/*Let's delete a stream.*/
+	if (err < 0) {
+		dev_dbg(BT_DEV, "Could not start a stream.");
+		(void)send_vs_delete_stream(audio_user, *stream_handle);
+	}
+
+finished_unlock_mutex:
+	dev_dbg(FM_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	mutex_unlock(&info->fm_mutex);
+	return err;
+}
+
+/**
+ * conn_start_i2s_to_fm_tx() - Start an audio stream connecting FM TX to I2S.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	[out] Pointer where to store the stream handle.
+ *
+ * This function sets up an I2S to FM TX stream.
+ * It does this by first setting the Audio Input source and then setting the
+ * configuration and input source of BT sample rate converter.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   -EIO for other errors.
+ */
+static int conn_start_i2s_to_fm_tx(struct audio_user *audio_user,
+				   unsigned int *stream_handle)
+{
+	int err = 0;
+	union cg2900_endpoint_config_union *fm_config;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(FM_DEV, "conn_start_i2s_to_fm_tx\n");
+
+	fm_config = find_endpoint(ENDPOINT_FM_TX, &info->endpoints);
+	if (!fm_config) {
+		dev_err(FM_DEV, "FM TX not configured before stream start\n");
+		return -EIO;
+	}
+
+	if (!(info->i2s_config_known)) {
+		dev_err(FM_DEV,
+			"I2S DAI not configured before stream start\n");
+		return -EIO;
+	}
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any time
+	 * on each channel.
+	 */
+	mutex_lock(&info->fm_mutex);
+	mutex_lock(&info->bt_mutex);
+
+	/*
+	 * Select Audio Input Source by sending HCI_Write command with
+	 * AIP_SetMode.
+	 */
+	if (info->revision == CG2900_CHIP_REV_PG1 ||
+			info->revision == CG2900_CHIP_REV_PG2) {
+		dev_dbg(FM_DEV, "FM: AIP_SetMode\n");
+		err = send_fm_write_1_param(audio_user,
+				CG2900_FM_CMD_ID_AIP_SET_MODE,
+				CG2900_FM_CMD_AIP_SET_MODE_INPUT_DIG);
+		if (err)
+			goto finished_unlock_mutex;
+	}
+	/*
+	 * Now configure the BT sample rate converter by sending HCI_Write
+	 * command with AIP_BT_SetControl.
+	 */
+	dev_dbg(FM_DEV, "FM: AIP_BT_SetControl\n");
+	err = send_fm_write_1_param(
+		audio_user, CG2900_FM_CMD_ID_AIP_BT_SET_CTRL,
+		fm_get_conversion(info, fm_config->fm.sample_rate));
+	if (err)
+		goto finished_unlock_mutex;
+
+	/*
+	 * Now set input of the BT sample rate converter by sending HCI_Write
+	 * command with AIP_BT_SetMode.
+	 */
+	dev_dbg(FM_DEV, "FM: AIP_BT_SetMode\n");
+	err = send_fm_write_1_param(audio_user,
+				    CG2900_FM_CMD_ID_AIP_BT_SET_MODE,
+				    CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_PAR);
+	if (err)
+		goto finished_unlock_mutex;
+
+	/* Set up the stream */
+	if (info->revision == CG2900_CHIP_REV_PG1) {
+		struct i2s_fm_stream_config_priv stream_priv;
+
+		/* Now send HCI_VS_Set_Session_Configuration command */
+		stream_priv.fm_config = &fm_config->fm;
+		stream_priv.rx = false;
+		err = send_vs_session_config(audio_user, config_i2s_fm_stream,
+					     &stream_priv);
+	} else {
+		struct mc_vs_port_cfg_fm fm_cfg;
+
+		memset(&fm_cfg, 0, sizeof(fm_cfg));
+
+		/* Configure port FM TX */
+		/* Expects 0-3 - same as user API - so no conversion needed */
+		PORTCFG_FM_SET_SRATE(fm_cfg, (u8)fm_config->fm.sample_rate);
+
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_FM_TX,
+				       &fm_cfg, sizeof(fm_cfg));
+		if (err)
+			goto finished_unlock_mutex;
+
+		/* CreateStream */
+		err = send_vs_create_stream(audio_user,
+					    CG2900_MC_PORT_I2S,
+					    CG2900_MC_PORT_FM_TX,
+					    0); /* chip doesn't care */
+	}
+
+	if (err < 0)
+		goto finished_unlock_mutex;
+
+	/* Store the stream handle (used for start and stop stream) */
+	*stream_handle = (u8)err;
+	dev_dbg(FM_DEV, "stream_handle set to %d\n", *stream_handle);
+
+	/* Now start the stream */
+	if (info->revision == CG2900_CHIP_REV_PG1)
+		err = send_vs_session_ctrl(audio_user, *stream_handle,
+					   CG2900_BT_SESSION_START);
+	else
+		err = send_vs_stream_ctrl(audio_user, *stream_handle,
+					  CG2900_MC_STREAM_START);
+	/* Let's delete and release stream.*/
+	if (err < 0) {
+		dev_dbg(BT_DEV, "Could not start a stream.");
+		(void)send_vs_delete_stream(audio_user, *stream_handle);
+	}
+
+finished_unlock_mutex:
+	dev_dbg(FM_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	mutex_unlock(&info->fm_mutex);
+	return err;
+}
+
+/**
+ * config_pcm_sco_stream() - Callback for @send_vs_session_config.
+ * @info:	Audio info structure.
+ * @_priv:	Pointer to a @cg2900_endpoint_config_sco_in_out struct.
+ * @cfg:	Pointer to stream config block in command packet.
+ *
+ * Fills in stream configuration for PCM-SCO.
+ */
+static void config_pcm_sco_stream(struct audio_info *info, void *_priv,
+				  struct session_config_stream *cfg)
+{
+	struct cg2900_endpoint_config_sco_in_out *sco_ep = _priv;
+
+	cfg->media_type = CG2900_BT_SESSION_MEDIA_TYPE_AUDIO;
+
+	SESSIONCFG_SET_CHANNELS(cfg, CG2900_BT_MEDIA_CONFIG_MONO);
+	SESSIONCFG_I2S_SET_SRATE(cfg,
+		session_config_sample_rate(sco_ep->sample_rate));
+
+	cfg->codec_type = CG2900_CODEC_TYPE_NONE;
+	/* codec mode and parameters not used  */
+
+	cfg->inport.type = CG2900_BT_VP_TYPE_BT_SCO;
+	cfg->inport.sco.acl_handle = cpu_to_le16(DEFAULT_ACL_HANDLE);
+
+	cfg->outport.type = CG2900_BT_VP_TYPE_PCM;
+	cfg->outport.pcm.index = CG2900_BT_SESSION_PCM_INDEX_PCM_I2S;
+
+	SESSIONCFG_PCM_SET_USED(cfg->outport, 0,
+				info->i2s_pcm_config.slot_0_used);
+	SESSIONCFG_PCM_SET_USED(cfg->outport, 1,
+				info->i2s_pcm_config.slot_1_used);
+	SESSIONCFG_PCM_SET_USED(cfg->outport, 2,
+				info->i2s_pcm_config.slot_2_used);
+	SESSIONCFG_PCM_SET_USED(cfg->outport, 3,
+				info->i2s_pcm_config.slot_3_used);
+
+	cfg->outport.pcm.slot_start[0] =
+		info->i2s_pcm_config.slot_0_start;
+	cfg->outport.pcm.slot_start[1] =
+		info->i2s_pcm_config.slot_1_start;
+	cfg->outport.pcm.slot_start[2] =
+		info->i2s_pcm_config.slot_2_start;
+	cfg->outport.pcm.slot_start[3] =
+		info->i2s_pcm_config.slot_3_start;
+}
+
+/**
+ * conn_start_pcm_to_sco() - Start an audio stream connecting Bluetooth (e)SCO to PCM_I2S.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	[out] Pointer where to store the stream handle.
+ *
+ * This function sets up a BT to_from PCM_I2S stream. It does this by
+ * first setting the Session configuration and then starting the Audio
+ * Stream.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   Errors from @cg2900_write
+ *   -EIO for other errors.
+ */
+static int conn_start_pcm_to_sco(struct audio_user *audio_user,
+				 unsigned int *stream_handle)
+{
+	int err = 0;
+	union cg2900_endpoint_config_union *bt_config;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(BT_DEV, "conn_start_pcm_to_sco\n");
+
+	bt_config = find_endpoint(ENDPOINT_BT_SCO_INOUT, &info->endpoints);
+	if (!bt_config) {
+		dev_err(BT_DEV, "BT not configured before stream start\n");
+		return -EIO;
+	}
+
+	if (!(info->i2s_pcm_config_known)) {
+		dev_err(BT_DEV,
+			"I2S_PCM DAI not configured before stream start\n");
+		return -EIO;
+	}
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any time on each
+	 * channel.
+	 */
+	mutex_lock(&info->bt_mutex);
+
+	/* Set up the stream */
+	if (info->revision == CG2900_CHIP_REV_PG1) {
+		err = send_vs_session_config(audio_user, config_pcm_sco_stream,
+					     &bt_config->sco);
+	} else {
+		struct mc_vs_port_cfg_sco sco_cfg;
+
+		/* zero codec params etc */
+		memset(&sco_cfg, 0, sizeof(sco_cfg));
+		sco_cfg.acl_id = DEFAULT_ACL_HANDLE;
+		PORTCFG_SCO_SET_CODEC(sco_cfg, CG2900_CODEC_TYPE_NONE);
+
+		err = send_vs_port_cfg(audio_user, CG2900_MC_PORT_BT_SCO,
+				       &sco_cfg, sizeof(sco_cfg));
+		if (err)
+			goto finished_unlock_mutex;
+
+		/* CreateStream */
+		err = send_vs_create_stream(audio_user,
+					    CG2900_MC_PORT_PCM_I2S,
+					    CG2900_MC_PORT_BT_SCO,
+					    0); /* chip doesn't care */
+	}
+
+	if (err < 0)
+		goto finished_unlock_mutex;
+
+	/* Store the stream handle (used for start and stop stream) */
+	*stream_handle = (u8)err;
+	dev_dbg(BT_DEV, "stream_handle set to %d\n", *stream_handle);
+
+	/* Now start the stream */
+	if (info->revision == CG2900_CHIP_REV_PG1)
+		err = send_vs_session_ctrl(audio_user, *stream_handle,
+					   CG2900_BT_SESSION_START);
+	else
+		err = send_vs_stream_ctrl(audio_user, *stream_handle,
+					  CG2900_MC_STREAM_START);
+	/* Let's delete and release stream.*/
+	if (err < 0) {
+		dev_dbg(BT_DEV, "Could not start a stream.");
+		(void)send_vs_delete_stream(audio_user, *stream_handle);
+	}
+
+finished_unlock_mutex:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	return err;
+}
+
+/**
+ * conn_stop_stream() - Stops an audio stream defined by @stream_handle.
+ * @audio_user:		Audio user to check for.
+ * @stream_handle:	Handle of the audio stream.
+ *
+ * This function is used to stop an audio stream defined by a stream
+ * handle. It does this by first stopping the stream and then
+ * resetting the session/stream.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ECOMM if no response was received.
+ *   -ENOMEM upon allocation errors.
+ *   Errors from @cg2900_write.
+ *   -EIO for other errors.
+ */
+static int conn_stop_stream(struct audio_user *audio_user,
+			    unsigned int stream_handle)
+{
+	int err = 0;
+	struct audio_info *info = audio_user->info;
+
+	dev_dbg(BT_DEV, "conn_stop_stream handle %d\n", stream_handle);
+
+	/*
+	 * Use mutex to assure that only ONE command is sent at any
+	 * time on each channel.
+	 */
+	mutex_lock(&info->bt_mutex);
+
+	/* Now stop the stream */
+	if (info->revision == CG2900_CHIP_REV_PG1)
+		err = send_vs_session_ctrl(audio_user, stream_handle,
+					   CG2900_BT_SESSION_STOP);
+	else
+		err = send_vs_stream_ctrl(audio_user, stream_handle,
+					  CG2900_MC_STREAM_STOP);
+	if (err)
+		goto finished_unlock_mutex;
+
+	err = send_vs_delete_stream(audio_user, stream_handle);
+
+finished_unlock_mutex:
+	dev_dbg(BT_DEV, "New resp_state: IDLE\n");
+	audio_user->resp_state = IDLE;
+	mutex_unlock(&info->bt_mutex);
+	return err;
+}
+
+/**
+ * cg2900_audio_get_devices() - Returns connected CG2900 Audio devices.
+ * @devices:	Array of CG2900 Audio devices.
+ * @size:	Max number of devices in array.
+ *
+ * Returns:
+ *   0 if no devices exist.
+ *   > 0 is the number of devices inserted in the list.
+ *   -EINVAL upon bad input parameter.
+ */
+int cg2900_audio_get_devices(struct device *devices[], __u8 size)
+{
+	struct list_head *cursor;
+	struct audio_info *tmp;
+	int i = 0;
+
+	if (!size) {
+		pr_err("No space to insert devices into list\n");
+		return 0;
+	}
+
+	if (!devices) {
+		pr_err("NULL submitted as devices array\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Go through and store the devices. If NULL is supplied for dev
+	 * just return first device found.
+	 */
+	list_for_each(cursor, &cg2900_audio_devices) {
+		tmp = list_entry(cursor, struct audio_info, list);
+		devices[i] = tmp->parent;
+		i++;
+		if (i == size)
+			break;
+	}
+	return i;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_get_devices);
+
+/**
+ * cg2900_audio_open() - Opens a session to the ST-Ericsson CG2900 Audio control interface.
+ * @session:	[out] Address where to store the session identifier.
+ *		Allocated by caller, must not be NULL.
+ * @parent:	Parent device representing the CG2900 controller connected.
+ *		If NULL is supplied the first available device is used.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EACCES if no info structure can be found.
+ *   -EINVAL upon bad input parameter.
+ *   -ENOMEM upon allocation failure.
+ *   -EMFILE if no more user session could be opened.
+ *   -EIO upon failure to register to CG2900.
+ *   Error codes from get_info.
+ */
+int cg2900_audio_open(unsigned int *session, struct device *parent)
+{
+	int err = 0;
+	int i;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data_bt;
+	struct cg2900_user_data *pf_data_fm;
+
+	pr_debug("cg2900_audio_open");
+
+	info = get_info(parent);
+	if (!info) {
+		pr_err("No audio info exist");
+		return -EACCES;
+	} else if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	if (!session) {
+		pr_err("NULL supplied as session");
+		return -EINVAL;
+	}
+
+	mutex_lock(&info->management_mutex);
+
+	*session = 0;
+
+	/*
+	 * First find a free session to use and allocate the session structure.
+	 */
+	for (i = FIRST_USER;
+	     i < MAX_NBR_OF_USERS && cg2900_audio_sessions[i];
+	     i++)
+		; /* Just loop until found or end reached */
+
+	if (i >= MAX_NBR_OF_USERS) {
+		pr_err("Couldn't find free user");
+		err = -EMFILE;
+		goto finished;
+	}
+
+	cg2900_audio_sessions[i] =
+		kzalloc(sizeof(*(cg2900_audio_sessions[0])), GFP_KERNEL);
+	if (!cg2900_audio_sessions[i]) {
+		pr_err("Could not allocate user");
+		err = -ENOMEM;
+		goto finished;
+	}
+	pr_debug("Found free session %d", i);
+	*session = i;
+	info->nbr_of_users_active++;
+
+	cg2900_audio_sessions[*session]->resp_state = IDLE;
+	cg2900_audio_sessions[*session]->session = *session;
+	cg2900_audio_sessions[*session]->info = info;
+
+	pf_data_bt = dev_get_platdata(info->dev_bt);
+	pf_data_fm = dev_get_platdata(info->dev_fm);
+
+	if (info->nbr_of_users_active == 1) {
+		struct cg2900_rev_data rev_data;
+
+		/*
+		 * First user so register to CG2900 Core.
+		 * First the BT audio device.
+		 */
+		err = pf_data_bt->open(pf_data_bt);
+		if (err) {
+			dev_err(BT_DEV, "Failed to open BT audio channel\n");
+			goto error_handling;
+		}
+
+		/* Then the FM audio device */
+		err = pf_data_fm->open(pf_data_fm);
+		if (err) {
+			dev_err(FM_DEV, "Failed to open FM audio channel\n");
+			goto error_handling;
+		}
+
+		/* Read chip revision data */
+		if (!pf_data_bt->get_local_revision(pf_data_bt, &rev_data)) {
+			pr_err("Couldn't retrieve revision data");
+			err = -EIO;
+			goto error_handling;
+		}
+
+		/* Decode revision data */
+		switch (rev_data.revision) {
+		case CG2900_PG1_REV:
+		case CG2900_PG1_SPECIAL_REV:
+			info->revision = CG2900_CHIP_REV_PG1;
+			break;
+
+		case CG2900_PG2_REV:
+			info->revision = CG2900_CHIP_REV_PG2;
+			break;
+
+		case CG2905_PG1_05_REV:
+			info->revision = CG2905_CHIP_REV_PG1_05;
+			break;
+
+		case CG2905_PG2_REV:
+			info->revision = CG2905_CHIP_REV_PG2;
+			break;
+
+		case CG2910_PG1_REV:
+			info->revision = CG2910_CHIP_REV_PG1;
+			break;
+
+		case CG2910_PG2_REV:
+			info->revision = CG2910_CHIP_REV_PG2;
+			break;
+
+		default:
+			pr_err("Chip rev 0x%04X sub 0x%04X not supported",
+			       rev_data.revision, rev_data.sub_version);
+			err = -EIO;
+			goto error_handling;
+		}
+
+		info->state = OPENED;
+	}
+
+	pr_info("Session %d opened", *session);
+
+	goto finished;
+
+error_handling:
+	if (pf_data_fm->opened)
+		pf_data_fm->close(pf_data_fm);
+	if (pf_data_bt->opened)
+		pf_data_bt->close(pf_data_bt);
+	info->nbr_of_users_active--;
+	kfree(cg2900_audio_sessions[*session]);
+	cg2900_audio_sessions[*session] = NULL;
+finished:
+	mutex_unlock(&info->management_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_open);
+
+/**
+ * cg2900_audio_close() - Closes an opened session to the ST-Ericsson CG2900 audio control interface.
+ * @session:	[in_out] Pointer to session identifier to close.
+ *		Will be 0 after this call.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened.
+ *   -EACCES if session has not opened.
+ */
+int cg2900_audio_close(unsigned int *session)
+{
+	int err = 0;
+	struct audio_user *audio_user;
+	struct audio_info *info;
+	struct cg2900_user_data *pf_data_bt;
+	struct cg2900_user_data *pf_data_fm;
+
+	pr_debug("cg2900_audio_close");
+
+	if (!session) {
+		pr_err("NULL pointer supplied");
+		return -EINVAL;
+	}
+
+	audio_user = get_session_user(*session);
+	if (!audio_user) {
+		pr_err("Invalid session ID");
+		return -EINVAL;
+	}
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	mutex_lock(&info->management_mutex);
+
+	pf_data_bt = dev_get_platdata(info->dev_bt);
+	pf_data_fm = dev_get_platdata(info->dev_fm);
+
+	if (!cg2900_audio_sessions[*session]) {
+		dev_err(BT_DEV, "Session %d not opened\n", *session);
+		err = -EACCES;
+		goto err_unlock_mutex;
+	}
+
+	kfree(cg2900_audio_sessions[*session]);
+	cg2900_audio_sessions[*session] = NULL;
+
+	info->nbr_of_users_active--;
+	if (info->nbr_of_users_active == 0) {
+		/* No more sessions open. Close channels */
+		pf_data_fm->close(pf_data_fm);
+		pf_data_bt->close(pf_data_bt);
+		info->state = CLOSED;
+	}
+
+	dev_info(BT_DEV, "Session %d closed\n", *session);
+
+	*session = 0;
+
+err_unlock_mutex:
+	mutex_unlock(&info->management_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_close);
+
+/**
+ * cg2900_audio_set_dai_config() -  Sets the Digital Audio Interface configuration.
+ * @session:	Session identifier this call is related to.
+ * @config:	Pointer to the configuration to set.
+ *		Allocated by caller, must not be NULL.
+ *
+ * Sets the Digital Audio Interface (DAI) configuration. The DAI is the external
+ * interface between the combo chip and the platform.
+ * For example the PCM or I2S interface.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened.
+ *   -ENOMEM upon allocation failure.
+ *   -EACCES if trying to set unsupported configuration.
+ *   Errors from @receive_bt_cmd_complete.
+ */
+int cg2900_audio_set_dai_config(unsigned int session,
+				struct cg2900_dai_config *config)
+{
+	int err = 0;
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_set_dai_config session %d", session);
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	/* Different command is used for CG2900 PG1 */
+	if (info->revision == CG2900_CHIP_REV_PG1)
+		err = set_dai_config_pg1(audio_user, config);
+	else
+		err = set_dai_config_pg2(audio_user, config);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_set_dai_config);
+
+/**
+ * cg2900_audio_get_dai_config() - Gets the current Digital Audio Interface configuration.
+ * @session:	Session identifier this call is related to.
+ * @config:	[out] Pointer to the configuration to get.
+ *		Allocated by caller, must not be NULL.
+ *
+ * Gets the current Digital Audio Interface configuration. Currently this method
+ * can only be called after some one has called
+ * cg2900_audio_set_dai_config(), there is today no way of getting
+ * the static settings file parameters from this method.
+ * Note that the @port parameter within @config must be set when calling this
+ * function so that the ST-Ericsson CG2900 Audio driver will know which
+ * configuration to return.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened or configuration has not been set.
+ */
+int cg2900_audio_get_dai_config(unsigned int session,
+				struct cg2900_dai_config *config)
+{
+	int err = 0;
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_get_dai_config session %d", session);
+
+	if (!config) {
+		pr_err("NULL supplied as config structure");
+		return -EINVAL;
+	}
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	/*
+	 * Return DAI configuration based on the received port.
+	 * If port has not been configured return error.
+	 */
+	switch (config->port) {
+	case PORT_0_I2S:
+		mutex_lock(&info->management_mutex);
+		if (info->i2s_config_known)
+			memcpy(&config->conf.i2s,
+			       &info->i2s_config,
+			       sizeof(config->conf.i2s));
+		else
+			err = -EIO;
+		mutex_unlock(&info->management_mutex);
+		break;
+
+	case PORT_1_I2S_PCM:
+		mutex_lock(&info->management_mutex);
+		if (info->i2s_pcm_config_known)
+			memcpy(&config->conf.i2s_pcm,
+			       &info->i2s_pcm_config,
+			       sizeof(config->conf.i2s_pcm));
+		else
+			err = -EIO;
+		mutex_unlock(&info->management_mutex);
+		break;
+
+	default:
+		dev_err(BT_DEV, "Unknown port configuration %d\n",
+			config->port);
+		err = -EIO;
+		break;
+	};
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_get_dai_config);
+
+/**
+ * cg2900_audio_config_endpoint() - Configures one endpoint in the combo chip's audio system.
+ * @session:	Session identifier this call is related to.
+ * @config:	Pointer to the endpoint's configuration structure.
+ *
+ * Configures one endpoint in the combo chip's audio system.
+ * Supported @endpoint_id values are:
+ *  * ENDPOINT_BT_SCO_INOUT
+ *  * ENDPOINT_BT_A2DP_SRC
+ *  * ENDPOINT_FM_RX
+ *  * ENDPOINT_FM_TX
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened.
+ *   -EACCES if supplied cg2900_dai_config struct contains not supported
+ *   endpoint_id.
+ */
+int cg2900_audio_config_endpoint(unsigned int session,
+				 struct cg2900_endpoint_config *config)
+{
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_config_endpoint\n");
+
+	if (!config) {
+		pr_err("NULL supplied as configuration structure");
+		return -EINVAL;
+	}
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	switch (config->endpoint_id) {
+	case ENDPOINT_BT_SCO_INOUT:
+	case ENDPOINT_BT_A2DP_SRC:
+	case ENDPOINT_FM_RX:
+	case ENDPOINT_FM_TX:
+		add_endpoint(config, &info->endpoints);
+		break;
+
+	case ENDPOINT_PORT_0_I2S:
+	case ENDPOINT_PORT_1_I2S_PCM:
+	case ENDPOINT_SLIMBUS_VOICE:
+	case ENDPOINT_SLIMBUS_AUDIO:
+	case ENDPOINT_BT_A2DP_SNK:
+	case ENDPOINT_ANALOG_OUT:
+	case ENDPOINT_DSP_AUDIO_IN:
+	case ENDPOINT_DSP_AUDIO_OUT:
+	case ENDPOINT_DSP_VOICE_IN:
+	case ENDPOINT_DSP_VOICE_OUT:
+	case ENDPOINT_DSP_TONE_IN:
+	case ENDPOINT_BURST_BUFFER_IN:
+	case ENDPOINT_BURST_BUFFER_OUT:
+	case ENDPOINT_MUSIC_DECODER:
+	case ENDPOINT_HCI_AUDIO_IN:
+	default:
+		dev_err(BT_DEV, "Unsupported endpoint_id %d\n",
+			config->endpoint_id);
+		return -EACCES;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_config_endpoint);
+
+static bool is_dai_port(enum cg2900_audio_endpoint_id ep)
+{
+	/* These are the only supported ones */
+	return (ep == ENDPOINT_PORT_0_I2S) || (ep == ENDPOINT_PORT_1_I2S_PCM);
+}
+
+/**
+ * cg2900_audio_start_stream() - Connects two endpoints and starts the audio stream.
+ * @session:		Session identifier this call is related to.
+ * @ep_1:		One of the endpoints, no relation to direction or role.
+ * @ep_2:		The other endpoint, no relation to direction or role.
+ * @stream_handle:	Pointer where to store the stream handle.
+ *			Allocated by caller, must not be NULL.
+ *
+ * Connects two endpoints and starts the audio stream.
+ * Note that the endpoints need to be configured before the stream is started;
+ * DAI endpoints, such as ENDPOINT_PORT_0_I2S, are
+ * configured through @cg2900_audio_set_dai_config() while other
+ * endpoints are configured through @cg2900_audio_config_endpoint().
+ *
+ * Supported @endpoint_id values are:
+ *  * ENDPOINT_PORT_0_I2S
+ *  * ENDPOINT_PORT_1_I2S_PCM
+ *  * ENDPOINT_BT_SCO_INOUT
+ *  * ENDPOINT_FM_RX
+ *  * ENDPOINT_FM_TX
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter or unsupported configuration.
+ *   -EIO if driver has not been opened.
+ *   Errors from @conn_start_i2s_to_fm_rx, @conn_start_i2s_to_fm_tx, and
+ *   @conn_start_pcm_to_sco.
+ */
+int cg2900_audio_start_stream(unsigned int session,
+			      enum cg2900_audio_endpoint_id ep_1,
+			      enum cg2900_audio_endpoint_id ep_2,
+			      unsigned int *stream_handle)
+{
+	int err;
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_start_stream session %d ep_1 %d ep_2 %d",
+		 session, ep_1, ep_2);
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	/* Put digital interface in ep_1 to simplify comparison below */
+	if (!is_dai_port(ep_1)) {
+		/* Swap endpoints */
+		enum cg2900_audio_endpoint_id t = ep_1;
+		ep_1 = ep_2;
+		ep_2 = t;
+	}
+
+	if (ep_1 == ENDPOINT_PORT_1_I2S_PCM && ep_2 == ENDPOINT_BT_SCO_INOUT) {
+		err = conn_start_pcm_to_sco(audio_user, stream_handle);
+	} else if (ep_1 == ENDPOINT_PORT_0_I2S && ep_2 == ENDPOINT_FM_RX) {
+		err = conn_start_i2s_to_fm_rx(audio_user, stream_handle);
+	} else if (ep_1 == ENDPOINT_PORT_0_I2S && ep_2 == ENDPOINT_FM_TX) {
+		err = conn_start_i2s_to_fm_tx(audio_user, stream_handle);
+	} else {
+		dev_err(BT_DEV, "Endpoint config not handled: ep1: %d, "\
+			"ep2: %d\n", ep_1, ep_2);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_start_stream);
+
+/**
+ * cg2900_audio_stop_stream() - Stops a stream and disconnects the endpoints.
+ * @session:		Session identifier this call is related to.
+ * @stream_handle:	Handle to the stream to stop.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL upon bad input parameter.
+ *   -EIO if driver has not been opened.
+ */
+int cg2900_audio_stop_stream(unsigned int session, unsigned int stream_handle)
+{
+	struct audio_user *audio_user;
+	struct audio_info *info;
+
+	pr_debug("cg2900_audio_stop_stream handle %d", stream_handle);
+
+	audio_user = get_session_user(session);
+	if (!audio_user)
+		return -EINVAL;
+
+	info = audio_user->info;
+
+	if (info->state != OPENED) {
+		dev_err(BT_DEV, "Audio driver not open\n");
+		return -EIO;
+	}
+
+	return conn_stop_stream(audio_user, stream_handle);
+}
+EXPORT_SYMBOL_GPL(cg2900_audio_stop_stream);
+
+/**
+ * audio_dev_open() - Open char device.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation failed.
+ *   Errors from @cg2900_audio_open.
+ */
+static int audio_dev_open(struct inode *inode, struct file *filp)
+{
+	int err;
+	struct char_dev_info *char_dev_info;
+	int minor;
+	struct audio_info *info = NULL;
+	struct audio_info *tmp;
+	struct list_head *cursor;
+
+	pr_debug("audio_dev_open");
+
+	minor = iminor(inode);
+
+	/* Find the info struct for this file */
+	list_for_each(cursor, &cg2900_audio_devices) {
+		tmp = list_entry(cursor, struct audio_info, list);
+		if (tmp->misc_dev.minor == minor) {
+			info = tmp;
+			break;
+		}
+	}
+	if (!info) {
+		pr_err("Could not identify device in inode");
+		return -EINVAL;
+	}
+
+	/*
+	 * Allocate the char dev info structure. It will be stored inside
+	 * the file pointer and supplied when file_ops are called.
+	 * It's free'd in audio_dev_release.
+	 */
+	char_dev_info = kzalloc(sizeof(*char_dev_info), GFP_KERNEL);
+	if (!char_dev_info) {
+		dev_err(BT_DEV, "Couldn't allocate char_dev_info\n");
+		return -ENOMEM;
+	}
+	filp->private_data = char_dev_info;
+	char_dev_info->info = info;
+	info->filp = filp;
+
+	mutex_init(&char_dev_info->management_mutex);
+	mutex_init(&char_dev_info->rw_mutex);
+	skb_queue_head_init(&char_dev_info->rx_queue);
+
+	mutex_lock(&char_dev_info->management_mutex);
+	err = cg2900_audio_open(&char_dev_info->session, info->dev_bt->parent);
+	mutex_unlock(&char_dev_info->management_mutex);
+	if (err) {
+		dev_err(BT_DEV, "Failed to open CG2900 Audio driver (%d)\n",
+			err);
+		goto error_handling_free_mem;
+	}
+
+	return 0;
+
+error_handling_free_mem:
+	kfree(char_dev_info);
+	filp->private_data = NULL;
+	return err;
+}
+
+/**
+ * audio_dev_release() - Release char device.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   Errors from @cg2900_audio_close.
+ */
+static int audio_dev_release(struct inode *inode, struct file *filp)
+{
+	int err = 0;
+	struct char_dev_info *dev = filp->private_data;
+	struct audio_info *info;
+
+	if (!dev) {
+		pr_err("audio_dev_release: Transport closed");
+		return -EBADF;
+	}
+
+	info = dev->info;
+
+	dev_dbg(BT_DEV, "audio_dev_release\n");
+
+	mutex_lock(&dev->management_mutex);
+	err = cg2900_audio_close(&dev->session);
+	if (err)
+		/*
+		 * Just print the error. Still free the char_dev_info since we
+		 * don't know the filp structure is valid after this call
+		 */
+		dev_err(BT_DEV, "Error %d when closing CG2900 audio driver\n",
+			err);
+
+	mutex_unlock(&dev->management_mutex);
+
+	kfree(dev);
+	filp->private_data = NULL;
+	info->filp = NULL;
+
+	return err;
+}
+
+/**
+ * audio_dev_read() - Return information to the user from last @write call.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Received buffer.
+ * @count:	Size of buffer.
+ * @f_pos:	Position in buffer.
+ *
+ * The audio_dev_read() function returns information from
+ * the last @write call to same char device.
+ * The data is in the following format:
+ *   * OpCode of command for this data
+ *   * Data content (Length of data is determined by the command OpCode, i.e.
+ *     fixed for each command)
+ *
+ * Returns:
+ *   Bytes successfully read (could be 0).
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EFAULT if copy_to_user fails.
+ *   -ENOMEM upon allocation failure.
+ */
+static ssize_t audio_dev_read(struct file *filp, char __user *buf, size_t count,
+			      loff_t *f_pos)
+{
+	struct char_dev_info *dev = filp->private_data;
+	struct audio_info *info;
+	unsigned int bytes_to_copy;
+	int err = 0;
+	struct sk_buff *skb;
+
+	if (!dev) {
+		pr_err("audio_dev_read: Transport closed");
+		return -EBADF;
+	}
+
+	info = dev->info;
+
+	dev_dbg(BT_DEV, "audio_dev_read count %d\n", (int)count);
+
+	mutex_lock(&dev->rw_mutex);
+
+	skb = skb_dequeue(&dev->rx_queue);
+	if (!skb) {
+		/* No data to read */
+		bytes_to_copy = 0;
+		goto finished;
+	}
+
+	bytes_to_copy = min_t(size_t, count, skb->len);
+
+	err = copy_to_user(buf, skb->data, bytes_to_copy);
+	if (err) {
+		dev_err(BT_DEV, "copy_to_user error %d\n", err);
+		skb_queue_head(&dev->rx_queue, skb);
+		err = -EFAULT;
+		goto error_handling;
+	}
+
+	skb_pull(skb, bytes_to_copy);
+
+	if (skb->len > 0)
+		skb_queue_head(&dev->rx_queue, skb);
+	else
+		kfree_skb(skb);
+
+	goto finished;
+
+error_handling:
+	mutex_unlock(&dev->rw_mutex);
+	return (ssize_t)err;
+finished:
+	mutex_unlock(&dev->rw_mutex);
+	return bytes_to_copy;
+}
+
+/**
+ * audio_dev_write() - Call CG2900 Audio API function.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Write buffer.
+ * @count:	Size of the buffer write.
+ * @f_pos:	Position of buffer.
+ *
+ * audio_dev_write() function executes supplied data and
+ * interprets it as if it was a function call to the CG2900 Audio API.
+ * The data is according to:
+ *   * OpCode (4 bytes, see API).
+ *   * Data according to OpCode (see API). No padding between parameters.
+ *
+ * Returns:
+ *   Bytes successfully written (could be 0). Equals input @count if successful.
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EFAULT if copy_from_user fails.
+ *   Error codes from all CG2900 Audio API functions.
+ */
+static ssize_t audio_dev_write(struct file *filp, const char __user *buf,
+			       size_t count, loff_t *f_pos)
+{
+	u8 *rec_data;
+	struct char_dev_info *dev = filp->private_data;
+	struct audio_info *info;
+	int err = 0;
+	int op_code = 0;
+	u8 *curr_data;
+	unsigned int stream_handle;
+	struct cg2900_dai_config dai_config;
+	struct cg2900_endpoint_config ep_config;
+	enum cg2900_audio_endpoint_id ep_1;
+	enum cg2900_audio_endpoint_id ep_2;
+	int bytes_left = count;
+
+	pr_debug("audio_dev_write count %d", (int)count);
+
+	if (!dev) {
+		pr_err("audio_dev_write: Transport closed");
+		return -EBADF;
+	}
+	info = dev->info;
+
+	rec_data = kmalloc(count, GFP_KERNEL);
+	if (!rec_data) {
+		dev_err(BT_DEV, "kmalloc failed (%d bytes)\n", (int)count);
+		return -ENOMEM;
+	}
+
+	mutex_lock(&dev->rw_mutex);
+
+	err = copy_from_user(rec_data, buf, count);
+	if (err) {
+		dev_err(BT_DEV, "copy_from_user failed (%d)\n", err);
+		err = -EFAULT;
+		goto finished_mutex_unlock;
+	}
+
+	/* Initialize temporary data pointer used to traverse the packet */
+	curr_data = rec_data;
+
+	op_code = curr_data[0];
+	/* OpCode is int size to keep data int aligned */
+	curr_data += sizeof(unsigned int);
+	bytes_left -= sizeof(unsigned int);
+
+	switch (op_code) {
+	case CG2900_OPCODE_SET_DAI_CONF:
+		if (bytes_left < sizeof(dai_config)) {
+			dev_err(BT_DEV, "Not enough data supplied for "\
+				"CG2900_OPCODE_SET_DAI_CONF\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		memcpy(&dai_config, curr_data, sizeof(dai_config));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_SET_DAI_CONF port %d\n",
+			dai_config.port);
+		err = cg2900_audio_set_dai_config(dev->session, &dai_config);
+		break;
+
+	case CG2900_OPCODE_GET_DAI_CONF:
+		if (bytes_left < sizeof(dai_config)) {
+			dev_err(BT_DEV, "Not enough data supplied for "\
+				"CG2900_OPCODE_GET_DAI_CONF\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		/*
+		 * Only need to copy the port really, but let's copy
+		 * like this for simplicity. It's only test functionality
+		 * after all.
+		 */
+		memcpy(&dai_config, curr_data, sizeof(dai_config));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_GET_DAI_CONF port %d\n",
+			dai_config.port);
+		err = cg2900_audio_get_dai_config(dev->session, &dai_config);
+		if (!err) {
+			int len;
+			struct sk_buff *skb;
+
+			/*
+			 * Command succeeded. Store data so it can be returned
+			 * when calling read.
+			 */
+			len = sizeof(op_code) + sizeof(dai_config);
+			skb = alloc_skb(len, GFP_KERNEL);
+			if (!skb) {
+				dev_err(BT_DEV, "CG2900_OPCODE_GET_DAI_CONF: "\
+						"Could not allocate skb\n");
+				err = -ENOMEM;
+				goto finished_mutex_unlock;
+			}
+			memcpy(skb_put(skb, sizeof(op_code)), &op_code,
+			       sizeof(op_code));
+			memcpy(skb_put(skb, sizeof(dai_config)),
+			       &dai_config, sizeof(dai_config));
+			skb_queue_tail(&dev->rx_queue, skb);
+		}
+		break;
+
+	case CG2900_OPCODE_CONFIGURE_ENDPOINT:
+		if (bytes_left < sizeof(ep_config)) {
+			dev_err(BT_DEV, "Not enough data supplied for "\
+				"CG2900_OPCODE_CONFIGURE_ENDPOINT\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		memcpy(&ep_config, curr_data, sizeof(ep_config));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_CONFIGURE_ENDPOINT ep_id %d\n",
+			ep_config.endpoint_id);
+		err = cg2900_audio_config_endpoint(dev->session, &ep_config);
+		break;
+
+	case CG2900_OPCODE_START_STREAM:
+		if (bytes_left < (sizeof(ep_1) + sizeof(ep_2))) {
+			dev_err(BT_DEV, "Not enough data supplied for "\
+				"CG2900_OPCODE_START_STREAM\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		memcpy(&ep_1, curr_data, sizeof(ep_1));
+		curr_data += sizeof(ep_1);
+		memcpy(&ep_2, curr_data, sizeof(ep_2));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_START_STREAM ep_1 %d ep_2 %d\n",
+			ep_1, ep_2);
+
+		err = cg2900_audio_start_stream(dev->session,
+			ep_1, ep_2, &stream_handle);
+		if (!err) {
+			int len;
+			struct sk_buff *skb;
+
+			/*
+			 * Command succeeded. Store data so it can be returned
+			 * when calling read.
+			 */
+			len = sizeof(op_code) + sizeof(stream_handle);
+			skb = alloc_skb(len, GFP_KERNEL);
+			if (!skb) {
+				dev_err(BT_DEV, "CG2900_OPCODE_START_STREAM: "\
+						"Could not allocate skb\n");
+				err = -ENOMEM;
+				goto finished_mutex_unlock;
+			}
+			memcpy(skb_put(skb, sizeof(op_code)), &op_code,
+			       sizeof(op_code));
+			memcpy(skb_put(skb, sizeof(stream_handle)),
+			       &stream_handle, sizeof(stream_handle));
+			skb_queue_tail(&dev->rx_queue, skb);
+
+			dev_dbg(BT_DEV, "stream_handle %d\n", stream_handle);
+		}
+		break;
+
+	case CG2900_OPCODE_STOP_STREAM:
+		if (bytes_left < sizeof(stream_handle)) {
+			dev_err(BT_DEV, "Not enough data supplied for "\
+				"CG2900_OPCODE_STOP_STREAM\n");
+			err = -EINVAL;
+			goto finished_mutex_unlock;
+		}
+		memcpy(&stream_handle, curr_data, sizeof(stream_handle));
+		dev_dbg(BT_DEV, "CG2900_OPCODE_STOP_STREAM stream_handle %d\n",
+			stream_handle);
+		err = cg2900_audio_stop_stream(dev->session, stream_handle);
+		break;
+
+	default:
+		dev_err(BT_DEV, "Received bad op_code %d\n", op_code);
+		break;
+	};
+
+finished_mutex_unlock:
+	kfree(rec_data);
+	mutex_unlock(&dev->rw_mutex);
+
+	if (err)
+		return err;
+	else
+		return count;
+}
+
+/**
+ * audio_dev_poll() - Handle POLL call to the interface.
+ * @filp:	Pointer to the file struct.
+ * @wait:	Poll table supplied to caller.
+ *
+ * This function is used by the User Space application to see if the device is
+ * still open and if there is any data available for reading.
+ *
+ * Returns:
+ *   Mask of current set POLL values.
+ */
+static unsigned int audio_dev_poll(struct file *filp, poll_table *wait)
+{
+	struct char_dev_info *dev = filp->private_data;
+	struct audio_info *info;
+	unsigned int mask = 0;
+
+	if (!dev) {
+		pr_err("audio_dev_poll: Transport closed");
+		return POLLERR | POLLRDHUP;
+	}
+	info = dev->info;
+
+	if (RESET == info->state)
+		mask |= POLLERR | POLLRDHUP | POLLPRI;
+	else
+		/* Unless RESET we can transmit */
+		mask |= POLLOUT;
+
+	if (!skb_queue_empty(&dev->rx_queue))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static const struct file_operations char_dev_fops = {
+	.open = audio_dev_open,
+	.release = audio_dev_release,
+	.read = audio_dev_read,
+	.write = audio_dev_write,
+	.poll = audio_dev_poll
+};
+
+/**
+ * probe_common() - Register misc device.
+ * @info:	Audio info structure.
+ * @dev:	Current device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   Error codes from misc_register.
+ */
+static int probe_common(struct audio_info *info, struct device *dev)
+{
+	struct audio_cb_info *cb_info;
+	struct cg2900_user_data *pf_data;
+	int err;
+
+	cb_info = kzalloc(sizeof(*cb_info), GFP_KERNEL);
+	if (!cb_info) {
+		dev_err(dev, "Failed to allocate cb_info\n");
+		return -ENOMEM;
+	}
+	init_waitqueue_head(&cb_info->wq);
+	skb_queue_head_init(&cb_info->skb_queue);
+
+	pf_data = dev_get_platdata(dev);
+	cg2900_set_usr(pf_data, cb_info);
+	pf_data->dev = dev;
+	pf_data->read_cb = read_cb;
+	pf_data->reset_cb = reset_cb;
+
+	/* Only register misc device when both devices (BT and FM) are probed */
+	if (!info->dev_bt || !info->dev_fm)
+		return 0;
+
+	/* Prepare and register MISC device */
+	info->misc_dev.minor = MISC_DYNAMIC_MINOR;
+	info->misc_dev.name = NAME;
+	info->misc_dev.fops = &char_dev_fops;
+	info->misc_dev.parent = dev;
+	info->misc_dev.mode = S_IRUGO | S_IWUGO;
+
+	err = misc_register(&info->misc_dev);
+	if (err) {
+		dev_err(dev, "Error %d registering misc dev\n", err);
+		return err;
+	}
+	info->misc_registered = true;
+
+	dev_info(dev, "CG2900 Audio driver started\n");
+	return 0;
+}
+
+/**
+ * cg2900_audio_bt_probe() - Initialize CG2900 BT audio resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   -EEXIST if device has already been started.
+ *   Error codes from probe_common.
+ */
+static int __devinit cg2900_audio_bt_probe(struct platform_device *pdev)
+{
+	int err;
+	struct audio_info *info;
+
+	dev_dbg(&pdev->dev, "cg2900_audio_bt_probe\n");
+
+	info = get_info(&pdev->dev);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->dev_bt = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, info);
+
+	err = probe_common(info, &pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "Could not probe audio BT (%d)\n", err);
+		dev_set_drvdata(&pdev->dev, NULL);
+		device_removed(info);
+	}
+
+	return err;
+}
+
+/**
+ * cg2900_audio_bt_probe() - Initialize CG2900 FM audio resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -ENOMEM if allocation fails.
+ *   -EEXIST if device has already been started.
+ *   Error codes from probe_common.
+ */
+static int __devinit cg2900_audio_fm_probe(struct platform_device *pdev)
+{
+	int err;
+	struct audio_info *info;
+
+	dev_dbg(&pdev->dev, "cg2900_audio_fm_probe\n");
+
+	info = get_info(&pdev->dev);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
+
+	info->dev_fm = &pdev->dev;
+	dev_set_drvdata(&pdev->dev, info);
+
+	err = probe_common(info, &pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "Could not probe audio FM (%d)\n", err);
+		dev_set_drvdata(&pdev->dev, NULL);
+		device_removed(info);
+	}
+
+	return err;
+}
+
+/**
+ * common_remove() - Dergister misc device.
+ * @info:	Audio info structure.
+ * @dev:	Current device.
+ *
+ * Returns:
+ *   0 if success.
+ *   Error codes from misc_deregister.
+ */
+static int common_remove(struct audio_info *info, struct device *dev)
+{
+	int err;
+	struct audio_cb_info *cb_info;
+	struct cg2900_user_data *pf_data;
+
+	pf_data = dev_get_platdata(dev);
+	cb_info = cg2900_get_usr(pf_data);
+	skb_queue_purge(&cb_info->skb_queue);
+	wake_up_all(&cb_info->wq);
+	kfree(cb_info);
+
+	if (!info->misc_registered)
+		return 0;
+
+	err = misc_deregister(&info->misc_dev);
+	if (err)
+		dev_err(dev, "Error %d deregistering misc dev\n", err);
+	info->misc_registered = false;
+
+	if (info->filp)
+		info->filp->private_data = NULL;
+
+	dev_info(dev, "CG2900 Audio driver removed\n");
+	return err;
+}
+
+/**
+ * cg2900_audio_bt_remove() - Release CG2900 audio resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   Error codes from common_remove.
+ */
+static int __devexit cg2900_audio_bt_remove(struct platform_device *pdev)
+{
+	int err;
+	struct audio_info *info;
+
+	dev_dbg(&pdev->dev, "cg2900_audio_bt_remove\n");
+
+	info = dev_get_drvdata(&pdev->dev);
+
+	info->dev_bt = NULL;
+
+	err = common_remove(info, &pdev->dev);
+	if (err)
+		dev_err(&pdev->dev,
+			"cg2900_audio_bt_remove:common_remove failed\n");
+
+	device_removed(info);
+
+	return 0;
+}
+
+/**
+ * cg2900_audio_fm_remove() - Release CG2900 audio resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   Error codes from common_remove.
+ */
+static int __devexit cg2900_audio_fm_remove(struct platform_device *pdev)
+{
+	int err;
+	struct audio_info *info;
+
+	dev_dbg(&pdev->dev, "cg2900_audio_fm_remove\n");
+
+	info = dev_get_drvdata(&pdev->dev);
+
+	info->dev_fm = NULL;
+
+	err = common_remove(info, &pdev->dev);
+	if (err)
+		dev_err(&pdev->dev,
+			"cg2900_audio_fm_remove:common_remove failed\n");
+
+	device_removed(info);
+
+	return 0;
+}
+
+static struct platform_driver cg2900_audio_bt_driver = {
+	.driver = {
+		.name	= "cg2900-audiovs",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_audio_bt_probe,
+	.remove	= __devexit_p(cg2900_audio_bt_remove),
+};
+
+static struct platform_driver cg2900_audio_fm_driver = {
+	.driver = {
+		.name	= "cg2900-audiofm",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_audio_fm_probe,
+	.remove	= __devexit_p(cg2900_audio_fm_remove),
+};
+
+/**
+ * cg2900_audio_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init cg2900_audio_init(void)
+{
+	int err;
+
+	pr_debug("cg2900_audio_init");
+
+	err = platform_driver_register(&cg2900_audio_bt_driver);
+	if (err)
+		return err;
+	return platform_driver_register(&cg2900_audio_fm_driver);
+}
+
+/**
+ * cg2900_audio_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit cg2900_audio_exit(void)
+{
+	pr_debug("cg2900_audio_exit");
+	platform_driver_unregister(&cg2900_audio_fm_driver);
+	platform_driver_unregister(&cg2900_audio_bt_driver);
+}
+
+module_init(cg2900_audio_init);
+module_exit(cg2900_audio_exit);
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_AUTHOR("Kjell Andersson ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux Bluetooth Audio ST-Ericsson controller");
diff --git a/drivers/staging/cg2900/mfd/cg2900_char_devices.c b/drivers/staging/cg2900/mfd/cg2900_char_devices.c
new file mode 100755
index 0000000..af49560
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_char_devices.c
@@ -0,0 +1,802 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson connectivity controller.
+ */
+#define NAME					"cg2900_char_dev"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <linux/compiler.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/mfd/core.h>
+#include <linux/clk.h>
+
+#include "cg2900.h"
+#include "cg2900_core.h"
+
+#define MAIN_DEV				(dev->dev)
+
+/**
+ * struct char_dev_user - Stores device information.
+ * @dev:		Current device.
+ * @miscdev:		Registered device struct.
+ * @filp:		Current file pointer.
+ * @name:		Name of device.
+ * @rx_queue:		Data queue.
+ * @rx_wait_queue:	Wait queue.
+ * @reset_wait_queue:	Reset Wait queue.
+ * @read_mutex:		Read mutex.
+ * @write_mutex:	Write mutex.
+ * @list:		List header for inserting into device list.
+ */
+struct char_dev_user {
+	struct device		*dev;
+	struct miscdevice	miscdev;
+	struct file		*filp;
+	char			*name;
+	struct sk_buff_head	rx_queue;
+	wait_queue_head_t	rx_wait_queue;
+	wait_queue_head_t	reset_wait_queue;
+	struct mutex		read_mutex;
+	struct mutex		write_mutex;
+	struct list_head	list;
+};
+
+/**
+ * struct char_info - Stores all current users.
+ * @open_mutex:	Open mutex (used for both open and release).
+ * @man_mutex:	Management mutex.
+ * @dev_users:	List of char dev users.
+ */
+struct char_info {
+	struct mutex		open_mutex;
+	struct mutex		man_mutex;
+	struct list_head	dev_users;
+};
+
+static struct char_info *char_info;
+
+/**
+ * char_dev_read_cb() - Handle data received from controller.
+ * @dev:	Device receiving data.
+ * @skb:	Buffer with data coming from controller.
+ *
+ * The char_dev_read_cb() function handles data received from the CG2900 driver.
+ */
+static void char_dev_read_cb(struct cg2900_user_data *dev, struct sk_buff *skb)
+{
+	struct char_dev_user *char_dev = dev_get_drvdata(dev->dev);
+
+	dev_dbg(dev->dev, "char_dev_read_cb len %d\n", skb->len);
+
+	skb_queue_tail(&char_dev->rx_queue, skb);
+
+	wake_up_interruptible(&char_dev->rx_wait_queue);
+}
+
+/**
+ * char_dev_reset_cb() - Handle reset from controller.
+ * @dev:	Device resetting.
+ *
+ * The char_dev_reset_cb() function handles reset from the CG2900 driver.
+ */
+static void char_dev_reset_cb(struct cg2900_user_data *dev)
+{
+	struct char_dev_user *char_dev = dev_get_drvdata(dev->dev);
+
+	dev_dbg(dev->dev, "char_dev_reset_cb\n");
+
+	wake_up_interruptible(&char_dev->rx_wait_queue);
+	wake_up_interruptible(&char_dev->reset_wait_queue);
+}
+
+/**
+ * char_dev_open() - Open char device.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * The char_dev_open() function opens the char device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if device cannot be found in device list.
+ *   Error codes from cg2900->open.
+ */
+static int char_dev_open(struct inode *inode, struct file *filp)
+{
+	int err;
+	int minor;
+	struct char_dev_user *dev = NULL;
+	struct char_dev_user *tmp;
+	struct list_head *cursor;
+	struct cg2900_user_data *user;
+
+	mutex_lock(&char_info->open_mutex);
+
+	minor = iminor(inode);
+
+	/* Find the device for this file */
+	mutex_lock(&char_info->man_mutex);
+	list_for_each(cursor, &char_info->dev_users) {
+		tmp = list_entry(cursor, struct char_dev_user, list);
+		if (tmp->miscdev.minor == minor) {
+			dev = tmp;
+			break;
+		}
+	}
+	mutex_unlock(&char_info->man_mutex);
+	if (!dev) {
+		pr_err("Could not identify device in inode");
+		err = -EINVAL;
+		goto error_handling;
+	}
+
+	filp->private_data = dev;
+	dev->filp = filp;
+	user = dev_get_platdata(dev->dev);
+
+	/* First initiate wait queues for this device. */
+	init_waitqueue_head(&dev->rx_wait_queue);
+	init_waitqueue_head(&dev->reset_wait_queue);
+
+	/* Register to CG2900 Driver */
+	err = user->open(user);
+	if (err) {
+		dev_err(MAIN_DEV,
+			"Couldn't register to CG2900 for H:4 channel %s\n",
+			dev->name);
+		goto error_handling;
+	}
+	dev_info(MAIN_DEV, "char_dev %s opened\n", dev->name);
+
+error_handling:
+	mutex_unlock(&char_info->open_mutex);
+	return err;
+}
+
+/**
+ * char_dev_flush() - flushes read queue.
+ * @filp:	Pointer to the file struct.
+ *
+ * The char_dev_flush() function purges read queue
+ * and releases rx and reset wait queue
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EBADF if NULL pointer was supplied in private data.
+ */
+static int char_dev_flush(struct file *filp, fl_owner_t id)
+{
+	int err = 0;
+	struct char_dev_user *dev = filp->private_data;
+
+	pr_debug("char_dev_flush");
+
+	if (!dev) {
+		pr_err("char_dev_flush: Calling with NULL pointer");
+		return -EBADF;
+	}
+
+	mutex_lock(&char_info->open_mutex);
+	mutex_lock(&dev->read_mutex);
+	mutex_lock(&dev->write_mutex);
+
+	/* Purge the queue */
+	skb_queue_purge(&dev->rx_queue);
+
+	wake_up_interruptible(&dev->rx_wait_queue);
+	wake_up_interruptible(&dev->reset_wait_queue);
+
+	mutex_unlock(&dev->write_mutex);
+	mutex_unlock(&dev->read_mutex);
+	mutex_unlock(&char_info->open_mutex);
+
+	return err;
+}
+
+/**
+ * char_dev_release() - Release char device.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * The char_dev_release() function release the char device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EBADF if NULL pointer was supplied in private data.
+ */
+static int char_dev_release(struct inode *inode, struct file *filp)
+{
+	int err = 0;
+	struct char_dev_user *dev = filp->private_data;
+	struct cg2900_user_data *user;
+
+	pr_debug("char_dev_release");
+
+	if (!dev) {
+		pr_err("char_dev_release: Calling with NULL pointer");
+		return -EBADF;
+	}
+
+	mutex_lock(&char_info->open_mutex);
+	mutex_lock(&dev->read_mutex);
+	mutex_lock(&dev->write_mutex);
+
+	user = dev_get_platdata(dev->dev);
+	if (user->opened)
+		user->close(user);
+
+	dev_info(MAIN_DEV, "char_dev %s closed\n", dev->name);
+
+	filp->private_data = NULL;
+	dev->filp = NULL;
+	wake_up_interruptible(&dev->rx_wait_queue);
+	wake_up_interruptible(&dev->reset_wait_queue);
+
+	/* Purge the queue since the device is closed now */
+	skb_queue_purge(&dev->rx_queue);
+
+	mutex_unlock(&dev->write_mutex);
+	mutex_unlock(&dev->read_mutex);
+	mutex_unlock(&char_info->open_mutex);
+
+	return err;
+}
+
+/**
+ * char_dev_read() - Queue and copy buffer to user.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Received buffer.
+ * @count:	Size of buffer.
+ * @f_pos:	Position in buffer.
+ *
+ * The char_dev_read() function queues and copy the received buffer to
+ * the user space char device. If no data is available this function will block.
+ *
+ * Returns:
+ *   Bytes successfully read (could be 0).
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EFAULT if copy_to_user fails.
+ *   Error codes from wait_event_interruptible.
+ */
+static ssize_t char_dev_read(struct file *filp, char __user *buf, size_t count,
+			     loff_t *f_pos)
+{
+	struct char_dev_user *dev = filp->private_data;
+	struct cg2900_user_data *user;
+	struct sk_buff *skb;
+	int bytes_to_copy;
+	int err = 0;
+
+	pr_debug("char_dev_read");
+
+	if (!dev) {
+		pr_err("char_dev_read: Calling with NULL pointer");
+		return -EBADF;
+	}
+	mutex_lock(&dev->read_mutex);
+
+	user = dev_get_platdata(dev->dev);
+
+	if (user->opened && skb_queue_empty(&dev->rx_queue)) {
+		err = wait_event_interruptible(dev->rx_wait_queue,
+				(!(skb_queue_empty(&dev->rx_queue))) ||
+				!user->opened);
+		if (err) {
+			dev_err(MAIN_DEV, "Failed to wait for event\n");
+			goto error_handling;
+		}
+	}
+
+	if (!user->opened) {
+		dev_err(MAIN_DEV, "Channel has been closed\n");
+		err = -EBADF;
+		goto error_handling;
+	}
+
+	skb = skb_dequeue(&dev->rx_queue);
+	if (!skb) {
+		dev_dbg(MAIN_DEV,
+			"skb queue is empty - return with zero bytes\n");
+		bytes_to_copy = 0;
+		goto finished;
+	}
+
+	bytes_to_copy = min_t(size_t, count, skb->len);
+
+	err = copy_to_user(buf, skb->data, bytes_to_copy);
+	if (err) {
+		dev_err(MAIN_DEV, "Error %d from copy_to_user\n", err);
+		skb_queue_head(&dev->rx_queue, skb);
+		err = -EFAULT;
+		goto error_handling;
+	}
+
+	skb_pull(skb, bytes_to_copy);
+
+	if (skb->len > 0)
+		skb_queue_head(&dev->rx_queue, skb);
+	else
+		kfree_skb(skb);
+
+	goto finished;
+
+error_handling:
+	mutex_unlock(&dev->read_mutex);
+	return (ssize_t)err;
+finished:
+	mutex_unlock(&dev->read_mutex);
+	return bytes_to_copy;
+}
+
+/**
+ * char_dev_write() - Copy buffer from user and write to CG2900 driver.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Write buffer.
+ * @count:	Size of the buffer write.
+ * @f_pos:	Position of buffer.
+ *
+ * Returns:
+ *   Bytes successfully written (could be 0).
+ *   -EBADF if NULL pointer was supplied in private data.
+ *   -EFAULT if copy_from_user fails.
+ */
+static ssize_t char_dev_write(struct file *filp, const char __user *buf,
+			      size_t count, loff_t *f_pos)
+{
+	struct sk_buff *skb;
+	struct char_dev_user *dev = filp->private_data;
+	struct cg2900_user_data *user;
+	int err = 0;
+
+	pr_debug("char_dev_write");
+
+	if (!dev) {
+		pr_err("char_dev_write: Calling with NULL pointer");
+		return -EBADF;
+	}
+
+	user = dev_get_platdata(dev->dev);
+	if (!user->opened) {
+		dev_err(MAIN_DEV, "char_dev_write: Channel not opened\n");
+		return -EACCES;
+	}
+
+	mutex_lock(&dev->write_mutex);
+
+	skb = user->alloc_skb(count, GFP_ATOMIC);
+	if (!skb) {
+		dev_err(MAIN_DEV, "Couldn't allocate sk_buff with length %d\n",
+			(int)count);
+		goto error_handling;
+	}
+
+	err = copy_from_user(skb_put(skb, count), buf, count);
+	if (err) {
+		dev_err(MAIN_DEV, "Error %d from copy_from_user\n", err);
+		kfree_skb(skb);
+		err = -EFAULT;
+		goto error_handling;
+	}
+
+	err = user->write(user, skb);
+	if (err) {
+		dev_err(MAIN_DEV, "cg2900_write failed (%d)\n", err);
+		kfree_skb(skb);
+		goto error_handling;
+	}
+
+	mutex_unlock(&dev->write_mutex);
+	return count;
+
+error_handling:
+	mutex_unlock(&dev->write_mutex);
+	return err;
+}
+
+/**
+ * char_dev_unlocked_ioctl() - Handle IOCTL call to the interface.
+ * @filp:	Pointer to the file struct.
+ * @cmd:	IOCTL command.
+ * @arg:	IOCTL argument.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if supplied cmd is not supported.
+ *   For cmd CG2900_CHAR_DEV_IOCTL_CHECK4RESET 0x01 is returned if device is
+ *   reset and 0x02 is returned if device is closed.
+ */
+static long char_dev_unlocked_ioctl(struct file *filp, unsigned int cmd,
+				    unsigned long arg)
+{
+	struct char_dev_user *dev = filp->private_data;
+	struct cg2900_user_data *user;
+	struct cg2900_rev_data rev_data;
+	int err = 0;
+	int ret_val;
+	void __user *user_arg = (void __user *)arg;
+	struct clk *clk = NULL;
+
+	if (!dev) {
+		pr_err("char_dev_unlocked_ioctl: Calling with NULL pointer");
+		return -EBADF;
+	}
+
+	dev_dbg(dev->dev, "char_dev_unlocked_ioctl for %s\n"\
+		"\tDIR: %d\n"\
+		"\tTYPE: %d\n"\
+		"\tNR: %d\n"\
+		"\tSIZE: %d",
+		dev->name, _IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd),
+		_IOC_SIZE(cmd));
+
+	user = dev_get_platdata(dev->dev);
+
+	switch (cmd) {
+	case CG2900_CHAR_DEV_IOCTL_RESET:
+		if (!user->opened)
+			return -EACCES;
+		dev_dbg(MAIN_DEV, "ioctl reset command for device %s\n",
+			dev->name);
+		err = user->reset(user);
+		break;
+
+	case CG2900_CHAR_DEV_IOCTL_CHECK4RESET:
+		if (user->opened)
+			ret_val = CG2900_CHAR_DEV_IOCTL_EVENT_IDLE;
+		else
+			ret_val = CG2900_CHAR_DEV_IOCTL_EVENT_RESET;
+
+		dev_dbg(MAIN_DEV, "ioctl check for reset command for device %s",
+			dev->name);
+
+		err = copy_to_user(user_arg, &ret_val, sizeof(ret_val));
+		if (err) {
+			dev_err(MAIN_DEV,
+				"Error %d from copy_to_user for reset\n", err);
+			return -EFAULT;
+		}
+		break;
+
+	case CG2900_CHAR_DEV_IOCTL_GET_REVISION:
+		if (!user->get_local_revision(user, &rev_data)) {
+			dev_err(MAIN_DEV, "No revision data available\n");
+			return -EIO;
+		}
+		dev_dbg(MAIN_DEV, "ioctl check for local revision info\n"\
+			"\trevision 0x%04X\n"\
+			"\tsub_version 0x%04X\n",
+			rev_data.revision, rev_data.sub_version);
+		err = copy_to_user(user_arg, &rev_data, sizeof(rev_data));
+		if (err) {
+			dev_err(MAIN_DEV,
+				"Error %d from copy_to_user for "
+				"revision\n", err);
+			return -EFAULT;
+		}
+		break;
+
+	case CG2900_CHAR_DEV_IOCTL_EXT_CLK_ENABLE:
+		if (!user->opened)
+			return -EACCES;
+		dev_dbg(MAIN_DEV, "ioctl clk_get enable "\
+				"command for device %s\n", dev->name);
+
+		clk = clk_get(dev->dev, "sysclk3");
+		if (IS_ERR(clk)) {
+			dev_dbg(MAIN_DEV, "ioctl clk_get enable "\
+					"command for device %s failed\n",
+					dev->name);
+			return -EFAULT;
+		} else {
+			err = clk_enable(clk);
+			if (err) {
+				dev_dbg(MAIN_DEV, "clk_enable failed:%d "\
+						"for %s\n", err, dev->name);
+				return err;
+			}
+		}
+		break;
+
+	case CG2900_CHAR_DEV_IOCTL_EXT_CLK_DISABLE:
+		if (!user->opened)
+			return -EACCES;
+		dev_dbg(MAIN_DEV, "ioctl clk_get disable "\
+				"command for device %s\n", dev->name);
+
+		clk = clk_get(dev->dev, "sysclk3");
+		if (IS_ERR(clk)) {
+			dev_dbg(MAIN_DEV, "ioctl clk_get disable "\
+					"command for device %s failed\n",
+					dev->name);
+			return -EFAULT;
+		} else
+			clk_disable(clk);
+
+		break;
+
+	default:
+		dev_err(MAIN_DEV, "Unknown ioctl command %08X\n", cmd);
+		err = -EINVAL;
+		break;
+	};
+
+	return err;
+}
+
+/**
+ * char_dev_poll() - Handle POLL call to the interface.
+ * @filp:	Pointer to the file struct.
+ * @wait:	Poll table supplied to caller.
+ *
+ * Returns:
+ *   Mask of current set POLL values
+ */
+static unsigned int char_dev_poll(struct file *filp, poll_table *wait)
+{
+	struct char_dev_user *dev = filp->private_data;
+	struct cg2900_user_data *user;
+	unsigned int mask = 0;
+
+	if (!dev) {
+		pr_debug("char_dev_poll: Device not open");
+		return POLLERR | POLLRDHUP;
+	}
+
+	user = dev_get_platdata(dev->dev);
+
+	poll_wait(filp, &dev->reset_wait_queue, wait);
+	poll_wait(filp, &dev->rx_wait_queue, wait);
+
+	if (!user->opened)
+		mask |= POLLERR | POLLRDHUP | POLLPRI;
+	else
+		mask |= POLLOUT; /* We can TX unless there is an error */
+
+	if (!(skb_queue_empty(&dev->rx_queue)))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+/*
+ * struct char_dev_fops - Char devices file operations.
+ * @read:		Function that reads from the char device.
+ * @write:		Function that writes to the char device.
+ * @unlocked_ioctl:	Function that performs IO operations with
+ *			the char device.
+ * @poll:		Function that checks if there are possible operations
+ *			with the char device.
+ * @open:		Function that opens the char device.
+ * @flush:		Function that flushes rx queue and releases wait queues
+ * @release:		Function that release the char device.
+ */
+static const struct file_operations char_dev_fops = {
+	.read		= char_dev_read,
+	.write		= char_dev_write,
+	.unlocked_ioctl	= char_dev_unlocked_ioctl,
+	.poll		= char_dev_poll,
+	.open		= char_dev_open,
+	.flush		= char_dev_flush,
+	.release	= char_dev_release
+};
+
+/**
+ * remove_dev() - Remove char device structure for device.
+ * @dev_usr:	Char device user.
+ *
+ * The remove_dev() function releases the char_dev structure for this device.
+ */
+static void remove_dev(struct char_dev_user *dev_usr)
+{
+	if (!dev_usr)
+		return;
+
+	dev_dbg(dev_usr->dev,
+		"Removing char device %s with major %d and minor %d\n",
+		dev_usr->name,
+		MAJOR(dev_usr->miscdev.this_device->devt),
+		MINOR(dev_usr->miscdev.this_device->devt));
+
+	skb_queue_purge(&dev_usr->rx_queue);
+
+	mutex_destroy(&dev_usr->read_mutex);
+	mutex_destroy(&dev_usr->write_mutex);
+
+	dev_usr->dev = NULL;
+	if (dev_usr->filp)
+		dev_usr->filp->private_data = NULL;
+
+	/* Remove device node in file system. */
+	misc_deregister(&dev_usr->miscdev);
+	kfree(dev_usr);
+}
+
+/**
+ * cg2900_char_probe() - Initialize char device module.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM if allocation fails.
+ *   -EACCES if device already have been initiated.
+ */
+static int __devinit cg2900_char_probe(struct platform_device *pdev)
+{
+	int err = 0;
+	struct char_dev_user *dev_usr;
+	struct cg2900_user_data *user;
+	struct device *dev = &pdev->dev;
+
+	dev_dbg(&pdev->dev, "cg2900_char_probe\n");
+
+	user = dev_get_platdata(dev);
+	user->dev = dev;
+	user->read_cb = char_dev_read_cb;
+	user->reset_cb = char_dev_reset_cb;
+
+	dev_usr = kzalloc(sizeof(*dev_usr), GFP_KERNEL);
+	if (!dev_usr) {
+		dev_err(&pdev->dev, "Couldn't allocate dev_usr\n");
+		return -ENOMEM;
+	}
+
+	dev_set_drvdata(&pdev->dev, dev_usr);
+	dev_usr->dev = &pdev->dev;
+
+	/* Store device name */
+	dev_usr->name = user->channel_data.char_dev_name;
+
+	/* Prepare miscdevice struct before registering the device */
+	dev_usr->miscdev.minor = MISC_DYNAMIC_MINOR;
+	dev_usr->miscdev.name = dev_usr->name;
+	dev_usr->miscdev.nodename = dev_usr->name;
+	dev_usr->miscdev.fops = &char_dev_fops;
+	dev_usr->miscdev.parent = &pdev->dev;
+	dev_usr->miscdev.mode = S_IRUGO | S_IWUGO;
+
+	err = misc_register(&dev_usr->miscdev);
+	if (err) {
+		dev_err(&pdev->dev, "Error %d registering misc dev\n", err);
+		goto err_free_usr;
+	}
+
+	dev_dbg(&pdev->dev, "Added char device %s with major %d and minor %d\n",
+		dev_usr->name, MAJOR(dev_usr->miscdev.this_device->devt),
+		MINOR(dev_usr->miscdev.this_device->devt));
+
+	mutex_init(&dev_usr->read_mutex);
+	mutex_init(&dev_usr->write_mutex);
+
+	skb_queue_head_init(&dev_usr->rx_queue);
+
+	mutex_lock(&char_info->man_mutex);
+	list_add_tail(&dev_usr->list, &char_info->dev_users);
+	mutex_unlock(&char_info->man_mutex);
+
+	return 0;
+
+err_free_usr:
+	kfree(dev_usr);
+	dev_set_drvdata(&pdev->dev, NULL);
+	return err;
+}
+
+/**
+ * cg2900_char_remove() - Release the char device module.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success (always success).
+ */
+static int __devexit cg2900_char_remove(struct platform_device *pdev)
+{
+	struct list_head *cursor, *next;
+	struct char_dev_user *tmp;
+	struct char_dev_user *user;
+
+	dev_dbg(&pdev->dev, "cg2900_char_remove\n");
+
+	user = dev_get_drvdata(&pdev->dev);
+
+	mutex_lock(&char_info->man_mutex);
+	list_for_each_safe(cursor, next, &char_info->dev_users) {
+		tmp = list_entry(cursor, struct char_dev_user, list);
+		if (tmp == user) {
+			list_del(cursor);
+			remove_dev(tmp);
+			dev_set_drvdata(&pdev->dev, NULL);
+			break;
+		}
+	}
+	mutex_unlock(&char_info->man_mutex);
+	return 0;
+}
+
+static struct platform_driver cg2900_char_driver = {
+	.driver = {
+		.name	= "cg2900-chardev",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_char_probe,
+	.remove	= __devexit_p(cg2900_char_remove),
+};
+
+/**
+ * cg2900_char_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init cg2900_char_init(void)
+{
+	pr_debug("cg2900_char_init");
+
+	/* Initialize private data. */
+	char_info = kzalloc(sizeof(*char_info), GFP_ATOMIC);
+	if (!char_info) {
+		pr_err("Could not alloc char_info struct");
+		return -ENOMEM;
+	}
+
+	mutex_init(&char_info->open_mutex);
+	mutex_init(&char_info->man_mutex);
+	INIT_LIST_HEAD(&char_info->dev_users);
+
+	return platform_driver_register(&cg2900_char_driver);
+}
+
+/**
+ * cg2900_char_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit cg2900_char_exit(void)
+{
+	struct list_head *cursor, *next;
+	struct char_dev_user *tmp;
+
+	pr_debug("cg2900_char_exit");
+
+	platform_driver_unregister(&cg2900_char_driver);
+
+	if (!char_info)
+		return;
+
+	list_for_each_safe(cursor, next, &char_info->dev_users) {
+		tmp = list_entry(cursor, struct char_dev_user, list);
+		list_del(cursor);
+		remove_dev(tmp);
+	}
+
+	mutex_destroy(&char_info->open_mutex);
+	mutex_destroy(&char_info->man_mutex);
+
+	kfree(char_info);
+	char_info = NULL;
+}
+
+module_init(cg2900_char_init);
+module_exit(cg2900_char_exit);
+
+MODULE_AUTHOR("Henrik Possung ST-Ericsson");
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("ST-Ericsson CG2900 Char Devices Driver");
diff --git a/drivers/staging/cg2900/mfd/cg2900_chip.c b/drivers/staging/cg2900/mfd/cg2900_chip.c
new file mode 100644
index 0000000..be26427
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_chip.c
@@ -0,0 +1,3986 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * Hemant Gupta (hemant.gupta@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+#define NAME					"cg2900_chip"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <asm/byteorder.h>
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/stat.h>
+#include <linux/string.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/mfd/core.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include "cg2900.h"
+#include "cg2900_chip.h"
+#include "cg2900_core.h"
+#include "cg2900_lib.h"
+
+#ifndef MAX
+#define MAX(x, y) (((x) > (y)) ? (x) : (y))
+#endif
+
+#define MAIN_DEV				(main_info->dev)
+#define BOOT_DEV				(info->user_in_charge->dev)
+
+#define WQ_NAME					"cg2900_chip_wq"
+
+/*
+ * After waiting the first 500 ms we should just try to get the selftest results
+ * for another number of poll attempts
+ */
+#define MAX_NBR_OF_POLLS			50
+
+#define LINE_TOGGLE_DETECT_TIMEOUT		100	/* ms */
+#define CHIP_READY_TIMEOUT			100	/* ms */
+#define CHIP_STARTUP_TIMEOUT			15000	/* ms */
+#define CHIP_SHUTDOWN_TIMEOUT			15000	/* ms */
+#define POWER_SW_OFF_WAIT			500	/* ms */
+#define SELFTEST_INITIAL			40	/* ms */
+#define SELFTEST_POLLING			20	/* ms */
+
+/** CHANNEL_BT_CMD - Bluetooth HCI H:4 channel
+ * for Bluetooth commands in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_CMD				0x01
+
+/** CHANNEL_BT_ACL - Bluetooth HCI H:4 channel
+ * for Bluetooth ACL data in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_ACL				0x02
+
+/** CHANNEL_BT_EVT - Bluetooth HCI H:4 channel
+ * for Bluetooth events in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_EVT				0x04
+
+/** CHANNEL_NFC - Bluetooth HCI H:4 channel
+ * for NFC in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_NFC			0x05
+
+/** CHANNEL_ANT_CMD - Bluetooth HCI H:4 channel
+ * for ANT command in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_ANT_CMD			0x0C
+
+/** CHANNEL_ANT_DAT - Bluetooth HCI H:4 channel
+ * for ANT data in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_ANT_DAT			0x0E
+
+/** CHANNEL_FM_RADIO - Bluetooth HCI H:4 channel
+ * for FM radio in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_FM_RADIO			0x08
+
+/** CHANNEL_GNSS - Bluetooth HCI H:4 channel
+ * for GNSS in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_GNSS				0x09
+
+/** CHANNEL_DEBUG - Bluetooth HCI H:4 channel
+ * for internal debug data in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_DEBUG				0x0B
+
+/** CHANNEL_STE_TOOLS - Bluetooth HCI H:4 channel
+ * for development tools data in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_STE_TOOLS			0x0D
+
+/** CHANNEL_DEV_MGMT - Device Management HCI H:4 channel
+ * for driver use only, to send device commands for initialization
+ * and shutdown on the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_DEV_MGMT			0x80
+
+/** CHANNEL_DEV_MGMT_AUDIO - Device Management HCI H:4 channel
+ * for audio driver use only, to send device commands on
+ * the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_DEV_MGMT_AUDIO		0x81
+
+/** CHANNEL_HCI_LOGGER - Bluetooth HCI H:4 channel
+ * for logging all transmitted H4 packets (on all channels).
+ */
+#define CHANNEL_HCI_LOGGER			0xFA
+
+/** CHANNEL_CORE - Bluetooth HCI H:4 channel
+ * for user space control of the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_CORE				0xFD
+
+/** CHANNEL_HCI_RAW - Bluetooth HCI H:4 channel
+ * for user space read/write on the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_HCI_RAW				0xFE
+
+/** CG2900_BT_CMD - Bluetooth HCI H4 channel for Bluetooth commands.
+ */
+#define CG2900_BT_CMD				"cg2900_bt_cmd"
+
+/** CG2900_BT_ACL - Bluetooth HCI H4 channel for Bluetooth ACL data.
+ */
+#define CG2900_BT_ACL				"cg2900_bt_acl"
+
+/** CG2900_BT_EVT - Bluetooth HCI H4 channel for Bluetooth events.
+ */
+#define CG2900_BT_EVT				"cg2900_bt_evt"
+
+/** CG2900_NFC - Bluetooth HCI H4 channel for NFC.
+ */
+#define CG2900_NFC				"cg2900_nfc"
+
+/** CG2900_ANT_CMD - Bluetooth HCI H4 channel for ANT Command.
+ */
+#define CG2900_ANT_CMD			"cg2900_antradio_cmd"
+
+/** CG2900_ANT_DAT - Bluetooth HCI H4 channel for ANT Data.
+ */
+#define CG2900_ANT_DAT			"cg2900_antradio_data"
+
+/** CG2900_FM_RADIO - Bluetooth HCI H4 channel for FM radio.
+ */
+#define CG2900_FM_RADIO				"cg2900_fm_radio"
+
+/** CG2900_GNSS - Bluetooth HCI H4 channel for GNSS.
+ */
+#define CG2900_GNSS				"cg2900_gnss"
+
+/** CG2900_DEBUG - Bluetooth HCI H4 channel for internal debug data.
+ */
+#define CG2900_DEBUG				"cg2900_debug"
+
+/** CG2900_STE_TOOLS - Bluetooth HCI H4 channel for development tools data.
+ */
+#define CG2900_STE_TOOLS			"cg2900_ste_tools"
+
+/** CG2900_HCI_LOGGER - BT channel for logging all transmitted H4 packets.
+ * Data read is copy of all data transferred on the other channels.
+ * Only write allowed is configuration of the HCI Logger.
+ */
+#define CG2900_HCI_LOGGER			"cg2900_hci_logger"
+
+/** CG2900_DEV_AUDIO - HCI channel for sending vendor specific commands
+ * meant for device audio configuration commands.
+ */
+#define CG2900_VS_AUDIO				"cg2900_vs_audio"
+
+/** CG2900_FM_AUDIO - HCI channel for FM audio configuration commands.
+ * Maps to FM Radio channel.
+ */
+#define CG2900_FM_AUDIO				"cg2900_fm_audio"
+
+/** CG2900_CORE- Channel for keeping ST-Ericsson CG2900 enabled.
+ * Opening this channel forces the chip to stay powered.
+ * No data can be written to or read from this channel.
+ */
+#define CG2900_CORE				"cg2900_core"
+
+/** CG2900_HCI_RAW - Channel for HCI RAW data exchange.
+ * Opening this channel will not allow any others HCI Channels
+ * to be opened except Logger Channel.
+ */
+#define CG2900_HCI_RAW				"cg2900_hci_raw"
+
+/**
+ * enum main_state - Main-state for CG2900 driver.
+ * @CG2900_INIT:	CG2900 initializing.
+ * @CG2900_IDLE:	No user registered to CG2900 driver.
+ * @CG2900_BOOTING:	CG2900 booting after first user is registered.
+ * @CG2900_CLOSING:	CG2900 closing after last user has deregistered.
+ * @CG2900_RESETING:	CG2900 reset requested.
+ * @CG2900_ACTIVE:	CG2900 up and running with at least one user.
+ * @CG2900_ACTIVE_BEFORE_SELFTEST: CG2900 up and running before
+ *		BT self test is run.
+ */
+enum main_state {
+	CG2900_INIT,
+	CG2900_IDLE,
+	CG2900_BOOTING,
+	CG2900_CLOSING,
+	CG2900_RESETING,
+	CG2900_ACTIVE,
+	CG2900_ACTIVE_BEFORE_SELFTEST
+};
+
+/**
+ * enum boot_state - BOOT-state for CG2900 chip driver.
+ * @BOOT_NOT_STARTED:			Boot has not yet started.
+ * @BOOT_SEND_BD_ADDRESS:		VS Store In FS command with BD address
+ *					has been sent.
+ * @BOOT_GET_FILES_TO_LOAD:		CG2900 chip driver is retrieving file to
+ *					load.
+ * @BOOT_DOWNLOAD_PATCH:		CG2900 chip driver is downloading
+ *					patches.
+ * @BOOT_ACTIVATE_PATCHES_AND_SETTINGS:	CG2900 chip driver is activating patches
+ *					and settings.
+ * @BOOT_READ_SELFTEST_RESULT:		CG2900 is performing selftests that
+ *					shall be read out.
+ * @BOOT_READY:				CG2900 chip driver boot is ready.
+ * @BOOT_FAILED:			CG2900 chip driver boot failed.
+ */
+enum boot_state {
+	BOOT_NOT_STARTED,
+	BOOT_SEND_BD_ADDRESS,
+	BOOT_GET_FILES_TO_LOAD,
+	BOOT_DOWNLOAD_PATCH,
+	BOOT_ACTIVATE_PATCHES_AND_SETTINGS,
+	BOOT_READ_SELFTEST_RESULT,
+	BOOT_READY,
+	BOOT_FAILED
+};
+
+/**
+ * enum closing_state - CLOSING-state for CG2900 chip driver.
+ * @CLOSING_RESET:		HCI RESET_CMD has been sent.
+ * @CLOSING_POWER_SWITCH_OFF:	HCI VS_POWER_SWITCH_OFF command has been sent.
+ * @CLOSING_SHUT_DOWN:		We have now shut down the chip.
+ */
+enum closing_state {
+	CLOSING_RESET,
+	CLOSING_POWER_SWITCH_OFF,
+	CLOSING_SHUT_DOWN
+};
+
+/**
+ * enum file_load_state - BOOT_FILE_LOAD-state for CG2900 chip driver.
+ * @FILE_LOAD_GET_PATCH:		Loading patches.
+ * @FILE_LOAD_GET_STATIC_SETTINGS:	Loading static settings.
+ * @FILE_LOAD_NO_MORE_FILES:		No more files to load.
+ * @FILE_LOAD_FAILED:			File loading failed.
+ */
+enum file_load_state {
+	FILE_LOAD_GET_PATCH,
+	FILE_LOAD_GET_STATIC_SETTINGS,
+	FILE_LOAD_NO_MORE_FILES,
+	FILE_LOAD_FAILED
+};
+
+/**
+ * enum download_state - BOOT_DOWNLOAD state.
+ * @DOWNLOAD_PENDING:	Download in progress.
+ * @DOWNLOAD_SUCCESS:	Download successfully finished.
+ * @DOWNLOAD_FAILED:	Downloading failed.
+ */
+enum download_state {
+	DOWNLOAD_PENDING,
+	DOWNLOAD_SUCCESS,
+	DOWNLOAD_FAILED
+};
+
+/**
+ * enum fm_radio_mode - FM Radio mode.
+ * It's needed because some FM do-commands generate interrupts only when
+ * the FM driver is in specific mode and we need to know if we should expect
+ * the interrupt.
+ * @FM_RADIO_MODE_IDLE:	Radio mode is Idle (default).
+ * @FM_RADIO_MODE_FMT:	Radio mode is set to FMT (transmitter).
+ * @FM_RADIO_MODE_FMR:	Radio mode is set to FMR (receiver).
+ */
+enum fm_radio_mode {
+	FM_RADIO_MODE_IDLE = 0,
+	FM_RADIO_MODE_FMT = 1,
+	FM_RADIO_MODE_FMR = 2
+};
+
+
+/**
+ * struct cg2900_channel_item - List object for channel.
+ * @list:	list_head struct.
+ * @user:	User for this channel.
+ */
+struct cg2900_channel_item {
+	struct list_head	list;
+	struct cg2900_user_data	*user;
+};
+
+/**
+ * struct cg2900_delayed_work_struct - Work structure for CG2900 chip.
+ * @delayed_work:	Work structure.
+ * @data:		Pointer to private data.
+ */
+struct cg2900_delayed_work_struct {
+	struct delayed_work	work;
+	void			*data;
+};
+
+/**
+ * struct cg2900_skb_data - Structure for storing private data in an sk_buffer.
+ * @dev:	CG2900 device for this sk_buffer.
+ */
+struct cg2900_skb_data {
+	struct cg2900_user_data *user;
+};
+#define cg2900_skb_data(__skb) ((struct cg2900_skb_data *)((__skb)->cb))
+
+/**
+ * struct cg2900_chip_info - Main info structure for CG2900 chip driver.
+ * @dev:			Current device. Same as @chip_dev->dev.
+ * @patch_file_name:		Stores patch file name.
+ * @settings_file_name:		Stores settings file name.
+ * @file_info:			Firmware file info (patch or settings).
+ * @boot_state:			Current BOOT-state of CG2900 chip driver.
+ * @closing_state:		Current CLOSING-state of CG2900 chip driver.
+ * @file_load_state:		Current BOOT_FILE_LOAD-state of CG2900 chip
+ *				driver.
+ * @download_state:		Current BOOT_DOWNLOAD-state of CG2900 chip
+ *				driver.
+ * @wq:				CG2900 chip driver workqueue.
+ * @chip_dev:			Chip handler info.
+ * @tx_bt_lock:			Spinlock used to protect some global structures
+ *				related to internal BT command flow control.
+ * @tx_fm_lock:			Spinlock used to protect some global structures
+ *				related to internal FM command flow control.
+ * @tx_fm_audio_awaiting_irpt:	Indicates if an FM interrupt event related to
+ *				audio driver command is expected.
+ * @fm_radio_mode:		Current FM radio mode.
+ * @tx_nr_pkts_allowed_bt:	Number of packets allowed to send on BT HCI CMD
+ *				H4 channel.
+ * @audio_bt_cmd_op:		Stores the OpCode of the last sent audio driver
+ *				HCI BT CMD.
+ * @audio_fm_cmd_id:		Stores the command id of the last sent
+ *				HCI FM RADIO command by the fm audio user.
+ * @hci_fm_cmd_func:		Stores the command function of the last sent
+ *				HCI FM RADIO command by the fm radio user.
+ * @tx_queue_bt:		TX queue for HCI BT commands when nr of commands
+ *				allowed is 0 (CG2900 internal flow control).
+ * @tx_queue_fm:		TX queue for HCI FM commands when nr of commands
+ *				allowed is 0 (CG2900 internal flow control).
+ * @user_in_charge:		User currently operating. Normally used at
+ *				channel open and close.
+ * @last_user:			Last user of this chip. To avoid complications
+ *				this will never be set for bt_audio and
+ *				fm_audio.
+ * @logger:			Logger user of this chip.
+ * @hci_raw:			HCI Raw user of this chip.
+ * @selftest_work:		Delayed work for reading selftest results.
+ * @nbr_of_polls:		Number of times we should poll for selftest
+ *				results.
+ * @startup:			True if system is starting up.
+ * @mfd_size:			Number of MFD cells.
+ * @mfd_char_size:		Number of MFD char device cells.
+ * @h4_channel_for_device:	H4 channel number for sending device
+ *				mangement commands.
+ */
+struct cg2900_chip_info {
+	struct device			*dev;
+	char				*patch_file_name;
+	char				*settings_file_name;
+	struct cg2900_file_info		file_info;
+	enum main_state			main_state;
+	enum boot_state			boot_state;
+	enum closing_state		closing_state;
+	enum file_load_state		file_load_state;
+	enum download_state		download_state;
+	struct workqueue_struct		*wq;
+	struct cg2900_chip_dev		*chip_dev;
+	spinlock_t			tx_bt_lock;
+	spinlock_t			tx_fm_lock;
+	spinlock_t			rw_lock;
+	bool				tx_fm_audio_awaiting_irpt;
+	enum fm_radio_mode		fm_radio_mode;
+	int				tx_nr_pkts_allowed_bt;
+	u16				audio_bt_cmd_op;
+	u16				audio_fm_cmd_id;
+	u16				hci_fm_cmd_func;
+	struct sk_buff_head		tx_queue_bt;
+	struct sk_buff_head		tx_queue_fm;
+	struct list_head		open_channels;
+	struct cg2900_user_data		*user_in_charge;
+	struct cg2900_user_data		*last_user;
+	struct cg2900_user_data		*logger;
+	struct cg2900_user_data		*hci_raw;
+	struct cg2900_user_data		*bt_audio;
+	struct cg2900_user_data		*fm_audio;
+	struct cg2900_delayed_work_struct	selftest_work;
+	int				nbr_of_polls;
+	bool				startup;
+	int				mfd_size;
+	int				mfd_extra_size;
+	int				mfd_char_size;
+	int				mfd_extra_char_size;
+	u8				h4_channel_for_device;
+};
+
+/**
+ * struct main_info - Main info structure for CG2900 chip driver.
+ * @dev:			Device structure.
+ * @cell_base_id:		Base ID for MFD cells.
+ * @man_mutex:			Management mutex.
+ */
+struct main_info {
+	struct device			*dev;
+	int				cell_base_id;
+	struct mutex			man_mutex;
+};
+
+static struct main_info *main_info;
+
+/*
+ * main_wait_queue - Main Wait Queue in CG2900 driver.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(main_wait_queue);
+/*
+ * Clock enabler should be released earlier
+ * before running read self test
+ * as that is not required for clock enabler
+ * as is the case for WLAN
+ */
+static DECLARE_WAIT_QUEUE_HEAD(clk_user_wait_queue);
+
+static struct mfd_cell cg2900_devs[];
+static struct mfd_cell cg2900_char_devs[];
+static struct mfd_cell cg2905_extra_devs[];
+static struct mfd_cell cg2905_extra_char_devs[];
+static struct mfd_cell cg2910_extra_devs[];
+static struct mfd_cell cg2910_extra_char_devs[];
+static struct mfd_cell cg2910_extra_devs_pg2[];
+static struct mfd_cell cg2910_extra_char_devs_pg2[];
+
+static void chip_startup_finished(struct cg2900_chip_info *info, int err);
+static void chip_shutdown(struct cg2900_user_data *user);
+
+/**
+ * bt_is_open() - Checks if any BT user is in open state.
+ * @info:	CG2900 info.
+ *
+ * Returns:
+ *   true if a BT channel is open.
+ *   false if no BT channel is open.
+ */
+static bool bt_is_open(struct cg2900_chip_info *info)
+{
+	struct list_head *cursor;
+	struct cg2900_channel_item *tmp;
+
+	list_for_each(cursor, &info->open_channels) {
+		tmp = list_entry(cursor, struct cg2900_channel_item, list);
+		if (tmp->user->h4_channel == CHANNEL_BT_CMD)
+			return true;
+	}
+	return false;
+}
+
+/**
+ * fm_is_open() - Checks if any FM user is in open state.
+ * @info:	CG2900 info.
+ *
+ * Returns:
+ *   true if a FM channel is open.
+ *   false if no FM channel is open.
+ */
+static bool fm_is_open(struct cg2900_chip_info *info)
+{
+	struct list_head *cursor;
+	struct cg2900_channel_item *tmp;
+
+	list_for_each(cursor, &info->open_channels) {
+		tmp = list_entry(cursor, struct cg2900_channel_item, list);
+		if (tmp->user->h4_channel == CHANNEL_FM_RADIO)
+			return true;
+	}
+	return false;
+}
+
+/**
+ * fm_irpt_expected() - check if this FM command will generate an interrupt.
+ * @cmd_id:	command identifier.
+ *
+ * Returns:
+ *   true if the command will generate an interrupt.
+ *   false if it won't.
+ */
+static bool fm_irpt_expected(struct cg2900_chip_info *info, u16 cmd_id)
+{
+	bool retval = false;
+
+	switch (cmd_id) {
+	case CG2900_FM_DO_AIP_FADE_START:
+		if (info->fm_radio_mode == FM_RADIO_MODE_FMT)
+			retval = true;
+		break;
+
+	case CG2900_FM_DO_AUP_BT_FADE_START:
+	case CG2900_FM_DO_AUP_EXT_FADE_START:
+	case CG2900_FM_DO_AUP_FADE_START:
+		if (info->fm_radio_mode == FM_RADIO_MODE_FMR)
+			retval = true;
+		break;
+
+	case CG2900_FM_DO_FMR_SETANTENNA:
+	case CG2900_FM_DO_FMR_SP_AFSWITCH_START:
+	case CG2900_FM_DO_FMR_SP_AFUPDATE_START:
+	case CG2900_FM_DO_FMR_SP_BLOCKSCAN_START:
+	case CG2900_FM_DO_FMR_SP_PRESETPI_START:
+	case CG2900_FM_DO_FMR_SP_SCAN_START:
+	case CG2900_FM_DO_FMR_SP_SEARCH_START:
+	case CG2900_FM_DO_FMR_SP_SEARCHPI_START:
+	case CG2900_FM_DO_FMR_SP_TUNE_SETCHANNEL:
+	case CG2900_FM_DO_FMR_SP_TUNE_STEPCHANNEL:
+	case CG2900_FM_DO_FMT_PA_SETCTRL:
+	case CG2900_FM_DO_FMT_PA_SETMODE:
+	case CG2900_FM_DO_FMT_SP_TUNE_SETCHANNEL:
+	case CG2900_FM_DO_GEN_ANTENNACHECK_START:
+	case CG2900_FM_DO_GEN_GOTOMODE:
+	case CG2900_FM_DO_GEN_POWERSUPPLY_SETMODE:
+	case CG2900_FM_DO_GEN_SELECTREFERENCECLOCK:
+	case CG2900_FM_DO_GEN_SETPROCESSINGCLOCK:
+	case CG2900_FM_DO_GEN_SETREFERENCECLOCKPLL:
+	case CG2900_FM_DO_TST_TX_RAMP_START:
+		retval = true;
+		break;
+
+	default:
+		break;
+	}
+
+	if (retval)
+		dev_dbg(info->dev, "Following interrupt event expected "\
+			" for this Cmd complete evt: cmd_id = 0x%X\n",
+			cmd_id);
+
+	return retval;
+}
+
+/**
+ * fm_is_do_cmd_irpt() - Check if irpt_val is one of the FM DO command related interrupts.
+ * @irpt_val:	interrupt value.
+ *
+ * Returns:
+ *   true if it's do-command related interrupt value.
+ *   false if it's not.
+ */
+static bool fm_is_do_cmd_irpt(u16 irpt_val)
+{
+	if ((irpt_val & CG2900_FM_IRPT_OPERATION_SUCCEEDED) ||
+	    (irpt_val & CG2900_FM_IRPT_OPERATION_FAILED)) {
+		dev_dbg(MAIN_DEV, "Irpt evt for FM do-command found, "\
+			"irpt_val = 0x%X\n", irpt_val);
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * fm_reset_flow_ctrl - Clears up internal FM flow control.
+ *
+ * Resets outstanding commands and clear FM TX list and set CG2900 FM mode to
+ * idle.
+ */
+static void fm_reset_flow_ctrl(struct cg2900_chip_info *info)
+{
+	dev_dbg(info->dev, "fm_reset_flow_ctrl\n");
+
+	skb_queue_purge(&info->tx_queue_fm);
+
+	/* Reset the fm_cmd_id. */
+	info->audio_fm_cmd_id = CG2900_FM_CMD_NONE;
+	info->hci_fm_cmd_func = CG2900_FM_CMD_PARAM_NONE;
+
+	info->fm_radio_mode = FM_RADIO_MODE_IDLE;
+}
+
+
+/**
+ * fm_parse_cmd - Parses a FM command packet.
+ * @data:	FM command packet.
+ * @cmd_func:	Out: FM legacy command function.
+ * @cmd_id:	Out: FM legacy command ID.
+ */
+static void fm_parse_cmd(u8 *data, u8 *cmd_func, u16 *cmd_id)
+{
+	/* Move past H4-header to start of actual package */
+	struct fm_leg_cmd *pkt = (struct fm_leg_cmd *)(data + HCI_H4_SIZE);
+
+	*cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	*cmd_id   = CG2900_FM_CMD_NONE;
+
+	if (pkt->opcode != CG2900_FM_GEN_ID_LEGACY) {
+		dev_err(MAIN_DEV, "fm_parse_cmd: Not an FM legacy command "\
+			"0x%02X\n", pkt->opcode);
+		return;
+	}
+
+	*cmd_func = pkt->fm_function;
+	if (*cmd_func == CG2900_FM_CMD_PARAM_WRITECOMMAND)
+		*cmd_id = cg2900_get_fm_cmd_id(le16_to_cpu(pkt->fm_cmd.head));
+}
+
+
+/**
+ * fm_parse_event - Parses a FM event packet
+ * @data:	FM event packet.
+ * @event:	Out: FM event.
+ * @cmd_func:	Out: FM legacy command function.
+ * @cmd_id:	Out: FM legacy command ID.
+ * @intr_val:	Out: FM interrupt value.
+ */
+static void fm_parse_event(u8 *data, u8 *event, u8 *cmd_func, u16 *cmd_id,
+			   u16 *intr_val)
+{
+	/* Move past H4-header to start of actual package */
+	union fm_leg_evt_or_irq *pkt = (union fm_leg_evt_or_irq *)data;
+
+	*cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	*cmd_id = CG2900_FM_CMD_NONE;
+	*intr_val = 0;
+	*event = CG2900_FM_EVENT_UNKNOWN;
+
+	if (pkt->evt.opcode == CG2900_FM_GEN_ID_LEGACY &&
+	    pkt->evt.read_write == CG2900_FM_CMD_LEG_PARAM_WRITE) {
+		/* Command complete */
+		*event = CG2900_FM_EVENT_CMD_COMPLETE;
+		*cmd_func = pkt->evt.fm_function;
+		if (*cmd_func == CG2900_FM_CMD_PARAM_WRITECOMMAND)
+			*cmd_id = cg2900_get_fm_cmd_id(
+				le16_to_cpu(pkt->evt.response_head));
+	} else if (pkt->irq_v2.opcode == CG2900_FM_GEN_ID_LEGACY &&
+		   pkt->irq_v2.event_type == CG2900_FM_CMD_LEG_PARAM_IRQ) {
+		/* Interrupt, PG2 style */
+		*event = CG2900_FM_EVENT_INTERRUPT;
+		*intr_val = le16_to_cpu(pkt->irq_v2.irq);
+	} else if (pkt->irq_v1.opcode == CG2900_FM_GEN_ID_LEGACY) {
+		/* Interrupt, PG1 style */
+		*event = CG2900_FM_EVENT_INTERRUPT;
+		*intr_val = le16_to_cpu(pkt->irq_v1.irq);
+	} else
+		dev_err(MAIN_DEV, "fm_parse_event: Not an FM legacy command "\
+			"0x%X %X %X %X\n", data[0], data[1], data[2], data[3]);
+}
+
+/**
+ * fm_update_mode - Updates the FM mode state machine.
+ * @data:	FM command packet.
+ *
+ * Parses a FM command packet and updates the FM mode state machine.
+ */
+static void fm_update_mode(struct cg2900_chip_info *info, u8 *data)
+{
+	u8 cmd_func;
+	u16 cmd_id;
+
+	fm_parse_cmd(data, &cmd_func, &cmd_id);
+
+	if (cmd_func == CG2900_FM_CMD_PARAM_WRITECOMMAND &&
+	    cmd_id == CG2900_FM_DO_GEN_GOTOMODE) {
+		/* Move past H4-header to start of actual package */
+		struct fm_leg_cmd *pkt =
+			(struct fm_leg_cmd *)(data + HCI_H4_SIZE);
+
+		info->fm_radio_mode = le16_to_cpu(pkt->fm_cmd.data[0]);
+		dev_dbg(info->dev, "FM Radio mode changed to %d\n",
+			info->fm_radio_mode);
+	}
+}
+
+
+/**
+ * transmit_skb_from_tx_queue_bt() - Check flow control info and transmit skb.
+ *
+ * The transmit_skb_from_tx_queue_bt() function checks if there are tickets
+ * available and commands waiting in the TX queue and if so transmits them
+ * to the controller.
+ * It shall always be called within spinlock_bh.
+ */
+static void transmit_skb_from_tx_queue_bt(struct cg2900_chip_dev *dev)
+{
+	struct cg2900_user_data *user;
+	struct cg2900_chip_info *info = dev->c_data;
+	struct sk_buff *skb;
+
+	dev_dbg(dev->dev, "transmit_skb_from_tx_queue_bt\n");
+
+	/* Dequeue an skb from the head of the list */
+	skb = skb_dequeue(&info->tx_queue_bt);
+	while (skb) {
+		if (info->tx_nr_pkts_allowed_bt <= 0) {
+			/*
+			 * If no more packets allowed just return, we'll get
+			 * back here after next Command Complete/Status event.
+			 * Put skb back at head of queue.
+			 */
+			skb_queue_head(&info->tx_queue_bt, skb);
+			return;
+		}
+
+		(info->tx_nr_pkts_allowed_bt)--;
+		dev_dbg(dev->dev, "tx_nr_pkts_allowed_bt = %d\n",
+			info->tx_nr_pkts_allowed_bt);
+
+		user = cg2900_skb_data(skb)->user; /* user is never NULL */
+
+		/*
+		 * If it's a command from audio application, store the OpCode,
+		 * it'll be used later to decide where to dispatch
+		 * the Command Complete event.
+		 */
+		if (info->bt_audio == user) {
+			struct hci_command_hdr *hdr = (struct hci_command_hdr *)
+				(skb->data + HCI_H4_SIZE);
+
+			info->audio_bt_cmd_op = le16_to_cpu(hdr->opcode);
+			dev_dbg(user->dev,
+				"Sending cmd from audio driver, saving "
+				"OpCode = 0x%04X\n", info->audio_bt_cmd_op);
+		}
+
+		cg2900_tx_to_chip(user, info->logger, skb);
+
+		/* Dequeue an skb from the head of the list */
+		skb = skb_dequeue(&info->tx_queue_bt);
+	}
+}
+
+/**
+ * transmit_skb_from_tx_queue_fm() - Check flow control info and transmit skb.
+ *
+ * The transmit_skb_from_tx_queue_fm() function checks if it possible to
+ * transmit and commands waiting in the TX queue and if so transmits them
+ * to the controller.
+ * It shall always be called within spinlock_bh.
+ */
+static void transmit_skb_from_tx_queue_fm(struct cg2900_chip_dev *dev)
+{
+	struct cg2900_user_data *user;
+	struct cg2900_chip_info *info = dev->c_data;
+	struct sk_buff *skb;
+
+	dev_dbg(dev->dev, "transmit_skb_from_tx_queue_fm\n");
+
+	/* Dequeue an skb from the head of the list */
+	skb = skb_dequeue(&info->tx_queue_fm);
+	while (skb) {
+		u16 cmd_id;
+		u8 cmd_func;
+
+		if (info->audio_fm_cmd_id != CG2900_FM_CMD_NONE ||
+		    info->hci_fm_cmd_func != CG2900_FM_CMD_PARAM_NONE) {
+			/*
+			 * There are currently outstanding FM commands.
+			 * Wait for them to finish. We will get back here later.
+			 * Queue back the skb at head of list.
+			 */
+			skb_queue_head(&info->tx_queue_bt, skb);
+			return;
+		}
+
+		user = cg2900_skb_data(skb)->user; /* user is never NULL */
+
+		if (!user->opened) {
+			/*
+			 * Channel is not open. That means that the user that
+			 * originally sent it has deregistered.
+			 * Just throw it away and check the next skb in the
+			 * queue.
+			 */
+			kfree_skb(skb);
+			/* Dequeue an skb from the head of the list */
+			skb = skb_dequeue(&info->tx_queue_fm);
+			continue;
+		}
+
+		fm_parse_cmd(&(skb->data[0]), &cmd_func, &cmd_id);
+
+		/*
+		 * Store the FM command function , it'll be used later to decide
+		 * where to dispatch the Command Complete event.
+		 */
+		if (info->fm_audio == user) {
+			info->audio_fm_cmd_id = cmd_id;
+			dev_dbg(user->dev, "Sending FM audio cmd 0x%04X\n",
+				info->audio_fm_cmd_id);
+		} else {
+			/* FM radio command */
+			info->hci_fm_cmd_func = cmd_func;
+			fm_update_mode(info, &skb->data[0]);
+			dev_dbg(user->dev, "Sending FM radio cmd 0x%04X\n",
+				info->hci_fm_cmd_func);
+		}
+
+		/*
+		 * We have only one ticket on FM. Just return after
+		 * sending the skb.
+		 */
+		cg2900_tx_to_chip(user, info->logger, skb);
+		return;
+	}
+}
+
+/**
+ * update_flow_ctrl_bt() - Update number of outstanding commands for BT CMD.
+ * @dev:	Current chip device.
+ * @skb:	skb with received packet.
+ *
+ * The update_flow_ctrl_bt() checks if incoming data packet is
+ * BT Command Complete/Command Status Event and if so updates number of tickets
+ * and number of outstanding commands. It also calls function to send queued
+ * commands (if the list of queued commands is not empty).
+ */
+static void update_flow_ctrl_bt(struct cg2900_chip_dev *dev,
+				const struct sk_buff * const skb)
+{
+	u8 *data = skb->data;
+	struct hci_event_hdr *event;
+	struct cg2900_chip_info *info = dev->c_data;
+
+	event = (struct hci_event_hdr *)data;
+	data += sizeof(*event);
+
+	if (HCI_EV_CMD_COMPLETE == event->evt) {
+		struct hci_ev_cmd_complete *complete;
+		complete = (struct hci_ev_cmd_complete *)data;
+
+		/*
+		 * If it's HCI Command Complete Event then we might get some
+		 * HCI tickets back. Also we can decrease the number outstanding
+		 * HCI commands (if it's not NOP command or one of the commands
+		 * that generate both Command Status Event and Command Complete
+		 * Event).
+		 * Check if we have any HCI commands waiting in the TX list and
+		 * send them if there are tickets available.
+		 */
+		spin_lock_bh(&info->tx_bt_lock);
+		info->tx_nr_pkts_allowed_bt = complete->ncmd;
+		dev_dbg(dev->dev, "New tx_nr_pkts_allowed_bt = %d\n",
+			info->tx_nr_pkts_allowed_bt);
+
+		if (!skb_queue_empty(&info->tx_queue_bt))
+			transmit_skb_from_tx_queue_bt(dev);
+		spin_unlock_bh(&info->tx_bt_lock);
+	} else if (HCI_EV_CMD_STATUS == event->evt) {
+		struct hci_ev_cmd_status *status;
+		status = (struct hci_ev_cmd_status *)data;
+
+		/*
+		 * If it's HCI Command Status Event then we might get some
+		 * HCI tickets back. Also we can decrease the number outstanding
+		 * HCI commands (if it's not NOP command).
+		 * Check if we have any HCI commands waiting in the TX queue and
+		 * send them if there are tickets available.
+		 */
+		spin_lock_bh(&info->tx_bt_lock);
+		info->tx_nr_pkts_allowed_bt = status->ncmd;
+		dev_dbg(dev->dev, "New tx_nr_pkts_allowed_bt = %d\n",
+			info->tx_nr_pkts_allowed_bt);
+
+		if (!skb_queue_empty(&info->tx_queue_bt))
+			transmit_skb_from_tx_queue_bt(dev);
+		spin_unlock_bh(&info->tx_bt_lock);
+	}
+}
+
+/**
+ * update_flow_ctrl_fm() - Update packets allowed for FM channel.
+ * @dev:	Current chip device.
+ * @skb:	skb with received packet.
+ *
+ * The update_flow_ctrl_fm() checks if incoming data packet is FM packet
+ * indicating that the previous command has been handled and if so update
+ * packets. It also calls function to send queued commands (if the list of
+ * queued commands is not empty).
+ */
+static void update_flow_ctrl_fm(struct cg2900_chip_dev *dev,
+				const struct sk_buff * const skb)
+{
+	u8 cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	u16 cmd_id = CG2900_FM_CMD_NONE;
+	u16 irpt_val = 0;
+	u8 event = CG2900_FM_EVENT_UNKNOWN;
+	struct cg2900_chip_info *info = dev->c_data;
+
+	fm_parse_event(&(skb->data[0]), &event, &cmd_func, &cmd_id, &irpt_val);
+
+	if (event == CG2900_FM_EVENT_CMD_COMPLETE) {
+		/* FM legacy command complete event */
+		spin_lock_bh(&info->tx_fm_lock);
+		/*
+		 * Check if it's not an write command complete event, because
+		 * then it cannot be a DO command.
+		 * If it's a write command complete event check that is not a
+		 * DO command complete event before setting the outstanding
+		 * FM packets to none.
+		 */
+		if (cmd_func != CG2900_FM_CMD_PARAM_WRITECOMMAND ||
+		    !fm_irpt_expected(info, cmd_id)) {
+			info->hci_fm_cmd_func = CG2900_FM_CMD_PARAM_NONE;
+			info->audio_fm_cmd_id = CG2900_FM_CMD_NONE;
+			dev_dbg(dev->dev,
+				"FM_Write: Outstanding FM commands:\n"
+				"\tRadio: 0x%04X\n"
+				"\tAudio: 0x%04X\n",
+				info->hci_fm_cmd_func,
+				info->audio_fm_cmd_id);
+			transmit_skb_from_tx_queue_fm(dev);
+
+		/*
+		 * If there was a write do command complete event check if it is
+		 * DO command previously sent by the FM audio user. If that's
+		 * the case we need remember that in order to be able to
+		 * dispatch the interrupt to the correct user.
+		 */
+		} else if (cmd_id == info->audio_fm_cmd_id) {
+			info->tx_fm_audio_awaiting_irpt = true;
+			dev_dbg(dev->dev,
+				"FM Audio waiting for interrupt = true\n");
+		}
+		spin_unlock_bh(&info->tx_fm_lock);
+	} else if (event == CG2900_FM_EVENT_INTERRUPT) {
+		/* FM legacy interrupt */
+		if (fm_is_do_cmd_irpt(irpt_val)) {
+			/*
+			 * If it is an interrupt related to a DO command update
+			 * the outstanding flow control and transmit blocked
+			 * FM commands.
+			 */
+			spin_lock_bh(&info->tx_fm_lock);
+			info->hci_fm_cmd_func = CG2900_FM_CMD_PARAM_NONE;
+			info->audio_fm_cmd_id = CG2900_FM_CMD_NONE;
+			dev_dbg(dev->dev,
+				"FM_INT: Outstanding FM commands:\n"
+				"\tRadio: 0x%04X\n"
+				"\tAudio: 0x%04X\n",
+				info->hci_fm_cmd_func,
+				info->audio_fm_cmd_id);
+			info->tx_fm_audio_awaiting_irpt = false;
+			dev_dbg(dev->dev,
+				"FM Audio waiting for interrupt = false\n");
+			transmit_skb_from_tx_queue_fm(dev);
+			spin_unlock_bh(&info->tx_fm_lock);
+		}
+	}
+}
+
+/**
+ * send_bd_address() - Send HCI VS command with BD address to the chip.
+ */
+static void send_bd_address(struct cg2900_chip_info *info)
+{
+	struct bt_vs_store_in_fs_cmd *cmd;
+	u8 plen = sizeof(*cmd) + BT_BDADDR_SIZE;
+
+	cmd = kmalloc(plen, GFP_KERNEL);
+	if (!cmd) {
+		dev_err(info->dev, "send_bd_address could not allocate cmd\n");
+		return;
+	}
+
+	cmd->opcode = cpu_to_le16(CG2900_BT_OP_VS_STORE_IN_FS);
+	cmd->plen = BT_PARAM_LEN(plen);
+	cmd->user_id = CG2900_VS_STORE_IN_FS_USR_ID_BD_ADDR;
+	cmd->len = BT_BDADDR_SIZE;
+	/* Now copy the BD address received from user space control app. */
+	memcpy(cmd->data, bd_address, BT_BDADDR_SIZE);
+
+	dev_dbg(BOOT_DEV, "New boot_state: BOOT_SEND_BD_ADDRESS\n");
+	info->boot_state = BOOT_SEND_BD_ADDRESS;
+
+	cg2900_send_bt_cmd(info->user_in_charge, info->logger,
+			cmd, plen, info->h4_channel_for_device);
+
+	kfree(cmd);
+}
+
+/**
+ * send_settings_file() - Transmit settings file.
+ *
+ * The send_settings_file() function transmit settings file.
+ * The file is read in parts to fit in HCI packets. When finished,
+ * close the settings file and send HCI reset to activate settings and patches.
+ */
+static void send_settings_file(struct cg2900_chip_info *info)
+{
+	int bytes_sent;
+
+	bytes_sent = cg2900_read_and_send_file_part(
+			info->user_in_charge,
+			info->logger,
+			&info->file_info,
+			info->file_info.fw_file_ssf,
+			info->h4_channel_for_device);
+
+	if (bytes_sent > 0) {
+		/* Data sent. Wait for CmdComplete */
+		return;
+	} else if (bytes_sent < 0) {
+		dev_err(BOOT_DEV, "send_settings_file: Error %d occurred\n",
+			bytes_sent);
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		chip_startup_finished(info, bytes_sent);
+		return;
+	}
+
+	/* No data was sent. This file is finished */
+	info->download_state = DOWNLOAD_SUCCESS;
+
+	/* Settings file finished. Release used resources */
+	dev_dbg(BOOT_DEV, "Settings file finished\n");
+
+	dev_dbg(BOOT_DEV, "New file_load_state: FILE_LOAD_NO_MORE_FILES\n");
+	info->file_load_state = FILE_LOAD_NO_MORE_FILES;
+
+	/* Create and send HCI VS Store In FS command with bd address. */
+	send_bd_address(info);
+}
+
+/**
+ * send_patch_file - Transmit patch file.
+ *
+ * The send_patch_file() function transmit patch file.
+ * The file is read in parts to fit in HCI packets. When the complete file is
+ * transmitted, the file is closed.
+ * When finished, continue with settings file.
+ */
+static void send_patch_file(struct cg2900_chip_dev *dev)
+{
+	int err;
+	int bytes_sent;
+	struct cg2900_chip_info *info = dev->c_data;
+
+	bytes_sent = cg2900_read_and_send_file_part(
+			info->user_in_charge,
+			info->logger,
+			&info->file_info,
+			info->file_info.fw_file_ptc,
+			info->h4_channel_for_device);
+
+	if (bytes_sent > 0) {
+		/* Data sent. Wait for CmdComplete */
+		return;
+	} else if (bytes_sent < 0) {
+		dev_err(BOOT_DEV, "send_patch_file: Error %d occurred\n",
+			bytes_sent);
+		err = bytes_sent;
+		goto error_handling;
+	}
+
+	/* No data was sent. This file is finished */
+	info->download_state = DOWNLOAD_SUCCESS;
+
+	dev_dbg(BOOT_DEV, "Patch file finished\n");
+
+	/* Now send the settings file */
+	dev_dbg(BOOT_DEV,
+		"New file_load_state: FILE_LOAD_GET_STATIC_SETTINGS\n");
+	info->file_load_state = FILE_LOAD_GET_STATIC_SETTINGS;
+	dev_dbg(BOOT_DEV, "New download_state: DOWNLOAD_PENDING\n");
+	info->download_state = DOWNLOAD_PENDING;
+	send_settings_file(info);
+	return;
+
+error_handling:
+	dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+	info->boot_state = BOOT_FAILED;
+	chip_startup_finished(info, err);
+}
+
+/**
+ * work_power_off_chip() - Work item to power off the chip.
+ * @work:	Reference to work data.
+ *
+ * The work_power_off_chip() function handles transmission of the HCI command
+ * vs_power_switch_off and then informs the CG2900 Core that this chip driver is
+ * finished and the Core driver can now shut off the chip.
+ */
+static void work_power_off_chip(struct work_struct *work)
+{
+	struct sk_buff *skb = NULL;
+	u8 *h4_header;
+	struct cg2900_platform_data *pf_data;
+	struct cg2900_work *my_work;
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	if (!work) {
+		dev_err(MAIN_DEV, "work_power_off_chip: work == NULL\n");
+		return;
+	}
+
+	my_work = container_of(work, struct cg2900_work, work);
+	dev = my_work->user_data;
+	info = dev->c_data;
+
+	/*
+	 * Get the VS Power Switch Off command to use based on connected
+	 * connectivity controller
+	 */
+	pf_data = dev_get_platdata(dev->dev);
+	if (pf_data->get_power_switch_off_cmd)
+		skb = pf_data->get_power_switch_off_cmd(dev, NULL);
+
+	/*
+	 * Transmit the received command.
+	 * If no command found for the device, just continue
+	 */
+	if (!skb) {
+		dev_err(dev->dev,
+			"Could not retrieve PowerSwitchOff command\n");
+		goto shut_down_chip;
+	}
+
+	dev_dbg(dev->dev,
+		"Got power_switch_off command. Add H4 header and transmit\n");
+
+	/*
+	 * Move the data pointer to the H:4 header position and store
+	 * the H4 header
+	 */
+	h4_header = skb_push(skb, CG2900_SKB_RESERVE);
+	*h4_header = info->h4_channel_for_device;
+
+	dev_dbg(dev->dev, "New closing_state: CLOSING_POWER_SWITCH_OFF\n");
+	info->closing_state = CLOSING_POWER_SWITCH_OFF;
+
+	if (info->user_in_charge)
+		cg2900_tx_to_chip(info->user_in_charge, info->logger, skb);
+	else
+		cg2900_tx_no_user(dev, skb);
+
+	/*
+	 * Mandatory to wait 500ms after the power_switch_off command has been
+	 * transmitted, in order to make sure that the controller is ready.
+	 */
+	schedule_timeout_killable(msecs_to_jiffies(POWER_SW_OFF_WAIT));
+
+shut_down_chip:
+	dev_dbg(dev->dev, "New closing_state: CLOSING_SHUT_DOWN\n");
+	info->closing_state = CLOSING_SHUT_DOWN;
+
+	/* Close the transport, which will power off the chip */
+	if (dev->t_cb.close)
+		dev->t_cb.close(dev);
+
+	/* Chip shut-down finished, set correct state and wake up the chip. */
+	dev_dbg(dev->dev, "New main_state: CG2900_IDLE\n");
+	info->main_state = CG2900_IDLE;
+	wake_up_all(&main_wait_queue);
+
+	/* If this is called during system startup, register the devices. */
+	if (info->startup) {
+		int err;
+
+		err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+				cg2900_devs, info->mfd_size, NULL, 0, NULL);
+		if (err) {
+			dev_err(dev->dev, "Failed to add cg2900_devs (%d)\n",
+					err);
+			goto finished;
+		}
+
+		err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+				cg2900_char_devs, info->mfd_char_size,
+				NULL, 0, NULL);
+		if (err) {
+			dev_err(dev->dev, "Failed to add cg2900_char_devs (%d)"\
+					"\n", err);
+			mfd_remove_devices(dev->dev);
+			goto finished;
+		}
+
+		/*
+		 * Increase base ID so next connected transport will not get the
+		 * same device IDs.
+		 */
+		main_info->cell_base_id +=
+				MAX(info->mfd_size, info->mfd_char_size);
+
+		if (dev->chip.hci_revision == CG2905_PG2_REV) {
+			err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+					cg2905_extra_devs,
+					info->mfd_extra_size, NULL, 0, NULL);
+			if (err) {
+				dev_err(dev->dev, "Failed to add "\
+					"cg2905_extra_devs(%d)\n", err);
+				goto finished;
+			}
+
+			err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+					cg2905_extra_char_devs,
+					info->mfd_extra_char_size,
+					NULL, 0, NULL);
+			if (err) {
+				dev_err(dev->dev, "Failed to add "\
+					"cg2905_extra_char_devs (%d)\n", err);
+				mfd_remove_devices(dev->dev);
+				goto finished;
+			}
+
+			/*
+			 * Increase base ID so next connected transport
+			 * will not get the same device IDs.
+			 */
+			main_info->cell_base_id +=
+					MAX(info->mfd_extra_size,
+						info->mfd_extra_char_size);
+		} else if (dev->chip.hci_revision == CG2910_PG1_REV) {
+			err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+					cg2910_extra_devs,
+					info->mfd_extra_size, NULL, 0, NULL);
+			if (err) {
+				dev_err(dev->dev, "Failed to add "\
+					"cg2910_extra_devs(%d)\n", err);
+				goto finished;
+			}
+
+			err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+					cg2910_extra_char_devs,
+					info->mfd_extra_char_size,
+					NULL, 0, NULL);
+			if (err) {
+				dev_err(dev->dev, "Failed to add "\
+					"cg2910_extra_char_devs (%d)\n", err);
+				mfd_remove_devices(dev->dev);
+				goto finished;
+			}
+
+			/*
+			 * Increase base ID so next connected transport
+			 * will not get the same device IDs.
+			 */
+			main_info->cell_base_id +=
+					MAX(info->mfd_extra_size,
+						info->mfd_extra_char_size);
+		} else if (dev->chip.hci_revision == CG2910_PG2_REV) {
+
+			err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+					cg2910_extra_devs_pg2,
+					info->mfd_extra_size, NULL, 0, NULL);
+			if (err) {
+				dev_err(dev->dev, "Failed to add "\
+					"cg2910_extra_devs_pg2 (%d)\n", err);
+				goto finished;
+			}
+
+			err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+					cg2910_extra_char_devs_pg2,
+					info->mfd_extra_char_size,
+					NULL, 0, NULL);
+			if (err) {
+				dev_err(dev->dev, "Failed to add "\
+					"cg2910_extra_char_devs_pg2 (%d)\n",
+					err);
+				mfd_remove_devices(dev->dev);
+				goto finished;
+			}
+
+			/*
+			 * Increase base ID so next connected transport
+			 * will not get the same device IDs.
+			 */
+			main_info->cell_base_id +=
+					MAX(info->mfd_extra_size,
+						info->mfd_extra_char_size);
+		}
+
+		info->startup = false;
+	}
+
+finished:
+	kfree(my_work);
+}
+
+/**
+ * work_chip_shutdown() - Shut down the chip.
+ * @work:	Reference to work data.
+ */
+static void work_chip_shutdown(struct work_struct *work)
+{
+	struct cg2900_work *my_work;
+	struct cg2900_user_data *user;
+
+	if (!work) {
+		dev_err(MAIN_DEV, "work_chip_shutdown: work == NULL\n");
+		return;
+	}
+
+	my_work = container_of(work, struct cg2900_work, work);
+	user = my_work->user_data;
+
+	chip_shutdown(user);
+
+	kfree(my_work);
+}
+
+/**
+ * work_reset_after_error() - Handle reset.
+ * @work:	Reference to work data.
+ *
+ * Handle a reset after received Command Complete event.
+ */
+static void work_reset_after_error(struct work_struct *work)
+{
+	struct cg2900_work *my_work;
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	if (!work) {
+		dev_err(MAIN_DEV, "work_reset_after_error: work == NULL\n");
+		return;
+	}
+
+	my_work = container_of(work, struct cg2900_work, work);
+	dev = my_work->user_data;
+	info = dev->c_data;
+
+	chip_startup_finished(info, -EIO);
+
+	kfree(my_work);
+}
+
+/**
+ * work_load_patch_and_settings() - Start loading patches and settings.
+ * @work:	Reference to work data.
+ */
+static void work_load_patch_and_settings(struct work_struct *work)
+{
+	struct cg2900_work *my_work;
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	if (!work) {
+		dev_err(MAIN_DEV,
+			"work_load_patch_and_settings: work == NULL\n");
+		return;
+	}
+
+	my_work = container_of(work, struct cg2900_work, work);
+	dev = my_work->user_data;
+	info = dev->c_data;
+
+	/* Check that we are in the right state */
+	if (info->boot_state != BOOT_GET_FILES_TO_LOAD)
+		goto finished;
+
+	/* We now all info needed */
+	dev_dbg(BOOT_DEV, "New boot_state: BOOT_DOWNLOAD_PATCH\n");
+	info->boot_state = BOOT_DOWNLOAD_PATCH;
+	dev_dbg(BOOT_DEV, "New download_state: DOWNLOAD_PENDING\n");
+	info->download_state = DOWNLOAD_PENDING;
+	dev_dbg(BOOT_DEV, "New file_load_state: FILE_LOAD_GET_PATCH\n");
+	info->file_load_state = FILE_LOAD_GET_PATCH;
+	info->file_info.chunk_id = 0;
+	info->file_info.file_offset = 0;
+
+	send_patch_file(dev);
+
+	goto finished;
+
+finished:
+	kfree(my_work);
+}
+
+/**
+ * work_cont_file_download() - A file block has been written.
+ * @work:	Reference to work data.
+ *
+ * Handle a received HCI VS Write File Block Complete event.
+ * Normally this means continue to send files to the controller.
+ */
+static void work_cont_file_download(struct work_struct *work)
+{
+	struct cg2900_work *my_work;
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	if (!work) {
+		dev_err(MAIN_DEV, "work_cont_file_download: work == NULL\n");
+		return;
+	}
+
+	my_work = container_of(work, struct cg2900_work, work);
+	dev = my_work->user_data;
+	info = dev->c_data;
+
+	/* Continue to send patches or settings to the controller */
+	if (info->file_load_state == FILE_LOAD_GET_PATCH)
+		send_patch_file(dev);
+	else if (info->file_load_state == FILE_LOAD_GET_STATIC_SETTINGS)
+		send_settings_file(info);
+	else
+		dev_dbg(BOOT_DEV, "No more files to load\n");
+
+	kfree(my_work);
+}
+
+/**
+ * work_send_read_selftest_cmd() - HCI VS Read_SelfTests_Result command shall be sent.
+ * @work:	Reference to work data.
+ */
+static void work_send_read_selftest_cmd(struct work_struct *work)
+{
+	struct delayed_work *del_work;
+	struct cg2900_delayed_work_struct *current_work;
+	struct cg2900_chip_info *info;
+	struct hci_command_hdr cmd;
+
+	if (!work) {
+		dev_err(MAIN_DEV,
+			"work_send_read_selftest_cmd: work == NULL\n");
+		return;
+	}
+
+	del_work = to_delayed_work(work);
+	current_work = container_of(del_work,
+				    struct cg2900_delayed_work_struct, work);
+	info = current_work->data;
+
+	if (info->boot_state != BOOT_READ_SELFTEST_RESULT)
+		return;
+
+	cmd.opcode = cpu_to_le16(CG2900_BT_OP_VS_READ_SELTESTS_RESULT);
+	cmd.plen = 0; /* No parameters for Read Selftests Result */
+	cg2900_send_bt_cmd(info->user_in_charge, info->logger,
+			&cmd, sizeof(cmd), info->h4_channel_for_device);
+}
+
+/**
+ * handle_reset_cmd_complete() - Handles HCI Reset Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_reset_cmd_complete(struct cg2900_chip_dev *dev, u8 *data)
+{
+	u8 status = data[0];
+	struct cg2900_chip_info *info = dev->c_data;
+
+	dev_dbg(BOOT_DEV, "Received Reset complete event with status 0x%X\n",
+		status);
+
+	if (CG2900_CLOSING != info->main_state &&
+	    CLOSING_RESET != info->closing_state)
+		return false;
+
+	if (HCI_BT_ERROR_NO_ERROR != status) {
+		/*
+		 * Continue in case of error, the chip is going to be shut down
+		 * anyway.
+		 */
+		dev_err(BOOT_DEV, "Command complete for HciReset "\
+			"received with error 0x%X\n", status);
+	}
+
+	cg2900_create_work_item(info->wq, work_power_off_chip, dev);
+
+	return true;
+}
+
+/**
+ * handle_vs_store_in_fs_cmd_complete() - Handles HCI VS StoreInFS Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_store_in_fs_cmd_complete(struct cg2900_chip_dev *dev,
+					       u8 *data)
+{
+	u8 status = data[0];
+	struct cg2900_chip_info *info = dev->c_data;
+
+	dev_dbg(BOOT_DEV,
+		"Received Store_in_FS complete event with status 0x%X\n",
+		status);
+
+	if (info->boot_state != BOOT_SEND_BD_ADDRESS)
+		return false;
+
+	if (HCI_BT_ERROR_NO_ERROR == status) {
+		struct hci_command_hdr cmd;
+
+		/* Send HCI SystemReset command to activate patches */
+		dev_dbg(BOOT_DEV,
+			"New boot_state: BOOT_ACTIVATE_PATCHES_AND_SETTINGS\n");
+		info->boot_state = BOOT_ACTIVATE_PATCHES_AND_SETTINGS;
+
+		cmd.opcode = cpu_to_le16(CG2900_BT_OP_VS_SYSTEM_RESET);
+		cmd.plen = 0; /* No parameters for System Reset */
+		cg2900_send_bt_cmd(info->user_in_charge, info->logger,
+				&cmd, sizeof(cmd), info->h4_channel_for_device);
+	} else {
+		dev_err(BOOT_DEV,
+			"Command complete for StoreInFS received with error "
+			"0x%X\n", status);
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		cg2900_create_work_item(info->wq, work_reset_after_error, dev);
+	}
+
+	return true;
+}
+
+/**
+ * handle_vs_write_file_block_cmd_complete() - Handles HCI VS WriteFileBlock Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_write_file_block_cmd_complete(struct cg2900_chip_dev *dev,
+						    u8 *data)
+{
+	u8 status = data[0];
+	struct cg2900_chip_info *info = dev->c_data;
+
+	if (info->boot_state != BOOT_DOWNLOAD_PATCH ||
+	    info->download_state != DOWNLOAD_PENDING)
+		return false;
+
+	if (HCI_BT_WRONG_SEQ_ERROR == status && info->file_info.chunk_id == 1 &&
+			(CG2905_PG1_05_REV == dev->chip.hci_revision ||
+			CG2910_PG1_REV == dev->chip.hci_revision)) {
+		/*
+		 * Because of bug in CG2905/CG2910 PG1 H/W, the first chunk
+		 * will return an error of wrong sequence number. As a
+		 * workaround the first chunk needs to be sent again.
+		 */
+		info->file_info.chunk_id = 0;
+		info->file_info.file_offset = 0;
+		/*
+		 * Set the status back to success so that it continues on the
+		 * success path rather than failure.
+		 */
+		status = HCI_BT_ERROR_NO_ERROR;
+	}
+
+	if (HCI_BT_ERROR_NO_ERROR == status)
+		cg2900_create_work_item(info->wq, work_cont_file_download, dev);
+	else {
+		dev_err(BOOT_DEV,
+			"Command complete for WriteFileBlock received with"
+			" error 0x%X\n", status);
+		dev_dbg(BOOT_DEV, "New download_state: DOWNLOAD_FAILED\n");
+		info->download_state = DOWNLOAD_FAILED;
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		cg2900_create_work_item(info->wq, work_reset_after_error, dev);
+	}
+
+	return true;
+}
+
+/**
+ * handle_vs_write_file_block_cmd_status() - Handles HCI VS WriteFileBlock Command Status event.
+ * @status:	Returned status of WriteFileBlock command.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_write_file_block_cmd_status(struct cg2900_chip_dev *dev,
+						  u8 status)
+{
+	struct cg2900_chip_info *info = dev->c_data;
+
+	if (info->boot_state != BOOT_DOWNLOAD_PATCH ||
+	    info->download_state != DOWNLOAD_PENDING)
+		return false;
+
+	/*
+	 * Only do something if there is an error. Otherwise we will wait for
+	 * CmdComplete.
+	 */
+	if (HCI_BT_ERROR_NO_ERROR != status) {
+		dev_err(BOOT_DEV,
+			"Command status for WriteFileBlock received with"
+			" error 0x%X\n", status);
+		dev_dbg(BOOT_DEV, "New download_state: DOWNLOAD_FAILED\n");
+		info->download_state = DOWNLOAD_FAILED;
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		cg2900_create_work_item(info->wq, work_reset_after_error, dev);
+	}
+
+	return true;
+}
+
+/**
+ * handle_vs_power_switch_off_cmd_complete() - Handles HCI VS PowerSwitchOff Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_power_switch_off_cmd_complete(struct cg2900_chip_dev *dev,
+						    u8 *data)
+{
+	u8 status = data[0];
+	struct cg2900_chip_info *info = dev->c_data;
+
+	if (CLOSING_POWER_SWITCH_OFF != info->closing_state)
+		return false;
+
+	dev_dbg(BOOT_DEV,
+		"handle_vs_power_switch_off_cmd_complete status %d\n", status);
+
+	/*
+	 * We were waiting for this but we don't need to do anything upon
+	 * reception except warn for error status
+	 */
+	if (HCI_BT_ERROR_NO_ERROR != status)
+		dev_err(BOOT_DEV,
+			"Command Complete for PowerSwitchOff received with "
+			"error 0x%X", status);
+
+	return true;
+}
+
+/**
+ * handle_vs_system_reset_cmd_complete() - Handle HCI VS SystemReset Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_system_reset_cmd_complete(struct cg2900_chip_dev *dev,
+						u8 *data)
+{
+	u8 status = data[0];
+	struct cg2900_chip_info *info = dev->c_data;
+
+	if (info->boot_state != BOOT_ACTIVATE_PATCHES_AND_SETTINGS)
+		return false;
+
+	dev_dbg(BOOT_DEV, "handle_vs_system_reset_cmd_complete status %d\n",
+		status);
+
+	if (HCI_BT_ERROR_NO_ERROR == status) {
+		if (dev->chip.hci_revision == CG2900_PG2_REV) {
+			/*
+			 * We must now wait for the selftest results. They will
+			 * take a certain amount of time to finish so start a
+			 * delayed work that will then send the command.
+			 */
+			dev_dbg(BOOT_DEV,
+				"New boot_state: BOOT_READ_SELFTEST_RESULT\n");
+			info->boot_state = BOOT_READ_SELFTEST_RESULT;
+			queue_delayed_work(info->wq, &info->selftest_work.work,
+					   msecs_to_jiffies(SELFTEST_INITIAL));
+			info->nbr_of_polls = 0;
+		} else {
+			/*
+			 * We are now almost finished. Shut off BT Core. It will
+			 * be re-enabled by the Bluetooth driver when needed.
+			 */
+			dev_dbg(BOOT_DEV, "New boot_state: BOOT_READY\n");
+			info->boot_state = BOOT_READY;
+			chip_startup_finished(info, 0);
+		}
+	} else {
+		dev_err(BOOT_DEV,
+			"Received Reset complete event with status 0x%X\n",
+			status);
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		chip_startup_finished(info, -EIO);
+	}
+
+	return true;
+}
+
+/**
+ * handle_vs_read_selftests_cmd_complete() - Handle HCI VS ReadSelfTestsResult Command Complete event.
+ * @dev:	Current chip.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_read_selftests_cmd_complete(struct cg2900_chip_dev *dev,
+						  u8 *data)
+{
+	struct bt_vs_read_selftests_result_evt *evt =
+			(struct bt_vs_read_selftests_result_evt *)data;
+	struct cg2900_chip_info *info = dev->c_data;
+
+	if (info->boot_state != BOOT_READ_SELFTEST_RESULT)
+		return false;
+
+	dev_dbg(BOOT_DEV,
+		"handle_vs_read_selftests_cmd_complete status %d result %d\n",
+		evt->status, evt->result);
+
+	if (HCI_BT_ERROR_NO_ERROR != evt->status)
+		goto err_handling;
+
+	if (CG2900_BT_SELFTEST_SUCCESSFUL == evt->result ||
+	    CG2900_BT_SELFTEST_FAILED == evt->result) {
+		if (CG2900_BT_SELFTEST_FAILED == evt->result)
+			dev_err(BOOT_DEV, "CG2900 self test failed\n");
+
+		/*
+		 * We are now almost finished. Shut off BT Core. It will
+		 * be re-enabled by the Bluetooth driver when needed.
+		 */
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_READY\n");
+		info->boot_state = BOOT_READY;
+		chip_startup_finished(info, 0);
+		return true;
+	} else if (CG2900_BT_SELFTEST_NOT_COMPLETED == evt->result) {
+		/*
+		 * Self tests are not yet finished. Wait some more time
+		 * before resending the command
+		 */
+		if (info->nbr_of_polls > MAX_NBR_OF_POLLS) {
+			dev_err(BOOT_DEV, "Selftest results reached max"\
+				" number of polls\n");
+			goto err_handling;
+		}
+		queue_delayed_work(info->wq, &info->selftest_work.work,
+				   msecs_to_jiffies(SELFTEST_POLLING));
+		info->nbr_of_polls++;
+		return true;
+	}
+
+err_handling:
+	dev_err(BOOT_DEV,
+		"Received Read SelfTests Result complete event with "
+		"status 0x%X and result 0x%X\n",
+		evt->status, evt->result);
+	dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+	info->boot_state = BOOT_FAILED;
+	chip_startup_finished(info, -EIO);
+	return true;
+}
+
+/**
+ * handle_rx_data_bt_evt() - Check if received data should be handled in CG2900 chip driver.
+ * @skb:	Data packet
+ *
+ * The handle_rx_data_bt_evt() function checks if received data should be
+ * handled in CG2900 chip driver. If so handle it correctly.
+ * Received data is always HCI BT Event.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_rx_data_bt_evt(struct cg2900_chip_dev *dev,
+				  struct sk_buff *skb, int h4_channel)
+{
+	bool pkt_handled = false;
+	/* skb cannot be NULL here so it is safe to de-reference */
+	u8 *data = skb->data;
+	struct hci_event_hdr *evt;
+	u16 op_code;
+	bool use_dev = use_device_channel_for_vs_cmd(dev->chip.hci_revision);
+	evt = (struct hci_event_hdr *)data;
+	data += sizeof(*evt);
+
+	/* First check the event code. */
+	if (HCI_EV_CMD_COMPLETE == evt->evt) {
+		struct hci_ev_cmd_complete *cmd_complete;
+
+		cmd_complete = (struct hci_ev_cmd_complete *)data;
+		op_code = le16_to_cpu(cmd_complete->opcode);
+
+		dev_dbg(dev->dev,
+			"Received Command Complete: op_code = 0x%04X\n",
+			op_code);
+		/* Move to first byte after OCF */
+		data += sizeof(*cmd_complete);
+
+		if (op_code == HCI_OP_RESET)
+			pkt_handled = handle_reset_cmd_complete(dev, data);
+		else {
+			if (use_dev) {
+				if (h4_channel != CHANNEL_DEV_MGMT)
+					return false;
+			} else if (h4_channel != CHANNEL_BT_EVT)
+				return false;
+
+			if (op_code == CG2900_BT_OP_VS_STORE_IN_FS)
+				pkt_handled =
+					handle_vs_store_in_fs_cmd_complete(
+						dev, data);
+			else if (op_code == CG2900_BT_OP_VS_WRITE_FILE_BLOCK)
+				pkt_handled =
+					handle_vs_write_file_block_cmd_complete(
+								dev, data);
+			else if (op_code == CG2900_BT_OP_VS_POWER_SWITCH_OFF)
+				pkt_handled =
+					handle_vs_power_switch_off_cmd_complete(
+								dev, data);
+			else if (op_code == CG2900_BT_OP_VS_SYSTEM_RESET) {
+				if (dev->chip.hci_revision == CG2900_PG2_REV) {
+					struct cg2900_chip_info *info =
+							dev->c_data;
+					/*
+					 * Don't wait till READ_SELFTESTS_RESULT
+					 * is complete for clock users
+					 */
+					dev_dbg(dev->dev,
+							"New main_state: CG2900_ACTIVE_BEFORE_SELFTEST\n");
+					info->main_state =
+						CG2900_ACTIVE_BEFORE_SELFTEST;
+					wake_up_all(&clk_user_wait_queue);
+				}
+
+				pkt_handled =
+					handle_vs_system_reset_cmd_complete(
+								dev, data);
+			} else if (op_code ==
+					CG2900_BT_OP_VS_READ_SELTESTS_RESULT)
+				pkt_handled =
+					handle_vs_read_selftests_cmd_complete(
+								dev, data);
+		}
+	} else if (HCI_EV_CMD_STATUS == evt->evt) {
+		struct hci_ev_cmd_status *cmd_status;
+
+		if (use_dev) {
+			if (h4_channel != CHANNEL_DEV_MGMT)
+				return false;
+		} else if (h4_channel != CHANNEL_BT_EVT)
+			return false;
+
+		cmd_status = (struct hci_ev_cmd_status *)data;
+
+		op_code = le16_to_cpu(cmd_status->opcode);
+
+		dev_dbg(dev->dev, "Received Command Status: op_code = 0x%04X\n",
+			op_code);
+
+		if (op_code == CG2900_BT_OP_VS_WRITE_FILE_BLOCK)
+			pkt_handled = handle_vs_write_file_block_cmd_status
+				(dev, cmd_status->status);
+	} else if (HCI_EV_VENDOR_SPECIFIC == evt->evt) {
+		/*
+		 * In the new versions of CG29xx i.e. after CG2900 we
+		 * will recieve HCI_Event_VS_Write_File_Block_Complete
+		 * instead of Command Complete while downloading
+		 * the patches/settings file
+		 */
+		struct bt_vs_evt *cmd_evt;
+		if (use_dev) {
+			if (h4_channel != CHANNEL_DEV_MGMT)
+				return false;
+		} else if (h4_channel != CHANNEL_BT_EVT)
+			return false;
+
+		cmd_evt = (struct bt_vs_evt *)data;
+
+		if (cmd_evt->evt_id == CG2900_EV_VS_WRITE_FILE_BLOCK_COMPLETE) {
+			struct bt_vs_write_file_block_evt *write_block_evt;
+			write_block_evt =
+				(struct bt_vs_write_file_block_evt *)
+				cmd_evt->data;
+			dev_dbg(dev->dev, "Received VS write file block complete\n");
+			pkt_handled = handle_vs_write_file_block_cmd_complete(
+				dev, &write_block_evt->status);
+		} else {
+			dev_err(dev->dev, "Vendor Specific Event 0x%x"\
+					"Not Supported\n", cmd_evt->evt_id);
+			return false;
+		}
+	} else if (HCI_EV_HW_ERROR == evt->evt) {
+		struct hci_ev_hw_error *hw_error;
+
+		hw_error = (struct hci_ev_hw_error *)data;
+		/*
+		 * Only do a printout. There might be a receiving stack that can
+		 * handle this event
+		 */
+		dev_err(dev->dev, "HW Error event received with error 0x%02X\n",
+			hw_error->hw_code);
+		return false;
+	} else
+		return false;
+
+	if (pkt_handled)
+		kfree_skb(skb);
+
+	return pkt_handled;
+}
+
+/**
+ * transmit_skb_with_flow_ctrl_bt() - Send the BT skb to the controller if it is allowed or queue it.
+ * @user:	Current user.
+ * @skb:	Data packet.
+ *
+ * The transmit_skb_with_flow_ctrl_bt() function checks if there are
+ * tickets available and if so transmits buffer to controller. Otherwise the skb
+ * and user name is stored in a list for later sending.
+ * If enabled, copy the transmitted data to the HCI logger as well.
+ */
+static void transmit_skb_with_flow_ctrl_bt(struct cg2900_user_data *user,
+					   struct sk_buff *skb)
+{
+	struct cg2900_chip_dev *dev = cg2900_get_prv(user);
+	struct cg2900_chip_info *info = dev->c_data;
+
+	/*
+	 * Because there are more users of some H4 channels (currently audio
+	 * application for BT command and FM channel) we need to have an
+	 * internal HCI command flow control in CG2900 driver.
+	 * So check here how many tickets we have and store skb in a queue if
+	 * there are no tickets left. The skb will be sent later when we get
+	 * more ticket(s).
+	 */
+	spin_lock_bh(&info->tx_bt_lock);
+
+	if (info->tx_nr_pkts_allowed_bt > 0) {
+		info->tx_nr_pkts_allowed_bt--;
+		dev_dbg(user->dev, "New tx_nr_pkts_allowed_bt = %d\n",
+			info->tx_nr_pkts_allowed_bt);
+
+		/*
+		 * If it's command from audio app store the OpCode,
+		 * it'll be used later to decide where to dispatch Command
+		 * Complete event.
+		 */
+		if (info->bt_audio == user) {
+			struct hci_command_hdr *hdr = (struct hci_command_hdr *)
+				(skb->data + HCI_H4_SIZE);
+
+			info->audio_bt_cmd_op = le16_to_cpu(hdr->opcode);
+
+			dev_dbg(user->dev,
+				"Sending cmd from audio driver, saving "
+				"OpCode = 0x%X\n",
+				info->audio_bt_cmd_op);
+		}
+
+		cg2900_tx_to_chip(user, info->logger, skb);
+	} else {
+		dev_dbg(user->dev, "Not allowed to send cmd to controller, "\
+			"storing in TX queue\n");
+
+		cg2900_skb_data(skb)->user = user;
+		skb_queue_tail(&info->tx_queue_bt, skb);
+	}
+	spin_unlock_bh(&info->tx_bt_lock);
+}
+
+/**
+ * transmit_skb_with_flow_ctrl_fm() - Send the FM skb to the controller if it is allowed or queue it.
+ * @user:	Current user.
+ * @skb:	Data packet.
+ *
+ * The transmit_skb_with_flow_ctrl_fm() function checks if chip is available and
+ * if so transmits buffer to controller. Otherwise the skb and user name is
+ * stored in a list for later sending.
+ * Also it updates the FM radio mode if it's FM GOTOMODE command, this is needed
+ * to know how to handle some FM DO commands complete events.
+ * If enabled, copy the transmitted data to the HCI logger as well.
+ */
+static void transmit_skb_with_flow_ctrl_fm(struct cg2900_user_data *user,
+					   struct sk_buff *skb)
+{
+	u8 cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	u16 cmd_id = CG2900_FM_CMD_NONE;
+	struct cg2900_chip_dev *dev = cg2900_get_prv(user);
+	struct cg2900_chip_info *info = dev->c_data;
+
+	fm_parse_cmd(&(skb->data[0]), &cmd_func, &cmd_id);
+
+	/*
+	 * If this is an FM IP disable or reset send command and also reset
+	 * the flow control and audio user.
+	 */
+	if (cmd_func == CG2900_FM_CMD_PARAM_DISABLE ||
+	    cmd_func == CG2900_FM_CMD_PARAM_RESET) {
+		spin_lock_bh(&info->tx_fm_lock);
+		fm_reset_flow_ctrl(info);
+		spin_unlock_bh(&info->tx_fm_lock);
+		cg2900_tx_to_chip(user, info->logger, skb);
+		return;
+	}
+
+	/*
+	 * If this is a FM user and no FM audio user command pending just send
+	 * FM command. It is up to the user of the FM channel to handle its own
+	 * flow control.
+	 */
+	spin_lock_bh(&info->tx_fm_lock);
+	if (info->fm_audio != user &&
+	    info->audio_fm_cmd_id == CG2900_FM_CMD_NONE) {
+		info->hci_fm_cmd_func = cmd_func;
+		dev_dbg(user->dev, "Sending FM radio command 0x%04X\n",
+			info->hci_fm_cmd_func);
+		/* If a GotoMode command update FM mode */
+		fm_update_mode(info, &skb->data[0]);
+		cg2900_tx_to_chip(user, info->logger, skb);
+	} else if (info->fm_audio == user &&
+		   info->hci_fm_cmd_func == CG2900_FM_CMD_PARAM_NONE &&
+		   info->audio_fm_cmd_id == CG2900_FM_CMD_NONE) {
+		/*
+		 * If it's command from fm audio user store the command id.
+		 * It'll be used later to decide where to dispatch
+		 * command complete event.
+		 */
+		info->audio_fm_cmd_id = cmd_id;
+		dev_dbg(user->dev, "Sending FM audio command 0x%04X\n",
+			info->audio_fm_cmd_id);
+		cg2900_tx_to_chip(user, info->logger, skb);
+	} else {
+		dev_dbg(user->dev,
+			"Not allowed to send FM cmd to controller, storing in "
+			"TX queue\n");
+
+		cg2900_skb_data(skb)->user = user;
+		skb_queue_tail(&info->tx_queue_fm, skb);
+	}
+	spin_unlock_bh(&info->tx_fm_lock);
+}
+
+/**
+ * is_bt_audio_user() - Checks if this packet is for the BT audio user.
+ * @info:	CG2900 info.
+ * @h4_channel:	H:4 channel for this packet.
+ * @skb:	Packet to check.
+ *
+ * Returns:
+ *   true if packet is for BT audio user.
+ *   false otherwise.
+ */
+static bool is_bt_audio_user(struct cg2900_chip_info *info, int h4_channel,
+			     const struct sk_buff * const skb)
+{
+	struct hci_event_hdr *hdr;
+	u8 *payload;
+	u16 opcode;
+
+	if (use_device_channel_for_vs_cmd(info->chip_dev->chip.hci_revision)) {
+		if (h4_channel == CHANNEL_DEV_MGMT_AUDIO)
+			return true;
+		else
+			return false;
+	}
+
+	if (h4_channel != CHANNEL_BT_EVT)
+		return false;
+
+	hdr = (struct hci_event_hdr *)skb->data;
+	payload = (u8 *)(hdr + 1); /* follows header */
+
+	if (HCI_EV_CMD_COMPLETE == hdr->evt)
+		opcode = le16_to_cpu(
+			((struct hci_ev_cmd_complete *)payload)->opcode);
+	else if (HCI_EV_CMD_STATUS == hdr->evt)
+		opcode = le16_to_cpu(
+			((struct hci_ev_cmd_status *)payload)->opcode);
+	else
+		return false;
+
+	if (opcode != info->audio_bt_cmd_op)
+		return false;
+
+	dev_dbg(info->bt_audio->dev, "Audio BT OpCode match = 0x%04X\n",
+		opcode);
+	info->audio_bt_cmd_op = CG2900_BT_OPCODE_NONE;
+	return true;
+}
+
+/**
+ * is_fm_audio_user() - Checks if this packet is for the FM audio user.
+ * @info:	CG2900 info.
+ * @h4_channel:	H:4 channel for this packet.
+ * @skb:	Packet to check.
+ *
+ * Returns:
+ *   true if packet is for BT audio user.
+ *   false otherwise.
+ */
+static bool is_fm_audio_user(struct cg2900_chip_info *info, int h4_channel,
+			     const struct sk_buff * const skb)
+{
+	u8 cmd_func;
+	u16 cmd_id;
+	u16 irpt_val;
+	u8 event;
+
+	if (h4_channel != CHANNEL_FM_RADIO)
+		return false;
+
+	cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	cmd_id = CG2900_FM_CMD_NONE;
+	irpt_val = 0;
+	event = CG2900_FM_EVENT_UNKNOWN;
+
+	fm_parse_event(&skb->data[0], &event, &cmd_func, &cmd_id,
+		       &irpt_val);
+	/* Check if command complete event FM legacy interface. */
+	if ((event == CG2900_FM_EVENT_CMD_COMPLETE) &&
+	    (cmd_func == CG2900_FM_CMD_PARAM_WRITECOMMAND) &&
+	    (cmd_id == info->audio_fm_cmd_id)) {
+		dev_dbg(info->fm_audio->dev,
+			"FM Audio Function Code match = 0x%04X\n",
+			cmd_id);
+		return true;
+	}
+
+	/* Check if Interrupt legacy interface. */
+	if ((event == CG2900_FM_EVENT_INTERRUPT) &&
+	    (fm_is_do_cmd_irpt(irpt_val)) &&
+	    (info->tx_fm_audio_awaiting_irpt))
+		return true;
+
+	return false;
+}
+
+/**
+ * data_from_chip() - Called when data is received from the chip.
+ * @dev:	Chip info.
+ * @cg2900_dev:	CG2900 user for this packet.
+ * @skb:	Packet received.
+ *
+ * The data_from_chip() function updates flow control and checks
+ * if packet is a response for a packet it itself has transmitted. If not it
+ * finds the correct user and sends the packet* to the user.
+ */
+static void data_from_chip(struct cg2900_chip_dev *dev,
+			   struct sk_buff *skb)
+{
+	int h4_channel;
+	struct list_head *cursor;
+	struct cg2900_channel_item *tmp;
+	struct cg2900_chip_info *info = dev->c_data;
+	struct cg2900_user_data *user = NULL;
+
+	spin_lock_bh(&info->rw_lock);
+	/* Copy RX Data into logger.*/
+	if (info->logger)
+		cg2900_send_to_hci_logger(info->logger, skb,
+						LOGGER_DIRECTION_RX);
+
+	/*
+	 * HCI Raw user can only have exclusive access to chip, there won't be
+	 * other users once it's opened.
+	 */
+	if (info->hci_raw && info->hci_raw->opened) {
+		info->hci_raw->read_cb(info->hci_raw, skb);
+		spin_unlock_bh(&info->rw_lock);
+		return;
+	}
+
+	h4_channel = skb->data[0];
+	skb_pull(skb, HCI_H4_SIZE);
+
+	/* First check if it is a BT or FM audio event */
+	if (is_bt_audio_user(info, h4_channel, skb))
+		user = info->bt_audio;
+	else if (is_fm_audio_user(info, h4_channel, skb))
+		user = info->fm_audio;
+	spin_unlock_bh(&info->rw_lock);
+
+	/* Now check if we should update flow control */
+	if (h4_channel == CHANNEL_BT_EVT)
+		update_flow_ctrl_bt(dev, skb);
+	else if (h4_channel == CHANNEL_FM_RADIO)
+		update_flow_ctrl_fm(dev, skb);
+
+	/* Then check if this is a response to data we have sent */
+	if (handle_rx_data_bt_evt(dev, skb, h4_channel))
+		return;
+
+	spin_lock_bh(&info->rw_lock);
+
+	if (user)
+		goto user_found;
+
+	/* Let's see if it is the last user */
+	if (info->last_user && info->last_user->h4_channel == h4_channel) {
+		user = info->last_user;
+		goto user_found;
+	}
+
+	/*
+	 * Search through the list of all open channels to find the user.
+	 * We skip the audio channels since they have already been checked
+	 * earlier in this function.
+	 */
+	list_for_each(cursor, &info->open_channels) {
+		tmp = list_entry(cursor, struct cg2900_channel_item, list);
+		if (tmp->user->h4_channel == h4_channel &&
+		    !tmp->user->is_audio) {
+			user = tmp->user;
+			goto user_found;
+		}
+	}
+
+user_found:
+	if (user != info->bt_audio && user != info->fm_audio)
+		info->last_user = user;
+
+	spin_unlock_bh(&info->rw_lock);
+
+	if (user)
+		user->read_cb(user, skb);
+	else {
+		dev_err(dev->dev,
+			"Could not find corresponding user to h4_channel %d\n",
+			h4_channel);
+		kfree_skb(skb);
+	}
+}
+
+/**
+ * chip_removed() - Called when transport has been removed.
+ * @dev:	Chip device.
+ *
+ * Removes registered MFD devices and frees internal resources.
+ */
+static void chip_removed(struct cg2900_chip_dev *dev)
+{
+	struct cg2900_chip_info *info = dev->c_data;
+
+	cancel_delayed_work(&info->selftest_work.work);
+	mfd_remove_devices(dev->dev);
+	if (info->file_info.fw_file_ptc) {
+		release_firmware(info->file_info.fw_file_ptc);
+		info->file_info.fw_file_ptc = NULL;
+	}
+
+	if (info->file_info.fw_file_ssf) {
+		release_firmware(info->file_info.fw_file_ssf);
+		info->file_info.fw_file_ssf = NULL;
+	}
+
+	kfree(info->settings_file_name);
+	kfree(info->patch_file_name);
+	destroy_workqueue(info->wq);
+	kfree(info);
+	dev->c_data = NULL;
+	dev->c_cb.chip_removed = NULL;
+	dev->c_cb.data_from_chip = NULL;
+}
+
+/**
+ * last_bt_user_removed() - Called when last BT user is removed.
+ * @info:	Chip handler info.
+ *
+ * Clears out TX queue for BT.
+ */
+static void last_bt_user_removed(struct cg2900_chip_info *info)
+{
+	spin_lock_bh(&info->tx_bt_lock);
+	skb_queue_purge(&info->tx_queue_bt);
+
+	/*
+	 * Reset number of packets allowed and number of outstanding
+	 * BT commands.
+	 */
+	info->tx_nr_pkts_allowed_bt = 1;
+	/* Reset the audio_bt_cmd_op. */
+	info->audio_bt_cmd_op = CG2900_BT_OPCODE_NONE;
+	spin_unlock_bh(&info->tx_bt_lock);
+}
+
+/**
+ * last_fm_user_removed() - Called when last FM user is removed.
+ * @info:	Chip handler info.
+ *
+ * Clears out TX queue for BT.
+ */
+static void last_fm_user_removed(struct cg2900_chip_info *info)
+{
+	spin_lock_bh(&info->tx_fm_lock);
+	fm_reset_flow_ctrl(info);
+	spin_unlock_bh(&info->tx_fm_lock);
+}
+
+/**
+ * chip_shutdown() - Reset and power the chip off.
+ * @user:	MFD device.
+ */
+static void chip_shutdown(struct cg2900_user_data *user)
+{
+	struct hci_command_hdr cmd;
+	struct cg2900_chip_dev *dev = cg2900_get_prv(user);
+	struct cg2900_chip_info *info = dev->c_data;
+
+	dev_dbg(user->dev, "chip_shutdown\n");
+
+	/* First do a quick power switch of the chip to assure a good state */
+	if (dev->t_cb.set_chip_power)
+		dev->t_cb.set_chip_power(dev, false);
+
+	/*
+	 * Wait 50ms before continuing to be sure that the chip detects
+	 * chip power off.
+	 */
+	schedule_timeout_killable(
+			msecs_to_jiffies(LINE_TOGGLE_DETECT_TIMEOUT));
+
+	if (dev->t_cb.set_chip_power)
+		dev->t_cb.set_chip_power(dev, true);
+
+	/* Wait 100ms before continuing to be sure that the chip is ready */
+	schedule_timeout_killable(msecs_to_jiffies(CHIP_READY_TIMEOUT));
+
+	if (user != info->bt_audio && user != info->fm_audio)
+		info->last_user = user;
+	info->user_in_charge = user;
+
+	/*
+	 * Transmit HCI reset command to ensure the chip is using
+	 * the correct transport and to put BT part in reset.
+	 */
+	dev_dbg(user->dev, "New closing_state: CLOSING_RESET\n");
+	info->closing_state = CLOSING_RESET;
+	cmd.opcode = cpu_to_le16(HCI_OP_RESET);
+	cmd.plen = 0; /* No parameters for HCI reset */
+	cg2900_send_bt_cmd(info->user_in_charge, info->logger, &cmd,
+			   sizeof(cmd), CHANNEL_BT_CMD);
+}
+
+/**
+ * chip_startup_finished() - Called when chip startup has finished.
+ * @info:	Chip handler info.
+ * @err:	Result of chip startup, 0 for no error.
+ *
+ * Shuts down the chip upon error, sets state to active, wakes waiting threads,
+ * and informs transport that startup has finished.
+ */
+static void chip_startup_finished(struct cg2900_chip_info *info, int err)
+{
+	dev_dbg(BOOT_DEV, "chip_startup_finished (%d)\n", err);
+
+	if (err)
+		/* Shutdown the chip */
+		cg2900_create_work_item(info->wq, work_chip_shutdown,
+					info->user_in_charge);
+	else {
+		dev_dbg(BOOT_DEV, "New main_state: CG2900_ACTIVE\n");
+		info->main_state = CG2900_ACTIVE;
+	}
+
+	wake_up_all(&main_wait_queue);
+
+	if (err) {
+		if (info->chip_dev->chip.hci_revision == CG2900_PG2_REV) {
+			/*
+			 * This will wakeup clock user too
+			 * if it started the initialization process
+			 */
+			wake_up_all(&clk_user_wait_queue);
+			return;
+		}
+	}
+
+	if (!info->chip_dev->t_cb.chip_startup_finished)
+		dev_dbg(BOOT_DEV, "chip_startup_finished callback not found\n");
+	else
+		info->chip_dev->t_cb.chip_startup_finished(info->chip_dev);
+}
+
+/**
+ * cg2900_open() - Called when user wants to open an H4 channel.
+ * @user:	MFD device to open.
+ *
+ * Checks that H4 channel is not already opened. If chip is not started, starts
+ * up the chip. Sets channel as opened and adds user to active users.
+ *
+ * Returns:
+ *   0 if success.
+ *   -EINVAL if user is NULL or read_cb is NULL.
+ *   -EBUSY if chip is in transit state (being started or shutdown).
+ *   -EACCES if H4 channel is already opened.
+ *   -ENOMEM if allocation fails.
+ *   -EIO if chip startup fails.
+ *   Error codes generated by t_cb.open.
+ */
+static int cg2900_open(struct cg2900_user_data *user)
+{
+	int err;
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+	struct list_head *cursor;
+	struct cg2900_channel_item *tmp;
+	enum main_state state_to_check = CG2900_ACTIVE;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV, "cg2900_open: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	if (!user->read_cb) {
+		dev_err(user->dev, "cg2900_open: read_cb missing\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(user->dev, "cg2900_open\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	/* HCI Raw channel shall have exclusive access to chip. */
+	if (info->hci_raw && user->h4_channel != CHANNEL_HCI_RAW &&
+		user->h4_channel != CHANNEL_HCI_LOGGER) {
+		dev_err(user->dev, "cg2900_open: Cannot open %s "\
+			"channel while HCI Raw channel is opened\n",
+			user->channel_data.char_dev_name);
+		return -EACCES;
+	}
+
+	mutex_lock(&main_info->man_mutex);
+
+	/*
+	 * Add a minor wait in order to avoid CPU blocking, looping openings.
+	 * Note there will of course be no wait if we are already in the right
+	 * state.
+	 */
+	err = wait_event_timeout(main_wait_queue,
+			(CG2900_IDLE == info->main_state ||
+			 CG2900_ACTIVE == info->main_state),
+			msecs_to_jiffies(CHIP_STARTUP_TIMEOUT));
+	if (err <= 0) {
+		if (CG2900_INIT == info->main_state)
+			dev_err(user->dev, "Transport not opened\n");
+		else
+			dev_err(user->dev, "cg2900_open currently busy (0x%X)."\
+				" Try again\n", info->main_state);
+		err = -EBUSY;
+		goto err_free_mutex;
+	}
+
+	err = 0;
+
+	list_for_each(cursor, &info->open_channels) {
+		tmp = list_entry(cursor, struct cg2900_channel_item, list);
+		if (tmp->user->h4_channel == user->h4_channel &&
+		    tmp->user->is_audio == user->is_audio) {
+			dev_err(user->dev, "Channel %d is already opened\n",
+				user->h4_channel);
+			err = -EACCES;
+			goto err_free_mutex;
+		}
+	}
+
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp) {
+		dev_err(user->dev, "Could not allocate tmp\n");
+		err = -ENOMEM;
+		goto err_free_mutex;
+	}
+	tmp->user = user;
+
+	if (CG2900_ACTIVE != info->main_state &&
+	    !user->chip_independent) {
+		/* Open transport and start-up the chip */
+		if (dev->t_cb.set_chip_power)
+			dev->t_cb.set_chip_power(dev, true);
+
+		/* Wait to be sure that the chip is ready */
+		schedule_timeout_killable(
+				msecs_to_jiffies(CHIP_READY_TIMEOUT));
+
+		if (dev->t_cb.open) {
+			err = dev->t_cb.open(dev);
+			if (err) {
+				if (dev->t_cb.set_chip_power)
+					dev->t_cb.set_chip_power(dev, false);
+				goto err_free_list_item;
+			}
+		}
+
+		/* Start the boot sequence */
+		info->user_in_charge = user;
+		if (user != info->bt_audio && user != info->fm_audio)
+			info->last_user = user;
+		dev_dbg(user->dev, "New boot_state: BOOT_GET_FILES_TO_LOAD\n");
+		info->boot_state = BOOT_GET_FILES_TO_LOAD;
+		dev_dbg(user->dev, "New main_state: CG2900_BOOTING\n");
+		info->main_state = CG2900_BOOTING;
+		cg2900_create_work_item(info->wq, work_load_patch_and_settings,
+					dev);
+
+		dev_dbg(user->dev, "Wait 15sec for chip to start\n");
+		if (dev->chip.hci_revision == CG2900_PG2_REV) {
+			if (user->is_clk_user) {
+				/*
+				 * Special case only in case cg2900 PG2,
+				 * as 500ms is taken in self test, to avoid
+				 * this wait for wlan. Wlan is made to return
+				 * earlier and not wait for read self test
+				 * result.
+				 */
+				dev_dbg(user->dev, "Clock user is Waiting here\n");
+				wait_event_timeout(clk_user_wait_queue,
+					CG2900_ACTIVE_BEFORE_SELFTEST ==
+					info->main_state,
+					msecs_to_jiffies(CHIP_STARTUP_TIMEOUT));
+				state_to_check = CG2900_ACTIVE_BEFORE_SELFTEST;
+			} else {
+				dev_dbg(user->dev, "Not a Clock user\n");
+				wait_event_timeout(main_wait_queue,
+					(CG2900_ACTIVE == info->main_state ||
+					CG2900_IDLE == info->main_state),
+					msecs_to_jiffies(CHIP_STARTUP_TIMEOUT));
+			}
+		} else {
+			wait_event_timeout(main_wait_queue,
+				(CG2900_ACTIVE == info->main_state ||
+				CG2900_IDLE == info->main_state),
+				msecs_to_jiffies(CHIP_STARTUP_TIMEOUT));
+		}
+
+
+		if (state_to_check != info->main_state) {
+			dev_err(user->dev, "CG2900 init failed\n");
+
+			if (dev->t_cb.close)
+				dev->t_cb.close(dev);
+
+			dev_dbg(user->dev, "main_state: CG2900_IDLE\n");
+			info->main_state = CG2900_IDLE;
+			err = -EIO;
+			goto err_free_list_item;
+		}
+
+		if (CG2905_PG1_05_REV == dev->chip.hci_revision ||
+				CG2910_PG1_REV == dev->chip.hci_revision) {
+			/*
+			 * Switch to higher baud rate
+			 * Because of bug in CG2905/CG2910 PG1 H/W,
+			 * We have to download the ptc/ssf files
+			 * at lower baud and then switch to Higher Baud
+			 */
+			if (info->chip_dev->t_cb.set_baud_rate)
+				info->chip_dev->t_cb.set_baud_rate(
+						info->chip_dev, false);
+		}
+
+	}
+
+	list_add_tail(&tmp->list, &info->open_channels);
+
+	user->opened = true;
+
+	dev_dbg(user->dev, "H:4 channel opened\n");
+
+	mutex_unlock(&main_info->man_mutex);
+	return 0;
+err_free_list_item:
+	kfree(tmp);
+err_free_mutex:
+	mutex_unlock(&main_info->man_mutex);
+	return err;
+}
+
+/**
+ * cg2900_hci_log_open() - Called when user wants to open HCI logger channel.
+ * @user:	MFD device to open.
+ *
+ * Registers user as hci_logger and calls @cg2900_open to open the channel.
+ *
+ * Returns:
+ *   0 if success.
+ *   -EINVAL if user is NULL.
+ *   -EEXIST if H4 channel is already opened.
+ *   Error codes generated by cg2900_open.
+ */
+static int cg2900_hci_log_open(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+	int err;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"cg2900_hci_log_open: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(user->dev, "cg2900_hci_log_open\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (info->logger) {
+		dev_err(user->dev, "HCI Logger already stored\n");
+		return -EEXIST;
+	}
+
+	info->logger = user;
+	err = cg2900_open(user);
+	if (err)
+		info->logger = NULL;
+	return err;
+}
+
+/**
+ * cg2900_hci_raw_open() - Called when user wants to open HCI Raw channel.
+ * @user:	MFD device to open.
+ *
+ * Registers user as hci_raw and calls @cg2900_open to open the channel.
+ *
+ * Returns:
+ *   0 if success.
+ *   -EINVAL if user is NULL.
+ *   -EEXIST if H4 channel is already opened.
+ *   -EACCES if H4 channel iother than HCI RAW is already opened.
+ *   Error codes generated by cg2900_open.
+ */
+static int cg2900_hci_raw_open(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+	struct list_head *cursor;
+	struct cg2900_channel_item *tmp;
+	int err;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"cg2900_hci_raw_open: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(user->dev, "cg2900_hci_raw_open\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (info->hci_raw) {
+		dev_err(user->dev, "HCI Raw Channel already stored\n");
+		return -EEXIST;
+	}
+
+	if (!list_empty(&info->open_channels)) {
+		/*
+		 * Go through each open channel to check if it is logger
+		 * channel or some other channel.
+		 */
+		list_for_each(cursor, &info->open_channels) {
+			tmp = list_entry(cursor,
+					struct cg2900_channel_item, list);
+			if (tmp->user->h4_channel != CHANNEL_HCI_LOGGER) {
+				dev_err(user->dev, "Other channels other than "\
+					"Logger is already opened. Cannot open"\
+					" HCI Raw Channel\n");
+				return -EACCES;
+			}
+		}
+	}
+
+	info->hci_raw = user;
+	err = cg2900_open(user);
+	if (err)
+		info->hci_raw = NULL;
+	return err;
+}
+
+/**
+ * cg2900_bt_audio_open() - Called when user wants to open BT audio channel.
+ * @user:	MFD device to open.
+ *
+ * Registers user as bt_audio and calls @cg2900_open to open the channel.
+ *
+ * Returns:
+ *   0 if success.
+ *   -EINVAL if user is NULL.
+ *   -EEXIST if H4 channel is already opened.
+ *   Error codes generated by cg2900_open.
+ */
+static int cg2900_bt_audio_open(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+	int err;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"cg2900_bt_audio_open: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(user->dev, "cg2900_bt_audio_open\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (info->bt_audio) {
+		dev_err(user->dev, "BT Audio already stored\n");
+		return -EEXIST;
+	}
+
+	info->bt_audio = user;
+	err = cg2900_open(user);
+	if (err)
+		info->bt_audio = NULL;
+	return err;
+}
+
+/**
+ * cg2900_fm_audio_open() - Called when user wants to open FM audio channel.
+ * @user:	MFD device to open.
+ *
+ * Registers user as fm_audio and calls @cg2900_open to open the channel.
+ *
+ * Returns:
+ *   0 if success.
+ *   -EINVAL if user is NULL.
+ *   -EEXIST if H4 channel is already opened.
+ *   Error codes generated by cg2900_open.
+ */
+static int cg2900_fm_audio_open(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+	int err;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"cg2900_fm_audio_open: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(user->dev, "cg2900_fm_audio_open\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (info->fm_audio) {
+		dev_err(user->dev, "FM Audio already stored\n");
+		return -EEXIST;
+	}
+
+	info->fm_audio = user;
+	err = cg2900_open(user);
+	if (err)
+		info->fm_audio = NULL;
+	return err;
+}
+
+/**
+ * cg2900_close() - Called when user wants to close an H4 channel.
+ * @user:	MFD device to close.
+ *
+ * Clears up internal resources, sets channel as closed, and shuts down chip if
+ * this was the last user.
+ */
+static void cg2900_close(struct cg2900_user_data *user)
+{
+	bool keep_powered = false;
+	struct list_head *cursor, *next;
+	struct cg2900_channel_item *tmp;
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV, "cg2900_close: Calling with NULL pointer\n");
+		return;
+	}
+
+	dev_dbg(user->dev, "cg2900_close\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	mutex_lock(&main_info->man_mutex);
+
+	/*
+	 * Go through each open channel. Remove our channel and check if there
+	 * is any other channel that want to keep the chip running
+	 */
+	list_for_each_safe(cursor, next, &info->open_channels) {
+		tmp = list_entry(cursor, struct cg2900_channel_item, list);
+		if (tmp->user == user) {
+			list_del(cursor);
+			kfree(tmp);
+		} else if (!tmp->user->chip_independent)
+			keep_powered = true;
+	}
+
+	if (user->h4_channel == CHANNEL_BT_CMD && !bt_is_open(info))
+		last_bt_user_removed(info);
+	else if (user->h4_channel == CHANNEL_FM_RADIO && !fm_is_open(info))
+		last_fm_user_removed(info);
+
+	if (keep_powered)
+		/* This was not the last user, we're done. */
+		goto finished;
+
+	if (CG2900_IDLE == info->main_state)
+		/* Chip has already been shut down. */
+		goto finished;
+
+	dev_dbg(user->dev, "New main_state: CG2900_CLOSING\n");
+	info->main_state = CG2900_CLOSING;
+	chip_shutdown(user);
+
+	dev_dbg(user->dev, "Wait up to 15 seconds for chip to shut-down\n");
+	wait_event_timeout(main_wait_queue,
+				(CG2900_IDLE == info->main_state),
+				msecs_to_jiffies(CHIP_SHUTDOWN_TIMEOUT));
+
+	/* Force shutdown if we timed out */
+	if (CG2900_IDLE != info->main_state) {
+		dev_err(user->dev,
+			"ST-Ericsson CG2900 Core Driver was shut-down with "
+			"problems\n");
+
+		if (dev->t_cb.close)
+			dev->t_cb.close(dev);
+
+		dev_dbg(user->dev, "New main_state: CG2900_IDLE\n");
+		info->main_state = CG2900_IDLE;
+	}
+
+finished:
+	mutex_unlock(&main_info->man_mutex);
+	user->opened = false;
+	dev_dbg(user->dev, "H:4 channel closed\n");
+}
+
+/**
+ * cg2900_hci_log_close() - Called when user wants to close HCI logger channel.
+ * @user:	MFD device to close.
+ *
+ * Clears hci_logger user and calls @cg2900_close to close the channel.
+ */
+static void cg2900_hci_log_close(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"cg2900_hci_log_close: Calling with NULL pointer\n");
+		return;
+	}
+
+	dev_dbg(user->dev, "cg2900_hci_log_close\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (user != info->logger) {
+		dev_err(user->dev, "cg2900_hci_log_close: Trying to remove "\
+			"another user\n");
+		return;
+	}
+
+	info->logger = NULL;
+	cg2900_close(user);
+}
+
+/**
+ * cg2900_hci_raw_close() - Called when user wants to close HCI Raw channel.
+ * @user:	MFD device to close.
+ *
+ * Clears hci_raw user and calls @cg2900_close to close the channel.
+ */
+static void cg2900_hci_raw_close(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"cg2900_hci_raw_close: Calling with NULL pointer\n");
+		return;
+	}
+
+	dev_dbg(user->dev, "cg2900_hci_raw_close\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (user != info->hci_raw) {
+		dev_err(user->dev, "cg2900_hci_raw_close: Trying to remove "\
+			"another user\n");
+		return;
+	}
+
+	info->hci_raw = NULL;
+	cg2900_close(user);
+}
+
+/**
+ * cg2900_bt_audio_close() - Called when user wants to close BT audio channel.
+ * @user:	MFD device to close.
+ *
+ * Clears bt_audio user and calls @cg2900_close to close the channel.
+ */
+static void cg2900_bt_audio_close(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"cg2900_bt_audio_close: Calling with NULL pointer\n");
+		return;
+	}
+
+	dev_dbg(user->dev, "cg2900_bt_audio_close\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (user != info->bt_audio) {
+		dev_err(user->dev, "cg2900_bt_audio_close: Trying to remove "\
+			"another user\n");
+		return;
+	}
+
+	info->bt_audio = NULL;
+	cg2900_close(user);
+}
+
+/**
+ * cg2900_fm_audio_close() - Called when user wants to close FM audio channel.
+ * @user:	MFD device to close.
+ *
+ * Clears fm_audio user and calls @cg2900_close to close the channel.
+ */
+static void cg2900_fm_audio_close(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"cg2900_fm_audio_close: Calling with NULL pointer\n");
+		return;
+	}
+
+	dev_dbg(user->dev, "cg2900_fm_audio_close\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (user != info->fm_audio) {
+		dev_err(user->dev, "cg2900_fm_audio_close: Trying to remove "\
+			"another user\n");
+		return;
+	}
+
+	info->fm_audio = NULL;
+	cg2900_close(user);
+}
+
+/**
+ * cg2900_reset() - Called when user wants to reset the chip.
+ * @user:	MFD device to reset.
+ *
+ * Closes down the chip and calls reset_cb for all open users.
+ *
+ * Returns:
+ *   0 if success.
+ *   -EINVAL if user is NULL.
+ */
+static int cg2900_reset(struct cg2900_user_data *user)
+{
+	struct list_head *cursor, *next;
+	struct cg2900_channel_item *tmp;
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	if (!user) {
+		dev_err(MAIN_DEV, "cg2900_reset: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	dev_info(user->dev, "cg2900_reset\n");
+
+	BUG_ON(!main_info);
+
+	mutex_lock(&main_info->man_mutex);
+
+	dev_dbg(user->dev, "New main_state: CG2900_RESETING\n");
+	info->main_state = CG2900_RESETING;
+
+	chip_shutdown(user);
+
+	/*
+	 * Inform all opened channels about the reset and free the user devices
+	 */
+	list_for_each_safe(cursor, next, &info->open_channels) {
+		tmp = list_entry(cursor, struct cg2900_channel_item, list);
+		list_del(cursor);
+		tmp->user->opened  = false;
+		tmp->user->reset_cb(tmp->user);
+		kfree(tmp);
+	}
+
+	/* Reset finished. We are now idle until first channel is opened */
+	dev_dbg(user->dev, "New main_state: CG2900_IDLE\n");
+	info->main_state = CG2900_IDLE;
+
+	mutex_unlock(&main_info->man_mutex);
+
+	/*
+	 * Send wake-up since this might have been called from a failed boot.
+	 * No harm done if it is a CG2900 chip user who called.
+	 */
+	wake_up_all(&main_wait_queue);
+
+	return 0;
+}
+
+/**
+ * cg2900_alloc_skb() - Allocates socket buffer.
+ * @size:	Sk_buffer size in bytes.
+ * @priority:	GFP priorit for allocation.
+ *
+ * Allocates a sk_buffer and reserves space for H4 header.
+ *
+ * Returns:
+ *   sk_buffer if success.
+ *   NULL if allocation fails.
+ */
+static struct sk_buff *cg2900_alloc_skb(unsigned int size, gfp_t priority)
+{
+	struct sk_buff *skb;
+
+	dev_dbg(MAIN_DEV, "cg2900_alloc_skb size %d bytes\n", size);
+
+	/* Allocate the SKB and reserve space for the header */
+	skb = alloc_skb(size + CG2900_SKB_RESERVE, priority);
+	if (skb)
+		skb_reserve(skb, CG2900_SKB_RESERVE);
+
+	return skb;
+}
+
+/**
+ * cg2900_write() - Called when user wants to write to the chip.
+ * @user:	MFD device representing H4 channel to write to.
+ * @skb:	Sk_buffer to transmit.
+ *
+ * Transmits the sk_buffer to the chip. If it is a BT cmd or FM audio packet it
+ * is checked that it is allowed to transmit the chip.
+ * Note that if error is returned it is up to the user to free the skb.
+ *
+ * Returns:
+ *   0 if success.
+ *   -EINVAL if user or skb is NULL.
+ *   -EACCES if channel is closed.
+ */
+static int cg2900_write(struct cg2900_user_data *user, struct sk_buff *skb)
+{
+	u8 *h4_header;
+	struct cg2900_chip_dev *dev;
+	struct cg2900_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV, "cg2900_write: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	if (!skb) {
+		dev_err(user->dev, "cg2900_write with no sk_buffer\n");
+		return -EINVAL;
+	}
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	dev_dbg(user->dev, "cg2900_write length %d bytes\n", skb->len);
+
+	if (!user->opened) {
+		dev_err(user->dev,
+			"Trying to transmit data on a closed channel\n");
+		return -EACCES;
+	}
+
+	if (user->h4_channel == CHANNEL_HCI_RAW) {
+		/*
+		 * Since the data transmitted on HCI Raw channel
+		 * can be byte by byte, flow control cannot be used.
+		 * This should be handled by user space application
+		 * of the HCI Raw channel, so just transmit the
+		 * received data to chip.
+		 */
+		cg2900_tx_to_chip(user, info->logger, skb);
+		return 0;
+	}
+
+	/*
+	 * Move the data pointer to the H:4 header position and
+	 * store the H4 header.
+	 */
+	h4_header = skb_push(skb, CG2900_SKB_RESERVE);
+	*h4_header = (u8)user->h4_channel;
+
+	if (user->h4_channel == CHANNEL_BT_CMD)
+		transmit_skb_with_flow_ctrl_bt(user, skb);
+	else if (user->h4_channel == CHANNEL_FM_RADIO)
+		transmit_skb_with_flow_ctrl_fm(user, skb);
+	else
+		cg2900_tx_to_chip(user, info->logger, skb);
+
+	return 0;
+}
+
+/**
+ * cg2900_no_write() - Used for channels where it is not allowed to write.
+ * @user:	MFD device representing H4 channel to write to.
+ * @skb:	Sk_buffer to transmit.
+ *
+ * Returns:
+ *   -EPERM.
+ */
+static int cg2900_no_write(struct cg2900_user_data *user,
+			   __attribute__((unused)) struct sk_buff *skb)
+{
+	dev_err(user->dev, "Not allowed to send on this channel\n");
+	return -EPERM;
+}
+
+/**
+ * cg2900_get_local_revision() - Called to retrieve revision data for the chip.
+ * @user:	MFD device to check.
+ * @rev_data:	Revision data to fill in.
+ *
+ * Returns:
+ *   true if success.
+ *   false upon failure.
+ */
+static bool cg2900_get_local_revision(struct cg2900_user_data *user,
+				      struct cg2900_rev_data *rev_data)
+{
+	struct cg2900_chip_dev *dev;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV, "cg2900_get_local_revision: Calling with "\
+			"NULL pointer\n");
+		return false;
+	}
+
+	if (!rev_data) {
+		dev_err(user->dev, "Calling with rev_data NULL\n");
+		return false;
+	}
+
+	dev = cg2900_get_prv(user);
+
+	rev_data->revision = dev->chip.hci_revision;
+	rev_data->sub_version = dev->chip.hci_sub_version;
+
+	return true;
+}
+
+static struct cg2900_user_data btcmd_data = {
+	.h4_channel = CHANNEL_BT_CMD,
+};
+static struct cg2900_user_data btacl_data = {
+	.h4_channel = CHANNEL_BT_ACL,
+};
+static struct cg2900_user_data btevt_data = {
+	.h4_channel = CHANNEL_BT_EVT,
+};
+static struct cg2900_user_data nfc_data = {
+	.h4_channel = CHANNEL_NFC,
+};
+static struct cg2900_user_data antcmd_data = {
+	.h4_channel = CHANNEL_ANT_CMD,
+};
+static struct cg2900_user_data antdat_data = {
+	.h4_channel = CHANNEL_ANT_DAT,
+};
+static struct cg2900_user_data fm_data = {
+	.h4_channel = CHANNEL_FM_RADIO,
+};
+static struct cg2900_user_data gnss_data = {
+	.h4_channel = CHANNEL_GNSS,
+};
+static struct cg2900_user_data debug_data = {
+	.h4_channel = CHANNEL_DEBUG,
+};
+static struct cg2900_user_data ste_tools_data = {
+	.h4_channel = CHANNEL_STE_TOOLS,
+};
+static struct cg2900_user_data hci_logger_data = {
+	.h4_channel = CHANNEL_HCI_LOGGER,
+	.chip_independent = true,
+	.write = cg2900_no_write,
+	.open = cg2900_hci_log_open,
+	.close = cg2900_hci_log_close,
+};
+static struct cg2900_user_data core_data = {
+	.h4_channel = CHANNEL_CORE,
+	.write = cg2900_no_write,
+};
+static struct cg2900_user_data audio_vs_data = {
+	.h4_channel = CHANNEL_BT_CMD,
+	.is_audio = true,
+	.open = cg2900_bt_audio_open,
+	.close = cg2900_bt_audio_close,
+};
+static struct cg2900_user_data audio_fm_data = {
+	.h4_channel = CHANNEL_FM_RADIO,
+	.is_audio = true,
+	.open = cg2900_fm_audio_open,
+	.close = cg2900_fm_audio_close,
+};
+static struct cg2900_user_data hci_raw_data = {
+	.h4_channel = CHANNEL_HCI_RAW,
+	.open = cg2900_hci_raw_open,
+	.close = cg2900_hci_raw_close,
+};
+
+static struct mfd_cell cg2900_devs[] = {
+	{
+		.name = "cg2900-btcmd",
+		.platform_data = &btcmd_data,
+		.pdata_size = sizeof(btcmd_data),
+	},
+	{
+		.name = "cg2900-btacl",
+		.platform_data = &btacl_data,
+		.pdata_size = sizeof(btacl_data),
+	},
+	{
+		.name = "cg2900-btevt",
+		.platform_data = &btevt_data,
+		.pdata_size = sizeof(btevt_data),
+	},
+	{
+		.name = "cg2900-fm",
+		.platform_data = &fm_data,
+		.pdata_size = sizeof(fm_data),
+	},
+	{
+		.name = "cg2900-gnss",
+		.platform_data = &gnss_data,
+		.pdata_size = sizeof(gnss_data),
+	},
+	{
+		.name = "cg2900-debug",
+		.platform_data = &debug_data,
+		.pdata_size = sizeof(debug_data),
+	},
+	{
+		.name = "cg2900-stetools",
+		.platform_data = &ste_tools_data,
+		.pdata_size = sizeof(ste_tools_data),
+	},
+	{
+		.name = "cg2900-hcilogger",
+		.platform_data = &hci_logger_data,
+		.pdata_size = sizeof(hci_logger_data),
+	},
+	{
+		.name = "cg2900-core",
+		.platform_data = &core_data,
+		.pdata_size = sizeof(core_data),
+	},
+	{
+		.name = "cg2900-audiovs",
+		.platform_data = &audio_vs_data,
+		.pdata_size = sizeof(audio_vs_data),
+	},
+	{
+		.name = "cg2900-audiofm",
+		.platform_data = &audio_fm_data,
+		.pdata_size = sizeof(audio_fm_data),
+	},
+	{
+		.name = "cg2900-hciraw",
+		.platform_data = &hci_raw_data,
+		.pdata_size = sizeof(hci_raw_data),
+	},
+};
+
+static struct mfd_cell cg2905_extra_devs[] = {
+	{
+		.name = "cg2900-antcmd",
+		.platform_data = &antcmd_data,
+		.pdata_size = sizeof(antcmd_data)
+	},
+	{
+		.name = "cg2900-antdat",
+		.platform_data = &antdat_data,
+		.pdata_size = sizeof(antdat_data)
+	},
+};
+
+static struct mfd_cell cg2910_extra_devs[] = {
+	{
+		.name = "cg2900-nfc",
+		.platform_data = &nfc_data,
+		.pdata_size = sizeof(nfc_data)
+	},
+};
+
+static struct mfd_cell cg2910_extra_devs_pg2[] = {
+	{
+		.name = "cg2900-nfc",
+		.platform_data = &nfc_data,
+		.pdata_size = sizeof(nfc_data)
+	},
+	{
+		.name = "cg2900-antcmd",
+		.platform_data = &antcmd_data,
+		.pdata_size = sizeof(antcmd_data)
+	},
+	{
+		.name = "cg2900-antdat",
+		.platform_data = &antdat_data,
+		.pdata_size = sizeof(antdat_data)
+	},
+};
+
+static struct cg2900_user_data char_btcmd_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_BT_CMD,
+	},
+	.h4_channel = CHANNEL_BT_CMD,
+};
+static struct cg2900_user_data char_btacl_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_BT_ACL,
+	},
+	.h4_channel = CHANNEL_BT_ACL,
+};
+static struct cg2900_user_data char_btevt_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_BT_EVT,
+	},
+	.h4_channel = CHANNEL_BT_EVT,
+};
+static struct cg2900_user_data char_nfc_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_NFC,
+	},
+	.h4_channel = CHANNEL_NFC,
+};
+static struct cg2900_user_data char_antcmd_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_ANT_CMD,
+	},
+	.h4_channel = CHANNEL_ANT_CMD,
+};
+static struct cg2900_user_data char_antdat_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_ANT_DAT,
+	},
+	.h4_channel = CHANNEL_ANT_DAT,
+};
+static struct cg2900_user_data char_fm_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_FM_RADIO,
+	},
+	.h4_channel = CHANNEL_FM_RADIO,
+};
+static struct cg2900_user_data char_gnss_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_GNSS,
+	},
+	.h4_channel = CHANNEL_GNSS,
+};
+static struct cg2900_user_data char_debug_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_DEBUG,
+	},
+	.h4_channel = CHANNEL_DEBUG,
+};
+static struct cg2900_user_data char_ste_tools_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_STE_TOOLS,
+	},
+	.h4_channel = CHANNEL_STE_TOOLS,
+};
+static struct cg2900_user_data char_hci_logger_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_HCI_LOGGER,
+	},
+	.h4_channel = CHANNEL_HCI_LOGGER,
+	.chip_independent = true,
+	.write = cg2900_no_write,
+	.open = cg2900_hci_log_open,
+	.close = cg2900_hci_log_close,
+};
+static struct cg2900_user_data char_core_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_CORE,
+	},
+	.h4_channel = CHANNEL_CORE,
+	.write = cg2900_no_write,
+};
+static struct cg2900_user_data char_audio_vs_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_VS_AUDIO,
+	},
+	.h4_channel = CHANNEL_BT_CMD,
+	.is_audio = true,
+};
+static struct cg2900_user_data char_audio_fm_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_FM_AUDIO,
+	},
+	.h4_channel = CHANNEL_FM_RADIO,
+	.is_audio = true,
+};
+static struct cg2900_user_data char_hci_raw_data = {
+	.channel_data = {
+		.char_dev_name = CG2900_HCI_RAW,
+	},
+	.h4_channel = CHANNEL_HCI_RAW,
+	.open = cg2900_hci_raw_open,
+	.close = cg2900_hci_raw_close,
+};
+
+
+static struct mfd_cell cg2900_char_devs[] = {
+	{
+		.name = "cg2900-chardev",
+		.id = 0,
+		.platform_data = &char_btcmd_data,
+		.pdata_size = sizeof(char_btcmd_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 1,
+		.platform_data = &char_btacl_data,
+		.pdata_size = sizeof(char_btacl_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 2,
+		.platform_data = &char_btevt_data,
+		.pdata_size = sizeof(char_btevt_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 3,
+		.platform_data = &char_fm_data,
+		.pdata_size = sizeof(char_fm_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 4,
+		.platform_data = &char_gnss_data,
+		.pdata_size = sizeof(char_gnss_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 5,
+		.platform_data = &char_debug_data,
+		.pdata_size = sizeof(char_debug_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 6,
+		.platform_data = &char_ste_tools_data,
+		.pdata_size = sizeof(char_ste_tools_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 7,
+		.platform_data = &char_hci_logger_data,
+		.pdata_size = sizeof(char_hci_logger_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 8,
+		.platform_data = &char_core_data,
+		.pdata_size = sizeof(char_core_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 9,
+		.platform_data = &char_audio_vs_data,
+		.pdata_size = sizeof(char_audio_vs_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 10,
+		.platform_data = &char_audio_fm_data,
+		.pdata_size = sizeof(char_audio_fm_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 11,
+		.platform_data = &char_hci_raw_data,
+		.pdata_size = sizeof(char_hci_raw_data),
+	},
+};
+
+static struct mfd_cell cg2905_extra_char_devs[] = {
+	{
+		.name = "cg2900-chardev",
+		.id = 12,
+		.platform_data = &char_antcmd_data,
+		.pdata_size = sizeof(char_antcmd_data)
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 13,
+		.platform_data = &char_antdat_data,
+		.pdata_size = sizeof(char_antdat_data)
+	},
+};
+
+static struct mfd_cell cg2910_extra_char_devs[] = {
+	{
+		.name = "cg2900-chardev",
+		.id = 12,
+		.platform_data = &char_nfc_data,
+		.pdata_size = sizeof(char_nfc_data)
+	},
+};
+
+static struct mfd_cell cg2910_extra_char_devs_pg2[] = {
+	{
+		.name = "cg2900-chardev",
+		.id = 12,
+		.platform_data = &char_nfc_data,
+		.pdata_size = sizeof(char_nfc_data)
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 13,
+		.platform_data = &char_antcmd_data,
+		.pdata_size = sizeof(char_antcmd_data)
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 14,
+		.platform_data = &char_antdat_data,
+		.pdata_size = sizeof(char_antdat_data)
+	},
+};
+
+/**
+ * set_plat_data() - Initializes data for an MFD cell.
+ * @cell:	MFD cell.
+ * @dev:	Current chip.
+ *
+ * Sets each callback to default function unless already set.
+ */
+static void set_plat_data(struct mfd_cell *cell, struct cg2900_chip_dev *dev)
+{
+	struct cg2900_user_data *pf_data = cell->platform_data;
+
+	if (!pf_data->open)
+		pf_data->open = cg2900_open;
+	if (!pf_data->close)
+		pf_data->close = cg2900_close;
+	if (!pf_data->reset)
+		pf_data->reset = cg2900_reset;
+	if (!pf_data->alloc_skb)
+		pf_data->alloc_skb = cg2900_alloc_skb;
+	if (!pf_data->write)
+		pf_data->write = cg2900_write;
+	if (!pf_data->get_local_revision)
+		pf_data->get_local_revision = cg2900_get_local_revision;
+
+	cg2900_set_prv(pf_data, dev);
+}
+
+/**
+ * fetch_firmware_files() - Do a request_firmware for ssf/ptc files.
+ * @dev:	Chip info structure.
+ *
+ * Returns:
+ *   system wide error.
+ */
+static int fetch_firmware_files(struct cg2900_chip_dev *dev,
+		struct cg2900_chip_info *info)
+{
+	int filename_size_ptc = strlen("CG29XX_XXXX_patch.fw");
+	int filename_size_ssf = strlen("CG29XX_XXXX_settings.fw");
+	int err;
+
+	/*
+	 * Create the patch file name from HCI revision and sub_version.
+	 * filename_size_ptc does not include terminating NULL character
+	 * so add 1.
+	 */
+	err = snprintf(info->patch_file_name, filename_size_ptc + 1,
+			"CG29XX_%04X_patch.fw", dev->chip.hci_revision);
+	if (err == filename_size_ptc) {
+		dev_dbg(info->dev, "Downloading patch file %s\n",
+				info->patch_file_name);
+	} else {
+		dev_err(info->dev, "Patch file name failed! err=%d\n", err);
+		goto error_handling;
+	}
+
+	/* OK. Now it is time to download the patches */
+	err = request_firmware(&(info->file_info.fw_file_ptc),
+			info->patch_file_name,
+			dev->dev);
+	if (err < 0) {
+		dev_err(info->dev, "Couldn't get patch file "\
+				"(%d)\n", err);
+		goto error_handling;
+	}
+
+	/*
+	 * Create the settings file name from HCI revision and sub_version.
+	 * filename_size_ssf does not include terminating NULL character
+	 * so add 1.
+	 */
+	err = snprintf(info->settings_file_name, filename_size_ssf + 1,
+			"CG29XX_%04X_settings.fw", dev->chip.hci_revision);
+	if (err == filename_size_ssf) {
+		dev_dbg(info->dev, "Downloading settings file %s\n",
+				info->settings_file_name);
+	} else {
+		dev_err(info->dev, "Settings file name failed! err=%d\n", err);
+		goto error_handling;
+	}
+
+	/* Retrieve the settings file */
+	err = request_firmware(&info->file_info.fw_file_ssf,
+			info->settings_file_name,
+			info->dev);
+	if (err) {
+		dev_err(info->dev, "Couldn't get settings file "\
+				"(%d)\n", err);
+		goto error_handling;
+	}
+
+	return 0;
+
+error_handling:
+	if (info->file_info.fw_file_ptc) {
+		release_firmware(info->file_info.fw_file_ptc);
+		info->file_info.fw_file_ptc = NULL;
+	}
+
+	if (info->file_info.fw_file_ssf) {
+		release_firmware(info->file_info.fw_file_ssf);
+		info->file_info.fw_file_ssf = NULL;
+	}
+
+	return err;
+}
+
+/**
+ * check_chip_support() - Checks if connected chip is handled by this driver.
+ * @dev:	Chip info structure.
+ *
+ * First check if chip is supported by this driver. If that is the case fill in
+ * the callbacks in @dev and initiate internal variables. Finally create MFD
+ * devices for all supported H4 channels. When finished power off the chip.
+ *
+ * Returns:
+ *   true if chip is handled by this driver.
+ *   false otherwise.
+ */
+static bool check_chip_support(struct cg2900_chip_dev *dev)
+{
+	struct cg2900_platform_data *pf_data;
+	struct cg2900_chip_info *info;
+	int i;
+	int err;
+
+	dev_dbg(dev->dev, "check_chip_support\n");
+
+	/*
+	 * Check if this is a CG29XX revision.
+	 * We do not care about the sub-version at the moment. Change this if
+	 * necessary.
+	 */
+	if (dev->chip.manufacturer != CG2900_SUPP_MANUFACTURER
+		|| !(check_chip_revision_support(dev->chip.hci_revision))) {
+		dev_err(dev->dev, "Unsupported Chip revision:0x%x\n",
+				dev->chip.hci_revision);
+		return false;
+	}
+
+	/* Store needed data */
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev->dev, "Couldn't allocate info struct\n");
+		return false;
+	}
+
+	/* Initialize all variables */
+	skb_queue_head_init(&info->tx_queue_bt);
+	skb_queue_head_init(&info->tx_queue_fm);
+
+	INIT_LIST_HEAD(&info->open_channels);
+
+	spin_lock_init(&info->tx_bt_lock);
+	spin_lock_init(&info->tx_fm_lock);
+	spin_lock_init(&info->rw_lock);
+
+	info->tx_nr_pkts_allowed_bt = 1;
+	info->audio_bt_cmd_op = CG2900_BT_OPCODE_NONE;
+	info->audio_fm_cmd_id = CG2900_FM_CMD_NONE;
+	info->hci_fm_cmd_func = CG2900_FM_CMD_PARAM_NONE;
+	info->fm_radio_mode = FM_RADIO_MODE_IDLE;
+	info->chip_dev = dev;
+	info->dev = dev->dev;
+
+	info->wq = create_singlethread_workqueue(WQ_NAME);
+	if (!info->wq) {
+		dev_err(dev->dev, "Could not create workqueue\n");
+		goto err_handling_free_info;
+	}
+
+	info->patch_file_name = kzalloc(NAME_MAX + 1, GFP_ATOMIC);
+	if (!info->patch_file_name) {
+		dev_err(dev->dev,
+			"Couldn't allocate name buffer for patch file\n");
+		goto err_handling_destroy_wq;
+	}
+
+	info->settings_file_name = kzalloc(NAME_MAX + 1, GFP_ATOMIC);
+	if (!info->settings_file_name) {
+		dev_err(dev->dev,
+			"Couldn't allocate name buffers settings file\n");
+		goto err_handling_free_patch_name;
+	}
+
+	err = fetch_firmware_files(dev, info);
+	if (err) {
+		dev_err(dev->dev,
+				"Couldn't fetch firmware files\n");
+		goto err_handling_free_patch_name;
+	}
+
+	info->selftest_work.data = info;
+	INIT_DELAYED_WORK(&info->selftest_work.work,
+			  work_send_read_selftest_cmd);
+
+	if (use_device_channel_for_vs_cmd(dev->chip.hci_revision))
+		info->h4_channel_for_device = CHANNEL_DEV_MGMT;
+	else
+		info->h4_channel_for_device = CHANNEL_BT_CMD;
+
+	dev->c_data = info;
+	/* Set the callbacks */
+	dev->c_cb.data_from_chip = data_from_chip;
+	dev->c_cb.chip_removed = chip_removed;
+
+	mutex_lock(&main_info->man_mutex);
+
+	pf_data = dev_get_platdata(dev->dev);
+	btcmd_data.channel_data.bt_bus = pf_data->bus;
+	btacl_data.channel_data.bt_bus = pf_data->bus;
+	btevt_data.channel_data.bt_bus = pf_data->bus;
+
+	if (use_device_channel_for_vs_cmd(dev->chip.hci_revision)) {
+		audio_vs_data.h4_channel = CHANNEL_DEV_MGMT_AUDIO;
+		char_audio_vs_data.h4_channel = CHANNEL_DEV_MGMT_AUDIO;
+	}
+
+	/* Set the Platform data based on supported chip */
+	for (i = 0; i < ARRAY_SIZE(cg2900_devs); i++)
+		set_plat_data(&cg2900_devs[i], dev);
+	for (i = 0; i < ARRAY_SIZE(cg2900_char_devs); i++)
+		set_plat_data(&cg2900_char_devs[i], dev);
+	info->mfd_size = ARRAY_SIZE(cg2900_devs);
+	info->mfd_char_size = ARRAY_SIZE(cg2900_char_devs);
+
+	if (dev->chip.hci_revision == CG2905_PG2_REV) {
+		for (i = 0; i < ARRAY_SIZE(cg2905_extra_devs); i++)
+			set_plat_data(&cg2905_extra_devs[i], dev);
+		for (i = 0; i < ARRAY_SIZE(cg2905_extra_char_devs); i++)
+			set_plat_data(&cg2905_extra_char_devs[i], dev);
+		info->mfd_extra_size = ARRAY_SIZE(cg2905_extra_devs);
+		info->mfd_extra_char_size = ARRAY_SIZE(cg2905_extra_char_devs);
+	} else if (dev->chip.hci_revision == CG2910_PG1_REV) {
+		for (i = 0; i < ARRAY_SIZE(cg2910_extra_devs); i++)
+			set_plat_data(&cg2910_extra_devs[i], dev);
+		for (i = 0; i < ARRAY_SIZE(cg2910_extra_char_devs); i++)
+			set_plat_data(&cg2910_extra_char_devs[i], dev);
+		info->mfd_extra_size = ARRAY_SIZE(cg2910_extra_devs);
+		info->mfd_extra_char_size = ARRAY_SIZE(cg2910_extra_char_devs);
+	} else if (dev->chip.hci_revision == CG2910_PG2_REV) {
+		for (i = 0; i < ARRAY_SIZE(cg2910_extra_devs_pg2); i++)
+			set_plat_data(&cg2910_extra_devs_pg2[i], dev);
+		for (i = 0; i < ARRAY_SIZE(cg2910_extra_char_devs_pg2); i++)
+			set_plat_data(&cg2910_extra_char_devs_pg2[i], dev);
+		info->mfd_extra_size = ARRAY_SIZE(cg2910_extra_devs_pg2);
+		info->mfd_extra_char_size =
+				ARRAY_SIZE(cg2910_extra_char_devs_pg2);
+	}
+
+
+	info->startup = true;
+
+	/*
+	 * The devices will be registered when chip has been powered down, i.e.
+	 * when the system startup is ready.
+	 */
+
+	mutex_unlock(&main_info->man_mutex);
+
+	dev_info(dev->dev, "Chip supported by the CG2900 driver\n");
+
+	/* Finish by turning off the chip */
+	cg2900_create_work_item(info->wq, work_power_off_chip, dev);
+
+	return true;
+
+err_handling_free_patch_name:
+	kfree(info->patch_file_name);
+err_handling_destroy_wq:
+	destroy_workqueue(info->wq);
+err_handling_free_info:
+	kfree(info);
+	return false;
+}
+
+static struct cg2900_id_callbacks chip_support_callbacks = {
+	.check_chip_support = check_chip_support,
+};
+
+/**
+ * cg2900_chip_probe() - Initialize CG2900 chip handler resources.
+ * @pdev:	Platform device.
+ *
+ * This function initializes the CG2900 driver, then registers to
+ * the CG2900 Core.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM for failed alloc or structure creation.
+ *   Error codes generated by cg2900_register_chip_driver.
+ */
+static int __devinit cg2900_chip_probe(struct platform_device *pdev)
+{
+	int err;
+
+	dev_dbg(&pdev->dev, "cg2900_chip_probe\n");
+
+	main_info = kzalloc(sizeof(*main_info), GFP_ATOMIC);
+	if (!main_info) {
+		dev_err(&pdev->dev, "Couldn't allocate main_info\n");
+		return -ENOMEM;
+	}
+
+	main_info->dev = &pdev->dev;
+	mutex_init(&main_info->man_mutex);
+
+	err = cg2900_register_chip_driver(&chip_support_callbacks);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Couldn't register chip driver (%d)\n", err);
+		goto error_handling;
+	}
+
+	dev_info(&pdev->dev, "CG2900 chip driver started\n");
+
+	return 0;
+
+error_handling:
+	mutex_destroy(&main_info->man_mutex);
+	kfree(main_info);
+	main_info = NULL;
+	return err;
+}
+
+/**
+ * cg2900_chip_remove() - Release CG2900 chip handler resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success (always success).
+ */
+static int __devexit cg2900_chip_remove(struct platform_device *pdev)
+{
+	dev_info(&pdev->dev, "CG2900 chip driver removed\n");
+
+	cg2900_deregister_chip_driver(&chip_support_callbacks);
+
+	if (!main_info)
+		return 0;
+	mutex_destroy(&main_info->man_mutex);
+	kfree(main_info);
+	main_info = NULL;
+	return 0;
+}
+
+static struct platform_driver cg2900_chip_driver = {
+	.driver = {
+		.name	= "cg2900-chip",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_chip_probe,
+	.remove	= __devexit_p(cg2900_chip_remove),
+};
+
+/**
+ * cg2900_chip_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init cg2900_chip_init(void)
+{
+	pr_debug("cg2900_chip_init");
+	return platform_driver_register(&cg2900_chip_driver);
+}
+
+/**
+ * cg2900_chip_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit cg2900_chip_exit(void)
+{
+	pr_debug("cg2900_chip_exit");
+	platform_driver_unregister(&cg2900_chip_driver);
+}
+
+module_init(cg2900_chip_init);
+module_exit(cg2900_chip_exit);
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux CG2900 Connectivity Device Driver");
diff --git a/drivers/staging/cg2900/mfd/cg2900_chip.h b/drivers/staging/cg2900/mfd/cg2900_chip.h
new file mode 100644
index 0000000..81f7da4
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_chip.h
@@ -0,0 +1,608 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * Hemant Gupta (hemant.gupta@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+
+#ifndef _CG2900_CHIP_H_
+#define _CG2900_CHIP_H_
+
+/*
+ *	Utility
+ */
+
+static inline void set_low_nibble(__u8 *var, __u8 value)
+{
+	*var = (*var & 0xf0) | (value & 0x0f);
+}
+
+static inline void set_high_nibble(__u8 *var, __u8 value)
+{
+	*var = (*var & 0x0f) | (value << 4);
+}
+
+static inline void store_bit(__u8 *var, size_t bit, __u8 value)
+{
+	*var = (*var & ~(1u << bit)) | (value << bit);
+}
+
+/*
+ *	General chip defines
+ */
+
+/* Supported chips */
+#define CG2900_SUPP_MANUFACTURER			0x30
+
+/*
+ *	Bluetooth
+ */
+
+#define BT_SIZE_OF_HDR				(sizeof(__le16) + sizeof(__u8))
+#define BT_PARAM_LEN(__pkt_len)			(__pkt_len - BT_SIZE_OF_HDR)
+
+struct bt_cmd_cmpl_event {
+	__u8	eventcode;
+	__u8	plen;
+	__u8	n_commands;
+	__le16	opcode;
+	/*
+	 * According to BT-specification what follows is "parameters"
+	 * and unique to every command, but all commands start the
+	 * parameters with the status field so include it here for
+	 * convenience
+	 */
+	__u8	status;
+	__u8	data[];
+} __packed;
+
+/* BT VS Store In FS command */
+#define CG2900_BT_OP_VS_STORE_IN_FS			0xFC22
+struct bt_vs_store_in_fs_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	user_id;
+	__u8	len;
+	__u8	data[];
+} __packed;
+
+#define CG2900_VS_STORE_IN_FS_USR_ID_BD_ADDR		0xFE
+
+#define HCI_EV_VENDOR_SPECIFIC					0xFF
+#define CG2900_EV_VS_WRITE_FILE_BLOCK_COMPLETE	0x60
+/* BT VS Event */
+struct bt_vs_evt {
+	__u8	evt_id;
+	__u8	data[];
+} __packed;
+
+/* BT VS Write File Block Event */
+struct bt_vs_write_file_block_evt {
+	__u8	status;
+	__u8	file_blk_id;
+} __packed;
+
+/* BT VS Write File Block command */
+#define CG2900_BT_OP_VS_WRITE_FILE_BLOCK		0xFC2E
+struct bt_vs_write_file_block_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	id;
+	__u8	data[];
+} __packed;
+
+#define CG2900_BT_DISABLE				0x00
+#define CG2900_BT_ENABLE				0x01
+
+/* BT VS BT Enable command */
+#define CG2900_BT_OP_VS_BT_ENABLE			0xFF10
+struct bt_vs_bt_enable_cmd {
+	__le16	op_code;
+	u8	plen;
+	u8	enable;
+} __packed;
+
+/* BT VS SetBaudRate command */
+#define CG2900_BT_OP_VS_SET_BAUD_RATE			0xFC09
+struct bt_vs_set_baud_rate_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	baud_rate;
+} __packed;
+
+#define CG2900_BT_SELFTEST_SUCCESSFUL			0x00
+#define CG2900_BT_SELFTEST_FAILED			0x01
+#define CG2900_BT_SELFTEST_NOT_COMPLETED		0x02
+
+/* BT VS ReadSelfTestsResult command & event */
+#define CG2900_BT_OP_VS_READ_SELTESTS_RESULT		0xFC10
+struct bt_vs_read_selftests_result_evt {
+	__u8	status;
+	__u8	result;
+} __packed;
+
+/* Bluetooth Vendor Specific Opcodes */
+#define CG2900_BT_OP_VS_POWER_SWITCH_OFF		0xFD40
+#define CG2900_BT_OP_VS_SYSTEM_RESET			0xFF12
+
+#define CG2900_BT_OPCODE_NONE				0xFFFF
+
+/*
+ *	Common multimedia
+ */
+
+#define CG2900_CODEC_TYPE_NONE				0x00
+#define CG2900_CODEC_TYPE_SBC				0x01
+
+#define CG2900_PCM_MODE_SLAVE				0x00
+#define CG2900_PCM_MODE_MASTER				0x01
+
+#define CG2900_I2S_MODE_MASTER				0x00
+#define CG2900_I2S_MODE_SLAVE				0x01
+
+/*
+ *	CG2900 PG1 multimedia API
+ */
+
+#define CG2900_BT_VP_TYPE_PCM				0x00
+#define CG2900_BT_VP_TYPE_I2S				0x01
+#define CG2900_BT_VP_TYPE_SLIMBUS			0x02
+#define CG2900_BT_VP_TYPE_FM				0x03
+#define CG2900_BT_VP_TYPE_BT_SCO			0x04
+#define CG2900_BT_VP_TYPE_BT_A2DP			0x05
+#define CG2900_BT_VP_TYPE_ANALOG			0x07
+
+#define CG2900_BT_VS_SET_HARDWARE_CONFIG		0xFD54
+/* These don't have the same length, so a union won't work */
+struct bt_vs_set_hw_cfg_cmd_pcm {
+	__le16	opcode;
+	__u8	plen;
+	__u8	vp_type;
+	__u8	port_id;
+	__u8	mode_dir; /* NB: mode is in bit 1 (not 0) */
+	__u8	bit_clock;
+	__le16	frame_len;
+} __packed;
+#define HWCONFIG_PCM_SET_MODE(pcfg, mode)		\
+	set_low_nibble(&(pcfg)->mode_dir, (mode) << 1)
+#define HWCONFIG_PCM_SET_DIR(pcfg, idx, dir)		\
+	store_bit(&(pcfg)->mode_dir, (idx) + 4, (dir))
+
+struct bt_vs_set_hw_cfg_cmd_i2s {
+	__le16	opcode;
+	__u8	plen;
+	__u8	vp_type;
+	__u8	port_id;
+	__u8	half_period;
+	__u8	master_slave;
+} __packed;
+
+/* Max length for allocating */
+#define CG2900_BT_LEN_VS_SET_HARDWARE_CONFIG	\
+	(sizeof(struct bt_vs_set_hw_cfg_cmd_pcm))
+
+#define CG2900_BT_VS_SET_SESSION_CONFIG			0xFD55
+struct session_config_vport {
+	__u8	type;
+	union {
+		struct {
+			__le16	acl_handle;
+			__u8	reserved[10];
+		} sco;
+		struct {
+			__u8	reserved[12];
+		} fm;
+		struct {
+			__u8	index;
+			__u8	slots_used;
+			__u8	slot_start[4];
+			__u8	reserved[6];
+		} pcm;
+		struct {
+			__u8	index;
+			__u8	channel;
+			__u8	reserved[10];
+		} i2s;
+	};
+} __packed;
+#define SESSIONCFG_PCM_SET_USED(port, idx, use)		\
+	store_bit(&(port).pcm.slots_used, (idx), (use))
+
+struct session_config_stream {
+	__u8	media_type;
+	__u8	csel_srate;
+	__u8	codec_type;
+	__u8	codec_mode;
+	__u8	codec_params[3];
+	struct session_config_vport inport;
+	struct session_config_vport outport;
+} __packed;
+#define SESSIONCFG_SET_CHANNELS(pcfg, chnl)		\
+	set_low_nibble(&(pcfg)->csel_srate, (chnl))
+#define SESSIONCFG_I2S_SET_SRATE(pcfg, rate)		\
+	set_high_nibble(&(pcfg)->csel_srate, (rate))
+
+struct bt_vs_session_config_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	n_streams; /* we only support one here */
+	struct session_config_stream stream;
+} __packed;
+
+#define CG2900_BT_SESSION_MEDIA_TYPE_AUDIO		0x00
+
+#define CG2900_BT_SESSION_RATE_8K			0x01
+#define CG2900_BT_SESSION_RATE_16K			0x02
+#define CG2900_BT_SESSION_RATE_44_1K			0x04
+#define CG2900_BT_SESSION_RATE_48K			0x05
+
+#define CG2900_BT_MEDIA_CONFIG_MONO			0x00
+#define CG2900_BT_MEDIA_CONFIG_STEREO			0x01
+#define CG2900_BT_MEDIA_CONFIG_JOINT_STEREO		0x02
+#define CG2900_BT_MEDIA_CONFIG_DUAL_CHANNEL		0x03
+
+#define CG2900_BT_SESSION_I2S_INDEX_I2S			0x00
+#define CG2900_BT_SESSION_PCM_INDEX_PCM_I2S		0x00
+
+
+#define CG2900_BT_VS_SESSION_CTRL			0xFD57
+struct bt_vs_session_ctrl_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	id;
+	__u8	control;
+} __packed;
+
+#define CG2900_BT_SESSION_START				0x00
+#define CG2900_BT_SESSION_STOP				0x01
+#define CG2900_BT_SESSION_PAUSE				0x02
+#define CG2900_BT_SESSION_RESUME			0x03
+
+#define CG2900_BT_VS_RESET_SESSION_CONFIG		0xFD56
+struct bt_vs_reset_session_cfg_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	id;
+} __packed;
+
+/*
+ *	CG2900 PG2 multimedia API
+ */
+
+#define CG2900_MC_PORT_PCM_I2S				0x00
+#define CG2900_MC_PORT_I2S				0x01
+#define CG2900_MC_PORT_BT_SCO				0x04
+#define CG2900_MC_PORT_FM_RX_0				0x07
+#define CG2900_MC_PORT_FM_RX_1				0x08
+#define CG2900_MC_PORT_FM_TX				0x09
+
+#define CG2900_MC_VS_PORT_CONFIG			0xFD64
+struct mc_vs_port_cfg_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	type;
+	/*
+	 * one of the following configuration structs should follow, but they
+	 * have different lengths so a union will not work
+	 */
+} __packed;
+
+struct mc_vs_port_cfg_pcm_i2s {
+	__u8 role_dir;
+	__u8 sco_a2dp_slots_used;
+	__u8 fm_slots_used;
+	__u8 ring_slots_used;
+	__u8 slot_start[4];
+	__u8 ratio_mode;
+	__u8 frame_len;
+	__u8 bitclk_srate;
+} __packed;
+#define PORTCFG_PCM_SET_ROLE(cfg, role)			\
+	set_low_nibble(&(cfg).role_dir, (role))
+#define PORTCFG_PCM_SET_DIR(cfg, idx, dir)		\
+	store_bit(&(cfg).role_dir, (idx) + 4, (dir))
+static inline void portcfg_pcm_set_sco_used(struct mc_vs_port_cfg_pcm_i2s *cfg,
+					    size_t index, __u8 use)
+{
+	if (use) {
+		/* clear corresponding slot in all cases */
+		cfg->sco_a2dp_slots_used &= ~(0x11 << index);
+		cfg->fm_slots_used &= ~(0x11 << index);
+		cfg->ring_slots_used &= ~(0x11 << index);
+		/* set for sco */
+		cfg->sco_a2dp_slots_used |= (1u << index);
+	} else {
+		/* only clear for sco */
+		cfg->sco_a2dp_slots_used &= ~(1u << index);
+	}
+}
+#define PORTCFG_PCM_SET_SCO_USED(cfg, idx, use)		\
+	portcfg_pcm_set_sco_used(&cfg, idx, use)
+#define PORTCFG_PCM_SET_RATIO(cfg, r)			\
+	set_low_nibble(&(cfg).ratio_mode, (r))
+#define PORTCFG_PCM_SET_MODE(cfg, mode)			\
+	set_high_nibble(&(cfg).ratio_mode, (mode))
+#define PORTCFG_PCM_SET_BITCLK(cfg, clk)		\
+	set_low_nibble(&(cfg).bitclk_srate, (clk))
+#define PORTCFG_PCM_SET_SRATE(cfg, rate)		\
+	set_high_nibble(&(cfg).bitclk_srate, (rate))
+
+#define CG2900_MC_PCM_SAMPLE_RATE_8			1
+#define CG2900_MC_PCM_SAMPLE_RATE_16			2
+#define CG2900_MC_PCM_SAMPLE_RATE_44_1			4
+#define CG2900_MC_PCM_SAMPLE_RATE_48			6
+
+struct mc_vs_port_cfg_i2s {
+	__u8 role_hper;
+	__u8 csel_srate;
+	__u8 wordlen;
+};
+#define PORTCFG_I2S_SET_ROLE(cfg, role)			\
+	set_low_nibble(&(cfg).role_hper, (role))
+#define PORTCFG_I2S_SET_HALFPERIOD(cfg, hper)		\
+	set_high_nibble(&(cfg).role_hper, (hper))
+#define PORTCFG_I2S_SET_CHANNELS(cfg, chnl)		\
+	set_low_nibble(&(cfg).csel_srate, (chnl))
+#define PORTCFG_I2S_SET_SRATE(cfg, rate)		\
+	set_high_nibble(&(cfg).csel_srate, (rate))
+#define PORTCFG_I2S_SET_WORDLEN(cfg, len)		\
+	set_low_nibble(&(cfg).wordlen, len)
+
+#define CG2900_MC_I2S_RIGHT_CHANNEL			1
+#define CG2900_MC_I2S_LEFT_CHANNEL			2
+#define CG2900_MC_I2S_BOTH_CHANNELS			3
+
+#define CG2900_MC_I2S_SAMPLE_RATE_8			0
+#define CG2900_MC_I2S_SAMPLE_RATE_16			1
+#define CG2900_MC_I2S_SAMPLE_RATE_44_1			2
+#define CG2900_MC_I2S_SAMPLE_RATE_48			4
+
+#define CG2900_MC_I2S_WORD_16				1
+#define CG2900_MC_I2S_WORD_32				3
+
+struct mc_vs_port_cfg_fm {
+	__u8 srate; /* NB: value goes in _upper_ nibble! */
+};
+#define PORTCFG_FM_SET_SRATE(cfg, rate)		\
+	set_high_nibble(&(cfg).srate, (rate))
+
+struct mc_vs_port_cfg_sco {
+	__le16	acl_id;
+	__u8	wbs_codec;
+} __packed;
+#define PORTCFG_SCO_SET_CODEC(cfg, codec)	\
+	set_high_nibble(&(cfg).wbs_codec, (codec))
+
+#define CG2900_MC_VS_CREATE_STREAM			0xFD66
+struct mc_vs_create_stream_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	id;
+	__u8	inport;
+	__u8	outport;
+	__u8	order; /* NB: not used by chip */
+} __packed;
+
+#define CG2900_MC_VS_DELETE_STREAM			0xFD67
+struct mc_vs_delete_stream_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	stream;
+} __packed;
+
+#define CG2900_MC_VS_STREAM_CONTROL			0xFD68
+struct mc_vs_stream_ctrl_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	command;
+	__u8	n_streams;
+	__u8	stream[];
+} __packed;
+
+#define CG2900_MC_STREAM_START				0x00
+#define CG2900_MC_STREAM_STOP				0x01
+#define CG2900_MC_STREAM_STOP_FLUSH			0x02
+
+#define CG2900_MC_VS_SET_FM_START_MODE			0xFD69
+
+/*
+ *	FM
+ */
+
+/* FM legacy command packet */
+struct fm_leg_cmd {
+	__u8	length;
+	__u8	opcode;
+	__u8	read_write;
+	__u8	fm_function;
+	union { /* Payload varies with function */
+		__le16	irqmask;
+		struct fm_leg_fm_cmd {
+			__le16	head;
+			__le16	data[];
+		} fm_cmd;
+	};
+} __packed;
+
+/* FM legacy command complete packet */
+struct fm_leg_cmd_cmpl {
+	__u8	param_length;
+	__u8	status;
+	__u8	opcode;
+	__u8	read_write;
+	__u8	cmd_status;
+	__u8	fm_function;
+	__le16	response_head;
+	__le16	data[];
+} __packed;
+
+/* FM legacy interrupt packet, PG2 style */
+struct fm_leg_irq_v2 {
+	__u8	param_length;
+	__u8	status;
+	__u8	opcode;
+	__u8	event_type;
+	__u8	event_id;
+	__le16	irq;
+} __packed;
+
+/* FM legacy interrupt packet, PG1 style */
+struct fm_leg_irq_v1 {
+	__u8	param_length;
+	__u8	opcode;
+	__u8	event_id;
+	__le16	irq;
+} __packed;
+
+union fm_leg_evt_or_irq {
+	__u8			param_length;
+	struct fm_leg_cmd_cmpl	evt;
+	struct fm_leg_irq_v2	irq_v2;
+	struct fm_leg_irq_v1	irq_v1;
+} __packed;
+
+/* FM Opcode generic*/
+#define CG2900_FM_GEN_ID_LEGACY				0xFE
+
+/* FM event*/
+#define CG2900_FM_EVENT_UNKNOWN				0
+#define CG2900_FM_EVENT_CMD_COMPLETE			1
+#define CG2900_FM_EVENT_INTERRUPT			2
+
+/* FM do-command identifiers. */
+#define CG2900_FM_DO_AIP_FADE_START			0x0046
+#define CG2900_FM_DO_AUP_BT_FADE_START			0x01C2
+#define CG2900_FM_DO_AUP_EXT_FADE_START			0x0102
+#define CG2900_FM_DO_AUP_FADE_START			0x00A2
+#define CG2900_FM_DO_FMR_SETANTENNA			0x0663
+#define CG2900_FM_DO_FMR_SP_AFSWITCH_START		0x04A3
+#define CG2900_FM_DO_FMR_SP_AFUPDATE_START		0x0463
+#define CG2900_FM_DO_FMR_SP_BLOCKSCAN_START		0x0683
+#define CG2900_FM_DO_FMR_SP_PRESETPI_START		0x0443
+#define CG2900_FM_DO_FMR_SP_SCAN_START			0x0403
+#define CG2900_FM_DO_FMR_SP_SEARCH_START		0x03E3
+#define CG2900_FM_DO_FMR_SP_SEARCHPI_START		0x0703
+#define CG2900_FM_DO_FMR_SP_TUNE_SETCHANNEL		0x03C3
+#define CG2900_FM_DO_FMR_SP_TUNE_STEPCHANNEL		0x04C3
+#define CG2900_FM_DO_FMT_PA_SETCTRL			0x01A4
+#define CG2900_FM_DO_FMT_PA_SETMODE			0x01E4
+#define CG2900_FM_DO_FMT_SP_TUNE_SETCHANNEL		0x0064
+#define CG2900_FM_DO_GEN_ANTENNACHECK_START		0x02A1
+#define CG2900_FM_DO_GEN_GOTOMODE			0x0041
+#define CG2900_FM_DO_GEN_POWERSUPPLY_SETMODE		0x0221
+#define CG2900_FM_DO_GEN_SELECTREFERENCECLOCK		0x0201
+#define CG2900_FM_DO_GEN_SETPROCESSINGCLOCK		0x0241
+#define CG2900_FM_DO_GEN_SETREFERENCECLOCKPLL		0x01A1
+#define CG2900_FM_DO_TST_TX_RAMP_START			0x0147
+#define CG2900_FM_CMD_NONE				0xFFFF
+#define CG2900_FM_CMD_ID_GEN_GOTO_POWER_DOWN		0x0081
+#define CG2900_FM_CMD_ID_GEN_GOTO_STANDBY		0x0061
+
+/* FM Command IDs */
+#define CG2900_FM_CMD_ID_AUP_EXT_SET_MODE		0x0162
+#define CG2900_FM_CMD_ID_AUP_EXT_SET_CTRL		0x0182
+#define CG2900_FM_CMD_ID_AIP_SET_MODE			0x01C6
+#define CG2900_FM_CMD_ID_AIP_BT_SET_CTRL		0x01A6
+#define CG2900_FM_CMD_ID_AIP_BT_SET_MODE		0x01E6
+
+/* FM Command Parameters. */
+#define CG2900_FM_CMD_PARAM_ENABLE			0x00
+#define CG2900_FM_CMD_PARAM_DISABLE			0x01
+#define CG2900_FM_CMD_PARAM_RESET			0x02
+#define CG2900_FM_CMD_PARAM_WRITECOMMAND		0x10
+#define CG2900_FM_CMD_PARAM_SET_INT_MASK_ALL		0x20
+#define CG2900_FM_CMD_PARAM_GET_INT_MASK_ALL		0x21
+#define CG2900_FM_CMD_PARAM_SET_INT_MASK		0x22
+#define CG2900_FM_CMD_PARAM_GET_INT_MASK		0x23
+#define CG2900_FM_CMD_PARAM_FM_FW_DOWNLOAD		0x30
+#define CG2900_FM_CMD_PARAM_NONE			0xFF
+
+/* FM Legacy Command Parameters */
+#define CG2900_FM_CMD_LEG_PARAM_WRITE			0x00
+#define CG2900_FM_CMD_LEG_PARAM_IRQ			0x01
+
+/* FM Command Status. */
+#define CG2900_FM_CMD_STATUS_COMMAND_SUCCEEDED		0x00
+#define CG2900_FM_CMD_STATUS_HW_FAILURE			0x03
+#define CG2900_FM_CMD_STATUS_INVALID_PARAMS		0x12
+#define CG2900_FM_CMD_STATUS_UNINITILIZED		0x15
+#define CG2900_FM_CMD_STATUS_UNSPECIFIED_ERROR		0x1F
+#define CG2900_FM_CMD_STATUS_COMMAND_DISALLOWED		0x0C
+#define CG2900_FM_CMD_STATUS_FW_WRONG_SEQUENCE_NR	0xF1
+#define CG2900_FM_CMD_STATUS_FW_UNKNOWN_FILE		0xF2
+#define CG2900_FM_CMD_STATUS_FW_FILE_VER_MISMATCH	0xF3
+
+/* FM Interrupts. */
+#define CG2900_FM_IRPT_FIQ				0x0000
+#define CG2900_FM_IRPT_OPERATION_SUCCEEDED		0x0001
+#define CG2900_FM_IRPT_OPERATION_FAILED			0x0002
+#define CG2900_FM_IRPT_BUFFER_FULL			0x0008
+#define CG2900_FM_IRPT_BUFFER_EMPTY			0x0008
+#define CG2900_FM_IRPT_SIGNAL_QUALITY_LOW		0x0010
+#define CG2900_FM_IRPT_MUTE_STATUS_CHANGED		0x0010
+#define CG2900_FM_IRPT_MONO_STEREO_TRANSITION		0x0020
+#define CG2900_FM_IRPT_OVER_MODULATION			0x0020
+#define CG2900_FM_IRPT_RDS_SYNC_FOUND			0x0040
+#define CG2900_FM_IRPT_INPUT_OVERDRIVE			0x0040
+#define CG2900_FM_IRPT_RDS_SYNC_LOST			0x0080
+#define CG2900_FM_IRPT_PI_CODE_CHANGED			0x0100
+#define CG2900_FM_IRPT_REQUEST_BLOCK_AVALIBLE		0x0200
+#define CG2900_FM_IRPT_BUFFER_CLEARED			0x2000
+#define CG2900_FM_IRPT_WARM_BOOT_READY			0x4000
+#define CG2900_FM_IRPT_COLD_BOOT_READY			0x8000
+
+/* FM Legacy Function Command Parameters */
+
+/* AUP_EXT_SetMode Output enum */
+#define CG2900_FM_CMD_AUP_EXT_SET_MODE_DISABLED		0x0000
+#define CG2900_FM_CMD_AUP_EXT_SET_MODE_I2S		0x0001
+#define CG2900_FM_CMD_AUP_EXT_SET_MODE_PARALLEL		0x0002
+
+/* SetControl Conversion enum */
+#define CG2900_FM_CMD_SET_CTRL_CONV_UP			0x0000
+#define CG2900_FM_CMD_SET_CTRL_CONV_DOWN		0x0001
+
+/* AIP_SetMode Input enum */
+#define CG2900_FM_CMD_AIP_SET_MODE_INPUT_ANA		0x0000
+#define CG2900_FM_CMD_AIP_SET_MODE_INPUT_DIG		0x0001
+
+/* AIP_BT_SetMode Input enum */
+#define CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_RESERVED	0x0000
+#define CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_I2S		0x0001
+#define CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_PAR		0x0002
+#define CG2900_FM_CMD_AIP_BT_SET_MODE_INPUT_FIFO	0x0003
+
+/* FM Parameter Lengths = FM command length - length field (1 byte) */
+#define CG2900_FM_CMD_PARAM_LEN(len) (len - 1)
+
+/*
+ * FM Command ID mapped per byte and shifted 3 bits left
+ * Also adds number of parameters at first 3 bits of LSB.
+ */
+static inline __u16 cg2900_get_fm_cmd_id(__u16 opcode)
+{
+	return opcode >> 3;
+}
+
+static inline __u16 cg2900_make_fm_cmd_id(__u16 id, __u8 num_params)
+{
+	return (id << 3) | num_params;
+}
+
+/*
+ *	GNSS
+ */
+
+struct gnss_hci_hdr {
+	__u8	op_code;
+	__le16	plen;
+} __packed;
+
+#endif /* _CG2900_CHIP_H_ */
diff --git a/drivers/staging/cg2900/mfd/cg2900_core.c b/drivers/staging/cg2900/mfd/cg2900_core.c
new file mode 100644
index 0000000..72ee1eb
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_core.c
@@ -0,0 +1,730 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+#define NAME					"cg2900_core"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <asm/byteorder.h>
+#include <linux/firmware.h>
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/stat.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/mfd/core.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include "cg2900.h"
+#include "cg2900_core.h"
+
+/* Device names */
+#define CG2900_CDEV_NAME		"cg2900_core_test"
+#define CG2900_CLASS_NAME		"cg2900_class"
+#define CG2900_DEVICE_NAME		"cg2900_driver"
+#define CORE_WQ_NAME			"cg2900_core_wq"
+
+#define LOGGER_DIRECTION_TX		0
+#define LOGGER_DIRECTION_RX		1
+
+/*
+ * Timeout values
+ */
+#define CHIP_READY_TIMEOUT		(100)	/* ms */
+#define REVISION_READOUT_TIMEOUT	(500)	/* ms */
+#define SLEEP_TIMEOUT_MS		(150)	/* ms */
+/* Timeout value to check CTS line for low power */
+#define READY_FOR_SLEEP_TIMEOUT_MS	(50)	/* ms */
+
+/**
+ * enum boot_state - BOOT-state for CG2900 Core.
+ * @BOOT_RESET:					HCI Reset has been sent.
+ * @BOOT_READ_LOCAL_VERSION_INFORMATION:	ReadLocalVersionInformation
+ *						command has been sent.
+ * @BOOT_READY:					CG2900 Core boot is ready.
+ * @BOOT_FAILED:				CG2900 Core boot failed.
+ */
+enum boot_state {
+	BOOT_RESET,
+	BOOT_READ_LOCAL_VERSION_INFORMATION,
+	BOOT_READY,
+	BOOT_FAILED
+};
+
+/**
+ * struct chip_handler_item - Structure to store chip handler cb.
+ * @list:	list_head struct.
+ * @cb:		Chip handler callback struct.
+ */
+struct chip_handler_item {
+	struct list_head		list;
+	struct cg2900_id_callbacks	cb;
+};
+
+/**
+ * struct core_info - Main info structure for CG2900 Core.
+ * @boot_state:		Current BOOT-state of CG2900 Core.
+ * @wq:			CG2900 Core workqueue.
+ * @chip_dev:		Device structure for chip driver.
+ * @work:		Work structure.
+ */
+struct core_info {
+	enum boot_state			boot_state;
+	struct workqueue_struct		*wq;
+	struct cg2900_chip_dev		*chip_dev;
+	struct work_struct		work;
+};
+
+/**
+ * struct main_info - Main info structure for CG2900 Core.
+ * @dev:		Device structure for STE Connectivity driver.
+ * @man_mutex:		Management mutex.
+ * @chip_handlers:	List of the register handlers for different chips.
+ * @wq:			Wait queue.
+ */
+struct main_info {
+	struct device		*dev;
+	struct mutex		man_mutex;
+	struct list_head	chip_handlers;
+	wait_queue_head_t	wq;
+};
+
+/* core_info - Main information object for CG2900 Core. */
+static struct main_info *main_info;
+
+/* Module parameters */
+u8 bd_address[] = {0x00, 0xBE, 0xAD, 0xDE, 0x80, 0x00};
+EXPORT_SYMBOL_GPL(bd_address);
+int bd_addr_count = BT_BDADDR_SIZE;
+
+static int sleep_timeout_ms = SLEEP_TIMEOUT_MS;
+
+/**
+ * send_bt_cmd() - Copy and send sk_buffer with no assigned user.
+ * @dev:	Current chip to transmit to.
+ * @data:	Data to send.
+ * @length:	Length in bytes of data.
+ *
+ * The send_bt_cmd() function allocate sk_buffer, copy supplied
+ * data to it, and send the sk_buffer to controller.
+ */
+void send_bt_cmd(struct cg2900_chip_dev *dev, void *data, int length)
+{
+	struct sk_buff *skb;
+	int err;
+
+	skb = alloc_skb(length + HCI_H4_SIZE, GFP_ATOMIC);
+	if (!skb) {
+		dev_err(dev->dev, "send_bt_cmd: Couldn't alloc sk_buff with "\
+			"length %d\n", length);
+		return;
+	}
+
+	skb_reserve(skb, HCI_H4_SIZE);
+	memcpy(skb_put(skb, length), data, length);
+	skb_push(skb, HCI_H4_SIZE);
+	skb->data[0] = HCI_BT_CMD_H4_CHANNEL;
+
+	err = dev->t_cb.write(dev, skb);
+	if (err) {
+		dev_err(dev->dev, "send_bt_cmd: Transport write failed (%d)\n",
+			err);
+		kfree_skb(skb);
+	}
+}
+
+/**
+ * handle_reset_cmd_complete_evt() - Handle a received HCI Command Complete event for a Reset command.
+ * @dev:	Current device.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_reset_cmd_complete_evt(struct cg2900_chip_dev *dev, u8 *data)
+{
+	bool pkt_handled = false;
+	u8 status = data[0];
+	struct hci_command_hdr cmd;
+	struct core_info *info = dev->prv_data;
+
+	dev_dbg(dev->dev, "Received Reset complete event with status 0x%X\n",
+		status);
+
+	if (info->boot_state == BOOT_RESET) {
+		/* Transmit HCI Read Local Version Information command */
+		dev_dbg(dev->dev, "New boot_state: "\
+			"BOOT_READ_LOCAL_VERSION_INFORMATION\n");
+		info->boot_state = BOOT_READ_LOCAL_VERSION_INFORMATION;
+		cmd.opcode = cpu_to_le16(HCI_OP_READ_LOCAL_VERSION);
+		cmd.plen = 0; /* No parameters for HCI reset */
+		send_bt_cmd(dev, &cmd, sizeof(cmd));
+
+		pkt_handled = true;
+	}
+
+	return pkt_handled;
+}
+
+/**
+ * handle_read_local_version_info_cmd_complete_evt() - Handle a received HCI Command Complete event for a ReadLocalVersionInformation command.
+ * @dev:	Current device.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool
+handle_read_local_version_info_cmd_complete_evt(struct cg2900_chip_dev *dev,
+						u8 *data)
+{
+	struct hci_rp_read_local_version *evt;
+	struct core_info *info = dev->prv_data;
+	u16 original_hci_revision = 0;
+
+	/* Check we're in the right state */
+	if (info->boot_state != BOOT_READ_LOCAL_VERSION_INFORMATION)
+		return false;
+
+	/* We got an answer for our HCI command. Extract data */
+	evt = (struct hci_rp_read_local_version *)data;
+
+	/* We will handle the packet */
+	if (HCI_BT_ERROR_NO_ERROR != evt->status) {
+		dev_err(dev->dev, "Received Read Local Version Information "\
+			"with status 0x%X\n", evt->status);
+		dev_dbg(dev->dev, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		wake_up_all(&main_info->wq);
+		return true;
+	}
+
+	/* The command worked. Store the data */
+	dev->chip.hci_version = evt->hci_ver;
+	dev->chip.hci_revision = le16_to_cpu(evt->hci_rev);
+	dev->chip.lmp_pal_version = evt->lmp_ver;
+	dev->chip.manufacturer = le16_to_cpu(evt->manufacturer);
+	dev->chip.hci_sub_version = le16_to_cpu(evt->lmp_subver);
+
+	if (dev->chip.hci_revision == CG2905_PG2_REV_OTP_NOT_SET ||
+		dev->chip.hci_revision == CG2905_PG1_05_REV_OTP_NOT_SET) {
+		original_hci_revision = dev->chip.hci_revision;
+		dev->chip.hci_revision |= CG2905_SET_OTP;
+	}
+
+	dev_info(dev->dev, "Received Read Local Version Information with:\n"\
+		 "\thci_version:  0x%02X\n"\
+		 "\thci_revision: 0x%04X\n"\
+		 "\tlmp_pal_version: 0x%02X\n"\
+		 "\tmanufacturer: 0x%04X\n"\
+		 "\tlmp_sub_version: 0x%04X\n",
+		 dev->chip.hci_version, dev->chip.hci_revision,
+		 dev->chip.lmp_pal_version, dev->chip.manufacturer,
+		 dev->chip.hci_sub_version);
+	if (original_hci_revision)
+		dev_info(dev->dev, "Note: Underlying hci revision is 0x%04X though!!\n",
+			original_hci_revision);
+	dev_dbg(dev->dev, "New boot_state: BOOT_READY\n");
+	info->boot_state = BOOT_READY;
+	wake_up_all(&main_info->wq);
+
+	return true;
+}
+
+/**
+ * handle_rx_data_bt_evt() - Check if data should be handled in CG2900 Core.
+ * @dev:	Current chip
+ * @skb:	Data packet
+ *
+ * The handle_rx_data_bt_evt() function checks if received data should be
+ * handled in CG2900 Core. If so handle it correctly.
+ * Received data is always HCI BT Event.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_rx_data_bt_evt(struct cg2900_chip_dev *dev,
+				  struct sk_buff *skb)
+{
+	bool pkt_handled = false;
+	u8 *data = &skb->data[CG2900_SKB_RESERVE];
+	struct hci_event_hdr *evt;
+	struct hci_ev_cmd_complete *cmd_complete;
+	u16 op_code;
+
+	evt = (struct hci_event_hdr *)data;
+
+	/* First check the event code */
+	if (HCI_EV_CMD_COMPLETE != evt->evt)
+		return false;
+
+	data += sizeof(*evt);
+	cmd_complete = (struct hci_ev_cmd_complete *)data;
+
+	op_code = le16_to_cpu(cmd_complete->opcode);
+
+	dev_dbg(dev->dev, "Received Command Complete: op_code = 0x%04X\n",
+		op_code);
+	data += sizeof(*cmd_complete); /* Move to first byte after OCF */
+
+	if (op_code == HCI_OP_RESET)
+		pkt_handled = handle_reset_cmd_complete_evt(dev, data);
+	else if (op_code == HCI_OP_READ_LOCAL_VERSION)
+		pkt_handled = handle_read_local_version_info_cmd_complete_evt
+					(dev, data);
+
+	if (pkt_handled)
+		kfree_skb(skb);
+
+	return pkt_handled;
+}
+
+static void cg2900_data_from_chip(struct cg2900_chip_dev *dev,
+				  struct sk_buff *skb)
+{
+	u8 h4_channel;
+
+	dev_dbg(dev->dev, "cg2900_data_from_chip\n");
+
+	if (!skb) {
+		dev_err(dev->dev, "No data supplied\n");
+		return;
+	}
+
+	h4_channel = skb->data[0];
+
+	/*
+	 * First check if this is the response for something
+	 * we have sent internally.
+	 */
+	if (HCI_BT_EVT_H4_CHANNEL == h4_channel &&
+	    handle_rx_data_bt_evt(dev, skb)) {
+		dev_dbg(dev->dev, "Received packet handled internally\n");
+	} else {
+		dev_err(dev->dev,
+			"cg2900_data_from_chip: Received unexpected packet\n");
+		kfree_skb(skb);
+	}
+}
+
+/**
+ * work_hw_registered() - Called when the interface to HW has been established.
+ * @work:	Reference to work data.
+ *
+ * Since there now is a transport identify the connected chip and decide which
+ * chip handler to use.
+ */
+static void work_hw_registered(struct work_struct *work)
+{
+	struct hci_command_hdr cmd;
+	struct cg2900_chip_dev *dev;
+	struct core_info *info;
+	bool chip_handled = false;
+	struct list_head *cursor;
+	struct chip_handler_item *tmp;
+
+	dev_dbg(main_info->dev, "work_hw_registered\n");
+
+	if (!work) {
+		dev_err(main_info->dev, "work_hw_registered: work == NULL\n");
+		return;
+	}
+
+	info = container_of(work, struct core_info, work);
+	dev = info->chip_dev;
+
+	/*
+	 * This might look strange, but we need to read out
+	 * the revision info in order to be able to shutdown the chip properly.
+	 */
+	if (dev->t_cb.set_chip_power)
+		dev->t_cb.set_chip_power(dev, true);
+
+	/* Set our function to receive data from chip */
+	dev->c_cb.data_from_chip = cg2900_data_from_chip;
+
+	/*
+	 * Transmit HCI reset command to ensure the chip is using
+	 * the correct transport
+	 */
+	dev_dbg(dev->dev, "New boot_state: BOOT_RESET\n");
+	info->boot_state = BOOT_RESET;
+	cmd.opcode = cpu_to_le16(HCI_OP_RESET);
+	cmd.plen = 0; /* No parameters for HCI reset */
+	send_bt_cmd(dev, &cmd, sizeof(cmd));
+
+	dev_dbg(dev->dev,
+		"Wait up to 500 milliseconds for revision to be read\n");
+	wait_event_timeout(main_info->wq,
+			   (BOOT_READY == info->boot_state ||
+			    BOOT_FAILED == info->boot_state),
+			    msecs_to_jiffies(REVISION_READOUT_TIMEOUT));
+
+	if (BOOT_READY != info->boot_state) {
+		dev_err(dev->dev,
+			"Could not read out revision from the chip\n");
+		info->boot_state = BOOT_FAILED;
+		if (dev->t_cb.set_chip_power)
+			dev->t_cb.set_chip_power(dev, false);
+		return;
+	}
+
+	dev->c_cb.data_from_chip = NULL;
+
+	mutex_lock(&main_info->man_mutex);
+	list_for_each(cursor, &main_info->chip_handlers) {
+		tmp = list_entry(cursor, struct chip_handler_item, list);
+		chip_handled = tmp->cb.check_chip_support(dev);
+		if (chip_handled) {
+			dev_info(dev->dev, "Chip handler found\n");
+			break;
+		}
+	}
+	mutex_unlock(&main_info->man_mutex);
+
+	if (!chip_handled)
+		dev_info(dev->dev, "No chip handler found\n");
+}
+
+/**
+ * cg2900_register_chip_driver() - Register a chip handler.
+ * @cb:	Callbacks to call when chip is connected.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ */
+int cg2900_register_chip_driver(struct cg2900_id_callbacks *cb)
+{
+	struct chip_handler_item *item;
+
+	dev_dbg(main_info->dev, "cg2900_register_chip_driver\n");
+
+	if (!cb) {
+		dev_err(main_info->dev, "NULL supplied as cb\n");
+		return -EINVAL;
+	}
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		dev_err(main_info->dev,
+			"cg2900_register_chip_driver: "
+			"Failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	memcpy(&item->cb, cb, sizeof(cb));
+	mutex_lock(&main_info->man_mutex);
+	list_add_tail(&item->list, &main_info->chip_handlers);
+	mutex_unlock(&main_info->man_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cg2900_register_chip_driver);
+
+/**
+ * cg2900_deregister_chip_driver() - Deregister a chip handler.
+ * @cb:	Callbacks to call when chip is connected.
+ */
+void cg2900_deregister_chip_driver(struct cg2900_id_callbacks *cb)
+{
+	struct chip_handler_item *tmp;
+	struct list_head *cursor, *next;
+
+	dev_dbg(main_info->dev, "cg2900_deregister_chip_driver\n");
+
+	if (!cb) {
+		dev_err(main_info->dev, "NULL supplied as cb\n");
+		return;
+	}
+	mutex_lock(&main_info->man_mutex);
+	list_for_each_safe(cursor, next, &main_info->chip_handlers) {
+		tmp = list_entry(cursor, struct chip_handler_item, list);
+		if (tmp->cb.check_chip_support == cb->check_chip_support) {
+			list_del(cursor);
+			kfree(tmp);
+			break;
+		}
+	}
+	mutex_unlock(&main_info->man_mutex);
+}
+EXPORT_SYMBOL_GPL(cg2900_deregister_chip_driver);
+
+/**
+ * cg2900_register_trans_driver() - Register a transport driver.
+ * @dev:	Transport device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ *   -EACCES if work can't be queued.
+ */
+int cg2900_register_trans_driver(struct cg2900_chip_dev *dev)
+{
+	int err;
+	struct cg2900_platform_data *pf_data;
+	struct core_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!dev || !dev->dev) {
+		dev_err(main_info->dev, "cg2900_register_trans_driver: "\
+			"Received NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(dev->dev, "cg2900_register_trans_driver\n");
+
+	if (!dev->t_cb.write) {
+		dev_err(dev->dev, "cg2900_register_trans_driver: Write "\
+			"function missing\n");
+		return -EINVAL;
+	}
+
+	pf_data = dev_get_platdata(dev->dev);
+	if (!pf_data) {
+		dev_err(dev->dev, "cg2900_register_trans_driver: Missing "\
+			"platform data\n");
+		return -EINVAL;
+	}
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev->dev, "Couldn't allocate info\n");
+		return -ENOMEM;
+	}
+
+	if (pf_data->init) {
+		err = pf_data->init(dev);
+		if (err) {
+			dev_err(dev->dev, "Platform init failed (%d)\n", err);
+			goto error_handling;
+		}
+	}
+
+	info->chip_dev = dev;
+	dev->prv_data = info;
+
+	info->wq = create_singlethread_workqueue(CORE_WQ_NAME);
+	if (!info->wq) {
+		dev_err(dev->dev, "Could not create workqueue\n");
+		err = -ENOMEM;
+		goto error_handling_exit;
+	}
+
+	dev_info(dev->dev, "Transport connected\n");
+
+	INIT_WORK(&info->work, work_hw_registered);
+	if (!queue_work(info->wq, &info->work)) {
+		dev_err(dev->dev, "Failed to queue work_hw_registered "\
+			"because it's already in the queue\n");
+		err = -EACCES;
+		goto error_handling_wq;
+	}
+
+	return 0;
+
+error_handling_wq:
+	destroy_workqueue(info->wq);
+error_handling_exit:
+	if (pf_data->exit)
+		pf_data->exit(dev);
+error_handling:
+	kfree(info);
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_register_trans_driver);
+
+/**
+ * cg2900_deregister_trans_driver() - Deregister a transport driver.
+ * @dev:	Transport device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ */
+int cg2900_deregister_trans_driver(struct cg2900_chip_dev *dev)
+{
+	struct cg2900_platform_data *pf_data;
+	struct core_info *info = dev->prv_data;
+
+	BUG_ON(!main_info);
+
+	dev_dbg(dev->dev, "cg2900_deregister_trans_driver\n");
+
+	if (dev->c_cb.chip_removed)
+		dev->c_cb.chip_removed(dev);
+
+	destroy_workqueue(info->wq);
+
+	dev->prv_data = NULL;
+	kfree(info);
+
+	dev_info(dev->dev, "Transport disconnected\n");
+
+	pf_data = dev_get_platdata(dev->dev);
+	if (!pf_data) {
+		dev_err(dev->dev, "Missing platform data\n");
+		return -EINVAL;
+	}
+
+	if (pf_data->exit)
+		pf_data->exit(dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cg2900_deregister_trans_driver);
+
+/**
+ * cg2900_get_sleep_timeout() - Return sleep timeout in jiffies.
+ * @check_sleep:	If we want to check whether chip has gone
+ * to sleep then use lesser timeout value
+ *
+ * Returns:
+ *   Sleep timeout in jiffies. 0 means that sleep timeout shall not be used.
+ */
+unsigned long cg2900_get_sleep_timeout(bool check_sleep)
+{
+	if (!sleep_timeout_ms)
+		return 0;
+
+	if (check_sleep)
+		return msecs_to_jiffies(READY_FOR_SLEEP_TIMEOUT_MS);
+	else
+		return msecs_to_jiffies(sleep_timeout_ms);
+}
+EXPORT_SYMBOL_GPL(cg2900_get_sleep_timeout);
+
+/**
+ * cg2900_probe() - Initialize module.
+ *
+ * @pdev:	Platform device.
+ *
+ * This function initialize the transport and CG2900 Core, then
+ * register to the transport framework.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM for failed alloc or structure creation.
+ */
+static int __devinit cg2900_probe(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "cg2900_probe\n");
+
+	main_info = kzalloc(sizeof(*main_info), GFP_KERNEL);
+	if (!main_info) {
+		dev_err(&pdev->dev, "Couldn't allocate main_info\n");
+		return -ENOMEM;
+	}
+
+	main_info->dev = &pdev->dev;
+	mutex_init(&main_info->man_mutex);
+	INIT_LIST_HEAD(&main_info->chip_handlers);
+	init_waitqueue_head(&main_info->wq);
+
+	dev_info(&pdev->dev, "CG2900 Core driver started\n");
+
+	return 0;
+}
+
+/**
+ * cg2900_remove() - Remove module.
+ *
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM if core_info does not exist.
+ *   -EINVAL if platform data does not exist in the device.
+ */
+static int __devexit cg2900_remove(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "cg2900_remove\n");
+
+	kfree(main_info);
+	main_info = NULL;
+
+	dev_info(&pdev->dev, "CG2900 Core driver removed\n");
+
+	return 0;
+}
+
+static struct platform_driver cg2900_driver = {
+	.driver = {
+		.name	= "cg2900",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_probe,
+	.remove	= __devexit_p(cg2900_remove),
+};
+
+/**
+ * cg2900_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init cg2900_init(void)
+{
+	pr_debug("cg2900_init");
+	return platform_driver_register(&cg2900_driver);
+}
+
+/**
+ * cg2900_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit cg2900_exit(void)
+{
+	pr_debug("cg2900_exit");
+	platform_driver_unregister(&cg2900_driver);
+}
+
+module_init(cg2900_init);
+module_exit(cg2900_exit);
+
+module_param(sleep_timeout_ms, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(sleep_timeout_ms,
+		 "Sleep timeout for data transmissions:\n"
+		 "\tDefault 10000 ms\n"
+		 "\t0 = disable\n"
+		 "\t>0 = sleep timeout in milliseconds");
+
+module_param_array(bd_address, byte, &bd_addr_count,
+		   S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(bd_address,
+		 "Bluetooth Device address. "
+		 "Default 0x00 0x80 0xDE 0xAD 0xBE 0xEF. "
+		 "Enter as comma separated value.");
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux Bluetooth HCI H:4 CG2900 Connectivity Device Driver");
diff --git a/drivers/staging/cg2900/mfd/cg2900_core.h b/drivers/staging/cg2900/mfd/cg2900_core.h
new file mode 100644
index 0000000..a0615fa
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_core.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+
+#ifndef _CG2900_CORE_H_
+#define _CG2900_CORE_H_
+
+#include <linux/device.h>
+#include <linux/skbuff.h>
+
+/* Reserve 1 byte for the HCI H:4 header */
+#define HCI_H4_SIZE				1
+#define CG2900_SKB_RESERVE			HCI_H4_SIZE
+
+/* Number of bytes to reserve at start of sk_buffer when receiving packet */
+#define RX_SKB_RESERVE				8
+
+#define BT_BDADDR_SIZE				6
+
+/* Standardized Bluetooth H:4 channels */
+#define HCI_BT_CMD_H4_CHANNEL			0x01
+#define HCI_BT_ACL_H4_CHANNEL			0x02
+#define HCI_BT_SCO_H4_CHANNEL			0x03
+#define HCI_BT_EVT_H4_CHANNEL			0x04
+
+/* Default H4 channels which may change depending on connected controller */
+#define HCI_FM_RADIO_H4_CHANNEL			0x08
+#define HCI_GNSS_H4_CHANNEL			0x09
+
+/* Bluetooth error codes */
+#define HCI_BT_ERROR_NO_ERROR			0x00
+#define HCI_BT_WRONG_SEQ_ERROR			0xF1
+
+/* Bluetooth lengths */
+#define HCI_BT_SEND_FILE_MAX_CHUNK_SIZE		254
+
+#define LOGGER_DIRECTION_TX			0
+#define LOGGER_DIRECTION_RX			1
+
+/* module_param declared in cg2900_core.c */
+extern u8 bd_address[BT_BDADDR_SIZE];
+
+#endif /* _CG2900_CORE_H_ */
diff --git a/drivers/staging/cg2900/mfd/cg2900_lib.c b/drivers/staging/cg2900/mfd/cg2900_lib.c
new file mode 100644
index 0000000..66d8a54
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_lib.c
@@ -0,0 +1,287 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+#define NAME					"cg2900_lib"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
+#include "cg2900.h"
+#include "cg2900_chip.h"
+#include "cg2900_core.h"
+#include "cg2900_lib.h"
+
+/*
+ * Max length in bytes for line buffer used to parse settings and patch file.
+ * Must be max length of name plus characters used to define chip version.
+ */
+#define LINE_BUFFER_LENGTH			(NAME_MAX + 30)
+#define LOGGER_HEADER_SIZE			1
+/**
+ * cg2900_tx_to_chip() - Transmit buffer to the transport.
+ * @user:	User data for BT command channel.
+ * @logger:	User data for logger channel.
+ * @skb:	Data packet.
+ *
+ * The transmit_skb_to_chip() function transmit buffer to the transport.
+ * If enabled, copy the transmitted data to the HCI logger as well.
+ */
+void cg2900_tx_to_chip(struct cg2900_user_data *user,
+		       struct cg2900_user_data *logger, struct sk_buff *skb)
+{
+	int err;
+	struct cg2900_chip_dev *chip_dev;
+
+	dev_dbg(user->dev, "cg2900_tx_to_chip %d bytes.\n", skb->len);
+
+	if (logger)
+		cg2900_send_to_hci_logger(logger, skb, LOGGER_DIRECTION_TX);
+
+	chip_dev = cg2900_get_prv(user);
+	err = chip_dev->t_cb.write(chip_dev, skb);
+	if (err) {
+		dev_err(user->dev, "cg2900_tx_to_chip: Transport write failed "\
+			"(%d)\n", err);
+		kfree_skb(skb);
+	}
+}
+EXPORT_SYMBOL_GPL(cg2900_tx_to_chip);
+
+/**
+ * cg2900_tx_no_user() - Transmit buffer to the transport.
+ * @dev:	Current chip to transmit to.
+ * @skb:	Data packet.
+ *
+ * This function transmits buffer to the transport when no user exist (system
+ * startup for example).
+ */
+void cg2900_tx_no_user(struct cg2900_chip_dev *dev, struct sk_buff *skb)
+{
+	int err;
+
+	dev_dbg(dev->dev, "cg2900_tx_no_user %d bytes.\n", skb->len);
+
+	err = dev->t_cb.write(dev, skb);
+	if (err) {
+		dev_err(dev->dev, "cg2900_tx_no_user: Transport write failed "\
+			"(%d)\n", err);
+		kfree_skb(skb);
+	}
+}
+EXPORT_SYMBOL_GPL(cg2900_tx_no_user);
+
+/**
+ * create_and_send_bt_cmd() - Copy and send sk_buffer.
+ * @user:	User data for current channel.
+ * @logger:	User data for logger channel.
+ * @data:	Data to send.
+ * @length:	Length in bytes of data.
+ *
+ * The create_and_send_bt_cmd() function allocate sk_buffer, copy supplied data
+ * to it, and send the sk_buffer to controller.
+ */
+void cg2900_send_bt_cmd(struct cg2900_user_data *user,
+			struct cg2900_user_data *logger,
+			void *data, int length,
+			u8 h4_channel)
+{
+	struct sk_buff *skb;
+
+	skb = user->alloc_skb(length, GFP_ATOMIC);
+	if (!skb) {
+		dev_err(user->dev, "cg2900_send_bt_cmd: Couldn't alloc "\
+			"sk_buff with length %d\n", length);
+		return;
+	}
+
+	memcpy(skb_put(skb, length), data, length);
+	skb_push(skb, HCI_H4_SIZE);
+	skb->data[0] = h4_channel;
+
+	cg2900_tx_to_chip(user, logger, skb);
+}
+EXPORT_SYMBOL_GPL(cg2900_send_bt_cmd);
+
+/**
+ * cg2900_send_bt_cmd_no_user() - Copy and send sk_buffer with no assigned user.
+ * @dev:	Current chip to transmit to.
+ * @data:	Data to send.
+ * @length:	Length in bytes of data.
+ *
+ * The cg2900_send_bt_cmd_no_user() function allocate sk_buffer, copy supplied
+ * data to it, and send the sk_buffer to controller.
+ */
+void cg2900_send_bt_cmd_no_user(struct cg2900_chip_dev *dev, void *data,
+				int length)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(length + HCI_H4_SIZE, GFP_KERNEL);
+	if (!skb) {
+		dev_err(dev->dev, "cg2900_send_bt_cmd_no_user: Couldn't alloc "\
+			"sk_buff with length %d\n", length);
+		return;
+	}
+
+	skb_reserve(skb, HCI_H4_SIZE);
+	memcpy(skb_put(skb, length), data, length);
+	skb_push(skb, HCI_H4_SIZE);
+	skb->data[0] = HCI_BT_CMD_H4_CHANNEL;
+
+	cg2900_tx_no_user(dev, skb);
+}
+EXPORT_SYMBOL_GPL(cg2900_send_bt_cmd_no_user);
+
+/**
+ * create_work_item() - Create work item and add it to the work queue.
+ * @wq:		Work queue.
+ * @work_func:	Work function.
+ * @user_data:	Arbitrary data set by user.
+ *
+ * The create_work_item() function creates work item and add it to
+ * the work queue.
+ * Note that work is allocated by kmalloc and work must be freed when work
+ * function is started.
+ */
+void cg2900_create_work_item(struct workqueue_struct *wq, work_func_t work_func,
+			     void *user_data)
+{
+	struct cg2900_work *new_work;
+	int err;
+
+	new_work = kmalloc(sizeof(*new_work), GFP_ATOMIC);
+	if (!new_work) {
+		pr_err("Failed to alloc memory for new_work");
+		return;
+	}
+
+	INIT_WORK(&new_work->work, work_func);
+	new_work->user_data = user_data;
+
+	err = queue_work(wq, &new_work->work);
+	if (!err) {
+		pr_err("Failed to queue work_struct because it's already "\
+		       "in the queue");
+		kfree(new_work);
+	}
+}
+EXPORT_SYMBOL_GPL(cg2900_create_work_item);
+
+/**
+ * read_and_send_file_part() - Transmit a part of the supplied file.
+ * @user:	User data for current channel.
+ * @logger:	User data for logger channel.
+ * @info:	File information.
+ *
+ * The cg2900_read_and_send_file_part() function transmit a part of the supplied
+ * file to the controller.
+ *
+ * Returns:
+ *   0 if there is no more data in the file.
+ *   >0 for number of bytes sent.
+ *   -ENOMEM if skb allocation failed.
+ */
+int cg2900_read_and_send_file_part(struct cg2900_user_data *user,
+				   struct cg2900_user_data *logger,
+				   struct cg2900_file_info *info,
+				   const struct firmware *fw_file,
+					u8 h4_channel)
+{
+	int bytes_to_copy;
+	struct sk_buff *skb;
+	struct bt_vs_write_file_block_cmd *cmd;
+	int plen;
+
+	/*
+	 * Calculate number of bytes to copy;
+	 * either max bytes for HCI packet or number of bytes left in file
+	 */
+	bytes_to_copy = min((int)HCI_BT_SEND_FILE_MAX_CHUNK_SIZE,
+			    (int)(fw_file->size - info->file_offset));
+
+	if (bytes_to_copy <= 0) {
+		/* Nothing more to read in file. */
+		dev_dbg(user->dev, "File download finished\n");
+		info->chunk_id = 0;
+		info->file_offset = 0;
+		return 0;
+	}
+
+	/* There is more data to send */
+	plen = sizeof(*cmd) + bytes_to_copy;
+	skb = user->alloc_skb(plen, GFP_KERNEL);
+	if (!skb) {
+		dev_err(user->dev, "Couldn't allocate sk_buffer\n");
+		return -ENOMEM;
+	}
+
+	skb_put(skb, plen);
+
+	cmd = (struct bt_vs_write_file_block_cmd *)skb->data;
+	cmd->opcode = cpu_to_le16(CG2900_BT_OP_VS_WRITE_FILE_BLOCK);
+	cmd->plen = BT_PARAM_LEN(plen);
+	cmd->id = info->chunk_id;
+	info->chunk_id++;
+
+	/* Copy the data from offset position */
+	memcpy(cmd->data,
+	       &(fw_file->data[info->file_offset]),
+	       bytes_to_copy);
+
+	/* Increase offset with number of bytes copied */
+	info->file_offset += bytes_to_copy;
+
+	skb_push(skb, CG2900_SKB_RESERVE);
+	skb->data[0] = h4_channel;
+
+	cg2900_tx_to_chip(user, logger, skb);
+
+	return bytes_to_copy;
+}
+EXPORT_SYMBOL_GPL(cg2900_read_and_send_file_part);
+
+void cg2900_send_to_hci_logger(struct cg2900_user_data *logger,
+							struct sk_buff *skb,
+							u8 direction)
+{
+	struct sk_buff *skb_log;
+	u8 *p;
+
+	/*
+	 * Alloc a new sk_buff and copy the data into it. Then send it to
+	 * the HCI logger.
+	 */
+	skb_log = alloc_skb(skb->len + LOGGER_HEADER_SIZE, GFP_NOWAIT);
+	if (!skb_log) {
+		pr_err("cg2900_send_to_hci_logger:"\
+				"Couldn't allocate skb_log\n");
+		return;
+	}
+	/* Reserve 1 byte for direction.*/
+	skb_reserve(skb_log, LOGGER_HEADER_SIZE);
+
+	memcpy(skb_put(skb_log, skb->len), skb->data, skb->len);
+	p = skb_push(skb_log, LOGGER_HEADER_SIZE);
+	*p = (u8) direction;
+
+	if (logger->read_cb)
+		logger->read_cb(logger, skb_log);
+	else
+		kfree_skb(skb_log);
+
+	return;
+}
+EXPORT_SYMBOL_GPL(cg2900_send_to_hci_logger);
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux CG2900 Library functions");
diff --git a/drivers/staging/cg2900/mfd/cg2900_lib.h b/drivers/staging/cg2900/mfd/cg2900_lib.h
new file mode 100644
index 0000000..470b8f2
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_lib.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+
+#ifndef _CG2900_LIB_H_
+#define _CG2900_LIB_H_
+
+#include <linux/firmware.h>
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
+
+#include "cg2900.h"
+
+/**
+ * struct cg2900_work - Generic work structure.
+ * @work:	Work structure.
+ * @user_data:	Arbitrary data set by user.
+ */
+struct cg2900_work {
+	struct work_struct work;
+	void *user_data;
+};
+
+/**
+ * struct cg2900_file_info - Info structure for file to download.
+ * @fw_file:		Stores firmware file.
+ * @file_offset:	Current read offset in firmware file.
+ * @chunk_id:		Stores current chunk ID of write file
+ *			operations.
+ */
+struct cg2900_file_info {
+	const struct firmware	*fw_file_ptc;
+	const struct firmware	*fw_file_ssf;
+	int			file_offset;
+	u8			chunk_id;
+};
+
+extern void cg2900_tx_to_chip(struct cg2900_user_data *user,
+			      struct cg2900_user_data *logger,
+			      struct sk_buff *skb);
+extern void cg2900_tx_no_user(struct cg2900_chip_dev *dev, struct sk_buff *skb);
+extern void cg2900_send_bt_cmd(struct cg2900_user_data *user,
+			       struct cg2900_user_data *logger,
+			       void *data, int length,
+			       u8 h4_channel);
+extern void cg2900_send_bt_cmd_no_user(struct cg2900_chip_dev *dev, void *data,
+				       int length);
+extern void cg2900_create_work_item(struct workqueue_struct *wq,
+				    work_func_t work_func,
+				    void *user_data);
+extern int cg2900_read_and_send_file_part(struct cg2900_user_data *user,
+					  struct cg2900_user_data *logger,
+					  struct cg2900_file_info *info,
+					  const struct firmware *fw_file,
+					  u8 h4_channel);
+extern void cg2900_send_to_hci_logger(struct cg2900_user_data *logger,
+							struct sk_buff *skb,
+							u8 direction);
+
+#endif /* _CG2900_LIB_H_ */
diff --git a/drivers/staging/cg2900/mfd/cg2900_test.c b/drivers/staging/cg2900/mfd/cg2900_test.c
new file mode 100755
index 0000000..6866096
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/cg2900_test.c
@@ -0,0 +1,402 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Driver for ST-Ericsson CG2900 test character device.
+ */
+#define NAME					"cg2900_test"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <asm/byteorder.h>
+#include <linux/firmware.h>
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/wait.h>
+
+#include "cg2900.h"
+#include "cg2900_core.h"
+
+#define MISC_DEV			(info->misc_dev.this_device)
+
+/* Device names */
+#define CG2900_CDEV_NAME		"cg2900_core_test"
+
+/**
+ * struct test_info - Main info structure for CG2900 test char device.
+ * @misc_dev:	Registered Misc Device.
+ * @rx_queue:	RX data queue.
+ * @dev:	Device structure for STE Connectivity driver.
+ * @pdev:	Platform device structure for STE Connectivity driver.
+ */
+struct test_info {
+	struct miscdevice	misc_dev;
+	struct sk_buff_head	rx_queue;
+	struct device		*dev;
+	struct platform_device	*pdev;
+};
+
+static struct test_info *test_info;
+
+/*
+ * main_wait_queue - Char device Wait Queue in CG2900 Core.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(char_wait_queue);
+
+/**
+ * tx_to_char_dev() - Handle data received from CG2900 Core.
+ * @dev:	Current chip device information.
+ * @skb:	Buffer with data coming form device.
+ */
+static int tx_to_char_dev(struct cg2900_chip_dev *dev, struct sk_buff *skb)
+{
+	struct test_info *info = dev->t_data;
+	skb_queue_tail(&info->rx_queue, skb);
+	wake_up_interruptible_all(&char_wait_queue);
+	return 0;
+}
+
+/**
+ * cg2900_test_open() - User space char device has been opened.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EACCES if transport already exists.
+ *   -ENOMEM if allocation fails.
+ *   Errors from create_work_item.
+ */
+static int cg2900_test_open(struct inode *inode, struct file *filp)
+{
+	struct test_info *info = test_info;
+	struct cg2900_chip_dev *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		dev_err(MISC_DEV, "Cannot allocate test_dev\n");
+		return -ENOMEM;
+	}
+	dev->dev = info->dev;
+	dev->pdev = info->pdev;
+	dev->t_data = info;
+	dev->t_cb.write = tx_to_char_dev;
+	filp->private_data = dev;
+
+	dev_info(MISC_DEV, "CG2900 test char dev opened\n");
+	return cg2900_register_trans_driver(dev);
+}
+
+/**
+ * cg2900_test_release() - User space char device has been closed.
+ * @inode:	Device driver information.
+ * @filp:	Pointer to the file struct.
+ *
+ * Returns:
+ *   0 if there is no error.
+ */
+static int cg2900_test_release(struct inode *inode, struct file *filp)
+{
+	struct cg2900_chip_dev *dev = filp->private_data;
+	struct test_info *info = dev->t_data;
+
+	dev_info(MISC_DEV, "CG2900 test char dev closed\n");
+	skb_queue_purge(&info->rx_queue);
+	cg2900_deregister_trans_driver(dev);
+	kfree(dev);
+
+	return 0;
+}
+
+/**
+ * cg2900_test_read() - Queue and copy buffer to user space char device.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Received buffer.
+ * @count:	Count of received data in bytes.
+ * @f_pos:	Position in buffer.
+ *
+ * Returns:
+ *   >= 0 is number of bytes read.
+ *   -EFAULT if copy_to_user fails.
+ */
+static ssize_t cg2900_test_read(struct file *filp, char __user *buf,
+				size_t count, loff_t *f_pos)
+{
+	struct sk_buff *skb;
+	int bytes_to_copy;
+	int err;
+	struct cg2900_chip_dev *dev = filp->private_data;
+	struct test_info *info = dev->t_data;
+	struct sk_buff_head *rx_queue = &info->rx_queue;
+
+	dev_dbg(MISC_DEV, "cg2900_test_read count %d\n", (int)count);
+
+	if (skb_queue_empty(rx_queue))
+		wait_event_interruptible(char_wait_queue,
+					 !(skb_queue_empty(rx_queue)));
+
+	skb = skb_dequeue(rx_queue);
+	if (!skb) {
+		dev_dbg(MISC_DEV,
+			"skb queue is empty - return with zero bytes\n");
+		bytes_to_copy = 0;
+		goto finished;
+	}
+
+	bytes_to_copy = min_t(size_t, count, skb->len);
+	err = copy_to_user(buf, skb->data, bytes_to_copy);
+	if (err) {
+		skb_queue_head(rx_queue, skb);
+		return -EFAULT;
+	}
+
+	skb_pull(skb, bytes_to_copy);
+
+	if (skb->len > 0)
+		skb_queue_head(rx_queue, skb);
+	else
+		kfree_skb(skb);
+
+finished:
+	return bytes_to_copy;
+}
+
+/**
+ * cg2900_test_write() - Copy buffer from user and write to CG2900 Core.
+ * @filp:	Pointer to the file struct.
+ * @buf:	Read buffer.
+ * @count:	Size of the buffer write.
+ * @f_pos:	Position in buffer.
+ *
+ * Returns:
+ *   >= 0 is number of bytes written.
+ *   -EFAULT if copy_from_user fails.
+ */
+static ssize_t cg2900_test_write(struct file *filp, const char __user *buf,
+				 size_t count, loff_t *f_pos)
+{
+	struct sk_buff *skb;
+	struct cg2900_chip_dev *dev = filp->private_data;
+	struct test_info *info = dev->t_data;
+
+	dev_dbg(MISC_DEV, "cg2900_test_write count %d\n", (int)count);
+
+	/* Allocate the SKB and reserve space for the header */
+	skb = alloc_skb(count + RX_SKB_RESERVE, GFP_KERNEL);
+	if (!skb) {
+		dev_err(MISC_DEV, "cg2900_test_write: Failed to alloc skb\n");
+		return -ENOMEM;
+	}
+	skb_reserve(skb, RX_SKB_RESERVE);
+
+	if (copy_from_user(skb_put(skb, count), buf, count)) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+
+	dev->c_cb.data_from_chip(dev, skb);
+
+	return count;
+}
+
+/**
+ * cg2900_test_poll() - Handle POLL call to the interface.
+ * @filp:	Pointer to the file struct.
+ * @wait:	Poll table supplied to caller.
+ *
+ * Returns:
+ *   Mask of current set POLL values (0 or (POLLIN | POLLRDNORM))
+ */
+static unsigned int cg2900_test_poll(struct file *filp, poll_table *wait)
+{
+	struct cg2900_chip_dev *dev = filp->private_data;
+	struct test_info *info = dev->t_data;
+	unsigned int mask = 0;
+
+	poll_wait(filp, &char_wait_queue, wait);
+
+	if (!(skb_queue_empty(&info->rx_queue)))
+		mask |= POLLIN | POLLRDNORM;
+
+	return mask;
+}
+
+static const struct file_operations test_char_dev_fops = {
+	.open = cg2900_test_open,
+	.release = cg2900_test_release,
+	.read = cg2900_test_read,
+	.write = cg2900_test_write,
+	.poll = cg2900_test_poll
+};
+
+/**
+ * test_char_dev_create() - Create a char device for testing.
+ * @info:	Test device info.
+ *
+ * Creates a separate char device that will interact directly with userspace
+ * test application.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   Error codes from misc_register.
+ */
+static int test_char_dev_create(struct test_info *info)
+{
+	int err;
+
+	/* Initialize the RX queue */
+	skb_queue_head_init(&info->rx_queue);
+
+	/* Prepare miscdevice struct before registering the device */
+	info->misc_dev.minor = MISC_DYNAMIC_MINOR;
+	info->misc_dev.name = CG2900_CDEV_NAME;
+	info->misc_dev.fops = &test_char_dev_fops;
+	info->misc_dev.parent = info->dev;
+	info->misc_dev.mode = S_IRUGO | S_IWUGO;
+
+	err = misc_register(&info->misc_dev);
+	if (err) {
+		dev_err(info->dev, "Error %d registering misc dev", err);
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * test_char_dev_destroy() - Clean up after test_char_dev_create().
+ * @info:	Test device info.
+ */
+static void test_char_dev_destroy(struct test_info *info)
+{
+	int err;
+
+	err = misc_deregister(&info->misc_dev);
+	if (err)
+		dev_err(info->dev, "Error %d deregistering misc dev\n", err);
+
+	/* Clean the message queue */
+	skb_queue_purge(&info->rx_queue);
+}
+
+/**
+ * cg2900_test_probe() - Initialize module.
+ *
+ * @pdev:	Platform device.
+ *
+ * This function initializes and registers the test misc char device.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM for failed alloc or structure creation.
+ *   -EEXIST if device already exists.
+ *   Error codes generated by test_char_dev_create.
+ */
+static int __devinit cg2900_test_probe(struct platform_device *pdev)
+{
+	int err;
+
+	dev_dbg(&pdev->dev, "cg2900_test_probe\n");
+
+	if (test_info) {
+		dev_err(&pdev->dev, "test_info exists\n");
+		return -EEXIST;
+	}
+
+	test_info = kzalloc(sizeof(*test_info), GFP_KERNEL);
+	if (!test_info) {
+		dev_err(&pdev->dev, "Couldn't allocate test_info\n");
+		return -ENOMEM;
+	}
+
+	test_info->dev = &pdev->dev;
+	test_info->pdev = pdev;
+
+	/* Create and add test char device. */
+	err = test_char_dev_create(test_info);
+	if (err) {
+		kfree(test_info);
+		test_info = NULL;
+		return err;
+	}
+
+	dev_set_drvdata(&pdev->dev, test_info);
+
+	dev_info(&pdev->dev, "CG2900 test char device driver started\n");
+
+	return 0;
+}
+
+/**
+ * cg2900_test_remove() - Remove module.
+ *
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM if core_info does not exist.
+ *   -EINVAL if platform data does not exist in the device.
+ */
+static int __devexit cg2900_test_remove(struct platform_device *pdev)
+{
+	struct test_info *test_info;
+
+	dev_dbg(&pdev->dev, "cg2900_test_remove\n");
+	test_info = dev_get_drvdata(&pdev->dev);
+	test_char_dev_destroy(test_info);
+	dev_set_drvdata(&pdev->dev, NULL);
+	kfree(test_info);
+	test_info = NULL;
+	dev_info(&pdev->dev, "CG2900 Test char device driver removed\n");
+	return 0;
+}
+
+static struct platform_driver cg2900_test_driver = {
+	.driver = {
+		.name	= "cg2900-test",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_test_probe,
+	.remove	= __devexit_p(cg2900_test_remove),
+};
+
+/**
+ * cg2900_test_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init cg2900_test_init(void)
+{
+	pr_debug("cg2900_test_init");
+	return platform_driver_register(&cg2900_test_driver);
+}
+
+/**
+ * cg2900_test_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit cg2900_test_exit(void)
+{
+	pr_debug("cg2900_test_exit");
+	platform_driver_unregister(&cg2900_test_driver);
+}
+
+module_init(cg2900_test_init);
+module_exit(cg2900_test_exit);
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux CG2900 Test Char Device Driver");
diff --git a/drivers/staging/cg2900/mfd/stlc2690_chip.c b/drivers/staging/cg2900/mfd/stlc2690_chip.c
new file mode 100644
index 0000000..ca3e26c
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/stlc2690_chip.c
@@ -0,0 +1,1710 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson STLC2690 BT/FM controller.
+ */
+#define NAME					"stlc2690_chip"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <asm/byteorder.h>
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/stat.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/mfd/core.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include "cg2900.h"
+#include "cg2900_core.h"
+#include "cg2900_lib.h"
+#include "stlc2690_chip.h"
+
+#ifndef MAX
+#define MAX(x, y) (((x) > (y)) ? (x) : (y))
+#endif
+
+#define MAIN_DEV				(main_info->dev)
+#define BOOT_DEV				(info->user_in_charge->dev)
+
+#define WQ_NAME					"stlc2690_chip_wq"
+
+#define LINE_TOGGLE_DETECT_TIMEOUT		50	/* ms */
+#define CHIP_READY_TIMEOUT			100	/* ms */
+#define CHIP_STARTUP_TIMEOUT			15000	/* ms */
+#define CHIP_SHUTDOWN_TIMEOUT			15000	/* ms */
+
+/** CHANNEL_BT_CMD - Bluetooth HCI H:4 channel
+ * for Bluetooth commands in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_CMD				0x01
+
+/** CHANNEL_BT_ACL - Bluetooth HCI H:4 channel
+ * for Bluetooth ACL data in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_ACL				0x02
+
+/** CHANNEL_BT_EVT - Bluetooth HCI H:4 channel
+ * for Bluetooth events in the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_BT_EVT				0x04
+
+/** CHANNEL_HCI_LOGGER - Bluetooth HCI H:4 channel
+ * for logging all transmitted H4 packets (on all channels).
+ */
+#define CHANNEL_HCI_LOGGER			0xFA
+
+/** CHANNEL_CORE - Bluetooth HCI H:4 channel
+ * for user space control of the ST-Ericsson connectivity controller.
+ */
+#define CHANNEL_CORE				0xFD
+
+/*
+ * For the char dev names we keep the same names in order to be able to reuse
+ * the users and to keep a consistent interface.
+ */
+
+/** STLC2690_BT_CMD - Bluetooth HCI H4 channel for Bluetooth commands.
+ */
+#define STLC2690_BT_CMD				"cg2900_bt_cmd"
+
+/** STLC2690_BT_ACL - Bluetooth HCI H4 channel for Bluetooth ACL data.
+ */
+#define STLC2690_BT_ACL				"cg2900_bt_acl"
+
+/** STLC2690_BT_EVT - Bluetooth HCI H4 channel for Bluetooth events.
+ */
+#define STLC2690_BT_EVT				"cg2900_bt_evt"
+
+/** STLC2690_HCI_LOGGER - BT channel for logging all transmitted H4 packets.
+ * Data read is copy of all data transferred on the other channels.
+ * Only write allowed is configuration of the HCI Logger.
+ */
+#define STLC2690_HCI_LOGGER			"cg2900_hci_logger"
+
+/** STLC2690_CORE- Channel for keeping ST-Ericsson STLC2690 enabled.
+ * Opening this channel forces the chip to stay powered.
+ * No data can be written to or read from this channel.
+ */
+#define STLC2690_CORE				"cg2900_core"
+
+/**
+ * enum main_state - Main-state for STLC2690 driver.
+ * @STLC2690_INIT:	STLC2690 initializing.
+ * @STLC2690_IDLE:	No user registered to STLC2690 driver.
+ * @STLC2690_BOOTING:	STLC2690 booting after first user is registered.
+ * @STLC2690_CLOSING:	STLC2690 closing after last user has deregistered.
+ * @STLC2690_RESETING:	STLC2690 reset requested.
+ * @STLC2690_ACTIVE:	STLC2690 up and running with at least one user.
+ */
+enum main_state {
+	STLC2690_INIT,
+	STLC2690_IDLE,
+	STLC2690_BOOTING,
+	STLC2690_CLOSING,
+	STLC2690_RESETING,
+	STLC2690_ACTIVE
+};
+
+/**
+ * enum boot_state - BOOT-state for STLC2690 chip driver.
+ * @BOOT_RESET:				HCI Reset has been sent.
+ * @BOOT_SEND_BD_ADDRESS:		VS Store In FS command with BD address
+ *					has been sent.
+ * @BOOT_GET_FILES_TO_LOAD:		STLC2690 chip driver is retrieving file
+ *					to load.
+ * @BOOT_DOWNLOAD_PATCH:		STLC2690 chip driver is downloading
+ *					patches.
+ * @BOOT_ACTIVATE_PATCHES_AND_SETTINGS:	STLC2690 chip driver is activating
+ *					patches and settings.
+ * @BOOT_READY:				STLC2690 chip driver boot is ready.
+ * @BOOT_FAILED:			STLC2690 chip driver boot failed.
+ */
+enum boot_state {
+	BOOT_RESET,
+	BOOT_SEND_BD_ADDRESS,
+	BOOT_GET_FILES_TO_LOAD,
+	BOOT_DOWNLOAD_PATCH,
+	BOOT_ACTIVATE_PATCHES_AND_SETTINGS,
+	BOOT_READY,
+	BOOT_FAILED
+};
+
+/**
+ * enum file_load_state - BOOT_FILE_LOAD-state for STLC2690 chip driver.
+ * @FILE_LOAD_GET_PATCH:		Loading patches.
+ * @FILE_LOAD_GET_STATIC_SETTINGS:	Loading static settings.
+ * @FILE_LOAD_NO_MORE_FILES:		No more files to load.
+ * @FILE_LOAD_FAILED:			File loading failed.
+ */
+enum file_load_state {
+	FILE_LOAD_GET_PATCH,
+	FILE_LOAD_GET_STATIC_SETTINGS,
+	FILE_LOAD_NO_MORE_FILES,
+	FILE_LOAD_FAILED
+};
+
+/**
+ * enum download_state - BOOT_DOWNLOAD state.
+ * @DOWNLOAD_PENDING:	Download in progress.
+ * @DOWNLOAD_SUCCESS:	Download successfully finished.
+ * @DOWNLOAD_FAILED:	Downloading failed.
+ */
+enum download_state {
+	DOWNLOAD_PENDING,
+	DOWNLOAD_SUCCESS,
+	DOWNLOAD_FAILED
+};
+
+
+/**
+ * struct stlc2690_channel_item - List object for channel.
+ * @list:	list_head struct.
+ * @user:	User for this channel.
+ */
+struct stlc2690_channel_item {
+	struct list_head	list;
+	struct cg2900_user_data	*user;
+};
+
+/**
+ * struct stlc2690_skb_data - Structure for storing private data in an sk_buffer.
+ * @dev:	STLC2690 device for this sk_buffer.
+ */
+struct stlc2690_skb_data {
+	struct cg2900_user_data *user;
+};
+#define stlc2690_skb_data(__skb) ((struct stlc2690_skb_data *)((__skb)->cb))
+
+/**
+ * struct stlc2690_chip_info - Main info structure for STLC2690 chip driver.
+ * @patch_file_name:		Stores patch file name.
+ * @settings_file_name:		Stores settings file name.
+ * @file_info:			Firmware file info (patch or settings).
+ * @main_state:			Current MAIN-state of STLC2690 chip driver.
+ * @boot_state:			Current BOOT-state of STLC2690 chip driver.
+ * @file_load_state:		Current BOOT_FILE_LOAD-state of STLC2690 chip
+ *				driver.
+ * @download_state:		Current BOOT_DOWNLOAD-state of STLC2690 chip
+ *				driver.
+ * @wq:				STLC2690 chip driver workqueue.
+ * @chip_dev:			Chip handler info.
+ * @user_in_charge:		User currently operating. Normally used at
+ *				channel open and close.
+ * @last_user:			Last user of this chip.
+ * @logger:			Logger user of this chip.
+ * @startup:			True if system is starting up.
+ * @mfd_size:			Number of MFD cells.
+ * @mfd_char_size:		Number of MFD char device cells.
+ */
+struct stlc2690_chip_info {
+	char				*patch_file_name;
+	char				*settings_file_name;
+	struct cg2900_file_info		file_info;
+	enum main_state			main_state;
+	enum boot_state			boot_state;
+	enum file_load_state		file_load_state;
+	enum download_state		download_state;
+	struct workqueue_struct		*wq;
+	struct cg2900_chip_dev		*chip_dev;
+	spinlock_t			rw_lock;
+	struct list_head		open_channels;
+	struct cg2900_user_data		*user_in_charge;
+	struct cg2900_user_data		*last_user;
+	struct cg2900_user_data		*logger;
+	bool				startup;
+	int				mfd_size;
+	int				mfd_char_size;
+};
+
+/**
+ * struct main_info - Main info structure for STLC2690 chip driver.
+ * @dev:			Device structure.
+ * @cell_base_id:		Base ID for MFD cells.
+ * @man_mutex:			Management mutex.
+ */
+struct main_info {
+	struct device			*dev;
+	int				cell_base_id;
+	struct mutex			man_mutex;
+};
+
+static struct main_info *main_info;
+
+/*
+ * main_wait_queue - Main Wait Queue in STLC2690 driver.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(main_wait_queue);
+
+static struct mfd_cell stlc2690_devs[];
+static struct mfd_cell stlc2690_char_devs[];
+
+static void chip_startup_finished(struct stlc2690_chip_info *info, int err);
+
+/**
+ * send_bd_address() - Send HCI VS command with BD address to the chip.
+ */
+static void send_bd_address(struct stlc2690_chip_info *info)
+{
+	struct bt_vs_store_in_fs_cmd *cmd;
+	u8 plen = sizeof(*cmd) + BT_BDADDR_SIZE;
+
+	cmd = kmalloc(plen, GFP_KERNEL);
+	if (!cmd)
+		return;
+
+	cmd->opcode = cpu_to_le16(STLC2690_BT_OP_VS_STORE_IN_FS);
+	cmd->plen = BT_PARAM_LEN(plen);
+	cmd->user_id = STLC2690_VS_STORE_IN_FS_USR_ID_BD_ADDR;
+	cmd->len = BT_BDADDR_SIZE;
+	/* Now copy the BD address received from user space control app. */
+	memcpy(cmd->data, bd_address, BT_BDADDR_SIZE);
+
+	dev_dbg(BOOT_DEV, "New boot_state: BOOT_SEND_BD_ADDRESS\n");
+	info->boot_state = BOOT_SEND_BD_ADDRESS;
+
+	cg2900_send_bt_cmd(info->user_in_charge, info->logger, cmd, plen,
+			CHANNEL_BT_CMD);
+
+	kfree(cmd);
+}
+
+/**
+ * send_settings_file() - Transmit settings file.
+ *
+ * The send_settings_file() function transmit settings file.
+ * The file is read in parts to fit in HCI packets. When finished,
+ * close the settings file and send HCI reset to activate settings and patches.
+ */
+static void send_settings_file(struct stlc2690_chip_info *info)
+{
+	int bytes_sent;
+
+	bytes_sent = cg2900_read_and_send_file_part(info->user_in_charge,
+						    info->logger,
+						    &info->file_info,
+						    info->file_info.fw_file_ssf,
+						    CHANNEL_BT_CMD);
+	if (bytes_sent > 0) {
+		/* Data sent. Wait for CmdComplete */
+		return;
+	} else if (bytes_sent < 0) {
+		dev_err(BOOT_DEV, "send_settings_file: Error %d occurred\n",
+			bytes_sent);
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		chip_startup_finished(info, bytes_sent);
+		return;
+	}
+
+	/* No data was sent. This file is finished */
+	info->download_state = DOWNLOAD_SUCCESS;
+
+	/* Settings file finished. Release used resources */
+	dev_dbg(BOOT_DEV, "Settings file finished\n");
+
+	dev_dbg(BOOT_DEV, "New file_load_state: FILE_LOAD_NO_MORE_FILES\n");
+	info->file_load_state = FILE_LOAD_NO_MORE_FILES;
+
+	/* Create and send HCI VS Store In FS command with bd address. */
+	send_bd_address(info);
+}
+
+/**
+ * send_patch_file - Transmit patch file.
+ *
+ * The send_patch_file() function transmit patch file.
+ * The file is read in parts to fit in HCI packets. When the complete file is
+ * transmitted, the file is closed.
+ * When finished, continue with settings file.
+ */
+static void send_patch_file(struct cg2900_chip_dev *dev)
+{
+	int err;
+	int bytes_sent;
+	struct stlc2690_chip_info *info = dev->c_data;
+
+	bytes_sent = cg2900_read_and_send_file_part(info->user_in_charge,
+						    info->logger,
+						    &info->file_info,
+						    info->file_info.fw_file_ptc,
+						    CHANNEL_BT_CMD);
+	if (bytes_sent > 0) {
+		/* Data sent. Wait for CmdComplete */
+		return;
+	} else if (bytes_sent < 0) {
+		dev_err(BOOT_DEV, "send_patch_file: Error %d occurred\n",
+			bytes_sent);
+		err = bytes_sent;
+		goto error_handling;
+	}
+
+	/* No data was sent. This file is finished */
+	info->download_state = DOWNLOAD_SUCCESS;
+
+	dev_dbg(BOOT_DEV, "Patch file finished\n");
+
+	/* Now send the settings file */
+	dev_dbg(BOOT_DEV,
+		"New file_load_state: FILE_LOAD_GET_STATIC_SETTINGS\n");
+	info->file_load_state = FILE_LOAD_GET_STATIC_SETTINGS;
+	dev_dbg(BOOT_DEV, "New download_state: DOWNLOAD_PENDING\n");
+	info->download_state = DOWNLOAD_PENDING;
+	send_settings_file(info);
+	return;
+
+error_handling:
+	dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+	info->boot_state = BOOT_FAILED;
+	chip_startup_finished(info, err);
+}
+
+/**
+ * work_reset_after_error() - Handle reset.
+ * @work:	Reference to work data.
+ *
+ * Handle a reset after received Command Complete event.
+ */
+static void work_reset_after_error(struct work_struct *work)
+{
+	struct cg2900_work *my_work;
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+
+	if (!work) {
+		dev_err(MAIN_DEV, "work_reset_after_error: work == NULL\n");
+		return;
+	}
+
+	my_work = container_of(work, struct cg2900_work, work);
+	dev = my_work->user_data;
+	info = dev->c_data;
+
+	chip_startup_finished(info, -EIO);
+
+	kfree(my_work);
+}
+
+/**
+ * work_load_patch_and_settings() - Start loading patches and settings.
+ * @work:	Reference to work data.
+ */
+static void work_load_patch_and_settings(struct work_struct *work)
+{
+	struct cg2900_work *my_work;
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+
+	if (!work) {
+		dev_err(MAIN_DEV,
+			"work_load_patch_and_settings: work == NULL\n");
+		return;
+	}
+
+	my_work = container_of(work, struct cg2900_work, work);
+	dev = my_work->user_data;
+	info = dev->c_data;
+
+	/* Check that we are in the right state */
+	if (info->boot_state != BOOT_GET_FILES_TO_LOAD)
+		goto finished;
+
+	/* We now all info needed */
+	dev_dbg(BOOT_DEV, "New boot_state: BOOT_DOWNLOAD_PATCH\n");
+	info->boot_state = BOOT_DOWNLOAD_PATCH;
+	dev_dbg(BOOT_DEV, "New download_state: DOWNLOAD_PENDING\n");
+	info->download_state = DOWNLOAD_PENDING;
+	dev_dbg(BOOT_DEV, "New file_load_state: FILE_LOAD_GET_PATCH\n");
+	info->file_load_state = FILE_LOAD_GET_PATCH;
+	info->file_info.chunk_id = 0;
+	info->file_info.file_offset = 0;
+
+	send_patch_file(dev);
+
+	goto finished;
+
+finished:
+	kfree(my_work);
+}
+
+/**
+ * work_cont_file_download() - A file block has been written.
+ * @work:	Reference to work data.
+ *
+ * Handle a received HCI VS Write File Block Complete event.
+ * Normally this means continue to send files to the controller.
+ */
+static void work_cont_file_download(struct work_struct *work)
+{
+	struct cg2900_work *my_work;
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+
+	if (!work) {
+		dev_err(MAIN_DEV, "work_cont_file_download: work == NULL\n");
+		return;
+	}
+
+	my_work = container_of(work, struct cg2900_work, work);
+	dev = my_work->user_data;
+	info = dev->c_data;
+
+	/* Continue to send patches or settings to the controller */
+	if (info->file_load_state == FILE_LOAD_GET_PATCH)
+		send_patch_file(dev);
+	else if (info->file_load_state == FILE_LOAD_GET_STATIC_SETTINGS)
+		send_settings_file(info);
+	else
+		dev_dbg(BOOT_DEV, "No more files to load\n");
+
+	kfree(my_work);
+}
+
+/**
+ * handle_reset_cmd_complete() - Handles HCI Reset Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_reset_cmd_complete(struct cg2900_chip_dev *dev, u8 *data)
+{
+	u8 status = data[0];
+	struct stlc2690_chip_info *info = dev->c_data;
+
+	dev_dbg(BOOT_DEV, "Received Reset complete event with status 0x%X\n",
+		status);
+
+	if (BOOT_RESET != info->boot_state &&
+	    BOOT_ACTIVATE_PATCHES_AND_SETTINGS != info->boot_state)
+		return false;
+
+	if (HCI_BT_ERROR_NO_ERROR != status) {
+		dev_err(BOOT_DEV, "Command complete for HciReset received with"\
+			" error 0x%X\n", status);
+		cg2900_create_work_item(info->wq, work_reset_after_error, dev);
+		return true;
+	}
+
+	if (BOOT_RESET == info->boot_state) {
+		info->boot_state = BOOT_GET_FILES_TO_LOAD;
+		cg2900_create_work_item(info->wq, work_load_patch_and_settings,
+					dev);
+	} else {
+		/*
+		 * The boot sequence is now finished successfully.
+		 * Set states and signal to waiting thread.
+		 */
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_READY\n");
+		info->boot_state = BOOT_READY;
+		chip_startup_finished(info, 0);
+	}
+
+	return true;
+}
+
+
+/**
+ * handle_vs_store_in_fs_cmd_complete() - Handles HCI VS StoreInFS Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_store_in_fs_cmd_complete(struct cg2900_chip_dev *dev,
+					       u8 *data)
+{
+	u8 status = data[0];
+	struct stlc2690_chip_info *info = dev->c_data;
+
+	dev_dbg(BOOT_DEV,
+		"Received Store_in_FS complete event with status 0x%X\n",
+		status);
+
+	if (info->boot_state != BOOT_SEND_BD_ADDRESS)
+		return false;
+
+	if (HCI_BT_ERROR_NO_ERROR == status) {
+		struct hci_command_hdr cmd;
+
+		/* Send HCI Reset command to activate patches */
+		dev_dbg(BOOT_DEV,
+			"New boot_state: BOOT_ACTIVATE_PATCHES_AND_SETTINGS\n");
+		info->boot_state = BOOT_ACTIVATE_PATCHES_AND_SETTINGS;
+
+		cmd.opcode = cpu_to_le16(HCI_OP_RESET);
+		cmd.plen = 0; /* No parameters for Reset */
+		cg2900_send_bt_cmd(info->user_in_charge, info->logger, &cmd,
+				   sizeof(cmd), CHANNEL_BT_CMD);
+	} else {
+		dev_err(BOOT_DEV,
+			"Command complete for StoreInFS received with error "
+			"0x%X\n", status);
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		cg2900_create_work_item(info->wq, work_reset_after_error, dev);
+	}
+
+	return true;
+}
+
+/**
+ * handle_vs_write_file_block_cmd_complete() - Handles HCI VS WriteFileBlock Command Complete event.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_write_file_block_cmd_complete(struct cg2900_chip_dev *dev,
+						    u8 *data)
+{
+	u8 status = data[0];
+	struct stlc2690_chip_info *info = dev->c_data;
+
+	if (info->boot_state != BOOT_DOWNLOAD_PATCH ||
+	    info->download_state != DOWNLOAD_PENDING)
+		return false;
+
+	if (HCI_BT_ERROR_NO_ERROR == status)
+		cg2900_create_work_item(info->wq, work_cont_file_download, dev);
+	else {
+		dev_err(BOOT_DEV,
+			"Command complete for WriteFileBlock received with"
+			" error 0x%X\n", status);
+		dev_dbg(BOOT_DEV, "New download_state: DOWNLOAD_FAILED\n");
+		info->download_state = DOWNLOAD_FAILED;
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+
+		cg2900_create_work_item(info->wq, work_reset_after_error, dev);
+	}
+
+	return true;
+}
+
+/**
+ * handle_vs_write_file_block_cmd_status() - Handles HCI VS WriteFileBlock Command Status event.
+ * @status:	Returned status of WriteFileBlock command.
+ *
+ * Returns:
+ *   true,  if packet was handled internally,
+ *   false, otherwise.
+ */
+static bool handle_vs_write_file_block_cmd_status(struct cg2900_chip_dev *dev,
+						  u8 status)
+{
+	struct stlc2690_chip_info *info = dev->c_data;
+
+	if (info->boot_state != BOOT_DOWNLOAD_PATCH ||
+	    info->download_state != DOWNLOAD_PENDING)
+		return false;
+
+	/*
+	 * Only do something if there is an error. Otherwise we will wait for
+	 * CmdComplete.
+	 */
+	if (HCI_BT_ERROR_NO_ERROR != status) {
+		dev_err(BOOT_DEV,
+			"Command status for WriteFileBlock received with"
+			" error 0x%X\n", status);
+		dev_dbg(BOOT_DEV, "New download_state: DOWNLOAD_FAILED\n");
+		info->download_state = DOWNLOAD_FAILED;
+		dev_dbg(BOOT_DEV, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+
+		cg2900_create_work_item(info->wq, work_reset_after_error, dev);
+	}
+
+	return true;
+}
+
+/**
+ * handle_rx_data_bt_evt() - Check if received data should be handled in STLC2690 chip driver.
+ * @skb:	Data packet
+ *
+ * The handle_rx_data_bt_evt() function checks if received data should be
+ * handled in STLC2690 chip driver. If so handle it correctly.
+ * Received data is always HCI BT Event.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_rx_data_bt_evt(struct cg2900_chip_dev *dev,
+				  struct sk_buff *skb)
+{
+	bool pkt_handled = false;
+	/* skb cannot be NULL here so it is safe to de-reference */
+	u8 *data = skb->data;
+	struct hci_event_hdr *evt;
+	u16 op_code;
+
+	evt = (struct hci_event_hdr *)data;
+	data += sizeof(*evt);
+
+	/* First check the event code. */
+	if (HCI_EV_CMD_COMPLETE == evt->evt) {
+		struct hci_ev_cmd_complete *cmd_complete;
+
+		cmd_complete = (struct hci_ev_cmd_complete *)data;
+		op_code = le16_to_cpu(cmd_complete->opcode);
+		dev_dbg(dev->dev,
+			"Received Command Complete: op_code = 0x%04X\n",
+			op_code);
+		/* Move to first byte after OCF */
+		data += sizeof(*cmd_complete);
+
+		if (op_code == HCI_OP_RESET)
+			pkt_handled = handle_reset_cmd_complete(dev, data);
+		else if (op_code == STLC2690_BT_OP_VS_STORE_IN_FS)
+			pkt_handled = handle_vs_store_in_fs_cmd_complete(dev,
+									 data);
+		else if (op_code == STLC2690_BT_OP_VS_WRITE_FILE_BLOCK)
+			pkt_handled =
+				handle_vs_write_file_block_cmd_complete(dev,
+									data);
+	} else if (HCI_EV_CMD_STATUS == evt->evt) {
+		struct hci_ev_cmd_status *cmd_status;
+
+		cmd_status = (struct hci_ev_cmd_status *)data;
+
+		op_code = le16_to_cpu(cmd_status->opcode);
+
+		dev_dbg(dev->dev, "Received Command Status: op_code = 0x%04X\n",
+			op_code);
+
+		if (op_code == STLC2690_BT_OP_VS_WRITE_FILE_BLOCK)
+			pkt_handled = handle_vs_write_file_block_cmd_status
+				(dev, cmd_status->status);
+	} else if (HCI_EV_HW_ERROR == evt->evt) {
+		struct hci_ev_hw_error *hw_error;
+
+		hw_error = (struct hci_ev_hw_error *)data;
+		/*
+		 * Only do a printout. There might be a receiving stack that can
+		 * handle this event
+		 */
+		dev_err(dev->dev, "HW Error event received with error 0x%02X\n",
+			hw_error->hw_code);
+		return false;
+	} else
+		return false;
+
+	if (pkt_handled)
+		kfree_skb(skb);
+
+	return pkt_handled;
+}
+
+/**
+ * data_from_chip() - Called when data is received from the chip.
+ * @dev:	Chip info.
+ * @skb:	Packet received.
+ *
+ * The data_from_chip() function checks if packet is a response for a packet it
+ * itself has transmitted. If not it finds the correct user and sends the packet
+ * to the user.
+ */
+static void data_from_chip(struct cg2900_chip_dev *dev,
+			   struct sk_buff *skb)
+{
+	int h4_channel;
+	struct list_head *cursor;
+	struct stlc2690_channel_item *tmp;
+	struct stlc2690_chip_info *info = dev->c_data;
+	struct cg2900_user_data *user = NULL;
+
+	h4_channel = skb->data[0];
+	skb_pull(skb, HCI_H4_SIZE);
+
+	/* Then check if this is a response to data we have sent */
+	if (h4_channel == CHANNEL_BT_EVT && handle_rx_data_bt_evt(dev, skb))
+		return;
+
+	spin_lock_bh(&info->rw_lock);
+
+	/* Let's see if this packet has the same user as the last one */
+	if (info->last_user && info->last_user->h4_channel == h4_channel) {
+		user = info->last_user;
+		goto user_found;
+	}
+
+	/* Search through the list of all open channels to find the user */
+	list_for_each(cursor, &info->open_channels) {
+		tmp = list_entry(cursor, struct stlc2690_channel_item, list);
+		if (tmp->user->h4_channel == h4_channel) {
+			user = tmp->user;
+			goto user_found;
+		}
+	}
+
+user_found:
+	info->last_user = user;
+	spin_unlock_bh(&info->rw_lock);
+
+	if (user)
+		user->read_cb(user, skb);
+	else {
+		dev_err(dev->dev,
+			"Could not find corresponding user to h4_channel %d\n",
+			h4_channel);
+		kfree_skb(skb);
+	}
+}
+
+static void chip_removed(struct cg2900_chip_dev *dev)
+{
+	struct stlc2690_chip_info *info = dev->c_data;
+
+	mfd_remove_devices(dev->dev);
+	if (info->file_info.fw_file_ptc) {
+		release_firmware(info->file_info.fw_file_ptc);
+		info->file_info.fw_file_ptc = NULL;
+	}
+
+	if (info->file_info.fw_file_ssf) {
+		release_firmware(info->file_info.fw_file_ssf);
+		info->file_info.fw_file_ssf = NULL;
+	}
+
+	kfree(info->settings_file_name);
+	kfree(info->patch_file_name);
+	destroy_workqueue(info->wq);
+	kfree(info);
+	dev->c_data = NULL;
+	dev->c_cb.chip_removed = NULL;
+	dev->c_cb.data_from_chip = NULL;
+}
+
+/**
+ * chip_shutdown() - Reset and power the chip off.
+ */
+static void chip_shutdown(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev = cg2900_get_prv(user);
+	struct stlc2690_chip_info *info = dev->c_data;
+
+	dev_dbg(user->dev, "chip_shutdown\n");
+
+	/* Close the transport, which will power off the chip */
+	if (dev->t_cb.close)
+		dev->t_cb.close(dev);
+
+	/* Chip shut-down finished, set correct state and wake up the chip. */
+	dev_dbg(dev->dev, "New main_state: STLC2690_IDLE\n");
+	info->main_state = STLC2690_IDLE;
+	wake_up_all(&main_wait_queue);
+}
+
+static void chip_startup_finished(struct stlc2690_chip_info *info, int err)
+{
+	dev_dbg(BOOT_DEV, "chip_startup_finished (%d)\n", err);
+
+	if (err)
+		/* Shutdown the chip */
+		chip_shutdown(info->user_in_charge);
+	else {
+		dev_dbg(BOOT_DEV, "New main_state: CORE_ACTIVE\n");
+		info->main_state = STLC2690_ACTIVE;
+	}
+
+	wake_up_all(&main_wait_queue);
+
+	if (err)
+		return;
+
+	if (!info->chip_dev->t_cb.chip_startup_finished)
+		dev_err(BOOT_DEV, "chip_startup_finished callback not found\n");
+	else
+		info->chip_dev->t_cb.chip_startup_finished(info->chip_dev);
+}
+
+static int stlc2690_open(struct cg2900_user_data *user)
+{
+	int err;
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+	struct list_head *cursor;
+	struct stlc2690_channel_item *tmp;
+	struct hci_command_hdr cmd;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV, "stlc2690_open: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(user->dev, "stlc2690_open\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	mutex_lock(&main_info->man_mutex);
+
+	/* Add a minor wait in order to avoid CPU blocking, looping openings */
+	err = wait_event_timeout(main_wait_queue,
+				 (STLC2690_IDLE == info->main_state ||
+				  STLC2690_ACTIVE == info->main_state),
+				 msecs_to_jiffies(LINE_TOGGLE_DETECT_TIMEOUT));
+	if (err <= 0) {
+		if (STLC2690_INIT == info->main_state)
+			dev_err(user->dev, "Transport not opened\n");
+		else
+			dev_err(user->dev, "stlc2690_open currently busy "\
+				"(0x%X). Try again\n", info->main_state);
+		err = -EBUSY;
+		goto err_free_mutex;
+	}
+
+	err = 0;
+
+	list_for_each(cursor, &info->open_channels) {
+		tmp = list_entry(cursor, struct stlc2690_channel_item, list);
+		if (tmp->user->h4_channel == user->h4_channel) {
+			dev_err(user->dev, "Channel %d is already opened\n",
+				user->h4_channel);
+			err = -EACCES;
+			goto err_free_mutex;
+		}
+	}
+
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp) {
+		dev_err(user->dev, "Could not allocate tmp\n");
+		err = -ENOMEM;
+		goto err_free_mutex;
+	}
+	tmp->user = user;
+
+	if (STLC2690_ACTIVE != info->main_state &&
+	    !user->chip_independent) {
+		/* Open transport and start-up the chip */
+		if (dev->t_cb.set_chip_power)
+			dev->t_cb.set_chip_power(dev, true);
+
+		/* Wait to be sure that the chip is ready */
+		schedule_timeout_killable(
+				msecs_to_jiffies(CHIP_READY_TIMEOUT));
+
+		if (dev->t_cb.open)
+			err = dev->t_cb.open(dev);
+		if (err) {
+			if (dev->t_cb.set_chip_power)
+				dev->t_cb.set_chip_power(dev, false);
+			goto err_free_list_item;
+		}
+
+		/* Start the boot sequence */
+		info->user_in_charge = user;
+		info->last_user = user;
+		dev_dbg(user->dev, "New boot_state: BOOT_RESET\n");
+		info->boot_state = BOOT_RESET;
+		dev_dbg(user->dev, "New main_state: STLC2690_BOOTING\n");
+		info->main_state = STLC2690_BOOTING;
+		cmd.opcode = cpu_to_le16(HCI_OP_RESET);
+		cmd.plen = 0; /* No parameters for HCI reset */
+		cg2900_send_bt_cmd(user, info->logger, &cmd, sizeof(cmd),
+				CHANNEL_BT_CMD);
+
+		dev_dbg(user->dev, "Wait up to 15 seconds for chip to start\n");
+		wait_event_timeout(main_wait_queue,
+				   (STLC2690_ACTIVE == info->main_state ||
+				    STLC2690_IDLE   == info->main_state),
+				   msecs_to_jiffies(CHIP_STARTUP_TIMEOUT));
+		if (STLC2690_ACTIVE != info->main_state) {
+			dev_err(user->dev, "STLC2690 driver failed to start\n");
+
+			if (dev->t_cb.close)
+				dev->t_cb.close(dev);
+
+			dev_dbg(user->dev, "New main_state: CORE_IDLE\n");
+			info->main_state = STLC2690_IDLE;
+			err = -EIO;
+			goto err_free_list_item;
+		}
+	}
+
+	list_add_tail(&tmp->list, &info->open_channels);
+
+	user->opened = true;
+
+	dev_dbg(user->dev, "H:4 channel opened\n");
+
+	mutex_unlock(&main_info->man_mutex);
+	return 0;
+err_free_list_item:
+	kfree(tmp);
+err_free_mutex:
+	mutex_unlock(&main_info->man_mutex);
+	return err;
+}
+
+static int stlc2690_hci_log_open(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+	int err;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"stlc2690_hci_log_open: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(user->dev, "stlc2690_hci_log_open\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	if (info->logger) {
+		dev_err(user->dev, "HCI Logger already stored\n");
+		return -EACCES;
+	}
+
+	info->logger = user;
+	err = stlc2690_open(user);
+	if (err)
+		info->logger = NULL;
+	return err;
+}
+
+static void stlc2690_close(struct cg2900_user_data *user)
+{
+	bool keep_powered = false;
+	struct list_head *cursor, *next;
+	struct stlc2690_channel_item *tmp;
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"stlc2690_close: Calling with NULL pointer\n");
+		return;
+	}
+
+	dev_dbg(user->dev, "stlc2690_close\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	mutex_lock(&main_info->man_mutex);
+
+	/*
+	 * Go through each open channel. Remove our channel and check if there
+	 * is any other channel that want to keep the chip running
+	 */
+	list_for_each_safe(cursor, next, &info->open_channels) {
+		tmp = list_entry(cursor, struct stlc2690_channel_item, list);
+		if (tmp->user == user) {
+			list_del(cursor);
+			kfree(tmp);
+		} else if (!tmp->user->chip_independent)
+			keep_powered = true;
+	}
+
+	if (keep_powered)
+		/* This was not the last user, we're done. */
+		goto finished;
+
+	if (STLC2690_IDLE == info->main_state)
+		/* Chip has already been shut down. */
+		goto finished;
+
+	dev_dbg(user->dev, "New main_state: CORE_CLOSING\n");
+	info->main_state = STLC2690_CLOSING;
+	chip_shutdown(user);
+
+	dev_dbg(user->dev, "Wait up to 15 seconds for chip to shut-down\n");
+	wait_event_timeout(main_wait_queue,
+			   STLC2690_IDLE == info->main_state,
+			   msecs_to_jiffies(CHIP_SHUTDOWN_TIMEOUT));
+
+	/* Force shutdown if we timed out */
+	if (STLC2690_IDLE != info->main_state) {
+		dev_err(user->dev,
+			"ST-Ericsson STLC2690 Core Driver was shut-down with "
+			"problems\n");
+
+		if (dev->t_cb.close)
+			dev->t_cb.close(dev);
+
+		dev_dbg(user->dev, "New main_state: CORE_IDLE\n");
+		info->main_state = STLC2690_IDLE;
+	}
+
+finished:
+	mutex_unlock(&main_info->man_mutex);
+	user->opened = false;
+	dev_dbg(user->dev, "H:4 channel closed\n");
+}
+
+static void stlc2690_hci_log_close(struct cg2900_user_data *user)
+{
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"stlc2690_hci_log_close: Calling with NULL pointer\n");
+		return;
+	}
+
+	dev_dbg(user->dev, "stlc2690_hci_log_close\n");
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	info->logger = NULL;
+	stlc2690_close(user);
+}
+
+static int stlc2690_reset(struct cg2900_user_data *user)
+{
+	struct list_head *cursor, *next;
+	struct stlc2690_channel_item *tmp;
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"stlc2690_reset: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	dev_info(user->dev, "stlc2690_reset\n");
+
+	BUG_ON(!main_info);
+
+	mutex_lock(&main_info->man_mutex);
+
+	dev_dbg(user->dev, "New main_state: CORE_RESETING\n");
+	info->main_state = STLC2690_RESETING;
+
+	chip_shutdown(user);
+
+	/*
+	 * Inform all opened channels about the reset and free the user devices
+	 */
+	list_for_each_safe(cursor, next, &info->open_channels) {
+		tmp = list_entry(cursor, struct stlc2690_channel_item, list);
+		list_del(cursor);
+		tmp->user->opened = false;
+		tmp->user->reset_cb(tmp->user);
+		kfree(tmp);
+	}
+
+	/* Reset finished. We are now idle until first channel is opened */
+	dev_dbg(user->dev, "New main_state: STLC2690_IDLE\n");
+	info->main_state = STLC2690_IDLE;
+
+	mutex_unlock(&main_info->man_mutex);
+
+	/*
+	 * Send wake-up since this might have been called from a failed boot.
+	 * No harm done if it is a STLC2690 chip user who called.
+	 */
+	wake_up_all(&main_wait_queue);
+
+	return 0;
+}
+
+static struct sk_buff *stlc2690_alloc_skb(unsigned int size, gfp_t priority)
+{
+	struct sk_buff *skb;
+
+	dev_dbg(MAIN_DEV, "stlc2690_alloc_skb size %d bytes\n", size);
+
+	/* Allocate the SKB and reserve space for the header */
+	skb = alloc_skb(size + CG2900_SKB_RESERVE, priority);
+	if (skb)
+		skb_reserve(skb, CG2900_SKB_RESERVE);
+
+	return skb;
+}
+
+static int stlc2690_write(struct cg2900_user_data *user, struct sk_buff *skb)
+{
+	int err = 0;
+	u8 *h4_header;
+	struct cg2900_chip_dev *dev;
+	struct stlc2690_chip_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV,
+			"stlc2690_write: Calling with NULL pointer\n");
+		return -EINVAL;
+	}
+
+	if (!skb) {
+		dev_err(user->dev, "stlc2690_write with no sk_buffer\n");
+		return -EINVAL;
+	}
+
+	dev = cg2900_get_prv(user);
+	info = dev->c_data;
+
+	dev_dbg(user->dev, "stlc2690_write length %d bytes\n", skb->len);
+
+	if (!user->opened) {
+		dev_err(user->dev,
+			"Trying to transmit data on a closed channel\n");
+		return -EACCES;
+	}
+
+	/*
+	 * Move the data pointer to the H:4 header position and
+	 * store the H4 header.
+	 */
+	h4_header = skb_push(skb, CG2900_SKB_RESERVE);
+	*h4_header = (u8)user->h4_channel;
+	cg2900_tx_to_chip(user, info->logger, skb);
+
+	return err;
+}
+
+static int stlc2690_no_write(struct cg2900_user_data *user,
+			     struct sk_buff *skb)
+{
+	dev_err(user->dev, "Not allowed to send on this channel\n");
+	return -EPERM;
+}
+
+static bool stlc2690_get_local_revision(struct cg2900_user_data *user,
+					struct cg2900_rev_data *rev_data)
+{
+	struct cg2900_chip_dev *dev;
+
+	BUG_ON(!main_info);
+
+	if (!user) {
+		dev_err(MAIN_DEV, "stlc2690_get_local_revision: Calling with "\
+			"NULL pointer\n");
+		return false;
+	}
+
+	if (!rev_data) {
+		dev_err(user->dev, "Calling with rev_data NULL\n");
+		return false;
+	}
+
+	dev = cg2900_get_prv(user);
+
+	rev_data->revision = dev->chip.hci_revision;
+	rev_data->sub_version = dev->chip.hci_sub_version;
+
+	return true;
+}
+
+static struct cg2900_user_data btcmd_data = {
+	.h4_channel = CHANNEL_BT_CMD,
+};
+static struct cg2900_user_data btacl_data = {
+	.h4_channel = CHANNEL_BT_ACL,
+};
+static struct cg2900_user_data btevt_data = {
+	.h4_channel = CHANNEL_BT_EVT,
+};
+static struct cg2900_user_data hci_logger_data = {
+	.h4_channel = CHANNEL_HCI_LOGGER,
+	.chip_independent = true,
+	.write = stlc2690_no_write,
+	.open = stlc2690_hci_log_open,
+	.close = stlc2690_hci_log_close,
+};
+static struct cg2900_user_data core_data = {
+	.h4_channel = CHANNEL_CORE,
+	.write = stlc2690_no_write,
+};
+
+static struct mfd_cell stlc2690_devs[] = {
+	{
+		.name = "cg2900-btcmd",
+		.platform_data = &btcmd_data,
+		.pdata_size = sizeof(btcmd_data),
+	},
+	{
+		.name = "cg2900-btacl",
+		.platform_data = &btacl_data,
+		.pdata_size = sizeof(btacl_data),
+	},
+	{
+		.name = "cg2900-btevt",
+		.platform_data = &btevt_data,
+		.pdata_size = sizeof(btevt_data),
+	},
+	{
+		.name = "cg2900-hcilogger",
+		.platform_data = &hci_logger_data,
+		.pdata_size = sizeof(hci_logger_data),
+	},
+	{
+		.name = "cg2900-core",
+		.platform_data = &core_data,
+		.pdata_size = sizeof(core_data),
+	},
+};
+
+static struct cg2900_user_data char_btcmd_data = {
+	.channel_data = {
+		.char_dev_name = STLC2690_BT_CMD,
+	},
+	.h4_channel = CHANNEL_BT_CMD,
+};
+static struct cg2900_user_data char_btacl_data = {
+	.channel_data = {
+		.char_dev_name = STLC2690_BT_ACL,
+	},
+	.h4_channel = CHANNEL_BT_ACL,
+};
+static struct cg2900_user_data char_btevt_data = {
+	.channel_data = {
+		.char_dev_name = STLC2690_BT_EVT,
+	},
+	.h4_channel = CHANNEL_BT_EVT,
+};
+static struct cg2900_user_data char_hci_logger_data = {
+	.channel_data = {
+		.char_dev_name = STLC2690_HCI_LOGGER,
+	},
+	.h4_channel = CHANNEL_HCI_LOGGER,
+	.chip_independent = true,
+	.write = stlc2690_no_write,
+	.open = stlc2690_hci_log_open,
+	.close = stlc2690_hci_log_close,
+};
+static struct cg2900_user_data char_core_data = {
+	.channel_data = {
+		.char_dev_name = STLC2690_CORE,
+	},
+	.h4_channel = CHANNEL_CORE,
+	.write = stlc2690_no_write,
+};
+
+static struct mfd_cell stlc2690_char_devs[] = {
+	{
+		.name = "cg2900-chardev",
+		.id = 0,
+		.platform_data = &char_btcmd_data,
+		.pdata_size = sizeof(char_btcmd_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 1,
+		.platform_data = &char_btacl_data,
+		.pdata_size = sizeof(char_btacl_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 2,
+		.platform_data = &char_btevt_data,
+		.pdata_size = sizeof(char_btevt_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 7,
+		.platform_data = &char_hci_logger_data,
+		.pdata_size = sizeof(char_hci_logger_data),
+	},
+	{
+		.name = "cg2900-chardev",
+		.id = 8,
+		.platform_data = &char_core_data,
+		.pdata_size = sizeof(char_core_data),
+	},
+};
+
+/**
+ * set_plat_data() - Initializes data for an MFD cell.
+ * @cell:	MFD cell.
+ * @dev:	Current chip.
+ *
+ * Sets each callback to default function unless already set.
+ */
+static void set_plat_data(struct mfd_cell *cell, struct cg2900_chip_dev *dev)
+{
+	struct cg2900_user_data *user = cell->platform_data;
+
+	if (!user->open)
+		user->open = stlc2690_open;
+	if (!user->close)
+		user->close = stlc2690_close;
+	if (!user->reset)
+		user->reset = stlc2690_reset;
+	if (!user->alloc_skb)
+		user->alloc_skb = stlc2690_alloc_skb;
+	if (!user->write)
+		user->write = stlc2690_write;
+	if (!user->get_local_revision)
+		user->get_local_revision = stlc2690_get_local_revision;
+
+	cg2900_set_prv(user, dev);
+}
+
+/**
+ * fetch_firmware_files() - Do a request_firmware for ssf/ptc files.
+ * @dev:	Chip info structure.
+ *
+ * Returns:
+ *   system wide error.
+ */
+static int fetch_firmware_files(struct cg2900_chip_dev *dev,
+		struct stlc2690_chip_info *info)
+{
+	int filename_size_ptc = strlen("STLC2690_XXXX_XXXX_patch.fw");
+	int filename_size_ssf = strlen("STLC2690_XXXX_XXXX_settings.fw");
+	int err;
+
+	/*
+	 * Create the patch file name from HCI revision and sub_version.
+	 * filename_size_ptc does not include terminating NULL character
+	 * so add 1.
+	 */
+	err = snprintf(info->patch_file_name, filename_size_ptc + 1,
+			"STLC2690_%04X_%04X_patch.fw", dev->chip.hci_revision,
+			dev->chip.hci_sub_version);
+	if (err == filename_size_ptc) {
+		dev_dbg(BOOT_DEV, "Downloading patch file %s\n",
+				info->patch_file_name);
+	} else {
+		dev_err(BOOT_DEV, "Patch file name failed! err=%d\n", err);
+		goto error_handling;
+	}
+
+	/* OK. Now it is time to download the patches */
+	err = request_firmware(&(info->file_info.fw_file_ptc),
+			info->patch_file_name,
+			dev->dev);
+	if (err < 0) {
+		dev_err(BOOT_DEV, "Couldn't get patch file "\
+				"(%d)\n", err);
+		goto error_handling;
+	}
+
+	/*
+	 * Create the settings file name from HCI revision and sub_version.
+	 * filename_size_ssf does not include terminating NULL character
+	 * so add 1.
+	 */
+	err = snprintf(info->settings_file_name, filename_size_ssf + 1,
+			"STLC2690_%04X_%04X_settings.fw",
+			dev->chip.hci_revision, dev->chip.hci_sub_version);
+	if (err == filename_size_ssf) {
+		dev_dbg(BOOT_DEV, "Downloading settings file %s\n",
+				info->settings_file_name);
+	} else {
+		dev_err(BOOT_DEV, "Settings file name failed! err=%d\n", err);
+		goto error_handling;
+	}
+
+	/* Retrieve the settings file */
+	err = request_firmware(&info->file_info.fw_file_ssf,
+			info->settings_file_name,
+			dev->dev);
+	if (err) {
+		dev_err(BOOT_DEV, "Couldn't get settings file "\
+				"(%d)\n", err);
+		goto error_handling;
+	}
+
+	return 0;
+
+error_handling:
+	if (info->file_info.fw_file_ptc) {
+		release_firmware(info->file_info.fw_file_ptc);
+		info->file_info.fw_file_ptc = NULL;
+	}
+
+	if (info->file_info.fw_file_ssf) {
+		release_firmware(info->file_info.fw_file_ssf);
+		info->file_info.fw_file_ssf = NULL;
+	}
+
+	return err;
+}
+
+/**
+ * check_chip_support() - Checks if connected chip is handled by this driver.
+ * @dev:	Chip info structure.
+ *
+ * If supported return true and fill in @callbacks.
+ *
+ * Returns:
+ *   true if chip is handled by this driver.
+ *   false otherwise.
+ */
+static bool check_chip_support(struct cg2900_chip_dev *dev)
+{
+	struct cg2900_platform_data *pf_data;
+	struct stlc2690_chip_info *info;
+	int i;
+	int err;
+
+	dev_dbg(dev->dev, "check_chip_support\n");
+
+	/*
+	 * Check if this is a STLC2690 revision.
+	 * We do not care about the sub-version at the moment. Change this if
+	 * necessary.
+	 */
+	if (dev->chip.manufacturer != STLC2690_SUPP_MANUFACTURER ||
+	    dev->chip.hci_revision < STLC2690_SUPP_REVISION_MIN ||
+	    dev->chip.hci_revision > STLC2690_SUPP_REVISION_MAX) {
+		dev_dbg(dev->dev, "Chip not supported by STLC2690 driver\n"\
+			"\tMan: 0x%02X\n"\
+			"\tRev: 0x%04X\n"\
+			"\tSub: 0x%04X\n",
+			dev->chip.manufacturer, dev->chip.hci_revision,
+			dev->chip.hci_sub_version);
+		return false;
+	}
+
+	/* Store needed data */
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev->dev, "Couldn't allocate info struct\n");
+		return false;
+	}
+
+	/* Initialize all variables */
+	INIT_LIST_HEAD(&info->open_channels);
+	spin_lock_init(&info->rw_lock);
+	info->chip_dev = dev;
+
+	info->wq = create_singlethread_workqueue(WQ_NAME);
+	if (!info->wq) {
+		dev_err(dev->dev, "Could not create workqueue\n");
+		goto err_handling_free_info;
+	}
+
+	info->patch_file_name = kzalloc(NAME_MAX + 1, GFP_ATOMIC);
+	if (!info->patch_file_name) {
+		dev_err(dev->dev,
+			"Couldn't allocate name buffer for patch file\n");
+		goto err_handling_destroy_wq;
+	}
+
+	info->settings_file_name = kzalloc(NAME_MAX + 1, GFP_ATOMIC);
+	if (!info->settings_file_name) {
+		dev_err(dev->dev,
+			"Couldn't allocate name buffers settings file\n");
+		goto err_handling_free_patch_name;
+	}
+
+	err = fetch_firmware_files(dev, info);
+	if (err) {
+		dev_err(dev->dev,
+				"Couldn't fetch firmware files\n");
+		goto err_handling_free_patch_name;
+	}
+
+	dev->c_data = info;
+	/* Set the callbacks */
+	dev->c_cb.data_from_chip = data_from_chip;
+	dev->c_cb.chip_removed = chip_removed,
+	info->chip_dev = dev;
+
+	mutex_lock(&main_info->man_mutex);
+
+	pf_data = dev_get_platdata(dev->dev);
+	btcmd_data.channel_data.bt_bus = pf_data->bus;
+	btacl_data.channel_data.bt_bus = pf_data->bus;
+	btevt_data.channel_data.bt_bus = pf_data->bus;
+
+	for (i = 0; i < ARRAY_SIZE(stlc2690_devs); i++)
+		set_plat_data(&stlc2690_devs[i], dev);
+	for (i = 0; i < ARRAY_SIZE(stlc2690_char_devs); i++)
+		set_plat_data(&stlc2690_char_devs[i], dev);
+	mutex_unlock(&main_info->man_mutex);
+
+	dev_info(dev->dev, "Chip supported by the STLC2690 chip driver\n");
+
+	/* Close the transport, which will power off the chip */
+	if (dev->t_cb.close)
+		dev->t_cb.close(dev);
+
+	dev_dbg(dev->dev, "New main_state: STLC2690_IDLE\n");
+	info->main_state = STLC2690_IDLE;
+
+	err = mfd_add_devices(dev->dev, main_info->cell_base_id, stlc2690_devs,
+			      ARRAY_SIZE(stlc2690_devs), NULL, 0, NULL);
+	if (err) {
+		dev_err(dev->dev, "Failed to add stlc2690_devs (%d)\n", err);
+		goto err_handling_free_settings_name;
+	}
+
+	err = mfd_add_devices(dev->dev, main_info->cell_base_id,
+			      stlc2690_char_devs,
+			      ARRAY_SIZE(stlc2690_char_devs), NULL, 0, NULL);
+	if (err) {
+		dev_err(dev->dev, "Failed to add stlc2690_char_devs (%d)\n",
+			err);
+		goto err_handling_remove_devs;
+	}
+
+	/*
+	 * Increase base ID so next connected transport will not get the
+	 * same device IDs.
+	 */
+	main_info->cell_base_id += MAX(ARRAY_SIZE(stlc2690_devs),
+				       ARRAY_SIZE(stlc2690_char_devs));
+
+	return true;
+
+err_handling_remove_devs:
+	mfd_remove_devices(dev->dev);
+err_handling_free_settings_name:
+	kfree(info->settings_file_name);
+err_handling_free_patch_name:
+	kfree(info->patch_file_name);
+err_handling_destroy_wq:
+	destroy_workqueue(info->wq);
+err_handling_free_info:
+	kfree(info);
+	return false;
+}
+
+static struct cg2900_id_callbacks chip_support_callbacks = {
+	.check_chip_support = check_chip_support,
+};
+
+/**
+ * stlc2690_chip_probe() - Initialize STLC2690 chip handler resources.
+ * @pdev:	Platform device.
+ *
+ * This function initializes the STLC2690 driver, then registers to
+ * the CG2900 Core.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM for failed alloc or structure creation.
+ *   Error codes generated by cg2900_register_chip_driver.
+ */
+static int __devinit stlc2690_chip_probe(struct platform_device *pdev)
+{
+	int err;
+
+	dev_dbg(&pdev->dev, "stlc2690_chip_probe\n");
+
+	main_info = kzalloc(sizeof(*main_info), GFP_ATOMIC);
+	if (!main_info) {
+		dev_err(&pdev->dev, "Couldn't allocate main_info\n");
+		return -ENOMEM;
+	}
+
+	main_info->dev = &pdev->dev;
+	mutex_init(&main_info->man_mutex);
+
+	err = cg2900_register_chip_driver(&chip_support_callbacks);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Couldn't register chip driver (%d)\n", err);
+		goto error_handling;
+	}
+
+	dev_info(&pdev->dev, "STLC2690 chip driver started\n");
+
+	return 0;
+
+error_handling:
+	mutex_destroy(&main_info->man_mutex);
+	kfree(main_info);
+	main_info = NULL;
+	return err;
+}
+
+/**
+ * stlc2690_chip_remove() - Release STLC2690 chip handler resources.
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success (always success).
+ */
+static int __devexit stlc2690_chip_remove(struct platform_device *pdev)
+{
+	dev_info(&pdev->dev, "STLC2690 chip driver removed\n");
+
+	cg2900_deregister_chip_driver(&chip_support_callbacks);
+
+	if (!main_info)
+		return 0;
+
+	mutex_destroy(&main_info->man_mutex);
+	kfree(main_info);
+	main_info = NULL;
+	return 0;
+}
+
+static struct platform_driver stlc2690_chip_driver = {
+	.driver = {
+		.name	= "stlc2690-chip",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= stlc2690_chip_probe,
+	.remove	= __devexit_p(stlc2690_chip_remove),
+};
+
+/**
+ * stlc2690_chip_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init stlc2690_chip_init(void)
+{
+	pr_debug("stlc2690_chip_init");
+	return platform_driver_register(&stlc2690_chip_driver);
+}
+
+/**
+ * stlc2690_chip_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit stlc2690_chip_exit(void)
+{
+	pr_debug("stlc2690_chip_exit");
+	platform_driver_unregister(&stlc2690_chip_driver);
+}
+
+module_init(stlc2690_chip_init);
+module_exit(stlc2690_chip_exit);
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux STLC2690 Connectivity Device Driver");
diff --git a/drivers/staging/cg2900/mfd/stlc2690_chip.h b/drivers/staging/cg2900/mfd/stlc2690_chip.h
new file mode 100644
index 0000000..d14e773
--- /dev/null
+++ b/drivers/staging/cg2900/mfd/stlc2690_chip.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson STLC2690 BT/FM controller.
+ */
+
+#ifndef _STLC2690_CHIP_H_
+#define _STLC2690_CHIP_H_
+
+/* Supported chips */
+#define STLC2690_SUPP_MANUFACTURER		0x30
+#define STLC2690_SUPP_REVISION_MIN		0x0500
+#define STLC2690_SUPP_REVISION_MAX		0x06FF
+
+#define BT_SIZE_OF_HDR				(sizeof(__le16) + sizeof(__u8))
+#define BT_PARAM_LEN(__pkt_len)			(__pkt_len - BT_SIZE_OF_HDR)
+
+/* BT VS Store In FS command */
+#define STLC2690_BT_OP_VS_STORE_IN_FS		0xFC22
+struct bt_vs_store_in_fs_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	user_id;
+	__u8	len;
+	__u8	data[];
+} __packed;
+
+/* BT VS Write File Block command */
+#define STLC2690_BT_OP_VS_WRITE_FILE_BLOCK	0xFC2E
+struct bt_vs_write_file_block_cmd {
+	__le16	opcode;
+	__u8	plen;
+	__u8	id;
+	__u8	data[];
+} __packed;
+
+/* User ID for storing BD address in chip using Store_In_FS command */
+#define STLC2690_VS_STORE_IN_FS_USR_ID_BD_ADDR	0xFE
+
+#endif /* _STLC2690_CHIP_H_ */
-- 
1.6.6.1

