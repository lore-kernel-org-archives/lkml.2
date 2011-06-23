Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926Ab1FWSjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:39:25 -0400
Received: from mail.perches.com ([173.55.12.10]:3172 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904Ab1FWSjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:39:23 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Trivial next 1/2] treewide: Fix recieve/receive typos
Date: Thu, 23 Jun 2011 11:39:19 -0700
Message-Id: <878fc4b8ba243033d5d325e2d1b6578dde8d0e87.1308853652.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1308853652.git.joe@perches.com>
References: <cover.1308853652.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just spelling fixes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/host/vub300.c     |    4 ++--
 drivers/net/caif/caif_hsi.c   |    2 +-
 drivers/net/wan/lmc/lmc_var.h |    2 +-
 drivers/usb/misc/ftdi-elan.c  |   28 ++++++++++++++--------------
 include/scsi/osd_initiator.h  |    2 +-
 sound/soc/omap/ams-delta.c    |    2 +-
 6 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index d4455ff..e8f6e65 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -1625,8 +1625,8 @@ static void __vub300_command_response(struct vub300_mmc_host *vub300,
 		cmd->error = respretval;
 	} else if (cmd->error) {
 		/*
-		 * the error occured sending the command
-		 * or recieving the response
+		 * the error occurred sending the command
+		 * or receiving the response
 		 */
 	} else if (vub300->command_out_urb->status) {
 		vub300->usb_transport_fail = vub300->command_out_urb->status;
diff --git a/drivers/net/caif/caif_hsi.c b/drivers/net/caif/caif_hsi.c
index 7a8ce612..016108a 100644
--- a/drivers/net/caif/caif_hsi.c
+++ b/drivers/net/caif/caif_hsi.c
@@ -988,7 +988,7 @@ int cfhsi_probe(struct platform_device *pdev)
 		goto err_alloc_rx;
 	}
 
-	/* Initialize recieve vaiables. */
+	/* Initialize receive variables. */
 	cfhsi->rx_ptr = cfhsi->rx_buf;
 	cfhsi->rx_len = CFHSI_DESC_SZ;
 
diff --git a/drivers/net/wan/lmc/lmc_var.h b/drivers/net/wan/lmc/lmc_var.h
index 01ad452..a1d202d 100644
--- a/drivers/net/wan/lmc/lmc_var.h
+++ b/drivers/net/wan/lmc/lmc_var.h
@@ -380,7 +380,7 @@ struct lmc___softc {
 /* CSR6 settings */
 #define OPERATION_MODE  0x00000200 /* Full Duplex      */
 #define PROMISC_MODE    0x00000040 /* Promiscuous Mode */
-#define RECIEVE_ALL     0x40000000 /* Receive All      */
+#define RECEIVE_ALL     0x40000000 /* Receive All      */
 #define PASS_BAD_FRAMES 0x00000008 /* Pass Bad Frames  */
 
 /* Dec control registers  CSR6 as well */
diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index b16bd3c..2f41089c 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -187,7 +187,7 @@ struct usb_ftdi {
         u32 controlreg;
         u8 response[4 + 1024];
         int expected;
-        int recieved;
+        int received;
         int ed_found;
 };
 #define kref_to_usb_ftdi(d) container_of(d, struct usb_ftdi, kref)
@@ -353,7 +353,7 @@ static void ftdi_elan_abandon_targets(struct usb_ftdi *ftdi)
                         mutex_lock(&ftdi->u132_lock);
                 }
         }
-        ftdi->recieved = 0;
+        ftdi->received = 0;
         ftdi->expected = 4;
         ftdi->ed_found = 0;
         mutex_unlock(&ftdi->u132_lock);
@@ -411,7 +411,7 @@ static void ftdi_elan_flush_targets(struct usb_ftdi *ftdi)
                         }
                 }
         }
-        ftdi->recieved = 0;
+        ftdi->received = 0;
         ftdi->expected = 4;
         ftdi->ed_found = 0;
         mutex_unlock(&ftdi->u132_lock);
@@ -447,7 +447,7 @@ static void ftdi_elan_cancel_targets(struct usb_ftdi *ftdi)
                         }
                 }
         }
-        ftdi->recieved = 0;
+        ftdi->received = 0;
         ftdi->expected = 4;
         ftdi->ed_found = 0;
         mutex_unlock(&ftdi->u132_lock);
@@ -874,7 +874,7 @@ static char *have_ed_set_response(struct usb_ftdi *ftdi,
                         mutex_unlock(&ftdi->u132_lock);
                         ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                                 payload);
-                        ftdi->recieved = 0;
+                        ftdi->received = 0;
                         ftdi->expected = 4;
                         ftdi->ed_found = 0;
                         return ftdi->response;
@@ -890,7 +890,7 @@ static char *have_ed_set_response(struct usb_ftdi *ftdi,
                         mutex_unlock(&ftdi->u132_lock);
                         ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                                 payload);
-                        ftdi->recieved = 0;
+                        ftdi->received = 0;
                         ftdi->expected = 4;
                         ftdi->ed_found = 0;
                         return ftdi->response;
@@ -905,7 +905,7 @@ static char *have_ed_set_response(struct usb_ftdi *ftdi,
                 mutex_unlock(&ftdi->u132_lock);
                 ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                         payload);
-                ftdi->recieved = 0;
+                ftdi->received = 0;
                 ftdi->expected = 4;
                 ftdi->ed_found = 0;
                 return ftdi->response;
@@ -914,7 +914,7 @@ static char *have_ed_set_response(struct usb_ftdi *ftdi,
                 mutex_unlock(&ftdi->u132_lock);
                 ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                         payload);
-                ftdi->recieved = 0;
+                ftdi->received = 0;
                 ftdi->expected = 4;
                 ftdi->ed_found = 0;
                 return ftdi->response;
@@ -934,7 +934,7 @@ static char *have_ed_get_response(struct usb_ftdi *ftdi,
         if (target->active)
                 ftdi_elan_do_callback(ftdi, target, NULL, 0);
         target->abandoning = 0;
-        ftdi->recieved = 0;
+        ftdi->received = 0;
         ftdi->expected = 4;
         ftdi->ed_found = 0;
         return ftdi->response;
@@ -951,7 +951,7 @@ static char *have_ed_get_response(struct usb_ftdi *ftdi,
 */
 static int ftdi_elan_respond_engine(struct usb_ftdi *ftdi)
 {
-        u8 *b = ftdi->response + ftdi->recieved;
+        u8 *b = ftdi->response + ftdi->received;
         int bytes_read = 0;
         int retry_on_empty = 1;
         int retry_on_timeout = 3;
@@ -1043,11 +1043,11 @@ static int ftdi_elan_respond_engine(struct usb_ftdi *ftdi)
                 u8 c = ftdi->bulk_in_buffer[++ftdi->bulk_in_last];
                 bytes_read += 1;
                 ftdi->bulk_in_left -= 1;
-                if (ftdi->recieved == 0 && c == 0xFF) {
+                if (ftdi->received == 0 && c == 0xFF) {
                         goto have;
                 } else
                         *b++ = c;
-                if (++ftdi->recieved < ftdi->expected) {
+                if (++ftdi->received < ftdi->expected) {
                         goto have;
                 } else if (ftdi->ed_found) {
                         int ed_number = (ftdi->response[0] >> 5) & 0x03;
@@ -1069,7 +1069,7 @@ static int ftdi_elan_respond_engine(struct usb_ftdi *ftdi)
                         }
                         ftdi_elan_do_callback(ftdi, target, 4 + ftdi->response,
                                 payload);
-                        ftdi->recieved = 0;
+                        ftdi->received = 0;
                         ftdi->expected = 4;
                         ftdi->ed_found = 0;
                         b = ftdi->response;
@@ -1089,7 +1089,7 @@ static int ftdi_elan_respond_engine(struct usb_ftdi *ftdi)
                         *respond->value = data;
                         *respond->result = 0;
                         complete(&respond->wait_completion);
-                        ftdi->recieved = 0;
+                        ftdi->received = 0;
                         ftdi->expected = 4;
                         ftdi->ed_found = 0;
                         b = ftdi->response;
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 0a50799..572fb54 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -262,7 +262,7 @@ int osd_execute_request_async(struct osd_request *or,
  * osd_req_decode_sense_full - Decode sense information after execution.
  *
  * @or:           - osd_request to examine
- * @osi           - Recievs a more detailed error report information (optional).
+ * @osi           - Receives a more detailed error report information (optional).
  * @silent        - Do not print to dmsg (Even if enabled)
  * @bad_obj_list  - Some commands act on multiple objects. Failed objects will
  *                  be received here (optional)
diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
index b40095a..30fe0d0 100644
--- a/sound/soc/omap/ams-delta.c
+++ b/sound/soc/omap/ams-delta.c
@@ -330,7 +330,7 @@ static int cx81801_hangup(struct tty_struct *tty)
 	return 0;
 }
 
-/* Line discipline .recieve_buf() */
+/* Line discipline .receive_buf() */
 static void cx81801_receive(struct tty_struct *tty,
 				const unsigned char *cp, char *fp, int count)
 {
-- 
1.7.6.rc1

