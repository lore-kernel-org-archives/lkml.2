Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1BYOML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:12:11 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:58394 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1BYOMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:12:08 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>, Rodolfo Giometti <giometti@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCH 1/2] pps: initialize ts_real properly
Date: Fri, 25 Feb 2011 17:11:55 +0300
Message-Id: <1298643116-3488-2-git-send-email-lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110208153129.0f7fe5d3.akpm@linux-foundation.org>
References: <20110208153129.0f7fe5d3.akpm@linux-foundation.org>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize ts_real.flags to fix compiler warning about possible
uninitialized use of this field.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/kapi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index cba1b43..a4e8eb9 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -168,7 +168,7 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 {
 	unsigned long flags;
 	int captured = 0;
-	struct pps_ktime ts_real;
+	struct pps_ktime ts_real = { .sec = 0, .nsec = 0, .flags = 0 };
 
 	/* check event type */
 	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
-- 
1.7.2.3

