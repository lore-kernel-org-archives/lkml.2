Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2LOE0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 23:26:18 -0500
Received: from [198.137.202.10] ([198.137.202.10]:54159 "EHLO mail.zytor.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2LOE0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 23:26:17 -0500
Message-ID: <50CBFBAC.3040001@zytor.com>
Date: Fri, 14 Dec 2012 20:25:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/uapi for 3.8
References: <201212122211.qBCMBRxl027895@terminus.zytor.com> <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com> <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
In-Reply-To: <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 05:16 PM, Linus Torvalds wrote:
> On Fri, Dec 14, 2012 at 3:45 PM, David Howells <dhowells@redhat.com> wrote:
>> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>> Yeah, I think I have most of the x86 stuff merged now (just merged the
>>> EFI and ACPI trees), and at this point it might be worth regenerating
>>> it and getting this over and done with.
>>
>> Okay, regenerated and pushed.
> 
> Ugh. This doesn't seem to work for me at all. It causes infinite
> scrolling of some text that I have no idea about.
> 
> I started bisecting (because I thought it might be something else and
> I hadn't booted after every pull), but by now the only thing I have
> left is ARM and a couple of tiny OF patches .. and the x86 UAPI split.
> 
> The split *should* have been safe, since it's mostly a "compile or
> not" thing like Peter said, but we had similar problems on other
> architectures, when things compiled but didn't actually work due to
> missing #define's and #ifdef handling. Things like
> architecture-specific macros that have default versions available when
> the macro is missing etc.
> 
> Now, maybe it's some of the other remaining commits after all, but
> from where I am in the bisection it really looks like the uapi patch
> is the most likely culprit. So I thought I'd let people know...
> 

Hmmm... I can't reproduce your failure.  Could you send me your config
and a hint about what hardware you're seeing this on?  That might help
chase this down.

Macs in particular are EFI machines, except they hide OF snippets inside
ACPI (I kid you not.)  All of that creates interesting cross-dependencies.

	-hpa


