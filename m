Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab0J2FkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:40:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab0J2FkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:40:19 -0400
Date: Fri, 29 Oct 2010 05:40:00 GMT
From: tip-bot for Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20101028224132.GB15804@sgi.com>
References: <20101028224132.GB15804@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, uv: More Westmere support on SGI UV
Message-ID: <tip-0520bd8438f18f2b1b2af5fd1c4ecc070a1bf837@git.kernel.org>
Git-Commit-ID: 0520bd8438f18f2b1b2af5fd1c4ecc070a1bf837
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Oct 2010 05:40:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0520bd8438f18f2b1b2af5fd1c4ecc070a1bf837
Gitweb:     http://git.kernel.org/tip/0520bd8438f18f2b1b2af5fd1c4ecc070a1bf837
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Thu, 28 Oct 2010 17:41:32 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 28 Oct 2010 22:38:07 -0700

x86, uv: More Westmere support on SGI UV

Enable Westmere support for all APIC modes on SGI UV.

Signed-off-by: Russ Anderson <rja@sgi.com>
LKML-Reference: <20101028224132.GB15804@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 0a2918e..ed4118d 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -71,7 +71,7 @@ static int early_get_nodeid(void)
 	return node_id.s.node_id;
 }
 
-static int __init early_get_apic_pnode_shift(void)
+static void __init early_get_apic_pnode_shift(void)
 {
 	unsigned long *mmr;
 
@@ -83,8 +83,6 @@ static int __init early_get_apic_pnode_shift(void)
 		 * Old bios, use default value
 		 */
 		uvh_apicid.s.pnode_shift = UV_APIC_PNODE_SHIFT;
-
-	return uvh_apicid.s.pnode_shift;
 }
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
@@ -93,6 +91,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 	if (!strcmp(oem_id, "SGI")) {
 		nodeid = early_get_nodeid();
+		early_get_apic_pnode_shift();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		x86_platform.nmi_init = uv_nmi_init;
 		if (!strcmp(oem_table_id, "UVL"))
@@ -101,7 +100,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				nodeid << (early_get_apic_pnode_shift() - 1);
+				nodeid << (uvh_apicid.s.pnode_shift - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
