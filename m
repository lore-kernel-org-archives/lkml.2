Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab2CIAFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:05:06 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:31437 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab2CIAES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYozgmQ
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086949"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 16/17] staging: tidspbridge: remove ref counting in nldr.c
Date: Fri,  9 Mar 2012 01:03:51 +0100
Message-Id: <8aa8c3bd7d5450a3d73c63af6eebfd3fd642ce59.1331250369.git.vjaquez@igalia.com>
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

The nldr module has a nldr_init() and a nldr_exit() whose only purpose
is to keep a reference counting which is not used at all.

This patch only removes the reference count variable, but not the
functions, because they are used through an interface.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/rmgr/nldr.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index a9d7a32..46086b5 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -263,8 +263,6 @@ static struct dbll_fxns ldr_fxns = {
 	(dbll_unload_fxn) dbll_unload,
 };
 
-static u32 refs;		/* module reference count */
-
 static int add_ovly_info(void *handle, struct dbll_sect_info *sect_info,
 				u32 addr, u32 bytes);
 static int add_ovly_node(struct dsp_uuid *uuid_obj,
@@ -627,7 +625,7 @@ void nldr_delete(struct nldr_object *nldr_obj)
  */
 void nldr_exit(void)
 {
-	refs--;
+	/* do nothing */
 }
 
 /*
@@ -743,8 +741,7 @@ int nldr_get_rmm_manager(struct nldr_object *nldr,
  */
 bool nldr_init(void)
 {
-	refs++;
-
+	/* do nothing */
 	return true;
 }
 
-- 
1.7.9.1

