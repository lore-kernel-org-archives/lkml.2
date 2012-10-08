Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2JHXAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:00:01 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37949 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2JHW76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:59:58 -0400
Date: Mon, 8 Oct 2012 15:59:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Dave Jones <davej@redhat.com>, Dave Airlie <airlied@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121008225939.GM2453@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hy434CQhT8WTvKmNzkO4k_isfKQOrCjgfYFYfMVgS7QDw@mail.gmail.com>
 <20121007014447.GB2485@linux.vnet.ibm.com>
 <CAPM=9tzoaZ3AWzA6MFnKAMzFgrarWW=JTLHSTzGBf0hoPQ_RmQ@mail.gmail.com>
 <20121007163029.GG2485@linux.vnet.ibm.com>
 <20121007201854.GA6628@redhat.com>
 <20121008010410.GL2485@linux.vnet.ibm.com>
 <CAGXu5jJVSOACDGxgggrR-dOc-_68dFi8_2pLRF-5wy6wN6uYgw@mail.gmail.com>
 <20121008222939.GK2453@linux.vnet.ibm.com>
 <CAGXu5jKrRPqP7J10A6QZr5wMhcqLJk=WK-F5nUwwvef_7NM0oQ@mail.gmail.com>
 <CAGXu5jKMDzGMKv7VDFwksCJ_SOvS26-hQFt4xp5VDMoLWGj2pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKMDzGMKv7VDFwksCJ_SOvS26-hQFt4xp5VDMoLWGj2pQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100822-1976-0000-0000-000012290EFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 03:40:57PM -0700, Kees Cook wrote:
> On Mon, Oct 8, 2012 at 3:37 PM, Kees Cook <keescook@chromium.org> wrote:
> > On Mon, Oct 8, 2012 at 3:29 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> >> On Mon, Oct 08, 2012 at 03:07:24PM -0700, Kees Cook wrote:
> >>> On Sun, Oct 7, 2012 at 6:04 PM, Paul E. McKenney
> >>> <paulmck@linux.vnet.ibm.com> wrote:
> >>> > On Sun, Oct 07, 2012 at 04:18:54PM -0400, Dave Jones wrote:
> >>> >> On Sun, Oct 07, 2012 at 09:30:29AM -0700, Paul E. McKenney wrote:
> >>> >>
> >>> >>  > > I think Kconfig is mostly what distro would like to use the thing is
> >>> >>  > > the Kconfig text needs to be there upfront when its merged, not two
> >>> >>  > > months later, since then it too late for a distro to notice.
> >>> >>  > >
> >>> >>  > > I'd bet most distros would read the warnings, but in a lot of cases
> >>> >>  > > the warning don't exist until its too late.
> >>> >>  >
> >>> >>  > In the case of CONFIG_RCU_USER_QS you are quite right, the warning
> >>> >>  > should have been there from the beginning and was not.  I suppose you
> >>> >>  > could argue that the warning was not sufficiently harsh in the case of
> >>> >>  > CONFIG_RCU_FAST_NO_HZ, but either way it did get ignored:
> >>> >>
> >>> >> Maybe if we had a universally agreed upon tag for kconfig, like
> >>> >> "distro recommendation: N" that would make things obvious, and also allow
> >>> >> those of us unfortunate enough to maintain distro kernels to have something
> >>> >> to easily grep for.  This would also catch the case when you eventually (hopefully)
> >>> >> flip from an N to a Y.
> >>> >>
> >>> >> There will likely still be some distros that will decide they know better
> >>> >> (and I'm pretty sure eventually I'll find reason to do so myself), but it at least
> >>> >> gives the feature maintainer the "I told you so" clause.
> >>> >>
> >>> >> Something we do quite often for our in-development kernels is enable something
> >>> >> that's shiny, new and unproven, and then when we branch for a release, we turn
> >>> >> it back off.  It would be great if a lot of this kind of thing could be more automated.
> >>> >
> >>> > One approach would be to have CONFIG_DISTRO, so that experimental
> >>> > features could use "depends on !DISTRO", but also to have multiple
> >>> > "BLEEDING" symbols.  For example, given a CONFIG_DISTRO_BLEEDING_HPC
> >>> > and CONFIG_DISTRO_BLEEDING_RT, CONFIG_RCU_USER_QS might eventually
> >>> > use the following clause:
> >>> >
> >>> >         depends on !DISTRO || DISTRO_BLEEDING_HPC || DISTRO_BLEEDING_RT
> >>> >
> >>> > A normal distro would define DISTRO, a distro looking to provide bleeding-edge
> >>> > HPC or real-time features would also define DISTRO_BLEEDING_HPC or
> >>> > DISTRO_BLEEDING_RT, respectively.
> >>> >
> >>> > Does that make sense, or am I being overly naive?
> >>>
> >>> I think we should avoid any global configs that disable things. We'll
> >>> just end up in the same place with distros again.
> >>
> >> So you believe that we should taint the kernel or splat on boot to
> >> warn distros off of features that might not be ready for 100 million
> >> users?  Or do you have some other approach in mind?
> >
> > Personally, I think taint+printk seems like the right way to go.
> 
> Actually, I think printk is sufficient. I don't want kernel taint to
> become the new CONFIG_EXPERIMENTAL. :)

OK, I'll bite...

Why would kernel taint be more likely to become the new CONFIG_EXPERIMENTAL
than printk() would?

							Thanx, Paul

