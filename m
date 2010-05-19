Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0ESQTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:19:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58510 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0ESQT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:19:29 -0400
Date: Thu, 20 May 2010 01:18:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Luca Barbieri <luca@luca-barbieri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [GIT PULL] x86/atomic changes for v2.6.35
Message-ID: <20100519161828.GB16082@linux-sh.org>
References: <20100517224531.GA27400@elte.hu> <AANLkTinWbueCQZdQgZFDLQPJYieB13orxDGYJzzRpPni@mail.gmail.com> <4BF3F480.3000902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF3F480.3000902@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 07:24:00AM -0700, H. Peter Anvin wrote:
> On 05/19/2010 04:46 AM, Geert Uytterhoeven wrote:
> > On Tue, May 18, 2010 at 00:45, Ingo Molnar <mingo@elte.hu> wrote:
> >> Please pull the latest x86-atomic-for-linus git tree from:
> >>
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-atomic-for-linus
> >>
> >>
> >> out-of-topic modifications in x86-atomic-for-linus:
> >> ---------------------------------------------------
> >> lib/Makefile                       # 86a8938: lib: Add self-test for atomic64_t
> >> lib/atomic64.c                     # 9757789: lib: Fix atomic64_add_unless retu
> >> lib/atomic64_test.c                # a5c9161: x86, atomic64: In selftest, disti
> >>                                   # 25a304f: lib: Fix atomic64_inc_not_zero te
> >>                                   # 9efbcd5: lib: Fix atomic64_add_unless test
> >>                                   # d7f6de1: x86: Implement atomic[64]_dec_if_
> >>                                   # 8f4f202: lib: Only test atomic64_dec_if_po
> >>                                   # 86a8938: lib: Add self-test for atomic64_t
> > 
> > Is having atomic64_t mandatory now?
> > 
> > According to the allmodconfig build logs
> > (http://kisskb.ellerman.id.au/kisskb/matrix/),
> > several architectures (at least m68k and mips) don't have it.
> > Furthermore, the test fails to compile on a few architectures that do have it
> > (parisc, s390, sh, ...).
> > 
> > <boilerplate>
> > It's a pity this wasn't raised/resolved between its detection in linux-next and
> > before it entered mainline...
> > </boilerplate>
> > 
> 
> Is having atomic64_t mandatory?  Not yet, I don't think, but it probably
> will be soon -- which is why there is a generic implementation
> available.  All those architectures just need to select
> CONFIG_GENERIC_ATOMIC64 and voil??, problem solved.
> 
No, the problem isn't solved, you apparently overlooked the part of
Geert's mail that point out that the test fails to build on architecures
that _do_ have atomic64_t. All of arm/parisc/powerpc/sh select
GENERIC_ATOMIC64, suggesting that the test itself was only ever tested on
x86 and never on the generic implementation. While that may be par for
the course these days, it's still pretty poor form.

> As far as your boilerplate is concerned, I think Linus made it clear at
> the Kernel Summit that is it not the obligation of x86/ARM/PowerPC to
> slow down to not break the smaller architectures; it's the
> responsibility of those architecture maintainers to keep up.  Sorry.
> 
This keeping up thing gets thrown around a lot without any real basis.
Most of the GENERIC_ATOMIC64 architectures enabled support for it within
days of it being merged, if they've all been broken now because of an
x86-centric change then it's really not so much of a keeping up issue as
it is an issue of unreviewed and untested crap being merged before anyone
gets a chance to look at it.

The breakage in question isn't even related to the atomic64_t
implementation, it's just some trivial header stuff. It would be nice if
people would spend even a cursory amount of time looking in to these
things before throwing around tired generalizations of how everyone else
needs to "keep up".
