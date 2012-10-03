Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2JCPIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:08:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38231 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756489Ab2JCPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:08:14 -0400
X-Sasl-enc: ULyVR8H13MDjq3iiuudfRs4pS0WLIXQ9b/vpnnXQ5v9o 1349276893
Date: Wed, 3 Oct 2012 08:08:12 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 6/7] usb: core: reuse kbasename()
Message-ID: <20121003150812.GC8460@kroah.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1349190062-13107-6-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAHp75VeFNVnKiggLLtKnkpiLpTStQh45Ws+DOq+AZq0FOhp4Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeFNVnKiggLLtKnkpiLpTStQh45Ws+DOq+AZq0FOhp4Cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:27:27AM +0300, Andy Shevchenko wrote:
> On Tue, Oct 2, 2012 at 6:00 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> 
> > --- a/drivers/usb/core/file.c
> > +++ b/drivers/usb/core/file.c
> 
> > @@ -200,14 +200,9 @@ int usb_register_dev(struct usb_interface *intf,
> >
> >         /* create a usb class device for this usb interface */
> >         snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
> > -       temp = strrchr(name, '/');
> > -       if (temp && (temp[1] != '\0'))
> I have checked current linux-next, the drivers define .name in the
> usb_class_driver structure as '...%d'.
> So, what is the reason to check for trailing '/' here? Historical
> reasons or there is a (broken/3rd party/etc) driver with it?

I really do not remember why it was done this way, sorry.  I have no
problem not doing it anymore, as long as you are willing to fix any
potential bugs that might pop up :)

And no, I don't worry about 3rd party drivers, that shouldn't be an
issue at all here.

greg k-h
