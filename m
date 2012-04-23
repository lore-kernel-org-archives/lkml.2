Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2DWASM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 20:18:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab2DWASK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 20:18:10 -0400
Date: Mon, 23 Apr 2012 10:18:02 +1000
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (md
 tree related)
Message-ID: <20120423101802.45d59ffc@notabene.brown>
In-Reply-To: <20120420153448.2257c33126add9118757791a@canb.auug.org.au>
References: <20120420153448.2257c33126add9118757791a@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=unAAIkUdK1NBToVWU0=4XQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=unAAIkUdK1NBToVWU0=4XQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Apr 2012 15:34:48 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
>=20
> After merging the final tree, today's linux-next build (i386 defconfig)
> failed like this:
>=20
> drivers/built-in.o: In function `bitmap_resize':
> (.text+0x202b76): undefined reference to `__udivdi3'
> drivers/built-in.o: In function `bitmap_resize':
> (.text+0x202bac): undefined reference to `__udivdi3'
>=20
> Caused by commit 6c5cb1922cca ("md/bitmap: add bitmap_resize function to
> allow bitmap resizing").
>=20
> I also get these warnings:
>=20
> drivers/md/bitmap.c: In function 'bitmap_resize':
> drivers/md/bitmap.c:1878:11: warning: comparison of distinct pointer type=
s lacks a cast [enabled by default]
> drivers/md/bitmap.c:1887:11: warning: passing argument 3 of 'bitmap_get_c=
ounter' from incompatible pointer type [enabled by default]
> drivers/md/bitmap.c:1225:26: note: expected 'sector_t *' but argument is =
of type 'long int *'
> drivers/md/bitmap.c:1892:12: warning: passing argument 3 of 'bitmap_get_c=
ounter' from incompatible pointer type [enabled by default]
> drivers/md/bitmap.c:1225:26: note: expected 'sector_t *' but argument is =
of type 'long int *'
> drivers/md/bitmap.c:1920:8: warning: passing argument 3 of 'bitmap_get_co=
unter' from incompatible pointer type [enabled by default]
> drivers/md/bitmap.c:1225:26: note: expected 'sector_t *' but argument is =
of type 'long int *'
>=20
> I applied the patch below for the link failure, but the above warnings
> should be addressed as well.

Thanks Stephen.  I've fixed all that up now - and done a test 32-bit
compile :-)

Thanks,
NeilBrown

--Sig_/=unAAIkUdK1NBToVWU0=4XQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5Sfujnsnt1WYoG5AQJbJg//VGvQKmJRcXDeHH6hdt30wIuAaeBsxGfN
Dc+w85BD0MDU3pFgm8fL64SfhHIpidQWTlh+eQ7Vs/ikbU/7y/40JnJaPBAP+DE1
Mi7ZfRftIkpc6mlE3OJBmP2V7K7VZwjHRtBU8uQX3Prh0TJEf0zlh7z0SMx/GFI/
yR7ZK+VZE0cSZmRNCX8GjrR2T0Kco3lCGuR0y1yYKMSOVFqCWGHC1FkKQYSkaM1o
Bvx/yHvNDcQZ+ssceWgiiZXMOEjt3ZwX9Ny0za4vTY6A6qj9HmfCMNtGoYmnsFKF
wb/qBcK4uJfvjLYn2oKOjFxIWnzNxwE0lUl+2T5it6R9gNSX42xnTwQ6uYS6UtQL
ywEBQ2yIV5cpNNrOYMHz/QrY4Ve/V7nZAQ8QCygcEDgpUw6HzCHzLyMjPqBfZqsj
DuHW5VI032Q7NlgK78Q5wKSYLsJ7F6DErPdNmaosYGWhbGLjxe75SWUrWTpbFlqk
V2Mf+aOPB2jGnATeFzfA9s2BiZ0qE3wnZPkExDqI+D3YGeTCKoiTMfHAdP1L6Eo6
KdKCCQtUGbf+cUcupXlW/8Az/mAngSEQVfENZ0uQBUC4XbPdsGQ3VTDYdR3ZaH9I
ZWz5sIQHCuca8dlLujQix/6BskNPo6OOJaBj3eaZAa6JNbC7ENbsij/86sxgtKgn
j44lW7I20Ms=
=kQQS
-----END PGP SIGNATURE-----

--Sig_/=unAAIkUdK1NBToVWU0=4XQ--
