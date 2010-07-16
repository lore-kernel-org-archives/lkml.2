Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965984Ab0GPQNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:13:08 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54496 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965891Ab0GPQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qIdOgCrDEPJ3JU1sALJBI6bvamzckLIMVmXkfJ+BTMQNBvjmubhZxe3Kfr7o85cGjT
         EuzsgPl93SJdhr6QWlwc3XrKMR1ht+dyT9B/BWTZap43iDXB3jSntdgFM2Ei8NihyPmS
         79qaaFUZaOpFt6oS96GlIfsCGv8NXX2enSTbw=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] arm/mach-u300: check kmalloc result
Date: Fri, 16 Jul 2010 20:12:46 +0400
Message-Id: <1279296767-24823-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kmalloc() fails free already allocated memory and exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/arm/mach-u300/dummyspichip.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-u300/dummyspichip.c b/arch/arm/mach-u300/dummyspichip.c
index 5f55012..452218a 100644
--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -64,6 +64,11 @@ static ssize_t dummy_looptest(struct device *dev,
 		goto out;
 	}
 	bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
+	if (bigrxbuf_virtual == NULL) {
+		kfree(bigtxbuf_virtual);
+		status = -ENOMEM;
+		goto out;
+	}
 
 	/* Fill TXBUF with some happy pattern */
 	memset(bigtxbuf_virtual, 0xAA, DMA_TEST_SIZE);
-- 
1.7.0.4

