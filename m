Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259Ab1ESSW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:22:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53635 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933904Ab1ESSII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:08 -0400
X-Sasl-enc: /S0RO56e271NyMUDxlM78dapyZ2nEMXVePysvu18sTvp 1305828487
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:56 2011
Message-Id: <20110519180556.005071127@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>
Subject: [18/71] drm/i915: Release object along create user fb error path
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 2dd251f0a294300a1cf8f4b63768145fa6153c4d upstream.

Reported-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6005,8 +6005,10 @@ intel_user_framebuffer_create(struct drm
 		return ERR_PTR(-ENOENT);
 
 	intel_fb = kzalloc(sizeof(*intel_fb), GFP_KERNEL);
-	if (!intel_fb)
+	if (!intel_fb) {
+		drm_gem_object_unreference_unlocked(&obj->base);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	ret = intel_framebuffer_init(dev, intel_fb, mode_cmd, obj);
 	if (ret) {


