Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1H2I1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:27:30 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:63403 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1H2I1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:27:04 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?UTF-8?q?=C3=89ric=20Piel?= <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH v4 4/8] Input: elantech - remove ETP_EDGE_FUZZ_V2
Date: Mon, 29 Aug 2011 16:28:55 +0800
Message-Id: <1314606539-24722-5-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314606539-24722-1-git-send-email-jj_ding@emc.com.tw>
References: <1314606539-24722-1-git-send-email-jj_ding@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try to be too clever and remove ETP_EDGE_FUZZ_V2. X, Y ranges
should be just the raw resolution of the device. Otherwise, they can
cause underflow on the Y axis.

Suggested-by: Éric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
Acked-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/elantech.h |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
index b54ea27..d9e6144 100644
--- a/drivers/input/mouse/elantech.h
+++ b/drivers/input/mouse/elantech.h
@@ -66,16 +66,13 @@
 #define ETP_YMAX_V1			(384 - ETP_EDGE_FUZZ_V1)
 
 /*
- * It seems the resolution for hardware version 2 doubled.
- * Hence the X and Y ranges are doubled too.
- * The bezel around the pad also appears to be smaller
+ * The resolution for older v2 hardware doubled.
+ * (newer v2's firmware provides command so we can query)
  */
-#define ETP_EDGE_FUZZ_V2		8
-
-#define ETP_XMIN_V2			(   0 + ETP_EDGE_FUZZ_V2)
-#define ETP_XMAX_V2			(1152 - ETP_EDGE_FUZZ_V2)
-#define ETP_YMIN_V2			(   0 + ETP_EDGE_FUZZ_V2)
-#define ETP_YMAX_V2			( 768 - ETP_EDGE_FUZZ_V2)
+#define ETP_XMIN_V2			0
+#define ETP_XMAX_V2			1152
+#define ETP_YMIN_V2			0
+#define ETP_YMAX_V2			768
 
 #define ETP_PMIN_V2			0
 #define ETP_PMAX_V2			255
-- 
1.7.4.1

