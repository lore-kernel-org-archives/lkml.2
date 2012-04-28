Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2D1Isr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 04:48:47 -0400
Received: from msa106.auone-net.jp ([61.117.18.166]:60859 "EHLO
	msa106.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2D1Isq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 04:48:46 -0400
Date: Sat, 28 Apr 2012 17:48:42 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, relocs: Fix a set-but-not-used warning
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20120428084843.6982962C03E@msa106.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this warning for x86-32 relocatable kernel:

arch/x86/boot/compressed/relocs.c: In function 'print_absolute_symbols':
arch/x86/boot/compressed/relocs.c:406:14: warning: variable 'sh_symtab' set but not used [-Wunused-but-set-variable]

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 arch/x86/boot/compressed/relocs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index d3c0b02..57c563d 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -414,7 +414,7 @@ static void print_absolute_symbols(void)
 		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
 			Elf32_Sym *sym;
 			const char *name;
-			sym = &sec->symtab[j];
+			sym = &sh_symtab[j];
 			name = sym_name(sym_strtab, sym);
 			if (sym->st_shndx != SHN_ABS) {
 				continue;
-- 
1.7.10

