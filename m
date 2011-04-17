Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1DQWei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 18:34:38 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:63943 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1DQWea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 18:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DgO5X0u3DlKltz2Fdcc4mkEYJwa1t2I3h2jCfBjMYDGtlQhx9eFknOPV/OAkjM6G4L
         mD4JXSohid1t+v/w+RhndiwHwOufnK2q6njwmLzgpSnOJi3+8/uuhKr5vSrYDAGkhIc6
         E6/9iEIC5zj44p7n+Hvjm8kb6XR4/oB8ehgeg=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH 1/1] drivers/usb/image/mdc800.c: Remove "typdef enum".
Date: Sun, 17 Apr 2011 19:34:14 -0300
Message-Id: <014287655bd0c4327bbd946b9c823a0e4ec35f8e.1303079016.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.5.rc2.4.g4d8b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead use the keyword "enum" where we use it.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/usb/image/mdc800.c |  111 +++++++++++++++++++++----------------------
 1 files changed, 54 insertions(+), 57 deletions(-)

diff --git a/drivers/usb/image/mdc800.c b/drivers/usb/image/mdc800.c
index 575b56c..4b0a032 100644
--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -122,59 +122,57 @@
 /* Minor Number of the device (create with mknod /dev/mustek c 180 32) */
 #define MDC800_DEVICE_MINOR_BASE 32
 
+/*
+ * Data and structs.
+ */
 
-/**************************************************************************
-	Data and structs
-***************************************************************************/
-
-
-typedef enum {
+enum mdc800_state {
 	NOT_CONNECTED, READY, WORKING, DOWNLOAD
-} mdc800_state;
+};
 
 
-/* Data for the driver */
+/* Data for the driver. */
 struct mdc800_data
 {
-	struct usb_device *	dev;			// Device Data
-	mdc800_state 		state;
+	struct usb_device*      dev;                  /* Device Data. */
+	enum mdc800_state	state;
 
-	unsigned int		endpoint [4];
+	unsigned int		endpoint[4];
 
-	struct urb *		irq_urb;
+	struct urb*             irq_urb;
 	wait_queue_head_t	irq_wait;
 	int			irq_woken;
 	char*			irq_urb_buffer;
 
-	int			camera_busy;          // is camera busy ?
-	int 			camera_request_ready; // Status to synchronize with irq
-	char 			camera_response [8];  // last Bytes send after busy
+	int			camera_busy;          /* Is camera busy? */
+	int			camera_request_ready; /* Status to synchronize with irq. */
+	char			camera_response[8];   /* last Bytes send after busy. */
 
-	struct urb *   		write_urb;
+	struct urb*             write_urb;
 	char*			write_urb_buffer;
 	wait_queue_head_t	write_wait;
 	int			written;
 
 
-	struct urb *   		download_urb;
+	struct urb*		download_urb;
 	char*			download_urb_buffer;
 	wait_queue_head_t	download_wait;
 	int			downloaded;
-	int			download_left;		// Bytes left to download ?
+	int			download_left;       /* Bytes left to download? */
 
 
 	/* Device Data */
-	char			out [64];	// Answer Buffer
-	int 			out_ptr;	// Index to the first not readen byte
-	int			out_count;	// Bytes in the buffer
+	char			out[64];	/* Answer buffer. */
+	int			out_ptr;	/* Index to the first not readen byte. */
+	int			out_count;	/* Bytes in the buffer. */
 
-	int			open;		// Camera device open ?
-	struct mutex		io_lock;	// IO -lock
+	int			open;		/* Camera device open. */
+	struct mutex		io_lock;	/* IO -lock. */
 
-	char 			in [8];		// Command Input Buffer
-	int  			in_count;
+	char			in [8];		/* Command Input Buffer. */
+	int			in_count;
 
-	int			pic_index;	// Cache for the Imagesize (-1 for nothing cached )
+	int			pic_index;	/* Cache for the Imagesize (-1 for nothing cached) */
 	int			pic_len;
 	int			minor;
 };
@@ -183,52 +181,51 @@ struct mdc800_data
 /* Specification of the Endpoints */
 static struct usb_endpoint_descriptor mdc800_ed [4] =
 {
-	{ 
-		.bLength = 		0,
+	{
+		.bLength =		0,
 		.bDescriptorType =	0,
 		.bEndpointAddress =	0x01,
-		.bmAttributes = 	0x02,
+		.bmAttributes =         0x02,
 		.wMaxPacketSize =	cpu_to_le16(8),
-		.bInterval = 		0,
-		.bRefresh = 		0,
-		.bSynchAddress = 	0,
+		.bInterval =		0,
+		.bRefresh =		0,
+		.bSynchAddress =	0,
 	},
 	{
-		.bLength = 		0,
-		.bDescriptorType = 	0,
-		.bEndpointAddress = 	0x82,
-		.bmAttributes = 	0x03,
-		.wMaxPacketSize = 	cpu_to_le16(8),
-		.bInterval = 		0,
-		.bRefresh = 		0,
-		.bSynchAddress = 	0,
+		.bLength =		0,
+		.bDescriptorType =	0,
+		.bEndpointAddress =	0x82,
+		.bmAttributes =         0x03,
+		.wMaxPacketSize =	cpu_to_le16(8),
+		.bInterval =		0,
+		.bRefresh =		0,
+		.bSynchAddress =	0,
 	},
 	{
-		.bLength = 		0,
-		.bDescriptorType = 	0,
-		.bEndpointAddress = 	0x03,
-		.bmAttributes = 	0x02,
-		.wMaxPacketSize = 	cpu_to_le16(64),
-		.bInterval = 		0,
-		.bRefresh = 		0,
-		.bSynchAddress = 	0,
+		.bLength =		0,
+		.bDescriptorType =	0,
+		.bEndpointAddress =	0x03,
+		.bmAttributes =         0x02,
+		.wMaxPacketSize =	cpu_to_le16(64),
+		.bInterval =		0,
+		.bRefresh =		0,
+		.bSynchAddress =	0,
 	},
 	{
-		.bLength = 		0,
-		.bDescriptorType = 	0,
-		.bEndpointAddress = 	0x84,
-		.bmAttributes = 	0x02,
-		.wMaxPacketSize = 	cpu_to_le16(64),
-		.bInterval = 		0,
-		.bRefresh = 		0,
-		.bSynchAddress = 	0,
+		.bLength =		0,
+		.bDescriptorType =	0,
+		.bEndpointAddress =     0x84,
+		.bmAttributes =         0x02,
+		.wMaxPacketSize =	cpu_to_le16(64),
+		.bInterval =		0,
+		.bRefresh =		0,
+		.bSynchAddress =	0,
 	},
 };
 
 /* The Variable used by the driver */
 static struct mdc800_data* mdc800;
 
-
 /***************************************************************************
 	The USB Part of the driver
 ****************************************************************************/
-- 
1.7.3.2.343.g7d43d

