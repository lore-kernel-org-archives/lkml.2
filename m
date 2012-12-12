Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab2LLNyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 08:54:14 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52803 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LLNyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 08:54:12 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: bskeggs@redhat.com, dri-devel@lists.freedesktops.org, airlied@linux.ie,
        kernel-janitors@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: nouveau: Bool tests don't need comparison
Date: Wed, 12 Dec 2012 14:54:10 +0100
Message-Id: <1355320451-23292-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Bool initializations should use true and false.  Bool tests don't need
 comparisons.  Based on contributions from Joe Perches, Rusty Russell
 and Bruce W Allan.

 The semantic patch that makes this output is available
 in scripts/coccinelle/misc/boolinit.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpu/drm/nouveau/core/subdev/timer/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/timer/base.c b/drivers/gpu/drm/nouveau/core/subdev/timer/base.c
index 5d417cc..de6d6b7 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/timer/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/timer/base.c
@@ -72,7 +72,7 @@ nouveau_timer_wait_cb(void *obj, u64 nsec, bool (*func)(void *), void *data)
 
 	time0 = ptimer->read(ptimer);
 	do {
-		if (func(data) == true)
+		if (func(data))
 			return true;
 	} while (ptimer->read(ptimer) - time0 < nsec);
 
-- 
1.7.10.4

