Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2A0SWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:22:22 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:34675 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751560Ab2A0SWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:22:21 -0500
Date: Fri, 27 Jan 2012 10:22:18 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/21] PCI: Disable cardbus bridge MEM1 pref CTL
Message-ID: <20120127102218.3dde7360@jbarnes-desktop>
In-Reply-To: <1327140517-14811-18-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-18-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/JcIYwD9ZubXxdIuta9Ysq=0"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JcIYwD9ZubXxdIuta9Ysq=0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 02:08:33 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Some BIOS enable both pref for MEM0 and MEM1.
>=20
> but we assume MEM1 is non-pref...
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 090217a..d5897c3 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -914,6 +914,14 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
>  	if (realloc_head)
>  		add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* d=
ont care */);
> =20
> +	/* MEM1 must not be pref mmio */
> +	pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
> +	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM1) {
> +		ctrl &=3D ~PCI_CB_BRIDGE_CTL_PREFETCH_MEM1;
> +		pci_write_config_word(bridge, PCI_CB_BRIDGE_CONTROL, ctrl);
> +		pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
> +	}
> +
>  	/*
>  	 * Check whether prefetchable memory is supported
>  	 * by this bridge.

Is there an actual bug report for this one where prefetchable regions
are causing trouble?  I can see that they would I just wonder if this
bug is hidden by some other...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/JcIYwD9ZubXxdIuta9Ysq=0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIutaAAoJEIEoDkX4Qk9hm5YP/2Vwfv76/BHrCmonbWfNQqij
7msm+24BaePa3rkDZySXQLj7xg72hkVGfw4hBaPYUwToJiYk7yfCCob0JoU14TND
01BgpJMhuVevZ4yE+yBrF01a7fiwHUR3y53VAoVkA6IjIhB7Mj3JTMLWS1RStHnq
nQrzWGK6cpk/MrN8PZlwC2wGTfivAR2/06sXBQCAoUlAynjFLa30UrLDnG/G/gLb
m2h6A2hdypPtIxQ5V9I8KwfdU/d3HVsDsoWAIh/BWp0K4QWzRHCDRt/J+zrpDQe2
EQJjdwoqrQQwRtQ7es3dyCmheQV+VpnR5c8JsvuTqTs3MJl6RbEE2QZLRdW6hYL9
tWDAdgofYm6l+nokw6DvzFs/AQvD1mwP9yJN9ZyGDrxTCQOWQ6QwrlsAO/lVXlkw
rj2Ii+arvqT+Cs1d0dGrhAaF8U35OmR8RuYeW/zDONzWhep0YD6sQ8QUE1x5Bs13
mw46qZSNKJQHVaD5BKHOqEWakTZ3nLdA3VPUY6dU/XF5lp8upngBXu7wY/N90yK6
6IhVnlMt/qQHux3SYSmawpTUMKw/aWBIXcAZL12gWYcZHB87Qrr/x066HUjVQV16
ugvsf39U5nMdtCuZNPwpihNk6ZrWiU/wtzgMZPRKBw9LvCk36MsBcc/aDmLKj+ll
UENKLccliPcd5PqU9aic
=5XNq
-----END PGP SIGNATURE-----

--Sig_/JcIYwD9ZubXxdIuta9Ysq=0--
