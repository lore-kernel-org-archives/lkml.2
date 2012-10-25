Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660Ab2JYOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:16:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38784 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab2JYOQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:16:54 -0400
Date: Fri, 26 Oct 2012 01:16:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the akpm tree
Message-Id: <20121026011645.5a4e6adac51cf0bdc44e48bc@canb.auug.org.au>
In-Reply-To: <20121025141232.GB4730@richard.(null)>
References: <20121025142854.1924363d6a607004f918ac63@canb.auug.org.au>
	<20121025143044.d21e2c29b16ee2005f93a371@canb.auug.org.au>
	<20121025141232.GB4730@richard.(null)>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Oct_2012_01_16_45_+1100_G6oLNqw28EGPa3C8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Oct_2012_01_16_45_+1100_G6oLNqw28EGPa3C8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Thu, 25 Oct 2012 22:12:32 +0800 Richard Yang <weiyang@linux.vnet.ibm.com=
> wrote:
>
> I did a quick check.=20
>=20
> The root reason is,=20
> 1. kfifo_in() second parameter should be type "const void *"
> 2. kfifo_out_locked() second parameter should be type "void *"
> 3. kfifo_in_locked() second parameter should be type "const void *"
>=20
> And I am curious about why the original code couldn't detect this type
> mismatch. =20
>=20
> The reason is: the original code use =3D not =3D=3D.=20
> so when a const void * is assigned another pointer type, there is no warn=
ing.
>=20
> While I write this test code, there is still no warning.=20
> int   main()
> {
> 	int *a;=20
> 	void* b;
> 	b =3D a;  // this should be ok.
> 	a =3D b;  // this should need the type transfer, but still no warning.
> 	return 0;
> }=20
>=20
> Hmm... not understand. Any error in my test code?

Yes, any pointer can be assigned to a void pointer and a void pointer can
be assigned to any pointer, so neither of the above should complain.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Oct_2012_01_16_45_+1100_G6oLNqw28EGPa3C8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiUnNAAoJEECxmPOUX5FEVsAQAJnO4pBL40JIw00691UOPg93
MJcWhNjtclBo92HfR4bafrkMuHby7YVzShkWZ5G0mJ3GRYDthFnf26uSWaTZ0DuE
UuSTWfhWoIvJyzL9aAPLZYiOKgVi95b/dnhfFlrg8lRKHysMLarZErVlrMV7VXeq
dWFow0ieIC5+tduUvaWUVDOvmsMiAfEMV8RK4Dyrn0yHuxhTZ/EvZa65iOrNL+g2
9zlLcsvCDey0cYT52CxzxRGwc8kXc5ra2Ee1JxqMP4mfNwxkiXaomiXIsv8qN8HE
Ecnba17OxWpvpty/ytKx/3lKppmDQnzSWObx2lOke10rzetosS9ocvRF6SVAzIit
Oy3YfGZVZNbVKIiV9K4LL+UpvvwWEcr7hjlXrNCqYxGbbN/D1dYgvYsGCoMiWQK7
BWVE43V/jU/kMMI55NJJIGtJ0ILZJnIsuZveh5olqn6XibaLSFGAUaj1s7zc0d9A
KwqFiOkWFbh8KfDpeL6XGIg1xwY/DdmCCIUd5aAHxAYyhTELhlx+3XvW4/CvMeqH
Y7JRu5/2EUDrGW8GSFBP+Vw3HDCCR2fSePWEUsKThRYhIy7LmNzMsE6qCIUO3OS4
JTNWZVkjyr6TPwY4YY5jUaplP959Gwxl4E/goEft9/sGneoNJIMj5xilBQ6HKHtL
oPRTKwERticdK7Lws9qR
=wEuT
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Oct_2012_01_16_45_+1100_G6oLNqw28EGPa3C8--
