Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1DNB0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 21:26:22 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39361 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab1DNB0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 21:26:21 -0400
Subject: Re: Build regressions/improvements in v2.6.39-rc3
From: Michael Ellerman <michaele@au1.ibm.com>
Reply-To: michaele@au1.ibm.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Tony Breeds <tony@bakeyournoodle.com>
In-Reply-To: <1302739533.12513.32.camel@concordia>
References: <alpine.DEB.2.00.1104131835280.32045@ayla.of.borg>
	 <20110413.103233.193707113.davem@davemloft.net>
	 <BANLkTinT09RGg5XDUGy76Kpa8yX3DNUoQw@mail.gmail.com>
	 <1302739533.12513.32.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 11:26:17 +1000
Message-ID: <1302744378.12513.84.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 10:05 +1000, Michael Ellerman wrote:
> On Wed, 2011-04-13 at 19:38 +0200, Geert Uytterhoeven wrote:
> > On Wed, Apr 13, 2011 at 19:32, David Miller <davem@davemloft.net> wrote:
> > > From: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Date: Wed, 13 Apr 2011 18:35:45 +0200 (CEST)
> > >
> > >> 47 regressions:
> > >>   + build/linus_sparc64-allmodconfig_sparc64/usr/include/linux/ethtool.h: error: expected specifier-qualifier-list before '__u32': 104, 90, 21, 282, 389, 460, 521, 444, 96, 297, 82, 57, 291, 258, 231, 482, 209, 510, 265, 113 => 104, 538, 90, 21, 523, 552, 266, 445, 292, 96, 82, 512, 563, 57, 259, 283, 298, 484, 390, 231, 209, 462, 574, 113
> > >
> > > I do allmodconfig builds on sparc64 systems every single day using
> > > various versions of gcc-4.4, gcc-4.5, and gcc-4.6
> > >
> > > And I never ever see this build error.  Never.
> > >
> > > If you're using a cross build environment, maybe something isn't quite
> > > right with that?
> > 
> > As it mentions `/usr/include/linux/ethtool.h', it seems to be an
> > include that's part of the
> > cross build environment.
> > 
> > I'm just using the logs from the linux-next build service...
> 
> Which is just using the cross compilers that Tony builds ...
> 
> I'll have a look and see if we can work out what the problem is.

So allmodconfig enables CONFIG_BUILD_DOCSRC, which builds the code in
Documentation, which is userspace code.

In our case we know that won't work because our cross tool chain doesn't
have libc, so I've taught kisskb to disable CONFIG_BUILD_DOCSRC for
allmodconfig builds.

cheers

-- 
Michael Ellerman
OzLabs, LTC Prism Kernel Team

email: michaele@au.ibm.com
stime: ellerman@au1.ibm.com
notes: Michael Ellerman/Australia/IBM

