Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1L1EiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 23:38:17 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59245 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1L1EiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 23:38:01 -0500
Date: Wed, 28 Dec 2011 15:37:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: linux-next: manual merge of the workqueues tree with the tip tree
Message-Id: <20111228153750.8db1e68b1c8857ceb2e59f88@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_15_37_50_+1100_E=to9k3KhvAKPWs0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_15_37_50_+1100_E=to9k3KhvAKPWs0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
arch/x86/include/asm/percpu.h between commit cebef5beed3d ("x86: Fix and
improve percpu_cmpxchg{8,16}b_double()") from the tip tree and commit
933393f58fef ("percpu: Remove irqsafe_cpu_xxx variants") from the
workqueues tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/percpu.h
index 529bf07e,562ccb5..0000000
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@@ -462,9 -446,8 +443,8 @@@ do {								=09
  	__ret;								\
  })
 =20
 -#define __this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_c=
mpxchg8b_double(pcp1, o1, o2, n1, n2)
 -#define this_cpu_cmpxchg_double_4(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmp=
xchg8b_double(pcp1, o1, o2, n1, n2)
 +#define __this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
 +#define this_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
- #define irqsafe_cpu_cmpxchg_double_4	percpu_cmpxchg8b_double
  #endif /* CONFIG_X86_CMPXCHG64 */
 =20
  /*
@@@ -519,9 -503,8 +492,8 @@@
  	__ret;								\
  })
 =20
 -#define __this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_c=
mpxchg16b_double(pcp1, o1, o2, n1, n2)
 -#define this_cpu_cmpxchg_double_8(pcp1, pcp2, o1, o2, n1, n2)		percpu_cmp=
xchg16b_double(pcp1, o1, o2, n1, n2)
 +#define __this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 +#define this_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
- #define irqsafe_cpu_cmpxchg_double_8	percpu_cmpxchg16b_double
 =20
  #endif
 =20

--Signature=_Wed__28_Dec_2011_15_37_50_+1100_E=to9k3KhvAKPWs0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+p0eAAoJEECxmPOUX5FEUCEP/0MNi00Ra8sew8TAE+UvPPZn
NSBEJt/RRxCPbYjOZ0cLSYQcQmX8YAZlZhaxrZD7iNZ+00wPlQdleuBUxNqtjGcd
hOUTmdGirkOwnmKsq7UpUkIXt1mO1XfD1hYZas/fnRpDpnB7Nq/Cj1bXtc7BfVNE
8DDznZa8cFhZhOP+nGO+gcMv3X3/a5xWOqfpfY505/zbldfWWYBJPaJCnae9FwtE
kSlHjoV3J/6pvrMn2mBF34B2aQevnr3HlEPYgToyPn/qD5jLcrillOLO9+LvwQRg
4YWYZFb07AneaUQuKioHXF8lyRUBDrStAj0J0TrybH2I0FTVgbydBP+KbEfsCowk
J5eWKDWdqYmxaQ1zEgd9KP3Zr3JJC5iHrdRjchcyO3LcZRxYui6fFDFt8mqFWT/x
7hzwGsRfhOnad0dqg6ysRl8ojj3v5bDf6JBA+wt3sZBaL+6AgiG3j/MQgngI93zN
pXDQSWmm4neG0A7VLtLuZ8OKLg6KRhKADOH5OcGtf9q38ChARMYhIUJh75Zg61Ew
VcD1Le+6jTm0Ez8yKI+aRViIL2qVVDM0edUWVj2T6GMANqxGw7IZdiJMUvosjYbF
hApjymApa8mDGOx8RNDeUWT6DgNzKBK2JHA2VX8LJE9guoWxy+L4QQ7V9bHFGWp9
w9hgp+MlhtCorRG6SxEv
=nAvQ
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_15_37_50_+1100_E=to9k3KhvAKPWs0--
