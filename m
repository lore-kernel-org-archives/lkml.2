Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab2AYUyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:54:07 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:35787 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752310Ab2AYUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:54:05 -0500
Message-ID: <4F20798C.4040205@xenotime.net>
Date: Wed, 25 Jan 2012 13:52:12 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] uwb & wusb: fix kconfig error
References: <20120125141938.c1a9460d56948e1c7b26d3f8@canb.auug.org.au>
In-Reply-To: <20120125141938.c1a9460d56948e1c7b26d3f8@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix UWB/WUSB kconfig error by changing 'select' to 'depends on'.

drivers/usb/wusbcore/Kconfig:4:error: recursive dependency detected!
drivers/usb/wusbcore/Kconfig:4:	symbol USB_WUSB is selected by USB_HWA_HCD
drivers/usb/host/Kconfig:559:	symbol USB_HWA_HCD depends on UWB
drivers/uwb/Kconfig:5:	symbol UWB is selected by USB_WUSB

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/usb/wusbcore/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120125.orig/drivers/usb/wusbcore/Kconfig
+++ linux-next-20120125/drivers/usb/wusbcore/Kconfig
@@ -6,7 +6,7 @@ config USB_WUSB
 	depends on EXPERIMENTAL
 	depends on USB
 	depends on PCI
-        select UWB
+	depends on UWB
         select CRYPTO
         select CRYPTO_BLKCIPHER
         select CRYPTO_CBC
