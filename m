Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3ACOjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:39:36 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62110 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3ACOje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:39:34 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.69.232]
In-Reply-To: <CA+icZUVEBEerN=YRSS8Rx-2Xvx4byFuBDbVcE45qq4QZ67+Q-A@mail.gmail.com>
References: <CA+icZUVEBEerN=YRSS8Rx-2Xvx4byFuBDbVcE45qq4QZ67+Q-A@mail.gmail.com>
Date: Thu, 3 Jan 2013 22:39:33 +0800
Message-ID: <CAMVG2svQkEZtz_kod-ifp1y=pwOPa4ZyRnsayf=oyzHzyRsotw@mail.gmail.com>
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
From: Daniel J Blueman <daniel@quora.org>
To: sedat.dilek@gmail.com
Cc: alan@lxorguk.ukuu.org.uk, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 January 2013 22:11, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Hi Daniel,
>
> just wanted to test the fb-fix [2] from Alan and followed the thread in [1].
> Me is also working with i915 KMS.
>
> I looked at nouveau KMS driver and adapted the part for i915:
>
> drivers/gpu/drm/nouveau/nouveau_drm.c-200-      /* remove conflicting
> drivers (vesafb, efifb etc) */
> drivers/gpu/drm/nouveau/nouveau_drm.c:201:      aper = alloc_apertures(3);
> drivers/gpu/drm/nouveau/nouveau_drm.c-202-      if (!aper)
> drivers/gpu/drm/nouveau/nouveau_drm.c-203-              return -ENOMEM;
>
> Untested by me, feel free to test.
>
> Maybe some of the i915 and/or fb driver experts can comment on the problem.

The structure array from alloc_apertures is just used for the PCI base
address registers, so it's important here.

I'll take a look at the efifb locking later.

Thanks,
  Daniel
-- 
Daniel J Blueman
