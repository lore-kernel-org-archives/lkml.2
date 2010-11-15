Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab0KORpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:45:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933230Ab0KORpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:45:19 -0500
Date: Mon, 15 Nov 2010 18:44:49 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Jim Bos <jim876@xs4all.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115174449.GW29412@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <m3lj52txaq.fsf@redhat.com>
 <4CD97A3D.1040602@xs4all.nl>
 <m31v6nmmr3.fsf@jhcloos.com>
 <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
 <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box>
 <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
 <20101115113739.GH7269@basil.fritz.box>
 <4CE16F86.40808@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE16F86.40808@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 06:36:06PM +0100, Jim Bos wrote:
> On 11/15/2010 12:37 PM, Andi Kleen wrote:
> See attached, note this is the vanilla 2.6.36 i8k.c (without any patch).
> And to be 100% sure, if I build this (make drivers/char/i8k.ko) it won't
> work.
> 
> [ The i8k.i is rather big, even gzipped 80k, not sure if it'll bounce ]

Please also say which exact gcc you are using.

Note, I've compiled it with current 4.5 branch and made the function
always_inline and still didn't see any issues in the *.optimized dump,
regs.eax after the inline asm has always been compared to the constant
that has been stored into regs.eax before the inline asm.

	Jakub
