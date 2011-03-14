Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab1CNWt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:49:26 -0400
Received: from imr4.ericy.com ([198.24.6.8]:54879 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab1CNWtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:49:25 -0400
Date: Mon, 14 Mar 2011 15:48:59 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        mems applications <mems.applications@st.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "carmine.iascone@st.com" <carmine.iascone@st.com>,
        "matteo.dameno@st.com" <matteo.dameno@st.com>,
        "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
Message-ID: <20110314224859.GA16970@ericsson.com>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com>
 <4D7E771B.1040804@cam.ac.uk>
 <20110314211809.29da8518@endymion.delvare>
 <201103142136.43566.arnd@arndb.de>
 <20110314224244.3d6d23ba@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110314224244.3d6d23ba@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 05:42:44PM -0400, Jean Delvare wrote:
> On Mon, 14 Mar 2011 21:36:43 +0100, Arnd Bergmann wrote:
> > On Monday 14 March 2011 21:18:09 Jean Delvare wrote:
> > > Jonathan is correct. Pressure sensors are not hardware monitoring
> > > devices, their drivers have nothing to do in drivers/hwmon. This is
> > > something for drivers/misc or staging/iio.
> > 
> > I generally try to prevent people from adding more ad-hoc interfaces
> > to drivers/misc. Anything that is called a drivers/misc driver to me
> > must qualify as "there can't possibly be a second driver with the
> > same semantics", otherwise it should be part of another subsystem
> > with clear rules, or be put into its own file system.
> 
> I see drivers/misc differently. I see it as "not enough drivers of the
> same type to justify a new subsystem". So I encourage people to put
> things there in the absence of any suitable subsystem, until someone
> gets enough motivation to start such a subsystem. This is more
> pragmatic than requesting subsystems to be created upfront.
> 
Agreed.

Note that there is already a pressure sensor in drivers/misc - bmp085.c.
That chip also includes a temperature sensor.

> That being said, staging is another option nowadays.
> 
> > While it seems that right now everyone is just trying to keep move
> > the driver to some other subsystem, I think it's worth noting that
> > it is indeed a useful thing to have the driver, I'm optimistic
> > that we can find some place for it. ;-)
> > 
> > Now how about the IIO stuff? This is the first time I've even
> > heard about it. Does it have any major disadvantages besides
> > being staging-quality?
> 
> This is indeed the major disadvantage. IIO seems to take a lot of time
> to move out of staging, although I don't know what the current ETA is.
> 
In general it would be nice to have a "sensors" subsystem. iio is going into
that direction, so creating another one might not make much sense at this point.

Guenter
