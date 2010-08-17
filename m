Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab0HQN3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:29:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:44032 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab0HQN3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:29:41 -0400
Date: Tue, 17 Aug 2010 22:29:19 +0900 (JST)
Message-Id: <20100817.222919.78028650.ryusuke@osrg.net>
To: Matthew Garrett <mjg@redhat.com>, Pierre Ducroquet <pinaraf@pinaraf.info>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.36-rc1 compile breakage in toshiba_acpi driver
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20100817.185725.260189930.ryusuke@osrg.net>
References: <20100817.185725.260189930.ryusuke@osrg.net>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 17 Aug 2010 22:29:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010 18:57:25 +0900 (JST), Ryusuke Konishi wrote:
> Hi,
> 
> I got the following error during compiling 2.6.36-rc1.
> 
> > ERROR: "led_classdev_register" [drivers/platform/x86/toshiba_acpi.ko] undefined!
> > ERROR: "led_classdev_unregister" [drivers/platform/x86/toshiba_acpi.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> 
> Is anyone looking at this issue ?

This turns out to be a Kconfig dependency problem introduced by commit
6c3f6e6c ("toshiba-acpi: Add support for Toshiba Illumination.")

The following patch fixes it.

Ryusuke Konishi

---
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

toshiba-acpi: fix build error due to missing Kconfig dependency

The commit 6c3f6e6c ("toshiba-acpi: Add support for Toshiba
Illumination.") introduced dependency on NEW_LEDS and LEDS_CLASS, so
it should be added to the Kconfig file.

> ERROR: "led_classdev_register" [drivers/platform/x86/toshiba_acpi.ko] undefined!
> ERROR: "led_classdev_unregister" [drivers/platform/x86/toshiba_acpi.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Pierre Ducroquet <pinaraf@pinaraf.info>
Cc: platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 044f430..5c3f044 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -490,6 +490,8 @@ config ACPI_TOSHIBA
 	depends on RFKILL || RFKILL = n
 	select INPUT_POLLDEV
 	select BACKLIGHT_CLASS_DEVICE
+	select NEW_LEDS
+	select LEDS_CLASS
 	---help---
 	  This driver adds support for access to certain system settings
 	  on "legacy free" Toshiba laptops.  These laptops can be recognized by
-- 
1.6.6.2

