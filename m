Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946947Ab2ERXSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:18:39 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:48533 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946599Ab2ERXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:18:34 -0400
Subject: [PATCH 1/2] resources: set type of new resource returned by
	__request_region()
To: David Woodhouse <dwmw2@infradead.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>
Date: Fri, 18 May 2012 17:18:32 -0600
Message-ID: <20120518231832.31187.10630.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
References: <20120518231238.31187.44571.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously we returned a new struct resource with only IORESOURCE_BUSY
set (and possibly IORESOURCE_MUXED or IORESOURCE_EXCLUSIVE), but no
MEM/IO/etc. bits set.  The new resource should inherit the type of
its parent.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 kernel/resource.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 7e8ea66..04bb527 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -847,7 +847,8 @@ struct resource * __request_region(struct resource *parent,
 	res->name = name;
 	res->start = start;
 	res->end = start + n - 1;
-	res->flags = IORESOURCE_BUSY;
+	res->flags = parent->flags;
+	res->flags |= IORESOURCE_BUSY;
 	res->flags |= flags;
 
 	write_lock(&resource_lock);

