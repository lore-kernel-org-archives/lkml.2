Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1EFKy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:26 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:43266 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257Ab1EFKyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:24 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 05/16] staging: usbip: usbip_common.h: coding style cleanup
Date: Fri,  6 May 2011 03:47:45 -0700
Message-Id: <412e28859e38bdbe9b279629a89aa646c518e95f.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the compiler macro __packed, fix a few alignment issues, and
remove extraneous lines.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/usbip_common.h |   75 +++++++++++++---------------------
 1 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index c767f52..7acec75 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -20,8 +20,8 @@
 #ifndef __VHCI_COMMON_H
 #define __VHCI_COMMON_H
 
-
 #include <linux/version.h>
+#include <linux/compiler.h>
 #include <linux/usb.h>
 #include <asm/byteorder.h>
 #include <net/sock.h>
@@ -37,23 +37,21 @@
  * @fmt:
  * @args:
  */
-
 #ifdef CONFIG_USB_IP_DEBUG_ENABLE
 
 #define usbip_udbg(fmt, args...)					\
 	do {								\
 		printk(KERN_DEBUG "%-10s:(%s,%d) %s: " fmt,		\
-			(in_interrupt() ? "interrupt" : (current)->comm),\
-			__FILE__, __LINE__, __func__, ##args);		\
+		       (in_interrupt() ? "interrupt" : (current)->comm),\
+		       __FILE__, __LINE__, __func__, ##args);		\
 	} while (0)
 
 #else  /* CONFIG_USB_IP_DEBUG_ENABLE */
 
-#define usbip_udbg(fmt, args...)		do { } while (0)
+#define usbip_udbg(fmt, args...)	do { } while (0)
 
 #endif /* CONFIG_USB_IP_DEBUG_ENABLE */
 
-
 enum {
 	usbip_debug_xmit	= (1 << 0),
 	usbip_debug_sysfs	= (1 << 1),
@@ -87,16 +85,16 @@ extern struct device_attribute dev_attr_usbip_debug;
 #define usbip_dbg_with_flag(flag, fmt, args...)		\
 	do {						\
 		if (flag & usbip_debug_flag)		\
-			usbip_udbg(fmt , ##args);		\
+			usbip_udbg(fmt , ##args);	\
 	} while (0)
 
-#define usbip_dbg_sysfs(fmt, args...)		\
+#define usbip_dbg_sysfs(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_sysfs, fmt , ##args)
-#define usbip_dbg_xmit(fmt, args...)		\
+#define usbip_dbg_xmit(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_xmit, fmt , ##args)
-#define usbip_dbg_urb(fmt, args...)		\
+#define usbip_dbg_urb(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_urb, fmt , ##args)
-#define usbip_dbg_eh(fmt, args...)		\
+#define usbip_dbg_eh(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_eh, fmt , ##args)
 
 #define usbip_dbg_vhci_rh(fmt, args...)	\
@@ -107,17 +105,16 @@ extern struct device_attribute dev_attr_usbip_debug;
 	usbip_dbg_with_flag(usbip_debug_vhci_rx, fmt , ##args)
 #define usbip_dbg_vhci_tx(fmt, args...)	\
 	usbip_dbg_with_flag(usbip_debug_vhci_tx, fmt , ##args)
-#define usbip_dbg_vhci_sysfs(fmt, args...)	\
+#define usbip_dbg_vhci_sysfs(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_vhci_sysfs, fmt , ##args)
 
-#define usbip_dbg_stub_cmp(fmt, args...)	\
+#define usbip_dbg_stub_cmp(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_stub_cmp, fmt , ##args)
-#define usbip_dbg_stub_rx(fmt, args...)	\
+#define usbip_dbg_stub_rx(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_stub_rx, fmt , ##args)
-#define usbip_dbg_stub_tx(fmt, args...)	\
+#define usbip_dbg_stub_tx(fmt, args...) \
 	usbip_dbg_with_flag(usbip_debug_stub_tx, fmt , ##args)
 
-
 /**
  * usbip_uerr - print error messages
  * @fmt:
@@ -126,8 +123,8 @@ extern struct device_attribute dev_attr_usbip_debug;
 #define usbip_uerr(fmt, args...)					\
 	do {								\
 		printk(KERN_ERR "%-10s: ***ERROR*** (%s,%d) %s: " fmt,	\
-			(in_interrupt() ? "interrupt" : (current)->comm),\
-			__FILE__, __LINE__, __func__, ##args);	\
+		       (in_interrupt() ? "interrupt" : (current)->comm),\
+		       __FILE__, __LINE__, __func__, ##args);		\
 	} while (0)
 
 /**
@@ -140,7 +137,6 @@ extern struct device_attribute dev_attr_usbip_debug;
 		printk(KERN_INFO "usbip: " fmt , ## args);	\
 	} while (0)
 
-
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -185,7 +181,7 @@ struct usbip_header_basic {
 #define USBIP_DIR_IN	1
 	__u32 direction;
 	__u32 ep;     /* endpoint number */
-} __attribute__ ((packed));
+} __packed;
 
 /*
  * An additional header for a CMD_SUBMIT packet.
@@ -212,43 +208,40 @@ struct usbip_header_cmd_submit {
 
 	/* set setup packet data for a CTRL request */
 	unsigned char setup[8];
-} __attribute__ ((packed));
+} __packed;
 
 /*
  * An additional header for a RET_SUBMIT packet.
  */
 struct usbip_header_ret_submit {
 	__s32 status;
-	__s32 actual_length; /* returned data length */
-	__s32 start_frame; /* ISO and INT */
-	__s32 number_of_packets;  /* ISO only */
-	__s32 error_count; /* ISO only */
-} __attribute__ ((packed));
+	__s32 actual_length;		/* returned data length */
+	__s32 start_frame;		/* ISO and INT */
+	__s32 number_of_packets;	/* ISO only */
+	__s32 error_count;		/* ISO only */
+} __packed;
 
 /*
  * An additional header for a CMD_UNLINK packet.
  */
 struct usbip_header_cmd_unlink {
-	__u32 seqnum; /* URB's seqnum which will be unlinked */
-} __attribute__ ((packed));
-
+	__u32 seqnum;			/* URB's seqnum that will be unlinked */
+} __packed;
 
 /*
  * An additional header for a RET_UNLINK packet.
  */
 struct usbip_header_ret_unlink {
 	__s32 status;
-} __attribute__ ((packed));
-
+} __packed;
 
 /* the same as usb_iso_packet_descriptor but packed for pdu */
 struct usbip_iso_packet_descriptor {
 	__u32 offset;
-	__u32 length;            /* expected length */
+	__u32 length;			/* expected length */
 	__u32 actual_length;
 	__u32 status;
-} __attribute__ ((packed));
-
+} __packed;
 
 /*
  * All usbip packets use a common header to keep code simple.
@@ -262,18 +255,13 @@ struct usbip_header {
 		struct usbip_header_cmd_unlink	cmd_unlink;
 		struct usbip_header_ret_unlink	ret_unlink;
 	} u;
-} __attribute__ ((packed));
-
-
-
+} __packed;
 
 /*-------------------------------------------------------------------------*/
 
-
 int usbip_xmit(int, struct socket *, char *, int, int);
 int usbip_sendmsg(struct socket *, struct msghdr *, int);
 
-
 static inline int interface_to_busnum(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
@@ -304,7 +292,6 @@ int set_sockaddr(struct socket *socket, struct sockaddr_storage *ss);
 void usbip_dump_urb(struct urb *purb);
 void usbip_dump_header(struct usbip_header *pdu);
 
-
 struct usbip_device;
 
 enum usbip_side {
@@ -331,7 +318,6 @@ enum usbip_status {
 /* a common structure for stub_device and vhci_device */
 struct usbip_device {
 	enum usbip_side side;
-
 	enum usbip_status status;
 
 	/* lock for status */
@@ -370,9 +356,8 @@ struct usbip_device {
 	} eh_ops;
 };
 
-
 void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
-								int pack);
+		    int pack);
 
 void usbip_header_correct_endian(struct usbip_header *pdu, int send);
 /* some members of urb must be substituted before. */
@@ -383,12 +368,10 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb);
 int usbip_pad_iso(struct usbip_device *ud, struct urb *urb);
 void *usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen);
 
-
 /* usbip_event.c */
 int usbip_start_eh(struct usbip_device *ud);
 void usbip_stop_eh(struct usbip_device *ud);
 void usbip_event_add(struct usbip_device *ud, unsigned long event);
 int usbip_event_happened(struct usbip_device *ud);
 
-
 #endif
-- 
1.7.5.1

