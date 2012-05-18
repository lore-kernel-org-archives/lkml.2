Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967799Ab2ERVV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:21:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58903 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab2ERVVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:21:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
Date: Fri, 18 May 2012 21:21:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <CA+55aFzfku-5qgVPahu27DLz-y8MUmh7Mw9sq_TyO49Zb0tg=A@mail.gmail.com> <CAMe9rOr883q0OAsh+JGA83ww603y6QSbQJKx+wk2YJfkYcaEdQ@mail.gmail.com>
In-Reply-To: <CAMe9rOr883q0OAsh+JGA83ww603y6QSbQJKx+wk2YJfkYcaEdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205182121.02706.arnd@arndb.de>
X-Provags-ID: V02:K0:0AWOUfR4Hb2Mh9s7o6Gn0Fx9SrrhFYMpL9QqjnkE2gm
 Skxnr+/uqzUOixwbnKkV6qP5/lq9WQ6uRP9CsGw//Qj3oh4bcP
 TDHUYBZh8kRdDvhW4WSaoy5RwO346sCl1AMdfOmL3FxQpFiC5p
 Z2DVlk6W7RnS53AmZZqbLATZ7m48nu4m3xauNVqeCn2oNZAePM
 tdgguMLXsv0FOupYDF3eiE9EdKA4VpdRZ6HrqkSATR1stcRd0G
 UF2YCB1LGleIHXl4+kgBam0pzVCM+L/3TXdTdeeR41RIuUMm6S
 BcTyUHvo81aPSIZBVKe/cwcRgSCuKAUlLFASXot3CwcgRcTDNE
 RRjSs5RiC6F69M7PvNG0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2012, H.J. Lu wrote:
> Since x32 uses the same kernel interface as x86-64 with a few
> exceptions.  The current kernel header files with
> 
> #ifdef __x86_64__
> # define __BITS_PER_LONG 64
> #else
> # define __BITS_PER_LONG 32
> #endif
> 
> #if __BITS_PER_LONG == 64
> Define x86-64 types
> #endif
> 
> work fine for x32 even if long for x32 is 32 bits.  If __BITS_PER_LONG
> is changed to 32 for x32, many types in kernel header files will be
> wrong for x32.
> 

A lot of things are broken if __BITS_PER_LONG is set to 64 in x32 user
space. It was specifically introduced to get around places in exported
headers that incorrectly used '#ifdef CONFIG_64BIT' to define a user
space structure, so that we can depend on whatever the user sees
in bitmasks and other data structures.

	Arnd
