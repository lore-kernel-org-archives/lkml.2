Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab2C1S1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:27:44 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43454 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932630Ab2C1S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:26:45 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/7 v6] fix gmbus writes and related issues
Date: Thu, 29 Mar 2012 02:26:32 +0800
Message-Id: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset addresses a couple of issues with the i915 gmbus
implementation.

v6 is a rebased and trimmed version of the patchset,
since the first few patches have already been merged onto drm-intel-next-queued.
 * Cleans up INDEX cycle implementation
 * Only remove POSTING_READ() when it immediately precedes another I915_READ().

Daniel Kurtz (7):
  drm/i915/intel_i2c: handle zero-length writes
  drm/i915/intel_i2c: use double-buffered writes
  drm/i915/intel_i2c: always wait for IDLE before clearing NAK
  drm/i915/intel_i2c: use WAIT cycle, not STOP
  drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
  drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
  drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers

 drivers/gpu/drm/i915/intel_i2c.c |  159 ++++++++++++++++++++++++++++----------
 1 files changed, 117 insertions(+), 42 deletions(-)

-- 
1.7.7.3

