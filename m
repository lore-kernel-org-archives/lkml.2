Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab0CXTUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:20:00 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:30931 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab0CXTT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:19:58 -0400
Message-ID: <4BAA658E.20400@oracle.com>
Date: Wed, 24 Mar 2010 12:18:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH -mmotm] leds-input: depends on INPUT
References: <201003232301.o2NN1bms031050@imap1.linux-foundation.org>
In-Reply-To: <201003232301.o2NN1bms031050@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BAA6598.00DC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

leds-input uses input_*() functions so it should depend on INPUT.

leds-input.c:(.text+0x6e0513): undefined reference to `input_unregister_handle'
leds-input.c:(.text+0x6e06eb): undefined reference to `input_inject_event'
leds-input.c:(.text+0x6e0700): undefined reference to `input_inject_event'
leds-input.c:(.text+0x6e0906): undefined reference to `input_register_handle'
leds-input.c:(.text+0x6e0bdc): undefined reference to `input_unregister_handler'
leds-input.c:(.init.text+0x285c8): undefined reference to `input_register_handler'
leds-input.c:(.exit.text+0x7b04): undefined reference to `input_unregister_handler'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2010-0323-1534.orig/drivers/leds/Kconfig
+++ mmotm-2010-0323-1534/drivers/leds/Kconfig
@@ -25,7 +25,7 @@ config LEDS_88PM860X
 
 config LEDS_INPUT
 	tristate "LED Support using input keyboards"
-	depends on LEDS_CLASS
+	depends on LEDS_CLASS && INPUT
 	select LEDS_TRIGGERS
 	help
 	  This option enables support for the LEDs on keyboard managed
