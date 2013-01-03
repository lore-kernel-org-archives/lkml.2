Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3ACPgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 10:36:10 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44729 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3ACPgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 10:36:09 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVEBEerN=YRSS8Rx-2Xvx4byFuBDbVcE45qq4QZ67+Q-A@mail.gmail.com>
References: <CA+icZUVEBEerN=YRSS8Rx-2Xvx4byFuBDbVcE45qq4QZ67+Q-A@mail.gmail.com>
Date: Thu, 3 Jan 2013 16:36:08 +0100
Message-ID: <CA+icZUUepiyko99f8PSSZm=kPKSe3cqChXeec55BszTVCmDAmw@mail.gmail.com>
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel J Blueman <daniel@quora.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-fbdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 3, 2013 at 3:11 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
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
>

That is the i915 part [---> i915_kick_out_firmware_fb()] where I looked at [1].

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/gpu/drm/i915/i915_dma.c;hb=refs/tags/v3.8-rc2#l1393

> Regards,
> - Sedat -
>
> [1] http://marc.info/?t=135721787600001&r=1&w=2
> [2] https://patchwork.kernel.org/patch/1757061/
