Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3AJMUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:20:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41531 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754350Ab3AJMTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:19:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 8/9] mfd: wm5102: Refresh register defaults
Date: Thu, 10 Jan 2013 12:18:51 +0000
Message-Id: <1357820332-14586-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
 <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM5102 register defaults are not up to date with the current register
map, synchronise them with those for current devices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |   95 +++++++++++++++----------------------------
 1 file changed, 33 insertions(+), 62 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 167e6c4..edee1da 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -224,11 +224,9 @@ const struct regmap_irq_chip wm5102_irq = {
 static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000008, 0x0019 },   /* R8     - Ctrl IF SPI CFG 1 */ 
 	{ 0x00000009, 0x0001 },   /* R9     - Ctrl IF I2C1 CFG 1 */ 
-	{ 0x0000000D, 0x0000 },   /* R13    - Ctrl IF Status 1 */ 
 	{ 0x00000016, 0x0000 },   /* R22    - Write Sequencer Ctrl 0 */ 
 	{ 0x00000017, 0x0000 },   /* R23    - Write Sequencer Ctrl 1 */ 
 	{ 0x00000018, 0x0000 },   /* R24    - Write Sequencer Ctrl 2 */ 
-	{ 0x0000001A, 0x0000 },   /* R26    - Write Sequencer PROM */ 
 	{ 0x00000020, 0x0000 },   /* R32    - Tone Generator 1 */ 
 	{ 0x00000021, 0x1000 },   /* R33    - Tone Generator 2 */ 
 	{ 0x00000022, 0x0000 },   /* R34    - Tone Generator 3 */ 
@@ -243,12 +241,14 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000062, 0x01FF },   /* R98    - Sample Rate Sequence Select 2 */ 
 	{ 0x00000063, 0x01FF },   /* R99    - Sample Rate Sequence Select 3 */ 
 	{ 0x00000064, 0x01FF },   /* R100   - Sample Rate Sequence Select 4 */ 
-	{ 0x00000068, 0x01FF },   /* R104   - Always On Triggers Sequence Select 1 */ 
-	{ 0x00000069, 0x01FF },   /* R105   - Always On Triggers Sequence Select 2 */ 
-	{ 0x0000006A, 0x01FF },   /* R106   - Always On Triggers Sequence Select 3 */ 
-	{ 0x0000006B, 0x01FF },   /* R107   - Always On Triggers Sequence Select 4 */ 
-	{ 0x0000006C, 0x01FF },   /* R108   - Always On Triggers Sequence Select 5 */ 
-	{ 0x0000006D, 0x01FF },   /* R109   - Always On Triggers Sequence Select 6 */ 
+	{ 0x00000066, 0x01FF },   /* R102   - Always On Triggers Sequence Select 1 */
+	{ 0x00000067, 0x01FF },   /* R103   - Always On Triggers Sequence Select 2 */
+	{ 0x00000068, 0x01FF },   /* R104   - Always On Triggers Sequence Select 3 */
+	{ 0x00000069, 0x01FF },   /* R105   - Always On Triggers Sequence Select 4 */
+	{ 0x0000006A, 0x01FF },   /* R106   - Always On Triggers Sequence Select 5 */
+	{ 0x0000006B, 0x01FF },   /* R107   - Always On Triggers Sequence Select 6 */
+	{ 0x0000006E, 0x01FF },   /* R110   - Trigger Sequence Select 32 */
+	{ 0x0000006F, 0x01FF },   /* R111   - Trigger Sequence Select 33 */
 	{ 0x00000070, 0x0000 },   /* R112   - Comfort Noise Generator */ 
 	{ 0x00000090, 0x0000 },   /* R144   - Haptics Control 1 */ 
 	{ 0x00000091, 0x7FFF },   /* R145   - Haptics Control 2 */ 
@@ -258,13 +258,14 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000095, 0x0000 },   /* R149   - Haptics phase 2 duration */ 
 	{ 0x00000096, 0x0000 },   /* R150   - Haptics phase 3 intensity */ 
 	{ 0x00000097, 0x0000 },   /* R151   - Haptics phase 3 duration */ 
-	{ 0x00000100, 0x0001 },   /* R256   - Clock 32k 1 */ 
+	{ 0x00000100, 0x0002 },   /* R256   - Clock 32k 1 */
 	{ 0x00000101, 0x0304 },   /* R257   - System Clock 1 */ 
 	{ 0x00000102, 0x0011 },   /* R258   - Sample rate 1 */ 
 	{ 0x00000103, 0x0011 },   /* R259   - Sample rate 2 */ 
 	{ 0x00000104, 0x0011 },   /* R260   - Sample rate 3 */ 
 	{ 0x00000112, 0x0305 },   /* R274   - Async clock 1 */ 
 	{ 0x00000113, 0x0011 },   /* R275   - Async sample rate 1 */ 
+	{ 0x00000114, 0x0011 },   /* R276   - Async sample rate 2 */
 	{ 0x00000149, 0x0000 },   /* R329   - Output system clock */ 
 	{ 0x0000014A, 0x0000 },   /* R330   - Output async clock */ 
 	{ 0x00000152, 0x0000 },   /* R338   - Rate Estimator 1 */ 
@@ -273,13 +274,14 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000155, 0x0000 },   /* R341   - Rate Estimator 4 */ 
 	{ 0x00000156, 0x0000 },   /* R342   - Rate Estimator 5 */ 
 	{ 0x00000161, 0x0000 },   /* R353   - Dynamic Frequency Scaling 1 */ 
-	{ 0x00000171, 0x0000 },   /* R369   - FLL1 Control 1 */ 
+	{ 0x00000171, 0x0002 },   /* R369   - FLL1 Control 1 */
 	{ 0x00000172, 0x0008 },   /* R370   - FLL1 Control 2 */ 
 	{ 0x00000173, 0x0018 },   /* R371   - FLL1 Control 3 */ 
 	{ 0x00000174, 0x007D },   /* R372   - FLL1 Control 4 */ 
 	{ 0x00000175, 0x0004 },   /* R373   - FLL1 Control 5 */ 
 	{ 0x00000176, 0x0000 },   /* R374   - FLL1 Control 6 */ 
 	{ 0x00000177, 0x0181 },   /* R375   - FLL1 Loop Filter Test 1 */ 
+	{ 0x00000178, 0x0000 },   /* R376   - FLL1 NCO Test 0 */
 	{ 0x00000181, 0x0000 },   /* R385   - FLL1 Synchroniser 1 */ 
 	{ 0x00000182, 0x0000 },   /* R386   - FLL1 Synchroniser 2 */ 
 	{ 0x00000183, 0x0000 },   /* R387   - FLL1 Synchroniser 3 */ 
@@ -295,6 +297,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000195, 0x0004 },   /* R405   - FLL2 Control 5 */ 
 	{ 0x00000196, 0x0000 },   /* R406   - FLL2 Control 6 */ 
 	{ 0x00000197, 0x0000 },   /* R407   - FLL2 Loop Filter Test 1 */ 
+	{ 0x00000198, 0x0000 },   /* R408   - FLL2 NCO Test 0 */
 	{ 0x000001A1, 0x0000 },   /* R417   - FLL2 Synchroniser 1 */ 
 	{ 0x000001A2, 0x0000 },   /* R418   - FLL2 Synchroniser 2 */ 
 	{ 0x000001A3, 0x0000 },   /* R419   - FLL2 Synchroniser 3 */ 
@@ -310,8 +313,13 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000218, 0x01A6 },   /* R536   - Mic Bias Ctrl 1 */ 
 	{ 0x00000219, 0x01A6 },   /* R537   - Mic Bias Ctrl 2 */ 
 	{ 0x0000021A, 0x01A6 },   /* R538   - Mic Bias Ctrl 3 */ 
+	{ 0x00000225, 0x0400 },   /* R549   - HP Ctrl 1L */
+	{ 0x00000226, 0x0400 },   /* R550   - HP Ctrl 1R */
 	{ 0x00000293, 0x0000 },   /* R659   - Accessory Detect Mode 1 */ 
 	{ 0x0000029B, 0x0020 },   /* R667   - Headphone Detect 1 */ 
+	{ 0x0000029C, 0x0000 },   /* R668   - Headphone Detect 2 */
+	{ 0x0000029F, 0x0000 },   /* R671   - Headphone Detect Test */
+	{ 0x000002A2, 0x0000 },   /* R674   - Micd Clamp control */
 	{ 0x000002A3, 0x1102 },   /* R675   - Mic Detect 1 */ 
 	{ 0x000002A4, 0x009F },   /* R676   - Mic Detect 2 */ 
 	{ 0x000002A5, 0x0000 },   /* R677   - Mic Detect 3 */ 
@@ -346,53 +354,44 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000400, 0x0000 },   /* R1024  - Output Enables 1 */ 
 	{ 0x00000408, 0x0000 },   /* R1032  - Output Rate 1 */ 
 	{ 0x00000409, 0x0022 },   /* R1033  - Output Volume Ramp */ 
-	{ 0x00000410, 0x0080 },   /* R1040  - Output Path Config 1L */ 
+	{ 0x00000410, 0x4080 },   /* R1040  - Output Path Config 1L */
 	{ 0x00000411, 0x0180 },   /* R1041  - DAC Digital Volume 1L */ 
-	{ 0x00000412, 0x0080 },   /* R1042  - DAC Volume Limit 1L */ 
+	{ 0x00000412, 0x0081 },   /* R1042  - DAC Volume Limit 1L */
 	{ 0x00000413, 0x0001 },   /* R1043  - Noise Gate Select 1L */ 
 	{ 0x00000414, 0x0080 },   /* R1044  - Output Path Config 1R */ 
 	{ 0x00000415, 0x0180 },   /* R1045  - DAC Digital Volume 1R */ 
-	{ 0x00000416, 0x0080 },   /* R1046  - DAC Volume Limit 1R */ 
+	{ 0x00000416, 0x0081 },   /* R1046  - DAC Volume Limit 1R */
 	{ 0x00000417, 0x0002 },   /* R1047  - Noise Gate Select 1R */ 
-	{ 0x00000418, 0x0080 },   /* R1048  - Output Path Config 2L */ 
+	{ 0x00000418, 0x4080 },   /* R1048  - Output Path Config 2L */
 	{ 0x00000419, 0x0180 },   /* R1049  - DAC Digital Volume 2L */ 
-	{ 0x0000041A, 0x0080 },   /* R1050  - DAC Volume Limit 2L */ 
+	{ 0x0000041A, 0x0081 },   /* R1050  - DAC Volume Limit 2L */
 	{ 0x0000041B, 0x0004 },   /* R1051  - Noise Gate Select 2L */ 
 	{ 0x0000041C, 0x0080 },   /* R1052  - Output Path Config 2R */ 
 	{ 0x0000041D, 0x0180 },   /* R1053  - DAC Digital Volume 2R */ 
-	{ 0x0000041E, 0x0080 },   /* R1054  - DAC Volume Limit 2R */ 
+	{ 0x0000041E, 0x0081 },   /* R1054  - DAC Volume Limit 2R */
 	{ 0x0000041F, 0x0008 },   /* R1055  - Noise Gate Select 2R */ 
-	{ 0x00000420, 0x0080 },   /* R1056  - Output Path Config 3L */ 
+	{ 0x00000420, 0x4080 },   /* R1056  - Output Path Config 3L */
 	{ 0x00000421, 0x0180 },   /* R1057  - DAC Digital Volume 3L */ 
-	{ 0x00000422, 0x0080 },   /* R1058  - DAC Volume Limit 3L */ 
+	{ 0x00000422, 0x0081 },   /* R1058  - DAC Volume Limit 3L */
 	{ 0x00000423, 0x0010 },   /* R1059  - Noise Gate Select 3L */ 
-	{ 0x00000424, 0x0080 },   /* R1060  - Output Path Config 3R */ 
-	{ 0x00000425, 0x0180 },   /* R1061  - DAC Digital Volume 3R */ 
-	{ 0x00000426, 0x0080 },   /* R1062  - DAC Volume Limit 3R */ 
-	{ 0x00000428, 0x0000 },   /* R1064  - Output Path Config 4L */ 
+	{ 0x00000428, 0xC000 },   /* R1064  - Output Path Config 4L */
 	{ 0x00000429, 0x0180 },   /* R1065  - DAC Digital Volume 4L */ 
-	{ 0x0000042A, 0x0080 },   /* R1066  - Out Volume 4L */ 
+	{ 0x0000042A, 0x0081 },   /* R1066  - Out Volume 4L */
 	{ 0x0000042B, 0x0040 },   /* R1067  - Noise Gate Select 4L */ 
-	{ 0x0000042C, 0x0000 },   /* R1068  - Output Path Config 4R */ 
 	{ 0x0000042D, 0x0180 },   /* R1069  - DAC Digital Volume 4R */ 
-	{ 0x0000042E, 0x0080 },   /* R1070  - Out Volume 4R */ 
+	{ 0x0000042E, 0x0081 },   /* R1070  - Out Volume 4R */
 	{ 0x0000042F, 0x0080 },   /* R1071  - Noise Gate Select 4R */ 
 	{ 0x00000430, 0x0000 },   /* R1072  - Output Path Config 5L */ 
 	{ 0x00000431, 0x0180 },   /* R1073  - DAC Digital Volume 5L */ 
-	{ 0x00000432, 0x0080 },   /* R1074  - DAC Volume Limit 5L */ 
+	{ 0x00000432, 0x0081 },   /* R1074  - DAC Volume Limit 5L */
 	{ 0x00000433, 0x0100 },   /* R1075  - Noise Gate Select 5L */ 
-	{ 0x00000434, 0x0000 },   /* R1076  - Output Path Config 5R */ 
 	{ 0x00000435, 0x0180 },   /* R1077  - DAC Digital Volume 5R */ 
-	{ 0x00000436, 0x0080 },   /* R1078  - DAC Volume Limit 5R */ 
-	{ 0x00000437, 0x0200 },   /* R1079  - Noise Gate Select 5R */ 
+	{ 0x00000436, 0x0081 },   /* R1078  - DAC Volume Limit 5R */
+	{ 0x00000437, 0x0200 },   /* R1079  - Noise Gate Select 5R */
 	{ 0x00000450, 0x0000 },   /* R1104  - DAC AEC Control 1 */ 
 	{ 0x00000458, 0x0001 },   /* R1112  - Noise Gate Control */ 
 	{ 0x00000490, 0x0069 },   /* R1168  - PDM SPK1 CTRL 1 */ 
 	{ 0x00000491, 0x0000 },   /* R1169  - PDM SPK1 CTRL 2 */ 
-	{ 0x000004DC, 0x0000 },   /* R1244  - DAC comp 1 */ 
-	{ 0x000004DD, 0x0000 },   /* R1245  - DAC comp 2 */ 
-	{ 0x000004DE, 0x0000 },   /* R1246  - DAC comp 3 */ 
-	{ 0x000004DF, 0x0000 },   /* R1247  - DAC comp 4 */ 
 	{ 0x00000500, 0x000C },   /* R1280  - AIF1 BCLK Ctrl */ 
 	{ 0x00000501, 0x0008 },   /* R1281  - AIF1 Tx Pin Ctrl */ 
 	{ 0x00000502, 0x0000 },   /* R1282  - AIF1 Rx Pin Ctrl */ 
@@ -420,7 +419,6 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000518, 0x0007 },   /* R1304  - AIF1 Frame Ctrl 18 */ 
 	{ 0x00000519, 0x0000 },   /* R1305  - AIF1 Tx Enables */ 
 	{ 0x0000051A, 0x0000 },   /* R1306  - AIF1 Rx Enables */ 
-	{ 0x0000051B, 0x0000 },   /* R1307  - AIF1 Force Write */ 
 	{ 0x00000540, 0x000C },   /* R1344  - AIF2 BCLK Ctrl */ 
 	{ 0x00000541, 0x0008 },   /* R1345  - AIF2 Tx Pin Ctrl */ 
 	{ 0x00000542, 0x0000 },   /* R1346  - AIF2 Rx Pin Ctrl */ 
@@ -436,7 +434,6 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000552, 0x0001 },   /* R1362  - AIF2 Frame Ctrl 12 */ 
 	{ 0x00000559, 0x0000 },   /* R1369  - AIF2 Tx Enables */ 
 	{ 0x0000055A, 0x0000 },   /* R1370  - AIF2 Rx Enables */ 
-	{ 0x0000055B, 0x0000 },   /* R1371  - AIF2 Force Write */ 
 	{ 0x00000580, 0x000C },   /* R1408  - AIF3 BCLK Ctrl */ 
 	{ 0x00000581, 0x0008 },   /* R1409  - AIF3 Tx Pin Ctrl */ 
 	{ 0x00000582, 0x0000 },   /* R1410  - AIF3 Rx Pin Ctrl */ 
@@ -452,7 +449,6 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000592, 0x0001 },   /* R1426  - AIF3 Frame Ctrl 12 */ 
 	{ 0x00000599, 0x0000 },   /* R1433  - AIF3 Tx Enables */ 
 	{ 0x0000059A, 0x0000 },   /* R1434  - AIF3 Rx Enables */ 
-	{ 0x0000059B, 0x0000 },   /* R1435  - AIF3 Force Write */ 
 	{ 0x000005E3, 0x0004 },   /* R1507  - SLIMbus Framer Ref Gear */ 
 	{ 0x000005E5, 0x0000 },   /* R1509  - SLIMbus Rates 1 */ 
 	{ 0x000005E6, 0x0000 },   /* R1510  - SLIMbus Rates 2 */ 
@@ -776,22 +772,6 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x000008CD, 0x0080 },   /* R2253  - DRC1RMIX Input 3 Volume */ 
 	{ 0x000008CE, 0x0000 },   /* R2254  - DRC1RMIX Input 4 Source */ 
 	{ 0x000008CF, 0x0080 },   /* R2255  - DRC1RMIX Input 4 Volume */ 
-	{ 0x000008D0, 0x0000 },   /* R2256  - DRC2LMIX Input 1 Source */ 
-	{ 0x000008D1, 0x0080 },   /* R2257  - DRC2LMIX Input 1 Volume */ 
-	{ 0x000008D2, 0x0000 },   /* R2258  - DRC2LMIX Input 2 Source */ 
-	{ 0x000008D3, 0x0080 },   /* R2259  - DRC2LMIX Input 2 Volume */ 
-	{ 0x000008D4, 0x0000 },   /* R2260  - DRC2LMIX Input 3 Source */ 
-	{ 0x000008D5, 0x0080 },   /* R2261  - DRC2LMIX Input 3 Volume */ 
-	{ 0x000008D6, 0x0000 },   /* R2262  - DRC2LMIX Input 4 Source */ 
-	{ 0x000008D7, 0x0080 },   /* R2263  - DRC2LMIX Input 4 Volume */ 
-	{ 0x000008D8, 0x0000 },   /* R2264  - DRC2RMIX Input 1 Source */ 
-	{ 0x000008D9, 0x0080 },   /* R2265  - DRC2RMIX Input 1 Volume */ 
-	{ 0x000008DA, 0x0000 },   /* R2266  - DRC2RMIX Input 2 Source */ 
-	{ 0x000008DB, 0x0080 },   /* R2267  - DRC2RMIX Input 2 Volume */ 
-	{ 0x000008DC, 0x0000 },   /* R2268  - DRC2RMIX Input 3 Source */ 
-	{ 0x000008DD, 0x0080 },   /* R2269  - DRC2RMIX Input 3 Volume */ 
-	{ 0x000008DE, 0x0000 },   /* R2270  - DRC2RMIX Input 4 Source */ 
-	{ 0x000008DF, 0x0080 },   /* R2271  - DRC2RMIX Input 4 Volume */ 
 	{ 0x00000900, 0x0000 },   /* R2304  - HPLP1MIX Input 1 Source */ 
 	{ 0x00000901, 0x0080 },   /* R2305  - HPLP1MIX Input 1 Volume */ 
 	{ 0x00000902, 0x0000 },   /* R2306  - HPLP1MIX Input 2 Source */ 
@@ -883,7 +863,7 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000D1B, 0xFFFF },   /* R3355  - IRQ2 Status 4 Mask */ 
 	{ 0x00000D1C, 0xFFFF },   /* R3356  - IRQ2 Status 5 Mask */ 
 	{ 0x00000D1F, 0x0000 },   /* R3359  - IRQ2 Control */ 
-	{ 0x00000D41, 0x0000 },   /* R3393  - ADSP2 IRQ0 */ 
+	{ 0x00000D50, 0x0000 },   /* R3408  - AOD wkup and trig */
 	{ 0x00000D53, 0xFFFF },   /* R3411  - AOD IRQ Mask IRQ1 */ 
 	{ 0x00000D54, 0xFFFF },   /* R3412  - AOD IRQ Mask IRQ2 */ 
 	{ 0x00000D56, 0x0000 },   /* R3414  - Jack detect debounce */ 
@@ -978,11 +958,6 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000E82, 0x0018 },   /* R3714  - DRC1 ctrl3 */ 
 	{ 0x00000E83, 0x0000 },   /* R3715  - DRC1 ctrl4 */ 
 	{ 0x00000E84, 0x0000 },   /* R3716  - DRC1 ctrl5 */ 
-	{ 0x00000E89, 0x0018 },   /* R3721  - DRC2 ctrl1 */ 
-	{ 0x00000E8A, 0x0933 },   /* R3722  - DRC2 ctrl2 */ 
-	{ 0x00000E8B, 0x0018 },   /* R3723  - DRC2 ctrl3 */ 
-	{ 0x00000E8C, 0x0000 },   /* R3724  - DRC2 ctrl4 */ 
-	{ 0x00000E8D, 0x0000 },   /* R3725  - DRC2 ctrl5 */ 
 	{ 0x00000EC0, 0x0000 },   /* R3776  - HPLPF1_1 */ 
 	{ 0x00000EC1, 0x0000 },   /* R3777  - HPLPF1_2 */ 
 	{ 0x00000EC4, 0x0000 },   /* R3780  - HPLPF2_1 */ 
@@ -993,16 +968,12 @@ static const struct reg_default wm5102_reg_default[] = {
 	{ 0x00000ECD, 0x0000 },   /* R3789  - HPLPF4_2 */ 
 	{ 0x00000EE0, 0x0000 },   /* R3808  - ASRC_ENABLE */ 
 	{ 0x00000EE2, 0x0000 },   /* R3810  - ASRC_RATE1 */ 
-	{ 0x00000EE3, 0x4000 },   /* R3811  - ASRC_RATE2 */ 
 	{ 0x00000EF0, 0x0000 },   /* R3824  - ISRC 1 CTRL 1 */ 
 	{ 0x00000EF1, 0x0000 },   /* R3825  - ISRC 1 CTRL 2 */ 
 	{ 0x00000EF2, 0x0000 },   /* R3826  - ISRC 1 CTRL 3 */ 
 	{ 0x00000EF3, 0x0000 },   /* R3827  - ISRC 2 CTRL 1 */ 
 	{ 0x00000EF4, 0x0000 },   /* R3828  - ISRC 2 CTRL 2 */ 
 	{ 0x00000EF5, 0x0000 },   /* R3829  - ISRC 2 CTRL 3 */ 
-	{ 0x00000EF6, 0x0000 },   /* R3830  - ISRC 3 CTRL 1 */ 
-	{ 0x00000EF7, 0x0000 },   /* R3831  - ISRC 3 CTRL 2 */ 
-	{ 0x00000EF8, 0x0000 },   /* R3832  - ISRC 3 CTRL 3 */ 
 	{ 0x00001100, 0x0010 },   /* R4352  - DSP1 Control 1 */ 
 	{ 0x00001101, 0x0000 },   /* R4353  - DSP1 Clocking 1 */ 
 };
-- 
1.7.10.4

