Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab1EaSNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:13:19 -0400
Received: from smtpout03.highway.telekom.at ([195.3.96.115]:31427 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751638Ab1EaSNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:13:18 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: add missing intel_enable_plane() call to i9xx_crtc_mode_set()
Date: Tue, 31 May 2011 20:13:14 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105312013.14986@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Melchior FRANZ <mfranz@aon.at>

Fix garbled up virtual linux console on Acer TM 5735Z-452G32Mnss
(colored stripes, unreadable text) by adding the intel_enable_plane()
call also to i9xx_crtc_mode_set(), which didn't inherit it from
intel_crtc_mode_set() like its twin ironlake_crtc_mode_set().

Signed-off-by: Melchior FRANZ <mfranz@aon.at>
---

The bug was originally introduced with 49183b2818 and fixed with
982b2035d9, but re-introduced by a recent drm/i915 branch merge.


diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f553ddf..5d20579 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4735,6 +4735,8 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
 
 	I915_WRITE(DSPCNTR(plane), dspcntr);
 	POSTING_READ(DSPCNTR(plane));
+	if (!HAS_PCH_SPLIT(dev))
+		intel_enable_plane(dev_priv, plane, pipe);
 
 	ret = intel_pipe_set_base(crtc, x, y, old_fb);
 
