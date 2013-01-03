Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3ACOMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:12:25 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53673 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab3ACOMW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:12:22 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 16
X-BigFish: VPS16(zz98dI9371Ic89bh936eI542I1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dh177df4h17326ah61b35ih44a89mz2dh668h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h1155h)
X-WSS-ID: 0MG1ZGF-01-9GL-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Boszormenyi Zoltan <zboszor@pr.hu>, Alex Deucher <alexdeucher@gmail.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Borislav Petkov <bp@alien8.de>, Shuah Khan <shuahkhan@gmail.com>
Subject: RE: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Thread-Topic: radeon 0000:02:00.0: GPU lockup CP stall for more than
 10000msec
Thread-Index: AQHN4IP03Wy26qsx9kidcpbJk0FueJgl5OCAgAAGmICAAATLAIAAq1MAgAABuICAAAGlAIAAAzcAgAADmYCAAAV/gIAACJAAgAATOwCAApMkgIAMXioAgACtXACAAFiWAIAACugAgABMIYCAAAHigIAAEI+AgADJGwD//8WhcA==
Date: Thu, 3 Jan 2013 14:12:15 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DC2C2FF@sausexdag04.amd.com>
References: <20121223113153.GA8918@liondog.tnic> <20121223115133.GA229@x4>
 <20121223122210.GA4460@liondog.tnic> <20121223133102.GA8153@liondog.tnic>
 <CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
 <50E3907C.4040106@iki.fi> <20130102120248.GC6181@x1.alien8.de>
 <CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com>
 <50E4755E.7030209@iki.fi>
 <CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com>
 <20130102223807.GA242@x4>
 <CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
 <50E56D66.9030807@pr.hu>
In-Reply-To: <50E56D66.9030807@pr.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.10.174]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Boszormenyi Zoltan [mailto:zboszor@pr.hu]
> Sent: Thursday, January 03, 2013 6:37 AM
> To: Alex Deucher
> Cc: Markus Trippelsdorf; lkml; dri-devel@lists.freedesktop.org; Deucher,
> Alexander; Borislav Petkov; Shuah Khan
> Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than
> 10000msec
> 
> 2013-01-03 00:37 keltezéssel, Alex Deucher írta:
> > On Wed, Jan 2, 2013 at 5:38 PM, Markus Trippelsdorf
> > <markus@trippelsdorf.de> wrote:
> >> On 2013.01.02 at 17:31 -0500, Jerome Glisse wrote:
> >>> Please affected people can you test if patch :
> >>> http://people.freedesktop.org/~glisse/0003-drm-radeon-fix-dma-copy-
> on-r6xx-r7xx-evergen-ni-si-g.patch
> >>>
> >>> Fix the issue, you need to make sure you don't have the patch that
> >>> disable dma on r6xx ie that line 977-978 & 1061-1062  in radeon_asic.c
> >>> is :
> >>>   .copy = &r600_copy_dma,
> >>>   .copy_ring_index = R600_RING_TYPE_DMA_INDEX,
> >> It fixes the issue for me. Thanks.
> > The count is actually the count, not count - 1.  The real fix seems to
> > be that r6xx requires 2 dw aligned transfers.  The attached patch
> > fixes the issue for me.
> >
> > Alex
> 
> I tried this patch over kernel 3.8.0-rc2 but the GDM screen is mostly garbage.
> Only some text, like "Not on the list?" below the users and small icons are
> visible
> but many user names are not rendered. http://tinypic.com/r/33xihit/6
> I am on Fedora 18/x86_64, Radeon HD6570.

I don't think the issue you are seeing is related to this one.  Looks similar to:
https://bugs.freedesktop.org/show_bug.cgi?id=55574

Alex


