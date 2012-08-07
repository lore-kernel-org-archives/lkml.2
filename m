Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2HGQs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:48:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47885 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513Ab2HGQs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:48:58 -0400
Date: Tue, 7 Aug 2012 17:48:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807164855.GS16861@opensource.wolfsonmicro.com>
References: <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
 <20120807103851.GS16861@opensource.wolfsonmicro.com>
 <20120807111331.GC24257@flint.arm.linux.org.uk>
 <20120807112844.GZ16861@opensource.wolfsonmicro.com>
 <20120807113121.GD24257@flint.arm.linux.org.uk>
 <20120807113652.GA6282@flint.arm.linux.org.uk>
 <20120807114556.GC16861@opensource.wolfsonmicro.com>
 <20120807115140.GH24257@flint.arm.linux.org.uk>
 <CAMuHMdUezhMNL19JUK9-uSqTr3=bU7yAci0ovFd5dSdksW1etQ@mail.gmail.com>
 <20120807154458.GK24257@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807154458.GK24257@flint.arm.linux.org.uk>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 04:44:58PM +0100, Russell King wrote:

> However, one issue that I hope has already been addressed is what space
> the ranges are in, and how does a sub-driver get to know that.  To put
> it another way, how does a sub-driver get to know about the 'base' for
> these register ranges.  I hope that problem has been thought about in
> MFD land _before_ the approach of passing around register ranges
> through resources was allowed to happen.

That's been thought through - the subdevice drivers already have to rely
heavily on the fact that they know about their parent and part of that
contract is that the base address for these resources is always address
zero in the register space of the MFD and there's never more than one
resource in the tree.  Nothing will ever do anything like reserve the
resources, they just get looked up to retrieve the base address for the
relevant range.

Someone could do a device which does something different but nobody
wanted to yet and it's very unclear that anyone would, if they did then
they'd have to deal with the issues that will result.
