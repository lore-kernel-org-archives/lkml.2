Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1JJNqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:46:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab1JJNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:40 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=n-O0odzCyiAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=QmLstDrSBIOjJvd1QVsA:9 a=rM4hZF0_oNvuPrtRx5QA:7 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=U77ut86-OoJUjDdygSYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010134138.393789456@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:38:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Winchester <kjwinchester@gmail.com>, jbaron@redhat.com,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH 03/20] x86: jump_label: arch_jump_label_text_poke_early: add missing __init
References: <20111010133852.829771373@goodmis.org>
Content-Disposition: inline; filename=0003-x86-jump_label-arch_jump_label_text_poke_early-add-m.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Kevin Winchester <kjwinchester@gmail.com>

arch_jump_label_text_poke_early calls text_poke_early, which is
an __init function.  Thus arch_jump_label_text_poke_early should
be the same.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: jbaron@redhat.com
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/1313539478-30303-1-git-send-email-kjwinchest=
er@gmail.com

[ Use __init_or_module instead of __init ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..cacdd46 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -42,7 +42,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
=20
-void arch_jump_label_text_poke_early(jump_label_t addr)
+void __init_or_module arch_jump_label_text_poke_early(jump_label_t addr)
 {
 	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
 			JUMP_LABEL_NOP_SIZE);
--=20
1.7.6.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYSAAoJEIy3vGnGbaoACjMQAMVerGTz+CK94mm1rU2HDeiD
nVS0h9lL4kLcXAktqpidMY74f1sFnsmRbqWJPwT+NqCtSvBt81U7LQmnjaPWnqUd
98MW3TueSwmGJtUxZoEaZi8IjFrcEL3R/LFWZ1oiLy/k6Bpufa+peS4dPuJvdknR
/HvRw2fVYVweNeuwBSbkSnGYv2IS2zRO48krCb6nPL/vyynVJbMN+TIy49NfkxzY
7UY7Z6opyc4sJ0F8opjfNbFYG/5Fs+hfrvNjYavYA2IUeDKmfQ57s7IilIPdxPVJ
Ytpr8/zBWrTTbIduLIyiR128ND4QYCnXi44jHiUKw9o24busPUSRF8/ze02iYEC7
iOPWuQkUfLczisJBkboY2wFvJsQnWyHGpyEMvoTnjwIej/7LE4vJ1QfkavNu6aUz
QKB9dvjM3GJmi4VyTQ3VMKQc3/akUvLqwnJ65mlV9DYpUgNIEbQAIIx/OeYjegrm
UJT1sjnLk6yVqyBYOZuKvqwLbmanvf9pCeYEK5cchWD6pRagzDNrG90CdGoQP/7C
LX26QGJUjotWnWFuFWBUktViym6MJBmHyZcUbvb1sHPwZbphLhc0bzfjSdP9LBCD
1CxGPE2YQlAwHdUjNR3SfZVu3A/rV0yINAd8D2XPg+7g1YFkK+zNNB5t9BmggJS9
jnANSacY9TMMTesAxMQ3
=yXjg
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
