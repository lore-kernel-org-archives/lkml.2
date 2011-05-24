Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab1EXBud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:50:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53424 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752835Ab1EXBua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:50:30 -0400
Date: Tue, 24 May 2011 02:50:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: x86@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: linux-next: Tree for May 23 (sound/soc/codecs)
Message-ID: <20110524014959.GA27710@opensource.wolfsonmicro.com>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au> <20110523134815.fb87933a.randy.dunlap@oracle.com> <20110523224659.GB19533@opensource.wolfsonmicro.com> <20110523155343.2e68c265.randy.dunlap@oracle.com> <20110524000837.GA30515@opensource.wolfsonmicro.com> <4DDB082F.3010107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDB082F.3010107@oracle.com>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 06:21:51PM -0700, Randy Dunlap wrote:
> On 05/23/11 17:08, Mark Brown wrote:

> > No, really we should.  The GPIO APIs are stubbed out when not in use for
> > a very good reason, think about the usability here.  The goal here isn't
> > to litter the code with ifdefs - if architectures aren't able to keep up
> > with API changes they should convert to using gpiolib so this stuff
> > happens automatically (indeed, I can't think of any good reason for an
> > architecture to not be using gpiolib at this point).

> No, I would say that there are a lot of drivers in sound/soc/codecs/
> that are missing some GPIO pieces in the Kconfig file.

Have you actually looked at the code here?  Vanishingly few of the
drivers need GPIOs at all, they can just optionally use GPIOs if the
system makes them available.  There is absolutely no dependency on GPIOs
for them, anything in Kconfig would be entirely unconstructive.

> >> MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");

> > You've clearly not looked at MAINTAINERS for this one.

> It's not listed in the MAINTAINERS file.

MAINTAINERS has a pattern sound/soc/codecs/wm*.

> But maybe you mean scripts/get_maintainer.pl, which I did try.
> I found that using git log <that source file name> was better info
> than using scripts/get_maintainer.pl.

get_maintainers is just a script that reads MAINTAINERS and trawls logs
for it; the reason I mentioned MAINTAINERs was that you were saying you
didn't use git.  In general you're better off doing things by hand
rather than using get_maintainers.
