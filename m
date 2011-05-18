Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab1ERD6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 23:58:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56273 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab1ERD6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 23:58:40 -0400
Date: Wed, 18 May 2011 13:58:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kiran Patil <kiran.patil@intel.com>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Yi Zou <yi.zou@intel.com>
Subject: Re: linux-next: build warning after merge of the scsi tree
Message-Id: <20110518135823.a809f829.sfr@canb.auug.org.au>
In-Reply-To: <1305684362.2856.349.camel@haakon2.linux-iscsi.org>
References: <20110518114912.dfdf8835.sfr@canb.auug.org.au>
	<1305684362.2856.349.camel@haakon2.linux-iscsi.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_May_2011_13_58_23_+1000_FP0RayMP1l8HFjcD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_May_2011_13_58_23_+1000_FP0RayMP1l8HFjcD
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

On Tue, 17 May 2011 19:06:02 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi=
.org> wrote:
>
> On Wed, 2011-05-18 at 11:49 +1000, Stephen Rothwell wrote:
> >=20
> > After merging the scsi tree, today's linux-next build (x86_64 allmodcon=
fig)
> > produced this warning:
> >=20
> > drivers/target/tcm_fc/tfc_io.c: In function 'ft_queue_data_in':
> > drivers/target/tcm_fc/tfc_io.c:209: warning: format '%x' expects type '=
unsigned int', but argument 5 has type 'size_t'
> >=20
> > Introduced by commit 3699d92a4d7b ("[SCSI] tcm_fc: Adding FC_FC4 provid=
er
> > (tcm_fc) for FCoE target (TCM - target core) support").
> >=20
>=20
> It appears that this warning was fixed in LIO upstream a while back, but
> did not make it into this morning scsi-misc merge.  Please apply.
>=20
> >From b830de5068d0c3745e83393f81d87f745ef7a4f2 Mon Sep 17 00:00:00 2001
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Thu, 17 Feb 2011 21:56:16 +0000
> Subject: [PATCH] tcm_fc: Fix conversion spec compile warning in ft_queue_=
data_in
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> This patch fixes the following compile warning in ft_queue_data_in():
>=20
> drivers/target/tcm_fc/tfc_io.c: In function =E2=80=98ft_queue_data_in=E2=
=80=99:
> drivers/target/tcm_fc/tfc_io.c:209: warning: format =E2=80=98%x=E2=80=99 =
expects type =E2=80=98unsigned int=E2=80=99, but argument 5 has type =E2=80=
=98size_t=E2=80=99
>=20
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/tcm_fc/tfc_io.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_i=
o.c
> index 4c3c0ef..3936bb1 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
> @@ -206,7 +206,8 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
>                                                 "xid <0x%x>, remaining <0=
x%x>, "
>                                                 "lso_max <0x%x>\n",
>                                                 __func__, fp, ep->xid,
> -                                               remaining, lport->lso_max=
);
> +                                               (unsigned int)remaining,
> +                                               lport->lso_max);

Given that "remaining" really is a length, surely it makes more sense to
print it with %zd than to cast it and print it with %x ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__18_May_2011_13_58_23_+1000_FP0RayMP1l8HFjcD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN00PfAAoJEDMEi1NhKgbsvWoH+wcpbpp6ojL8nxHoyCce8h4L
QtupWyDAIE05m/7aGIesul1wVk5jmFlMODItqm2Uqpi5ArbjlhwKiNeCoGHOTdBO
2U2awHuH67+bVvN3z23QymwvKm9LY4NTw6kbGdfUmgM/AIjFo8GszbIVBve1pDK7
uMLSueCFjlLyXY8pljexSPZIbzaOrf/pIJmUe6ckMHGNabtD4vk84PWExKC2RBvz
sgIwzKl6VZAh2QQwl0VxLINZOBGikwo2tm9rRUU8ZhXEYlT/bMn55Wwa9fWFJbck
PsFZxPhGGIpC8bETSXMx0AfTJoGGMkaEJ5bF6F+DxQYQnktMkIwSl8sUFLi+/eo=
=3Qx/
-----END PGP SIGNATURE-----

--Signature=_Wed__18_May_2011_13_58_23_+1000_FP0RayMP1l8HFjcD--
