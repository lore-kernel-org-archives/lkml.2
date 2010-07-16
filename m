Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965995Ab0GPQNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:13:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60495 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965891Ab0GPQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qlxXLfGWOZsb03adYUmcoMof8nKt3paPTtGSW+81K9E7DVGna1phPtOLeoJpX28IAW
         IRWbBWh06LC6wH0mOd053a/mnlxmYb9cRs9S54vkJ1v2qbJMnLGzrWoOkDr2H9cL1DV7
         P051upZ5NLfxc4OfB+v3dv/3V/rPYA+Q5fx5M=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] arch/tile: check kmalloc() result
Date: Fri, 16 Jul 2010 20:13:02 +0400
Message-Id: <1279296783-24863-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kmalloc() fails exit with -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/tile/kernel/hardwall.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/hardwall.c b/arch/tile/kernel/hardwall.c
index 7bf0627..584b965 100644
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -364,6 +364,8 @@ static struct hardwall_info *hardwall_create(
 	/* Allocate a new rectangle optimistically. */
 	rect = kmalloc(sizeof(struct hardwall_info),
 			GFP_KERNEL | __GFP_ZERO);
+	if (rect == NULL)
+		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(&rect->task_head);
 
 	/* Compute the rectangle size and validate that it's plausible. */
-- 
1.7.0.4

