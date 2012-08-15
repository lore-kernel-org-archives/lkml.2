Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2HOTvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:52 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63023 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2HOTvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Artur Zimmer <artur128@3dzimmer.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 107/165] USB: Serial: Add PID(0xF7C0) to FTDI SIO driver for a zeitcontrol-device
Date: Wed, 15 Aug 2012 15:47:31 -0400
Message-ID: <1345060109-9187-108-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artur Zimmer <artur128@3dzimmer.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ce7e9065958191e6b7ca49d7ed0e1099c486d198 upstream.

Here is a patch for a new PID (zeitcontrol-device mifare-reader FT232BL(like FT232BM but lead free)).

Signed-off-by: Artur Zimmer <artur128@3dzimmer.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 90dfdb1..24dc63c 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -160,6 +160,7 @@ static struct ftdi_sio_quirk ftdi_8u2232c_quirk = {
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
 static struct usb_device_id id_table_combined [] = {
+	{ USB_DEVICE(FTDI_VID, FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_AMC232_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 1167732..c4670e5 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1166,3 +1166,9 @@
 #define FTDI_CTI_MINI_PID	0xF608
 /* USB-Nano-485*/
 #define FTDI_CTI_NANO_PID	0xF60B
+
+/*
+ * ZeitControl cardsystems GmbH rfid-readers http://zeitconrol.de
+ */
+/* TagTracer MIFARE*/
+#define FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID	0xF7C0
-- 
1.7.12.rc2

