Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2HGM6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:58:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58624 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab2HGM6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:58:23 -0400
Date: Tue, 7 Aug 2012 13:58:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807125820.GD16861@opensource.wolfsonmicro.com>
References: <20120806213124.GB14594@flint.arm.linux.org.uk>
 <20120806220032.GD26698@opensource.wolfsonmicro.com>
 <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
 <20120807103851.GS16861@opensource.wolfsonmicro.com>
 <20120807111331.GC24257@flint.arm.linux.org.uk>
 <20120807112844.GZ16861@opensource.wolfsonmicro.com>
 <20120807113121.GD24257@flint.arm.linux.org.uk>
 <20120807113652.GA6282@flint.arm.linux.org.uk>
 <20120807114556.GC16861@opensource.wolfsonmicro.com>
 <20120807115140.GH24257@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807115140.GH24257@flint.arm.linux.org.uk>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:51:40PM +0100, Russell King wrote:

> For fuck sake Mark.  You are insane.

Please take a step back from the ad hominem remarks.

> How can:

> #define IORESOURCE_FOO 0x00000300

> in ioport.h be called "invasive" ?  The best chance of error is that the
> identifier is already in use.  So learn to use grep to check the whole
> sodding tree first to make sure that the identifier you're choosing to
> use isn't already in use somewhere.

My concern there (and that of others who've looked at adding a new
resource type) is that this value can also be written as

  #define IORESOURCE_FOO (IORESOURCE_IO | IORESOURCE_MEM)

and the selection of values chosen for the resource types clearly looks
like it's supposed to be interpreted as a bitmask for some reason.  This
is the main reason nobody touched the code already, it sets off alarm
bells from a code review point of view.

It may well be the case that the constants are only ever viewed as plain
old numbers in which case we're fine but it really doesn't seem too
clevr for stable.

> And in any case, I suspect you've lost the plot, because I suspect the
> driver you are referring to is wm831x, which has already had your solution
> patched into it by you back in May.

The urgent issue is for the Marvell PMIC drivers (drivers/mfd/88pm*)
which are also affected but have not had a fix implemented so have been
broken since v3.4.  The wm831x drivers should be updated to use the new
API too but don't now have an issue in stable right now.  There may be
others but presumably they're not even testing stable releases so again
probably not urgent.

> And you still haven't done me the curtesy of answering my repeated
> questions about WHAT BLOODY DRIVER you are referring to has the problem.

You've only asked this once that I've seen, in the mail where you posted
your patch (which is a helpful step forward, thanks!) which very recent.
It's possible that you've asked this elsewhere, though I did just scan
through a good chunk of the mails and didn't see the question.

> There is no point in discussing this any further unless you START answering
> some of the basic questions, rather than constantly trying to poke holes
> in a solution you did not invent.  (Do you suffer from not-invented-here
> syndrome?  Because you *are* showing all the signs of that.)

As I keep saying I don't think there's been any disagreement that adding
one or more new resource types is the best approach going forward, the
only issues have been around what happens in stable and someone having
the time to add the new resource type.
