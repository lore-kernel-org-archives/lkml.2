Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab1GJJue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:50:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56451 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab1GJJu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:50:29 -0400
Date: Sun, 10 Jul 2011 10:50:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/4] Add a generic struct clk
Message-ID: <20110710095013.GZ4812@n2100.arm.linux.org.uk>
References: <1305876469.325655.313573683829.0.gpush@pororo> <1305876469.325655.313573683829.0.gpush@pororo> <20110710090927.GA23445@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110710090927.GA23445@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 06:09:30PM +0900, Mark Brown wrote:
> On Fri, May 20, 2011 at 03:27:49PM +0800, Jeremy Kerr wrote:
> > [This series was originally titled 'Add a common struct clk', but
> > the goals have changed since that first set of patches. We're now aiming
> > for a more complete generic clock infrastructure, rather than just
> > abstracting struct clk]

... which will mean the platforms at the simpler end of the spectrum
will ignore it because it'll be far too heavy weight for them.

If we're going to do something generic with it, then we need something
that _can_ scale from damned simple right up to OMAP-type complex.  We
don't want to start with something OMAP-type complex and have everyone
use it even for just one or two (or even 30 simple enable/disable
non-tree like) clocks.  And those platforms should not have to have
several K of unused code in their kernel because of it.

Otherwise, we'll just end up going back to people trying to directly
access clock mask registers from drivers.

Note that because of the develtech.com fuckup, I don't have your patch
series because I had to drop off the lists for about six hours to stop
the deluge of emails.
