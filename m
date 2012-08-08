Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab2HHPPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:15:54 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:50847 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758663Ab2HHPPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:15:52 -0400
Date: Wed, 8 Aug 2012 18:11:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: iommu@lists.linux-foundation.org, linux-tegra@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/tegra: smmu: Use __debugfs_create_dir
Message-ID: <20120808151128.GC9091@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
 <1344407073-12030-3-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <1344407073-12030-3-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 08, 2012 at 09:24:33AM +0300, Hiroshi Doyu wrote:
> The commit c3b1a35 "debugfs: make sure that debugfs_create_file() gets
> used only for regulars" doesn't allow to use debugfs_create_file() for
> dir. Use the version with "data", __debugfs_create_dir().
>=20
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Reported-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/iommu/tegra-smmu.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index 5e51fb7..41aff7a 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -1035,9 +1035,7 @@ static void smmu_debugfs_create(struct smmu_device =
*smmu)
>  	int i;
>  	struct dentry *root;
> =20
> -	root =3D debugfs_create_file(dev_name(smmu->dev),
> -				   S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
> -				   NULL, smmu, NULL);
> +	root =3D __debugfs_create_dir(dev_name(smmu->dev), NULL, smmu);

why would the directory need extra data ? Looking in mainline,
tegra-smmu.c doesn't have any debugfs support, where can I see the
patches adding debugfs to tegra-smmu ? It doesn't look correct that the
directory will have a data field.

--=20
balbi

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQIoGgAAoJEIaOsuA1yqREoO4P/3IGJvcLfa5Uv9B/cTujVivE
pfCLPj9x6+MXNKl+J5Qkqw6PuSDC011vRd8rdWL0SX7bpVYpR7ES9BTr0ryPlvFj
Yy/UboqL5YxMFqLiDOO5xzb6YFXmjXixvnPAZ/CngudVqrXeXv5aPUQBxwNBFPDV
QL1svrcFBEtgdOqfvspBHF4lLnTJGOe2Z7U2k/cqbWsKbunvxUDrDtXcciRXHuNs
+QDHzNS6PH7q4Qv+oqTI01pKAniTVzrCGKYBeX7fZipAZbIgcEyLIsx562i4hzzA
7IEaX9ugpEw+p3pilGGIAFxXbiao+EUalP8M1D0dg8296YctjmPa8Lna7986mVH3
5w7zHL65RnbvIQKRHZgbn9+CLUrBSz5hASbHDyIif0huADnIrcTOc+oSjFkqLRL+
R2N6YSQxEgdkVRZOWyUXJrSOC2Eu607Pj3+bUS5FcOx9gn0c8oC03ohLxgTQxIdu
bJEHiD5TpsJplDczXlVcZ/qaMaCtO4Ggp7xtzlZzQroVtG75q9YeZDCfehtaq3oo
0J4jbyph/T3wh/cSm7iI7VaXLo09ogfS9J1TQM1AUmZ44Dip4kNBpWgKbMj6fT8e
xaUFbQA69WjpHw1D+NZai0SHvoNFJpZhyQI0yQR8P7WswfQZ4xc5XuUAK953xncQ
yTM7Zx/Msoz/T0rJgQth
=b59e
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
