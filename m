Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0C2TMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:12:16 -0400
Received: from vps.mortis.eu ([79.99.135.181]:35097 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab0C2TMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:12:14 -0400
Date: Mon, 29 Mar 2010 21:12:09 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: watchdog simple example: don't fail on fsync()
Message-ID: <20100329191209.GA4777@salidar.me.mortis.eu>
References: <1269260557-18150-1-git-send-email-me@mortis.eu>
 <20100329184041.GU3823@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20100329184041.GU3823@infomag.iguana.be>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2010 at 08:40:41PM +0200, Wim Van Sebroeck wrote:
>> Don't terminate the watchdog daemon when fsync() fails because no
>> watchdog driver actually implements the fsync() syscall.
>=20
> Wouldn't it be simpler then to just do an fsync without checking the erro=
r-result?

Yes, it definitly would be. Though I think it would be even simpler to
simply ditch the fsync() call. Considering that none of the watchdog
drivers implements it, nor can I think of a usecase where it would make
sense to implement (as more than a NOP).

So instead I suggest the patch following this line:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
doc: watchdog simple example: don't fail on fsync()

Don't terminate the watchdog daemon when fsync() fails because no
watchdog driver actually implements the fsync() syscall.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 Documentation/watchdog/src/watchdog-simple.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Documentation/watchdog/src/watchdog-simple.c b/Documentation/w=
atchdog/src/watchdog-simple.c
index 4cf72f3..ba45803 100644
--- a/Documentation/watchdog/src/watchdog-simple.c
+++ b/Documentation/watchdog/src/watchdog-simple.c
@@ -17,9 +17,6 @@ int main(void)
 			ret =3D -1;
 			break;
 		}
-		ret =3D fsync(fd);
-		if (ret)
-			break;
 		sleep(10);
 	}
 	close(fd);
--=20
1.6.4.4

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuw+4kACgkQZBYm/87l50IOrwCgjlwesy3y/QQveLBMeMWO/gVC
PFYAoJu65ldEbkh908S6rZk2ZHCsJcFH
=98Al
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
