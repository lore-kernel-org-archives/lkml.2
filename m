Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab2EaCEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:04:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab2EaCEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:04:42 -0400
X-Authority-Analysis: v=2.0 cv=PqgRnnw3 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=a_Bdc9Mq0iMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=Okzlp3J_d807DFtoaSsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=FN71H4xp8gx7nVSPQZoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120531020441.165841749@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 May 2012 21:28:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/5] x86: Reset the debug_stack update counter
References: <20120531012829.160060586@goodmis.org>
Content-Disposition: inline; filename=0003-x86-Reset-the-debug_stack-update-counter.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When an NMI goes off and it sees that it preempted the debug stack,
to keep the debug stack safe, it changes the IDT to point to one that
does not modify the stack on breakpoint (to allow breakpoints in NMIs).

But the variable that gets set to know to undo it on exit never gets
cleared on exit. Thus every NMI will reset it on exit the first time
it is done even if it does not need to be reset.

Cc: <stable@vger.kernel.org> # v3.3
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/nmi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 9087527..c1fffc5 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -450,8 +450,10 @@ static inline void nmi_nesting_preprocess(struct pt_re=
gs *regs)
=20
 static inline void nmi_nesting_postprocess(void)
 {
-	if (unlikely(__get_cpu_var(update_debug_stack)))
+	if (unlikely(__get_cpu_var(update_debug_stack))) {
 		debug_stack_reset();
+		__get_cpu_var(update_debug_stack) =3D 0;
+	}
 }
 #endif
=20
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPxtG5AAoJEIy3vGnGbaoAZvQP/0VHCmVW3fFV7r3w1HeJM4LM
PfZ9oNxnn5JiLykK7tkFpzfj25Bavdcak+8iImBxFsueyWAm5TTuLPtrLq0Wpq29
ZQcooPbyDDNlaNV0pgv5Nq/1xlHTJ1BBZhnJdtXi385C9JrGoYhKd+i6ykDjhbR6
00Iryzkw9Y/GfOS2cV0EvK40Mp8RWI9sKW8xeEMlIVhm98IPNi4IlXw2TNmhiKtK
UrAQGRmBLK7DZEWJgYjELpD66AWHy9kwPcSsoVRau1DVtbKqShz0QKua6xsDa/De
iuJcke9y0plzg2hh4YyX3/Sxo1jC1AIrF3aROe3/sD7/5TCxAugk/JBGguaPI1Vt
wOfvPX1pnhfqvwDmbgEREsMKqwOHBuOkFH77jYBJ+wZ0gzNDBBejUcNN9HNfWHDY
RpPopQegk0nqoHQoEhmIPg52BuC6VPAJ5TYqgNDoA8vKCFxyL9CoLqFoTdVWh/Ut
fd49sVgfq7scfj1jK9UKHwHDv5HAZwa47Vkkn++OJ20KY7o2ah1nIDhkP1W5C6I1
WgUmdWMyBA5QBr80DdlT5rantTMI4fz8ilCHrll2+K366tjwrqiI5w/n0kGUBBa7
gUn79QGtq90aff5cPMBNLZNJGDR4YVYks578hvNt511tL+5S5HQXNrdjcmU1qvh8
ZqLD9sD4oDVreoBQvYjb
=1hME
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
