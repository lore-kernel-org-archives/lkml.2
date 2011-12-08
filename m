Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab1LHGTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 01:19:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:52721 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1LHGTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 01:19:11 -0500
Date: Thu, 8 Dec 2011 09:19:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 1/2] staging: vt6656: aes_ccmp, baseband, bssdb, card:
 Change BOOL to int
Message-ID: <20111208061920.GK3374@mwanda>
References: <1323047566-12650-1-git-send-email-marcos.mage@gmail.com>
 <20111205065517.GC3236@mwanda>
 <alpine.LNX.2.00.1112052237140.2379@cactuar.localhost>
 <20111206061018.GD3374@mwanda>
 <alpine.LNX.2.00.1112071922560.2146@darkstar.example.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n83H03bbH672hrlY"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1112071922560.2146@darkstar.example.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4EE056D8.0075,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n83H03bbH672hrlY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 07, 2011 at 07:28:07PM +0000, Marcos Paulo de Souza wrote:
> So, I agree with you. So, we can make some chnages and ask for
> people to test it? I don't have other hardware than my x86.
>=20
> So, I think we can remove the typedefs of unsigned char to BYTE.
>=20
> When I submit some patches chaging this, you ask me to change this to u8.
>=20
> So, you think I can change this typedefs to theirs respective u8 for
> unsigned char, u16 for unsigned short and u32 for unsgined long?
>=20

What I'm saying is that so often people see the TODO or the output
=66rom checkpatch and think, "This is easy, I can just use sed and
replace the old code."  Sometimes that's the right thing to do, but
sometime the original code is not right, like here where it should
be using bool but it's using int.  So go slowly.

> If it ca generate some crash in other architetures, how we can
> change it and be sure that nothing bad could happen?
>=20

Check if the data is part of the userspace or hardware API or we
care about the exact size of the struct for some reason.  If it is
then we have to leave it as int.  Otherwise it should be bool or a
bitfield.

regards,
dan carpenter

--n83H03bbH672hrlY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO4FboAAoJEOnZkXI/YHqRAEYQAIXq927MwF11DlqL2HzZwGZh
UZCuVKIGVnL47RN/gdzqbKP7g5nstw+CLvhzVcB53fBDYNwtRM6zNNgBf1uL9HXJ
b/INMClRCEEvEni+ZgGNT7fqZeRIPyISzCKEGOlPiyQlbS39Sweix0vPvkqqLxBE
GYr8eMVT6t1QdFUKsMAc1HQ42PNeU3+PXY921cnrwFwIO4vwDNx2VzZi84asRCTa
l1WJE2I3duBRVCSzA5XuIfVXCP7qVpvWeRFl7XfofCGSFG2y/1Y21T47j/0cPZpF
PeNSvL1xaxoj8PaQdRMfpeBD7/HO9JQmX28qQhzqrsbVEk1GP3GnqBBNjl+kTYe8
2n5TotDmpXDcL5PzZnyRMxkyfVLIBUWvTeLqV5/GhEz9sRXEFkki6d9GiLr5uQwL
xxK5TxShnAqoi/DliMIFsAjJVR894SD35lTyTWH6hg4qXV9uJgpwOIEXCAR/+Ceq
0+p2COIBozEc12E04vqviIT4wo8ej8ZXWcbhJPIgLDR3A90blCVGDSrAyvEs+zQx
6Xqr8xww6ENZNPlB5XCXNuFmJqlloVCQ1s0vSnwRNWRXL9Kwfc8EGMTcET9TM2nx
R5sK5CsuugpHkynPslZO3ReMBNLXOes8xRW+aqSpkrHT6et0ML3Aj76wdjO+8EDE
5c6c+GLjIGKzGBFaxuym
=0rfC
-----END PGP SIGNATURE-----

--n83H03bbH672hrlY--
