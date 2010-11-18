Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab0KRQMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:12:39 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36031 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759323Ab0KRQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:12:34 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv4 11/17] pps: simplify conditions a bit
Date: Thu, 18 Nov 2010 19:01:04 +0300
Message-Id: <f78fed4c9fd5836636f2d307d1ffb808a3c10923.1290087480.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
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
index 54261c4..2bdfbed 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -184,8 +184,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 
 	/* Check the event */
 	pps->current_mode = pps->params.mode;
-	if ((event & PPS_CAPTUREASSERT) &
-			(pps->params.mode & PPS_CAPTUREASSERT)) {
+	if (event & pps->params.mode & PPS_CAPTUREASSERT) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
 			pps_add_offset(&ts_real,
@@ -199,8 +198,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 
 		captured = ~0;
 	}
-	if ((event & PPS_CAPTURECLEAR) &
-			(pps->params.mode & PPS_CAPTURECLEAR)) {
+	if (event & pps->params.mode & PPS_CAPTURECLEAR) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
 			pps_add_offset(&ts_real,
-- 
1.7.2.3

