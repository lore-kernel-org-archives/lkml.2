Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab1DQNum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 09:50:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44366 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1DQNug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 09:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LW5BNDRieb/5Toze5xmRSBvypqI1ZDNROKUsXbv+XWDYai28b4Zb1vyWPYhVwBare5
         R4SZN0XE0W9upmro5mJQ+85t0ZUSUtrhh/Yb16feGht3Z0wQrm2rNi1N8bAwF/2BAOi7
         4Ub0BH20SbBim6oA8b6t6Y1HmafSTBQk6/nxg=
MIME-Version: 1.0
In-Reply-To: <1301836277-30185-2-git-send-email-geert@linux-m68k.org>
References: <1301836277-30185-1-git-send-email-geert@linux-m68k.org>
	<1301836277-30185-2-git-send-email-geert@linux-m68k.org>
Date: Sun, 17 Apr 2011 22:50:35 +0900
Message-ID: <BANLkTin8ok0bMBM3YrcU43FVEr1MuzegBQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] m68k: bitops - Never step beyond the end of the bitmap
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/3 Geert Uytterhoeven <geert@linux-m68k.org>:
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
> 3. Unfortunately find_first_bit() takes unsigned int as the size argument.
>
> 4. find_first_bit will access bitmap[2~] until it find any set bits.
>
> Add missing tests for stepping beyond the end of the bitmap to all
> find_{first,next}_*() functions, and make sure they never return a value
> larger than the bitmap size.
>
> Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Andreas Schwab <schwab@linux-m68k.org>

These patches look good.

I checked that find_next_zero_bit_le() and find_next_bit_le() work
as I expect.
