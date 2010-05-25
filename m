Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab0EYTuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:50:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49991 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab0EYTug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CILGFJ6sNOq36aawG8XB0itFL/8HhdvpSyTdgZr5SRXs6qAN3fg3U/qZ7T6WpWPfiT
         sSzuOdvf0u+9Lrl2oz09WvWVFFs47XOcR8wfuAfLbexBOsPe0ZEr5HAgNCgk80k4L6hE
         yyIrDztmvRId4MPgxKfxARqTF0wZub7BXFx9U=
MIME-Version: 1.0
In-Reply-To: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org>
Date: Tue, 25 May 2010 21:50:34 +0200
X-Google-Sender-Auth: 1g92tJrcRk489jC6K_P2oetLHBk
Message-ID: <AANLkTimH-p5muib3-3sPWySFpQN7eLXf9KsCb_f0r9gw@mail.gmail.com>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the 
	slab
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jie Zhang <jie.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 21:24, Mike Frysinger <vapier@gentoo.org> wrote:
> From: Jie Zhang <jie.zhang@analog.com>
>
> The recent commit 1f0ce8b3dd667dca7 which moved the ARCH_SLAB_MINALIGN
> default into the global header inadvertently broke FLAT for a bunch of
> systems.  Blackfin systems now fail on any FLAT exec with:
> Unable to read code+data+bss, errno 14
> When your /init is a FLAT binary, obviously this can be annoying ;).
>
> This stems from the alignment usage in the FLAT loader.  The behavior
> before was that FLAT would default to ARCH_SLAB_MINALIGN only if it was
> defined, and this was only defined by arches when they wanted a larger
> alignment value.  Otherwise it'd default to pointer alignment.  Arguably,
                                             ^^^^^^^^^^^^^^^^^
That would be __alignof__(void *)

> +#elif defined(ARCH_SLAB_MINALIGN)
>  #define FLAT_DATA_ALIGN        (ARCH_SLAB_MINALIGN)
>  #else
>  #define FLAT_DATA_ALIGN        (sizeof(void *))

Not sizeof(void *)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
