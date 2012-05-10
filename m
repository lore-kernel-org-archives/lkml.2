Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568Ab2EJRs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:48:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58653 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760206Ab2EJRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:55 -0400
Message-Id: <20120510173133.917563177@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 11/52] x86, relocs: Remove an unused variable
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kusanagi Kouichi <slash@ac.auone-net.jp>

commit 7c77cda0fe742ed07622827ce80963bbeebd1e3f upstream.

sh_symtab is set but not used.

[ hpa: putting this in urgent because of the sheer harmlessness of the patch:
  it quiets a build warning but does not change any generated code. ]

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Link: http://lkml.kernel.org/r/20120401082932.D5E066FC03D@msa105.auone-net.jp
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/relocs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -402,13 +402,11 @@ static void print_absolute_symbols(void)
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


