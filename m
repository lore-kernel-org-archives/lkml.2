Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab1FIWs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:48:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55353 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab1FIWs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=CW3HOzKjn/hlERQqQI8QCHwsl29/4lWmuMjwtXgJKknslufzCmUaYeBduT0rs3WQeA
         ze4V3h8u1DehyciSKfhcQcX9wzx+pghk7kPK7/4zNH671jei5AVK6XRyhcNx2/PlNoVe
         k60ahveoWo4pF1eQeLOjuIwcDRoCZgFAd959M=
Date: Thu, 9 Jun 2011 18:18:39 -0400
From: Jay Estabrook <jay.estabrook@gmail.com>
To: linux-alpha <linux-alpha@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Cc: Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Jay Estabrook <jay.estabrook@gmail.com>, airlied@linux.ie
Subject: [PATCH 1/3] alpha, drm: Cleanup Alpha support in DRM generic code
Message-ID: <20110609181839.7ca8838a.jay.estabrook_gmail.com@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; alpha-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove an obsolete Alpha adjustment, and modify another,
to go with the current Alpha architecture support.

Signed-off-by: Jay Estabrook <jay.estabrook@gmail.com>
---
 drivers/gpu/drm/drm_bufs.c    |    3 ---
 drivers/gpu/drm/drm_vm.c      |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff -Naurp a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
--- a/drivers/gpu/drm/drm_bufs.c	2011-04-26 23:48:50.000000000 -0400
+++ b/drivers/gpu/drm/drm_bufs.c	2011-05-02 11:51:48.000000000 -0400
@@ -183,9 +183,6 @@ static int drm_addmap_core(struct drm_de
 			return -EINVAL;
 		}
 #endif
-#ifdef __alpha__
-		map->offset += dev->hose->mem_space->start;
-#endif
 		/* Some drivers preinitialize some maps, without the X Server
 		 * needing to be aware of it.  Therefore, we just return success
 		 * when the server tries to create a duplicate map.
diff -Naurp a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
--- a/drivers/gpu/drm/drm_vm.c	2011-04-26 23:48:50.000000000 -0400
+++ b/drivers/gpu/drm/drm_vm.c	2011-05-02 11:51:48.000000000 -0400
@@ -526,7 +526,7 @@ static int drm_mmap_dma(struct file *fil
 static resource_size_t drm_core_get_reg_ofs(struct drm_device *dev)
 {
 #ifdef __alpha__
-	return dev->hose->dense_mem_base - dev->hose->mem_space->start;
+	return dev->hose->dense_mem_base;
 #else
 	return 0;
 #endif

---
