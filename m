Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2HGPpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:45:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56590 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2HGPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:45:19 -0400
Date: Tue, 7 Aug 2012 16:44:58 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807154458.GK24257@flint.arm.linux.org.uk>
References: <20120806220032.GD26698@opensource.wolfsonmicro.com> <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com> <20120807103851.GS16861@opensource.wolfsonmicro.com> <20120807111331.GC24257@flint.arm.linux.org.uk> <20120807112844.GZ16861@opensource.wolfsonmicro.com> <20120807113121.GD24257@flint.arm.linux.org.uk> <20120807113652.GA6282@flint.arm.linux.org.uk> <20120807114556.GC16861@opensource.wolfsonmicro.com> <20120807115140.GH24257@flint.arm.linux.org.uk> <CAMuHMdUezhMNL19JUK9-uSqTr3=bU7yAci0ovFd5dSdksW1etQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUezhMNL19JUK9-uSqTr3=bU7yAci0ovFd5dSdksW1etQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 05:22:45PM +0200, Geert Uytterhoeven wrote:
> And as Arnd pointed out, if resources will be used for various new buses,
> "IORESOURCE_FOO" or "IORESOURCE_OTHER" is a bit vague.
> What about conflicts where one driver means i2c addresses and another
> one means gpio addresses? The resource system will reject them?

I changed the subsequent patch to use IORESOURCE_REG - at least that
better describes what it's for.  Maybe IORESOURCE_REGRANGE would be
better (so it can be used for any register range resource on any bus
type) ?

However, one issue that I hope has already been addressed is what space
the ranges are in, and how does a sub-driver get to know that.  To put
it another way, how does a sub-driver get to know about the 'base' for
these register ranges.  I hope that problem has been thought about in
MFD land _before_ the approach of passing around register ranges
through resources was allowed to happen.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
