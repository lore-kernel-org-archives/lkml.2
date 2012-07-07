Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab2GGMF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 08:05:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2GGMF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 08:05:28 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/8] staging/ft1000: fix the no brace needed warning in ft1000_interrupt
Date: Sat,  7 Jul 2012 17:35:12 +0530
Message-Id: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as the if statement encloses only one line braces around it are not
needed.

The following warn fixed,
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index c4a8a0a..0bd080c 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1998,9 +1998,8 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 
     // Make sure we process all interrupt before leaving the ISR due to the edge trigger interrupt type
     while (inttype) {
-	if (inttype & ISR_DOORBELL_PEND) {
-		ft1000_parse_dpram_msg(dev);
-	}
+		if (inttype & ISR_DOORBELL_PEND)
+			ft1000_parse_dpram_msg(dev);
 
 	if (inttype & ISR_RCV) {
 		DEBUG(1, "Data in FIFO\n");
-- 
1.7.9.5

