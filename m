Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2F1XSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:18:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2F1XSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:18:09 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=rzCU7g-bn60A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=57SyGIRnAAAA:8 a=VwQbUJbxAAAA:8 a=h3sCQ_blAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=wuNl-Zt_mAcjDZABV5oA:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=LI9Vle30uBYA:10 a=fNChW5oJl9MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=v39dMnaX9O-NQX-yEB0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120628231807.067060568@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Jun 2012 19:16:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Avi Kivity <avi@redhat.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/4] tracing/kvm: Use __print_hex() for kvm_emulate_insn tracepoint
References: <20120628231625.869980334@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-kvm-Use-__print_hex-for-kvm_emulate_insn-tra.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Namhyung Kim <namhyung.kim@lge.com>

The kvm_emulate_insn tracepoint used __print_insn()
for printing its instructions. However it makes the
format of the event hard to parse as it reveals TP
internals.

Fortunately, kernel provides __print_hex for almost
same purpose, we can use it instead of open coding
it. The user-space can be changed to parse it later.

That means raw kernel tracing will not be affected
by this change:

 # cd /sys/kernel/debug/tracing/
 # cat events/kvm/kvm_emulate_insn/format
 name: kvm_emulate_insn
 ID: 29
 format:
	...
 print fmt: "%x:%llx:%s (%s)%s", REC->csbase, REC->rip, __print_hex(REC->in=
sn, REC->len), \
 __print_symbolic(REC->flags, { 0, "real" }, { (1 << 0) | (1 << 1), "vm16" =
}, \
 { (1 << 0), "prot16" }, { (1 << 0) | (1 << 2), "prot32" }, { (1 << 0) | (1=
 << 3), "prot64" }), \
 REC->failed ? " failed" : ""

 # echo 1 > events/kvm/kvm_emulate_insn/enable
 # cat trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 2183/2183   #P:12
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
         qemu-kvm-1782  [002] ...1   140.931636: kvm_emulate_insn: 0:c102fa=
25:89 10 (prot32)
         qemu-kvm-1781  [004] ...1   140.931637: kvm_emulate_insn: 0:c102fa=
25:89 10 (prot32)

Link: http://lkml.kernel.org/n/tip-wfw6y3b9ugtey8snaow9nmg5@git.kernel.org
Link: http://lkml.kernel.org/r/1340757701-10711-2-git-send-email-namhyung@k=
ernel.org

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: kvm@vger.kernel.org
Acked-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/trace.h   |   12 +-----------
 include/trace/ftrace.h |    1 +
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 911d264..62d02e3 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -710,16 +710,6 @@ TRACE_EVENT(kvm_skinit,
 		  __entry->rip, __entry->slb)
 );
=20
-#define __print_insn(insn, ilen) ({		                 \
-	int i;							 \
-	const char *ret =3D p->buffer + p->len;			 \
-								 \
-	for (i =3D 0; i < ilen; ++i)				 \
-		trace_seq_printf(p, " %02x", insn[i]);		 \
-	trace_seq_printf(p, "%c", 0);				 \
-	ret;							 \
-	})
-
 #define KVM_EMUL_INSN_F_CR0_PE (1 << 0)
 #define KVM_EMUL_INSN_F_EFL_VM (1 << 1)
 #define KVM_EMUL_INSN_F_CS_D   (1 << 2)
@@ -786,7 +776,7 @@ TRACE_EVENT(kvm_emulate_insn,
=20
 	TP_printk("%x:%llx:%s (%s)%s",
 		  __entry->csbase, __entry->rip,
-		  __print_insn(__entry->insn, __entry->len),
+		  __print_hex(__entry->insn, __entry->len),
 		  __print_symbolic(__entry->flags,
 				   kvm_trace_symbol_emul_flags),
 		  __entry->failed ? " failed" : ""
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7697249..c6bc2fa 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -571,6 +571,7 @@ static inline void ftrace_test_probe_##call(void)			\
=20
 #undef __print_flags
 #undef __print_symbolic
+#undef __print_hex
 #undef __get_dynamic_array
 #undef __get_str
=20
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7OYvAAoJEIy3vGnGbaoAJ/wP/3P7PmM4COMyhKyssLIJBCUm
tOqoxfC2w619MqF1FhrlbK/iZ+3ZHYJn+Ob5lMtQnI56s6orpH7uFXCklXZHGQ69
9ctswrTXhD/hwrG1jEUI0ua7Zlp2wdtUCTmvphZDQ5Jo1hI24tzthQmObO/1cZEq
8re8MKu0Tkcerl8jn54I5/DxXlKiQD/4wht5HYcN0wv++nggtLG6CF/LJiZrnfV7
JbgH0moggCfAZrV021ZFDE9Fv2uPZcs3NaMZ66EuELuJMHAJivI6my+xWBsrDQ+1
AComIdf3m9ad1Lt/J/JWOgAezzCeQ0ajor3tUh7Yv0qeUpX8g7hJc/cpnudigSHn
mprbiLcgIsk7rqktb0RMpNMCpGHbtljg3fqFzwmiVtXF293i6ApfhHuLXtvL+kKk
DNvye3uty1KDAuiBZBlZCQRUrqQ228dXZvr4fW8y5nE5XJA9hcbowp2UJwkfRYty
G1kaowCGhjekeiVjjfCxDK/8pytqb+ooWhaowlVUiQ9EIgdyB8vBl4aDqoDBZApO
n7mKbo1GAHggr1a4tO050fPZltLhRLHAM+oNKX7O07Bkwug4a2+MU2UtI/62Tjsy
qTEyvYeBcmzJBUkHh6pOiBYGJFJSRZ3PeLjt4OBnelUX2WrigFhN7+HDOX7Lg5Gx
Wf4dGlgppShLbzC2oHRl
=75wb
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
