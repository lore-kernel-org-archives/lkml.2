Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab0FMFHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 01:07:13 -0400
Received: from mail.perches.com ([173.55.12.10]:1097 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0FMFHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 01:07:12 -0400
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
From: Joe Perches <joe@perches.com>
To: Mark Rankilor <reodge@gmail.com>
Cc: Henri =?ISO-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>,
       devel@driverdev.osuosl.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, andrea.gelmini@gelma.net
In-Reply-To: <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
	 <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 22:07:06 -0700
Message-ID: <1276405626.1449.26.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-13 at 10:14 +0800, Mark Rankilor wrote:
> 2010/6/12 Henri Häkkinen <henuxd@gmail.com>:
> > -                       printk
> > -                           (KERN_INFO "comedi: failed to increment module count, skipping\n");
> > +                       printk(KERN_INFO "comedi: failed to increment module "
> > +                              "count, skipping\n");
> 
> Regarding your breaking up of printk statements, although some of
> those lines do go over 80 characters, it is preferable to keep the
> strings together since then those are searchable within the code.
> 
> I figure it is quite acceptable to break the string after "comedi: ",
> so maybe that will fix the line length issue, otherwise it is
> preferable to keep the checkpatch warning in this case.

A couple of options for comedi:

1: Use #define pr_fmt(fmt) "comedi: " fmt
   pr_<level>(format, ...)

2: Create some comedi logging functions or macros like:
   	comedi_<level>(fmt, arg...) (ie: comedi_info, comedi_err, etc)
   where "comedi:" is always prefixed and an
   optional #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
   could be used.

That'd shorten line lengths quite a bit and add
some better standardization to comedi.


