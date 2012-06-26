Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2FZAWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:22:23 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:3245 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab2FZAWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:22:22 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-132.messagelabs.com!1340670141!12492441!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 31/33] staging: comedi: cb_das16_cs: use the BIP_RANGE helper macro
Date: Mon, 25 Jun 2012 17:22:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251722.18665.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BIP_RANGE(a) macro can be used instead of the RANGE(a,b)
macro when -a == b. And it's a bit clearer that this is a bipolar
range.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 68e6436..0d303d1 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -90,12 +90,13 @@ struct das16cs_private {
 
 static struct pcmcia_device *cur_dev;
 
-static const struct comedi_lrange das16cs_ai_range = { 4, {
-							   RANGE(-10, 10),
-							   RANGE(-5, 5),
-							   RANGE(-2.5, 2.5),
-							   RANGE(-1.25, 1.25),
-							   }
+static const struct comedi_lrange das16cs_ai_range = {
+	4, {
+		BIP_RANGE(10),
+		BIP_RANGE(5),
+		BIP_RANGE(2.5),
+		BIP_RANGE(1.25),
+	}
 };
 
 static irqreturn_t das16cs_interrupt(int irq, void *d)
-- 
1.7.11

