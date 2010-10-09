Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab0JIVpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 17:45:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab0JIVpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 17:45:35 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: catalin.marinas@arm.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lacombar@gmail.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH] kconfig: Temporarily disable dependency warnings
Date: Sat,  9 Oct 2010 23:45:01 +0200
Message-Id: <1286660701-31557-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101008150343.GF4088@hack>
References: <20101008150343.GF4088@hack>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After fixing a use-after-free bug in kconfig, a 'make defconfig' or
'make allmodconfig' fills the screen with warnings that were not
detected before. Given that we are close to the release now, disable the
warnings temporarily and deal with them after 2.6.36.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 943712c..1f8b305 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -349,16 +349,18 @@ void sym_calc_value(struct symbol *sym)
 							      prop->visible.tri);
 				}
 			}
 		calc_newval:
+#if 0
 			if (sym->dir_dep.tri == no && sym->rev_dep.tri != no) {
 				fprintf(stderr, "warning: (");
 				expr_fprint(sym->rev_dep.expr, stderr);
 				fprintf(stderr, ") selects %s which has unmet direct dependencies (",
 					sym->name);
 				expr_fprint(sym->dir_dep.expr, stderr);
 				fprintf(stderr, ")\n");
 			}
+#endif
 			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
 		}
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
 			newval.tri = yes;
-- 
1.7.1

