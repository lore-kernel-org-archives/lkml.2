Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab0GLPoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:44:11 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35975 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0GLPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:44:09 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Date: Mon, 12 Jul 2010 17:43:56 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34.1-tp42-toi-3.1.1.1-04990-g3a7d1f4; KDE/4.4.4; i686; ; )
Cc: Willy Tarreau <w@1wt.eu>
References: <201007110918.42120.Martin@lichtvoll.de> <201007111651.42963.Martin@lichtvoll.de> <20100711172252.GA3379@1wt.eu> (sfid-20100711_193037_169001_8F8BE25C)
In-Reply-To: <20100711172252.GA3379@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3345607.fSTufF7NeY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007121744.05844.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3345607.fSTufF7NeY
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Sonntag 11 Juli 2010 schrieb Willy Tarreau:
> Hi Martin,

Hi Willy,
=20
> On Sun, Jul 11, 2010 at 04:51:42PM +0200, Martin Steigerwald wrote:
> > I hope that someone answers who actually can take some critique. From
> > the current replies I perceive a lack of that ability.
>=20
> well, I'll try to do then :-)
>=20
> There were some threads in the past about kernel releases quality,
> where Linus explained why it could not be completely black or white.
>=20
> Among the things he explained, I remember that one of primary concern
> was the inability to slow down development. I mean, if he waits 2 more
> weeks for things to stabilize, then there will be two more weeks of
> crap^H^H^H^Hdevelopment merged in next merge window, so in fact this
> will just shift dates and not quality.

Would it make that much of a difference? Linus could still say no to=20
obvious crap, couldn't he?

> There are also some regressions that get merged with every pre-release.
> Thus, assuming he would wait for one more pre-release to merge the
> fixes you spotted, 2 or 3 more would appear, so there's a point where
> it must be decided when to release.

Some sort of classifying bugs could help here I think. Something that=20
helps Linus to decide whether it is worth to do another release candidate=20
round or not.

Actually I think the USB soundcard not working after resume bug I=20
mentioned (bug #15788) wouldn't warrant a new release candidate round,=20
especially as it didn't have a patch yet and will likely just affect a=20
minority of users. Still it would be fine if it was fixed in time. I do=20
think that the Radeon KMS does not work after resume bug (#15969) does=20
qualify since it causes loss of data handled by the current X session(s) -=
=20
sure I normally save my stuff before hibernating, but... And it actually=20
had a patch that has been tested! The desktop freeze bug I mentioned would=
=20
slip, cause I didn't report it and except from a debian bug report I found=
=20
it wasn't confirmed at all. An reported and confirmed desktop freeze would=
=20
qualify IMHO.

Actually I read postings from Linus that he actually reads the regression=20
list kindly provided by Rafael. 15788 was in there, but IMHO wouldn't=20
qualify (see posting "2.6.34-rc5: Reported regressions from 2.6.33"). But=20
15969 was not - well it was reported for rc7, so too late for the manual=20
report by Rafael. So yes, I see how it can have slipped.

Maybe an approach would be to dynamically generate the list from all bug=20
reports marked for 2.6.34 versions and have it posted to kernel mailing=20
list after every rc. This way bug #15969 would at least have been in the=20
list of known regressions.

Bugzilla severity and priority fields or something similar could be used to=
=20
set the importance of a bug report and the regression list could be sorted=
=20
by importance. One important criterion also would be whether someone could=
=20
confirm it, reproduce it. Even when I reported those desktop freezes,=20
unless someone confirmed them it might just happen for me. Well a "confirm"=
=20
or vote button might be good, so that the amount of confirmations could be=
=20
counted.=20

It would need some triaging and classifying and I am willing to help with=20
that.

> Right now it's released when he feels it "good enough". This can be
> very subjective, but I'd think that "good enough" basically means
> that the kernel will be able to live in its stable branch without
> major changes and without reverting features.

Okay, then thats two different definitions of stable. I mean stable enough=
=20
for (adventurous) end users. And here its more of a development point of=20
view.
=20
> Also, you have to consider that there are several types of users.
> Some of them are developers who will run a latest -git kernel at
> some point. Some of them will be enthousiasts waiting for a feature,
> and who will run every -rc kernel once the feature is merged, to
> ensure it does not break before the release. There are also janitors
> and the curious ones who'll basically run a few of the last -rc as
> time permits to see if they can spot a few last-minute issues before
> the release. There are the brave ones who systematically download
> the dot-0 release once Linus announces it and will proudly run it
> to show their friends who it's better than the last one. There are
> those who need a bit of stability (eg: professional laptop or home
> server) and will prefer to wait for a few stable releases to ensure
> they won't waste their time on a big stupid issue that all other ones
> above will have immediately spotted for them. And there are the ones
> who run production servers who will either use distro kernels of
> long term stable kernels, with a more or less long qualification
> process between upgrades.

Yes, stable enough for whom? I see.

> It's just an ecosystem where you have to find your place. From your
> description, I think you're before the last ones above, you need
> something which works, eventhough it's not critical, so you could
> very well wait for 2-3 stable updates before upgrading (that does
> not prevent you from testing earlier on other systems if you want
> to test performance, new features, regressions, etc...).

ACK.

> It's not really advisable to call dot-0 releases "unstable" because
> it will only result in shifting the adoption point between the user
> classes above. We need to have enthousiasts who proudly say "hey
> look, dot-0 and it's already rock solid". We've all seen some of them
> and they're the ones who help reporting issues that get fixed in the
> next stable release.

I do think the claim should be honest. "stable" IMHO is not, at least from=
=20
a user's point of view. "unstable" isn't either, cause a dot-0 kernel is=20
not guarenteed to be unstable ;). So I agree with the major release kernel=
=20
approach from Rafael.

> I think that the most reasonable thing to do is to assume your need
> for stability and always refrain from running on the latest release.
>=20
> Speaking for myself, I tend to run rock solid kernels for my data (my
[...]
> You see, there's a kernel for everyone, and for every usage. You just
> have to make your choice. And when you don't know or don't want to
> guess, stick to the distro's kernel.

Yes. As told already I will rebalance my decision on which kernel to use.=20
And I now better understand some of the problems. Thanks.

But beyond that, I do think its worth thinking about ways to improve the=20
process of ensuring as much stability as sensibly possible. A dot-0 kernel=
=20
won't be error-free - but I find just claiming the current process as "the=
=20
best we can have" not actually satisfying. And I do think it can be=20
improved upon. I do not do kernel development, but I am willing to help=20
with collecting information about the current state of the kernel, help=20
with bug triaging as good as I can and manage to take time. I do have some=
=20
experience with quality management as I coordinated the betatest of some=20
AmigaOS versions,  but then this has been in a closed group. Here its a=20
different scale and I believe it needs somewhat different approaches.

I reply to other posts in that thread later in the next days.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3345607.fSTufF7NeY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw7OD0ACgkQmRvqrKWZhMfjvQCfRBm6lfJkJBBmiye6Qyk3XjB/
a7cAn2YTwraXjQ+Bw3lrlqHQyMF6Xnxb
=conZ
-----END PGP SIGNATURE-----

--nextPart3345607.fSTufF7NeY--
