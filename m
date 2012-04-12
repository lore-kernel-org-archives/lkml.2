Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab2DLGSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:18:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab2DLGSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:18:15 -0400
Date: Thu, 12 Apr 2012 16:18:05 +1000
From: NeilBrown <neilb@suse.de>
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: lib/raid6: SSSE3 optimized recovery functions v2
Message-ID: <20120412161805.133c4ad0@notabene.brown>
In-Reply-To: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n8PRusdB.6g8ogvYuiy1PeX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/n8PRusdB.6g8ogvYuiy1PeX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012 12:40:27 -0700 Jim Kukunas
<james.t.kukunas@linux.intel.com> wrote:

> Hi Folks,
>=20
> The following patchset adds SSSE3 optimized recovery
> functions to RAID6.
>=20
> This version differs from version 1, in that:
>         0) cpu_has_ssse3 is moved to within the #ifdef block
> 	1) the functions are moved into their own file, recov_ssse3.c
> 	2) a superfluous memory load is removed from raid6_2data_recov_ssse3
>=20
> A technical description of the algorithm can be found
> at http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
>=20
> Thanks.
>=20


Thanks.

Could I trouble you to run 'checkpatch.pl' and fix up some of the more
reasonable complaints?

ERROR: open brace '{' following function declarations go on the next line
#243: FILE: lib/raid6/recov_ssse3.c:28:
+	static const u8 __attribute__((aligned(16))) x0f[16] =3D {

is clearly bogus, but=20

WARNING: __aligned(size) is preferred over __attribute__((aligned(size)))
#243: FILE: lib/raid6/recov_ssse3.c:28:
+	static const u8 __attribute__((aligned(16))) x0f[16] =3D {

is probably worth considering, as are some others.

NeilBrown


--Sig_/n8PRusdB.6g8ogvYuiy1PeX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4ZznTnsnt1WYoG5AQIU1RAAmMmltjaU7mNNucwS6cD4xoK4XBTRG1XF
LKzoSlJQoN0c2phBwMk18bsHsJ5oL1XK7nlBTgtGUc6JD3k7V/1dh8mDMB15KvS0
F3Z6VW5HF2b2N09g9YKyyCN2HXqgk9VfHhrgeRbk++vE6c3dtYMrawNtr/pTX7pI
mDaWUcPQdRK9Qs+RYFbzXcqLcSkyx1Dnbl/OTbClfY1v9YzzEuqBLkLXJ8eItqBn
Z34WSkmb5oPKt9mcjgfl9enTks5YGEKO24UBmBtE151fz279QDkW5MgYxrtNmI22
iIQKXlfE5gvAQOZBDz8oy0O4ibvJ+aGUrRkv54wXYhE8Vw8i1u9rK1KdhvSAxyGZ
O+aqeQGgPiEhBqhKg+BwULiesJ0G+7AXX2k1e/Mt1jDHRH6S5N3qB4NhBV2mDcEb
JNTfT89KAC6n4dW8zXIcYiQ6ftN5QdtwfwKFZ0foyNww7Ypj2A7CDlVtTks7VHey
llbLj5XNAYjMkxQx4JrqOKrnyVFw2wsV3N8wh+5A6MZsLZ6KQzzKMAXVJRrUg0e2
w2XP4N2YW2WswGTwPldE/dwuSi5HadPB1J3mt4Frg25R05vxHWLUNfL6zoxAHn4B
9Yaw2Mv9MT8Zwn0ISXNNKqk8DyDdxdYRX9NBrQ1vsOCcFsxuD4r+7ertgOwJ07Mr
NC9pORGUS80=
=5cBh
-----END PGP SIGNATURE-----

--Sig_/n8PRusdB.6g8ogvYuiy1PeX--
