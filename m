Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0KMOsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:48:13 -0500
Received: from kroah.org ([198.145.64.141]:55869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab0KMOsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:48:08 -0500
Date: Sat, 13 Nov 2010 06:45:12 -0800
From: Greg KH <greg@kroah.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
Message-ID: <20101113144512.GB29781@kroah.com>
References: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com> <20101109224450.GB21992@kroah.com> <AANLkTimHOAdUieTzFvNNhaPxwvas2wBDfSL8aPu764HZ@mail.gmail.com> <20101110183940.GA15089@kroah.com> <AANLkTimTy0vngwuM=jWfeU7qgqznamPgAftX7=2LShL+@mail.gmail.com> <20101111121917.GA933@kroah.com> <AANLkTi=dTW3WA-eLnnaHNcLdVKz7Bn41e8FE=67iVCyJ@mail.gmail.com> <AANLkTin1wDCKc0A0PTtMPAALpLP0E3gL3J-AvFqEEqBG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin1wDCKc0A0PTtMPAALpLP0E3gL3J-AvFqEEqBG@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 07:35:10PM +0600, Rakib Mullick wrote:
> On 11/11/10, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> > On 11/11/10, Greg KH <greg@kroah.com> wrote:
> >>
> >> perhaps, yes, that might be correct, but as almost no one builds with
> >> WARN not enabled, is this a real issue?
> >
> > I'm trying to find out the config, which causes the warning (it gets
> > overwritten). Not all config produces the warning. Maybe - it was a
> > randconfig, which generates the warning. I'll again try some
> > randconfig and will try to find the config which generates the
> > warning. If I find something I'll notice. But, I think the issue is
> > real.
> >
> CONFIG_EMBEDDED=y and CONFIG_BUG=n produces that warning, in that case
> #ifndef WARN is defined as follows:
> 
> #define WARN(condition, format...) ({					\
> 	int __ret_warn_on = !!(condition);				\
> 	unlikely(__ret_warn_on);					\
> })
> 
> from above we can see, format isn't used. sysfs_pathname is passed as
> format when called from sysfs_add_one through WARN(). Since format
> isn't used, that's why we're having that problem. Am I right? Should I
> create a patch to split up WARN() and calling sysfs_pathname ? Or is
> there any better way?

No, you should probably just not worry about it as the number of people
using those two configuration options are in the extreme minority so
it's really not a big issue at all.

thanks,

greg k-h
