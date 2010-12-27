Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0L0QZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 11:25:07 -0500
Received: from srv010071.webreus.nl ([212.61.10.71]:35395 "EHLO
	srv010071.webreus.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0L0QZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 11:25:06 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Dec 2010 11:25:05 EST
Date: Mon, 27 Dec 2010 17:18:22 +0100
From: Michel Roelofs <michel@michelroelofs.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] LinuxPPS: Fix nanoseconds field in timestamp debug output
Message-ID: <20101227161821.GA21789@ster.michelroelofs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the debug output print at least nine digits for the
nanoseconds field, instead of at least six.

Signed-off-by: Michel Roelofs <michel@michelroelofs.nl>
Acked-by: Rodolfo Giometti <giometti@linux.it>
---
    drivers/pps/kapi.c |    2 +-
    1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 1aa02db..b0e347c 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -284,7 +284,7 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
    	if (!pps)
    		return;
    
-	pr_debug("PPS event on source %d at %llu.%06u\n",
+	pr_debug("PPS event on source %d at %llu.%09u\n",
    			pps->id, (unsigned long long) ts->sec, ts->nsec);
    
    	spin_lock_irqsave(&pps->lock, flags);
-- 
1.7.0.4
