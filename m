Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3ACPJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:09:41 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:36758 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3ACPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:09:38 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAMVG2svQkEZtz_kod-ifp1y=pwOPa4ZyRnsayf=oyzHzyRsotw@mail.gmail.com>
References: <CA+icZUVEBEerN=YRSS8Rx-2Xvx4byFuBDbVcE45qq4QZ67+Q-A@mail.gmail.com>
	<CAMVG2svQkEZtz_kod-ifp1y=pwOPa4ZyRnsayf=oyzHzyRsotw@mail.gmail.com>
Date: Thu, 3 Jan 2013 16:09:37 +0100
Message-ID: <CA+icZUW-qfVusVOtTA1U2mi0rwk6yOeE+z_kpbSRfN5jZNtd+Q@mail.gmail.com>
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 3:39 PM, Daniel J Blueman <daniel@quora.org> wrote:
> On 3 January 2013 22:11, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> Hi Daniel,
>>
>> just wanted to test the fb-fix [2] from Alan and followed the thread in [1].
>> Me is also working with i915 KMS.
>>
>> I looked at nouveau KMS driver and adapted the part for i915:
>>
>> drivers/gpu/drm/nouveau/nouveau_drm.c-200-      /* remove conflicting
>> drivers (vesafb, efifb etc) */
>> drivers/gpu/drm/nouveau/nouveau_drm.c:201:      aper = alloc_apertures(3);
>> drivers/gpu/drm/nouveau/nouveau_drm.c-202-      if (!aper)
>> drivers/gpu/drm/nouveau/nouveau_drm.c-203-              return -ENOMEM;
>>
>> Untested by me, feel free to test.
>>
>> Maybe some of the i915 and/or fb driver experts can comment on the problem.
>
> The structure array from alloc_apertures is just used for the PCI base
> address registers, so it's important here.
>
> I'll take a look at the efifb locking later.
>

That is the code part [1] I looked at.
Maybe the next lines with ap(er)->ranges || pci_resource_start() and
pci_resource_len() are missing?

I also looked at "include/linux/fb.h" but could not get wiser.
Also I can't say what the value "1" or "3" means in alloc_apertures().

Wouldn't it make sense to remove the conflicting fb-drivers globally
not in each affected DRM/KMS driver?
Just an idea.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/gpu/drm/nouveau/nouveau_drm.c;hb=refs/tags/v3.8-rc2#l192

> Thanks,
>   Daniel
> --
> Daniel J Blueman
