Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1LCBh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:37:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1LCBhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:37:46 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=3nLstqFArToA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=hzis4LBC8CJ2KpBMWakA:9 a=lOKbjoKh1MInWfvx7cgA:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=maPiPDhOAo2z5QQKIE0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203013743.465705812@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:36:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable-rt@vger.kernel.org
Subject: [PATCH 05/10] wait: Provide __wake_up_all_locked
References: <20111203013653.090501690@goodmis.org>
Content-Disposition: inline; filename=0005-wait-Provide-__wake_up_all_locked.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

For code which protects the waitqueue itself with another lock it
makes no sense to acquire the waitqueue lock for wakeup all. Provide
__wake_up_all_locked.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/wait.h |    5 +++--
 kernel/sched.c       |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3efc9f3..1e904b8 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -157,7 +157,7 @@ void __wake_up(wait_queue_head_t *q, unsigned int mode,=
 int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *k=
ey);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
 			void *key);
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
 int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(vo=
id *), unsigned);
@@ -170,7 +170,8 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
 #define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
-#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)
+#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
+#define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
=20
 #define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
 #define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, n=
r, NULL)
diff --git a/kernel/sched.c b/kernel/sched.c
index 640f740..63aeba0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4642,9 +4642,9 @@ EXPORT_SYMBOL(__wake_up);
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t hel=
d.
  */
-void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr)
 {
-	__wake_up_common(q, mode, 1, 0, NULL);
+	__wake_up_common(q, mode, nr, 0, NULL);
 }
 EXPORT_SYMBOL_GPL(__wake_up_locked);
=20
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO2X1nAAoJEIy3vGnGbaoA4TEP/RCfrHQ0bo6yvwTsDAJBNPXd
Y/SkyZ5fTgNeC+epKFCg0uxHdS++A+ihSHZ/5p5MF8fnV5CuodaswHTHi//jt07a
QRuaH42oV+KNlQtR1g8uvYY8ZRZRvNzp3yWFkpr8/Gl3DdgxiBIyj8eNUKZHULit
647DFWeHQnFoNjDKXS+jvnfeQU84PgzDVw+PPab4BshVCiWG/kM+25FMMxeHeK0e
hcFla2MSteBSeJbKCWgCPHHgu66b5lQGF5kODNTGwyPXIxT/4XdkhfAgULeBo4uz
qNQ05ocUMc6m0zY6iM5QzaSKF3y3cAcj+e3bX40gF0T4vr8MeAwGOF7IvhATldpV
1QTw5Ssq1HiF5fV/UdMBm/xaGbl5daDKLnMfdlUhFH/gqybmkLl1WZj6W6LDWXKV
ov80dvYM56Af2JVTwdPxff+SBraovUpPk7iswVCG7Ne2ctIx5JIjf+Bf1mHfLAmc
GirSaRhiepkl76dImL5aAOFwPbHvHDY8xDw00bIRx98RMARTvxtl558Tt0Y+/rXU
q+PnrNmSn7jdCMYzx/nQJNDF2hib8mKK4//NYW1uxhXTOJWQ8Y8FB76b5S6UEqgm
CaYc6p0KfhfxotVI3K3GDLt8HYBczKQk+6tNKhoGTOsDjiCmlHEV1yKLzn3epnH3
GXJ2itVuw33KQH36RYjO
=Hgwj
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
