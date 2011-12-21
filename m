Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab1LUGdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:33:12 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39936 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1LUGdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:33:09 -0500
Date: Wed, 21 Dec 2011 17:33:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: linux-next: build failure after merge of the final tree (mfd tree
 related)
Message-Id: <20111221173301.1111dc371e11d5c7025f03ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Dec_2011_17_33_01_+1100_8aMus3PSCPlttZSj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Dec_2011_17_33_01_+1100_8aMus3PSCPlttZSj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/twl-core.c: In function 'twl_probe':
drivers/mfd/twl-core.c:1212:22: error: 'TWL6030_IRQ_BASE' undeclared (first=
 use in this function)
drivers/mfd/twl-core.c:1212:22: note: each undeclared identifier is reporte=
d only once for each function it appears in
drivers/mfd/twl-core.c:1213:39: error: 'TWL6030_BASE_NR_IRQS' undeclared (f=
irst use in this function)
drivers/mfd/twl-core.c:1215:22: error: 'TWL4030_IRQ_BASE' undeclared (first=
 use in this function)
drivers/mfd/twl-core.c:1216:39: error: 'TWL4030_BASE_NR_IRQS' undeclared (f=
irst use in this function)
drivers/mfd/twl-core.c:1218:3: error: implicit declaration of function 'irq=
_domain_add_simple' [-Werror=3Dimplicit-function-declaration]

Caused by commit 4eea8b1d717d ("mfd: Add initial DT support for
twl4030/twl6030").  A missing include?  Or a CONFIG problem?

This build does not have CONFIG_IRQ_DOMAIN set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Dec_2011_17_33_01_+1100_8aMus3PSCPlttZSj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8X2dAAoJEECxmPOUX5FE7acQAKfO1JnHBxP1N23UHIovjsfY
DpcXbSEfKGcC1O//3fg7KJNSyF0/miKsAhMvSJFuBTwFbE0AlpZkj7qlSMuDtwvq
zXw8TrPvHegzwoKL5kjc6+q6BoyGsYKWa8ecjqmkmT8C1my+HxjhweCnPwutMI7W
mOst3FKfJOgWCXKKAJr5XlfMDVnb3cl/m/vO9ycYlOjRe+ozN+j2SaiIeruFeySH
HSDb3ik6gCn/4GSzWWj8NjV8mXcRnqvZXmVDYueS1EVDLUm1ZF+OHPi0EEknrVv4
uP22MT0q5sw76IOCl6UAgd1AoTEnEKkOZ6OtuVlKx6XayWyvvMuOhFt7Kme8ZaCL
G9l+/gedGBcMM6zTSGqHB0UCRZjSTszgi7qn3MMtK0D9Z+NtQ38UPGpGhO3Z/FLG
eaZjlykm7CeshX2XHzu306mNVYvVG7Pub8F5dxxNbas6IYK7aphFy5qnKbI6IwwV
PWL8Z7aBSUE+4nU4SuH8vRK9VRC9TqsAliEpwjQmw+GpB3Gj4Aq5rs7O7Jy61JQw
iQt9clZj5NdEkbKsLGCwRmdpaMtA1dJpehJSyxM28HUjefEi+0fixugCM6suLK0R
YtxMDG9EDkfYFElaO2MGwOGA6GwO1zCD8AnQchdiOSZKxbLBdqEYHaEc/Ty1zTXA
qGhTwMITY4GYhPwideBe
=pr19
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Dec_2011_17_33_01_+1100_8aMus3PSCPlttZSj--
