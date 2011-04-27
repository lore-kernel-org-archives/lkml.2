Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1D0OAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:00:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43399 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab1D0OAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fMFrlfA0BVOMxoOUu8k9XYnH2OyYjn5qIDyLL1ec7Odh4+A/eqXUq6w1TcQxZK2hBA
         4jz9R33xG5HNAlT+mHizd2FYJc7EbZmYiwCo9P11gnSZ0FCo7O+YGf5o1K1TM/hdetqq
         g1lgDi4c9ZYRK5LoMLTISAnKNqa0w/1QKKEm0=
MIME-Version: 1.0
In-Reply-To: <1303910411-15793-3-git-send-email-akinobu.mita@gmail.com>
References: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com>
	<1303910411-15793-3-git-send-email-akinobu.mita@gmail.com>
Date: Wed, 27 Apr 2011 16:00:28 +0200
X-Google-Sender-Auth: MWf-V18xhXAWYatJjXUF5d5Zi00
Message-ID: <BANLkTi=t4jFh58TSkgCt0YsweoEoO8TXvA@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] arch: add #define for each of optimized find bitops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 15:20, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> The style that we normally use in asm-generic is to test the macro itself
> for existence, so in asm-generic, do:
>
>        #ifndef find_next_zero_bit_le
>        extern unsigned long find_next_zero_bit_le(const void *addr,
>                unsigned long size, unsigned long offset);
>        #endif
>
> and in the architectures, write
>
>        static inline unsigned long find_next_zero_bit_le(const void *addr,
>                unsigned long size, unsigned long offset)
>        #define find_next_zero_bit_le find_next_zero_bit_le
>
> This adds the #define for each of the optimized find bitops in the
> architectures.
>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
