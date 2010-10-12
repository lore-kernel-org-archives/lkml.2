Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0JLNUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:20:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:33193 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab0JLNUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:20:12 -0400
From: Michal Marek <mmarek@suse.cz>
To: randy.dunlap@oracle.com
Cc: catalin.marinas@arm.com, linux-kbuild@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lacombar@gmail.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH] Revert "kconfig: Temporarily disable dependency warnings"
Date: Tue, 12 Oct 2010 15:19:46 +0200
Message-Id: <1286889586-13483-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101011145930.11fe570c.randy.dunlap@oracle.com>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 71ebc01, which was a 2.6.36-only stopgap solution.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/symbol.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index cb00568..c0efe10 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -350,7 +350,6 @@ void sym_calc_value(struct symbol *sym)
 				}
 			}
 		calc_newval:
-#if 0
 			if (sym->dir_dep.tri == no && sym->rev_dep.tri != no) {
 				fprintf(stderr, "warning: (");
 				expr_fprint(sym->rev_dep.expr, stderr);
@@ -359,7 +358,6 @@ void sym_calc_value(struct symbol *sym)
 				expr_fprint(sym->dir_dep.expr, stderr);
 				fprintf(stderr, ")\n");
 			}
-#endif
 			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
 		}
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
-- 
1.7.1

