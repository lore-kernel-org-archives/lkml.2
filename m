Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2GSRxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:53:17 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39897 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2GSRxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:53:14 -0400
Date: Thu, 19 Jul 2012 19:53:10 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120719175310.GF23393@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120714124332.GA4093@moon>
 <20120714174827.GA13319@aftab.osrc.amd.com>
 <20120719144217.GC16873@home.goodmis.org>
 <20120719164807.GD23393@aftab.osrc.amd.com>
 <CA+55aFxX41pGnHcc17A=VBnW+03LEwkwATiZWObbPgD9Ap37Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxX41pGnHcc17A=VBnW+03LEwkwATiZWObbPgD9Ap37Xg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 10:06:44AM -0700, Linus Torvalds wrote:
> On Thu, Jul 19, 2012 at 9:48 AM, Borislav Petkov <bp@amd64.org> wrote:
> >
> > Seriously, this helps only in the cases where the stuff the distro
> > actually needs is in modules. So, there probably are obscure situations
> > where you need to enable stuff which is bool and not M.
> 
> Sadly, not obscure at all.
> 
> Most of the *drivers* are modules, but most of the "distro config"
> options are indeed booleans (or, if tristate, =y).
> 
> Even driver-wise, there are some things that are often =y, even though
> you generally don't want them.

Tell me about it. I'm always pissed off when someone thinks his stuff is
very important and sets his sacred option to be =y/=m by default so the
wider audience can at least compile-test it while the majority of the
machines don't actually need it.

A more coarse-grained config where most of the stuff is off by default
could take care of that probably.

> PCMCIA? Not even *laptops* have that shit any more, but having
> built-in cardbus support almost certainly helps in a distro kernel for
> booting of certain odder cases.

Yeah, distros need the one-size-fits-all thing so they have to enable
*everything*.

> Xen support? Odd partition tables? All the different AGP versions?
> Many of us couldn't care less, but again, it makes sense in the actual
> distro kernel, even if it does *not* necessarily make sense in a
> personalized one.

Yep.

> So doing "make allmodconfig" is certainly a workable thing (modulo the
> modules that you need for stuff you hadn't happened to use), but it's
> not wonderful.

Oh and I always aim to build distro kernels on a big machine -
allmodconfig build is no fun on a tiny laptop. So would it be better
to have better profiled kernels, obviating the need for an almost full
build? Hell yeah!

> I also hate having to enable support for modules. A non-modular build
> is quicker to build and avoids some security issues. Some drivers
> don't work well built-in (they load firmware etc too early), but imho
> it's worth doing if you can, and it's something we should make easy
> for people to do because of the security side (of course, per-build
> randomly generated keys and signed modules with the keys deleted after
> the build would be reasonably equivalent from a security standpoint,
> but we're not there yet).

Agreed.

So there are some not-so-obscure situations, judging by your examples
above. Ho-humm.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
