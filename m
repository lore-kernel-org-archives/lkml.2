Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1IFXAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:00:51 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52432 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312Ab1IFXAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:00:43 -0400
X-Sasl-enc: y2tw0okUGCP9GEnJisHQ6+f3koo9lLGWI0dsekwoL0MN 1315350042
Date: Tue, 6 Sep 2011 15:57:08 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andrew Chew <AChew@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V3 1/5] i2c: Add irq_gpio field to struct i2c_client,
 i2c_board_info.
Message-ID: <20110906225708.GA28957@kroah.com>
References: <1314914676-28397-1-git-send-email-swarren@nvidia.com>
 <20110902085620.4ad918c4@endymion.delvare>
 <4E609F9C.5020403@cam.ac.uk>
 <20110902112435.69c9e8f7@endymion.delvare>
 <74CDBE0F657A3D45AFBB94109FB122FF04B327A628@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B327A628@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 11:24:04AM -0700, Stephen Warren wrote:
> Jean Delvare wrote at Friday, September 02, 2011 3:25 AM:
> > Hi Jonathan,
> > 
> > On Fri, 02 Sep 2011 10:19:24 +0100, Jonathan Cameron wrote:
> > > On 09/02/11 07:56, Jean Delvare wrote:
> > > > Stephen,
> > > >
> > > > Can you please fix your e-mail client / system / whatever so that your
> > > > patch series are no longer sent duplicated?
> > > >
> > > > On Thu,  1 Sep 2011 16:04:27 -0600, Stephen Warren wrote:
> > > >> Some devices use a single pin as both an IRQ and a GPIO. In that case,
> > > >> irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
> > > >> Where they do, and the use of this feature is optional, and the system
> > > >> wishes to disable this feature, this field must be explicitly set to a
> > > >> defined invalid GPIO ID, such as -1.
> > > >>
> > > >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > > >> ---
> > > >> v3: Also add the field to i2c_board_info, and copy the field from
> > > >>     i2c_board_info to i2c_client upon instantiation
> > > >
> > > > I don't get the idea. The i2c core doesn't make any use of the field,
> > > > and that field will only be used by a few drivers amongst the 420+
> > > > i2c drivers in the tree. This looks like a waste of memory. What's wrong
> > > > with including the new field in the private platform or arch data
> > > > structure for drivers which need it?
> > >
> > > Why not make it platform data for now and 'if' it becomes way more common
> > > (probably won't) we can always propose adding as a general field at a later
> > > date.
> > 
> > Yes, this sounds like a much more reasonable approach.
> 
> BTW, if that's the direction that's decided, just take the first version
> of the patchset I posted, plus Jonathan Cameron's subsequent patch to
> modify ak8975 to accept GPIO ID through platform data.

I don't know which patchset that would be, can you please just resend
what you want applied so that I know I get the correct one?

thanks,

greg k-h
