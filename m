Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab1LGVNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:13:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757860Ab1LGVNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:13:15 -0500
Date: Wed, 7 Dec 2011 16:12:38 -0500
From: Don Zickus <dzickus@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        robert.richter@amd.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [patch] x86, NMI: add to_cpumask() to silence compile warning
Message-ID: <20111207211238.GJ1669@redhat.com>
References: <1318533267-18880-3-git-send-email-dzickus@redhat.com>
 <tip-99e8b9ca90d688c3ac7d3a141b701c9694a93925@git.kernel.org>
 <20111206090612.GA18662@elte.hu>
 <20111206180859.GR1669@redhat.com>
 <20111207110612.GA3437@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111207110612.GA3437@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 02:06:12PM +0300, Dan Carpenter wrote:
> Gcc complains if we don't cast this to a struct cpumask pointer.
> arch/x86/kernel/nmi_selftest.c:93:2:
> 	warning: passing argument 1 of ‘cpumask_empty’ from
> 	incompatible pointer type [enabled by default]
> 

Crap, another fallout found by Randy.

Cheers,
Don

---8<---
From: Don Zickus <dzickus@redhat.com>
Date: Wed, 7 Dec 2011 16:03:40 -0500
Subject: [PATCH] x86, NMI: NMI selftest depends on the local apic

The selftest doesn't work with out a local apic for now.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 020a4f1..d6eea6d 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -286,7 +286,7 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 config DEBUG_NMI_SELFTEST
 	bool "NMI Selftest"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && X86_LOCAL_APIC
 	---help---
 	  Enabling this option turns on a quick NMI selftest to verify
 	  that the NMI behaves correctly.
-- 
1.7.6.4

