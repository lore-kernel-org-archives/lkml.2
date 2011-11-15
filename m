Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1KOXaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:30:04 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59467 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab1KOXaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:30:03 -0500
Date: Wed, 16 Nov 2011 10:29:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the nfsd tree
Message-Id: <20111116102952.d653d19f69ca5a7fad8a0291@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_Nov_2011_10_29_52_+1100_fyY+beiC9jrYsFHf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Nov_2011_10_29_52_+1100_fyY+beiC9jrYsFHf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bruce,

After merging the nfsd tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/nfsd/nfs4state.c:4446:5: error: expected ';', ',' or ')' before 'void'
fs/nfsd/nfs4state.c: In function 'nfsd_forget_locks':
fs/nfsd/nfs4state.c:4468:2: error: implicit declaration of function 'nfsd_r=
elease_n_owners' [-Werror=3Dimplicit-function-declaration]

Caused by commit 16bfdaafa2c6 ("nfsd4: share open and lock owner hash
tables").  Please build test *before* releasing code ...  :-(

I have used the nfsd tree from next-20111115 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Nov_2011_10_29_52_+1100_fyY+beiC9jrYsFHf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOwvXwAAoJEECxmPOUX5FE8bUQAKbQcZLBFQ9N6Gv5L4oIrgCf
CJ4Y3LIRKw+X+oihx8k3rVUjKcStBkoGOX1jg9vn2FAal1AtF9lGiv5zQCacOBfz
C+UAk3O5ZzKXjzd2wtEzYMDxYyjGN0ukhyOvROzdlYjZsHQ3KAgxWq0MMWLzryUF
gVwJcrO7PUS920T0AiJEDJFjZumw1o3DgV7Z+Cpadr8ivfmTFr3d3oc4O+qbGPnk
GeKgntQzuAELh5Cx8RYGaGwgOfr0HSOywCMZVEYmZmYu3RGmDYOM3HW81KcYWTlE
DO/YaF9Dj189PhoXSkckCv03GfCNEouy0a64m9pKIICmQn5XOQom4976xTCVYyCS
OohcP8xK+JqWcIZSZvE5TAxv0a7+3eITRSRSgIhxwXpvu8wDM/pRWSWMdv8ktmAt
apQcnorQVeTSYOHESCE6yJ3M14JJr2Ylz8N6hJwv8FuQxHvIkd4ao2h35Bhjf2/r
DtjoxoDAL1dLQ5ZozZnmrT/p25FcKXjvekbzz2ugaGgvB03uJ8BS0BKYpHwsK4xW
WwcX3rh9T7KfZ6Kcrizvz9m6GczNb1HLtf1oF1y7CtTE3O79En/q+hMCv6ICMkKT
L3/PH29la1TbvPUcugj0k/M2sejj33AK6eBYXv7xAYgNizkUrdQAyWyWli+Y7ipY
2BlrLi0HIGEQELdG3HO4
=xx2M
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Nov_2011_10_29_52_+1100_fyY+beiC9jrYsFHf--
