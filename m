Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0IACNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:13:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0IACNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:13:04 -0400
Date: Tue, 31 Aug 2010 22:13:02 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: airlied@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH trivial] drm: log level in print_hex_dump_bytes is redundant
Message-ID: <20100901021302.GX2684@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ends up with a dmesg like:
[drm:drm_edid_block_valid] *ERROR* Raw EDID:
<3>00 ff ff ff ff ff ff 00 10 ac 29 a0 53 48 4e 31  ..........).SHN1
<3>14 12 01 03 0e 34 20 7f ff ff ff ff ff ff ff ff  .....4 .........

Since print_hex_dump_bytes implicitly adds KERN_DEBUG.

Would probably be nice to pretty print the encoder that found the bad
EDID, but it seems in some cases another caller of drm_edid_is_valid
will do that, so probably unnecessary...

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 96e9631..32a167c 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -186,7 +186,7 @@ drm_edid_block_valid(u8 *raw_edid)
 bad:
 	if (raw_edid) {
 		DRM_ERROR("Raw EDID:\n");
-		print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE, raw_edid, EDID_LENGTH);
+		print_hex_dump_bytes("", DUMP_PREFIX_NONE, raw_edid, EDID_LENGTH);
 		printk("\n");
 	}
 	return 0;
