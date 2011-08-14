Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1HNVUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 17:20:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1HNVUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 17:20:17 -0400
Date: Sun, 14 Aug 2011 16:19:54 -0500
From: Clark Williams <williams@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
Message-ID: <20110814161954.07d68a0f@redhat.com>
In-Reply-To: <1313232790.25267.7.camel@twins>
References: <1313232790.25267.7.camel@twins>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zu33/mNG5HrWrFjxevRE8nz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zu33/mNG5HrWrFjxevRE8nz
Content-Type: multipart/mixed; boundary="MP_/8f8+dK./IHXPO8ykoaGvqC6"

--MP_/8f8+dK./IHXPO8ykoaGvqC6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sat, 13 Aug 2011 12:53:10 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

>=20
> Whee, I can skip release announcements too!
>=20
> So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
> grabs.
>=20
> Changes include (including the missing -rt10):
>=20
>   - hrtimer fix that should make RT_GROUP work again
>   - RCU fixes that should make the RCU stalls go away
>   - fixes SMP=3Dn builds after breaking them in -rt9
>=20
>=20
> The patch should be at (once the mirrors catch up):
>=20
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0.1-rt11.pat=
ch.bz2
>=20
> The quilt series can be found here:
>=20
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.t=
ar.bz2
>

Wow, never thought I'd be sending a patch for patches, but here it is.

The current quilt series is borken for 'git quiltimport'.=20

There has always been an issue with:

	ftrace-hash-fix.patch
	panic-disable-random-on-rt.patch
	power-use-generic-rwsem-on-rt.patch

but Paul's patch broke it with the double slashes.=20

BTW, since the panic-* and power* patches didn't have any attribution,
I guessed that they were tglx's :)

Clark

--MP_/8f8+dK./IHXPO8ykoaGvqC6
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=rt11-fixups.patch

diff -ru patches/ftrace-hash-fix.patch patches-rt11/ftrace-hash-fix.patch
--- patches/ftrace-hash-fix.patch	2011-07-23 12:49:08.000000000 -0500
+++ patches-rt11/ftrace-hash-fix.patch	2011-08-14 14:16:38.853411213 -0500
@@ -1,5 +1,4 @@
-commit 41fb61c2d08107ce96a5dcb3a6289b2afd3e135c
-Author: Steven Rostedt <srostedt@redhat.com>
+From: Steven Rostedt <srostedt@redhat.com>
 Date:   Wed Jul 13 15:03:44 2011 -0400
=20
     ftrace: Balance records when updating the hash
diff -ru patches/panic-disable-random-on-rt.patch patches-rt11/panic-disabl=
e-random-on-rt.patch
--- patches/panic-disable-random-on-rt.patch	2011-07-23 12:49:08.000000000 =
-0500
+++ patches-rt11/panic-disable-random-on-rt.patch	2011-08-14 14:13:17.71990=
5593 -0500
@@ -1,3 +1,5 @@
+From: Thomas Gleixner <tglx@linutronix.de>
+
 ---
  kernel/panic.c |    2 ++
  1 file changed, 2 insertions(+)
diff -ru patches/_paul_e__mckenney_-eliminate_-_rcu_boosted.patch patches-r=
t11/_paul_e__mckenney_-eliminate_-_rcu_boosted.patch
--- patches/_paul_e__mckenney_-eliminate_-_rcu_boosted.patch	2011-08-12 16:=
46:08.000000000 -0500
+++ patches-rt11/_paul_e__mckenney_-eliminate_-_rcu_boosted.patch	2011-08-1=
4 14:16:15.578512313 -0500
@@ -17,7 +17,7 @@
=20
 diff -urpNa -X dontdiff linux-3.0.1-rt9/include/linux/sched.h linux-3.0.1-=
rt9.patched//include/linux/sched.h
 --- linux-3.0.1-rt9/include/linux/sched.h	2011-08-12 14:22:22.000000000 -0=
700
-+++ linux-3.0.1-rt9.patched//include/linux/sched.h	2011-08-12 14:32:18.000=
000000 -0700
++++ linux-3.0.1-rt9.patched/include/linux/sched.h	2011-08-12 14:32:18.0000=
00000 -0700
 @@ -1268,9 +1268,6 @@ struct task_struct {
  #ifdef CONFIG_PREEMPT_RCU
  	int rcu_read_lock_nesting;
@@ -30,7 +30,7 @@
  #ifdef CONFIG_TREE_PREEMPT_RCU
 diff -urpNa -X dontdiff linux-3.0.1-rt9/kernel/rcutree_plugin.h linux-3.0.=
1-rt9.patched//kernel/rcutree_plugin.h
 --- linux-3.0.1-rt9/kernel/rcutree_plugin.h	2011-08-12 14:22:24.000000000 =
-0700
-+++ linux-3.0.1-rt9.patched//kernel/rcutree_plugin.h	2011-08-12 14:33:21.0=
00000000 -0700
++++ linux-3.0.1-rt9.patched/kernel/rcutree_plugin.h	2011-08-12 14:33:21.00=
0000000 -0700
 @@ -299,6 +299,9 @@ static noinline void rcu_read_unlock_spe
  	int empty_exp;
  	unsigned long flags;
diff -ru patches/power-use-generic-rwsem-on-rt.patch patches-rt11/power-use=
-generic-rwsem-on-rt.patch
--- patches/power-use-generic-rwsem-on-rt.patch	2011-07-23 12:49:09.0000000=
00 -0500
+++ patches-rt11/power-use-generic-rwsem-on-rt.patch	2011-08-14 14:13:08.99=
6920880 -0500
@@ -1,3 +1,5 @@
+From: Thomas Gleixner <tglx@linutronix.de>
+
 ---
  arch/powerpc/Kconfig |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

--MP_/8f8+dK./IHXPO8ykoaGvqC6--

--Sig_/zu33/mNG5HrWrFjxevRE8nz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5IO/oACgkQHyuj/+TTEp3exgCgmbIMPT+tPevHSbN752UbH4Uo
NacAnRJkSms2VAsQHSxIKFkhXOb5PMLO
=ZSL6
-----END PGP SIGNATURE-----

--Sig_/zu33/mNG5HrWrFjxevRE8nz--
