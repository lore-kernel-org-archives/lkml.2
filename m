Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1E1PeV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:34:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:22408 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1E1PeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:34:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,285,1304319600"; 
   d="scan'208";a="3372401"
Date: Sat, 28 May 2011 08:34:17 -0700
From: Andi Kleen <ak@linux.intel.com>
To: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Will Deacon <Will.Deacon@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Disable -fconserve-stack on ARM
Message-ID: <20110528153417.GB25869@alboin.amr.corp.intel.com>
References: <20110525124348.GA2340@arm.com>
 <yw1xaaeanbxe.fsf@unicorn.mansr.com>
 <BANLkTim2TOZgB-3Vkv5RcK572Qr07s3=CA@mail.gmail.com>
 <1306429854.26735.9.camel@e102144-lin.cambridge.arm.com>
 <alpine.LFD.2.00.1105261650330.3207@xanadu.home>
 <20110526215101.GL24876@n2100.arm.linux.org.uk>
 <20110527083806.GA21100@e102109-lin.cambridge.arm.com>
 <20110527085414.GP24876@n2100.arm.linux.org.uk>
 <20110527095111.GC21100@e102109-lin.cambridge.arm.com>
 <yw1xlixse2fl.fsf@unicorn.mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yw1xlixse2fl.fsf@unicorn.mansr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a untested but straight forward patch to disable it.
-Andi

---

Disable -fconserve-stack on ARM

There are reports that -fconserve-stack misaligns variables on the stack.
Disable it for ARM to work around this gcc bug.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 25750bc..0883cff 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -41,6 +41,10 @@ ifeq ($(CONFIG_CC_STACKPROTECTOR),y)
 KBUILD_CFLAGS	+=-fstack-protector
 endif
 
+# ARM gcc developers unfortunately broke -fconserve-stack. It misaligns
+# variables on the stack
+KBUILD_CFLAGS += $(call cc-option,-fno-conserve-stack)
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN),y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 AS		+= -EB


