Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1ABQt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 11:49:58 -0500
Received: from utm.netup.ru ([193.203.36.250]:57767 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1ABQt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 11:49:57 -0500
Message-ID: <4D20AC23.1080609@netup.ru>
Date: Sun, 02 Jan 2011 16:47:31 +0000
From: Abylay Ospan <aospan@netup.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5 v2] stv0367: implement uncorrected blocks counter.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
  drivers/media/dvb/frontends/stv0367.c |   20 +++++++++++++++++++-
  1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0367.c 
b/drivers/media/dvb/frontends/stv0367.c
index b85b9b9..67301a3 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -3327,6 +3327,24 @@ static int stv0367cab_read_snr(struct 
dvb_frontend *fe, u16 *snr)
  	return 0;
  }
  +static int stv0367cab_read_ucblcks(struct dvb_frontend *fe, u32 
*ucblocks)
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
  /*	.read_ber				= stv0367cab_read_ber,*/
  	.read_signal_strength			= stv0367cab_read_strength,
  	.read_snr				= stv0367cab_read_snr,
-/* 	.read_ucblocks				= stv0367cab_read_ucblcks,*/
+	.read_ucblocks				= stv0367cab_read_ucblcks,
  	.get_tune_settings			= stv0367_get_tune_settings,
  };
  -- 1.7.1

