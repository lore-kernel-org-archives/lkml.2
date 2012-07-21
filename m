Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2GUCVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 22:21:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22835 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2GUCVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 22:21:10 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=FUJXACS5bz8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=TsNgXkvQm6id9O5xiMMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=EvKJbDF4Ut8A:10 a=s0Dg3XkGZUyswKr378AA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120721022107.235836623@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 20 Jul 2012 22:19:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 04/19] ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function
 tracer
References: <20120721021943.274162381@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-x86_32-Push-ftrace_ops-in-as-3rd-parameter-to.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add support of passing the current ftrace_ops into the 3rd parameter
of the callback to the function tracer.

Link: http://lkml.kernel.org/r/20120612225424.942411318@goodmis.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    2 +-
 arch/x86/kernel/entry_32.S    |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 783b107..b3bb1f3 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -32,7 +32,7 @@
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
=20
-#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
+#ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 #endif
=20
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 623f288..e3e17a0 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1111,6 +1111,7 @@ ENTRY(ftrace_caller)
 	pushl %edx
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
+	leal function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
=20
 .globl ftrace_call
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQChITAAoJEIy3vGnGbaoAwIYP/j1H37r3CVFZqIybXSgSejPD
tcgbZ78fSHAJKkaGj/KB1ogN2K4YJcQRyPtmExdF6eNQn+nobc3KTMbM220509G5
WpIT8Y9j4SaAVeCpNwT8lmwXypRlOWX/eRKB+TdYaGaosogHGRMGdfKllC2ZBEH7
EvgW4BNmdLjgoeHyYADIvd58yQT93AtKDQGV/Xiu7tnw5EZ71L0obcImsTfHa0oi
4T/Asu444sUyXO32qkrUykDgYPWmAJ0NDtYgdleS0avzLlnQeMpYclOG29dEpoo3
xMxuojz4gYxzeQnaeY0tcbx2Ow3KBEUTOm+LAvmfdX3Rwo1cnAmKMPiRLAp5cT7E
7SZXSOwsmEIGcE59bxnzNPzbvMFcN1+YEi/1W285jgixjt3cZAM0oU2oM4Jx2u7c
AtV3mfyFX8zXHw4lSnkDNyFt+FLqS0/bMqgdoO15cl7Nutto3I+yGBaeNCmlMNb7
VxBjL3Ebl4yzuuXqXKfBhtevpubxJVErpDbSQ4o77bf0H1zk5yokJaH5kdkNQ7Fz
ZXg7uG0CwWO/h/lRxpkmIMV0nTHeh73dMG0xEZVpqji1pa2YedPG2rAOjoXZ0MF8
4MWw8Hy3cLVFofwaWoADPijZT/Prx0JLKhOLbRHVyCQZY8pTsNrwyaHEkQNKNpIV
YpOeNkCteOcqVCZpO1C9
=2IO6
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
