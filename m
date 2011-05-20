Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935300Ab1ETEyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:54:07 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:36554 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935242Ab1ETExi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:53:38 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 07/12] staging: usbip: usbip_common.c: fix misspelled function name
Date: Thu, 19 May 2011 21:37:01 -0700
Message-Id: <bc5a64e373593174e9eeec9d1be66d782358a9ee.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305866084.git.mfm@muteddisk.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change pakcet to packet in usbip_iso_packet_correct_endian().

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/usbip_common.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 954d90d..b204e6f 100644
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

