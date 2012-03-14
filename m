Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839Ab2CNQ2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:28:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab2CNQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:27:10 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=2T7vlW5cG-QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=UOuEXLYGAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=RGrtQqOvj_poEzIjHo8A:9 a=QEXdDO2ut3YA:10 a=KDHgVdQ1CmEA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=cfys0rgo-HAX9PftGDYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314162708.250921795@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 14 Mar 2012 12:26:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Gerlando Falauto <gerlando.falauto@keymile.com>
Subject: [PATCH 2/6] tracing: Do not select FRAME_POINTER on PPC
References: <20120314162629.118638243@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Do-not-select-FRAME_POINTER-on-PPC.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Gerlando Falauto <gerlando.falauto@keymile.com>

On PowerPC, FUNCTION_TRACER selects FRAME_POINTER, even
though the architecture does not support it.

This causes the following warning:
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && FUN=
CTION_TRACER && KMEMCHECK) selects FRAME_POINTER which has unmet direct dep=
endencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH |=
| BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)

So remove the warning by adding the extra condition
"if !PPC" to FUNCTION_TRACER for FRAME_POINTER selection

Link: http://lkml.kernel.org/r/1330330101-8618-1-git-send-email-gerlando.fa=
lauto@keymile.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd31345..a1d2849 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -141,7 +141,7 @@ if FTRACE
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
 	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !S390 && !MICROBLAZE
+	select FRAME_POINTER if !ARM_UNWIND && !PPC && !S390 && !MICROBLAZE
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYMbcAAoJEIy3vGnGbaoAvcQP/A0bOgkx6LwTbsoZMSo0xJmf
nfzrXfsD8wDci9+fmiYBrJa2ZSVMHI9d/1HTXrSwJTLZbnqWyS1Mxu5yLR3HTgZA
HMLnKWhroQZ+rFKOdrmryTkGIEht4JJsPEQvbsx+7QTI1v5NYLjuzEfkwBIhsOU9
WlkBPw+/fHeYYHP2hp+tZWPM/iIYxmsQc7uoGHSB3Tdu815nlFIzdjsZ39E9vviE
FsbpsZ6k7gxOutWnQ+FBy0m1wSn/L8ileEZhhbdvTq1d0vVmFmz5Dxd+mfYLKiNd
vLs1i/VMOyXWY/Gu7yNmjAVJWyTHNz1j5b37xZCJf6MIGiyfiovciWQuA4BKAK1o
JmJQljT3ZBLcYyLoEdnPVphYTL6jmZCR25Jv31PWA3F1VXuxdw08+KeHYZ54Yg4D
bs61qssnPnPgKi5Hyc2qU6f8N/uAZnlJ51omRs2Vt84goqsDldS7vIzHvruq0Tdj
HQq8zTAQcKWY9i2uQmlzd7XL6zRCRjHOJ3gV3Y0LSWVgAHPFycPG7zUiVcoeJC4l
dlFffXgV1mVcqKgmX8UdvuJzPMHxZw0Lk7kU06zankv+BVFp0AmU0vwd8cdAYQKx
5R5pizadoCYuwEDkYa0c0I1lx7H5yqMISZeVRqEMaGtjpXNQUzFIgYY+SQT//VcY
M5N1mIR7aabVknydteLG
=AVF2
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
