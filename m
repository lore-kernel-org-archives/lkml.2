Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0GYViu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:38:50 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:54791 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0GYVis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:38:48 -0400
Date: Sun, 25 Jul 2010 23:38:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/4] kconfig: save location of config symbols
Message-ID: <20100725213846.GA5834@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100725213808.GA5814@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f427c3886d7916ad8c6575964a753a33507d9f2e Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 24 Jul 2010 20:17:33 +0200
Subject: [PATCH 1/4] kconfig: save location of config symbols

When we add a new config symbol save the file/line
so we later can refer to their location.

The information is saved as a property to a config symbol
because we may have multiple definitions of the same symbol.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/expr.h   |    1 +
 scripts/kconfig/menu.c   |    2 ++
 scripts/kconfig/symbol.c |    2 ++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 891cd9c..4526a58 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -131,6 +131,7 @@ enum prop_type {
 	P_SELECT,   /* select BAR */
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_ENV,      /* value from environment variable */
+	P_SYMBOL,   /* where a symbol is defined */
 };
 
 struct property {
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 203632c..6400823 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -58,6 +58,8 @@ void menu_add_entry(struct symbol *sym)
 	*last_entry_ptr = menu;
 	last_entry_ptr = &menu->next;
 	current_entry = menu;
+	if (sym)
+		menu_add_prop(P_SYMBOL, NULL, NULL, NULL);
 }
 
 void menu_end_entry(void)
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 2e7a048..de36f3e 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -943,6 +943,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "select";
 	case P_RANGE:
 		return "range";
+	case P_SYMBOL:
+		return "symbol";
 	case P_UNKNOWN:
 		break;
 	}
-- 
1.6.0.6

