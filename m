Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2BCTfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:35:10 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33272 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab2BCTfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:35:08 -0500
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 03 Feb 2012 21:34:53 +0200
In-Reply-To: <20120203170825.GX23916@ZenIV.linux.org.uk>
References: <m14nvc82jo.fsf@fess.ebiederm.org>
	 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
	 <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org>
	 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
	 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
	 <20120202012258.GQ23916@ZenIV.linux.org.uk>
	 <20120202212400.GR23916@ZenIV.linux.org.uk>
	 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
	 <20120203011612.GS23916@ZenIV.linux.org.uk>
	 <20120203170825.GX23916@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-FmJcqI7s6gvcKZl2wtZH"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1328297704.2107.3.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FmJcqI7s6gvcKZl2wtZH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-03 at 17:08 +0000, Al Viro wrote:
> On Fri, Feb 03, 2012 at 01:16:12AM +0000, Al Viro wrote:
>=20
> > 	* ubifs, hfsplus, jffs2 - definitely broken if you create enough
> > links.  i_nlink wraparound to zero, confused inode eviction logics.
>=20
> BTW, ubifs plays funny games with i_nlink - decrements it early in
> unlink/rmdir/rename and then increments it back on failure.  *If*
> we really want it that way, we need to use set_nlink() there.  Frankly,
> I'd rather deal with drop_nlink() after the last possible failure
> exit...  Unless there are serious reasons why that wouldn't work, that is=
.

There was a good reason for those games. I cannot provide a good
explanation right now because I need to refresh my memory (but I am sure
there must be a big comment in the code about this) and my daughter is
getting upset already because I am typing something instead of playing
with her. Will try to answer on Monday. Have a nice weekend!

--=20
Best Regards,
Artem Bityutskiy

--=-FmJcqI7s6gvcKZl2wtZH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPLDbeAAoJEJtuLFy+q7femfgH/2ZFbUXY/BKJ3QjnwdZpsEu9
MICacIp6S/55aq1k66LLyxwGTQwG+eJgeybizo2nlmnOxNCswewweeFjBkyX3uaY
1aAd/+UpctQ4FcXjusvU/SwSo8JzwC1qwQsxqfam4qU7m+mRoXrr2qtrSSDulZ3E
IyqodlvmmNUlvp2erZLMVbcuMlvKBwN93hZupKJ0G2tajJQR/SfXquZFc1siRfYX
E7Jo1EyMPYnhCwZEh4V8r+Nc+PM/N1W0LWHXZX+2vFFyrMuOgh5wl8QXB1Km7SdH
W9syAiwg/as8sMr+Xb80AU9m3Z+ABdQNmJlDSlDII2GyWmoiFClAtfjqXJ5g1Mw=
=d8Z1
-----END PGP SIGNATURE-----

--=-FmJcqI7s6gvcKZl2wtZH--

