Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab0GINuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:50:25 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50399 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773Ab0GINuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:50:21 -0400
Date: Fri, 9 Jul 2010 15:50:19 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 08/11] Removing dead ETRAX_SERIAL_PROC_ENTRY
Message-ID: <b098e59cfac4e1c356ec27bc633b97ec98b03a10.1278682303.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ETRAX_SERIAL_PROC_ENTRY doesn't exist in Kconfig, therefore removing
all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/crisv10.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 47f4bf8..eb7967c 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -459,30 +459,8 @@ static struct e100_serial rs_table[] = {
 static struct fast_timer fast_timers[NR_PORTS];
 #endif
 
-#ifdef CONFIG_ETRAX_SERIAL_PROC_ENTRY
-#define PROCSTAT(x) x
-struct ser_statistics_type {
-	int overrun_cnt;
-	int early_errors_cnt;
-	int ser_ints_ok_cnt;
-	int errors_cnt;
-	unsigned long int processing_flip;
-	unsigned long processing_flip_still_room;
-	unsigned long int timeout_flush_cnt;
-	int rx_dma_ints;
-	int tx_dma_ints;
-	int rx_tot;
-	int tx_tot;
-};
-
-static struct ser_statistics_type ser_stat[NR_PORTS];
-
-#else
-
 #define PROCSTAT(x)
 
-#endif /* CONFIG_ETRAX_SERIAL_PROC_ENTRY */
-
 /* RS-485 */
 #if defined(CONFIG_ETRAX_RS485)
 #ifdef CONFIG_ETRAX_FAST_TIMER
-- 
1.7.0.4

