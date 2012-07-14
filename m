Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2GNNlU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:41:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63887 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2GNNlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:41:17 -0400
From: Pekka Enberg <penberg@kernel.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/3] x86/mm: Simplify for-loop in free_init_pages()
Date: Sat, 14 Jul 2012 16:41:06 +0300
Message-Id: <1342273267-2108-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342273267-2108-1-git-send-email-penberg@kernel.org>
References: <1342273267-2108-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a cleanup, move initial "addr" assignment to the for-loop construct
in free_init_pages().

Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 9eb53c2..e270f94 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -349,8 +349,6 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	if (begin >= end)
 		return;
 
-	addr = begin;
-
 	/*
 	 * If debugging page accesses then do not free this memory but
 	 * mark them not present - any buggy init-section access will
@@ -371,7 +369,7 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
-	for (; addr < end; addr += PAGE_SIZE) {
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
 		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-- 
1.7.7.6

