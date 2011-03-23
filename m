Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab1CWO4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:56:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61306 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337Ab1CWOz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:55:59 -0400
Date: Wed, 23 Mar 2011 10:55:55 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: andy.green@linaro.org, andy@warmcat.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1103231044510.11889@xanadu.home>
References: <4D79F068.2080009@linaro.org> <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com> <1300828125.2402.300.camel@pasglop> <4D8924B6.8040403@linaro.org> <1300842219.2402.309.camel@pasglop> <alpine.LFD.2.00.1103222138320.11889@xanadu.home>
 <1300850595.2402.320.camel@pasglop> <4D89BDE2.60907@linaro.org> <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011, Alan Cox wrote:

> Much of this depends upon what the data is and what it changes. Things
> like interface names for example shouldn't be kernel mangled on the whim
> of random board vendors. They follow a unified behaviour *across*
> platforms, which is what matters most in the bigger picture.

And that's exactly what we're trying to restore on the Panda.  It 
happens that the Panda has an ethernet connector backed by an USB to 
Ethernet bridge, but the kernel currently decides to rename its network 
device from eth%d to usb%d, and assign it a random MAC address on each 
boot.  What we want _is_ a more unified behaviour with other platforms.

> Other stuff is to all intents and purposes sometimes hard coded into
> drivers because while they are USB drivers they are checking specific
> vendor id fields and changing behaviour on them. In some cases those
> vendor id fields are actually a specific hardwired device.

Here we're talking about a plain standard chipset but which happens in 
this case to be soldered directly on the board without the usual EEPROM 
which would have been used to distinguish this particular case 
otherwise.  All we have left is the board specific code where the kernel 
knows on which board it is dealing with, from where we can tell that one 
particular instance of that USB device should be used in some unexpected 
way in order to present user space with an unified behaviour with other 
similar platforms.


Nicolas

