Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab2CIAFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:09 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:47122 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab2CIAET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086950"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 15/17] staging: tidspbridge: remove gh_init() and gh_exit()
Date: Fri,  9 Mar 2012 01:03:50 +0100
Message-Id: <42a10f510859985692dfbf0a42658acd91568ac1.1331250369.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <cover.1331250368.git.vjaquez@igalia.com>
References: <cover.1331250368.git.vjaquez@igalia.com>
In-Reply-To: <cover.1331250368.git.vjaquez@igalia.com>
References: <cover.1331250368.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gh module has a gh_init() and a gh_exit(), but they don't do
anything, they are just noops.

This patch removes these functions.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/gen/gh.c               |   18 ------------------
 drivers/staging/tidspbridge/include/dspbridge/gh.h |    2 --
 drivers/staging/tidspbridge/pmgr/dbll.c            |   12 ++----------
 3 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/tidspbridge/gen/gh.c b/drivers/staging/tidspbridge/gen/gh.c
index 60aa7b0..25eaef7 100644
--- a/drivers/staging/tidspbridge/gen/gh.c
+++ b/drivers/staging/tidspbridge/gen/gh.c
@@ -95,15 +95,6 @@ void gh_delete(struct gh_t_hash_tab *hash_tab)
 }
 
 /*
- *  ======== gh_exit ========
- */
-
-void gh_exit(void)
-{
-	/* Do nothing */
-}
-
-/*
  *  ======== gh_find ========
  */
 
@@ -122,15 +113,6 @@ void *gh_find(struct gh_t_hash_tab *hash_tab, void *key)
 }
 
 /*
- *  ======== gh_init ========
- */
-
-void gh_init(void)
-{
-	/* Do nothing */
-}
-
-/*
  *  ======== gh_insert ========
  */
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/gh.h b/drivers/staging/tidspbridge/include/dspbridge/gh.h
index 9de291d..da85079 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/gh.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/gh.h
@@ -23,9 +23,7 @@ extern struct gh_t_hash_tab *gh_create(u16 max_bucket, u16 val_size,
 				       bool(*match) (void *, void *),
 				       void (*delete) (void *));
 extern void gh_delete(struct gh_t_hash_tab *hash_tab);
-extern void gh_exit(void);
 extern void *gh_find(struct gh_t_hash_tab *hash_tab, void *key);
-extern void gh_init(void);
 extern void *gh_insert(struct gh_t_hash_tab *hash_tab, void *key, void *value);
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 void gh_iterate(struct gh_t_hash_tab *hash_tab,
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 071ee86..9f07036 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -187,8 +187,6 @@ static u16 name_hash(void *key, u16 max_bucket);
 static bool name_match(void *key, void *sp);
 static void sym_delete(void *value);
 
-static u32 refs;		/* module reference count */
-
 /* Symbol Redefinition */
 static int redefined_symbol;
 static int gbl_search = 1;
@@ -268,10 +266,7 @@ void dbll_delete(struct dbll_tar_obj *target)
  */
 void dbll_exit(void)
 {
-	refs--;
-
-	if (refs == 0)
-		gh_exit();
+	/* do nothing */
 }
 
 /*
@@ -394,10 +389,7 @@ int dbll_get_sect(struct dbll_library_obj *lib, char *name, u32 *paddr,
  */
 bool dbll_init(void)
 {
-	if (refs == 0)
-		gh_init();
-
-	refs++;
+	/* do nothing */
 
 	return true;
 }
-- 
1.7.9.1

