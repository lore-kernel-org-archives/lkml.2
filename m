Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0DFFdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:33:36 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:7946 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0DFFda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=Dt6m7nSjjyAidorXuWxKAByi6p4BPUmuqs+byPiLBBWqvMWhurC43Q0sNgOMtm4qwO
         jZUcn4OwTNhm9GoRZiuBQL7eOhyUklm7KJymTdwgJgtOcjxzQAF6ZDXvRS5ebiMGOaj1
         P0S1t/Imv+NDQMJ887oh3QpQsrST9O2gzve90=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 6 Apr 2010 13:33:09 +0800
Message-ID: <k2n427d64721004052233s314c7daj1f96a77061f6b836@mail.gmail.com>
Subject: [PATCH] pl061: Trivial fix for offset value range checking
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Brownell <david-b@pacbell.net>, Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The valid offset value is 0..PL061_GPIO_NR-1,
this patch corrects the offset value range checking.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/pl061.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
index 5ad8f77..8e0906a 100644
--- a/drivers/gpio/pl061.c
+++ b/drivers/gpio/pl061.c
@@ -158,7 +158,7 @@ static int pl061_irq_type(unsigned irq, unsigned trigger)
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;

-	if (offset < 0 || offset > PL061_GPIO_NR)
+	if (offset < 0 || offset >= PL061_GPIO_NR)
 		return -EINVAL;

 	spin_lock_irqsave(&chip->irq_lock, flags);
-- 
1.5.4.3
