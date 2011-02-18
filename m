Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab1BRJFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:05:47 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56507 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab1BRJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:05:08 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Stefan Bader <stefan.bader@canonical.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 7/7] drm/i915: Add dependency on CONFIG_TMPFS" has been added to staging queue
Date: Fri, 18 Feb 2011 10:05:06 +0100
Message-Id: <1298019906-2504-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 7/7] drm/i915: Add dependency on CONFIG_TMPFS

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 93e829f0593456805b1745cf34ae8e76f2c28d3d Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 20 Jan 2011 10:03:24 +0000
Subject: [PATCH 7/7] drm/i915: Add dependency on CONFIG_TMPFS

commit f7ab9b407b3bc83161c2aa74c992ba4782e87c9c upstream.

Without tmpfs, shmem_readpage() is not compiled in causing an OOPS as
soon as we try to allocate some swappable pages for GEM.

Jan 19 22:52:26 harlie kernel: Modules linked in: i915(+) drm_kms_helper cfbcopyarea video backlight cfbimgblt cfbfillrect
Jan 19 22:52:26 harlie kernel:
Jan 19 22:52:26 harlie kernel: Pid: 1125, comm: modprobe Not tainted 2.6.37Harlie #10 To be filled by O.E.M./To be filled by O.E.M.
Jan 19 22:52:26 harlie kernel: EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 3
Jan 19 22:52:26 harlie kernel: EIP is at 0x0
Jan 19 22:52:26 harlie kernel: EAX: 00000000 EBX: f7b7d000 ECX: f3383100 EDX: f7b7d000
Jan 19 22:52:26 harlie kernel: ESI: f1456118 EDI: 00000000 EBP: f2303c98 ESP: f2303c7c
Jan 19 22:52:26 harlie kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jan 19 22:52:26 harlie kernel: Process modprobe (pid: 1125, ti=f2302000 task=f259cd80 task.ti=f2302000)
Jan 19 22:52:26 harlie kernel: Stack:
Jan 19 22:52:26 harlie udevd-work[1072]: '/sbin/modprobe -b pci:v00008086d00000046sv00000000sd00000000bc03sc00i00' unexpected exit with status 0x0009
Jan 19 22:52:26 harlie kernel:  c1074061 000000d0 f2f42b80 00000000 000a13d2 f2d5dcc0 00000001 f2303cac
Jan 19 22:52:26 harlie kernel:  c107416f 00000000 000a13d2 00000000 f2303cd4 f8d620ed f2cee620 00001000
Jan 19 22:52:26 harlie kernel:  00000000 000a13d2 f1456118 f2d5dcc0 f1a40000 00001000 f2303d04 f8d637ab
Jan 19 22:52:26 harlie kernel: Call Trace:
Jan 19 22:52:26 harlie kernel:  [<c1074061>] ? do_read_cache_page+0x71/0x160
Jan 19 22:52:26 harlie kernel:  [<c107416f>] ? read_cache_page_gfp+0x1f/0x30
Jan 19 22:52:26 harlie kernel:  [<f8d620ed>] ? i915_gem_object_get_pages+0xad/0x1d0 [i915]
Jan 19 22:52:26 harlie kernel:  [<f8d637ab>] ? i915_gem_object_bind_to_gtt+0xeb/0x2d0 [i915]
Jan 19 22:52:26 harlie kernel:  [<f8d65961>] ? i915_gem_object_pin+0x151/0x190 [i915]
Jan 19 22:52:26 harlie kernel:  [<c11e16ed>] ? drm_gem_object_init+0x3d/0x60
Jan 19 22:52:26 harlie kernel:  [<f8d65aa5>] ? i915_gem_init_ringbuffer+0x105/0x1e0 [i915]
Jan 19 22:52:26 harlie kernel:  [<f8d571b7>] ? i915_driver_load+0x667/0x1160 [i915]

Reported-by: John J. Stimson-III <john@idsfa.net>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 305c590..7bb111b 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -94,7 +94,10 @@ config DRM_I830
 config DRM_I915
 	tristate "i915 driver"
 	depends on AGP_INTEL
+	# we need shmfs for the swappable backing store, and in particular
+	# the shmem_readpage() which depends upon tmpfs
 	select SHMEM
+	select TMPFS
 	select DRM_KMS_HELPER
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
--
1.7.0.4

