Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629Ab1KJILr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:11:47 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:43570 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab1KJIGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:06:12 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: dwmw2@infradead.org, dedekind1@gmail.com, mikedunn@newsguy.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 02/16] mtd/docg3: fix tracing of IO in writeb
Date: Thu, 10 Nov 2011 09:05:28 +0100
Message-Id: <1320912342-30147-3-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writeb was incorrectly traced as a 16 bits write, instead of
a 8 bits write. Fix it by tracing the correct width.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/mtd/devices/docg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 6f5233d..8942a75 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -82,7 +82,7 @@ static inline u16 doc_readw(struct docg3 *docg3, u16 reg)
 static inline void doc_writeb(struct docg3 *docg3, u8 val, u16 reg)
 {
 	writeb(val, docg3->base + reg);
-	trace_docg3_io(1, 16, reg, val);
+	trace_docg3_io(1, 8, reg, val);
 }
 
 static inline void doc_writew(struct docg3 *docg3, u16 val, u16 reg)
-- 
1.7.5.4

