Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab2D0F7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:59:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51111 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab2D0F73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:59:29 -0400
Date: Fri, 27 Apr 2012 15:54:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (kvm-ppc
 tree related)
Message-Id: <20120427155453.dc0b61315798677ceb3b59a2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Apr_2012_15_54_53_+1000_xExPF3=b5GwVWaPO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Apr_2012_15_54_53_+1000_xExPF3=b5GwVWaPO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

arch/powerpc/kernel/ppc_ksyms.c:194:1: error: redefinition of '__kstrtab_do=
_IRQ'
arch/powerpc/kernel/ppc_ksyms.c:62:1: note: previous definition of '__kstrt=
ab_do_IRQ' was here

Caused by commit f4601ff93980 ("PPC: Export some interrupt handlers").

I applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Apr 2012 15:52:54 +1000
Subject: [PATCH] KVM/PPC: do not export things twice

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/ppc_ksyms.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksym=
s.c
index f6484f2..cace146 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -191,6 +191,8 @@ EXPORT_SYMBOL(__arch_hweight32);
 EXPORT_SYMBOL(__arch_hweight64);
 #endif
=20
-EXPORT_SYMBOL_GPL(do_IRQ);
-EXPORT_SYMBOL_GPL(timer_interrupt);
+#ifndef CONFIG_PPC32
+EXPORT_SYMBOL(do_IRQ);
+EXPORT_SYMBOL(timer_interrupt);
+#endif
 EXPORT_SYMBOL_GPL(performance_monitor_exception);
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Apr_2012_15_54_53_+1000_xExPF3=b5GwVWaPO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmjStAAoJEECxmPOUX5FEBusP/1Qjt1wWI/APjNtxf62+2puo
5eMMSLPBJVagnDsNYtQq9uuY7DEzpY7rBn1qq0ZLzQwIInFM5uWFaN0Vc0r6Aaim
6rpcvKTGLO+MbjQU6uPmPGgWIHYmekFRxGmQ8HONw5RPa7LNWx2RjC7bbB3CWOhm
uQVkK9vGtWe4yzpb/j7OTXKV2fYUXZrwGKxjxsAkVebKZPhirEc+U2vwNUv6MUC9
YJgd58Ac50k6nNEgyyEu3IDKTSs3mqrDsCbRfX3QY/bIPOjtukeYMcxAghd0/PeT
jCh0MsmmA/pd3voNh54mY/PlAfWCeYSaamLluD24pOgpknAx6VlMiOpe0asvGV+O
5Oq/o562RSVRt4fQO0aNUcXgFJSb4lqshrvROjWgdV9G6Wc9soqme1q9Ax7ufxNh
Ha6aUziUH601CMu/TNpuU5/85aplZJbw2OpZ9xEVTirYnhm2rQ/mqnKTvlicZV0U
gapXlJ46QOkpFRjOPfV2yAjPywSLzGsxLZZQVVFMQGSr8qFWgNtKyCoVH32IVSIL
H9xYYGl70da0HA3cvFG47Tw4btJz3UHKUJb9MQj8S7YXaG2BCjAQMjuqErgtvb87
1+0MSvRH6R/EZQFDCvWc2B+jYGXQfa3PllXiPu95RDFGId2KHVzdWONgh5lAZVua
S0XhWEYMMr/K5H3grXYj
=ub9I
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Apr_2012_15_54_53_+1000_xExPF3=b5GwVWaPO--
