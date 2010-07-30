Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570Ab0G3TNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:13:42 -0400
Received: from kroah.org ([198.145.64.141]:46340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815Ab0G3RSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:11 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:02 2010
Message-Id: <20100730171502.653716968@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Subject: [033/165] drm/i915: Define MI_ARB_STATE bits
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Keith Packard <keithp@keithp.com>

commit 45503ded966c98e604c9667c0b458d40666b9ef3 upstream.

The i915 memory arbiter has a register full of configuration
bits which are currently not defined in the driver header file.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h |   64 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -307,6 +307,70 @@
 #define LM_BURST_LENGTH     0x00000700
 #define LM_FIFO_WATERMARK   0x0000001F
 #define MI_ARB_STATE	0x020e4 /* 915+ only */
+#define   MI_ARB_MASK_SHIFT	  16	/* shift for enable bits */
+
+/* Make render/texture TLB fetches lower priorty than associated data
+ *   fetches. This is not turned on by default
+ */
+#define   MI_ARB_RENDER_TLB_LOW_PRIORITY	(1 << 15)
+
+/* Isoch request wait on GTT enable (Display A/B/C streams).
+ * Make isoch requests stall on the TLB update. May cause
+ * display underruns (test mode only)
+ */
+#define   MI_ARB_ISOCH_WAIT_GTT			(1 << 14)
+
+/* Block grant count for isoch requests when block count is
+ * set to a finite value.
+ */
+#define   MI_ARB_BLOCK_GRANT_MASK		(3 << 12)
+#define   MI_ARB_BLOCK_GRANT_8			(0 << 12)	/* for 3 display planes */
+#define   MI_ARB_BLOCK_GRANT_4			(1 << 12)	/* for 2 display planes */
+#define   MI_ARB_BLOCK_GRANT_2			(2 << 12)	/* for 1 display plane */
+#define   MI_ARB_BLOCK_GRANT_0			(3 << 12)	/* don't use */
+
+/* Enable render writes to complete in C2/C3/C4 power states.
+ * If this isn't enabled, render writes are prevented in low
+ * power states. That seems bad to me.
+ */
+#define   MI_ARB_C3_LP_WRITE_ENABLE		(1 << 11)
+
+/* This acknowledges an async flip immediately instead
+ * of waiting for 2TLB fetches.
+ */
+#define   MI_ARB_ASYNC_FLIP_ACK_IMMEDIATE	(1 << 10)
+
+/* Enables non-sequential data reads through arbiter
+ */
+#define   MI_ARB_DUAL_DATA_PHASE_DISABLE       	(1 << 9)
+
+/* Disable FSB snooping of cacheable write cycles from binner/render
+ * command stream
+ */
+#define   MI_ARB_CACHE_SNOOP_DISABLE		(1 << 8)
+
+/* Arbiter time slice for non-isoch streams */
+#define   MI_ARB_TIME_SLICE_MASK		(7 << 5)
+#define   MI_ARB_TIME_SLICE_1			(0 << 5)
+#define   MI_ARB_TIME_SLICE_2			(1 << 5)
+#define   MI_ARB_TIME_SLICE_4			(2 << 5)
+#define   MI_ARB_TIME_SLICE_6			(3 << 5)
+#define   MI_ARB_TIME_SLICE_8			(4 << 5)
+#define   MI_ARB_TIME_SLICE_10			(5 << 5)
+#define   MI_ARB_TIME_SLICE_14			(6 << 5)
+#define   MI_ARB_TIME_SLICE_16			(7 << 5)
+
+/* Low priority grace period page size */
+#define   MI_ARB_LOW_PRIORITY_GRACE_4KB		(0 << 4)	/* default */
+#define   MI_ARB_LOW_PRIORITY_GRACE_8KB		(1 << 4)
+
+/* Disable display A/B trickle feed */
+#define   MI_ARB_DISPLAY_TRICKLE_FEED_DISABLE	(1 << 2)
+
+/* Set display plane priority */
+#define   MI_ARB_DISPLAY_PRIORITY_A_B		(0 << 0)	/* display A > display B */
+#define   MI_ARB_DISPLAY_PRIORITY_B_A		(1 << 0)	/* display B > display A */
+
 #define CACHE_MODE_0	0x02120 /* 915+ only */
 #define   CM0_MASK_SHIFT          16
 #define   CM0_IZ_OPT_DISABLE      (1<<6)


