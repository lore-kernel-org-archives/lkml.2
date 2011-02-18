Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab1BRUrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 15:47:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42970 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab1BRUrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 15:47:33 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] kbuild: reenable section mismatch analysis
Date: Fri, 18 Feb 2011 21:47:20 +0100
Message-Id: <1298062040-2774-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110216200734.GA25184@merkur.ravnborg.org>
References: <20110216200734.GA25184@merkur.ravnborg.org>
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

This was disabled in commit

	e5f95c8 (kbuild: print only total number of section mismatces found)

because there were too many warnings.  Now we're down to a reasonable
number again, so we start scaring people with the details.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 lib/Kconfig.debug |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2b97418..0f77ed1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -102,11 +102,7 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	depends on UNDEFINED || (BLACKFIN)
 	default y
-	# This option is on purpose disabled for now.
-	# It will be enabled when we are down to a reasonable number
-	# of section mismatch warnings (< 10 for an allyesconfig build)
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.
-- 
1.7.2.3

