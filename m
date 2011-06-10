Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1FJDh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:37:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547Ab1FJDhz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>
References: <20110609214241.GA4849@sepie.suse.cz> <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
 <BANLkTi=qaA_AMvq_78eon3Lr86wT2R497g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jun 2011 20:37:32 -0700
Message-ID: <BANLkTinbXpFp43+EebWbWvs1Uu5wWvhxQQ@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, pefoley2@verizon.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 8:14 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>
> any chance to share your .config ? x86-64's defconfig, plus Michal
> branch merged on top of the tip of your tree, plus the following patch
> removing the SUBLEVEL:
>
> diff --git a/Makefile b/Makefile
> index 72c0e32..5c75864 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,6 +1,6 @@
>  VERSION = 3
>  PATCHLEVEL = 0
> -SUBLEVEL = 0
> +SUBLEVEL =
>  EXTRAVERSION = -rc2
>  NAME = Sneaky Weasel
>
> install is fine for me. What bugs me is that "git grep '\.temp'" in
> that tree does not return anything relevant.

"make install" just runs the distro install script, usually
/sbin/installkernel, which at least on F-14 will then run
/sbin/new-kernel-pkg /sbin/dracut to build the initrd etc.

And that runs "depmod", which seems to end up being confused: we give
it the new kernel version as an argument, but it seems to not like it,
so it decides to do "uname()" to get the _current_ kernel version
instead, and that is where the confusion comes from.

If it works for you, I suspect you're running a different distribution.

                  Linus
