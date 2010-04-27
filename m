Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0D0Hq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:46:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab0D0Hq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:46:57 -0400
Message-ID: <4BD696DF.70100@cn.fujitsu.com>
Date: Tue, 27 Apr 2010 15:48:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH 3/6] gconfig: fix to tag NEW symbols correctly
References: <4BD696C0.8050500@cn.fujitsu.com>
In-Reply-To: <4BD696C0.8050500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic should be reversed.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/gconf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index bef1041..1b18329 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -1114,7 +1114,7 @@ static gchar **fill_row(struct menu *menu)
 
 	row[COL_OPTION] =
 	    g_strdup_printf("%s %s", _(menu_get_prompt(menu)),
-			    sym && sym_has_value(sym) ? "(NEW)" : "");
+			    sym && !sym_has_value(sym) ? "(NEW)" : "");
 
 	if (opt_mode == OPT_ALL && !menu_is_visible(menu))
 		row[COL_COLOR] = g_strdup("DarkGray");
-- 
1.6.3
