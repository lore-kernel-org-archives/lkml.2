Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1LFTMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:10 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45409 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1LFTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:07 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 01/25] kernel/module.c: fix compile err, warnings under ifdef DEBUGP
Date: Tue,  6 Dec 2011 12:11:11 -0700
Message-Id: <1323198694-7186-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

resubmit of https://lkml.org/lkml/2010/9/15/399 4/4 patch
with tiny mod.

Fixes these warnings, err if DEBUGP is defined in kernel/module.c:

kernel/module.c: In function ‘layout_sections’:
kernel/module.c:1776: error: ‘name’ undeclared (first use in this function)
kernel/module.c:1776: error: (Each undeclared identifier is reported only once
kernel/module.c:1776: error: for each function it appears in.)
kernel/module.c: In function ‘move_module’:
kernel/module.c:2394: warning: format ‘%lx’ expects type ‘long unsigned int’,
but argument 2 has type ‘Elf64_Addr’

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/module.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 178333c..30ffed4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1978,7 +1978,7 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			    || strstarts(sname, ".init"))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
-			DEBUGP("\t%s\n", name);
+			DEBUGP("\t%s\n", sname);
 		}
 		switch (m) {
 		case 0: /* executable */
@@ -2639,8 +2639,8 @@ static int move_module(struct module *mod, struct load_info *info)
 			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
 		/* Update sh_addr to point to copy in image. */
 		shdr->sh_addr = (unsigned long)dest;
-		DEBUGP("\t0x%lx %s\n",
-		       shdr->sh_addr, info->secstrings + shdr->sh_name);
+		DEBUGP("\t0x%p %s\n",
+		       (void *)shdr->sh_addr, info->secstrings + shdr->sh_name);
 	}
 
 	return 0;
-- 
1.7.7.3

