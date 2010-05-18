Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0ERDQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:16:47 -0400
Received: from relay11.uol.com.br ([200.147.1.1]:41726 "EHLO
	relay11.uol.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0ERDQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:16:46 -0400
X-UOL-SMTP: SMTPS25
Date: Tue, 18 May 2010 00:14:36 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Select WIRELESS_EXT for the rndis_wlan driver to compile
Message-ID: <20100518031436.GA6006@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SIG5: 55d7ab69c3b433021b81fd8d951f6022
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rndis_wlan.ko module needs the function wireless_send_event, which
is not included if the option WIRELESS_EXT is not selected by the
driver.  Otherwise, the user gets compilation problems like:

,----
| (...)
| Kernel: arch/x86/boot/bzImage is ready  (#3)
|   Building modules, stage 2.
|   MODPOST 427 modules
| ERROR: "wireless_send_event" [drivers/net/wireless/rndis_wlan.ko] undefined!
| make[1]: *** [__modpost] Error 1
| make: *** [modules] Error 2
`----
---

I don't know if this is a proper fix, but I would love to know a better
solution to the problem.

 drivers/net/wireless/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 5889436..0d5fff4 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -186,6 +186,7 @@ config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
 	depends on USB && EXPERIMENTAL
 	depends on CFG80211
+	select WIRELESS_EXT
 	select USB_USBNET
 	select USB_NET_CDCETHER
 	select USB_NET_RNDIS_HOST
-- 
1.7.1

