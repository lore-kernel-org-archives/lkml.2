Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2ICNtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:49:55 -0400
Received: from bosmailout05.eigbox.net ([66.96.190.5]:56174 "EHLO
	bosmailout05.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab2ICNtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:49:22 -0400
X-Greylist: delayed 2533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2012 09:49:22 EDT
X-Authority-Analysis: v=2.0 cv=KtT6LxqN c=1 sm=1
 a=kVl5ZQvD7FSRn1NYLyvcVQ==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=BeqPfl1cZ3UA:10 a=8nJEP1OIZ-IA:10 a=DpD6vjqgePMA:10 a=imTROTZUkysA:10
 a=SWp5yrndY2wA:10 a=6211v-_6zocA:10 a=Abkf3k7uQ9YA:10 a=1U9TzpqtFrQA:10
 a=ohnJ7w5aPpoA:10 a=kavQi50aEgwA:10 a=rdiWsZQgeBwA:10 a=D-xm97IzuG4A:10
 a=NVKt8WYRSasA:10 a=rLeoDPuMdhoA:10 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19
 a=pGLkceISAAAA:8 a=KKAkSRfTAAAA:8 a=NhBR5AZoqENsnboNEDEA:9 a=wPNLvfGTeEIA:10
 a=MSl-tDqOz04A:10 a=WwgC8nHKvroA:10 a=jcMFiYeD4Gz02xRQ37rMPA==:117
X-EN-OrigOutIP: 10.20.18.4
X-EN-IMPSID: ud761j00F05GATN01d76cs
Message-ID: <5044AB51.3040106@yahoo.es>
Date: Mon, 03 Sep 2012 21:06:25 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v4 2/3] dw_dmac: max_mem_width limits value for SRC/DST_TR_WID
 register
References: <50439D44.3080100@yahoo.es> <CAHp75VcQOeVeKPg8z9u+fd8ia4QAyrq6UQn-D7Q-yO9+pLS6LQ@mail.gmail.com> <CAKohpo=bvzm1O4FAtsr3YpLg-w1Rp7RT-9ZuJBgVZRxVHnQO_g@mail.gmail.com> <CAHp75VcpzomoWb3+xOk=++BkUh5_cuXQTu8ZuDByjfX+pYmNCA@mail.gmail.com> <CAKohpomFDuTFVJ8SCmhRmPbCXMWdhD1Acjs5CAZD4aeqLZnurA@mail.gmail.com>
In-Reply-To: <CAKohpomFDuTFVJ8SCmhRmPbCXMWdhD1Acjs5CAZD4aeqLZnurA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.61.152
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/2012 4:59 PM, Viresh Kumar wrote:
> On 3 September 2012 14:19, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>> On Mon, Sep 3, 2012 at 11:30 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> Which register are you talking about? This configuration is outside of DMAC
>>> controller and i am not sure if dw DMAC controller can do 128 or 256
>>> bit transfers.
>> SRC_WIDTH & DST_WIDTH in CTLx. The field are 3 bit long. Acceptable
>> values from 0 to 5.
>> 2 corresponds to 32 bit transfers.
> The field is 3 bit long but only allowable values are 0,1,2 & 3... This is what
> i can check in my copy of dw_dmac manual.
>
> 4 and 5 aren't valid values.

About today's remarks about the patch series:

1. The first draft of the patches worked with the max allowable value for
the SRC_WIDTH & DST_WIDTH fields: 0,1,2,3... Viresh thought it was not
transparent enough, he suggested to make it simpler with a binary choice of
32- or 64-bits, defaulting to 64-bits.
But Andy is right: there are versions supporting 256-bit wide memory transfers.
I'd also go for this previous solution and use: "min(max_mem_width, width)"

The only problem is that one doesn't want to change arch code for other
platforms (ARM) so I proposed: let "max_mem_width=0" mean: leave it up to
the driver, for now 3 : 64-bits.

2. In another version I made 'max_mem_width' a member of 'dw_dma_platform_data'
because I also see it as 'constant' for all dma slaves.
But the dw_dmac controller can be used for multiple (types of) memories
and in that case, maybe a limit per slave might be desirable? My knowledge
of DMA-hardware doesn't reach far enough to judge that.

I'd say: for now let it become a member of 'dw_dma_platform_data' because
it's the max value of a register field.

3. Felipe Balbi: why don't we ask the DW IP for its maximum allowed value of
SRC_WIDTH & DST_WIDTH (on the memory side)? Sure, would be elegant!
I contacted Synopsys this week but as my company doesn't have a contract
with them, they won't share any secrets. And before sharing secrets, I'd need
to sign a non-disclosure contract with them...
I was particularly interested in the register called 'DMA ID Register' at
offset 0x3a8, which has no description in the Atmel sheets.

Alternatively, we could do a small dma-memcpy-test at start-up and try all
values from 5 (or 7) down to 2. The first value that works correctly will be
used as the maximum.
But that'll take some CPU time, because with invalid settings the memcpy
will timeout. I wouldn't mind to try this to see if it is a solution.


Hein
