Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3AJK2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:28:40 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:54944 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab3AJK2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:28:38 -0500
X-IronPort-AV: E=Sophos;i="4.84,443,1355094000"; 
   d="scan'208";a="189246355"
Date: Thu, 10 Jan 2013 11:28:32 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add helper functions for setting up transfers
In-Reply-To: <50EE8FFD.2000000@metafoo.de>
Message-ID: <alpine.DEB.2.02.1301101125520.2063@localhost6.localdomain6>
References: <1357752671-30222-1-git-send-email-lars@metafoo.de> <alpine.DEB.2.02.1301100951060.2063@localhost6.localdomain6> <50EE8FFD.2000000@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2013, Lars-Peter Clausen wrote:

> On 01/10/2013 09:53 AM, Julia Lawall wrote:
> >> +@r1@
> >> +identifier fn;
> >> +identifier xfers;
> >> +@@
> >> +fn(...)
> >> +{
> >> +	...
> >> +(
> >> +	struct spi_transfer xfers[...];
> >> +|
> >> +	struct spi_transfer xfers[];
> >> +)
> >> +	...
> >> +}
> > 
> > Can it happen that there would be more than one spi_transfer or spi_message
> > variable per function?  This semantic patch will only treat the case where
> > there is only one, because the ... before an after the variable declaration
> > won't match another declaration of the same form.
> > 
> > julia
> 
> I guess it could happen, but I would consider it to be very rare. There are
> a few examples of multiple transfers in the kernel. But most of them look like
> 
> struct spi_message msg;
> struct spi_transfer xfer_foo;
> struct spi_transfer xfer_bar;
> 
> ...
> spi_message_add_tail(&xfer_foo, &msg);
> spi_message_add_tail(&xfer_bar, &msg);
> 
> So the transformation can't be applied here anyway.
> 
> Do you have an idea how to change the rule to work with multiple
> transfers/messages per function? If it would make the cocci file more
> complex I wouldn't bother to take care of it, since it basically has no
> practical use.

Probably the simplest thing is to put when any on all of the ...s
It might get slower, though.

Alternatively you could have a rule at the end that prints a warning for 
any cases that are not transformed.

julia
