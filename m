Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0FOWhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 18:37:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:33915 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753721Ab0FOWhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 18:37:50 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX19SdJQ9y7xScAcRHjjbaWh9kMdyE8U1DTRrSOAfR6
	xa9XYv9PFJixlm
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [B.A.T.M.A.N.] [PATCH] drivers/staging/batman-adv: Use (pr|netdev)_<level> macro helpers
Date: Wed, 16 Jun 2010 00:37:47 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: devel <devel@driverdev.osuosl.org>, b.a.t.m.a.n@lists.open-mesh.net,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Joe Perches <joe@perches.com>, Marek Lindner <lindner_marek@yahoo.de>
References: <1275498615.23599.12.camel@Joe-Laptop.home> <1275509466.23599.43.camel@Joe-Laptop.home> <201006160023.04296.sven.eckelmann@gmx.de>
In-Reply-To: <201006160023.04296.sven.eckelmann@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2099613.Wn9nel2nsZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201006160037.48573.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2099613.Wn9nel2nsZ
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Sven Eckelmann wrote:
[...]
> Found some time to play a little bit around with your patch and noticed
> that it crashes the kernel. I did my tests using following "interesting"
> part:
>=20
[...]
>=20
> I compiled the module and loaded it using `insmod batman-adv.ko`. This wi=
ll
> create some files in /sys. Just changed the vis mode to server using:
>=20
> echo 0 > /sys/class/net/bat0/mesh/vis_mode
>=20
> And then it will crash at that netdev_info call.
>=20
> The problem seems to be that dev_printk is used by netdev_printk (which is
> used by netdev_info). netdev_printk will add (netdev)->dev.parent as seco=
nd
> parameter of dev_printk (and parent is NULL in our case). This macro will
> now call dev_driver_string with NULL as parameter and just dereference
> this null pointer.
>=20
> Maybe it is related to something else, but at least I think that this cou=
ld
> be the cause of the crash.

Something i forgot to say:

As far as I understand, the netdev_* stuff is made to be used by real drive=
rs=20
with more or less physical hardware. batman-adv is a virtual bridge used fo=
r=20
mesh networks. Like net/bridge/ it has no physical parent device and only=20
other net_devices are used inside of it - which may have real physical netw=
ork=20
devices as parents.

Please correct me if my assumption is wrong.

Best regards,
	Sven

--nextPart2099613.Wn9nel2nsZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMGAC7AAoJEF2HCgfBJntGLswP/RkKOcjzO1zOKCr3LkAedBdB
XuiSdbD7yZTyueGdFr++WSNZ6U2eSkR0gkDzceHGv7aZoPz/AfoHhvRVlMqr9iZF
x9q2m6ko8lJrsX5BOkPsG2zIjP14QK6+zzQ1aCWpxsK8ivnKcnU+hajoJ9ZmXGD8
Tz/UOJk+/H0JpyZsIOtG2rAvmbIoPr4f5vShqDyfyS5nnXTUYSZaSJq/9Uh4IdWr
V8aB2E71bMZ8/IdYYauMDiQij+cL67ng/VHdBIwkmJfnJA/Vp7Eo9A9QpoZnPm4C
UOFP/X4z6xWvWRLd52C11aEOlnzJ9ns6L87sB5UDZlXwQawrhrPt9Ok8aDQv82ZD
1Mr8rfL6r/t0dafSR3lCwMniYd44O+rKJa9CW/2rPH8dfk1EHB7/MtXvNojoTih/
KVC3fTMVp3fXClTVEjAFnfCIcoUT86WU7cFU57wCKkirB0o6MrPAFIuXnYlwcoQq
XDggaIQip8UkEa3ug+J+Xanz6/CDniUjVRS0+Y19iEjI0qJXg932LpHxXLYZgTXG
SygywzpaSBlPhufXTJYr3sfbEE1SEQlXMdgWVYQNKVLfakbwPq450eqv7mqV/3mG
6TjfpcpIZHga4ZXgjPVDMudB5yK3wVNebxbzI8DKGRPNWvdzJxzWftDqaP78uiTr
JVAaI8JRg8zTv0qGQx4Z
=M6rT
-----END PGP SIGNATURE-----

--nextPart2099613.Wn9nel2nsZ--
