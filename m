Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777Ab2ENXzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:55:39 -0400
Received: from mail.gctsemi.com ([211.106.186.8]:51100 "EHLO
	KRMAIL01.gctsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab2ENXze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:55:34 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 19:55:33 EDT
From: Sage Ahn <syahn@gctsemi.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <olofj@chromium.org>, <benchan@chromium.org>,
        Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH] staging: gdm72xx: Add GCT GDM72xx WiMAX driver.
Date: Tue, 15 May 2012 08:49:36 +0900
Message-ID: <1337039376-15345-1-git-send-email-syahn@gctsemi.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-GFI-SMTP-Submission: 1
X-GFI-SMTP-HelloDomain: localhost.localdomain
X-GFI-SMTP-RemoteIP: 192.168.24.212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the kernel driver for the GDM72xx WiMAX chips
developed by GCT Semiconductor, Inc., which enables mobile WiMAX
connection on the Linux host.

Signed-off-by: Sage Ahn <syahn@gctsemi.com>
Cc: Ben Chan <benchan@chromium.org>
---
 drivers/staging/Kconfig             |    2 +
 drivers/staging/Makefile            |    1 +
 drivers/staging/gdm72xx/ChangeLog   |   88 +++
 drivers/staging/gdm72xx/Kconfig     |   45 ++
 drivers/staging/gdm72xx/LICENSE     |   26 +
 drivers/staging/gdm72xx/Makefile    |    6 +
 drivers/staging/gdm72xx/TODO        |    5 +
 drivers/staging/gdm72xx/gdm_qos.c   |  453 ++++++++++++++++
 drivers/staging/gdm72xx/gdm_qos.h   |   86 +++
 drivers/staging/gdm72xx/gdm_sdio.c  |  747 +++++++++++++++++++++++++
 drivers/staging/gdm72xx/gdm_sdio.h  |   65 +++
 drivers/staging/gdm72xx/gdm_usb.c   |  797 +++++++++++++++++++++++++++
 drivers/staging/gdm72xx/gdm_usb.h   |   78 +++
 drivers/staging/gdm72xx/gdm_wimax.c | 1018 +++++++++++++++++++++++++++++++++++
 drivers/staging/gdm72xx/gdm_wimax.h |   85 +++
 drivers/staging/gdm72xx/hci.h       |  211 ++++++++
 drivers/staging/gdm72xx/netlink_k.c |  143 +++++
 drivers/staging/gdm72xx/netlink_k.h |   17 +
 drivers/staging/gdm72xx/sdio_boot.c |  152 ++++++
 drivers/staging/gdm72xx/sdio_boot.h |   14 +
 drivers/staging/gdm72xx/usb_boot.c  |  397 ++++++++++++++
 drivers/staging/gdm72xx/usb_boot.h  |   15 +
 drivers/staging/gdm72xx/usb_ids.h   |   75 +++
 drivers/staging/gdm72xx/wm_ioctl.h  |   90 +++
 24 files changed, 4616 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/gdm72xx/ChangeLog
 create mode 100644 drivers/staging/gdm72xx/Kconfig
 create mode 100644 drivers/staging/gdm72xx/LICENSE
 create mode 100644 drivers/staging/gdm72xx/Makefile
 create mode 100644 drivers/staging/gdm72xx/TODO
 create mode 100644 drivers/staging/gdm72xx/gdm_qos.c
 create mode 100644 drivers/staging/gdm72xx/gdm_qos.h
 create mode 100644 drivers/staging/gdm72xx/gdm_sdio.c
 create mode 100644 drivers/staging/gdm72xx/gdm_sdio.h
 create mode 100644 drivers/staging/gdm72xx/gdm_usb.c
 create mode 100644 drivers/staging/gdm72xx/gdm_usb.h
 create mode 100644 drivers/staging/gdm72xx/gdm_wimax.c
 create mode 100644 drivers/staging/gdm72xx/gdm_wimax.h
 create mode 100644 drivers/staging/gdm72xx/hci.h
 create mode 100644 drivers/staging/gdm72xx/netlink_k.c
 create mode 100644 drivers/staging/gdm72xx/netlink_k.h
 create mode 100644 drivers/staging/gdm72xx/sdio_boot.c
 create mode 100644 drivers/staging/gdm72xx/sdio_boot.h
 create mode 100644 drivers/staging/gdm72xx/usb_boot.c
 create mode 100644 drivers/staging/gdm72xx/usb_boot.h
 create mode 100644 drivers/staging/gdm72xx/usb_ids.h
 create mode 100644 drivers/staging/gdm72xx/wm_ioctl.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index d6417d11..7e0e5e4 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -130,4 +130,6 @@ source "drivers/staging/ozwpan/Kconfig"
 
 source "drivers/staging/ipack/Kconfig"
 
+source "drivers/staging/gdm72xx/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index fd8b7ce..3090105 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_RAMSTER)		+= ramster/
 obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
+obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
diff --git a/drivers/staging/gdm72xx/ChangeLog b/drivers/staging/gdm72xx/ChangeLog
new file mode 100644
index 0000000..948fe4e
--- /dev/null
+++ b/drivers/staging/gdm72xx/ChangeLog
@@ -0,0 +1,88 @@
+v3.2.3
+	Patch for the message "NOHZ: local_softirq_pending 08" not to be printed.
+	Add code for WiMAX2. To use WiMAX2, change CONFIG_WIMAX2 in Makefile from
+	'n' to 'y'.
+
+v3.2.2
+	Remaining data is padded with 4bytes in send_sdio_pkt().
+	Remove warning message that is printed when netlink_send API is called.
+	Change scheduling of RX traffic.
+	Support Linux Kernel 2.6.38.
+
+v3.2.1
+	Handle SDU RXs in aggregated SDU RX one by one.
+	Check the validity of the gap between SDU TXs.
+
+v3.2.0
+	Change internal architecture of ioctl.
+	Add debug code for sdu.
+	SDIO packet aggregation for SDU.
+	Support K_mode Scan.
+
+v.3.1.3
+	Fix a bug that complete_info is not freed when device is removed.
+	In gdm_wimax_ioctl_set_data function, if the size requested is the same
+	with nic's data buffer size, the buffer is used again without re-allocation.
+
+v.3.1.2
+	Change the function name of handle_irq to gdm_sdio_irq.
+	In the kernel whose version is greater than 2.6.27, provide net_device
+	net_device_ops variable instead of operation functions.
+
+v.3.1.1
+	Support indicating network interface up/down.
+	If the HCI to let driver stop sending SDU comes from wimax device, cancel
+	all pending SDU tx. If the HCI to let drvier resume sending SDU comes from
+	wimax, send all pending SDU tx.
+	Fix a bug that SDU TX request arrives when there is no avialable tx
+	buffer.
+
+V.3.1.0
+	Support USB Selective Suspend.
+	Fix a bug in SDIO module that spin lock is not unreleased after spin lock
+	is locked.
+
+v.3.0.4
+	In big-endian system, FW loading do not work.
+
+v.3.0.3
+	If the Type-A type of a received packet through SDIO is 2, discard
+	the first 4-bytes of data part.
+
+v.3.0.2
+	Support setting/getting profile-ID.
+
+v.3.0.1
+	Fix a bug that PID's composite bit is not cleared.
+
+v.3.0
+	Remove the code to check the id of a image. This code is valid only for
+	the FW whose VID is GCT's.
+
+v.2.1.2
+	Support setting/getting connection-complte information.
+
+v.2.1.1
+	Fix how to calculate the index of wimax device.
+
+v.2.1
+	Fix a bug that CM is not working on Big-Endian machine.
+
+v.2.0
+	New host interface, SDIO is available.
+
+v.1.1
+	Support emergency downloading f/w.
+
+v.1.0
+	Change HCI interface from netdevive socket to netlink socket.
+
+v.0.2
+	Manage TX buffer.
+
+v.0.1.1
+	Bugfix:
+		1. System is locked up when device is removed in kernel v.2.4.
+		2. System is locked up when cm is executed.
+v.0.1
+	First update
diff --git a/drivers/staging/gdm72xx/Kconfig b/drivers/staging/gdm72xx/Kconfig
new file mode 100644
index 0000000..5c37cba
--- /dev/null
+++ b/drivers/staging/gdm72xx/Kconfig
@@ -0,0 +1,45 @@
+#
+# GCT GDM72xx WiMAX driver configuration
+#
+
+menuconfig WIMAX_GDM72XX
+	tristate "GCT GDM72xx WiMAX support"
+	help
+	  Support for the GCT GDM72xx WiMAX chip
+
+if WIMAX_GDM72XX
+
+config WIMAX_GDM72XX_QOS
+	bool "Enable QoS support"
+	default n
+
+config WIMAX_GDM72XX_K_MODE
+	bool "Enable K mode"
+	default n
+
+config WIMAX_GDM72XX_WIMAX2
+	bool "Enable WIMAX2 support"
+	default n
+
+choice
+	prompt "Select interface"
+
+config WIMAX_GDM72XX_USB
+	bool "USB interface"
+	depends on USB
+
+config WIMAX_GDM72XX_SDIO
+	bool "SDIO interface"
+	depends on MMC
+
+endchoice
+
+if WIMAX_GDM72XX_USB
+
+config WIMAX_GDM72XX_USB_PM
+	bool "Enable power managerment support"
+	default n
+
+endif # WIMAX_GDM72XX_USB
+
+endif # WIMAX_GDM72XX
diff --git a/drivers/staging/gdm72xx/LICENSE b/drivers/staging/gdm72xx/LICENSE
new file mode 100644
index 0000000..99154af
--- /dev/null
+++ b/drivers/staging/gdm72xx/LICENSE
@@ -0,0 +1,26 @@
+Copyright (c) 2012, GCT Semiconductor, Inc. All rights reserved.
+
+Redistribution and use in source and binary forms, with or without
+modification, are permitted provided that the following conditions are met:
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in the
+      documentation and/or other materials provided with the distribution.
+    * Neither the name of GCT Semiconductor, Inc. nor
+      the names of its contributors may be used to endorse or promote
+      products derived from this software without specific prior written
+      permission.
+
+
+THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
+LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGE.
diff --git a/drivers/staging/gdm72xx/Makefile b/drivers/staging/gdm72xx/Makefile
new file mode 100644
index 0000000..35da7b9
--- /dev/null
+++ b/drivers/staging/gdm72xx/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_WIMAX_GDM72XX) := gdmwm.o
+
+gdmwm-y += gdm_wimax.o netlink_k.o
+gdmwm-$(CONFIG_WIMAX_GDM72XX_QOS) += gdm_qos.o
+gdmwm-$(CONFIG_WIMAX_GDM72XX_SDIO) += gdm_sdio.o sdio_boot.o
+gdmwm-$(CONFIG_WIMAX_GDM72XX_USB) += gdm_usb.o usb_boot.o
diff --git a/drivers/staging/gdm72xx/TODO b/drivers/staging/gdm72xx/TODO
new file mode 100644
index 0000000..30ac01a
--- /dev/null
+++ b/drivers/staging/gdm72xx/TODO
@@ -0,0 +1,5 @@
+TODO:
+- Replace kernel_thread with kthread in gdm_usb.c
+- Replace hard-coded firmware paths with request_firmware in
+  sdio_boot.c and usb_boot.c
+- Clean up coding style to meet kernel standard.
diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
new file mode 100644
index 0000000..2047d23
--- /dev/null
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -0,0 +1,453 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#include <linux/version.h>
+#include <linux/etherdevice.h>
+#include <asm/byteorder.h>
+
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/if_ether.h>
+
+#include "gdm_wimax.h"
+#include "hci.h"
+#include "gdm_qos.h"
+
+#define B2H(x)		__be16_to_cpu(x)
+
+#undef dprintk
+#define dprintk(fmt, args ...) printk(KERN_DEBUG "[QoS] " fmt, ## args)
+#undef wprintk
+#define wprintk(fmt, args ...) \
+	printk(KERN_WARNING "[QoS WARNING] " fmt, ## args)
+#undef eprintk
+#define eprintk(fmt, args ...) printk(KERN_ERR "[QoS ERROR] " fmt, ## args)
+
+
+#define MAX_FREE_LIST_CNT		32
+static struct {
+	struct list_head head;
+	int cnt;
+	spinlock_t lock;
+} qos_free_list;
+
+static void init_qos_entry_list(void)
+{
+	qos_free_list.cnt = 0;
+	INIT_LIST_HEAD(&qos_free_list.head);
+	spin_lock_init(&qos_free_list.lock);
+}
+
+static void *alloc_qos_entry(void)
+{
+	struct qos_entry_s *entry;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qos_free_list.lock, flags);
+	if (qos_free_list.cnt) {
+		entry = list_entry(qos_free_list.head.prev, struct qos_entry_s,
+					list);
+		list_del(&entry->list);
+		qos_free_list.cnt--;
+		spin_unlock_irqrestore(&qos_free_list.lock, flags);
+		return entry;
+	}
+	spin_unlock_irqrestore(&qos_free_list.lock, flags);
+
+	entry = kmalloc(sizeof(struct qos_entry_s), GFP_ATOMIC);
+	return entry;
+}
+
+static void free_qos_entry(void *entry)
+{
+	struct qos_entry_s *qentry = (struct qos_entry_s *) entry;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qos_free_list.lock, flags);
+	if (qos_free_list.cnt < MAX_FREE_LIST_CNT) {
+		list_add(&qentry->list, &qos_free_list.head);
+		qos_free_list.cnt++;
+		spin_unlock_irqrestore(&qos_free_list.lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&qos_free_list.lock, flags);
+
+	kfree(entry);
+}
+
+static void free_qos_entry_list(struct list_head *free_list)
+{
+	struct qos_entry_s *entry, *n;
+	int total_free = 0;
+
+	list_for_each_entry_safe(entry, n, free_list, list) {
+		list_del(&entry->list);
+		kfree(entry);
+		total_free++;
+	}
+
+	dprintk("%s: total_free_cnt=%d\n", __func__, total_free);
+}
+
+void gdm_qos_init(void *nic_ptr)
+{
+	struct nic *nic = nic_ptr;
+	struct qos_cb_s *qcb = &nic->qos;
+	int i;
+
+	for (i = 0 ; i < QOS_MAX; i++) {
+		INIT_LIST_HEAD(&qcb->qos_list[i]);
+		qcb->csr[i].QoSBufCount = 0;
+		qcb->csr[i].Enabled = 0;
+	}
+
+	qcb->qos_list_cnt = 0;
+	qcb->qos_null_idx = QOS_MAX-1;
+	qcb->qos_limit_size = 255;
+
+	spin_lock_init(&qcb->qos_lock);
+
+	init_qos_entry_list();
+}
+
+void gdm_qos_release_list(void *nic_ptr)
+{
+	struct nic *nic = nic_ptr;
+	struct qos_cb_s *qcb = &nic->qos;
+	unsigned long flags;
+	struct qos_entry_s *entry, *n;
+	struct list_head free_list;
+	int i;
+
+	INIT_LIST_HEAD(&free_list);
+
+	spin_lock_irqsave(&qcb->qos_lock, flags);
+
+	for (i = 0; i < QOS_MAX; i++) {
+		qcb->csr[i].QoSBufCount = 0;
+		qcb->csr[i].Enabled = 0;
+	}
+
+	qcb->qos_list_cnt = 0;
+	qcb->qos_null_idx = QOS_MAX-1;
+
+	for (i = 0; i < QOS_MAX; i++) {
+		list_for_each_entry_safe(entry, n, &qcb->qos_list[i], list) {
+			list_move_tail(&entry->list, &free_list);
+		}
+	}
+	spin_unlock_irqrestore(&qcb->qos_lock, flags);
+	free_qos_entry_list(&free_list);
+}
+
+static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *Stream, u8 *port)
+{
+	int i;
+
+	if (csr->ClassifierRuleEnable&IPTYPEOFSERVICE) {
+		if (((Stream[1] & csr->IPToSMask) < csr->IPToSLow) ||
+		((Stream[1] & csr->IPToSMask) > csr->IPToSHigh))
+			return 1;
+	}
+
+	if (csr->ClassifierRuleEnable&PROTOCOL) {
+		if (Stream[9] != csr->Protocol)
+			return 1;
+	}
+
+	if (csr->ClassifierRuleEnable&IPMASKEDSRCADDRESS) {
+		for (i = 0; i < 4; i++) {
+			if ((Stream[12 + i] & csr->IPSrcAddrMask[i]) !=
+			(csr->IPSrcAddr[i] & csr->IPSrcAddrMask[i]))
+				return 1;
+		}
+	}
+
+	if (csr->ClassifierRuleEnable&IPMASKEDDSTADDRESS) {
+		for (i = 0; i < 4; i++) {
+			if ((Stream[16 + i] & csr->IPDstAddrMask[i]) !=
+			(csr->IPDstAddr[i] & csr->IPDstAddrMask[i]))
+				return 1;
+		}
+	}
+
+	if (csr->ClassifierRuleEnable&PROTOCOLSRCPORTRANGE) {
+		i = ((port[0]<<8)&0xff00)+port[1];
+		if ((i < csr->SrcPortLow) || (i > csr->SrcPortHigh))
+			return 1;
+	}
+
+	if (csr->ClassifierRuleEnable&PROTOCOLDSTPORTRANGE) {
+		i = ((port[2]<<8)&0xff00)+port[3];
+		if ((i < csr->DstPortLow) || (i > csr->DstPortHigh))
+			return 1;
+	}
+
+	return 0;
+}
+
+static u32 get_qos_index(struct nic *nic, u8* iph, u8* tcpudph)
+{
+	u32	IP_Ver, Header_Len, i;
+	struct qos_cb_s *qcb = &nic->qos;
+
+	if (iph == NULL || tcpudph == NULL)
+		return -1;
+
+	IP_Ver = (iph[0]>>4)&0xf;
+	Header_Len = iph[0]&0xf;
+
+	if (IP_Ver == 4) {
+		for (i = 0; i < QOS_MAX; i++) {
+			if (qcb->csr[i].Enabled) {
+				if (qcb->csr[i].ClassifierRuleEnable) {
+					if (chk_ipv4_rule(&qcb->csr[i], iph,
+					tcpudph) == 0)
+						return i;
+				}
+			}
+		}
+	}
+
+	return -1;
+}
+
+static u32 extract_qos_list(struct nic *nic, struct list_head *head)
+{
+	struct qos_cb_s *qcb = &nic->qos;
+	struct qos_entry_s *entry;
+	int i;
+
+	INIT_LIST_HEAD(head);
+
+	for (i = 0; i < QOS_MAX; i++) {
+		if (qcb->csr[i].Enabled) {
+			if (qcb->csr[i].QoSBufCount < qcb->qos_limit_size) {
+				if (!list_empty(&qcb->qos_list[i])) {
+					entry = list_entry(
+					qcb->qos_list[i].prev,
+					struct qos_entry_s, list);
+					list_move_tail(&entry->list, head);
+					qcb->csr[i].QoSBufCount++;
+
+					if (!list_empty(&qcb->qos_list[i]))
+						wprintk("QoS Index(%d) "
+							"is piled!!\n", i);
+				}
+			}
+		}
+	}
+
+	return 0;
+}
+
+static void send_qos_list(struct nic *nic, struct list_head *head)
+{
+	struct qos_entry_s *entry, *n;
+
+	list_for_each_entry_safe(entry, n, head, list) {
+		list_del(&entry->list);
+		free_qos_entry(entry);
+		gdm_wimax_send_tx(entry->skb, entry->dev);
+	}
+}
+
+int gdm_qos_send_hci_pkt(struct sk_buff *skb, struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	int index;
+	struct qos_cb_s *qcb = &nic->qos;
+	unsigned long flags;
+	struct ethhdr *ethh = (struct ethhdr *) (skb->data + HCI_HEADER_SIZE);
+	struct iphdr *iph = (struct iphdr *) ((char *) ethh + ETH_HLEN);
+	struct tcphdr *tcph;
+	struct qos_entry_s *entry = NULL;
+	struct list_head send_list;
+	int ret = 0;
+
+	tcph = (struct tcphdr *) iph + iph->ihl*4;
+
+	if (B2H(ethh->h_proto) == ETH_P_IP) {
+		if (qcb->qos_list_cnt && !qos_free_list.cnt) {
+			entry = alloc_qos_entry();
+			entry->skb = skb;
+			entry->dev = dev;
+			dprintk("qcb->qos_list_cnt=%d\n", qcb->qos_list_cnt);
+		}
+
+		spin_lock_irqsave(&qcb->qos_lock, flags);
+		if (qcb->qos_list_cnt) {
+			index = get_qos_index(nic, (u8 *)iph, (u8 *) tcph);
+			if (index == -1)
+				index = qcb->qos_null_idx;
+
+			if (!entry) {
+				entry = alloc_qos_entry();
+				entry->skb = skb;
+				entry->dev = dev;
+			}
+
+			list_add_tail(&entry->list, &qcb->qos_list[index]);
+			extract_qos_list(nic, &send_list);
+			spin_unlock_irqrestore(&qcb->qos_lock, flags);
+			send_qos_list(nic, &send_list);
+			goto out;
+		}
+		spin_unlock_irqrestore(&qcb->qos_lock, flags);
+		if (entry)
+			free_qos_entry(entry);
+	}
+
+	ret = gdm_wimax_send_tx(skb, dev);
+out:
+	return ret;
+}
+
+static u32 get_csr(struct qos_cb_s *qcb, u32 SFID, int mode)
+{
+	int i;
+
+	for (i = 0; i < qcb->qos_list_cnt; i++) {
+		if (qcb->csr[i].SFID == SFID)
+			return i;
+	}
+
+	if (mode) {
+		for (i = 0; i < QOS_MAX; i++) {
+			if (qcb->csr[i].Enabled == 0) {
+				qcb->csr[i].Enabled = 1;
+				qcb->qos_list_cnt++;
+				return i;
+			}
+		}
+	}
+	return -1;
+}
+
+#define QOS_CHANGE_DEL	0xFC
+#define QOS_ADD		0xFD
+#define QOS_REPORT	0xFE
+
+void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
+{
+	struct nic *nic = nic_ptr;
+	u32 i, SFID, index, pos;
+	u8 subCmdEvt;
+	u8 len;
+	struct qos_cb_s *qcb = &nic->qos;
+	struct qos_entry_s *entry, *n;
+	struct list_head send_list;
+	struct list_head free_list;
+	unsigned long flags;
+
+	subCmdEvt = (u8)buf[4];
+
+	if (subCmdEvt == QOS_REPORT) {
+		len = (u8)buf[5];
+
+		spin_lock_irqsave(&qcb->qos_lock, flags);
+		for (i = 0; i < qcb->qos_list_cnt; i++) {
+			SFID = ((buf[(i*5)+6]<<24)&0xff000000);
+			SFID += ((buf[(i*5)+7]<<16)&0xff0000);
+			SFID += ((buf[(i*5)+8]<<8)&0xff00);
+			SFID += (buf[(i*5)+9]);
+			index = get_csr(qcb, SFID, 0);
+			if (index == -1) {
+				spin_unlock_irqrestore(&qcb->qos_lock, flags);
+				eprintk("QoS ERROR: No SF\n");
+				return;
+			}
+			qcb->csr[index].QoSBufCount = buf[(i*5)+10];
+		}
+
+		extract_qos_list(nic, &send_list);
+		spin_unlock_irqrestore(&qcb->qos_lock, flags);
+		send_qos_list(nic, &send_list);
+		return;
+	} else if (subCmdEvt == QOS_ADD) {
+		pos = 5;
+		len = (u8)buf[pos++];
+
+		SFID = ((buf[pos++]<<24)&0xff000000);
+		SFID += ((buf[pos++]<<16)&0xff0000);
+		SFID += ((buf[pos++]<<8)&0xff00);
+		SFID += (buf[pos++]);
+
+		index = get_csr(qcb, SFID, 1);
+		if (index == -1) {
+			eprintk("QoS ERROR: csr Update Error\n");
+			return;
+		}
+
+		dprintk("QOS_ADD SFID = 0x%x, index=%d\n", SFID, index);
+
+		spin_lock_irqsave(&qcb->qos_lock, flags);
+		qcb->csr[index].SFID = SFID;
+		qcb->csr[index].ClassifierRuleEnable = ((buf[pos++]<<8)&0xff00);
+		qcb->csr[index].ClassifierRuleEnable += buf[pos++];
+		if (qcb->csr[index].ClassifierRuleEnable == 0)
+			qcb->qos_null_idx = index;
+		qcb->csr[index].IPToSMask = buf[pos++];
+		qcb->csr[index].IPToSLow = buf[pos++];
+		qcb->csr[index].IPToSHigh = buf[pos++];
+		qcb->csr[index].Protocol = buf[pos++];
+		qcb->csr[index].IPSrcAddrMask[0] = buf[pos++];
+		qcb->csr[index].IPSrcAddrMask[1] = buf[pos++];
+		qcb->csr[index].IPSrcAddrMask[2] = buf[pos++];
+		qcb->csr[index].IPSrcAddrMask[3] = buf[pos++];
+		qcb->csr[index].IPSrcAddr[0] = buf[pos++];
+		qcb->csr[index].IPSrcAddr[1] = buf[pos++];
+		qcb->csr[index].IPSrcAddr[2] = buf[pos++];
+		qcb->csr[index].IPSrcAddr[3] = buf[pos++];
+		qcb->csr[index].IPDstAddrMask[0] = buf[pos++];
+		qcb->csr[index].IPDstAddrMask[1] = buf[pos++];
+		qcb->csr[index].IPDstAddrMask[2] = buf[pos++];
+		qcb->csr[index].IPDstAddrMask[3] = buf[pos++];
+		qcb->csr[index].IPDstAddr[0] = buf[pos++];
+		qcb->csr[index].IPDstAddr[1] = buf[pos++];
+		qcb->csr[index].IPDstAddr[2] = buf[pos++];
+		qcb->csr[index].IPDstAddr[3] = buf[pos++];
+		qcb->csr[index].SrcPortLow = ((buf[pos++]<<8)&0xff00);
+		qcb->csr[index].SrcPortLow += buf[pos++];
+		qcb->csr[index].SrcPortHigh = ((buf[pos++]<<8)&0xff00);
+		qcb->csr[index].SrcPortHigh += buf[pos++];
+		qcb->csr[index].DstPortLow = ((buf[pos++]<<8)&0xff00);
+		qcb->csr[index].DstPortLow += buf[pos++];
+		qcb->csr[index].DstPortHigh = ((buf[pos++]<<8)&0xff00);
+		qcb->csr[index].DstPortHigh += buf[pos++];
+
+		qcb->qos_limit_size = 254/qcb->qos_list_cnt;
+		spin_unlock_irqrestore(&qcb->qos_lock, flags);
+	} else if (subCmdEvt == QOS_CHANGE_DEL) {
+		pos = 5;
+		len = (u8)buf[pos++];
+		SFID = ((buf[pos++]<<24)&0xff000000);
+		SFID += ((buf[pos++]<<16)&0xff0000);
+		SFID += ((buf[pos++]<<8)&0xff00);
+		SFID += (buf[pos++]);
+		index = get_csr(qcb, SFID, 1);
+		if (index == -1) {
+			eprintk("QoS ERROR: Wrong index(%d)\n", index);
+			return;
+		}
+
+		dprintk("QOS_CHANGE_DEL SFID = 0x%x, index=%d\n", SFID, index);
+
+		INIT_LIST_HEAD(&free_list);
+
+		spin_lock_irqsave(&qcb->qos_lock, flags);
+		qcb->csr[index].Enabled = 0;
+		qcb->qos_list_cnt--;
+		qcb->qos_limit_size = 254/qcb->qos_list_cnt;
+
+		list_for_each_entry_safe(entry, n, &qcb->qos_list[index],
+					list) {
+			list_move_tail(&entry->list, &free_list);
+		}
+		spin_unlock_irqrestore(&qcb->qos_lock, flags);
+		free_qos_entry_list(&free_list);
+	}
+}
diff --git a/drivers/staging/gdm72xx/gdm_qos.h b/drivers/staging/gdm72xx/gdm_qos.h
new file mode 100644
index 0000000..8fc3ba2
--- /dev/null
+++ b/drivers/staging/gdm72xx/gdm_qos.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#if !defined(GDM_QOS_H_20090403)
+#define GDM_QOS_H_20090403
+
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/list.h>
+
+#define BOOLEAN	u8
+
+#define QOS_MAX						16
+#define IPTYPEOFSERVICE				0x8000
+#define	PROTOCOL				0x4000
+#define	IPMASKEDSRCADDRESS			0x2000
+#define	IPMASKEDDSTADDRESS			0x1000
+#define	PROTOCOLSRCPORTRANGE		0x800
+#define	PROTOCOLDSTPORTRANGE		0x400
+#define	DSTMACADDR					0x200
+#define	SRCMACADDR					0x100
+#define	ETHERTYPE					0x80
+#define	IEEE802_1DUSERPRIORITY		0x40
+#define	IEEE802_1QVLANID			0x10
+
+struct gdm_wimax_csr_s {
+	/*	union{
+		U16 all;
+		struct _CS_CLASSIFIER_RULE_ENABLE{
+			IPTypeOfService:1,
+			Protocol:1,
+			IPMaskedSrcAddress:1,
+			IPMaskedDstAddress:1,
+			ProtocolSrcPortRange:1,
+			ProtocolDstPortRange:1,
+			DstMacAddr:1,
+			SrcMacAddr:1,
+			Ethertype:1,
+			IEEE802_1DUserPriority:1,
+			IEEE802_1QVLANID:1,
+			Reserved:5;
+		} fields;
+	} */
+	BOOLEAN		Enabled;
+	u32			SFID;
+	u8			QoSBufCount;
+	u16		ClassifierRuleEnable;
+	u8			IPToSLow;
+	u8			IPToSHigh;
+	u8			IPToSMask;
+	u8			Protocol;
+	u8			IPSrcAddr[16];
+	u8			IPSrcAddrMask[16];
+	u8			IPDstAddr[16];
+	u8			IPDstAddrMask[16];
+	u16		SrcPortLow;
+	u16		SrcPortHigh;
+	u16		DstPortLow;
+	u16		DstPortHigh;
+};
+
+struct qos_entry_s {
+	struct list_head list;
+	struct sk_buff *skb;
+	struct net_device *dev;
+
+};
+
+struct qos_cb_s {
+	struct list_head	qos_list[QOS_MAX];
+	u32			qos_list_cnt;
+	u32			qos_null_idx;
+	struct gdm_wimax_csr_s	csr[QOS_MAX];
+	spinlock_t	qos_lock;
+	u32			qos_limit_size;
+};
+
+void gdm_qos_init(void *nic_ptr);
+void gdm_qos_release_list(void *nic_ptr);
+int gdm_qos_send_hci_pkt(struct sk_buff *skb, struct net_device *dev);
+void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size);
+
+#endif
diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
new file mode 100644
index 0000000..1eef5fd
--- /dev/null
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -0,0 +1,747 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+
+#include <linux/mmc/core.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+
+#include "gdm_sdio.h"
+#include "gdm_wimax.h"
+#include "sdio_boot.h"
+#include "hci.h"
+
+#define TYPE_A_HEADER_SIZE	4
+#define TYPE_A_LOOKAHEAD_SIZE	16
+
+#define MAX_NR_RX_BUF	4
+
+#define SDU_TX_BUF_SIZE	2048
+#define TX_BUF_SIZE		2048
+#define TX_CHUNK_SIZE	(2048 - TYPE_A_HEADER_SIZE)
+#define RX_BUF_SIZE		(25*1024)
+
+#define TX_HZ	2000
+#define TX_INTERVAL	(1000000/TX_HZ)
+
+/*#define DEBUG*/
+
+static int init_sdio(struct sdiowm_dev *sdev);
+static void release_sdio(struct sdiowm_dev *sdev);
+
+#ifdef DEBUG
+static void hexdump(char *title, u8 *data, int len)
+{
+	int i;
+
+	printk(KERN_DEBUG "%s: length = %d\n", title, len);
+	for (i = 0; i < len; i++) {
+		printk(KERN_DEBUG "%02x ", data[i]);
+		if ((i & 0xf) == 0xf)
+			printk(KERN_DEBUG "\n");
+	}
+	printk(KERN_DEBUG "\n");
+}
+#endif
+
+static struct sdio_tx *alloc_tx_struct(struct tx_cxt *tx)
+{
+	struct sdio_tx *t = NULL;
+
+	t = kmalloc(sizeof(*t), GFP_ATOMIC);
+	if (t == NULL)
+		goto out;
+
+	memset(t, 0, sizeof(*t));
+
+	t->buf = kmalloc(TX_BUF_SIZE, GFP_ATOMIC);
+	if (t->buf == NULL)
+		goto out;
+
+	t->tx_cxt = tx;
+
+	return t;
+out:
+	if (t) {
+		kfree(t->buf);
+		kfree(t);
+	}
+	return NULL;
+}
+
+static void free_tx_struct(struct sdio_tx *t)
+{
+	if (t) {
+		kfree(t->buf);
+		kfree(t);
+	}
+}
+
+static struct sdio_rx *alloc_rx_struct(struct rx_cxt *rx)
+{
+	struct sdio_rx *r = NULL;
+
+	r = kmalloc(sizeof(*r), GFP_ATOMIC);
+	if (r == NULL)
+		goto out;
+
+	memset(r, 0, sizeof(*r));
+
+	r->rx_cxt = rx;
+
+	return r;
+out:
+	kfree(r);
+	return NULL;
+}
+
+static void free_rx_struct(struct sdio_rx *r)
+{
+	kfree(r);
+}
+
+/* Before this function is called, spin lock should be locked. */
+static struct sdio_tx *get_tx_struct(struct tx_cxt *tx, int *no_spc)
+{
+	struct sdio_tx *t;
+
+	if (list_empty(&tx->free_list))
+		return NULL;
+
+	t = list_entry(tx->free_list.prev, struct sdio_tx, list);
+	list_del(&t->list);
+
+	*no_spc = list_empty(&tx->free_list) ? 1 : 0;
+
+	return t;
+}
+
+/* Before this function is called, spin lock should be locked. */
+static void put_tx_struct(struct tx_cxt *tx, struct sdio_tx *t)
+{
+	list_add_tail(&t->list, &tx->free_list);
+}
+
+/* Before this function is called, spin lock should be locked. */
+static struct sdio_rx *get_rx_struct(struct rx_cxt *rx)
+{
+	struct sdio_rx *r;
+
+	if (list_empty(&rx->free_list))
+		return NULL;
+
+	r = list_entry(rx->free_list.prev, struct sdio_rx, list);
+	list_del(&r->list);
+
+	return r;
+}
+
+/* Before this function is called, spin lock should be locked. */
+static void put_rx_struct(struct rx_cxt *rx, struct sdio_rx *r)
+{
+	list_add_tail(&r->list, &rx->free_list);
+}
+
+static int init_sdio(struct sdiowm_dev *sdev)
+{
+	int ret = 0, i;
+	struct tx_cxt	*tx = &sdev->tx;
+	struct rx_cxt	*rx = &sdev->rx;
+	struct sdio_tx	*t;
+	struct sdio_rx	*r;
+
+	INIT_LIST_HEAD(&tx->free_list);
+	INIT_LIST_HEAD(&tx->sdu_list);
+	INIT_LIST_HEAD(&tx->hci_list);
+
+	spin_lock_init(&tx->lock);
+
+	tx->sdu_buf = kmalloc(SDU_TX_BUF_SIZE, GFP_KERNEL);
+	if (tx->sdu_buf == NULL) {
+		printk(KERN_ERR "Failed to allocate SDU tx buffer.\n");
+		goto fail;
+	}
+
+	for (i = 0; i < MAX_NR_SDU_BUF; i++) {
+		t = alloc_tx_struct(tx);
+		if (t == NULL) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+		list_add(&t->list, &tx->free_list);
+	}
+
+	INIT_LIST_HEAD(&rx->free_list);
+	INIT_LIST_HEAD(&rx->req_list);
+
+	spin_lock_init(&rx->lock);
+
+	for (i = 0; i < MAX_NR_RX_BUF; i++) {
+		r = alloc_rx_struct(rx);
+		if (r == NULL) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+		list_add(&r->list, &rx->free_list);
+	}
+
+	rx->rx_buf = kmalloc(RX_BUF_SIZE, GFP_KERNEL);
+	if (rx->rx_buf == NULL) {
+		printk(KERN_ERR "Failed to allocate rx buffer.\n");
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	release_sdio(sdev);
+	return ret;
+}
+
+static void release_sdio(struct sdiowm_dev *sdev)
+{
+	struct tx_cxt	*tx = &sdev->tx;
+	struct rx_cxt	*rx = &sdev->rx;
+	struct sdio_tx	*t, *t_next;
+	struct sdio_rx	*r, *r_next;
+
+	kfree(tx->sdu_buf);
+
+	list_for_each_entry_safe(t, t_next, &tx->free_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->sdu_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->hci_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	kfree(rx->rx_buf);
+
+	list_for_each_entry_safe(r, r_next, &rx->free_list, list) {
+		list_del(&r->list);
+		free_rx_struct(r);
+	}
+
+	list_for_each_entry_safe(r, r_next, &rx->req_list, list) {
+		list_del(&r->list);
+		free_rx_struct(r);
+	}
+}
+
+static void send_sdio_pkt(struct sdio_func *func, u8 *data, int len)
+{
+	int n, blocks, ret, remain;
+
+	sdio_claim_host(func);
+
+	blocks = len / func->cur_blksize;
+	n = blocks * func->cur_blksize;
+	if (blocks) {
+		ret = sdio_memcpy_toio(func, 0, data, n);
+		if (ret < 0) {
+			if (ret != -ENOMEDIUM)
+				printk(KERN_ERR "gdmwms: %s error: ret = %d\n",
+					__func__, ret);
+			goto end_io;
+		}
+	}
+
+	remain = len - n;
+	remain = (remain + 3) & ~3;
+
+	if (remain) {
+		ret = sdio_memcpy_toio(func, 0, data + n, remain);
+		if (ret < 0) {
+			if (ret != -ENOMEDIUM)
+				printk(KERN_ERR "gdmwms: %s error: ret = %d\n",
+					__func__, ret);
+			goto end_io;
+		}
+	}
+
+end_io:
+	sdio_release_host(func);
+}
+
+static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
+{
+	struct list_head *l, *next;
+	struct hci_s *hci;
+	struct sdio_tx *t;
+	int pos, len, i, estlen, aggr_num = 0, aggr_len;
+	u8 *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	pos = TYPE_A_HEADER_SIZE + HCI_HEADER_SIZE;
+	list_for_each_entry(t, &tx->sdu_list, list) {
+		estlen = ((t->len + 3) & ~3) + 4;
+		if ((pos + estlen) > SDU_TX_BUF_SIZE)
+			break;
+
+		aggr_num++;
+		memcpy(tx->sdu_buf + pos, t->buf, t->len);
+		memset(tx->sdu_buf + pos + t->len, 0, estlen - t->len);
+		pos += estlen;
+	}
+	aggr_len = pos;
+
+	hci = (struct hci_s *)(tx->sdu_buf + TYPE_A_HEADER_SIZE);
+	hci->cmd_evt = H2B(WIMAX_TX_SDU_AGGR);
+	hci->length = H2B(aggr_len - TYPE_A_HEADER_SIZE - HCI_HEADER_SIZE);
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+#ifdef DEBUG
+	hexdump("sdio_send", tx->sdu_buf + TYPE_A_HEADER_SIZE,
+		aggr_len - TYPE_A_HEADER_SIZE);
+#endif
+
+	for (pos = TYPE_A_HEADER_SIZE; pos < aggr_len; pos += TX_CHUNK_SIZE) {
+		len = aggr_len - pos;
+		len = len > TX_CHUNK_SIZE ? TX_CHUNK_SIZE : len;
+		buf = tx->sdu_buf + pos - TYPE_A_HEADER_SIZE;
+
+		buf[0] = len & 0xff;
+		buf[1] = (len >> 8) & 0xff;
+		buf[2] = (len >> 16) & 0xff;
+		buf[3] = (pos + len) >= aggr_len ? 0 : 1;
+		send_sdio_pkt(func, buf, len + TYPE_A_HEADER_SIZE);
+	}
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	for (l = tx->sdu_list.next, i = 0; i < aggr_num; i++, l = next) {
+		next = l->next;
+		t = list_entry(l, struct sdio_tx, list);
+		if (t->callback)
+			t->callback(t->cb_data);
+
+		list_del(l);
+		put_tx_struct(t->tx_cxt, t);
+	}
+
+	do_gettimeofday(&tx->sdu_stamp);
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static void send_hci(struct sdio_func *func, struct tx_cxt *tx,
+			struct sdio_tx *t)
+{
+	unsigned long flags;
+
+#ifdef DEBUG
+	hexdump("sdio_send", t->buf + TYPE_A_HEADER_SIZE,
+		t->len - TYPE_A_HEADER_SIZE);
+#endif
+	send_sdio_pkt(func, t->buf, t->len);
+
+	spin_lock_irqsave(&tx->lock, flags);
+	if (t->callback)
+		t->callback(t->cb_data);
+	free_tx_struct(t);
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static void do_tx(struct work_struct *work)
+{
+	struct sdiowm_dev *sdev = container_of(work, struct sdiowm_dev, ws);
+	struct sdio_func *func = sdev->func;
+	struct tx_cxt *tx = &sdev->tx;
+	struct sdio_tx *t = NULL;
+	struct timeval now, *before;
+	int is_sdu = 0;
+	long diff;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	if (!tx->can_send) {
+		spin_unlock_irqrestore(&tx->lock, flags);
+		return;
+	}
+
+	if (!list_empty(&tx->hci_list)) {
+		t = list_entry(tx->hci_list.next, struct sdio_tx, list);
+		list_del(&t->list);
+		is_sdu = 0;
+	} else if (!tx->stop_sdu_tx && !list_empty(&tx->sdu_list)) {
+		do_gettimeofday(&now);
+		before = &tx->sdu_stamp;
+
+		diff = (now.tv_sec - before->tv_sec) * 1000000 +
+			(now.tv_usec - before->tv_usec);
+		if (diff >= 0 && diff < TX_INTERVAL) {
+			schedule_work(&sdev->ws);
+			spin_unlock_irqrestore(&tx->lock, flags);
+			return;
+		}
+		is_sdu = 1;
+	}
+
+	if (!is_sdu && t == NULL) {
+		spin_unlock_irqrestore(&tx->lock, flags);
+		return;
+	}
+
+	tx->can_send = 0;
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	if (is_sdu)
+		send_sdu(func, tx);
+	else
+		send_hci(func, tx, t);
+}
+
+static int gdm_sdio_send(void *priv_dev, void *data, int len,
+			void (*cb)(void *data), void *cb_data)
+{
+	struct sdiowm_dev *sdev = priv_dev;
+	struct tx_cxt *tx = &sdev->tx;
+	struct sdio_tx *t;
+	u8 *pkt = data;
+	int no_spc = 0;
+	u16 cmd_evt;
+	unsigned long flags;
+
+	BUG_ON(len > TX_BUF_SIZE - TYPE_A_HEADER_SIZE);
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	cmd_evt = (pkt[0] << 8) | pkt[1];
+	if (cmd_evt == WIMAX_TX_SDU) {
+		t = get_tx_struct(tx, &no_spc);
+		if (t == NULL) {
+			/* This case must not happen. */
+			spin_unlock_irqrestore(&tx->lock, flags);
+			return -ENOSPC;
+		}
+		list_add_tail(&t->list, &tx->sdu_list);
+
+		memcpy(t->buf, data, len);
+
+		t->len = len;
+		t->callback = cb;
+		t->cb_data = cb_data;
+	} else {
+		t = alloc_tx_struct(tx);
+		if (t == NULL) {
+			spin_unlock_irqrestore(&tx->lock, flags);
+			return -ENOMEM;
+		}
+		list_add_tail(&t->list, &tx->hci_list);
+
+		t->buf[0] = len & 0xff;
+		t->buf[1] = (len >> 8) & 0xff;
+		t->buf[2] = (len >> 16) & 0xff;
+		t->buf[3] = 2;
+		memcpy(t->buf + TYPE_A_HEADER_SIZE, data, len);
+
+		t->len = len + TYPE_A_HEADER_SIZE;
+		t->callback = cb;
+		t->cb_data = cb_data;
+	}
+
+	if (tx->can_send)
+		schedule_work(&sdev->ws);
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	if (no_spc)
+		return -ENOSPC;
+
+	return 0;
+}
+
+/*
+ * Handle the HCI, WIMAX_SDU_TX_FLOW.
+ */
+static int control_sdu_tx_flow(struct sdiowm_dev *sdev, u8 *hci_data, int len)
+{
+	struct tx_cxt *tx = &sdev->tx;
+	u16 cmd_evt;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	cmd_evt = (hci_data[0] << 8) | (hci_data[1]);
+	if (cmd_evt != WIMAX_SDU_TX_FLOW)
+		goto out;
+
+	if (hci_data[4] == 0) {
+#ifdef DEBUG
+		printk(KERN_DEBUG "WIMAX ==> STOP SDU TX\n");
+#endif
+		tx->stop_sdu_tx = 1;
+	} else if (hci_data[4] == 1) {
+#ifdef DEBUG
+		printk(KERN_DEBUG "WIMAX ==> START SDU TX\n");
+#endif
+		tx->stop_sdu_tx = 0;
+		if (tx->can_send)
+			schedule_work(&sdev->ws);
+		/*
+		 * If free buffer for sdu tx doesn't exist, then tx queue
+		 * should not be woken. For this reason, don't pass the command,
+		 * START_SDU_TX.
+		 */
+		if (list_empty(&tx->free_list))
+			len = 0;
+	}
+
+out:
+	spin_unlock_irqrestore(&tx->lock, flags);
+	return len;
+}
+
+static void gdm_sdio_irq(struct sdio_func *func)
+{
+	struct phy_dev *phy_dev = sdio_get_drvdata(func);
+	struct sdiowm_dev *sdev = phy_dev->priv_dev;
+	struct tx_cxt *tx = &sdev->tx;
+	struct rx_cxt *rx = &sdev->rx;
+	struct sdio_rx *r;
+	unsigned long flags;
+	u8 val, hdr[TYPE_A_LOOKAHEAD_SIZE], *buf;
+	u32 len, blocks, n;
+	int ret, remain;
+
+	/* Check interrupt */
+	val = sdio_readb(func, 0x13, &ret);
+	if (val & 0x01)
+		sdio_writeb(func, 0x01, 0x13, &ret);	/* clear interrupt */
+	else
+		return;
+
+	ret = sdio_memcpy_fromio(func, hdr, 0x0, TYPE_A_LOOKAHEAD_SIZE);
+	if (ret) {
+		printk(KERN_ERR "Cannot read from function %d\n", func->num);
+		goto done;
+	}
+
+	len = (hdr[2] << 16) | (hdr[1] << 8) | hdr[0];
+	if (len > (RX_BUF_SIZE - TYPE_A_HEADER_SIZE)) {
+		printk(KERN_ERR "Too big Type-A size: %d\n", len);
+		goto done;
+	}
+
+	if (hdr[3] == 1) {	/* Ack */
+#ifdef DEBUG
+		u32 *ack_seq = (u32 *)&hdr[4];
+#endif
+		spin_lock_irqsave(&tx->lock, flags);
+		tx->can_send = 1;
+
+		if (!list_empty(&tx->sdu_list) || !list_empty(&tx->hci_list))
+			schedule_work(&sdev->ws);
+		spin_unlock_irqrestore(&tx->lock, flags);
+#ifdef DEBUG
+		printk(KERN_DEBUG "Ack... %0x\n", ntohl(*ack_seq));
+#endif
+		goto done;
+	}
+
+	memcpy(rx->rx_buf, hdr + TYPE_A_HEADER_SIZE,
+			TYPE_A_LOOKAHEAD_SIZE - TYPE_A_HEADER_SIZE);
+
+	buf = rx->rx_buf + TYPE_A_LOOKAHEAD_SIZE - TYPE_A_HEADER_SIZE;
+	remain = len - TYPE_A_LOOKAHEAD_SIZE + TYPE_A_HEADER_SIZE;
+	if (remain <= 0)
+		goto end_io;
+
+	blocks = remain / func->cur_blksize;
+
+	if (blocks) {
+		n = blocks * func->cur_blksize;
+		ret = sdio_memcpy_fromio(func, buf, 0x0, n);
+		if (ret) {
+			printk(KERN_ERR "Cannot read from function %d\n",
+				func->num);
+			goto done;
+		}
+		buf += n;
+		remain -= n;
+	}
+
+	if (remain) {
+		ret = sdio_memcpy_fromio(func, buf, 0x0, remain);
+		if (ret) {
+			printk(KERN_ERR "Cannot read from function %d\n",
+				func->num);
+			goto done;
+		}
+	}
+
+end_io:
+#ifdef DEBUG
+	hexdump("sdio_receive", rx->rx_buf, len);
+#endif
+	len = control_sdu_tx_flow(sdev, rx->rx_buf, len);
+
+	spin_lock_irqsave(&rx->lock, flags);
+
+	if (!list_empty(&rx->req_list)) {
+		r = list_entry(rx->req_list.next, struct sdio_rx, list);
+		spin_unlock_irqrestore(&rx->lock, flags);
+		if (r->callback)
+			r->callback(r->cb_data, rx->rx_buf, len);
+		spin_lock_irqsave(&rx->lock, flags);
+		list_del(&r->list);
+		put_rx_struct(rx, r);
+	}
+
+	spin_unlock_irqrestore(&rx->lock, flags);
+
+done:
+	sdio_writeb(func, 0x00, 0x10, &ret);	/* PCRRT */
+	if (!phy_dev->netdev)
+		register_wimax_device(phy_dev);
+}
+
+static int gdm_sdio_receive(void *priv_dev,
+				void (*cb)(void *cb_data, void *data, int len),
+				void *cb_data)
+{
+	struct sdiowm_dev *sdev = priv_dev;
+	struct rx_cxt *rx = &sdev->rx;
+	struct sdio_rx *r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rx->lock, flags);
+	r = get_rx_struct(rx);
+	if (r == NULL) {
+		spin_unlock_irqrestore(&rx->lock, flags);
+		return -ENOMEM;
+	}
+
+	r->callback = cb;
+	r->cb_data = cb_data;
+
+	list_add_tail(&r->list, &rx->req_list);
+	spin_unlock_irqrestore(&rx->lock, flags);
+
+	return 0;
+}
+
+static int sdio_wimax_probe(struct sdio_func *func,
+				const struct sdio_device_id *id)
+{
+	int ret;
+	struct phy_dev *phy_dev = NULL;
+	struct sdiowm_dev *sdev = NULL;
+
+	printk(KERN_INFO "Found GDM SDIO VID = 0x%04x PID = 0x%04x...\n",
+			func->vendor, func->device);
+	printk(KERN_INFO "GCT WiMax driver version %s\n", DRIVER_VERSION);
+
+	sdio_claim_host(func);
+	sdio_enable_func(func);
+	sdio_claim_irq(func, gdm_sdio_irq);
+
+	ret = sdio_boot(func);
+	if (ret)
+		return ret;
+
+	phy_dev = kmalloc(sizeof(*phy_dev), GFP_KERNEL);
+	if (phy_dev == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	sdev = kmalloc(sizeof(*sdev), GFP_KERNEL);
+	if (sdev == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memset(phy_dev, 0, sizeof(*phy_dev));
+	memset(sdev, 0, sizeof(*sdev));
+
+	phy_dev->priv_dev = (void *)sdev;
+	phy_dev->send_func = gdm_sdio_send;
+	phy_dev->rcv_func = gdm_sdio_receive;
+
+	ret = init_sdio(sdev);
+	if (sdev < 0)
+		goto out;
+
+	sdev->func = func;
+
+	sdio_writeb(func, 1, 0x14, &ret);	/* Enable interrupt */
+	sdio_release_host(func);
+
+	INIT_WORK(&sdev->ws, do_tx);
+
+	sdio_set_drvdata(func, phy_dev);
+out:
+	if (ret) {
+		kfree(phy_dev);
+		kfree(sdev);
+	}
+
+	return ret;
+}
+
+static void sdio_wimax_remove(struct sdio_func *func)
+{
+	struct phy_dev *phy_dev = sdio_get_drvdata(func);
+	struct sdiowm_dev *sdev = phy_dev->priv_dev;
+
+	if (phy_dev->netdev)
+		unregister_wimax_device(phy_dev);
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+	sdio_disable_func(func);
+	sdio_release_host(func);
+	release_sdio(sdev);
+
+	kfree(sdev);
+	kfree(phy_dev);
+}
+
+static const struct sdio_device_id sdio_wimax_ids[] = {
+	{ SDIO_DEVICE(0x0296, 0x5347) },
+	{0}
+};
+
+MODULE_DEVICE_TABLE(sdio, sdio_wimax_ids);
+
+static struct sdio_driver sdio_wimax_driver = {
+	.probe		= sdio_wimax_probe,
+	.remove		= sdio_wimax_remove,
+	.name		= "sdio_wimax",
+	.id_table	= sdio_wimax_ids,
+};
+
+static int __init sdio_gdm_wimax_init(void)
+{
+	return sdio_register_driver(&sdio_wimax_driver);
+}
+
+static void __exit sdio_gdm_wimax_exit(void)
+{
+	sdio_unregister_driver(&sdio_wimax_driver);
+}
+
+module_init(sdio_gdm_wimax_init);
+module_exit(sdio_gdm_wimax_exit);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_DESCRIPTION("GCT WiMax SDIO Device Driver");
+MODULE_AUTHOR("Ethan Park");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/gdm72xx/gdm_sdio.h b/drivers/staging/gdm72xx/gdm_sdio.h
new file mode 100644
index 0000000..c6ecc20
--- /dev/null
+++ b/drivers/staging/gdm72xx/gdm_sdio.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#ifndef __GDM_SDIO_H__
+#define __GDM_SDIO_H__
+
+#include <linux/types.h>
+#include <linux/time.h>
+
+#define MAX_NR_SDU_BUF  64
+
+struct sdio_tx {
+	struct list_head	list;
+	struct tx_cxt		*tx_cxt;
+
+	u8	*buf;
+	int	len;
+
+	void (*callback)(void *cb_data);
+	void *cb_data;
+};
+
+struct tx_cxt {
+	struct list_head	free_list;
+	struct list_head	sdu_list;
+	struct list_head	hci_list;
+	struct timeval		sdu_stamp;
+
+	u8	*sdu_buf;
+
+	spinlock_t			lock;
+	int	can_send;
+	int stop_sdu_tx;
+};
+
+struct sdio_rx {
+	struct list_head	list;
+	struct rx_cxt		*rx_cxt;
+
+	void (*callback)(void *cb_data, void *data, int len);
+	void *cb_data;
+};
+
+struct rx_cxt {
+	struct list_head	free_list;
+	struct list_head	req_list;
+
+	u8		*rx_buf;
+
+	spinlock_t			lock;
+};
+
+struct sdiowm_dev {
+	struct sdio_func	*func;
+
+	struct tx_cxt	tx;
+	struct rx_cxt	rx;
+
+	struct work_struct	ws;
+};
+
+#endif /* __GDM_SDIO_H__ */
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
new file mode 100644
index 0000000..1f8c32d
--- /dev/null
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -0,0 +1,797 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/usb.h>
+#include <asm/byteorder.h>
+
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+#ifndef CONFIG_USB_SUSPEND
+#error "USB host doesn't support USB Selective Suspend."
+#endif
+#endif
+
+#include "gdm_usb.h"
+#include "gdm_wimax.h"
+#include "usb_boot.h"
+#include "hci.h"
+
+#include "usb_ids.h"
+
+MODULE_DEVICE_TABLE(usb, id_table);
+
+#define TX_BUF_SIZE	2048
+#if defined(CONFIG_WIMAX_GDM72XX_WIMAX2)
+#define RX_BUF_SIZE	(128*1024)	/* For packet aggregation */
+#else
+#define RX_BUF_SIZE	2048
+#endif
+
+#define GDM7205_PADDING		256
+
+#define H2B(x)		__cpu_to_be16(x)
+#define B2H(x)		__be16_to_cpu(x)
+#define DB2H(x)		__be32_to_cpu(x)
+
+#define DOWNLOAD_CONF_VALUE		0x21
+
+#ifdef CONFIG_WIMAX_GDM72XX_K_MODE
+
+static DECLARE_WAIT_QUEUE_HEAD(k_wait);
+static LIST_HEAD(k_list);
+static DEFINE_SPINLOCK(k_lock);
+static int k_mode_stop;
+
+#define K_WAIT_TIME	(2 * HZ / 100)
+
+#endif /* CONFIG_WIMAX_GDM72XX_K_MODE */
+
+static int init_usb(struct usbwm_dev *udev);
+static void release_usb(struct usbwm_dev *udev);
+
+/*#define DEBUG */
+#ifdef DEBUG
+static void hexdump(char *title, u8 *data, int len)
+{
+	int i;
+
+	printk(KERN_DEBUG "%s: length = %d\n", title, len);
+	for (i = 0; i < len; i++) {
+		printk(KERN_DEBUG "%02x ", data[i]);
+		if ((i & 0xf) == 0xf)
+			printk(KERN_DEBUG "\n");
+	}
+	printk(KERN_DEBUG "\n");
+}
+#endif
+
+static struct usb_tx *alloc_tx_struct(struct tx_cxt *tx)
+{
+	struct usb_tx *t = NULL;
+
+	t = kmalloc(sizeof(*t), GFP_ATOMIC);
+	if (t == NULL)
+		goto out;
+
+	memset(t, 0, sizeof(*t));
+
+	t->urb = usb_alloc_urb(0, GFP_ATOMIC);
+	t->buf = kmalloc(TX_BUF_SIZE, GFP_ATOMIC);
+	if (t->urb == NULL || t->buf == NULL)
+		goto out;
+
+	t->tx_cxt = tx;
+
+	return t;
+out:
+	if (t) {
+		usb_free_urb(t->urb);
+		kfree(t->buf);
+		kfree(t);
+	}
+	return NULL;
+}
+
+static void free_tx_struct(struct usb_tx *t)
+{
+	if (t) {
+		usb_free_urb(t->urb);
+		kfree(t->buf);
+		kfree(t);
+	}
+}
+
+static struct usb_rx *alloc_rx_struct(struct rx_cxt *rx)
+{
+	struct usb_rx *r = NULL;
+
+	r = kmalloc(sizeof(*r), GFP_ATOMIC);
+	if (r == NULL)
+		goto out;
+
+	memset(r, 0, sizeof(*r));
+
+	r->urb = usb_alloc_urb(0, GFP_ATOMIC);
+	r->buf = kmalloc(RX_BUF_SIZE, GFP_ATOMIC);
+	if (r->urb == NULL || r->buf == NULL)
+		goto out;
+
+	r->rx_cxt = rx;
+	return r;
+out:
+	if (r) {
+		usb_free_urb(r->urb);
+		kfree(r->buf);
+		kfree(r);
+	}
+	return NULL;
+}
+
+static void free_rx_struct(struct usb_rx *r)
+{
+	if (r) {
+		usb_free_urb(r->urb);
+		kfree(r->buf);
+		kfree(r);
+	}
+}
+
+/* Before this function is called, spin lock should be locked. */
+static struct usb_tx *get_tx_struct(struct tx_cxt *tx, int *no_spc)
+{
+	struct usb_tx *t;
+
+	if (list_empty(&tx->free_list)) {
+		*no_spc = 1;
+		return NULL;
+	}
+
+	t = list_entry(tx->free_list.next, struct usb_tx, list);
+	list_del(&t->list);
+
+	*no_spc = list_empty(&tx->free_list) ? 1 : 0;
+
+	return t;
+}
+
+/* Before this function is called, spin lock should be locked. */
+static void put_tx_struct(struct tx_cxt *tx, struct usb_tx *t)
+{
+	list_add_tail(&t->list, &tx->free_list);
+}
+
+/* Before this function is called, spin lock should be locked. */
+static struct usb_rx *get_rx_struct(struct rx_cxt *rx)
+{
+	struct usb_rx *r;
+
+	if (list_empty(&rx->free_list)) {
+		r = alloc_rx_struct(rx);
+		if (r == NULL)
+			return NULL;
+
+		list_add(&r->list, &rx->free_list);
+	}
+
+	r = list_entry(rx->free_list.next, struct usb_rx, list);
+	list_del(&r->list);
+	list_add_tail(&r->list, &rx->used_list);
+
+	return r;
+}
+
+/* Before this function is called, spin lock should be locked. */
+static void put_rx_struct(struct rx_cxt *rx, struct usb_rx *r)
+{
+	list_del(&r->list);
+	list_add(&r->list, &rx->free_list);
+}
+
+static int init_usb(struct usbwm_dev *udev)
+{
+	int ret = 0, i;
+	struct tx_cxt	*tx = &udev->tx;
+	struct rx_cxt	*rx = &udev->rx;
+	struct usb_tx	*t;
+	struct usb_rx	*r;
+
+	INIT_LIST_HEAD(&tx->free_list);
+	INIT_LIST_HEAD(&tx->sdu_list);
+	INIT_LIST_HEAD(&tx->hci_list);
+#if defined(CONFIG_WIMAX_GDM72XX_USB_PM) || defined(CONFIG_WIMAX_GDM72XX_K_MODE)
+	INIT_LIST_HEAD(&tx->pending_list);
+#endif
+
+	INIT_LIST_HEAD(&rx->free_list);
+	INIT_LIST_HEAD(&rx->used_list);
+
+	spin_lock_init(&tx->lock);
+	spin_lock_init(&rx->lock);
+
+	for (i = 0; i < MAX_NR_SDU_BUF; i++) {
+		t = alloc_tx_struct(tx);
+		if (t == NULL) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+		list_add(&t->list, &tx->free_list);
+	}
+
+	r = alloc_rx_struct(rx);
+	if (r == NULL) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	list_add(&r->list, &rx->free_list);
+	return ret;
+
+fail:
+	release_usb(udev);
+	return ret;
+}
+
+static void release_usb(struct usbwm_dev *udev)
+{
+	struct tx_cxt	*tx = &udev->tx;
+	struct rx_cxt	*rx = &udev->rx;
+	struct usb_tx	*t, *t_next;
+	struct usb_rx	*r, *r_next;
+
+	list_for_each_entry_safe(t, t_next, &tx->sdu_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->hci_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->free_list, list) {
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(r, r_next, &rx->free_list, list) {
+		list_del(&r->list);
+		free_rx_struct(r);
+	}
+
+	list_for_each_entry_safe(r, r_next, &rx->used_list, list) {
+		list_del(&r->list);
+		free_rx_struct(r);
+	}
+}
+
+static void gdm_usb_send_complete(struct urb *urb)
+{
+	struct usb_tx *t = urb->context;
+	struct tx_cxt *tx = t->tx_cxt;
+	u8 *pkt = t->buf;
+	u16 cmd_evt;
+	unsigned long flags;
+
+	/* Completion by usb_unlink_urb */
+	if (urb->status == -ECONNRESET)
+		return;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	if (t->callback)
+		t->callback(t->cb_data);
+
+	/* Delete from sdu list or hci list. */
+	list_del(&t->list);
+
+	cmd_evt = (pkt[0] << 8) | pkt[1];
+	if (cmd_evt == WIMAX_TX_SDU)
+		put_tx_struct(tx, t);
+	else
+		free_tx_struct(t);
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static int gdm_usb_send(void *priv_dev, void *data, int len,
+			void (*cb)(void *data), void *cb_data)
+{
+	struct usbwm_dev *udev = priv_dev;
+	struct usb_device *usbdev = udev->usbdev;
+	struct tx_cxt *tx = &udev->tx;
+	struct usb_tx *t;
+	int padding = udev->padding;
+	int no_spc = 0, ret;
+	u8 *pkt = data;
+	u16 cmd_evt;
+	unsigned long flags;
+
+	if (!udev->usbdev) {
+		printk(KERN_ERR "%s: No such device\n", __func__);
+		return -ENODEV;
+	}
+
+	BUG_ON(len > TX_BUF_SIZE - padding - 1);
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	cmd_evt = (pkt[0] << 8) | pkt[1];
+	if (cmd_evt == WIMAX_TX_SDU) {
+		t = get_tx_struct(tx, &no_spc);
+		if (t == NULL) {
+			/* This case must not happen. */
+			spin_unlock_irqrestore(&tx->lock, flags);
+			return -ENOSPC;
+		}
+		list_add_tail(&t->list, &tx->sdu_list);
+	} else {
+		t = alloc_tx_struct(tx);
+		if (t == NULL) {
+			spin_unlock_irqrestore(&tx->lock, flags);
+			return -ENOMEM;
+		}
+		list_add_tail(&t->list, &tx->hci_list);
+	}
+
+	memcpy(t->buf + padding, data, len);
+	t->callback = cb;
+	t->cb_data = cb_data;
+
+	/*
+	 * In some cases, USB Module of WiMax is blocked when data size is
+	 * the multiple of 512. So, increment length by one in that case.
+	 */
+	if ((len % 512) == 0)
+		len++;
+
+	usb_fill_bulk_urb(t->urb,
+			usbdev,
+			usb_sndbulkpipe(usbdev, 1),
+			t->buf,
+			len + padding,
+			gdm_usb_send_complete,
+			t);
+
+#ifdef DEBUG
+	hexdump("usb_send", t->buf, len + padding);
+#endif
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+	if (usbdev->state & USB_STATE_SUSPENDED) {
+		list_add_tail(&t->p_list, &tx->pending_list);
+		schedule_work(&udev->pm_ws);
+		goto out;
+	}
+#endif /* CONFIG_WIMAX_GDM72XX_USB_PM */
+
+#ifdef CONFIG_WIMAX_GDM72XX_K_MODE
+	if (udev->bw_switch) {
+		list_add_tail(&t->p_list, &tx->pending_list);
+		goto out;
+	} else if (cmd_evt == WIMAX_SCAN) {
+		struct rx_cxt *rx;
+		struct usb_rx *r;
+
+		rx = &udev->rx;
+
+		list_for_each_entry(r, &rx->used_list, list)
+			usb_unlink_urb(r->urb);
+		udev->bw_switch = 1;
+
+		spin_lock(&k_lock);
+		list_add_tail(&udev->list, &k_list);
+		spin_unlock(&k_lock);
+
+		wake_up(&k_wait);
+	}
+#endif /* CONFIG_WIMAX_GDM72XX_K_MODE */
+
+	ret = usb_submit_urb(t->urb, GFP_ATOMIC);
+	if (ret)
+		goto send_fail;
+
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+	usb_mark_last_busy(usbdev);
+#endif /* CONFIG_WIMAX_GDM72XX_USB_PM */
+
+#if defined(CONFIG_WIMAX_GDM72XX_USB_PM) || defined(CONFIG_WIMAX_GDM72XX_K_MODE)
+out:
+#endif
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	if (no_spc)
+		return -ENOSPC;
+
+	return 0;
+
+send_fail:
+	t->callback = NULL;
+	gdm_usb_send_complete(t->urb);
+	spin_unlock_irqrestore(&tx->lock, flags);
+	return ret;
+}
+
+static void gdm_usb_rcv_complete(struct urb *urb)
+{
+	struct usb_rx *r = urb->context;
+	struct rx_cxt *rx = r->rx_cxt;
+	struct usbwm_dev *udev = container_of(r->rx_cxt, struct usbwm_dev, rx);
+	struct tx_cxt *tx = &udev->tx;
+	struct usb_tx *t;
+	u16 cmd_evt;
+	unsigned long flags;
+
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+	struct usb_device *dev = urb->dev;
+#endif
+
+	/* Completion by usb_unlink_urb */
+	if (urb->status == -ECONNRESET)
+		return;
+
+	spin_lock_irqsave(&tx->lock, flags);
+
+	if (!urb->status) {
+		cmd_evt = (r->buf[0] << 8) | (r->buf[1]);
+#ifdef DEBUG
+		hexdump("usb_receive", r->buf, urb->actual_length);
+#endif
+		if (cmd_evt == WIMAX_SDU_TX_FLOW) {
+			if (r->buf[4] == 0) {
+#ifdef DEBUG
+				printk(KERN_DEBUG "WIMAX ==> STOP SDU TX\n");
+#endif
+				list_for_each_entry(t, &tx->sdu_list, list)
+					usb_unlink_urb(t->urb);
+			} else if (r->buf[4] == 1) {
+#ifdef DEBUG
+				printk(KERN_DEBUG "WIMAX ==> START SDU TX\n");
+#endif
+				list_for_each_entry(t, &tx->sdu_list, list) {
+					usb_submit_urb(t->urb, GFP_ATOMIC);
+				}
+				/*
+				 * If free buffer for sdu tx doesn't
+				 * exist, then tx queue should not be
+				 * woken. For this reason, don't pass
+				 * the command, START_SDU_TX.
+				 */
+				if (list_empty(&tx->free_list))
+					urb->actual_length = 0;
+			}
+		}
+	}
+
+	if (!urb->status && r->callback)
+		r->callback(r->cb_data, r->buf, urb->actual_length);
+
+	spin_lock(&rx->lock);
+	put_rx_struct(rx, r);
+	spin_unlock(&rx->lock);
+
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+	usb_mark_last_busy(dev);
+#endif
+}
+
+static int gdm_usb_receive(void *priv_dev,
+			void (*cb)(void *cb_data, void *data, int len),
+			void *cb_data)
+{
+	struct usbwm_dev *udev = priv_dev;
+	struct usb_device *usbdev = udev->usbdev;
+	struct rx_cxt *rx = &udev->rx;
+	struct usb_rx *r;
+	unsigned long flags;
+
+	if (!udev->usbdev) {
+		printk(KERN_ERR "%s: No such device\n", __func__);
+		return -ENODEV;
+	}
+
+	spin_lock_irqsave(&rx->lock, flags);
+	r = get_rx_struct(rx);
+	spin_unlock_irqrestore(&rx->lock, flags);
+
+	if (r == NULL)
+		return -ENOMEM;
+
+	r->callback = cb;
+	r->cb_data = cb_data;
+
+	usb_fill_bulk_urb(r->urb,
+			usbdev,
+			usb_rcvbulkpipe(usbdev, 0x82),
+			r->buf,
+			RX_BUF_SIZE,
+			gdm_usb_rcv_complete,
+			r);
+
+	return usb_submit_urb(r->urb, GFP_ATOMIC);
+}
+
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+static void do_pm_control(struct work_struct *work)
+{
+	struct usbwm_dev *udev = container_of(work, struct usbwm_dev, pm_ws);
+	struct tx_cxt *tx = &udev->tx;
+	int ret;
+	unsigned long flags;
+
+	ret = usb_autopm_get_interface(udev->intf);
+	if (!ret)
+		usb_autopm_put_interface(udev->intf);
+
+	spin_lock_irqsave(&tx->lock, flags);
+	if (!(udev->usbdev->state & USB_STATE_SUSPENDED)
+		&& (!list_empty(&tx->hci_list) || !list_empty(&tx->sdu_list))) {
+		struct usb_tx *t, *temp;
+
+		list_for_each_entry_safe(t, temp, &tx->pending_list, p_list) {
+			list_del(&t->p_list);
+			ret =  usb_submit_urb(t->urb, GFP_ATOMIC);
+
+			if (ret) {
+				t->callback = NULL;
+				gdm_usb_send_complete(t->urb);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+#endif /* CONFIG_WIMAX_GDM72XX_USB_PM */
+
+static int gdm_usb_probe(struct usb_interface *intf,
+				const struct usb_device_id *id)
+{
+	int ret = 0;
+	u8 bConfigurationValue;
+	struct phy_dev *phy_dev = NULL;
+	struct usbwm_dev *udev = NULL;
+	u16 idVendor, idProduct, bcdDevice;
+
+	struct usb_device *usbdev = interface_to_usbdev(intf);
+
+	usb_get_dev(usbdev);
+	bConfigurationValue = usbdev->actconfig->desc.bConfigurationValue;
+
+	/*USB description is set up with Little-Endian*/
+	idVendor = L2H(usbdev->descriptor.idVendor);
+	idProduct = L2H(usbdev->descriptor.idProduct);
+	bcdDevice = L2H(usbdev->descriptor.bcdDevice);
+
+	printk(KERN_INFO "Found GDM USB VID = 0x%04x PID = 0x%04x...\n",
+		idVendor, idProduct);
+	printk(KERN_INFO "GCT WiMax driver version %s\n", DRIVER_VERSION);
+
+
+	if (idProduct == EMERGENCY_PID) {
+		ret = usb_emergency(usbdev);
+		goto out;
+	}
+
+	/* Support for EEPROM bootloader */
+	if (bConfigurationValue == DOWNLOAD_CONF_VALUE ||
+		idProduct & B_DOWNLOAD) {
+		ret = usb_boot(usbdev, bcdDevice);
+		goto out;
+	}
+
+	phy_dev = kmalloc(sizeof(*phy_dev), GFP_KERNEL);
+	if (phy_dev == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	udev = kmalloc(sizeof(*udev), GFP_KERNEL);
+	if (udev == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memset(phy_dev, 0, sizeof(*phy_dev));
+	memset(udev, 0, sizeof(*udev));
+
+	if (idProduct == 0x7205 || idProduct == 0x7206)
+		udev->padding = GDM7205_PADDING;
+	else
+		udev->padding = 0;
+
+	phy_dev->priv_dev = (void *)udev;
+	phy_dev->send_func = gdm_usb_send;
+	phy_dev->rcv_func = gdm_usb_receive;
+
+	ret = init_usb(udev);
+	if (ret < 0)
+		goto out;
+
+	udev->usbdev = usbdev;
+
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+	udev->intf = intf;
+
+	intf->needs_remote_wakeup = 1;
+	device_init_wakeup(&intf->dev, 1);
+
+	pm_runtime_set_autosuspend_delay(&usbdev->dev, 10 * 1000); /* msec */
+
+	INIT_WORK(&udev->pm_ws, do_pm_control);
+#endif /* CONFIG_WIMAX_GDM72XX_USB_PM */
+
+	ret = register_wimax_device(phy_dev);
+
+out:
+	if (ret) {
+		kfree(phy_dev);
+		kfree(udev);
+	}
+	usb_set_intfdata(intf, phy_dev);
+	return ret;
+}
+
+static void gdm_usb_disconnect(struct usb_interface *intf)
+{
+	u8 bConfigurationValue;
+	struct phy_dev *phy_dev;
+	struct usbwm_dev *udev;
+	u16 idProduct;
+	struct usb_device *usbdev = interface_to_usbdev(intf);
+
+	bConfigurationValue = usbdev->actconfig->desc.bConfigurationValue;
+	phy_dev = usb_get_intfdata(intf);
+
+	/*USB description is set up with Little-Endian*/
+	idProduct = L2H(usbdev->descriptor.idProduct);
+
+	if (idProduct != EMERGENCY_PID &&
+			bConfigurationValue != DOWNLOAD_CONF_VALUE &&
+			(idProduct & B_DOWNLOAD) == 0) {
+		udev = phy_dev->priv_dev;
+		udev->usbdev = NULL;
+
+		unregister_wimax_device(phy_dev);
+		release_usb(udev);
+		kfree(udev);
+		kfree(phy_dev);
+	}
+
+	usb_put_dev(usbdev);
+}
+
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+static int gdm_suspend(struct usb_interface *intf, pm_message_t pm_msg)
+{
+	struct phy_dev *phy_dev;
+	struct usbwm_dev *udev;
+	struct rx_cxt *rx;
+	struct usb_rx *r;
+
+	phy_dev = usb_get_intfdata(intf);
+	udev = phy_dev->priv_dev;
+	rx = &udev->rx;
+
+	list_for_each_entry(r, &rx->used_list, list)
+		usb_unlink_urb(r->urb);
+
+	return 0;
+}
+
+static int gdm_resume(struct usb_interface *intf)
+{
+	struct phy_dev *phy_dev;
+	struct usbwm_dev *udev;
+	struct rx_cxt *rx;
+	struct usb_rx *r;
+
+	phy_dev = usb_get_intfdata(intf);
+	udev = phy_dev->priv_dev;
+	rx = &udev->rx;
+
+	list_for_each_entry(r, &rx->used_list, list)
+		usb_submit_urb(r->urb, GFP_ATOMIC);
+
+	return 0;
+}
+
+#endif /* CONFIG_WIMAX_GDM72XX_USB_PM */
+
+#ifdef CONFIG_WIMAX_GDM72XX_K_MODE
+static int k_mode_thread(void *arg)
+{
+	struct usbwm_dev *udev;
+	struct tx_cxt *tx;
+	struct rx_cxt *rx;
+	struct usb_tx *t, *temp;
+	struct usb_rx *r;
+	unsigned long flags, flags2, expire;
+	int ret;
+
+	daemonize("k_mode_wimax");
+
+	while (!k_mode_stop) {
+
+		spin_lock_irqsave(&k_lock, flags2);
+		while (!list_empty(&k_list)) {
+
+			udev = list_entry(k_list.next, struct usbwm_dev, list);
+			tx = &udev->tx;
+			rx = &udev->rx;
+
+			list_del(&udev->list);
+			spin_unlock_irqrestore(&k_lock, flags2);
+
+			expire = jiffies + K_WAIT_TIME;
+			while (jiffies < expire)
+				schedule_timeout(K_WAIT_TIME);
+
+			list_for_each_entry(r, &rx->used_list, list)
+				usb_submit_urb(r->urb, GFP_ATOMIC);
+
+			spin_lock_irqsave(&tx->lock, flags);
+
+			list_for_each_entry_safe(t, temp, &tx->pending_list,
+						p_list) {
+				list_del(&t->p_list);
+				ret = usb_submit_urb(t->urb, GFP_ATOMIC);
+
+				if (ret) {
+					t->callback = NULL;
+					gdm_usb_send_complete(t->urb);
+				}
+			}
+
+			udev->bw_switch = 0;
+			spin_unlock_irqrestore(&tx->lock, flags);
+
+			spin_lock_irqsave(&k_lock, flags2);
+		}
+		spin_unlock_irqrestore(&k_lock, flags2);
+
+		interruptible_sleep_on(&k_wait);
+	}
+	return 0;
+}
+#endif /* CONFIG_WIMAX_GDM72XX_K_MODE */
+
+static struct usb_driver gdm_usb_driver = {
+	.name = "gdm_wimax",
+	.probe = gdm_usb_probe,
+	.disconnect = gdm_usb_disconnect,
+	.id_table = id_table,
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+	.supports_autosuspend = 1,
+	.suspend = gdm_suspend,
+	.resume = gdm_resume,
+	.reset_resume = gdm_resume,
+#endif
+};
+
+static int __init usb_gdm_wimax_init(void)
+{
+#ifdef CONFIG_WIMAX_GDM72XX_K_MODE
+	kernel_thread(k_mode_thread, NULL, CLONE_KERNEL);
+#endif /* CONFIG_WIMAX_GDM72XX_K_MODE */
+	return usb_register(&gdm_usb_driver);
+}
+
+static void __exit usb_gdm_wimax_exit(void)
+{
+#ifdef CONFIG_WIMAX_GDM72XX_K_MODE
+	k_mode_stop = 1;
+	wake_up(&k_wait);
+#endif
+	usb_deregister(&gdm_usb_driver);
+}
+
+module_init(usb_gdm_wimax_init);
+module_exit(usb_gdm_wimax_exit);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_DESCRIPTION("GCT WiMax Device Driver");
+MODULE_AUTHOR("Ethan Park");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/gdm72xx/gdm_usb.h b/drivers/staging/gdm72xx/gdm_usb.h
new file mode 100644
index 0000000..fa11024
--- /dev/null
+++ b/drivers/staging/gdm72xx/gdm_usb.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#ifndef __GDM_USB_H__
+#define __GDM_USB_H__
+
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/list.h>
+
+#define B_DIFF_DL_DRV		(1<<4)
+#define B_DOWNLOAD			(1 << 5)
+#define MAX_NR_SDU_BUF		64
+
+struct usb_tx {
+	struct list_head	list;
+#if defined(CONFIG_WIMAX_GDM72XX_USB_PM) || defined(CONFIG_WIMAX_GDM72XX_K_MODE)
+	struct list_head	p_list;
+#endif
+	struct tx_cxt		*tx_cxt;
+
+	struct urb	*urb;
+	u8			*buf;
+
+	void (*callback)(void *cb_data);
+	void *cb_data;
+};
+
+struct tx_cxt {
+	struct list_head	free_list;
+	struct list_head	sdu_list;
+	struct list_head	hci_list;
+#if defined(CONFIG_WIMAX_GDM72XX_USB_PM) || defined(CONFIG_WIMAX_GDM72XX_K_MODE)
+	struct list_head	pending_list;
+#endif
+
+	spinlock_t			lock;
+};
+
+struct usb_rx {
+	struct list_head	list;
+	struct rx_cxt		*rx_cxt;
+
+	struct urb	*urb;
+	u8			*buf;
+
+	void (*callback)(void *cb_data, void *data, int len);
+	void *cb_data;
+};
+
+struct rx_cxt {
+	struct list_head	free_list;
+	struct list_head	used_list;
+	spinlock_t			lock;
+};
+
+struct usbwm_dev {
+	struct usb_device	*usbdev;
+#ifdef CONFIG_WIMAX_GDM72XX_USB_PM
+	struct work_struct	pm_ws;
+
+	struct usb_interface	*intf;
+#endif
+#ifdef CONFIG_WIMAX_GDM72XX_K_MODE
+	int bw_switch;
+	struct list_head	list;
+#endif
+
+	struct tx_cxt	tx;
+	struct rx_cxt	rx;
+
+	int padding;
+};
+
+#endif /* __GDM_USB_H__ */
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
new file mode 100644
index 0000000..0bc84c1
--- /dev/null
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -0,0 +1,1018 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#include <linux/version.h>
+#include <linux/etherdevice.h>
+#include <asm/byteorder.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/udp.h>
+#include <linux/in.h>
+
+#include "gdm_wimax.h"
+#include "hci.h"
+#include "wm_ioctl.h"
+#include "netlink_k.h"
+
+#define gdm_wimax_send(n, d, l)	\
+	(n->phy_dev->send_func)(n->phy_dev->priv_dev, d, l, NULL, NULL)
+#define gdm_wimax_send_with_cb(n, d, l, c, b)	\
+	(n->phy_dev->send_func)(n->phy_dev->priv_dev, d, l, c, b)
+#define gdm_wimax_rcv_with_cb(n, c, b)	\
+	(n->phy_dev->rcv_func)(n->phy_dev->priv_dev, c, b)
+
+#define EVT_MAX_SIZE	2048
+
+struct evt_entry {
+	struct list_head list;
+	struct net_device *dev;
+	char evt_data[EVT_MAX_SIZE];
+	int	 size;
+};
+
+static void __gdm_wimax_event_send(struct work_struct *work);
+static inline struct evt_entry *alloc_event_entry(void);
+static inline void free_event_entry(struct evt_entry *e);
+static struct evt_entry *get_event_entry(void);
+static void put_event_entry(struct evt_entry *e);
+
+static struct {
+	int ref_cnt;
+	struct sock *sock;
+	struct list_head evtq;
+	spinlock_t evt_lock;
+
+	struct list_head freeq;
+	struct work_struct ws;
+} wm_event;
+
+static u8 gdm_wimax_macaddr[6] = {0x00, 0x0a, 0x3b, 0xf0, 0x01, 0x30};
+
+static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm);
+static void gdm_wimax_ind_if_updown(struct net_device *dev, int if_up);
+
+#if defined(DEBUG_SDU)
+static void printk_hex(u8 *buf, u32 size)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (i && i % 16 == 0)
+			printk(KERN_DEBUG "\n%02x ", *buf++);
+		else
+			printk(KERN_DEBUG "%02x ", *buf++);
+	}
+
+	printk(KERN_DEBUG "\n");
+}
+
+static const char *get_protocol_name(u16 protocol)
+{
+	static char buf[32];
+	const char *name = "-";
+
+	switch (protocol) {
+	case ETH_P_ARP:
+		name = "ARP";
+		break;
+	case ETH_P_IP:
+		name = "IP";
+		break;
+	case ETH_P_IPV6:
+		name = "IPv6";
+		break;
+	}
+
+	sprintf(buf, "0x%04x(%s)", protocol, name);
+	return buf;
+}
+
+static const char *get_ip_protocol_name(u8 ip_protocol)
+{
+	static char buf[32];
+	const char *name = "-";
+
+	switch (ip_protocol) {
+	case IPPROTO_TCP:
+		name = "TCP";
+		break;
+	case IPPROTO_UDP:
+		name = "UDP";
+		break;
+	case IPPROTO_ICMP:
+		name = "ICMP";
+		break;
+	}
+
+	sprintf(buf, "%u(%s)", ip_protocol, name);
+	return buf;
+}
+
+static const char *get_port_name(u16 port)
+{
+	static char buf[32];
+	const char *name = "-";
+
+	switch (port) {
+	case 67:
+		name = "DHCP-Server";
+		break;
+	case 68:
+		name = "DHCP-Client";
+		break;
+	case 69:
+		name = "TFTP";
+		break;
+	}
+
+	sprintf(buf, "%u(%s)", port, name);
+	return buf;
+}
+
+static void dump_eth_packet(const char *title, u8 *data, int len)
+{
+	struct iphdr *ih = NULL;
+	struct udphdr *uh = NULL;
+	u16 protocol = 0;
+	u8 ip_protocol = 0;
+	u16 port = 0;
+
+	protocol = (data[12]<<8) | data[13];
+	ih = (struct iphdr *) (data+ETH_HLEN);
+
+	if (protocol == ETH_P_IP) {
+		uh = (struct udphdr *) ((char *)ih + sizeof(struct iphdr));
+		ip_protocol = ih->protocol;
+		port = ntohs(uh->dest);
+	} else if (protocol == ETH_P_IPV6) {
+		struct ipv6hdr *i6h = (struct ipv6hdr *) data;
+		uh = (struct udphdr *) ((char *)i6h + sizeof(struct ipv6hdr));
+		ip_protocol = i6h->nexthdr;
+		port = ntohs(uh->dest);
+	}
+
+	printk(KERN_DEBUG "[%s] len=%d, %s, %s, %s\n",
+		title, len,
+		get_protocol_name(protocol),
+		get_ip_protocol_name(ip_protocol),
+		get_port_name(port));
+
+	#if 1
+	if (!(data[0] == 0xff && data[1] == 0xff)) {
+		if (protocol == ETH_P_IP) {
+			printk(KERN_DEBUG "     src=%u.%u.%u.%u\n",
+				NIPQUAD(ih->saddr));
+		} else if (protocol == ETH_P_IPV6) {
+			#ifdef NIP6
+			printk(KERN_DEBUG "     src=%x:%x:%x:%x:%x:%x:%x:%x\n",
+				NIP6(ih->saddr));
+			#else
+			printk(KERN_DEBUG "     src=%pI6\n", &ih->saddr);
+			#endif
+		}
+	}
+	#endif
+
+	#if (DUMP_PACKET & DUMP_SDU_ALL)
+	printk_hex(data, len);
+	#else
+		#if (DUMP_PACKET & DUMP_SDU_ARP)
+		if (protocol == ETH_P_ARP)
+			printk_hex(data, len);
+		#endif
+		#if (DUMP_PACKET & DUMP_SDU_IP)
+		if (protocol == ETH_P_IP || protocol == ETH_P_IPV6)
+			printk_hex(data, len);
+		#else
+			#if (DUMP_PACKET & DUMP_SDU_IP_TCP)
+			if (ip_protocol == IPPROTO_TCP)
+				printk_hex(data, len);
+			#endif
+			#if (DUMP_PACKET & DUMP_SDU_IP_UDP)
+			if (ip_protocol == IPPROTO_UDP)
+				printk_hex(data, len);
+			#endif
+			#if (DUMP_PACKET & DUMP_SDU_IP_ICMP)
+			if (ip_protocol == IPPROTO_ICMP)
+				printk_hex(data, len);
+			#endif
+		#endif
+	#endif
+}
+#endif
+
+
+static inline int gdm_wimax_header(struct sk_buff **pskb)
+{
+	u16 buf[HCI_HEADER_SIZE / sizeof(u16)];
+	struct sk_buff *skb = *pskb;
+	int ret = 0;
+
+	if (unlikely(skb_headroom(skb) < HCI_HEADER_SIZE)) {
+		struct sk_buff *skb2;
+
+		skb2 = skb_realloc_headroom(skb, HCI_HEADER_SIZE);
+		if (skb2 == NULL)
+			return -ENOMEM;
+		if (skb->sk)
+			skb_set_owner_w(skb2, skb->sk);
+		kfree_skb(skb);
+		skb = skb2;
+	}
+
+	skb_push(skb, HCI_HEADER_SIZE);
+	buf[0] = H2B(WIMAX_TX_SDU);
+	buf[1] = H2B(skb->len - HCI_HEADER_SIZE);
+	memcpy(skb->data, buf, HCI_HEADER_SIZE);
+
+	*pskb = skb;
+	return ret;
+}
+
+static void gdm_wimax_event_rcv(struct net_device *dev, u16 type, void *msg,
+				int len)
+{
+	struct nic *nic = netdev_priv(dev);
+
+	#if defined(DEBUG_HCI)
+	u8 *buf = (u8 *) msg;
+	u16 hci_cmd =  (buf[0]<<8) | buf[1];
+	u16 hci_len = (buf[2]<<8) | buf[3];
+	printk(KERN_DEBUG "H=>D: 0x%04x(%d)\n", hci_cmd, hci_len);
+	#endif
+
+	gdm_wimax_send(nic, msg, len);
+}
+
+static int gdm_wimax_event_init(void)
+{
+	if (wm_event.ref_cnt == 0) {
+		wm_event.sock = netlink_init(NETLINK_WIMAX,
+						gdm_wimax_event_rcv);
+		INIT_LIST_HEAD(&wm_event.evtq);
+		INIT_LIST_HEAD(&wm_event.freeq);
+		INIT_WORK(&wm_event.ws, __gdm_wimax_event_send);
+		spin_lock_init(&wm_event.evt_lock);
+	}
+
+	if (wm_event.sock) {
+		wm_event.ref_cnt++;
+		return 0;
+	}
+
+	printk(KERN_ERR "Creating WiMax Event netlink is failed\n");
+	return -1;
+}
+
+static void gdm_wimax_event_exit(void)
+{
+	if (wm_event.sock && --wm_event.ref_cnt == 0) {
+		struct evt_entry *e, *temp;
+		unsigned long flags;
+
+		spin_lock_irqsave(&wm_event.evt_lock, flags);
+
+		list_for_each_entry_safe(e, temp, &wm_event.evtq, list) {
+			list_del(&e->list);
+			free_event_entry(e);
+		}
+		list_for_each_entry_safe(e, temp, &wm_event.freeq, list) {
+			list_del(&e->list);
+			free_event_entry(e);
+		}
+
+		spin_unlock_irqrestore(&wm_event.evt_lock, flags);
+		netlink_exit(wm_event.sock);
+		wm_event.sock = NULL;
+	}
+}
+
+static inline struct evt_entry *alloc_event_entry(void)
+{
+	return kmalloc(sizeof(struct evt_entry), GFP_ATOMIC);
+}
+
+static inline void free_event_entry(struct evt_entry *e)
+{
+	kfree(e);
+}
+
+static struct evt_entry *get_event_entry(void)
+{
+	struct evt_entry *e;
+
+	if (list_empty(&wm_event.freeq))
+		e = alloc_event_entry();
+	else {
+		e = list_entry(wm_event.freeq.next, struct evt_entry, list);
+		list_del(&e->list);
+	}
+
+	return e;
+}
+
+static void put_event_entry(struct evt_entry *e)
+{
+	BUG_ON(!e);
+
+	list_add_tail(&e->list, &wm_event.freeq);
+}
+
+static void __gdm_wimax_event_send(struct work_struct *work)
+{
+	int idx;
+	unsigned long flags;
+	struct evt_entry *e;
+
+	spin_lock_irqsave(&wm_event.evt_lock, flags);
+
+	while (!list_empty(&wm_event.evtq)) {
+		e = list_entry(wm_event.evtq.next, struct evt_entry, list);
+		spin_unlock_irqrestore(&wm_event.evt_lock, flags);
+
+		sscanf(e->dev->name, "wm%d", &idx);
+		netlink_send(wm_event.sock, idx, 0, e->evt_data, e->size);
+
+		spin_lock_irqsave(&wm_event.evt_lock, flags);
+		list_del(&e->list);
+		put_event_entry(e);
+	}
+
+	spin_unlock_irqrestore(&wm_event.evt_lock, flags);
+}
+
+static int gdm_wimax_event_send(struct net_device *dev, char *buf, int size)
+{
+	struct evt_entry *e;
+	unsigned long flags;
+
+	#if defined(DEBUG_HCI)
+	u16 hci_cmd =  ((u8)buf[0]<<8) | (u8)buf[1];
+	u16 hci_len = ((u8)buf[2]<<8) | (u8)buf[3];
+	printk(KERN_DEBUG "D=>H: 0x%04x(%d)\n", hci_cmd, hci_len);
+	#endif
+
+	spin_lock_irqsave(&wm_event.evt_lock, flags);
+
+	e = get_event_entry();
+	if (!e) {
+		printk(KERN_ERR "%s: No memory for event\n", __func__);
+		spin_unlock_irqrestore(&wm_event.evt_lock, flags);
+		return -ENOMEM;
+	}
+
+	e->dev = dev;
+	e->size = size;
+	memcpy(e->evt_data, buf, size);
+
+	list_add_tail(&e->list, &wm_event.evtq);
+	spin_unlock_irqrestore(&wm_event.evt_lock, flags);
+
+	schedule_work(&wm_event.ws);
+
+	return 0;
+}
+
+static void tx_complete(void *arg)
+{
+	struct nic *nic = arg;
+
+	if (netif_queue_stopped(nic->netdev))
+		netif_wake_queue(nic->netdev);
+}
+
+int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev)
+{
+	int ret = 0;
+	struct nic *nic = netdev_priv(dev);
+
+	ret = gdm_wimax_send_with_cb(nic, skb->data, skb->len, tx_complete,
+					nic);
+	if (ret == -ENOSPC) {
+		netif_stop_queue(dev);
+		ret = 0;
+	}
+
+	if (ret) {
+		skb_pull(skb, HCI_HEADER_SIZE);
+		return ret;
+	}
+
+	nic->stats.tx_packets++;
+	nic->stats.tx_bytes += skb->len - HCI_HEADER_SIZE;
+	kfree_skb(skb);
+	return ret;
+}
+
+static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
+{
+	int ret = 0;
+	struct nic *nic = netdev_priv(dev);
+	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+
+	#if defined(DEBUG_SDU)
+	dump_eth_packet("TX", skb->data, skb->len);
+	#endif
+
+	ret = gdm_wimax_header(&skb);
+	if (ret < 0) {
+		skb_pull(skb, HCI_HEADER_SIZE);
+		return ret;
+	}
+
+	#if !defined(LOOPBACK_TEST)
+	if (!fsm)
+		printk(KERN_ERR "ASSERTION ERROR: fsm is NULL!!\n");
+	else if (fsm->m_status != M_CONNECTED) {
+		printk(KERN_EMERG "ASSERTION ERROR: Device is NOT ready. status=%d\n",
+			fsm->m_status);
+		kfree_skb(skb);
+		return 0;
+	}
+	#endif
+
+#if defined(CONFIG_WIMAX_GDM72XX_QOS)
+	ret = gdm_qos_send_hci_pkt(skb, dev);
+#else
+	ret = gdm_wimax_send_tx(skb, dev);
+#endif
+	return ret;
+}
+
+static int gdm_wimax_set_config(struct net_device *dev, struct ifmap *map)
+{
+	if (dev->flags & IFF_UP)
+		return -EBUSY;
+
+	return 0;
+}
+
+static void __gdm_wimax_set_mac_addr(struct net_device *dev, char *mac_addr)
+{
+	u16 hci_pkt_buf[32 / sizeof(u16)];
+	u8 *pkt = (u8 *) &hci_pkt_buf[0];
+	struct nic *nic = netdev_priv(dev);
+
+	/* Since dev is registered as a ethernet device,
+	 * ether_setup has made dev->addr_len to be ETH_ALEN
+	 */
+	memcpy(dev->dev_addr, mac_addr, dev->addr_len);
+
+	/* Let lower layer know of this change by sending
+	 * SetInformation(MAC Address)
+	 */
+	hci_pkt_buf[0] = H2B(WIMAX_SET_INFO);	/* cmd_evt */
+	hci_pkt_buf[1] = H2B(8);			/* size */
+	pkt[4] = 0; /* T */
+	pkt[5] = 6; /* L */
+	memcpy(pkt + 6, mac_addr, dev->addr_len); /* V */
+
+	gdm_wimax_send(nic, pkt, HCI_HEADER_SIZE + 8);
+}
+
+/* A driver function */
+static int gdm_wimax_set_mac_addr(struct net_device *dev, void *p)
+{
+	struct sockaddr *addr = p;
+
+	if (netif_running(dev))
+		return -EBUSY;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	__gdm_wimax_set_mac_addr(dev, addr->sa_data);
+
+	return 0;
+}
+
+static struct net_device_stats *gdm_wimax_stats(struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+
+	return &nic->stats;
+}
+
+static int gdm_wimax_open(struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+
+	netif_start_queue(dev);
+
+	if (fsm && fsm->m_status != M_INIT)
+		gdm_wimax_ind_if_updown(dev, 1);
+	return 0;
+}
+
+static int gdm_wimax_close(struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+
+	netif_stop_queue(dev);
+
+	if (fsm && fsm->m_status != M_INIT)
+		gdm_wimax_ind_if_updown(dev, 0);
+	return 0;
+}
+
+static void kdelete(void **buf)
+{
+	if (buf && *buf) {
+		kfree(*buf);
+		*buf = NULL;
+	}
+}
+
+static int gdm_wimax_ioctl_get_data(struct data_s *dst, struct data_s *src)
+{
+	int size;
+
+	size = dst->size < src->size ? dst->size : src->size;
+
+	dst->size = size;
+	if (src->size) {
+		if (!dst->buf)
+			return -EINVAL;
+		if (copy_to_user(dst->buf, src->buf, size))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int gdm_wimax_ioctl_set_data(struct data_s *dst, struct data_s *src)
+{
+	if (!src->size) {
+		dst->size = 0;
+		return 0;
+	}
+
+	if (!src->buf)
+		return -EINVAL;
+
+	if (!(dst->buf && dst->size == src->size)) {
+		kdelete(&dst->buf);
+		dst->buf = kmalloc(src->size, GFP_KERNEL);
+		if (dst->buf == NULL)
+			return -ENOMEM;
+	}
+
+	if (copy_from_user(dst->buf, src->buf, src->size)) {
+		kdelete(&dst->buf);
+		return -EFAULT;
+	}
+	dst->size = src->size;
+	return 0;
+}
+
+static void gdm_wimax_cleanup_ioctl(struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	int i;
+
+	for (i = 0; i < SIOC_DATA_MAX; i++)
+		kdelete(&nic->sdk_data[i].buf);
+}
+
+static void gdm_update_fsm(struct net_device *dev, struct fsm_s *new_fsm)
+{
+	struct nic *nic = netdev_priv(dev);
+	struct fsm_s *cur_fsm =
+		(struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+
+	if (!cur_fsm)
+		return;
+
+	if (cur_fsm->m_status != new_fsm->m_status ||
+		cur_fsm->c_status != new_fsm->c_status) {
+		if (new_fsm->m_status == M_CONNECTED)
+			netif_carrier_on(dev);
+		else if (cur_fsm->m_status == M_CONNECTED) {
+			netif_carrier_off(dev);
+			#if defined(CONFIG_WIMAX_GDM72XX_QOS)
+			gdm_qos_release_list(nic);
+			#endif
+		}
+		gdm_wimax_ind_fsm_update(dev, new_fsm);
+	}
+}
+
+static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct wm_req_s *req = (struct wm_req_s *) ifr;
+	struct nic *nic = netdev_priv(dev);
+	int ret;
+
+	if (cmd != SIOCWMIOCTL)
+		return -EOPNOTSUPP;
+
+	switch (req->cmd) {
+	case SIOCG_DATA:
+	case SIOCS_DATA:
+		if (req->data_id >= SIOC_DATA_MAX) {
+			printk(KERN_ERR
+				"%s error: data-index(%d) is invalid!!\n",
+				__func__, req->data_id);
+			return -EOPNOTSUPP;
+		}
+		if (req->cmd == SIOCG_DATA) {
+			ret = gdm_wimax_ioctl_get_data(&req->data,
+						&nic->sdk_data[req->data_id]);
+			if (ret < 0)
+				return ret;
+		} else if (req->cmd == SIOCS_DATA) {
+			if (req->data_id == SIOC_DATA_FSM) {
+				/*NOTE: gdm_update_fsm should be called
+				before gdm_wimax_ioctl_set_data is called*/
+				gdm_update_fsm(dev,
+						(struct fsm_s *) req->data.buf);
+			}
+			ret = gdm_wimax_ioctl_set_data(
+				&nic->sdk_data[req->data_id], &req->data);
+			if (ret < 0)
+				return ret;
+		}
+		break;
+	default:
+		printk(KERN_ERR "%s: %x unknown ioctl\n", __func__, cmd);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static void gdm_wimax_prepare_device(struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	u16 buf[32 / sizeof(u16)];
+	struct hci_s *hci = (struct hci_s *) buf;
+	u16 len = 0;
+	u32 val = 0;
+
+	#define BIT_MULTI_CS	0
+	#define BIT_WIMAX		1
+	#define BIT_QOS			2
+	#define BIT_AGGREGATION	3
+
+	/* GetInformation mac address */
+	len = 0;
+	hci->cmd_evt = H2B(WIMAX_GET_INFO);
+	hci->data[len++] = TLV_T(T_MAC_ADDRESS);
+	hci->length = H2B(len);
+	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
+
+	val = (1<<BIT_WIMAX) | (1<<BIT_MULTI_CS);
+	#if defined(CONFIG_WIMAX_GDM72XX_QOS)
+	val |= (1<<BIT_QOS);
+	#endif
+	#if defined(CONFIG_WIMAX_GDM72XX_WIMAX2)
+	val |= (1<<BIT_AGGREGATION);
+	#endif
+
+	/* Set capability */
+	len = 0;
+	hci->cmd_evt = H2B(WIMAX_SET_INFO);
+	hci->data[len++] = TLV_T(T_CAPABILITY);
+	hci->data[len++] = TLV_L(T_CAPABILITY);
+	val = DH2B(val);
+	memcpy(&hci->data[len], &val, TLV_L(T_CAPABILITY));
+	len += TLV_L(T_CAPABILITY);
+	hci->length = H2B(len);
+	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
+
+	printk(KERN_INFO "GDM WiMax Set CAPABILITY: 0x%08X\n", DB2H(val));
+}
+
+static int gdm_wimax_hci_get_tlv(u8 *buf, u8 *T, u16 *L, u8 **V)
+{
+	#define __U82U16(b) ((u16)((u8 *)(b))[0] | ((u16)((u8 *)(b))[1] << 8))
+	int next_pos;
+
+	*T = buf[0];
+	if (buf[1] == 0x82) {
+		*L = B2H(__U82U16(&buf[2]));
+		next_pos = 1/*type*/+3/*len*/;
+	} else {
+		*L = buf[1];
+		next_pos = 1/*type*/+1/*len*/;
+	}
+	*V = &buf[next_pos];
+
+	next_pos += *L/*length of val*/;
+	return next_pos;
+}
+
+static int gdm_wimax_get_prepared_info(struct net_device *dev, char *buf,
+					int len)
+{
+	u8 T, *V;
+	u16 L;
+	u16 cmd_evt, cmd_len;
+	int pos = HCI_HEADER_SIZE;
+
+	cmd_evt = B2H(*(u16 *)&buf[0]);
+	cmd_len = B2H(*(u16 *)&buf[2]);
+
+	if (len < cmd_len + HCI_HEADER_SIZE) {
+		printk(KERN_ERR "%s: invalid length [%d/%d]\n", __func__,
+			cmd_len + HCI_HEADER_SIZE, len);
+		return -1;
+	}
+
+	if (cmd_evt == WIMAX_GET_INFO_RESULT) {
+		if (cmd_len < 2) {
+			printk(KERN_ERR "%s: len is too short [%x/%d]\n",
+				__func__, cmd_evt, len);
+			return -1;
+		}
+
+		pos += gdm_wimax_hci_get_tlv(&buf[pos], &T, &L, &V);
+		if (T == TLV_T(T_MAC_ADDRESS)) {
+			if (L != dev->addr_len) {
+				printk(KERN_ERR
+					"%s Invalid inofrmation result T/L "
+					"[%x/%d]\n", __func__, T, L);
+				return -1;
+			}
+			printk(KERN_INFO
+				"MAC change [%02x:%02x:%02x:%02x:%02x:%02x]"
+				"->[%02x:%02x:%02x:%02x:%02x:%02x]\n",
+				dev->dev_addr[0], dev->dev_addr[1],
+				dev->dev_addr[2], dev->dev_addr[3],
+				dev->dev_addr[4], dev->dev_addr[5],
+				V[0], V[1], V[2], V[3], V[4], V[5]);
+			memcpy(dev->dev_addr, V, dev->addr_len);
+			return 1;
+		}
+	}
+
+	gdm_wimax_event_send(dev, buf, len);
+	return 0;
+}
+
+static void gdm_wimax_netif_rx(struct net_device *dev, char *buf, int len)
+{
+	struct nic *nic = netdev_priv(dev);
+	struct sk_buff *skb;
+	int ret;
+
+	#if defined(DEBUG_SDU)
+	dump_eth_packet("RX", buf, len);
+	#endif
+
+	skb = dev_alloc_skb(len + 2);
+	if (!skb) {
+		printk(KERN_ERR "%s: dev_alloc_skb failed!\n", __func__);
+		return;
+	}
+	skb_reserve(skb, 2);
+
+	nic->stats.rx_packets++;
+	nic->stats.rx_bytes += len;
+
+	memcpy(skb_put(skb, len), buf, len);
+
+	skb->dev = dev;
+	skb->protocol = eth_type_trans(skb, dev); /* what will happen? */
+
+	ret = in_interrupt() ? netif_rx(skb) : netif_rx_ni(skb);
+	if (ret == NET_RX_DROP)
+		printk(KERN_ERR "%s skb dropped\n", __func__);
+}
+
+static void gdm_wimax_transmit_aggr_pkt(struct net_device *dev, char *buf,
+					int len)
+{
+	#define HCI_PADDING_BYTE	4
+	#define HCI_RESERVED_BYTE	4
+	struct hci_s *hci;
+	int length;
+
+	while (len > 0) {
+		hci = (struct hci_s *) buf;
+
+		if (B2H(hci->cmd_evt) != WIMAX_RX_SDU) {
+			printk(KERN_ERR "Wrong cmd_evt(0x%04X)\n",
+				B2H(hci->cmd_evt));
+			break;
+		}
+
+		length = B2H(hci->length);
+		gdm_wimax_netif_rx(dev, hci->data, length);
+
+		if (length & 0x3) {
+			/* Add padding size */
+			length += HCI_PADDING_BYTE - (length & 0x3);
+		}
+
+		length += HCI_HEADER_SIZE + HCI_RESERVED_BYTE;
+		len -= length;
+		buf += length;
+	}
+}
+
+static void gdm_wimax_transmit_pkt(struct net_device *dev, char *buf, int len)
+{
+	#if defined(CONFIG_WIMAX_GDM72XX_QOS)
+	struct nic *nic = netdev_priv(dev);
+	#endif
+	u16 cmd_evt, cmd_len;
+
+	/* This code is added for certain rx packet to be ignored. */
+	if (len == 0)
+		return;
+
+	cmd_evt = B2H(*(u16 *)&buf[0]);
+	cmd_len = B2H(*(u16 *)&buf[2]);
+
+	if (len < cmd_len + HCI_HEADER_SIZE) {
+		if (len)
+			printk(KERN_ERR "%s: invalid length [%d/%d]\n",
+				__func__, cmd_len + HCI_HEADER_SIZE, len);
+		return;
+	}
+
+	switch (cmd_evt) {
+	case WIMAX_RX_SDU_AGGR:
+		gdm_wimax_transmit_aggr_pkt(dev, &buf[HCI_HEADER_SIZE],
+						cmd_len);
+		break;
+	case WIMAX_RX_SDU:
+		gdm_wimax_netif_rx(dev, &buf[HCI_HEADER_SIZE], cmd_len);
+		break;
+	#if defined(CONFIG_WIMAX_GDM72XX_QOS)
+	case WIMAX_EVT_MODEM_REPORT:
+		gdm_recv_qos_hci_packet(nic, buf, len);
+		break;
+	#endif
+	case WIMAX_SDU_TX_FLOW:
+		if (buf[4] == 0) {
+			if (!netif_queue_stopped(dev))
+				netif_stop_queue(dev);
+		} else if (buf[4] == 1) {
+			if (netif_queue_stopped(dev))
+				netif_wake_queue(dev);
+		}
+		break;
+	default:
+		gdm_wimax_event_send(dev, buf, len);
+		break;
+	}
+}
+
+static void gdm_wimax_ind_fsm_update(struct net_device *dev, struct fsm_s *fsm)
+{
+	u16 buf[32 / sizeof(u16)];
+	u8 *hci_pkt_buf = (u8 *)&buf[0];
+
+	/* Indicate updating fsm */
+	buf[0] = H2B(WIMAX_FSM_UPDATE);
+	buf[1] = H2B(sizeof(struct fsm_s));
+	memcpy(&hci_pkt_buf[HCI_HEADER_SIZE], fsm, sizeof(struct fsm_s));
+
+	gdm_wimax_event_send(dev, hci_pkt_buf,
+				HCI_HEADER_SIZE + sizeof(struct fsm_s));
+}
+
+static void gdm_wimax_ind_if_updown(struct net_device *dev, int if_up)
+{
+	u16 buf[32 / sizeof(u16)];
+	struct hci_s *hci = (struct hci_s *) buf;
+	unsigned char up_down;
+
+	up_down = if_up ? WIMAX_IF_UP : WIMAX_IF_DOWN;
+
+	/* Indicate updating fsm */
+	hci->cmd_evt = H2B(WIMAX_IF_UPDOWN);
+	hci->length = H2B(sizeof(up_down));
+	hci->data[0] = up_down;
+
+	gdm_wimax_event_send(dev, (char *)hci, HCI_HEADER_SIZE+sizeof(up_down));
+}
+
+static void rx_complete(void *arg, void *data, int len)
+{
+	struct nic *nic = arg;
+
+	gdm_wimax_transmit_pkt(nic->netdev, data, len);
+	gdm_wimax_rcv_with_cb(nic, rx_complete, nic);
+}
+
+static void prepare_rx_complete(void *arg, void *data, int len)
+{
+	struct nic *nic = arg;
+	int ret;
+
+	ret = gdm_wimax_get_prepared_info(nic->netdev, data, len);
+	if (ret == 1)
+		gdm_wimax_rcv_with_cb(nic, rx_complete, nic);
+	else {
+		if (ret < 0)
+			printk(KERN_ERR "get_prepared_info failed(%d)\n", ret);
+		gdm_wimax_rcv_with_cb(nic, prepare_rx_complete, nic);
+		#if 0
+		/* Re-prepare WiMax device */
+		gdm_wimax_prepare_device(nic->netdev);
+		#endif
+	}
+}
+
+static void start_rx_proc(struct nic *nic)
+{
+	gdm_wimax_rcv_with_cb(nic, prepare_rx_complete, nic);
+}
+
+static struct net_device_ops gdm_netdev_ops = {
+	.ndo_open				= gdm_wimax_open,
+	.ndo_stop				= gdm_wimax_close,
+	.ndo_set_config			= gdm_wimax_set_config,
+	.ndo_start_xmit			= gdm_wimax_tx,
+	.ndo_get_stats			= gdm_wimax_stats,
+	.ndo_set_mac_address	= gdm_wimax_set_mac_addr,
+	.ndo_do_ioctl			= gdm_wimax_ioctl,
+};
+
+int register_wimax_device(struct phy_dev *phy_dev)
+{
+	struct nic *nic = NULL;
+	struct net_device *dev;
+	int ret;
+
+	dev = (struct net_device *)alloc_netdev(sizeof(*nic),
+						"wm%d", ether_setup);
+
+	if (dev == NULL) {
+		printk(KERN_ERR "alloc_etherdev failed\n");
+		return -ENOMEM;
+	}
+
+	dev->mtu = 1400;
+	dev->netdev_ops = &gdm_netdev_ops;
+	dev->flags &= ~IFF_MULTICAST;
+	memcpy(dev->dev_addr, gdm_wimax_macaddr, sizeof(gdm_wimax_macaddr));
+
+	nic = netdev_priv(dev);
+	memset(nic, 0, sizeof(*nic));
+
+	nic->netdev = dev;
+	nic->phy_dev = phy_dev;
+	phy_dev->netdev = dev;
+
+	/* event socket init */
+	ret = gdm_wimax_event_init();
+	if (ret < 0) {
+		printk(KERN_ERR "Cannot create event.\n");
+		goto cleanup;
+	}
+
+	ret = register_netdev(dev);
+	if (ret)
+		goto cleanup;
+
+	#if defined(LOOPBACK_TEST)
+	netif_start_queue(dev);
+	netif_carrier_on(dev);
+	#else
+	netif_carrier_off(dev);
+	#endif
+
+#ifdef CONFIG_WIMAX_GDM72XX_QOS
+	gdm_qos_init(nic);
+#endif
+
+	start_rx_proc(nic);
+
+	/* Prepare WiMax device */
+	gdm_wimax_prepare_device(dev);
+
+	return 0;
+
+cleanup:
+	printk(KERN_ERR "register_netdev failed\n");
+	free_netdev(dev);
+	return ret;
+}
+
+void unregister_wimax_device(struct phy_dev *phy_dev)
+{
+	struct nic *nic = netdev_priv(phy_dev->netdev);
+	struct fsm_s *fsm = (struct fsm_s *) nic->sdk_data[SIOC_DATA_FSM].buf;
+
+	if (fsm)
+		fsm->m_status = M_INIT;
+	unregister_netdev(nic->netdev);
+
+	gdm_wimax_event_exit();
+
+#if defined(CONFIG_WIMAX_GDM72XX_QOS)
+	gdm_qos_release_list(nic);
+#endif
+
+	gdm_wimax_cleanup_ioctl(phy_dev->netdev);
+
+	free_netdev(nic->netdev);
+}
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
new file mode 100644
index 0000000..bb6826f
--- /dev/null
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#ifndef __GDM_WIMAX_H__
+#define __GDM_WIMAX_H__
+
+#include <linux/netdevice.h>
+#include <linux/version.h>
+#include <linux/types.h>
+#include "wm_ioctl.h"
+#if defined(CONFIG_WIMAX_GDM72XX_QOS)
+#include "gdm_qos.h"
+#endif
+
+#define DRIVER_VERSION		"3.2.3"
+
+/*#define ETH_P_IP	0x0800 */
+/*#define ETH_P_ARP	0x0806 */
+/*#define ETH_P_IPV6	0x86DD */
+
+#define H2L(x)		__cpu_to_le16(x)
+#define L2H(x)		__le16_to_cpu(x)
+#define DH2L(x)		__cpu_to_le32(x)
+#define DL2H(x)		__le32_to_cpu(x)
+
+#define H2B(x)		__cpu_to_be16(x)
+#define B2H(x)		__be16_to_cpu(x)
+#define DH2B(x)		__cpu_to_be32(x)
+#define DB2H(x)		__be32_to_cpu(x)
+
+struct phy_dev {
+	void	*priv_dev;
+	struct net_device	*netdev;
+
+	int	(*send_func)(void *priv_dev, void *data, int len,
+			void (*cb)(void *cb_data), void *cb_data);
+	int	(*rcv_func)(void *priv_dev,
+			void (*cb)(void *cb_data, void *data, int len),
+			void *cb_data);
+};
+
+struct nic {
+	struct net_device	*netdev;
+	struct phy_dev		*phy_dev;
+
+	struct net_device_stats	stats;
+
+	struct data_s	sdk_data[SIOC_DATA_MAX];
+
+#if defined(CONFIG_WIMAX_GDM72XX_QOS)
+	struct qos_cb_s	qos;
+#endif
+
+};
+
+
+#if 0
+#define dprintk(fmt, args ...)	printk(KERN_DEBUG " [GDM] " fmt, ## args)
+#else
+#define dprintk(...)
+#endif
+
+/*#define DEBUG_SDU */
+#if defined(DEBUG_SDU)
+#define DUMP_SDU_ALL		(1<<0)
+#define DUMP_SDU_ARP		(1<<1)
+#define DUMP_SDU_IP			(1<<2)
+#define DUMP_SDU_IP_TCP		(1<<8)
+#define DUMP_SDU_IP_UDP		(1<<9)
+#define DUMP_SDU_IP_ICMP	(1<<10)
+#define DUMP_PACKET			(DUMP_SDU_ALL)
+#endif
+
+/*#define DEBUG_HCI */
+
+/*#define LOOPBACK_TEST */
+
+extern int register_wimax_device(struct phy_dev *phy_dev);
+extern int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev);
+extern void unregister_wimax_device(struct phy_dev *phy_dev);
+
+#endif
diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
new file mode 100644
index 0000000..651d7b5
--- /dev/null
+++ b/drivers/staging/gdm72xx/hci.h
@@ -0,0 +1,211 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#ifndef HCI_H_20080801
+#define HCI_H_20080801
+
+#define HCI_HEADER_SIZE		4
+#define HCI_VALUE_OFFS		(HCI_HEADER_SIZE)
+#define HCI_MAX_PACKET		2048
+#define HCI_MAX_PARAM		(HCI_MAX_PACKET-HCI_HEADER_SIZE)
+#define HCI_MAX_TLV			32
+
+/* CMD-EVT */
+
+/* Category 0 */
+#define WIMAX_RESET				0x0000
+#define WIMAX_SET_INFO			0x0001
+#define WIMAX_GET_INFO			0x0002
+#define WIMAX_GET_INFO_RESULT	0x8003
+#define WIMAX_RADIO_OFF			0x0004
+#define WIMAX_RADIO_ON			0x0006
+#define WIMAX_WIMAX_RESET		0x0007	/* Is this still here */
+
+/* Category 1 */
+#define WIMAX_NET_ENTRY			0x0100
+#define WIMAX_NET_DISCONN		0x0102
+#define WIMAX_ENTER_SLEEP		0x0103
+#define WIMAX_EXIT_SLEEP		0x0104
+#define WIMAX_ENTER_IDLE		0x0105
+#define WIMAX_EXIT_IDLE			0x0106
+#define WIMAX_MODE_CHANGE		0x8108
+#define WIMAX_HANDOVER			0x8109	/* obsolete */
+
+#define WIMAX_SCAN				0x010d
+#define WIMAX_SCAN_COMPLETE		0x810e
+#define WIMAX_SCAN_RESULT		0x810f
+
+#define WIMAX_CONNECT			0x0110
+#define WIMAX_CONNECT_START		0x8111
+#define WIMAX_CONNECT_COMPLETE	0x8112
+#define WIMAX_ASSOC_START		0x8113
+#define WIMAX_ASSOC_COMPLETE	0x8114
+#define WIMAX_DISCONN_IND		0x8115
+#define WIMAX_ENTRY_IND			0x8116
+#define WIMAX_HO_START			0x8117
+#define WIMAX_HO_COMPLETE		0x8118
+#define WIMAX_RADIO_STATE_IND	0x8119
+#define WIMAX_IP_RENEW_IND		0x811a
+
+#define WIMAX_DISCOVER_NSP			0x011d
+#define WIMAX_DISCOVER_NSP_RESULT	0x811e
+
+#define WIMAX_SDU_TX_FLOW		0x8125
+
+/* Category 2 */
+#define WIMAX_TX_EAP		0x0200
+#define WIMAX_RX_EAP		0x8201
+#define WIMAX_TX_SDU		0x0202
+#define WIMAX_RX_SDU		0x8203
+#define WIMAX_RX_SDU_AGGR	0x8204
+#define WIMAX_TX_SDU_AGGR	0x0205
+
+/* Category 3 */
+#define WIMAX_DM_CMD				0x030a
+#define WIMAX_DM_RSP				0x830b
+
+#define WIMAX_CLI_CMD				0x030c
+#define WIMAX_CLI_RSP				0x830d
+
+#define WIMAX_DL_IMAGE				0x0310
+#define WIMAX_DL_IMAGE_STATUS		0x8311
+#define WIMAX_UL_IMAGE				0x0312
+#define WIMAX_UL_IMAGE_RESULT		0x8313
+#define WIMAX_UL_IMAGE_STATUS		0x0314
+
+#define WIMAX_EVT_MODEM_REPORT		0x8325
+
+/* Category 0xF */
+#define WIMAX_FSM_UPDATE			0x8F01
+#define WIMAX_IF_UPDOWN				0x8F02
+	#define WIMAX_IF_UP				1
+	#define WIMAX_IF_DOWN			2
+
+/* WIMAX mode */
+#define W_NULL				0
+#define W_STANDBY			1
+#define W_OOZ				2
+#define W_AWAKE				3
+#define W_IDLE				4
+#define W_SLEEP				5
+#define W_WAIT				6
+
+#define W_NET_ENTRY_RNG		0x80
+#define W_NET_ENTRY_SBC		0x81
+#define W_NET_ENTRY_PKM		0x82
+#define W_NET_ENTRY_REG		0x83
+#define W_NET_ENTRY_DSX		0x84
+
+#define W_NET_ENTRY_RNG_FAIL	0x1100100
+#define W_NET_ENTRY_SBC_FAIL	0x1100200
+#define W_NET_ENTRY_PKM_FAIL	0x1102000
+#define W_NET_ENTRY_REG_FAIL	0x1103000
+#define W_NET_ENTRY_DSX_FAIL	0x1104000
+
+/* Scan Type */
+#define W_SCAN_ALL_CHANNEL				0
+#define W_SCAN_ALL_SUBSCRIPTION			1
+#define W_SCAN_SPECIFIED_SUBSCRIPTION	2
+
+/*
+ * TLV
+ *
+ * [31:31] indicates the type is composite.
+ * [30:16] is the length of the type. 0 length means length is variable.
+ * [15:0] is the actual type.
+ *
+ */
+#define TLV_L(x)		(((x) >> 16) & 0xff)
+#define TLV_T(x)			((x) & 0xff)
+#define TLV_COMPOSITE(x)	((x) >> 31)
+
+/* GENERAL */
+#define T_MAC_ADDRESS			(0x00	| (6 << 16))
+#define T_BSID				(0x01	| (6 << 16))
+#define T_MSK				(0x02	| (64 << 16))
+#define T_RSSI_THRSHLD			(0x03	| (1 << 16))
+#define T_FREQUENCY			(0x04	| (4 << 16))
+#define T_CONN_CS_TYPE			(0x05	| (1 << 16))
+#define T_HOST_IP_VER			(0x06	| (1 << 16))
+#define T_STBY_SCAN_INTERVAL		(0x07	| (4  << 16))
+#define T_OOZ_SCAN_INTERVAL		(0x08	| (4 << 16))
+#define T_IMEI				(0x09	| (8 << 16))
+#define T_PID				(0x0a	| (12 << 16))
+
+#define T_CAPABILITY			(0x1a	| (4 << 16))
+#define T_RELEASE_NUMBER		(0x1b	| (4 << 16))
+#define T_DRIVER_REVISION		(0x1c	| (4 << 16))
+#define T_FW_REVISION			(0x1d	| (4 << 16))
+#define T_MAC_HW_REVISION		(0x1e	| (4 << 16))
+#define T_PHY_HW_REVISION		(0x1f	| (4 << 16))
+
+/* HANDOVER */
+#define T_SCAN_INTERVAL		(0x20	| (1 << 16))
+
+#define T_RSC_RETAIN_TIME		(0x2f	| (2 << 16))
+
+/* SLEEP */
+#define T_TYPE1_ISW			(0x40	| (1 << 16))
+
+#define T_SLP_START_TO			(0x4a	| (2 << 16))
+
+/* IDLE */
+#define T_IDLE_MODE_TO			(0x50	| (2 << 16))
+
+#define T_IDLE_START_TO		(0x54	| (2 << 16))
+
+/* MONITOR */
+#define T_RSSI				(0x60	| (1 << 16))
+#define T_CINR				(0x61	| (1 << 16))
+#define T_TX_POWER			(0x6a   | (1 << 16))
+#define T_CUR_FREQ			(0x7f	| (4 << 16))
+
+
+/* WIMAX */
+#define T_MAX_SUBSCRIPTION		(0xa1	| (1 << 16))
+#define T_MAX_SF			(0xa2	| (1 << 16))
+#define T_PHY_TYPE			(0xa3	| (1 << 16))
+#define T_PKM				(0xa4	| (1 << 16))
+#define T_AUTH_POLICY			(0xa5	| (1 << 16))
+#define T_CS_TYPE			(0xa6	| (2 << 16))
+#define T_VENDOR_NAME			(0xa7	| (0 << 16))
+#define T_MOD_NAME			(0xa8	| (0 << 16))
+#define T_PACKET_FILTER		(0xa9	| (1 << 16))
+#define T_NSP_CHANGE_COUNT		(0xaa	| (4 << 16))
+#define T_RADIO_STATE			(0xab	| (1 << 16))
+#define T_URI_CONTACT_TYPE		(0xac	| (1 << 16))
+#define T_URI_TEXT			(0xad	| (0 << 16))
+#define T_URI				(0xae	| (0 << 16))
+#define T_ENABLE_AUTH			(0xaf	| (1 << 16))
+#define T_TIMEOUT			(0xb0   | (2 << 16))
+#define T_RUN_MODE			(0xb1	| (1 << 16))
+#define T_OMADMT_VER			(0xb2	| (4 << 16))
+/* This is measured in seconds from 00:00:00 GMT January 1, 1970. */
+#define T_RTC_TIME			(0xb3	| (4 << 16))
+#define T_CERT_STATUS			(0xb4	| (4 << 16))
+#define T_CERT_MASK			(0xb5	| (4 << 16))
+#define T_EMSK				(0xb6	| (64 << 16))
+
+/* Subscription TLV */
+#define T_SUBSCRIPTION_LIST		(0xd1	| (0 << 16) | (1 << 31))
+#define T_H_NSPID			(0xd2	| (3 << 16))
+#define T_NSP_NAME			(0xd3	| (0 << 16))
+#define T_SUBSCRIPTION_NAME		(0xd4	| (0 << 16))
+#define T_SUBSCRIPTION_FLAG		(0xd5	| (2 << 16))
+#define T_V_NSPID			(0xd6	| (3 << 16))
+#define T_NAP_ID			(0xd7	| (3 << 16))
+#define T_PREAMBLES			(0xd8	| (15 << 16))
+#define T_BW				(0xd9	| (4 << 16))
+#define T_FFTSIZE			(0xda	| (4 << 16))
+#define T_DUPLEX_MODE			(0xdb	| (4 << 16))
+
+struct hci_s {
+	unsigned short cmd_evt;
+	unsigned short length;
+	unsigned char  data[0];
+} __packed;
+
+#endif
diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
new file mode 100644
index 0000000..aaa1451
--- /dev/null
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -0,0 +1,143 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/etherdevice.h>
+#include <linux/netlink.h>
+#include <asm/byteorder.h>
+#include <net/sock.h>
+
+#if !defined(NLMSG_HDRLEN)
+#define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
+#endif
+
+#define ND_MAX_GROUP			30
+#define ND_IFINDEX_LEN			sizeof(int)
+#define ND_NLMSG_SPACE(len)		(NLMSG_SPACE(len) + ND_IFINDEX_LEN)
+#define ND_NLMSG_DATA(nlh) \
+	((void *)((char *)NLMSG_DATA(nlh) + ND_IFINDEX_LEN))
+#define ND_NLMSG_S_LEN(len)		(len+ND_IFINDEX_LEN)
+#define ND_NLMSG_R_LEN(nlh)		(nlh->nlmsg_len-ND_IFINDEX_LEN)
+#define ND_NLMSG_IFIDX(nlh)		NLMSG_DATA(nlh)
+#define ND_MAX_MSG_LEN			8096
+
+#if defined(DEFINE_MUTEX)
+static DEFINE_MUTEX(netlink_mutex);
+#else
+static struct semaphore netlink_mutex;
+#define mutex_lock(x)		down(x)
+#define mutex_unlock(x)		up(x)
+#endif
+
+static void (*rcv_cb)(struct net_device *dev, u16 type, void *msg, int len);
+
+static void netlink_rcv_cb(struct sk_buff *skb)
+{
+	struct nlmsghdr *nlh;
+	struct net_device *dev;
+	u32 mlen;
+	void *msg;
+	int ifindex;
+
+	if (skb->len >= NLMSG_SPACE(0)) {
+		nlh = (struct nlmsghdr *)skb->data;
+
+		if (skb->len < nlh->nlmsg_len ||
+		nlh->nlmsg_len > ND_MAX_MSG_LEN) {
+			printk(KERN_ERR "Invalid length (%d,%d)\n", skb->len,
+				nlh->nlmsg_len);
+			return;
+		}
+
+		memcpy(&ifindex, ND_NLMSG_IFIDX(nlh), ND_IFINDEX_LEN);
+		msg = ND_NLMSG_DATA(nlh);
+		mlen = ND_NLMSG_R_LEN(nlh);
+
+		if (rcv_cb) {
+			dev = dev_get_by_index(&init_net, ifindex);
+			if (dev) {
+				rcv_cb(dev, nlh->nlmsg_type, msg, mlen);
+				dev_put(dev);
+			} else
+				printk(KERN_ERR "dev_get_by_index(%d) "
+					"is not found.\n", ifindex);
+		} else
+			printk(KERN_ERR "Unregistered Callback\n");
+	}
+}
+
+static void netlink_rcv(struct sk_buff *skb)
+{
+	mutex_lock(&netlink_mutex);
+	netlink_rcv_cb(skb);
+	mutex_unlock(&netlink_mutex);
+}
+
+struct sock *netlink_init(int unit, void (*cb)(struct net_device *dev, u16 type,
+						void *msg, int len))
+{
+	struct sock *sock;
+
+#if !defined(DEFINE_MUTEX)
+	init_MUTEX(&netlink_mutex);
+#endif
+
+	sock = netlink_kernel_create(&init_net, unit, 0, netlink_rcv, NULL,
+					THIS_MODULE);
+
+	if (sock)
+		rcv_cb = cb;
+
+	return sock;
+}
+
+void netlink_exit(struct sock *sock)
+{
+	sock_release(sock->sk_socket);
+}
+
+int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
+{
+	static u32 seq;
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh;
+	int ret = 0;
+
+	if (group > ND_MAX_GROUP) {
+		printk(KERN_ERR "Group %d is invalied.\n", group);
+		printk(KERN_ERR "Valid group is 0 ~ %d.\n", ND_MAX_GROUP);
+		return -EINVAL;
+	}
+
+	skb = alloc_skb(NLMSG_SPACE(len), GFP_ATOMIC);
+	if (!skb) {
+		printk(KERN_ERR "netlink_broadcast ret=%d\n", ret);
+		return -ENOMEM;
+	}
+
+	seq++;
+	nlh = NLMSG_PUT(skb, 0, seq, type, len);
+	memcpy(NLMSG_DATA(nlh), msg, len);
+
+	NETLINK_CB(skb).pid = 0;
+	NETLINK_CB(skb).dst_group = 0;
+
+	ret = netlink_broadcast(sock, skb, 0, group+1, GFP_ATOMIC);
+
+	if (!ret)
+		return len;
+	else {
+		if (ret != -ESRCH) {
+			printk(KERN_ERR "netlink_broadcast g=%d, t=%d, l=%d, r=%d\n",
+				group, type, len, ret);
+		}
+		ret = 0;
+	}
+
+nlmsg_failure:
+	return ret;
+}
diff --git a/drivers/staging/gdm72xx/netlink_k.h b/drivers/staging/gdm72xx/netlink_k.h
new file mode 100644
index 0000000..5c04532
--- /dev/null
+++ b/drivers/staging/gdm72xx/netlink_k.h
@@ -0,0 +1,17 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#if !defined(NETLINK_H_20081202)
+#define NETLINK_H_20081202
+#include <linux/netdevice.h>
+#include <net/sock.h>
+
+struct sock *netlink_init(int unit,
+	void (*cb)(struct net_device *dev, u16 type, void *msg, int len));
+void netlink_exit(struct sock *sock);
+int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len);
+
+#endif
diff --git a/drivers/staging/gdm72xx/sdio_boot.c b/drivers/staging/gdm72xx/sdio_boot.c
new file mode 100644
index 0000000..e5c9714
--- /dev/null
+++ b/drivers/staging/gdm72xx/sdio_boot.c
@@ -0,0 +1,152 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <linux/mmc/core.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+
+#include "gdm_sdio.h"
+
+#define TYPE_A_HEADER_SIZE	4
+#define TYPE_A_LOOKAHEAD_SIZE   16
+#define YMEM0_SIZE			0x8000	/* 32kbytes */
+#define DOWNLOAD_SIZE		(YMEM0_SIZE - TYPE_A_HEADER_SIZE)
+
+#define KRN_PATH	"/lib/firmware/gdm72xx/gdmskrn.bin"
+#define RFS_PATH	"/lib/firmware/gdm72xx/gdmsrfs.bin"
+
+static u8 *tx_buf;
+
+static int ack_ready(struct sdio_func *func)
+{
+	unsigned long start = jiffies;
+	u8 val;
+	int ret;
+
+	while ((jiffies - start) < HZ) {
+		val = sdio_readb(func, 0x13, &ret);
+		if (val & 0x01)
+			return 1;
+		schedule();
+	}
+
+	return 0;
+}
+
+static int download_image(struct sdio_func *func, char *img_name)
+{
+	int ret = 0, len, size, pno;
+	struct file *filp = NULL;
+	struct inode *inode = NULL;
+	u8 *buf = tx_buf;
+	loff_t pos = 0;
+
+	filp = filp_open(img_name, O_RDONLY | O_LARGEFILE, 0);
+	if (IS_ERR(filp)) {
+		printk(KERN_ERR "Can't find %s.\n", img_name);
+		return -ENOENT;
+	}
+
+	if (filp->f_dentry)
+		inode = filp->f_dentry->d_inode;
+	if (!inode || !S_ISREG(inode->i_mode)) {
+		printk(KERN_ERR "Invalid file type: %s\n", img_name);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	size = i_size_read(inode->i_mapping->host);
+	if (size <= 0) {
+		printk(KERN_ERR "Unable to find file size: %s\n", img_name);
+		ret = size;
+		goto out;
+	}
+
+	pno = 0;
+	while ((len = filp->f_op->read(filp, buf + TYPE_A_HEADER_SIZE,
+					DOWNLOAD_SIZE, &pos))) {
+		if (len < 0) {
+			ret = -1;
+			goto out;
+		}
+
+		buf[0] = len & 0xff;
+		buf[1] = (len >> 8) & 0xff;
+		buf[2] = (len >> 16) & 0xff;
+
+		if (pos >= size)	/* The last packet */
+			buf[3] = 2;
+		else
+			buf[3] = 0;
+
+		ret = sdio_memcpy_toio(func, 0, buf, len + TYPE_A_HEADER_SIZE);
+		if (ret < 0) {
+			printk(KERN_ERR "gdmwm: send image error: "
+				"packet number = %d ret = %d\n", pno, ret);
+			goto out;
+		}
+		if (buf[3] == 2)	/* The last packet */
+			break;
+		if (!ack_ready(func)) {
+			ret = -EIO;
+			printk(KERN_ERR "gdmwm: Ack is not ready.\n");
+			goto out;
+		}
+		ret = sdio_memcpy_fromio(func, buf, 0, TYPE_A_LOOKAHEAD_SIZE);
+		if (ret < 0) {
+			printk(KERN_ERR "gdmwm: receive ack error: "
+				"packet number = %d ret = %d\n", pno, ret);
+			goto out;
+		}
+		sdio_writeb(func, 0x01, 0x13, &ret);
+		sdio_writeb(func, 0x00, 0x10, &ret);	/* PCRRT */
+
+		pno++;
+	}
+out:
+	filp_close(filp, current->files);
+	return ret;
+}
+
+int sdio_boot(struct sdio_func *func)
+{
+	static mm_segment_t fs;
+	int ret;
+
+	tx_buf = kmalloc(YMEM0_SIZE, GFP_KERNEL);
+	if (tx_buf == NULL) {
+		printk(KERN_ERR "Error: kmalloc: %s %d\n", __func__, __LINE__);
+		return -ENOMEM;
+	}
+
+	fs = get_fs();
+	set_fs(get_ds());
+
+	ret = download_image(func, KRN_PATH);
+	if (ret)
+		goto restore_fs;
+	printk(KERN_INFO "GCT: Kernel download success.\n");
+
+	ret = download_image(func, RFS_PATH);
+	if (ret)
+		goto restore_fs;
+	printk(KERN_INFO "GCT: Filesystem download success.\n");
+
+restore_fs:
+	set_fs(fs);
+	kfree(tx_buf);
+	return ret;
+}
diff --git a/drivers/staging/gdm72xx/sdio_boot.h b/drivers/staging/gdm72xx/sdio_boot.h
new file mode 100644
index 0000000..b4c40cb
--- /dev/null
+++ b/drivers/staging/gdm72xx/sdio_boot.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#ifndef __SDIO_BOOT_H__
+#define __SDIO_BOOT_H__
+
+struct sdio_func;
+
+extern int sdio_boot(struct sdio_func *func);
+
+#endif /* __SDIO_BOOT_H__ */
diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
new file mode 100644
index 0000000..0eca205
--- /dev/null
+++ b/drivers/staging/gdm72xx/usb_boot.c
@@ -0,0 +1,397 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/usb.h>
+#include <linux/unistd.h>
+#include <linux/slab.h>
+
+#include <asm/byteorder.h>
+#include "gdm_usb.h"
+#include "usb_boot.h"
+
+#define DN_KERNEL_MAGIC_NUMBER		0x10760001
+#define DN_ROOTFS_MAGIC_NUMBER		0x10760002
+
+#define DOWNLOAD_SIZE	1024
+
+#define DH2B(x)		__cpu_to_be32(x)
+#define DL2H(x)		__le32_to_cpu(x)
+
+#define MIN(a, b)	((a) > (b) ? (b) : (a))
+
+#define MAX_IMG_CNT		16
+#define UIMG_PATH		"/lib/firmware/gdm72xx/gdmuimg.bin"
+#define KERN_PATH		"/lib/firmware/gdm72xx/zImage"
+#define FS_PATH			"/lib/firmware/gdm72xx/ramdisk.jffs2"
+
+struct dn_header {
+	u32	magic_num;
+	u32	file_size;
+};
+
+struct img_header {
+	u32		magic_code;
+	u32		count;
+	u32		len;
+	u32		offset[MAX_IMG_CNT];
+	char	hostname[32];
+	char	date[32];
+};
+
+struct fw_info {
+	u32		id;
+	u32		len;
+	u32		kernel_len;
+	u32		rootfs_len;
+	u32		kernel_offset;
+	u32		rootfs_offset;
+	u32		fw_ver;
+	u32		mac_ver;
+	char	hostname[32];
+	char	userid[16];
+	char	date[32];
+	char	user_desc[128];
+};
+
+static void array_le32_to_cpu(u32 *arr, int num)
+{
+	int i;
+	for (i = 0; i < num; i++, arr++)
+		*arr = DL2H(*arr);
+}
+
+static u8 *tx_buf;
+
+static int gdm_wibro_send(struct usb_device *usbdev, void *data, int len)
+{
+	int ret;
+	int actual;
+
+	ret = usb_bulk_msg(usbdev, usb_sndbulkpipe(usbdev, 1), data, len,
+			&actual, 1000);
+
+	if (ret < 0) {
+		printk(KERN_ERR "Error : usb_bulk_msg ( result = %d )\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int gdm_wibro_recv(struct usb_device *usbdev, void *data, int len)
+{
+	int ret;
+	int actual;
+
+	ret = usb_bulk_msg(usbdev, usb_rcvbulkpipe(usbdev, 2), data, len,
+			&actual, 5000);
+
+	if (ret < 0) {
+		printk(KERN_ERR "Error : usb_bulk_msg(recv) ( result = %d )\n",
+			ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int download_image(struct usb_device *usbdev, struct file *filp,
+				loff_t *pos, u32 img_len, u32 magic_num)
+{
+	struct dn_header h;
+	int ret = 0;
+	u32 size;
+	int len, readn;
+
+	size = (img_len + DOWNLOAD_SIZE - 1) & ~(DOWNLOAD_SIZE - 1);
+	h.magic_num = DH2B(magic_num);
+	h.file_size = DH2B(size);
+
+	ret = gdm_wibro_send(usbdev, &h, sizeof(h));
+	if (ret < 0)
+		goto out;
+
+	readn = 0;
+	while ((len = filp->f_op->read(filp, tx_buf, DOWNLOAD_SIZE, pos))) {
+
+		if (len < 0) {
+			ret = -1;
+			goto out;
+		}
+		readn += len;
+
+		ret = gdm_wibro_send(usbdev, tx_buf, DOWNLOAD_SIZE);
+		if (ret < 0)
+			goto out;
+		if (readn >= img_len)
+			break;
+	}
+
+	if (readn < img_len) {
+		printk(KERN_ERR "gdmwm: Cannot read to the requested size. "
+			"Read = %d Requested = %d\n", readn, img_len);
+		ret = -EIO;
+	}
+out:
+
+	return ret;
+}
+
+int usb_boot(struct usb_device *usbdev, u16 pid)
+{
+	int i, ret = 0;
+	struct file *filp = NULL;
+	struct inode *inode = NULL;
+	static mm_segment_t fs;
+	struct img_header hdr;
+	struct fw_info fw_info;
+	loff_t pos = 0;
+	char *img_name = UIMG_PATH;
+	int len;
+
+	tx_buf = kmalloc(DOWNLOAD_SIZE, GFP_KERNEL);
+	if (tx_buf == NULL) {
+		printk(KERN_ERR "Error: kmalloc\n");
+		return -ENOMEM;
+	}
+
+	fs = get_fs();
+	set_fs(get_ds());
+
+	filp = filp_open(img_name, O_RDONLY | O_LARGEFILE, 0);
+	if (IS_ERR(filp)) {
+		printk(KERN_ERR "Can't find %s.\n", img_name);
+		set_fs(fs);
+		ret = -ENOENT;
+		goto restore_fs;
+	}
+
+	if (filp->f_dentry)
+		inode = filp->f_dentry->d_inode;
+	if (!inode || !S_ISREG(inode->i_mode)) {
+		printk(KERN_ERR "Invalid file type: %s\n", img_name);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	len = filp->f_op->read(filp, (u8 *)&hdr, sizeof(hdr), &pos);
+	if (len != sizeof(hdr)) {
+		printk(KERN_ERR "gdmwm: Cannot read the image info.\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	array_le32_to_cpu((u32 *)&hdr, 19);
+#if 0
+	if (hdr.magic_code != 0x10767fff) {
+		printk(KERN_ERR "gdmwm: Invalid magic code 0x%08x\n",
+			hdr.magic_code);
+		ret = -EINVAL;
+		goto out;
+	}
+#endif
+	if (hdr.count > MAX_IMG_CNT) {
+		printk(KERN_ERR "gdmwm: Too many images. %d\n", hdr.count);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < hdr.count; i++) {
+		if (hdr.offset[i] > hdr.len) {
+			printk(KERN_ERR "gdmwm: Invalid offset. "
+				"Entry = %d Offset = 0x%08x "
+				"Image length = 0x%08x\n",
+				i, hdr.offset[i], hdr.len);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		pos = hdr.offset[i];
+		len = filp->f_op->read(filp, (u8 *)&fw_info, sizeof(fw_info),
+					&pos);
+		if (len != sizeof(fw_info)) {
+			printk(KERN_ERR "gdmwm: Cannot read the FW info.\n");
+			ret = -EIO;
+			goto out;
+		}
+
+		array_le32_to_cpu((u32 *)&fw_info, 8);
+#if 0
+		if ((fw_info.id & 0xfffff000) != 0x10767000) {
+			printk(KERN_ERR "gdmwm: Invalid FW id. 0x%08x\n",
+				fw_info.id);
+			ret = -EIO;
+			goto out;
+		}
+#endif
+
+		if ((fw_info.id & 0xffff) != pid)
+			continue;
+
+		pos = hdr.offset[i] + fw_info.kernel_offset;
+		ret = download_image(usbdev, filp, &pos, fw_info.kernel_len,
+				DN_KERNEL_MAGIC_NUMBER);
+		if (ret < 0)
+			goto out;
+		printk(KERN_INFO "GCT: Kernel download success.\n");
+
+		pos = hdr.offset[i] + fw_info.rootfs_offset;
+		ret = download_image(usbdev, filp, &pos, fw_info.rootfs_len,
+				DN_ROOTFS_MAGIC_NUMBER);
+		if (ret < 0)
+			goto out;
+		printk(KERN_INFO "GCT: Filesystem download success.\n");
+
+		break;
+	}
+
+	if (i == hdr.count) {
+		printk(KERN_ERR "Firmware for gsk%x is not installed.\n", pid);
+		ret = -EINVAL;
+	}
+out:
+	filp_close(filp, current->files);
+
+restore_fs:
+	set_fs(fs);
+	kfree(tx_buf);
+	return ret;
+}
+
+/*#define GDM7205_PADDING		256 */
+#define DOWNLOAD_CHUCK			2048
+#define KERNEL_TYPE_STRING		"linux"
+#define FS_TYPE_STRING			"rootfs"
+
+static int em_wait_ack(struct usb_device *usbdev, int send_zlp)
+{
+	int ack;
+	int ret = -1;
+
+	if (send_zlp) {
+		/*Send ZLP*/
+		ret = gdm_wibro_send(usbdev, NULL, 0);
+		if (ret < 0)
+			goto out;
+	}
+
+	/*Wait for ACK*/
+	ret = gdm_wibro_recv(usbdev, &ack, sizeof(ack));
+	if (ret < 0)
+		goto out;
+out:
+	return ret;
+}
+
+static int em_download_image(struct usb_device *usbdev, char *path,
+				char *type_string)
+{
+	struct file *filp;
+	struct inode *inode;
+	static mm_segment_t fs;
+	char *buf = NULL;
+	loff_t pos = 0;
+	int ret = 0;
+	int len, readn = 0;
+	#if defined(GDM7205_PADDING)
+	const int pad_size = GDM7205_PADDING;
+	#else
+	const int pad_size = 0;
+	#endif
+
+	fs = get_fs();
+	set_fs(get_ds());
+
+	filp = filp_open(path, O_RDONLY | O_LARGEFILE, 0);
+	if (IS_ERR(filp)) {
+		printk(KERN_ERR "Can't find %s.\n", path);
+		set_fs(fs);
+		ret = -ENOENT;
+		goto restore_fs;
+	}
+
+	if (filp->f_dentry) {
+		inode = filp->f_dentry->d_inode;
+		if (!inode || !S_ISREG(inode->i_mode)) {
+			printk(KERN_ERR "Invalid file type: %s\n", path);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	buf = kmalloc(DOWNLOAD_CHUCK + pad_size, GFP_KERNEL);
+	if (buf == NULL) {
+		printk(KERN_ERR "Error: kmalloc\n");
+		return -ENOMEM;
+	}
+
+	strcpy(buf+pad_size, type_string);
+	ret = gdm_wibro_send(usbdev, buf, strlen(type_string)+pad_size);
+	if (ret < 0)
+		goto out;
+
+	while ((len = filp->f_op->read(filp, buf+pad_size, DOWNLOAD_CHUCK,
+					&pos))) {
+		if (len < 0) {
+			ret = -1;
+			goto out;
+		}
+		readn += len;
+
+		ret = gdm_wibro_send(usbdev, buf, len+pad_size);
+		if (ret < 0)
+			goto out;
+
+		ret = em_wait_ack(usbdev, ((len+pad_size) % 512 == 0));
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = em_wait_ack(usbdev, 1);
+	if (ret < 0)
+		goto out;
+
+out:
+	filp_close(filp, current->files);
+
+restore_fs:
+	set_fs(fs);
+
+	kfree(buf);
+
+	return ret;
+}
+
+static int em_fw_reset(struct usb_device *usbdev)
+{
+	int ret;
+
+	/*Send ZLP*/
+	ret = gdm_wibro_send(usbdev, NULL, 0);
+	return ret;
+}
+
+int usb_emergency(struct usb_device *usbdev)
+{
+	int ret;
+
+	ret = em_download_image(usbdev, KERN_PATH, KERNEL_TYPE_STRING);
+	if (ret < 0)
+		goto out;
+	printk(KERN_INFO "GCT Emergency: Kernel download success.\n");
+
+	ret = em_download_image(usbdev, FS_PATH, FS_TYPE_STRING);
+	if (ret < 0)
+		goto out;
+	printk(KERN_INFO "GCT Emergency: Filesystem download success.\n");
+
+	ret = em_fw_reset(usbdev);
+out:
+	return ret;
+}
diff --git a/drivers/staging/gdm72xx/usb_boot.h b/drivers/staging/gdm72xx/usb_boot.h
new file mode 100644
index 0000000..705b531
--- /dev/null
+++ b/drivers/staging/gdm72xx/usb_boot.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#ifndef __USB_BOOT_H__
+#define __USB_BOOT_H__
+
+struct usb_device;
+
+extern int usb_boot(struct usb_device *usbdev, u16 pid);
+extern int usb_emergency(struct usb_device *usbdev);
+
+#endif /* __USB_BOOT_H__ */
diff --git a/drivers/staging/gdm72xx/usb_ids.h b/drivers/staging/gdm72xx/usb_ids.h
new file mode 100644
index 0000000..c100ea6
--- /dev/null
+++ b/drivers/staging/gdm72xx/usb_ids.h
@@ -0,0 +1,75 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#ifndef __USB_IDS_H__
+#define __USB_IDS_H__
+
+/*You can replace vendor-ID as yours.*/
+#define GCT_VID			0x1076
+
+/*You can replace product-ID as yours.*/
+#define GCT_PID1			0x7e00
+#define GCT_PID2			0x7f00
+
+#define USB_DEVICE_ID_MATCH_DEVICE_INTERFACE	\
+	(USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_CLASS)
+
+#define USB_DEVICE_INTF(vend, prod, intf)	\
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE_INTERFACE,	\
+	.idVendor = (vend), .idProduct = (prod), .bInterfaceClass = (intf)
+
+#define EMERGENCY_PID		0x720f
+#define BL_PID_MASK			0xffc0
+
+#define USB_DEVICE_BOOTLOADER(vid, pid)	\
+	{USB_DEVICE((vid), ((pid)&BL_PID_MASK)|B_DOWNLOAD)},	\
+	{USB_DEVICE((vid), ((pid)&BL_PID_MASK)|B_DOWNLOAD|B_DIFF_DL_DRV)}
+
+#define USB_DEVICE_CDC_DATA(vid, pid)	\
+	{USB_DEVICE_INTF((vid), (pid), USB_CLASS_CDC_DATA)}
+
+static const struct usb_device_id id_table[] = {
+	USB_DEVICE_BOOTLOADER(GCT_VID, GCT_PID1),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x1),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x2),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x3),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x4),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x5),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x6),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x7),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x8),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0x9),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0xa),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0xb),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0xc),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0xd),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0xe),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID1+0xf),
+
+	USB_DEVICE_BOOTLOADER(GCT_VID, GCT_PID2),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x1),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x2),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x3),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x4),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x5),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x6),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x7),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x8),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0x9),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0xa),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0xb),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0xc),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0xd),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0xe),
+	USB_DEVICE_CDC_DATA(GCT_VID, GCT_PID2+0xf),
+
+	{USB_DEVICE(GCT_VID, EMERGENCY_PID)},
+	{ }
+};
+
+#endif /* __USB_IDS_H__ */
diff --git a/drivers/staging/gdm72xx/wm_ioctl.h b/drivers/staging/gdm72xx/wm_ioctl.h
new file mode 100644
index 0000000..4a88999
--- /dev/null
+++ b/drivers/staging/gdm72xx/wm_ioctl.h
@@ -0,0 +1,90 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ * Use of this source code is governed by a BSD-style license that can be
+ * found in the LICENSE file.
+ */
+
+#if !defined(WM_IOCTL_H_20080714)
+#define WM_IOCTL_H_20080714
+#if !defined(__KERNEL__)
+#include <net/if.h>
+#endif
+
+#define NETLINK_WIMAX	31
+
+#define SIOCWMIOCTL			SIOCDEVPRIVATE
+
+#define SIOCG_DATA			0x8D10
+#define SIOCS_DATA			0x8D11
+
+enum {
+	SIOC_DATA_FSM,
+	SIOC_DATA_NETLIST,
+	SIOC_DATA_CONNNSP,
+	SIOC_DATA_CONNCOMP,
+	SIOC_DATA_PROFILEID,
+
+	SIOC_DATA_END
+};
+
+#define SIOC_DATA_MAX			16
+
+/* FSM */
+enum {
+	M_INIT = 0,
+	M_OPEN_OFF,
+	M_OPEN_ON,
+	M_SCAN,
+	M_CONNECTING,
+	M_CONNECTED,
+	M_FSM_END,
+
+	C_INIT = 0,
+	C_CONNSTART,
+	C_ASSOCSTART,
+	C_RNG,
+	C_SBC,
+	C_AUTH,
+	C_REG,
+	C_DSX,
+	C_ASSOCCOMPLETE,
+	C_CONNCOMPLETE,
+	C_FSM_END,
+
+	D_INIT = 0,
+	D_READY,
+	D_LISTEN,
+	D_IPACQUISITION,
+
+	END_FSM
+};
+
+struct fsm_s {
+	int		m_status;	/*main status*/
+	int		c_status;	/*connection status*/
+	int		d_status;	/*oma-dm status*/
+};
+
+struct data_s {
+	int		size;
+	void	*buf;
+};
+
+struct wm_req_s {
+	union {
+		char	ifrn_name[IFNAMSIZ];
+	} ifr_ifrn;
+
+	unsigned short	cmd;
+
+	unsigned short	data_id;
+	struct data_s	data;
+
+/* NOTE: sizeof(struct wm_req_s) must be less than sizeof(struct ifreq). */
+};
+
+#ifndef ifr_name
+#define ifr_name	ifr_ifrn.ifrn_name
+#endif
+
+#endif
-- 
1.7.7.3

