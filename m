Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab2I1VWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:22:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964851Ab2I1UaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 162/218] drm/nouveau: fix booting with plymouth + dumb support
Date: Fri, 28 Sep 2012 13:16:19 -0700
Message-Id: <20120928201520.134970182@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 610bd7da160f76f1644ecb4cd7f39511b49a22cc upstream.

We noticed a plymouth bug on Fedora 18, and I then
noticed this stupid thinko, fixing it fixed the problem
with plymouth.

Acked-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -586,7 +586,7 @@ nouveau_display_dumb_create(struct drm_f
 	args->size = args->pitch * args->height;
 	args->size = roundup(args->size, PAGE_SIZE);
 
-	ret = nouveau_gem_new(dev, args->size, 0, TTM_PL_FLAG_VRAM, 0, 0, &bo);
+	ret = nouveau_gem_new(dev, args->size, 0, NOUVEAU_GEM_DOMAIN_VRAM, 0, 0, &bo);
 	if (ret)
 		return ret;
 


