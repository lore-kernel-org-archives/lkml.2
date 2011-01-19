Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1ASEmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:42:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52835 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab1ASEmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:42:19 -0500
Date: Wed, 19 Jan 2011 15:42:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: linux-next: build failure after merge of the rr tree
Message-Id: <20110119154210.435453e4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__19_Jan_2011_15_42_10_+1100_o8NOkkl5.=gUXM_p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Jan_2011_15_42_10_+1100_o8NOkkl5.=gUXM_p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the rr tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

net/dsa/dsa.c:432: error: two or more data types in declaration specifiers

Lines 431-433 of that file are:

MODULE_AUTHOR("Lennert Buytenhek <buytenh@wantstofly.org>")
MODULE_DESCRIPTION("Driver for Distributed Switch Architecture switch chips=
");
MODULE_LICENSE("GPL");

Presumably caused by commit b64781e8e2b0f480affb170460cbfb3b11fa9e5d
("param: add null statement to compiled-in module params").  I wonder how
many more build errors this change may provoke.  Please try to find them
and fix them before adding this change, thanks.

I used the version of the rr tree from next-20110118 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

P.S. (some of these may just be in linux-next)
$ git grep '^[ 	]*MODULE_.*)[ 	]*$'
drivers/media/dvb/dvb-core/dvbdev.h:	MODULE_PARM_DESC(adapter_nr, "DVB adap=
ter numbers")
drivers/net/arm/ks8695net.c:MODULE_AUTHOR("Simtec Electronics")
drivers/platform/x86/thinkpad_acpi.c:	MODULE_ALIAS("dmi:bvnIBM:bvr" __type =
"ET??WW*")
drivers/usb/atm/xusbatm.c:	MODULE_PARM_DESC(name, desc)
drivers/usb/gadget/f_mass_storage.c:	MODULE_PARM_DESC(prefix ## name, desc)
drivers/usb/gadget/f_mass_storage.c:	MODULE_PARM_DESC(prefix ## name, desc)
include/linux/blkdev.h:	MODULE_ALIAS("block-major-" __stringify(major) "-" =
__stringify(minor))
include/linux/blkdev.h:	MODULE_ALIAS("block-major-" __stringify(major) "-*")
include/linux/device.h:	MODULE_ALIAS("char-major-" __stringify(major) "-" _=
_stringify(minor))
include/linux/device.h:	MODULE_ALIAS("char-major-" __stringify(major) "-*")
include/linux/isapnp.h:		MODULE_GENERIC_TABLE(isapnp_card, name)
include/linux/module.h:  MODULE_GENERIC_TABLE(type##_device,name)
include/linux/net.h:	MODULE_ALIAS("net-pf-" __stringify(proto))
include/linux/net.h:	MODULE_ALIAS("net-pf-" __stringify(pf) "-proto-" __str=
ingify(proto))
include/linux/netfilter/nfnetlink.h:	MODULE_ALIAS("nfnetlink-subsys-" __str=
ingify(subsys))
include/linux/tty_ldisc.h:	MODULE_ALIAS("tty-ldisc-" __stringify(ldisc))
include/net/netfilter/nf_conntrack.h:        MODULE_ALIAS("nfct-helper-" he=
lper)
include/net/xfrm.h:	MODULE_ALIAS("xfrm-mode-" __stringify(family) "-" __str=
ingify(encap))
include/net/xfrm.h:	MODULE_ALIAS("xfrm-type-" __stringify(family) "-" __str=
ingify(proto))
include/scsi/scsi_device.h:	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
include/sound/minors.h:	MODULE_ALIAS("sound-service-?-" __stringify(type))
net/dsa/dsa.c:MODULE_AUTHOR("Lennert Buytenhek <buytenh@wantstofly.org>")

--Signature=_Wed__19_Jan_2011_15_42_10_+1100_o8NOkkl5.=gUXM_p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNNmuiAAoJEDMEi1NhKgbsX/UH/2qb+RibPMc0wxnyV8p8y0g0
+r6gyc+ln7yEjXnZstO1CfkRfzRrxxo7FJE6nNROvaxcK72/vSqfKaDQeIdvefId
8sYlCuPmBMdO2gjqUuGDq/HwJzaOAJf6R3ZhJtFSatwhwvvDHrdPcguZcGzARd9l
bKUSIJczQf/+Zz0rxUAPo+kQJUTUmdNQgyufnXb3f72l35hGihT8cvJQv6O5Xe52
hD0FNVquEo0Syhpe/U6A5YkNeqR/hZP4Dbw0c7phq1RWylKJBxxHk+tHzzAbZg7A
omt6n61bWF8OS5Mc5DwnWEbnQC89oXMUnsNahgp10viiURGmTFMy3F6dUi8DNO8=
=gHsY
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Jan_2011_15_42_10_+1100_o8NOkkl5.=gUXM_p--
