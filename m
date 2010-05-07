Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0EGKEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:04:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45222 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0EGKEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:04:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=rqKk8PlHzTicI+48PLehnLhqMkC2P68v0yJhtczFqTAAE+TqA+yhZCq7uOlVVqHrMe
         qBd6XfCwz6K3pIlvm9BTcz/0v7AqOwtUWr7BXLCrqyGfapYo5Ce24h3c/KbFhX0TvROa
         woX8P3Grw6lYraio2x5KjdvUjuui6ngNMQxJQ=
MIME-Version: 1.0
Date: Fri, 7 May 2010 18:04:09 +0800
Message-ID: <x2ybd0d95d71005070304wf9c7235eqedf0d0c37dffe316@mail.gmail.com>
Subject: [PATCH] Check kmalloc return value before use the bigrxbuf_virtual 
	and kfree the bigtxbuf_virtual
From: Steven Liu <lingjiujianke@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       lgy123616 sadas <lingjiujianke@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check kmalloc return value before use the bigrxbuf_virtual ,when
bigrxbuf_virtual is NULL, kfree  bigtxbuf_virtual and out

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
