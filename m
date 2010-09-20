Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0ITI1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:27:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56351 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab0ITI1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C/3uk75xcE5fuBtwEm32OROuRy2QXaPcwbuh9i1Po0kBdsjhvDxpItHqVkdFSyQYSo
         IXcf3OO5860syBTF7kEWVzk3FmNSRVdgc2uZ5ZQ5b40VF+6PoI9xl0CWj6kjW9UxEe2+
         0GQh7ZVmm8yRg1XRktd/XiDULS3BJuxCtqCHE=
MIME-Version: 1.0
In-Reply-To: <4C963E99.9080207@gmx.de>
References: <20100919172833.14bf291e@neptune.home>
	<4C963E99.9080207@gmx.de>
Date: Mon, 20 Sep 2010 10:27:37 +0200
X-Google-Sender-Auth: C5OkeTUv7_unKPBcGUwN4t9wADY
Message-ID: <AANLkTimH4HmxH=gcX7-=t64pHttQjrhm9XkxnnpQYR1S@mail.gmail.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 18:47, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> Bruno Prémont schrieb:
>> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
>> index 0a08f13..be5f342 100644
>> --- a/drivers/video/fbsysfs.c
>> +++ b/drivers/video/fbsysfs.c
>> @@ -58,6 +58,7 @@ struct fb_info *framebuffer_alloc(size_t size, struct
>> device *dev)
>>                info->par = p + fb_info_size;
>>        info->device = dev;
>> +       kref_init(&info->refcount);
>
> As far as I know there exist framebuffer drivers which do not call
> framebuffer_alloc but contain their own fb_info. I guess these would be
> broken as well.

Those should be converted to framebuffer_alloc() anyway. Janitors?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
