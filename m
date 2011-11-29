Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1K2VBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:01:03 -0500
Received: from relay2.sgi.com ([192.48.179.30]:37651 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756694Ab1K2VBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:01:01 -0500
Date: Tue, 29 Nov 2011 15:00:58 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH resend] x86, UV - UV2 fix for hub part number
Message-ID: <20111129210058.GA20452@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a mixup when the SGI UV2 hub chip was sent to be fabricated, and it
ended up with the wrong part number in the HRP_NODE_ID mmr. Future versions
of the chip will (may) have the correct part number. Change the UV infrastructure
to recognize both part numbers as valid IDs of a UV2 hub chip.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/include/asm/uv/uv_mmrs.h  |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 ++
 2 files changed, 3 insertions(+)

Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2011-10-07 11:17:23.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2011-10-07 11:21:07.555566441 -0500
@@ -57,6 +57,7 @@
 
 #define UV1_HUB_PART_NUMBER	0x88a5
 #define UV2_HUB_PART_NUMBER	0x8eb8
+#define UV2_HUB_PART_NUMBER_X	0x1111
 
 /* Compat: if this #define is present, UV headers support UV2 */
 #define UV2_HUB_IS_SUPPORTED	1
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2011-10-07 11:20:28.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2011-10-07 11:21:56.574608699 -0500
@@ -93,6 +93,8 @@ static int __init early_get_pnodeid(void
 
 	if (node_id.s.part_number == UV2_HUB_PART_NUMBER)
 		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
+	if (node_id.s.part_number == UV2_HUB_PART_NUMBER_X)
+		uv_min_hub_revision_id += UV2_HUB_REVISION_BASE - 1;
 
 	uv_hub_info->hub_revision = uv_min_hub_revision_id;
 	pnode = (node_id.s.node_id >> 1) & ((1 << m_n_config.s.n_skt) - 1);
