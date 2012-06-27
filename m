Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2F0A44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:56:56 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:41542 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F0A4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:56:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1340758614!6915774!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/36] staging: comedi: cb_pcidas: simplify the boardinfo
Date: Tue, 26 Jun 2012 17:56:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261756.44046.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The boardinfo values 'has_ai_trig_gated' and 'has_ai_trig_invert'
are both only set for the "1602" versions of the boards supported
by this driver.

Simplify the boardinfo, and the code, by replacing these two
variables with one "is_1602" variable.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 41 ++++++++++++------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 4b653c5..0c14582 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -250,8 +250,7 @@ struct cb_pcidas_board {
 	const struct comedi_lrange *ranges;
 	enum trimpot_model trimpot;
 	unsigned has_dac08:1;
-	unsigned has_ai_trig_gated:1;	/* Tells if the AI trigger can be gated */
-	unsigned has_ai_trig_invert:1;	/* Tells if the AI trigger can be inverted */
+	unsigned is_1602:1;
 };
 
 static const struct cb_pcidas_board cb_pcidas_boards[] = {
@@ -269,8 +268,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 .ranges = &cb_pcidas_ranges,
 	 .trimpot = AD8402,
 	 .has_dac08 = 1,
-	 .has_ai_trig_gated = 1,
-	 .has_ai_trig_invert = 1,
+	 .is_1602 = 1,
 	 },
 	{
 	 .name = "pci-das1200",
@@ -285,8 +283,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 .ranges = &cb_pcidas_ranges,
 	 .trimpot = AD7376,
 	 .has_dac08 = 0,
-	 .has_ai_trig_gated = 0,
-	 .has_ai_trig_invert = 0,
+	 .is_1602 = 0,
 	 },
 	{
 	 .name = "pci-das1602/12",
@@ -302,8 +299,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 .ranges = &cb_pcidas_ranges,
 	 .trimpot = AD7376,
 	 .has_dac08 = 0,
-	 .has_ai_trig_gated = 1,
-	 .has_ai_trig_invert = 1,
+	 .is_1602 = 1,
 	 },
 	{
 	 .name = "pci-das1200/jr",
@@ -318,8 +314,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 .ranges = &cb_pcidas_ranges,
 	 .trimpot = AD7376,
 	 .has_dac08 = 0,
-	 .has_ai_trig_gated = 0,
-	 .has_ai_trig_invert = 0,
+	 .is_1602 = 0,
 	 },
 	{
 	 .name = "pci-das1602/16/jr",
@@ -334,8 +329,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 .ranges = &cb_pcidas_ranges,
 	 .trimpot = AD8402,
 	 .has_dac08 = 1,
-	 .has_ai_trig_gated = 1,
-	 .has_ai_trig_invert = 1,
+	 .is_1602 = 1,
 	 },
 	{
 	 .name = "pci-das1000",
@@ -350,8 +344,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 .ranges = &cb_pcidas_ranges,
 	 .trimpot = AD7376,
 	 .has_dac08 = 0,
-	 .has_ai_trig_gated = 0,
-	 .has_ai_trig_invert = 0,
+	 .is_1602 = 0,
 	 },
 	{
 	 .name = "pci-das1001",
@@ -366,8 +359,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 .ranges = &cb_pcidas_alt_ranges,
 	 .trimpot = AD7376,
 	 .has_dac08 = 0,
-	 .has_ai_trig_gated = 0,
-	 .has_ai_trig_invert = 0,
+	 .is_1602 = 0,
 	 },
 	{
 	 .name = "pci-das1002",
@@ -382,8 +374,7 @@ static const struct cb_pcidas_board cb_pcidas_boards[] = {
 	 .ranges = &cb_pcidas_ranges,
 	 .trimpot = AD7376,
 	 .has_dac08 = 0,
-	 .has_ai_trig_gated = 0,
-	 .has_ai_trig_invert = 0,
+	 .is_1602 = 0,
 	 },
 };
 
@@ -938,8 +929,7 @@ static int cb_pcidas_ai_cmdtest(struct comedi_device *dev,
 			    ~(CR_FLAGS_MASK & ~(CR_EDGE | CR_INVERT));
 			err++;
 		}
-		if (!thisboard->has_ai_trig_invert &&
-		    (cmd->start_arg & CR_INVERT)) {
+		if (!thisboard->is_1602 && (cmd->start_arg & CR_INVERT)) {
 			cmd->start_arg &= (CR_FLAGS_MASK & ~CR_INVERT);
 			err++;
 		}
@@ -1118,11 +1108,12 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 		bits |= SW_TRIGGER;
 	else if (cmd->start_src == TRIG_EXT) {
 		bits |= EXT_TRIGGER | TGEN | XTRCL;
-		if (thisboard->has_ai_trig_invert
-		    && (cmd->start_arg & CR_INVERT))
-			bits |= TGPOL;
-		if (thisboard->has_ai_trig_gated && (cmd->start_arg & CR_EDGE))
-			bits |= TGSEL;
+		if (thisboard->is_1602) {
+		    	if (cmd->start_arg & CR_INVERT)
+				bits |= TGPOL;
+			if (cmd->start_arg & CR_EDGE)
+				bits |= TGSEL;
+		}
 	} else {
 		comedi_error(dev, "bug!");
 		return -1;
-- 
1.7.11

