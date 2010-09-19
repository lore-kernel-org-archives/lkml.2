Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0ISH2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:28:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48845 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751790Ab0ISH2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:28:37 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19EMe1fHoZE4bwqOXjR7pFzNKP1gqWLKeYAKesNbY
	8Q3tzTFVP9ovgy
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 11/12] viafb: rename output devices
Date: Sun, 19 Sep 2010 07:39:56 +0000
Message-Id: <b03e8e9c51899b1a856ab123aa4930f0306ee734.1284879533.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <a20caff43626418b91187e476905ebc7cd974701.1284879533.git.FlorianSchandinat@gmx.de>
References: <a20caff43626418b91187e476905ebc7cd974701.1284879533.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: rename output devices

Now it looks like we finally know enough about the output devices to give
them proper names. As VIA_96 is often referred to as DVP0 rename it to
VIA_DVP0. As VIA_6C and VIA_93 seem to exist only on CLE266 and "replace"
DVP0 and DVP1 there rename them to VIA_LDVP0 and VIA_LDVP1 (L as legacy).
The proc names were changed accordingly which should be harmless as they
were just introduced and not beyond RFC state.
This patch should make things a bit more comfortable and less scary.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/via/hw.c       |   44 +++++++++++++++++++++---------------------
 drivers/video/via/hw.h       |    6 ++--
 drivers/video/via/viafbdev.c |   10 ++++----
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 00fecb5..7d7010a 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -719,9 +719,9 @@ static struct rgbLUT palLUT_table[] = {
 };
 
 static struct via_device_mapping device_mapping[] = {
-	{VIA_6C, "6C"},
-	{VIA_93, "93"},
-	{VIA_96, "96"},
+	{VIA_LDVP0, "LDVP0"},
+	{VIA_LDVP1, "LDVP1"},
+	{VIA_DVP0, "DVP0"},
 	{VIA_CRT, "CRT"},
 	{VIA_DVP1, "DVP1"},
 	{VIA_LVDS1, "LVDS1"},
@@ -763,11 +763,11 @@ static u32 get_dvi_devices(int output_interface)
 {
 	switch (output_interface) {
 	case INTERFACE_DVP0:
-		return VIA_96 | VIA_6C;
+		return VIA_DVP0 | VIA_LDVP0;
 
 	case INTERFACE_DVP1:
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
-			return VIA_93;
+			return VIA_LDVP1;
 		else
 			return VIA_DVP1;
 
@@ -775,7 +775,7 @@ static u32 get_dvi_devices(int output_interface)
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
 			return 0;
 		else
-			return VIA_LVDS2 | VIA_96;
+			return VIA_LVDS2 | VIA_DVP0;
 
 	case INTERFACE_DFP_LOW:
 		if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266)
@@ -794,13 +794,13 @@ static u32 get_lcd_devices(int output_interface)
 {
 	switch (output_interface) {
 	case INTERFACE_DVP0:
-		return VIA_96;
+		return VIA_DVP0;
 
 	case INTERFACE_DVP1:
 		return VIA_DVP1;
 
 	case INTERFACE_DFP_HIGH:
-		return VIA_LVDS2 | VIA_96;
+		return VIA_LVDS2 | VIA_DVP0;
 
 	case INTERFACE_DFP_LOW:
 		return VIA_LVDS1 | VIA_DVP1;
@@ -988,17 +988,17 @@ static void set_crt_source(u8 iga)
 	via_write_reg_mask(VIASR, 0x16, value, 0x40);
 }
 
-static inline void set_6C_source(u8 iga)
+static inline void set_ldvp0_source(u8 iga)
 {
 	set_source_common(0x6C, 7, iga);
 }
 
-static inline void set_93_source(u8 iga)
+static inline void set_ldvp1_source(u8 iga)
 {
 	set_source_common(0x93, 7, iga);
 }
 
-static inline void set_96_source(u8 iga)
+static inline void set_dvp0_source(u8 iga)
 {
 	set_source_common(0x96, 4, iga);
 }
@@ -1020,12 +1020,12 @@ static inline void set_lvds2_source(u8 iga)
 
 void via_set_source(u32 devices, u8 iga)
 {
-	if (devices & VIA_6C)
-		set_6C_source(iga);
-	if (devices & VIA_93)
-		set_93_source(iga);
-	if (devices & VIA_96)
-		set_96_source(iga);
+	if (devices & VIA_LDVP0)
+		set_ldvp0_source(iga);
+	if (devices & VIA_LDVP1)
+		set_ldvp1_source(iga);
+	if (devices & VIA_DVP0)
+		set_dvp0_source(iga);
 	if (devices & VIA_CRT)
 		set_crt_source(iga);
 	if (devices & VIA_DVP1)
@@ -1060,7 +1060,7 @@ static void set_crt_state(u8 state)
 	via_write_reg_mask(VIACR, 0x36, value, 0x30);
 }
 
-static void set_96_state(u8 state)
+static void set_dvp0_state(u8 state)
 {
 	u8 value;
 
@@ -1136,11 +1136,11 @@ void via_set_state(u32 devices, u8 state)
 {
 	/*
 	TODO: Can we enable/disable these devices? How?
-	if (devices & VIA_6C)
-	if (devices & VIA_93)
+	if (devices & VIA_LDVP0)
+	if (devices & VIA_LDVP1)
 	*/
-	if (devices & VIA_96)
-		set_96_state(state);
+	if (devices & VIA_DVP0)
+		set_dvp0_state(state);
 	if (devices & VIA_CRT)
 		set_crt_state(state);
 	if (devices & VIA_DVP1)
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index ad6f9b1..b764409 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -33,9 +33,9 @@
 #define viafb_write_reg_mask(i, p, d, m)	via_write_reg_mask(p, i, d, m)
 
 /* VIA output devices */
-#define VIA_6C		0x00000001
-#define VIA_93		0x00000002
-#define VIA_96		0x00000004
+#define VIA_LDVP0	0x00000001
+#define VIA_LDVP1	0x00000002
+#define VIA_DVP0	0x00000004
 #define VIA_CRT		0x00000010
 #define VIA_DVP1	0x00000020
 #define VIA_LVDS1	0x00000040
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 17f228a..145645d 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -64,14 +64,14 @@ static struct fb_ops viafb_ops;
  * K400 seems to support VIA_96, VIA_DVP1, VIA_LVDS{1,2} as in viamode.c
  */
 static const u32 supported_odev_map[] = {
-	[UNICHROME_CLE266]	= VIA_CRT | VIA_6C | VIA_93,
-	[UNICHROME_K400]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+	[UNICHROME_CLE266]	= VIA_CRT | VIA_LDVP0 | VIA_LDVP1,
+	[UNICHROME_K400]	= VIA_CRT | VIA_DVP0 | VIA_DVP1 | VIA_LVDS1
 				| VIA_LVDS2,
-	[UNICHROME_K800]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+	[UNICHROME_K800]	= VIA_CRT | VIA_DVP0 | VIA_DVP1 | VIA_LVDS1
 				| VIA_LVDS2,
-	[UNICHROME_PM800]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+	[UNICHROME_PM800]	= VIA_CRT | VIA_DVP0 | VIA_DVP1 | VIA_LVDS1
 				| VIA_LVDS2,
-	[UNICHROME_CN700]	= VIA_CRT | VIA_96 | VIA_DVP1 | VIA_LVDS1
+	[UNICHROME_CN700]	= VIA_CRT | VIA_DVP0 | VIA_DVP1 | VIA_LVDS1
 				| VIA_LVDS2,
 	[UNICHROME_CX700]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
 	[UNICHROME_CN750]	= VIA_CRT | VIA_DVP1 | VIA_LVDS1 | VIA_LVDS2,
-- 
1.6.3.2

