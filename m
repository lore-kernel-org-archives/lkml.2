Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1GYBnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:43:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55745 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1GYBnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:43:42 -0400
Date: Mon, 25 Jul 2011 11:43:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Jonas Bonn <jonas@southpole.se>, Rusty Russell <rusty@rustcorp.com.au>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: manual merge of the rr tree with the  tree
Message-Id: <20110725114327.fa9c46a5398677ffa4acbd6f@canb.auug.org.au>
In-Reply-To: <20110707102432.5a779744e247652be005b592@canb.auug.org.au>
References: <20110705135932.de7f0526.sfr@canb.auug.org.au>
	<1309967847.3393.44.camel@jerome>
	<4E14F373.1020307@snapgear.com>
	<20110707102432.5a779744e247652be005b592@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, 7 Jul 2011 10:24:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> On Thu, 7 Jul 2011 09:44:51 +1000 Greg Ungerer <gerg@snapgear.com> wrote:
> >
> > On 07/07/11 01:57, Jonas Bonn wrote:
> > >
> > > On Tue, 2011-07-05 at 13:59 +1000, Stephen Rothwell wrote:
> > >>
> > >> Today's linux-next merge of the rr tree got a conflict in
> > >> arch/m68k/kernel/module_mm.c arch/m68k/kernel/module_no.c between commit
> > >> 4528acce2607 ("m68k: merge the non-mmu and mmu versions of module.c")
> > >> from the m68knommu tree and commit 7b935befe6bc ("modules: make arch's
> > >> use default loader hooks") from the rr tree.
> > >>
> > >> The former removes these files, so I did that.
> > >>
> > >> I then added this merge fix up patch (which I can carry as necessary and
> > >> may not be coorrect):
> > >>
> > >> From: Stephen Rothwell<sfr@canb.auug.org.au>
> > >> Date: Tue, 5 Jul 2011 13:12:26 +1000
> > >> Subject: [PATCH] modules/m68k: make arch's use default loader hooks
> > >>
> > >> Signed-off-by: Stephen Rothwell<sfr@canb.auug.org.au>
> > >> ---
> > >>   arch/m68k/kernel/module.c |   27 ---------------------------
> > >>   1 files changed, 0 insertions(+), 27 deletions(-)
> > >>
> > >
> > > That patch looks good to me.
> > >
> > > Acked-by: Jonas Bonn<jonas@southpole.se>
> > 
> > Looks fine to me too:
> > 
> > Acked-by: Greg Ungerer <gerg@uclinux.org>
> 
> OK, so now someone just has to remember to apply it (or tell Linus, or
> fix up the trees) during the merge window.   That person probably won't
> be me (since I will not be online next week (assuming Linus follows
> through and opens the merge window next week).

This patch now needs to be applied to the m68knommu tree (after merging
Linus' tree) as Rusty's changes have gone upstream.

Here is the patch I have applied again for reference:

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
