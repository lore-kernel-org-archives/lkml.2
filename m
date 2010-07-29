Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0G2IPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 04:15:44 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44610 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0G2IPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 04:15:41 -0400
Date: Thu, 29 Jul 2010 10:15:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>,
        Aristeu Rozanski <aris@redhat.com>
Subject: [PATCH 1/2] kconfig: rename loose_nonint_oldconfig => oldnoconfig
Message-ID: <20100729081539.GA5157@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <20100729081316.GA4990@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729081316.GA4990@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a76c17f4fa213ad68227456374be6c84c825c3a5 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 29 Jul 2010 09:34:43 +0200
Subject: [PATCH 1/2] kconfig: rename loose_nonint_oldconfig => oldnoconfig

Rename target to something that fall more in line
with the other kconfig targets.

oldnoconfig shall read as:

- read the old configuration and set all new options to no

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Aristeu Rozanski <aris@redhat.com>
---
 scripts/kconfig/Makefile |    9 ++++-----
 scripts/kconfig/conf.c   |   14 +++++++-------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index ed3f157..6c71306 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -3,7 +3,7 @@
 # These targets are used from top-level makefile
 
 PHONY += oldconfig xconfig gconfig menuconfig config silentoldconfig update-po-config \
-	localmodconfig localyesconfig
+	localmodconfig localyesconfig oldnoconfig
 
 ifdef KBUILD_KCONFIG
 Kconfig := $(KBUILD_KCONFIG)
@@ -72,10 +72,10 @@ localyesconfig: $(obj)/streamline_config.pl $(obj)/conf
 	fi
 	$(Q)rm -f .tmp.config
 
-nonint_oldconfig: $(obj)/conf
+nonit_oldconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
-loose_nonint_oldconfig: $(obj)/conf
+oldnoconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 # Create new linux.pot file
@@ -138,8 +138,7 @@ help:
 	@echo  '  allnoconfig	  - New config where all options are answered with no'
 	@echo  '  nonint_oldconfig - Checks the current configuration and fails if an option is '
 	@echo  '                    not set'
-	@echo  '  loose_nonint_oldconfig - Same as nonint_oldconfig, but updates the config file with '
-	@echo  '                    missing config options as unset'
+	@echo  '  oldnoconfig     - Same as silentoldconfig but set new symbols to n (unset)'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 36bd331..3c8f31b 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -35,7 +35,7 @@ enum input_mode {
 	defconfig,
 	readdefconfig,
 	nonint_oldconfig,
-	loose_nonint_oldconfig,
+	oldnoconfig,
 } input_mode = oldaskconfig;
 
 char *defconfig_file;
@@ -368,7 +368,7 @@ static void conf(struct menu *menu)
 		case P_MENU:
 			if ((input_mode == silentoldconfig ||
 			     input_mode == nonint_oldconfig ||
-			     input_mode == loose_nonint_oldconfig) &&
+			     input_mode == oldnoconfig) &&
 			    rootEntry != menu) {
 				check_conf(menu);
 				return;
@@ -428,7 +428,7 @@ static void check_conf(struct menu *menu)
 		if (sym_is_changable(sym) ||
 		    (sym_is_choice(sym) && sym_get_tristate_value(sym) == yes)) {
 			if (input_mode == nonint_oldconfig ||
-			    input_mode == loose_nonint_oldconfig) {
+			    input_mode == oldnoconfig) {
 				if (input_mode == nonint_oldconfig &&
 				    sym->name && !sym_is_choice_value(sym)) {
 					if (!unset_variables)
@@ -462,7 +462,7 @@ static struct option long_opts[] = {
 	{"allmodconfig",    no_argument,       NULL, allmodconfig},
 	{"allrandconfig",   no_argument,       NULL, allrandconfig},
 	{"nonint_oldconfig",       no_argument, NULL, nonint_oldconfig},
-	{"loose_nonint_oldconfig", no_argument, NULL, loose_nonint_oldconfig},
+	{"oldnoconfig",     no_argument,       NULL, oldnoconfig},
 	{NULL, 0, NULL, 0}
 };
 
@@ -543,7 +543,7 @@ int main(int ac, char **av)
 	case oldaskconfig:
 	case oldconfig:
 	case nonint_oldconfig:
-	case loose_nonint_oldconfig:
+	case oldnoconfig:
 		conf_read(NULL);
 		break;
 	case allnoconfig:
@@ -607,7 +607,7 @@ int main(int ac, char **av)
 		input_mode = silentoldconfig;
 		/* fall through */
 	case nonint_oldconfig:
-	case loose_nonint_oldconfig:
+	case oldnoconfig:
 	case silentoldconfig:
 		/* Update until a loop caused no more changes */
 		do {
@@ -615,7 +615,7 @@ int main(int ac, char **av)
 			check_conf(&rootmenu);
 		} while (conf_cnt &&
 			 (input_mode != nonint_oldconfig &&
-			  input_mode != loose_nonint_oldconfig));
+			  input_mode != oldnoconfig));
 		break;
 	}
 
-- 
1.6.0.6

