Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1H2Scg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:32:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44110 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab1H2Scf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:32:35 -0400
Message-ID: <4E5BDAF6.40000@zytor.com>
Date: Mon, 29 Aug 2011 11:31:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <4E5840FE.5090705@zytor.com> <20110827044050.GA3549@infradead.org> <201108291704.08279.arnd@arndb.de>
In-Reply-To: <201108291704.08279.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 08:04 AM, Arnd Bergmann wrote:
> 
> Right. The asm-generic/unistd.h interface doesn't provide them either
> for new architectures and expects libc to emulate them for any user
> application whose developers can't be bothered to fix their code.
> 
> I think I've also commented in the past that I think x32 should use
> the same set of syscalls asm asm-generic, even if it's more convenient
> to use a different ordering.
> 

It definitely is not convenient to use asm-generic for a whole lot of
reasons, which basically comes down to leveraging the existing x86-64
system calls plus leveraging the i386-on-x86-64 compat layer as much as
possible.

I talked to H.J. this morning and we're certainly dropping the 32-bit
filesystem calls.  I'm going to audit which paths have both time_t
(including struct timespec/timeval) and pointers; that is hopefully a
matter of legwork.  This will mean introducing new ioctls, but it's not
clear how many.

The end result is going to be bigger than the current patchset (which is
+2197 -510, and most of which is just the system call tables themselves;
the balance is only +690 -105), but it is definitely a *better* ABI.

	-hpa
