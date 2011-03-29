Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1C2Uho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:37:44 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60199 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1C2Uhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:37:43 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Linux\/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound computation for COMPAT_BRK
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz>
	<AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
	<alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz>
	<AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com>
	<alpine.LNX.2.00.1103281619320.26754@pobox.suse.cz>
	<AANLkTi=pNxVY8NZjRhT_aJMQNiTpfkmECqc-ZnTD7ynW@mail.gmail.com>
X-Yow: Uh-oh!!  I'm having TOO MUCH FUN!!
Date: Tue, 29 Mar 2011 22:37:38 +0200
In-Reply-To: <AANLkTi=pNxVY8NZjRhT_aJMQNiTpfkmECqc-ZnTD7ynW@mail.gmail.com>
	(Geert Uytterhoeven's message of "Tue, 29 Mar 2011 22:24:21 +0200")
Message-ID: <m262r1hdd9.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Seems like the binary doesn't like brk() rounding up the requested
> value to the next page...

>From libc-5.4.46/libc/sysdeps/linux/m68k/__sbrk.c:

void *
__sbrk(ptrdiff_t increment)
{
    if (__init_brk () == 0)
    {
	register void * tmp asm ("%d1") = ___brk_addr+increment;
	__asm__ volatile ("movel %1,%/d0\n\t"
			  "trap  #0\n\t"
			  "movel %/d0,%0"
		:"=g" (___brk_addr)
		:"i" (SYS_brk),"g" (tmp) : "%d0");
	if (___brk_addr == tmp)
		return tmp-increment;
	errno = ENOMEM;
    }
    return ((void *) -1);
}

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
