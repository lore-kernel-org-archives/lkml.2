Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2GaRcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:32:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:8785 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab2GaRcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:32:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="179883329"
Subject: Re: [patch] x86, avx: don't use avx instructions with "noxsave"
 boot param
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: NeilBrown <neilb@suse.de>, james.t.kukunas@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 31 Jul 2012 10:29:14 -0700
In-Reply-To: <50180B2A.6070602@zytor.com>
References: <1343688375.3696.597.camel@sbsiddha-desk.sc.intel.com>
	  <20120731142049.7d0ab5f9@notabene.brown>
	  <7b101443-b8d7-4474-ab54-03692d232469@email.android.com>
	 <1343752022.3696.602.camel@sbsiddha-desk.sc.intel.com>
	 <50180B2A.6070602@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1343755754.2041.2.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 09:43 -0700, H. Peter Anvin wrote:
> My main reason for thinking that it would be good to clear the bits is 
> that it plays a lot nicer with alternatives and with static_cpu_has().

Fair enough. Neil, can you please drop the previous patch and Peter,
please queue this for v3.6. Thanks.

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, avx: don't use avx instructions with "noxsave" boot param

Clear AVX, AVX2 features along with clearing XSAVE feature bits,
as part of the parsing "noxsave" parameter.

Fixes the kernel boot panic with "noxsave" boot parameter.

We could have checked cpu_has_osxsave along with cpu_has_avx etc, but Peter
mentioned clearing the feature bits will be better for uses like
static_cpu_has() etc.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org	# v3.5
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


