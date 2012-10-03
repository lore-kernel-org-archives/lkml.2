Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2JCI1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:27:32 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42733 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654Ab2JCI13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:27:29 -0400
MIME-Version: 1.0
In-Reply-To: <1349190062-13107-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349190062-13107-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349190062-13107-6-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 3 Oct 2012 11:27:27 +0300
Message-ID: <CAHp75VeFNVnKiggLLtKnkpiLpTStQh45Ws+DOq+AZq0FOhp4Cg@mail.gmail.com>
Subject: Re: [PATCH 6/7] usb: core: reuse kbasename()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 6:00 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> --- a/drivers/usb/core/file.c
> +++ b/drivers/usb/core/file.c

> @@ -200,14 +200,9 @@ int usb_register_dev(struct usb_interface *intf,
>
>         /* create a usb class device for this usb interface */
>         snprintf(name, sizeof(name), class_driver->name, minor - minor_base);
> -       temp = strrchr(name, '/');
> -       if (temp && (temp[1] != '\0'))
I have checked current linux-next, the drivers define .name in the
usb_class_driver structure as '...%d'.
So, what is the reason to check for trailing '/' here? Historical
reasons or there is a (broken/3rd party/etc) driver with it?

> -               ++temp;
> -       else
> -               temp = name;
>         intf->usb_dev = device_create(usb_class->class, &intf->dev,
>                                       MKDEV(USB_MAJOR, minor), class_driver,
> -                                     "%s", temp);
> +                                     "%s", kbasename(name));



-- 
With Best Regards,
Andy Shevchenko
