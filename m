Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1CLVHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:07:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44597 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755491Ab1CLVHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:07:49 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18ozCdUHq8omIwBrUPc3WPgUZaYm6bJgy0OjUpC9l
	TPLmQkR00gGiwG
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: factor lcd scaling parameters out
Date: Sat, 12 Mar 2011 21:22:59 +0000
Message-Id: <1299964979-3391-5-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These parameters are the same for all currently known VIA IGPs so it
does not make any sense to store them with IGP specific data. This
saves a few bytes and helps a bit in dicovering the real differences.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c      |   19 ++++++++++
 drivers/video/via/viamode.c |   85 -------------------------------------------
 2 files changed, 19 insertions(+), 85 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index b0b0278..6cb3b56 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -360,6 +360,24 @@ static struct pll_map pll_value[] = {
 		{208, 5, 2} }
 };
 
+/* according to VIA Technologies these values are based on experiment */
+static struct io_reg scaling_parameters[] = {
+	{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1 */
+	{VIACR, CR7B, 0xFF, 0x02},	/* LCD Scaling Parameter 2 */
+	{VIACR, CR7C, 0xFF, 0x03},	/* LCD Scaling Parameter 3 */
+	{VIACR, CR7D, 0xFF, 0x04},	/* LCD Scaling Parameter 4 */
+	{VIACR, CR7E, 0xFF, 0x07},	/* LCD Scaling Parameter 5 */
+	{VIACR, CR7F, 0xFF, 0x0A},	/* LCD Scaling Parameter 6 */
+	{VIACR, CR80, 0xFF, 0x0D},	/* LCD Scaling Parameter 7 */
+	{VIACR, CR81, 0xFF, 0x13},	/* LCD Scaling Parameter 8 */
+	{VIACR, CR82, 0xFF, 0x16},	/* LCD Scaling Parameter 9 */
+	{VIACR, CR83, 0xFF, 0x19},	/* LCD Scaling Parameter 10 */
+	{VIACR, CR84, 0xFF, 0x1C},	/* LCD Scaling Parameter 11 */
+	{VIACR, CR85, 0xFF, 0x1D},	/* LCD Scaling Parameter 12 */
+	{VIACR, CR86, 0xFF, 0x1E},	/* LCD Scaling Parameter 13 */
+	{VIACR, CR87, 0xFF, 0x1F},	/* LCD Scaling Parameter 14 */
+};
+
 static struct fifo_depth_select display_fifo_depth_reg = {
 	/* IGA1 FIFO Depth_Select */
 	{IGA1_FIFO_DEPTH_SELECT_REG_NUM, {{SR17, 0, 7} } },
@@ -2419,6 +2437,7 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 		break;
 	}
 
+	viafb_write_regx(scaling_parameters, ARRAY_SIZE(scaling_parameters));
 	device_off();
 	via_set_state(devices, VIA_STATE_OFF);
 
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 4b06dd7..8127489 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -108,20 +108,6 @@ struct io_reg CN400_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR6A, 0xFF, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
 {VIACR, CR6C, 0xFF, 0x00},
-{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1             */
-{VIACR, CR7B, 0xFF, 0x02},	/* LCD Scaling Parameter 2             */
-{VIACR, CR7C, 0xFF, 0x03},	/* LCD Scaling Parameter 3             */
-{VIACR, CR7D, 0xFF, 0x04},	/* LCD Scaling Parameter 4             */
-{VIACR, CR7E, 0xFF, 0x07},	/* LCD Scaling Parameter 5             */
-{VIACR, CR7F, 0xFF, 0x0A},	/* LCD Scaling Parameter 6             */
-{VIACR, CR80, 0xFF, 0x0D},	/* LCD Scaling Parameter 7             */
-{VIACR, CR81, 0xFF, 0x13},	/* LCD Scaling Parameter 8             */
-{VIACR, CR82, 0xFF, 0x16},	/* LCD Scaling Parameter 9             */
-{VIACR, CR83, 0xFF, 0x19},	/* LCD Scaling Parameter 10            */
-{VIACR, CR84, 0xFF, 0x1C},	/* LCD Scaling Parameter 11            */
-{VIACR, CR85, 0xFF, 0x1D},	/* LCD Scaling Parameter 12            */
-{VIACR, CR86, 0xFF, 0x1E},	/* LCD Scaling Parameter 13            */
-{VIACR, CR87, 0xFF, 0x1F},	/* LCD Scaling Parameter 14            */
 {VIACR, CR88, 0xFF, 0x40},	/* LCD Panel Type                      */
 {VIACR, CR89, 0xFF, 0x00},	/* LCD Timing Control 0                */
 {VIACR, CR8A, 0xFF, 0x88},	/* LCD Timing Control 1                */
@@ -172,20 +158,6 @@ struct io_reg CN700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR78, 0xFF, 0x00},	/* LCD scaling Factor */
 {VIACR, CR79, 0xFF, 0x00},	/* LCD scaling Factor */
 {VIACR, CR9F, 0x03, 0x00},	/* LCD scaling Factor */
-{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1 */
-{VIACR, CR7B, 0xFF, 0x02},	/* LCD Scaling Parameter 2 */
-{VIACR, CR7C, 0xFF, 0x03},	/* LCD Scaling Parameter 3 */
-{VIACR, CR7D, 0xFF, 0x04},	/* LCD Scaling Parameter 4 */
-{VIACR, CR7E, 0xFF, 0x07},	/* LCD Scaling Parameter 5 */
-{VIACR, CR7F, 0xFF, 0x0A},	/* LCD Scaling Parameter 6 */
-{VIACR, CR80, 0xFF, 0x0D},	/* LCD Scaling Parameter 7 */
-{VIACR, CR81, 0xFF, 0x13},	/* LCD Scaling Parameter 8 */
-{VIACR, CR82, 0xFF, 0x16},	/* LCD Scaling Parameter 9 */
-{VIACR, CR83, 0xFF, 0x19},	/* LCD Scaling Parameter 10 */
-{VIACR, CR84, 0xFF, 0x1C},	/* LCD Scaling Parameter 11 */
-{VIACR, CR85, 0xFF, 0x1D},	/* LCD Scaling Parameter 12 */
-{VIACR, CR86, 0xFF, 0x1E},	/* LCD Scaling Parameter 13 */
-{VIACR, CR87, 0xFF, 0x1F},	/* LCD Scaling Parameter 14 */
 {VIACR, CR88, 0xFF, 0x40},	/* LCD Panel Type */
 {VIACR, CR89, 0xFF, 0x00},	/* LCD Timing Control 0 */
 {VIACR, CR8A, 0xFF, 0x88},	/* LCD Timing Control 1 */
@@ -229,20 +201,6 @@ struct io_reg KM400_ModeXregs[] = {
 	{VIACR, CR36, 0xFF, 0x01},	/* Power Mangement 3                  */
 	{VIACR, CR68, 0xFF, 0x67},	/* Default FIFO For IGA2              */
 	{VIACR, CR6A, 0x20, 0x20},	/* Extended FIFO On                   */
-	{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1            */
-	{VIACR, CR7B, 0xFF, 0x02},	/* LCD Scaling Parameter 2            */
-	{VIACR, CR7C, 0xFF, 0x03},	/* LCD Scaling Parameter 3            */
-	{VIACR, CR7D, 0xFF, 0x04},	/* LCD Scaling Parameter 4            */
-	{VIACR, CR7E, 0xFF, 0x07},	/* LCD Scaling Parameter 5            */
-	{VIACR, CR7F, 0xFF, 0x0A},	/* LCD Scaling Parameter 6            */
-	{VIACR, CR80, 0xFF, 0x0D},	/* LCD Scaling Parameter 7            */
-	{VIACR, CR81, 0xFF, 0x13},	/* LCD Scaling Parameter 8            */
-	{VIACR, CR82, 0xFF, 0x16},	/* LCD Scaling Parameter 9            */
-	{VIACR, CR83, 0xFF, 0x19},	/* LCD Scaling Parameter 10           */
-	{VIACR, CR84, 0xFF, 0x1C},	/* LCD Scaling Parameter 11           */
-	{VIACR, CR85, 0xFF, 0x1D},	/* LCD Scaling Parameter 12           */
-	{VIACR, CR86, 0xFF, 0x1E},	/* LCD Scaling Parameter 13           */
-	{VIACR, CR87, 0xFF, 0x1F},	/* LCD Scaling Parameter 14           */
 	{VIACR, CR88, 0xFF, 0x40},	/* LCD Panel Type                     */
 	{VIACR, CR89, 0xFF, 0x00},	/* LCD Timing Control 0               */
 	{VIACR, CR8A, 0xFF, 0x88},	/* LCD Timing Control 1               */
@@ -283,20 +241,6 @@ struct io_reg CX700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR6A, 0xFF, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
 {VIACR, CR6C, 0xFF, 0x00},
-{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1             */
-{VIACR, CR7B, 0xFF, 0x02},	/* LCD Scaling Parameter 2             */
-{VIACR, CR7C, 0xFF, 0x03},	/* LCD Scaling Parameter 3             */
-{VIACR, CR7D, 0xFF, 0x04},	/* LCD Scaling Parameter 4             */
-{VIACR, CR7E, 0xFF, 0x07},	/* LCD Scaling Parameter 5             */
-{VIACR, CR7F, 0xFF, 0x0A},	/* LCD Scaling Parameter 6             */
-{VIACR, CR80, 0xFF, 0x0D},	/* LCD Scaling Parameter 7             */
-{VIACR, CR81, 0xFF, 0x13},	/* LCD Scaling Parameter 8             */
-{VIACR, CR82, 0xFF, 0x16},	/* LCD Scaling Parameter 9             */
-{VIACR, CR83, 0xFF, 0x19},	/* LCD Scaling Parameter 10            */
-{VIACR, CR84, 0xFF, 0x1C},	/* LCD Scaling Parameter 11            */
-{VIACR, CR85, 0xFF, 0x1D},	/* LCD Scaling Parameter 12            */
-{VIACR, CR86, 0xFF, 0x1E},	/* LCD Scaling Parameter 13            */
-{VIACR, CR87, 0xFF, 0x1F},	/* LCD Scaling Parameter 14            */
 {VIACR, CR88, 0xFF, 0x40},	/* LCD Panel Type                      */
 {VIACR, CR89, 0xFF, 0x00},	/* LCD Timing Control 0                */
 {VIACR, CR8A, 0xFF, 0x88},	/* LCD Timing Control 1                */
@@ -342,20 +286,6 @@ struct io_reg VX855_ModeXregs[] = {
 {VIACR, CR6A, 0xFD, 0x60},
 {VIACR, CR6B, 0xFF, 0x00},
 {VIACR, CR6C, 0xFF, 0x00},
-{VIACR, CR7A, 0xFF, 0x01},          /* LCD Scaling Parameter 1             */
-{VIACR, CR7B, 0xFF, 0x02},          /* LCD Scaling Parameter 2             */
-{VIACR, CR7C, 0xFF, 0x03},          /* LCD Scaling Parameter 3             */
-{VIACR, CR7D, 0xFF, 0x04},          /* LCD Scaling Parameter 4             */
-{VIACR, CR7E, 0xFF, 0x07},          /* LCD Scaling Parameter 5             */
-{VIACR, CR7F, 0xFF, 0x0A},          /* LCD Scaling Parameter 6             */
-{VIACR, CR80, 0xFF, 0x0D},          /* LCD Scaling Parameter 7             */
-{VIACR, CR81, 0xFF, 0x13},          /* LCD Scaling Parameter 8             */
-{VIACR, CR82, 0xFF, 0x16},          /* LCD Scaling Parameter 9             */
-{VIACR, CR83, 0xFF, 0x19},          /* LCD Scaling Parameter 10            */
-{VIACR, CR84, 0xFF, 0x1C},          /* LCD Scaling Parameter 11            */
-{VIACR, CR85, 0xFF, 0x1D},          /* LCD Scaling Parameter 12            */
-{VIACR, CR86, 0xFF, 0x1E},          /* LCD Scaling Parameter 13            */
-{VIACR, CR87, 0xFF, 0x1F},          /* LCD Scaling Parameter 14            */
 {VIACR, CR88, 0xFF, 0x40},          /* LCD Panel Type                      */
 {VIACR, CR89, 0xFF, 0x00},          /* LCD Timing Control 0                */
 {VIACR, CR8A, 0xFF, 0x88},          /* LCD Timing Control 1                */
@@ -390,21 +320,6 @@ struct io_reg CLE266_ModeXregs[] = { {VIASR, SR1E, 0xF0, 0x00},
 {VIAGR, GR20, 0xFF, 0x00},
 {VIAGR, GR21, 0xFF, 0x00},
 {VIAGR, GR22, 0xFF, 0x00},
-	/* LCD Parameters */
-{VIACR, CR7A, 0xFF, 0x01},	/* LCD Parameter 1 */
-{VIACR, CR7B, 0xFF, 0x02},	/* LCD Parameter 2 */
-{VIACR, CR7C, 0xFF, 0x03},	/* LCD Parameter 3 */
-{VIACR, CR7D, 0xFF, 0x04},	/* LCD Parameter 4 */
-{VIACR, CR7E, 0xFF, 0x07},	/* LCD Parameter 5 */
-{VIACR, CR7F, 0xFF, 0x0A},	/* LCD Parameter 6 */
-{VIACR, CR80, 0xFF, 0x0D},	/* LCD Parameter 7 */
-{VIACR, CR81, 0xFF, 0x13},	/* LCD Parameter 8 */
-{VIACR, CR82, 0xFF, 0x16},	/* LCD Parameter 9 */
-{VIACR, CR83, 0xFF, 0x19},	/* LCD Parameter 10 */
-{VIACR, CR84, 0xFF, 0x1C},	/* LCD Parameter 11 */
-{VIACR, CR85, 0xFF, 0x1D},	/* LCD Parameter 12 */
-{VIACR, CR86, 0xFF, 0x1E},	/* LCD Parameter 13 */
-{VIACR, CR87, 0xFF, 0x1F},	/* LCD Parameter 14 */
 
 };
 
-- 
1.6.3.2

