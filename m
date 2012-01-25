Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab2AYQQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:16:48 -0500
Received: from home.keithp.com ([63.227.221.253]:33821 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab2AYQQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:16:46 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 0/2] drm/i915: Use correct bpc computations for DisplayPort
Date: Wed, 25 Jan 2012 08:16:24 -0800
Message-Id: <1327508186-26704-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a couple of patches that fix some bpc (bits per component)
computation issues with DisplayPort. The problem was that the
DisplayPort code tried to figure out the 'current' bpc by looking at
the bpp stored in an associated crtc, but that was never right (as
described in the message for the first patch).

The first patch assumes that the display will run at 8bpc (24bpp) if
the link has enough bandwidth, otherwise at 6bpc (18bpp). This is
essentially what the existing code ends up doing at boot time; modes
are computed before any crtc is assigned, so intel_dp_link_required
would have used 24bpp for bandwidth computations.

The second patch allows for arbitrary bpc values, computing the
display bpc in both intel_dp_mode_fixup and the two crtc_mode_set
functions. Obviously doing the computation once would be nice, but
there isn't an obvious place to stick the result between those two
functions as the bpc computation is also needed for non-DP encoders.

This should fix problems where display port doesn't come back after
resume for panels which need 6bpc modes.

--
keith.packard@intel.com
