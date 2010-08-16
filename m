Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0HPPwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:52:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33059 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab0HPPwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:52:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XViZWBWuUWPjBoZApJvN77tm1zIxww+1CNauR4gGrDsiQDsDgwZPmTPl3rdliP2RVw
         v5BIeooAVSc9TS3i+05JcuRqzcHXB8jtD9HEzpSBeXbBrBoBlB2uvCylFSiUJL7dCSLu
         rEa50duyts8eL8gxpVFuaUzVjXbguGtecxUGs=
From: Huang Shijie <shijie8@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH] avoiding the same resource to be inserted
Date: Mon, 16 Aug 2010 23:55:38 +0800
Message-Id: <1281974138-5553-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  If the same resource is inserted to the resource tree
(maybe not on purpose), a dead loop will be created. In this situation,
The kernel does not report any warning or error	:(

  The command below will show a endless print.
  #cat /proc/iomem

  So, adding the check for the same resource is needed for the stability
and reliability of the kernel.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 kernel/resource.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 7b36976..60daab4 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -451,7 +451,7 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
 		if (!first)
 			return first;
 
-		if (first == parent)
+		if (first == parent || first == new)
 			return first;
 
 		if ((first->start > new->start) || (first->end < new->end))
-- 
1.6.6.1

