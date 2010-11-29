Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0K2Vrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:47:39 -0500
Received: from kroah.org ([198.145.64.141]:37003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab0K2Vri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:47:38 -0500
Date: Mon, 29 Nov 2010 13:44:39 -0800
From: Greg KH <greg@kroah.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Greg KH <gregkh@suse.de>, Scott Wood <scottwood@freescale.com>,
        Timur Tabi <timur@freescale.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        devicetree-discuss@vger.kernel.org
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101129214439.GA9830@kroah.com>
References: <4CE546C5.8060401@freescale.com>
 <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com>
 <20101118112146.3275eb08@udp111988uds.am.freescale.net>
 <4CE5657D.8060105@freescale.com>
 <20101118121356.3491da72@udp111988uds.am.freescale.net>
 <1290594227.4446.12.camel@concordia>
 <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
 <20101124182353.GA10589@suse.de>
 <1290638647.14502.10.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290638647.14502.10.camel@concordia>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 09:44:07AM +1100, Michael Ellerman wrote:
> On Wed, 2010-11-24 at 10:23 -0800, Greg KH wrote:
> > On Wed, Nov 24, 2010 at 12:08:18PM -0600, Scott Wood wrote:
> > > On Wed, 24 Nov 2010 21:23:47 +1100
> > > Michael Ellerman <michael@ellerman.id.au> wrote:
> > > 
> > > > On Thu, 2010-11-18 at 12:13 -0600, Scott Wood wrote:
> > > > > Unfortunately, it's not an exact match, and the fact that reg doesn't
> > > > > translate to a physical address means that AFAICT you'll currently get
> > > > > something like "byte-channel.nnn", where "nnn" is an arbitrary
> > > > > kernel-assigned number.
> > > > 
> > > > Can you not use device_rename() ?
> > > 
> > > Ah, didn't know about that.  Still, might be nice to add support for
> > > "handle" nodes at the infrastructure level rather than in each driver.
> > 
> > No, please never use that function, bad things will happen.
> 
> Why? The network & wireless code uses it, so presumably it can work?

Yes it can, but networking is the only code that should use this.

> If
> not please consider:
> 
> commit f470f680dfaad8731f079a033a50440082e20930
> Author: Michael Ellerman <michael@ellerman.id.au>
> Date:   Thu Nov 25 09:41:28 2010 +1100
> 
>     driver core: Document that device_rename() is not to be used
>     
>     Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 6ed6454..f1fac19 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1513,6 +1513,8 @@ EXPORT_SYMBOL_GPL(device_destroy);
>   * exclusion between two different calls of device_rename
>   * on the same device to ensure that new_name is valid and
>   * won't conflict with other devices.
> + *
> + * "Never use this function, bad things will happen" - gregkh

Nice, I like it :)

I'll go queue this up.

greg k-h
