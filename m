Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1I3BKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:10:07 -0400
Received: from home.keithp.com ([63.227.221.253]:49772 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab1I3BKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:05 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 00/24] MacBook Air patch sequence (v2)
Date: Thu, 29 Sep 2011 18:09:32 -0700
Message-Id: <1317344993-24945-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <20110923085243.6e4b7b4c@jbarnes-x220>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, so I've split all of the changes into bite-sized pieces so that
they should make sense individually now. I've also added the same
asynchronous power control to the panel power, this reduces the
module load time down to about 700ms on my MacBook Air, which is
pretty nice.

Given the length of the series, I don't think this should all land in
3.1, however I'd like opinions on whether I should push this subset,
which makes the MacBook Air work, into drm-intel-fixes and send that
along.

 [PATCH 01/21] drm/i915: Enable digital port hotplug on PCH systems
 [PATCH 02/21] drm/i915: Shut down PCH interrupts during
 [PATCH 03/21] drm/i915: Remove extra 300ms delay during eDP mode
 [PATCH 04/21] drm/i915: Only use VBT panel mode on eDP if no EDID is
 [PATCH 05/21] drm/i915: Check eDP power when doing aux channel
 [PATCH 06/21] drm/i915: Unlock PCH_PP_CONTROL always
 [PATCH 07/21] drm/i915: Check for eDP inside
 [PATCH 08/21] drm/i915: Turn force VDD back off when panel running
 [PATCH 09/21] drm/i915: Delay DP i2c initialization until panel
 [PATCH 10/21] drm/i915: Wrap DP EDID fetch functions to enable eDP
 [PATCH 11/21] drm/i915: Enable eDP panel power during I2C
 [PATCH 12/21] drm/i915: Ensure eDP powered up during DP_SET_POWER
 [PATCH 13/21] drm/i915: Place long delays after each eDP VDD
 [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay

The diffstat for that sequence is:

 i915_drv.h |    1 
 i915_irq.c |   28 ++++++++
 i915_reg.h |    6 +
 intel_dp.c |  194 ++++++++++++++++++++++++++++++++++++++++++++++---------------
 4 files changed, 180 insertions(+), 49 deletions(-)

This might be too big at this point in the 3.1 release, so perhaps
just marking these with a Cc: to stable would be more appropriate.

-keith
