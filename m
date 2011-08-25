Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1HYGR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:17:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50817 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab1HYGR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:17:56 -0400
Date: Thu, 25 Aug 2011 16:17:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: linux-next: build failure after merge of the final tree (akpm and
 moduleh trees related)
Message-Id: <20110825161750.45803be66cba17a6bd3906bc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Aug_2011_16_17_50_+1000_489uwZDFlTGJ1lH/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Aug_2011_16_17_50_+1000_489uwZDFlTGJ1lH/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

kernel/printk.c:536:35: error: expected ')' before string constant
kernel/printk.c:1116:35: error: expected ')' before string constant

Caused by commits 8a04dedc045d ("We are enabling some power features on
medfield.  To test suspend-2-RAM") and d09d67ec904c (same - the following
commit) from the akpm tree interacting with commit a25ffe9fafa1 ("kernel:
Map most files to use export.h instead of module.h") from the moduleh
tree.  This file now needs module.h, not just export.h since
MODULE_PARM_DESC if defined there.

I have applied a merge fixup patch to change export.h back to module.h.

P.S. Andrew, these commits could do with better subject lines :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Aug_2011_16_17_50_+1000_489uwZDFlTGJ1lH/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVekOAAoJEDMEi1NhKgbsTZwH/iKnBjRMO8Nf1R4VmxCwnsIe
YjCI8ui48KNw/1eS4gEKGZLZda/ve+zKJ2WDSy0mTqOCSEKNl1tuVvLdLva0/ktW
SdQVMegfBJnvHwHiP6yKGfIzzFBo/c6wHH4vuC0c6qF0kDTYJABAHIFrOImESv7B
nSrtHN6TO1NGuD4j9Nx276Eirgmv9Lq1Vk5FU5CWzH7EyRwuSIg6xfdXFGcZznpL
tAIS5wsnx+hB6PInx4pHQZoy4d9wldreaVh0IpIOFkYaa9iq9whYyKS22nEwDX0D
8nl0Blx3j590m4qZrKCLrEyZc3xblT276uxEH0cjbDeSDACFYGHlY0TcXc2XaJY=
=bnF1
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Aug_2011_16_17_50_+1000_489uwZDFlTGJ1lH/--
