Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab2JJUKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:10:11 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:53515 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752254Ab2JJUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:10:08 -0400
Message-ID: <5075D616.4080403@xenotime.net>
Date: Wed, 10 Oct 2012 13:09:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH -next] drm: fix radeon printk format warnings
References: <20121010160904.e73f247f4c7034876bf5af30@canb.auug.org.au>
In-Reply-To: <20121010160904.e73f247f4c7034876bf5af30@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
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
 drivers/gpu/drm/radeon/radeon_acpi.c         |    4 ++--
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20121010.orig/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ linux-next-20121010/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -148,7 +148,7 @@ static int radeon_atpx_verify_interface(
 
 	size = *(u16 *) info->buffer.pointer;
 	if (size < 8) {
-		printk("ATPX buffer is too small: %lu\n", size);
+		printk("ATPX buffer is too small: %zu\n", size);
 		err = -EINVAL;
 		goto out;
 	}
--- linux-next-20121010.orig/drivers/gpu/drm/radeon/radeon_acpi.c
+++ linux-next-20121010/drivers/gpu/drm/radeon/radeon_acpi.c
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
