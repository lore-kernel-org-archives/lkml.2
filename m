Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0FMSMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 14:12:00 -0400
Received: from mail.perches.com ([173.55.12.10]:1114 "EHLO mail.perches.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab0FMSL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 14:11:59 -0400
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
From: Joe Perches <joe@perches.com>
To: Henri =?ISO-8859-1?Q?H=E4kkinen?= <henrih81@gmail.com>
Cc: Mark Rankilor <reodge@gmail.com>, devel@driverdev.osuosl.org,
       gregkh@suse.de, andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org
In-Reply-To: <EC683E5B-0C90-4C16-B493-7BFAEC675BDA@gmail.com>
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
	 <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>
	 <1276405626.1449.26.camel@Joe-Laptop.home>
	 <1276407050.1449.28.camel@Joe-Laptop.home>
	 <EC683E5B-0C90-4C16-B493-7BFAEC675BDA@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 11:11:18 -0700
Message-ID: <1276452678.1449.73.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-13 at 14:27 +0300, Henri Häkkinen wrote:
> There are several printk statements without the "comedi:" prefix.
> Do you think it is better to leave these as they are, or should they
> be changed to use comedi_xxx macros (which will print the "comedi:"
> prefix)?
> 
> printk(KERN_WARNING "BUG: dev->driver=NULL in comedi_device_detach()\n");

I think it's better to convert them.

Anything with "BUG" in the format
maybe should be converted to BUG_ON.

> Also even with logging macros, there will be few lines which go beyond
> the 80 character boundary.

I'd ignore printk related long line warnings.

I suggest coalescing the format string to a single line
where reasonable.  If a single printk has non trailing
'\n's in a format, it may be better to split them up.

comedi_info("some incredibly long output line with error: %d\n"
	    "Another line with some other information: %d\n",
	    err, info);


