Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945923Ab2LOBmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 20:42:10 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60038 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2LOBmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 20:42:08 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Dec 2012 17:41:47 -0800
X-Google-Sender-Auth: CyxeH4HQdJ0RECsE0xUFWEaQOmc
Message-ID: <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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

I was wrong. It's not the x86 UAPI split, it's the DT pull. More people added.

Grant and Guennadi - it looks like some nasty memory corruption,
because now it didn't cause infinite scrolling, now it caused an oops
in unmap_single_vma() during exit_vmas(). In udevd. Followed by a
hang. I don't know *which* commit it is yet, but commit 4939e27d46fe
("Merge tag 'devicetree-for-linus' ...") is bad, and the previous
merge (the ARM mvebu one is fine).

I'll bisect to the commit, but wanted to let David off the hook, and
put the DT people on the hook. Maybe it's some odd merge artifact,
although I don't think that one had any conflicts at all.

             Linus

On Fri, Dec 14, 2012 at 5:16 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
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
>             Linus
