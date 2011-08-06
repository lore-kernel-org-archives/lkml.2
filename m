Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1HFUSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 16:18:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32993 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1HFUSj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 16:18:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110531193602.GA26535@elte.hu>
References: <cover.1306851090.git.luto@mit.edu>
	<1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu>
	<20110531183448.GA27166@one.firstfloor.org>
	<BANLkTinXSDJoT6Uege6zLZqSp87oURfh0w@mail.gmail.com>
	<20110531192833.GA23458@elte.hu>
	<20110531193602.GA26535@elte.hu>
Date: Sat, 6 Aug 2011 16:18:38 -0400
X-Google-Sender-Auth: CxrjIOozOX3aiMh4cBIry4MG0G8
Message-ID: <CAObL_7HFht0rBHkeLqwVRBNR1yn2qJgWsM7Qr2p3w482t3WKpQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
From: Andrew Lutomirski <luto@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Lutomirski <luto@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 31, 2011, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> [...] solution that filters the caller RIP at the generic syscall
>> entry point and checks RCX against the 'expected' SYSCALL
>> instruction address, which is the (per task) vdso-address +
>> constant-offset.
>
> Note that this solution would allow the vsyscall page to be
> 'filtered' to the 3 allowed system calls rather efficiently, via a
> second level check.
>
> This second check does not affect the fastpath, and it could be put
> behind a CONFIG_COMPAT_VSYSCALL deprecation define once glibc does
> not put vsyscall references anywhere - but we could even keep it
> around forever, as this way it's defanged permanently.

I'm confused.  Are you thinking about the 32-bit vDSO?  I think that
64-bit code puts syscall instructions all over the place.

--Andy

>
> Thanks,
>
>         Ingo
>
