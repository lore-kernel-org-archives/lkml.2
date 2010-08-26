Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0HZSg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:36:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49013 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753718Ab0HZSgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:36:25 -0400
Date: Thu, 26 Aug 2010 19:36:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: Add generic driver for simple memory mapped
	controllers
Message-ID: <20100826183623.GA24381@opensource.wolfsonmicro.com>
References: <20100826174822.75094415@lxorguk.ukuu.org.uk> <216397.86259.qm@web180306.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <216397.86259.qm@web180306.mail.gq1.yahoo.com>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 10:34:58AM -0700, David Brownell wrote:
> --- On Thu, 8/26/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Just rename it to match the IP block used.

> > There are zillions of IP blocks that have that interface,

> If there are "zillions" that suggests the HW
> engineers have version/naming issues just like
> certain software engineers.  Only goes to show
> how close Verilog and VHDL are to software! :)

Half the thing here is that it's barely IP - it's the sort of thing
that's so trivial to implement that it'd take more time to locate a
suitable IP than to just hook up the output pins to the register map
directly.

> > how exactly do
> > you propose to rename it.

> My suggestion was to use the name provided/used
> by the hardware engineers.  (E.g. whatever the
> Verilog or VHDL equivalent of a module name is.)

That's not going to happen, nobody's sharing any IP for this.

> If I understand you correctly, those engineers
> are not reusing a named module; they are at best
> just copying/pasting some Verilog/VHDL and adding
> ASIC/SoC/.../FPGA-specific hacks.  (Which calls into
> question just how much assurance there can be that
> one driver will work reliably for all instances...

Essentially all this sort of GPIO controller is is a straight wire
through of a set of register bits to an output signal (especially if you
don't have a separate clear register).  It's the first thing a hardware
engineer would think of for implementing this - it's not even copy and
paste really, my understanding is that normally it's just basic plumbing
to wire the relevant signals together.
