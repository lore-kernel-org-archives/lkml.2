Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1AAJea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 04:34:30 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35214 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab1AAJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 04:34:29 -0500
Message-ID: <4d1ef522.cc7e0e0a.6f59.09ec@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Fri, 31 Dec 2010 13:37:00 +0200
Subject: [PATCH 13/18] stv0367: coding style corrections
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/media/dvb/frontends/stv0367.c |   68 ++++++++++++++++----------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index aaa2b44..67301a3 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -784,7 +784,7 @@ int stv0367_writeregs (struct stv0367_state *state, u16 reg, u8 *data, int len)
 
 	ret = i2c_transfer (state->i2c, &msg, 1);
 	if (ret != 1)
-		printk("%s: i2c write error! \n", __func__);
+		printk("%s: i2c write error!\n", __func__);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -818,7 +818,7 @@ static u8 stv0367_readreg (struct stv0367_state *state, u16 reg)
 
 	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2)
-		printk("%s: i2c read error \n", __func__);
+		printk("%s: i2c read error\n", __func__);
 
 	if (i2cdebug) printk("%s: %02x: %02x\n", __func__, reg, b1[0]);
 
@@ -1032,12 +1032,12 @@ static u32 stv0367ter_get_mclk(struct stv0367_state *state, u32 ExtClk_Hz)
 
 		mclk_Hz = ((ExtClk_Hz / 2) * n) / (m * (1 << p));
 
-		printk("N=%d M=%d P=%d mclk_Hz=%d ExtClk_Hz=%d \n",
+		printk("N=%d M=%d P=%d mclk_Hz=%d ExtClk_Hz=%d\n",
 				n, m, p, mclk_Hz, ExtClk_Hz);
 	} else
 		mclk_Hz = ExtClk_Hz;
 
-	printk("%s: mclk_Hz=%d \n", __func__, mclk_Hz);
+	printk("%s: mclk_Hz=%d\n", __func__, mclk_Hz);
 
 	return mclk_Hz;
 }
@@ -1205,7 +1205,7 @@ fe_stv0367_ter_signal_type_t stv0367ter_check_syr(struct stv0367_state *state)
 	else
 		SYRStatus =  FE_TER_SYMBOLOK;
 
-	dprintk("stv0367ter_check_syr SYRStatus %s \n",
+	dprintk("stv0367ter_check_syr SYRStatus %s\n",
 				SYR_var == 0 ? "No Symbol" : "OK");
 
 	return SYRStatus;
@@ -1239,7 +1239,7 @@ fe_stv0367_ter_signal_type_t stv0367ter_check_cpamp(struct stv0367_state *state,
 		break;
 	}
 
-	dprintk("%s: CPAMPMin=%d wd=%d \n", __func__, CPAMPMin, wd);
+	dprintk("%s: CPAMPMin=%d wd=%d\n", __func__, CPAMPMin, wd);
 
 	CPAMPvalue = stv0367_readbits(state, F367TER_PPM_CPAMP_DIRECT);
 	while ((CPAMPvalue < CPAMPMin) && (wd > 0)) {
@@ -1308,8 +1308,8 @@ fe_stv0367_ter_signal_type_t stv0367ter_lock_algo(struct stv0367_state *state)
 
 	tmp  = stv0367_readreg(state, R367TER_SYR_STAT);
 	tmp2 = stv0367_readreg(state, R367TER_STATUS);
-	printk("state=0x%x \n", (int)state);
-	printk("LOCK OK! mode=%d SYR_STAT=0x%x R367TER_STATUS=0x%x \n",
+	printk("state=0x%x\n", (int)state);
+	printk("LOCK OK! mode=%d SYR_STAT=0x%x R367TER_STATUS=0x%x\n",
 							mode, tmp, tmp2);
 
 	tmp  = stv0367_readreg(state, R367TER_PRVIT);
@@ -1317,7 +1317,7 @@ fe_stv0367_ter_signal_type_t stv0367ter_lock_algo(struct stv0367_state *state)
 	printk("PRVIT=0x%x I2CRPT=0x%x\n", tmp, tmp2);
 
 	tmp  = stv0367_readreg(state, R367TER_GAIN_SRC1);
-	printk("GAIN_SRC1=0x%x \n", tmp);
+	printk("GAIN_SRC1=0x%x\n", tmp);
 
 	if ((mode != 0) && (mode != 1) && (mode != 2)) {
 		return FE_TER_SWNOK;
@@ -1436,7 +1436,7 @@ fe_stv0367_ter_signal_type_t stv0367ter_lock_algo(struct stv0367_state *state)
 
 	stv0367_writebits(state, F367TER_SYR_TR_DIS, 1);
 
-	printk("FE_TER_LOCKOK !!! \n");
+	printk("FE_TER_LOCKOK !!!\n");
 
 	return	FE_TER_LOCKOK;
 
@@ -1545,7 +1545,7 @@ int stv0367ter_init(struct dvb_frontend *fe)
 		break;
 	default:
 	case 27000000:
-		printk("FE_STV0367TER_SetCLKgen for 27Mhz \n");
+		printk("FE_STV0367TER_SetCLKgen for 27Mhz\n");
 		stv0367_writereg(state, R367TER_PLLMDIV, 0x1);
 		stv0367_writereg(state, R367TER_PLLNDIV, 0x8);
 		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
@@ -1583,7 +1583,7 @@ static int stv0367ter_algo(struct dvb_frontend *fe,
 	s32 timing_offset = 0;
 	u32 trl_nomrate = 0, InternalFreq = 0, temp = 0;
 
-	dprintk("%s: \n", __func__);
+	dprintk("%s:\n", __func__);
 
 	ter_state->frequency = param->frequency;
 	ter_state->force = FE_TER_FORCENONE
@@ -1591,24 +1591,24 @@ static int stv0367ter_algo(struct dvb_frontend *fe,
 	ter_state->if_iq_mode = state->config->if_iq_mode;
 	switch (state->config->if_iq_mode) {
 	case FE_TER_NORMAL_IF_TUNER:  /* Normal IF mode */
-		printk("ALGO: FE_TER_NORMAL_IF_TUNER selected \n");
+		printk("ALGO: FE_TER_NORMAL_IF_TUNER selected\n");
 		stv0367_writebits(state, F367TER_TUNER_BB, 0);
 		stv0367_writebits(state, F367TER_LONGPATH_IF, 0);
 		stv0367_writebits(state, F367TER_DEMUX_SWAP, 0);
 		break;
 	case FE_TER_LONGPATH_IF_TUNER:  /* Long IF mode */
-		printk("ALGO: FE_TER_LONGPATH_IF_TUNER selected \n");
+		printk("ALGO: FE_TER_LONGPATH_IF_TUNER selected\n");
 		stv0367_writebits(state, F367TER_TUNER_BB, 0);
 		stv0367_writebits(state, F367TER_LONGPATH_IF, 1);
 		stv0367_writebits(state, F367TER_DEMUX_SWAP, 1);
 		break;
 	case FE_TER_IQ_TUNER:  /* IQ mode */
-		printk("ALGO: FE_TER_IQ_TUNER selected \n");
+		printk("ALGO: FE_TER_IQ_TUNER selected\n");
 		stv0367_writebits(state, F367TER_TUNER_BB, 1);
 		stv0367_writebits(state, F367TER_PPM_INVSEL, 0);
 		break;
 	default:
-		printk("ALGO: wrong TUNER type selected \n");
+		printk("ALGO: wrong TUNER type selected\n");
 		return -EINVAL;
 	}
 
@@ -1690,7 +1690,7 @@ static int stv0367ter_algo(struct dvb_frontend *fe,
 		((InternalFreq - state->config->if_khz) * (1 << 16)
 							/ (InternalFreq));
 
-	printk("DEROT temp=0x%x \n", temp);
+	printk("DEROT temp=0x%x\n", temp);
 	stv0367_writebits(state, F367TER_INC_DEROT_HI, temp / 256);
 	stv0367_writebits(state, F367TER_INC_DEROT_LO, temp % 256);
 
@@ -2349,11 +2349,11 @@ static u32 stv0367cab_get_mclk(struct dvb_frontend *fe, u32 ExtClk_Hz)
 			P = 5;
 
 		mclk_Hz = ((ExtClk_Hz / 2) * N) / (M * (1 << P));
-		printk("stv0367cab_get_mclk BYPASS_PLLXN mclk_Hz=%d \n", mclk_Hz);
+		printk("stv0367cab_get_mclk BYPASS_PLLXN mclk_Hz=%d\n", mclk_Hz);
 	} else
 		mclk_Hz = ExtClk_Hz;
 
-	printk("stv0367cab_get_mclk final mclk_Hz=%d \n", mclk_Hz);
+	printk("stv0367cab_get_mclk final mclk_Hz=%d\n", mclk_Hz);
 
 	return mclk_Hz;
 }
@@ -2472,7 +2472,7 @@ static u32 stv0367cab_set_derot_freq(struct stv0367_state *state,
 
 	adc_khz = adc_hz / 1000;
 
-	printk("%s: adc_hz=%d derot_hz=%d \n", __func__, adc_hz, derot_hz);
+	printk("%s: adc_hz=%d derot_hz=%d\n", __func__, adc_hz, derot_hz);
 
 	if (adc_khz != 0) {
 		if (derot_hz < 1000000)
@@ -2488,7 +2488,7 @@ static u32 stv0367cab_set_derot_freq(struct stv0367_state *state,
 	if (sampled_if > 8388607)
 		sampled_if = 8388607;
 
-	printk("%s: sampled_if=0x%x \n", __func__, sampled_if);
+	printk("%s: sampled_if=0x%x\n", __func__, sampled_if);
 
 	stv0367_writereg(state, R367CAB_MIX_NCO_LL, sampled_if);
 	stv0367_writereg(state, R367CAB_MIX_NCO_HL, (sampled_if >> 8));
@@ -2769,7 +2769,7 @@ int stv0367cab_init(struct dvb_frontend *fe)
 
 	switch (state->config->ts_mode) {
 	case STV0367_DVBCI_CLOCK:
-		printk("Setting TSMode = STV0367_DVBCI_CLOCK \n");
+		printk("Setting TSMode = STV0367_DVBCI_CLOCK\n");
 		stv0367_writebits(state, F367CAB_OUTFORMAT, 0x03);
 		break;
 	case STV0367_SERIAL_PUNCT_CLOCK:
@@ -2881,7 +2881,7 @@ fe_stv0367_cab_signal_type_t stv0367cab_algo(struct stv0367_state *state,
 	FECTimeOut = 20;
 	DemodTimeOut = AGCTimeOut + TRLTimeOut + CRLTimeOut + EQLTimeOut;
 
-	printk("%s: DemodTimeOut=%d \n", __func__, DemodTimeOut);
+	printk("%s: DemodTimeOut=%d\n", __func__, DemodTimeOut);
 
 	/* Reset the TRL to ensure nothing starts until the
 	   AGC is stable which ensures a better lock time
@@ -2938,23 +2938,23 @@ fe_stv0367_cab_signal_type_t stv0367cab_algo(struct stv0367_state *state,
 			msleep(10);
 			LockTime += 10;
 		}
-		printk("QAM_Lock=0x%x LockTime=%d \n", QAM_Lock, LockTime);
+		printk("QAM_Lock=0x%x LockTime=%d\n", QAM_Lock, LockTime);
 		tmp = stv0367_readreg(state, R367CAB_IT_STATUS1);
 
-		printk("R367CAB_IT_STATUS1=0x%x \n", tmp);
+		printk("R367CAB_IT_STATUS1=0x%x\n", tmp);
 
 	} while (((QAM_Lock != 0x0c) && (QAM_Lock != 0x0b)) &&
 						(LockTime < DemodTimeOut));
 
-	printk("QAM_Lock=0x%x \n", QAM_Lock);
+	printk("QAM_Lock=0x%x\n", QAM_Lock);
 
 	tmp = stv0367_readreg(state, R367CAB_IT_STATUS1);
-	printk("R367CAB_IT_STATUS1=0x%x \n", tmp);
+	printk("R367CAB_IT_STATUS1=0x%x\n", tmp);
 	tmp = stv0367_readreg(state, R367CAB_IT_STATUS2);
-	printk("R367CAB_IT_STATUS2=0x%x \n", tmp);
+	printk("R367CAB_IT_STATUS2=0x%x\n", tmp);
 
 	tmp  = stv0367cab_get_derot_freq(state, cab_state->adc_clk);
-	printk("stv0367cab_get_derot_freq=0x%x \n", tmp);
+	printk("stv0367cab_get_derot_freq=0x%x\n", tmp);
 
 	if ((QAM_Lock == 0x0c) || (QAM_Lock == 0x0b)) {
 		/* Wait for FEC lock */
@@ -3114,7 +3114,7 @@ static int stv0367cab_get_frontend(struct dvb_frontend *fe,
 
 	stv0367cab_mod_t QAMSize;
 
-	printk("%s: \n", __func__);
+	printk("%s:\n", __func__);
 
 	op->symbol_rate = stv0367cab_GetSymbolRate(state, cab_state->mclk);
 
@@ -3225,14 +3225,14 @@ static int stv0367cab_read_strength(struct dvb_frontend *fe, u16 *strength)
 
 	s32 signal =  stv0367cab_get_rf_lvl(state);
 
-	dprintk ("%s: signal=%d dBm\n", __func__, signal);
+	dprintk("%s: signal=%d dBm\n", __func__, signal);
 
 	if (signal <= -72)
 		*strength = 65535;
 	else
 		*strength = (22 + signal) * (-1311);
 
-	dprintk ("%s: strength=%d\n", __func__, (*strength));
+	dprintk("%s: strength=%d\n", __func__, (*strength));
 
 	return 0;
 }
@@ -3320,7 +3320,7 @@ static int stv0367cab_read_snr(struct dvb_frontend *fe, u16 *snr)
 	else
 		noisepercentage = 0;
 
-	dprintk ("%s: noisepercentage=%d\n", __func__, noisepercentage);
+	dprintk("%s: noisepercentage=%d\n", __func__, noisepercentage);
 
 	*snr = (noisepercentage * 65535) / 100;
 
@@ -3366,7 +3366,7 @@ static struct dvb_frontend_ops stv0367cab_ops = {
 	.set_frontend				= stv0367cab_set_frontend,
 	.get_frontend				= stv0367cab_get_frontend,
 	.read_status				= stv0367cab_read_status,
-/* 	.read_ber				= stv0367cab_read_ber,*/
+/*	.read_ber				= stv0367cab_read_ber,*/
 	.read_signal_strength			= stv0367cab_read_strength,
 	.read_snr				= stv0367cab_read_snr,
 	.read_ucblocks				= stv0367cab_read_ucblcks,
-- 
1.7.1

