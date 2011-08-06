Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab1HFL0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 07:26:48 -0400
Received: from www17.your-server.de ([213.133.104.17]:34585 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab1HFL0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 07:26:45 -0400
Subject: [PATCH] arm: mach-davinci: use kzalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 06 Aug 2011 13:26:13 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312629976.5589.128.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kzalloc rather than kmalloc followed by memset with 0

 This considers some simple cases that are common and easy to validate
 Note in particular that there are no ...s in the rule, so all of the
 matched code has to be contiguous

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/arm/mach-davinci/dma.c b/arch/arm/mach-davinci/dma.c
--- a/arch/arm/mach-davinci/dma.c 2010-10-26 18:50:12.713889353 +0200
+++ b/arch/arm/mach-davinci/dma.c 2011-08-01 20:40:38.326583216 +0200
@@ -1435,12 +1435,11 @@ static int __init edma_probe(struct plat
 			goto fail1;
 		}
 
-		edma_cc[j] = kmalloc(sizeof(struct edma), GFP_KERNEL);
+		edma_cc[j] = kzalloc(sizeof(struct edma), GFP_KERNEL);
 		if (!edma_cc[j]) {
 			status = -ENOMEM;
 			goto fail1;
 		}
-		memset(edma_cc[j], 0, sizeof(struct edma));
 
 		edma_cc[j]->num_channels = min_t(unsigned, info[j]->n_channel,
 							EDMA_MAX_DMACH);



