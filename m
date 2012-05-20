Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2ETCL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:11:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42648 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2ETCL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:11:57 -0400
Date: Sat, 19 May 2012 19:11:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jiri Kosina <jkosina@suse.cz>
cc: Przemo Firszt <przemo@firszt.eu>, pinglinux@gmail.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: Re: [PATCH] HID: wacom: Add LED selector control for Wacom Intuos4
 WL
In-Reply-To: <alpine.LNX.2.00.1205111448350.17928@pobox.suse.cz>
Message-ID: <alpine.DEB.2.00.1205191905430.24674@chino.kir.corp.google.com>
References: <1336674232-5410-1-git-send-email-przemo@firszt.eu> <alpine.LNX.2.00.1205111448350.17928@pobox.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Jiri Kosina wrote:

> > Add sysfs attribute to control LED selector on Wacom Intuos4. 
> 
> Applied, thanks.
> 

This results in a build failure if you've enabled CONFIG_HID_WACOM without 
CONFIG_NEW_LEDS, which is required for CONFIG_LEDS_CLASS.

drivers/built-in.o: In function `led_classdev_unregister':
(.text+0x3ff685): undefined reference to `led_brightness_set'
drivers/built-in.o: In function `led_classdev_unregister':
(.text+0x3ff695): undefined reference to `leds_list_lock'
drivers/built-in.o: In function `led_classdev_unregister':
(.text+0x3ff6ab): undefined reference to `leds_list_lock'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x3ff6e9): undefined reference to `leds_list_lock'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x3ff6f5): undefined reference to `leds_list'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x3ff700): undefined reference to `leds_list'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x3ff70c): undefined reference to `leds_list_lock'

Please apply the patch below.


hid, wacom: fix build breakage without CONFIG_LEDS_CLASS

CONFIG_HID_WACOM must depend on CONFIG_LEDS_CLASS, otherwise 
CONFIG_NEW_LEDS may be disabled.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/hid/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -613,8 +613,8 @@ config THRUSTMASTER_FF
 config HID_WACOM
 	tristate "Wacom Bluetooth devices support"
 	depends on BT_HIDP
+	depends on LEDS_CLASS
 	select POWER_SUPPLY
-	select LEDS_CLASS
 	---help---
 	Support for Wacom Graphire Bluetooth and Intuos4 WL tablets.
 
