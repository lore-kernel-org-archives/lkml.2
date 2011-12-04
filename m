Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab1LDTCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:02:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40957 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab1LDTAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:18 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=CFB24ZDOxKEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=hzis4LBC8CJ2KpBMWakA:9 a=lOKbjoKh1MInWfvx7cgA:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Ct1bUFrPmBkG6KOr8DAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111204190015.658345057@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sun, 04 Dec 2011 13:54:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH 06/11] wait: Provide __wake_up_all_locked
References: <20111204185444.411298317@goodmis.org>
Content-Disposition: inline; filename=0006-wait-Provide-__wake_up_all_locked.patch
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

iQIcBAABAgAGBQJO28M/AAoJEIy3vGnGbaoAfJQP/3INf0EIVmjFXJoHs0dhmU2P
ev/WedENRqUb3/hpcEN8mShNG3Syqqkjuv1Eoi3TLhQZaVIWagTYypbbVchpt6iy
5ix8/0nccbSBHxz/M2ndfrk1xyOee89YC/Y/5GHAlD5tzrrYOGNqJPL84OW3kc8/
HmF/GpW+8fPj3o4lbetf8fpsSfYbtsib04l5rRO2lrpL8BRnFiOM2/fuChE0kKl0
jPrFoNM4EtF33qybclo8SVUXlBJT75syMeYkc3EvLmg9zAYdrgghyM4gJDmq+1x3
rbFKrMcFFjTAHQabPlR5bpqburjaF2mQtZffzL6Eq8Y3krwN2TCIMN4ny4zG3KRi
WZqcsG0Hu+P7NGXsKP6X4SydyzPZtpJqcKp6/kW5mjR2ixzkrgMvP9BWpKcy1XLo
Qjc54irUNWObjY45Cczo9MBZbDPiKFL4hTbk8soQioWmE2N9TmRflr7gr4FLiCcv
NfbrXUHtM02edH6jrWbcuWmUOE4d/p8H7YELt7mk0X4MiwJBWpbIhkul0mO1siux
sHl6/FvI2zJBFMPuGamcrNGdqNc2NfZ+cgVoNKHrroBlpRl3Ff2PyplabQQkdK0L
n8t4SZ+lyC7cFioJfY4c+XydtTKSkk1sMQ0I/TJEdOPgtqiwFcDKH/q0P+tpDyGa
OmBNYF//Wt7XQIcq5IXy
=Rt05
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
