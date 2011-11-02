Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1KBTRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:17:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab1KBTRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:17:32 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=HVAoYpKHslcA:10 a=5SG0PmZfjMsA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=D_SbEOMbAAAA:8 a=ayC55rCoAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=yVeNhkG9aDR6brvXEI4A:9 a=NYwZVWVbHIcmVGQiy7cA:7 a=PUjeQqilurYA:10 a=7KbvKZvEaC0A:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=lWI7GXLC-pdcaJNWxoIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320261445.4793.49.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL] sched: Set the command name of the idle tasks in
 SMP kernels
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>
Date: Wed, 02 Nov 2011 15:17:25 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ktguUN28u+iWFEzvo09R"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ktguUN28u+iWFEzvo09R
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Ingo,

Please pull the latest tip/sched/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/sched/core

Head SHA1: 901f405ff7ff12c5643f0f1f8b06052079be1389


Carsten Emde (1):
      sched: Set the command name of the idle tasks in SMP kernels

----
 include/linux/init_task.h |    3 ++-
 kernel/sched.c            |    4 ++++
 2 files changed, 6 insertions(+), 1 deletions(-)
---------------------------
commit 901f405ff7ff12c5643f0f1f8b06052079be1389
Author: Carsten Emde <C.Emde@osadl.org>
Date:   Wed Oct 26 23:14:16 2011 +0200

    sched: Set the command name of the idle tasks in SMP kernels
   =20
    In UP systems, the idle task is initialized using the init_task
    structure from which the command name is taken (currently "swapper").
   =20
    In SMP systems, one idle task per CPU is forked by the worker thread
    from which the task structure is copied. The command name is, therefore=
,
    "kworker/0:0" or "kworker/0:1", if not updated. Since such update was
    lacking, all idle tasks in SMP systems were incorrectly named. This
    longtime bug was not discovered immediately, because there is no /proc/=
0
    entry - the bug only becomes apparent when tracing is enabled or if
    a crash happens while current is the idle task. The displayed name
    of the task will be kworker/0 instead of swapper. This has already
    caused some confusion while debugging RCU.
   =20
    Link: http://lkml.kernel.org/r/1320075882.4793.4.camel@gandalf.stny.rr.=
com
   =20
    This patch sets the command name of the idle tasks in SMP systems to th=
e
    name that is used in the INIT_TASK structure suffixed by a slash and th=
e
    number of the CPU.
   =20
    Link: http://lkml.kernel.org/r/20111026211708.768925506@osadl.org
   =20
    Cc: stable@vger.kernel.org
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Carsten Emde <C.Emde@osadl.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index d14e058..7da43db 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -126,6 +126,7 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
=20
+#define INIT_TASK_COMM "swapper"
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=3D0, limit=3D0x1fffff (=3D2MB)
@@ -162,7 +163,7 @@ extern struct cred init_cred;
 	.group_leader	=3D &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
-	.comm		=3D "swapper",					\
+	.comm		=3D INIT_TASK_COMM,				\
 	.thread		=3D INIT_THREAD,					\
 	.fs		=3D &init_fs,					\
 	.files		=3D &init_files,					\
diff --git a/kernel/sched.c b/kernel/sched.c
index 24637c7..4af20fd 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/init_task.h>
=20
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -6098,6 +6099,9 @@ void __cpuinit init_idle(struct task_struct *idle, in=
t cpu)
 	 */
 	idle->sched_class =3D &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
+#if defined(CONFIG_SMP)
+	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
+#endif
 }
=20
 /*


--=-ktguUN28u+iWFEzvo09R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOsZdFAAoJEIy3vGnGbaoAVQoP+wSOCJElP8PPchgDeVWSLkJy
o40PbcVpQ13ynQX4e9fw065yvHZcYpTp2MoGy+gRJLgbjfY+2HTWwClWhvGs116D
qNlXWAXHf56p4rmjLGUeZ9t48Oru1cR/UW2/z6J/hCAcJnfk84xTT8gwc4idbrgt
fiOq2BV6Nn574JO0EGVx9amgRkjoSf0yPdPS/JYwL6iawUsxw2eRdo8Zv6LZsF7p
ZLFGmdfw0fFcaEFzr6m/9+E5I3ltmlYWal9q5uffzDhplvvIvDGDT8OBULoSDc0C
plJwCU8v5o/YzTNUxzqQyQxIQ6Su3xLOI7o4WcRDjA9rbRc/85dhic/mZ5ea+w9x
9z7U9Y0pS2bxvYCi5xUZ5PM7dC6OVWnxDbkYI8wTzEIBkY2/wX9rQSSSq3Lz2esv
SJTmf+/LM671jT4pXk7laiAlMZbyUMiH/9H/UliGFJMrAmdfUzhOKjKVjyNeu3Pv
3fQN4Kgxb8e31fzYKJwzjsaYdAmqHPmQ25rZZNZ9fttwl5+iX8tfjLbsGNB8uY6r
spYf8Uw1OD+pX1LBJ6prTQXFzBb5HEBnVs4Rn/ah3NCL8DF6nEwcbzTDgj8m+94z
h/pt4eS25SgXufkAiL0deUhADv0oyJwnyEmFR3vJo3DOso3hXuaiSh0PEqemipo1
tEf4/ePlWRM28zRfLrax
=74+L
-----END PGP SIGNATURE-----

--=-ktguUN28u+iWFEzvo09R--

