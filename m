Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2KHQpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 11:45:04 -0500
Received: from dupo.coraid.com ([208.71.232.133]:47086 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323Ab2KHQpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 11:45:03 -0500
Message-Id: <1f2ecdb54fd5ea705ce20442f0cba832a3fe70e5.1352316179.git.ecashin@coraid.com>
In-Reply-To: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
References: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 5/8] aoe: manipulate aoedev network stats under lock
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 8 Nov 2012 11:44:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 6ea27fd..9aefbe3 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -603,14 +603,14 @@ rexmit_timer(ulong vp)
 
 	d = (struct aoedev *) vp;
 
+	spin_lock_irqsave(&d->lock, flags);
+
 	/* timeout based on observed timings and variations */
 	timeout = 2 * d->rttavg >> RTTSCALE;
 	timeout += 8 * d->rttdev >> RTTDSCALE;
 	if (timeout == 0)
 		timeout = 1;
 
-	spin_lock_irqsave(&d->lock, flags);
-
 	if (d->flags & DEVFL_TKILL) {
 		spin_unlock_irqrestore(&d->lock, flags);
 		return;
-- 
1.7.1

