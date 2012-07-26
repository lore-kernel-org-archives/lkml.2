Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2GZQe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:34:26 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42012 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2GZQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:34:23 -0400
Subject: [PATCH 3/3] hpsa: use ioremap_nocache instead of ioremap
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Date: Thu, 26 Jul 2012 11:34:23 -0500
Message-ID: <20120726163422.25864.19285.stgit@beardog.cce.hp.com>
In-Reply-To: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
References: <20120726162726.25864.49510.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

I think ioremap() ends up being equivalent to ioremap_nocache
by default, but we should signal our intent that these mappings
should be non-cacheable.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 415db96..5ed5859 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3337,7 +3337,8 @@ static void __iomem *remap_pci_mem(ulong base, ulong size)
 {
 	ulong page_base = ((ulong) base) & PAGE_MASK;
 	ulong page_offs = ((ulong) base) - page_base;
-	void __iomem *page_remapped = ioremap(page_base, page_offs + size);
+	void __iomem *page_remapped = ioremap_nocache(page_base,
+		page_offs + size);
 
 	return page_remapped ? (page_remapped + page_offs) : NULL;
 }

