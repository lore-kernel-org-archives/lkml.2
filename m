Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2EMQI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:08:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47592 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab2EMQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:49 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 6/7] pcmcia: Do not change selected options in EXPERT mode
Date: Sun, 13 May 2012 18:07:09 +0200
Message-Id: <1336925230-2853-7-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPERT mode is supposed to toggle the visibility of config options, it
should never modify them, though. If users enable EXPERT mode to change a
single value, they might get unwanted side-effects with our current
behavior.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 drivers/pcmcia/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index bba3ab2..ef0dbf9 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -69,7 +69,6 @@ comment "PC-card bridges"
 config YENTA
 	tristate "CardBus yenta-compatible bridge support"
 	depends on PCI
-	select CARDBUS if !EXPERT
 	select PCCARD_NONSTATIC if PCMCIA != n
 	---help---
 	  This option enables support for CardBus host bridges.  Virtually
-- 
1.7.10.2

