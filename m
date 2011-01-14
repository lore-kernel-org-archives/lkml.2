Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1ANXI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:08:26 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:33010 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752661Ab1ANXIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:08:25 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18Hmn4BshcHxnm0qpb7LolCeWApBu4r/AMVyCmGMQ
	yIfQrc3ID78L0h
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] staging: r8712u: Fix external firmware loading
Date: Sat, 15 Jan 2011 00:08:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-0.slh.4-aptosid-686; KDE/4.4.5; i686; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
References: <4d30b7fa.j0xZq9/VwpVGxx/H%Larry.Finger@lwfinger.net> <201101150005.26858.s.L-H@gmx.de>
In-Reply-To: <201101150005.26858.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101150008.18054.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* select FW_LOADER
* change firmware location to represent published linux-fimware.git
* declare MODULE_FIRMWARE for r8712u

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
 drivers/staging/rtl8712/Kconfig    |    1 +
 drivers/staging/rtl8712/hal_init.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/Kconfig b/drivers/staging/rtl8712/Kconfig
index 1e9a230..041e1e8 100644
--- a/drivers/staging/rtl8712/Kconfig
+++ b/drivers/staging/rtl8712/Kconfig
@@ -3,6 +3,7 @@ config R8712U
 	depends on WLAN && USB
 	select WIRELESS_EXT
 	select WEXT_PRIV
+	select FW_LOADER
 	default N
 	---help---
 	This option adds the Realtek RTL8712 USB device such as the D-Link DWA-130.
diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 52ab2d5..1411c7bf 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -40,7 +40,7 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
 		    const u8 **ppmappedfw)
 {
 	int rc;
-	const char firmware_file[] = "rtl8712u/rtl8712u.bin";
+	const char firmware_file[] = "rtlwifi/rtl8712u.bin";
 	const struct firmware **praw = (const struct firmware **)
 				       (pphfwfile_hdl);
 	struct dvobj_priv *pdvobjpriv = (struct dvobj_priv *)
@@ -58,6 +58,7 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
 	*ppmappedfw = (u8 *)((*praw)->data);
 	return (*praw)->size;
 }
+MODULE_FIRMWARE("rtlwifi/rtl8712u.bin");
 
 static void fill_fwpriv(struct _adapter *padapter, struct fw_priv *pfwpriv)
 {
-- 
1.7.2.3

