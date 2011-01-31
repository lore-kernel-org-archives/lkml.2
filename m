Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1AaRW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:22:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62636 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1AaRW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:22:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nXAh4J8sAGQLpTFAew/cg+7Kk+UGR8X3pEgUQHabCOZTO7WbolLrx2QvjnlIxzxRS2
         VPS0mVD4Y/xkM7nWbsQwjSLWniEXScNKqKWoEBIYQG7U5rJa9XCwijIzh8s6y4cMtC7b
         qhwUqI8PeRusSIt9s9Nn3KyQbbrRgRiXsTylE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
References: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
Date: Mon, 31 Jan 2011 18:22:57 +0100
X-Google-Sender-Auth: P4NHiAtVfMPFlQmS5c-yX6HCSR0
Message-ID: <AANLkTinU9nWTW9nJeGYQ9YJKbSzWn2SK7BjXPx_JZ-0w@mail.gmail.com>
Subject: Re: typecheck code
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 18:03, Sri Ram Vemulpali
<sri.ram.gmu06@gmail.com> wrote:
> Hi all,
>
> /*
>  * Check at compile time that something is of a particular type.
>  * Always evaluates to 1 so you may use it easily in comparisons.
>  */
>  #define typecheck(type,x) \
>  ({      type __dummy; \
>        typeof(x) __dummy2; \
>        (void)(&__dummy == &__dummy2); \
>        1; \
>  })
>
> #define typecheck_fn(type,function) \
> ({      typeof(type) __tmp = function; \
>       (void)__tmp; \
> })
>
> Can anyone help me, explain the above code typecheck. How does
> (void)(&__dummy == &__dummy2) evaluates to 1

It does not rely on the equation evaluating to 1. That result is
expicitly unused,
witness the cast to void.
It does rely on gcc complaining if you compare two pointers that don't
point to the same type.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
