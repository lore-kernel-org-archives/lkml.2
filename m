Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab0FQXcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:32:18 -0400
Received: from kroah.org ([198.145.64.141]:54520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab0FQXcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:32:17 -0400
Date: Thu, 17 Jun 2010 16:28:10 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Mark Rankilor <reodge@gmail.com>, devel@driverdev.osuosl.org,
       Henri =?iso-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>, gregkh@suse.de,
       andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
Message-ID: <20100617232810.GA6821@kroah.com>
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
 <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>
 <1276405626.1449.26.camel@Joe-Laptop.home>
 <1276407050.1449.28.camel@Joe-Laptop.home>
 <20100617225108.GA32334@kroah.com>
 <1276816558.1005.93.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276816558.1005.93.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 04:15:58PM -0700, Joe Perches wrote:
> On Thu, 2010-06-17 at 15:51 -0700, Greg KH wrote:
> > On Sat, Jun 12, 2010 at 10:30:50PM -0700, Joe Perches wrote:
> > > On Sat, 2010-06-12 at 22:07 -0700, Joe Perches wrote:
> > > > 2: Create some comedi logging functions or macros like:
> > > >    	comedi_<level>(fmt, arg...) (ie: comedi_info, comedi_err, etc)
> > > >    where "comedi:" is always prefixed and an
> > > >    optional #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > >    could be used.
> 
> > I would prefer the conversion of everything over to the dev_printk()
> > versions instead of creating a new macro for every individual subsystem.
> > That way you get the advantage of logging everything in the common
> > format and the dynamic debug functionality as well.
> 
> What I posted has dynamic_debug.
> 
> +#elif defined(CONFIG_DYNAMIC_DEBUG)
> +/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
> +#define comedi_debug(fmt, ...)                         \
> +       dynamic_pr_debug(fmt, ##__VA_ARGS__)
> 
> As far as I know, comedi doesn't always take a struct device *.
> I believe it's only used when there's a DMA.

No, there's a struct device down in the device almost always.

> In struct comedi_device, there are two struct device *'s.
> 
> 	struct device *class_dev;
> ...
> 	struct device *hw_dev;

hw_dev is what we want to use.

thanks,

greg k-h
