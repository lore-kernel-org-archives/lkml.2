Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1KYDub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 22:50:31 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60582 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1KYDu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 22:50:29 -0500
Date: Fri, 25 Nov 2011 14:50:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: build failure after merge of the cgroup tree
Message-Id: <20111125145022.d5578c15eb900e2628a072b2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__25_Nov_2011_14_50_22_+1100_a5MHaguyaZ0Zu2S2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Nov_2011_14_50_22_+1100_a5MHaguyaZ0Zu2S2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the cgroup tree, today's linux-next build (x86_64
allmodconfig) failed like this:

kernel/cgroup_freezer.c: In function 'freezer_can_attach':
kernel/cgroup_freezer.c:179:3: error: implicit declaration of function '__c=
group_freezing_or_frozen' [-Werror=3Dimplicit-function-declaration]

Caused by commit cfb5ec210751 ("cgroup: don't use subsys->can_attach_task
() or ->attach_task()") from the cgroup tree interacting with commit
22b4e111fa01 ("cgroup_freezer: prepare for removal of TIF_FREEZE") from
the pm tree.

I don't know how to fix this up (the obvious fix will cause us to have
nested rcu_read_lock()s and I have no idea if that is allowed).  Can you
please provide me with a merge resolution?   I am also wondering why such
closely related work is happening in 2 different trees.

I have used the cgroup tree from next-20111124 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Nov_2011_14_50_22_+1100_a5MHaguyaZ0Zu2S2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzxB+AAoJEECxmPOUX5FEZboP/iJXwop797I0aSJ9vmeUogrq
SNfWjZJOTq2UGedfVHDGzA2qjBZoeHHNdmcevG09u5VN8svI588p1oSs2S478TYy
0Phe3gbXc05jGGKOX4yru4utaWrQszzy+/fw5Cq5vQuVSynZaN7BTjPr2Mzv0oBY
LxMIFju973FNdtlY+TcFHPP0ojz5ivow2BC9e7E8EfiKnshe07wS/MKTFVclRv2w
HDMsmHPRVfvrEb9oM+efAGZI6nnGhlnKyyeN58BHLkuY36l3iKtK3inTu4eQ0+Hx
yeaOeZYL//2AcwNHF65kfhur+0xQsvZaYmBmMc41DiJOSP/zaj60QPTpFlKeacOF
C96rE+lEfWpyuSEJmEECfPlANQi0W/vWNrXz86AQu61+kTQr3MCEHcpft6uXBC5h
2+MPUh8NwB3YLTUY7DK59nTilGGJioP8X/BSImUnGK3Dso4q4OPf4t8zO1ZPpOBb
so4gve5wjgvGLtrfnSesyoavoD1juQLcJIjAT+66AJ1RPPZ4dDmN3rrGNhiQr+7i
Sx0rmWj0Zwo6QyWs7jlZulKrAs/dW5vywyrnPS0wCnPEy/sDXSCi24eKprUsVwWH
DtqeeTRx4PjIgMRoNrXw0QjMFagGgPfBb79UcgnJdPIQ+PaCx0kLcxGNNAe/EXEK
jNnPByH+NOZY/c7QOxYE
=gvcq
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Nov_2011_14_50_22_+1100_a5MHaguyaZ0Zu2S2--
