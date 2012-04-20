Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2DTWIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:08:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34201 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2DTWIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:08:13 -0400
Date: Fri, 20 Apr 2012 15:08:01 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-3ee89722cfb165295cc8eb498018c0bdafc57062@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mtosatti@redhat.com, david.daney@cavium.com, tglx@linutronix.de,
        avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, david.daney@cavium.com, tglx@linutronix.de,
        avi@redhat.com
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/include/asm/kvm_host
 .h
Git-Commit-ID: 3ee89722cfb165295cc8eb498018c0bdafc57062
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:08:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ee89722cfb165295cc8eb498018c0bdafc57062
Gitweb:     http://git.kernel.org/tip/3ee89722cfb165295cc8eb498018c0bdafc57062
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 13:41:59 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:40 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/include/asm/kvm_host.h

Remove open-coded exception table entries in arch/x86/include/asm/kvm_host.h,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/include/asm/kvm_host.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e216ba0..e5b97be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/msr-index.h>
+#include <asm/asm.h>
 
 #define KVM_MAX_VCPUS 254
 #define KVM_SOFT_MAX_VCPUS 160
@@ -921,9 +922,7 @@ extern bool kvm_rebooting;
 	__ASM_SIZE(push) " $666b \n\t"	      \
 	"call kvm_spurious_fault \n\t"	      \
 	".popsection \n\t" \
-	".pushsection __ex_table, \"a\" \n\t" \
-	_ASM_PTR " 666b, 667b \n\t" \
-	".popsection"
+	_ASM_EXTABLE(666b, 667b)
 
 #define __kvm_handle_fault_on_reboot(insn)		\
 	____kvm_handle_fault_on_reboot(insn, "")
