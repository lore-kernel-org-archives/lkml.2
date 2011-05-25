Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1EYBoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 21:44:24 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:39447 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752399Ab1EYBoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 21:44:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:X-Identified-User;
	b=FpUDZzwPPDXYT+FdXKGf3fLC3qWPeIvq0SyPpRQSWYwDZNG8SuTlj3YgxtvwVwkLSzChzdh6fWwMG5TE1qYw0h88NAv7R/EQgR2cAlxpdbEqzqP1u8zPP6nzsBMRGj7Q;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] wireless: Default to 'n' for 2 new added devices in Kconfig.
Date: Wed, 25 May 2011 09:44:05 +0800
Message-Id: <1306287845-2230-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306250341.3839.0.camel@jlt3.sipsolutions.net>
References: <1306250341.3839.0.camel@jlt3.sipsolutions.net>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

We make oldconfig every time when a new kernel arrives, but
if we don't have such a device(I guess this is the most common
case for a new device), the default value should be 'n' so
that the kernel size we build doesn't grow up too much quickly.
For anyone who has the device, it is OK for them to turn it on
by themselves.

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    1 -
 drivers/net/wireless/rt2x00/Kconfig    |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index d9ff841..d9c08c6 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -26,7 +26,6 @@ config ATH9K
 config ATH9K_PCI
 	bool "Atheros ath9k PCI/PCIe bus support"
 	depends on ATH9K && PCI
-	default PCI
 	---help---
 	  This option enables the PCI bus support in ath9k.
 
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 9def1e5..b2f8b8f 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -166,7 +166,6 @@ config RT2800USB_RT35XX
 config RT2800USB_RT53XX
        bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
        depends on EXPERIMENTAL
-       default y
        ---help---
          This adds support for rt53xx wireless chipset family to the
          rt2800pci driver.
-- 
1.7.4

