Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab2IYVFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:05:06 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55390 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab2IYVFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <7cfb202968f0928bba66965146a828a1cff87950.1345978012.git.joe@perches.com>
References: <cover.1345978012.git.joe@perches.com>
	<7cfb202968f0928bba66965146a828a1cff87950.1345978012.git.joe@perches.com>
Date: Tue, 25 Sep 2012 23:05:03 +0200
X-Google-Sender-Auth: 3dQqkqpe8mWRv24yXs1Fk6z-ZPM
Message-ID: <CAMuHMdVH-ni1NhbTDXgh82WUSAV85fahUjp1BoizVy6D2Xyvaw@mail.gmail.com>
Subject: Re: [PATCH 4/5] dev: Add dev_vprintk_emit and dev_printk_emit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Kay Sievers <kay@vrfy.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 1:25 PM, Joe Perches <joe@perches.com> wrote:
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -914,6 +918,13 @@ int _dev_info(const struct device *dev, const char *fmt, ...);
>
>  #else
>
> +static int dev_vprintk_emit(int level, const struct device *dev,

Missing "inline", cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/7271354/

include/linux/device.h:930:12: error: 'dev_vprintk_emit' defined but
not used [-Werror=unused-function]
cc1: all warnings being treated as errors
make[2]: *** [arch/sh/kernel/dma-nommu.o] Error 1

> +                           const char *fmt, va_list args)
> +{ return 0; }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
