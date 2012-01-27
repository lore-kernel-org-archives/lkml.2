Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab2A0VuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:50:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44150 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2A0VuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:50:23 -0500
Message-ID: <4F231C6C.80803@gmail.com>
Date: Sat, 28 Jan 2012 08:51:40 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: airlied@linux.ie, airlied@redhat.com, thellstrom@vmware.com,
        jakob@vmware.com
CC: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        joe@perches.com, stable@vger.kernel.org
Subject: [PATCH] vmwgfx: Fix assignment in vmw_framebuffer_create_handle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The assignment of handle in vmw_framebuffer_create_handle doesn't actually do anything useful and is incorrectly assigning an integer value to a pointer argument. It appears that this is a typo and should be dereferencing handle rather than assigning to it directly. This fixes a bug where an undefined handle value is potentially returned to user-space.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
Reviewed-by: Jakob Bornecrantz<jakob@vmware.com>
Cc: stable@vger.kernel.org
---
Thomas and Jakob have said that a correct fix involves returning the correct user_handle, but also requires changes to userspace. This patch is therefore a temporary fix only. Because it corrects an undefined handle value being returned to userspace, this should also be merged for stable kernels.

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 0af6ebd..b66ef0e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -378,7 +378,7 @@ int vmw_framebuffer_create_handle(struct drm_framebuffer *fb,
 				  unsigned int *handle)
 {
 	if (handle)
-		handle = 0;
+		*handle = 0;
 
 	return 0;
 }



