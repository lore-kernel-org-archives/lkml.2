Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1F0WTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:19:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57924 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab1F0WSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lsECwtGN7ec0kjJevEqB2QihjYVsogBIS2Kjm25o/QYkpdKwakvmcAHpQ4dvh79I4y
         if9e6KiCG7aGBbhZ+3+XRIIrM+E6OOHMYVn1AomrxVFjiFbijj/PJG2Rv/XSQFcDRyfy
         EF1CgajLWqOaj951JN4CUTfyyROT2+nWqWRMc=
MIME-Version: 1.0
In-Reply-To: <yunhb7ckxtl.fsf@aiko.keithp.com>
References: <BANLkTikAJEma_NNi0NYnjBEB6RkFJK3Dpg@mail.gmail.com> <yunhb7ckxtl.fsf@aiko.keithp.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Mon, 27 Jun 2011 19:17:48 -0300
Message-ID: <BANLkTikhFyR9c6UfJX2oTdWq9crb9M73Ow@mail.gmail.com>
Subject: Re: i915, framebuffer: wrong xoffset?
To: Keith Packard <keithp@keithp.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

On Sun, Jun 26, 2011 at 19:55, Keith Packard <keithp@keithp.com> wrote:
> On Sat, 18 Jun 2011 13:29:47 -0300, Lucas De Marchi <lucas.de.marchi@gmail.com> wrote:
>
>> Since 3.0-rc1 when booting my computer the text in the fb console is
>> displayed with a wrong xoffset. I took a picture (sorry for the poor
>> quality):
>
> Can you capture register dumps in the working and broken configuration?
>
> git clone git://anongit.freedesktop.org/git/xorg/app/intel-gpu-tools
>
> Build that and run tools/intel_reg_dumper and send along the output of
> that in working and non-working configurations. That should show us
> where the problem lies.

I've just build a new kernel and noticed it's fixed in current Linux
tree. Since -rc4 still had this bug, it was very quick to bisect this,
and the fix was this commit:


commit efc2924e733631a64c0afed8dbba2741d186998c
Author: Keith Packard <keithp@keithp.com>
Date:   Mon Jun 6 17:12:49 2011 -0700

    drm/i915: Call intel_enable_plane from i9xx_crtc_mode_set (again)

    This change got placed in the ironlake path instead of the 9xx path
    during a recent code shuffle.

    Signed-off-by: Keith Packard <keithp@keithp.com>



Does it make sense? Do you still want the register dumps or they
aren't needed anymore?


Lucas De Marchi
