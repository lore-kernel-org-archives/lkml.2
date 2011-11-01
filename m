Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1KAUKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 16:10:10 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:51895 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1KAUKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 16:10:08 -0400
Date: Tue, 1 Nov 2011 16:10:07 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com
Subject: Re: [PATCH 6/6 V2] Add age out of guest paused flag
Message-ID: <20111101201007.GD9852@mgebm.net>
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
 <1320091650-24682-7-git-send-email-emunson@mgebm.net>
 <4EB049C3.7080206@us.ibm.com>
 <20111101195111.GA9852@mgebm.net>
 <4EB04F5F.4010709@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zbGR4y+acU1DwHSi"
Content-Disposition: inline
In-Reply-To: <4EB04F5F.4010709@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zbGR4y+acU1DwHSi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 01 Nov 2011, Anthony Liguori wrote:

> On 11/01/2011 02:51 PM, Eric B Munson wrote:
> >On Tue, 01 Nov 2011, Anthony Liguori wrote:
> >
> >>On 10/31/2011 03:07 PM, Eric B Munson wrote:
> >>>The KVM_GUEST_PAUSED flag will prevent a guest from compaining about a=
 soft
> >>>lockup but it can mask real soft lockups if the flag isn't cleared whe=
n it is
> >>>no longer relevant.  This patch adds a kvm ioctl that the hypervisor w=
ill use
> >>>when it resumes a guest to start a timer for aging out the flag.  The =
time out
> >>>will be specified by the hypervisor in the ioctl call.
> >>>
> >>>Signed-off-by: Eric B Munson<emunson@mgebm.net>
> >>
> >>Why not have the guest clear the flag when it acknowledges it?
> >>
> >>The hypervisor would unconditionally set the bit, and the guest
> >>would do a testandclear to check if the bit is set.  I think that
> >>avoids the whole aging business.
> >>
> >>Regards,
> >>
> >>Anthony Liguori
> >
> >If you have a look at patch 5 of this series, the flag is cleared when t=
he
> >guest checks the validity of a soft lockup.  However, the aging is meant=
 to
> >cover the case where the guest never sees a soft lockup.  We don't want =
this
> >flag to be stored for ever and end up delaying real soft lockup messages=
=2E  With
> >that case in mind, I thought this was a good/simple compramise.
>=20
> If the guest clears the flag, then I don't think you have to worry about =
this.
>=20
> Regards,
>=20
> Anthony Liguori

Except that the soft lockup doesn't trigger on every qemu "stop", only some=
 of
them.  The flag isn't cleared until the detector is triggered.

Eric

--zbGR4y+acU1DwHSi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsFIeAAoJEKhG9nGc1bpJ2Z4P/0bUvJwMZLKKRjhtnoC9pkZY
UZRFbJj3RFFoFpLXo66Bc8c3XcPfqWYOtwy+BXhwBIpVsfHrIyrXvV3yxOlTmPF5
+ycqNwgnSEDGz2F/nduw+6PLNnVHuHfpCtzBR+UU7tk5e/QF830X6ZgnM7gcjrSm
t7Ki9qK8NOwvE80Bnuv3kPQrH4spsZWssMUKW/pj86UbMXz3VuDIvhOjh490Aspm
nAAkXAXlvlSZSuRXs2LSnwMZSZKWzuDCFpLvvqxa2AtcG0DPYYPM8Sko3In0GnJY
yQAZ7P5A0ehi7nkmpRGkn8dmjDBvoKf3pQb5Vaf+ONolA00O0EtCmT6vXlt5aP/M
3CX2/PsUWtugXGHYu+IW1Tj7OsOlr1p+4rMsYGY5c+OrILR0+8a5mlO+3YM5/9DC
4/rFrTCD6oVq8HBhT4B5AS7tQOaAroc2cqdwpECl55N6YCcZusUrbkwdFTLOMva0
Ihk49ALroxog67tOY5fym4DkkjHPv5bh80Jj2bZlwd78kiCdpuvwtXS31o04Sx2q
6bwD9tuORZMRSd5gPCt3ZaRSqxHlGJ5ZR2SQW7eCozW0nY/+2C0dNngTu2Di7JVy
bKFpREy7t4i0evcsy8f/dOkso/JFK4qc+pPbGMT9l5q8mLYeRHkyiiz33alN0EwQ
TwuK1xGluzu1bfYgMPPP
=UEvx
-----END PGP SIGNATURE-----

--zbGR4y+acU1DwHSi--
