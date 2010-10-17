Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab0JQXfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 19:35:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43983 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0JQXfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 19:35:42 -0400
Date: Mon, 18 Oct 2010 10:35:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: linux-next: manual merge of the msm tree with the arm tree
Message-Id: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Today's linux-next merge of the msm tree got a conflict in
arch/arm/mach-msm/include/mach/debug-macro.S between commit
08a610d9ef5394525b0328da0162d7b58c982cc4 ("arm: return both physical and
virtual addresses from addruart") from the arm tree and commit
46fe5f29e3062f681cc3cf07a604d82396faea89 ("msm: allow uart to be
conditionally disabled") from the msm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-msm/include/mach/debug-macro.S
index 3c35b0d,238c4f1..0000000
--- a/arch/arm/mach-msm/include/mach/debug-macro.S
+++ b/arch/arm/mach-msm/include/mach/debug-macro.S
@@@ -19,11 -19,13 +19,11 @@@
  #include <mach/hardware.h>
  #include <mach/msm_iomap.h>
  
- #ifdef CONFIG_MSM_DEBUG_UART
+ #ifdef CONFIG_HAS_MSM_DEBUG_UART_PHYS
 -	.macro	addruart, rx, tmp
 +	.macro	addruart, rp, rv
  	@ see if the MMU is enabled and select appropriate base address
 -	mrc	p15, 0, \rx, c1, c0
 -	tst	\rx, #1
 -	ldreq	\rx, =MSM_DEBUG_UART_PHYS
 -	ldrne	\rx, =MSM_DEBUG_UART_BASE
 +	ldr	\rp, =MSM_DEBUG_UART_PHYS
 +	ldr	\rv, =MSM_DEBUG_UART_BASE
  	.endm
  
  	.macro	senduart,rd,rx
