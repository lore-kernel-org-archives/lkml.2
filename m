Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab1DEISZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:18:25 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55857 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1DEISX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:18:23 -0400
Date: Tue, 5 Apr 2011 09:18:18 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jamie Iles <jamie@jamieiles.com>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] gpio: support for Synopsys DesignWare APB GPIO
Message-ID: <20110405081817.GA4797@pulham.picochip.com>
References: <1301665638-29841-1-git-send-email-jamie@jamieiles.com>
 <alpine.LFD.2.00.1104022300130.5929@localhost6.localdomain6>
 <20110403025907.GA5670@pulham.picochip.com>
 <BANLkTimCG5t0k0XS=ojj_AqKM-7e=GB6-A@mail.gmail.com>
 <alpine.LFD.2.00.1104031118580.5929@localhost6.localdomain6>
 <20110403120344.GA1540@oksana.dev.rtsoft.ru>
 <20110403140750.GB5670@pulham.picochip.com>
 <BANLkTikoODn75U=DKiqT9xV6kVsjr5T2fA@mail.gmail.com>
 <20110403152244.GC5670@pulham.picochip.com>
 <20110405024838.GA29522@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405024838.GA29522@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 08:48:38PM -0600, Grant Likely wrote:
> On Sun, Apr 03, 2011 at 04:22:44PM +0100, Jamie Iles wrote:
> > The reason I proposed this was for controllers where the registers 
> > aren't grouped together for each bank.  For example, the Synopsys 
> > block has:
> > 
> > 	0x00-0x08 bank A control registers
> > 	0x0c-0x14 bank B control registers
> > 	...
> > 	0x50	  bank A input register
> > 	0x54	  bank B input register.
> > 
> > So when you mentioned before using a single register resource with 
> > offsets I understood it to be something like what I've proposed 
> > otherwise multiple banks would have overlapping resources (or the 
> > resource would just be used to indicate the start address rather than 
> > start + end).
> 
> That may be a problem for request_mem_region() which would indeed
> prevent the driver from specifying the full register range with
> offsets inside it.  I suspect that the platform_bus_type will inhibit
> two platform_devices with overlapping regions from getting registered.
> Fair enough, that is a pretty strong argument for Anton's model.  I
> don't think it would be a good idea to try and work around it by
> making the resource only include the start address.
> 
> It does mean some gymnastics for a device tree binding to figure out
> which registers are present, but the appropriate behaviour could be
> selected by a set of compatible values for each kind of register
> interface.

OK, I'll start having a look at this then.  I have a few other things on 
at the moment so it may take me a little while to get onto it but I'll 
try and get some patches posted fairly quickly.

Anton, I'm happy to do some of the changes that Thomas suggested such as 
removing some of the runtime calculations too unless you're planning on 
doing these.

> > 
> > Also, it's not clear here but this would create one gpio_chip per bank.
> 
> And that's bad why?  :-)

Not a bad thing, I just realized that my initial description was far 
from complete!

Jamie
