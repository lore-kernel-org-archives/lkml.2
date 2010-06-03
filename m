Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0FCSy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:54:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57627 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0FCSyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:54:25 -0400
Date: Thu, 3 Jun 2010 19:53:33 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603185333.GD25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:18:05AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 3 Jun 2010, Russell King wrote:
> > 
> > Umm.  I don't think you've actually looked at the Kconfig files if you're
> > writing this, because that's precisely what we already do.
> 
> .. but if you do this _right_, then the defconfig files would be 
> unnecessary.
> 
> That's my point. If you are right, then I can remove the defconfig files 
> entirely. Are you ready for that?

Absolutely no way are we ready for that.

> And if you aren't ready for that, then what was the point of your email?

Linus, don't make this personal.

The problem is NOT "what options which are found under the arch/arm tree
do I need".

The problem is "what options throughout the rest of the kernel do I need
to result in a usable kernel".

No amount of reorganising the Kconfig files into a heirarchial manner
(which they already are) helps.  Not one bit.  Because they already are.
That's not where the problem is.

For instance, if I have platform A, I know it has an RTC.  How do I know
which of the 37 RTC drivers the kernel configuration presents me with to
select?  Am I really expected to open up the platform and read the
device numbers off all the chips (some of which being surface mount are
abbreviated) and work out that it's a TWL4030 RTC that I should be using?

That's just one instance - and there's probably many more just like that.
Just look at "multifunction drivers" for another case in point.  How the
hell do I know what multifunction driver is appropriate for a platform?

Ditto "Power supply support".

The list goes endlessly on.  All those things I've mentioned are all
_outside_ of arch/arm.  That's where the _real_ problem is.  Solve that
problem so that it's easier for people to configure the kernel, and then
we don't need the multitude defconfig files.

That's the problem which the defconfigs are solving today.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
