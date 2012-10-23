Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2JWKrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:47:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46618 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab2JWKrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:47:51 -0400
MIME-Version: 1.0
In-Reply-To: <1907817.pMPUYlsyRc@avalon>
References: <1350908271-11448-1-git-send-email-prabhakar.lad@ti.com> <1907817.pMPUYlsyRc@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 23 Oct 2012 16:17:30 +0530
Message-ID: <CA+V-a8twTJggR9H5Ei4H16n9VOzgWnfBw4qhCnqdoc8cow1xuw@mail.gmail.com>
Subject: Re: [PATCH RESEND] media: davinci: vpbe: fix build warning
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Mon, Oct 22, 2012 at 5:53 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Monday 22 October 2012 17:47:51 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
>>
>> Warnings were generated because of the following commit changed data type
>> for address pointer
>>
>> 195bbca ARM: 7500/1: io: avoid writeback addressing modes for __raw_
>> accessors add  __iomem annotation to fix following warnings
>>
>> drivers/media/platform/davinci/vpbe_osd.c: In function ‘osd_read’:
>> drivers/media/platform/davinci/vpbe_osd.c:49:2: warning: passing
>>  argument 1 of ‘__raw_readl’ makes pointer from integer without a cast
>> [enabled by default] arch/arm/include/asm/io.h:104:19: note: expected
>> ‘const volatile
>>  void *’ but argument is of type ‘long unsigned int’
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
>> ---
>>   Resending the patch since, it didn't reach the DLOS mailing list.
>>
>>  drivers/media/platform/davinci/vpbe_osd.c |   16 ++++++++--------
>>  1 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpbe_osd.c
>> b/drivers/media/platform/davinci/vpbe_osd.c index bba299d..9ab9280 100644
>> --- a/drivers/media/platform/davinci/vpbe_osd.c
>> +++ b/drivers/media/platform/davinci/vpbe_osd.c
>> @@ -46,14 +46,14 @@ static inline u32 osd_read(struct osd_state *sd, u32
>> offset) {
>>       struct osd_state *osd = sd;
>>
>> -     return readl(osd->osd_base + offset);
>> +     return readl(IOMEM(osd->osd_base + offset));
>
> A better fix, in my opinion, would be to change the osd->osd_base field to be
> a void __iomem * instead of long unsigned int.
>
Ok I'll make it as void * and post a v2.

Regards,
--Prabhakar

>>  }
>>
>>  static inline u32 osd_write(struct osd_state *sd, u32 val, u32 offset)
>>  {
>>       struct osd_state *osd = sd;
>>
>> -     writel(val, osd->osd_base + offset);
>> +     writel(val, IOMEM(osd->osd_base + offset));
>>
>>       return val;
>>  }
>> @@ -63,9 +63,9 @@ static inline u32 osd_set(struct osd_state *sd, u32 mask,
>> u32 offset) struct osd_state *osd = sd;
>>
>>       u32 addr = osd->osd_base + offset;
>> -     u32 val = readl(addr) | mask;
>> +     u32 val = readl(IOMEM(addr)) | mask;
>>
>> -     writel(val, addr);
>> +     writel(val, IOMEM(addr));
>>
>>       return val;
>>  }
>> @@ -75,9 +75,9 @@ static inline u32 osd_clear(struct osd_state *sd, u32
>> mask, u32 offset) struct osd_state *osd = sd;
>>
>>       u32 addr = osd->osd_base + offset;
>> -     u32 val = readl(addr) & ~mask;
>> +     u32 val = readl(IOMEM(addr)) & ~mask;
>>
>> -     writel(val, addr);
>> +     writel(val, IOMEM(addr));
>>
>>       return val;
>>  }
>> @@ -88,9 +88,9 @@ static inline u32 osd_modify(struct osd_state *sd, u32
>> mask, u32 val, struct osd_state *osd = sd;
>>
>>       u32 addr = osd->osd_base + offset;
>> -     u32 new_val = (readl(addr) & ~mask) | (val & mask);
>> +     u32 new_val = (readl(IOMEM(addr)) & ~mask) | (val & mask);
>>
>> -     writel(new_val, addr);
>> +     writel(new_val, IOMEM(addr));
>>
>>       return new_val;
>>  }
> --
> Regards,
>
> Laurent Pinchart
>
