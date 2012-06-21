Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab2FUDs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:48:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33929 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab2FUDs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:48:56 -0400
Date: Thu, 21 Jun 2012 13:48:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Mackey <tdmackey@twitter.com>, Pekka Enberg <penberg@kernel.org>
Subject: linux-next: manual merge of the tip tree with the slab tree
Message-Id: <20120621134844.36eacc287e76a38b960f2ef2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Jun_2012_13_48_44_+1000_GzACR0nQ70yUgwR="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jun_2012_13_48_44_+1000_GzACR0nQ70yUgwR=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got conflicts in mm/slab.c and
mm/slub.c between commit e7b691b085fd ("slab/mempolicy: always use local
policy from interrupt context") from the slab tree and commit
2ab41dd59922 ("mm: Optimize put_mems_allowed() usage") from the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/slab.c
index dd607a8,5070f96..0000000
--- a/mm/slab.c
+++ b/mm/slab.c
@@@ -3341,8 -3367,8 +3341,8 @@@ static void *fallback_alloc(struct kmem
  	local_flags =3D flags & (GFP_CONSTRAINT_MASK|GFP_RECLAIM_MASK);
 =20
  retry_cpuset:
- 	cpuset_mems_cookie =3D get_mems_allowed();
+ 	cpuset_mems_cookie =3D read_mems_allowed_begin();
 -	zonelist =3D node_zonelist(slab_node(current->mempolicy), flags);
 +	zonelist =3D node_zonelist(slab_node(), flags);
 =20
  retry:
  	/*
diff --cc mm/slub.c
index f96d8bc,fb2ef09..0000000
--- a/mm/slub.c
+++ b/mm/slub.c
@@@ -1616,8 -1616,8 +1616,8 @@@ static void *get_any_partial(struct kme
  		return NULL;
 =20
  	do {
- 		cpuset_mems_cookie =3D get_mems_allowed();
+ 		cpuset_mems_cookie =3D read_mems_allowed_begin();
 -		zonelist =3D node_zonelist(slab_node(current->mempolicy), flags);
 +		zonelist =3D node_zonelist(slab_node(), flags);
  		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
  			struct kmem_cache_node *n;
 =20

--Signature=_Thu__21_Jun_2012_13_48_44_+1000_GzACR0nQ70yUgwR=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4pmcAAoJEECxmPOUX5FEcS0P/R09twGtt4C0QbHoJ4BbIL1D
SBGKZ9W2RQlOTXWcjXWFJyZRooN5gexFsiu4sy02FRuEh9H8jzzdR2pxs7vpoQWQ
Ea9PatkY7apVDJjRG6ObR+4/WUjD82JudSuKllMNtmkipcQu2BK2Z/+Ek20E0zdt
HdG4bKb98S3/4K+tfcoZjHVZcJXr2dWWIGjCjtXZTyX9pAdHdb0D2DE2hY0To6dw
1uxsYq+tAxzxYUvddYIy5O+lt03RkNLF9qx+62H7D2y64CkRLysdbwPh92/DHaDM
t4RAD/M1v+9pnKPcEyfZh84LEiiLaNm3zF87jt6hSf8jxD6CShUzG6gCAMyNiy4C
oUnALi0VUnbtIRZ1ujAjiOVSk/RgBZponMQGxB9haAKt9Xw6emG4wUOvRjt1/415
x0RlSwM8nTvzhNDdQGvMAoMVdTu3hN0BkcKng0i4gidxRgBfBoI+9/L0ppgJ2a6l
1sB1S2xKl/0VTPfRXL99tvBJiUyA4syob1XRrIRgbgsSd4Si2UMPPR5sYptoa5L6
Eq1aDYy/ypZy7AtCajVH5j7DmjEZwH8s/3ikXY/L8zGHN14hWjeoxUoEj4y86Gm1
1rAGVbbB5kIrOqX0QZ8G8J947RhGIutrXGtey64/vGVuUJcxzx2cphyKaFZDh4x7
2zRn3l/2IW8pAU/oteqW
=OyA2
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jun_2012_13_48_44_+1000_GzACR0nQ70yUgwR=--
