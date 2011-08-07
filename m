Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab1HGVHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 17:07:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab1HGVHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 17:07:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAGhQ9Vy9boyXuMMn=0E5Z-oN629wUTCC=ZMWWwUpB8U9RXJmdw@mail.gmail.com>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
 <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
 <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
 <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
 <CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com>
 <CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
 <d86cf41b-bc2f-400f-823e-8042913974ae@email.android.com> <CAGhQ9VwgpPv=z3TmODKwaXSneTaCrsj4cTpLEVXJ1aATiGZLrg@mail.gmail.com>
 <m2liv5ovf5.fsf@igel.home> <CA+55aFz9K1A=v6RsMMfjJdMURWPNGTi6J53iA5jqSwqP+x-gRQ@mail.gmail.com>
 <CAGhQ9Vy9boyXuMMn=0E5Z-oN629wUTCC=ZMWWwUpB8U9RXJmdw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Aug 2011 14:06:51 -0700
Message-ID: <CA+55aFyNtMwgJaMDjsy8V4k3v+WPcw9byNEVN46VGetvDOheuw@mail.gmail.com>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
To: Joachim Eastwood <manabian@gmail.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>, Nicolas Pitre <nico@fluxnic.net>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 1:48 PM, Joachim  Eastwood <manabian@gmail.com> wrote:
>
> yes, this works. At least my board boots as normal.

Ok, I'll remove it for -rc1, just to have a working ARM setup. Maybe
we can re-introduce it later (either together with some arm-specific
hack for SHA_WORKSPACE_WORDS or by having an arm-optimized version of
the *good* sha1 routine).

But I doubt it: there used to be an ARM-optimized thing in git too. It
was removed two years ago with the commit message:

    remove ARM and Mozilla SHA1 implementations

    They are both slower than the new BLK_SHA1 implementation, so it is
    pointless to keep them around.

and quite frankly, that removed code seems to be the same as the
in-kernel one. So I bet the ARM "optimized" SHA1 is simply not worth
keeping around.

                      Linus
