Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197Ab1KJDj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:39:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964871Ab1KJDju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:39:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:48 2011
Message-Id: <20111109213148.841179134@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [067/264] ath9k_hw: Fix magnitude/phase coeff correction
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit e9c10469cf3c71bc1c6b0f01319161e277d6ac9b upstream.

Do the magnitude/phase coeff correction only if the outlier
is detected. Updating wrong magnitude/phase coeff factor
impacts not only tx gain setting but also leads to poor
performance in congested networks. In the clear environment
the impact is very minimal because the outlier happens
very rarely according to the past experiment. It occured
less than once every 1000 calibrations.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -643,8 +643,9 @@ static void ar9003_hw_detect_outlier(int
 			outlier_idx = max_idx;
 		else
 			outlier_idx = min_idx;
+
+		mp_coeff[outlier_idx] = mp_avg;
 	}
-	mp_coeff[outlier_idx] = mp_avg;
 }
 
 static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,


