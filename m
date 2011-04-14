Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab1DNR4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:56:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:38314 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab1DNRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sebastien Bourdeauducq <sebastien@milkymist.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 073/209] USB: ftdi_sio: add device IDs for Milkymist One JTAG/serial
Date: Thu, 14 Apr 2011 13:41:43 -0400
Message-Id: <1302803039-9400-74-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Bourdeauducq <sebastien@milkymist.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 7fea0f714ffb3f303d4b66933af2df2f5584c9bf upstream.

Add the USB IDs for the Milkymist One FTDI-based JTAG/serial adapter
(http://projects.qi-hardware.com/index.php/p/mmone-jtag-serial-cable/)
to the ftdi_sio driver and disable the first serial channel (used as
JTAG from userspace).

Signed-off-by: Sebastien Bourdeauducq <sebastien@milkymist.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 55ff244..6c7b6ba 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -800,6 +800,8 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LOGBOOKML_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_LS_LOGBOOK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_SCIENCESCOPE_HS_LOGBOOK_PID) },
+	{ USB_DEVICE(QIHARDWARE_VID, MILKYMISTONE_JTAGSERIAL_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 4addf78..9116449 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1107,3 +1107,9 @@
 #define FTDI_SCIENCESCOPE_LOGBOOKML_PID		0xFF18
 #define FTDI_SCIENCESCOPE_LS_LOGBOOK_PID	0xFF1C
 #define FTDI_SCIENCESCOPE_HS_LOGBOOK_PID	0xFF1D
+
+/*
+ * Milkymist One JTAG/Serial
+ */
+#define QIHARDWARE_VID			0x20B7
+#define MILKYMISTONE_JTAGSERIAL_PID	0x0713
-- 
1.7.4.4

