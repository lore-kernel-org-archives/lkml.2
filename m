Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2EMQJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:09:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39930 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2EMQHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:46 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/7] rfkill: Do not change default values in EXPERT mode
Date: Sun, 13 May 2012 18:07:06 +0200
Message-Id: <1336925230-2853-4-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expert mode was designed to toggle visibility of options and not to
change their behavior. If a user wants to tweak a single value and
enables EXPERT mode to do this, he will have several unexpected
side effects when other subsystems toggle their default values based
on EXPERT mode. This makes EXPERT pretty useless.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 net/rfkill/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
index 78efe89..3d96f42 100644
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -21,7 +21,7 @@ config RFKILL_INPUT
 	bool "RF switch input support" if EXPERT
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
-	default y if !EXPERT
+	default y
 
 config RFKILL_REGULATOR
 	tristate "Generic rfkill regulator driver"
-- 
1.7.10.2

