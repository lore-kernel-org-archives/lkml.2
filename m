Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab0E1Bpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:45:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab0E1Bpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:45:52 -0400
Date: Fri, 28 May 2010 11:45:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20100528114539.012ff1d2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_May_2010_11_45_39_+1000_kuciqvZGrw7rViBF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_May_2010_11_45_39_+1000_kuciqvZGrw7rViBF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/cell/spufs/file.c:1852: error: expected ';', ',' or =
')' before 'int'
arch/powerpc/platforms/cell/spufs/file.c:1871: error: 'spufs_mfc_fsync' und=
eclared here (not in a function)

Caused by commit 05b2fc7d1f1046fef1199e1a4d2f63df998ef3aa ("drop unused
dentry argument to ->fsync").

My merge of the vfs tree was also bad because commit
facd07b07d2a7988f5ce849558838cc953847637 ("direct-io: add a hook for the
fs to provide its own submit_bio function") that entered Linus' tree in
the past 24 hours changed the prototype of __blockdev_direct_IO() and
that probably needs reflecting in the new __blockdev_direct_IO_newtrunc().

I have used the vfs tree from next-20100527 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_May_2010_11_45_39_+1000_kuciqvZGrw7rViBF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv/IEMACgkQjjKRsyhoI8za/QCeJlrcHgy+s6ZvibMvaj+GJxc/
ukwAnR4tcZoxLmEHH7kw0niiT0Pwvs51
=ZJ63
-----END PGP SIGNATURE-----

--Signature=_Fri__28_May_2010_11_45_39_+1000_kuciqvZGrw7rViBF--
