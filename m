Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab0EDS6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:58:06 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:39356 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab0EDS6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:58:05 -0400
Subject: [PATCH 1/2] resources: fill in type for __request_region()
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 04 May 2010 12:58:01 -0600
Message-ID: <20100504185801.7244.39173.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Set the IORESOURCE_TYPE based on the parent.  Without this, the type is
never set, which is slightly confusing if we ever print the resource later.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index aa63746..f0d83a4 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -699,8 +699,9 @@ struct resource * __request_region(struct resource *parent,
 	res->name = name;
 	res->start = start;
 	res->end = start + n - 1;
-	res->flags = IORESOURCE_BUSY;
-	res->flags |= flags;
+	res->flags = parent->flags & IORESOURCE_TYPE_BITS;
+	res->flags |= (flags & ~IORESOURCE_TYPE_BITS);
+	res->flags |= IORESOURCE_BUSY;
 
 	write_lock(&resource_lock);
 

