Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1LETfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:35:32 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36637 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753842Ab1LETfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:35:31 -0500
Date: Mon, 5 Dec 2011 11:38:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: Only call pci_stop_bus_device() one time for
 children devices during removing
Message-ID: <20111205113803.37cc5d4c@jbarnes-desktop>
In-Reply-To: <4ECC7F6D.6090802@oracle.com>
References: <4ECC7F6D.6090802@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zOu9lkd8t/.46BhH4gW1vum"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zOu9lkd8t/.46BhH4gW1vum
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 21:06:53 -0800
Yinghai Lu <yinghai.lu@oracle.com> wrote:

>=20
> During debugging pcie hotplug with SRIOV with pcie switch, found
> pci_stop_bus_device() are called several times for some children devices.
>=20
> Current pci_remove_bus_device() will call pci_stop_bus_device() at first.
> and then use remove_behind_bridge() to call pci_stop_bus_device() for chi=
ldren
> devices. But pci_stop_bus_device() already include depth first to stop ch=
ildren.
> So We can remove unnecessary calling in pci_remove_behind_bridge() for ch=
ildren.
>=20
> The patch change original pci_remove_bus_device() to __pci_remove_bus_dev=
ice(), and
> it only do remove work, and new pci_remove_bus_device will call
> pci_stop_bus_device() one time, and then call __pci_remove_bus_device().
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

applied to linux-next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/zOu9lkd8t/.46BhH4gW1vum
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3R2bAAoJEIEoDkX4Qk9hBz0P/RTnsxsrktzh/K+siypJwG6l
ZSHaWzCNoGhBfzuJqJbN2FAsOu4fFjiDCkcXLFtT21/v5tpE/VwJQzArmYTrhnLf
IHZ83hWZoDIkbTHzNw0CyljUU7Ejijn9fwJfotngAKzH2s/UjG3CnaTQVVdQ0IL0
jwu8UHxkv9ezWBh2JQ4RvHNG0gFwK2kc+MCNBtJGhUaE9APsIrQihe4XV1vRht69
61duC4sf0466fcRBD0ECCGhk4E4jH1EYVKvJvx1gpE9S13nnj3KsZlw0bZ9iuyCn
GsQATRfA215XtYS+KjPjmVLsFxGbPE2ZBvyHMQsHiYOvReTvB/rHN3H2BlDRvgxP
4vMA7S8zY2grln2e6OePfu1RJwGfT+2MgWNyJFUQghy0ePllQm2e37iHbtQmLvgo
1fB6fs41pJs2Vt4LHJXAXh+T/KNAPkWsj/E0hW0nArkOrxpJIBR5LYNNnJ6DTiBn
UeIOVank9RiGzgQglkMaUDrqP7OM8oo7wMYpPCdAhAenrno+jz+jP8v91+Vr/Y6t
hWgq/fm2ZSmXUXE4gDeaxzIucRmNhGqX/U2yzvsxDlohod+4m6qQ5Z/WAEkKzLDY
GBvUUHz8u9mSLp91qSzZDob1VwQRB1GqrZZ4JT/eo+9n80ZooYhe8gYCmgXoPxzO
IFpxIfgi+WgANW2o7jsO
=tZ0v
-----END PGP SIGNATURE-----

--Sig_/zOu9lkd8t/.46BhH4gW1vum--
