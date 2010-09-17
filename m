Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0IPXil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:38:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34354 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab0IPXii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:38:38 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 1/3] drivers:staging:ti-st: set right the data types
Date: Thu, 16 Sep 2010 20:49:30 -0400
Message-Id: <1284684572-12508-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1284684572-12508-1-git-send-email-pavan_savoy@ti.com>
References: <1284684572-12508-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

replace uint and family by a much more proper u8/u16 types.
This is required specifically for data members of structures coming
in from the chip and data members parsed from the binary firmware file.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/fm.h     |    6 +++---
 drivers/staging/ti-st/st_kim.h |   36 ++++++++++++++++++------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/ti-st/fm.h b/drivers/staging/ti-st/fm.h
index be41453..962ccd6 100644
--- a/drivers/staging/ti-st/fm.h
+++ b/drivers/staging/ti-st/fm.h
@@ -1,5 +1,5 @@
 struct fm_event_hdr {
-	unsigned char plen;
+	u8 plen;
 } __attribute__ ((packed));
 
 #define FM_MAX_FRAME_SIZE 0xFF	/* TODO: */
@@ -8,6 +8,6 @@ struct fm_event_hdr {
 
 /* gps stuff */
 struct gps_event_hdr {
-unsigned char opcode;
-unsigned short plen;
+	u8 opcode;
+	u16 plen;
 } __attribute__ ((packed));
diff --git a/drivers/staging/ti-st/st_kim.h b/drivers/staging/ti-st/st_kim.h
index 7de2541..e09cdf3 100644
--- a/drivers/staging/ti-st/st_kim.h
+++ b/drivers/staging/ti-st/st_kim.h
@@ -128,10 +128,10 @@ void kim_st_list_protocols(struct st_data_s *, void *);
  *	relevant procedure to be called.
  */
 struct bts_header {
-	uint32_t magic;
-	uint32_t version;
-	uint8_t future[24];
-	uint8_t actions[0];
+	u32 magic;
+	u32 version;
+	u8 future[24];
+	u8 actions[0];
 } __attribute__ ((packed));
 
 /**
@@ -139,28 +139,28 @@ struct bts_header {
  *	data.
  */
 struct bts_action {
-	uint16_t type;
-	uint16_t size;
-	uint8_t data[0];
+	u16 type;
+	u16 size;
+	u8 data[0];
 } __attribute__ ((packed));
 
 struct bts_action_send {
-	uint8_t data[0];
+	u8 data[0];
 } __attribute__ ((packed));
 
 struct bts_action_wait {
-	uint32_t msec;
-	uint32_t size;
-	uint8_t data[0];
+	u32 msec;
+	u32 size;
+	u8 data[0];
 } __attribute__ ((packed));
 
 struct bts_action_delay {
-	uint32_t msec;
+	u32 msec;
 } __attribute__ ((packed));
 
 struct bts_action_serial {
-	uint32_t baud;
-	uint32_t flow_control;
+	u32 baud;
+	u32 flow_control;
 } __attribute__ ((packed));
 
 /**
@@ -170,10 +170,10 @@ struct bts_action_serial {
  *	when it receives request from KIM for ldisc installation.
  */
 struct hci_command {
-	uint8_t prefix;
-	uint16_t opcode;
-	uint8_t plen;
-	uint32_t speed;
+	u8 prefix;
+	u16 opcode;
+	u8 plen;
+	u32 speed;
 } __attribute__ ((packed));
 
 
-- 
1.6.5

