Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0FCUSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:18:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58873 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab0FCUSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:18:42 -0400
Date: Thu, 3 Jun 2010 21:18:03 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603201803.GH25779@flint.arm.linux.org.uk>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org> <20100603185333.GD25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org> <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com> <20100603194559.GF25779@flint.arm.linux.org.uk> <1275594598.23384.52.camel@c-dwalke-linux.qualcomm.com> <20100603195703.GG25779@flint.arm.linux.org.uk> <1275595608.23384.58.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275595608.23384.58.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 01:06:48PM -0700, Daniel Walker wrote:
> On Thu, 2010-06-03 at 20:57 +0100, Russell King wrote:
> > config MACH_HALIBUT
> > 	bool "Halibut Board (QCT SURF7201A)"
> > 	select I2C if STD_CONFIG
> > 	select I2C_WHATEVER if STD_CONFIG
> > 	...
> > 
> > That means if you enable STD_CONFIG, you'll get everything that's required
> > selected.  If you then disable STD_CONFIG, I believe Kconfig leaves
> > everything that was selected as still being selected.
> 
> I just did a little test, and it doesn't. Kconfig would un-select all
> the drivers, at least from my test.

That's because it knows what the original state of the symbol is.
Yes, that's a little undesirable for our behaviour - but it can be
worked around - by saving and restarting Kconfig.

Try this:

config STD_CONFIG
	bool "Standard config"
	default y

config DRIVER_A
	tristate "Driver A"

config ARM
	def_bool y
	select DRIVER_A if STD_CONFIG

and in a new directory /path/to/kernel/scripts/kconfig/mconf test.conf
If you turn off STD_CONFIG immediately, it'll turn off DRIVER_A.
However, save out the config, and re-run mconf test.conf.  You'll then
find that DRIVER_A remains set even when STD_CONFIG is turned off.

So, Kconfig does have the behaviour we desire but it's not directly
accessible.

Is it worth persuing?  Will Linus accept this STD_CONFIG idea or did
his lack of reply to it indicate that he's not something he's willing
to entertain?

In any case, this is my last mail on the subject.  I won't be replying
to mail for at least the next four days.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
