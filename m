Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1BIWuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:50:52 -0500
Received: from kroah.org ([198.145.64.141]:57180 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1BIWuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:50:50 -0500
Date: Wed, 9 Feb 2011 14:50:38 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110209225038.GA23245@kroah.com>
References: <20110209224006.GA11202@kroah.com>
 <20110209144419.f673facf.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209144419.f673facf.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 02:44:19PM -0800, Randy Dunlap wrote:
> On Wed, 9 Feb 2011 14:40:06 -0800 Greg KH wrote:
> 
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > This adds the samsung-laptop driver to the kernel.  It now supports
> > all known Samsung laptops.
> > 
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  Documentation/ABI/testing/sysfs-driver-samsung-laptop |   19 
> >  drivers/platform/x86/Kconfig                          |   13 
> >  drivers/platform/x86/Makefile                         |    1 
> >  drivers/platform/x86/samsung-laptop.c                 |  768 ++++++++++++++++++
> >  4 files changed, 801 insertions(+)
> > 
> > Matthew, this is a copy of the latest version in the linux-next tree of the
> > driver.  Once it has been accepted into your tree, I'll delete the
> > staging driver.  Or, if you want to give your ACK, I can just move the
> > driver from staging into this directory in my tree, which will properly
> > preserve the history of the code.
> 
> 
> > diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> > index d163bc2..da9aed1 100644
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -654,4 +654,17 @@ config XO1_RFKILL
> >  	  Support for enabling/disabling the WLAN interface on the OLPC XO-1
> >  	  laptop.
> >  
> > +config SAMSUNG_LAPTOP
> > +	tristate "Samsung Laptop driver"
> > +	depends on RFKILL && BACKLIGHT_CLASS_DEVICE && X86
> 
> This entire Kconfig file already depends on X86, so the "&& X86" above
> is redundant.

Ah, yeah, nice catch, that came from when it was stand-alone in the
staging directory.  Can't hurt though :)

Matthew, want me to respin for this change?

thanks,

greg k-h
