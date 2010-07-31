Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0GaVbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 17:31:55 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:32983 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0GaVbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 17:31:52 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Aristeu Rozanski <aris@redhat.com>
Subject: [PATCH] kconfig: rename loose_nonint_oldconfig => oldnoconfig
Date: Sat, 31 Jul 2010 23:31:43 +0200
Message-Id: <1280611910-8155-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20100731212907.GA7554@merkur.ravnborg.org>
References: <20100731212907.GA7554@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename target to something that fall more in line
with the other kconfig targets.

oldnoconfig shall read as:

- read the old configuration and set all new options to no

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Aristeu Rozanski <aris@redhat.com>
---
 scripts/kconfig/Makefile |    7 +++----
 scripts/kconfig/conf.c   |   14 +++++++-------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index b712bdb..0e3c670 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -100,9 +100,9 @@ PHONY += allnoconfig allyesconfig allmodconfig randconfig
 allnoconfig allyesconfig allmodconfig randconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
-PHONY += nonint_oldconfig loose_nonint_oldconfig defconfig
+PHONY += nonint_oldconfig oldnoconfig defconfig
 
-nonint_oldconfig loose_nonint_oldconfig: $(obj)/conf
+nonint_oldconfig oldnoconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 defconfig: $(obj)/conf
@@ -134,8 +134,7 @@ help:
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
 	@echo  '  nonint_oldconfig - Checks the current configuration and fails if an option is '
 	@echo  '                    not set'
-	@echo  '  loose_nonint_oldconfig - Same as nonint_oldconfig, but updates the config file with '
-	@echo  '                    missing config options as unset'
+	@echo  '  oldnoconfig     - Same as silentoldconfig but set new symbols to n (unset)'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 2dec584..1f86fca 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -34,7 +34,7 @@ enum input_mode {
 	randconfig,
 	defconfig,
 	nonint_oldconfig,
-	loose_nonint_oldconfig,
+	oldnoconfig,
 } input_mode = oldaskconfig;
 
 char *defconfig_file;
@@ -367,7 +367,7 @@ static void conf(struct menu *menu)
 		case P_MENU:
 			if ((input_mode == silentoldconfig ||
 			     input_mode == nonint_oldconfig ||
-			     input_mode == loose_nonint_oldconfig) &&
+			     input_mode == oldnoconfig) &&
 			    rootEntry != menu) {
 				check_conf(menu);
 				return;
@@ -427,7 +427,7 @@ static void check_conf(struct menu *menu)
 		if (sym_is_changable(sym) ||
 		    (sym_is_choice(sym) && sym_get_tristate_value(sym) == yes)) {
 			if (input_mode == nonint_oldconfig ||
-			    input_mode == loose_nonint_oldconfig) {
+			    input_mode == oldnoconfig) {
 				if (input_mode == nonint_oldconfig &&
 				    sym->name && !sym_is_choice_value(sym)) {
 					if (!unset_variables)
@@ -460,7 +460,7 @@ static struct option long_opts[] = {
 	{"allmodconfig",    no_argument,       NULL, allmodconfig},
 	{"randconfig",      no_argument,       NULL, randconfig},
 	{"nonint_oldconfig",       no_argument, NULL, nonint_oldconfig},
-	{"loose_nonint_oldconfig", no_argument, NULL, loose_nonint_oldconfig},
+	{"oldnoconfig",     no_argument,       NULL, oldnoconfig},
 	{NULL, 0, NULL, 0}
 };
 
@@ -540,7 +540,7 @@ int main(int ac, char **av)
 	case oldaskconfig:
 	case oldconfig:
 	case nonint_oldconfig:
-	case loose_nonint_oldconfig:
+	case oldnoconfig:
 		conf_read(NULL);
 		break;
 	case allnoconfig:
@@ -603,7 +603,7 @@ int main(int ac, char **av)
 		input_mode = silentoldconfig;
 		/* fall through */
 	case nonint_oldconfig:
-	case loose_nonint_oldconfig:
+	case oldnoconfig:
 	case silentoldconfig:
 		/* Update until a loop caused no more changes */
 		do {
@@ -611,7 +611,7 @@ int main(int ac, char **av)
 			check_conf(&rootmenu);
 		} while (conf_cnt &&
 			 (input_mode != nonint_oldconfig &&
-			  input_mode != loose_nonint_oldconfig));
+			  input_mode != oldnoconfig));
 		break;
 	}
 
-- 
1.6.0.6

