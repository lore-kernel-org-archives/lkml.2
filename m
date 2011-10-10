Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1JJNog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:44:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60188 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab1JJNlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:42 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=COTO7UtEhdgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=SpvumKaVcxQ2gLH4gdoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=kqRj2VkGkC-2JDsqu8gA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134137.475256277@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:38:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 01/20] tracing: Clean up tb_fmt to not give faulty compile warning
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Clean-up-tb_fmt-to-not-give-faulty-compile-w.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

gcc incorrectly states that the variable "fmt" is uninitialized when
CC_OPITMIZE_FOR_SIZE is set.

Instead of just blindly setting fmt to NULL, the code is cleaned up
a little to be a bit easier for humans to follow, as well as gcc
to know the variables are initialized.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_printk.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 1f06468..6fd4ffd 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -59,18 +59,19 @@ void hold_module_trace_bprintk_format(const char **star=
t, const char **end)
 			continue;
 		}
=20
+		fmt =3D NULL;
 		tb_fmt =3D kmalloc(sizeof(*tb_fmt), GFP_KERNEL);
-		if (tb_fmt)
+		if (tb_fmt) {
 			fmt =3D kmalloc(strlen(*iter) + 1, GFP_KERNEL);
-		if (tb_fmt && fmt) {
-			list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
-			strcpy(fmt, *iter);
-			tb_fmt->fmt =3D fmt;
-			*iter =3D tb_fmt->fmt;
-		} else {
-			kfree(tb_fmt);
-			*iter =3D NULL;
+			if (fmt) {
+				list_add_tail(&tb_fmt->list, &trace_bprintk_fmt_list);
+				strcpy(fmt, *iter);
+				tb_fmt->fmt =3D fmt;
+			} else
+				kfree(tb_fmt);
 		}
+		*iter =3D fmt;
+
 	}
 	mutex_unlock(&btrace_mutex);
 }
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYRAAoJEIy3vGnGbaoAhkgQAIgfjWR7T6p/DaML+kV2Xwpv
6tk2aatgbRlO4oT3Hh07XJSInH1uWBlIls1Ci8QRR+H1teZDoPgB27f4VnEdjXbH
jPRotGJXKq6AUDjupxJMngMW65Ev96qIEhH0/8j8bc+CpOHKFMg6FGLo5JcTsuuH
oR0150NB/AEFeX1ZKeJsLLUX4uybrBM4Oms62ePDNYfVLj9i5P6jBEAR2DgKAcDU
9BLmrj1Zcj5H62ypWqATXU+yj6ONO5b0p1Oe6sPrA+3J4MBcxzFsaAEChVokboqe
o8VJD+6nMQBnzxm3eXL/v0fsF2TV5rQvOCNGvv2d+tT6E98T6Yxro/HMLjXVOHIo
5RZY0kH7DyRnZ2H528ckfv1zuL6R+QKIGASU/TKRVe7GxJQ3XScjR9awOsp+N6Wz
AWPxSr4vgko+s/cZmsIiLVWM9OCj7rfHEFTVhqp3vDOAzV0tz6SEgG7RRcgfdzXy
7FUJt053m308n+ACGK6pg3NUqIcG/bLnnGT/68XRs2mLsGYfRONaXgh9QTux0bsx
aVRiGYDMulXPaB6ZNd83kWouX1zWzppz6LyqPUdIxSbt/AQBE8Iuvr4+aFF8qkss
7OWOpUHPhHPBHZWx3251PACU/6KTbqh0rlyU2qcEihazpNbrChUBAe/CsYxLug+a
ROM7eg96WY5y7Za2ypMC
=ujmX
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
