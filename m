Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1DRQwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:52:16 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:55498 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab1DRQwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:52:08 -0400
Message-ID: <4DAC6C2C.5000503@ece.ntua.gr>
Date: Mon, 18 Apr 2011 19:51:56 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/1] ppc64: fix build error when compiling with gcc-4.6.0
References: <1303144739-4407-1-git-send-email-psomas@cslab.ece.ntua.gr> <1303144739-4407-2-git-send-email-psomas@cslab.ece.ntua.gr>
In-Reply-To: <1303144739-4407-2-git-send-email-psomas@cslab.ece.ntua.gr>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB728FF0943D58F1C8F7032D7"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Mon, 18 Apr 2011 19:52:02 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB728FF0943D58F1C8F7032D7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 18/04/2011 07:38 =CE=BC=CE=BC, Stratos Psomadakis wrote:
> variable 'old' is set but not used, which results to a warning
> (-Werror=3Dunused-but-set-variable) when compiling with gcc-4.6.0, and =
subsequent
> build failure.
> Remove the variable 'old', since it's not used anyway.
Something went wrong with git-send-email :/

So I send the first mail in the chain as a reply:

The build error was reported at the Gentoo Bugzilla [1].

When compiling with gcc-4.6.0, a build error occurs:=20
"variable =E2=80=98old=E2=80=99 set but not used [-Werror=3Dunused-but-se=
t-variable]
cc1: all warnings being treated as errors"

This patch removes the unnecessary assignments to the variable 'old', whi=
ch cause
the compiler warning (used but not set), and build failure, and remove th=
e variable completely.
I think it's ok to do that, since the variable is actually never used. Ri=
ght?
(of course disabling CONFIG_PPC_WERROR would resolve the build failure, b=
ut cleaning up the code a bit, is better I think).

[1] https://bugs.gentoo.org/show_bug.cgi?id=3D363935

--=20
Stratos Psomadakis
<psomas@ece.ntua.gr>



--------------enigB728FF0943D58F1C8F7032D7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2sbDAACgkQid1lVeNDMmB0UACgnAcC0jy0ox84DIbGFl+tVkw7
k4IAn3EMUScfVOrWG6L/3EwW5NC+mdHN
=bGNI
-----END PGP SIGNATURE-----

--------------enigB728FF0943D58F1C8F7032D7--
