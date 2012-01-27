Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2A0Rcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:32:32 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:46752 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751281Ab2A0Rc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:32:29 -0500
Date: Fri, 27 Jan 2012 09:32:25 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/2] pci: Introduce __pci_reset_function_locked to be
 used when holding device_lock.
Message-ID: <20120127093225.7c1194ae@jbarnes-desktop>
In-Reply-To: <1326388007-19178-2-git-send-email-konrad.wilk@oracle.com>
References: <1326388007-19178-1-git-send-email-konrad.wilk@oracle.com>
	<1326388007-19178-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wOU34tgT+IIj2Ug/yepQ1AI"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wOU34tgT+IIj2Ug/yepQ1AI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jan 2012 12:06:46 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> The use case of this is when a driver wants to call FLR when a device
> is attached to it using the SysFS "bind" or "unbind" functionality.
>=20
> The call chain when a user does "bind" looks as so:
>=20
>  echo "0000:01.07.0" > /sys/bus/pci/drivers/XXXX/bind
>=20
> and ends up calling:
>   driver_bind:
>     device_lock(dev);  <=3D=3D=3D TAKES LOCK
>     XXXX_probe:
>          .. pci_enable_device()
>          ...__pci_reset_function(), which calls
>                  pci_dev_reset(dev, 0):
>                         if (!0) {
>                                 device_lock(dev) <=3D=3D=3D=3D DEADLOCK

I have these two in my -next branch now; but you could also push them
through the Xen tree.  If you have other deps and the Xen tree would be
easier, just let me know and I'll drop them.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/wOU34tgT+IIj2Ug/yepQ1AI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIt+pAAoJEIEoDkX4Qk9h0uEQAJd6MNnPCNalZFs6c18vFEJb
Tz6rEPPsyPyd9NFrTE1ko2sQmDtPwRCjvqGUOs4e/+eoFwAgC/K4eWNn1plkNaDj
3z0FtP2gK8+qYp+nOah2du6GGiYYo4qRWQk04gAQ/8FI9Mpa5myk7OZM2ALk6fCb
9lcvJaWSSkVljOs6TqgsDLIcjS3tRfrw191KxUKVmEsFyIIkB7Y/6WUkf43YjS1Q
qgsVXJzYM3BWFHI+OOBpna78qaoXWHR8CurchdCINSrBMSpxl4VBSqJqSoYJtSLX
7TyYNLlAwnbefT+cLx7wIj9Bk2HnJApHj4Ez6q8HSKABpKXfCNcuMkBcGo5l67PO
4kWXsZDpkcZKVP96+KW4DQOPP9EVAge+eInXT+cJSseXWcuRS9rBLjDhj+1E6B8t
SWOTB5RRTD8l7/B4PT66GA5oI/Pg4roZuiXe3oti/ZVyyhdRkfJKkC428+qfDaKA
KWzionpARPsHL78WEM6ZkSgYhbW3XW/yECM3fKjNiQ97osq3lyx9jmrj2a13O7Dc
Ys3PMuKY2FED0oFGqQscYBZYP7ScfX76IU3ryxLG/K9BQpGqYaNVpYxFplkVHK7H
hUsD7Nmvj8omVUFyKEDCGBTSgdJyWveZf1RLIlyMaQa+fbYUyPxD8ShVvMuciu7j
5EJxwTUoASaMbzbc82O5
=nf3W
-----END PGP SIGNATURE-----

--Sig_/wOU34tgT+IIj2Ug/yepQ1AI--
