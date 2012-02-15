Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418Ab2BOJfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:35:54 -0500
Received: from smtp-out-228.synserver.de ([212.40.185.228]:1070 "EHLO
	smtp-out-225.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755446Ab2BOJfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:35:52 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23804
From: Lars-Peter Clausen <lars@metafoo.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] microblaze: Do not select GENERIC_GPIO by default
Date: Wed, 15 Feb 2012 10:36:06 +0100
Message-Id: <1329298566-8596-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9
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
---
 arch/microblaze/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index c8d6efb..e031036 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -49,7 +49,7 @@ config GENERIC_CLOCKEVENTS
 	def_bool y
 
 config GENERIC_GPIO
-	def_bool y
+	bool
 
 config GENERIC_CSUM
 	def_bool y
-- 
1.7.9

