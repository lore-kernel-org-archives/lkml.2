Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab2C1HmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:42:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38086 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2C1HmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:42:02 -0400
MIME-Version: 1.0
In-Reply-To: <1332869030.2213.46.camel@joe2Laptop>
References: <1332869030.2213.46.camel@joe2Laptop>
Date: Wed, 28 Mar 2012 09:42:00 +0200
X-Google-Sender-Auth: 4Kk5-SOV5_DbEJfoJOU5C_FhIDU
Message-ID: <CAMuHMdWOw+UgdL7H9MLm6LLEFBkuqecrc4urHMYi7E7eTGWz4w@mail.gmail.com>
Subject: Re: [RFC] Remove most all #define pr_fmt(fmt) lines
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, Jim Cromie <jim.cromie@gmail.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 19:23, Joe Perches <joe@perches.com> wrote:
>  #ifndef pr_fmt
> +
> +#ifndef pr_fmt_std
> +#define pr_fmt_std(fmt) KBUILD_MODNAME ": " fmt
> +#endif
> +#ifndef pr_fmt_dbg
> +#define pr_fmt_dbg(fmt) fmt
> +#endif
>  #define pr_fmt(fmt) fmt

What's the rationale behind the above line?
I had expected

     #define pr_fmt(fmt) pr_fmt_std(fmt)

> +
> +#else
> +
> +#ifndef pr_fmt_std
> +#define pr_fmt_std(fmt...) pr_fmt(fmt)

Why the "fmt..." here, and "fmt" in the definitions above?

> +#endif
> +#ifndef pr_fmt_dbg
> +#define pr_fmt_dbg(fmt...) pr_fmt(fmt)
> +#endif
> +
>  #endif

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
