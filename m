Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2DINDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:03:33 -0400
Received: from smtp-out-106.synserver.de ([212.40.185.106]:1069 "EHLO
	smtp-out-105.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751620Ab2DINDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:03:32 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12925
From: Lars-Peter Clausen <lars@metafoo.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-linux@lists.itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend] microblaze: Do not select GENERIC_GPIO by default
Date: Mon,  9 Apr 2012 15:05:44 +0200
Message-Id: <1333976744-9404-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The microblaze architecture does not provide a native GPIO API implementation
nor requires GPIOLIB, but still selects GENERIC_GPIO by default. As a result the
following build error occurs, if GPIOLIB is not selected:

	include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
	include/asm-generic/gpio.h:218: error: implicit declaration of function '__gpio_get_value'
	include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
	include/asm-generic/gpio.h:224: error: implicit declaration of function '__gpio_set_value'

This patch addresses the issue by not selecting GENERIC_GPIO by default. This
causes the GPIO API to be stubbed out if no implementation is provided.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: stable@vger.kernel.org
---
 arch/microblaze/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index ac22dc7..333b85e 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -57,7 +57,7 @@ config GENERIC_CLOCKEVENTS
 	def_bool y
 
 config GENERIC_GPIO
-	def_bool y
+	bool
 
 config GENERIC_CSUM
 	def_bool y
-- 
1.7.9.5

