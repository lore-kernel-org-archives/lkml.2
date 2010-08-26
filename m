Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab0HZPi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:38:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65268 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab0HZPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=g9FXpengYoVeqUO91rFypJG/wYKIF6c0aw0ubTB+W8IKWLwGTsy/DUoZpFOFh/Gjz0
         7ZMXWuhU/Ep/oG/UsOn7FWYSUedB37ugAyW3EAqE6vLpJUo5OYYbWt+95RACe3SNq4Qm
         hmYnHzySKrkhapxv987tm254K2Cu9IoSh65/Q=
MIME-Version: 1.0
Date: Thu, 26 Aug 2010 11:38:24 -0400
Message-ID: <AANLkTinpiGAaAJyHOxHja7jAM-3iwDPMcJhHPF9pRV7A@mail.gmail.com>
Subject: [PATCH] i915: build error
From: Mark Stanovich <mrktimber@gmail.com>
To: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if I put the select VGA_ARB in the correct order for the Kconfig file.

When building 2.6.36-rc2, the following error occurs:

ERROR: "vga_get" [drivers/gpu/drm/i915/i915.ko] undefined!
ERROR: "vga_put" [drivers/gpu/drm/i915/i915.ko] undefined!
make[1]: *** [__modpost] Error 1

This is due to commit 9cce37f4855a30cc7c364edf18522282782f7ddc
which adds a use of function vga_put and vga_get in
drivers/gpu/drm/i915/intel_display.c.  vga_put and vga_get are is
defined in file drivers/gpu/vga/vgaarb.c.  To ensure that this
file is built, select VGA_ARB when DRM_I915 is selected.  If
DRM_I915 is selected without VGA_ARB, a build error will occur.

Signed-off-by: Mark Stanovich <mrktimber@gmail.com>
---
 drivers/gpu/drm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 4cab0c6..8f0a08b 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -98,6 +98,7 @@ config DRM_I915
   tristate "i915 driver"
   depends on AGP_INTEL
   select SHMEM
+  select VGA_ARB
   select DRM_KMS_HELPER
   select FB_CFB_FILLRECT
   select FB_CFB_COPYAREA
