Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2LJDnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 22:43:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab2LJDnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 22:43:18 -0500
X-IronPort-AV: E=Sophos;i="4.84,249,1355068800"; 
   d="scan'208";a="6363344"
Message-ID: <50C556A3.2050307@cn.fujitsu.com>
Date: Mon, 10 Dec 2012 11:27:31 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] binfmt_elf: remove unused argument in fill_elf_header
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/10 11:28:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/10 11:42:28,
	Serialize complete at 2012/12/10 11:42:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function fill_elf_header, elf->e_ident[EI_OSABI] is always set
to ELF_OSABI, so remove the unused argument 'osabi'.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 fs/binfmt_elf.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fbd9f60..d7b012f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1247,7 +1247,7 @@ static int writenote(struct memelfnote *men, struct file *file,
 #undef DUMP_WRITE
 
 static void fill_elf_header(struct elfhdr *elf, int segs,
-			    u16 machine, u32 flags, u8 osabi)
+			    u16 machine, u32 flags)
 {
 	memset(elf, 0, sizeof(*elf));
 
@@ -1627,7 +1627,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	 * Initialize the ELF file header.
 	 */
 	fill_elf_header(elf, phdrs,
-			view->e_machine, view->e_flags, view->ei_osabi);
+			view->e_machine, view->e_flags);
 
 	/*
 	 * Allocate a structure for each thread.
@@ -1867,7 +1867,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	elf_core_copy_regs(&info->prstatus->pr_reg, regs);
 
 	/* Set up header */
-	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS, ELF_OSABI);
+	fill_elf_header(elf, phdrs, ELF_ARCH, ELF_CORE_EFLAGS);
 
 	/*
 	 * Set up the notes in similar form to SVR4 core dumps made
-- 
1.7.1
