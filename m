Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030647Ab2HQHQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:16:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63439 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab2HQHQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:16:24 -0400
From: Adam Lee <adam8157@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz> (odd fixer:KCONFIG 
	,commit_signer:6/7=86%,commit_signer:2/4=50%),
        Yaakov Selkowitz <yselkowitz@users.sourceforge.net> (commit_signer:2/7=29%),
        Peter Foley <pefoley2@verizon.net> (commit_signer:1/7=14%),
        Steven Rostedt <rostedt@goodmis.org> (commit_signer:1/7=14% 
	,commit_signer:61/63=97%),
        Paul Bolle <pebolle@tiscali.nl> (commit_signer:1/7=14%),
        "Eric W. Biederman" <ebiederm@xmission.com> (commit_signer:2/4=50%),
        linux-kbuild@vger.kernel.org (open list:KCONFIG)
Subject: [PATCH] kconfig: replace 'oldnoconfig' with 'olddefconfig', what it really does
Date: Fri, 17 Aug 2012 15:16:13 +0800
Message-Id: <1345187778-19678-1-git-send-email-adam8157@gmail.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 67d34a6a391369269a2e5dba8a5f42cc4cd50231 said, 'oldnoconfig' doesn't
set new symbols to 'n', but instead sets it to their default values.

So, this patch replace 'oldnoconfig' with 'olddefconfig', stop making
people confused.

PS: the document in conf.c fixed in another mail, "[PATCH] [Signed-off]
kconfig: document oldnoconfig to what it really does in conf.c"

Signed-off-by: Adam Lee <adam8157@gmail.com>
---
 scripts/kconfig/Makefile     |  6 +++---
 scripts/kconfig/conf.c       | 18 +++++++++---------
 tools/testing/ktest/ktest.pl | 15 +++++++--------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 77d5399..15c69f2 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -76,9 +76,9 @@ PHONY += allnoconfig allyesconfig allmodconfig alldefconfig randconfig
 allnoconfig allyesconfig allmodconfig alldefconfig randconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
-PHONY += listnewconfig oldnoconfig savedefconfig defconfig
+PHONY += listnewconfig olddefconfig savedefconfig defconfig
 
-listnewconfig oldnoconfig: $(obj)/conf
+listnewconfig olddefconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
 
 savedefconfig: $(obj)/conf
@@ -114,7 +114,7 @@ help:
 	@echo  '  alldefconfig    - New config with all symbols set to default'
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  listnewconfig   - List new options'
-	@echo  '  oldnoconfig     - Same as silentoldconfig but sets new symbols to their default value'
+	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their default value'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 6875680..80d122f 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -32,7 +32,7 @@ enum input_mode {
 	defconfig,
 	savedefconfig,
 	listnewconfig,
-	oldnoconfig,
+	olddefconfig,
 } input_mode = oldaskconfig;
 
 static int indent = 1;
@@ -365,7 +365,7 @@ static void conf(struct menu *menu)
 		case P_MENU:
 			if ((input_mode == silentoldconfig ||
 			     input_mode == listnewconfig ||
-			     input_mode == oldnoconfig) &&
+			     input_mode == olddefconfig) &&
 			    rootEntry != menu) {
 				check_conf(menu);
 				return;
@@ -429,7 +429,7 @@ static void check_conf(struct menu *menu)
 				if (sym->name && !sym_is_choice_value(sym)) {
 					printf("%s%s\n", CONFIG_, sym->name);
 				}
-			} else if (input_mode != oldnoconfig) {
+			} else if (input_mode != olddefconfig) {
 				if (!conf_cnt++)
 					printf(_("*\n* Restart config...\n*\n"));
 				rootEntry = menu_get_parent_menu(menu);
@@ -454,7 +454,7 @@ static struct option long_opts[] = {
 	{"alldefconfig",    no_argument,       NULL, alldefconfig},
 	{"randconfig",      no_argument,       NULL, randconfig},
 	{"listnewconfig",   no_argument,       NULL, listnewconfig},
-	{"oldnoconfig",     no_argument,       NULL, oldnoconfig},
+	{"olddefconfig",    no_argument,       NULL, olddefconfig},
 	{NULL, 0, NULL, 0}
 };
 
@@ -467,7 +467,7 @@ static void conf_usage(const char *progname)
 	printf("  --oldaskconfig          Start a new configuration using a line-oriented program\n");
 	printf("  --oldconfig             Update a configuration using a provided .config as base\n");
 	printf("  --silentoldconfig       Same as oldconfig, but quietly, additionally update deps\n");
-	printf("  --oldnoconfig           Same as silentoldconfig but sets new symbols to their default value\n");
+	printf("  --olddefconfig          Same as silentoldconfig but sets new symbols to their default value\n");
 	printf("  --defconfig <file>      New config with default defined in <file>\n");
 	printf("  --savedefconfig <file>  Save the minimal current configuration to <file>\n");
 	printf("  --allnoconfig           New config where all options are answered with no\n");
@@ -520,7 +520,7 @@ int main(int ac, char **av)
 		case allmodconfig:
 		case alldefconfig:
 		case listnewconfig:
-		case oldnoconfig:
+		case olddefconfig:
 			break;
 		case '?':
 			conf_usage(progname);
@@ -565,7 +565,7 @@ int main(int ac, char **av)
 	case oldaskconfig:
 	case oldconfig:
 	case listnewconfig:
-	case oldnoconfig:
+	case olddefconfig:
 		conf_read(NULL);
 		break;
 	case allnoconfig:
@@ -645,7 +645,7 @@ int main(int ac, char **av)
 		/* fall through */
 	case oldconfig:
 	case listnewconfig:
-	case oldnoconfig:
+	case olddefconfig:
 	case silentoldconfig:
 		/* Update until a loop caused no more changes */
 		do {
@@ -653,7 +653,7 @@ int main(int ac, char **av)
 			check_conf(&rootmenu);
 		} while (conf_cnt &&
 			 (input_mode != listnewconfig &&
-			  input_mode != oldnoconfig));
+			  input_mode != olddefconfig));
 		break;
 	}
 
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 52b7959..0ed73b5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1871,10 +1871,10 @@ sub make_oldconfig {
 	apply_min_config;
     }
 
-    if (!run_command "$make oldnoconfig") {
-	# Perhaps oldnoconfig doesn't exist in this version of the kernel
+    if (!run_command "$make olddefconfig") {
+	# Perhaps olddefconfig doesn't exist in this version of the kernel
 	# try a yes '' | oldconfig
-	doprint "oldnoconfig failed, trying yes '' | make oldconfig\n";
+	doprint "olddefconfig failed, trying yes '' | make oldconfig\n";
 	run_command "yes '' | $make oldconfig" or
 	    dodie "failed make config oldconfig";
     }
@@ -1927,7 +1927,7 @@ sub build {
 
     # old config can ask questions
     if ($type eq "oldconfig") {
-	$type = "oldnoconfig";
+	$type = "olddefconfig";
 
 	# allow for empty configs
 	run_command "touch $output_config";
@@ -1957,7 +1957,7 @@ sub build {
 	load_force_config($minconfig);
     }
 
-    if ($type ne "oldnoconfig") {
+    if ($type ne "olddefconfig") {
 	run_command "$make $type" or
 	    dodie "failed make config";
     }
@@ -2456,8 +2456,7 @@ my %config_set;
 
 # config_off holds the set of configs that the bad config had disabled.
 # We need to record them and set them in the .config when running
-# oldnoconfig, because oldnoconfig does not turn off new symbols, but
-# instead just keeps the defaults.
+# olddefconfig, because olddefconfig keeps the defaults.
 my %config_off;
 
 # config_off_tmp holds a set of configs to turn off for now
@@ -3248,7 +3247,7 @@ sub test_this_config {
     }
 
     # Remove this config from the list of configs
-    # do a make oldnoconfig and then read the resulting
+    # do a make olddefconfig and then read the resulting
     # .config to make sure it is missing the config that
     # we had before
     my %configs = %min_configs;
-- 
1.7.11.2

