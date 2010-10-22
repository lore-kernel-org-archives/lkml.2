Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0JVRTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:19:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61482 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab0JVRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OPwkpMZJOIGi7rMa6WtPNw+OBUNGb0Dh0/roRqZ6U9xk2yYTx3txE161oUXkrXTjXm
         EmDuINSuN7tErT5Ppj9Dirp6754P9AgiUP9sS+WtuiB+4LEfXLjAAHvigzbrpcmbmWFX
         JKkcpjCwweI/QcqffhdzYmagWamta4gN0FHI0=
Message-ID: <4CC1C77C.1000700@pobox.com>
Date: Fri, 22 Oct 2010 13:18:52 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Nicolas Kaiser <nikai@nikai.net>, Antonino Daplas <adaplas@gmail.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rivafb: dubious assignment
References: <20101022133130.4cb2cb96@absol.kitzblitz> <AANLkTimAb_gjx7m6pKvYHL=SjB9DousdUJA2K9uyPt1F@mail.gmail.com>
In-Reply-To: <AANLkTimAb_gjx7m6pKvYHL=SjB9DousdUJA2K9uyPt1F@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 10:47 AM, Geert Uytterhoeven wrote:
> On Fri, Oct 22, 2010 at 13:31, Nicolas Kaiser<nikai@nikai.net>  wrote:
>> A duplicated assignment unconditionally changes max_gfsize to
>> GFIFO_SIZE.
>>
>> It looks to me like this might not be intended, or is it?
>>
>> Signed-off-by: Nicolas Kaiser<nikai@nikai.net>
>> ---
>>   drivers/video/riva/riva_hw.c |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/riva/riva_hw.c b/drivers/video/riva/riva_hw.c
>> index 78fdbf5..936abfa 100644
>> --- a/drivers/video/riva/riva_hw.c
>> +++ b/drivers/video/riva/riva_hw.c
>> @@ -263,7 +263,6 @@ static int nv3_iterate(nv3_fifo_info *res_info, nv3_sim_state * state, nv3_arb_i
>>      vmisses = 2;
>>      if (ainfo->gburst_size == 128) max_gfsize = GFIFO_SIZE_128;
>>      else  max_gfsize = GFIFO_SIZE;
>> -    max_gfsize = GFIFO_SIZE;
>>      while (1)
>>      {
>>          if (ainfo->vid_en)
>> --
>> 1.7.2.2
>
> According to full-history-linux, this comes from the initial drop in 2.3.49pre2,
> from nVidia code(?), imported by Jeff Garzik.

Yep, came straight from X.org driver code...   Patch certainly looks 
correct, but who knows but NV for sure :)


