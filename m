Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2CUPOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:14:49 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47182 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2CUPOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:14:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120321151357.53fb86e4@endymion.delvare>
References: <1332328201-21191-1-git-send-email-amit.kachhap@linaro.org>
	<20120321151357.53fb86e4@endymion.delvare>
Date: Wed, 21 Mar 2012 16:14:46 +0100
X-Google-Sender-Auth: rLafDXpDDt2qb5P9BFU7CTpmxUY
Message-ID: <CAMuHMdUFh=kRJFGP3sxHCqERSVcrWGD40iYzhrFMRxDNFvounA@mail.gmail.com>
Subject: Re: [PATCH] thermal: Fix for setting the thermal zone mode to enable/disable
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 15:13, Jean Delvare <khali@linux-fr.org> wrote:
> On Wed, 21 Mar 2012 16:40:01 +0530, Amit Daniel Kachhap wrote:
>> Basically without this patch changing the mode of thermal zone
>> is not possible as wrong string size is passed to strncmp.
>
> Actually it is possible,
> $ echo -n disabled > mode
> works fine. But it fails without the -n, your patch would fix that.

Now it ignores any extra characters. Are they always newlines?

Now "echo -n disabledx > mode" will also "succeed".

> Acked-by: Jean Delvare <khali@linux-fr.org>
>
> Note that a quick grep suggests that drivers/misc/ad525x_dpot.c,
> security/selinux/hooks.c and arch/m68k/sun3/prom/console.c suffer from
> the same issue, if you want to fix them too.

W.r.t. the Sun-3 code, those strings don't come from the user, but from the
firmware. But the code (copied from SPARC, which has the right firmware,
unlike Sun-3) is commented out anyway.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
