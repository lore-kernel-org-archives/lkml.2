Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2EMOlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 10:41:39 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46651 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab2EMOli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 10:41:38 -0400
Message-ID: <1336920094.2003.20.camel@koala>
Subject: Re: [PATCH] [RFC] UBI: Kill data type hint
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Date: Sun, 13 May 2012 17:41:34 +0300
In-Reply-To: <1336738443-112022-2-git-send-email-richard@nod.at>
References: <1336738443-112022-1-git-send-email-richard@nod.at>
	 <1336738443-112022-2-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NPq7KQPKGWPvOLrikujk"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NPq7KQPKGWPvOLrikujk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Fri, 2012-05-11 at 14:14 +0200, Richard Weinberger wrote:
>  struct ubi_map_req {
>         __s32 lnum;
> -       __s8  dtype;
> -       __s8  padding[3];
> +       __s8  padding[4];
>  } __packed;


The "dtype" field is part of ABI, and merging it with padding is bad
because padding holds "free" fields, which can be used in future. But
"dtype" is not really free. I think it should stay here. You should put
a comment explaining that it was used in the past for this and that, but
now unused and ignored by UBI. Probably a date when we stopped using it
would also be good.

May be it even deserves to be in a separate patches for this one and
ubi_leb_change_req ?

Thanks !

--=20
Best Regards,
Artem Bityutskiy

--=-NPq7KQPKGWPvOLrikujk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPr8geAAoJECmIfjd9wqK010UQAM+07sMXeY1Eaz1SAYiEA8Ui
/UwJ4PDq7bTA5pygic8LQPkAPGNUcq6RegUkldV1shLBbJJ9W9wt/5NnRkg9/y/M
7stKM2Q2D6Nx7F0Ckml+2VJIvQfx/4yOKPvuZxlCoh2XjigrImI9npCvR6HE3D6s
NZMbMnHgzXaYHJOqEHq5dhrFCs0bwSLo65fOU52bQavRFd/OwmMdiBEgUN8ePE1j
nepm7Dzv3H6U6S7z+6pQrdAuoqJ2vckSXuKU7LYSuap7Im6HNy+o9gKOMweZXMSp
SzCOqwMFHzJw6//AK/roEGxw7XYWJZzxoINcSlfSWuf0NQNp1XkJNR27F/sRBwyw
Qzoqxv9HBNDUxyP7/TRdhm4yDgbnm8mTcaZHwjBIKV5QofJ5K0KjZFAcDTSNStXv
yk/hwtxc4QwZ2cLY1Xl6GyzCDiPM5wGc/QtyH/eC6Sgv8ZSD6c55aOaAcmSo+ESq
AxeJyGhL2dOCxXlzN84xLDOa615/xjgEYlYuhYAJQocTaVsClx17QB0jYRzZ33qG
mM4wcmt8vCVc8rjPFvm3MonV0ngYcyBzgj+ArZQTKMb3TZ8ITGS+sUSUV0EExuct
6EyHLeqfz2ato5cHwh4wv/POekmRComhigoENIy4i5ZPDoZHKl4NNPm7niTFto50
/gx9394f4Hv3uwwjMVBu
=P2g0
-----END PGP SIGNATURE-----

--=-NPq7KQPKGWPvOLrikujk--

