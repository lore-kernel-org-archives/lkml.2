Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2ITV65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:58:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:54168 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755036Ab2ITV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:58:55 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19adJkc4GdaUNzy5JDJp7gxQSDtXyM3LdUpqEbr5i
	FmMc1IjJ6oMIgB
Message-ID: <505B9196.3040203@gmx.de>
Date: Thu, 20 Sep 2012 21:58:46 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Damien Cassou <damien.cassou@lifl.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/video/gbefb.c: use devm_ functions
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>	<1343752762-16861-3-git-send-email-damien.cassou@lifl.fr>	<50369498.4010006@gmx.de> <CAMuHMdWsiXmt=2uo3C8ZC_apnHRV2aHi3yZrYV_jgwB22=3Mfw@mail.gmail.com>
In-Reply-To: <CAMuHMdWsiXmt=2uo3C8ZC_apnHRV2aHi3yZrYV_jgwB22=3Mfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 09/13/2012 07:06 PM, Geert Uytterhoeven wrote:
> On Thu, Aug 23, 2012 at 10:37 PM, Florian Tobias Schandinat
> <FlorianSchandinat@gmx.de> wrote:
>> On 07/31/2012 04:39 PM, Damien Cassou wrote:
>>> From: Damien Cassou <damien.cassou@lifl.fr>
>>>
>>> The various devm_ functions allocate memory that is released when a driver
>>> detaches.  This patch uses these functions for data that is allocated in
>>> the probe function of a platform device and is only freed in the remove
>>> function.
>>>
>>> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>
>>
>> Applied.
> 
>>> diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
>>> index 7e7b7a9..9b79d38 100644
>>> --- a/drivers/video/gbefb.c
>>> +++ b/drivers/video/gbefb.c
>>> @@ -1156,7 +1156,8 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
>>>               goto out_release_framebuffer;
>>>       }
>>>
>>> -     gbe = (struct sgi_gbe *) ioremap(GBE_BASE, sizeof(struct sgi_gbe));
>>> +     gbe = (struct sgi_gbe *) devm_ioremap(&p_dev->dev, GBE_BASE,
>>> +                                           sizeof(struct sgi_gbe));
> 
> drivers/video/gbefb.c:1159:16: error: implicit declaration of function
> 'devm_ioremap' [-Werror=implicit-function-declaration]
> drivers/video/gbefb.c:1179:3: error: implicit declaration of function
> 'devm_ioremap_nocache' [-Werror=implicit-function-declaration]

Thanks for pointing this out. I guess the solution is to replace the
include asm/io.h by linux/io.h as Axel Lin did for some other driver in
this patch series.

@Damien:
Can you please do a patch as I suggested and preferable also recheck the
other drivers you touched?
And it probably would have been a good idea to mention that you didn't
compile-test it. I do some compile tests before pushing my branch but
that is far from complete due to arch and platform specific drivers.


Best regards,

Florian Tobias Schandinat

> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/7187731/
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

