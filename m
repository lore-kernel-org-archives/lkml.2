Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2A3LGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:06:05 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60705 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab2A3LGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:06:03 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/gpu/drm/drm_ioc32.c: initialize all fields
Date: Mon, 30 Jan 2012 12:05:55 +0100
Message-Id: <1327921555-7862-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1327921555-7862-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1327921555-7862-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The c32 structure is allocated on the stack and its idx field is not
initialized before copying it to user level.  This patch takes the value
from the result of the ioctl, as done for the other fields.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
An alternative would be to change the earlier code

        if (get_user(idx, &argp->idx))
                return -EFAULT;

to write into the c32 structure, rather than into the local idx variable.
This would be more similar to what is done in compat_drm_version.

 drivers/gpu/drm/drm_ioc32.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index ddd70db..637fcc3 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -315,7 +315,8 @@ static int compat_drm_getclient(struct file *file, unsigned int cmd,
 	if (err)
 		return err;
 
-	if (__get_user(c32.auth, &client->auth)
+	if (__get_user(c32.idx, &client->idx)
+	    || __get_user(c32.auth, &client->auth)
 	    || __get_user(c32.pid, &client->pid)
 	    || __get_user(c32.uid, &client->uid)
 	    || __get_user(c32.magic, &client->magic)

