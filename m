Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2JOW7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:59:55 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58642 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753902Ab2JOW7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:59:53 -0400
Message-ID: <507C955D.8030401@xenotime.net>
Date: Mon, 15 Oct 2012 15:59:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org
Subject: [PATCH resend] drm: radeon: fix printk format warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warnings in gpu/drm/radeon/:

drivers/gpu/drm/radeon/radeon_atpx_handler.c:151:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
drivers/gpu/drm/radeon/radeon_acpi.c:204:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'
drivers/gpu/drm/radeon/radeon_acpi.c:488:3: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc:	David Airlie <airlied@linux.ie>
Cc:	dri-devel@lists.freedesktop.org
---
Originally posted for linux-next, but now needed in mainline.

 drivers/gpu/drm/radeon/radeon_acpi.c         |    4 ++--
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- lnx-37-rc1.orig/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ lnx-37-rc1/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -148,7 +148,7 @@ static int radeon_atpx_verify_interface(
 
 	size = *(u16 *) info->buffer.pointer;
 	if (size < 8) {
-		printk("ATPX buffer is too small: %lu\n", size);
+		printk("ATPX buffer is too small: %zu\n", size);
 		err = -EINVAL;
 		goto out;
 	}
--- lnx-37-rc1.orig/drivers/gpu/drm/radeon/radeon_acpi.c
+++ lnx-37-rc1/drivers/gpu/drm/radeon/radeon_acpi.c
@@ -201,7 +201,7 @@ static int radeon_atif_verify_interface(
 
 	size = *(u16 *) info->buffer.pointer;
 	if (size < 12) {
-		DRM_INFO("ATIF buffer is too small: %lu\n", size);
+		DRM_INFO("ATIF buffer is too small: %zu\n", size);
 		err = -EINVAL;
 		goto out;
 	}
@@ -485,7 +485,7 @@ static int radeon_atcs_verify_interface(
 
 	size = *(u16 *) info->buffer.pointer;
 	if (size < 8) {
-		DRM_INFO("ATCS buffer is too small: %lu\n", size);
+		DRM_INFO("ATCS buffer is too small: %zu\n", size);
 		err = -EINVAL;
 		goto out;
 	}
