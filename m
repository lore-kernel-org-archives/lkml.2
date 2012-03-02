Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2CBRGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:06:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51524 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2CBRGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:06:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.134.33 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Fri, 2 Mar 2012 09:04:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org, christoph.mair@gmail.com,
        stefan.nilsson@unixphere.com, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH 0/3] Replace bmp085 with bmp18x
Message-ID: <20120302170449.GA3186@kroah.com>
References: <1330545489-31169-1-git-send-email-eric.andersson@unixphere.com>
 <201202292018.45557.arnd@arndb.de>
 <20120229235217.494d49d8@pyramind.ukuu.org.uk>
 <201203021649.18156.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203021649.18156.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 04:49:17PM +0000, Arnd Bergmann wrote:
> On Wednesday 29 February 2012, Alan Cox wrote:
> > On Wed, 29 Feb 2012 20:18:45 +0000
> > Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > On Wednesday 29 February 2012, Eric Andersson wrote:
> > > > This patch-set replaces the BMP085 driver with a driver for Bosch Sensortec's new
> > > > generation of pressure sensors called BMP18x. These pressure sensors can be
> > > > connected on I2C but also on SPI as a variant, so the driver implements both.
> > > > Register-wise they are fully compatible with the older BMP085, so the driver will
> > > > support those chips as well.
> > > > 
> > > > The driver is based on bmp085.c by Christoph Mair.
> > > 
> > > Hmm,  the implementation looks fine, but I don't think we should add support
> > > for new devices with a one-off interface that we know is getting replaced by
> > > something generic.
> > > 
> > > Why is this not using IIO for its user interface?
> > 
> > This is become a repeating problem
> > 
> > Either get the IIO layer out of staging (where it appears to have
> > congealed) or stop asking people to use it. IIO stuck in staging is
> > becoming a problem not a cure. It's creating uncertainty blocking lots of
> > stuff that needs to get upstream and that current stream is going to
> > become a tide post Android merging.
> > 
> > It needs resolving one way or the other and soon.
> 
> Yes, that is probably true. It has been looking like we are closing in
> on merging IIO for some time now, but I'm not sure how well it's going
> recently. In November, Jonathan mentioned that he is busy with other
> things and that he would welcome other people to help out. There were
> patches to move parts of IIO out of staging, but I'm not completely
> sure how far they have come.
> 
> In case of bmp085 I don't see much of a problem and I was probably
> overreacting as this is an existing driver.
> 
> Unfortunately, I'm not sure if there is any reasonable alternative
> to iio for new device drivers: If we get a flood of new drivers for
> all sorts of sensors that each have their own user interface,
> someone still needs to review all those interfaces and come up
> with infrastucture to reduce the amount of code duplication and
> interface differences between the drivers. IIO was promising to
> do just that, and it has come a long way since it was initially
> included into staging. 

I merged a bunch of patches cleaning up some of the core changes that
iio needed to make in order for it to be able to move out of staging,
and those will show up in 3.4.  So, maybe, if all goes well, and people
do the work, 3.5 might have it moving out.

Hopefully :)

greg k-h
