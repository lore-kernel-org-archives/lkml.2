Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab0KOTW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:22:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756811Ab0KOTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:22:27 -0500
MIME-Version: 1.0
In-Reply-To: <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
References: <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
 <4CE17098.8090000@xs4all.nl> <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
 <4CE17C4B.1070305@xs4all.nl> <20101115185848.GI2583@sunsite.ms.mff.cuni.cz> <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 15 Nov 2010 11:21:30 -0800
Message-ID: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
To: Jakub Jelinek <jakub@redhat.com>
Cc: Jim Bos <jim876@xs4all.nl>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:12 AM, Jakub Jelinek <jakub@redhat.com> wrote:
>
> Ah, the problem is that memory_identifier_string is only initialized in
> ipa-reference.c's initialization, so it can be (and is in this case) NULL in
> ipa-pure-const.c.

Ok. And I guess you can verify that all versions of gcc do this
correctly for "asm volatile"?

Because since we'll have to work around this problem in the kernel, I
suspect the simplest solution is to remove the "+m" that causes
register pressure problems, and then use "asm volatile" to work around
the const-function bug.

And add a large comment about why "asm volatile" is probably always a
good idea when you have a memory clobber and don't have any other
visible memory modifications.

I do wonder if this explains some of the problems we had with the
bitop asms too.

Hmm?

                       Linus
