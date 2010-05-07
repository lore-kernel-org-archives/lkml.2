Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0EGHRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:17:42 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:52964 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0EGHRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=F/gOE45xd+RK6mp0R1CTS/N8ovcXb8YOmWFdtM5VtEYZSsoyfRs/seLTBnnMcXAuiT
         0FFI32Bi972u97whQW9ZIZsZu7hQTtFiv8+DGOFp6/uGuGSnnQ7U0xj7prnCjEV8dzHF
         4W7xYaTwD6cqRtKTk64jWgk6APyuO5vXDexto=
MIME-Version: 1.0
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
Date: Fri, 7 May 2010 15:17:39 +0800
Message-ID: <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
From: Steven Liu <lingjiujianke@gmail.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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
