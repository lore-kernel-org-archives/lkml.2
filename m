Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1DEO7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:59:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:44431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1DEO73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:29 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/34] kconfig: Do not record timestamp in auto.conf and autoconf.h
Date: Tue,  5 Apr 2011 16:58:48 +0200
Message-Id: <1302015561-21047-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timestamps in file data are useless and there is already one in .config

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/kconfig/confdata.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 61c35bf..834eecb 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -784,7 +784,6 @@ int conf_write_autoconf(void)
 	const char *str;
 	const char *name;
 	FILE *out, *tristate, *out_h;
-	time_t now;
 	int i;
 
 	sym_clear_all_valid();
@@ -811,22 +810,19 @@ int conf_write_autoconf(void)
 		return 1;
 	}
 
-	time(&now);
 	fprintf(out, "#\n"
 		     "# Automatically generated make config: don't edit\n"
 		     "# %s\n"
-		     "# %s"
 		     "#\n",
-		     rootmenu.prompt->text, ctime(&now));
+		     rootmenu.prompt->text);
 	fprintf(tristate, "#\n"
 			  "# Automatically generated - do not edit\n"
 			  "\n");
 	fprintf(out_h, "/*\n"
 		       " * Automatically generated C config: don't edit\n"
 		       " * %s\n"
-		       " * %s"
 		       " */\n",
-		       rootmenu.prompt->text, ctime(&now));
+		       rootmenu.prompt->text);
 
 	for_all_symbols(i, sym) {
 		sym_calc_value(sym);
-- 
1.7.4.1

