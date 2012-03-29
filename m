Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab2C2HOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 03:14:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59587 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab2C2HOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 03:14:10 -0400
Date: Thu, 29 Mar 2012 08:14:08 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm intel hibernation fix
Message-ID: <alpine.DEB.2.00.1203290811240.25319@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I tracked down the misc memory corruption after i915 hibernate to the 
blinking fbcon cursor, and realised the i915 driver wasn't doing the fbdev 
suspend/resume calls at all. nouveau and radeon have done these calls for 
a long time.

This has been fairly well tested and is definitely the main culprit in 
hibernate not working.

Dave.

The following changes since commit d936622c36273a9ecfbb4aacf26cd29405995159:

  drm/radeon: Only warn if the intra-domain offset actually exceeds the limit. (2012-03-28 13:50:05 +0100)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Dave Airlie (1):
      drm/i915: suspend fbdev device around suspend/hibernate

 drivers/gpu/drm/i915/i915_drv.c  |    7 +++++++
 drivers/gpu/drm/i915/intel_drv.h |    2 +-
 drivers/gpu/drm/i915/intel_fb.c  |   10 ++++++++++
 3 files changed, 18 insertions(+), 1 deletions(-)
