Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2FGEPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:15:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab2FGEPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:15:08 -0400
Message-Id: <20120607040336.793354927@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:38 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <monstr@monstr.eu>
Subject: [ 02/82] microblaze: Do not select GENERIC_GPIO by default
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/microblaze/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -57,7 +57,7 @@ config GENERIC_CLOCKEVENTS
 	def_bool y
 
 config GENERIC_GPIO
-	def_bool y
+	bool
 
 config GENERIC_CSUM
 	def_bool y


