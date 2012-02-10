Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168Ab2BJUqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:46:19 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:60083 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760124Ab2BJUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:46:17 -0500
Date: Fri, 10 Feb 2012 12:46:14 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] PCI: Disable cardbus bridge MEM1 pref CTL
Message-ID: <20120210124614.5006563e@jbarnes-desktop>
In-Reply-To: <1328424908-6385-4-git-send-email-yinghai@kernel.org>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-4-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Xw.lNCemD=g6gl3MLg8_U=Z"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Xw.lNCemD=g6gl3MLg8_U=Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Feb 2012 22:55:02 -0800
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

Does this actually fix any bugs?  Dominik, have you tested it?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Xw.lNCemD=g6gl3MLg8_U=Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNYIWAAoJEIEoDkX4Qk9hCAIP/imSMtl+Cm2CrK0reSRlXZp6
f99slEizLCqd5qkx3vU/lYEcHTtDS+8KT/lZyYitWB7a7tXRCuJdmG+cH3StOJxf
zcg2LW5G5hXmw/uTBR3YjkZwGtGRdukXqxLgQGX/o7pn7/UpdCF09Mj/z+J+Rfe5
quq9ydItZUZC+jhv3Cr53vmhhYU3djDFJKrjQHbmBEetwgiVhqFmScJQ33D40sZF
qRxG5yCFfta8odfmgvdQgPI1pQAzdH4hhsaYkC3w+sukPJ0SkVMEfXLawnVNMHr3
xXAI5ks4z/QNgjK5xVOobwNKfL0Y0pr6WefxZoqqzDuQYPpN+ptHHAgg4vqKizTW
B3MMcr3ic9ldcA6ruYOy92SRMfSVtBDZI2NOoJFOV7ScmwLRnyvI/JoHzGnMkyzf
Qp8XoIWtfMsiU0Nb9f0EusOAV8xqjR9nUmroxbfikla4e19D2y5RY8U/JOstXsh7
E+lKwiWkfKG2KAjwpmRnD+qB7PWu3B2snoSQeYLejs5JD89iLKcceWam3jrTfuOj
kJYcoUvzcnqzKQU3pdaZlYuVjgcDVac6aM39rqka3KrgBIc2erb80vU20EpgcgRI
e4QdSB8VaiLBv5PO0VSaFtb5D8ioIMyqlr0h75smHCgg46ZApan3IkCHley/WFbd
Es+4Byx/GhxIanuwvyTY
=TZ0U
-----END PGP SIGNATURE-----

--Sig_/Xw.lNCemD=g6gl3MLg8_U=Z--
