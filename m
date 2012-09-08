Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2IHL5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:57:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab2IHL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:56:42 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=EKbiWhdEN20A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_e5aofE2InkA:10 a=VwQbUJbxAAAA:8 a=WfulkdPnAAAA:8 a=QyXUC8HyAAAA:8 a=S1O5vlPNCnW5EmEqb6sA:9 a=QEXdDO2ut3YA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=O1tfeLvxfL-6mov8DQMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120908115640.032328533@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Sep 2012 07:55:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/7] perf: Enable function tracing for perf core
References: <20120908115515.211175517@goodmis.org>
Content-Disposition: inline; filename=0001-perf-Enable-function-tracing-for-perf-core.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

According to Steven R. there is no reason left to not support
function tracing for the perf core. This makes it easier to debug
perf.

Don't remove -pg for the x86 and generic perf core.

Link: http://lkml.kernel.org/r/1345306530-25665-2-git-send-email-andi@first=
floor.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/Makefile |    1 -
 kernel/events/Makefile       |    4 ----
 2 files changed, 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index d30a6a9..6a16725 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -5,7 +5,6 @@
 # Don't trace early stages of a secondary CPU boot
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_common.o =3D -pg
-CFLAGS_REMOVE_perf_event.o =3D -pg
 endif
=20
 # Make sure load_percpu_segment has no stackprotector
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d1..a630994 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -1,7 +1,3 @@
-ifdef CONFIG_FUNCTION_TRACER
-CFLAGS_REMOVE_core.o =3D -pg
-endif
-
 obj-y :=3D core.o ring_buffer.o callchain.o
=20
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) +=3D hw_breakpoint.o
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQSzJ4AAoJEIy3vGnGbaoAcuwP/2PSPGhzNpRbL+zUVPscpKe7
JUozSmAxwJXjP4L72pC6azRbUi1mqEHneEAFLpne1JBwFSEBvN0/lpSMfpK43NbT
Wx3PJJL3KY5y5KLlBJbDjuis3zQVv2v+8GYTLOvzMjC4cAzpoNn4Y5BZOM1Xsixe
Q1+ED7Zu/Dxr//4lEUp9cTMeuF+LdVwvPxRSGzLsTArG+tAgJsC/EIoCpdwqY6oh
n8yvuXH30kuCXe7eQ+rgLRK8ngTTwe7g0X3plbxIEhPm6At26T+cddwTz177qCgL
aSWHCdBzpPkPH0TC8JnMUjkHLNCRP4N5TA0PWqebD55ZNUp7+kcHkyAFipoF7TKZ
keADMobf3Q7CusAzS12cairIMoak5hQMHJC+ct4M+zXWwYujOicSDu2qcFa7t8q9
qlFY38+948EDKDjKi7E9spByZOyiXfeCWQdRULIOcmnJq2HkZP5HU0wDrldA4wsW
Br+D5ShNUwyD8kfysrw93pFadml1u39wLdM2nT2tkCGGCwvkV+Sd5ALOHEib3r/z
l2MnXzm6Qf9rLnNaYoECekxb2ZpCqKANe3J7FStHgPAtYnREC9uCnrvk8YCUQm3S
8+mvSyFW8lsKbbEn56ip+MFR5XbCRGveX69s+eFO013yAId27mr537BRJLgqD/8f
kfIivUr0VuaEqOuLWqYq
=sHst
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
