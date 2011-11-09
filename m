Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211Ab1KJDj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:39:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935897Ab1KJDjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:39:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:48 2011
Message-Id: <20111109213148.738734220@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [066/264] ath9k_hw: Fix descriptor status of TxOpExceeded
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 2a15b394f8e46dd3e2ab365ab41cfa701d92fa77 upstream.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -253,8 +253,6 @@ static int ar9003_hw_proc_txdesc(struct
 		return -EIO;
 	}
 
-	if (status & AR_TxOpExceeded)
-		ts->ts_status |= ATH9K_TXERR_XTXOP;
 	ts->ts_rateindex = MS(status, AR_FinalTxIdx);
 	ts->ts_seqnum = MS(status, AR_SeqNum);
 	ts->tid = MS(status, AR_TxTid);
@@ -264,6 +262,8 @@ static int ar9003_hw_proc_txdesc(struct
 	ts->ts_status = 0;
 	ts->ts_flags  = 0;
 
+	if (status & AR_TxOpExceeded)
+		ts->ts_status |= ATH9K_TXERR_XTXOP;
 	status = ACCESS_ONCE(ads->status2);
 	ts->ts_rssi_ctl0 = MS(status, AR_TxRSSIAnt00);
 	ts->ts_rssi_ctl1 = MS(status, AR_TxRSSIAnt01);


