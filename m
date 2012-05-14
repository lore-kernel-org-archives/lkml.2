Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab2ENUcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:32:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60697 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab2ENUcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:32:05 -0400
Date: Mon, 14 May 2012 13:31:52 -0700
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-c3709e6734daa4d9b37fe31592ebb0eb57bae1bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org, mtosatti@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com, avi@redhat.com
In-Reply-To: <20120514174059.30236.1064.stgit@bluebook>
References: <20120514174059.30236.1064.stgit@bluebook>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, kvm: KVM paravirt kernels don'
 t check for CPUID being unavailable
Git-Commit-ID: c3709e6734daa4d9b37fe31592ebb0eb57bae1bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 13:31:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3709e6734daa4d9b37fe31592ebb0eb57bae1bb
Gitweb:     http://git.kernel.org/tip/c3709e6734daa4d9b37fe31592ebb0eb57bae1bb
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Mon, 14 May 2012 18:41:09 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 14 May 2012 10:49:32 -0700

x86, kvm: KVM paravirt kernels don't check for CPUID being unavailable

We set cpuid_level to -1 if there is no CPUID instruction (only
possible on i386).

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/20120514174059.30236.1064.stgit@bluebook
Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=12122
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/kvm_para.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 734c376..183922e 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -170,6 +170,9 @@ static inline int kvm_para_available(void)
 	unsigned int eax, ebx, ecx, edx;
 	char signature[13];
 
+	if (boot_cpu_data.cpuid_level < 0)
+		return 0;	/* So we don't blow up on old processors */
+
 	cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
 	memcpy(signature + 0, &ebx, 4);
 	memcpy(signature + 4, &ecx, 4);
