Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1DJGQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 02:16:16 -0400
Received: from mail-iw0-f194.google.com ([209.85.214.194]:62702 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab1DJGQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 02:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D/XIsednjRo2THusQfHvbGzg/Hi5D2pJVK9ZfGuZ+ja/Zai3Mu3uy9JnluLvX2dd5t
         4q6IePJBDzFl+42qB6tsX5xZPQRCXJDh9qNf5b45kCPnsffNN0KffWDCke7zL7qtULYz
         fm6+d0wBGkC8iNL1kj78OkkzsVua9w0TpvvrA=
From: wanlong.gao@gmail.com
To: hans-christian.egtvedt@atmel.com, chris@zankel.net, steiner@sgi.com,
        tglx@linutronix.de, akpm@linux-foundation.org, hch@lst.de
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 3/3] fix the wrong members of gru_chip
Date: Sun, 10 Apr 2011 14:14:44 +0800
Message-Id: <1302416084-13372-3-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1302416084-13372-1-git-send-email-wanlong.gao@gmail.com>
References: <1302416084-13372-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Fix the wrong members and the wrong function's definition,
since the irq_chip had changed .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/misc/sgi-gru/grufile.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 20e4e93..ecafa4b
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -348,15 +348,15 @@ static unsigned long gru_chiplet_cpu_to_mmr(int chiplet, int cpu, int *corep)
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(struct irq_data *d)
 {
 }
 
 static struct irq_chip gru_chip[GRU_CHIPLETS_PER_BLADE] = {
 	[0 ... GRU_CHIPLETS_PER_BLADE - 1] {
-		.mask		= gru_noop,
-		.unmask		= gru_noop,
-		.ack		= gru_noop
+		.irq_mask	= gru_noop,
+		.irq_unmask	= gru_noop,
+		.irq_ack	= gru_noop
 	}
 };
 
-- 
1.7.3

