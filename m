Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab0LHB70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:59:26 -0500
Received: from kroah.org ([198.145.64.141]:48447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab0LHA7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:22 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:24 2010
Message-Id: <20101208005724.094976112@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [027/289] ath9k_htc: Set proper firmware offset for Netgear WNDA3200
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajkumar Manoharan <rmanoharan@atheros.com>

commit d654567dec75782d6fd9add4b7b9c50e0926d369 upstream.

Netgear WNDA3200 device uses ar7010 firmware but it is failed to set
correct firmware offset on firmware download which causes device initialization
failure.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -799,10 +799,16 @@ static int ath9k_hif_usb_download_fw(str
 	}
 	kfree(buf);
 
-	if ((hif_dev->device_id == 0x7010) || (hif_dev->device_id == 0x7015))
+	switch (hif_dev->device_id) {
+	case 0x7010:
+	case 0x7015:
+	case 0x9018:
 		firm_offset = AR7010_FIRMWARE_TEXT;
-	else
+		break;
+	default:
 		firm_offset = AR9271_FIRMWARE_TEXT;
+		break;
+	}
 
 	/*
 	 * Issue FW download complete command to firmware.


