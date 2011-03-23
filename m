Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab1CWPiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:38:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64034 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab1CWPiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:38:11 -0400
Date: Wed, 23 Mar 2011 11:38:08 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Greg KH <greg@kroah.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        andy.green@linaro.org, Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        roger.quadros@nokia.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <20110323150413.GC6284@kroah.com>
Message-ID: <alpine.LFD.2.00.1103231113200.11889@xanadu.home>
References: <4D79F068.2080009@linaro.org> <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com> <1300828125.2402.300.camel@pasglop> <4D8924B6.8040403@linaro.org> <1300842219.2402.309.camel@pasglop> <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop> <alpine.LFD.2.00.1103222336030.11889@xanadu.home> <20110323093847.55e9dbba@lxorguk.ukuu.org.uk> <20110323105335.GB778@opensource.wolfsonmicro.com> <20110323150413.GC6284@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Greg KH wrote:

> On Wed, Mar 23, 2011 at 10:53:35AM +0000, Mark Brown wrote:
> > In the specific case of MACs and device names for network adaptors we
> > have userspace solutions which are obscuring the discussion but there
> > are other things which get configured this way which one would usually
> > expect to be handled in kernel.
> 
> No, this isn't obsucuring the discussion, it's exactly the point here.
> 
> I asked for concrete examples of a need for this type of thing (i.e.
> platform data on USB devices), and this was the only need cited.  I
> then pointed out that this is correctly solved in userspace, as it has
> for other devices like this, and that it's not a valid example of this
> need.

It was also pointed out that, unlike those examples for which the user 
space solution has been developed to deal with other devices not exactly 
like this, that in this case determining the specific instance of the 
device that require a quirk is extremely cumbersome, hackish, fragile, 
and way more ugly and complex to maintain than some in-kernel solution 
where the actual knowledge of the specific board and device instance is 
obvious.  Again we're not after some particular customization for this 
particular board, but rather after a way to make the kernel behavior 
uniform across similar platforms.  From that point people are still free 
to use udev to apply customizations over the kernel default as they see 
fit.  It is that kernel default that we want to get.

> So again, this problem, for this device, has been solved in userspace
> without any kernel changes needed.

No it has not.  We are not going to convince every distributions to 
start accumulating complex and fragile user space hacks into their udev 
rules which would be justifiably seen as unneeded cruft for exceptional 
cases when the kernel can make things look regular and uniform to user 
space with much less code and infrastructure.  And so far it seems that 
everyone else agrees with dealing with such issues in the kernel, while 
the actual implementation is still debated.


Nicolas
