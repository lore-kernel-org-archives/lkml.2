Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2AZWeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 17:34:37 -0500
Received: from numidia.opendz.org ([98.142.220.152]:56862 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2AZWeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 17:34:36 -0500
Date: Thu, 26 Jan 2012 23:37:23 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kcore: make get_sparsemem_vmemmap_info static
Message-ID: <20120126223723.GA20412@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_sparsemem_vmemmap_info() is only used inside fs/proc/kcore.c

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/kcore.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index d245cb2..699e92b 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -157,7 +157,8 @@ static int kcore_update_ram(void)
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /* calculate vmemmap's address from given system ram pfn and register it */
-int get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
+static int
+get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
 {
 	unsigned long pfn = __pa(ent->addr) >> PAGE_SHIFT;
 	unsigned long nr_pages = ent->size >> PAGE_SHIFT;
@@ -189,7 +190,8 @@ int get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
 
 }
 #else
-int get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
+static int
+get_sparsemem_vmemmap_info(struct kcore_list *ent, struct list_head *head)
 {
 	return 1;
 }
-- 
1.7.1
