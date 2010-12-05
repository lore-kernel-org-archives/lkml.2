Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0LELPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 06:15:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51920 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab0LELPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 06:15:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=uXrAM9yBrx1Bt2S4hY9JMLJi1gW5Or2o8Pt6kj4TQoJhV2sRfSz5OZccqpRqfzwBGq
         RAaqz9CXwJ+kNIcGJzwYL5eIAMIoK2R4QQXiJAiUNxKEVBtvUx8rSbn1J4/ZyMFz+6nD
         eyI3HcKCY13Xbm6OdMI446q5B4B+btDG2//1U=
MIME-Version: 1.0
Date: Sun, 5 Dec 2010 12:15:10 +0100
X-Google-Sender-Auth: yNhE74N7YkucgXrseCElFRC-HDg
Message-ID: <AANLkTi=9B-8KN0oiXoiU+KqPt6B8Vs=d7yu9cui-7e1r@mail.gmail.com>
Subject: Signal patchset (was: Re: aranym bug, manifests as "ida_remove called
 for id=13" on recent kernels)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Thorsten Glaser <tg@mirbsd.de>,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 2, 2010 at 16:30, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Mon, Oct 11, 2010 at 16:24, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> BTW, any comments on signal patchset?  Seems to work here, including the
>> stack expansion fixes, but that's on aranym.  I'll try to resurrect the
>> real hardware, but that may take a while.  If somebody could give it a beating
>> in the meanwhile...
>
> I tried it on my Amiga 4000/040.
> Without your patches, gdb gets stuck in state D+ when reaching a breakpoint:
>
> | cassandra:~# gdb /tmp/hello
> | GNU gdb 6.4.90-debian
> | Copyright (C) 2006 Free Software Foundation, Inc.
> | GDB is free software, covered by the GNU General Public License, and you are
> | welcome to change it and/or distribute copies of it under certain conditions.
> | Type "show copying" to see the conditions.
> | There is absolutely no warranty for GDB.  Type "show warranty" for details.
> | This GDB was configured as "m68k-linux-gnu"...Using host
> libthread_db library "/lib/libthread_db.so.1".
> |
> | (gdb) break main
> | Breakpoint 1 at 0x800003fc: file /home/geert/hello.c, line 6.
> | (gdb) run
> | Starting program: /tmp/hello
> |
> | Breakpoint 1, main (argc=1, argv=0xefbeedb4) at /home/geert/hello.c:6
>
> With your patches, it works a bit better:
>
> | cassandra:~# gdb /tmp/hello
> | GNU gdb 6.4.90-debian
> | Copyright (C) 2006 Free Software Foundation, Inc.
> | GDB is free software, covered by the GNU General Public License, and you are
> | welcome to change it and/or distribute copies of it under certain conditions.
> | Type "show copying" to see the conditions.
> | There is absolutely no warranty for GDB.  Type "show warranty" for details.
> | This GDB was configured as "m68k-linux-gnu"...Using host
> libthread_db library "/lib/libthread_db.so.1".
> |
> | (gdb) break main
> | Breakpoint 1 at 0x800003fc: file /home/geert/hello.c, line 6.
> | (gdb) run
> | Starting program: /tmp/hello
> |
> | Breakpoint 1, main (argc=1, argv=0xefcc5db4) at /home/geert/hello.c:6
> | 6         printf("Hello, world! [C]\n");
> | (gdb) cont
> | Continuing.
> | Hello, world! [C]
> |
> | Program exited normally.
> | (gdb) run
> | Starting program: /tmp/hello
> |
> | Breakpoint 1, main (argc=1, argv=0xef85bdb4) at /home/geert/hello.c:6
> | 6         printf("Hello, world! [C]\n");
> | (gdb) next
> | Hello, world! [C]
>
> After which gdb is stuck in S+, and /tmp/hello in t.

Unless someone objects, I'm inclined to apply Al's patchset, as it improves the
situation anyway.

OK?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
