Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab0DNDmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:42:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58047 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab0DNDmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:42:37 -0400
Message-ID: <4BC53A05.2040908@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:44:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 1/6] kconfig: some small fixes
References: <4BC539DD.5040003@cn.fujitsu.com>
In-Reply-To: <4BC539DD.5040003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- fix a typo in documentation
- fix a typo in a printk on error
- fix comments in dialog_inputbox()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/kbuild/kconfig-language.txt |    2 +-
 scripts/kconfig/lxdialog/inputbox.c       |    4 ++--
 scripts/kconfig/menu.c                    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index c412c24..b472e4e 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -181,7 +181,7 @@ Expressions are listed in decreasing order of precedence.
 (7) Returns the result of max(/expr/, /expr/).
 
 An expression can have a value of 'n', 'm' or 'y' (or 0, 1, 2
-respectively for calculations). A menu entry becomes visible when it's
+respectively for calculations). A menu entry becomes visible when its
 expression evaluates to 'm' or 'y'.
 
 There are two types of symbols: constant and non-constant symbols.
diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index 616c601..dd8e587 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -180,7 +180,7 @@ do_resize:
 		case KEY_LEFT:
 			switch (button) {
 			case -1:
-				button = 1;	/* Indicates "Cancel" button is selected */
+				button = 1;	/* Indicates "Help" button is selected */
 				print_buttons(dialog, height, width, 1);
 				break;
 			case 0:
@@ -204,7 +204,7 @@ do_resize:
 				print_buttons(dialog, height, width, 0);
 				break;
 			case 0:
-				button = 1;	/* Indicates "Cancel" button is selected */
+				button = 1;	/* Indicates "Help" button is selected */
 				print_buttons(dialog, height, width, 1);
 				break;
 			case 1:
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 059a246..6761055 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -197,7 +197,7 @@ static void sym_check_prop(struct symbol *sym)
 			if ((sym->type == S_STRING || sym->type == S_INT || sym->type == S_HEX) &&
 			    prop->expr->type != E_SYMBOL)
 				prop_warn(prop,
-				    "default for config symbol '%'"
+				    "default for config symbol '%s'"
 				    " must be a single symbol", sym->name);
 			break;
 		case P_SELECT:
-- 
1.6.3

