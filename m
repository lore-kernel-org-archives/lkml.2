Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209Ab2CNQ1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:27:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2CNQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:27:09 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=bcmkCN2ZbB8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=RQ1JPUh_Bq6KXdNUK20A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=eHndc2AEcC7bWzMSyqQA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314162708.584325126@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 14 Mar 2012 12:26:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/6] tracing: Keep NMI watchdog from triggering when dumping trace
References: <20120314162629.118638243@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Keep-NMI-watchdog-from-triggering-when-dumpi.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As ftrace_dump() (called by ftrace_dump_on_oops) disables interrupts
as it dumps its output to the console, it can keep interrupts disabled
for long periods of time. This is likely to trigger the NMI watchdog,
and it can disrupt the output of critical data.

Add a touch_nmi_watchdog() to each event that is written to the screen
to keep the NMI watchdog from affecting the output.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f3c13d6..3a19c35 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -36,6 +36,7 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
+#include <linux/nmi.h>
 #include <linux/fs.h>
=20
 #include "trace.h"
@@ -4903,6 +4904,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_=
mode oops_dump_mode)
 			if (ret !=3D TRACE_TYPE_NO_CONSUME)
 				trace_consume(&iter);
 		}
+		touch_nmi_watchdog();
=20
 		trace_printk_seq(&iter.seq);
 	}
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYMbcAAoJEIy3vGnGbaoAUPMP/0BpSfuTX/VCBI64Y9YkMKnu
b1B+GDDsxsSO0B8DqocXEhW93uiq5BklKGq2Sh3Kxwt44JQZ7XXTL7+35D2aeJwl
+fB5mpY2OukbdtQw+twR29fn6YfZp6bj9G/f+AGKYJK2XfPmbYYNVIjTHlcJAo3w
p27axvY3vdYVZjapvyRFZgC9MKIho7PAulnNde+XKgSAe6loQ4XmR2+RklJ4c5b8
qOwW7GE/1LavX0GAtGecXZuFKCuld9C2Q/2laJ4AAxYy8o7Aiuf8lPI6nVWIrGS4
XpzDPdXYd/39kC/kuy5R2yMyUb5f0Mn26jeHKwKOqkPSjr/Do0dkaAV8HKjglg+3
qjTcucK5Rr6U2vB0km5PDRQzcmO8gCP9qQ/JiXQD0yo7FVStPOhN2NgjQETta8rH
vfymYN6QswFyTb06ePSdhDVrS2Z4fO3pWY5Ao45yTHKx8rXLWyhIdLTMbzCQGvE9
imUpKo5it8abiaOEc/FiaivA9W0hN/e5nBUZkNmV9n8clGC5zh89tziGjErn2Y1y
RRh4DWgUwdM2/Gj0sHSIWazOJev/e7jkpW1daZf30Bu8PgsntdSaP9aLYJc8ivKg
i+82da6zVykyg6vE8sQ+9dI9ZdqO7GNIRz84IWRrJ/BzHlWOGuPhUSOPKDvb1vu7
yLPIchxdxZd0OeA4OQem
=lzBb
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
