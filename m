Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2BNDkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:40:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34864 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab2BNDkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:40:10 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=CWtqnKM6Dr4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=UPm3pfgAAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=2zli643jjhjTyJyuCMsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=mOio7EKfaG4A:10 a=jeBq3FmKZ4MA:10 a=3vjraaJA2kyUgIr61wAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120214034007.297163721@goodmis.org>
User-Agent: quilt/0.50-1
Date: Mon, 13 Feb 2012 22:39:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 5/9] cpuidle/tracing: Denote the tracepoints as being in rcu_idle_exit()
 section
References: <20120214033909.904564921@goodmis.org>
Content-Disposition: inline; filename=0005-cpuidle-tracing-Denote-the-tracepoints-as-being-in-r.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As the tracepoints in the cpuidle code are called when rcu_idle_exit() is in
effect, the _rcuidle() version must be used, otherwise the rcu_read_lock()s
that protect the tracepoint will not be honored.

Cc: Len Brown <len.brown@intel.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/cpuidle/cpuidle.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..6588f43 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -94,13 +94,13 @@ int cpuidle_idle_call(void)
=20
 	target_state =3D &drv->states[next_state];
=20
-	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
-	trace_cpu_idle(next_state, dev->cpu);
+	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
=20
 	entered_state =3D target_state->enter(dev, drv, next_state);
=20
-	trace_power_end(dev->cpu);
-	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
+	trace_power_end_rcuidle(dev->cpu);
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
=20
 	if (entered_state >=3D 0) {
 		/* Update cpuidle counters */
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPOdeXAAoJEIy3vGnGbaoA6RgQAMMsr1ppYXzvujeGy0ZMN10C
CYvfhOipJga/bu8SzEX+zYLIsEzoepHDnSCm/CtaSel51rD3JYB103w2crVsvvux
TBfgtYI7n4mZfsylNNLNAHNd22I4NAAABzAoX3N7tnHE1Pvwwv1G/+LhzgC1NQo1
7Led6K9vo+0jNBV8u/MnBeuitvIWY+YZNVLvFmcGBosru/VHq+CDNsMUT0Kf4dGa
BKpvrT2NNeAwnBHE/crIT57q11CL5Bw5S4GOOACmIOBVQ6CEM5Uow/R7Be6qfc8X
jzemwsSbJUJGd8a/Njbvgc7pPhD5TatJoTTqXme/mojDxEROLO78e3PnrhRlqzLr
g5bNrxLFNmrMM9hW6zXpj3AZR2Cf2yTHNfZ8AH3rlFaf/pCzB9LzkpmcSNca4Vcg
+7rXRSks15Mf7nBeVYx3yATwOJnlwqf/h+Mu+ouqNQUFQOJS7f2c+FJ1ghrl/MAe
Jo/JFUF2i6S5oA++CSGz58RrB1m79yjWo3YAwTHDGedlrmm1gZEf9aXLZDvtIWQo
PBAbmc6BQ33ZplgsVmKr/qYDw8Zm6e/+M22kwDiEQxd6exVZGDJxgPsB7+COMnPE
Xlteko6QAZB5OHP2eVt7FuWBckaSLssSpmyyTZt0iujjDveiKkvDkR271IiBa9Mj
9zKic8uOMkOINRptoeKJ
=zMMm
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
