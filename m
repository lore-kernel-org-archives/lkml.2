Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab1H3VLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:11:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56347 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1H3VLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:11:11 -0400
Date: Tue, 30 Aug 2011 22:10:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110830211018.GB17887@n2100.arm.linux.org.uk>
References: <20110823221314.GL3895@n2100.arm.linux.org.uk> <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com> <20110825121416.GB8883@n2100.arm.linux.org.uk> <20110825121710.GK3286@htj.dyndns.org> <20110825122543.GC8883@n2100.arm.linux.org.uk> <20110825123542.GM3286@htj.dyndns.org> <20110825130414.GE8883@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk> <20110830205802.GT2061@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830205802.GT2061@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 09:58:03PM +0100, Mark Brown wrote:
> On Thu, Aug 25, 2011 at 03:55:58PM +0100, Russell King - ARM Linux wrote:
> 
> > Here's the patch.  As the kernel I've run this against doesn't have the
> > change to try_to_freeze(), I added a might_sleep() in do_signal() during
> > my testing to verify that it fixes Mark's problem (which it does.)
> 
> > Mark, can you test this to make sure it fixes your problem please?
> 
> Yes, it resolves the problem for me - thanks!
> 
> Tested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Sorry about the delay, was away for the bank holiday weekend.

That's good, thanks.

Just waiting for Ulrich Weigand to verify that his gdb test-case doesn't
break with this patch.
