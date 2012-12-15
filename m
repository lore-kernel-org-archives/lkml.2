Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2LOXhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 18:37:25 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51287 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2LOXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 18:37:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX=5=5-U3ix=LGJUOxFrbmYRG3h_qbe11t2Q-zE4pEV3A@mail.gmail.com>
References: <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4> <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
 <50CCD24F.9090603@zytor.com> <CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com>
 <20121215210411.GA228@x4> <CA+55aFznbC_FHyfGWaD6e6wNE88CiAYaPwjerBh1HfBpfPfNsg@mail.gmail.com>
 <CAE9FiQX=5=5-U3ix=LGJUOxFrbmYRG3h_qbe11t2Q-zE4pEV3A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Dec 2012 15:37:02 -0800
X-Google-Sender-Auth: DXl-e0osG6pJcv2rwAfvFtrd97Q
Message-ID: <CA+55aFwxtt2Rs7dJt_icCsH5QUzrV_UaATQ3aJQY2KGH+anc3A@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: Yinghai Lu <yinghai@kernel.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@suse.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 2:05 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Dec 15, 2012 at 1:06 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> I've reverted the commit.
>
> more than that, 3 commits just after that commit should be reverted at
> the same time.
> they all depend on that commit.

Thanks for pointing that out, and just to make sure I verified that on
my Macbook Air which does use EFI. It was broken by the single revert,
and fixed by the additional three reverts.

Sadly:

> and first checking of that commit, it would have problem with system
> more than 512g ...

That particular bug isn't the cause for my non-EFI problems, since I
don't have that kind of memory..

So there is something else going on in addition to the bug you found.
But good eye.

Anybody see anything else?

And why do we have to call the get-time calls so early? Couldn't we
move them later and avoid all the crazy "let's create silly magical
page tables just for the idiotic EFI problems".

And while I'm asking, why the f*ck did Intel do that crazy EFI thing
in the first place again?

              Linus
