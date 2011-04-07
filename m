Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1DGIEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 04:04:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51816 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab1DGIEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 04:04:16 -0400
Date: Thu, 7 Apr 2011 01:04:04 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Greg KH <gregkh@suse.de>
Cc: Andres Salomon <dilinger@queued.net>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110407080404.GF6427@angua.secretlab.ca>
References: <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
 <20110404100314.GC2751@sortiz-mobl>
 <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
 <20110406155805.GA20095@suse.de>
 <20110406170537.GB2757@sortiz-mobl>
 <20110406175647.GA8048@suse.de>
 <20110406112557.5c4c9bfe@debxo>
 <20110406183854.GA10058@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406183854.GA10058@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:38:54AM -0700, Greg KH wrote:
> On Wed, Apr 06, 2011 at 11:25:57AM -0700, Andres Salomon wrote:
> > > > We've been faced with the problem of being able to pass both MFD
> > > > related data and a platform_data pointer to some of those drivers.
> > > > Squeezing the MFD bits in the sub driver platform_data pointer
> > > > doesn't work for drivers that know nothing about MFDs. It also adds
> > > > an additional dependency on the MFD API to all MFD sub drivers.
> > > > That prevents any of those drivers to eventually be used as plain
> > > > platform device drivers.
> > > 
> > > Then they shouldn't be "plain" platform drivers, that should only be
> > > reserved for drivers that are the "lowest" type.  Just make them MFD
> > > devices and go from there.
> > 
> > 
> > The problem is of mixing "plain" platform devices and MFD devices.
> 
> Then don't do that.

>From my perspective, MFD devices are little more than a bag of
platform_devices, with the MFD layer provides infrastructure for
managing it.  It isn't that there are 'plain' platform device and
'mfd' devices.  There are only platform_devices, but some of the
drivers use additional data stored in a struct mfd.

Personally, I'm not thrilled with the approach of using struct mfd, or
more specifically making it available to drivers, but on the ugly
scale it isn't very high.

However, the changes on how struct mfd is passed that were merged in
2.6.39 were actively dangerous and are going to be reverted.  Yet
a method is still needed to pass the struct mfd in a safe way.  I
don't have a problem with adding the mfd pointer to struct
platform_device, even if it should just be a stop gap to something
better.

Independently, I have been experimenting with typesafe methods for
attaching data to devices which may very well be the long term
approach, but for the short term I see no problem with adding the mfd
pointer, particularly because it is by far safer than any of the other
immediately available options.

g.
