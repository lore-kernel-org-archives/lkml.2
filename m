Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3ACId2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 03:33:28 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:46956 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACIdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 03:33:25 -0500
Date: Thu, 3 Jan 2013 09:33:22 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Jerome Glisse <j.glisse@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Borislav Petkov <bp@alien8.de>, Shuah Khan <shuahkhan@gmail.com>,
        Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20130103083322.GA230@x4>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.01.02 at 18:37 -0500, Alex Deucher wrote:
> On Wed, Jan 2, 2013 at 5:38 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On 2013.01.02 at 17:31 -0500, Jerome Glisse wrote:
> >> Please affected people can you test if patch :
> >> http://people.freedesktop.org/~glisse/0003-drm-radeon-fix-dma-copy-on-r6xx-r7xx-evergen-ni-si-g.patch
> >>
> >> Fix the issue, you need to make sure you don't have the patch that
> >> disable dma on r6xx ie that line 977-978 & 1061-1062  in radeon_asic.c
> >> is :
> >>  .copy = &r600_copy_dma,
> >>  .copy_ring_index = R600_RING_TYPE_DMA_INDEX,
> >
> > It fixes the issue for me. Thanks.
> 
> The count is actually the count, not count - 1.  The real fix seems to
> be that r6xx requires 2 dw aligned transfers.  The attached patch
> fixes the issue for me.

Yes, this one also works for me. Thanks.

-- 
Markus
