Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1E3Lfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:35:55 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60256 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab1E3Lfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=YNqElr5A1DVoNyITVsXPqpa2el5Auos+dwIvLBWiTO1UniSB9pWMk8xTwOPkvva1T9
         9vMpDqopNmbO7fIrqRhPrGB93yrVr0RSsJ2b8Ps9QPIHr4M8u0VzVJLC9IkpfYmpuDV9
         cTPgBeEPCuvaQtJAXLR4HeCj/Q/p3yAbhgHRM=
MIME-Version: 1.0
In-Reply-To: <20110530105937.GB20133@elte.hu>
References: <cover.1306724657.git.luto@mit.edu> <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
 <20110530074608.GD27557@elte.hu> <BANLkTi=aX5un5ZPVD9u6NRJb-koFG7T=6w@mail.gmail.com>
 <20110530105937.GB20133@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 30 May 2011 07:35:33 -0400
X-Google-Sender-Auth: AdvhR5PK-TSFifNtE56pE8LQPis
Message-ID: <BANLkTimhMuN03qABgs0+Z+yti-rco5V82Q@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] x86-64: Emulate vsyscalls
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
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

On Mon, May 30, 2011 at 6:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>>
>> I'd advocate waiting until glibc 2.14 comes out with this change:
>>
>> http://sourceware.org/git/?p=glibc.git;a=commit;h=a8509ca540427502bd955f35296ff7b727c7a8a1
>>
>> I want to add a warning (ratelimited to an extremely low rate) in v3
>> whenever any of the vsyscalls get used telling users that their legacy
>> code is suffering a performance impact, but it seems like bad form to
>> tell people to build glibc from git to avoid a regression.
>
> But only statically built binaries would be impacted in practice,
> right? The number of statically built binaries that heavily rely on
> vsyscalls ought to be a very small set ...

With current glibc even dynamic binaries take the hit on time().

With the emulation warning (coming in v3), I get (on a Fedora 15-based VM):

[    0.635493] init[1] emulated legacy vsyscall time(); upgrade your
code to avoid a performance hit. ip:ffffffffff600404 sp:7fff277fe9c8
caller:3da3e9e27d in libc.so.6[3da3e00000+192000]

--Andy
