Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0KHMUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:20:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab0KHMUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:20:03 -0500
Date: Mon, 8 Nov 2010 13:20:01 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Richard Guenther <richard.guenther@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
In-Reply-To: <877hgorrj1.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.1011081312570.29956@wotan.suse.de>
References: <4CD538CA.8010901@xs4all.nl> <87wroostw3.fsf@basil.nowhere.org>
 <m2hbfsu57i.fsf@igel.home> <87k4kospnd.fsf@basil.nowhere.org>
 <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
 <877hgorrj1.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 8 Nov 2010, Andi Kleen wrote:

> Richard Guenther <richard.guenther@gmail.com> writes:
> 
> > On Mon, Nov 8, 2010 at 12:03 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >> Andreas Schwab <schwab@linux-m68k.org> writes:
> >>>
> >>> The asm fails to mention that it modifies *regs.
> >>
> >> It has a memory clobber, that should be enough, no?
> >
> > No.  A memory clobber does not cover automatic storage.
> 
> That's a separate problem.
> 
> > Btw, I can't see a testcase anywhere so I just assume Andreas got
> > it right as usual.
> 
> An asm with live inputs and outputs should never be optimized
> way. If 4.5.1 started doing that it's seriously broken.

You know the drill: testcase -> gcc.gnu.org/bugzilla/

(In particular up to now it's only speculation in some forum that the asm 
really is optimized away, which I agree would be a bug, or if it isn't 
merely that regs->eax isn't reloaded after the asm(), which would be 
caused by the problem Andreas mentioned)


Ciao,
Michael.
