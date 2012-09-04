Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2IDG7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 02:59:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57019 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2IDG7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 02:59:06 -0400
Date: Tue, 4 Sep 2012 16:58:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerry Chu <hkchu@google.com>
Subject: linux-next: build failure after merge of the final tree (net-next
 tree related)
Message-Id: <20120904165853.bc2f7b6524a3b03a09c4180d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Sep_2012_16_58_53_+1000_oEtjYTrRTiev9CXG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Sep_2012_16_58_53_+1000_oEtjYTrRTiev9CXG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

net/built-in.o: In function `tcp_fastopen_ctx_free':
tcp_fastopen.c:(.text+0x5cc5c): undefined reference to `crypto_destroy_tfm'
net/built-in.o: In function `tcp_fastopen_reset_cipher':
(.text+0x5cccc): undefined reference to `crypto_alloc_base'
net/built-in.o: In function `tcp_fastopen_reset_cipher':
(.text+0x5cd6c): undefined reference to `crypto_destroy_tfm'

Presumably caused by commit 104671636897 ("tcp: TCP Fast Open Server -
header & support functions") from the net-next tree.  I assume that some
dependency on the CRYPTO infrastructure is missing.

I have reverted commit 1bed966cc3bd ("Merge branch
'tcp_fastopen_server'") for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Sep_2012_16_58_53_+1000_oEtjYTrRTiev9CXG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRaatAAoJEECxmPOUX5FEMnsP/3WJ61qSsvILCvFqa/vEYlj/
4fD96LZQBVeLDgWPQpW84Dg+9Nl5jHnIORt5SWn/bqHo0xqDlCfqGVOS+yKxHVMG
Fv7640wsp/s65nvc6lEN2yjL0zTpDYA12NDzCb6z+sLmZSKXUf0iane4VFd/eH2L
AxZB8FvDsvUT0iAmVcz1kanR4NOZi7cw+qddUnm+W/Zt54obYQ14xfW2HXrraal3
aCI0y2WEUT85DV+6QveC7IWaaWhWk4tH0PvqSPC9alJ8dm5grS0RXnIh37+yAoWk
ydrYqROQW9ZpGiTglX8GXA6X4SWb/NfJ+wF9kT/nzQb6VpRLGO7McEHuburEM/Ac
C4kQ2bfvUnBzqh+zjmvVXN8NuYgxtR920rMq0YK0RSvoOpk3DusIXMvNghIKQNCw
af+shVDMzK/ftHEzRNzj+7mulWdAmdthnZ1x4bgZeYjUVNc7MmzZ3XoNBV6ijIh9
WG7qz02YAMRVWRfDjoXGdqx5hWvEW9JbY7b9yHJufAP70503GPG9lAbMZS7pIxQP
yVfCp1dF7OGVHoQM+c4i0Y6qPDeOzPwQeb3HJglmhkb8ltX3kV8X6+lbBaybquAI
Pboc9NIb/jXumS8esQUbHbOWgiefwyAX7J+vLdCdC83DQkCNyWu9sGEzwzzBmcm6
x2wwn5Zn+SP1PVkZf9KP
=TNv1
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Sep_2012_16_58_53_+1000_oEtjYTrRTiev9CXG--
