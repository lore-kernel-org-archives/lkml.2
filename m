Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab1ETN5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:57:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:48018 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ETN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:57:45 -0400
Date: Fri, 20 May 2011 09:58:45 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git merge branch
Message-ID: <20110520135845.GG25179@zod.rchland.ibm.com>
References: <1305777978.7481.37.camel@pasglop>
 <20110520132328.GA5785@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520132328.GA5785@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 03:23:29PM +0200, Richard Cochran wrote:
>When I try to build 'next' (now at 208b3a4c), it does not compile due
>to a change from the following commit.
>
>> Benjamin Herrenschmidt (1):
>>       powerpc/smp: Make start_secondary_resume available to all CPU variants
>
>I would appreciate your help in getting this fixed...

Could you try the patch below?

Commit 69e3cea8d5fd526 introduced start_secondary_resume to misc_32.S,
however it uses a 64-bit instruction which is not valid on 32-bit
platforms.  Use 'stw' instead.

Reported-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---

diff --git a/arch/powerpc/kernel/misc_32.S
b/arch/powerpc/kernel/misc_32.S
index 402560e..998a100 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -700,7 +700,7 @@ _GLOBAL(start_secondary_resume)
	rlwinm  r1,r1,0,0,(31-THREAD_SHIFT)     /* current_thread_info() */
	addi    r1,r1,THREAD_SIZE-STACK_FRAME_OVERHEAD
	li      r3,0
-	std     r3,0(r1)                /* Zero the stack frame pointer */
+	stw     r3,0(r1)                /* Zero the stack frame pointer */
	bl      start_secondary
	b       .
 #endif /* CONFIG_SMP */

