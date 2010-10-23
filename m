Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0JWCrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:47:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36633 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab0JWCrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:47:51 -0400
Date: Sat, 23 Oct 2010 13:47:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Lukas Czerner <lczerner@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the ext4 tree
Message-Id: <20101023134742.218ae337.sfr@canb.auug.org.au>
In-Reply-To: <20100921140410.f1ba148e.sfr@canb.auug.org.au>
References: <20100921140410.f1ba148e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__23_Oct_2010_13_47_42_+1100_pI9bdJsrIYsR/lk3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__23_Oct_2010_13_47_42_+1100_pI9bdJsrIYsR/lk3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Tue, 21 Sep 2010 14:04:10 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the block tree got a conflict in
> fs/ext4/mballoc.c between commit 9c543072a9dd7cf60cbf472914a6480ffda50b27
> ("ext4: Check for negative error code from sb_issue_discard") from the
> ext4 tree and commit 2cf6d26a354ab6362e301b5a323832b02867df47 ("block:
> pass gfp_mask and flags to sb_issue_discard") from the block tree.
>=20
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
>=20
> diff --cc fs/ext4/mballoc.c
> index e4f4dae,19aa0d4..0000000
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@@ -2612,8 -2566,8 +2612,8 @@@ static inline void ext4_issue_discard(s
>   	discard_block =3D block + ext4_group_first_block_no(sb, block_group);
>   	trace_ext4_discard_blocks(sb,
>   			(unsigned long long) discard_block, count);
> - 	ret =3D sb_issue_discard(sb, discard_block, count);
> + 	ret =3D sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
>  -	if (ret =3D=3D EOPNOTSUPP) {
>  +	if (ret =3D=3D -EOPNOTSUPP) {
>   		ext4_warning(sb, "discard not supported, disabling");
>   		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
>   	}

This merge fix will now be necessary when merging with Linus' current tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__23_Oct_2010_13_47_42_+1100_pI9bdJsrIYsR/lk3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMwkzOAAoJEDMEi1NhKgbsFOIIAISEIOsjRmhp2fEXuxqIs9W+
dQWqhs6PJDyA1ZOGXf2OsgQ8mkCGzB0iZhGpYJG8domnuh7vzgGGqnQvsdJBGukG
N5rVUdcAsEJVoV53tHk3COal9dvwZjr2544X2iJ/zN3xzY1RZQMJVgVtjXI+Ae/r
FSS8ernkPFeRt92Oopl0EDPJ8bUrSyzA745AKPBCaM4LrAKIJ+OPNS4+OzGzyCm8
erxop+7c21w3WePF0M0bp5N/F8g5Rqs3FUOPbysOxw146wo4UW2PjKUFzvllAUJz
qBarh1RyMkt1rPnldq2/sowiGfPPPFWOI3JLbethbKou2vBUJOPe7HGbLZH/X8U=
=FI0f
-----END PGP SIGNATURE-----

--Signature=_Sat__23_Oct_2010_13_47_42_+1100_pI9bdJsrIYsR/lk3--
