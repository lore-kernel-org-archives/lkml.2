Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1CUFIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 01:08:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51573 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab1CUFIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 01:08:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: X32 psABI status update
Date: Mon, 21 Mar 2011 01:08:48 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.37.3; KDE/4.6.0; x86_64; ; )
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com> <201103162257.10440.vapier@gentoo.org> <AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
In-Reply-To: <AANLkTikfiVvxrxakH-_pch6v0jkT1yZstw4kXShyx+Sd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10409012.WX68hfceO8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103210108.49780.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10409012.WX68hfceO8
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday, March 17, 2011 01:21:16 H.J. Lu wrote:
> On Wed, Mar 16, 2011 at 7:57 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> > in looking at the gcc files, it doesnt seem like there's any defines
> > setup to declare x32 directly.  instead, you'd have to do something
> > like: #ifdef __x86_64__
> > # if __SIZEOF_LONG__ =3D=3D 8
> > /* x86_64 */
> > # else
> > /* x32 */
> > # endif
> > #endif
> >=20
> > any plans on adding an __x32__ (or whatever) cpp symbol to keep people
> > from coming up with their own special/broken crap ?  or are there some
> > already that i'm not seeing ?
>=20
> The idea is in most cases, you only need to check __x86_64__ since x32 and
> x86-64 are very close.  In some cases, x32 is very different from x86_64,
> like assembly codes on long and pointer, you can check __x86_64__ and
> __LP64__. In glibc, I used a different approach by using macros REG_RAX,
> .., MOV_LP, ADD_LP, SUB_LP and CMP_LP in assembly codes.

while i agree with you in general that this is how people should be doing=20
things, in practice i often see people fishing around.  education only goes=
 so=20
far, so if there was an __x32__ define, i feel like people are more likely =
to=20
get it right than wrong.

i dont have any use cases off the top of my head, but i wouldnt be surprise=
d=20
if the heavy inline assembly people (like the multimedia peeps e.g. libav)=
=20
approached it this way.  rather than google for documentation, look at the =
cpp=20
output between -m64 and -mx32 and see what sticks out.  "__x32__" would=20
certainly do that.
=2Dmike

--nextPart10409012.WX68hfceO8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNht1hAAoJEEFjO5/oN/WB51AQANfh3mlHcOqIw9aO/nxuHyzw
b02BQgmtlgAIFOoC0PMGB6lQpInT+4KpHLwzgXiHXJgzLA/U1MyAzv/ggKCByK66
vVJPpcGA70vVSZx2LjvHAQMv/cXe+PFJhrkeIl2W42ipFEQXCJl7NdVxMnxlesAq
74yNRmIsATeOPSPdR7dVXuvpCqsh3Dpmqyoyl9w1KBO7RoN6KSVAhnx7wnVkcUYv
U76TyLrx5YBndmiwTXSWPnwydj1zjGH3IAGustgXlgtcWqdYANcgFVqTapoQPhP0
YWYlYchP2K/AKPRoOuu06uTV9adDM4/sxzSm/NrjpiJ5vwKzN4Bl5uz7ZZsZEDIe
ZLqWzhFtdrR3WEU7S0M5+bmQ9e72lXUfWZ7BjPkeg4TV8TevWn1qg7IEOT3N+uVD
cgmgFU2U10FQ66PiwVafYVBcQLClyYduwaBju0Cet/RMvjQZPUCgbD0PMkgpyx5X
+gYrBhhbZqTWFOeJIZk5EDMZ+2iwhjKAPhqFyaG67cFcVficb2/TCOXHXqv/7xbg
UAVhY/hEi9n9LLOjvxKvGa3Cydpb01JfseUsiksbvH0999LXxqtT8lCkl++rLmd3
qLg0u1WNuG6mtsUL5YSXbfN5Lgk9MPs3nZoe6r3Tn8PKYXJ8HSICCpcnr/OSMtjC
cIHCvKg71GanvKM904Kp
=oa/t
-----END PGP SIGNATURE-----

--nextPart10409012.WX68hfceO8--
