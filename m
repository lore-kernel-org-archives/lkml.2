Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0HZO70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:59:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41765 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0HZO7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:59:21 -0400
Date: Thu, 26 Aug 2010 16:59:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Airlie <airlied@linux.ie>
Cc: Ben Hutchings <ben@decadent.org.uk>, Eric Anholt <eric@anholt.net>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Matthew Garrett <mjg@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i915, drm: Fix build dependency on VGA_ARB
Message-ID: <20100826145917.GA3267@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	David Airlie <airlied@linux.ie>,
	Ben Hutchings <ben@decadent.org.uk>, Eric Anholt <eric@anholt.net>,
	Jordan Crouse <jcrouse@codeaurora.org>,
	Matthew Garrett <mjg@redhat.com>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get:

  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `intel_modeset_init':
(.text+0xa993f): undefined reference to `vga_get'
drivers/built-in.o: In function `intel_modeset_init':
(.text+0xa9963): undefined reference to `vga_put'
make: *** [.tmp_vmlinux1] Error 1

since CONFIG_AGB_ARB is not being selected. Make I915 driver select it
as the numerous other things it selects.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---

This is on latest Linus git (v2.6.36-rc2-237-gd4348c6) after doing `make
oldconfig' on an Acer Aspire One netbook.

 drivers/gpu/drm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 4cab0c6..43590ab 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -97,6 +97,7 @@ config DRM_I830
 config DRM_I915
 	tristate "i915 driver"
 	depends on AGP_INTEL
+	select VGA_ARB
 	select SHMEM
 	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
-- 
1.7.1


-- 
Regards/Gruss,
Boris.
