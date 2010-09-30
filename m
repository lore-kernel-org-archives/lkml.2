Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab0I3TCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:02:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37206 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab0I3TCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:02:08 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/3] drivers:staging:ti-st: mv ti_wilink_st header
Date: Thu, 30 Sep 2010 16:13:30 -0400
Message-Id: <1285877610-3043-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1285877610-3043-3-git-send-email-pavan_savoy@ti.com>
References: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
 <1285877610-3043-2-git-send-email-pavan_savoy@ti.com>
 <1285877610-3043-3-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Move the header to a standard linux device driver location.
This should pave the way for other drivers to be moved into the relevant
directories.

ti_wilink_st.h is a common header file used by the TI's shared transport device
driver for WiLink chipsets. Each individual protocol drivers like bluetooth
driver, FM V4L2 driver and GPS drivers will make use of this header.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/bt_drv.c       |    2 +-
 drivers/staging/ti-st/st_core.c      |    2 +-
 drivers/staging/ti-st/st_kim.c       |    2 +-
 drivers/staging/ti-st/st_ll.c        |    2 +-
 drivers/staging/ti-st/ti_wilink_st.h |  402 ----------------------------------
 include/linux/ti_wilink_st.h         |  402 ++++++++++++++++++++++++++++++++++
 6 files changed, 406 insertions(+), 406 deletions(-)
 delete mode 100644 drivers/staging/ti-st/ti_wilink_st.h
 create mode 100644 include/linux/ti_wilink_st.h

diff --git a/drivers/staging/ti-st/bt_drv.c b/drivers/staging/ti-st/bt_drv.c
index 50da66d..75065bf 100644
--- a/drivers/staging/ti-st/bt_drv.c
+++ b/drivers/staging/ti-st/bt_drv.c
@@ -24,7 +24,7 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 
-#include "ti_wilink_st.h"
+#include <linux/ti_wilink_st.h>
 #include "bt_drv.h"
 
 /* Define this macro to get debug msg */
diff --git a/drivers/staging/ti-st/st_core.c b/drivers/staging/ti-st/st_core.c
index 03397be..5bef61e 100644
--- a/drivers/staging/ti-st/st_core.c
+++ b/drivers/staging/ti-st/st_core.c
@@ -28,7 +28,7 @@
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci.h>
-#include "ti_wilink_st.h"
+#include <linux/ti_wilink_st.h>
 
 /* strings to be used for rfkill entries and by
  * ST Core to be used for sysfs debug entry
diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index 09e2c97..372a996 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -36,7 +36,7 @@
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci.h>
 
-#include "ti_wilink_st.h"
+#include <linux/ti_wilink_st.h>
 
 
 static int kim_probe(struct platform_device *pdev);
diff --git a/drivers/staging/ti-st/st_ll.c b/drivers/staging/ti-st/st_ll.c
index d08b58e..ed1e4bc 100644
--- a/drivers/staging/ti-st/st_ll.c
+++ b/drivers/staging/ti-st/st_ll.c
@@ -21,7 +21,7 @@
 #define pr_fmt(fmt) "(stll) :" fmt
 #include <linux/skbuff.h>
 #include <linux/module.h>
-#include "ti_wilink_st.h"
+#include <linux/ti_wilink_st.h>
 
 /**********************************************************************/
 /* internal functions */
diff --git a/drivers/staging/ti-st/ti_wilink_st.h b/drivers/staging/ti-st/ti_wilink_st.h
deleted file mode 100644
index 2a5acf5..0000000
--- a/drivers/staging/ti-st/ti_wilink_st.h
+++ /dev/null
@@ -1,402 +0,0 @@
-/*
- *  Shared Transport Header file
- *	To be included by the protocol stack drivers for
- *	Texas Instruments BT,FM and GPS combo chip drivers
- *	and also serves the sub-modules of the shared transport driver.
- *
- *  Copyright (C) 2009-2010 Texas Instruments
- *  Author: Pavan Savoy <pavan_savoy@ti.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- */
-
-#ifndef TI_WILINK_ST_H
-#define TI_WILINK_ST_H
-
-/**
- * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
- *	gpio states for their chip/core enable gpios
- */
-enum kim_gpio_state {
-	KIM_GPIO_INACTIVE,
-	KIM_GPIO_ACTIVE,
-};
-
-/**
- * enum proto-type - The protocol on WiLink chips which share a
- *	common physical interface like UART.
- */
-enum proto_type {
-	ST_BT,
-	ST_FM,
-	ST_GPS,
-	ST_MAX,
-};
-
-/**
- * struct st_proto_s - Per Protocol structure from BT/FM/GPS to ST
- * @type: type of the protocol being registered among the
- *	available proto_type(BT, FM, GPS the protocol which share TTY).
- * @recv: the receiver callback pointing to a function in the
- *	protocol drivers called by the ST driver upon receiving
- *	relevant data.
- * @match_packet: reserved for future use, to make ST more generic
- * @reg_complete_cb: callback handler pointing to a function in protocol
- *	handler called by ST when the pending registrations are complete.
- *	The registrations are marked pending, in situations when fw
- *	download is in progress.
- * @write: pointer to function in ST provided to protocol drivers from ST,
- *	to be made use when protocol drivers have data to send to TTY.
- * @priv_data: privdate data holder for the protocol drivers, sent
- *	from the protocol drivers during registration, and sent back on
- *	reg_complete_cb and recv.
- */
-struct st_proto_s {
-	enum proto_type type;
-	long (*recv) (void *, struct sk_buff *);
-	unsigned char (*match_packet) (const unsigned char *data);
-	void (*reg_complete_cb) (void *, char data);
-	long (*write) (struct sk_buff *skb);
-	void *priv_data;
-};
-
-extern long st_register(struct st_proto_s *);
-extern long st_unregister(enum proto_type);
-
-
-/*
- * header information used by st_core.c
- */
-
-/* states of protocol list */
-#define ST_NOTEMPTY	1
-#define ST_EMPTY	0
-
-/*
- * possible st_states
- */
-#define ST_INITIALIZING		1
-#define ST_REG_IN_PROGRESS	2
-#define ST_REG_PENDING		3
-#define ST_WAITING_FOR_RESP	4
-
-/**
- * struct st_data_s - ST core internal structure
- * @st_state: different states of ST like initializing, registration
- *	in progress, this is mainly used to return relevant err codes
- *	when protocol drivers are registering. It is also used to track
- *	the recv function, as in during fw download only HCI events
- *	can occur , where as during other times other events CH8, CH9
- *	can occur.
- * @tty: tty provided by the TTY core for line disciplines.
- * @ldisc_ops: the procedures that this line discipline registers with TTY.
- * @tx_skb: If for some reason the tty's write returns lesser bytes written
- *	then to maintain the rest of data to be written on next instance.
- *	This needs to be protected, hence the lock inside wakeup func.
- * @tx_state: if the data is being written onto the TTY and protocol driver
- *	wants to send more, queue up data and mark that there is
- *	more data to send.
- * @list: the list of protocols registered, only MAX can exist, one protocol
- *	can register only once.
- * @rx_state: states to be maintained inside st's tty receive
- * @rx_count: count to be maintained inside st's tty receieve
- * @rx_skb: the skb where all data for a protocol gets accumulated,
- *	since tty might not call receive when a complete event packet
- *	is received, the states, count and the skb needs to be maintained.
- * @txq: the list of skbs which needs to be sent onto the TTY.
- * @tx_waitq: if the chip is not in AWAKE state, the skbs needs to be queued
- *	up in here, PM(WAKEUP_IND) data needs to be sent and then the skbs
- *	from waitq can be moved onto the txq.
- *	Needs locking too.
- * @lock: the lock to protect skbs, queues, and ST states.
- * @protos_registered: count of the protocols registered, also when 0 the
- *	chip enable gpio can be toggled, and when it changes to 1 the fw
- *	needs to be downloaded to initialize chip side ST.
- * @ll_state: the various PM states the chip can be, the states are notified
- *	to us, when the chip sends relevant PM packets(SLEEP_IND, WAKE_IND).
- * @kim_data: reference to the parent encapsulating structure.
- *
- */
-struct st_data_s {
-	unsigned long st_state;
-	struct tty_struct *tty;
-	struct tty_ldisc_ops *ldisc_ops;
-	struct sk_buff *tx_skb;
-#define ST_TX_SENDING	1
-#define ST_TX_WAKEUP	2
-	unsigned long tx_state;
-	struct st_proto_s *list[ST_MAX];
-	unsigned long rx_state;
-	unsigned long rx_count;
-	struct sk_buff *rx_skb;
-	struct sk_buff_head txq, tx_waitq;
-	spinlock_t lock;
-	unsigned char	protos_registered;
-	unsigned long ll_state;
-	void *kim_data;
-};
-
-/**
- * st_int_write -
- * point this to tty->driver->write or tty->ops->write
- * depending upon the kernel version
- */
-int st_int_write(struct st_data_s*, const unsigned char*, int);
-
-/**
- * st_write -
- * internal write function, passed onto protocol drivers
- * via the write function ptr of protocol struct
- */
-long st_write(struct sk_buff *);
-
-/* function to be called from ST-LL */
-void st_ll_send_frame(enum proto_type, struct sk_buff *);
-
-/* internal wake up function */
-void st_tx_wakeup(struct st_data_s *st_data);
-
-/* init, exit entry funcs called from KIM */
-int st_core_init(struct st_data_s **);
-void st_core_exit(struct st_data_s *);
-
-/* ask for reference from KIM */
-void st_kim_ref(struct st_data_s **, int);
-
-#define GPS_STUB_TEST
-#ifdef GPS_STUB_TEST
-int gps_chrdrv_stub_write(const unsigned char*, int);
-void gps_chrdrv_stub_init(void);
-#endif
-
-/*
- * header information used by st_kim.c
- */
-
-/* time in msec to wait for
- * line discipline to be installed
- */
-#define LDISC_TIME	500
-#define CMD_RESP_TIME	500
-#define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
-	| ((unsigned short)((unsigned char)(b))) << 8))
-
-#define GPIO_HIGH 1
-#define GPIO_LOW  0
-
-/* the Power-On-Reset logic, requires to attempt
- * to download firmware onto chip more than once
- * since the self-test for chip takes a while
- */
-#define POR_RETRY_COUNT 5
-
-/**
- * struct chip_version - save the chip version
- */
-struct chip_version {
-	unsigned short full;
-	unsigned short chip;
-	unsigned short min_ver;
-	unsigned short maj_ver;
-};
-
-/**
- * struct kim_data_s - the KIM internal data, embedded as the
- *	platform's drv data. One for each ST device in the system.
- * @uim_pid: KIM needs to communicate with UIM to request to install
- *	the ldisc by opening UART when protocol drivers register.
- * @kim_pdev: the platform device added in one of the board-XX.c file
- *	in arch/XX/ directory, 1 for each ST device.
- * @kim_rcvd: completion handler to notify when data was received,
- *	mainly used during fw download, which involves multiple send/wait
- *	for each of the HCI-VS commands.
- * @ldisc_installed: completion handler to notify that the UIM accepted
- *	the request to install ldisc, notify from tty_open which suggests
- *	the ldisc was properly installed.
- * @resp_buffer: data buffer for the .bts fw file name.
- * @fw_entry: firmware class struct to request/release the fw.
- * @gpios: the list of core/chip enable gpios for BT, FM and GPS cores.
- * @rx_state: the rx state for kim's receive func during fw download.
- * @rx_count: the rx count for the kim's receive func during fw download.
- * @rx_skb: all of fw data might not come at once, and hence data storage for
- *	whole of the fw response, only HCI_EVENTs and hence diff from ST's
- *	response.
- * @rfkill: rfkill data for each of the cores to be registered with rfkill.
- * @rf_protos: proto types of the data registered with rfkill sub-system.
- * @core_data: ST core's data, which mainly is the tty's disc_data
- * @version: chip version available via a sysfs entry.
- *
- */
-struct kim_data_s {
-	long uim_pid;
-	struct platform_device *kim_pdev;
-	struct completion kim_rcvd, ldisc_installed;
-	char resp_buffer[30];
-	const struct firmware *fw_entry;
-	long gpios[ST_MAX];
-	unsigned long rx_state;
-	unsigned long rx_count;
-	struct sk_buff *rx_skb;
-	struct rfkill *rfkill[ST_MAX];
-	enum proto_type rf_protos[ST_MAX];
-	struct st_data_s *core_data;
-	struct chip_version version;
-};
-
-/**
- * functions called when 1 of the protocol drivers gets
- * registered, these need to communicate with UIM to request
- * ldisc installed, read chip_version, download relevant fw
- */
-long st_kim_start(void *);
-long st_kim_stop(void *);
-
-void st_kim_recv(void *, const unsigned char *, long count);
-void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
-void st_kim_complete(void *);
-void kim_st_list_protocols(struct st_data_s *, void *);
-
-/*
- * BTS headers
- */
-#define ACTION_SEND_COMMAND     1
-#define ACTION_WAIT_EVENT       2
-#define ACTION_SERIAL           3
-#define ACTION_DELAY            4
-#define ACTION_RUN_SCRIPT       5
-#define ACTION_REMARKS          6
-
-/**
- * struct bts_header - the fw file is NOT binary which can
- *	be sent onto TTY as is. The .bts is more a script
- *	file which has different types of actions.
- *	Each such action needs to be parsed by the KIM and
- *	relevant procedure to be called.
- */
-struct bts_header {
-	u32 magic;
-	u32 version;
-	u8 future[24];
-	u8 actions[0];
-} __attribute__ ((packed));
-
-/**
- * struct bts_action - Each .bts action has its own type of
- *	data.
- */
-struct bts_action {
-	u16 type;
-	u16 size;
-	u8 data[0];
-} __attribute__ ((packed));
-
-struct bts_action_send {
-	u8 data[0];
-} __attribute__ ((packed));
-
-struct bts_action_wait {
-	u32 msec;
-	u32 size;
-	u8 data[0];
-} __attribute__ ((packed));
-
-struct bts_action_delay {
-	u32 msec;
-} __attribute__ ((packed));
-
-struct bts_action_serial {
-	u32 baud;
-	u32 flow_control;
-} __attribute__ ((packed));
-
-/**
- * struct hci_command - the HCI-VS for intrepreting
- *	the change baud rate of host-side UART, which
- *	needs to be ignored, since UIM would do that
- *	when it receives request from KIM for ldisc installation.
- */
-struct hci_command {
-	u8 prefix;
-	u16 opcode;
-	u8 plen;
-	u32 speed;
-} __attribute__ ((packed));
-
-/*
- * header information used by st_ll.c
- */
-
-/* ST LL receiver states */
-#define ST_W4_PACKET_TYPE       0
-#define ST_BT_W4_EVENT_HDR      1
-#define ST_BT_W4_ACL_HDR        2
-#define ST_BT_W4_SCO_HDR        3
-#define ST_BT_W4_DATA           4
-#define ST_FM_W4_EVENT_HDR      5
-#define ST_GPS_W4_EVENT_HDR	6
-
-/* ST LL state machines */
-#define ST_LL_ASLEEP               0
-#define ST_LL_ASLEEP_TO_AWAKE      1
-#define ST_LL_AWAKE                2
-#define ST_LL_AWAKE_TO_ASLEEP      3
-#define ST_LL_INVALID		   4
-
-/* different PM notifications coming from chip */
-#define LL_SLEEP_IND	0x30
-#define LL_SLEEP_ACK	0x31
-#define LL_WAKE_UP_IND	0x32
-#define LL_WAKE_UP_ACK	0x33
-
-/* initialize and de-init ST LL */
-long st_ll_init(struct st_data_s *);
-long st_ll_deinit(struct st_data_s *);
-
-/**
- * enable/disable ST LL along with KIM start/stop
- * called by ST Core
- */
-void st_ll_enable(struct st_data_s *);
-void st_ll_disable(struct st_data_s *);
-
-/**
- * various funcs used by ST core to set/get the various PM states
- * of the chip.
- */
-unsigned long st_ll_getstate(struct st_data_s *);
-unsigned long st_ll_sleep_state(struct st_data_s *, unsigned char);
-void st_ll_wakeup(struct st_data_s *);
-
-/*
- * header information used by st_core.c for FM and GPS
- * packet parsing, the bluetooth headers are already available
- * at net/bluetooth/
- */
-
-struct fm_event_hdr {
-	u8 plen;
-} __attribute__ ((packed));
-
-#define FM_MAX_FRAME_SIZE 0xFF	/* TODO: */
-#define FM_EVENT_HDR_SIZE 1	/* size of fm_event_hdr */
-#define ST_FM_CH8_PKT 0x8
-
-/* gps stuff */
-struct gps_event_hdr {
-	u8 opcode;
-	u16 plen;
-} __attribute__ ((packed));
-
-#endif /* TI_WILINK_ST_H */
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
new file mode 100644
index 0000000..2a5acf5
--- /dev/null
+++ b/include/linux/ti_wilink_st.h
@@ -0,0 +1,402 @@
+/*
+ *  Shared Transport Header file
+ *	To be included by the protocol stack drivers for
+ *	Texas Instruments BT,FM and GPS combo chip drivers
+ *	and also serves the sub-modules of the shared transport driver.
+ *
+ *  Copyright (C) 2009-2010 Texas Instruments
+ *  Author: Pavan Savoy <pavan_savoy@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef TI_WILINK_ST_H
+#define TI_WILINK_ST_H
+
+/**
+ * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
+ *	gpio states for their chip/core enable gpios
+ */
+enum kim_gpio_state {
+	KIM_GPIO_INACTIVE,
+	KIM_GPIO_ACTIVE,
+};
+
+/**
+ * enum proto-type - The protocol on WiLink chips which share a
+ *	common physical interface like UART.
+ */
+enum proto_type {
+	ST_BT,
+	ST_FM,
+	ST_GPS,
+	ST_MAX,
+};
+
+/**
+ * struct st_proto_s - Per Protocol structure from BT/FM/GPS to ST
+ * @type: type of the protocol being registered among the
+ *	available proto_type(BT, FM, GPS the protocol which share TTY).
+ * @recv: the receiver callback pointing to a function in the
+ *	protocol drivers called by the ST driver upon receiving
+ *	relevant data.
+ * @match_packet: reserved for future use, to make ST more generic
+ * @reg_complete_cb: callback handler pointing to a function in protocol
+ *	handler called by ST when the pending registrations are complete.
+ *	The registrations are marked pending, in situations when fw
+ *	download is in progress.
+ * @write: pointer to function in ST provided to protocol drivers from ST,
+ *	to be made use when protocol drivers have data to send to TTY.
+ * @priv_data: privdate data holder for the protocol drivers, sent
+ *	from the protocol drivers during registration, and sent back on
+ *	reg_complete_cb and recv.
+ */
+struct st_proto_s {
+	enum proto_type type;
+	long (*recv) (void *, struct sk_buff *);
+	unsigned char (*match_packet) (const unsigned char *data);
+	void (*reg_complete_cb) (void *, char data);
+	long (*write) (struct sk_buff *skb);
+	void *priv_data;
+};
+
+extern long st_register(struct st_proto_s *);
+extern long st_unregister(enum proto_type);
+
+
+/*
+ * header information used by st_core.c
+ */
+
+/* states of protocol list */
+#define ST_NOTEMPTY	1
+#define ST_EMPTY	0
+
+/*
+ * possible st_states
+ */
+#define ST_INITIALIZING		1
+#define ST_REG_IN_PROGRESS	2
+#define ST_REG_PENDING		3
+#define ST_WAITING_FOR_RESP	4
+
+/**
+ * struct st_data_s - ST core internal structure
+ * @st_state: different states of ST like initializing, registration
+ *	in progress, this is mainly used to return relevant err codes
+ *	when protocol drivers are registering. It is also used to track
+ *	the recv function, as in during fw download only HCI events
+ *	can occur , where as during other times other events CH8, CH9
+ *	can occur.
+ * @tty: tty provided by the TTY core for line disciplines.
+ * @ldisc_ops: the procedures that this line discipline registers with TTY.
+ * @tx_skb: If for some reason the tty's write returns lesser bytes written
+ *	then to maintain the rest of data to be written on next instance.
+ *	This needs to be protected, hence the lock inside wakeup func.
+ * @tx_state: if the data is being written onto the TTY and protocol driver
+ *	wants to send more, queue up data and mark that there is
+ *	more data to send.
+ * @list: the list of protocols registered, only MAX can exist, one protocol
+ *	can register only once.
+ * @rx_state: states to be maintained inside st's tty receive
+ * @rx_count: count to be maintained inside st's tty receieve
+ * @rx_skb: the skb where all data for a protocol gets accumulated,
+ *	since tty might not call receive when a complete event packet
+ *	is received, the states, count and the skb needs to be maintained.
+ * @txq: the list of skbs which needs to be sent onto the TTY.
+ * @tx_waitq: if the chip is not in AWAKE state, the skbs needs to be queued
+ *	up in here, PM(WAKEUP_IND) data needs to be sent and then the skbs
+ *	from waitq can be moved onto the txq.
+ *	Needs locking too.
+ * @lock: the lock to protect skbs, queues, and ST states.
+ * @protos_registered: count of the protocols registered, also when 0 the
+ *	chip enable gpio can be toggled, and when it changes to 1 the fw
+ *	needs to be downloaded to initialize chip side ST.
+ * @ll_state: the various PM states the chip can be, the states are notified
+ *	to us, when the chip sends relevant PM packets(SLEEP_IND, WAKE_IND).
+ * @kim_data: reference to the parent encapsulating structure.
+ *
+ */
+struct st_data_s {
+	unsigned long st_state;
+	struct tty_struct *tty;
+	struct tty_ldisc_ops *ldisc_ops;
+	struct sk_buff *tx_skb;
+#define ST_TX_SENDING	1
+#define ST_TX_WAKEUP	2
+	unsigned long tx_state;
+	struct st_proto_s *list[ST_MAX];
+	unsigned long rx_state;
+	unsigned long rx_count;
+	struct sk_buff *rx_skb;
+	struct sk_buff_head txq, tx_waitq;
+	spinlock_t lock;
+	unsigned char	protos_registered;
+	unsigned long ll_state;
+	void *kim_data;
+};
+
+/**
+ * st_int_write -
+ * point this to tty->driver->write or tty->ops->write
+ * depending upon the kernel version
+ */
+int st_int_write(struct st_data_s*, const unsigned char*, int);
+
+/**
+ * st_write -
+ * internal write function, passed onto protocol drivers
+ * via the write function ptr of protocol struct
+ */
+long st_write(struct sk_buff *);
+
+/* function to be called from ST-LL */
+void st_ll_send_frame(enum proto_type, struct sk_buff *);
+
+/* internal wake up function */
+void st_tx_wakeup(struct st_data_s *st_data);
+
+/* init, exit entry funcs called from KIM */
+int st_core_init(struct st_data_s **);
+void st_core_exit(struct st_data_s *);
+
+/* ask for reference from KIM */
+void st_kim_ref(struct st_data_s **, int);
+
+#define GPS_STUB_TEST
+#ifdef GPS_STUB_TEST
+int gps_chrdrv_stub_write(const unsigned char*, int);
+void gps_chrdrv_stub_init(void);
+#endif
+
+/*
+ * header information used by st_kim.c
+ */
+
+/* time in msec to wait for
+ * line discipline to be installed
+ */
+#define LDISC_TIME	500
+#define CMD_RESP_TIME	500
+#define MAKEWORD(a, b)  ((unsigned short)(((unsigned char)(a)) \
+	| ((unsigned short)((unsigned char)(b))) << 8))
+
+#define GPIO_HIGH 1
+#define GPIO_LOW  0
+
+/* the Power-On-Reset logic, requires to attempt
+ * to download firmware onto chip more than once
+ * since the self-test for chip takes a while
+ */
+#define POR_RETRY_COUNT 5
+
+/**
+ * struct chip_version - save the chip version
+ */
+struct chip_version {
+	unsigned short full;
+	unsigned short chip;
+	unsigned short min_ver;
+	unsigned short maj_ver;
+};
+
+/**
+ * struct kim_data_s - the KIM internal data, embedded as the
+ *	platform's drv data. One for each ST device in the system.
+ * @uim_pid: KIM needs to communicate with UIM to request to install
+ *	the ldisc by opening UART when protocol drivers register.
+ * @kim_pdev: the platform device added in one of the board-XX.c file
+ *	in arch/XX/ directory, 1 for each ST device.
+ * @kim_rcvd: completion handler to notify when data was received,
+ *	mainly used during fw download, which involves multiple send/wait
+ *	for each of the HCI-VS commands.
+ * @ldisc_installed: completion handler to notify that the UIM accepted
+ *	the request to install ldisc, notify from tty_open which suggests
+ *	the ldisc was properly installed.
+ * @resp_buffer: data buffer for the .bts fw file name.
+ * @fw_entry: firmware class struct to request/release the fw.
+ * @gpios: the list of core/chip enable gpios for BT, FM and GPS cores.
+ * @rx_state: the rx state for kim's receive func during fw download.
+ * @rx_count: the rx count for the kim's receive func during fw download.
+ * @rx_skb: all of fw data might not come at once, and hence data storage for
+ *	whole of the fw response, only HCI_EVENTs and hence diff from ST's
+ *	response.
+ * @rfkill: rfkill data for each of the cores to be registered with rfkill.
+ * @rf_protos: proto types of the data registered with rfkill sub-system.
+ * @core_data: ST core's data, which mainly is the tty's disc_data
+ * @version: chip version available via a sysfs entry.
+ *
+ */
+struct kim_data_s {
+	long uim_pid;
+	struct platform_device *kim_pdev;
+	struct completion kim_rcvd, ldisc_installed;
+	char resp_buffer[30];
+	const struct firmware *fw_entry;
+	long gpios[ST_MAX];
+	unsigned long rx_state;
+	unsigned long rx_count;
+	struct sk_buff *rx_skb;
+	struct rfkill *rfkill[ST_MAX];
+	enum proto_type rf_protos[ST_MAX];
+	struct st_data_s *core_data;
+	struct chip_version version;
+};
+
+/**
+ * functions called when 1 of the protocol drivers gets
+ * registered, these need to communicate with UIM to request
+ * ldisc installed, read chip_version, download relevant fw
+ */
+long st_kim_start(void *);
+long st_kim_stop(void *);
+
+void st_kim_recv(void *, const unsigned char *, long count);
+void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
+void st_kim_complete(void *);
+void kim_st_list_protocols(struct st_data_s *, void *);
+
+/*
+ * BTS headers
+ */
+#define ACTION_SEND_COMMAND     1
+#define ACTION_WAIT_EVENT       2
+#define ACTION_SERIAL           3
+#define ACTION_DELAY            4
+#define ACTION_RUN_SCRIPT       5
+#define ACTION_REMARKS          6
+
+/**
+ * struct bts_header - the fw file is NOT binary which can
+ *	be sent onto TTY as is. The .bts is more a script
+ *	file which has different types of actions.
+ *	Each such action needs to be parsed by the KIM and
+ *	relevant procedure to be called.
+ */
+struct bts_header {
+	u32 magic;
+	u32 version;
+	u8 future[24];
+	u8 actions[0];
+} __attribute__ ((packed));
+
+/**
+ * struct bts_action - Each .bts action has its own type of
+ *	data.
+ */
+struct bts_action {
+	u16 type;
+	u16 size;
+	u8 data[0];
+} __attribute__ ((packed));
+
+struct bts_action_send {
+	u8 data[0];
+} __attribute__ ((packed));
+
+struct bts_action_wait {
+	u32 msec;
+	u32 size;
+	u8 data[0];
+} __attribute__ ((packed));
+
+struct bts_action_delay {
+	u32 msec;
+} __attribute__ ((packed));
+
+struct bts_action_serial {
+	u32 baud;
+	u32 flow_control;
+} __attribute__ ((packed));
+
+/**
+ * struct hci_command - the HCI-VS for intrepreting
+ *	the change baud rate of host-side UART, which
+ *	needs to be ignored, since UIM would do that
+ *	when it receives request from KIM for ldisc installation.
+ */
+struct hci_command {
+	u8 prefix;
+	u16 opcode;
+	u8 plen;
+	u32 speed;
+} __attribute__ ((packed));
+
+/*
+ * header information used by st_ll.c
+ */
+
+/* ST LL receiver states */
+#define ST_W4_PACKET_TYPE       0
+#define ST_BT_W4_EVENT_HDR      1
+#define ST_BT_W4_ACL_HDR        2
+#define ST_BT_W4_SCO_HDR        3
+#define ST_BT_W4_DATA           4
+#define ST_FM_W4_EVENT_HDR      5
+#define ST_GPS_W4_EVENT_HDR	6
+
+/* ST LL state machines */
+#define ST_LL_ASLEEP               0
+#define ST_LL_ASLEEP_TO_AWAKE      1
+#define ST_LL_AWAKE                2
+#define ST_LL_AWAKE_TO_ASLEEP      3
+#define ST_LL_INVALID		   4
+
+/* different PM notifications coming from chip */
+#define LL_SLEEP_IND	0x30
+#define LL_SLEEP_ACK	0x31
+#define LL_WAKE_UP_IND	0x32
+#define LL_WAKE_UP_ACK	0x33
+
+/* initialize and de-init ST LL */
+long st_ll_init(struct st_data_s *);
+long st_ll_deinit(struct st_data_s *);
+
+/**
+ * enable/disable ST LL along with KIM start/stop
+ * called by ST Core
+ */
+void st_ll_enable(struct st_data_s *);
+void st_ll_disable(struct st_data_s *);
+
+/**
+ * various funcs used by ST core to set/get the various PM states
+ * of the chip.
+ */
+unsigned long st_ll_getstate(struct st_data_s *);
+unsigned long st_ll_sleep_state(struct st_data_s *, unsigned char);
+void st_ll_wakeup(struct st_data_s *);
+
+/*
+ * header information used by st_core.c for FM and GPS
+ * packet parsing, the bluetooth headers are already available
+ * at net/bluetooth/
+ */
+
+struct fm_event_hdr {
+	u8 plen;
+} __attribute__ ((packed));
+
+#define FM_MAX_FRAME_SIZE 0xFF	/* TODO: */
+#define FM_EVENT_HDR_SIZE 1	/* size of fm_event_hdr */
+#define ST_FM_CH8_PKT 0x8
+
+/* gps stuff */
+struct gps_event_hdr {
+	u8 opcode;
+	u16 plen;
+} __attribute__ ((packed));
+
+#endif /* TI_WILINK_ST_H */
-- 
1.6.5

