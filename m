Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab1EaUFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:05:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51783 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab1EaUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xN/J+p7rzQ0mbaM2HpssJh/Lz/kQW05EfqmqdmUzGDXsNvAc8AeK3YhC7u9kxD5AR9
         6a8GGyGCMIUk9RJ9W0XXnMQZAj0RjMTnjMSb/lhRbAXUXIvbJEax8Gh8B5jcXgQHTCoa
         ytldi68ZT8a+RQ7hSnE+OeGp/wf8zbLHqEoJA=
MIME-Version: 1.0
In-Reply-To: <20110531193602.GA26535@elte.hu>
References: <cover.1306851090.git.luto@mit.edu>
	<1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu>
	<20110531183448.GA27166@one.firstfloor.org>
	<BANLkTinXSDJoT6Uege6zLZqSp87oURfh0w@mail.gmail.com>
	<20110531192833.GA23458@elte.hu>
	<20110531193602.GA26535@elte.hu>
Date: Tue, 31 May 2011 16:05:07 -0400
X-Google-Sender-Auth: y2JyutP_rW6ZRm8sUZ2f1LgyJs0
Message-ID: <BANLkTinQ-y-g_3OKOWwOJ-sWxjJgh_G-=Q@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
From: Andrew Lutomirski <luto@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, possible resend.]

On 5/31/11, Ingo Molnar <mingo@elte.hu> wrote:
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
>

Are you thinking about the 32-bit vDSO? I think that 64-bit code puts
syscalls instructions all over the place.

How is this better than v2 of my series, stopping after the int cc fallback?

--Andy

> Thanks,
>
> 	Ingo
>
