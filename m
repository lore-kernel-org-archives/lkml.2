Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab2BJUjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:39:33 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:45444 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932420Ab2BJUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:39:31 -0500
Date: Fri, 10 Feb 2012 12:39:29 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] PCI: Fix /sys warning when sriov enabled card is
 hot removed
Message-ID: <20120210123929.61fe8ac4@jbarnes-desktop>
In-Reply-To: <1328424908-6385-3-git-send-email-yinghai@kernel.org>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-3-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6IQlFvg_EPB2Iirxyle1AOW"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6IQlFvg_EPB2Iirxyle1AOW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat,  4 Feb 2012 22:55:01 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> During recent strick checking about sysfs_remove from Eric.
> it will spit more bitter warning.
>=20
> For SRIOV hotplug, we are calling pci_stop_dev() for VF at first.
> (after we update pci_stop_bus_devices).
>=20
> that pci_stop_dev will calling device_unregiste for that VF, so that dire=
ctory
> in VF is removed already.
>=20
> We double checking if that VF dir in /sys is there, before try removing t=
hat
>  physfn link.
>=20
> Signed-of-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/iov.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 0321fa3..dfc7d65 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -173,7 +173,12 @@ static void virtfn_remove(struct pci_dev *dev, int i=
d, int reset)
> =20
>  	sprintf(buf, "virtfn%u", id);
>  	sysfs_remove_link(&dev->dev.kobj, buf);
> -	sysfs_remove_link(&virtfn->dev.kobj, "physfn");
> +	/*
> +	 * pci_stop_dev() could be called for this virtfn before already
> +	 *  so directory for the virtfn is removed before.
> +	 */
> +	if (virtfn->dev.kobj.sd)
> +		sysfs_remove_link(&virtfn->dev.kobj, "physfn");
> =20
>  	mutex_lock(&iov->dev->sriov->lock);
>  	pci_remove_bus_device(virtfn);

Cleaned up the commit & comment text a bit and put into -next.  Please
check it out.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/6IQlFvg_EPB2Iirxyle1AOW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNYCBAAoJEIEoDkX4Qk9hkJEP/Ax4RE0IWNSTZ23/ZsBxgR/1
7piNYIHKx9bzCCveWYdlA685CeK6VRArFrdHm31NKAf+3vPmXCW5tcGI2gqk18RH
ERNKbhgWnzWA59d5QgC3kM0D563IKedk+7v/68FHlDDOva8C+ppsv6ZHV7DPqgmq
MsY9zeHhWgW9OsRHoJVjRo0BtAoks4HPB5+8qlLbfjg6HHfoXYQx+x9C97Qxh67C
w5orVnNze0EyGZZ87UChO/ac9N1YVwTbd9mpV86iSfqh4Xr/GepRPLET9p+k8wTb
AQuuC5DBipM17rm3d4RhE8sMmscTSj63hmchEh7nFOz9G7nZPtP7yJhbEG34C2z2
wpQVuTl3OFSv4OrtaWkWSotyg9ZWJsHnxdDGc7lLsnvPiKhZXifjgAlygB34a3Ch
aUheugeOA4G1BUsCnrzlOXwDY3g0EQGvBnTkYBz7rpfkEMLrKh4uTp1ZptnNPqmV
R91MyOhUxJUOgPsYg6qjzD8E7nxszEZZsbJdHm3cJ3Yfce2QhiV4R012Rn/rTE5y
7C7u/PGkLlTdLj8EajjCgy5ltu9F1WEseOmN9Kvyipebus/SpiDetQE5m6aO+VCV
UbDE79E8BkdDsNXHrimSuVBdk752GesE+TWMOsso7wfyt3dx3l4UlyzbbXqe0bDi
cEBqy37I4dvE58Ok8KiN
=EE5E
-----END PGP SIGNATURE-----

--Sig_/6IQlFvg_EPB2Iirxyle1AOW--
