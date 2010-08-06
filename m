Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935132Ab0HFUor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:44:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:43663 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935078Ab0HFUoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:44:44 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/1] console: Fix compilation regression
Date: Fri,  6 Aug 2010 15:43:42 -0500
Message-Id: <1281127422-15689-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281127422-15689-1-git-send-email-jason.wessel@windriver.com>
References: <1281127422-15689-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 06 Aug 2010 20:44:27.0433 (UTC) FILETIME=[2953D990:01CB35A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A regression of building without CONFIG_HW_CONSOLE was introduced with
commit b45cfba4e9005d64d419718e7ff7f7cab44c1994 (vt,console,kdb:
implement atomic console enter/leave functions).

ERROR: "con_debug_enter" [drivers/serial/kgdboc.ko] undefined!
ERROR: "vc_cons" [drivers/serial/kgdboc.ko] undefined!
ERROR: "fg_console" [drivers/serial/kgdboc.ko] undefined!
ERROR: "con_debug_leave" [drivers/serial/kgdboc.ko] undefined!

When there is no HW console the con_debug_enter and con_debug_leave
functions should have no code.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 include/linux/console.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/console.h b/include/linux/console.h
index f76fc29..95cf6f0 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -79,8 +79,13 @@ int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
 int take_over_console(const struct consw *sw, int first, int last, int deflt);
 void give_up_console(const struct consw *sw);
+#ifdef CONFIG_HW_CONSOLE
 int con_debug_enter(struct vc_data *vc);
 int con_debug_leave(void);
+#else
+#define con_debug_enter(vc) (0)
+#define con_debug_leave() (0)
+#endif
 
 /* scroll */
 #define SM_UP       (1)
-- 
1.6.3.3

