Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2HPBpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:45:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33571 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2HPBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:44:59 -0400
Date: Thu, 16 Aug 2012 11:44:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yishai Hadas <yishaih@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: linux-next: build failure after merge of the infiniband tree
Message-Id: <20120816114443.600553d2fd103a5b2b36e061@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Aug_2012_11_44_43_+1000_AAAWVDGtVF/MIRj8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Aug_2012_11_44_43_+1000_AAAWVDGtVF/MIRj8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/net/ethernet/mellanox/mlx4/mr.c: In function 'mlx4_buddy_init':
drivers/net/ethernet/mellanox/mlx4/mr.c:134:4: error: implicit declaration =
of function 'vzalloc' [-Werror=3Dimplicit-function-declaration]
drivers/net/ethernet/mellanox/mlx4/mr.c:134:19: warning: assignment makes p=
ointer from integer without a cast [enabled by default]
drivers/net/ethernet/mellanox/mlx4/mr.c:148:4: error: implicit declaration =
of function 'vfree' [-Werror=3Dimplicit-function-declaration]
cc1: some warnings being treated as errors

Caused by commit 2354c0904331 ("mlx4_core: Allow large mlx4_buddy
bitmaps") which added the vmalloc call (which was changed to vzalloc by
commit 09e22f30018b ("mlx4_core: Clean up buddy bitmap allocation").  The
include of vmalloc.h is missing.  See Rule 1 in
Documentation/SubmitChecklist.

I have used the infiniband tree from next-20120814 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Aug_2012_11_44_43_+1000_AAAWVDGtVF/MIRj8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLFCLAAoJEECxmPOUX5FER+0P/ihqHNaSOZ1Ch2/XJAY2/THv
cJi6hpF1zr48xuKlhUdd4XF8mV+I9blvmsMdnvp8qQR/LEonVvIc3mndYyN2NSyG
FmKUYFi+06revIXZXcM8nbKqVj5hVo7EtK7PEkG2K7Hx2EcB4NBKcZ/5P0RP5BUS
O1ziVoGRrCGtwlcqNqhAlLodxggByeRBT0J8V/O7GYqPP5zwsQZ5GYi9jrG5L7EH
3hjm+pcq8XQi2rbA8yzDzNP43IWEeFjKNwrXSuB7HBEBGHqH2FHm5r4VkY+8KOgP
rxDLoWNyFJp8iQkyO9uCSrKFv2IdOtey3gRD8O4QlA7VzaLhXms6azhDc+MOw7de
4rAWd7n5Qa7xXLgxK9dfG/+zHKDKJD2vaaAPrQWEt0fkAwoQXWDaSUKcMtLiSgwt
WBKJMseU6bZgd0WZvhnXnsuCtRaUztgP6v8vCJfNPdO4Tps41L9jSs3rKwAFohn0
2XaAK/MPbPsMD6bnC9mnnqVw5GlkvjFJj4/0XesCcWAD4fplVfXF8ozyf1aP8Yhj
yBDgX/KtVaBYZP4NzufFUCWj3UPj8eG8Yh30U3piNO99N8tsTsVBk3Ak25QRT/qN
mq0v2+OUdW0GcHHcwsokFDEGekGyJXqZCjWh4aAFmmTNpWavogOikRBSmT/ZapyT
32S0I570i4nd3hNYDF7S
=KEnF
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Aug_2012_11_44_43_+1000_AAAWVDGtVF/MIRj8--
