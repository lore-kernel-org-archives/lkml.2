Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab0IXQ4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:56:03 -0400
Received: from kroah.org ([198.145.64.141]:38279 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab0IXQ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:17 2010
Message-Id: <20100924162617.428279397@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, tiwai@suse.de,
        chris@chris-wilson.co.uk, Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [29/80] agp/intel: fix physical address mask bits for sandybridge
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

[This is backport patch from upstream 8dfc2b14.]

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-gtt.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1317,6 +1317,16 @@ static unsigned long intel_i965_mask_mem
 	return addr | bridge->driver->masks[type].mask;
 }
 
+static unsigned long intel_gen6_mask_memory(struct agp_bridge_data *bridge,
+					    dma_addr_t addr, int type)
+{
+	/* gen6 has bit11-4 for physical addr bit39-32 */
+	addr |= (addr >> 28) & 0xff0;
+
+	/* Type checking must be done elsewhere */
+	return addr | bridge->driver->masks[type].mask;
+}
+
 static void intel_i965_get_gtt_range(int *gtt_offset, int *gtt_size)
 {
 	u16 snb_gmch_ctl;
@@ -1535,7 +1545,7 @@ static const struct agp_bridge_driver in
 	.configure		= intel_i9xx_configure,
 	.fetch_size		= intel_i9xx_fetch_size,
 	.cleanup		= intel_i915_cleanup,
-	.mask_memory		= intel_i965_mask_memory,
+	.mask_memory		= intel_gen6_mask_memory,
 	.masks			= intel_i810_masks,
 	.agp_enable		= intel_i810_agp_enable,
 	.cache_flush		= global_cache_flush,


