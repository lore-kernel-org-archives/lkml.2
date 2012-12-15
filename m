Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab2LOSfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 13:35:36 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42854 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2LOSff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 13:35:35 -0500
MIME-Version: 1.0
In-Reply-To: <20121215163323.GA229@x4>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com> <20121215163323.GA229@x4>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Dec 2012 10:35:13 -0800
X-Google-Sender-Auth: DuWPgLJsYODFaqWTtgARUPHU6HI
Message-ID: <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jan Beulich <jbeulich@suse.com>, Matt Fleming <matt.fleming@intel.com>
Cc: David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 8:33 AM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2012.12.14 at 17:47 -0800, Linus Torvalds wrote:
>>
>> Ho humm. Anybody else see anything strange?
>
> Yes. I'm seeing a BUG early during boot on my machine (RIP=NULL):
>
>  BUG: unable to handle kernel NULL pointer dereference at           (null)
>
> This is caused by commit 53b87cf088e2 ("x86, mm: Include the
> entire kernel memory map in trampoline_pgd")

Hmm. That reverts cleanly, and the result boots fine for me. And the
commit looks like exactly the kind of thing that could result in
problems with exactly the right memory layout, so it could explain why
the bisect failed and some kernels randomly worked for me and others
didn't.

So this at least looks like a very possible candidate.

Does anybody have an explanation for the problem?

Btw. the machine in question does not have EFI, and is a bog-standard
PC (DMI string: "P7H57D-V EVO, BIOS 0999 01/19/2010")

Matt? Jan?

                    Linus
