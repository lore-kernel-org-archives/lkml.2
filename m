Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab1AMAOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:14:44 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53633 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab1AMAOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:14:41 -0500
Date: Wed, 12 Jan 2011 16:12:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH v2] module: fix build when DEBUGP is defined
Message-Id: <20110112161217.0da1d290.randy.dunlap@oracle.com>
In-Reply-To: <201101130832.16210.rusty@rustcorp.com.au>
References: <20110111172153.e43e03b8.randy.dunlap@oracle.com>
	<201101121918.21079.rusty@rustcorp.com.au>
	<4D2DD629.1080701@oracle.com>
	<201101130832.16210.rusty@rustcorp.com.au>
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

(on x86_64:)
kernel/module.c:1910: error: 'name' undeclared (first use in this function)
kernel/module.c:2567: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'Elf64_Addr'
(or on i386:)
kernel/module.c:2567: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'Elf32_Addr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
@@ -2564,7 +2564,8 @@ static int move_module(struct module *mo
 		/* Update sh_addr to point to copy in image. */
 		shdr->sh_addr = (unsigned long)dest;
 		DEBUGP("\t0x%lx %s\n",
-		       shdr->sh_addr, info->secstrings + shdr->sh_name);
+		       (unsigned long)shdr->sh_addr,
+		       info->secstrings + shdr->sh_name);
 	}
 
 	return 0;
