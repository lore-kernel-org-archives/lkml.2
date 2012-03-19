Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032316Ab2CSRtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:49:17 -0400
Received: from canardo.mork.no ([148.122.252.1]:42651 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030417Ab2CSRtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:49:14 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] net: qmi_wwan: fix build error due to cdc-wdm dependecy
Date: Mon, 19 Mar 2012 18:48:29 +0100
Message-Id: <1332179309-4163-1-git-send-email-bjorn@mork.no>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <20120319184830.fce597a16eaf7206195a7a45@canb.auug.org.au>
References: <20120319184830.fce597a16eaf7206195a7a45@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:

drivers/built-in.o: In function `qmi_wwan_bind_shared':
qmi_wwan.c:(.text+0x25b686): undefined reference to `usb_cdc_wdm_register'
make[1]: *** [.tmp_vmlinux1] Error 1

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
Thanks for noticing.

This should have been in commit c3ecb08a
 net: qmi_wwan: support devices having a shared QMI/wwan interface


Bjørn


 drivers/net/usb/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 4bad899..833e32f 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -401,6 +401,7 @@ config USB_NET_KALMIA
 config USB_NET_QMI_WWAN
 	tristate "QMI WWAN driver for Qualcomm MSM based 3G and LTE modems"
 	depends on USB_USBNET
+	select USB_WDM
 	help
 	  Support WWAN LTE/3G devices based on Qualcomm Mobile Data Modem
 	  (MDM) chipsets.  Examples of such devices are
-- 
1.7.9.1

