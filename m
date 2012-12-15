Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab2LOBQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 20:16:43 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37707 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab2LOBQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 20:16:42 -0500
MIME-Version: 1.0
In-Reply-To: <21507.1355528749@warthog.procyon.org.uk>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Dec 2012 17:16:21 -0800
X-Google-Sender-Auth: UPztLHrwqBbean-AkZE6oZ8ne64
Message-ID: <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: David Howells <dhowells@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 3:45 PM, David Howells <dhowells@redhat.com> wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> Yeah, I think I have most of the x86 stuff merged now (just merged the
>> EFI and ACPI trees), and at this point it might be worth regenerating
>> it and getting this over and done with.
>
> Okay, regenerated and pushed.

Ugh. This doesn't seem to work for me at all. It causes infinite
scrolling of some text that I have no idea about.

I started bisecting (because I thought it might be something else and
I hadn't booted after every pull), but by now the only thing I have
left is ARM and a couple of tiny OF patches .. and the x86 UAPI split.

The split *should* have been safe, since it's mostly a "compile or
not" thing like Peter said, but we had similar problems on other
architectures, when things compiled but didn't actually work due to
missing #define's and #ifdef handling. Things like
architecture-specific macros that have default versions available when
the macro is missing etc.

Now, maybe it's some of the other remaining commits after all, but
from where I am in the bisection it really looks like the uapi patch
is the most likely culprit. So I thought I'd let people know...

            Linus
