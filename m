Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2BWUoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:44:34 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:43218 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756359Ab2BWUoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:44:32 -0500
Date: Thu, 23 Feb 2012 12:44:26 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 1/4] PCI: Add class support in quirk handling
Message-ID: <20120223124426.2631b779@jbarnes-desktop>
In-Reply-To: <1329370832-2253-2-git-send-email-yinghai@kernel.org>
References: <1329370832-2253-1-git-send-email-yinghai@kernel.org>
	<1329370832-2253-2-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BWo0ax=4MrbQ7fkiVm7d6Do"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BWo0ax=4MrbQ7fkiVm7d6Do
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Feb 2012 21:40:29 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Recently there is new support to make quirk calling will report duration =
time.
> That will boot log get more print out with initcall_debug is specified.
>=20
> Found a lot of quirks are calling for not related devices.
>=20
> Reason is quirk frame do not support class handling. So quirk code have to
> use PCI_ANY_ID for vendor/device and let quirk code itself to check class
> inside the func.
>=20
> The patch add class and cls_shift into struct pci_fixup.
> Also update related macro to accept the class and shift.
>=20
> -v2: fix v1 that left over of sparated patch.

I like this series, a few comments:
  - class and class_shift everywhere (in pci_fixup {} and the new
    macros) for readability
  - split the individual quirk fixes into separate patches (makes it
    easier to revert or identify if one breaks)
  - the reassigndev patch looks like a good one independent of the
    series

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/BWo0ax=4MrbQ7fkiVm7d6Do
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRqUqAAoJEIEoDkX4Qk9hJxEP/jnXFqyV0bxdGFDYRfyZ9NaB
wjAM7XA4+ERGjN5A5dbmgsPZj71Jo/qsoSc9MWUVySjnD3pLIqDE3tFBL0Fs+hX4
xZeksBKlX8/3r8EUESpIM/3pMtw1BFor2ubWjD8DlCYDf7RMUTamx8wscFwKLlp7
j7Pgc39h5PL0GxnnM22K3hbQA+S5b3t6faxpR4GRvS25AIcrPgxWHuA2hi+y82HS
Eh4MOW3hPWt+TCWhVqQNYaUvRnePXwQxeZTGV17jdGENRGiAaPWEHauXGpDwMFgK
LRmul3jj3cSUsQVKaovKW7d1VKTpdqY4KTtJvCZywhimloO2DHaemmu1AQFMkFyO
RuDIUgx4YQd6+nO+qsYArQbPIrPvu4RVwCa0TNFOb8eXc3u/vo3yabd+5vTzWfuY
njnV3Hj6tkvppUgKx6fAVPpqpBU5nieEfu84aNX1OV0C9sFFcsKdqNNoni9PvON6
DJ2jDP3RYNrJm+xCi3ARycRDrSAryfKIcVVN3XzwYtT2Eh1oKhZ6H96wvQ92HMFp
LQYoxWDrnpT5fi+jooikDPgV/wBme65Daiv1rhS3ukwQcVoOWxF2i6QUmYsW9mus
wz/ULpqlbsMvbg1AkZFNRAv3DgFI+vrP/yqhUEU4V6VbeX2GjWy8KtC33e84J25h
J0sPT96TgheFwWUf/P1A
=8nOd
-----END PGP SIGNATURE-----

--Sig_/BWo0ax=4MrbQ7fkiVm7d6Do--
