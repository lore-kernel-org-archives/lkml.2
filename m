Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab1EYPUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:20:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38694 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab1EYPUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ggz+mf15LNu1Qsjf9+g1lyz6siMYDz6vhAVXFT+dN2QI2q7tWOwhiV4J4zs9a09DBm
         0aJLujvnA7v6qg4qkhHSea2/KeQfdJqCqkSCB3ftFBVwBFoaDH0JACNAXCsaN1Deis9v
         2SSAhCVJyQqekoRgs6MJdFxLcmBQjSdZwxkLg=
MIME-Version: 1.0
In-Reply-To: <1306334551.2298.89.camel@Joe-Laptop>
References: <1306334551.2298.89.camel@Joe-Laptop>
Date: Wed, 25 May 2011 17:20:08 +0200
X-Google-Sender-Auth: pvScTW3U_lPNSV_ol3xigkrMTpM
Message-ID: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
Subject: Re: [PATCH 1/4] include/linux/printk.h is not self-contained
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 16:42, Joe Perches <joe@perches.com> wrote:
> On Wed, 2011-05-25 at 11:09 +0200, y@mail.of.borg wrote:

Sorry, that email address is a relic from typing one too many "y" responses
to git-send-email questions.

>> From: Geert Uytterhoeven <geert@linux-m68k.org>
>> <linux/printk.h> needs to include
>>   - <stdarg.h> for "va_list",
>>   - <linux/linkage.h> for "asmlinkage",
>>   - <linux/types.h> for "bool".
>
> I wonder if printk should be self-contained.
>
> If so, this patch should also add:
>
> #include <linux/dynamic_debug.h>
> #include <linux/ratelimit.h>

Hmm, it does compile without those, as long as you don't use
dynamic debug or ratelimit.

> If not, maybe add:
>
> #ifndef _LINUX_KERNEL_H
> #error don't include <linux/printk.h> directly, use <linux/kernel.h>
> #endif

That's another possibility. We already have several users, though.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
