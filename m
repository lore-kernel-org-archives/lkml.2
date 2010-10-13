Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0JMTKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:10:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:38187 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0JMTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:10:00 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] atomic kernel mode setting fixups for drm-core-next
Date: Wed, 13 Oct 2010 14:09:41 -0500
Message-Id: <1286996984-21987-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 13 Oct 2010 19:09:55.0846 (UTC) FILETIME=[38E35A60:01CB6B0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains fixes against the original merge of the
atomic kernel mode setting for the radeon and nouveau drivers.  The
first change is a revert of a prior patch that was radeon specific.
It turns out, as David Airlie suspected, that a generic solution is
needed for saving and restoring the R G B gamma values when using
atomic kernel mode setting.

The final patch in the series is a fix up per prior comments from
Jesse Barnes about using enums vs passing lots of true and false
values in the drm API calls.


Thanks,
Jason.

---
The following changes since commit 26bf62e47261142d528a6109fdd671a2e280b4ea:
  Dave Airlie (1):
        Merge branch 'drm-radeon-next' of ../drm-radeon-next into drm-core-next

--

Jason Wessel (3):
      Revert "radeon, kdb, kms: Save and restore the LUT on atomic KMS enter/exit"
      kdb,kms: Save and restore the LUT on atomic KMS enter/exit
      drm,kdb,kms: Change mode_set_base_atomic() enter argument to be an enum

 drivers/gpu/drm/drm_fb_helper.c             |   31 +++++++++++++++++++++++--
 drivers/gpu/drm/i915/intel_display.c        |    5 ++-
 drivers/gpu/drm/nouveau/nv04_crtc.c         |    4 +-
 drivers/gpu/drm/nouveau/nv50_crtc.c         |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |    2 +-
 drivers/gpu/drm/radeon/radeon_display.c     |   32 ---------------------------
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    7 +-----
 drivers/gpu/drm/radeon/radeon_mode.h        |   10 ++++----
 include/drm/drm_crtc_helper.h               |    7 +++++-
 9 files changed, 47 insertions(+), 53 deletions(-)
