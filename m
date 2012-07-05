Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab2GEFti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 01:49:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52393 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2GEFth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 01:49:37 -0400
Date: Thu, 5 Jul 2012 15:49:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stuart Yoder <stuart.yoder@freescale.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the kvm-ppc tree
Message-Id: <20120705154929.219789032ef59f9243d0b8a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jul_2012_15_49_29_+1000_=prvsJydXyRidabc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jul_2012_15_49_29_+1000_=prvsJydXyRidabc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

After merging the kvm-ppc tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:479: Error: wrong number of operands
arch/powerpc/kernel/exceptions-64s.S:486: Error: wrong number of operands
arch/powerpc/kernel/exceptions-64s.S:486: Error: wrong number of operands
arch/powerpc/kernel/exceptions-64s.S:487: Error: wrong number of operands
arch/powerpc/kernel/exceptions-64s.S:487: Error: wrong number of operands
arch/powerpc/kernel/exceptions-64s.S:494: Error: wrong number of operands
arch/powerpc/kernel/exceptions-64s.S:494: Error: wrong number of operands

Caused by commit bc8cc4993e19 ("PPC: use CURRENT_THREAD_INFO instead of
open coded assembly").  The fact that this patch has problems was already
pointed out on the linuxppc-dev mailing list and it clearly hasn't been
build tested.

I have used the version of the kvm-ppc tree from next-20120703 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Jul_2012_15_49_29_+1000_=prvsJydXyRidabc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9SrpAAoJEECxmPOUX5FEZZkQAJxNa1Um+xGuhziscd5TI0N5
NU2ZYiyMZcI0uh7fS2WaOrwop4i70mltOp2fV+z9pamFS8K46Bf/Uxr1jrr265cy
4M9oXUhbYo7/z8O5BiUzBc+cCtA4BbjGoaux5apuHMHpUFamE1Fty86LtaF9Dauj
g3DOn0cJMZ+y1Uf0Q1tK72GNt3nmPeU01effqgFLvi+bC//q/OHfBoWwAQcRjEqK
ncp5ZES5ef4VfQfPal24anUTqxgqTvIWW2kc4JcwgnmkkUxJa4MCVD1vQljJkNWD
r9SOv2DxW+ZTNZIQrF8nlW6azVgvS/l6Albiyngfr8T7e0Yg7xpyPDlJ4IiKSjst
1eqC3nyB1A++w/YwEtgRR1An3QGpo3JhduWtxQnabQE5is0EgT93MtfmiQVb+1md
W7W/MGhkLAb/sHfET1wnpLXJBBx9ua+0TY00bQ66ZgWv44t7mcCkP8nE7FKYom2c
2vTFc6iCM/J7eCVqEv4I270p/3Gw+D+EekYbEtOmW9UnWfUksRyXrjIaA2XT4fhX
+U8etlZZDtfK9eh6+7MrFHhe+gzj+dcwBRzS70MdbbGndR7lX3SJYBwVtVttfdMy
Bj9d5w3aZScZeU9BS0XsTfBASw9ImQ8x1HGx6sb1W+qNk2PeD3cW0S4HLQtLJ1EV
3nq7i8aHGa2f6lP3AKdO
=95m6
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jul_2012_15_49_29_+1000_=prvsJydXyRidabc--
