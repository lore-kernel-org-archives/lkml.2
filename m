Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab2JaDfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:35:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2JaDfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:35:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,684,1344182400"; 
   d="scan'208";a="6104067"
Message-ID: <50909C35.9080702@cn.fujitsu.com>
Date: Wed, 31 Oct 2012 11:34:13 +0800
From: zhangyanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: x86@kernel.org, kexec@lists.infradead.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v3 2/2] KVM: make crash_clear_loaded_vmcss valid when loading
 kvm_intel module
References: <50909B55.2070901@cn.fujitsu.com>
In-Reply-To: <50909B55.2070901@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 11:34:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 11:34:52,
	Serialize complete at 2012/10/31 11:34:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/kvm/vmx.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4ff0ab9..f6a16b2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -41,6 +41,7 @@
 #include <asm/i387.h>
 #include <asm/xcr.h>
 #include <asm/perf_event.h>
+#include <asm/kexec.h>
 
 #include "trace.h"
 
@@ -7230,6 +7231,10 @@ static int __init vmx_init(void)
 	if (r)
 		goto out3;
 
+#ifdef CONFIG_KEXEC
+	crash_clear_loaded_vmcss = vmclear_local_loaded_vmcss;
+#endif
+
 	vmx_disable_intercept_for_msr(MSR_FS_BASE, false);
 	vmx_disable_intercept_for_msr(MSR_GS_BASE, false);
 	vmx_disable_intercept_for_msr(MSR_KERNEL_GS_BASE, true);
@@ -7265,6 +7270,10 @@ static void __exit vmx_exit(void)
 	free_page((unsigned long)vmx_io_bitmap_b);
 	free_page((unsigned long)vmx_io_bitmap_a);
 
+#ifdef CONFIG_KEXEC
+	crash_clear_loaded_vmcss = NULL;
+#endif
+
 	kvm_exit();
 }
 
-- 
1.7.1

