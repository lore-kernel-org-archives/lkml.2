Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2HGHCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:02:36 -0400
Received: from www17.your-server.de ([213.133.104.17]:54273 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2HGHCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:02:34 -0400
Subject: [PATCH] drm/exynos: Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(.. [1]
From: Thomas Meyer <thomas@m3y3r.de>
To: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 07 Aug 2012 08:57:25 +0200
Message-ID: <1344322645.14513.122.camel@localhost.localdomain>
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/err_cast.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/gpu/drm/exynos/exynos_drm_gem.c b/drivers/gpu/drm/exynos/exynos_drm_gem.c
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -122,7 +122,7 @@ fail:
 		__free_page(pages[i]);
 
 	drm_free_large(pages);
-	return ERR_PTR(PTR_ERR(p));
+	return ERR_CAST(p);
 }
 
 static void exynos_gem_put_pages(struct drm_gem_object *obj,
