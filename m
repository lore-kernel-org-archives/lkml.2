Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab1BPRXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:23:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59587 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1BPRXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:23:19 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] ARM: reenable DEBUG_SECTION_MISMATCH
Date: Wed, 16 Feb 2011 18:23:13 +0100
Message-Id: <1297876993-4146-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 2.6.38-rc4-git9 only 29 out of 133 defconfigs still produce section
mismatches.  These defconfigs produce 55 mismatches (weighted sum, so
maybe less uniq mismatches).

This is in my opinion enough to start scaring people about the remaining
problems.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3967c23..1130dd4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -102,7 +102,7 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	depends on UNDEFINED || (BLACKFIN)
+	depends on ARM || BLACKFIN
 	default y
 	# This option is on purpose disabled for now.
 	# It will be enabled when we are down to a reasonable number
-- 
1.7.2.3

