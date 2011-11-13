Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1KMDOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 22:14:22 -0500
Received: from [69.28.251.93] ([69.28.251.93]:48172 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1KMDOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 22:14:20 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Jan Beulich <JBeulich@novell.com>
Subject: [PATCH V2 1/2] module: Add comments describing how the "strmap" logic
 works
Date: Sat, 12 Nov 2011 19:08:55 -0800
Message-Id: <73defb5e4bca04a6431392cc341112b1@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 kernel/module.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 178333c..cf9f1b6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2193,6 +2193,13 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 
 	src = (void *)info->hdr + symsect->sh_offset;
 	nsrc = symsect->sh_size / sizeof(*src);
+
+	/*
+	 * info->strmap has a '1' bit for each byte of .strtab we want to
+	 * keep resident in mod->core_strtab.  Everything else in .strtab
+	 * is unreferenced by the symbols in mod->core_symtab, and will be
+	 * discarded when add_kallsyms() compacts the string table.
+	 */
 	for (ndst = i = 1; i < nsrc; ++i, ++src)
 		if (is_core_symbol(src, info->sechdrs, info->hdr->e_shnum)) {
 			unsigned int j = src->st_name;
@@ -2215,6 +2222,8 @@ static void layout_symtab(struct module *mod, struct load_info *info)
 
 	/* Append room for core symbols' strings at end of core part. */
 	info->stroffs = mod->core_size;
+
+	/* First strtab byte (and first symtab entry) are zeroes. */
 	__set_bit(0, info->strmap);
 	mod->core_size += bitmap_weight(info->strmap, strsect->sh_size);
 }
-- 
1.7.6.3

