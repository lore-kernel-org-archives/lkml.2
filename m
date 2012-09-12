Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2ILXeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:34:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2ILXdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:33:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Forest Bond <forest.bond@rapidrollout.com>,
        Alan Cox <alan@linux.intel.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 056/108] gma500: Consider CRTC initially active.
Date: Wed, 12 Sep 2012 16:28:54 -0700
Message-Id: <20120912232456.412255046@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forest Bond <forest.bond@rapidrollout.com>

commit 4a68a74ba04e7ccf798d45988f4f2d2131fb5063 upstream.

[this one ideally should make 3.6 - it fixes the very annoying mode setting bug]

This causes the pipe to be forced off prior to initial mode set, which
roughly mirrors the behavior of the i915 driver.  It fixes initial mode
setting on my Intel DN2800MT (Cedarview) board.  Without it, mode
setting triggers an out-of-range error from the monitor for most modes,
but only on initial configuration (i.e. they can be configured
successfully from userspace after that).

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/gma500/psb_intel_display.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -1362,6 +1362,9 @@ void psb_intel_crtc_init(struct drm_devi
 	    (struct drm_connector **) (psb_intel_crtc + 1);
 	psb_intel_crtc->mode_set.num_connectors = 0;
 	psb_intel_cursor_init(dev, psb_intel_crtc);
+
+	/* Set to true so that the pipe is forced off on initial config. */
+	psb_intel_crtc->active = true;
 }
 
 int psb_intel_get_pipe_from_crtc_id(struct drm_device *dev, void *data,


