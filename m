Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2KFE6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 23:58:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49281 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2KFE6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 23:58:12 -0500
Date: Tue, 6 Nov 2012 15:58:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>
Subject: linux-next: manual merge of the akpm tree with the cgroup tree
Message-Id: <20121106155809.46653a71d0e14c93e6d989b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Nov_2012_15_58_09_+1100_b2TU7PKX8QSCx1I6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Nov_2012_15_58_09_+1100_b2TU7PKX8QSCx1I6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/memcontrol.c between commit ab5196c202c6 ("memcg: make
mem_cgroup_reparent_charges non failing") from the cgroup tree and commit
"memcg: destroy memcg caches" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index a38e9fb,b650e09..0000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -5946,11 -6034,17 +6008,12 @@@ free_out
  	return ERR_PTR(error);
  }
 =20
 -static int mem_cgroup_pre_destroy(struct cgroup *cont)
 +static void mem_cgroup_pre_destroy(struct cgroup *cont)
  {
  	struct mem_cgroup *memcg =3D mem_cgroup_from_cont(cont);
 -	int ret;
 =20
 -	css_get(&memcg->css);
 -	ret =3D mem_cgroup_reparent_charges(memcg);
 +	mem_cgroup_reparent_charges(memcg);
+ 	mem_cgroup_destroy_all_caches(memcg);
 -	css_put(&memcg->css);
 -
 -	return ret;
  }
 =20
  static void mem_cgroup_destroy(struct cgroup *cont)

--Signature=_Tue__6_Nov_2012_15_58_09_+1100_b2TU7PKX8QSCx1I6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmJjhAAoJEECxmPOUX5FEz18P/RB5LUubr92Htv9wNZMLDnt9
3hUyTRZF+TZa1Tr+GoJUAdKVJyVArBfupxNuLrfW/3OIG0DA0KqiRLviC6Nq2fdi
Sjc+g5HtYFtOTEgYAZdgsvRSr7hH2j6NMRbJMEhj7YbIk1g96ioNfqUy6+2RFjhM
1pxAUTXYH0OqFsxoACPjxPmR0PheLBXU/TJHMKaWAtezbgnpcYjF5zPw5+9/t/yB
HmDGMT6JYWvhkzjPsAYrLq+dmGbdrtcJxE+7gYp5jnA4u369BuWJm7RjDUFdMYg0
Y7e0gTK6ENZiU1RJZPnQwQtx5ABirCJ4aGAGqeo1Zs0Bs95XYu7zdr3BOuwPdjEu
UlinaSmvVUSZ4Ku3E4wePS4n3Z/PQqJtkl7QfB/lO7fiQiR6YkbA0QS868tzhdCM
L8fRjxRRDYpWNBPqb4r5X736DCKXQtb3pTVfUh9dFeSdpWk1BIhx0/sMw5qIOa3b
EyRXX1xr16Q8I0WO7Jm5SREXJbdeJv/K0KBy3/UMjQvEb7coudh/98vGsBIF3kyY
DauqkjZhQITMqxgcuqrnDPbyF3QlOkfgCBB+vKfet6r/f58nb1NtoBYjksmMjkzN
b1VQQhIdaG5Wi+U4qpB4LbMXi48T79UmsxIvMOcqfly4RZdFL+ccycum0LQ11WFy
eIjLbtSTM+uSMJU9Fk2N
=mOTP
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Nov_2012_15_58_09_+1100_b2TU7PKX8QSCx1I6--
