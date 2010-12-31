Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1AAJeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 04:34:13 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58205 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1AAJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 04:34:12 -0500
Message-ID: <4d1ef512.857a0e0a.45e5.0be6@mx.google.com>
From: Abylay Ospan <liplianin@me.by>
Date: Fri, 31 Dec 2010 13:37:00 +0200
Subject: [PATCH 12/18] stv0367: implement uncorrected blocks counter.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb/frontends/stv0367.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index 9439388..aaa2b44 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -3327,6 +3327,24 @@ static int stv0367cab_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 }
 
+static int stv0367cab_read_ucblcks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct stv0367_state *state = fe->demodulator_priv;
+	int corrected, tscount;
+
+	*ucblocks = (stv0367_readreg(state, R367CAB_RS_COUNTER_5) << 8)
+			| stv0367_readreg(state, R367CAB_RS_COUNTER_4);
+	corrected = (stv0367_readreg(state, R367CAB_RS_COUNTER_3) << 8)
+			| stv0367_readreg(state, R367CAB_RS_COUNTER_2);
+	tscount = (stv0367_readreg(state, R367CAB_RS_COUNTER_2) << 8)
+			| stv0367_readreg(state, R367CAB_RS_COUNTER_1);
+
+	dprintk("%s: uncorrected blocks=%d corrected blocks=%d tscount=%d\n",
+				__func__, *ucblocks, corrected, tscount);
+
+	return 0;
+};
+
 static struct dvb_frontend_ops stv0367cab_ops = {
 	.info = {
 		.name = "ST STV0367 DVB-C",
@@ -3351,7 +3369,7 @@ static struct dvb_frontend_ops stv0367cab_ops = {
 /* 	.read_ber				= stv0367cab_read_ber,*/
 	.read_signal_strength			= stv0367cab_read_strength,
 	.read_snr				= stv0367cab_read_snr,
-/* 	.read_ucblocks				= stv0367cab_read_ucblcks,*/
+	.read_ucblocks				= stv0367cab_read_ucblcks,
 	.get_tune_settings			= stv0367_get_tune_settings,
 };
 
-- 
1.7.1

