Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2FTSVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:21:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab2FTSVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:15 -0400
Message-Id: <20120620173021.681022406@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 08/61] drm sis: initialize object_idr
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Márton Németh <nm127@freemail.hu>

commit 648ccc7d35e3416fdc739d2e520e85de3125361b upstream.

The filed object_idr of struct drm_sis_private was introduced with
commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=6de8a748881f1cd9d795454da2b6db616d5ca3d7 .

The idr_init(&dev->object_name_idr) is called instead of
idr_init(&dev_priv->object_idr) by mistake, leaving object_idr
uninitialized. Correct this.

This patch was not tested because of lack of hardware.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/sis/sis_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -47,9 +47,9 @@ static int sis_driver_load(struct drm_de
 	if (dev_priv == NULL)
 		return -ENOMEM;
 
+	idr_init(&dev_priv->object_idr);
 	dev->dev_private = (void *)dev_priv;
 	dev_priv->chipset = chipset;
-	idr_init(&dev->object_name_idr);
 
 	return 0;
 }


