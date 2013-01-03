Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab3ACBET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:04:19 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:49533 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab3ACBER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:04:17 -0500
Message-ID: <50E4D8E2.8010107@iki.fi>
Date: Thu, 03 Jan 2013 03:03:30 +0200
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: Shuah Khan <shuahkhan@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jerome Glisse <j.glisse@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
References: <20121223113153.GA8918@liondog.tnic> <20121223115133.GA229@x4> <20121223122210.GA4460@liondog.tnic> <20121223133102.GA8153@liondog.tnic> <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com> <50E3907C.4040106@iki.fi> <20130102120248.GC6181@x1.alien8.de> <CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com> <50E4755E.7030209@iki.fi> <CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com> <20130102223807.GA242@x4> <CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com> <CAKocOOMx4nLFXfbE95WxsJ7j3mFf_GPWxcmMxqHbMh8tBgULWw@mail.gmail.com> <CADnq5_OBpEogK2FCof16NoZts9ieDQYJdTJjqZptkL2K4GaZ_A@mail.gmail.com>
In-Reply-To: <CADnq5_OBpEogK2FCof16NoZts9ieDQYJdTJjqZptkL2K4GaZ_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.184.254
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 01:59 AM, Alex Deucher wrote:
> On Wed, Jan 2, 2013 at 6:58 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
>> On Wed, Jan 2, 2013 at 4:37 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>> On Wed, Jan 2, 2013 at 5:38 PM, Markus Trippelsdorf
>>> <markus@trippelsdorf.de> wrote:
>>>> On 2013.01.02 at 17:31 -0500, Jerome Glisse wrote:
>>>>> Please affected people can you test if patch :
>>>>> http://people.freedesktop.org/~glisse/0003-drm-radeon-fix-dma-copy-on-r6xx-r7xx-evergen-ni-si-g.patch
>>>>>
>>>>> Fix the issue, you need to make sure you don't have the patch that
>>>>> disable dma on r6xx ie that line 977-978 & 1061-1062  in radeon_asic.c
>>>>> is :
>>>>>   .copy = &r600_copy_dma,
>>>>>   .copy_ring_index = R600_RING_TYPE_DMA_INDEX,
>>>>
>>>> It fixes the issue for me. Thanks.
>>>
>>> The count is actually the count, not count - 1.  The real fix seems to
>>> be that r6xx requires 2 dw aligned transfers.  The attached patch
>>> fixes the issue for me.
>>>
>>
>> Catching up with this thread. I reverted the
>>
>> drm/radeon: use async dma for ttm buffer moves on 6xx-SI
>> commit id: 2d6cc7296d4ee128ab0fa3b715f0afde511f49c2
>>
>> Do I need to apply this patch without reverting
>> 2d6cc7296d4ee128ab0fa3b715f0afde511f49c2?
>
> Correct.  Don't revert anything.  Just apply this patch.

Tested, it is working.

I didn't revert anything, just added that latest patch.

regards
Antti

-- 
http://palosaari.fi/
