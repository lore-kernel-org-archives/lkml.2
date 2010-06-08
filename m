Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0FHPaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:30:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65150 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab0FHPaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:30:23 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: ARM defconfig files
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<1275584003.23384.2.camel@c-dwalke-linux.qualcomm.com>
Date: Tue, 08 Jun 2010 16:30:00 +0100
In-Reply-To: <1275584003.23384.2.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Thu, 03 Jun 2010 09:53:23 -0700")
Message-ID: <tnxeighczk7.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Jun 2010 15:30:05.0226 (UTC) FILETIME=[783438A0:01CB071F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@codeaurora.org> wrote:
> Have you noticed this ..
>
> http://ktrap.org/mailarchive/linux-kernel/2010/5/17/4571130
>
> I'm not sure of the goals, but it sounds like it might be relevant.

In some cases you don't want to automatically enable features but rather
fix the Kconfig file. For example, with the select dependencies patch
(http://lkml.org/lkml/2009/9/16/413) on ARMv7 RealView I get the
following:

warning: (CPU_V7 && !ARCH_OMAP2 || CPU_MMP2 && ARCH_MMP) selects
CPU_32v6K which has unmet direct dependencies (CPU_V6)

Unless I misunderstand this, a solver may try to select CPU_V6 which I
don't want to. The solution is to fix Kconfig as below:


Author: Catalin Marinas <catalin.marinas@arm.com>
Date:   Wed Aug 12 13:50:05 2009 +0100

    Mark CPU_32v6K as depended on CPU_V7
    
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 9f10a9b..a4909db 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -398,7 +398,7 @@ config CPU_V6
 # ARMv6k
 config CPU_32v6K
 	bool "Support ARM V6K processor extensions" if !SMP
-	depends on CPU_V6
+	depends on CPU_V6 || CPU_V7
 	default y if SMP && !(ARCH_MX3 || ARCH_OMAP2)
 	help
 	  Say Y here if your ARMv6 processor supports the 'K' extension.


-- 
Catalin
