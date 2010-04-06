Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab0DFFFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:05:47 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:40615 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0DFFFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:05:41 -0400
Date: Mon, 5 Apr 2010 22:04:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: akpm@linux-foundation.org, rvinyard@cs.nmsu.edu,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
Message-Id: <20100405220414.9d90da83.randy.dunlap@oracle.com>
In-Reply-To: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBAC117.009B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

HID_PICOLCD should depend on LCD_CLASS_DEVICE, otherwise the
build fails when HID_PICOLCD=y and LCD_CLASS_DEVICE=m:

hid-picolcd.c:(.text+0x84523f): undefined reference to `lcd_device_unregister'
hid-picolcd.c:(.text+0x8478ab): undefined reference to `lcd_device_register'
hid-picolcd.c:(.text+0x84c15f): undefined reference to `lcd_device_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/hid/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2010-0405-1609.orig/drivers/hid/Kconfig
+++ mmotm-2010-0405-1609/drivers/hid/Kconfig
@@ -265,6 +265,7 @@ config HID_PETALYNX
 config HID_PICOLCD
 	tristate "PicoLCD (graphic version)"
 	depends on USB_HID
+	depends on LCD_CLASS_DEVICE
 	select FB_DEFERRED_IO if FB
 	select FB_SYS_FILLRECT if FB
 	select FB_SYS_COPYAREA if FB
