Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2HZQEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:04:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:59692 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab2HZQEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:04:37 -0400
Message-ID: <1345997040.5138.1.camel@pasglop>
Subject: Re: udev 182: response timeout for request_firmware in module_probe
 path
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ming Lei <tom.leiming@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        systemd-devel@lists.freedesktop.org
Date: Mon, 27 Aug 2012 02:04:00 +1000
In-Reply-To: <20120823174613.0489837d@pyramind.ukuu.org.uk>
References: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
	 <CACVXFVOMdWQSutkBzdcLJ-ozmecq_p-yzYJbtoLVUafz5KV=KQ@mail.gmail.com>
	 <CAPXgP13LBR6GD=VomBPim3mDPy1bJ=eFBZ=oDaKZCjEo=Xp94Q@mail.gmail.com>
	 <CACVXFVMFKGPv9Am0KzKSVsRamcA8EMMnD0kQO40MJ6OsjK4Eow@mail.gmail.com>
	 <20120823174613.0489837d@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 17:46 +0100, Alan Cox wrote:
> > IMO, the driver probing path is allowed to sleep, so looks request
> firmware
> > should be allowed inside .probe().
> 
> I'm not convinced about that. It can sleep but its holding various
> locks
> in most cases, and it looks like that can end up in a complete heap.
> 
> By all means *request* the firmware asynchronously in the probe, but
> there needs to be a seperate method somewhere after the probe to
> finish
> the job once the firmware appears. 

Not necessarily enough in the general case, for example some stacks will
cause a driver open to be call back from somewhere within the
register_foo() the driver did to register itself with it's subsystem
inside probe. For example register_framebuffer(), register_netdev(), ...

This is clearly a udev bug :-)

Cheers,
Ben.


