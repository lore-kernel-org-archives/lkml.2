Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2IMKbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:31:44 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:63674 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab2IMKbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:31:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwCAMO0UVBbdWObgWdsb2JhbABFhUC2MCIBARYmJ4IhAQUnUhBRVwYTiBG8HZFHA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,416,1344204000"; 
   d="scan'208";a="951021180"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH v2 4/5] Staging: ipack/devices/ipoctal: acknowledge BREAK condition.
Date: Thu, 13 Sep 2012 12:32:22 +0200
Message-Id: <1347532343-22948-4-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347532343-22948-1-git-send-email-siglesias@igalia.com>
References: <1347532343-22948-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear the BREAK flag from the ISR register. Doing that, we avoid to read
the same condition for the next character received.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 9fc2f7f..164e43c 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -158,6 +158,7 @@ static void ipoctal_irq_rx(struct ipoctal_channel *channel,
 				flag = TTY_FRAME;
 			}
 			if (sr & SR_RECEIVED_BREAK) {
+				iowrite8(CR_CMD_RESET_BREAK_CHANGE, &channel->regs->w.cr);
 				channel->stats.rcv_break++;
 				flag = TTY_BREAK;
 			}
-- 
1.7.10.4

