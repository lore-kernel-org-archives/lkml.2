Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab1KWAix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:38:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759070Ab1KWAhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:37:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:57 2011
Message-Id: <20111123002557.325656786@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        Robert Hooker <robert.hooker@canonical.com>
Subject: [47/53] drm/i915: always set FDI composite sync bit
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit c4f9c4c2b3f1831e932e04db992cf6fe92c2a95a upstream.

It's needed for 3 pipe support as well as just regular functionality
(e.g. DisplayPort).

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Adam Jackson <ajax@redhat.com>
Tested-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Robert Hooker <robert.hooker@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3175,6 +3175,7 @@
 #define  FDI_LINK_TRAIN_NONE_IVB            (3<<8)
 
 /* both Tx and Rx */
+#define  FDI_COMPOSITE_SYNC		(1<<11)
 #define  FDI_LINK_TRAIN_AUTO		(1<<10)
 #define  FDI_SCRAMBLING_ENABLE          (0<<7)
 #define  FDI_SCRAMBLING_DISABLE         (1<<7)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2600,6 +2600,7 @@ static void ivb_manual_fdi_link_train(st
 	temp |= FDI_LINK_TRAIN_PATTERN_1_IVB;
 	temp &= ~FDI_LINK_TRAIN_VOL_EMP_MASK;
 	temp |= FDI_LINK_TRAIN_400MV_0DB_SNB_B;
+	temp |= FDI_COMPOSITE_SYNC;
 	I915_WRITE(reg, temp | FDI_TX_ENABLE);
 
 	reg = FDI_RX_CTL(pipe);
@@ -2607,6 +2608,7 @@ static void ivb_manual_fdi_link_train(st
 	temp &= ~FDI_LINK_TRAIN_AUTO;
 	temp &= ~FDI_LINK_TRAIN_PATTERN_MASK_CPT;
 	temp |= FDI_LINK_TRAIN_PATTERN_1_CPT;
+	temp |= FDI_COMPOSITE_SYNC;
 	I915_WRITE(reg, temp | FDI_RX_ENABLE);
 
 	POSTING_READ(reg);


