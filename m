Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1HQD24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 23:28:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34463 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab1HQD2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 23:28:53 -0400
MIME-Version: 1.0
From: Pavel Ivanov <paivanof@gmail.com>
Date: Tue, 16 Aug 2011 23:28:22 -0400
Message-ID: <CAG1a4rt_NML2Q_Mkd+RuvLvft4D6inG7c9=s6kpAXqtAvatOBg@mail.gmail.com>
Subject: [PATCH] ath9k: make driver usable standalone
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ath9k is the only wireless driver included in the build
WIRELESS_EXT configuration option becomes undefined. Because of that
driver becomes essentially unusable as you can't actually connect to
any WiFi network. By including WIRELESS_EXT into Kconfig we ensure
that build with ath9k and without other drivers (having WIRELESS_EXT
selected in their Kconfig) is actually usable.

Signed-off-by: Pavel Ivanov <paivanof@gmail.com>
---

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
b/drivers/net/wireless/ath/ath9k/Kconfig
index d9c08c6..2573f77 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -11,6 +11,7 @@ config ATH9K
 	select LEDS_CLASS
 	select NEW_LEDS
 	select ATH9K_COMMON
+	select WIRELESS_EXT
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros IEEE 802.11n AR5008, AR9001 and AR9002 family
