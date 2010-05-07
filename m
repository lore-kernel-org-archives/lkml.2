Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0EGF4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:56:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60284 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab0EGFz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:55:59 -0400
Message-ID: <4BE3ABDD.7010101@cn.fujitsu.com>
Date: Fri, 07 May 2010 13:57:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/8] gconfig: fix null pointer warning
References: <4BE3AB91.80606@cn.fujitsu.com>
In-Reply-To: <4BE3AB91.80606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gconfig if you enable "Show all options", you'll see some "(null)"
config options, and clicking those options triggers a warning:

(gconf:9368): Gtk-CRITICAL **: gtk_text_buffer_insert_with_tags: assertion `text != NULL' failed

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kconfig/gconf.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index 1b18329..d669882 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1343,7 +1343,8 @@ static void update_tree(struct menu *src, GtkTreeIter * dst)
 #endif
 
 		if ((opt_mode == OPT_NORMAL && !menu_is_visible(child1)) ||
-		    (opt_mode == OPT_PROMPT && !menu_has_prompt(child1))) {
+		    (opt_mode == OPT_PROMPT && !menu_has_prompt(child1)) ||
+		    (opt_mode == OPT_ALL    && !menu_get_prompt(child1))) {
 
 			/* remove node */
 			if (gtktree_iter_find_node(dst, menu1) != NULL) {
@@ -1425,7 +1426,7 @@ static void display_tree(struct menu *menu)
 
 		if ((opt_mode == OPT_NORMAL && menu_is_visible(child)) ||
 		    (opt_mode == OPT_PROMPT && menu_has_prompt(child)) ||
-		    (opt_mode == OPT_ALL))
+		    (opt_mode == OPT_ALL    && menu_get_prompt(child)))
 			place_node(child, fill_row(child));
 #ifdef DEBUG
 		printf("%*c%s: ", indent, ' ', menu_get_prompt(child));
-- 
1.6.3

