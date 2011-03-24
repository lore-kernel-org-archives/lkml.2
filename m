Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933852Ab1CXTRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:17:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52706 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab1CXTRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:17:13 -0400
Date: Thu, 24 Mar 2011 13:17:04 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: andy.green@linaro.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110324191704.GB15807@ponder.secretlab.ca>
References: <4D79F068.2080009@linaro.org>
 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
 <1300828125.2402.300.camel@pasglop>
 <4D8924B6.8040403@linaro.org>
 <1300842219.2402.309.camel@pasglop>
 <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop>
 <4D89BDE2.60907@linaro.org>
 <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
 <4D89C618.1020608@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D89C618.1020608@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:06:16AM +0000, Andy Green wrote:
> On 03/23/2011 09:47 AM, Somebody in the thread at some point said:
> >>There is no udev solution for what is being done currently by the async
> >>platform_data patchset with SDIO WLAN.  The patches are out there and in
> >>use already.  The only reason I don't post them here as round 2 of the
> >>RFC yet is because Grant wanted a couple of days and politically it's
> >>expedient for me to agree to that.
> >
> >Kernel policy has always been that just because some vendor has deployed
> >an interface doesn't mean we care one iota about it or consider it an
> >argument for the solution. In some cases in fact it bcomes the working
> >demo of why it was a bad idea.
> 
> To be clear, this is not about any funny business at the interface
> on the hardware.
> 
> The SDIO patches target wl12xx that is already in mainline and
> already using literally platform_data.  Because there's no neater
> way on offer, it currently -- in mainline -- does it by having a
> built-in stub with its own Kconfig, that copies platform_data from
> the board definition file into a private malloc'd buffer, then uses
> it by getting a pointer to the copy from another private api in the
> driver.  All this in a specific driver.

I've spent some time looking at the wl12xx driver code, and while the
data symbol it is using happens to be called 'platform_data', it isn't
actually the same thing as we're debating in this thread.

The platform_data in drivers/net/wireless/wl12xx_platform_data.c is a
strongly typed pointer to a 'struct wl12xx_platform_data', which
doesn't have the deficiencies associated with
(struct device*)->platform_data.  It isn't a void* travelling through
the device model without guarantees that the right thing will get
dereferenced on the other end.

The fact that it has /other/ deficiencies is I imagine exactly why
you want to be rid of it, and rightly so.  Immediately obvious is that
the way it currently is done means that there can never be more than
one wl12xx in the system.

I've got a proposal for a solution.  I'll get it written up as
quickly as possible and send it out soon.

g.

