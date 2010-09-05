Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0IEScz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:32:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60131 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0IEScw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SWsFQdQEf/YTb0uICTmHQ5METXMlOJwz3UxJtK51fVamKTa83FqKi2+3HSWuzE0q7a
         6rueLaZ0IlZUcOWOnLxq0u5xLYRSBuslpDh9nwaOlPs2BESMMpwAMN3bxjRKyPyS9SGU
         2ByEI7VVQn5SZq8HTdbjKKDBmzAbV+sYqjVd4=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ernesto Ramos <ernesto@ti.com>, Nishanth Menon <nm@ti.com>,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] staging: tidspbridge: check return code of get_user
Date: Sun,  5 Sep 2010 22:32:45 +0400
Message-Id: <1283711565-7375-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function get_user may fail. Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I couldn't compile this driver at all, so it is not tested.

 drivers/staging/tidspbridge/pmgr/dspapi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index b23591b..faf8304 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -872,7 +872,11 @@ u32 procwrap_load(union trapped_args *args, void *pr_ctxt)
 		/* number of elements in the envp array including NULL */
 		count = 0;
 		do {
-			get_user(temp, args->args_proc_load.user_envp + count);
+			if (get_user(temp,
+				     args->args_proc_load.user_envp + count)) {
+				status = -EFAULT;
+				goto func_cont;
+			}
 			count++;
 		} while (temp);
 		envp = kmalloc(count * sizeof(u8 *), GFP_KERNEL);
-- 
1.7.0.4

