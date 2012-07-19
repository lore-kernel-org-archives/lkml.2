Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2GSRHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:07:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42814 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2GSRHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120719164807.GD23393@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org> <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic> <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120714124332.GA4093@moon> <20120714174827.GA13319@aftab.osrc.amd.com>
 <20120719144217.GC16873@home.goodmis.org> <20120719164807.GD23393@aftab.osrc.amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Jul 2012 10:06:44 -0700
X-Google-Sender-Auth: 2YSQWDDVtrsVn_mN-ofI9Pv0uSY
Message-ID: <CA+55aFxX41pGnHcc17A=VBnW+03LEwkwATiZWObbPgD9Ap37Xg@mail.gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
To: Borislav Petkov <bp@amd64.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 9:48 AM, Borislav Petkov <bp@amd64.org> wrote:
>
> Seriously, this helps only in the cases where the stuff the distro
> actually needs is in modules. So, there probably are obscure situations
> where you need to enable stuff which is bool and not M.

Sadly, not obscure at all.

Most of the *drivers* are modules, but most of the "distro config"
options are indeed booleans (or, if tristate, =y).

Even driver-wise, there are some things that are often =y, even though
you generally don't want them. PCMCIA? Not even *laptops* have that
shit any more, but having built-in cardbus support almost certainly
helps in a distro kernel for booting of certain odder cases.

Xen support? Odd partition tables? All the different AGP versions?
Many of us couldn't care less, but again, it makes sense in the actual
distro kernel, even if it does *not* necessarily make sense in a
personalized one.

So doing "make allmodconfig" is certainly a workable thing (modulo the
modules that you need for stuff you hadn't happened to use), but it's
not wonderful.

I also hate having to enable support for modules. A non-modular build
is quicker to build and avoids some security issues. Some drivers
don't work well built-in (they load firmware etc too early), but imho
it's worth doing if you can, and it's something we should make easy
for people to do because of the security side (of course, per-build
randomly generated keys and signed modules with the keys deleted after
the build would be reasonably equivalent from a security standpoint,
but we're not there yet).

              Linus
