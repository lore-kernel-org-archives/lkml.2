Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2JQHmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:42:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51670 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2JQHmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:42:37 -0400
MIME-Version: 1.0
In-Reply-To: <20121003150812.GC8460@kroah.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349190062-13107-6-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAHp75VeFNVnKiggLLtKnkpiLpTStQh45Ws+DOq+AZq0FOhp4Cg@mail.gmail.com>
	<20121003150812.GC8460@kroah.com>
Date: Wed, 17 Oct 2012 10:42:35 +0300
Message-ID: <CAHp75Vej3jGPy=-f7F1BVJeF43bOJXH-bRbDu8LY2UGw8jDN+w@mail.gmail.com>
Subject: Re: [PATCH 6/7] usb: core: reuse kbasename()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 6:08 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Oct 03, 2012 at 11:27:27AM +0300, Andy Shevchenko wrote:
>> On Tue, Oct 2, 2012 at 6:00 PM, Andy Shevchenko
>> <andriy.shevchenko@linux.intel.com> wrote:
>>
>> > --- a/drivers/usb/core/file.c
>> > +++ b/drivers/usb/core/file.c
>>
>> > @@ -200,14 +200,9 @@ int usb_register_dev(struct usb_interface *intf,
>> >
>> >         /* create a usb class device for this usb interface */
>> >         snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
>> > -       temp = strrchr(name, '/');
>> > -       if (temp && (temp[1] != '\0'))
>> I have checked current linux-next, the drivers define .name in the
>> usb_class_driver structure as '...%d'.
>> So, what is the reason to check for trailing '/' here? Historical
>> reasons or there is a (broken/3rd party/etc) driver with it?
>
> I really do not remember why it was done this way, sorry.  I have no
> problem not doing it anymore, as long as you are willing to fix any
> potential bugs that might pop up :)

Hmm... this series about cleaning up. The bugs might pop up in the
drivers that still using something like '/foo/bar/' for their names
here.
Anyway, I tried to dig into history and only what I found is the patch
http://www.kernel.org/pub/linux/kernel//people/akpm/patches/2.5/2.5.69/2.5.69-mm3/broken-out/linus.patch
that brings a piece of code. And it the same time it brings the same
piece to the tty layer. I suspect that this piece was copied and
pasted in few place.

Currently the device_create() call uses the name parameter as a
parameter of kobject. But kobject doesn't accept '/' in the names, it
changes it to '!'.
So, I think the way of treating a trailing slash in the usb code is redundant.

> And no, I don't worry about 3rd party drivers, that shouldn't be an
> issue at all here.

Fair enough


-- 
With Best Regards,
Andy Shevchenko
