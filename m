Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1DSOr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:47:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52948 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751899Ab1DSOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:47:56 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 0/8] Further clean up and setup
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 15:26:51 +0100
Message-ID: <20110419142432.16479.89255.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This begins to put meaningful code into the buffer management. It's in theory
pretty much all there now but needs a fair bit of debug before it'll actually
do anything useful. We also strip out a lot of the old GTT code we no longer
need and the last remnants of the TTM stuff.
---

Alan Cox (8):
      gma500: allow non stolen page backed framebuffer
      gma500: prune some unused variables
      gma500: GEM - now we have the basics we shall stick pins in it
      gma500: GEMify the frame buffer base bits
      gma500: Begin the GEMification of the cursor code
      gma500: Add support for inserting and removing pages from the GART
      gma500: begin adding GEM
      gma500: add the ability to request backed space or not


 drivers/staging/gma500/Makefile            |    2 
 drivers/staging/gma500/mrst_crtc.c         |   15 
 drivers/staging/gma500/psb_2d.c            |    4 
 drivers/staging/gma500/psb_drm.h           |   11 
 drivers/staging/gma500/psb_drv.c           |   46 +
 drivers/staging/gma500/psb_drv.h           |   25 -
 drivers/staging/gma500/psb_fb.c            |  301 +++----
 drivers/staging/gma500/psb_fb.h            |    5 
 drivers/staging/gma500/psb_gem.c           |  209 +++++
 drivers/staging/gma500/psb_gtt.c           | 1215 ++++++++--------------------
 drivers/staging/gma500/psb_gtt.h           |   70 --
 drivers/staging/gma500/psb_intel_display.c |  116 +--
 drivers/staging/gma500/psb_intel_drv.h     |   13 
 drivers/staging/gma500/psb_intel_lvds.c    |   14 
 drivers/staging/gma500/psb_powermgmt.c     |    5 
 drivers/staging/gma500/psb_pvr_glue.c      |   73 --
 drivers/staging/gma500/psb_pvr_glue.h      |   25 -
 17 files changed, 801 insertions(+), 1348 deletions(-)
 create mode 100644 drivers/staging/gma500/psb_gem.c
 delete mode 100644 drivers/staging/gma500/psb_pvr_glue.c
 delete mode 100644 drivers/staging/gma500/psb_pvr_glue.h

-- 
Carry on carry on, there's nothing to be done on days like these
In the ruins and the rage, planting flowers for new days
In the ruins and the rage, we carry on


