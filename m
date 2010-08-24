Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0HXPpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:45:51 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:55603 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0HXPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:45:49 -0400
Date: Tue, 24 Aug 2010 17:47:41 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Message-ID: <20100824154740.GD2160@osiris.boeblingen.de.ibm.com>
References: <4C61EE55.5030506@codeaurora.org>
 <201008191309.15425.arnd@arndb.de>
 <20100824150655.GB2160@osiris.boeblingen.de.ibm.com>
 <201008241726.08797.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008241726.08797.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 05:26:08PM +0200, Arnd Bergmann wrote:
> On Tuesday 24 August 2010, Heiko Carstens wrote:
> > > (Taking Martin and Heiko on Cc for s390)
> > > 
> > > I'd strongly suggest making the behavior the same for everyone. It should
> > > be fairly easy to make sure none of these warnings ever triggers
> > > on s390, because most of the Linux device driver code does not get build
> > > there anyway.
> > 
> > Please don't do that. An s390 allyesconfig still triggers 45 warnings and
> > I'm currently not willing to "patch" working code just to get rid of these
> > warnings which are most likely all false positives.
> > That's the reason why we currently don't error out and only generate
> > warnings.
> 
> Can't you just turn that option off then? Or are you worried about
> allyesconfig builds?

I'd like to keep an allyesconfig compiling and booting.
With the proposed change we would never see a green entry at
http://kisskb.ellerman.id.au/kisskb/branch/9/ for s390's allyesconfig
build ;)
And it would make it a bit harder to find the usual !HAS_DMA and
!HAS_IOMEM build breakages we see quite frequently. No reason to make
it even more difficult to keep s390 compiling.

> The current state is confusing because on s390
> CONFIG_DEBUG_STRICT_USER_COPY_CHECKS means that gcc will warn rather
> than ignore the finding, while on all others, the same option turns
> a warning into an error.

Then maybe add a "choice" Kconfig option in a way that both allyesconfig
as well as allnoconfig will build?
