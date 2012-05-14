Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab2ENVeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:34:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60920 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2ENVeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120512001818.GH14782@lizard>
References: <20120512001506.GA8653@lizard>
	<20120512001818.GH14782@lizard>
Date: Mon, 14 May 2012 14:34:18 -0700
X-Google-Sender-Auth: gQLX-V7DrLogSflOQhGwCPrRf48
Message-ID: <CAGXu5jK961tGg01fHupR2kmCYvx1LGkPqT+uPZoC6g74ath_Mw@mail.gmail.com>
Subject: Re: [PATCH 08/11] ramoops: Move to fs/pstore/ram.c
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 5:18 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Since ramoops was converted to pstore, it has nothing to do with character
> devices nowadays. Instead, today it is just a RAM backend for pstore.
>
> The patch just moves things around. There are a few changes were needed
> because of the move:
>
> 1. Kconfig and Makefiles fixups, of course.
>
> 2. In pstore/ram.c we have to play a bit with MODULE_PARAM_PREFIX, this
>   is needed to keep user experience the same as with ramoops driver
>   (i.e. so that ramoops.foo kernel command line arguments would still
>   work).
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

This consolidation seems good. I might prefer the move separated from
the changes, just to make review easier, but I have no idea what
that'll do to a bisect. :P

> --- /dev/null
> +++ b/fs/pstore/ram.c

"ram.ko" seems like an awfully generic modbule name. Should this be
called pstore_ram.* instead, like was done for the header file?

And unless anyone objects, I have no problem letting the built-in name
change too.

> --- /dev/null
> +++ b/include/linux/pstore_ram.h
> @@ -0,0 +1,17 @@
> +#ifndef __RAMOOPS_H
> +#define __RAMOOPS_H

This define should probably change just to avoid confusion.

-Kees

-- 
Kees Cook
Chrome OS Security
