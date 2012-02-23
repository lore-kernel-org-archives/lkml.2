Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2BWJPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:15:48 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:49990 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2BWJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:15:16 -0500
From: Tang Liang <liang.tang@oracle.com>
To: mjg59@srcf.ucam.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        konrad.wilk@oracle.com, JBeulich@suse.com
Cc: liang.tang@oracle.com
Subject: [PATCH 4/5V2] Xen efi: Add xen efi enabled detect
Date: Thu, 23 Feb 2012 17:14:00 +0800
Message-Id: <1329988440-27004-1-git-send-email-liang.tang@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1329988283-26722-1-git-send-email-liang.tang@oracle.com>
References: <1329988283-26722-1-git-send-email-liang.tang@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090204.4F460340.0099,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use hypercall to detect the xen efi enabled or not.
If xen efi enable is set,replace the efi public function to xen efi public
function and set efi_enabled to 1 in the function efi_probe;

Signed-off-by: Tang Liang <liang.tang@oracle.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 12eb07b..92982c1 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -31,6 +31,7 @@
 #include <linux/pci.h>
 #include <linux/gfp.h>
 #include <linux/memblock.h>
+#include <linux/efi.h>
 
 #include <xen/xen.h>
 #include <xen/interface/xen.h>
@@ -1282,6 +1283,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_setup_runstate_info(0);
 
+	if (xen_initial_domain())
+		xen_efi_probe();
 	/* Start the world */
 #ifdef CONFIG_X86_32
 	i386_start_kernel();
-- 
1.7.7.5

