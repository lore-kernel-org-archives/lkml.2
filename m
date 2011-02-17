Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1BQPMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:12:46 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52146 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1BQPMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:12:42 -0500
Date: Thu, 17 Feb 2011 15:12:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Linn <John.Linn@xilinx.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, glikely@secretlab.ca
Subject: Re: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly
	macros
Message-ID: <20110217151223.GJ24627@n2100.arm.linux.org.uk>
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com> <20110217100126.GD22961@pulham.picochip.com> <71326bcb-7836-4820-84c1-f3d8257e9f92@VA3EHSMHS020.ehs.local> <201102171541.12261.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102171541.12261.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 03:41:11PM +0100, Arnd Bergmann wrote:
> On Thursday 17 February 2011, John Linn wrote:
> > > > +
> > > > +#define UART_FIFO_WRITE(base, value) \
> > > > +   (*(volatile unsigned int *)((base) + UART_FIFO_OFFSET) =
> > (value))
> > > > +
> > > > +#define UART_STATUS(base) \
> > > > +   (*(volatile unsigned int *)((base) + UART_SR_OFFSET))
> > > 
> > > You could probably make these static inline functions in the header
> > and
> > > use __raw_{readl,writel}() to make this a little cleaner.
> > > 
> > 
> > I had considered that, but it wasn't clear to me at the time what the
> > compressor could use or not.
> > 
> > I'll give it a try as I agree that's cleaner.
> 
> Actually, for correctness you should use the regular readl/writel, not
> the __raw_ versions, which can result in reordered or partial accesses
> on the bus.

Not in the decompressor.  readl/writel are unsupported there - the
decompressor doesn't have the L2 cache support code and so the barriers
necessary for readl/writel cause link errors.
