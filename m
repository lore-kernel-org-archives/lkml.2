Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1C2VE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:04:26 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:39996 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab1C2VEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:04:25 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix msecs_to_jiffies() to not return values greater than MAX_JIFFY_OFFSET
Date: Tue, 29 Mar 2011 23:03:47 +0200
Message-Id: <6206394.oTpczxkaEM@donald.sf-tec.de>
User-Agent: KMail/4.6 beta4 (Linux/2.6.37-12-desktop; KDE/4.6.1; i686; ; )
In-Reply-To: <alpine.LFD.2.00.1103292103070.2774@localhost6.localdomain6>
References: <2120287.WTetKHanc4@donald.sf-tec.de> <alpine.LFD.2.00.1103292103070.2774@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1434542.gV8MdA4CJe"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1434542.gV8MdA4CJe
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Am Dienstag, 29. M=E4rz 2011, 21:42:59 schrieb Thomas Gleixner:
> On Tue, 29 Mar 2011, Rolf Eike Beer wrote:

> > @@ -467,9 +468,10 @@ unsigned long msecs_to_jiffies(const unsigned =
int m)
> >=20
> >  =09if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET)=
)
> >  =09
> >  =09=09return MAX_JIFFY_OFFSET;
>=20
> Hmm, this check is silly. MUL32 is chosen, so that we cannot overflow=
.

IMHO the second part of the check should be enough, no? If m is greater=
 than=20
j2m(MAX) then it's irrelevant what's up else, it's too big. Period.

Eike
--nextPart1434542.gV8MdA4CJe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk2SSVAACgkQXKSJPmm5/E7hkgCeKh09MNecx1nv/IwAnDfHghwp
9RoAniRgYGsC5AwkfmHppY3EuI3doCS4
=R2OD
-----END PGP SIGNATURE-----

--nextPart1434542.gV8MdA4CJe--

