Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab1F3L2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:28:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55049 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1F3L2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:28:17 -0400
Date: Thu, 30 Jun 2011 12:28:04 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Qin Dehua <qindehua@gmail.com>
Cc: linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com,
        dan.j.williams@intel.com, neilb@suse.de
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause
	OOPS
Message-ID: <20110630112804.GA21481@flint.arm.linux.org.uk>
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com> <20110630074301.GC27959@flint.arm.linux.org.uk> <BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 07:16:24PM +0800, Qin Dehua wrote:
> Commit 2ffe2da3e follows v2.6.32, the message is from kernel build on
> commit 2ffe2da3e.
> 
> The config has CONFIG_BUG=y and CONFIG_DEBUG_BUGVERBOSE=y, but the
> message is Oops, not BUG() macro, so they don't have line number.

In that case, the raid5 code contains an explicit NULL pointer
dereference which isn't a BUG() - the code line disassembles to:

   0:   ebfff1bc        bl      0xffffc6f8
   4:   e28dd044        add     sp, sp, #68     ; 0x44
   8:   e8bd8ff0        pop     {r4, r5, r6, r7, r8, r9, sl, fp, pc}
   c:   e3a03000        mov     r3, #0  ; 0x0
  10:   e5833000        str     r3, [r3] <=== faulting instruction

So, if you're saying that's not a BUG(), then I don't know what it is
and I'm afraid I can't help because the oops doesn't make any sense
to me.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
