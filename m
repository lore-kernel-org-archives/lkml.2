Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab1FKBQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 21:16:18 -0400
Received: from mail.perches.com ([173.55.12.10]:2802 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758440Ab1FKBQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 21:16:17 -0400
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio-vr41xx: Convert use of struct resource to resource_size(ptr)
Date: Fri, 10 Jun 2011 18:16:15 -0700
Message-Id: <fb9fae86e3bc9f2d532cca7e513ac24229a67ceb.1307754917.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove miscellaneous use of direct calculation by using resource_size().

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpio/gpio-vr41xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index a365be0..98723cb 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -518,7 +518,7 @@ static int __devinit giu_probe(struct platform_device *pdev)
 	if (!res)
 		return -EBUSY;
 
-	giu_base = ioremap(res->start, res->end - res->start + 1);
+	giu_base = ioremap(res->start, resource_size(res));
 	if (!giu_base)
 		return -ENOMEM;
 
-- 
1.7.6.rc1

