Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab0EIITL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 04:19:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:43983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0EIITH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 04:19:07 -0400
Date: Sun, 9 May 2010 08:18:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       dtor@vmware.com, tglx@linutronix.de, akataria@vmware.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       dtor@vmware.com, tglx@linutronix.de, akataria@vmware.com
In-Reply-To: <4BE49778.6060800@zytor.com>
References: <4BE49778.6060800@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, hypervisor: Export the x86_hyper* symbols
Message-ID: <tip-96f6e775b58687d85ee33004d414419b5ec34106@git.kernel.org>
Git-Commit-ID: 96f6e775b58687d85ee33004d414419b5ec34106
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 09 May 2010 08:18:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96f6e775b58687d85ee33004d414419b5ec34106
Gitweb:     http://git.kernel.org/tip/96f6e775b58687d85ee33004d414419b5ec34106
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sun, 9 May 2010 01:10:34 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 9 May 2010 01:10:34 -0700

x86, hypervisor: Export the x86_hyper* symbols

Export x86_hyper and the related specific structures, allowing for
hypervisor identification by modules.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Ky Srinivasan <ksrinivasan@novell.com>
Cc: Dmitry Torokhov <dtor@vmware.com>
LKML-Reference: <4BE49778.6060800@zytor.com>
---
 arch/x86/kernel/cpu/hypervisor.c |    1 +
 arch/x86/kernel/cpu/mshyperv.c   |    1 +
 arch/x86/kernel/cpu/vmware.c     |    2 +-
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8738175..4afb5a2 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -36,6 +36,7 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 };
 
 const struct hypervisor_x86 *x86_hyper;
+EXPORT_SYMBOL(x86_hyper);
 
 static inline void __init
 detect_hypervisor_vendor(void)
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 5969c3e..0f13717 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -51,3 +51,4 @@ const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
 	.detect			= ms_hyperv_platform,
 	.init_platform		= ms_hyperv_init_platform,
 };
+EXPORT_SYMBOL(x86_hyper_ms_hyperv);
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 265b432..b9d1ff5 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -99,7 +99,6 @@ static bool __init vmware_platform(void)
 
 	return false;
 }
-EXPORT_SYMBOL(vmware_platform);
 
 /*
  * VMware hypervisor takes care of exporting a reliable TSC to the guest.
@@ -125,3 +124,4 @@ const __refconst struct hypervisor_x86 x86_hyper_vmware = {
 	.set_cpu_features	= vmware_set_cpu_features,
 	.init_platform		= vmware_platform_setup,
 };
+EXPORT_SYMBOL(x86_hyper_vmware);
