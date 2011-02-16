Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab1BPAwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:52:18 -0500
Received: from kroah.org ([198.145.64.141]:46297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933499Ab1BPAwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:52:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:15 2011
Message-Id: <20110216002115.899593566@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [patch 169/176] drm/i915: Add dependency on CONFIG_TMPFS
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

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

---
 drivers/gpu/drm/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -97,7 +97,10 @@ config DRM_I830
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


