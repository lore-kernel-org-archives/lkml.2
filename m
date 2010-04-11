Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab0DKRBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:01:37 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:50014 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0DKRBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DBssNtKYZJRNJ1SIIqPsoz6C5KzZjRcNUbBfbpBe00Ppe4hUvFkZ8LVqzne2Gd2+uO
         PuBeqS7aPc3iYrTJi3BxWsNsHCXmVQyeMEJK5Gzz5Kh8+ez/3lub9Gu8OZnvKZd7eknS
         v9LRqu9c0YKSAdIwmIm7anTIhKrULqmYelsiQ=
MIME-Version: 1.0
In-Reply-To: <20100411164248.GA1998@elf.ucw.cz>
References: <20100411072625.GA9926@elf.ucw.cz>
	 <n2g480988181004110742w2ce92bfdr4f0f01216f879fe8@mail.gmail.com>
	 <20100411164248.GA1998@elf.ucw.cz>
Date: Sun, 11 Apr 2010 10:01:34 -0700
X-Google-Sender-Auth: 90a73a67e8f243bf
Message-ID: <n2m480988181004111001h28d25ccavf6df2b4db62fadee@mail.gmail.com>
Subject: Re: staging: udlfb -- staging version does not work, external does
From: Bernie Thompson <bernie@plugable.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: roberto@unbit.it, gregkh@suse.de, Cyril Hrubis <metan@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

There are two separate issues you're discussing. Can you check the
lockup issue with the git.plugable.com code?

Thanks,
Bernie

On Sun, Apr 11, 2010 at 9:42 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> Thanks for the bug report!
>
> Thanks for trying to solve it :-).
>
>> > (I tried testing with cat /bin/bash > /dev/fb1 and cat /dev/fb0 >
>> > /dev/fb1).
>>
>> I don't think redirects like that will work.  The fbcon module loads
>> against one fb, and can only be switch with utilities like "fbset"
>>
>> > So I tried
>> >
>> >    Roberto De Ioris roberto at unbit.it
>> >    Wed Jun 10 08:00:07 PDT 2009
>>
>> It's good to know Roberto's works. This will be a solvable problem.
>>
>> OK - this may be this bug (fixed at
>> http://git.plugable.com/gitphp/index.php?p=udlfb&a=commit&h=ac7f578b51ce5738386b571d096da4d8889c48e0).
>>  Can you try latest udlfb (git clone
>> http://git.plugable.com/webdav/udlfb ) to see if that's it?
>
> I tried with that patch, no change. dmesg from insmod and cat /dev/fb0
>> /dev/fb1 attempt are:
>
> Apr 11 18:39:02 amd kernel: udlfb: module is from the staging
> directory, the quality is unknown, you have been warned.
> Apr 11 18:39:02 amd kernel: udlfb 1-1:1.0: usb_probe_interface
> Apr 11 18:39:02 amd kernel: udlfb 1-1:1.0: usb_probe_interface - got
> id
> Apr 11 18:39:02 amd kernel: usb 1-1: dlfb: allocated 4 65024 byte urbs
> Apr 11 18:39:02 amd kernel: usb 1-1: dlfb: set_par mode 1024x768
> Apr 11 18:39:02 amd kernel: usb 1-1: dlfb: DisplayLink USB device
> /dev/fb1 attached. 1024x768 resolution. Using 3072K framebuffer memory
> Apr 11 18:39:02 amd kernel: usbcore: registered new interface driver
> udlfb
> Apr 11 18:39:02 amd kernel: VMODES initialized
> Apr 11 18:39:08 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
> fb_info=f5087bf0 count=1
> Apr 11 18:39:08 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
> count=0
>
> I tried to play with /dev/fb1 a bit more:
>
> root@amd:~# cat /dev/zero > /dev/fb1
> cat: write error: No space left on device
> root@amd:~# cat /dev/fb1
> root@amd:~# echo ahoj > /dev/fb1
> root@amd:~# cat /dev/fb1
> ahoj
> root@amd:~#
>
> ...but still not change on usb connected display, and nothing really
> interesting in dmesg:
>
> Apr 11 18:41:39 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
> fb_info=f5087bf0 count=1
> Apr 11 18:41:40 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
> count=0
> Apr 11 18:41:46 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
> fb_info=f5087bf0 count=1
> Apr 11 18:41:46 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
> count=0
> Apr 11 18:41:51 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
> fb_info=f5087bf0 count=1
> Apr 11 18:41:51 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
> count=0
> Apr 11 18:41:52 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
> fb_info=f5087bf0 count=1
> Apr 11 18:41:53 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
> count=0
> Apr 11 18:41:59 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
> fb_info=f5087bf0 count=1
> Apr 11 18:41:59 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
> count=0
> Apr 11 18:42:01 amd kernel: usb 1-1: dlfb: open /dev/fb1 user=1
> fb_info=f5087bf0 count=1
> Apr 11 18:42:01 amd kernel: usb 1-1: dlfb: release /dev/fb1 user=1
> count=0
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
