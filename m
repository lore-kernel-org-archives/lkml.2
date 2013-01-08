Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3AHCYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:24:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58034 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3AHCYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:24:14 -0500
Date: Tue, 8 Jan 2013 13:23:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20130108132352.dbabdc281512cdaffbae5ae9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_13_23_52_+1100_MnRboU6=AE=XD.rZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_13_23_52_+1100_MnRboU6=AE=XD.rZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/comedi/comedi_fops.c: In function 'comedi_unlocked_ioctl':
drivers/staging/comedi/comedi_fops.c:1665:4: error: 'dev_file_info' undecla=
red (first use in this function)

Caused by commit 4da5fa9a439f ("staging: comedi: use comedi_dev_from_minor
()") interacting with commit 7d3135af399e ("staging: comedi: prevent
auto-unconfig of manually configured devices") from the staging.current
tree.

I just reverted the latter commit in the hope that the bug is fixed in
some other way in the staging tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_13_23_52_+1100_MnRboU6=AE=XD.rZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ64M4AAoJEECxmPOUX5FE8asP/14OTLZsWDmLEhH1Eq/e2ofu
kOA7xLRyg8Btu3AbfwQEJDjr9VGJnk1rQ+mdmX+zM+ngGjvcuLutnluWfuKSMH4a
MFwneXVMhpKD1ZotJktZd6V5GkVDcxFpLK1VG4nmR1vPfc/Us9tXaRGJLFN+qxG/
F87KyOtGKkHblG+8iv6PSQ6NVMsaUqQ8lkH9PglRi0+eEzePoEM6n2WCwg2lkK2L
OfpsaevXIx8Ax2ib6dw06M4MxXjtSboBk9OvIm/LwX/qOeMjrljiA/x1UooPO945
JmIgH+9eYuVii/ATSEuHPR7KqRjNAY0X8iueSZ45zJI9t3JyUMcBM7delwBcKGgY
mgCza7o5HEIoHusCEgeO4zm6lBytoyFHS0FGLpvX7pNO+vwUJYFi7aYTJLma481N
76DclRz8TlsBgK4hKTYoEetnsoChAP19x0XvMzwg1PE1n2qb45+xcBwL/ijikqAd
1jhQt/8lkaz2RS4Bc5XJqIkndQWOBWkcWhLW7W4bocp/tFsjtaCf6SIh10uq+UaU
lSkrgZJTpg4bguZmjivW+nyj7BJKZPcdznH5fwlHcyS+iPYyEk8YdX18uqfYUmz+
ap8RzrnyvveVeMvswQJLIfmxRiCdouh3uyvMBh0axkqFaVN+bB77xpcM4eFsQJu3
NWNABe/N82En3KOBpkBU
=SPX2
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_13_23_52_+1100_MnRboU6=AE=XD.rZ--
