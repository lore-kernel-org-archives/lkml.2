Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714Ab1L1Iug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 03:50:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1L1Iud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 03:50:33 -0500
Message-ID: <1325062341.1165.93.camel@sauron.fi.intel.com>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the logfs tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        =?ISO-8859-1?Q?=22J=F6rn?= "Engel\"" <joern@logfs.org>
Date: Wed, 28 Dec 2011 10:52:21 +0200
In-Reply-To: <20111228124833.80c36e5660fdd9fe0c8481ba@canb.auug.org.au>
References: <20111228124833.80c36e5660fdd9fe0c8481ba@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-TP7bV8+PUxsok6ELflfW"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TP7bV8+PUxsok6ELflfW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-12-28 at 12:48 +1100, Stephen Rothwell wrote:
> Hi Artem,
>=20
> Today's linux-next merge of the l2-mtd tree got a conflict in
> fs/logfs/dev_mtd.c between commit d1cc3ad397f2 ("Logfs: Allow NULL
> block_isbad() methods") from the  tree and commit 22aed0c2578c ("mtd:
> introduce mtd_block_isbad interface") from the l2-mtd tree.

Hi, thanks.

> I fixed it up (see below) and can carry the fix as necessary.  I am a
> little worried that the block_isbad member of struct mtd_info may be
> hidden in the future and so break the NULL checks here.

I will take care of all the direct use of "mtd->block_isbad" everywhere
during the 3.3 cycle. So far I just introduced the wrapper functions,
and amended all the users that coccinelle has found.

But it is also OK to use the pointers directly so far (in 3.2), and I
will take care of this by 3.3.

Thanks for taking care of the conflict.

--=20
Best Regards,
Artem Bityutskiy

--=-TP7bV8+PUxsok6ELflfW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO+tjFAAoJECmIfjd9wqK0eskP/2m6clTHWs4KQtS3p1yFXpQD
9cm93Kb0IiPnoi1dYjuNfFspRgglQAyRKDOJ6s5sXLpdTCJIVaYVf4p5ddUlRZ9w
Fkh9SHHSZek/ey+OSksYNCvXxHnVlru+zQjS98GHZO1yRJpTZwaU9jBexEnm3GCR
wShOG70IetZRSllEyHmQs7gVsxKTOFEwm9fUkXaVlBaUVpReuvz1bsCNgwfB68uh
UbfkO1ivVk51Xqei85h6MfR/5HZiY3DR2HUPBKVpdK19DyTKA9gV5xBDfIleoYIK
cKBn07ydvRw8V9zCK66P8ODGBZFpu3SyB8MsrvfYDrwPKNOyn8v2y4cJWwDBEXOp
R8B5VQvSMb73WoO9O/eh4hj9Jy9/3+ccQVdRLha3AAwoUaLJS6eCQubdrI8WY0cg
Cjy5OhlB846/TiuJ8fmOkOpNycjjtCqb1nw0Nau0GiltZECdqYRs7V751nEecAEA
s/aJK9F3977Gjp7kJlpio3gjcGJSCEqDjht8jzfb9vqupM4mwuZmPdno80cBx0n0
0UND6rdvZnNiBg3DAtqe9mMPM2ghC7BRhPLmGvthIujRIq+01o/ug6t0CJSu+ikP
6krxBdiYqOEkG9ETaK1q/d8Lr0EWUrJFJ0vMGTQUPPeGsvfPXeDS2i8/gYmE9rBR
f2Zh6wH1eeO/YwyUkFPf
=L+S+
-----END PGP SIGNATURE-----

--=-TP7bV8+PUxsok6ELflfW--

