Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0IDTLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 15:11:46 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34600 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0IDTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 15:11:45 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Ted Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: stable? quality assurance?
Date: Sat, 4 Sep 2010 21:11:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33-tp42-01231-g11b897c; KDE/4.4.5; i686; ; )
References: <201007110918.42120.Martin@lichtvoll.de> <201009041839.09261.Martin@lichtvoll.de> <20100904184611.GC4887@thunk.org> (sfid-20100904_205601_461929_71B6D5A7)
In-Reply-To: <20100904184611.GC4887@thunk.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1771521.9o0aSr4Zlh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009042111.41695.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1771521.9o0aSr4Zlh
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Samstag 04 September 2010 schrieb Ted Ts'o:
> On Sat, Sep 04, 2010 at 06:38:59PM +0200, Martin Steigerwald wrote:
> > During bisecting [Bug 16376] random - possibly Radeon DRM KMS related
> > freezes, which goes very slowly due to having lots of unbootable
> > kernels
>=20
> > with an ext4 / readahead related backtrace during boot, I had an idea:
> So I'm not sure what you're referring to here.  If there's an ext4
> bug, why haven't you reported it to the linux-ext4 list?  I've done a
> Google search for "Steigerwald ext4 readahead" and I can't find any
> bug report related to kernel oops that are ext4/readahead-related.
>=20
> No one else has reported such a bug to me, and I run a complete set of
> regression tests before I push ext4 changes to Linus.  So I'm not sure
> what you're seeing.  But complaining about it in passing on an e-mail
> without sending a formal bug report to the linux-ext4 mailing list is
> not likely to solve your problem...

Stop! I think we are misunderstanding.

Its a bug I stumpled across the bisecting process. Neither 2.6.33 or=20
2.6.34 are affected, but some kernels in between. As such I didn't think=20
its worth reporting the bug.

I made a photo of part of the backtrace tough, so if you want I open a bug=
=20
report about it nonetheless. But I really think it has been fixed during=20
the 2.6.33 to 2.6.34 development cycle.

=46or now I just skipped affected kernels in the bisection process in the=20
hope that none is the first last good or first bad one regarding the freeze=
=20
bug. Since for now it has all been kernels of a usb merge that showed this=
=20
issue, I don't think the freeze bug is in there.

Its from:

# skip: [124d255382ddd37ffa920e9f5183efa54bbfe4f2] USB: pl2303: remove=20
unnecessary reset of usb_device in urbs

to

# skip: [c68bb0d738897ed39b90c7ccb22e01c938117051] USB: cxacru: document=20
how to interact with the flash memory

I did not test booting every single of those >100 revisions, but got fed=20
up with this after the fifth non booting kernel or so. I didn't get why git=
=20
bisect insisted on taking me back to this range of commits - even in the=20
middle of two skips! - instead of just readjusting the binary search so=20
that that range is met later in the process. Cause then it might have not=20
met again at all. In the end I skipped every commit in this USB merge=20
manually. The ext4 readahead thing must have been introduced before that=20
merge and fixed somewhere after that merge. But I didn't find the comment=20
that might have fixed it from a quick glance.

I do not even know whether its ext4 related at all, but ext4 and readahead=
=20
has been in that backtrace.

So I just wanted to show that I am seriously working on tracking down that=
=20
likely radeon kms related freeze bug and that its time-consuming for me=20
due to having lots of unbootable kernels. I got another one of these with=20
"Destination address too large" before even InitRD seems to have done=20
anything. I skipped this one commit as well, and now git bisect seems to=20
have taken me to a good one again, lets see. At least it didn't freeze=20
prior up to now and I better press send now ;-). But from my bet on where=20
the offending commit might be, this should be a good one. I am learning a=20
lot on how to bisect a kernel right now ;).

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1771521.9o0aSr4Zlh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyCmeYACgkQmRvqrKWZhMdCLwCdE7ZecgXqnotk6iBgfEi9RO9Z
HqQAoI6c2fm8xoxriNbcCvhxCNWbsrCw
=/B3o
-----END PGP SIGNATURE-----

--nextPart1771521.9o0aSr4Zlh--
