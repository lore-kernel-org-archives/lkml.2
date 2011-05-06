Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab1EFS4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:56:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36099 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab1EFS4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OB/J52aY6hu0ymKSOkcZW7mioY0xh4La6BBKfWY1rsArt4IkTqVsCj7kn268xcLGsW
         KNOWu72qpYn4SFFMIhqlPsO5e4djTQenaZZ4bY9Al0DW7wmdhh4QZbdefcaUs9bUFxmG
         4Q6hVIKinu5TOGIBcrOhz80fepF10YCr+47z8=
MIME-Version: 1.0
In-Reply-To: <m38vuk9qzf.fsf@linux-m68k.org>
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
	<201105050824.34056.arnd@arndb.de>
	<alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
	<201105052237.11656.arnd@arndb.de>
	<BANLkTinqouGVWH8CmfM038TKFvhpJEczUQ@mail.gmail.com>
	<m38vuk9qzf.fsf@linux-m68k.org>
Date: Fri, 6 May 2011 20:56:12 +0200
X-Google-Sender-Auth: 4JZPLP9D6AUZpfqjTnIyCwUIUM0
Message-ID: <BANLkTimreydRXQBURdxgZLxaa1XhUk5oOA@mail.gmail.com>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 10:24, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> BTW, we have a hole at 218/219. I don't remember why, but it may have been
>> a placeholder for pselect6 and ppoll when that implementation was still in flux.
>> Couldn't find anything about it in git/cvs archives, so I'll check
>> have to check my
>> old mailing list archives...
>
> Probably it originated from the time when it was still deemed useful to
> keep the numbers in sync with the x86 ones.  The hole is filled with

Found it. Originally we kept the numbers in sync with i386.
For 217/218/219 there was a brief period of overlap of up to 3 different
syscalls for the same number: pivot_root, mincore, madvise, timer_* (which
got accepted later), and sys_setenviron/sys_setarguments (which never
got accepted). So we kept the boat of, and never filled the
conflicting gap (except with pivot_root some time later), and lost
compatibility with i386
numbers from then on.

> mincore and madvice there (pselect6 and ppoll came much later).

Yep. pselect6 and ppoll were introduced in many archs in two steps (a
syscall number reservation and an actual hook up), because they need
TIF_RESTORE_SIGMASK. As m68k only got TIF_RESTORE_SIGMASK
last year, we never completed the second step.

Will fix.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
