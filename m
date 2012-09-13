Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2IMTGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 15:06:38 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64745 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2IMTGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 15:06:36 -0400
MIME-Version: 1.0
In-Reply-To: <50369498.4010006@gmx.de>
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
	<1343752762-16861-3-git-send-email-damien.cassou@lifl.fr>
	<50369498.4010006@gmx.de>
Date: Thu, 13 Sep 2012 21:06:35 +0200
X-Google-Sender-Auth: E8w8L1q_kpgKaPanIC2CEQbIqUc
Message-ID: <CAMuHMdWsiXmt=2uo3C8ZC_apnHRV2aHi3yZrYV_jgwB22=3Mfw@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivers/video/gbefb.c: use devm_ functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Damien Cassou <damien.cassou@lifl.fr>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 10:37 PM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> On 07/31/2012 04:39 PM, Damien Cassou wrote:
>> From: Damien Cassou <damien.cassou@lifl.fr>
>>
>> The various devm_ functions allocate memory that is released when a driver
>> detaches.  This patch uses these functions for data that is allocated in
>> the probe function of a platform device and is only freed in the remove
>> function.
>>
>> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>
>
> Applied.

>> diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
>> index 7e7b7a9..9b79d38 100644
>> --- a/drivers/video/gbefb.c
>> +++ b/drivers/video/gbefb.c
>> @@ -1156,7 +1156,8 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
>>               goto out_release_framebuffer;
>>       }
>>
>> -     gbe = (struct sgi_gbe *) ioremap(GBE_BASE, sizeof(struct sgi_gbe));
>> +     gbe = (struct sgi_gbe *) devm_ioremap(&p_dev->dev, GBE_BASE,
>> +                                           sizeof(struct sgi_gbe));

drivers/video/gbefb.c:1159:16: error: implicit declaration of function
'devm_ioremap' [-Werror=implicit-function-declaration]
drivers/video/gbefb.c:1179:3: error: implicit declaration of function
'devm_ioremap_nocache' [-Werror=implicit-function-declaration]

http://kisskb.ellerman.id.au/kisskb/buildresult/7187731/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
