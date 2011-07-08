Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab1GHJRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:17:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58878 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1GHJRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:17:30 -0400
Date: Fri, 8 Jul 2011 10:17:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Tommy Lin <tommy.lin.1101@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tommy Lin <tommy.lin@caviumnetworks.com>
Subject: Re: [PATCH 1/2] arch: arm: Correct the dependency of HAVE_ARM_TWD
Message-ID: <20110708091713.GF2414@n2100.arm.linux.org.uk>
References: <1310104763-12948-1-git-send-email-tommy.lin@caviumnetworks.com> <20110708091014.GA15142@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708091014.GA15142@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 01:10:14PM +0400, Anton Vorontsov wrote:
> On Fri, Jul 08, 2011 at 01:59:23PM +0800, Tommy Lin wrote:
> > Original mpcore_wdt config dependency is as follow:
> > MPCORE_WATCHDOG -> HAVE_ARM_TWD -> SMP -> (CPU_V6K || CPU_V7)
> > This patch will remove SMP and made the dependency as follow:
> > MPCORE_WATCHDOG -> HAVE_ARM_TWD -> (CPU_V6K || CPU_V7)
> > 
> > The MPCore watchdog (and timer) can be found at ARM11 MPCore (CPU_V6K) and
> > Cortex A9 MPCore (CPU_V7). The dependency between MPCORE_WATCHDOG and
> > (CPU_V6K || CPUV7) is necessary, but the dependency of SMP is redundant.
> > The MPCore watchdog should function normally even SMP is not turned on with
> > ARM11 or Cortex A9 CPU.
> > 
> > Signed-off-by: Tommy Lin <tommy.lin@caviumnetworks.com>
> > ---
> 
> Russell,
> 
> As the patch is needed for CNS3xxx Watchdog support, I'd like to take
> it via CNS3xxx tree, if you're OK with that.

No.

TWD is only useful if SMP is enabled, otherwise the contained code
won't be called.  Without SMP you'll find that the timer rate will
be zero.

So actually your problems are bigger than just this dependency.
