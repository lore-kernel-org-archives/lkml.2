Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab2BTXmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:42:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab2BTXmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:42:54 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=u2WiT7buBwEA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=zFkZ_6QL2c1Zs3ro5JoA:9 a=X0IYoXPt7F-W4kZaac4A:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=XwzYH2d7JHcz6I1v-QYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329781367.25686.45.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.3] x86: Specify a size for the cmp in the NMI
 handler
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 20 Feb 2012 18:42:47 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rBlTfu8DEUbZDlyWHQbs"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rBlTfu8DEUbZDlyWHQbs
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/x86/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/urgent

Head SHA1: 869d49dc575a9cf7041e535ea4911a511bbee764


Steven Rostedt (1):
      x86: Specify a size for the cmp in the NMI handler

----
 arch/x86/kernel/entry_64.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit 869d49dc575a9cf7041e535ea4911a511bbee764
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Feb 20 15:29:34 2012 -0500

    x86: Specify a size for the cmp in the NMI handler
   =20
    Linus noticed that the cmp used to check if the code segment is
    __KERNEL_CS or not did not specify a size. Perhaps it does not matter
    as H. Peter Anvin noted that user space can not set the bottom two
    bits of the %cs register. But it's best not to let the assembly choose
    and change things between different versions of gas, but instead just
    pick the size.
   =20
    The full 8 bytes is used to compare the saved code segment against
    __KERNEL_CS. Perhaps this might mess up Xen, but we can fix that when
    the time comes.
   =20
    Also I noticed that there was another non-specified cmp that checks
    the special stack variable if it is 1 or 0. This too probably doesn't
    matter what cmp is used, but this patch uses cmpl just to make it non
    ambiguous.
   =20
    Link: http://lkml.kernel.org/r/CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9Z=
AoZKDVgNfGA@mail.gmail.com
   =20
    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index debd851..666f2cb 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1535,14 +1535,14 @@ ENTRY(nmi)
 	 * If %cs was not the kernel segment, then the NMI triggered in user
 	 * space, which means it is definitely not nested.
 	 */
-	cmp $__KERNEL_CS, 16(%rsp)
+	cmpq $__KERNEL_CS, 16(%rsp)
 	jne first_nmi
=20
 	/*
 	 * Check the special variable on the stack to see if NMIs are
 	 * executing.
 	 */
-	cmp $1, -8(%rsp)
+	cmpl $1, -8(%rsp)
 	je nested_nmi
=20
 	/*


--=-rBlTfu8DEUbZDlyWHQbs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPQtp3AAoJEIy3vGnGbaoAILwP/0AF5sayHR20w5YESOuOkFcS
ifOiO4V3a8wrNVs2HeMINVyC05SpTFKbYZx2j47n5q2iQ78TS9CIdkP/9AhHlZKH
+Cv8OiCnmpcSkjx9U5IrcUl0LzhuYdHixjZXMxT73G/e0/ewO7/rU49y0oaYduQr
wGI5owqbUGbyVxGYNCVgwQwP6Y9ztiuCHYhIosVYtLieTX4H13j0TDE+PVPyRBR4
9wBa/Cx3ZooWn7vmKkqlWJhanjYBhnOMj0dsJ9ymhVqWI02VhcHczm+sgpV3WkcC
d2RKJd/vcpAwvD2N3dkM0Tfy/UYFCK51K8itpLjPYk5tIpQIqjqJxnD3YRs6aVxl
1GXw5HtQb/xKbWcNKfjf8gYWsJyAX+EoJ+4w1zbloVhUidy0W72DmwKes7YvGxU3
Blc/JiGLMiQDQ3bvwA7vJCs4SBfcRHCqhfz8HrkB7yvgSk0w6OCznBIQ3k7APKtt
CXpm18FVkrFmN2Kp4jriKp/GW1c4NlirQVkekg3IZEC+2G1NVmUMuBIoLh+F+ggL
IfQczWQKMDhRQNfgL9SDLBosgter0/F5dm0afs/NouhmrV+GKAUtu9hXUjZBIVIv
3FN9Tz+V4voVjA2ZctnQM9ShVM/6ex7PChjayIwN+V7KIdt7sFDSDq74q9ToB5UZ
NboD0mzsrWeOb1CAl2/b
=YzMD
-----END PGP SIGNATURE-----

--=-rBlTfu8DEUbZDlyWHQbs--

