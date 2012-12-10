Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068Ab2LJCVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 21:21:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab2LJCVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 21:21:37 -0500
Date: Mon, 10 Dec 2012 13:21:23 +1100
From: NeilBrown <neilb@suse.de>
To: device-mapper development <dm-devel@redhat.com>
Cc: gzhao@suse.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 0/3] add resync speed control for dm-raid1
Message-ID: <20121210132123.5a4ab015@notabene.brown>
In-Reply-To: <1353565673-4233-1-git-send-email-gzhao@suse.com>
References: <1353565673-4233-1-git-send-email-gzhao@suse.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Sx.1tE3ezEd02Ak/McFn=xI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Sx.1tE3ezEd02Ak/McFn=xI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Nov 2012 14:27:50 +0800 Guangliang Zhao <gzhao@suse.com> wrote:

> Hi,
>=20
> These patches are used to add resync speed control for dm-raid1. The
> second and third patch provide support for user-space tool dmsetup.
>=20
> Guangliang Zhao (3):
>   dm raid1: add resync speed control for dm-raid1
>   dm raid1: add interface to set resync speed
>   dm raid1: add interface to get resync speed
>=20
>  drivers/md/dm-raid1.c |   93 +++++++++++++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 90 insertions(+), 3 deletions(-)
>=20

The problem with this approach is that it slows down resync even when there
is no other IO happening.
If that is deemed to be acceptable, then the patch set seems fine, though I
would probably make the default a lot higher so as not to change current
default behaviour for anyone.

If it isn't acceptable, then you either need to monitor the number of
requests going to the underlying devices - like md does - or monitor the
number of requests coming in to the dm-raid1 target - which is probably
easier with dm.

i.e. only impose the rate limit if there have been any requests for the
dm-raid1 target in the last 'RESYNC_JIFFIES'.

What do you think of that?

NeilBrown

--Sig_/Sx.1tE3ezEd02Ak/McFn=xI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMVHIznsnt1WYoG5AQJT4w//d05qha+0BkL9K8mdK5nrCCBMmPhWktls
99pX6YDapiHzIV4HiDQR/xLiddTo9E8mzpG9CMTKFsFWx5JFN3gi6e70XiVMCDot
oMsHgKIQc3Xwesu32emXzPUQkUSau9E8deHOp/cEl3JEdEn1sY3s0qSymrBjvitt
JsB/4uo4kUdqcJPdSO+2JAZbo8AAhT7h8OelfnlohRgoOGEmrLtyd5FXwOQDlYsp
KlKkHpY0FI+GS7eU7GubzKU8WGi+Ac+P5r5RctcyLPPqu5/ISeWghR9ohGzIrnW5
lSTuYoikoda50S2XFSV/tWoF48rm8sgxyC64SBZfHZtWr+HBc5zDVURvrn75utga
32HhtUH7m12i2c32BDj5Se09jw67aSl77WQb/yXGTHZfqvKvVBm98Tw543HgCUR7
dYk1VuLw0H83uy2g+27wluNnFd+zbbaM7+AYLL771Ik/AXlYp9gPJRYRgXEJeySN
JINTcCCWdCXEyTc7Hm1QLOXOj0yw2x/3a87YziCmrB9G04MRXexlzLbSIW7qpi/O
TQHLL8VK8SCyhHKb04wD3Ilb7umatcYcMbjnuDJMrlZf5qUIxFhcPd6ax3jC7i1e
ZFiiWCciN9NYandLW/0WVn8wUp6pBXXfmRrzXLyq9pm3csb2JnHxoPF6L/4SYgZP
npWdQMKTTYQ=
=YJtW
-----END PGP SIGNATURE-----

--Sig_/Sx.1tE3ezEd02Ak/McFn=xI--
