Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab2BAVpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:45:00 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42364 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756246Ab2BAVJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:08 -0500
X-Sasl-enc: 5qgZ0DFFnBgxDy4HLlCvLYnDABzJ3zKC8y8AHGpivzYs 1328130546
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:40 2012
Message-Id: <20120201205740.792273750@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ryan Mallon <rmallon@gmail.com>,
        Jakob Bornecrantz <jakob@vmware.com>, Dave Airlie <airlied@redhat.com>
Subject: [38/65] vmwgfx: Fix assignment in vmw_framebuffer_create_handle
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Mallon <rmallon@gmail.com>

commit bf9c05d5b6d19b3e4c9fe21047694e94f48db89b upstream.

The assignment of handle in vmw_framebuffer_create_handle doesn't actually do anything useful and is incorrectly assigning an integer value to a pointer argument. It appears that this is a typo and should be dereferencing handle rather than assigning to it directly. This fixes a bug where an undefined handle value is potentially returned to user-space.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
Reviewed-by: Jakob Bornecrantz<jakob@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -313,7 +313,7 @@ int vmw_framebuffer_create_handle(struct
 				  unsigned int *handle)
 {
 	if (handle)
-		handle = 0;
+		*handle = 0;
 
 	return 0;
 }


