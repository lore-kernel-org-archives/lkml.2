Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2GUCWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 22:22:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26516 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2GUCVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 22:21:11 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=R-VO9erGiE4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=2yy7z9ee9AFxJZM3T4oA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=hjMDBj44-Z88cRaBKZYA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120721022108.597891394@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 20 Jul 2012 22:19:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 08/19] ftrace/x86: Remove function_trace_stop check from graph caller
References: <20120721021943.274162381@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-x86-Remove-function_trace_stop-check-from-gra.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The graph caller is called by the mcount callers, which already does
the check against the function_trace_stop variable. No reason to
check it again.

Link: http://lkml.kernel.org/r/20120711195745.588538769@goodmis.org

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S |    3 ---
 arch/x86/kernel/entry_64.S |    3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 4dc3017..061ac17 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1241,9 +1241,6 @@ END(mcount)
=20
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	cmpl $0, function_trace_stop
-	jne ftrace_stub
-
 	pushl %eax
 	pushl %ecx
 	pushl %edx
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 52bda2e..38308fa 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -213,9 +213,6 @@ END(mcount)
=20
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	cmpl $0, function_trace_stop
-	jne ftrace_stub
-
 	MCOUNT_SAVE_FRAME
=20
 	leaq 8(%rbp), %rdi
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQChIUAAoJEIy3vGnGbaoAxzoP/0MgwqYNSF7tM0yd6o0IzKDP
rU8ylajhWX2wlNRb6OxATFYX70RJ+WGPjojB6dQnq0etk10WcKnThNunQP7crovQ
ZSHgZfCXl430o9J7foHuojguOQmRsjbaJnAsWGApja9gudVR7mnzFC11FfuH5JmJ
p7TFbUJDWkAmVxKSmOKALndwYZm+A49JI3BhL8Rp4id1v/3UFlmqcNEywbFVIpsV
M79Wqpwz41wvt3G7CUsKI1MCwNcEmZxyMmH6o/ZszHmokw3+qihqe+dKMa7Yders
v9cHwZ1aaOLIOnF1UgwAuv5JPTKTVbOgxscI45Wpdbwk+zrl5P2G+T0j7sc68YIb
Mbt5/axj0JPNyzqyjT3sihQTQ3wbqEle70NXBgIih0n109vZQVNIw6+TFGrcz1XE
pI2uRLasT9q5JI6s5PjwcLSiOrnDRRIVVTfJB8BpE76NPbXGqKlTzGXoAqMxLvwi
XjtvAweENOQsj4VMr9/ZbJPgtnQTclZna5sParTQHxJjV7tTnftFd/EUBLFodNVD
Xe4ZuuksRirzXn6iYGNHdNoJ4KQxRKSmN8OjGTBPkFzADElVyNQxdcod7nOYOmzS
KeSbh1osIQSnw5qBckM3CbRfiUuP5Ux13vCZ2IqVZR1sQchmHKC84BcUXLtI4+10
7zIPDcy6kgZz92/uSxUD
=k6xk
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
