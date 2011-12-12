Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1LLElu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 23:41:50 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35060 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1LLEls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 23:41:48 -0500
Date: Mon, 12 Dec 2011 15:41:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20111212154139.9c8aaa79884568ca461cb3f6@canb.auug.org.au>
In-Reply-To: <20111212152601.e03fe38dc6606f70d86a1cef@canb.auug.org.au>
References: <20111209160856.d1f8de40a6d415cd5d9cafc7@canb.auug.org.au>
	<20111208214744.19117662.akpm@linux-foundation.org>
	<20111212152601.e03fe38dc6606f70d86a1cef@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Dec_2011_15_41_39_+1100_UY4M_jALS9/.WCrN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Dec_2011_15_41_39_+1100_UY4M_jALS9/.WCrN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 12 Dec 2011 15:26:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 8 Dec 2011 21:47:44 -0800 Andrew Morton <akpm@linux-foundation.or=
g> wrote:
> >
> > I suppose this is a good enough fix for that:
> >=20
> >  include/linux/mempolicy.h |   10 ----------
> >  mm/mempolicy.c            |   12 ++++++++++++
> >  2 files changed, 12 insertions(+), 10 deletions(-)
>=20
> OK, I applied this to the akpm tree today.

Actually I applied this:  (put the inlines the the correct file):

 include/linux/mempolicy.h |   10 ----------
 kernel/cpuset.c           |   12 ++++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index d2589e2..7978eec 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -253,11 +253,6 @@ static inline int vma_migratable(struct vm_area_struct=
 *vma)
 	return 1;
 }
=20
-static inline bool task_has_mempolicy(struct task_struct *task)
-{
-	return task->mempolicy;
-}
-
 #else
=20
 struct mempolicy {};
@@ -384,11 +379,6 @@ static inline int mpol_to_str(char *buffer, int maxlen=
, struct mempolicy *pol,
 	return 0;
 }
=20
-static inline bool task_has_mempolicy(struct task_struct *task)
-{
-	return false;
-}
-
 #endif /* CONFIG_NUMA */
 #endif /* __KERNEL__ */
=20
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ba5dfe5..540ef69 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -938,6 +938,18 @@ static void cpuset_migrate_mm(struct mm_struct *mm, co=
nst nodemask_t *from,
 	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
 }
=20
+#ifdef CONFIG_NUMA
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return task->mempolicy;
+}
+#else
+static inline bool task_has_mempolicy(struct task_struct *task)
+{
+	return false;
+}
+#endif
+
 /*
  * cpuset_change_task_nodemask - change task's mems_allowed and mempolicy
  * @tsk: the task to change
--=20
1.7.7.3


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Dec_2011_15_41_39_+1100_UY4M_jALS9/.WCrN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5YYDAAoJEECxmPOUX5FEOaMP/jdzDbmQf0mHLlhkIxCEiEsh
LIu1yGqYUgRvRkfPOhB3sE/Cv1YlbqAMU5hpIOw/+gEQ1IiMCasl7sD371P3Hr+f
a0umCJV3Br0xYi9awGKYyhX0KSnCTN/x7HeVQuy2+JpE2KnixKiAZU0aDjwPbs+z
5PGalGk8p7SIjHdnZ5xs0pJMInNdjRFpwC5mBRfsiabjIQCOuCm850AJ5/VUqNI0
EABrH/kpKMHzJwmxkVGf+6YMyxjbSfSQdLKWGD4rKB7+QKRk/DyVZTPM+2s3oWYS
Ay96kI1Q0avVu5NGUyRLYQP+kx0MvT+UqGO0F5Qs4I5a9UKaCcZashJ+iAhCuhau
n4c8XoNLoUGVwYHgasuP5Ige/UCSA9aO0oe6Szn/aC1pz/c2NIEigHTKaaa7ZGdp
mkDBLczNW9A4uf2bBdfI4GzmH6Pgnp2y+23qZDvi5S7SnPh6c4rqUF522suYE8Az
1WcanyrWV5pz4anewJVkydF87XKVPDg7EvkZyQXqoenqs0q9Y72FxMLjqYOulTfm
JIoDZQWx4jy/MD9lSdAy+Gg8GWcFPqfHI0oEkcXpJomfgrUx4T37n0La0yzwAAQs
4ck4eDmQgfWF0N6kNonCobeYnQ3875BVaB+JHhFdDD+3OCSGXyNyD1DZNwQc8yDa
G+DPLJoRYlpZ8tTtP2yW
=/iT7
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Dec_2011_15_41_39_+1100_UY4M_jALS9/.WCrN--
