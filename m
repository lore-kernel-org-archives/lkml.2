Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab0IQBhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 21:37:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40779 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab0IQBhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 21:37:51 -0400
Date: Fri, 17 Sep 2010 11:37:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20100917113738.f8ecaf63.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Sep_2010_11_37_38_+1000_y.p0Wr2/iKA41cin"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Sep_2010_11_37_38_+1000_y.p0Wr2/iKA41cin
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/ocfs2/file.c: In function 'ocfs2_sync_file':
fs/ocfs2/file.c:191: error: 'BLKDEV_IFL_WAIT' undeclared (first use in this=
 function)
fs/ocfs2/file.c:191: error: too many arguments to function 'blkdev_issue_fl=
ush'

Caused by commit dd3932eddf428571762596e17b65f5dc92ca361b ("block: remove
BLKDEV_IFL_WAIT") interacting with commit
04eda1a18019bb387dc7e97ee99979dd88dc608a ("ocfs2: Flush drive's caches on
fdatasync") that entered Linus' tree before v2.6.36-rc4.

I have used the block tree from next-20100916 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Sep_2010_11_37_38_+1000_y.p0Wr2/iKA41cin
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMksZiAAoJEDMEi1NhKgbs3VcH/3LGbIPB051MrHrjeVS1rHNi
OuVkIlOz1QS3aEbDOh5dsWnPwwhvDJ70n2jGLdICGL0vQKG2S3oZGUdK0IhXdVUw
KNCo7vu5AoodCIpeLFsvgYXBAAZxhTIUMTL/bghjFdz6fK92e2pyjVlCgSHqcZ2b
XNeXly45O0eFkovyBxUigs5V4AabxfzY/TSMCaWSoyca7+ow2NwIr7LqZYzKMy09
NuYQwtyjNurYk6kvPZdMmvvdX3+HNAOGiDqO2tyda9G+gJoPKdZyu3kaReCgX+4e
kLVccEmd7PKjOHWw1E79VsOUn5YtyQSD76i9ydrjmwB20TCgFL9DaKE2Oo3Tb+s=
=reIW
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Sep_2010_11_37_38_+1000_y.p0Wr2/iKA41cin--
