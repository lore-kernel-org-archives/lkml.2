Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2EAE7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 00:59:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47114 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2EAE7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 00:59:34 -0400
Date: Tue, 1 May 2012 14:59:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Roland Dreier <roland@purestorage.com>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120501145922.14f2235dff099d20acf3b54a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_May_2012_14_59_22_+1000_9AzlLmnTx9bT2NE+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_May_2012_14_59_22_+1000_9AzlLmnTx9bT2NE+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/kernel.h:23:0,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/stat.h:60,
                 from include/linux/module.h:10,
                 from drivers/infiniband/ulp/srp/ib_srp.c:35:
include/linux/dynamic_debug.h: In function 'ddebug_dyndbg_module_param_cb':
include/linux/dynamic_debug.h:112:3: error: expected ')' before 'PFX'

Caused by commit b48420c1d301 ("dynamic_debug: make dynamic-debug work
for module initialization") interacting with commit e0bda7d8c33e
("IB/srp: Use pr_fmt() and pr_err()/pr_warn()") from Linus' tree (added
before v3.4-rc1).

I have used the driver-core tree from next-20120430 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__1_May_2012_14_59_22_+1000_9AzlLmnTx9bT2NE+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPn22qAAoJEECxmPOUX5FEPDIP/jIstQ48WABFWZSSbSqI36Pe
g5MKFMM9E5KLMnP7OSqbQKL7a4DwUw+69q+/n+wczoMU3XtFsW1qNTQrofUZESUF
NGKrEmR5OmJNEwuirUm/3Lv+ZmOyeNRpLPOLi4ian+oejTEZiwirpb603rBKS6Si
HjwPy86Z8zTc8gQrJ8XvIzArg78E4H8+QItiSgh8YzRNjm9q6OZ+Sog5lzDgET3S
kviojGcY1puwGGH9HwOy6uCZAp9I9NdSteIdNHrBFy8lkBxpBMghksSNLh/FFQ08
l7pWOtQM1Ma0bm/cTDNGmgKmrbiKhDhYaPgm2E1dP+Rcdgg7fkviAzOU0Av0HYr0
bwbz/EI55qzCkJzzpC57pW7hU9Pf113PqZX5tWmyR/jJ0yOGdnLUO1QeestR6VZr
YSOAbLEfopq7HlRT3iC1fMVBs2GYLvxXmP67ts1VVonXI1BADe67SqKEbG6gjz1t
CKsXbxEJ7ZCITgyaJ5uV9u9uAoosFnLjjJkXF+DHN52fzocRpuS5MHkMkWUaIp9C
0Y0SDbovdh0ewSAF8QT1/GDhqlMY1xdtM/pmHnVECvFqaTe3BboLxAIU1RYRRNSi
umGcvlUN8lu7BPzsOtWChI7NvnnPPcJkIF1oBcvEqeCOwMRWjAXn/lN812fYuQac
KiLfgsZJ27+BG7wvlEio
=LiXg
-----END PGP SIGNATURE-----

--Signature=_Tue__1_May_2012_14_59_22_+1000_9AzlLmnTx9bT2NE+--
