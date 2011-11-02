Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1KBVFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:05:31 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:54441 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751079Ab1KBVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:05:27 -0400
Date: Wed, 2 Nov 2011 14:05:22 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] pciehp: Retrieve link speed after link is trained
Message-ID: <20111102140522.411ef343@jbarnes-desktop>
In-Reply-To: <4E9147DE.3050006@oracle.com>
References: <4E9147DE.3050006@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/q6/_Q64coyUiOYoMiqb9kSh"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/q6/_Q64coyUiOYoMiqb9kSh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 09 Oct 2011 00:06:06 -0700
Yinghai Lu <yinghai.lu@oracle.com> wrote:

>=20
> During hot plug, board_added will call pciehp_power_on_slot().
> But link speed is updated in pciehp_power_on_slot().
>=20
> We should not update link speed there, because that is too early.
>=20
> Move updating to pciehp_check_link_status() after making sure link is tra=
ined.
>=20
> Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>
>=20
> ---
>  drivers/pci/hotplug/pciehp_hpc.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>=20
> Index: linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/pci/hotplug/pciehp_hpc.c
> +++ linux-2.6/drivers/pci/hotplug/pciehp_hpc.c
> @@ -294,6 +294,8 @@ int pciehp_check_link_status(struct cont
>  		return retval;
>  	}
> =20
> +	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
> +
>  	return retval;
>  }
> =20
> @@ -516,14 +518,6 @@ int pciehp_power_on_slot(struct slot * s
>  	ctrl_dbg(ctrl, "%s: SLOTCTRL %x write cmd %x\n", __func__,
>  		 pci_pcie_cap(ctrl->pcie->port) + PCI_EXP_SLTCTL, slot_cmd);
> =20
> -	retval =3D pciehp_readw(ctrl, PCI_EXP_LNKSTA, &lnk_status);
> -	if (retval) {
> -		ctrl_err(ctrl, "%s: Cannot read LNKSTA register\n",
> -				__func__);
> -		return retval;
> -	}
> -	pcie_update_link_speed(ctrl->pcie->port->subordinate, lnk_status);
> -
>  	return retval;
>  }

Kenji-san or Hidetoshi-san, would it be possible to get tested-bys and
reviewed-bys from you on this patch?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/q6/_Q64coyUiOYoMiqb9kSh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsbCSAAoJEIEoDkX4Qk9h6f8P/3JrJzb0LToRe/5C815xNJ5Y
FvyHSDizsP0xzDeBo6gLq13kDtoUFg2pnhFabZkayAgsxlNqZ9f4e8Fa8Ns20PiG
mFZ2R5Cmis4+xygNbcVX4GEYuGfBAuG/Ee8/Yjuo9ORGr0NZ03cGQAeHSjIL5vR0
BAUZTRhE03inJahOuMlqFa80Qi3FuULDK7n4uodZLHkIQ7rITc1HyAaZZXwnIbez
n7wKkRiSNSiv+mgxI2GUHWJxs0goOuFOL2bH9mSFXjLJGEWS54SDeJq6b2itV8jv
YMM4UbrH+V+WmI+HCmt3Lm1d9MBIOys+aEniK0tpw2UiEG4bz5gWa7CTLXrKAmIN
Snc+yzNEMEFJc8DNd7m5aqnqE4OecTJwEcCYUFtU2E0kB0qwDKmsklkuIZLwWBbT
oMn9XSps1/M6yaVExqVxOdnTymk8uzBS3gFBn3osIgaCK4sL8Rlr653+561d42m2
I9VjU8yUIZ7muOsvt5hcVP7OMe64HkxFuhX/7qSFAptlTf11h5I1/Cnat+1PXuFT
/xtesYL0z1AMsrFv/mP+XoPq7N4Q3XZl8ooa4LHSWUaeDEwmE6cppmQEFAVfMUQw
Gxu2+S6ft0UAD/sBqg1Z5rqWW5rJVE4dABOycqs9zang4RxmvJ/CXqAPlb1Bb1q9
5Skfz6+AA9BTMxvMTKOb
=bHhA
-----END PGP SIGNATURE-----

--Sig_/q6/_Q64coyUiOYoMiqb9kSh--
