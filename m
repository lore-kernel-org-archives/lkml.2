Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2LMAOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:14:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24885 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2LMAOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:14:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d6-50c91dd92785
Message-id: <1355357651.24219.21.camel@kjgkr>
Subject: Re: [PATCH] f2fs: fix up f2fs_get_parent issue to retrieve correct
 parent inode number
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Leon Romanovsky <leon@leon.nu>, Fubo Chen <fubo.chen@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Thu, 13 Dec 2012 09:14:11 +0900
In-reply-to: <CAKYAXd-3tvx4feHO5z_2p4FAMS8CvUDVKngh=R178TL4YASadQ@mail.gmail.com>
References: <1355323077-5803-1-git-send-email-linkinjeon@gmail.com>
 <CAJAFBLDE1k+sj4_FpjhSnaVF43twY2RRg=JsbdVVQOT0L4BPEw@mail.gmail.com>
 <CALq1K=J_tDiUoQ2u384KjCqPe6YWzRCL=HJbsgkEOfXug4DOhA@mail.gmail.com>
 <CAJAFBLD9qETdS+6YovpSR2xQHktSdJWk-FmDJ-mJFJfx=3_M4Q@mail.gmail.com>
 <CALq1K=+uWpQ4kzx_FOaH8f=xbtYZP9-Vooh2rwDSp6u6W_H7ew@mail.gmail.com>
 <CAKYAXd-3tvx4feHO5z_2p4FAMS8CvUDVKngh=R178TL4YASadQ@mail.gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-qq+sRZ+NBtG2FoiDp4YH"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zvu5N2ZMBBjt/qljs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVc+bqHqWC1aMXHoysYGxh/CHYxcnJICJhIbF+8iAXC
	FpO4cG89WxcjF4eQwDJGias3Gplgitpf/mGGSExnlFi9aDELhPOaUeLg00/MIFW8AroS22fd
	ZQWxhQUSJa7MuABkc3CwCWhLbN5vABIWElCUeLv/LlhYREBNYsKzVJAxzAJ/GSX+nJkPdgWL
	gKrE6cfHGUFsToFgialrHzFCXcQssff0fbAifgFRiZOtn8CKmAWqJK7N2M0OcamSxO72TnaI
	ewQlfky+BzVUQOLb5EMsIIslBGQlNh0Ae0ZC4BG7REvjZ2aIXkmJgytusExgFJ+FZOwsJKMg
	4poSrdt/s0PY2hLLFr5mhrBtJdatew9VYyOx6eoCRghbXmL72znMCxjZVzGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmKExKX0DsZVDRaHGAU4GJV4eC+8PB4gxJpYVlyZe4hRBWjOow2rLzBK
	seTl56UqifC2/z8RIMSbklhZlVqUH19UmpNafIgxGejTicxSosn5wFSSVxJvaGxsYmZiamJu
	aWpuSpqwkjhvs0dKgJBAemJJanZqakFqEcwWJg5OqQbGhcYCs9VeT1i6b5XZ1CWi6oui+Bhc
	w/vqtu49oaVb2sup6bPFgj/BtyVkSvLl5L7DBzykemesnbPMLOzNbekLi7Z2/YlIuvdiw7Lz
	/NZvXu6+d7vb6Inpl4cVISV32S5Evjl0tWX52zeFgTbvb2WHzd5wxHhJ5sft3atV7prnqH9L
	Frr7PWRxsxJLcUaioRZzUXEiALaw+1wbAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd2bsicDDPpnKVjs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmXPm6h6lgtWjF
	x6MrGBsYfwh2MXJySAiYSLS//MMMYYtJXLi3nq2LkYtDSGA6o8TqRYtZIJzXjBIHn34Cq+IV
	0JXYPusuK4gtLJAocWXGBSCbg4NNQFti834DkLCQgKLE2/13wcIiAmoSE56lgoxhFvjLKPHn
	zHwWkBoWAVWJ04+PM4LYnALBElPXPmKE2LWMWWLv6ftgRfwCohInWz+BFTELVElcm7GbHeJS
	JYnd7Z3sEPcISvyYfI9lAqPgLCRls5CkIOKaEq3bf7ND2NoSyxa+ZoawbSXWrXsPVWMjsenq
	AkYIW15i+9s5zAsY2VcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf9M+kdjKsaLA4xCnAw
	KvHwXnh5PECINbGsuDL3EKMK0JxHG1ZfYJRiycvPS1US4W3/fyJAiDclsbIqtSg/vqg0J7X4
	EGMyMDgmMkuJJucDE1VeSbyhsYmZkaWRmYWRibk5acJK4rzNHikBQgLpiSWp2ampBalFMFuY
	ODilGhiD5//23PtU7Z/TX7uni39nmT9bprF89cvS3v/HFG8fc1jyPkTtTCT7xC11jPMNkjbY
	drL/P573Z/L6q37OzzmYqxOKyqXDFn/lfa7sXDpv5kyJ9CuZ2YcNbh2YvXbGg44HFmfE9Cct
	bWxtzvU7L1vZ8DCPlXe15sPvlSGcXFdlHV7JJ+Qa3NqmxFKckWioxVxUnAgAsbkk00oDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qq+sRZ+NBtG2FoiDp4YH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2012-12-13 (=EB=AA=A9), 07:44 +0900, Namjae Jeon:
> 2012/12/13, Leon Romanovsky <leon@leon.nu>:
> > On Wed, Dec 12, 2012 at 8:50 AM, Fubo Chen <fubo.chen@gmail.com> wrote:
> >> On Wed, Dec 12, 2012 at 5:12 PM, Leon Romanovsky <leon@leon.nu> wrote:
> >>> On Wed, Dec 12, 2012 at 7:05 AM, Fubo Chen <fubo.chen@gmail.com> wrot=
e:
> >>>>
> >>>> On Wed, Dec 12, 2012 at 3:37 PM, Namjae Jeon <linkinjeon@gmail.com>
> >>>> wrote:
> >>>> > +       /* dot and dotdot dentries should have zero-value hash cod=
e
> >>>> > */
> >>>> > +       if (!memcmp(name, ".", 1) || !memcmp(name, "..", 2))
> >>>> > +               return 0;
> >>>>
> >>>> That looks suspicious. If memcmp(name, "..", 2) =3D=3D 0 then always
> >>>> memcmp(name, ".", 1) =3D=3D 0. Why two tests ?
> >>>
> >>> It is not the case vice versa, so you still need to do two checks.
> >>> You need to distinguish dot(.), dotdot(..) and something with dot at
> >>> the beginning (for example - .o)
> >>
> >> Thanks for replying. I understand that the intention is what you
> >> explained. But to me the code says something else: "if the first byte
> >> of name is a dot, return 0". Did I see that correctly ?
> > Excellent catch, I agree with you It will also return 0 for every file
> > which starts from the dot.
> > The right solution must take name length into account.
> Hi.
> Agree. I will change it on v2 patch.
> Thanks for review.

Nice catch!
I made a mistake initially before. Sorry Namjae.
Thanks to all of you.

--=20
Jaegeuk Kim
Samsung

--=-qq+sRZ+NBtG2FoiDp4YH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQyR3TAAoJEEAUqH6CSFDShKoP/jXHVtLGK7IyJpSWGcZFOQEw
JpC8ARex2fQEq61YHvhlfULeLO2e7ihzuavVUW/JkG8jIjU88mEtshUeAh9zKk8m
HIvOcMwgVgpVHCSnfifmZ5M8e4Gd73RkFP2TQXaWulBFv0LOaR/kBl55a0d2vP/I
1F/CnqC0BtCS1gEJ6RcQe9OexmUbvIhn3pU76bq/1x9m+mJsm3/sOReg1qVs0J3X
Mcaf9dOtunXQFU7umJ4l6bTEmDkIOW08aKvNaPiz8SFFZnYWcQHt3iFKyM/ArGlp
PI+Z5x6zlpMLOKF5Qs63BwsjXc01AyAZo6bjL4SmMKizBiOf+K/a0KfEVPYUXVkQ
Lzyd94JD2HxVHqibcY8F0loGInUHqyT+3EWHQ2QNcB8phPEre76AOXbsw8CANFsQ
RTFGD7oYJjhTSPOnQ73Gmzt0FFNZffojvYlY4UEKOqYGHcqkVK7sK8FpK7TOfH37
otPlgX+6FQLG1HYktenjD0XYdPCd8rtdfk2nV09mBtBOBgOBxpS3ulDyTKjljlTu
LUUiTRthg3xcmzzejvS2OiHfTnCI1ZKP+s+7Uh1etMuuPHur4/qwF6Q6gSFQZ43n
XkWOrfWBx+WY1SKi04lwoYCl4jwjSaeDMuIjaHZLayEvMSGYCeWjuWUBR+bwRS1Y
Gy2RmlmSQ7QUh1VtSaVv
=fb03
-----END PGP SIGNATURE-----

--=-qq+sRZ+NBtG2FoiDp4YH--

