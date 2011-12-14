Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab1LNKQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:16:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab1LNKQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:16:40 -0500
Message-ID: <4EE8777C.4090704@redhat.com>
Date: Wed, 14 Dec 2011 11:16:28 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Ajeet Yadav <ajeet.yadav.77@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: zram: print the disk size in KB
References: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com> <CAMuHMdV_eyMhWS6+CFc--i_KBcyb31u11tEO3OkDQsB4HbYpfA@mail.gmail.com>
In-Reply-To: <CAMuHMdV_eyMhWS6+CFc--i_KBcyb31u11tEO3OkDQsB4HbYpfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 08:52 AM, Geert Uytterhoeven wrote:
> On Tue, Dec 13, 2011 at 06:16, Ajeet Yadav <ajeet.yadav.77@gmail.com> wrote:
>> From a5d5ba92b5af9134e617986884856334c377e1d0 Mon Sep 17 00:00:00 2001
>> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
>> Date: Mon, 12 Dec 2011 18:42:30 +0530
>> Subject: [PATCH 1/1] Staging: zram: print the disk size in KB
>>
>> Total memory size is in KB, but the zram disk size was not
>> printed in KB, correct the figure in KB units.
> 
> Kelvin bytes?
> 
>> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
>> ---
>>  drivers/staging/zram/zram_drv.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
>> index 09de99f..ff591e3 100644
>> --- a/drivers/staging/zram/zram_drv.c
>> +++ b/drivers/staging/zram/zram_drv.c
>> @@ -126,7 +126,7 @@ static void zram_set_disksize(struct zram *zram,
>> size_t totalram_bytes)
>>                "\tMemory Size: %zu kB\n"
> 
> kilobytes? Either this ...
> 
>>                "\tSize you selected: %llu kB\n"
> 
> ... and this should be KiB ...

I'm personally all for the international system of units, but there
are *a lot* of places in the kernel where the inaccurate kilo = 2^10
notation is used. I haven't checked, but I would guess that in kernel
kB stands more often for 1024 bytes than 1000 bytes.

Is there any coding rule about its usage?

Jerome

> 
>>                "Continuing anyway ...\n",
>> -               totalram_bytes >> 10, zram->disksize
>> +               totalram_bytes >> 10, zram->disksize >> 10
> 
> ... or these should be / 1000 instead of >> 10.
> 
>>                );
>>        }
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

