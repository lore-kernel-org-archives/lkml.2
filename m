Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1KKRow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:44:52 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:46853 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751210Ab1KKRou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:44:50 -0500
Date: Fri, 11 Nov 2011 09:45:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PCI: Maintain a list of FW-assigned BIOS BAR values
Message-ID: <20111111094509.0de1c139@jbarnes-desktop>
In-Reply-To: <20111110004351.5866.40960.stgit@amt.stowe>
References: <20111110004339.5866.28478.stgit@amt.stowe>
	<20111110004351.5866.40960.stgit@amt.stowe>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KItNkH7X5fY3/hoDpw7F9Fr"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KItNkH7X5fY3/hoDpw7F9Fr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 09 Nov 2011 17:43:51 -0700
Myron Stowe <myron.stowe@redhat.com> wrote:

> From: Myron Stowe <mstowe@redhat.com>
>=20
> Commit 58c84eda075 introduced functionality to try and reinstate the
> original BIOS BAR addresses of a PCI device when normal resource
> assignment attempts fail.  To keep track of the BIOS BAR addresses,
> struct pci_dev was augmented with an array to hold the BAR addresses
> of the PCI device: 'resource_size_t fw_addr[DEVICE_COUNT_RESOURCE]'.
>=20
> The reinstatement of BAR addresses is an uncommon event leaving the
> 'fw_addr' array unused normally.  As the use of struct pci_dev is so
> prevalent, this seems wasteful.
>=20
> This patch introduces a stand alone data structure and corresponding set
> of interfacing routines for maintaining a list of FW-assigned BIOS BAR
> value temporary entries.
>=20
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
>=20
>  drivers/pci/setup-res.c |   73 +++++++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/pci.h     |    1 +
>  2 files changed, 74 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index ad8c4ae..ab45c11 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -26,6 +26,79 @@
>  #include "pci.h"
> =20
> =20
> +/*
> + * This list of dynamic mappings is for temporarly maintaining
> + * original BIOS BAR addresses for possbile reinstatement.
> + */
> +struct pci_fwaddrmap {
> +	struct list_head list;
> +	struct pci_dev *dev;
> +	resource_size_t fw_addr[DEVICE_COUNT_RESOURCE];
> +	unsigned long refcount;
> +};
> +
> +static LIST_HEAD(pci_fwaddrmappings);
> +static DEFINE_SPINLOCK(pci_fwaddrmap_lock);

Is the refcounting really needed?  Can't we just free the whole list at
some point to simplify things a bit?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/KItNkH7X5fY3/hoDpw7F9Fr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIbBAEBAgAGBQJOvV8mAAoJEIEoDkX4Qk9hgv4P+IZtyBzETfQ2SilRhFfUKozt
lxJ5578ZuLB8QqFJW72sc2waVR9gf+tLsDp6ZlabKLBWIEhO6Lsu5qK7Ff44cXzY
3M/wjoFrBqTd3KB4LZSs/G/fT+x/XHdjlZfUejVc7qthcoWeOQZEuEiZfZ7OhH+u
BvVbQ5Zu8b6IlE8jIcKGbODuq49wUMnwf6jRGuOZzyqXwMBWj+wM0zcTbJ6SyjRG
KAiJ0sgODJqIfMQycu/6gSWmduEJodHARr290XXdtaFDnodgZQbGaNq5gPYDSyd9
QG/gyuh026lTW6EfBcW1ie2LCs9g+n2uxSP0+/kLCB6xsS3cgnKfty7yMiIQKTWo
ouQjEcjz5N0OQlukQZslPYARndAdleWilCn1GAlcTniZuM6NzfBnxnTjqSVRayoa
Kyg8oEamILLKiQNjJXd3M84AMyzgGG03kVtH1t/D24exDU4NuZnx+R2xGEBpZGt1
OQ2xgutpFFAwJaql1gsgannHajUfqLfgXRxjPwF7WVbNVBtovftzpp0gBQNP4DLU
6lYEpHilPwnjO9CSa0qx8PSm/xiCf0T4Hs2mLru+9+/8qTvFPLOSC8R+6s6x8+/G
oAmw+l4iVJH8sPp81AeQfMTtzWAnpJse0fc3B4m3IR5wZBsQ6tZhjH7UQpRSE9Kz
PzzntZq+EBSosS9qQP0=
=mdGC
-----END PGP SIGNATURE-----

--Sig_/KItNkH7X5fY3/hoDpw7F9Fr--
