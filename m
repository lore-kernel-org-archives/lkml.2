Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab2ERNNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:13:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713Ab2ERNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:50 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=dxZqrmz8_3oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=r3gMXHhZIFJ0t6_2q1EA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=QGFCxrSHdWll_91x1PMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131049.627556714@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Laurent Chavey <chavey@google.com>,
        Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 07/15] tracing: change CPU ring buffer state from tracing_cpumask
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-change-CPU-ring-buffer-state-from-tracing_cp.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

According to Documentation/trace/ftrace.txt:

tracing_cpumask:

        This is a mask that lets the user only trace
        on specified CPUS. The format is a hex string
        representing the CPUS.

The tracing_cpumask currently doesn't affect the tracing state of
per-CPU ring buffers.

This patch enables/disables CPU recording as its corresponding bit in
tracing_cpumask is set/unset.

Link: http://lkml.kernel.org/r/1336096792-25373-3-git-send-email-vnagarnaik=
@google.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Laurent Chavey <chavey@google.com>
Cc: Justin Teravest <teravest@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0ed4df0..08a08ba 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2669,10 +2669,12 @@ tracing_cpumask_write(struct file *filp, const char=
 __user *ubuf,
 		if (cpumask_test_cpu(cpu, tracing_cpumask) &&
 				!cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_inc(&global_trace.data[cpu]->disabled);
+			ring_buffer_record_disable_cpu(global_trace.buffer, cpu);
 		}
 		if (!cpumask_test_cpu(cpu, tracing_cpumask) &&
 				cpumask_test_cpu(cpu, tracing_cpumask_new)) {
 			atomic_dec(&global_trace.data[cpu]->disabled);
+			ring_buffer_record_enable_cpu(global_trace.buffer, cpu);
 		}
 	}
 	arch_spin_unlock(&ftrace_max_lock);
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpZAAoJEIy3vGnGbaoAaoAQAOyKhFxDFS7ZklTRjsE2ytk3
jhEux+o2Wng8eYnenwefgtJAjbnM1RfOoZ0f+8pzWYBV2Wq3MNsRl+T2hw7tWIVn
Lp6bjnAo1shR7PKhT6Smd0Hg7xb6RVi2OuB4iKM0SV41lCvrqa8rfTfcuHLbiZ+2
TNYRhytiPTSRC9K6hBc2eLEIHGtRRW0ml1CC2q6sHITlnJ5hLCBCgicdFdmYp80J
8se2m7kXtX3M88T98VmoUjoY5BtbY2B0uUUd2n2vAT6uLxL/N3D4gAee0zOxQ/Dk
4LcLi+CmCMu/KkTqMO9gHGeo9HeKaUR3+vI9XRx0kVjxd1SRUfNwgB6o9Fb6MtW+
EBfdl7rYouJ0LivtV1CSwNmAvAsFB2boDESPtRgby5pMrcEMrePv7WoKHUw6zcZV
fNmzlLp0K4TRn5nnTOkJWwyhpn4KbAxTduHHXpjp8oSJAYTL22KdaQDMNHhEwTjh
slsk+8WztfBgmzlknmd5FSh+mWgtIqxWNG60eiAB4bUCLw9dO+DC6B0qVImkns1x
QMq6SGbK3YllF5gL0DDgKihkXFPhQdK2LIaHt1VXhVSKYzqK9tXukOA9oLQDgx27
ujtGSvszRpEbZN8HXrghvRQEh0Hdj2k/Ccw5MEquX+lxdRwzCGICipq02zWuGJnH
6PIsmDJRdJt9p+TwauFb
=bhGS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
