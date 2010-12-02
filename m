Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0LBKNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:13:13 -0500
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:21147 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751748Ab0LBKNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:13:12 -0500
Subject: [PATCH 1/3] ath5k: Use EWMA factor of 1024 instead of 1000
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com, j@w1.fi,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com,
        johannes@sipsolutions.net
Date: Thu, 02 Dec 2010 19:12:31 +0900
Message-ID: <20101202101231.22988.33396.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prepares the only place which uses the EWMA library so far for the
performance improved implementation coming up, which requires factor and
weight to be a power of two.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a8d380a..25db9eb 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2536,7 +2536,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	ah->ah_cal_next_full = jiffies;
 	ah->ah_cal_next_ani = jiffies;
 	ah->ah_cal_next_nf = jiffies;
-	ewma_init(&ah->ah_beacon_rssi_avg, 1000, 8);
+	ewma_init(&ah->ah_beacon_rssi_avg, 1024, 8);
 
 	/*
 	 * Change channels and update the h/w rate map if we're switching;

