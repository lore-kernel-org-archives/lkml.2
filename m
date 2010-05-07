Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0EGClQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:41:16 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44237 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0EGClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=GB6lRZnqJN+w8rm32vKRbfG7pVJt11bdHjg5myzlYy/W105Dp8ugiC1QiCiPWCB9Ey
         feI0SxiQ0SF5wRY8PeCfdS/fWUMKjRm6k2hHVgreanDwBuH5BwH/CvQDE7K7tiqssyw5
         dJ+V+p9o/Qtk9iMP8NT6iVFis89+OmGz66Kz4=
MIME-Version: 1.0
Date: Fri, 7 May 2010 10:41:14 +0800
Message-ID: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
Subject: [PATCH] Check kmalloc return value before use the buffer
From: Steven Liu <lingjiujianke@gmail.com>
To: linus.walleij@stericsson.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,linus.walleij

          Check kmalloc return value before use the buffer


Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 arch/arm/mach-u300/dummyspichip.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-u300/dummyspichip.c
b/arch/arm/mach-u300/dummyspichip.c
index 962f9de..4f2af7c 100644
--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -63,6 +63,11 @@ static ssize_t dummy_looptest(struct device *dev,
 		goto out;
 	}
 	bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
+	if (bigtxbuf_virtual == NULL) {
+		status = -ENOMEM;
+		kfree(bigtxbuf_virtual);
+		goto out;
+	}

 	/* Fill TXBUF with some happy pattern */
 	memset(bigtxbuf_virtual, 0xAA, DMA_TEST_SIZE);
-- 
1.6.0.3
