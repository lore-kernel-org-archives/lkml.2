Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab1DMWrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:47:21 -0400
Received: from kroah.org ([198.145.64.141]:45471 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab1DMWrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:47:20 -0400
Date: Wed, 13 Apr 2011 15:46:21 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: "Mark A. Allyn" <mark.a.allyn@intel.com>, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, jayant.mangalampalli@intel.com,
        venkat.r.gokulrangan@intel.com
Subject: Re: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Message-ID: <20110413224621.GA4909@kroah.com>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
 <1302731811.11415.38.camel@Joe-Laptop>
 <20110413222332.GA32013@kroah.com>
 <1302733836.11415.42.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302733836.11415.42.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:30:36PM -0700, Joe Perches wrote:
> On Wed, 2011-04-13 at 15:23 -0700, Greg KH wrote:
> > Ick, no, never use your own macros, just use the "real" things like is
> > done in this driver.  If it's a pain to get to that pointer, then use a
> > temporary variable in the code and then use it.
> > 
> > Otherwise, no, I don't like this patch at all, sorry.
> 
> I think you're simply incorrect here.
> 
> There are lots of other uses like netdev_<foo>
> where <foo>_<level> takes a particular pointer type.
> 
> This is a structure that contains a pointer to
> another structure than contains a struct device.
> 
> You might also look at the macros the USB subsystem
> uses for message logging.
> 
> Hey, aren't you the USB maintainer?

Yes, and over time we have been moving away from using those macros.  I
don't like seeing every individual driver have its own way of handling
debug macros, that's crazy.

For larger stuff like networking, yes, they can do that, and that's
fine.  They also were doing this before the dev_* macros came along,
just like USB did, so there is historical precident there.

But again, not for a new driver, don't redefine the existing macros just
because you don't like typing a few extra characters...

thanks,

greg k-h
