Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2F0JKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:10:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47162 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2F0JKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:10:41 -0400
Date: Wed, 27 Jun 2012 12:10:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -resend] drm/i915/bios: cleanup return type of
 intel_parse_bios()
Message-ID: <20120627091030.GV31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are unintuitive.  These are type bool and return -1 casted to true
on failure.  Let's just make it return an int.  The callers don't care,
but let's change this as a cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
Originally sent on Wed, Mar 28, 2012.  This one is prossibly my fault.
I assumed these would be in the same tree, but apparently I should have
broken them out.  Daniel acked the patch and told me that if I wanted to
I could break it up and he could merge part (or all of it?).  I have no
problem with redoing patches but I understood that to mean it was going
to go through a someone else's tree with his Acked-by.  If you give me
an option, of course I'm going to pick the laziest one.  That is my firm
promise and commitment.

diff --git a/drivers/gpu/drm/gma500/intel_bios.h b/drivers/gpu/drm/gma500/intel_bios.h
index 0a73866..2e95523 100644
--- a/drivers/gpu/drm/gma500/intel_bios.h
+++ b/drivers/gpu/drm/gma500/intel_bios.h
@@ -431,7 +431,7 @@ struct bdb_driver_features {
 	u8 custom_vbt_version;
 } __attribute__((packed));
 
-extern bool psb_intel_init_bios(struct drm_device *dev);
+extern int psb_intel_init_bios(struct drm_device *dev);
 extern void psb_intel_destroy_bios(struct drm_device *dev);
 
 /*
diff --git a/drivers/gpu/drm/gma500/intel_bios.c b/drivers/gpu/drm/gma500/intel_bios.c
index 973d7f6..8d7caf0 100644
--- a/drivers/gpu/drm/gma500/intel_bios.c
+++ b/drivers/gpu/drm/gma500/intel_bios.c
@@ -427,7 +427,7 @@ parse_device_mapping(struct drm_psb_private *dev_priv,
  *
  * Returns 0 on success, nonzero on failure.
  */
-bool psb_intel_init_bios(struct drm_device *dev)
+int psb_intel_init_bios(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct pci_dev *pdev = dev->pdev;
diff --git a/drivers/gpu/drm/i915/intel_bios.h b/drivers/gpu/drm/i915/intel_bios.h
index dbda6e3..31c2107 100644
--- a/drivers/gpu/drm/i915/intel_bios.h
+++ b/drivers/gpu/drm/i915/intel_bios.h
@@ -476,7 +476,7 @@ struct bdb_edp {
 } __attribute__ ((packed));
 
 void intel_setup_bios(struct drm_device *dev);
-bool intel_parse_bios(struct drm_device *dev);
+int intel_parse_bios(struct drm_device *dev);
 
 /*
  * Driver<->VBIOS interaction occurs through scratch bits in
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 3534593..8c60741 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -692,7 +692,7 @@ static const struct dmi_system_id intel_no_opregion_vbt[] = {
  *
  * Returns 0 on success, nonzero on failure.
  */
-bool
+int
 intel_parse_bios(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
