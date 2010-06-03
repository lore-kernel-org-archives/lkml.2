Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab0FCHWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:22:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61070 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab0FCHWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:22:30 -0400
Message-ID: <4C0758C9.7080108@cn.fujitsu.com>
Date: Thu, 03 Jun 2010 15:24:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Nobin Mathew <nobin.mathew@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] menuconfig: truncate list items
References: <4C0758B7.5070907@cn.fujitsu.com>
In-Reply-To: <4C0758B7.5070907@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Truncate list items to fit in a single line, otherwise those items
which have long prompts will cover some other items.

This follows the behavior of menubox.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/lxdialog/checklist.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lxdialog/checklist.c b/scripts/kconfig/lxdialog/checklist.c
index c92a05a..a2eb80f 100644
--- a/scripts/kconfig/lxdialog/checklist.c
+++ b/scripts/kconfig/lxdialog/checklist.c
@@ -31,6 +31,10 @@ static int list_width, check_x, item_x;
 static void print_item(WINDOW * win, int choice, int selected)
 {
 	int i;
+	char *list_item = malloc(list_width + 1);
+
+	strncpy(list_item, item_str(), list_width - item_x);
+	list_item[list_width - item_x] = '\0';
 
 	/* Clear 'residue' of last item */
 	wattrset(win, dlg.menubox.atr);
@@ -45,13 +49,14 @@ static void print_item(WINDOW * win, int choice, int selected)
 		wprintw(win, "(%c)", item_is_tag('X') ? 'X' : ' ');
 
 	wattrset(win, selected ? dlg.tag_selected.atr : dlg.tag.atr);
-	mvwaddch(win, choice, item_x, item_str()[0]);
+	mvwaddch(win, choice, item_x, list_item[0]);
 	wattrset(win, selected ? dlg.item_selected.atr : dlg.item.atr);
-	waddstr(win, (char *)item_str() + 1);
+	waddstr(win, list_item + 1);
 	if (selected) {
 		wmove(win, choice, check_x + 1);
 		wrefresh(win);
 	}
+	free(list_item);
 }
 
 /*
-- 
1.6.3
