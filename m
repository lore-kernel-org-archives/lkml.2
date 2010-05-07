Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0EGJFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:05:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34927 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab0EGJFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=geeRdn0Vw0/hGCvX2O7lsualcMFqiBPYymbNjgTOtV+Sryu3Gj1LglOASQXHCxhGta
         +FrcchvROwk4gRAHc6BXSJmHIrihRs+/pRYQzCCYhLFSYB72xzxrewDqf9nXoaE7owz1
         XU+1GH1RuQejLC/2SHK65XYysGQWONV8odq3o=
MIME-Version: 1.0
Date: Fri, 7 May 2010 17:05:44 +0800
Message-ID: <t2pbd0d95d71005070205s5707e3bq45d16050262c303@mail.gmail.com>
Subject: [PATCH] Check kmalloc return value before use the buffer
From: Steven Liu <lingjiujianke@gmail.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 arch/arm/mach-u300/dummyspichip.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-u300/dummyspichip.c
b/arch/arm/mach-u300/dummyspichip.c
index 5f55012..df19f9b 100644
--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -64,6 +64,11 @@ static ssize_t dummy_looptest(struct device *dev,
 		goto out;
 	}
 	bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
+	if (bigrxbuf_virtual == NULL) {
+		status = -ENOMEM;
+		kfree(bigtxbuf_virtual);
+		goto out;
+	}

 	/* Fill TXBUF with some happy pattern */
 	memset(bigtxbuf_virtual, 0xAA, DMA_TEST_SIZE);
-- 
1.6.0.3
