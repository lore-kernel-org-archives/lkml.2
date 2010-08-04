Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab0HDVTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:19:00 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57582 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759004Ab0HDVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:18:55 -0400
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv3 11/16] pps: simplify conditions a bit
Date: Thu,  5 Aug 2010 01:06:48 +0400
Message-Id: <3eb2789176f3d6f25373b31c82ed2d2a1bc84e09.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bitwise conjunction is distributive so we can simplify some conditions.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/kapi.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 220ab08..0335b2c 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -180,8 +180,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 
 	/* Check the event */
 	pps->current_mode = pps->params.mode;
-	if ((event & PPS_CAPTUREASSERT) &
-			(pps->params.mode & PPS_CAPTUREASSERT)) {
+	if (event & pps->params.mode & PPS_CAPTUREASSERT) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
 			pps_add_offset(&ts_real,
@@ -195,8 +194,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 
 		captured = ~0;
 	}
-	if ((event & PPS_CAPTURECLEAR) &
-			(pps->params.mode & PPS_CAPTURECLEAR)) {
+	if (event & pps->params.mode & PPS_CAPTURECLEAR) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
 			pps_add_offset(&ts_real,
-- 
1.7.1

