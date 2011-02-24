Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab1BXTgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:36:40 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:57157 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280Ab1BXTgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:36:38 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] Input: bcm5974 - Report button also for zero fingers
Date: Thu, 24 Feb 2011 20:37:44 +0100
Message-Id: <1298576264-1563-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.4.1
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1Psgyn-0005NM-CB.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Psgyn-0005NM-CB c461e51bcafd430d8ac29a419b5f4eeb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current code, pressing the integrated button with an
isolating tool does not result in any button report. Fixed
with this this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Dmitry,

that nobody every complained about this bug is beyond me...

Thanks,
Henrik

 drivers/input/mouse/bcm5974.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index ee82851..0efaf66 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -430,10 +430,6 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 		ptest = int2bound(&c->p, raw_p);
 		origin = raw2int(f->origin);
 
-		/* set the integrated button if applicable */
-		if (c->tp_type == TYPE2)
-			ibt = raw2int(dev->tp_data[BUTTON_TYPE2]);
-
 		/* while tracking finger still valid, count all fingers */
 		if (ptest > PRESSURE_LOW && origin) {
 			abs_p = ptest;
@@ -452,6 +448,10 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 		}
 	}
 
+	/* set the integrated button if applicable */
+	if (c->tp_type == TYPE2)
+		ibt = raw2int(dev->tp_data[BUTTON_TYPE2]);
+
 	if (dev->fingers < nmin)
 		dev->fingers = nmin;
 	if (dev->fingers > nmax)
-- 
1.7.4.1

