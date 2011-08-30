Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1H3MJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:09:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63695 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1H3MJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:09:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFD: x32 ABI system call numbers
Date: Tue, 30 Aug 2011 14:09:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <4E582577.2060805@zytor.com> <201108291704.08279.arnd@arndb.de> <4E5BDAF6.40000@zytor.com>
In-Reply-To: <4E5BDAF6.40000@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301409.27527.arnd@arndb.de>
X-Provags-ID: V02:K0:DHaPOiIncVnbzaVOOSChDmTOd5wWVFfsOAbbEfuNBBb
 3B4Ci5DN1n+Vzh1JlC5uDBQt/BMlaru8YJ+TyUxmpy7XLo7TE6
 FQ6pGHbyifplaveU2iGr/HyLGAEO6dH5lMW3zZN3K88c/mLFdU
 ZFM3hvynZudV4XLxuoWEUxXE41cgI4uImQ7QMJi08W6q+W1pJp
 FDs05LlZs5+h+7K4kSIKpLAQQJrWX1idsJl6fXB/0STZrW7v5P
 BmejsVfMCmxg2WsW5f1RSh8wpPBuFDInAwDNiSznGtoHGOJ/NE
 /fooiL89ltMtzwOJ+dn/BkLCrzQOryrxGtLqZD1/XU15ROQH+0
 z75o6HPR+UOE2tQh7U0o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 August 2011, H. Peter Anvin wrote:
> On 08/29/2011 08:04 AM, Arnd Bergmann wrote:
> > 
> > Right. The asm-generic/unistd.h interface doesn't provide them either
> > for new architectures and expects libc to emulate them for any user
> > application whose developers can't be bothered to fix their code.
> > 
> > I think I've also commented in the past that I think x32 should use
> > the same set of syscalls asm asm-generic, even if it's more convenient
> > to use a different ordering.
> > 
> 
> It definitely is not convenient to use asm-generic for a whole lot of
> reasons, which basically comes down to leveraging the existing x86-64
> system calls plus leveraging the i386-on-x86-64 compat layer as much as
> possible.

Yes, but that's not what I meant. My point was that any new architecture
should have only the set of 269 syscalls that asm-generic has, i.e. 
no none of the syscalls that have been replaced for any number of
reasons (large files, *at, uid32, pselect).

I do agree that you should keep using the x86 data structures unless
there is a good reason to do otherwise, and I agree that you should
keep using the syscall numbers for the calls that remain, but I would
just leave out from the ABI the calls that are no longer necessary.

> I talked to H.J. this morning and we're certainly dropping the 32-bit
> filesystem calls.  I'm going to audit which paths have both time_t
> (including struct timespec/timeval) and pointers; that is hopefully a
> matter of legwork.  This will mean introducing new ioctls, but it's not
> clear how many.
> 
> The end result is going to be bigger than the current patchset (which is
> +2197 -510, and most of which is just the system call tables themselves;
> the balance is only +690 -105), but it is definitely a better ABI.

Ok.

I'm wondering about the time_t changes: given that we are still adding
new 32 bit architectures, should we change the asm-generic API as well
to use 64 bit time_t by default (with fallbacks for the existing ones)?

If you are adding support for these in x32 already, we could use the
same code for regular 32 bit architectures.

	Arnd
