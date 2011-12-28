Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab1L1ILg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 03:11:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:54908 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1L1ILd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 03:11:33 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] kmemleak/module: only scan the existed data section
Date: Wed, 28 Dec 2011 16:11:31 +0800
Message-ID: <1325059891-20540-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only scan the sections containing data and it's size is not
zero as well.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 kernel/module.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 12cfa2b..0b93c30 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2045,6 +2045,8 @@ static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
 		if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
 		    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
 			continue;
+		if (sechdrs[i].sh_size == 0)
+			continue;
 
 		kmemleak_scan_area((void *)sechdrs[i].sh_addr,
 				   sechdrs[i].sh_size, GFP_KERNEL);
-- 
1.6.0.4

