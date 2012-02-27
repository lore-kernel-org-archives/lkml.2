Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2B0UTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:19:41 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57517 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754134Ab2B0UTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:19:40 -0500
Date: Mon, 27 Feb 2012 12:19:32 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] PCI: acpihp user __pci_remove_bus_device instead
Message-ID: <20120227121932.24852506@jbarnes-desktop>
In-Reply-To: <1330206863-31381-5-git-send-email-yinghai@kernel.org>
References: <1330206863-31381-1-git-send-email-yinghai@kernel.org>
	<1330206863-31381-5-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TCcGUpmW5aX1Tnb3r8+DclX"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TCcGUpmW5aX1Tnb3r8+DclX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 25 Feb 2012 13:54:23 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> pci_stop_bus_device get called before in the same loop.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>=20
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-2.6/drivers/pci/hotplug/acpiphp_glue.c
> @@ -910,7 +910,7 @@ static int disable_device(struct acpiphp
>  				disable_bridges(pdev->subordinate);
>  				pci_disable_device(pdev);
>  			}
> -			pci_stop_and_remove_bus_device(pdev);
> +			__pci_remove_bus_device(pdev);
>  			pci_dev_put(pdev);
>  		}
>  	}
>=20

Ok applied these.  How about another that converts in-tree users to
pci_remove_bus_device and marks the __ version deprecated though?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/TCcGUpmW5aX1Tnb3r8+DclX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPS+VUAAoJEIEoDkX4Qk9hxt8QAMAp+2tK1c+5mTtTOuItEckt
cM2KORyERTzalS98iabSG7UhI18cNaIuLbflbgG5IVQxdvBLFJdFgBk8MqDTI1Ra
4i9lu+QFXVFgNTSaYKvtzKIzJtYURJq7O+tWY+gjIzAkb9DWjO48CYXXZBtwO4o5
CfCntYsyjQJpsDY8Q/euSE3OvHXRg/HWoJzi2NgXfbFKQlmUvDmxWqFfMsKuvpkT
rTi/TZAoPefwEQjUSBoPtfigaeEXPFRBPmI84vfVZ2Ojnw3qMreMcAoQiL/7D5+k
2LAOVpvdJx5MVkcTt/0c4bRmO653nStNU5+tFyX3EywkoPJZw+ByYUlWYUp0qXQo
xwS2M0BSStdCPo5Ao2qahxM/qdCclN0NK4+2+JJDWdXxxEhpADfoiZ5u4ylRCEja
+rMGJ6jxCdgOI0oCzncqD/f6mEno1yjWFbab8oLClPqmIu6ePUc4q05HJ6eHe4AF
04/aoQyHTiW649tQQU4Oi61pht/95sx5GR8GScn+EE2p/XtnhDzkg7OW/Dcg7VV8
ydD24hLQWotMc9zmdgV+yfJQ07pz4qmFrFOEnYXsDOEd6WP/7S1s6AoLN37hy8ub
impfqT9obX+WwdnHsrxnp0Ija1e1N3LHGfR91AGw/3H3Y94QJiClcKI5ieYCZro7
AP9xV1TTSKpwrzFhnWv0
=x/N/
-----END PGP SIGNATURE-----

--Sig_/TCcGUpmW5aX1Tnb3r8+DclX--
