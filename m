Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229Ab2JXC2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:28:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54050 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab2JXC2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:28:37 -0400
Date: Wed, 24 Oct 2012 13:28:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20121024132827.b22e6f33031f785ff0189791@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Oct_2012_13_28_27_+1100_LTLElCZDY.J7yOhU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Oct_2012_13_28_27_+1100_LTLElCZDY.J7yOhU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/staging/dgrp/dgrp_net_ops.c: In function 'dgrp_input':
drivers/staging/dgrp/dgrp_net_ops.c:216:27: error: 'struct tty_struct' has =
no member named 'real_raw'
drivers/staging/dgrp/dgrp_net_ops.c:229:8: error: 'struct tty_struct' has n=
o member named 'read_cnt'
drivers/staging/dgrp/dgrp_net_ops.c:229:8: error: 'struct tty_struct' has n=
o member named 'read_cnt'
drivers/staging/dgrp/dgrp_net_ops.c:261:30: error: 'struct tty_struct' has =
no member named 'real_raw'
drivers/staging/dgrp/dgrp_net_ops.c:276:28: error: 'struct tty_struct' has =
no member named 'real_raw'

Caused by commits 53c5ee2cfb4d ("TTY: move ldisc data from tty_struct:
simple members") and ba2e68ac6157 ("TTY: move ldisc data from tty_struct:
read_* and echo_* and canon_* stuff") interacting with commit
0b52b7497271 ("staging: Add dgrp driver for Digi Realport devices") now
in Linus' tree.

I disabled building of the dgrp driver for now using this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 24 Oct 2012 13:25:29 +1100
Subject: [PATCH] staging: disable dgrp driver since it is broken by tty
 changes

drivers/staging/dgrp/dgrp_net_ops.c: In function 'dgrp_input':
drivers/staging/dgrp/dgrp_net_ops.c:216:27: error: 'struct tty_struct' has =
no member named 'real_raw'
drivers/staging/dgrp/dgrp_net_ops.c:229:8: error: 'struct tty_struct' has n=
o member named 'read_cnt'
drivers/staging/dgrp/dgrp_net_ops.c:229:8: error: 'struct tty_struct' has n=
o member named 'read_cnt'
drivers/staging/dgrp/dgrp_net_ops.c:261:30: error: 'struct tty_struct' has =
no member named 'real_raw'
drivers/staging/dgrp/dgrp_net_ops.c:276:28: error: 'struct tty_struct' has =
no member named 'real_raw'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/dgrp/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dgrp/Kconfig b/drivers/staging/dgrp/Kconfig
index 39f4bb6..7d378c2 100644
--- a/drivers/staging/dgrp/Kconfig
+++ b/drivers/staging/dgrp/Kconfig
@@ -2,6 +2,7 @@ config DGRP
        tristate "Digi Realport driver"
        default n
        depends on SYSFS
+	depends on BROKEN
        ---help---
        Support for Digi Realport devices.  These devices allow you to
        access remote serial ports as if they are local tty devices.  This
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Oct_2012_13_28_27_+1100_LTLElCZDY.J7yOhU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQh1JLAAoJEECxmPOUX5FE9ZYP/0DoYci1W85FBEugHrfnD5N7
OleRITv21pSjt+EDkgJTQI60+pgLkHTR6ukfwSDBOa5xQVkeCtnuL9etEY2YbbV1
TBgdKfoOipUauSobqDWKiTCmds1g/W+ICUi3Bgk5zI3+V8SfLfVPhs6PoYaT0e6B
m6sEMBHEd/IIkIxQXLhP3ewvymkq6taKr2GDs3HnRCQqxyjXvwSCJ0+KpMCy/BwQ
V0+4umfcfUpzcBvIMTHap9KdcubHD2OZNVi1hIWyJ6+gcjdXYqubfnXTPHLNNgL/
N7tOLbdRirv79IAeMMKYmqm5HS3JKcjk9o1Mf4yQrY/gQW6icM22S+/zj39q/L4c
ocV/U9OTCEem4+0BRkgq0sa79JgBgT9uWzlITFntQ6AdyYOZJk0UPXThbMyZdxFz
g+y73eC/JpzLGQU48vh/4dAaO9qZI61eMZ4LVcrT6kZP8e9bX5mZ3rBzMDDscU6F
N0tqtYr0PekIjC/c1lKMQO4qwvZrTffxnb71DCK8EDjZXKsFmwxc3azY/6lDuZcN
DGb3njM50ucPpSrtF8LyLNtSWTUFHpQGII3X/WuB+/soc+v9Fy4O1b7g4b+yU4A6
TAYJDLHhem0BzqJlIslIMsRkunrR/I1P4xG02QhnY3Rb76JYizSR0pkmNn9pDLFn
EF3GIlRjxweRnxfNtPE4
=kRju
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Oct_2012_13_28_27_+1100_LTLElCZDY.J7yOhU--
