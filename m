Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1GED7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 23:59:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42638 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab1GED7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 23:59:38 -0400
Date: Tue, 5 Jul 2011 13:59:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, Jonas Bonn <jonas@southpole.se>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the rr tree with the  tree
Message-Id: <20110705135932.de7f0526.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/m68k/kernel/module_mm.c arch/m68k/kernel/module_no.c between commit
4528acce2607 ("m68k: merge the non-mmu and mmu versions of module.c")
from the m68knommu tree and commit 7b935befe6bc ("modules: make arch's
use default loader hooks") from the rr tree.

The former removes these files, so I did that.

I then added this merge fix up patch (which I can carry as necessary and
may not be coorrect):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 5 Jul 2011 13:12:26 +1000
Subject: [PATCH] modules/m68k: make arch's use default loader hooks

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/m68k/kernel/module.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/arch/m68k/kernel/module.c b/arch/m68k/kernel/module.c
index 146d646..34849c4 100644
--- a/arch/m68k/kernel/module.c
+++ b/arch/m68k/kernel/module.c
@@ -19,29 +19,6 @@
 
 #ifdef CONFIG_MODULES
 
-void *module_alloc(unsigned long size)
-{
-	if (size == 0)
-		return NULL;
-	return vmalloc(size);
-}
-
-
-/* Free memory returned from module_alloc */
-void module_free(struct module *mod, void *module_region)
-{
-	vfree(module_region);
-}
-
-/* We don't need anything special. */
-int module_frob_arch_sections(Elf_Ehdr *hdr,
-			      Elf_Shdr *sechdrs,
-			      char *secstrings,
-			      struct module *mod)
-{
-	return 0;
-}
-
 int apply_relocate(Elf32_Shdr *sechdrs,
 		   const char *strtab,
 		   unsigned int symindex,
@@ -130,10 +107,6 @@ int module_finalize(const Elf_Ehdr *hdr,
 	return 0;
 }
 
-void module_arch_cleanup(struct module *mod)
-{
-}
-
 #endif /* CONFIG_MODULES */
 
 void module_fixup(struct module *mod, struct m68k_fixup_info *start,
-- 
1.7.5.4


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
