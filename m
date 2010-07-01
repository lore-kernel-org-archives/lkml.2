Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab0GAVTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:19:44 -0400
Received: from kroah.org ([198.145.64.141]:33252 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156Ab0GAVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:27 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:02 2010
Message-Id: <20100701174302.326830955@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [187/200] KVM: SVM: Report emulated SVM features to userspace
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

This patch implements the reporting of the emulated SVM
features to userspace instead of the real hardware
capabilities. Every real hardware capability needs emulation
in nested svm so the old behavior was broken.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit c2c63a493924e09a1984d1374a0e60dfd54fc0b0)
---
 arch/x86/kvm/svm.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2909,6 +2909,16 @@ static void svm_cpuid_update(struct kvm_
 
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
+	switch (func) {
+	case 0x8000000A:
+		entry->eax = 1; /* SVM revision 1 */
+		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
+				   ASID emulation to nested SVM */
+		entry->ecx = 0; /* Reserved */
+		entry->edx = 0; /* Do not support any additional features */
+
+		break;
+	}
 }
 
 static const struct trace_print_flags svm_exit_reasons_str[] = {


