Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2HSDBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:60723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab2HSC5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415462"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 66/74] Kbuild, lto: Handle basic LTO in modpost
Date: Sat, 18 Aug 2012 19:57:02 -0700
Message-Id: <1345345030-22211-67-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- Don't warn for __gnu_lto_* COMMON symbols
- Don't complain about .gnu.lto* sections

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/mod/modpost.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index ccd34ff..11fc5a6 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -600,7 +600,8 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
-		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
+		if (strncmp(symname, "__gnu_lto_", sizeof("__gnu_lto_")-1))
+			warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
 		break;
 	case SHN_ABS:
 		/* CRC'd symbol */
@@ -827,6 +828,7 @@ static const char *section_white_list[] =
 	".note*",
 	".got*",
 	".toc*",
+	".gnu.lto*",
 	NULL
 };
 
-- 
1.7.7.6

