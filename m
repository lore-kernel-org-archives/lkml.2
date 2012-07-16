Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2GPA7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 20:59:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43998 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2GPA7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 20:59:21 -0400
Date: Mon, 16 Jul 2012 10:59:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Dave Kleikamp <shaggy@kernel.org>
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20120716105906.1abc525c01164b4f9031bcb2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Jul_2012_10_59_06_+1000_bQnnk_fEJKWaP2x0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Jul_2012_10_59_06_+1000_bQnnk_fEJKWaP2x0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/ext2/super.c: In function 'ext2_sync_fs':
fs/ext2/super.c:1191:2: error: implicit declaration of function 'dquot_writ=
eback_dquots' [-Werror=3Dimplicit-function-declaration]
fs/ext3/super.c: In function 'ext3_sync_fs':
fs/ext3/super.c:2534:2: error: implicit declaration of function 'dquot_writ=
eback_dquots' [-Werror=3Dimplicit-function-declaration]
fs/ext4/super.c: In function 'ext4_sync_fs':
fs/ext4/super.c:4493:2: error: implicit declaration of function 'dquot_writ=
eback_dquots' [-Werror=3Dimplicit-function-declaration]

Caused by commits 05566b558a47 ("quota: Move quota syncing to ->sync_fs
method") and ad04033e79d2 ("quota: Split dquot_quota_sync() to writeback
and cache flushing part").  Please do build testing with and without
CONFIG QUOTA for quota changes ...

I have used the vfs tree from next-20120713 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Jul_2012_10_59_06_+1000_bQnnk_fEJKWaP2x0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQA2daAAoJEECxmPOUX5FEy74P/0UA3Ed0he+5i/4OAe8AlMdQ
RTWesHEj5p2Conp5ZSlCFax9pfOkq+1z/G5ItcJhkGC9giC8Hpcv00OroZsft+Qu
EtFxWycLkLE97XgGlNMR4qFi+Y6V3UCxRSYSSNfgX0dBFX3U/TWFDJvd7utAxBRx
EzQxJdI7+ICQs7DS6r1t9guWVL4j8EljJTfrOCsqO0tzhntHq1ujmCePvyklutpp
/GAtzDSjECInpMQNsK9knkx3w5+I7y+u1tZHzpdXgw9amGw/gCN4YMs8MwAG1AyO
he/RVZQXrICC9UW2AIXvJZ2yoKQNcGqYt2wv5YK/z9IL3s8FtEP8Y6T8N395jqP0
/zrjQA1X9QGZ3UO0OZ3ml3h64sP0Qe+wonvCU0bPWOiB/zgJBIk6USa9VRUlhLZW
X74IKAhYbNz2aVus98/zzdaJuZnwlo1KohIvWmpolvFwcfTj1UmTo6PiGcjd2vV/
ISl3WNOeRmQ7UiW9mddpggGwY3WtZyYBADs/aPBOJR+AKnAfIL9XXDoBGpCCny5B
vv1aqeNxbARGWEyamYOas6pyiMcqRvqi4clvtJMwu93hUuBk2ZUTJ1ncwywxdwLk
s01HvjcAd9tZ5Gnp+d2vHMsDYF/W6Uvzc4uGyb8LK16r6+xc96y1jqsVklw9JeqV
ZNCcHzxcUgPWt2oCduos
=+Aa2
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Jul_2012_10_59_06_+1000_bQnnk_fEJKWaP2x0--
