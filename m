Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab1JEHgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:36:49 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43247 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab1JEHgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:36:48 -0400
Date: Wed, 5 Oct 2011 18:36:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todd Poynor <toddpoynor@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the moduleh tree with the mfd tree
Message-Id: <20111005183641.922f5e5da976b972f25a6d90@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Oct_2011_18_36_41_+1100_=euAgXMDvF5COyfk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_18_36_41_+1100_=euAgXMDvF5COyfk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/mfd/twl6030-irq.c between commit 2b8af0825999 ("mfd: Fix twl6030
lockdep recursion warning on setting wake IRQs") from the mfd tree and
commit c86747746435 ("mfd: Add export.h for EXPORT_SYMBOL/THIS_MODULE as
required") from the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/twl6030-irq.c
index deec3ec,b57383b..0000000
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@@ -37,7 -37,7 +37,8 @@@
  #include <linux/kthread.h>
  #include <linux/i2c/twl.h>
  #include <linux/platform_device.h>
 +#include <linux/suspend.h>
+ #include <linux/export.h>
 =20
  #include "twl-core.h"
 =20

--Signature=_Wed__5_Oct_2011_18_36_41_+1100_=euAgXMDvF5COyfk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjAkJAAoJEECxmPOUX5FEt1MQAI8EZh+LTBW7laG7Q+ZRKcnG
JSgXRe9BSM+YdeebU+EgKj5JRGZVwPBEHP5p+GxO4+ZGrx5XHDeJFYxnIzKQwwUp
g20TXRizNfez9lfnyY5Xb+7PjmtNsJptTwNblUxaG0m6WGZAU0qB/Jy2vFcWvtiM
VkCnplmUkeJLmF2JFW5KYisu36YWkK5Qkq2ewgfks9VWCA2mTKZGasKhtJQ5n7hg
KCD56H9VHFj10jSBpPJm47dRrHdKyjPBjm+h4OlHlNHjEz9/aetWZZP11BYByGBx
zbzf3wZhVX1IFvakM/ybE4R/CxjPPrDIfXQC46ZcVl5R8M9+OMoKBcNQjtCI5MiT
JVieW7oHCUS8b5fG/lYs2frbjgCpEkUbZePX1GXb+WKhT8/md8CxAy+G9doIaQYy
Ibfe6Q8mS70+rWB39wl4PFtY/XUupfI/pKgnQPQskEBxy1SgCmM9Kx4gZp7g1bqh
S3NgBcM8Yhcu+Bvf7hfeUSom756uNs4/oA17cMqcD1Mm/Gu5j3eG1KsrpzFf81NW
5glAbwUXml5RFpJcYUq1dl2t6DMlTzSJ1KNDIgNkbxUdGnIqikK10K07XZueW97Q
HqHB8O3MuDDa+kbkS1x9CiuRarf66CCBdjb4vQMffa4TfBr3FYLJMoQTycGj0O45
8y6igMY0LPlfssQpsZCh
=WMcB
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_18_36_41_+1100_=euAgXMDvF5COyfk--
