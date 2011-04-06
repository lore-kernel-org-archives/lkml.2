Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1DFUlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:41:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42222 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab1DFUlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VBdyvn+KDslLVQjhUyGWcFWAVAt9nMcVJ4noi9/W15RPTW9zMNIv3aUdROPRMXsCK9
         +azIC8ghw6trYsCtUDPN0tdEYLgGVV/fKvRN6DuZ5sMh13X1LEqsiSLpAxNFw1kl4wau
         pDccfGnTSZ/0KukR8Mu1g7LY6bwQhNBofHVEM=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1104061336190.5855@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz>
	<AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
	<alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz>
	<AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com>
	<alpine.LNX.2.00.1103281619320.26754@pobox.suse.cz>
	<AANLkTi=pNxVY8NZjRhT_aJMQNiTpfkmECqc-ZnTD7ynW@mail.gmail.com>
	<alpine.LNX.2.00.1104061155530.5855@pobox.suse.cz>
	<BANLkTinnvXX70OCrtyYy_2e-zJDqS9f2iw@mail.gmail.com>
	<alpine.LNX.2.00.1104061336190.5855@pobox.suse.cz>
Date: Wed, 6 Apr 2011 22:40:58 +0200
X-Google-Sender-Auth: Za6k7PF-YYaZowlkvf2jemEUkX8
Message-ID: <BANLkTinhTM3pntJauwpxSEd02MDAB+VS1w@mail.gmail.com>
Subject: Re: [PATCH] brk: COMPAT_BRK: fix detection of randomized brk (was Re:
 [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound computation forCOMPAT_BRK)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 22:38, Jiri Kosina <jkosina@suse.cz> wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: brk: COMPAT_BRK: fix detection of randomized brk
>
> 5520e89 ("brk: fix min_brk lower bound computation for COMPAT_BRK")
> tried to get the whole logic of brk randomization for legacy (libc5-based)
> applications finally right.
>
> It turns out that the way to detect whether brk has actually been randomized in
> the end or not introduced by that patch still doesn't work for those binaries,
> as reported by Geert.
>
> I don't like it, but currently see no better option than a bit flag in
> task_struct to catch the CONFIG_COMPAT_BRK && randomize_va_space == 2
> case.
>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>
> I am not really happy about introducing the bit flag, but I currently
> don't see another option. And it's only for the legacy CONFIG_COMPAT_BRK
> case anyway.
>
> Andrew, Ingo, any opinions/objections?
>
> If not -- Andrew, I guess this should go into current -rc still.

And in 2.6.38-stable.

Does anyone still have libc5 binaries for i386?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
