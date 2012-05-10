Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895Ab2EJXot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:44:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877Ab2EJXob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:44:31 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/29] MODSIGN: Suppress some redundant ELF checks [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:44:22 +0100
Message-ID: <20120510234422.4137.92830.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppress some redundant ELF checks in module_verify_elf() that are also done
by copy_and_check() in the core module loader code prior to calling
module_verify().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module-verify.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index a31b39c..e1bfd28 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -76,7 +76,7 @@ static noinline int module_verify_elf(struct module_verify_data *mvdata)
 	const Elf_Shdr *section, *secstop;
 	const Elf_Sym *symbols, *symbol, *symstop;
 	const char *strtab;
-	size_t size, secsize, secstrsize, strsize, notesize, notemetasize;
+	size_t size, secstrsize, strsize, notesize, notemetasize;
 	unsigned line;
 
 	size = mvdata->size;
@@ -96,11 +96,11 @@ do { if (unlikely(!(X))) { line = __LINE__; goto symcheck_error; } } while(0)
 
 	elfcheck(hdr->e_shnum < SHN_LORESERVE);
 	elfcheck(hdr->e_shstrndx < hdr->e_shnum);
-	elfcheck(hdr->e_shentsize == sizeof(Elf_Shdr));
-	elfcheck(hdr->e_shoff < size);
+	/* elfcheck(hdr->e_shentsize == sizeof(Elf_Shdr)); */
+	/* elfcheck(hdr->e_shoff < size); */
 	elfcheck(hdr->e_shoff >= hdr->e_ehsize);
 	elfcheck(hdr->e_shoff % sizeof(long) == 0);
-	elfcheck(hdr->e_shnum * sizeof(Elf_Shdr) <= size - hdr->e_shoff);
+	/* elfcheck(hdr->e_shnum * sizeof(Elf_Shdr) <= size - hdr->e_shoff); */
 
 	/* Validate the section table contents */
 	mvdata->nsects = hdr->e_shnum;

