Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab1ESQB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:01:27 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:43235 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932733Ab1ESQBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:01:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEY81U1tg2Sy/2dsb2JhbACmEHiIcMEXDoYLBJ8I
Date: Thu, 19 May 2011 18:01:23 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jimmy Chen =?utf-8?B?KOmZs+awuOmBlCk=?= <jimmy.chen@moxa.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: add support for MOXA V2100 watchdog
	driver
Message-ID: <20110519160123.GN17887@infomag.iguana.be>
References: <ECB3782BB8F03341905DD923270296115F73D8@mhqms01.moxa.com> <ECB3782BB8F03341905DD92327029611622363@mhqms01.moxa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ECB3782BB8F03341905DD92327029611622363@mhqms01.moxa.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jimmy,

> From: Jimmy Chen <jimmy.chen@moxa.com>
> 
> Does anyone have comment on this driver?
> 
> Signed-off-by: Jimmy Chen <jimmy.chen@moxa.com>

I'm not going to add this driver. Reason is that the underlying hardware is an ITE IT8783 EC LPC superI/O chipset.
Support for this should actually go in it87_wdt.c . I think the following patch replaces your driver (see below).
Could you test it?

(and we can probably add the IT8781F and the IT8782F also, and the hwmon guys can probably add all 3 also in it87.c).

Kind regards,
Wim.


diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 1b0f98b..0afa0bf 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -590,7 +590,8 @@ config IT87_WDT
 	depends on X86 && EXPERIMENTAL
 	---help---
 	  This is the driver for the hardware watchdog on the ITE IT8702,
-	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 Super I/O chips.
+	  IT8712, IT8716, IT8718, IT8720, IT8721, IT8726, IT8783 Super I/O
+	  chips.
 	  This watchdog simply watches your kernel to make sure it doesn't
 	  freeze, and if it does, it reboots your computer after a certain
 	  amount of time.
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index b1bc72f..3529e8c 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -12,7 +12,7 @@
  *		    http://www.ite.com.tw/
  *
  *	Support of the watchdog timers, which are available on
- *	IT8702, IT8712, IT8716, IT8718, IT8720, IT8721 and IT8726.
+ *	IT8702, IT8712, IT8716, IT8718, IT8720, IT8721, IT8726 and IT8783.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -84,6 +84,7 @@
 #define IT8720_ID	0x8720
 #define IT8721_ID	0x8721
 #define IT8726_ID	0x8726	/* the data sheet suggest wrongly 0x8716 */
+#define IT8783_ID	0x8783
 
 /* GPIO Configuration Registers LDN=0x07 */
 #define WDTCTRL		0x71
@@ -585,6 +586,7 @@ static int __init it87_wdt_init(void)
 	case IT8718_ID:
 	case IT8720_ID:
 	case IT8721_ID:
+	case IT8783_ID:
 		max_units = 65535;
 		try_gameport = 0;
 		break;
