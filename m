Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3ADOGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:06:39 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:52383 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3ADOGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:06:36 -0500
MIME-Version: 1.0
In-Reply-To: <50E6BA0D.6030602@pr.hu>
References: <20121223122210.GA4460@liondog.tnic>
	<20121223133102.GA8153@liondog.tnic>
	<CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
	<50E3907C.4040106@iki.fi>
	<20130102120248.GC6181@x1.alien8.de>
	<CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com>
	<50E4755E.7030209@iki.fi>
	<CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com>
	<20130102223807.GA242@x4>
	<CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
	<20130104074054.GB20905@x1.alien8.de>
	<50E6BA0D.6030602@pr.hu>
Date: Fri, 4 Jan 2013 09:06:35 -0500
Message-ID: <CADnq5_Oh=2eTkdSEUZVGwZ3PNtR-PPnZNee89i3QuZWQQRANGg@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Alex Deucher <alexdeucher@gmail.com>
To: Boszormenyi Zoltan <zboszor@pr.hu>
Cc: Borislav Petkov <bp@alien8.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jerome Glisse <j.glisse@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Shuah Khan <shuahkhan@gmail.com>, Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 6:16 AM, Boszormenyi Zoltan <zboszor@pr.hu> wrote:
> 2013-01-04 08:40 keltezéssel, Borislav Petkov írta:
>
>> On Wed, Jan 02, 2013 at 06:37:23PM -0500, Alex Deucher wrote:
>>>
>>> From: Alex Deucher <alexander.deucher@amd.com>
>>> Date: Wed, 2 Jan 2013 18:30:21 -0500
>>> Subject: [PATCH] drm/radeon/r6xx: fix DMA engine for ttm bo transfers
>>>
>>> count must be a multiple of 2.
>>>
>>> Cc: Borislav Petkov <bp@alien8.de>
>>> Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
>>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>
>> Thanks, will run it on the box in question next week when I have access.
>>
>> Btw, you could add the note about count needing to be a multiple of 2 as
>> a comment in the code below, for future reference.
>>
>>> ---
>>>   drivers/gpu/drm/radeon/r600.c |    4 ++--
>>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/radeon/r600.c
>>> b/drivers/gpu/drm/radeon/r600.c
>>> index 2aaf147..9f4ce5e 100644
>>> --- a/drivers/gpu/drm/radeon/r600.c
>>> +++ b/drivers/gpu/drm/radeon/r600.c
>>> @@ -2636,8 +2636,8 @@ int r600_copy_dma(struct radeon_device *rdev,
>>>         for (i = 0; i < num_loops; i++) {
>>>                 cur_size_in_dw = size_in_dw;
>>> -               if (cur_size_in_dw > 0xFFFF)
>>> -                       cur_size_in_dw = 0xFFFF;
>>> +               if (cur_size_in_dw > 0xFFFE)
>>> +                       cur_size_in_dw = 0xFFFE;
>
>
> How about any other odd numbers? Like 0xFFFB, or 0x0003?
> They will get passed as is after this change, no? Shouldn't they
> be also fixed? Something like this below?
>
>               if (cur_size_in_dw & 0x0001)
>                    cur_size_in_dw &= ~1;


This function only deals with pages so they will always be even.

Alex
