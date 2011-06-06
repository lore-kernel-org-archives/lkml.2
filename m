Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab1FFMeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:34:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49670 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab1FFMeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=HjtFHkfyGKhNQ+UrQ7sjcER+HRLwjRUh9RnSkkJkUY0OH50ha21aI431vbn1pVan8Y
         mRPq2n3yh3tRomf9Vg1IB9LGbU4zqp12o714Qyv/E5uUM8lHztW1ksPVXz79L045Xztn
         fi6OTxSEMu7wMQeQffGIEfKuji2oS6bw9gElo=
MIME-Version: 1.0
In-Reply-To: <20110606121937.GI7180@thunk.org>
References: <cover.1307292171.git.luto@mit.edu> <4de62bfbf6974f14d0e9d9ae37cc137dbc926a30.1307292171.git.luto@mit.edu>
 <BANLkTimrhO8QfBqQsH_Q13ghRH2P+ZP7AA@mail.gmail.com> <20110606102419.GA837@elte.hu>
 <20110606121937.GI7180@thunk.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 6 Jun 2011 08:33:49 -0400
X-Google-Sender-Auth: iUYnaJaU7wT89YXfKOwBHwpQTho
Message-ID: <BANLkTik86BuPwktj1R1vnMoqrReY8RhHtw@mail.gmail.com>
Subject: Re: [PATCH] x86-64, vsyscalls: Rename UNSAFE_VSYSCALLS to COMPAT_VSYSCALLS
To: "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@mit.edu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 8:19 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Jun 06, 2011 at 12:24:19PM +0200, Ingo Molnar wrote:
>>
>> -What:        CONFIG_UNSAFE_VSYSCALLS (x86_64)
>> +What:        CONFIG_COMPAT_VSYSCALLS (x86_64)
>>  When:        When glibc 2.14 or newer is ubitquitous.  Perhaps mid-2012.
>> -Why: Having user-executable code at a fixed address is a security problem.
>> -     Turning off CONFIG_UNSAFE_VSYSCALLS mostly removes the risk but will
>> +Why: Having user-executable syscall invoking code at a fixed addresses makes
>> +     it easier for attackers to exploit security holes.
>> +     Turning off CONFIG_COMPAT_VSYSCALLS mostly removes the risk but will
>>       make the time() function slower on glibc versions 2.13 and below.
>>  Who: Andy Lutomirski <luto@mit.edu>
>
> I'd suggest 2013 or 2014, at least.  People using Ubuntu LTS and RHEL
> 6 are stuck back at glibc 2.11, and many of those users do like being
> able to upgrade to newer kernels.  And there are probably are a large
> number of static binaries around.
>
> Maybe in 2012 or so we change the to be 'no' (and I'd suggest adding a
> comment in the feature-removal-schedule.txt file that this will also
> break static binaries).

It doesn't actually break them; it just slows them down.  But I'm very
particular about the date.

--Andy
