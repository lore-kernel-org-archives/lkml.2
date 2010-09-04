Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab0IDTdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 15:33:32 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41296 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0IDTdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 15:33:31 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: stable? quality assurance?
Date: Sat, 4 Sep 2010 21:33:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33-tp42-01231-g11b897c; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201009041842.19968.Martin@lichtvoll.de> <20100904172201.GM25062@1wt.eu> (sfid-20100904_192739_374896_FBD313AF)
In-Reply-To: <20100904172201.GM25062@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1939531.gVDzi50szd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009042133.28709.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1939531.gVDzi50szd
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hi again,

Am Samstag 04 September 2010 schrieb Willy Tarreau:
> On Sat, Sep 04, 2010 at 06:42:19PM +0200, Martin Steigerwald wrote:
> (...)
>=20
> > The main idea here is to have a two-staged freeze process and to
> > distribute the "I am only taking bug fixes" work to more people than
> > Linus.
> >=20
> > For this to work properly, I think at the time of the release of the
> > stable kernel subsystem maintainers and Andrew should branch their
> > trees. For example when 2.6.36 is released:
> >=20
> > - tree
> >=20
> >   =3D> 2.6.36-stable-tree
> >   =3D> tree, where 2.6.37 stuff will be going in
> >=20
> > Thus when subsystem maintainers take new stuff during the merge
> > window, it will be for the next kernel release already, not for the
> > current one. Except bugfix work. Whereas I think the criteria for
> > bug fix work should not be that strict than for the stable patches
> > Greg collects.
> >=20
> > Thus it needs to be clear: No new stuff for next kernel already two
> > weeks prior to release the current stable kernel.
>=20
> While I respect your beliefs on this matter (they once were mine too),
> I now realized I was wrong for several reasons :
>   - most developers want to create. They (generally) test what they
> create, they believe it's flawless because it works for them. No need
> for more testing, go on with new features ; if you refuse to merge
> their new work for some time, they work on their own tree and push you
> more work at once next time.
>=20
>   - developers need real world use cases. That means more testers.
> Developers are bad testers because they don't trigger the unexpected
> use cases. And how do you get good testers ? by motivating end users
> to test your code. Most testers will only test a new kernel to get a
> new feature. If it works for them, no need to push the tests further.
> So that means that the first RCs are the most tested, and that the
> later ones are the least tested. Thus at one point you can't hope to
> get bug reports anymore. When you see an -rc7 or -rc8, you think "hey,
> -rc4 was OK, let's wait for -final and install it".

That fits perfectly well. If the first rcs are nicely testing, then ideally=
=20
all major issues should be done, when rc7 or rc8 are reached. And thus=20
time can be spent on fixing the major remaining open regression. I guess=20
those who reported these regression are interested in testing a fix.

=46or me features have been number one reason to upgrade kernels as well,=20
but then its not a yes or no decision, but more a tuning on how much new=20
feature stuff each stable kernel release should have and a way to put a=20
little bit more attention to making a stable kernel release stable.

>   - people concerned by stability don't test every release. They test
> when they can, precisely because they can't impact production. So they
> don't contribute bug reports in time. And as the 2.4 maintainer, I'm
> well aware of that, because when I break something, I only know about
> it 3-4 months later.

How does this affect my suggestion above? If as you say the first rcs are=20
tested better and if as I assume those who reported regressions have an=20
interest in testing their fixes, I think this can work out nicely.

Aside from that, I am not sure whether most people step in with rc1 or rc2=
=20
already. When I tested rc kernels - there have been some times - I usually=
=20
waited to rc3 or rc4 so I could be somewhat confident that really major=20
issues are fixed already.

> For this reason, I think the release rhythm can't much be changed.

I still object that for above given reasons. And cause I think that if=20
something does not work out perfectly it still can be improved. But I am=20
interested in your other suggestions as well, cause maybe its not so much=20
the release process but something else the issue here:

> I think that trying to evaluate and publish quality per developer or
> maintainer can have a better effect because everyone in the commit
> chain is responsible. But even doing that is hard because some changes
> touch everything and it's not obvious to say that Mr X or Y has done
> some crap.

And who judges on what is crap? Build failures could be tracked=20
automatically. Partly maybe even performance regression as the automated=20
tests from Phoronix show. Well boot failures or freezes are even more=20
important. But then, you are probably not judging the quality of the work=20
of the developer but the difficulty of the area he works on.

Nix pointed out that programming ATI Radeon cards can be quite=20
challenging. And I do have lots of respect for the Radeon KMS related=20
work. So I think it would be unfair to point at one of the Radeon KMS=20
developers and say to him "you did crap" for example.

I think crap does happen and am more concerned about how to handle it when=
=20
it does.

> In my opinion, reporting bugs is the most effective way of improving
> quality. If you report 10 bugs in a week on the same driver, there are
> chances that at one point this driver's author will want to take some
> time to audit his code and find other bugs before you next point your
> finger at him/her. As you see, the goal is not just to report bugs to
> get them fixed, but to educate bug authors.

Okay, my contribution then: I report bugs. I reported 4-5 kernels bugs in=20
the last time. I reported some before, but only occassionally. I didn't=20
face that many bugs prior to 2.6.34 which contributed to my admittedly=20
very subjective impression that kernel quality has lowered.

> I can tell you that I am an author of quite a number of bugs in another
> project (haproxy), and I absolutely hate it when a bug is detected in
> production (especially given the product's goal), to the point that the
> code is generally reworked 2, 3, 5, 10 times before being committed. Of
> course it is still not enough to catch all bugs, but since the product
> has got a widely accepted reputation of being rock solid, I think it
> works quite well afterall.

Interesting project, I am implementing a highly available active/passive=20
loadbalancer cluster using Corosync, Pacemaker and the IPVS frontend=20
Ldirectord at the moment currently at work.

> Last, developers must not betray their users' trust. When they're not
> certain of their code, this must be advertised (this is often the case
> but not always). That helps a lot end users select only reliable
> features and experience more stability.

Well for me a balance must be met: A kernel has to work good enough for me=
=20
to use it regularily. And currently 2.6.34 upto 2.6.36-rc2 on my ThinkPad=20
T42 simply do not fulfil that criterium. What annoys me most: Radeon KMS=20
already works perfectly stable on 2.6.33 for me. So the issue was not in=20
the initial version of Radeon KMS. It has been introduced afterwards. Thus=
=20
a supposedly more matured and stable version of it is working less stable=20
for me.

2.6.33-tp42-01231-g11b897c has been good to me so far. I am glad it had=20
not frozen yet. I better press send now.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1939531.gVDzi50szd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyCnwgACgkQmRvqrKWZhMduogCfWfA4okA0XDhlHtzgx4xp2OeM
T2wAn3XBZMqp2SDmwkwJuMZehA6aH2kx
=boKR
-----END PGP SIGNATURE-----

--nextPart1939531.gVDzi50szd--
