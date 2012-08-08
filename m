Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2HHW0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:26:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2HHWZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:25:59 -0400
Date: Wed, 8 Aug 2012 15:25:46 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-c6fd893da927c6cefb2ece22402765379921a834@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1343755754.2041.2.camel@sbsiddha-desk.sc.intel.com>
References: <1343755754.2041.2.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, avx: don't use avx instructions with "
 noxsave" boot param
Git-Commit-ID: c6fd893da927c6cefb2ece22402765379921a834
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 08 Aug 2012 15:25:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6fd893da927c6cefb2ece22402765379921a834
Gitweb:     http://git.kernel.org/tip/c6fd893da927c6cefb2ece22402765379921a834
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 31 Jul 2012 10:29:14 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 8 Aug 2012 13:41:42 -0700

x86, avx: don't use avx instructions with "noxsave" boot param

Clear AVX, AVX2 features along with clearing XSAVE feature bits,
as part of the parsing "noxsave" parameter.

Fixes the kernel boot panic with "noxsave" boot parameter.

We could have checked cpu_has_osxsave along with cpu_has_avx etc, but Peter
mentioned clearing the feature bits will be better for uses like
static_cpu_has() etc.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1343755754.2041.2.camel@sbsiddha-desk.sc.intel.com
Cc: <stable@vger.kernel.org>	# v3.5
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/common.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 46d8786..a5fbc3c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -144,6 +144,8 @@ static int __init x86_xsave_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	setup_clear_cpu_cap(X86_FEATURE_AVX);
+	setup_clear_cpu_cap(X86_FEATURE_AVX2);
 	return 1;
 }
 __setup("noxsave", x86_xsave_setup);
