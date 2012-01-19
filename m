Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab2ASCIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:08:07 -0500
Received: from relay2.sgi.com ([192.48.179.30]:58472 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756904Ab2ASCH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:07:57 -0500
Date: Wed, 18 Jan 2012 20:07:54 -0600
From: Russ Anderson <rja@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: [PATCH] x86/uv: Fix uv_gpa_to_soc_phys_ram shift
Message-ID: <20120119020753.GA7228@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uv_gpa_to_soc_phys_ram() was inadvertently ignoring the
shift values.  This fix takes the shift into account.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/include/asm/uv/uv_hub.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2012-01-18 19:49:53.134409748 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2012-01-18 19:49:56.978409600 -0600
@@ -318,13 +318,13 @@ uv_gpa_in_mmr_space(unsigned long gpa)
 /* UV global physical address --> socket phys RAM */
 static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
 {
-	unsigned long paddr = gpa & uv_hub_info->gpa_mask;
+	unsigned long paddr;
 	unsigned long remap_base = uv_hub_info->lowmem_remap_base;
 	unsigned long remap_top =  uv_hub_info->lowmem_remap_top;
 
 	gpa = ((gpa << uv_hub_info->m_shift) >> uv_hub_info->m_shift) |
 		((gpa >> uv_hub_info->n_lshift) << uv_hub_info->m_val);
-	gpa = gpa & uv_hub_info->gpa_mask;
+	paddr = gpa & uv_hub_info->gpa_mask;
 	if (paddr >= remap_base && paddr < remap_base + remap_top)
 		paddr -= remap_base;
 	return paddr;
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
