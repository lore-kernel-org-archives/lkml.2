Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2GJBXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:23:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43952 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2GJBXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:23:23 -0400
Date: Tue, 10 Jul 2012 11:23:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aditya Kali <adityakali@google.com>, Jan Kara <jack@suse.cz>,
        Johann Lombardi <johann@whamcloud.com>
Subject: linux-next: build failure after merge of the ext4 tree
Message-Id: <20120710112312.099a2f602cd6aea90226732c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jul_2012_11_23_12_+1000_Q3ERyouSQR3bNNiH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jul_2012_11_23_12_+1000_Q3ERyouSQR3bNNiH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

After merging the ext4 tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/ext4/super.c: In function 'ext4_remount':
fs/ext4/super.c:4739:4: error: implicit declaration of function 'ext4_enabl=
e_quotas' [-Werror=3Dimplicit-function-declaration]

Caused by commit 182bb8fec8f5 ("ext4: make quota as first class supported
feature").  The quota code needs to be protected by CONFIG_QUOTA.

I have used the ext4 tree from next-20120709 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Jul_2012_11_23_12_+1000_Q3ERyouSQR3bNNiH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+4QAAAoJEECxmPOUX5FEVjwP/iaBbFRzeNhCL102k2kHe5LP
UZvAnjyt2v42oybXMYo5DtwL8WY8wi3H25kb7uK/OMHomcapq6DLEDI1tIP4L/nV
4NM/hNfShDYQimRF1rU2m1s3HoksD/Y8EPo7iPZCHMb0eA7HMgT4ypuc9UzuCWtV
HpWBbXl5PDJpo0U72GoYwEqoOuRr5koSMehxtFsDOJVPI4Q5v72H4lE+RhMUkIVL
6YXFofgogJ3hzwEyTVItNxuHvquz1/WRDG8NffsLk7/rKn6xqcQ7Y9UeQZy+Wcp1
3BIgvHUJgK3S6iZ/+RyGbeEc9+FNrkmPuVaKoK0gKVtCMoO6giQbTQrIJUkUKUCB
WL+csd1MRERGj/Dcy5ZTLZr1U0H6xREMRvZKasMZ+0A0R/ENmiBCfr3yPUJrXsm/
OqqolpVLeeKQ+0JCIPaGUxpqlGlijPXn05weFI9vB3xfPSWdwu250iJjCgUSoM5a
nXcp+FwvjjKb+bHGyIjBoLAqJARZjCGDAPU0jDwRvsxSXnsxQfZDHvzBekEaOLRU
tub6T27tjI2EbW+05EiuYYEKHICJrJ/CAHx7SrAyZi5tlVyBeLf3bgxb+m8i/IkJ
4W3MKhVqakKXcBgXQvYBveE4mGYTo6IFAfffXDXAQb/4vvrfg5+gNd+Ok5EAF65q
Uz+YNkap/mgmN6wxFlxt
=C/w5
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jul_2012_11_23_12_+1000_Q3ERyouSQR3bNNiH--
