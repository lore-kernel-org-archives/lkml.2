Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1EEXBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 19:01:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:40241 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab1EEXBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 19:01:40 -0400
Date: Thu, 5 May 2011 15:53:02 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
Message-ID: <20110505225302.GC12316@suse.de>
References: <20110419204117.979118654@clark.kroah.org>
 <1303263653.3464.65.camel@localhost>
 <20110420020128.GA27631@suse.de>
 <1303265862.3464.77.camel@localhost>
 <20110420031105.GA11945@suse.de>
 <1303274910.3464.95.camel@localhost>
 <20110420050617.GA16756@suse.de>
 <1303356555.3464.128.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303356555.3464.128.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 04:29:15AM +0100, Ben Hutchings wrote:
> > We got a few new quirks added for AMD hardware platforms that fix
> > problems.
> 
> Maybe, but I still haven't seen anyone explain what those problems are!

I'll let the AMD people answer this.

> > It took 3 patches to get there, yes, but now, as time goes
> > on, adding new ones is even easier as the .32 code matches the .39 code
> > in this area due to these patches being added.
> > 
> > Now if you find problems in these, great, let me know and I will work to
> > resolve them.
> > 
> > As for regressions, what are you referring to?
> 
> These are the regressions I'm aware of in the last few updates:
> 
> 2.6.32.36: 'x86: Cleanup highmap after brk is concluded' broke
> hibernation on x86-64 and some x86-32 machines (reverted in .37)
> 2.6.32.36: 'signal: Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from
> spoofing the signal code' broke glibc aio (fixed in .37)
> 2.6.32.34: powerpc kdump/kexec changes didn't compile on UP or 32-bit
> (fixed in .37)
> 2.6.32.30: 'x86 quirk: Fix polarity for IRQ0 pin2 override on SB800
> systems' broke the revision check for other quirks (fixed in .34)

Bugs are always a part of life, the fact that we fix them is what is
important.

> 2.6.32.29: 'USB: Prevent buggy hubs from crashing the USB stack' broke
> MUSB on BeagleBoards (still unfixed?)

This woried me, as I don't recall anyone notifying me of it.  Then I saw
your revert, and I noticed that all you really need to resolve this is
commit id ec95d35a6bd0047f05fe8a21e6c52f8bb418da55 to be added to the
tree.  I'll go queue that one up for the next .32-stable tree.

So all should be resolved now, right?

thanks,

greg k-h
