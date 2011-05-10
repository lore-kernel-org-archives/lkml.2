Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1EJK5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:57:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41213 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1EJK5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:57:21 -0400
MIME-Version: 1.0
Reply-To: devos@fedoraproject.org
In-Reply-To: <BANLkTinEJZ=fvJmWRkQ7kKyxbFRaJnum7g@mail.gmail.com>
References: <1305019249-9898-1-git-send-email-ndevos@redhat.com>
	<BANLkTinEJZ=fvJmWRkQ7kKyxbFRaJnum7g@mail.gmail.com>
Date: Tue, 10 May 2011 11:57:18 +0100
X-Google-Sender-Auth: w26OzdzgfAgchy0QVpibZT4J8IA
Message-ID: <BANLkTim0Wao+dX-+GpKxdsHtg96DF1bHyw@mail.gmail.com>
Subject: Re: [PATCH] omap2/omapfb: make DBG() more resistant in if-else constructions
From: Niels de Vos <ndevos@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Premi, Sanjeev" <premi@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 10:42 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, May 10, 2011 at 11:20, Niels de Vos <ndevos@redhat.com> wrote:
>> When DBG() is used in a simple if-else, the resulting code path
>> currently depends on the definition of DBG(). Inserting the statement in
>> a "do { ... } while (0)" prevents this possible misuse.
>>
>> Signed-off-by: Niels de Vos <ndevos@redhat.com>
>
>> --- a/drivers/video/omap2/omapfb/omapfb.h
>> +++ b/drivers/video/omap2/omapfb/omapfb.h
>> @@ -34,8 +34,10 @@
>>  #ifdef DEBUG
>>  extern unsigned int omapfb_debug;
>>  #define DBG(format, ...) \
>> -       if (omapfb_debug) \
>> -               printk(KERN_DEBUG "OMAPFB: " format, ## __VA_ARGS__)
>> +       do { \
>> +               if (omapfb_debug) \
>> +                       printk(KERN_DEBUG "OMAPFB: " format, ## __VA_ARGS__); \
>> +       while (0)
>
> Where's the closing '}'?

Good catch! That's in a "fixup!" that I forgot to squash :-/
I'll post an update version in a bit.


>>  #else
>>  #define DBG(format, ...)
>
> BTW, no printf()-style format checking here.
>
>>  #endif
>
> What about using the standard pr_debug()/dev_dbg() instead?
> With dynamic debug, it can be enabled at run time.
> As a bonus, you get printf()-style format checking if debugging is disabled.

I think removing DBG() and the omapfb_debug module-parameter is surely
a good thing. Unfortunately DBG() is used quite a bit in the code and
replacing them 'll take some more time. I don't know yet when I find
some time to do and test that.

Thanks for the pointers,
Niels


> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
