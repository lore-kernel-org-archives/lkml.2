Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab1EaS7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:59:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38112 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1EaS7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=IVihnU9tC+E7f1Gt5rLykuGU8M29ZiaBctBKUMfEe/V8vOo3AIHWiaPPIM9XtY7GkQ
         8iAX7N/KK530hpurViVXoJeLRcAvYuPO2ClPWLOrzm8ZyUBuJtJXzX0I5solRRhTBmft
         X8IGwLfLbsPZo8X+h04sfd7gCw5/tEvoNNtRI=
MIME-Version: 1.0
In-Reply-To: <20110531183448.GA27166@one.firstfloor.org>
References: <cover.1306851090.git.luto@mit.edu> <1660d1687db01852ec58bbf970e22868db367d53.1306851090.git.luto@mit.edu>
 <20110531183448.GA27166@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 14:59:10 -0400
X-Google-Sender-Auth: 8CcMBMVNeSQSQlZpI6C37dqKN4c
Message-ID: <BANLkTinXSDJoT6Uege6zLZqSp87oURfh0w@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] x86-64: Add CONFIG_UNSAFE_VSYSCALLS to feature-removal-schedule
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
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

On Tue, May 31, 2011 at 2:34 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> +What:        CONFIG_UNSAFE_VSYSCALLS (x86_64)
>> +When:        When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
>> +Why: Having user-executable code at a fixed address is a security problem.
>> +     Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
>> +     make the time() function slower on glibc versions 2.13 and below.
>
> I disagree with this description (and the whole idea really)
>
> First it's time+gettimeofday+vgetcu, not just time.
>
> A more accurate description is
>
> "will make all x86-64 Linux programs written to the original pre
> vDSO syscall ABI significantly slower"

Well, if this series goes in, then gettimeofday and getcpu are already
slower.  It's just time that would get even slower later on.

>
> And the assumption that all world is using glibc is still as bad
> as it was on the first po.st

As opposed to?

uclibc and klibc don't appear to use vsyscalls or the vdso.

dietlibc is hardcoded to use the vsyscall.  Are there any
performance-critical programs using dietlibc?

I don't think that Bionic runs on any released x86-64 systems.

>
> And it's still a bad idea. Especially since there's a much better
> alternative anyways for the "security problem" which has none of
> these drawbacks.

What's the alternative?

--Andy
