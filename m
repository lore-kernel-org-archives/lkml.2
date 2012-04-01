Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2DAI3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 04:29:39 -0400
Received: from msa105.auone-net.jp ([61.117.18.165]:45287 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2DAI3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 04:29:35 -0400
Date: Sun, 1 Apr 2012 17:29:32 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, relocs: Remove an unused variable
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20120401082932.D5E066FC03D@msa105.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sh_symtab is set but not used.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 arch/x86/boot/compressed/relocs.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index d3c0b02..fb7117a 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -403,13 +403,11 @@ static void print_absolute_symbols(void)
 	for (i = 0; i < ehdr.e_shnum; i++) {
 		struct section *sec = &secs[i];
 		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
 		int j;
 
 		if (sec->shdr.sh_type != SHT_SYMTAB) {
 			continue;
 		}
-		sh_symtab = sec->symtab;
 		sym_strtab = sec->link->strtab;
 		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
 			Elf32_Sym *sym;
-- 
1.7.9.5

