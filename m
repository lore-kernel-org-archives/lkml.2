Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab2ECPnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:43:21 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42195 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab2ECPnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:43:19 -0400
Date: Thu, 3 May 2012 17:44:23 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] drm-intel-fixes
Message-ID: <20120503154423.GK4983@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

One more regression fix and a 3 small patches:
- Paulo fixed the hdmi infoframe regression on gm45 introduced in 3.2 by
  Jesse.
- snb/ilk has a nice debug register where the hw can tell us when it
  dropped writes and we've added a WARN in 3.4 when this happens. This
  caught code which shouldn't run on gen6+, the two patches by Chris fix
  this. No known bad side-effects besides the WARN backtrace (and in a
  way, not really a regression fix, but still).
- Fix up 2 broken no-lvds quirks added in 3.4 - I've figured shipping with
  broken quirk entries is pointless, and these are easily revertable.

Yours, Daniel

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

for you to fetch changes up to c1230df7e19e0f27655c0eb9d966c7e03be7cc50:

  drm/i915: enable dip before writing data on gen4 (2012-05-03 15:55:38 +0200)

----------------------------------------------------------------
Chris Wilson (2):
      drm/i915: Do not read non-existent DPLL registers on PCH hardware
      drm/i915: Only enable IPS polling for gen5

Marc Gariepy (1):
      fixing dmi match for hp t5745 and hp st5747 thin client

Paulo Zanoni (1):
      drm/i915: enable dip before writing data on gen4

 drivers/gpu/drm/i915/i915_debugfs.c  |    3 +++
 drivers/gpu/drm/i915/i915_dma.c      |   15 ++++++++++-----
 drivers/gpu/drm/i915/intel_display.c |    9 +++++----
 drivers/gpu/drm/i915/intel_hdmi.c    |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c    |    4 ++--
 5 files changed, 21 insertions(+), 12 deletions(-)

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
