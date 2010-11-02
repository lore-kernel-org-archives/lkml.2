Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0KBPa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:30:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33173 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0KBPax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vDjY40iwk/0j315qxd7VKhsEaFb4H3VJMMpLEllkKF7iTvC7zaZMZRp6WXbs6tIPs0
         aj7gl+sxb1QnwgDeFnt9Ak7DoKPQ7p04GVApOsrNEnitW1xtfRZ/p1/cEfvQd28mTY7W
         feIMPQ9C7sQccYIgXnsOOEO2ac7UsTcnZY/Us=
MIME-Version: 1.0
In-Reply-To: <20101011142428.GK19804@ZenIV.linux.org.uk>
References: <AANLkTin4886D+-yo=zrf2Yj2R5NM9qdRkc3M9cG2rN_F@mail.gmail.com>
	<20101010144952.GF19804@ZenIV.linux.org.uk>
	<AANLkTinuA3AzMoJ82pvCuhmo59DZxL2F1j3xhXUkjj7z@mail.gmail.com>
	<20101010235256.GG19804@ZenIV.linux.org.uk>
	<20101011024103.GH19804@ZenIV.linux.org.uk>
	<20101011043632.GA2566@cynthia.pants.nu>
	<20101011044808.GI19804@ZenIV.linux.org.uk>
	<Pine.BSM.4.64L.1010111218040.23471@herc.mirbsd.org>
	<20101011133545.GJ19804@ZenIV.linux.org.uk>
	<m3wrpo24u0.fsf@hase.home>
	<20101011142428.GK19804@ZenIV.linux.org.uk>
Date: Tue, 2 Nov 2010 16:30:52 +0100
X-Google-Sender-Auth: tsEiZ4MOwuSehA8cKssWj3YomGg
Message-ID: <AANLkTinbD+32635CYBhFGVmCrj8YxfjbR4dfSGiTQOsw@mail.gmail.com>
Subject: Re: aranym bug, manifests as "ida_remove called for id=13" on recent kernels
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Thorsten Glaser <tg@mirbsd.de>,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 16:24, Al Viro <viro@zeniv.linux.org.uk> wrote:
> BTW, any comments on signal patchset?  Seems to work here, including the
> stack expansion fixes, but that's on aranym.  I'll try to resurrect the
> real hardware, but that may take a while.  If somebody could give it a beating
> in the meanwhile...

I tried it on my Amiga 4000/040.
Without your patches, gdb gets stuck in state D+ when reaching a breakpoint:

| cassandra:~# gdb /tmp/hello
| GNU gdb 6.4.90-debian
| Copyright (C) 2006 Free Software Foundation, Inc.
| GDB is free software, covered by the GNU General Public License, and you are
| welcome to change it and/or distribute copies of it under certain conditions.
| Type "show copying" to see the conditions.
| There is absolutely no warranty for GDB.  Type "show warranty" for details.
| This GDB was configured as "m68k-linux-gnu"...Using host
libthread_db library "/lib/libthread_db.so.1".
|
| (gdb) break main
| Breakpoint 1 at 0x800003fc: file /home/geert/hello.c, line 6.
| (gdb) run
| Starting program: /tmp/hello
|
| Breakpoint 1, main (argc=1, argv=0xefbeedb4) at /home/geert/hello.c:6

With your patches, it works a bit better:

| cassandra:~# gdb /tmp/hello
| GNU gdb 6.4.90-debian
| Copyright (C) 2006 Free Software Foundation, Inc.
| GDB is free software, covered by the GNU General Public License, and you are
| welcome to change it and/or distribute copies of it under certain conditions.
| Type "show copying" to see the conditions.
| There is absolutely no warranty for GDB.  Type "show warranty" for details.
| This GDB was configured as "m68k-linux-gnu"...Using host
libthread_db library "/lib/libthread_db.so.1".
|
| (gdb) break main
| Breakpoint 1 at 0x800003fc: file /home/geert/hello.c, line 6.
| (gdb) run
| Starting program: /tmp/hello
|
| Breakpoint 1, main (argc=1, argv=0xefcc5db4) at /home/geert/hello.c:6
| 6	    printf("Hello, world! [C]\n");
| (gdb) cont
| Continuing.
| Hello, world! [C]
|
| Program exited normally.
| (gdb) run
| Starting program: /tmp/hello
|
| Breakpoint 1, main (argc=1, argv=0xef85bdb4) at /home/geert/hello.c:6
| 6	    printf("Hello, world! [C]\n");
| (gdb) next
| Hello, world! [C]

After which gdb is stuck in S+, and /tmp/hello in t.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
