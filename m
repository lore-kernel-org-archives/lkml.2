Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab2HGLvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:51:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56217 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2HGLvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:51:53 -0400
Date: Tue, 7 Aug 2012 12:51:40 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807115140.GH24257@flint.arm.linux.org.uk>
References: <20120806195352.GC16199@opensource.wolfsonmicro.com> <20120806213124.GB14594@flint.arm.linux.org.uk> <20120806220032.GD26698@opensource.wolfsonmicro.com> <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com> <20120807103851.GS16861@opensource.wolfsonmicro.com> <20120807111331.GC24257@flint.arm.linux.org.uk> <20120807112844.GZ16861@opensource.wolfsonmicro.com> <20120807113121.GD24257@flint.arm.linux.org.uk> <20120807113652.GA6282@flint.arm.linux.org.uk> <20120807114556.GC16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807114556.GC16861@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 12:45:57PM +0100, Mark Brown wrote:
> On Tue, Aug 07, 2012 at 12:36:52PM +0100, Russell King wrote:
> 
> > And, for those hard of thinking, I'll tell you exactly how invasive it
> > is.
> 
> > 1. You modify ioport.h to add the new type.
> 
> > Yes, it's really that damned simple.  Not invasive at all.
> 
> Your step 1 is the bit that strikes me as invasive here - that's not
> something I'd be touching in a stable release if I didn't have to, it's
> visible to half the kernel in an area where we clearly don't have ideal
> review of the code (otherwise we'd not have a problem here in the first
> place) which seems totally disproportionate to the benefit here.  We're
> talking about an issue which affects one device which is used only on
> Marvell systems here.
> 
> I think everyone agrees that this is the best route forward for future
> kernels.

For fuck sake Mark.  You are insane.

How can:

#define IORESOURCE_FOO 0x00000300

in ioport.h be called "invasive" ?  The best chance of error is that the
identifier is already in use.  So learn to use grep to check the whole
sodding tree first to make sure that the identifier you're choosing to
use isn't already in use somewhere.

And in any case, I suspect you've lost the plot, because I suspect the
driver you are referring to is wm831x, which has already had your solution
patched into it by you back in May.

And you still haven't done me the curtesy of answering my repeated
questions about WHAT BLOODY DRIVER you are referring to has the problem.

There is no point in discussing this any further unless you START answering
some of the basic questions, rather than constantly trying to poke holes
in a solution you did not invent.  (Do you suffer from not-invented-here
syndrome?  Because you *are* showing all the signs of that.)

commit ce7e4e11221dd7fbe82c8ad28d1875b0dfa20de4
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Mon May 7 10:03:20 2012 +0100

    mfd: Fix wm831x register range passing for recent ARM updates

    The removal of mach/io.h from most ARM platforms also set the range of
    valid IO ports to be empty for most platforms when previously any 32
    bit integer had been valid. This makes it impossible to add IO resources
    as the added range is smaller than that of the root resource for IO ports.

    Since we're not really using IO memory at all fix this by defining our
    own root resource outside the normal tree and make that the parent of
    all IO resources. This also ensures we won't conflict with read IO ports
    if we ever run on a platform which happens to use them.

    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
