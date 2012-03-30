Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab2C3Lq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:46:58 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57090 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261Ab2C3Lqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:46:49 -0400
MIME-Version: 1.0
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/8 v7] fix gmbus writes and related issues
Date: Fri, 30 Mar 2012 19:46:35 +0800
Message-Id: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset addresses a couple of issues with the i915 gmbus
implementation.

v7 adds a final patch to switch to using DRM_ERROR for reporting timeouts.

Daniel Kurtz (8):
  drm/i915/intel_i2c: handle zero-length writes
  drm/i915/intel_i2c: use double-buffered writes
  drm/i915/intel_i2c: always wait for IDLE before clearing NAK
  drm/i915/intel_i2c: use WAIT cycle, not STOP
  drm/i915/intel_i2c: use INDEX cycles for i2c read transactions
  drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
  drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
  drm/i915/intel_i2c: use DRM_ERROR on timeouts

 drivers/gpu/drm/i915/intel_i2c.c |  163 +++++++++++++++++++++++++++----------
 1 files changed, 119 insertions(+), 44 deletions(-)

-- 
1.7.7.3

