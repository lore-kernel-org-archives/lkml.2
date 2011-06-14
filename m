Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1FNVeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:34:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55702 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1FNVeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=GQSq7h2JQfAF1jvt+NQfQHs0sWjGt37BTy0yJaVY0TSpv5/I5YsK3UlTTwXXfNoBH4
         k49ElExR8b9+T1e8Whea9OOEppL/glGByO5EWbmRNZfVlrQajy8pFaKna6bHFGQarvgJ
         p/laXKTjAmtmpQtCnkppNbkzK1lMMTHKzL6vs=
MIME-Version: 1.0
In-Reply-To: <20110614213109.GA9725@elte.hu>
References: <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
 <BANLkTi=yEo9fcXW8SqUCtSOag7Mn_+Ni9Q@mail.gmail.com> <BANLkTimv6F8NsH0Lg7q6gi1-oiBv8nUrSA@mail.gmail.com>
 <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com> <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com>
 <BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com> <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com>
 <4DF7A264.3030901@mit.edu> <20110614211613.GB12249@elte.hu>
 <BANLkTi=W1xFdoSFxnNBGX9gt_pYOH4oF=A@mail.gmail.com> <20110614213109.GA9725@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 14 Jun 2011 17:33:50 -0400
X-Google-Sender-Auth: 6CxzchamvBhIbOlF5_4hojEjXag
Message-ID: <BANLkTimXYaf_14VbB6ex0kG6sPnTUfzu6g@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rakib Mullick <rakib.mullick@gmail.com>, hpa@zytor.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 5:31 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Tue, Jun 14, 2011 at 2:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > I think correctness trumps code size and turning BUG() and BUG_ON()
>> > into a NOP is just crazy ...
>>
>> Umm. It's even CRAZIER to turn it into a "compiler generates random code".
>
> Sigh, i assumed it got turned into an infinite loop - that is what
> i've done in a prior patch.
>
> You are right, unreachable() is bogus and you'd also be right to
> suggest that i should not comment on patches after 11pm ;-)

What we want is a magic GCC trick that says "don't warn about code
paths that go through here but generate the same code as you would
without this annotation."  I don't think such a thing exists.

--Andy
