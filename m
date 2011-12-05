Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1LEPKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 10:10:24 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45805 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab1LEPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 10:10:23 -0500
Date: Mon, 5 Dec 2011 16:10:16 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [GIT PULL] x86, microcode fixes for 3.2
Message-ID: <20111205151016.GC7834@aftab>
References: <20111128204311.GA2814@aftab>
 <20111202194658.GF15204@aftab>
 <20111205092612.GB29641@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205092612.GB29641@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 10:26:12AM +0100, Ingo Molnar wrote:
> Mind respinning this once more against latest -git? There's a 
> new conflict due to:
> 
>   8e8da023f5af: x86: Fix boot failures on older AMD CPU's

Branch is updated, it also contains the following patch:

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 5 Dec 2011 14:28:37 +0100
Subject: [PATCH] x86: Document rdmsr_safe restrictions

Recently, I got bitten by using rdmsr_safe too early in the boot
process. Document its shortcomings for future reference.

Link: http://lkml.kernel.org/r/4ED5B70F.606@lwfinger.net
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 084ef95..95203d4 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -169,7 +169,14 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 	return native_write_msr_safe(msr, low, high);
 }
 
-/* rdmsr with exception handling */
+/*
+ * rdmsr with exception handling.
+ *
+ * Please note that the exception handling works only after we've
+ * switched to the "smart" #GP handler in trap_init() which knows about
+ * exception tables - using this macro earlier than that causes machine
+ * hangs on boxes which do not implement the @msr in the first argument.
+ */
 #define rdmsr_safe(msr, p1, p2)					\
 ({								\
 	int __err;						\
-- 
1.7.8.rc0

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
