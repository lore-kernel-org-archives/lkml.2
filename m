Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1HBKff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:35:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59080 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab1HBKfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:12 -0400
From: Julia Lawall <julia@diku.dk>
To: Ben Dooks <ben-linux@fluff.org>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/11] arch/arm/mach-s3c64xx/dma.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:34:56 +0200
Message-Id: <1312281304-11847-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/mach-s3c64xx/dma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/arch/arm/mach-s3c64xx/dma.c b/arch/arm/mach-s3c64xx/dma.c
--- a/arch/arm/mach-s3c64xx/dma.c
+++ b/arch/arm/mach-s3c64xx/dma.c
@@ -603,8 +603,7 @@ static irqreturn_t s3c64xx_dma_irq(int i
 				&& buff->next != chan->next)
 			buff = buff->next;
 
-		if (!buff)
-			BUG();
+		BUG_ON(!buff);
 
 		if (buff == chan->next)
 			buff = chan->end;

