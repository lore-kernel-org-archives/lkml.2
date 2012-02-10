Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab2BJAuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:50:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45259 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2BJAuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:50:16 -0500
Date: Fri, 10 Feb 2012 11:50:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: linux-next: build failure after merge of the target-updates tree
Message-Id: <20120210115005.b828eca7065d1fbed82c80c6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Feb_2012_11_50_05_+1100_i5fW57mgW=C5/8NM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Feb_2012_11_50_05_+1100_i5fW57mgW=C5/8NM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

After merging the target-updates tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'srpt_abort_cmd':
drivers/infiniband/ulp/srpt/ib_srpt.c:1381:25: error: 'struct se_cmd' has n=
o member named 'transport_lun_stop'
drivers/infiniband/ulp/srpt/ib_srpt.c:1390:25: error: 'struct se_cmd' has n=
o member named 'transport_lun_stop'
drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'srpt_handle_rdma_err_co=
mp':
drivers/infiniband/ulp/srpt/ib_srpt.c:1516:25: error: 'struct se_cmd' has n=
o member named 'transport_lun_stop'

Caused by commit 3f1d120476c5 ("target: replace various cmd flags with a
transport state").

I have used the target-updates tree from next-20120209 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__10_Feb_2012_11_50_05_+1100_i5fW57mgW=C5/8NM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPNGm9AAoJEECxmPOUX5FEqn0QAJuGe3uJ/O3w567NZ2+UIrsu
WxZNImJJq0iHRFXA2BzCL9v821VB/EelJ9B5kANOafmhyZOQ0d0gbwXBletiSVAP
tSgjVPjqmDWAA3JdbMWgZIZDByaStfU54PzkABM1yM/s8aLN8t6Mb2a+eLWLWplA
Tci/R85I005nX5tYgn7zyaFBhoxmH9eNzv061Szt+RnPe6JN+3FckPLiNKCSQktl
b/l0ymzOH0sgbfE0bK27JFosmUCwsROFbB6FRREc0ysQ4o9ZFVHX2lulLZOiUMIz
fFMz8ebBO7IlW9hm859x0U/YuQ/+m/98oLJyJ2HYcEb/oA1C3w120OHh1P8QLj5b
Ue4qqXIpVBx0yf1CV1fKRpVkRJi5rZLMmPE4QddQWx5zBIYQRFT1LuNxHuW8Dt/B
yeC2p4boVlUNi/MJBQX95O3A2LquE9F9TJ5O+FnX88m8OTJF+lNrplQhmp+W9OIT
dh6lp223gFvGgsHI/jDhWcfMICsxXy6SABvSntiDgaK/G+uyJgYRiRQLGBlFIRpm
+XKRpCkXcieDin9eveOvVX9SJN8WulFS5WukKQNmYm35N1QrqItAHSmUd+f+S9yz
FcNC+D1ue02x3JIWTf6I6adVGkMoIVNbDH7mJBfvpkP8gT/aIPfwDpOnUZ+ecBW+
s4rR8fCTsSQulnVyoTbB
=VzM5
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Feb_2012_11_50_05_+1100_i5fW57mgW=C5/8NM--
