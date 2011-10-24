Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1JXVih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:38:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48231 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab1JXVif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:38:35 -0400
Date: Tue, 25 Oct 2011 08:38:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: linux-next: manual merge of the libata tree with the at91 tree
Message-Id: <20111025083819.0940cc9ecefac0d5390a23eb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_08_38_19_+1100_wX.lmN0WBYP.PoKZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_08_38_19_+1100_wX.lmN0WBYP.PoKZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

Today's linux-next merge of the libata tree got a conflict in
drivers/ata/pata_at91.c between commit 9585cf300d98 ("ARM: at91/pata: use
gpio_is_valid to check the gpio") from the at91 tree and commit
8e3bfdb95ad7 ("pata_at91: call clk_put() on ata_host_activate() failure")
from the libata tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ata/pata_at91.c
index 7822813,c6d1409..0000000
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@@ -414,10 -414,13 +414,13 @@@ static int __devinit pata_at91_probe(st
 =20
  	host->private_data =3D info;
 =20
- 	return ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
 -	ret =3D ata_host_activate(host, irq ? gpio_to_irq(irq) : 0,
 -			irq ? ata_sff_interrupt : NULL,
++	ret =3D ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : =
0,
 +			gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
  			irq_flags, &pata_at91_sht);
 =20
+ 	if (!ret)
+ 		return 0;
+=20
  err_put:
  	clk_put(info->mck);
  	return ret;

--Signature=_Tue__25_Oct_2011_08_38_19_+1100_wX.lmN0WBYP.PoKZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpdrLAAoJEECxmPOUX5FE5qQQAIjBjCiA8lNYNeuydENyX5Cs
i9XpoUjxp2uci5Y28ItWIFU65BkhggYuIIaYGLFLy0ywz3FsChzhtiADgZtBFTXI
XyS3FIZlz6I0Y3FhxkMEjXYHPSUd5ka9Jp277EFgSm+kU4gOVJmewJ84F+l/BZGt
tur+pYj0R4tUaSuQp/ufI9LcSZsahrjZ9p4QHOw5ATFZMps5J1cz1eQgsvPfZEvA
WJE3N2KUjFS3sojwpccRzplWd54NT+FBvHKkhMPorKpThY2LzO5C2zAycfnwPmxT
Be7PTDTrFMKqumnfXASMsmCBO0P31jOeh5xPc7FYe6IxMxKMFxGKL71LHnUr4ZJ1
BP/TqNLAh0EwuMW2I6zOXhpuTxPs2u8SlT002greeKbyJhE68wi+mXHeTyZnqzQV
4KnazwG6YSnZJUFWCyxVSLUa+tnqKHoPf5EgRAmpE18+JwJ1rt6PMcT7a5Ne1PRq
QpUKZEYaAN3VQQvMH6a9AvL2Wu5vBHHlDag7m6JCGtoxl3obmZUgcRaoVQhpU1mI
zFye2k6qhx5EpUoT6AQ7lrSW7hNS+tTTRwG+uFtP5ljeZCxt448nMzMn1kscTis5
26yFBubJd3AmsDHBw7Fn8nSWWZRqiuDBgblvvM2BUskjCvCaDm541FgZhz8F0IAN
mdfwnGt/IcMjQ98BlN6V
=Emwo
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_08_38_19_+1100_wX.lmN0WBYP.PoKZ--
