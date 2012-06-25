Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2FYGlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:41:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37732 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab2FYGlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:41:52 -0400
Date: Mon, 25 Jun 2012 16:41:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120625164141.1c5b1b543e0309005dfd0d9c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Jun_2012_16_41_41_+1000_sCL7wSPmJ2JSk1.H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jun_2012_16_41_41_+1000_sCL7wSPmJ2JSk1.H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/namei.c: In function 'path_openat':
fs/namei.c:2874:4: error: 'filp' undeclared (first use in this function)

Caused by patch "fs: add link restrictions" from the akpm tree
interacting with (at least) commit 4066cd545681 ("vfs: remove open
intents from nameidata") from the vfs tree.

I don't know how to fix this, so I have reverted the akpm patch for today
(in the hope that someone else will fix it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__25_Jun_2012_16_41_41_+1000_sCL7wSPmJ2JSk1.H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6AglAAoJEECxmPOUX5FEsEEP/jnfHNOdoAkgm29P3imKFhc+
aWX8CWBzxTPTp6Dc2Lh4M0H1as5atETI4E5gaHtGLqSSiYVngOCjasmuupyOJKpM
5zB3B9SEMHG+8GcEU5JBko6niTPzkG5ZpXs+1PPeii7HEcjCL63k4EeoTs6YptEH
GzPdoENZB5B5WViGfnjc2+0t4WMTDe9Iegr0LSjLdDn9m3DYF0FtvQ6xd7ZjBZxa
jgg0GHl/guXUehAxicPEZuddCl65gbi/rjBDsdzc8iZDziB8+wDgyb4IfrU01nt5
TFfH/HUgh3J4Q5gkljrzgLkofNHhFYTiMvYf8UkYFyfkc3EONYG9mfeZjA8Y6leK
E2oOPowYnFhPFuGjD5XkWEcROtzL+oilT7j22ChK7qDpJO4Uc8/+8rasTOTuOMJU
ZCbaYloq9Sl5c/JLlEBlulYSSamIGxmxYaNpXVjaC0bFdeNxdc4ODLBbnEE7uM3V
HIo7huK+b4/y819AOZ3EMr0DulSSHsrYQCsdEgn2axOWF1cEVo79+H/olmQFUj0B
rYD/8rWI0W+1N+8M6RNtisVAZxYhpgxS713U6yu0O9UQxnBNJpLtMFBBBPP3tZAs
t9X7JEYFwFhGZkCdatqZpzIDF1UR5LbOf5oQ5OAaPZpXxoXZHnwljwhgbGgRuepN
iKmSY0z4VDYGAbbCZFuV
=UZKp
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jun_2012_16_41_41_+1000_sCL7wSPmJ2JSk1.H--
