Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0HDCJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:09:14 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49684 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab0HDCJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:09:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kees Cook <kees.cook@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
In-Reply-To: Your message of "Tue, 03 Aug 2010 15:34:51 PDT."
             <20100803223451.GB4138@outflux.net>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802122421.GA12130@infradead.org> <20100802165936.GV3948@outflux.net> <15424.1280775073@localhost> <20100803165010.GG3948@outflux.net> <78690.1280871500@localhost>
            <20100803223451.GB4138@outflux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280887675_4030P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Aug 2010 22:07:55 -0400
Message-ID: <7184.1280887675@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4C58CB7C.0193,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280887675_4030P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Aug 2010 15:34:51 PDT, Kees Cook said:
> On Tue, Aug 03, 2010 at 05:38:20PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > The fact that a patch for one case has been used for years doesn't mean
> > that it's a well thought out fix for the general case.
> 
> Well, we clearly disagree on this point. :)

Actually, we do, because you yourself have stated that:

a) It's a patch for one case.
b) It's been around for 15 years.
c) It doesn't even try to address the general case.

So Yama is a special case that after years still doesn't cover the genera case
:)

> > - the point is that ad-hoc fixes for the low-hanging fruit isn't doing anybody
> > any favors.
> 
> This is the basis of our disagreement. Fixing it does do people a favor. At
> the very least, it does me a favor because now I don't have to publish
> security updates for an entire class of vulnerability.

Umm.. Tell you what.  I'll give you a chance to pretend you didn't
send that from a vendor e-mail address... :)

Do you *really* want to go on record as saying "We didn't ship a fix for
Frobozz 3.2 because The Kernel Would Stop The Obvious Exploit", when it's
usually quite possible that somebody can come up with a different exploit
scenario?  That's also going to go over *really* well with customers who end up
turning off Yama because it breaks some third-party app that's doing some
batshit crazy thing it shouldn't be doing in the first place.

> I think this is irrelevant; the symlink/hardlink combo fixes a
> vulnerability with DAC. It's a break in the DAC security model.

Actually, if you trace it through, in almost every single case of an exploit
abusing a symlink, at no time does the DAC model actually get violated. Every
single access *is* in fact done according to the DAC in effect. The problem is
that some of the accesses are not the ones the programmer intended the software
to make.

> Right, though my objection to all MACs is that they are on top of DAC, and
> that large portions of the Linux user base do not use a MAC, but they
> cannot avoid DAC. Since the symlink/hardlink issue is with DAC, it should
> be fixed there, not in a MAC layer above.

As pointed out above, it's *not* a DAC issue.  The abused program never
actually writes to anything that the DAC doesn't allow it to.

In fact, a moment's thought will show that in general, a DAC *cannot* by
definition actually secure a system - because the D stands for Discretionary.
And most of the abuses you're trying to stop are basically convincing a program
to abuse its discretionary choices. DAC is by definition "The user/program gets
to decide who gets what access, and we trust the user/program to take actions
that implement its decisions".  (Here is where you insert the clip from Indiana
Jones and the Last Crusade: "He chose... poorly").

That's DAC in a nutshell.  The break is *not* in DAC, because it was never
intended to defend against certain classes of threats (namely, programs that
can be accidentally tricked into do things they didn't intend to, but the
DAC says they can do).  The break is in your idea that DAC can actually
enforce security (which it can't - you need MAC for that).

> Right. But I'm trying to help protect people from their kid sister too.
> Unfortunately, the use-case is where it's both the kid sister admin with no
> MAC policy being attacked by the kid sister script kiddie with a symlink
> race exploit due to the kid sister programmer who wrote an application that
> uses a guessable /tmp file. 

> You're completely right that the PTRACE exception idea isn't perfect. It
> could be raced between the crasher's fork()/exec() and prctl(). There are
> probably more cases, but it sure is better than just letting everything
> PTRACE everything else.

> While waiting for smarter people than me make it impossible to exploit
> security vulnerabilities in the future, I want to make it harder for
> attackers to exploit security vulnerabilities now.

The sad part is that there are already known ways developed by smarter people.
You just refuse to consider them as solutions and keep trying to deploy stuff
that a sufficiently clever kid sister can bypass.

> Heh, well, I have a PTRACE model. :) "Only CAP_SYSADMIN can PTRACE_ATTACH."

That's not actually a full model. ;)

> Unfortunately, I'm stuck with these damned crash handlers which are really
> just hacks to avoid writing a core to disk. Oddly, this is a solved problem
> (via core dump patterns and distro-wide crash handlers) , but some
> applications want to opt out of it instead of providing proper system hooks
> to do crash analysis. Of course, with PTRACE still allowed, there's no
> carrot (or stick) to encourage application writers to use distro-provided
> crash handlers.

So do the obvious - ship with SELinux configured to not allow the arbitrary ptrace,
document it, and tell them "it doesn't work, use the proper system interface instead".

:)




--==_Exmh_1280887675_4030P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWMt7cC3lWbTT17ARAl6xAKDfCmGujkH/nNSXIX36L3iHOuvd4gCeKp2T
moqdpiFHLuOWghd++1Xmpvo=
=fpco
-----END PGP SIGNATURE-----

--==_Exmh_1280887675_4030P--

