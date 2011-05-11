Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1EKPoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:44:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60919 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1EKPoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wBUTT403zx77QPNxB1qUbllUGK6uxYuVrspRz2yFiB0pLtJiR8oxLJNzgxP+tZE/9s
         CSh5605w1Jz52ncr2jHODrNclTk/9jXDWe+TOTBQUlSqiQz7AMThBPYSjCSMY+XLThxk
         B8cwzGZqTAHhE7j88P4iqgKMJ+wQNiQG2go70=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 08/12] staging: usbip: usbip_common.c: fix misspelled function name
Date: Wed, 11 May 2011 01:54:20 -0700
Message-Id: <5c68db87d889a920e13ea1d97c5d0f5d46bb1824.1305103212.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305103212.git.mfm@muteddisk.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change pakcet to packet in usbip_iso_packet_correct_endian().

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/usbip_common.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index fbf549c..d2fb1ae 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -627,7 +627,7 @@ void usbip_header_correct_endian(struct usbip_header *pdu, int send)
 }
 EXPORT_SYMBOL_GPL(usbip_header_correct_endian);
 
-static void usbip_iso_pakcet_correct_endian(
+static void usbip_iso_packet_correct_endian(
 		struct usbip_iso_packet_descriptor *iso, int send)
 {
 	/* does not need all members. but copy all simply. */
@@ -677,7 +677,7 @@ void *usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen)
 		iso = buff + (i * sizeof(*iso));
 
 		usbip_pack_iso(iso, &urb->iso_frame_desc[i], 1);
-		usbip_iso_pakcet_correct_endian(iso, 1);
+		usbip_iso_packet_correct_endian(iso, 1);
 	}
 
 	*bufflen = size;
@@ -728,7 +728,7 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 	for (i = 0; i < np; i++) {
 		iso = buff + (i * sizeof(*iso));
 
-		usbip_iso_pakcet_correct_endian(iso, 0);
+		usbip_iso_packet_correct_endian(iso, 0);
 		usbip_pack_iso(iso, &urb->iso_frame_desc[i], 0);
 		total_length += urb->iso_frame_desc[i].actual_length;
 	}
-- 
1.7.5.1

