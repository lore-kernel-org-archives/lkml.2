Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab2HHM4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:56:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63611 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179Ab2HHMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:55:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 3/6] ARM: sa1100: include asm/io.h in hackkit leds code
Date: Wed,  8 Aug 2012 14:54:50 +0200
Message-Id: <1344430493-5304-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344430493-5304-1-git-send-email-arnd@arndb.de>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/KNzojj8bNtUH875uo2LkKe7AeKX+Ds540MoVDJx1OF
 l3xIEXsvAoiRYH+MD2Qba4K9rCbgP2kfEfpkn9pNeMQsDj56uz
 PRek3vYjdGYje86qDF64LIK6OEYvh68r2n1m9J71a5Sw1VGNgB
 E4kdDoE14qWG//FGlvFDbXQp7AzBy7tCMnP1iCEeUUcbRXSsBW
 LLeG+XT7VQuytrzSmMdkcEr1uh7k5sTg4qrGMmaeoP1mCXDDYv
 5SSPIJI1XlxQEQm4Xusc7lhxjwB3YzgX1T8SvIhsOMYThSbfRt
 Y30OT22T/saUDpxbIlA7mCcZSTIaQkaN2KbW8l/uz0wM5Uoxdx
 0lSLBX3vuJ0YRXYzv9SJt/CgV8vVKTgzhDFieKnZobiLGdNWdJ
 oXzC2UtQE9n/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sa1100 definition of the io_p2v macro has changed in v3.6, and this one
file stopped working because of that.

Without this patch, building hackkit_defconfig results in:

arch/arm/mach-sa1100/leds-hackkit.c: In function 'hackkit_leds_event':
arch/arm/mach-sa1100/leds-hackkit.c:39:4: error: implicit declaration of function 'IOMEM' [-Werror=implicit-function-declaration]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-sa1100/leds-hackkit.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sa1100/leds-hackkit.c b/arch/arm/mach-sa1100/leds-hackkit.c
index 6a23524..9c79674 100644
--- a/arch/arm/mach-sa1100/leds-hackkit.c
+++ b/arch/arm/mach-sa1100/leds-hackkit.c
@@ -13,6 +13,7 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
+#include <asm/io.h>
 
 #include "leds.h"
 
-- 
1.7.10

