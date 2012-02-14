Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2BNAEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:04:54 -0500
Received: from mail-fa0-f74.google.com ([209.85.161.74]:56816 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758508Ab2BNAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:04:50 -0500
Subject: [PATCH] PM / Hibernate: print physical addresses consistently with
	other parts of kernel
To: "Rafael J. Wysocki" <rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Mon, 13 Feb 2012 17:04:47 -0700
Message-ID: <20120214000447.32522.5191.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print physical address info in a style consistent with the %pR style used
elsewhere in the kernel.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 kernel/power/snapshot.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 6a768e5..8e2e746 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -711,9 +711,10 @@ static void mark_nosave_pages(struct memory_bitmap *bm)
 	list_for_each_entry(region, &nosave_regions, list) {
 		unsigned long pfn;
 
-		pr_debug("PM: Marking nosave pages: %016lx - %016lx\n",
-				region->start_pfn << PAGE_SHIFT,
-				region->end_pfn << PAGE_SHIFT);
+		pr_debug("PM: Marking nosave pages: [mem %#010llx-%#010llx]\n",
+			 (unsigned long long) region->start_pfn << PAGE_SHIFT,
+			 ((unsigned long long) region->end_pfn << PAGE_SHIFT)
+				- 1);
 
 		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
 			if (pfn_valid(pfn)) {

