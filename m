Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0GWDPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 23:15:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54522 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0GWDPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 23:15:15 -0400
Date: Fri, 23 Jul 2010 13:15:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the catalin tree with the arm tree
Message-Id: <20100723131514.8d3b97e9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Today's linux-next merge of the catalin tree got a conflict in
arch/arm/kernel/entry-armv.S between commit
df0698be14c6683606d5df2d83e3ae40f85ed0d9 ("ARM: stack protector: change
the canary value per task") from the arm tree and commit
838105a674b7b72cb26c346155a40901c5bf7723 ("ARM: Remove the domain
switching on ARMv6k/v7 CPUs") from the catalin tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/entry-armv.S
index bb8e93a,d05e080..0000000
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@@ -737,12 -737,7 +737,12 @@@ ENTRY(__switch_to
  	ldr	r6, [r2, #TI_CPU_DOMAIN]
  #endif
  	set_tls	r3, r4, r5
 +#if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 +	ldr	r7, [r2, #TI_TASK]
 +	ldr	r8, =__stack_chk_guard
 +	ldr	r7, [r7, #TSK_STACK_CANARY]
 +#endif
- #ifdef CONFIG_MMU
+ #ifdef CONFIG_CPU_USE_DOMAINS
  	mcr	p15, 0, r6, c3, c0, 0		@ Set domain register
  #endif
  	mov	r5, r0
