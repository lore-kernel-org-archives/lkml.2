Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2CUGeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:34:06 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52431 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2CUGeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:34:03 -0400
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.46.74
Date: Tue, 20 Mar 2012 23:33:51 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm-intel: Auto-load on CPUs with VMX.
Message-ID: <20120321063350.GA3468@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable x86 feature-based autoloading for the kvm-intel module on CPUs
with X86_FEATURE_VMX.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

I've tested this and it works correctly.  I can also supply the obvious
equivalent patch for kvm-amd on AMD CPUs with SVM, but I don't have any
such CPUs to test that on.

 arch/x86/kvm/vmx.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3b4c8d8..bb3bcff 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -27,6 +27,7 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/moduleparam.h>
+#include <linux/mod_devicetable.h>
 #include <linux/ftrace_event.h>
 #include <linux/slab.h>
 #include <linux/tboot.h>
@@ -51,6 +52,12 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+static const struct x86_cpu_id vmx_cpu_id[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_VMX),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, vmx_cpu_id);
+
 static bool __read_mostly enable_vpid = 1;
 module_param_named(vpid, enable_vpid, bool, 0444);
 
-- 
1.7.9.1

