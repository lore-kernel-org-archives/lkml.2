Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296Ab1C3VhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:37:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:61838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890Ab1C3VIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237780"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: airlied@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [160/275] drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.
Message-Id: <20110330210642.2EB063E1A06@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dave Airlie <airlied@redhat.com>

commit 1922756124ddd53846877416d92ba4a802bc658f upstream.

This fixes CVE-2011-1013.

Reported-by: Matthiew Herrb (OpenBSD X.org team)
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/drm_irq.c |    3 ++-
 include/drm/drmP.h        |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/drm_irq.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/drm_irq.c	2011-03-29 22:51:01.380687839 -0700
+++ linux-2.6.35.y/drivers/gpu/drm/drm_irq.c	2011-03-29 23:03:01.580259734 -0700
@@ -545,7 +545,8 @@
 		    struct drm_file *file_priv)
 {
 	struct drm_modeset_ctl *modeset = data;
-	int crtc, ret = 0;
+	int ret = 0;
+	unsigned int crtc;
 
 	/* If drm_vblank_init() hasn't been called yet, just no-op */
 	if (!dev->num_crtcs)
Index: linux-2.6.35.y/include/drm/drmP.h
===================================================================
--- linux-2.6.35.y.orig/include/drm/drmP.h	2011-03-29 22:51:01.380687839 -0700
+++ linux-2.6.35.y/include/drm/drmP.h	2011-03-29 23:03:01.581259709 -0700
@@ -1021,7 +1021,7 @@
 	struct pci_controller *hose;
 #endif
 	struct drm_sg_mem *sg;	/**< Scatter gather memory */
-	int num_crtcs;                  /**< Number of CRTCs on this device */
+	unsigned int num_crtcs;                  /**< Number of CRTCs on this device */
 	void *dev_private;		/**< device private data */
 	void *mm_private;
 	struct address_space *dev_mapping;
