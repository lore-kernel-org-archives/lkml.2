Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab2JWDmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:42:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53664 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2JWDmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:42:24 -0400
Date: Tue, 23 Oct 2012 14:42:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Kay Sievers <kay@vrfy.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20121023144221.5ae3061a11766df8175b959d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Oct_2012_14_42_21_+1100_Fa2mr9oPPI9+SRHy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Oct_2012_14_42_21_+1100_Fa2mr9oPPI9+SRHy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/printk/printk_syslog.c: In function 'printk_syslog_print':
kernel/printk/printk_syslog.c:108:3: error: implicit declaration of functio=
n 'copy_to_user' [-Werror=3Dimplicit-function-declaration]
kernel/printk/printk_syslog.c: In function 'do_syslog':
kernel/printk/printk_syslog.c:245:3: error: implicit declaration of functio=
n 'access_ok' [-Werror=3Dimplicit-function-declaration]
kernel/printk/printk_syslog.c:245:18: error: 'VERIFY_WRITE' undeclared (fir=
st use in this function)
kernel/printk/printk_syslog.c:245:18: note: each undeclared identifier is r=
eported only once for each function it appears in

Caused by commit 598815e5f25f ("printk: add printk_syslog.c and .h").

Presumably missing an (or some) include files - see Rule 1 in
Documentation/SubmitChecklist.

I have reverted that commit for today (and the following commit
2cf91e0e4b9f ("printk: move kmsg_dump functions to separate file")).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__23_Oct_2012_14_42_21_+1100_Fa2mr9oPPI9+SRHy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhhIdAAoJEECxmPOUX5FEQ7gQAJ06t7YdftK5QqQ7IBYaDC6m
IjLyV7pGHg3gMZOGrbwgdQjNwk7PIfuAxx5LkEPj6DrGMwc3MUiUaC/UqpwVbrov
Rq5OFNNLr1LwruNFe423As9zfFeZPJT6j3FDPt8pyY5hJtgdwvOMe/EhfSuQWdH4
FzXZ7zGbz38xbgAO3dgnUyUFG6gsnXd16WoCXCGufhca885AUA77pzvD+i/WvuK7
QAnfw2ZlAQKSA5aypuNbYTFTPM72W4ucWtiYqU7l/o1I4rRdpHaK+q2zqLJpRRJL
axve18PyNVg+IvDY0mHc90ah93JXt1PScio9wwdRXQdJzJAszShRaSXxZsWF84LS
p4rOF4rBtncHq6hF7Hg9mySLMZA0NQI322WSn++qRF2DGEFrVxCKgockq/97iZGm
PWFFGvFP9Yxz1TqXKI4WgreT69CSLX9bAaQNBVz4S5C03k+0RYq0zZppV4T2ALb8
xDKJReexDF30cCf3VzuhYhqjJT4nlrENS/h2YkDHylAZOHWGPENbrnvF8l0+O0XN
osVspkpNK42XgCcBc3sN/4lINfOuJEh7psbr7HM0j4AJLCwr8uMuBBjXcTjVeMSp
baGQmIK8HBO2eeOKG8BtwNP+FcwCmYKMjgdUHia/nrWx1I0boL4GHtYCrRaKkKy8
DIfkv4sAo3b+9yWU3ixb
=Jv9P
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Oct_2012_14_42_21_+1100_Fa2mr9oPPI9+SRHy--
