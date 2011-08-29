Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1H2PFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:05:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65154 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab1H2PFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:05:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFD: x32 ABI system call numbers
Date: Mon, 29 Aug 2011 17:04:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <4E582577.2060805@zytor.com> <4E5840FE.5090705@zytor.com> <20110827044050.GA3549@infradead.org>
In-Reply-To: <20110827044050.GA3549@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291704.08279.arnd@arndb.de>
X-Provags-ID: V02:K0:UjRLjiA8XeRb1XC/5TeawOEBByxLjeI3m2/Oo0UBgMw
 4t/k1MUMvN7BClEtFRC+/2qweBq5K5wewyBHoRJHQJ5wDnKV6k
 yN3BVHRkYJuIOaTv25ykJuKlL5N5tPUSh2lSN7FELOZxQ4A6i1
 IOxqSMdcBglPjhCbWKF6DOa+DS2d06CDVjJrKckW6Bo1tTII55
 DfQChhy9yiazc7wwe3Bh0gJKRZirVFBO6v5t163pELRYQghFuV
 UxqzqtJ7XeMchkraHs9V/YMfGIyGQ3WRi/xkt1D//c5NE0J3Ac
 jZjBDEc6A/Hqf9IR9amBLu772KQaIsbeqUK711pkjzwPKHzyMQ
 UovdF039WYZgRfZx216Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 August 2011, Christoph Hellwig wrote:
> On Fri, Aug 26, 2011 at 05:57:34PM -0700, H. Peter Anvin wrote:
> > On 08/26/2011 05:36 PM, Linus Torvalds wrote:
> > > If you want to be compatible with "int 0x80" and old libraries, then I
> > > really don't see why you would introduce anything new.
> > 
> > Just to be clear, the reason to keep the LFS stuff in there was to be
> > compatible with the existing 32-bit *programming model*, so that a
> > program recompiled from i386 to x32 should behave the same.
> > 
> > Not that anyone should compile without -D_FILE_OFFSET_BITS=64 these days...
> 
> Any new port should not even offer non-LFS system calls.  They are a
> pain in the but, and I would sacrifice chicken if we coud stop glibc
> offering it as a default that way.

Right. The asm-generic/unistd.h interface doesn't provide them either
for new architectures and expects libc to emulate them for any user
application whose developers can't be bothered to fix their code.

I think I've also commented in the past that I think x32 should use
the same set of syscalls asm asm-generic, even if it's more convenient
to use a different ordering.

	Arnd
