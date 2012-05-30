Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2E3PPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:15:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:59054 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2E3PPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:15:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="158734298"
Message-ID: <1338391121.2536.94.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] UBIFS: compute KSA size and store in superblock
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 18:18:41 +0300
In-Reply-To: <alpine.DEB.2.00.1205301531220.6465@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205251509220.2989@eristoteles.iwoars.net>
	 <1337952271.30969.37.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205301531220.6465@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QFUtqbYJzFhh4au76/V2"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QFUtqbYJzFhh4au76/V2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2012-05-30 at 15:32 +0200, Joel Reardon wrote:
> @@ -389,6 +408,7 @@ static int validate_sb(struct ubifs_info *c, struct u=
bifs_sb_node *sup)
>  	 */
>  	min_leb_cnt =3D UBIFS_SB_LEBS + UBIFS_MST_LEBS + c->log_lebs;
>  	min_leb_cnt +=3D c->lpt_lebs + c->orph_lebs + c->jhead_cnt + 6;
> +	min_leb_cnt +=3D c->ksa_lebs;

You need to validate that:

1. if use_ubifsec is true, then ksa_lebs is not zero.
2. ksa_lebs is sane - not too small, not too large.

> diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
> index 90f348c..1dda25d 100644
> --- a/fs/ubifs/ubifs-media.h
> +++ b/fs/ubifs/ubifs-media.h
> @@ -618,10 +618,13 @@ struct ubifs_pad_node {
>   * @rp_uid: reserve pool UID
>   * @rp_gid: reserve pool GID
>   * @rp_size: size of the reserved pool in bytes
> - * @padding2: reserved for future, zeroes

Do not remove this comment.

>   * @time_gran: time granularity in nanoseconds
>   * @uuid: UUID generated when the file system image was created
>   * @ro_compat_version: UBIFS R/O compatibility version
> + * @crypto_lebs: number of LEBS being used to store keys
> + * @use_ubifsec: the LSB signifies whether the file system should use se=
cure
> + *		 deletion
> + * @padding2: reserved for future, zeroes
>   */
>  struct ubifs_sb_node {
>  	struct ubifs_ch ch;
> @@ -649,7 +652,9 @@ struct ubifs_sb_node {
>  	__le32 time_gran;
>  	__u8 uuid[16];
>  	__le32 ro_compat_version;
> -	__u8 padding2[3968];
> +	__le32 ksa_lebs;
> +	__u8 use_ubifsec;
> +	__u8 padding2[3963];
>  } __packed;

--=20
Best Regards,
Artem Bityutskiy

--=-QFUtqbYJzFhh4au76/V2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPxjpRAAoJECmIfjd9wqK0/UUQAMgxA9zYWz3K6ZuK6VTQ4YkJ
pNCdK4J7uFxTZeH08lFefgmR3Vfn2yTRQKvB46UC4cRJ5LCmAmWVxSWGfa7P7W/8
EsRKF1TsH1MV7aZcT4/GnYD3gQQMtRGRsSE0r1qsrmA2cfLLoD8QnNd35ahK94LB
phWjaHNswTlkmi5fcAcOrbB02tpC57vlz1YsiqpAVR/L/KWh4oyfQoGqLbgLbXAE
Swy0plGCtiBxFfygb5yrCenriDbpZZjxtZDz1ObsBLz6iWwTAxHpIIhyGmg/+0co
dTRA583JGEjfDIrsCPaSkHwJCW1H8MCppEoT7l2vlwbpRD0UAyUV6M4xikJSKf98
249SJ5QbQEny7g8gf9H8Ohz2W6iuPJrIeQEgx7ps/u4tTZ7HTgmWoGOwtbsHVrY9
Vhh6g9lSaTXW0SJkCzUcl5ZXrr09qlYsbetcLtelMIta58qPqGsBjQsSPdUDzEuE
vYA84kul4JjlZtolwqjAA0LqBH5MV4sk5MffsftNSfsZ4jvscqsMDf3hD5d6gEXe
WLXUlXT52lGdsOYYyNx+5ZW8S1otW1PO0jAfeUhVJiRkdNIJw05yBjD8+gG0bo9h
y38P27bZLZRJdA8RoiIhvxEwhvY7v3Xv1ec6tSiG/nM7eXhySgpBHCd5Beuncm3d
2Y5zUAWH6IEA2eTke3Kc
=uQsK
-----END PGP SIGNATURE-----

--=-QFUtqbYJzFhh4au76/V2--

