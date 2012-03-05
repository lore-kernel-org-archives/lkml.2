Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2CEXkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:40:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32885 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757790Ab2CEXkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:40:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Remove defaults for volatile registers
Date: Mon,  5 Mar 2012 23:40:14 +0000
Message-Id: <1330990814-11210-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some volatile registers accidentally had defaults added, though there were
no harmful side effects other than increased memory consumption.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-regmap.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index 9f54f6d..f00427d 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -19,7 +19,6 @@
 #include "wm8994.h"
 
 static struct reg_default wm1811_defaults[] = {
-	{ 0x0000, 0x1811 },    /* R0    - Software Reset */
 	{ 0x0001, 0x0000 },    /* R1    - Power Management (1) */
 	{ 0x0002, 0x6000 },    /* R2    - Power Management (2) */
 	{ 0x0003, 0x0000 },    /* R3    - Power Management (3) */
@@ -68,16 +67,12 @@ static struct reg_default wm1811_defaults[] = {
 	{ 0x004C, 0x1F25 },    /* R76   - Charge Pump (1) */
 	{ 0x004D, 0xAB19 },    /* R77   - Charge Pump (2) */
 	{ 0x0051, 0x0004 },    /* R81   - Class W (1) */
-	{ 0x0054, 0x0000 },    /* R84   - DC Servo (1) */
 	{ 0x0055, 0x054A },    /* R85   - DC Servo (2) */
-	{ 0x0058, 0x0000 },    /* R88   - DC Servo Readback */
 	{ 0x0059, 0x0000 },    /* R89   - DC Servo (4) */
 	{ 0x0060, 0x0000 },    /* R96   - Analogue HP (1) */
 	{ 0x00C5, 0x0000 },    /* R197  - Class D Test (5) */
 	{ 0x00D0, 0x7600 },    /* R208  - Mic Detect 1 */
 	{ 0x00D1, 0x007F },    /* R209  - Mic Detect 2 */
-	{ 0x00D2, 0x0000 },    /* R210  - Mic Detect 3 */
-	{ 0x0100, 0x0100 },    /* R256  - Chip Revision */
 	{ 0x0101, 0x8004 },    /* R257  - Control Interface */
 	{ 0x0200, 0x0000 },    /* R512  - AIF1 Clocking (1) */
 	{ 0x0201, 0x0000 },    /* R513  - AIF1 Clocking (2) */
@@ -87,7 +82,6 @@ static struct reg_default wm1811_defaults[] = {
 	{ 0x0209, 0x0000 },    /* R521  - Clocking (2) */
 	{ 0x0210, 0x0083 },    /* R528  - AIF1 Rate */
 	{ 0x0211, 0x0083 },    /* R529  - AIF2 Rate */
-	{ 0x0212, 0x0000 },    /* R530  - Rate Status */
 	{ 0x0220, 0x0000 },    /* R544  - FLL1 Control (1) */
 	{ 0x0221, 0x0000 },    /* R545  - FLL1 Control (2) */
 	{ 0x0222, 0x0000 },    /* R546  - FLL1 Control (3) */
@@ -217,8 +211,6 @@ static struct reg_default wm1811_defaults[] = {
 	{ 0x070A, 0xA101 },    /* R1802 - GPIO 11 */
 	{ 0x0720, 0x0000 },    /* R1824 - Pull Control (1) */
 	{ 0x0721, 0x0156 },    /* R1825 - Pull Control (2) */
-	{ 0x0730, 0x0000 },    /* R1840 - Interrupt Status 1 */
-	{ 0x0731, 0x0000 },    /* R1841 - Interrupt Status 2 */
 	{ 0x0732, 0x0000 },    /* R1842 - Interrupt Raw Status 2 */
 	{ 0x0738, 0x07FF },    /* R1848 - Interrupt Status 1 Mask */
 	{ 0x0739, 0xDFEF },    /* R1849 - Interrupt Status 2 Mask */
@@ -227,7 +219,6 @@ static struct reg_default wm1811_defaults[] = {
 };
 
 static struct reg_default wm8994_defaults[] = {
-	{ 0x0000, 0x8994 },    /* R0     - Software Reset */ 
 	{ 0x0001, 0x0000 },    /* R1     - Power Management (1) */ 
 	{ 0x0002, 0x6000 },    /* R2     - Power Management (2) */ 
 	{ 0x0003, 0x0000 },    /* R3     - Power Management (3) */ 
@@ -274,12 +265,9 @@ static struct reg_default wm8994_defaults[] = {
 	{ 0x003C, 0x0003 },    /* R60    - LDO 2 */ 
 	{ 0x004C, 0x1F25 },    /* R76    - Charge Pump (1) */ 
 	{ 0x0051, 0x0004 },    /* R81    - Class W (1) */ 
-	{ 0x0054, 0x0000 },    /* R84    - DC Servo (1) */ 
 	{ 0x0055, 0x054A },    /* R85    - DC Servo (2) */ 
 	{ 0x0057, 0x0000 },    /* R87    - DC Servo (4) */ 
-	{ 0x0058, 0x0000 },    /* R88    - DC Servo Readback */ 
 	{ 0x0060, 0x0000 },    /* R96    - Analogue HP (1) */ 
-	{ 0x0100, 0x0003 },    /* R256   - Chip Revision */ 
 	{ 0x0101, 0x8004 },    /* R257   - Control Interface */ 
 	{ 0x0110, 0x0000 },    /* R272   - Write Sequencer Ctrl (1) */ 
 	{ 0x0111, 0x0000 },    /* R273   - Write Sequencer Ctrl (2) */ 
@@ -291,7 +279,6 @@ static struct reg_default wm8994_defaults[] = {
 	{ 0x0209, 0x0000 },    /* R521   - Clocking (2) */ 
 	{ 0x0210, 0x0083 },    /* R528   - AIF1 Rate */ 
 	{ 0x0211, 0x0083 },    /* R529   - AIF2 Rate */ 
-	{ 0x0212, 0x0000 },    /* R530   - Rate Status */ 
 	{ 0x0220, 0x0000 },    /* R544   - FLL1 Control (1) */ 
 	{ 0x0221, 0x0000 },    /* R545   - FLL1 Control (2) */ 
 	{ 0x0222, 0x0000 },    /* R546   - FLL1 Control (3) */ 
@@ -444,9 +431,6 @@ static struct reg_default wm8994_defaults[] = {
 	{ 0x070A, 0xA101 },    /* R1802  - GPIO 11 */ 
 	{ 0x0720, 0x0000 },    /* R1824  - Pull Control (1) */ 
 	{ 0x0721, 0x0156 },    /* R1825  - Pull Control (2) */ 
-	{ 0x0730, 0x0000 },    /* R1840  - Interrupt Status 1 */ 
-	{ 0x0731, 0x0000 },    /* R1841  - Interrupt Status 2 */ 
-	{ 0x0732, 0x0000 },    /* R1842  - Interrupt Raw Status 2 */ 
 	{ 0x0738, 0x07FF },    /* R1848  - Interrupt Status 1 Mask */ 
 	{ 0x0739, 0xFFFF },    /* R1849  - Interrupt Status 2 Mask */ 
 	{ 0x0740, 0x0000 },    /* R1856  - Interrupt Control */ 
@@ -454,7 +438,6 @@ static struct reg_default wm8994_defaults[] = {
 };
 
 static struct reg_default wm8958_defaults[] = {
-	{ 0x0000, 0x8958 },    /* R0     - Software Reset */ 
 	{ 0x0001, 0x0000 },    /* R1     - Power Management (1) */
 	{ 0x0002, 0x6000 },    /* R2     - Power Management (2) */
 	{ 0x0003, 0x0000 },    /* R3     - Power Management (3) */
-- 
1.7.9.1

