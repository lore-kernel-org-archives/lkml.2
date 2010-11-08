Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab0KHG6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 01:58:11 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:54807 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab0KHG6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:58:07 -0500
Date: Mon, 8 Nov 2010 08:57:37 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCH] drivers/misc: Altera Cyclone active serial
 implementation
Message-ID: <20101108065737.GA10452@jasper.tkos.co.il>
References: <879a6320efee16c04f0732a6887b95c1b4c6d10f.1288793522.git.baruch@tkos.co.il>
 <20101106181930.GB6927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101106181930.GB6927@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sat, Nov 06, 2010 at 11:19:30AM -0700, Greg KH wrote:
> On Wed, Nov 03, 2010 at 04:21:35PM +0200, Baruch Siach wrote:
> > From: Alex Gershgorin <agersh@rambler.ru>
> > 
> > The active serial protocol can be used to program Altera Cyclone FPGA devices.
> > This driver uses the kernel gpio interface to implement the active serial
> > protocol.
> > 
> > Signed-off-by: Alex Gershgorin <agersh@rambler.ru>
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---

[snip]

> > +static struct class *cyclone_as_class;
> 
> Please don't create your own class just for a single driver.  Just use
> the misc class interface instead, as all you really want/need here is a
> character device node, right?

Searching for 'mist' under include/linux/ I couldn't find this "misc class 
interface". Can you enlighten me?

I did find the "miscdevices" interface in include/linux/miscdevice.h.  I also 
tried this one before going on to create a class of my own. However, this 
interface seems to be limited to singleton devices. Can I use 
MISC_DYNAMIC_MINOR to create multiple device nodes? Is there any example for 
this?

> And as discussed at the Plumbers conference this past week, we don't
> want to add any new 'struct class' implementations to the kernel from
> now on, as it's the overall wrong thing to do.
> 
> > --- /dev/null
> > +++ b/include/linux/cyclone_as.h
> 
> Why do you need a .h file at all?

Look at the content of this file. I need to pass GPIO numbers from the 
platform code under arch/ to the driver. For this I use a platform_data 
struct, which must be visible to the platform code. Is there a better way to 
do this?

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
