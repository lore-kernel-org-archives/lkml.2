Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2KZEb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 23:31:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57329 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab2KZEbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 23:31:25 -0500
Date: Mon, 26 Nov 2012 15:31:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <cgroups@vger.kernel.org>
Subject: linux-next: manual merge of the cgroup tree with the net-next tree
Message-Id: <20121126153115.682955b2504f3b0af19acbe2@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_15_31_15_+1100_ByOEjkozq7Sowsh4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_15_31_15_+1100_ByOEjkozq7Sowsh4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the cgroup tree got a conflict in
net/sched/cls_cgroup.c between commit 6a328d8c6f03 ("cgroup: net_cls:
Rework update socket logic") from the net-next tree and commits
92fb97487a7e ("cgroup: rename ->create/post_create/pre_destroy/destroy()
to ->css_alloc/online/offline/free()") and 0ba18f7a5e26 ("netcls_cgroup:
move config inheritance to ->css_online() and remove .broken_hierarchy
marking") from the cgroup tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/sched/cls_cgroup.c
index 709b0fb,31f06b6..0000000
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@@ -98,9 -79,9 +102,10 @@@ static struct cftype ss_files[] =3D=20
 =20
  struct cgroup_subsys net_cls_subsys =3D {
  	.name		=3D "net_cls",
- 	.create		=3D cgrp_create,
- 	.destroy	=3D cgrp_destroy,
+ 	.css_alloc	=3D cgrp_css_alloc,
+ 	.css_online	=3D cgrp_css_online,
+ 	.css_free	=3D cgrp_css_free,
 +	.attach		=3D cgrp_attach,
  	.subsys_id	=3D net_cls_subsys_id,
  	.base_cftypes	=3D ss_files,
  	.module		=3D THIS_MODULE,

--Signature=_Mon__26_Nov_2012_15_31_15_+1100_ByOEjkozq7Sowsh4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsvCTAAoJEECxmPOUX5FEw48QAJ1UqQ0Y0bDZLHbUj7urAgS1
ywPq5QgXAkTDiolBPxXau6fffnKvWnqx/Y9BZV92myrQSMJ+A+3qQVDT1Pr1b61l
8htsqC7YoPC66405GWyzZXyTEkmQfeR0CRfJreH5PgL4th/OWvH7r28OgeRUMKiq
NV4hmicwKzob2xOoyhmnmqR1UAjC63EM+2rtN29vbSRCe6ZGycVp/t1V0cWMX70s
kWexjnyC8ikfG/i0f4UW2UF+7b7hcFHx6dzFka95J6QNCpBTTGFH1k1qm4mL5lJ/
smphmhmL/RvAFW9HqajK6IxQTUNu3RXavCNWfietHvOPSsjmqwPaGqp3X9/Zx7EJ
uTwI43HTTsSXf2weej+j97T3YPXK7ojC90nrrsgskFtVN+Mm6DZJJXItjj1stV8v
7kIxPH7y597qlAPNWUuk/L1hYCYoNecQEq8SYTKBJg6n+DDLgUXH3deo30zO70Ol
AxyKZQEKQYvXC9b+2l3nXlyyKUQEBoQJmN/ojXm0JvbTKWSyTtpXOi/Tn2DbKnTQ
9kG4HZJ47Evubt0d79/B3NKr9WVdafOow2bzqzkrADh/GdJfvwne/4X+kjrotm8r
7KIjwo1S6niP1kHdHCdG5M0ca4XkLCwqPEvIjXuSFct/oliX0Mh7/WrWzhKWdFeX
tHYzUQH2w4glPr2XYx16
=ITAP
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_15_31_15_+1100_ByOEjkozq7Sowsh4--
