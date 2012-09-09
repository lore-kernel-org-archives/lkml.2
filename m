Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2IIO5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 10:57:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38868 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2IIO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 10:57:35 -0400
MIME-Version: 1.0
In-Reply-To: <1346425339-17138-1-git-send-email-linux@roeck-us.net>
References: <1346425339-17138-1-git-send-email-linux@roeck-us.net>
Date: Sun, 9 Sep 2012 16:57:34 +0200
X-Google-Sender-Auth: kKLae3wO4-cDpMspCy4TCZOdl0c
Message-ID: <CAMuHMdWT2xKzOY9t05mYTMjmk=-V_XQQ8mZc69eQyrDN99hMuw@mail.gmail.com>
Subject: Re: [PATCH v4] linux/kernel.h: Fix DIV_ROUND_CLOSEST to support
 negative dividends
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jean Delvare <khali@linux-fr.org>,
        lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 5:02 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> DIV_ROUND_CLOSEST returns a bad result for negative dividends:
>         DIV_ROUND_CLOSEST(-2, 2) = 0
>
> Most of the time this does not matter. However, in the hardware monitoring
> subsystem, DIV_ROUND_CLOSEST is sometimes used on integers which can be
> negative (such as temperatures).

This seems to cause 3 new warnings in my m68k builds of v3.6-rc5:

drivers/hwmon/mcp3021.c:76: warning: comparison is always true due to
limited range of data type
drivers/ide/ide-cd.c:1158: warning: comparison is always true due to
limited range of data type
drivers/ide/ide-cd.c:1159: warning: comparison is always true due to
limited range of data type

$ m68k-linux-gnu-gcc -v
Using built-in specs.
Target: m68k-linux-gnu
Configured with: ../src/configure -v --enable-languages=c,c++
--prefix=/usr --enable-shared --with-system-zlib --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --enable-nls
--with-gxx-include-dir=/usr/m68k-linux-gnu/include/c++/4.1.2
--program-suffix=-4.1 --enable-__cxa_atexit --enable-clocale=gnu
--enable-libstdcxx-debug --disable-libssp --disable-werror
--enable-checking=release --program-prefix=m68k-linux-gnu-
--includedir=/usr/m68k-linux-gnu/include --build=x86_64-linux-gnu
--host=x86_64-linux-gnu --target=m68k-linux-gnu
Thread model: posix
gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
