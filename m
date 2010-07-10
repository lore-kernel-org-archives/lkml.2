Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0GJOuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 10:50:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36375 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0GJOuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 10:50:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dFYoRLArY9WNk4UCYNSBNY/qMKmob/rtYUSt99Ud7o4UqgyFaRRlXBP3iQM+CvPri0
         wyjbbyRr88/QGfwL7ee3goMhjjEn1AaPannY94EDW617uxYPE5oUFRn+2KVitiL17McA
         xGy7SsZGErEZsieIXY7F1haBbCH+tE7e31txY=
From: Martin Enderleit <menderleit@gmail.com>
To: mdharm-usb@one-eyed-alien.net
Cc: gregkh@suse.de, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
       Martin Enderleit <menderleit@gmail.com>
Subject: [PATCH] usb: storage: freecom: Fixed several coding style issues.
Date: Sat, 10 Jul 2010 16:50:12 +0200
Message-Id: <1278773412-21989-1-git-send-email-menderleit@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Enderleit <martin@martin-desktop.(none)>

Fixed several coding style issues in freecom.c.

Signed-off-by: Martin Enderleit <menderleit@gmail.com>
---
 drivers/usb/storage/freecom.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index 54cc942..6542ca4 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -269,7 +269,7 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 	/* The firmware will time-out commands after 20 seconds. Some commands
 	 * can legitimately take longer than this, so we use a different
 	 * command that only waits for the interrupt and then sends status,
-	 * without having to send a new ATAPI command to the device. 
+	 * without having to send a new ATAPI command to the device.
 	 *
 	 * NOTE: There is some indication that a data transfer after a timeout
 	 * may not work, but that is a condition that should never happen.
@@ -324,14 +324,14 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 	/* Find the length we desire to read. */
 	switch (srb->cmnd[0]) {
-		case INQUIRY:
-		case REQUEST_SENSE:		/* 16 or 18 bytes? spec says 18, lots of devices only have 16 */
-		case MODE_SENSE:
-		case MODE_SENSE_10:
-			length = le16_to_cpu(fst->Count);
-			break;
-		default:
-			length = scsi_bufflen(srb);
+	case INQUIRY:
+	case REQUEST_SENSE:	/* 16 or 18 bytes? spec says 18, lots of devices only have 16 */
+	case MODE_SENSE:
+	case MODE_SENSE_10:
+		length = le16_to_cpu(fst->Count);
+		break;
+	default:
+		length = scsi_bufflen(srb);
 	}
 
 	/* verify that this amount is legal */
@@ -414,7 +414,7 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 		/* should never hit here -- filtered in usb.c */
 		US_DEBUGP ("freecom unimplemented direction: %d\n",
 				us->srb->sc_data_direction);
-		// Return fail, SCSI seems to handle this better.
+		/* Return fail, SCSI seems to handle this better. */
 		return USB_STOR_TRANSPORT_FAILED;
 		break;
 	}
@@ -494,8 +494,7 @@ static void pdump (void *ibuffer, int length)
 				offset = 0;
 			}
 			offset += sprintf (line+offset, "%08x:", i);
-		}
-		else if ((i & 7) == 0) {
+		} else if ((i & 7) == 0) {
 			offset += sprintf (line+offset, " -");
 		}
 		offset += sprintf (line+offset, " %02x", buffer[i] & 0xff);
-- 
1.7.0.4

