Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab2LOWFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 17:05:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38249 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2LOWFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 17:05:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFznbC_FHyfGWaD6e6wNE88CiAYaPwjerBh1HfBpfPfNsg@mail.gmail.com>
References: <23916.1355356085@warthog.procyon.org.uk>
	<CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
	<21507.1355528749@warthog.procyon.org.uk>
	<CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
	<CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
	<CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
	<20121215163323.GA229@x4>
	<CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
	<50CCD24F.9090603@zytor.com>
	<CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com>
	<20121215210411.GA228@x4>
	<CA+55aFznbC_FHyfGWaD6e6wNE88CiAYaPwjerBh1HfBpfPfNsg@mail.gmail.com>
Date: Sat, 15 Dec 2012 14:05:29 -0800
X-Google-Sender-Auth: VMxgeZpZyuhm7vQetNVBEcb-cFw
Message-ID: <CAE9FiQX=5=5-U3ix=LGJUOxFrbmYRG3h_qbe11t2Q-zE4pEV3A@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
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

On Sat, Dec 15, 2012 at 1:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Dec 15, 2012 at 1:04 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
>>
>> So I wonder if the following simple patch might be enough?
>> It fixes the issue for me at least.
>
> Not enough.
>
> It presumably fixes the issue for you by hiding the problem. But if
> you were to boot a kernel with EFI support, it would re-surface.
> Including in any distro kernel that obviously will include EFI support
> in order to handle the generic case.
>
> I've reverted the commit.

more than that, 3 commits just after that commit should be reverted at
the same time.
they all depend on that commit.

and first checking of that commit, it would have problem with system
more than 512g ...

static int insert_identity_mapping(resource_size_t paddr, unsigned long vaddr,
                                   unsigned long size)
...
     pgd_t *vpgd, *ppgd;
     ppgd = __va(real_mode_header->trampoline_pgd) + pgd_index(paddr);

it missed one . we should use

    ppgd = (pgd_t *)__va(real_mode_header->trampoline_pgd) + pgd_index(paddr);

Yinghai
