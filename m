Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0GNNVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:21:25 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45183 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756895Ab0GNNVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:21:23 -0400
Date: Wed, 14 Jul 2010 15:21:21 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Olivier Grenie <Olivier.Grenie@dibcom.fr>,
        =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        Tejun Heo <tj@kernel.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 2/4] drivers/media/dvb: Remove undead configs
Message-ID: <4c77b458d7d338c1afbd552db5f9c5d049f4e012.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following CONFIG_ options are set within the C File, so the blocks
will always be selected. For the matter of readability the ifdefs are
not nesseccary:

CONFIG_BAND_CBAND
CONFIG_BAND_UHF
CONFIG_BAND_VHF
CONFIG_DIB0090_USE_PWM_AGC
CONFIG_SYS_ISDBT

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/media/dvb/frontends/dib0090.c |   42 ---------------------------------
 1 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib0090.c b/drivers/media/dvb/frontends/dib0090.c
index c54ce31..007878e 100644
--- a/drivers/media/dvb/frontends/dib0090.c
+++ b/drivers/media/dvb/frontends/dib0090.c
@@ -45,12 +45,6 @@ MODULE_PARM_DESC(debug, "turn on debugging (default: 0)");
 	} \
 } while (0)
 
-#define CONFIG_SYS_ISDBT
-#define CONFIG_BAND_CBAND
-#define CONFIG_BAND_VHF
-#define CONFIG_BAND_UHF
-#define CONFIG_DIB0090_USE_PWM_AGC
-
 #define EN_LNA0      0x8000
 #define EN_LNA1      0x4000
 #define EN_LNA2      0x2000
@@ -576,18 +570,14 @@ void dib0090_pwm_gain_reset(struct dvb_frontend *fe)
 	/* reset the AGC */
 
 	if (state->config->use_pwm_agc) {
-#ifdef CONFIG_BAND_CBAND
 		if (state->current_band == BAND_CBAND) {
 			dib0090_set_rframp_pwm(state, rf_ramp_pwm_cband);
 			dib0090_set_bbramp_pwm(state, bb_ramp_pwm_normal);
 		} else
-#endif
-#ifdef CONFIG_BAND_VHF
 		if (state->current_band == BAND_VHF) {
 			dib0090_set_rframp_pwm(state, rf_ramp_pwm_vhf);
 			dib0090_set_bbramp_pwm(state, bb_ramp_pwm_normal);
 		} else
-#endif
 		{
 			dib0090_set_rframp_pwm(state, rf_ramp_pwm_uhf);
 			dib0090_set_bbramp_pwm(state, bb_ramp_pwm_normal);
@@ -617,18 +607,14 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 		state->agc_freeze = 0;
 		dib0090_write_reg(state, 0x04, 0x0);
 
-#ifdef CONFIG_BAND_VHF
 		if (state->current_band == BAND_VHF) {
 			dib0090_set_rframp(state, rf_ramp_vhf);
 			dib0090_set_bbramp(state, bb_ramp_boost);
 		} else
-#endif
-#ifdef CONFIG_BAND_CBAND
 		if (state->current_band == BAND_CBAND) {
 			dib0090_set_rframp(state, rf_ramp_cband);
 			dib0090_set_bbramp(state, bb_ramp_boost);
 		} else
-#endif
 		{
 			dib0090_set_rframp(state, rf_ramp_uhf);
 			dib0090_set_bbramp(state, bb_ramp_boost);
@@ -655,14 +641,12 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 
 		if (*tune_state == CT_AGC_STEP_0) {
 			if (wbd_error < 0 && state->rf_gain_limit > 0) {
-#ifdef CONFIG_BAND_CBAND
 				/* in case of CBAND tune reduce first the lt_gain2 before adjusting the RF gain */
 				u8 ltg2 = (state->rf_lt_def >> 10) & 0x7;
 				if (state->current_band == BAND_CBAND && ltg2) {
 					ltg2 >>= 1;
 					state->rf_lt_def &= ltg2 << 10;	/* reduce in 3 steps from 7 to 0 */
 				}
-#endif
 			} else {
 				state->agc_step = 0;
 				*tune_state = CT_AGC_STEP_1;
@@ -673,7 +657,6 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 			adc = (adc * ((s32) 355774) + (((s32) 1) << 20)) >> 21;	/* included in [0:-700] */
 
 			adc_error = (s16) (((s32) ADC_TARGET) - adc);
-#ifdef CONFIG_SYS_ISDBT
 			if ((state->fe->dtv_property_cache.delivery_system == SYS_ISDBT) && (((state->fe->dtv_property_cache.layer[0].segment_count >
 											       0)
 											      &&
@@ -700,7 +683,6 @@ int dib0090_gain_control(struct dvb_frontend *fe)
 			    )
 			    )
 				adc_error += 60;
-#endif
 
 			if (*tune_state == CT_AGC_STEP_1) {	/* quickly go to the correct range of the ADC power */
 				if (ABS(adc_error) < 50 || state->agc_step++ > 5) {
@@ -1049,7 +1031,6 @@ static void dib0090_set_bandwidth(struct dib0090_state *state)
 }
 
 static const struct dib0090_pll dib0090_pll_table[] = {
-#ifdef CONFIG_BAND_CBAND
 	{56000, 0, 9, 48, 6},
 	{70000, 1, 9, 48, 6},
 	{87000, 0, 8, 32, 4},
@@ -1057,57 +1038,40 @@ static const struct dib0090_pll dib0090_pll_table[] = {
 	{115000, 0, 7, 24, 6},
 	{140000, 1, 7, 24, 6},
 	{170000, 0, 6, 16, 4},
-#endif
-#ifdef CONFIG_BAND_VHF
 	{200000, 1, 6, 16, 4},
 	{230000, 0, 5, 12, 6},
 	{280000, 1, 5, 12, 6},
 	{340000, 0, 4, 8, 4},
 	{380000, 1, 4, 8, 4},
 	{450000, 0, 3, 6, 6},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{580000, 1, 3, 6, 6},
 	{700000, 0, 2, 4, 4},
 	{860000, 1, 2, 4, 4},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_tuning_table_fm_vhf_on_cband[] = {
-
-#ifdef CONFIG_BAND_CBAND
 	{184000, 4, 1, 15, 0x280, 0x2912, 0xb94e, EN_CAB},
 	{227000, 4, 3, 15, 0x280, 0x2912, 0xb94e, EN_CAB},
 	{380000, 4, 7, 15, 0x280, 0x2912, 0xb94e, EN_CAB},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{520000, 2, 0, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{550000, 2, 2, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{650000, 2, 3, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{750000, 2, 5, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{850000, 2, 6, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{900000, 2, 7, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
-#endif
 };
 
 static const struct dib0090_tuning dib0090_tuning_table[] = {
-
-#ifdef CONFIG_BAND_CBAND
 	{170000, 4, 1, 15, 0x280, 0x2912, 0xb94e, EN_CAB},
-#endif
-#ifdef CONFIG_BAND_VHF
 	{184000, 1, 1, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
 	{227000, 1, 3, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
 	{380000, 1, 7, 15, 0x300, 0x4d12, 0xb94e, EN_VHF},
-#endif
-#ifdef CONFIG_BAND_UHF
 	{520000, 2, 0, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{550000, 2, 2, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{650000, 2, 3, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{750000, 2, 5, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{850000, 2, 6, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
 	{900000, 2, 7, 15, 0x300, 0x1d12, 0xb9ce, EN_UHF},
-#endif
 };
 
 #define WBD     0x781		/* 1 1 1 1 0000 0 0 1 */
@@ -1140,10 +1104,8 @@ static int dib0090_tune(struct dvb_frontend *fe)
 	/* from these are needed :                               */
 	/* Cp,HFdiv,VCOband,SD,Num,Den,FB and REFDiv             */
 
-#ifdef CONFIG_SYS_ISDBT
 	if (state->fe->dtv_property_cache.delivery_system == SYS_ISDBT && state->fe->dtv_property_cache.isdbt_sb_mode == 1)
 		rf += 850;
-#endif
 
 	if (state->current_rf != rf) {
 		state->tuner_is_tuned = 0;
@@ -1241,9 +1203,7 @@ static int dib0090_tune(struct dvb_frontend *fe)
 				lo6 = (lo6 & 0xff9f) | 0x2;
 
 			dib0090_write_reg(state, 0x24, lo6 | EN_LO
-#ifdef CONFIG_DIB0090_USE_PWM_AGC
 					  | state->config->use_pwm_agc * EN_CRYSTAL
-#endif
 			    );
 
 			state->current_rf = rf;
@@ -1319,9 +1279,7 @@ static int dib0090_tune(struct dvb_frontend *fe)
 		c = 4;
 		i = 3;
 		dib0090_write_reg(state, 0x10, (c << 13) | (i << 11) | (WBD
-#ifdef CONFIG_DIB0090_USE_PWM_AGC
 									| (state->config->use_pwm_agc << 1)
-#endif
 				  ));
 		dib0090_write_reg(state, 0x09, (tune->lna_tune << 5) | (tune->lna_bias << 0));
 		dib0090_write_reg(state, 0x0c, tune->v2i);
-- 
1.7.0.4

