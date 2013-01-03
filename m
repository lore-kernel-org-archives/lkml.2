Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3ACMBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:01:01 -0500
Received: from mail.pr.hu ([87.242.0.5]:44374 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab3ACMA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:00:58 -0500
X-Greylist: delayed 1412 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2013 07:00:58 EST
Message-ID: <50E56D66.9030807@pr.hu>
Date: Thu, 03 Jan 2013 12:37:10 +0100
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Borislav Petkov <bp@alien8.de>, Shuah Khan <shuahkhan@gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
References: <20121223113153.GA8918@liondog.tnic> <20121223115133.GA229@x4> <20121223122210.GA4460@liondog.tnic> <20121223133102.GA8153@liondog.tnic> <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com> <50E3907C.4040106@iki.fi> <20130102120248.GC6181@x1.alien8.de> <CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com> <50E4755E.7030209@iki.fi> <CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com> <20130102223807.GA242@x4> <CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
In-Reply-To: <CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.2 (/)
X-Scan-Signature: 179ef3736e309226eac6e039e192467d
X-Spam-Tracer: backend.mail.pr.hu -0.2 20130103113602Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-01-03 00:37 keltezéssel, Alex Deucher írta:
> On Wed, Jan 2, 2013 at 5:38 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
>> On 2013.01.02 at 17:31 -0500, Jerome Glisse wrote:
>>> Please affected people can you test if patch :
>>> http://people.freedesktop.org/~glisse/0003-drm-radeon-fix-dma-copy-on-r6xx-r7xx-evergen-ni-si-g.patch
>>>
>>> Fix the issue, you need to make sure you don't have the patch that
>>> disable dma on r6xx ie that line 977-978 & 1061-1062  in radeon_asic.c
>>> is :
>>>   .copy = &r600_copy_dma,
>>>   .copy_ring_index = R600_RING_TYPE_DMA_INDEX,
>> It fixes the issue for me. Thanks.
> The count is actually the count, not count - 1.  The real fix seems to
> be that r6xx requires 2 dw aligned transfers.  The attached patch
> fixes the issue for me.
>
> Alex

I tried this patch over kernel 3.8.0-rc2 but the GDM screen is mostly garbage.
Only some text, like "Not on the list?" below the users and small icons are visible
but many user names are not rendered. http://tinypic.com/r/33xihit/6
I am on Fedora 18/x86_64, Radeon HD6570.

Best regards,
Zoltán Böszörményi

