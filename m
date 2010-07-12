Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0GLPrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:47:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38531 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0GLPrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:47:14 -0400
Message-ID: <4C3B3900.6050000@austin.ibm.com>
Date: Mon, 12 Jul 2010 10:47:12 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linuxppc-dev@ozlabs.org
Subject: [PATCH 6/7] Update sysfs node routines for new sysfs memory directories
References: <4C3B3446.5090302@austin.ibm.com>
In-Reply-To: <4C3B3446.5090302@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the node sysfs directory routines that create
links to the memory sections under each node.  This update makes
the node code aware that a memory sysfs directory can cover
multiple memory sections.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

---
 drivers/base/node.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/base/node.c
===================================================================
--- linux-2.6.orig/drivers/base/node.c	2010-07-09 14:36:53.000000000 -0500
+++ linux-2.6/drivers/base/node.c	2010-07-09 14:38:22.000000000 -0500
@@ -346,8 +346,10 @@
 		return -EFAULT;
 	if (!node_online(nid))
 		return 0;
-	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
-	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
+
+	sect_start_pfn = section_nr_to_pfn(mem_blk->start_phys_index);
+	sect_end_pfn = section_nr_to_pfn(mem_blk->end_phys_index);
+	sect_end_pfn += PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int page_nid;
 
@@ -383,8 +385,10 @@
 	if (!unlinked_nodes)
 		return -ENOMEM;
 	nodes_clear(*unlinked_nodes);
-	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
-	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
+
+	sect_start_pfn = section_nr_to_pfn(mem_blk->start_phys_index);
+	sect_end_pfn = section_nr_to_pfn(mem_blk->end_phys_index);
+	sect_end_pfn += PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int nid;
