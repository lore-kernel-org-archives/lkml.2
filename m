Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761420Ab2FHFZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:25:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43183 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760241Ab2FHFHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:17 -0400
Message-Id: <20120608041843.292749193@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <monstr@monstr.eu>
Subject: [ 18/82] microblaze: Do not select GENERIC_GPIO by default
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 59516b07b4ffa7e607a5787674ea3c405f1b390c upstream.

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
Tested-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


