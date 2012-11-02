Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582Ab2KBSOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:14:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934455Ab2KBSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:37 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Yuv1v-kq_N0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2KByqrNPVRQA:10 a=20KFwNOVAAAA:8 a=2N7iOkv7plfqhN_ov1EA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=yyqHT7HSdn8umHtQCOMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181432.844114164@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 17/19] tracing: Remove deprecated tracing_enabled file
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0017-tracing-Remove-deprecated-tracing_enabled-file.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The tracing_enabled file was used as a quick way to stop
tracers, and try to bring down overhead for things like
the latency tracers (irqsoff, wakeup, etc). But it didn't
work that well.

The tracing_on file was created as a really fast way to
stop recording into the ftrace ring buffer and can interact
with the kernel. That is a tracing_off() call in the kernel
can disable recording of events, and then from userspace one
could echo 1 into the tracing_on file to continue it. The
tracing_enabled function did too much to allow for this.

The tracing_on has taken over as a way to start and stop tracing
and the tracing_enabled file should not be used. But because of
its existance, it still confuses people. Over a year ago the
following commit was added:

 commit 6752ab4a9c30d5411b2dfdb251a3f1cb18aae487
 Author: Steven Rostedt <srostedt@redhat.com>
 Date:   Tue Feb 8 13:54:06 2011 -0500

    tracing: Deprecate tracing_enabled for tracing_on

This commit added a WARN_ON() if the tracing_enabled file's variable
was changed. After this was added, only LatencyTop complained, and
they soon fixed their tool as there was no reason that LatencyTop
should touch this file as it was using the perf ring buffers which
this file does not interact with. But since that time no one else
has complained about this WARN_ON(). Thus it is safe to assume that
this file is no longer needed. Time to get rid of it.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3c9b96a..d5cbc0d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4788,9 +4788,6 @@ static __init int tracer_init_debugfs(void)
=20
 	d_tracer =3D tracing_init_dentry();
=20
-	trace_create_file("tracing_enabled", 0644, d_tracer,
-			  &global_trace, &rb_simple_fops);
-
 	trace_create_file("trace_options", 0644, d_tracer,
 			NULL, &tracing_iter_fops);
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2IAAoJEOdOSU1xswtMu9AH/Ri8XbgaWyPfyxKoYqSFpc85
NiMtkb4ZqqDizRpwu1AD6zv6utrc4EWmKitgm4IjxIkdlAUue+Xi4oL4mslVNBJN
dOQ8FxyPUBknYt2r3wKGMPoghnnaFTQY5lD5gSmtbcRnalG8QoP3jhFQO4MmBRol
NBl8UzmXrFn65MLK4RWf+Sb5igonvTVYxEerAZrWxwaAp00s2NL6Whvm9k3MMz/l
lfgiubU/6OZa2VWvq8RJRJExxbgKYDA33h2I69znlQmcVb+mTE7GCaKDXz+G0+UD
hCHyxbkZG9MptBl85/KC+YxyruQCfnWpxjaqmzuk+Wy52fChYrbtf61+kG1N+9E=
=IO1o
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
