Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2JWDqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 23:46:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab2JWDqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 23:46:31 -0400
Date: Tue, 23 Oct 2012 14:46:40 +1100
From: NeilBrown <neilb@suse.de>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: [PATCH 02/16 v2] f2fs: add on-disk layout
Message-ID: <20121023144640.228d919e@notabene.brown>
In-Reply-To: <001201cdb0c5$bdf728f0$39e57ad0$%kim@samsung.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
	<001201cdb0c5$bdf728f0$39e57ad0$%kim@samsung.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SS=mA/f=6DrQGi/ssv8AKES"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SS=mA/f=6DrQGi/ssv8AKES
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Oct 2012 11:26:00 +0900 Jaegeuk Kim <jaegeuk.kim@samsung.com>
wrote:

> This adds a header file describing the on-disk layout of f2fs.
>=20


> +struct f2fs_inode {
> +	__le16 i_mode;			/* File mode */
> +	__u8 i_advise;			/* File hints */
> +	__u8 i_reserved;		/* Reserved */
> +	__le32 i_uid;			/* User ID */
> +	__le32 i_gid;			/* Group ID */
> +	__le32 i_links;			/* Links count */
> +	__le64 i_size;			/* File size in bytes */
> +	__le64 i_blocks;		/* File size in blocks */
> +	__le64 i_ctime;			/* Inode change time */
> +	__le64 i_mtime;			/* Modification time */
> +	__le32 i_ctime_nsec;
> +	__le32 i_mtime_nsec;
> +	__le32 current_depth;
> +	__le32 i_xattr_nid;		/* nid to save xattr */
> +	__le32 i_flags;			/* file attributes */
> +	__le32 i_pino;			/* parent inode number */
> +	__le32 i_namelen;		/* file name length */
> +	__u8 i_name[F2FS_MAX_NAME_LEN];	/* file name for SPOR */
> +
> +	struct f2fs_extent i_ext;	/* caching a largest extent */
> +
> +	__le32 i_addr[ADDRS_PER_INODE];	/* Pointers to data blocks */
> +
> +	__le32 i_nid[5];		/* direct(2), indirect(2),
> +						double_indirect(1) node id */
> +} __packed;
> +


You appear to have dropped i_btime - no big deal, you weren't using it anyw=
ay.
However if you ever want to support NFS export you will need some value whi=
ch
is assigned when the inode is allocated and never changed until it is
de-allocated.  This is used to detect when an NFS file-handle refers to a
previous incarnation of an inode and so should be rejected as STALE.
i_btime could have possibly provided this, but not any more.  You might want
to add something back.
ext3 uses "i_generation" and has an 's_next_generation' in the superblock to
ensure that each new inode gets a new generation number.

You've also dropped i_atime.  I can certainly understand the desire to do
that, but I wonder if it is entirely wise.  There are some use-cases where
i_mtime is a poor substitute.

Also 'current_depth' looks a little odd without a 'i_' prefix.  It wouldn't
hurt to have a comment noting that it is for directories.

Thanks,
NeilBrown


--Sig_/SS=mA/f=6DrQGi/ssv8AKES
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIYTIDnsnt1WYoG5AQILfQ//arT9tWCMPWvGKHM0IC/Us8vYwTqkW5lg
rC98KCSo/CqEd2DuRsNaf2whCGWavAMwUvf/hcw3qJw2EH9YOuAIY/2pCQi+as9V
12LA388rIGSEVRJkpuu2KcyohrITa0PRR9Ybm2v2pPOxLHQoElhTwJE2gNMUm0g+
rJ7fNjD9JCDn1hDyHtODjZIsh8I/OXT7McU4U07mM4EAIxXDbHs6u1rzZ+qYfekQ
/LI1go2CkolkAZv1IuQED8c2/B8uLCcg0AhjaOEUfOCKgNuy54J94q1zgwS1TYJY
WUZVIlgqC04nNCAh3VhjnMZVXE0npVEFg9POyOoZQAzh+PlmuRASPOTxMxhi6/pn
mrG7tml2Yzr9PhU5KMt/88ZUFJk912dh2blJZTsxplv9t8J4TJ+KQg0sGPpLq1z6
r5l1/46ZHD1IJDIzUd2hddgNXAyetBhDdvnUQwF4d0qnC3Ij96E0wNO8lHPnxZCj
OWWcM3JUJ6u0OfqaSf6io3AdoqQ/BzGRDndBb6He7nex/dx+w7gmpo4C6ZdNkQUQ
Mt3l3sNCIbilZ0W1zSmUBDv78+o3ONQ2aGm5SZLPH3xSehEYywmFHs+dJ9j2Cixz
+RPOxC6De7ZohfPAbFloZHfscjTA6DcOq48cHJHooGR1b32mO0n2e3uAxCu5BglQ
DNj0H8D31CM=
=L8vj
-----END PGP SIGNATURE-----

--Sig_/SS=mA/f=6DrQGi/ssv8AKES--
