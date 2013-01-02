Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3ABX6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:58:14 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:57858 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3ABX6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:58:11 -0500
MIME-Version: 1.0
In-Reply-To: <CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
References: <20121223113153.GA8918@liondog.tnic>
	<20121223115133.GA229@x4>
	<20121223122210.GA4460@liondog.tnic>
	<20121223133102.GA8153@liondog.tnic>
	<CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
	<50E3907C.4040106@iki.fi>
	<20130102120248.GC6181@x1.alien8.de>
	<CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com>
	<50E4755E.7030209@iki.fi>
	<CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com>
	<20130102223807.GA242@x4>
	<CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
Date: Wed, 2 Jan 2013 16:58:10 -0700
Message-ID: <CAKocOOMx4nLFXfbE95WxsJ7j3mFf_GPWxcmMxqHbMh8tBgULWw@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Shuah Khan <shuahkhan@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jerome Glisse <j.glisse@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Borislav Petkov <bp@alien8.de>, Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 4:37 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Wed, Jan 2, 2013 at 5:38 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
>> On 2013.01.02 at 17:31 -0500, Jerome Glisse wrote:
>>> Please affected people can you test if patch :
>>> http://people.freedesktop.org/~glisse/0003-drm-radeon-fix-dma-copy-on-r6xx-r7xx-evergen-ni-si-g.patch
>>>
>>> Fix the issue, you need to make sure you don't have the patch that
>>> disable dma on r6xx ie that line 977-978 & 1061-1062  in radeon_asic.c
>>> is :
>>>  .copy = &r600_copy_dma,
>>>  .copy_ring_index = R600_RING_TYPE_DMA_INDEX,
>>
>> It fixes the issue for me. Thanks.
>
> The count is actually the count, not count - 1.  The real fix seems to
> be that r6xx requires 2 dw aligned transfers.  The attached patch
> fixes the issue for me.
>

Catching up with this thread. I reverted the

drm/radeon: use async dma for ttm buffer moves on 6xx-SI
commit id: 2d6cc7296d4ee128ab0fa3b715f0afde511f49c2

Do I need to apply this patch without reverting
2d6cc7296d4ee128ab0fa3b715f0afde511f49c2?

Thanks,
-- Shuah
