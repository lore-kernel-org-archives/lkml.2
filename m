Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092Ab1DZELU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 00:11:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57899 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1DZELT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 00:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IVgauTZfn0Rx4o57faI6n5ONjuRoJ02J8c7S98znhxCjNQtb7ZLgXgsHre/3wYO6Fu
         Db6Kn3Y0hphbDg4Syi+qqy0TovEmk0Rdax6wPI4tnSyN+EerGlP+thdLlzsF4xKE5iwZ
         jMpe6f1ck8fdSn9roJnlODAcwwVutcSakCURA=
From: Liu Yuan <namei.unix@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH] virtio, ring: Use ALIGN macros in virtio_ring.h
Date: Tue, 26 Apr 2011 12:11:10 +0800
Message-Id: <1303791070-15196-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>


Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 include/linux/virtio_ring.h |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index e4d144b..6299050 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -99,15 +99,13 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 	vr->num = num;
 	vr->desc = p;
 	vr->avail = p + num*sizeof(struct vring_desc);
-	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
-			    & ~(align - 1));
+	vr->used = (void *)PTR_ALIGN(&vr->avail->ring[num], align);
 }
 
 static inline unsigned vring_size(unsigned int num, unsigned long align)
 {
-	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
-		 + align - 1) & ~(align - 1))
-		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
+	return ((sizeof(struct vring_desc) * num + ALIGN(sizeof(__u16) * (2 + num), align))
+		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num);
 }
 
 #ifdef __KERNEL__
-- 
1.7.1

