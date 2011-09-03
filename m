Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1ICIld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 04:41:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59371 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab1ICIlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 04:41:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Date: Sat, 03 Sep 2011 10:41:16 +0200
Message-ID: <8179020.mG8hWW8BRr@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E61BB42.4090301@zytor.com>
References: <4E582577.2060805@zytor.com> <CAMe9rOpP9Dt0FvHb0FDbHha0-fv2q4ahfMB_CejqcbWqxuYe8Q@mail.gmail.com> <4E61BB42.4090301@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JWOAZBDbBxmTtaRuaBq3/OPMbsiA4DzEp74rNb86OjW
 FEhX9OxB/4cNPiaVAjYWKtnTTpiL9QhYK4HwsDFhi3Qv5viRK8
 H3R3QkCoQZXEUHpjJDJWaMDT0rzz73+uFeu71/xRbl3UmWFyGb
 ehD761pQJYZnzDu96/VizUpaXmEj+31ivk9qXX+mJ2xWmq7eeT
 UehC2fZv/zWV0yzE6z2hJGKT0FcooRXuSUroZGlQbr2cTRKEMo
 JsNAcKbQH0npKRrtBowMSwi1rmYwY49KHgVGeK9ZpEz8T6vk4i
 sq9psl6US3Lc1YBqGMqJQh6dVYnQ+9J+WlRiQIYO/kTkCancJp
 qGgmvbtGpx9LIObSqI48=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 September 2011 22:29:38 H. Peter Anvin wrote:
> On 09/02/2011 09:44 PM, H.J. Lu wrote:
> > 
> > Is there a way to support something similar to  __SNATIVE_LONG_TYPE
> > and  __UNATIVE_LONG_TYPE for kernel header files.
> > 
> 
> Again, what is the definition you're looking for?  We have __u64 and
> __s64, but the question is what alignment those types should be using,
> given that we're presumably stuck with using compat_ioctl for ioctl...

I think the above types have to use full 64 bit alignment, otherwise
you are incompatible with any native data structures that have padding
in the 64-bit ABI.

For the ioctl interface however, the __u64/__s64 type in the x32 ABI
must be defined with __attribute__((packed,aligned(4))) to match what
the kernel implements because it emulates the x86-32 ABI.

This also means we need to audit all ioctl definitions that use
some other type like 'unsigned long long' or 'uint64_t' and change
those to use the proper '__u64'.

	Arnd
