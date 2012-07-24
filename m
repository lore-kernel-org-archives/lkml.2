Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2GXTKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:10:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37022 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2GXTKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:10:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120724190302.GE10534@zod.bos.redhat.com>
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com> <20120724183230.GC10534@zod.bos.redhat.com>
 <CA+55aFwFcWoH=QB5tKgVjWcUH3SLCDVNqJY-oXRYy7AWOJfLPA@mail.gmail.com> <20120724190302.GE10534@zod.bos.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 12:09:41 -0700
X-Google-Sender-Auth: 54FdIV0cofkv7cbn3Qi4fQ5RHRY
Message-ID: <CA+55aFyn-yMUMdcY8jp65eeoGm3RPzy9p+St35-HGE_xXiVJag@mail.gmail.com>
Subject: Re: [PATCH v2] posix_types.h: make __NFDBITS compatible with glibc definition
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, law@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:03 PM, Josh Boyer <jwboyer@redhat.com> wrote:
>
> FWIW, the definitions of __FD_ELT/__FD_MASK in glibc are:
>
> #define __FD_ELT(d)     ((d) / __NFDBITS)
> #define __FD_MASK(d)    ((__fd_mask) 1 << ((d) % __NFDBITS))
>
> where __fd_mask is 'typdef long int'.

Yeah, that's not good.

If __NFDBITS is signed (and it is), and "d" is a signed type, that
division and modulus now create stupid extra code with conditionals
(assuming 'd' isn't constant, of course).

So changing the sign of __NFDBITS has these kinds of subtle side
effects that clearly the glibc people didn't actually think about.

What was the *advantage* of that stupidity?

Quite frankly, if you want to make NFDBITS be an "int", then it should
have been done at that

   #define NFDBITS ((int)__NFDBITS)

level, not at "__NFDBITS". Exactly because the unsigned type there matters.

Does anybody in the glibc camp care about efficient and small code AT ALL?

                  Linus
