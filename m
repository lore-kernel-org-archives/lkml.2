Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab1ALBYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:24:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37706 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab1ALBYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:24:07 -0500
Date: Tue, 11 Jan 2011 17:21:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] module: fix build when DEBUGP is defined
Message-Id: <20110111172153.e43e03b8.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix module loader build when DEBUGP is defined.
Fixes build error & warning:

kernel/module.c:1910: error: 'name' undeclared (first use in this function)
kernel/module.c:2567: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'Elf64_Addr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20110111.orig/kernel/module.c
+++ linux-next-20110111/kernel/module.c
@@ -1907,7 +1907,7 @@ static void layout_sections(struct modul
 			    || strstarts(sname, ".init"))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
-			DEBUGP("\t%s\n", name);
+			DEBUGP("\t%s\n", sname);
 		}
 		switch (m) {
 		case 0: /* executable */
@@ -2563,7 +2563,7 @@ static int move_module(struct module *mo
 			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
 		/* Update sh_addr to point to copy in image. */
 		shdr->sh_addr = (unsigned long)dest;
-		DEBUGP("\t0x%lx %s\n",
+		DEBUGP("\t0x%llx %s\n",
 		       shdr->sh_addr, info->secstrings + shdr->sh_name);
 	}
 
