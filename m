Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab1AXXES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:04:18 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7662 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1AXXER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:04:17 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: linux-mips@linux-mips.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] binfmt_elf: Quiet GCC-4.6 'set but not used' warning in load_elf_binary()
Date: Mon, 24 Jan 2011 15:04:09 -0800
Message-Id: <1295910249-23626-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 24 Jan 2011 23:04:17.0398 (UTC) FILETIME=[06C62960:01CBBC1B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With GCC-4.6 we get warnings about things being 'set but not used'.

In load_elf_binary() this can happen with reloc_func_desc if
ELF_PLAT_INIT is defined, but doesn't use the reloc_func_desc
argument.

Quiet the warning/error by marking reloc_func_desc as __maybe_unused.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 fs/binfmt_elf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d5b640b..b2fae009 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -570,7 +570,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	unsigned long elf_entry;
 	unsigned long interp_load_addr = 0;
 	unsigned long start_code, end_code, start_data, end_data;
-	unsigned long reloc_func_desc = 0;
+	unsigned long reloc_func_desc __maybe_unused = 0;
 	int executable_stack = EXSTACK_DEFAULT;
 	unsigned long def_flags = 0;
 	struct {
-- 
1.7.2.3

