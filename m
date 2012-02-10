Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2BJUU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:20:26 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:56947 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932337Ab2BJUUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:20:24 -0500
Date: Fri, 10 Feb 2012 12:20:19 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] pci: Fix pci cardbus removal
Message-ID: <20120210122019.2ce504f9@jbarnes-desktop>
In-Reply-To: <1328424908-6385-2-git-send-email-yinghai@kernel.org>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-2-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/36tscn935Z69CCuYmhdb+AY"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/36tscn935Z69CCuYmhdb+AY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Feb 2012 22:55:00 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> During test busn_res allocation with cardbus, found pci card removal is n=
ot
> working anymore, and it turns out it is broken by:
>=20
> |commit 79cc9601c3e42b4f0650fe7e69132ebce7ab48f9
> |Date:   Tue Nov 22 21:06:53 2011 -0800
> |
> |    PCI: Only call pci_stop_bus_device() one time for child devices at r=
emove
>=20
> that patch changed pci_remove_behind_bridge behavoir that yenta_carbus de=
pends.
>=20
> Restore the old behavoir of pci_remove_behind_bridge by:
> 1. rename pci_remove_behind_bridge to __pci_remove_behind_bridge, and let
> 	__pci_remove_bus_device() call it instead.
> 2. add pci-stop_befind_bridge that will stop device under bridge
> 3. add back pci_remove_behind_bridge that will stop and remove device
> 	under bridge.
>=20
> This one is for v3.3

Applied to -fixes with Dominik's tested-by.  A nice cleanup on top
might be to rename pci_remove_behind_bridge to
pci_stop_remove_behind_bridge or something to indicate that it's
calling stop each time as well...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/36tscn935Z69CCuYmhdb+AY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNXwDAAoJEIEoDkX4Qk9h3UkQAJyK8w08lsmVxgVQqBnpRzWA
iCgVskuCqW9TJqTVAljjD4NeARt4I1Lr6xiPQHA1goR+DXaTs53vk0FbtNfbA0yO
ZsZ3mspkIr8sIRiIpn/GTFtnMG+ikOBmXgmU58DYEIW0cD4m91xyY8U3sSyfKBnb
0iUqVLnkQ6UrWU5GUABM81pQr08uCrYNnCGZK4oMsgxlW/auCp8Uv0CCZIlRM5zf
kPo19aTzTMCLozmVbkvHPzw5rRGn+Uxq5MkON7ERED6tlg0PoUh0gOUH7eD5myHn
CYVqpYqla6R8H71pKUR+6IswSE0XYWY4SsrcO3WeQIV9ZYlJGNa+A1lrOtND+4to
rnntHTwNFt7eBbTzmm0/QHfRZnqqahZLL9tx6nzeZeP9V5IDY2epcFdqQmtcBMr3
Tifs+Cj4bcUH1vAUFdRnCTKid0Rqn/uj3I/Qc7l6OkeDTpUPzANlpBiRjRWkldav
rw3B4oA3TCHIvKjH5XZS0u44sTqQCYBavq/JkBxA6PjotAYfk0lfiKlSxNs8g4MA
yeN2Xxq3f6VJKb39bZQYsYLDi7H0UKwV5k1q+2mj3CMbuPQBh9erQw/EBQIA3jNw
PVgruMwYwm61Q+LOgnE17sG2JelBmbxrihaysdWrt/2UIrR5kAxQkyK6qvr1EKvA
XtHsT4aSUGLKr8jotxAZ
=6l9O
-----END PGP SIGNATURE-----

--Sig_/36tscn935Z69CCuYmhdb+AY--
