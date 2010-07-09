Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0GINuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:50:12 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50378 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776Ab0GINuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:50:09 -0400
Date: Fri, 9 Jul 2010 15:50:07 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 07/11] Removing dead ETRAX_EXTERN_PB6CLK_ENABLED
Message-ID: <af65ef6805cbc23a705a28b41dceb720c6133560.1278682303.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ETRAX_EXTERN_PB6CLK_ENABLED doesn't exist in Kconfig, therefore
removing all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/crisv10.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 84e5357..47f4bf8 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -2981,19 +2981,6 @@ change_speed(struct e100_serial *info)
 			*R_SERIAL_PRESCALE = divisor;
 			info->baud = SERIAL_PRESCALE_BASE/divisor;
 		}
-#ifdef CONFIG_ETRAX_EXTERN_PB6CLK_ENABLED
-		else if ((info->baud_base==CONFIG_ETRAX_EXTERN_PB6CLK_FREQ/8 &&
-			  info->custom_divisor == 1) ||
-			 (info->baud_base==CONFIG_ETRAX_EXTERN_PB6CLK_FREQ &&
-			  info->custom_divisor == 8)) {
-				/* ext_clk selected */
-				alt_source =
-					IO_STATE(R_ALT_SER_BAUDRATE, ser0_rec, extern) |
-					IO_STATE(R_ALT_SER_BAUDRATE, ser0_tr, extern);
-				DBAUD(printk("using external baudrate: %lu\n", CONFIG_ETRAX_EXTERN_PB6CLK_FREQ/8));
-				info->baud = CONFIG_ETRAX_EXTERN_PB6CLK_FREQ/8;
-			}
-#endif
 		else
 		{
 			/* Bad baudbase, we don't support using timer0
-- 
1.7.0.4

