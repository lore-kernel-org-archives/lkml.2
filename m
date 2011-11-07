Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1KGUxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:53:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36643 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab1KGUw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:52:58 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] Input: ALPS - Add protocol version field in alps_model_info
Date: Mon,  7 Nov 2011 14:52:36 -0600
Message-Id: <1320699160-28492-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
References: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for adding support for more ALPS protocol versions,
add a field for the protocol version to the model info instead of
using a field in the flags. OLDPROTO and !OLDPROTO are now called
version 1 and version 2, repsectively.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/alps.c |   47 +++++++++++++++++++++----------------------
 drivers/input/mouse/alps.h |    4 +++
 2 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 19d0943..77b776d 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -23,7 +23,6 @@
 #include "psmouse.h"
 #include "alps.h"
 
-#define ALPS_OLDPROTO		0x01	/* old style input */
 #define ALPS_DUALPOINT		0x02	/* touchpad has trackstick */
 #define ALPS_PASS		0x04	/* device has a pass-through port */
 
@@ -35,30 +34,30 @@
 					   6-byte ALPS packet */
 
 static const struct alps_model_info alps_model_data[] = {
-	{ { 0x32, 0x02, 0x14 },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* Toshiba Salellite Pro M10 */
-	{ { 0x33, 0x02, 0x0a },	0x88, 0xf8, ALPS_OLDPROTO },		  /* UMAX-530T */
-	{ { 0x53, 0x02, 0x0a },	0xf8, 0xf8, 0 },
-	{ { 0x53, 0x02, 0x14 },	0xf8, 0xf8, 0 },
-	{ { 0x60, 0x03, 0xc8 }, 0xf8, 0xf8, 0 },			  /* HP ze1115 */
-	{ { 0x63, 0x02, 0x0a },	0xf8, 0xf8, 0 },
-	{ { 0x63, 0x02, 0x14 },	0xf8, 0xf8, 0 },
-	{ { 0x63, 0x02, 0x28 },	0xf8, 0xf8, ALPS_FW_BK_2 },		  /* Fujitsu Siemens S6010 */
-	{ { 0x63, 0x02, 0x3c },	0x8f, 0x8f, ALPS_WHEEL },		  /* Toshiba Satellite S2400-103 */
-	{ { 0x63, 0x02, 0x50 },	0xef, 0xef, ALPS_FW_BK_1 },		  /* NEC Versa L320 */
-	{ { 0x63, 0x02, 0x64 },	0xf8, 0xf8, 0 },
-	{ { 0x63, 0x03, 0xc8 }, 0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D800 */
-	{ { 0x73, 0x00, 0x0a },	0xf8, 0xf8, ALPS_DUALPOINT },		  /* ThinkPad R61 8918-5QG */
-	{ { 0x73, 0x02, 0x0a },	0xf8, 0xf8, 0 },
-	{ { 0x73, 0x02, 0x14 },	0xf8, 0xf8, ALPS_FW_BK_2 },		  /* Ahtec Laptop */
-	{ { 0x20, 0x02, 0x0e },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */
-	{ { 0x22, 0x02, 0x0a },	0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
-	{ { 0x22, 0x02, 0x14 }, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
+	{ { 0x32, 0x02, 0x14 },	ALPS_PROTO_V2, 0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* Toshiba Salellite Pro M10 */
+	{ { 0x33, 0x02, 0x0a },	ALPS_PROTO_V1, 0x88, 0xf8, 0 },				 /* UMAX-530T */
+	{ { 0x53, 0x02, 0x0a },	ALPS_PROTO_V2, 0xf8, 0xf8, 0 },
+	{ { 0x53, 0x02, 0x14 },	ALPS_PROTO_V2, 0xf8, 0xf8, 0 },
+	{ { 0x60, 0x03, 0xc8 }, ALPS_PROTO_V2, 0xf8, 0xf8, 0 },				 /* HP ze1115 */
+	{ { 0x63, 0x02, 0x0a },	ALPS_PROTO_V2, 0xf8, 0xf8, 0 },
+	{ { 0x63, 0x02, 0x14 },	ALPS_PROTO_V2, 0xf8, 0xf8, 0 },
+	{ { 0x63, 0x02, 0x28 },	ALPS_PROTO_V2, 0xf8, 0xf8, ALPS_FW_BK_2 },		 /* Fujitsu Siemens S6010 */
+	{ { 0x63, 0x02, 0x3c },	ALPS_PROTO_V2, 0x8f, 0x8f, ALPS_WHEEL },		 /* Toshiba Satellite S2400-103 */
+	{ { 0x63, 0x02, 0x50 },	ALPS_PROTO_V2, 0xef, 0xef, ALPS_FW_BK_1 },		 /* NEC Versa L320 */
+	{ { 0x63, 0x02, 0x64 },	ALPS_PROTO_V2, 0xf8, 0xf8, 0 },
+	{ { 0x63, 0x03, 0xc8 }, ALPS_PROTO_V2, 0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D800 */
+	{ { 0x73, 0x00, 0x0a },	ALPS_PROTO_V2, 0xf8, 0xf8, ALPS_DUALPOINT },		 /* ThinkPad R61 8918-5QG */
+	{ { 0x73, 0x02, 0x0a },	ALPS_PROTO_V2, 0xf8, 0xf8, 0 },
+	{ { 0x73, 0x02, 0x14 },	ALPS_PROTO_V2, 0xf8, 0xf8, ALPS_FW_BK_2 },		 /* Ahtec Laptop */
+	{ { 0x20, 0x02, 0x0e },	ALPS_PROTO_V2, 0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT }, /* XXX */
+	{ { 0x22, 0x02, 0x0a },	ALPS_PROTO_V2, 0xf8, 0xf8, ALPS_PASS | ALPS_DUALPOINT },
+	{ { 0x22, 0x02, 0x14 }, ALPS_PROTO_V2, 0xff, 0xff, ALPS_PASS | ALPS_DUALPOINT }, /* Dell Latitude D600 */
 	/* Dell Latitude E5500, E6400, E6500, Precision M4400 */
-	{ { 0x62, 0x02, 0x14 }, 0xcf, 0xcf,
+	{ { 0x62, 0x02, 0x14 }, ALPS_PROTO_V2, 0xcf, 0xcf,
 		ALPS_PASS | ALPS_DUALPOINT | ALPS_PS2_INTERLEAVED },
-	{ { 0x73, 0x02, 0x50 }, 0xcf, 0xcf, ALPS_FOUR_BUTTONS },	  /* Dell Vostro 1400 */
-	{ { 0x52, 0x01, 0x14 }, 0xff, 0xff,
-		ALPS_PASS | ALPS_DUALPOINT | ALPS_PS2_INTERLEAVED },	  /* Toshiba Tecra A11-11L */
+	{ { 0x73, 0x02, 0x50 }, ALPS_PROTO_V2, 0xcf, 0xcf, ALPS_FOUR_BUTTONS },		 /* Dell Vostro 1400 */
+	{ { 0x52, 0x01, 0x14 }, ALPS_PROTO_V2, 0xff, 0xff,
+		ALPS_PASS | ALPS_DUALPOINT | ALPS_PS2_INTERLEAVED },			 /* Toshiba Tecra A11-11L */
 };
 
 /*
@@ -112,7 +111,7 @@ static void alps_process_packet(struct psmouse *psmouse)
 	int x, y, z, ges, fin, left, right, middle;
 	int back = 0, forward = 0;
 
-	if (model->flags & ALPS_OLDPROTO) {
+	if (model->proto_version == ALPS_PROTO_V1) {
 		left = packet[2] & 0x10;
 		right = packet[2] & 0x08;
 		middle = 0;
diff --git a/drivers/input/mouse/alps.h b/drivers/input/mouse/alps.h
index 904ed8b..4ce9bba 100644
--- a/drivers/input/mouse/alps.h
+++ b/drivers/input/mouse/alps.h
@@ -12,8 +12,12 @@
 #ifndef _ALPS_H
 #define _ALPS_H
 
+#define ALPS_PROTO_V1	0
+#define ALPS_PROTO_V2	1
+
 struct alps_model_info {
         unsigned char signature[3];
+	unsigned char proto_version;
         unsigned char byte0, mask0;
         unsigned char flags;
 };
-- 
1.7.5.4

