Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab0HFSlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:41:14 -0400
Received: from kroah.org ([198.145.64.141]:48634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964891Ab0HFSfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:43 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:01 2010
Message-Id: <20100806183201.564503709@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [17/38] ath9k_hw: fix a sign error in the IQ calibration code
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 23399016d9583d799ca98ce443a1410b13c3e96e upstream.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -239,7 +239,7 @@ static void ar9002_hw_iqcalibrate(struct
 			if (qCoff > 15)
 				qCoff = 15;
 			else if (qCoff <= -16)
-				qCoff = 16;
+				qCoff = -16;
 
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",


