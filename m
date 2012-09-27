Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2I0HnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:43:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40599 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2I0HnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:43:24 -0400
Date: Thu, 27 Sep 2012 17:43:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120927174316.c6c4485c392aef3c552183f7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_17_43_16_+1000_5t0J8aLogWHj9VJD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_17_43_16_+1000_5t0J8aLogWHj9VJD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from arch/x86/include/asm/syscall.h:16:0,
                 from arch/x86/kernel/signal.c:40:
include/linux/audit.h: In function 'audit_get_loginuid':
include/linux/audit.h:536:1: error: expected ';' before '}' token

Caused by commit 57fb5bbce51d ("audit.h: replace defines with C stubs").

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 27 Sep 2012 17:35:06 +1000
Subject: [PATCH] audit.h: replace defines with C stubs fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/audit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index f1cfe02..30e9bea 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -532,7 +532,7 @@ extern int audit_set_loginuid(kuid_t loginuid);
=20
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
-	return tsk->loginuid
+	return tsk->loginuid;
 }
=20
 static inline int audit_get_sessionid(struct task_struct *tsk)
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Sep_2012_17_43_16_+1000_5t0J8aLogWHj9VJD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQZAOUAAoJEECxmPOUX5FEivkP/3x/c7qDEadxxGiOgV5wWr0p
dhqk5JZaKX4ub34o3wBh1+yGPvOqMNnWxdXjugEGyT3l6N0rYYf3viKDM05jWWdE
KFsKhkhYqvBNRpCUh6zWGAsZkll9y9l+PRGZjd08RunqE0HH/fp0So+9WACScNfw
wD+MRUdJ5IM6wjxu94jfhNE/h+gZsbkHBk0rXmduJWwO+TSg56S2asEy6YWNQuQr
a70dzYSgVSCNUQKCr1urnQt9xi6VCIgr9ddduxDQo1ac2Ea473ZGsvi1+wsRBsXZ
sxv6LMGTsZIPtbzIgpLpX1mOJJRsTlciTALRbDrnJzfnfNjrok4J+5CSpL9fQ4f6
6xLr5B84uD5TxOpUshHOpZx/aGsrNXXhY9IYbcFXvPIvyF7TsoM5/kMz72R6muKt
4QdNttYsOqKw/dfGvKs756WP267HC4kreTromUi5CsFSkcCpvdHMySzhwi19GzkV
AVNbVjHfoqwFlAGTbpVQMeRAEKzX9ZgW2UucRrs+ZkSmLtW6GpJyWFlnbg73reBC
pW8X0/85WXivxGtr8Imh1dnzhtpRRa61sFNBdLRtCBUpBvZzL3lR9BHywSA3QUF1
sC7V/T8B4cTm3aasGCg9YVXgBLpo+BTi6w/ZxKER2e7kyUZUhx5RxVrkCBs/8gm0
C2Oz9+m/JnCLu8Bqx1OB
=066J
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_17_43_16_+1000_5t0J8aLogWHj9VJD--
