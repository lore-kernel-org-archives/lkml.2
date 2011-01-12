Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab1ALEcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 23:32:14 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43561 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ALEcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 23:32:12 -0500
Date: Tue, 11 Jan 2011 23:32:03 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: sfi-devel@simplefirmware.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SFI: use ioremap_cache() instead of ioremap()
Message-id: <alpine.LFD.2.02.1101112329590.11311@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

We copied ACPI's oversight of using ioremap() and creating
non-cached table mappings when we should have been using
ioremap_cache().

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/sfi/sfi_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index ceba593..04113e5 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -101,7 +101,7 @@ static void __iomem * __ref sfi_map_memory(u64 phys, u32 size)
 		return NULL;
 
 	if (sfi_use_ioremap)
-		return ioremap(phys, size);
+		return ioremap_cache(phys, size);
 	else
 		return early_ioremap(phys, size);
 }
-- 
1.7.4.rc1.7.g2cf08

