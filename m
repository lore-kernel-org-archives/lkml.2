Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab1C3SCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:02:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64022 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab1C3SCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=F6yfJHg0iBhIdgKxWVXsTids2FE1Q6Md2rQJP7+euVn7/MS09P5r1OPTV2bvpBSBbu
         OQ48zlZA5IL3NQw6Q0aoABgrzZ8e+H0qEFkCgxHBlNnLRy3mZ+qDpFNvw5RPl+BaOWlu
         IaDJHi12rNExN4R+8tc/SiMRAhvlXTXVMG6NY=
MIME-Version: 1.0
In-Reply-To: <1301050810-11329-1-git-send-email-akinobu.mita@gmail.com>
References: <1301050810-11329-1-git-send-email-akinobu.mita@gmail.com>
Date: Wed, 30 Mar 2011 20:02:50 +0200
X-Google-Sender-Auth: FrlbRYZtbRqFUzLS7cEO7BiJHIs
Message-ID: <AANLkTikKA2MY6nf+LLyJbNQffX=qYY3eZdpNmwVQc21u@mail.gmail.com>
Subject: Re: [PATCH] m68k: fix find_next bitops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Michael Schmitz <schmitzmic@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:00, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> find_next bitops on m68k (find_next_zero_bit, find_next_bit, and
> find_next_bit_le) may cause out of bounds memory access
> when the bitmap size in bits % 32 != 0 and offset (the bitnumber
> to start searching at) is very close to the bitmap size.
>
> For example,
>
>       unsigned long bitmap[2] = { 0, 0 };
>       find_next_bit(bitmap, 63, 62);
>
> 1. find_next_bit() tries to find any set bits in bitmap[1],
>   but no bits set.
>
> 2. Then find_first_bit(bimap + 2, -1)
>
> 3. Unfortunately find_fist_bit() takes unsigned int as the size argument.
>
> 4. find_first_bit will access bitmap[2~] until it find any set bits.
>
> This switches find_next bitops to use generic implementation of
> find bitops to fix the problem.

Andreas, do you think it's worth keeping (and fixing) the m68k "optimized"
versions?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
