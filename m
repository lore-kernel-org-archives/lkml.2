Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1KWOvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:51:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:43309 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1KWOvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:51:41 -0500
Date: Wed, 23 Nov 2011 17:50:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mori Hess <fmhess@users.sourceforge.net>, security@kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <abbotti@mev.co.uk>,
        Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: Re: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
Message-ID: <20111123145020.GA3258@mwanda>
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com>
 <20111123061355.GA3295@mwanda>
 <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4ECD0827.00BD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2011 at 08:59:52AM -0500, Xi Wang wrote:
> Thanks for the pointer.  However you cannot do the overflow check using
>=20
>   if (sizeof(struct comedi_insn) * insnlist.n_insns < insnlist.n_insns)
>=20
> Let's assume 32-bit system, sizeof(struct comedi_insn) =3D 32, and
> insnlist.n_insns =3D 0x7fffffff.
>=20
> Note that 32 * 0x7fffffff =3D 0xffffffe0 overflows but bypasses your chec=
k.
>=20

Argh...  You're right, my check is wrong.  What I like about my patch
though is that it doesn't introduce an arbitrary limit.  Could you
redo your check without the MAX_INSNS?

regards,
dan carpenter


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzQgrAAoJEOnZkXI/YHqRdS0QAJ+B7bpDYFkjtYQKAHZCmDbD
V/g9eoZY0MAKiUT+NuPT1EmpaEYaDIRFhTTuh4fn5e7QzFaBbREBM29q0EBBF9VN
X9DHYeuy3/b6k3CUOWV/gm9uk66YzY/O9RMpcM5Bee2i+vHNpB2fSl1HYL5GJbJ2
igRZib12HSHHCdiu8HrIbLU9n6GYlaI8WNO7cOKx5C30KZky3TcMEGlYc66/R5NS
Pm9Z+Dqb5/s/02XBXJgWRKzgIRE4l9RZYkDggTN5pJ6fcD3AJmOdBebeO7xncVa6
kX29/7MgosdVOlclptYaFTskP/7ZehhN450zPMoW40OKLcpsck1DGfGGQuCuZvja
x3QNkRmjsqaITMdR1gdgoynEWcaaPgRC0dox7Kttkb3DEMruik6uB9n1Ac+vd/uB
FsVq6zX67RMAo4hRZCOlxuwxoXqdIH6wY+KYHNP1cnaXYo1JoUcwQ1+jWqXe8VvY
MKZvirX6sRVPSfRpc4aakooUuufWnLLUXCDDgmUjmKXh1apw+0xVJp+INqPIr9RK
vk1Yig3wJHNZlDISC+A33BWoHBrS9qNeY5FLvOfeQ0uMwGYdHUMzPeoVq4qeT5su
hfa0eqyQzaB4iXmRSiX/8BNs9DWFeN7qVQAdeCZhrpiX+QTpxNfDfuDoptZeavDA
BeQ8u4VImhLj/ZhUryp2
=7YTq
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
