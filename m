Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519Ab2CGRfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:35:46 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26060 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683Ab2CGRfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:35:44 -0500
Date: Wed, 7 Mar 2012 20:37:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, wharms@bfs.de,
        lindar_liu <lindar_liu@usish.com>,
        James Bottomley <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jack Wang <jack_wang@usish.com>
Subject: Re: [PATCH] [SCSI] pm8001: fix endian issue with code optimization.
Message-ID: <20120307173751.GS22598@mwanda>
References: <4f4a4580.aa3a440a.34c7.2776@mx.google.com>
 <4AB8AEEB15F74D15A87019F5663EA805@usish.com.cn>
 <D65B94D9-B33A-436F-9BCE-A500B35652D2@xyratex.com>
 <00F74E64-A5EC-4DF8-A347-2D8BC5659638@xyratex.com>
 <4F5785A9.2040707@bfs.de>
 <2E1367F2-077A-4654-8932-4FDAEE56240B@xyratex.com>
 <CAOD=uF67VkUnqYQQpgP=+0ndw-x+c1uWqN3-JUAVN24bgV2c=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MdJ3p2aQbVp3YFXz"
Content-Disposition: inline
In-Reply-To: <CAOD=uF67VkUnqYQQpgP=+0ndw-x+c1uWqN3-JUAVN24bgV2c=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F579C66.00D8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MdJ3p2aQbVp3YFXz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 10:54:17PM +0530, santosh prasad nayak wrote:
>  static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  {
> -       u32 pHeader = (u32)*(u32 *)piomb;
> -       u8 opc = (u8)(pHeader & 0xFFF);
> +       __le32 pHeader = (__le32)*(__le32 *)piomb;
                           ^^^^^^^^
You could drop this cast, "*(__le32 *)piomb" is already an __le32
data type.

regards,
dan carpenter



--MdJ3p2aQbVp3YFXz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV5zvAAoJEOnZkXI/YHqR1wsP/2N7xa91n+Fe71cgiKE8k+W/
GZv9rk/mFmVmSqbTv8akmIzHlL93f5LSgw0guzAqqlcD117D8tVigkH/L7M0hKkS
OoLF2oRBLH7XMt667FESu0snd/mqDnmMAQituZZipjE3/SbdefYttkWHlX3x0z6B
Dgs7v0UcvA5fWsYb0anTByQJutLO2cXlo9nkFf7OkAyzkoXz1F9vXCwpStsYuNni
+I/+tMFrkQ2WrUPTvk8rd/9ftcImW4vIx+EFryjfGlMmz+okG40LLfxdE22g2qBC
DjvYGKhLPA5Zbzf9CSL0512ROJTMJtrSziH15xFpiN2NJxJf2Rc0niLPG3q1QUVs
k1oH8jE8Z6kQiwMzQttHaOo2Ckn6BquGCUd8wRkHAkky5C18AducKC1IJ+0hPURD
vD7SGiHb50y3SHczvBM0bbRQkUo9EWxh6l2Fg7tmXUvY8xxTft96tO+DNUTCH5hw
p9bEjqA0xegBfBDdsPShxy2Mc5982brJ8YH5gu8dupzIBASMVD+tWcmfOb1hGnZ/
9vrX0RDMveTrIAm4k+DCtLhFKrrMcx0ud5QlDvzb48m82QqDS22rpe4HfVktOw2z
iYAExby4ORfy3xGRTzGTXSbxHEDaA0f91PRi1qq4ImmOIPTza/hblOFhsCTJuAVx
hoOPZ3uk8ff0OzbycAsI
=PxwE
-----END PGP SIGNATURE-----

--MdJ3p2aQbVp3YFXz--
