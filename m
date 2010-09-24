Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0IXM3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:29:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:41537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab0IXM2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:28:34 -0400
From: Thomas Renninger <trenn@suse.de>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com, jbaron@redhat.com,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 4/4] kernel/module.c: Fix compiler warnings if debug is compiled in
Date: Fri, 24 Sep 2010 14:28:31 +0200
Message-Id: <1285331311-21753-5-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20100920184441.GA2915@redhat.com>
References: <20100920184441.GA2915@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes these warnings:
kernel/module.c: In function ‘layout_sections’:
kernel/module.c:1776: error: ‘name’ undeclared (first use in this function)
kernel/module.c:1776: error: (Each undeclared identifier is reported only once
kernel/module.c:1776: error: for each function it appears in.)
kernel/module.c: In function ‘move_module’:
kernel/module.c:2394: warning: format ‘%lx’ expects type ‘long unsigned int’,
but argument 2 has type ‘Elf64_Addr’

if DEBUGP is defined in kernel/module.c

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: Greg KH <gregkh@suse.de>
CC: jbaron@redhat.com
CC: lkml <linux-kernel@vger.kernel.org>
---
 kernel/module.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 3912e12..66e4361 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1773,7 +1773,6 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			    || strstarts(sname, ".init"))
 				continue;
 			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
-			DEBUGP("\t%s\n", name);
 		}
 		if (m == 0)
 			mod->core_text_size = mod->core_size;
@@ -2390,8 +2389,8 @@ static int move_module(struct module *mod, struct load_info *info)
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
1.6.4.2

