Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab0JGSp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:45:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63818 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JGSpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=uM+OYxpAy0OD7k1K1ij5w+oP5kPc6kBJw3UROzSAp867dhSyQH4Aq7fVZboQxOR7yr
         bcqZhQYQ5Q11UzBsObSTSXHCoveefZtcLR3hzatDCMAc+p6sGHXggxD2ze5iqr8/w/AJ
         lD2jpHirwSLeqXPbM2voe3Oo47wqPmL8ekuVI=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com, tsanghan@gmail.com,
        u.kleine-koenig@pengutronix.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] Staging: comedi: file: Removed braces from some statement blocks
Date: Thu,  7 Oct 2010 19:45:38 +0100
Message-Id: <1286477138-2446-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unnecessary braces in some statement blocks

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 7600431..81f1c87 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -1576,12 +1576,12 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 
 	/* use sample&hold signal? */
-	if (cmd->convert_src == TRIG_NOW) {
+	if (cmd->convert_src == TRIG_NOW)
 		devpriv->usessh = 1;
-	} /* yes */
-	else {
+	/* yes */
+	else
 		devpriv->usessh = 0;
-	}			/*  no */
+				/*  no */
 
 	DPRINTK("1 neverending=%d scans=%u usessh=%d ai_startstop=0x%2x\n",
 		devpriv->ai_neverending, devpriv->ai_scans, devpriv->usessh,
@@ -1598,9 +1598,8 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->usedma = 1;
 		if ((cmd->flags & TRIG_WAKE_EOS) &&
 		    (devpriv->ai_n_scanlen == 1)) {
-			if (cmd->convert_src == TRIG_NOW) {
+			if (cmd->convert_src == TRIG_NOW)
 				devpriv->ai_add_back = 1;
-			}
 			if (cmd->convert_src == TRIG_TIMER) {
 				devpriv->usedma = 0;
 					/*
@@ -1695,11 +1694,10 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		(cmd->scan_begin_src == TRIG_INT)) &&
 		(cmd->convert_src == TRIG_TIMER)) {
 					/* both timer is used for one time */
-		if (cmd->scan_begin_src == TRIG_EXT) {
+		if (cmd->scan_begin_src == TRIG_EXT)
 			devpriv->ai_do = 4;
-		} else {
+		else
 			devpriv->ai_do = 1;
-		}
 		pci9118_calc_divisors(devpriv->ai_do, dev, s,
 				      &cmd->scan_begin_arg, &cmd->convert_arg,
 				      devpriv->ai_flags,
@@ -2213,11 +2211,10 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
-	if (it->options[3] & 1) {
+	if (it->options[3] & 1)
 		master = 0;	/* user don't want use bus master */
-	} else {
+	else
 		master = 1;
-	}
 
 	ret = alloc_private(dev, sizeof(struct pci9118_private));
 	if (ret < 0) {
-- 
1.7.0.4

