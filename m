Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab0D1XO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:14:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32877 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab0D1XO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GoVBlhU5AtQJn0ihGIuAqkViw1/23dOiTVY9ZyYCZkQERDFevQBKRi6yPSAm9hylss
         r8ustc52sIyCKfT33JvINC0qbShg3u8WFnsWQSiujVznafBHgl4YBAtb+75hxcsiHL6S
         YOsYKJz9pdwBkDat2ad2hAkOyBKmTSvG4lwLA=
MIME-Version: 1.0
In-Reply-To: <s91ma7-76h.ln1@chipmunk.wormnet.eu>
References: <4BD8415C.9060409@gmail.com> <s91ma7-76h.ln1@chipmunk.wormnet.eu>
Date: Thu, 29 Apr 2010 09:14:26 +1000
Message-ID: <y2zd66caabb1004281614qe5af7fa7i6d9d5ac957ea6520@mail.gmail.com>
Subject: Re: Request For Help - Embedded x86, Kernel 2.6.33 boots, Mounts 
	JFFS2 rootfs, Stops at init
From: Graeme Russ <graeme.russ@gmail.com>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 1:37 AM, Alexander Clouter <alex@digriz.org.uk> wrote:
> Graeme Russ <graeme.russ@gmail.com> wrote:
>>
>> I've been working for a while now getting the x86 U-Boot port up to speed
>> to boot a linux kernel
>>
> ...ewww x86.

Yeah, nothing like a challange ;)

>
>> [snipped]
>>
>> [    1.911896] Write protecting the kernel read-only data: 596k
>> [    1.915842] kernel_execve(/sbin/init)
>>
>> (I've added a printk in kernel_execve() which gives me the last line)
>>
>> I  initially had hot-plug support compiled into the kernel and was getting
>> a lot of kernel_execve(/sbin/hotplug) messages as well (plus a udev:
>> starting version 151 message which appear 100+ seconds and the above
>> messages), but I have since removed that and used mknod to create
>> /dev/ttyS0 directly
>>
>> I have also tried the following test script:
>>
>> #!/bin/bash
>> stty -F /dev/ttyS0 115200
>> cat hello > /dev/ttyS0
>>
>> but still no luck
>>
>> Does anyone have any advise on how I can debug this problem?
>>
> What does you /dev directory look like?  You need to have at least the
> following:
> ----
> mknod console c 5 1
> mknod null c 1 3
> mknod ttyS0 c 4 64
> ----
>

tick, tick, tick

A little further background (should have included this last night but it
was late and I thought the problem must be trivial)...

I had originally mounted this root fs using NFS with (very) limited
success. After mounting and performing a few NFS requests (observed using
wireshark) the NFS activity would simply stop with 'server not responding'
messages. I turned on debugging in the 8139too and NFS drivers. With
debugging output enabled I was still getting 'server not responding'
messages, but (eventually) the boot sequence would continue. This even
resulted in logs in /var/log of the NFS share for the device (filled with
raw network packet data).

But no console...

What if I init with the following:

#!/bin/bash
echo hello > /hello.txt

and then rebooted and checked the root fs in U-Boot? How long will it
take for hello.txt to be flushed? Can I force the flush?

Regards,

Graeme
