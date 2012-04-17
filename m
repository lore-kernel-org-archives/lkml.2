Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2DQCJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:09:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56293 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2DQCJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:09:00 -0400
Date: Tue, 17 Apr 2012 12:08:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: Will Drewry <wad@chromium.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: [PATCH] seccomp: use a static inline for a function stub
Message-Id: <20120417120848.e7f3eabfbf79dc609318ea1e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_12_08_48_+1000_LCPVam8Xvpn0Whj7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_12_08_48_+1000_LCPVam8Xvpn0Whj7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Fixes this error message when CONFIG_SECCOMP is not set:

arch/powerpc/kernel/ptrace.c: In function 'do_syscall_trace_enter':
arch/powerpc/kernel/ptrace.c:1713:2: error: statement with no effect [-Werr=
or=3Dunused-value]

Signed-off-by: Stephen Rothwell <sfr@ozlabs.au.ibm.com>
---
 include/linux/seccomp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 5818e86..60f2b35 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -90,7 +90,7 @@ static inline int seccomp_mode(struct seccomp *s)
 struct seccomp { };
 struct seccomp_filter { };
=20
-#define secure_computing(x) 0
+static inline int secure_computing(int this_syscall) { return 0; }
=20
 static inline long prctl_get_seccomp(void)
 {
--=20
1.7.8.3



--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Apr_2012_12_08_48_+1000_LCPVam8Xvpn0Whj7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjNCwAAoJEECxmPOUX5FEaEIQAIny0tCow9vM3W3NeHsw27Ar
7+jmsLCVLBHKS+vdevN472pIBwl+0fOnPZutCfpEtX8WSjmnNmkWKta7WY3UpgIz
fXhmJX7ZohvCzdzEw4y+02MALRtk+5rxEtRDaMQzCSHX66ZC+Mpf+FMwoavOgaiA
iUpYxJ29tq9tg8QH77U33uMKJ9CE10dZ58Z3IFMYlWIi2cVmakrCdGf8Yak9JqAz
Of95urF/ZeT5KKiDgnkHcUpIH3/8HZVgN1iaEepgXprMPFEKcU7WX9cSEeTMWXTA
JQfevKrHgOVAqOymP1/XLmtcWMu6XXiiJw1VDpI9vhIvyA/1YWsh9C2L9crKx9XF
zFao3z2weDIQTo6F0Efjt5i0so2mr5dF3B0j/9U4tbM27MAmffcNLEwL1H6lY8+u
2a+gt62+5Muoy/ifDMYCKiRewe+Wa8eQm2OEBwhqSUljj3IESfBqFHVIw2SsFxGV
bVnGwzbVn/CMk6SCBIuqrx4z4Gu7rwOoi8buMnIBw0OdgeRCSDbrSXRYJShrh3I+
xS98+rZq4EGgT9OqziN+lPmBoVoBlCEdx0hZ6FLjQxBuJietyxfspxAkXqDVwB4D
hcR0zW4m+ITyax+J5Pl7SRoIg5yxRIxYsdagnrpwMS80iVP0BuzjkEk67P3+jBdW
ipxjTG9r3BRg/AxNqZ18
=ZVmM
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_12_08_48_+1000_LCPVam8Xvpn0Whj7--
