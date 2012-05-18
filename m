Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946033Ab2ERNLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:11:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945932Ab2ERNK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:56 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=WupOhK0eYXgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=2mpfi5TdF5UcT3aGsd0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=kDy_IvSbt3LMxHlSWWgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131052.374128232@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 15/15] ftrace: Remove selecting FRAME_POINTER with FUNCTION_TRACER
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0015-ftrace-Remove-selecting-FRAME_POINTER-with-FUNCTION_.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The function tracer will enable the -pg option with gcc, which requires
that frame pointers. When FRAME_POINTER is defined in the kernel config
it adds the gcc option -fno-omit-frame-pointer which causes some problems
on some architectures. For those architectures, the FRAME_POINTER select
was not set.

When FUNCTION_TRACER was selected on these architectures that can not have
-fno-omit-frame-pointer, the -pg option is still set. But when
FRAME_POINTER is not selected, the kernel config would add the gcc option
-fomit-frame-pointer. Adding this option is incompatible with -pg
even on archs that do not need frame pointers with -pg.

The answer to this was to just not add either -fno-omit-frame-pointer
or -fomit-frame-pointer on these archs that want function tracing
but do not set FRAME_POINTER.

As it turns out, for archs that require frame pointers for function
tracing, the same can be used. If gcc requires frame pointers with
-pg, it will simply add it. The best thing to do is not select FRAME_POINTER
when function tracing is selected, and let gcc add it if needed.

Only add the -fno-omit-frame-pointer when something else selects
FRAME_POINTER, but do not add -fomit-frame-pointer if function tracing
is selected.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a1d2849..d81a1a5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,6 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !PPC && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpcAAoJEIy3vGnGbaoAqSsQAI65zO1pqKFB13RnBgepy3z9
8C23er0liJ5HuR+W2CxloZi6CFNJXaseaIGzDxfu5U+xGsUpTmvEdJgEjXfiw/Gz
6pC0TiRQlNs4mdv4lCe4k+iho7eQ1jbHN0YR4QIN9VKKTCrJU4/YuKxztMOvrORk
OVGIs86iqHLyVIblgZHfrThsKsi1bJNQHoXS4cMHWztqxa2Qkj+X9UkOG5gwn4yE
QPRfPACftnkf2yHYNVKOUo6HHMKy8ZHJFvIui4UITxMcu45+L2CpwbqtmXRTv1GJ
DxMY+wonWwQNVNmOMLxlNwAbXvrkBeM1Tu/x+yJ8fXdpIRyUJqnKIBbL2oRHxbbB
ayhNZ2nrHQtrOzTmneXYKR4cOgj+LlCXkGZY9AfeDT2AlvQoPwIQpJQ72w1dPKa7
RreZakmi/m8TBS2//Cq3yVN/asjcVvyoPYzSaRJIS0i/OBX/0LN/728I0Int2PjW
MlLQp75saHl7ykyxgT1JN33s3ylgJDfHeRoqla7tcR1dEsIe9T28emWncbLUWVyj
6R8jQg08D26QALYmGjvX6EOq7z+fHIJ4knz7gPUzn0l2T8T/LtWp9BrnTCzp1ogr
bsUC2wjycXZL2bdoAsw5kj8La16q2r8m8XGdEA2yRj6Oi5RwDVoOyP6/lZ14Mt6F
qEWwvo5+O118bctatpwq
=DVFS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
