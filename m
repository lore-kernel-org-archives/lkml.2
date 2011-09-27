Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1I0GLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:11:54 -0400
Received: from home.keithp.com ([63.227.221.253]:55017 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab1I0GLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:11:53 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: PCH reference clock cleanups
Date: Mon, 26 Sep 2011 23:11:37 -0700
Message-Id: <1317103906-4649-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <yunbou6lxb4.fsf@aiko.keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch sequence which cleans up a bunch of PCH refclk related
bits. There are a couple of questionable patches that I'd like to see
people look at:

 [PATCH 6/9] drm/i915: Fix PCH SSC reference clock settings
 [PATCH 9/9] drm/i915: Initialize PCH refclks at modeset init time

Here's the main patch -- this looks at the global set of encoders and
figures out what the refclk should be to make all of those work
correctly. Nothing is dependent on the active configuration, so we
aren't reprogramming this register during run-time. The last patch in
the sequence moves the setting of this register from modeset time to
init time.

 [PATCH 7/9] drm/i915: Use CK505 as non-SSC source where available

This is a small piece straight from Jesse's patch; just uses the VBT
configuration for CK505 clock sources.

 [PATCH 8/9] drm/i915: All PCH refclks are 120MHz

Ok, so I'd love to know where in any PCH reference matter someone has
found a place where the reference clock for any of the PLLs is
anything other than 120MHz. Can someone find a reference for other frequencies?

--
keith.packard@intel.com
