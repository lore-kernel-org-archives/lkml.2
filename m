Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab1KSEsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:48:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab1KSEsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:48:35 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=eMqdmb6FSZgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=1BvyPUWsSLuwEhnMVCYA:9 a=l_SoNF0GsXkLrliSFecA:7 a=QEXdDO2ut3YA:10 a=_twGcrsKVrYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=nrEvBcxuzEO0xzgtf20A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111119044831.614814511@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 23:45:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, stable-rt@vger.kernel.org
Subject: [PATCH 2/5] rcu: Fix macro substitution for synchronize_rcu_bh() on RT
References: <20111119044510.811163517@goodmis.org>
Content-Disposition: inline; filename=0002-rcu-Fix-macro-substitution-for-synchronize_rcu_bh-on.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: John Kacur <jkacur@redhat.com>

kernel/rcutorture.c:492: error: =E2=80=98synchronize_rcu_bh=E2=80=99 undecl=
ared here (not in a function)

synchronize_rcu_bh() is not just called as a normal function, but can
also be referenced as a function pointer. When CONFIG_PREEMPT_RT_FULL
is enabled, synchronize_rcu_bh() is defined as synchronize_rcu(), but
needs to be defined without the parenthesis because the compiler will
complain when synchronize_rcu_bh is referenced as a function pointer
and not a function.

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: stable-rt@vger.kernel.org
Link: http://lkml.kernel.org/r/1321235083-21756-1-git-send-email-jkacur@red=
hat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/rcutree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 7a25aea..3bf47dc 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -60,7 +60,7 @@ static inline void exit_rcu(void)
 #ifndef CONFIG_PREEMPT_RT_FULL
 extern void synchronize_rcu_bh(void);
 #else
-# define synchronize_rcu_bh()	synchronize_rcu()
+# define synchronize_rcu_bh	synchronize_rcu
 #endif
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOxzUfAAoJEIy3vGnGbaoAXQUP/15+IXQ/IT/9MAhQd/04iueH
FxzNx02/lnkL4RQEYi8NdP1D0ASoSKjc6QObAVrMCfvlYGyZgZIztc0AwNkns5fo
J5bm6RE60MtsCoL0MUjfUcQ4JM7ZgFqjt8vzsyjBi0kIcXyI4DWMwRNTSomgINnB
/Lhl3t5iAHQowzqyOZVcFvrtogYqFssXrsvnlEOa4ta5nSPdClAoC7kVaFknJQXj
efNakJ8mFxSikhEUmG9AQOdd/o4GuuofhzE0COeghmpWuLVEwDUKvFqb0pxhoEms
cp72fm2SVBsuo+Ld2voQzpK8l/0wvy2jZHkxMGIm03RAIMLRZDzdtue78B8kT6rV
/RXuJNhjgQhi+6uPjlI5nDikqZPQ2B+c2+NuEdGdGmk9sKKeVxt/GEjwv8AdCi/M
GxAmncTspV6RbhsGwntHDyE1Qv4ZAvqV1awmIw66t6E5kGuYJLvtiQKSsQq7QI/4
W6vpx+oa98x4vdy18H+JKXbmpHVqUK8juATi8wcCK1vIyO5uS9Q5eZyDDcscJM62
PhBG1X86/71119odhhUwlRUmsgVbMTzlb0FGFg0klR6YQy/87jastTjHMCOR50rA
tw+u+KqdtWvEEQ+GD7BnNNxghUiOpqW8sLbsARoA+kmDUif68mCthgEI9jDl9VV+
baA9sJokN8h86n3eVz4h
=vzUy
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
