Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1C1BV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 21:21:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44416 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab1C1BV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 21:21:57 -0400
Date: Mon, 28 Mar 2011 12:21:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: linux-next: manual merge of the xfs tree with Linus' tree
Message-Id: <20110328122148.1b48a742.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Mar_2011_12_21_48_+1100_=LIa9Bz6Z/i51/Hw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Mar_2011_12_21_48_+1100_=LIa9Bz6Z/i51/Hw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xfs tree got a conflict in
fs/xfs/linux-2.6/xfs_buf.c between commit 7eaceaccab5f ("block: remove
per-queue plugging") from Linus' tree and commit 0e6e847ffe37 ("xfs: stop
using the page cache to back the buffer cache") from the xfs tree.

I assume that these changes (on both sides) were discussed somewhere, but
maybe not clearly enough?

I have no idea how to fix this, so I tried to just use the xfs tree
version for today.  That failed like this:

fs/xfs/linux-2.6/xfs_buf.c: In function 'xfs_buf_lock':
fs/xfs/linux-2.6/xfs_buf.c:923: error: implicit declaration of function 'bl=
k_run_backing_dev'

So I used the xfs tree from next-20110325 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Mar_2011_12_21_48_+1100_=LIa9Bz6Z/i51/Hw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNj+KsAAoJEDMEi1NhKgbsVo0H/1MTib0r0CN5jaNXlBGWRo0M
mlIlqbk6seWpNP56LgiUsxLWo/Lrmc6BvFtWb1bDqm493ajBdIJOBhZFuwssdXvt
F6H+PRn7Ehc/sUXMkp8/fe2YfLyc7R0MqMHRsQcaMfZkg8vbTptORCwLV86toIol
yxnB9gO5FAE013Qxsxu9/4OU/8FPb+XDrDuRMIlWhkd55aMu1nwRzfQOdnP2zXTm
S280GJEs52Je35tEDrC/bfkWZQHZoJyTO2yvQVhcV5vCUNcFjq3N+UNAlvxlNRxG
R3W3UsUQt2Yf2ELIAALupTYEWikRDr07PtXOO9q+E52bOfhZ4Ot8k9Vtuv/RU/E=
=CIbv
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Mar_2011_12_21_48_+1100_=LIa9Bz6Z/i51/Hw--
