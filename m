Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1JDF41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 01:56:27 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:38236 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1JDF40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 01:56:26 -0400
Date: Tue, 4 Oct 2011 06:56:17 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Keith Packard <keithp@keithp.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: i915 kmemleak report
Message-ID: <20111004055616.GA17545@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been finding that kmemleak reports that i915 is leaking gem
buffers (although it takes about 20 minutes before the supposed leaks
occur).  The leaks normally occur in batches of 13 and seem to require
chrome to be running looking at a page like google.com while a
gnome-terminal is also present. It is important that the screensaver is
postponed using something like
watch "xdg-screensaver reset" .

A batch of the leaks are below:

unreferenced object 0xe9b1d640 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740514 (age 4367.634s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe9b1d780 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740514 (age 4367.634s)
  hex dump (first 32 bytes):
    00 00 00 00 40 d6 b1 e9 00 00 00 00 00 00 00 00  ....@...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xeb0db000 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740514 (age 4367.634s)
  hex dump (first 32 bytes):
    00 00 00 00 80 d7 b1 e9 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe3d37b40 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740514 (age 4367.634s)
  hex dump (first 32 bytes):
    00 00 00 00 00 b0 0d eb 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe3d37780 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740514 (age 4367.654s)
  hex dump (first 32 bytes):
    00 00 00 00 40 7b d3 e3 00 00 00 00 00 00 00 00  ....@{..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe3d373c0 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740514 (age 4367.654s)
  hex dump (first 32 bytes):
    00 00 00 00 80 77 d3 e3 00 00 00 00 00 00 00 00  .....w..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe3d37640 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740515 (age 4367.653s)
  hex dump (first 32 bytes):
    00 00 00 00 c0 73 d3 e3 00 00 00 00 00 00 00 00  .....s..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe3d37a00 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740515 (age 4367.653s)
  hex dump (first 32 bytes):
    00 00 00 00 40 76 d3 e3 00 00 00 00 00 00 00 00  ....@v..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe3d378c0 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740515 (age 4367.653s)
  hex dump (first 32 bytes):
    00 00 00 00 00 7a d3 e3 00 00 00 00 00 00 00 00  .....z..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe3d37500 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740515 (age 4367.670s)
  hex dump (first 32 bytes):
    00 00 00 00 c0 78 d3 e3 00 00 00 00 00 00 00 00  .....x..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe363c3c0 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740515 (age 4367.670s)
  hex dump (first 32 bytes):
    00 00 00 00 00 75 d3 e3 00 00 00 00 00 00 00 00  .....u..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xe363cc80 (size 148):
  comm "Xorg", pid 1398, jiffies 4294740515 (age 4367.670s)
  hex dump (first 32 bytes):
    00 00 00 00 c0 c3 63 e3 00 00 00 00 00 00 00 00  ......c.........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff
unreferenced object 0xdf14dc80 (size 148):
  comm "Xorg", pid 1398, jiffies 4294753046 (age 4355.140s)
  hex dump (first 32 bytes):
    00 00 00 00 80 cc 63 e3 00 00 00 00 00 00 00 00  ......c.........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0553b87>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b026b264>] idr_pre_get+0x54/0x80
    [<b030324c>] drm_gem_handle_create+0x3c/0xd0
    [<b03294f9>] i915_gem_create+0x49/0xa0
    [<b0329578>] i915_gem_create_ioctl+0x28/0x40
    [<b0301716>] drm_ioctl+0x1d6/0x470
    [<b01aa8de>] do_vfs_ioctl+0x7e/0x5a0
    [<b01aae39>] sys_ioctl+0x39/0x70
    [<b055ff17>] sysenter_do_call+0x12/0x36
    [<ffffffff>] 0xffffffff

-- 
Sitsofe | http://sucs.org/~sits/
