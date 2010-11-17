Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267Ab0KQEoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:44:12 -0500
Received: from waste.org ([173.11.57.241]:57781 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950Ab0KQEoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:44:10 -0500
Subject: Re: Behavior of BUG() [Was: Re: [PATCH 2/5] of/fdt: add kernel
 command line option for dtb_compat string]
From: Matt Mackall <mpm@selenic.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        dirk.brandewie@gmail.com, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org
In-Reply-To: <AANLkTinz27cfdNKEtyUo9f3nuw+XbZ2Osz0ThRiOQnnL@mail.gmail.com>
References: <AANLkTinop4_JT4JLtdmWkydPgDDU=TyZNbtiBbgeh1dj@mail.gmail.com>
	 <AANLkTimQtXeCE1Gu4YuPBBZ_J3ieW6Z5JtvzF=hF7pWX@mail.gmail.com>
	 <AANLkTinz27cfdNKEtyUo9f3nuw+XbZ2Osz0ThRiOQnnL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 22:44:06 -0600
Message-ID: <1289969046.26343.380.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 23:29 -0500, Arnaud Lacombe wrote:
> Hi,
> 
> On Tue, Nov 16, 2010 at 11:13 PM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
> > On Tue, Nov 16, 2010 at 8:45 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> >> Hi,
> >>
> >> [CC: list reduced as starting a new thread, most on the context
> >> removed as this concern a different issue.]
> >>
> >> On Tue, Nov 16, 2010 at 7:16 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> >>> On Tue, Nov 16, 2010 at 3:41 PM,  <dirk.brandewie@gmail.com> wrote:
> >>>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> >>>> [...]
> >>> The kernel needs to complain *loudly* if this occurs because it
> >>> represents a bug.  I'm tempted to say use BUG, but that would halt the
> >>> kernel and prevent any possibility of kernel log output.
> >>> [...]
> >> does it ? if CONFIG_BUG is not enabled and the arch has no define for
> >> it, the default does _nothing_:
> >>
> >> from `include/asm-generic/bug.h':
> >>
> >> #else /* !CONFIG_BUG */
> >> #ifndef HAVE_ARCH_BUG
> >> #define BUG() do {} while(0)
> >> #endif
> >>
> >> #ifndef HAVE_ARCH_BUG_ON
> >> #define BUG_ON(condition) do { if (condition) ; } while(0)
> >> #endif
> >> [...]
> >>
> >> gcc is triggering about ~30 warnings (like [0]) on code path using
> >> BUG(). Most of these path assume BUG() will never return, which is not
> >> true.
> >
> > As far as I know, BUG() is not supposed to return.  Period.
> >
> but the code I pointed out _do_ return.
> 
> > The patch
> > below is part of the linux-tiny work, and should only ever be used on
> > embedded systems where small size is more important than debugability.
> >
> AFAIK, this is not precised anywhere, but I may not have search enough.

Read the help for CONFIG_BUG and CONFIG_EMBEDDED.

> Matt, any reason the generic code does not just spin (or OOPS) and
> marked __noreturn in any case ?

Yes. Spinning and oopsing take space. Function calls take space. The
whole damn point of this option is to say is _we don't care about BUGs,
we care about space_. In other words, this code is a hack and is marked
as such. Arguing about "correctness" here is a waste of time, it's
intentionally not correct.

I seem to recall attempting to fool GCC with a __noreturn and failing.

-- 
Mathematics is the supreme nostalgia of our time.


