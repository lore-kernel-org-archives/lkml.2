Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1EXPMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:12:20 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53220 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753332Ab1EXPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:12:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=wrmaPP/KsMfPOxGqK4hQTCUOGDvHcROh1gAbLgZqglA7ApF1Ms5WbuBfQOtC+e4XGyNbq9TIsmsXj0W0vBe1oKygyA/QbwxpEXeQ9i3IiSANgB35Mr78M6MmI9h6exT8;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: Default to 'n' for 2 new added devices in Kconfig.
Date: Tue, 24 May 2011 23:11:56 +0800
Message-Id: <1306249916-6638-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.40.193 authed with tm@tao.ma}
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
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    1 +
 drivers/net/wireless/rt2x00/Kconfig    |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index d9ff841..2548f47 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -25,6 +25,7 @@ config ATH9K
 
 config ATH9K_PCI
 	bool "Atheros ath9k PCI/PCIe bus support"
+	default n
 	depends on ATH9K && PCI
 	default PCI
 	---help---
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 9def1e5..677abc9 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -166,7 +166,7 @@ config RT2800USB_RT35XX
 config RT2800USB_RT53XX
        bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
        depends on EXPERIMENTAL
-       default y
+       default n
        ---help---
          This adds support for rt53xx wireless chipset family to the
          rt2800pci driver.
-- 
1.7.4

