Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab0LHB5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:57:16 -0500
Received: from kroah.org ([198.145.64.141]:48525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab0LHA7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:32 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:25 2010
Message-Id: <20101208005725.149945421@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [038/289] ath9k_htc: Add new devices into AR7010
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit 7cbf2611dac8d5f76fe64795a9426b8c97e6c3f8 upstream.

Treat new PIDs (0xA704, 0x1200) as AR7010 devices.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |    4 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 ++
 drivers/net/wireless/ath/ath9k/reg.h          |    4 +++-
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -803,6 +803,8 @@ static int ath9k_hif_usb_download_fw(str
 	case 0x7010:
 	case 0x7015:
 	case 0x9018:
+	case 0xA704:
+	case 0x1200:
 		firm_offset = AR7010_FIRMWARE_TEXT;
 		break;
 	default:
@@ -909,6 +911,8 @@ static int ath9k_hif_usb_probe(struct us
 	case 0x7010:
 	case 0x7015:
 	case 0x9018:
+	case 0xA704:
+	case 0x1200:
 		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
 			hif_dev->fw_name = FIRMWARE_AR7010_1_1;
 		else
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -247,6 +247,8 @@ static int ath9k_init_htc_services(struc
 	case 0x7010:
 	case 0x7015:
 	case 0x9018:
+	case 0xA704:
+	case 0x1200:
 		priv->htc->credits = 45;
 		break;
 	default:
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -901,7 +901,9 @@
 #define AR_DEVID_7010(_ah) \
 	(((_ah)->hw_version.devid == 0x7010) || \
 	 ((_ah)->hw_version.devid == 0x7015) || \
-	 ((_ah)->hw_version.devid == 0x9018))
+	 ((_ah)->hw_version.devid == 0x9018) || \
+	 ((_ah)->hw_version.devid == 0xA704) || \
+	 ((_ah)->hw_version.devid == 0x1200))
 
 #define AR9287_HTC_DEVID(_ah) \
 	(((_ah)->hw_version.devid == 0x7015) || \


