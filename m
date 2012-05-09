Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab2EIGBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:01:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39057 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490Ab2EIFxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:43 -0400
Message-Id: <20120509055050.693943991@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 153/167] [PATCH] x86, relocs: Remove an unused variable
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kusanagi Kouichi <slash@ac.auone-net.jp>

commit 7c77cda0fe742ed07622827ce80963bbeebd1e3f upstream.

sh_symtab is set but not used.

[ hpa: putting this in urgent because of the sheer harmlessness of the patch:
  it quiets a build warning but does not change any generated code. ]

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Link: http://lkml.kernel.org/r/20120401082932.D5E066FC03D@msa105.auone-net.jp
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
1.7.10



