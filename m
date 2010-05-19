Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0ESLqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:46:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38635 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0ESLqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AZNR829GLVqtAoz31TLXWxRHm5jFwGZX6XX3tTnzuEwlhQ56e1nKeYwtIOSWn8AXwu
         kGe4oMZQqBhHW7oxVeK/X3tOaWkNlwe/Zr8Ddau+lwmS4BdNu64vv9VZbx8vPthdqpqd
         KsmeqzzLXIH+fpPygO5uhhJBBlyxW6GmsCoYQ=
MIME-Version: 1.0
In-Reply-To: <20100517224531.GA27400@elte.hu>
References: <20100517224531.GA27400@elte.hu>
Date: Wed, 19 May 2010 13:46:01 +0200
X-Google-Sender-Auth: SssMtGwSPhRcGX5-JcS5WzexG9I
Message-ID: <AANLkTinWbueCQZdQgZFDLQPJYieB13orxDGYJzzRpPni@mail.gmail.com>
Subject: Re: [GIT PULL] x86/atomic changes for v2.6.35
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>, Luca Barbieri <luca@luca-barbieri.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 00:45, Ingo Molnar <mingo@elte.hu> wrote:
> Please pull the latest x86-atomic-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-atomic-for-linus
>
>
> out-of-topic modifications in x86-atomic-for-linus:
> ---------------------------------------------------
> lib/Makefile                       # 86a8938: lib: Add self-test for atomic64_t
> lib/atomic64.c                     # 9757789: lib: Fix atomic64_add_unless retu
> lib/atomic64_test.c                # a5c9161: x86, atomic64: In selftest, disti
>                                   # 25a304f: lib: Fix atomic64_inc_not_zero te
>                                   # 9efbcd5: lib: Fix atomic64_add_unless test
>                                   # d7f6de1: x86: Implement atomic[64]_dec_if_
>                                   # 8f4f202: lib: Only test atomic64_dec_if_po
>                                   # 86a8938: lib: Add self-test for atomic64_t

Is having atomic64_t mandatory now?

According to the allmodconfig build logs
(http://kisskb.ellerman.id.au/kisskb/matrix/),
several architectures (at least m68k and mips) don't have it.
Furthermore, the test fails to compile on a few architectures that do have it
(parisc, s390, sh, ...).

<boilerplate>
It's a pity this wasn't raised/resolved between its detection in linux-next and
before it entered mainline...
</boilerplate>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
