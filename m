Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2AIB3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:29:42 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57725 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab2AIB3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:29:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvwJWrSRSNxHE620XZkc4w0ayzeqqxZOR1efkh1V+VBO1w@mail.gmail.com>
References: <1326055714.13595.309.camel@deadeye> <CA+55aFwwnJPpVY++Vgr6p3s47YjdYWV3sgLZzvCtiJp6DEu78Q@mail.gmail.com>
 <CAFLxGvwJWrSRSNxHE620XZkc4w0ayzeqqxZOR1efkh1V+VBO1w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 17:29:18 -0800
X-Google-Sender-Auth: kGn7v-JswOSMH321XN8qmD2PYCI
Message-ID: <CA+55aFwVnLE-DLRzS8G=8NxQZjF5M_O4kgrPoX+AOOEH-OZgog@mail.gmail.com>
Subject: Re: [PATCH 1/2] topology: Check for missing CPU devices
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 5:06 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Mon, Jan 9, 2012 at 1:18 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Ok, both of the patches look sane to me, but it would really be nice
>> to hear from somebody with the actual affected architectures, and get
>> a tested-by.
>
> UML is affected:
> https://lkml.org/lkml/2012/1/8/186
>
> I wasted an hour finding out why it is crashing.
> Instead of testing kernels I really should read more LKML. ;-)

Hmm.

Ben - how about that

  static DEFINE_PER_CPU(struct cpu, cpu_devices);

approach that Richard uses in his patch, instead of the kcalloc? And
clearly UM should also do that CONFIG_GENERIC_CPU_DEVICES thing with
your patch.

Richard - does Ben's patch work for  you too if you just add "select
GENERIC_CPU_DEVICES" in the UM Kconfig too (Kconfig.common, probably)?

                      Linus
