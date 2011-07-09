Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1GIABT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 20:01:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:52128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1GIABS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 20:01:18 -0400
Date: Sat, 9 Jul 2011 00:01:03 GMT
From: tip-bot for Anupam Chanda <achanda@nicira.com>
Message-ID: <tip-24a42bae6852d27ae569757f5415c91538e6a255@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, eddie.dong@intel.com,
        stefano.stabellini@eu.citrix.com, achanda@nicira.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, eddie.dong@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, achanda@nicira.com
In-Reply-To: <1310150570-26810-1-git-send-email-achanda@nicira.com>
References: <1310150570-26810-1-git-send-email-achanda@nicira.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/detect-hyper] x86, hyper: Change hypervisor detection order
Git-Commit-ID: 24a42bae6852d27ae569757f5415c91538e6a255
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 09 Jul 2011 00:01:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24a42bae6852d27ae569757f5415c91538e6a255
Gitweb:     http://git.kernel.org/tip/24a42bae6852d27ae569757f5415c91538e6a255
Author:     Anupam Chanda <achanda@nicira.com>
AuthorDate: Fri, 8 Jul 2011 11:42:50 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 8 Jul 2011 16:22:29 -0700

x86, hyper: Change hypervisor detection order

Detect Xen before HyperV because in Viridian compatibility mode Xen
presents itself as HyperV.  Move Xen to the top since it seems more
likely that Xen would emulate VMware than vice versa.

Signed-off-by: Anupam Chanda <achanda@nicira.com>
Link: http://lkml.kernel.org/r/1310150570-26810-1-git-send-email-achanda@nicira.com
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/hypervisor.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 8095f86..755f64f 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -32,11 +32,11 @@
  */
 static const __initconst struct hypervisor_x86 * const hypervisors[] =
 {
-	&x86_hyper_vmware,
-	&x86_hyper_ms_hyperv,
 #ifdef CONFIG_XEN_PVHVM
 	&x86_hyper_xen_hvm,
 #endif
+	&x86_hyper_vmware,
+	&x86_hyper_ms_hyperv,
 };
 
 const struct hypervisor_x86 *x86_hyper;
