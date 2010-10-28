Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106Ab0J1Wln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:41:43 -0400
Received: from relay3.sgi.com ([192.48.152.1]:35294 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758888Ab0J1Wlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:41:35 -0400
Date: Thu, 28 Oct 2010 17:41:32 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
        Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>
Subject: [PATCH] x86, uv: More Westmere support on SGI UV
Message-ID: <20101028224132.GB15804@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86, uv: More Westmere support on SGI UV

Enable Westmere support on all apic modes on SGI UV.

Signed-off-by: Russ Anderson <rja@sgi.com>

---

 arch/x86/kernel/apic/x2apic_uv_x.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-10-28 16:39:23.771774569 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-10-28 16:45:52.295342718 -0500
@@ -71,7 +71,7 @@ static int early_get_nodeid(void)
 	return node_id.s.node_id;
 }
 
-static int __init early_get_apic_pnode_shift(void)
+static void __init early_get_apic_pnode_shift(void)
 {
 	unsigned long *mmr;
 
@@ -83,8 +83,6 @@ static int __init early_get_apic_pnode_s
 		 * Old bios, use default value
 		 */
 		uvh_apicid.s.pnode_shift = UV_APIC_PNODE_SHIFT;
-
-	return uvh_apicid.s.pnode_shift;
 }
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
@@ -93,6 +91,7 @@ static int __init uv_acpi_madt_oem_check
 
 	if (!strcmp(oem_id, "SGI")) {
 		nodeid = early_get_nodeid();
+		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		x86_platform.nmi_init = uv_nmi_init;
 		if (!strcmp(oem_table_id, "UVL"))
@@ -101,7 +100,7 @@ static int __init uv_acpi_madt_oem_check
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				nodeid << (early_get_apic_pnode_shift() - 1);
+				nodeid << (uvh_apicid.s.pnode_shift - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
