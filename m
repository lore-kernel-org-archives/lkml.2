Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1LBKDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:03:43 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47600 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1LBKDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:03:35 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH 3/3] wl128x: fmdrv_tx: fix signedness bugs
Date: Fri,  2 Dec 2011 05:01:13 -0500
Message-Id: <1322820073-19347-4-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322820073-19347-1-git-send-email-xi.wang@gmail.com>
References: <1322820073-19347-1-git-send-email-xi.wang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error handling with (ret < 0) didn't work where ret is a u32.
Use int instead.  To be consistent we also change the functions to
return an int.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 drivers/media/radio/wl128x/fmdrv_tx.c |   61 +++++++++++++++++----------------
 drivers/media/radio/wl128x/fmdrv_tx.h |   20 +++++-----
 2 files changed, 41 insertions(+), 40 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_tx.c b/drivers/media/radio/wl128x/fmdrv_tx.c
index be54068..6ea33e0 100644
--- a/drivers/media/radio/wl128x/fmdrv_tx.c
+++ b/drivers/media/radio/wl128x/fmdrv_tx.c
@@ -24,10 +24,10 @@
 #include "fmdrv_common.h"
 #include "fmdrv_tx.h"
 
-u32 fm_tx_set_stereo_mono(struct fmdev *fmdev, u16 mode)
+int fm_tx_set_stereo_mono(struct fmdev *fmdev, u16 mode)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (fmdev->tx_data.aud_mode == mode)
 		return 0;
@@ -46,10 +46,10 @@ u32 fm_tx_set_stereo_mono(struct fmdev *fmdev, u16 mode)
 	return ret;
 }
 
-static u32 set_rds_text(struct fmdev *fmdev, u8 *rds_text)
+static int set_rds_text(struct fmdev *fmdev, u8 *rds_text)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	ret = fmc_send_cmd(fmdev, RDS_DATA_SET, REG_WR, rds_text,
 			strlen(rds_text), NULL, NULL);
@@ -66,10 +66,10 @@ static u32 set_rds_text(struct fmdev *fmdev, u8 *rds_text)
 	return 0;
 }
 
-static u32 set_rds_data_mode(struct fmdev *fmdev, u8 mode)
+static int set_rds_data_mode(struct fmdev *fmdev, u8 mode)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	/* Setting unique PI TODO: how unique? */
 	payload = (u16)0xcafe;
@@ -89,10 +89,10 @@ static u32 set_rds_data_mode(struct fmdev *fmdev, u8 mode)
 	return 0;
 }
 
-static u32 set_rds_len(struct fmdev *fmdev, u8 type, u16 len)
+static int set_rds_len(struct fmdev *fmdev, u8 type, u16 len)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	len |= type << 8;
 	payload = len;
@@ -105,10 +105,10 @@ static u32 set_rds_len(struct fmdev *fmdev, u8 type, u16 len)
 	return 0;
 }
 
-u32 fm_tx_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
+int fm_tx_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 	u8 rds_text[] = "Zoom2\n";
 
 	fmdbg("rds_en_dis:%d(E:%d, D:%d)\n", rds_en_dis,
@@ -148,10 +148,10 @@ u32 fm_tx_set_rds_mode(struct fmdev *fmdev, u8 rds_en_dis)
 	return 0;
 }
 
-u32 fm_tx_set_radio_text(struct fmdev *fmdev, u8 *rds_text, u8 rds_type)
+int fm_tx_set_radio_text(struct fmdev *fmdev, u8 *rds_text, u8 rds_type)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_TX)
 		return -EPERM;
@@ -176,10 +176,10 @@ u32 fm_tx_set_radio_text(struct fmdev *fmdev, u8 *rds_text, u8 rds_type)
 	return 0;
 }
 
-u32 fm_tx_set_af(struct fmdev *fmdev, u32 af)
+int fm_tx_set_af(struct fmdev *fmdev, u32 af)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_TX)
 		return -EPERM;
@@ -196,10 +196,10 @@ u32 fm_tx_set_af(struct fmdev *fmdev, u32 af)
 	return 0;
 }
 
-u32 fm_tx_set_region(struct fmdev *fmdev, u8 region)
+int fm_tx_set_region(struct fmdev *fmdev, u8 region)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (region != FM_BAND_EUROPE_US && region != FM_BAND_JAPAN) {
 		fmerr("Invalid band\n");
@@ -216,10 +216,10 @@ u32 fm_tx_set_region(struct fmdev *fmdev, u8 region)
 	return 0;
 }
 
-u32 fm_tx_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
+int fm_tx_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
 {
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	fmdbg("tx: mute mode %d\n", mute_mode_toset);
 
@@ -233,11 +233,11 @@ u32 fm_tx_set_mute_mode(struct fmdev *fmdev, u8 mute_mode_toset)
 }
 
 /* Set TX Audio I/O */
-static u32 set_audio_io(struct fmdev *fmdev)
+static int set_audio_io(struct fmdev *fmdev)
 {
 	struct fmtx_data *tx = &fmdev->tx_data;
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	/* Set Audio I/O Enable */
 	payload = tx->audio_io;
@@ -251,12 +251,12 @@ static u32 set_audio_io(struct fmdev *fmdev)
 }
 
 /* Start TX Transmission */
-static u32 enable_xmit(struct fmdev *fmdev, u8 new_xmit_state)
+static int enable_xmit(struct fmdev *fmdev, u8 new_xmit_state)
 {
 	struct fmtx_data *tx = &fmdev->tx_data;
 	unsigned long timeleft;
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	/* Enable POWER_ENB interrupts */
 	payload = FM_POW_ENB_EVENT;
@@ -289,11 +289,11 @@ static u32 enable_xmit(struct fmdev *fmdev, u8 new_xmit_state)
 }
 
 /* Set TX power level */
-u32 fm_tx_set_pwr_lvl(struct fmdev *fmdev, u8 new_pwr_lvl)
+int fm_tx_set_pwr_lvl(struct fmdev *fmdev, u8 new_pwr_lvl)
 {
 	u16 payload;
 	struct fmtx_data *tx = &fmdev->tx_data;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_TX)
 		return -EPERM;
@@ -328,11 +328,11 @@ u32 fm_tx_set_pwr_lvl(struct fmdev *fmdev, u8 new_pwr_lvl)
  * Sets FM TX pre-emphasis filter value (OFF, 50us, or 75us)
  * Convert V4L2 specified filter values to chip specific filter values.
  */
-u32 fm_tx_set_preemph_filter(struct fmdev *fmdev, u32 preemphasis)
+int fm_tx_set_preemph_filter(struct fmdev *fmdev, u32 preemphasis)
 {
 	struct fmtx_data *tx = &fmdev->tx_data;
 	u16 payload;
-	u32 ret;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_TX)
 		return -EPERM;
@@ -360,10 +360,11 @@ u32 fm_tx_set_preemph_filter(struct fmdev *fmdev, u32 preemphasis)
 }
 
 /* Get the TX tuning capacitor value.*/
-u32 fm_tx_get_tune_cap_val(struct fmdev *fmdev)
+int fm_tx_get_tune_cap_val(struct fmdev *fmdev)
 {
 	u16 curr_val;
-	u32 ret, resp_len;
+	u32 resp_len;
+	int ret;
 
 	if (fmdev->curr_fmmode != FM_MODE_TX)
 		return -EPERM;
@@ -379,11 +380,11 @@ u32 fm_tx_get_tune_cap_val(struct fmdev *fmdev)
 }
 
 /* Set TX Frequency */
-u32 fm_tx_set_freq(struct fmdev *fmdev, u32 freq_to_set)
+int fm_tx_set_freq(struct fmdev *fmdev, u32 freq_to_set)
 {
 	struct fmtx_data *tx = &fmdev->tx_data;
 	u16 payload, chanl_index;
-	u32 ret;
+	int ret;
 
 	if (test_bit(FM_CORE_TX_XMITING, &fmdev->flag)) {
 		enable_xmit(fmdev, 0);
diff --git a/drivers/media/radio/wl128x/fmdrv_tx.h b/drivers/media/radio/wl128x/fmdrv_tx.h
index e393a2b..11ae2e4 100644
--- a/drivers/media/radio/wl128x/fmdrv_tx.h
+++ b/drivers/media/radio/wl128x/fmdrv_tx.h
@@ -22,16 +22,16 @@
 #ifndef _FMDRV_TX_H
 #define _FMDRV_TX_H
 
-u32 fm_tx_set_freq(struct fmdev *, u32);
-u32 fm_tx_set_pwr_lvl(struct fmdev *, u8);
-u32 fm_tx_set_region(struct fmdev *, u8);
-u32 fm_tx_set_mute_mode(struct fmdev *, u8);
-u32 fm_tx_set_stereo_mono(struct fmdev *, u16);
-u32 fm_tx_set_rds_mode(struct fmdev *, u8);
-u32 fm_tx_set_radio_text(struct fmdev *, u8 *, u8);
-u32 fm_tx_set_af(struct fmdev *, u32);
-u32 fm_tx_set_preemph_filter(struct fmdev *, u32);
-u32 fm_tx_get_tune_cap_val(struct fmdev *);
+int fm_tx_set_freq(struct fmdev *, u32);
+int fm_tx_set_pwr_lvl(struct fmdev *, u8);
+int fm_tx_set_region(struct fmdev *, u8);
+int fm_tx_set_mute_mode(struct fmdev *, u8);
+int fm_tx_set_stereo_mono(struct fmdev *, u16);
+int fm_tx_set_rds_mode(struct fmdev *, u8);
+int fm_tx_set_radio_text(struct fmdev *, u8 *, u8);
+int fm_tx_set_af(struct fmdev *, u32);
+int fm_tx_set_preemph_filter(struct fmdev *, u32);
+int fm_tx_get_tune_cap_val(struct fmdev *);
 
 #endif
 
-- 
1.7.5.4

