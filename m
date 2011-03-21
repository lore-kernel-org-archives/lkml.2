Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1CUFxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 01:53:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56503 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab1CUFxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 01:53:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: X32 psABI status update
Date: Mon, 21 Mar 2011 01:53:08 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.37.3; KDE/4.6.0; x86_64; ; )
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com> <201103210108.49780.vapier@gentoo.org> <AANLkTikSJDGEWCqazvAKHUC8_MoOP-+vyFOjyCmrA9dL@mail.gmail.com>
In-Reply-To: <AANLkTikSJDGEWCqazvAKHUC8_MoOP-+vyFOjyCmrA9dL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2504859.ZcOd1GG08T";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103210153.10145.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2504859.ZcOd1GG08T
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Monday, March 21, 2011 01:35:35 H.J. Lu wrote:
> On Sun, Mar 20, 2011 at 10:08 PM, Mike Frysinger wrote:
> > On Thursday, March 17, 2011 01:21:16 H.J. Lu wrote:
> >> On Wed, Mar 16, 2011 at 7:57 PM, Mike Frysinger wrote:
> >> > in looking at the gcc files, it doesnt seem like there's any defines
> >> > setup to declare x32 directly.  instead, you'd have to do something
> >> > like: #ifdef __x86_64__
> >> > # if __SIZEOF_LONG__ =3D=3D 8
> >> > /* x86_64 */
> >> > # else
> >> > /* x32 */
> >> > # endif
> >> > #endif
> >> >=20
> >> > any plans on adding an __x32__ (or whatever) cpp symbol to keep peop=
le
> >> > from coming up with their own special/broken crap ?  or are there so=
me
> >> > already that i'm not seeing ?
> >>=20
> >> The idea is in most cases, you only need to check __x86_64__ since x32
> >> and x86-64 are very close.  In some cases, x32 is very different from
> >> x86_64, like assembly codes on long and pointer, you can check
> >> __x86_64__ and __LP64__. In glibc, I used a different approach by using
> >> macros REG_RAX, .., MOV_LP, ADD_LP, SUB_LP and CMP_LP in assembly
> >> codes.
> >=20
> > while i agree with you in general that this is how people should be doi=
ng
> > things, in practice i often see people fishing around.  education only
> > goes so far, so if there was an __x32__ define, i feel like people are
> > more likely to get it right than wrong.
> >=20
> > i dont have any use cases off the top of my head, but i wouldnt be
> > surprised if the heavy inline assembly people (like the multimedia peeps
> > e.g. libav) approached it this way.  rather than google for
> > documentation, look at the cpp output between -m64 and -mx32 and see
> > what sticks out.  "__x32__" would certainly do that.
>=20
> My point is __x86_64__ version should work for both 64bit and x32. There
> should no need for a separate x32 version.

yes, and my point is that people often reach for cpp defines rather than=20
figure out how to do it right.

i'm not saying that __x32__ should be defined in place of __x86_64__, just=
=20
that when -mx32 is used, __x32__ is additionally defined.  simply as an=20
example, what i'm referring to could be accomplished by adding this to the=
=20
*cpp specs:
	%{mx32:-D__x32__=3D1}
=2Dmike

--nextPart2504859.ZcOd1GG08T
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNhufGAAoJEEFjO5/oN/WBiWUP/28gXwWb2XkwNDXXbOiBJOwU
dUsEjb5lZWtEvpmUtRMgGIfO9L8pww8xkdjHg2GIuL49+UVYN84ZJLv11f81H1RY
Ht0JL7m0fonuuwD4Kc0I0FqNQRiMv+Bb0CLuXwhl/pkYQEmcp322H8L98f+1zuhv
D4uqv29FcC0wm0GYbko9lNqrmH/4emvsb8lCSMQY+9i3JUOcJMy2HAaK8DCmCyuq
7ZsT9wljBZD3b96N5Fe+IBAcNiQsP6+abE//US8HGk9i0d15NynEfenSP0c0U0B+
4hOeFt0fkmDcr+4DRv5DA7IifgKzMudisMcPIcd6vySV+ZetsZgNEt2Qt60GTZvm
CzDPhW5PfrtctEPKX2Qy5f0q/Y08I3pJS/IwNYyF0Fx2hmW+FzsXBqND7wwgnhDd
jApz5uaQzN9sqv8r9D909RYmyON0xDFCkQZoWIdDOcY+v5FZ1HgvmJCCveMZ0OMj
shfoz/nyU3OuWNaiuR6fQ98vwgM33wNOthcSgZi4UwaHp9rO347Kd08EUyIZRGUP
zzm16s4iEXgKlTAkWt9ehV89Fj1Rm8Te25L6MTSyfaPtMk3ySUqxcJBz94nGgtRj
MqPs5zD5dqNMcgsRdXukYCL2SV3XZ5wft7lTNQhVvOON1r14uVGCgCY8nCQlA5Z6
m4qRJHfG0L4QvZaGBrsE
=DzNf
-----END PGP SIGNATURE-----

--nextPart2504859.ZcOd1GG08T--
