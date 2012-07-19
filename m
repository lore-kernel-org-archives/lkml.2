Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2GSSxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 14:53:10 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32507 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2GSSxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 14:53:07 -0400
Date: Thu, 19 Jul 2012 14:42:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20120719184249.GA6696@phenom.dumpdata.com>
References: <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120714124332.GA4093@moon>
 <20120714174827.GA13319@aftab.osrc.amd.com>
 <20120719144217.GC16873@home.goodmis.org>
 <20120719164807.GD23393@aftab.osrc.amd.com>
 <CA+55aFxX41pGnHcc17A=VBnW+03LEwkwATiZWObbPgD9Ap37Xg@mail.gmail.com>
 <20120719175310.GF23393@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719175310.GF23393@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 07:53:10PM +0200, Borislav Petkov wrote:
> On Thu, Jul 19, 2012 at 10:06:44AM -0700, Linus Torvalds wrote:
> > On Thu, Jul 19, 2012 at 9:48 AM, Borislav Petkov <bp@amd64.org> wrote:
> > >
> > > Seriously, this helps only in the cases where the stuff the distro
> > > actually needs is in modules. So, there probably are obscure situations
> > > where you need to enable stuff which is bool and not M.
> > 
> > Sadly, not obscure at all.
> > 
> > Most of the *drivers* are modules, but most of the "distro config"
> > options are indeed booleans (or, if tristate, =y).
> > 
> > Even driver-wise, there are some things that are often =y, even though
> > you generally don't want them.
> 
> Tell me about it. I'm always pissed off when someone thinks his stuff is
> very important and sets his sacred option to be =y/=m by default so the
> wider audience can at least compile-test it while the majority of the
> machines don't actually need it.
> 
> A more coarse-grained config where most of the stuff is off by default
> could take care of that probably.
> 
> > PCMCIA? Not even *laptops* have that shit any more, but having
> > built-in cardbus support almost certainly helps in a distro kernel for
> > booting of certain odder cases.
> 
> Yeah, distros need the one-size-fits-all thing so they have to enable
> *everything*.
> 
> > Xen support? Odd partition tables? All the different AGP versions?
> > Many of us couldn't care less, but again, it makes sense in the actual
> > distro kernel, even if it does *not* necessarily make sense in a
> > personalized one.
> 
> Yep.

I proposed something that would solve some of this - but not during
compile time but rather during boot-time
[http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-June/000099.html]
(interestingly enough hpa was first to propose it 10 years ago :-)

The goal is turn built-in components in well, unloadable components.
That way you won't have at least that much stuff laying around not being
used. Not the full silver bullet, but at least it gets some of this
stuff out of the way and you don't have to worry about the extra
stuff that was built-in.
