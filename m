Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1C3JRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:17:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51149 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755564Ab1C3JRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:17:46 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 00/18] GMA500 updates
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 09:58:57 +0100
Message-ID: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches tackles three basic things

- Add support for Moorestown (not yet usable as it needs a memory allocator)
- Completely remove all the ttm related glue from the driver
- Turn on SDVO support on Poulsbo - which should get the various non panel
  users working

Getting useful Moorestown support will need the power management tackling
further, memory allocator and possibly MIPI panel support. For now the priority
is Poulsbo.

---

Alan Cox (17):
      gma500: turn on psb SDVO
      gma500; kill off TTM
      gma500: pull mrst firmware stuff into its own header
      gma500: Clean up more unused structures and code
      gma500: We don't support the CI either
      gma500: delete the RAR handling
      gma500: Add Moorestown identifiers
      gma500: Moorestown does its setup differently
      gma500: enable Moorestown CRTC handling
      gma500: add framebuffer setup
      gma500: Add Moorestown backlight support
      gma500: Makefiles
      gma500: Add moorestown specific data to the device structure
      gma500: Add moorestown config structures
      gma500: Make some of the lvds operations non-static
      gma500: Add moorestown lvds driver code
      gma500: begin adding Moorestown support

Justin P. Mattock (1):
      drivers:staging:gma500 Remove extra semi-colon.


 drivers/staging/gma500/Makefile                 |   11 
 drivers/staging/gma500/mrst.h                   |  217 ++++++++
 drivers/staging/gma500/mrst_crtc.c              |  623 +++++++++++++++++++++++
 drivers/staging/gma500/mrst_lvds.c              |  364 +++++++++++++
 drivers/staging/gma500/psb_2d.c                 |    1 
 drivers/staging/gma500/psb_bl.c                 |  112 +++-
 drivers/staging/gma500/psb_buffer.c             |  450 ----------------
 drivers/staging/gma500/psb_drm.h                |  111 ----
 drivers/staging/gma500/psb_drv.c                |  543 ++++++++------------
 drivers/staging/gma500/psb_drv.h                |  278 +---------
 drivers/staging/gma500/psb_fb.c                 |   23 +
 drivers/staging/gma500/psb_fence.c              |  122 ----
 drivers/staging/gma500/psb_gtt.c                |   51 --
 drivers/staging/gma500/psb_gtt.h                |    4 
 drivers/staging/gma500/psb_intel_display.c      |   10 
 drivers/staging/gma500/psb_intel_lvds.c         |   16 -
 drivers/staging/gma500/psb_sgx.c                |  238 ---------
 drivers/staging/gma500/psb_sgx.h                |   32 -
 drivers/staging/gma500/psb_ttm_fence.c          |  605 ----------------------
 drivers/staging/gma500/psb_ttm_fence_api.h      |  272 ----------
 drivers/staging/gma500/psb_ttm_fence_driver.h   |  302 -----------
 drivers/staging/gma500/psb_ttm_fence_user.c     |  237 ---------
 drivers/staging/gma500/psb_ttm_fence_user.h     |  140 -----
 drivers/staging/gma500/psb_ttm_glue.c           |  349 -------------
 drivers/staging/gma500/psb_ttm_placement_user.c |  628 -----------------------
 drivers/staging/gma500/psb_ttm_userobj_api.h    |   85 ---
 26 files changed, 1593 insertions(+), 4231 deletions(-)
 create mode 100644 drivers/staging/gma500/mrst.h
 create mode 100644 drivers/staging/gma500/mrst_crtc.c
 create mode 100644 drivers/staging/gma500/mrst_lvds.c
 delete mode 100644 drivers/staging/gma500/psb_buffer.c
 delete mode 100644 drivers/staging/gma500/psb_fence.c
 delete mode 100644 drivers/staging/gma500/psb_sgx.c
 delete mode 100644 drivers/staging/gma500/psb_sgx.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_api.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_driver.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_user.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_user.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_glue.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_placement_user.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_userobj_api.h

-- 
Alan

