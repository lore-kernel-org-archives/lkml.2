Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0KOKyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:54:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44093 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0KOKyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:54:50 -0500
Date: Mon, 15 Nov 2010 11:54:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org,
        Jim Bos <jim876@xs4all.nl>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115105446.GD7269@basil.fritz.box>
References: <877hgorrj1.fsf@basil.nowhere.org>
 <4CD843DC.10106@gmail.com>
 <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
 <20101109134816.GB29433@basil.fritz.box>
 <m3lj52txaq.fsf@redhat.com>
 <4CD97A3D.1040602@xs4all.nl>
 <m31v6nmmr3.fsf@jhcloos.com>
 <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
 <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And for this the starting point should be what has been requested,
> i.e. preprocessed source + gcc options + gcc version and some hints what
> actually misbehaves (with the , "+m" (*regs) change reverted)
> in gcc bugzilla.  Only with that we can actually look at what has been
> happening, see whether it is the tree optimizations or RTL and which one
> makes a difference.
> If I've missed a PR about this I apologize. 

I tried to file one, but I can't reproduce it currently
(I don't have hardware, so have to rely on code reading and the 32bit
code looks correct to me even without the additional +m)

The preprocessed source is at
http://halobates.de/tmp/i8k.i

Options I used:

 -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -m32 -msoft-float -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2 -march=i686 -mtune=pentium3 -mtune=generic -maccumulate-outgoing-args -Wa,-mtune=generic32 -ffreestanding -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -pg -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
