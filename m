Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab0JUXYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:24:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754Ab0JUXYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:24:11 -0400
Date: Thu, 21 Oct 2010 16:24:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Luca Barbieri <luca@luca-barbieri.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
Message-Id: <20101021162410.5c0d6720.akpm@linux-foundation.org>
In-Reply-To: <AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
	<20101021150250.f6499506.akpm@linux-foundation.org>
	<201010211823.38287.vapier@gentoo.org>
	<20101021155528.b3d6d027.akpm@linux-foundation.org>
	<AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 19:04:36 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> On Thu, Oct 21, 2010 at 18:55, Andrew Morton wrote:
> > On Thu, 21 Oct 2010 18:23:37 -0400 Mike Frysinger wrote:
> >> On Thursday, October 21, 2010 18:02:50 Andrew Morton wrote:
> >> > On Sat, 16 Oct 2010 13:27:15 -0400 Mike Frysinger wrote:
> >> > > If the arch doesn't provide atomic64 functionality (there are quite a
> >> > > few), then don't bother trying to build this test.
> >> >
> >> > I don't get it. __If the arch doesn't implement atomic64 then this file
> >> > will get zillions of build errors, won't it?
> >>
> >> ... which is why i added the ifdef protection
> >
> > So the changelog was poor. __Please write complete changelogs so I need
> > to have this sort of conversation less often?
> 
> the changelog seems pretty clear to me.  arch doesnt provide atomic64,
> so dont build code that uses atomic64.

That the patch fixes build errors is rather important information.

> > I know that. __But the standard way for an architecture to indicate to
> > the core that it impements a feature is for it to define CONFIG_HAVE_*.
> > Picking some related #define which architectures happen to implement
> > is atypical and unexpected.
> >
> > Will it cause problems? __Probably not, unless the arch goes and defines
> > ATOMIC64_INIT without actually implementing atomic64. __But it's
> > atypical and unexpected and, yes, lazy!
> 
> you can say "lazy" all you like.  i dont see the point in going that route.

Try

	grep HAVE arch/x86/Kconfig

If all of those were instead to use some random #define which the
particular feature happened to define in some header file then we would
have a mess on our hands.

There's your point.
