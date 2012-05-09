Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438Ab2EIQ67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:58:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32933 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760374Ab2EIQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:58:41 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=Rw2YHs0ERYYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=omOdbC7AAAAA:8 a=VnNF1IyMAAAA:8 a=UPm3pfgAAAAA:8 a=meVymXHHAAAA:8 a=0E1gmkPGgpvvfwTtov8A:9 a=IaZqOcpztjV0nXeGJhoA:7 a=QEXdDO2ut3YA:10 a=v3rLFGiuRE8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=UTB_XpHje0EA:10 a=Zh68SRI7RUMA:10 a=mOio7EKfaG4A:10 a=jeBq3FmKZ4MA:10 a=UyCiFHsJN-25Fn--YtIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120509165838.254683141@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 12:57:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, Minho Ban <mhban@samsung.com>
Subject: [PATCH 1/3] tracing: Prevent wasting time evaluating parameters in
 trace_preempt_on/off
References: <20120509165751.114716410@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Prevent-wasting-time-evaluating-parameters-i.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Minho Ban <mhban@samsung.com>

This fixes spending time for evaluating parameters in trace_preempt_on/off =
when
the tracer config is off.

The patch mainly inspired by Steven Rostedt, thanks Steven.

Link: http://lkml.kernel.org/r/4FA73510.7070705@samsung.com

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Minho Ban <mhban@samsung.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 0b55903..d32cc5e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -491,8 +491,12 @@ static inline void __ftrace_enabled_restore(int enable=
d)
   extern void trace_preempt_on(unsigned long a0, unsigned long a1);
   extern void trace_preempt_off(unsigned long a0, unsigned long a1);
 #else
-  static inline void trace_preempt_on(unsigned long a0, unsigned long a1) =
{ }
-  static inline void trace_preempt_off(unsigned long a0, unsigned long a1)=
 { }
+/*
+ * Use defines instead of static inlines because some arches will make cod=
e out
+ * of the CALLER_ADDR, when we really want these to be a real nop.
+ */
+# define trace_preempt_on(a0, a1) do { } while (0)
+# define trace_preempt_off(a0, a1) do { } while (0)
 #endif
=20
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqqI+AAoJEIy3vGnGbaoA5fUP/04SQ/vHlS4S7CkbpEJzp+kB
gkIgyV3H/PnXx0zp9TVLCVoQ4c4OYeR1/w+NUPMcsbJS4NJEFG8T9wLCWaeVepJ/
ey1vjstHKq+dBQvFKKKnCe9LEBv1uv/yYkfjGTgov8dWQ5kWrT96DYxm56D84N8K
EMGGLJOhFYUIxLxLhGVmBcYc5b5vmCymz1z2Mn2imUqK8Pd0UmiQvBi7l7IHlxjh
l1gCCnq+nuBUBxhQMODJlwi8UzNfzZYi4cVb9JXLPkAVM8N8s2716PO0yyXlu5eV
M0yQWxWFZB7bKkTYuXzD6ppmwlsF/yS3bjbnGet4Pz7il3axlDsmuRYAQqvk8r2z
2K9k9xCwLj7M1DbmFi1cMmRWnwIXRwdJla0UZ7N8Pnp1rRIoOh8ysIY+6d+4v10U
sf2pGZsiJRB6XF9waOLcT9AHa/OANYVUZNqghZ3Lx8GvM+gJ3MRKHJcDiW1QAS8Z
+dbytSlHHO32PvttWDplf3kxsomwG0KrYeyEJvMc9sfi3rnXsTgO0SHHNwFcc4Id
6QT4l5ZbKOklE+hsmhZoJTosEM2emSmG9HnE4b3klXJm464qKr7/EamWNyQoGK68
0fpwc8UkbeHl0xENB1fo7GNuUTINum1XtD52llDKIbrqScBfeGTmcUbgIMLYslbe
Ziyr0POPmNh7NcDbfq7q
=8oDY
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
