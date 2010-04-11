Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0DKQmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 12:42:18 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36380 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752162Ab0DKQmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 12:42:17 -0400
Date: Sun, 11 Apr 2010 18:42:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bernie Thompson <bernie@plugable.com>
Cc: roberto@unbit.it, gregkh@suse.de, Cyril Hrubis <metan@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: staging: udlfb -- staging version does not work, external does
Message-ID: <20100411164248.GA1998@elf.ucw.cz>
References: <20100411072625.GA9926@elf.ucw.cz>
 <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Thanks for the bug report!

Thanks for trying to solve it :-).

> > (I tried testing with cat /bin/bash > /dev/fb1 and cat /dev/fb0 >
> > /dev/fb1).
> 
> I don't think redirects like that will work.  The fbcon module loads
> against one fb, and can only be switch with utilities like "fbset"
> 
> > So I tried
> >
> >    Roberto De Ioris roberto at unbit.it
> >    Wed Jun 10 08:00:07 PDT 2009
> 
> It's good to know Roberto's works. This will be a solvable problem.
> 
> OK - this may be this bug (fixed at
> http://git.plugable.com/gitphp/index.php?p=udlfb&a=commit&h=ac7f578b51ce5738386b571d096da4d8889c48e0).
>  Can you try latest udlfb (git clone
> http://git.plugable.com/webdav/udlfb ) to see if that's it?

I tried with that patch, no change. dmesg from insmod and cat /dev/fb0
> /dev/fb1 attempt are:

Apr 11 18:39:02 amd kernel: udlfb: module is from the staging
directory, the quality is unknown, you have been warned.
Apr 11 18:39:02 amd kernel: udlfb 1-1:1.0: usb_probe_interface
Apr 11 18:39:02 amd kernel: udlfb 1-1:1.0: usb_probe_interface - got
id
Apr 11 18:39:02 amd kernel: usb 1-1: dlfb: allocated 4 65024 byte urbs
Apr 11 18:39:02 amd kernel: usb 1-1: dlfb: set_par mode 1024x768
Apr 11 18:39:02 amd kernel: usb 1-1: dlfb: DisplayLink USB device
/dev/fb1 attached. 1024x768 resolution. Using 3072K framebuffer memory
Apr 11 18:39:02 amd kernel: usbcore: registered new interface driver
udlfb
Apr 11 18:39:02 amd kernel: VMODES initialized
Apr 11 18:39:08 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
fb_info=f5087bf0 count=1
Apr 11 18:39:08 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
count=0

I tried to play with /dev/fb1 a bit more:

root@amd:~# cat /dev/zero > /dev/fb1
cat: write error: No space left on device
root@amd:~# cat /dev/fb1
root@amd:~# echo ahoj > /dev/fb1
root@amd:~# cat /dev/fb1
ahoj
root@amd:~#

...but still not change on usb connected display, and nothing really
interesting in dmesg:

Apr 11 18:41:39 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
fb_info=f5087bf0 count=1
Apr 11 18:41:40 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
count=0
Apr 11 18:41:46 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
fb_info=f5087bf0 count=1
Apr 11 18:41:46 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
count=0
Apr 11 18:41:51 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
fb_info=f5087bf0 count=1
Apr 11 18:41:51 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
count=0
Apr 11 18:41:52 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
fb_info=f5087bf0 count=1
Apr 11 18:41:53 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
count=0
Apr 11 18:41:59 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
fb_info=f5087bf0 count=1
Apr 11 18:41:59 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
count=0
Apr 11 18:42:01 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
fb_info=f5087bf0 count=1
Apr 11 18:42:01 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
count=0


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
