Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab1DXB5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:57:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55513 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757414Ab1DXB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:57:16 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18PIqsdIbUPnqAi91HMClSkSpKC9EuWBS5jSThhy2
	XNZD2/bt4pwaPk
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/3] viafb: delete clock and PLL initialization
Date: Sun, 24 Apr 2011 02:13:20 +0000
Message-Id: <1303611201-8727-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1303611201-8727-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1303611201-8727-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do this also in the real program code so there is no reason to
do it here too (and here it's hardly readable).

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viamode.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 8c5bc41..e550063 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -41,7 +41,6 @@ struct io_reg CN400_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFF, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
-{VIACR, CR6C, 0xFF, 0x00},
 {VIACR, CR88, 0xFF, 0x40},	/* LCD Panel Type                      */
 {VIACR, CR89, 0xFF, 0x00},	/* LCD Timing Control 0                */
 {VIACR, CR8A, 0xFF, 0x88},	/* LCD Timing Control 1                */
@@ -87,7 +86,6 @@ struct io_reg CN700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFD, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
-{VIACR, CR6C, 0xFF, 0x00},
 {VIACR, CR77, 0xFF, 0x00},	/* LCD scaling Factor */
 {VIACR, CR78, 0xFF, 0x00},	/* LCD scaling Factor */
 {VIACR, CR79, 0xFF, 0x00},	/* LCD scaling Factor */
@@ -161,7 +159,7 @@ struct io_reg CX700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIASR, SR1B, 0xFF, 0xF0},
 {VIASR, SR1E, 0xFF, 0x01},
 {VIASR, SR2A, 0xFF, 0x00},
-{VIASR, SR2D, 0xFF, 0xFF},	/* VCK and LCK PLL power on.           */
+{VIASR, SR2D, 0xC0, 0xC0},	/* delayed E3_ECK */
 {VIACR, CR0A, 0xFF, 0x1E},	/* Cursor Start                        */
 {VIACR, CR0B, 0xFF, 0x00},	/* Cursor End                          */
 {VIACR, CR0E, 0xFF, 0x00},	/* Cursor Location High                */
@@ -174,7 +172,6 @@ struct io_reg CX700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFF, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
-{VIACR, CR6C, 0xFF, 0x00},
 {VIACR, CR88, 0xFF, 0x40},	/* LCD Panel Type                      */
 {VIACR, CR89, 0xFF, 0x00},	/* LCD Timing Control 0                */
 {VIACR, CR8A, 0xFF, 0x88},	/* LCD Timing Control 1                */
@@ -204,7 +201,7 @@ struct io_reg VX855_ModeXregs[] = {
 {VIASR, SR2A, 0xF0, 0x00},
 {VIASR, SR58, 0xFF, 0x00},
 {VIASR, SR59, 0xFF, 0x00},
-{VIASR, SR2D, 0xFF, 0xFF},	/* VCK and LCK PLL power on.           */
+{VIASR, SR2D, 0xC0, 0xC0},	/* delayed E3_ECK */
 {VIACR, CR09, 0xFF, 0x00},	/* Initial CR09=0*/
 {VIACR, CR11, 0x8F, 0x00},	/* IGA1 initial  Vertical end       */
 {VIACR, CR17, 0x7F, 0x00}, 	/* IGA1 CRT Mode control init   */
@@ -219,7 +216,6 @@ struct io_reg VX855_ModeXregs[] = {
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFD, 0x60},
 {VIACR, CR6B, 0xFF, 0x00},
-{VIACR, CR6C, 0xFF, 0x00},
 {VIACR, CR88, 0xFF, 0x40},          /* LCD Panel Type                      */
 {VIACR, CR89, 0xFF, 0x00},          /* LCD Timing Control 0                */
 {VIACR, CR8A, 0xFF, 0x88},          /* LCD Timing Control 1                */
-- 
1.6.3.2

