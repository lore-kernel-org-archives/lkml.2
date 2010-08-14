Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab0HNVwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:52:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59135 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab0HNVwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k0W+TXx1Vw7OLnCEYaAMBAgU/4Y9vKqYCUSTN6XE06RbKQddO4e/sKHY8+0F+W3LUF
         n4SHi+hgcQAVQsJENmplD8u1E2PzmgqKvXSrtpVV9nUUxhWuNvDu9HzGfsTfgjb8TntG
         i3y/yE37M/d/EuO16TpVjghKAQOI3HoZgqwYA=
MIME-Version: 1.0
In-Reply-To: <20100812162218.GA21286@core.coreip.homeip.net>
References: <20100812162218.GA21286@core.coreip.homeip.net>
Date: Sat, 14 Aug 2010 23:52:13 +0200
X-Google-Sender-Auth: 2fOzNe9JP97CF6aKTDP8CjMV154
Message-ID: <AANLkTikj2kqifwYo1c47+9knVejny1bR=Oe5yOkAchCk@mail.gmail.com>
Subject: Re: [PATCH] Input: fix faulty XXinput_* calls
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Mack <daniel@caiaq.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 18:22, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> From: Daniel Mack <daniel@caiaq.de>
>
> They've been introduced by 987a6c02 ("Input: switch to input_abs_*()
> access functions") and they appear to be some kind of debug left-over.
>
> [Dmitry Torokhov: these are my fault - I added XX prefixes in places where
>  I wanted to do additional review of the code but failed to actually do
>  that in these particular instances.]
>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
>  drivers/input/joystick/amijoy.c  |    2 +-

Thanks, amijoy.c compiles now.

But hil_kbd.c still doesn't compile:

> diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
> index ddd5afd..dcc86b9 100644
> --- a/drivers/input/keyboard/hil_kbd.c
> +++ b/drivers/input/keyboard/hil_kbd.c
> @@ -235,7 +235,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
>                        if (val < input_abs_min(dev, ABS_X + i))
>                                input_abs_set_min(dev, ABS_X + i, val);
>                        if (val > input_abs_max(dev, ABS_X + i))

error: implicit declaration of function ‘input_abs_max’.

And indeed, input_abs_max() does not exist, while hil_kbd.c has 4 callers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
