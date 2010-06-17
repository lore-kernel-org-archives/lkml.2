Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901Ab0FQXQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:16:04 -0400
Received: from mail.perches.com ([173.55.12.10]:1177 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab0FQXQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:16:01 -0400
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Mark Rankilor <reodge@gmail.com>, devel@driverdev.osuosl.org,
       Henri =?ISO-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>, gregkh@suse.de,
       andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org
In-Reply-To: <20100617225108.GA32334@kroah.com>
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
	 <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>
	 <1276405626.1449.26.camel@Joe-Laptop.home>
	 <1276407050.1449.28.camel@Joe-Laptop.home>
	 <20100617225108.GA32334@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 16:15:58 -0700
Message-ID: <1276816558.1005.93.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 15:51 -0700, Greg KH wrote:
> On Sat, Jun 12, 2010 at 10:30:50PM -0700, Joe Perches wrote:
> > On Sat, 2010-06-12 at 22:07 -0700, Joe Perches wrote:
> > > 2: Create some comedi logging functions or macros like:
> > >    	comedi_<level>(fmt, arg...) (ie: comedi_info, comedi_err, etc)
> > >    where "comedi:" is always prefixed and an
> > >    optional #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > >    could be used.

> I would prefer the conversion of everything over to the dev_printk()
> versions instead of creating a new macro for every individual subsystem.
> That way you get the advantage of logging everything in the common
> format and the dynamic debug functionality as well.

What I posted has dynamic_debug.

+#elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
+#define comedi_debug(fmt, ...)                         \
+       dynamic_pr_debug(fmt, ##__VA_ARGS__)

As far as I know, comedi doesn't always take a struct device *.
I believe it's only used when there's a DMA.

In struct comedi_device, there are two struct device *'s.

	struct device *class_dev;
...
	struct device *hw_dev;


