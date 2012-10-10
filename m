Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab2JJS4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:56:05 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:47608 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757040Ab2JJS4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:56:00 -0400
Message-ID: <5075C4B5.3050005@xenotime.net>
Date: Wed, 10 Oct 2012 11:55:49 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>, Daniel Drake <dsd@laptop.org>
Subject: [PATCH resend] olpc: fix olpc-xo1-sci.c build errors
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors when CONFIG_INPUT=m.
This is not pretty, but all of the OLPC kconfig options
are bool instead of tristate.

arch/x86/built-in.o: In function `send_lid_state':
olpc-xo1-sci.c:(.text+0x1d323): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1d338): undefined reference to `input_event'
arch/x86/built-in.o: In function `free_ebook_switch':
olpc-xo1-sci.c:(.text+0x1d529): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.text+0x1d533): undefined reference to `input_free_device'
arch/x86/built-in.o: In function `free_power_button':
olpc-xo1-sci.c:(.text+0x1d549): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.text+0x1d553): undefined reference to `input_free_device'
arch/x86/built-in.o: In function `send_ebook_state':
olpc-xo1-sci.c:(.text+0x1d632): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1d647): undefined reference to `input_event'
arch/x86/built-in.o: In function `xo1_sci_intr':
olpc-xo1-sci.c:(.text+0x1d78e): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1d7a3): undefined reference to `input_event'
olpc-xo1-sci.c:(.text+0x1d7be): undefined reference to `input_event'
arch/x86/built-in.o:olpc-xo1-sci.c:(.text+0x1d7d3): more undefined references to `input_event' follow
arch/x86/built-in.o: In function `free_lid_switch':
olpc-xo1-sci.c:(.text+0x1d7fd): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.text+0x1d807): undefined reference to `input_free_device'
arch/x86/built-in.o: In function `setup_lid_switch':
olpc-xo1-sci.c:(.devinit.text+0x155): undefined reference to `input_allocate_device'
olpc-xo1-sci.c:(.devinit.text+0x1a4): undefined reference to `input_register_device'
olpc-xo1-sci.c:(.devinit.text+0x1ce): undefined reference to `input_unregister_device'
olpc-xo1-sci.c:(.devinit.text+0x1d8): undefined reference to `input_free_device'
arch/x86/built-in.o: In function `xo1_sci_probe':
olpc-xo1-sci.c:(.devinit.text+0x235): undefined reference to `input_allocate_device'
olpc-xo1-sci.c:(.devinit.text+0x285): undefined reference to `input_register_device'
olpc-xo1-sci.c:(.devinit.text+0x299): undefined reference to `input_free_device'
olpc-xo1-sci.c:(.devinit.text+0x2e1): undefined reference to `input_register_device'
olpc-xo1-sci.c:(.devinit.text+0x2f5): undefined reference to `input_free_device'
olpc-xo1-sci.c:(.devinit.text+0x54c): undefined reference to `input_allocate_device'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	Andres Salomon <dilinger@queued.net>
Cc:	Chris Ball <cjb@laptop.org>
Cc:	Jon Nettleton <jon.nettleton@gmail.com>
Cc:	Daniel Drake <dsd@laptop.org>
---
Found in linux-next but also applies to mainline.
This patch was first sent 2012.Jan.10, 10 months ago.

But in the long run, fixing this driver kconfig to be tristate
instead of bool would be a very good change.

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20121010.orig/arch/x86/Kconfig
+++ linux-next-20121010/arch/x86/Kconfig
@@ -2126,6 +2126,7 @@ config OLPC_XO1_RTC
 config OLPC_XO1_SCI
 	bool "OLPC XO-1 SCI extras"
 	depends on OLPC && OLPC_XO1_PM
+	depends on INPUT=y
 	select POWER_SUPPLY
 	select GPIO_CS5535
 	select MFD_CORE
