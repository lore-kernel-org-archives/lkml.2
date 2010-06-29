Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0F2HHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:07:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:39170 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab0F2HH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:07:26 -0400
Date: Tue, 29 Jun 2010 07:07:04 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, laijs@cn.fujitsu.com
In-Reply-To: <4C2474EF.4050902@cn.fujitsu.com>
References: <4C2474EF.4050902@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/alternatives] x86, alternatives: correct obsolete use of "u8" in static_cpu_has()
Message-ID: <tip-a3d2d12f275fcd33d7edc34e6b4112b5a3c9d35d@git.kernel.org>
Git-Commit-ID: a3d2d12f275fcd33d7edc34e6b4112b5a3c9d35d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 07:07:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3d2d12f275fcd33d7edc34e6b4112b5a3c9d35d
Gitweb:     http://git.kernel.org/tip/a3d2d12f275fcd33d7edc34e6b4112b5a3c9d35d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 28 Jun 2010 12:00:18 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 28 Jun 2010 22:04:47 -0700

x86, alternatives: correct obsolete use of "u8" in static_cpu_has()

gcc seems to pass unsigned words on as signed to the assembler, at
least with the %P format.  As such, it is critical to get the correct
type.

Furthermore we are no longer limited to features < 256.

Reported-and-tested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4C2474EF.4050902@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 66878c5..e8b8896 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -291,7 +291,7 @@ extern const char * const x86_power_flags[32];
  * patch the target code for additional performance.
  *
  */
-static __always_inline __pure bool __static_cpu_has(u8 bit)
+static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
 #if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
 		asm goto("1: jmp %l[t_no]\n"
@@ -339,7 +339,7 @@ static __always_inline __pure bool __static_cpu_has(u8 bit)
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
 		boot_cpu_has(bit) :				\
-	(__builtin_constant_p(bit) && !((bit) & ~0xff)) ?	\
+	__builtin_constant_p(bit) ?				\
 		__static_cpu_has(bit) :				\
 		boot_cpu_has(bit)				\
 )
