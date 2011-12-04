Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1LDTfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:35:51 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:32972 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1LDTfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:35:50 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44.1112041459310.4682-100000@hubble.stokkie.net>
References: <Pine.LNX.4.44.1112041459310.4682-100000@hubble.stokkie.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 4 Dec 2011 11:35:22 -0800
X-Google-Sender-Auth: 7yaCcXI7WA9XwuMIPCj_dC6uouE
Message-ID: <CA+55aFyYxvTFGmO3Z-h3LOYJC3i90g6Epe37McpBZP=gUbrGjQ@mail.gmail.com>
Subject: Re: restrictions inside GCC 4.6.x and libc6-2.13 (x86_64)
To: "Robert M. Stockmann" <stock@stokkie.net>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds like you have compiled it with -D_FORTIFY_SOURCE=1 (which may
well be the default on Ubuntu these days), and it found a real bug.

You need to check *which* snprintf is overflowing the buffer (should
be easy enough with gdb), and see where that happens.

Or you could try to disable fortify, and live with the bug that
apparently seldom causes problems in practice.

You can do it with -D_FORTIFY_SOURCE=0. I don't recommend it, but if
the program is doing something odd/bad on purpose, or if you are not
willing to try to debug it, it should give you a working setup. Or as
working as it ever was.

You should also report this to the right people. Which is *not* the
kernel people. Talk to the libspf guys. Because it's almost certainly
a real bug in their code.

                    Linus


On Sun, Dec 4, 2011 at 6:42 AM, Robert M. Stockmann <stock@stokkie.net> wrote:
>
> Hi,
>
> As i wanted to port some old source code [1] to the latest
> ubuntu 11.10 x86_64 distribution i ran across a strange
> observation :
>
> [acer30:root]:(/usr/lib/x86_64-linux-gnu)# spfqtool -i 192.168.2.5 -s stock@stokkie.net -h stokkie.net
> *** buffer overflow detected ***: spfqtool terminated
> ======= Backtrace: =========
> /lib/x86_64-linux-gnu/libc.so.6(__fortify_fail+0x37)[0x7fb98f9537f7]
> /lib/x86_64-linux-gnu/libc.so.6(+0xf7710)[0x7fb98f952710]
> /lib/x86_64-linux-gnu/libc.so.6(+0xf6dfb)[0x7fb98f951dfb]
> /lib/x86_64-linux-gnu/libc.so.6(__snprintf_chk+0x78)[0x7fb98f951cd8]
> /usr/lib/libspf-1.0.so.0(SPF_init+0x277)[0x7fb98fbfc8e7]
> spfqtool[0x400afb]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xed)[0x7fb98f87c30d]
> spfqtool[0x400e1d]
>
> [ ... ]"
>
> This is also observed on ubuntu 11.04 x86_64 ..
> When searching on google for this with 'spfqtool' omitted  :
>
> *** buffer overflow detected ***:  terminated
> http://www.google.com/search?hl=en&safe=off&q=***+buffer+overflow+detected+***%3A++terminated&oq=***+buffer+overflow+detected+***%3A++terminated&aq=f&aqi=g-v1g-b9&aql=&gs_sm=e&gs_upl=5641l6824l0l8707l9l9l0l0l0l0l111l878l4.5l9l0
>
> i get about About 820,000 results (0.08 seconds), which reach from the
> year 2009 upto 2011.  I really wonder what is the trouble here, as such
> old source, which has run many CPU cycles for the last 8 years, now
> suddenly has become buggy and prone to buffer overflows ...
>
> Any suggestions on how to migrate 'old code' to the new Linux
> platforms ?
>
> Best Regards,
>
> Robert
> [1] libspf (www.libspf.org)
>    http://crashrecovery.org/SPF/RPMS/spf/src/
>    http://crashrecovery.org/SPF/RPMS/spf/src/libspf-1.0.0-RC6-pre10.tar.bz2
> --
> Robert M. Stockmann - RHCE
> Network Engineer - UNIX/Linux Specialist
> crashrecovery.org  stock@stokkie.net
>
