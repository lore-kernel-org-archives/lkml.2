Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1HGUSi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 16:18:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011Ab1HGUSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 16:18:36 -0400
MIME-Version: 1.0
In-Reply-To: <m2liv5ovf5.fsf@igel.home>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
 <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
 <CA+55aFxKES2bbcYWD29TFsGg19KXauPDwdkgYXXZbZ72kEXduw@mail.gmail.com>
 <CAGhQ9VzBAXv1cW5hAmUmfHQBDcAprLg_8T2XxRyrWT2G85AV6A@mail.gmail.com>
 <CA+55aFyECSVQT9Gi6KuiBrrMoC44CVJRZAb+s0Lt9j0UuKyfwQ@mail.gmail.com>
 <CAGhQ9Vx-MoFb7rEBQCwqi8zLjoWiED7FXvzcq2eDfTEg_P=2ug@mail.gmail.com>
 <d86cf41b-bc2f-400f-823e-8042913974ae@email.android.com> <CAGhQ9VwgpPv=z3TmODKwaXSneTaCrsj4cTpLEVXJ1aATiGZLrg@mail.gmail.com>
 <m2liv5ovf5.fsf@igel.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Aug 2011 13:17:35 -0700
Message-ID: <CA+55aFz9K1A=v6RsMMfjJdMURWPNGTi6J53iA5jqSwqP+x-gRQ@mail.gmail.com>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
To: Andreas Schwab <schwab@linux-m68k.org>, Nicolas Pitre <nico@fluxnic.net>
Cc: Joachim Eastwood <manabian@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 12:47 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>
> ARM has its own implementation of sha_transform in arch/arm/lib/sha1.S,
> which assumes SHA_WORKSPACE_WORDS is 80.

Well, that certainly explains it.

I wonder if that thing is worth it. It seems to be based on the bad
slow version of sha1, so I suspect that the biggest advantage of it
may the byte-swapping being done more efficiently. The ARM version of
"get_unaligned_be32()" is potentially pretty bad.

Joachim, does it all work for you if you just remove 'sha1.o' from
lib-y in arch/arm/lib/Makefile?

Nico (now with corrected email address): is that ARM-optimized asm
really worth it? Compared to the git C implementation?

                        Linus
