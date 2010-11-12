Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab0KLJRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:17:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61093 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab0KLJRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LDeJ8j+JgBLm7mxI+KsAz9w8tqMZVePWdsgj7zm3NuXFs+KO1Iy9JOHGDkgSk9BxSH
         +lcUqyoHRpwz6uhsQuN48jQt7Nz+bo+25QmLFiTFcfEim+ySIoZSsSM0nAr6gwAyLaA/
         7O8KYFvhZqrE/rQZbdc6V5QqZnp1Grk9j00Hw=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=emVB3kqR322Man01sDd0DFecxzDENVCS6B1jj@mail.gmail.com>
References: <AANLkTi=emVB3kqR322Man01sDd0DFecxzDENVCS6B1jj@mail.gmail.com>
Date: Fri, 12 Nov 2010 10:17:07 +0100
Message-ID: <AANLkTik4Bj2_D_oz8jWxzKSKz16S=Yv6884iHA072bJe@mail.gmail.com>
Subject: Re: Regressions in resume on intel graphics
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: airlied@redhat.com, jbarnes@virtuousgeek.org,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/12 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> Hi
>
> I've noticed that after resume  with 2.6.36 kernel I need to switch
> between console and back to Xorg to get usable Xsession again.
> (my hw - T61, gma965, 4GB)
>
> I've played bisect game -  and this is the first broken kernel:
>
> ---
> commit 8fd4bd22350784d5b2fe9274f6790ba353976415
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Wed Jun 23 12:56:12 2010 -0700
>
>    vt/console: try harder to print output when panicing
> ---

I've been able to boot and test with 2.6.37-rc1-00170-gf6614b7
- and this problem seems to be fixed in this version (vt.c file seems
to be gone?).

>
> Also I'd like to increase focus on another  suspend/resume killer (at
> least on my T61)
> https://bugzilla.kernel.org/show_bug.cgi?id=19052
> https://bugzilla.redhat.com/show_bug.cgi?id=617809
>

With kernel 2.6.37-rc1-00170-gf6614b7  message has changed (with
enabled polling thread)
--
[drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
[drm:i915_reset] *ERROR* Failed to reset chip.
X[1378]: segfault at 0 ip 00007f33409c727d sp 00007fff930e7120 error 4
in intel_drv.so[7f3340990000+4a000]
[drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
--

But I can't be sure about whether it's the same bug - as display seems
to be enabled for a second after resume.
and then just everything crashes.. - with original EIR bug 19052 - my
display remains completely black

I'm  using Fedora Rawhide  Xorg & driver:
xorg-x11-server-Xorg-1.9.1-3.fc15.x86_64
xorg-x11-drv-intel-2.12.0-8.fc15.x86_64

Zdenek
