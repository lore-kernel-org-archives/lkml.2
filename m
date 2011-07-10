Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1GJXhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 19:37:54 -0400
Received: from gw.minian.org ([83.96.227.91]:54356 "EHLO lab.minian.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756853Ab1GJXhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 19:37:53 -0400
From: Edwin van Vliet <edwin@cheatah.nl>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: alan@linux.intel.com, linux-cris-kernel@axis.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Edwin van Vliet <edwin@cheatah.nl>
Subject: [PATCH] drivers/tty/serial/crisv10: fix double assignment
Date: Mon, 11 Jul 2011 01:37:31 +0200
Message-Id: <1310341051-27057-1-git-send-email-edwin@cheatah.nl>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Struct member dma_in_enabled was assigned twice in a row.

Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
---
 drivers/tty/serial/crisv10.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 225123b..0c55181 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -330,7 +330,6 @@ static struct e100_serial rs_table[] = {
 	  .dma_in_irq_description = "serial 1 dma rec",
 #else
 	  .dma_in_enabled = 0,
-	  .dma_in_enabled = 0,
 	  .dma_in_nbr = UINT_MAX,
 	  .dma_in_irq_nbr = 0,
 	  .dma_in_irq_flags = 0,
-- 
1.7.5.4

