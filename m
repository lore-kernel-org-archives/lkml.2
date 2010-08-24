Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab0HXPl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:41:59 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:56095 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0HXPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:41:56 -0400
Date: Tue, 24 Aug 2010 16:41:55 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/2] drm/i915: Revert wait for vblank to prevent X refresh
	issues
Message-ID: <20100824154154.GA10473@sucs.org>
References: <20100823233551.GA31920@sucs.org> <89kc63$hrmse5@fmsmga002.fm.intel.com> <20100824075741.GA11000@sucs.org> <8u3s8d$jcg467@orsmga001.jf.intel.com> <20100824084902.GA27569@sucs.org> <89kc63$hrqoho@fmsmga002.fm.intel.com> <20100824095535.GA14020@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824095535.GA14020@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 9d0498a2bf7455159b317f19531a3e5db2ecc9c4 20ms waits were
converted into vblank waits. One of these caused tearing, mode detection
and redraw issues on an EeePC 900 with a more recent intel userspace (
http://lkml.org/lkml/2010/8/23/432 ). Restoring the 20ms wait resolves
the issue.
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 23157e1..116d938 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4539,7 +4539,7 @@ struct drm_crtc *intel_get_load_detect_pipe(struct intel_encoder *intel_encoder,
 		encoder_funcs->commit(encoder);
 	}
 	/* let the connector get through one full cycle before testing */
-	intel_wait_for_vblank(dev, intel_crtc->pipe);
+	msleep(20);
 
 	return crtc;
 }
-- 
1.7.1

