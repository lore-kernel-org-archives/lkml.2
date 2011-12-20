Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1LTDa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:30:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36899 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab1LTDax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:30:53 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, zefir.kurtisi@neratec.com,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Joe Perches <joe@perches.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] ath9k: fix roadkill due to Joe's patch on ath_dbg() changes
Date: Mon, 19 Dec 2011 19:30:43 -0800
Message-Id: <1324351843-4115-1-git-send-email-rodrigue@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Joe changed ath_dbg() to simpify code but while his patch was
being merged dfs.c was born and as such did not get the change
Joe envisioned. This fixes that. Test compiled with:

 make allmodconfig

Cc: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: John W. Linville <linville@tuxdriver.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/dfs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index e4e84a9..f4f56af 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -66,7 +66,7 @@ ath9k_postprocess_radar_event(struct ath_softc *sc,
 	u8 rssi;
 	u16 dur;
 
-	ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_DFS,
+	ath_dbg(ath9k_hw_common(sc->sc_ah), DFS,
 		"pulse_bw_info=0x%x, pri,ext len/rssi=(%u/%u, %u/%u)\n",
 		are->pulse_bw_info,
 		are->pulse_length_pri, are->rssi,
@@ -161,7 +161,7 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 
 	if ((!(rs->rs_phyerr != ATH9K_PHYERR_RADAR)) &&
 	    (!(rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT))) {
-		ath_dbg(common, ATH_DBG_DFS,
+		ath_dbg(common, DFS,
 			"Error: rs_phyer=0x%x not a radar error\n",
 			rs->rs_phyerr);
 		return;
@@ -190,7 +190,7 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	ard.pulse_length_ext = vdata_end[-2];
 	ard.pulse_length_pri = vdata_end[-3];
 
-	ath_dbg(common, ATH_DBG_DFS,
+	ath_dbg(common, DFS,
 		"bw_info=%d, length_pri=%d, length_ext=%d, "
 		"rssi_pri=%d, rssi_ext=%d\n",
 		ard.pulse_bw_info, ard.pulse_length_pri, ard.pulse_length_ext,
@@ -200,7 +200,7 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 	drp.ts = mactime;
 	if (ath9k_postprocess_radar_event(sc, &ard, &drp)) {
 		static u64 last_ts;
-		ath_dbg(common, ATH_DBG_DFS,
+		ath_dbg(common, DFS,
 			"ath9k_dfs_process_phyerr: channel=%d, ts=%llu, "
 			"width=%d, rssi=%d, delta_ts=%llu\n",
 			drp.freq, drp.ts, drp.width, drp.rssi, drp.ts-last_ts);
-- 
1.7.4.15.g7811d

