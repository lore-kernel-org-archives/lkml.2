Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2A0GZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:25:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40216 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2A0GZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:25:18 -0500
Message-ID: <4F224348.8050607@gmail.com>
Date: Fri, 27 Jan 2012 17:25:12 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: airlied@linux.ie, airlied@redhat.com, thellstrom@vmware.com,
        jakob@vmware.com
CC: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        joe Perches <joe@perches.com>
Subject: [RFC PATCH] vmwgfx: Fix assignment in vmw_framebuffer_create_handle
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The assignment of handle in vmw_framebuffer_create_handle doesn't
actually do anything useful and is incorrectly assigning an integer
value to a pointer argument. It appears that this is a typo and should
be dereferencing handle rather than assigning to it directly.
    
Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

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

