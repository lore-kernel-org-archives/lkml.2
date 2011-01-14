Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1ANX3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:29:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1ANX3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:29:23 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=o0z8XtDfgsIA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=ZGnmX5WwYlvDyfHlGK8A:9 a=gTrsBU-fWzqzWFoIat0A:7 a=SjcDQY7qX04po4s-prlb76uwKwwA:4 a=CjuIK1q_8ugA:10 a=_RhRFcbxBZMA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Fri, 14 Jan 2011 17:29:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: florian.c.schilhabel@googlemail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: r8712u: Firmware changes for driver
Message-ID: <4d30dc6a.Ckx8zvYnh6tT+mgY%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* select FW_LOADER in Kconfig - From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
* declare MODULE_FIRMWARE for r8712u and change to correct directory
* delete 10K line farray.h containing internal firmware

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/Kconfig    |    1 +
 drivers/staging/rtl8712/farray.h   |10197 ------------------------------------
 drivers/staging/rtl8712/hal_init.c |    3 +-
 3 files changed, 3 insertions(+), 10198 deletions(-)
 delete mode 100644 drivers/staging/rtl8712/farray.h

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
index 52ab2d5..1411c7b 100644
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
1.7.1

