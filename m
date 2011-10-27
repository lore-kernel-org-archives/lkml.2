Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1J0WCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:02:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab1J0WCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:43 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 0/9] Split psb_intel_output to encoders and connectors
Date: Fri, 28 Oct 2011 00:02:05 +0200
Message-Id: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches gets rid of the pairing of encoders and connectors we had
in psb_intel_output. This was done to make life easier getting the SDVO code
from i915 copied into our tree (included in this patchset). It also gives more
flexibility for better output handling in the future.

SDVO can now properly setup DDC and get EDID on the Fit-PC2 DVI connector but
there are known issues when setting resolutions at 1920x1080 and above.
On Asus 1201HA the VGA connector still fails to get EDID so more work is needed.

The changes to Cedarview, Moorestown and Medfield have not been tested so they
are subject to change. Particularly the changes to Medfield are known not to be
complete so more pondering is also needed there.

Patrik Jakobsson (9):
  gma500: Initial support for our encoder and connector structs
  gma500: Remove psb_intel_output from ddc_probe and ddc_get_modes
  gma500: Fix encoder type checking for connectors
  gma500: Convert PSB LVDS to new output handling
  gma500: Add support for Intel GMBUS
  gma500: Replace SDVO code with slightly modified version from i915
  gma500: Convert Cedarview to work with new output handling
  gma500: Convert Moorestown to work with new output handling
  gma500: Convert Medfield to work with new output handling

 drivers/staging/gma500/Makefile              |    1 +
 drivers/staging/gma500/cdv_intel_crt.c       |   47 +-
 drivers/staging/gma500/cdv_intel_display.c   |   14 +-
 drivers/staging/gma500/cdv_intel_hdmi.c      |  112 +-
 drivers/staging/gma500/cdv_intel_lvds.c      |  117 +-
 drivers/staging/gma500/framebuffer.c         |    8 +-
 drivers/staging/gma500/intel_gmbus.c         |  492 +++++
 drivers/staging/gma500/mdfld_dsi_dbi.c       |    5 +
 drivers/staging/gma500/mdfld_dsi_dpi.c       |    5 +
 drivers/staging/gma500/mdfld_dsi_output.c    |   40 +-
 drivers/staging/gma500/mdfld_intel_display.c |   14 +-
 drivers/staging/gma500/medfield.h            |    6 +-
 drivers/staging/gma500/mrst_crtc.c           |   18 +-
 drivers/staging/gma500/mrst_hdmi.c           |   29 +-
 drivers/staging/gma500/mrst_lvds.c           |   79 +-
 drivers/staging/gma500/psb_device.c          |    7 +
 drivers/staging/gma500/psb_drv.c             |    6 +-
 drivers/staging/gma500/psb_drv.h             |   30 +-
 drivers/staging/gma500/psb_intel_display.c   |   39 +-
 drivers/staging/gma500/psb_intel_drv.h       |   98 +-
 drivers/staging/gma500/psb_intel_lvds.c      |  151 +-
 drivers/staging/gma500/psb_intel_modes.c     |   16 +-
 drivers/staging/gma500/psb_intel_reg.h       |   74 +
 drivers/staging/gma500/psb_intel_sdvo.c      | 3059 ++++++++++++++++++--------
 drivers/staging/gma500/psb_intel_sdvo_regs.h |  591 ++++-
 25 files changed, 3769 insertions(+), 1289 deletions(-)
 create mode 100644 drivers/staging/gma500/intel_gmbus.c

-- 
1.7.4.1

