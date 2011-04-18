Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab1DRU1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:27:09 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55800 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1DRU1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=MkQtdwPwYCG303CBqMB6k50rVe2Umss7xaqC1yNnNxfk6Lzk3e+FT7tKg67DMAmEg7
         ruluG7N7HhhhYmRaRSswZqbIBPoqxRhE6mU0lL5ojSODqqZkq087nUKih+ApBKCjoXZZ
         ndg7fq9Anj8Y2jMvmr0H0+EOsMQixQSqxAseU=
MIME-Version: 1.0
In-Reply-To: <1303157094-11425-1-git-send-email-mjg@redhat.com>
References: <1303157094-11425-1-git-send-email-mjg@redhat.com>
From: Matt Turner <mattst88@gmail.com>
Date: Mon, 18 Apr 2011 16:26:45 -0400
Message-ID: <BANLkTinEgisHUqg8JxukunMLA-SuEmc=ZQ@mail.gmail.com>
Subject: Re: [PATCH] drm: Add a driver for kvm emulated Cirrus
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 4:04 PM, Matthew Garrett <mjg@redhat.com> wrote:
> qemu-kvm emulates a Cirrus GPU, including its acceleration engine. We
> typically then run a Cirrus-specific X driver on top of this, which
> turns requests into commands and sends them to the emulated accelerator.
> This all seems to be unnecessary overhead given that we're just going
> to end up writing to memory from the host instead, and performance is
> almost certainly going to be better using an unaccelerated framebuffer
> and a guest-side shadow.
>
> This patch provides a simple modesetting-only KMS driver for the hardware
> emulated in qemu-kvm. It's stripped down to the point where it's able to
> program the emulation, but would almost certainly fail miserably if asked
> to run on real hardware. It's intended to reduce virt overhead slightly,
> but also to serve as a template to writing a basic KMS driver.
>
> The code and structure are heavily derived from Matt Turner's glint
> driver, with the modesetting code cribbed from cirrusfb (hence the
> license).

Nice!

> +#define CIRRUS_DPMS_CLEARED (-1)

I wanted to add a DPMS_CLEARED to DRM, since it's duplicated in at
least Nouveau, glint, and now cirrusfb. I guess we should fix that at
some point.

The only other nit-pick I've got is that I named variables gfb and
gfbdev because I'm uncreative with variable names and because glint
started with a 'g'. Not important though.

Thanks, I'll have to give it a try. Please have a

Reviewed-by: Matt Turner <mattst88@gmail.com>

Matt
