Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab1CJDIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 22:08:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55501 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab1CJDIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 22:08:52 -0500
Date: Thu, 10 Mar 2011 14:08:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20110310140843.15fe4e6e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Mar_2011_14_08_43_+1100_A3GiH+kX94SV73J2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Mar_2011_14_08_43_+1100_A3GiH+kX94SV73J2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/target/target_core_iblock.c: In function 'iblock_do_task':
drivers/target/target_core_iblock.c:425: error: 'struct request_queue' has =
no member named 'unplug_fn'
drivers/target/target_core_iblock.c:426: error: 'struct request_queue' has =
no member named 'unplug_fn'

Caused by commit 622f85400f0b ("block: remove per-queue plugging").  Grep
is your friend :-)

I have used the block tree from next-20110309 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Mar_2011_14_08_43_+1100_A3GiH+kX94SV73J2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNeEC7AAoJEDMEi1NhKgbsWosIAIUCIFeJiwNf4BA4eyc9/CQQ
D80zTWpHzYfNM2WuNHpjxJZH6key7GDmOBpvEv2bmrkuqP0BdE4wNduprZp7cSI+
IljcVckaWgH3zVfD625XuTucYJS7uu/FgFVld9tZ0GaXq+XcfsuMLjnoDY+UUa6b
kendHz4wPPCKO38Uud9vPG43U8IGEYZr38l2SKYg/ZeJ68HsU/1tSZpyEN9s5UTK
XRSzu2pxfIECSGK63YFKrjKh1Ar3kM3N/0TRubT9uPjpHuwpX6Y/CV7PnEgAv/nP
RyI2wvQkmbitqHauKFzoaM0FzUFOUF9IEPfg3dhE9TChHTCw7SQfUj3ue2pzseY=
=B2F/
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Mar_2011_14_08_43_+1100_A3GiH+kX94SV73J2--
