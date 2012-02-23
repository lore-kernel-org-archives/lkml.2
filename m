Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab2BWWfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:35:02 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47654 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab2BWWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:34:59 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, JBeulich@novell.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] xen/setup/pm/acpi: Remove the call to boot_option_idle_override.
Date: Thu, 23 Feb 2012 17:31:08 -0500
Message-Id: <1330036270-20015-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1330036270-20015-1-git-send-email-konrad.wilk@oracle.com>
References: <1330036270-20015-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F46BF09.00A0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We needed that call in the past to force the kernel to use
default_idle (which called safe_halt, which called xen_safe_halt).

But set_pm_idle_to_default() does now that, so there is no need
to use this boot option operand.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index e03c636..1236623 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -420,7 +420,6 @@ void __init xen_arch_setup(void)
 	boot_cpu_data.hlt_works_ok = 1;
 #endif
 	disable_cpuidle();
-	boot_option_idle_override = IDLE_HALT;
 	WARN_ON(set_pm_idle_to_default());
 	fiddle_vdso();
 }
-- 
1.7.9.48.g85da4d

