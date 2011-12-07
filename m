Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1LGLGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:06:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:65359 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab1LGLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:06:32 -0500
Date: Wed, 7 Dec 2011 14:06:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        robert.richter@amd.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: [patch] x86, NMI: add to_cpumask() to silence compile warning
Message-ID: <20111207110612.GA3437@mwanda>
References: <1318533267-18880-3-git-send-email-dzickus@redhat.com>
 <tip-99e8b9ca90d688c3ac7d3a141b701c9694a93925@git.kernel.org>
 <20111206090612.GA18662@elte.hu>
 <20111206180859.GR1669@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20111206180859.GR1669@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EDF489C.00B2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Gcc complains if we don't cast this to a struct cpumask pointer.
arch/x86/kernel/nmi_selftest.c:93:2:
	warning: passing argument 1 of =E2=80=98cpumask_empty=E2=80=99 from
	incompatible pointer type [enabled by default]

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index 1e42a23..0d01a8e 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -90,7 +90,7 @@ static void remote_ipi(void)
 {
 	cpumask_copy(to_cpumask(nmi_ipi_mask), cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
-	if (!cpumask_empty(nmi_ipi_mask))
+	if (!cpumask_empty(to_cpumask(nmi_ipi_mask)))
 		test_nmi_ipi(to_cpumask(nmi_ipi_mask));
 }
=20

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO30ikAAoJEOnZkXI/YHqRSm4P/jFs4DmwCqCZzJAIQIhEXXGK
odheM/AfW5grQtEq1e2XAH8a+uK5CuJqUBqEd9LKS/J71jdWXTUDBU1dZqRmthyW
ITurHFXoaBGhdlTaZ5xVhLuhN23wXhYHsaSIIhQV6avTL96Ixx7on3AsdRATfTAM
vfoZNSw+wZatKEKVKNqmKmj6c0wrXUC4Ky4aY1EmWeko2vg9Daa1mAzHtIHdyU+6
JwbgGq+pjUc2LlVgZbrCjIgDYFLuceMK54v6FQckQ2M/XarNAx2khKIpyMgKbf2n
fiKW69uNwehL5PG+dmjce1YdWsBE+EdFHDTy4ICfPHU8frPnlOHuQy+radkIRwzk
sXC45j7aFq7j6Kz3iJnfMuUZihCSnc1pSYDUTONIemZvPTKnBzgQFqr37fxObGma
htdpjOicgYdptx7u1b/pyAQ69RnuXIL3SXBvQQAI2NWFXj685GqE/JcvRhHUhF9z
jMXaELnEu6Egj2oDi3aSOJWJq8fRmvNfBGzpUF8JAeJglMXGD6xzlLhQKy+J/yj4
/BRrqvv11Cy/nRV4kagBXvxa7mrc82txEbAveMXiBhtUdLVW0sVoy2NfV6qq4fb1
92wkxMlLgh7VvvMJvPylhRPJ8mrNJxDBhaw9bqz5uc25jjKu/qdfz/dGDTgHdnwQ
nCcOQTUs4pekA9QXt1h2
=69JD
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
