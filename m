Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2KUSRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:17:38 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39926 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755409Ab2KUSRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:17:37 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org
Subject: [PATCH] brcmsmac: Add __printf verification to logging prototypes
Date: Wed, 21 Nov 2012 10:17:34 -0800
Message-Id: <a74034e340d7db52dfb0b1a01c18759eb091fd18.1353521783.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding __printf helps spot format and argument mismatches.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/debug.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.h b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
index c0d2cf7..f77066b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.h
@@ -8,17 +8,23 @@
 #include "main.h"
 #include "mac80211_if.h"
 
+__printf(2, 3)
 void __brcms_info(struct device *dev, const char *fmt, ...);
+__printf(2, 3)
 void __brcms_warn(struct device *dev, const char *fmt, ...);
+__printf(2, 3)
 void __brcms_err(struct device *dev, const char *fmt, ...);
+__printf(2, 3)
 void __brcms_crit(struct device *dev, const char *fmt, ...);
 
 #if defined(CONFIG_BRCMDBG) || defined(CONFIG_BRCM_TRACING)
+__printf(4, 5)
 void __brcms_dbg(struct device *dev, u32 level, const char *func,
 		 const char *fmt, ...);
 #else
-static inline void __brcms_dbg(struct device *dev, u32 level,
-			       const char *func, const char *fmt, ...)
+static inline __printf(4, 5)
+void __brcms_dbg(struct device *dev, u32 level, const char *func,
+		 const char *fmt, ...)
 {
 }
 #endif
-- 
1.7.8.112.g3fd21

