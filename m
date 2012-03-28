Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab2C1Scl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:32:41 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33681 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683Ab2C1Scj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:32:39 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.46.74
Date: Wed, 28 Mar 2012 11:32:28 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] kvm-amd: Auto-load on CPUs with SVM.
Message-ID: <20120328183228.GA24889@leaf>
References: <20120321063350.GA3468@leaf>
 <4F72F549.6060407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F72F549.6060407@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable x86 feature-based autoloading for the kvm-amd module on CPUs
with X86_FEATURE_SVM.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

On Wed, Mar 28, 2012 at 01:26:01PM +0200, Avi Kivity wrote:
> On 03/21/2012 08:33 AM, Josh Triplett wrote:
> > Enable x86 feature-based autoloading for the kvm-intel module on CPUs
> > with X86_FEATURE_VMX.
> 
> Thanks, applied.

As promised, the corresponding patch for kvm-amd.

 arch/x86/kvm/svm.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e385214..cd95ea7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -22,6 +22,7 @@
 #include "x86.h"
 
 #include <linux/module.h>
+#include <linux/mod_devicetable.h>
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
 #include <linux/highmem.h>
@@ -42,6 +43,12 @@
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
+static const struct x86_cpu_id svm_cpu_id[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_SVM),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
+
 #define IOPM_ALLOC_ORDER 2
 #define MSRPM_ALLOC_ORDER 1
 
