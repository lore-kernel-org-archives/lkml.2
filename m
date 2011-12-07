Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab1LGQVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:21:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab1LGQVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:15 2011
Message-Id: <20111207161215.447285296@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:10 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Keith Packard <keithp@keithp.com>
Subject: [008/104] drm/i915: Ivybridge still has fences!
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 775d17b6ca4357048f36c22151335addfe15db4b upstream.

So don't forget to restore them on resume and dump them into
the error state.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c     |    1 +
 drivers/gpu/drm/i915/i915_suspend.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -822,6 +822,7 @@ static void i915_gem_record_fences(struc
 
 	/* Fences */
 	switch (INTEL_INFO(dev)->gen) {
+	case 7:
 	case 6:
 		for (i = 0; i < 16; i++)
 			error->fence[i] = I915_READ64(FENCE_REG_SANDYBRIDGE_0 + (i * 8));
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -370,6 +370,7 @@ static void i915_save_modeset_reg(struct
 
 	/* Fences */
 	switch (INTEL_INFO(dev)->gen) {
+	case 7:
 	case 6:
 		for (i = 0; i < 16; i++)
 			dev_priv->saveFENCE[i] = I915_READ64(FENCE_REG_SANDYBRIDGE_0 + (i * 8));
@@ -404,6 +405,7 @@ static void i915_restore_modeset_reg(str
 
 	/* Fences */
 	switch (INTEL_INFO(dev)->gen) {
+	case 7:
 	case 6:
 		for (i = 0; i < 16; i++)
 			I915_WRITE64(FENCE_REG_SANDYBRIDGE_0 + (i * 8), dev_priv->saveFENCE[i]);


