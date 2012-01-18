Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2ARDrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:47:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab2ARDrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:47:01 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=l5uZ5QArPtIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=jL09i4WA_XB7JUFfNdkA:9 a=bO4Kx3JPDThagYbUgJwA:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Te8VYn8y_C3hEePXsD4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120118034659.876968220@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 17 Jan 2012 22:45:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 1/4] sched: ttwu: Return success when only changing the saved_state value
References: <20120118034531.335521323@goodmis.org>
Content-Disposition: inline; filename=0001-sched-ttwu-Return-success-when-only-changing-the-sav.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

When a task blocks on a rt lock, it saves the current state in
p->saved_state, so a lock related wake up will not destroy the
original state.

When a real wakeup happens, while the task is running due to a lock
wakeup already, we update p->saved_state to TASK_RUNNING, but we do
not return success, which might cause another wakeup in the waitqueue
code and the task remains in the waitqueue list. Return success in
that case as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 63aeba0..e5ef7a8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2693,8 +2693,10 @@ try_to_wake_up(struct task_struct *p, unsigned int s=
tate, int wake_flags)
 		 * if the wakeup condition is true.
 		 */
 		if (!(wake_flags & WF_LOCK_SLEEPER)) {
-			if (p->saved_state & state)
+			if (p->saved_state & state) {
 				p->saved_state =3D TASK_RUNNING;
+				success =3D 1;
+			}
 		}
 		goto out;
 	}
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPFkCzAAoJEIy3vGnGbaoA/yMP/3Ffp7A8zsu++5Q/sV1iqNjA
QvLF0FMPUCcnxWTqhz5f9QkKpxuSMmixnMQ66F/Q8jWDxr9DvdhZ3Oz1zvfBaY1J
HFEKHswoiTVvo43KLgmvW/tyQF2wfq/jck9a+Wzg8e8oRjkMGwbH9SCTL3yr3W6Y
FhjvfXeRxz/47MlLOaCUVk+miTxKUiCrl57+sPSQ5JRw8aIuu0Gl5FK03/BeC/3G
UA2/VJgGutsYSOS+7x6bElh/1tpSJUD1JfPaVuGnpF20fgxJunhGo/YdfLthcNVI
B0ApbXbPB12r+w9BLwdzxWEdF6hJEKCNi4JgJqbCCbMHtX20VUQ70LhXglhPrL27
uK8/Xlqrab5BadbQv6e+Mhu/7PBRyNZG5fyFfmyW4HG5pwGgYxT24qiFUTutFxar
4sZnIL4qaNGgJ8VBgpKmtIa7qcp8l90NrZ56Ape3Ry/C9snfGcREI2By4E+bsELN
U5w2YHIjhPPEAUYj4zMVf8Qb56KO20TmSqbbVtIKT+E8Oj/BKvvaLM6vM/m1uxuZ
RAFlu098e8gQ9qAnqTKwdTi05uSVcafj6+/uK4CZ8y31wVDSjY/p1Xp99jbsuerw
k5rgrFzAKyrq4hrd77hy99D4ikZok5Uf/fkQkrJo/dEbROo/xEYaZ30XCMtUuVUc
kmvpBQHD26w03zfv7Oa4
=UI7h
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
