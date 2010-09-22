Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0IVQxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:53:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50229 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0IVQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=bDz2fJPWculbNTy3ryp13trNzadXaLDRmfYQqt8P9flARSDHp0neqlMGYmQ0lNPPx2
         Ev0ItwO11zxuUdQU8X/0lj4iQ/hmPzjGVIOuUHouMRbgTu8tZoDIOYISHyYQot+Y4dNC
         wT5hPjLeiBfvJzX1lyVfEzqLSd4rbFL0qL11c=
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 17:53:38 +0100
Message-ID: <AANLkTi=VfZrWzCmij+_a=YVLNNV9U7Udqm=3tUt2-cQx@mail.gmail.com>
Subject: [2.6.36-rc5] DRM fixes...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct function storage class, and correct assignment type.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

diff --git a/drivers/gpu/drm/drm_buffer.c b/drivers/gpu/drm/drm_buffer.c
index 55d03ed..687de5f 100644
--- a/drivers/gpu/drm/drm_buffer.c
+++ b/drivers/gpu/drm/drm_buffer.c
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(drm_buffer_alloc);
  *   user_data: A pointer the data that is copied to the buffer.
  *   size: The Number of bytes to copy.
  */
-extern int drm_buffer_copy_from_user(struct drm_buffer *buf,
+int drm_buffer_copy_from_user(struct drm_buffer *buf,
         void __user *user_data, int size)
 {
     int nr_pages = size / PAGE_SIZE + 1;
@@ -163,7 +163,7 @@ void *drm_buffer_read_object(struct drm_buffer *buf,
 {
     int idx = drm_buffer_index(buf);
     int page = drm_buffer_page(buf);
-    void *obj = 0;
+    void *obj = NULL;

     if (idx + objsize <= PAGE_SIZE) {
         obj = &buf->data[page][idx];
-- 
Daniel J Blueman
