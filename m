Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab2D3XsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:48:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2D3XsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:48:06 -0400
Date: Mon, 30 Apr 2012 16:47:49 -0700
From: tip-bot for Kusanagi Kouichi <slash@ac.auone-net.jp>
Message-ID: <tip-7c77cda0fe742ed07622827ce80963bbeebd1e3f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        slash@ac.auone-net.jp, stable@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        slash@ac.auone-net.jp, tglx@linutronix.de, stable@vger.kernel.org,
        hpa@linux.intel.com
In-Reply-To: <20120401082932.D5E066FC03D@msa105.auone-net.jp>
References: <20120401082932.D5E066FC03D@msa105.auone-net.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, relocs: Remove an unused variable
Git-Commit-ID: 7c77cda0fe742ed07622827ce80963bbeebd1e3f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Apr 2012 16:47:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7c77cda0fe742ed07622827ce80963bbeebd1e3f
Gitweb:     http://git.kernel.org/tip/7c77cda0fe742ed07622827ce80963bbeebd1e3f
Author:     Kusanagi Kouichi <slash@ac.auone-net.jp>
AuthorDate: Sun, 1 Apr 2012 17:29:32 +0900
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 30 Apr 2012 12:55:15 -0700

x86, relocs: Remove an unused variable

sh_symtab is set but not used.

[ hpa: putting this in urgent because of the sheer harmlessness of the patch:
  it quiets a build warning but does not change any generated code. ]

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Link: http://lkml.kernel.org/r/20120401082932.D5E066FC03D@msa105.auone-net.jp
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/boot/compressed/relocs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

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
