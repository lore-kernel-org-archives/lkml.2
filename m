Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2JVSuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:50:10 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46834 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2JVSuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:50:08 -0400
Date: Mon, 22 Oct 2012 11:50:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Nair <anilcoll90@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: usbview 2.0 release
Message-ID: <20121022185004.GA19645@kroah.com>
References: <20121022162140.GA10021@kroah.com>
 <CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
 <1350927423.4238.5.camel@iscandar.digidescorp.com>
 <20121022175907.GA19113@kroah.com>
 <CAHkwNTnH-qx5rUZhVwB9cW-4wVOa-TEuO3=A158XZ7T+Y7LOPw@mail.gmail.com>
 <CAHkwNTniuL-G11c25FV5k5F_yyhOR-++OBhOahBugjeFqWzFng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkwNTniuL-G11c25FV5k5F_yyhOR-++OBhOahBugjeFqWzFng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 12:09:00AM +0530, Anil Nair wrote:
> Hello Greg,
> 
> I had only one doubt though the tool seems to work for rooted users only?
> when i try to launch it as a normal user it gives me error saying,
> 
> "
> Can not open the file /sys/kernel/debug/usb/devices
> 
>  Verify that you have USB compiled into your kernel,
>  have the USB core modules loaded, and have the
>  usbdevfs filesystem mounted
> 
> "

Ugh, that old usbdevfs name should go away, it's debugfs that is being
used now, thanks for pointing it out.

> That problem gets solved when using root user, is it because of the
> reason that i have to mount usbdevfs for my current user?
> The earlier usbview v1.1 tool required that that is why i am asking you.

No, debugfs needs to be mounted at /sys/kernel/debug/  Is it not mounted
that way for you?  Perhaps it is mounted with root-only access (default
for 3.7-rc1 and newer kernels)?

I should just port the thing to use libusb instead of debugfs, but
that's a larger job for such a low-priority tool.

thanks,

greg k-h
