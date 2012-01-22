Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2AVTCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:02:47 -0500
Received: from www17.your-server.de ([213.133.104.17]:46614 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2AVTCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:02:46 -0500
Subject: [PATCH] drm/omap: Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(..
From: Thomas Meyer <thomas@m3y3r.de>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Sun, 22 Jan 2012 18:27:21 +0100
Message-ID: <1327253241.1434.43.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
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

diff -u -p a/drivers/staging/omapdrm/omap_gem_helpers.c b/drivers/staging/omapdrm/omap_gem_helpers.c
--- a/drivers/staging/omapdrm/omap_gem_helpers.c 2012-01-10 08:19:54.879656961 +0100
+++ b/drivers/staging/omapdrm/omap_gem_helpers.c 2012-01-22 09:56:56.915880561 +0100
@@ -84,7 +84,7 @@ fail:
 		page_cache_release(pages[i]);
 	}
 	drm_free_large(pages);
-	return ERR_PTR(PTR_ERR(p));
+	return ERR_CAST(p);
 }
 
 /**
