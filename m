Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0ESTBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:01:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49770 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0ESTBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:01:13 -0400
Message-ID: <4BF43559.6080808@zytor.com>
Date: Wed, 19 May 2010 12:00:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Luca Barbieri <luca@luca-barbieri.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: [GIT PULL] x86/atomic changes for v2.6.35
References: <20100517224531.GA27400@elte.hu> <AANLkTinWbueCQZdQgZFDLQPJYieB13orxDGYJzzRpPni@mail.gmail.com> <4BF3F480.3000902@zytor.com> <20100519161828.GB16082@linux-sh.org>
In-Reply-To: <20100519161828.GB16082@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 09:18 AM, Paul Mundt wrote:
>
> No, the problem isn't solved, you apparently overlooked the part of
> Geert's mail that point out that the test fails to build on architecures
> that _do_ have atomic64_t. All of arm/parisc/powerpc/sh select
> GENERIC_ATOMIC64, suggesting that the test itself was only ever tested on
> x86 and never on the generic implementation. While that may be par for
> the course these days, it's still pretty poor form.
> 

I don't see any atomic64_t issues in the ARM, PowerPC or MIPS builds --
which doesn't mean they're not there, but if so they're obscured by
other errors.  m68k is missing #include <asm-generic/atomic64.h> in
<asm/atomic.h>, and SPARC64 and S390 seems to have issues due to missing
<linux/kernel.h> in atomic64_test.c; the latter is indeed a bug in the
test and yes, should be fixed.

	-hpa
