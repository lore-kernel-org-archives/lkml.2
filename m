Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2LCF5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:57:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36683 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2LCF5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:57:20 -0500
Date: Mon, 3 Dec 2012 16:57:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Pawel Moll <pawel.moll@arm.com>
Subject: linux-next: manual merge of the arm-soc tree with the devicetree
 tree
Message-Id: <20121203165717.c0a658649d824c9f5d5a2db3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Dec_2012_16_57_17_+1100_lXSNSA=rpvrfI.6E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Dec_2012_16_57_17_+1100_lXSNSA=rpvrfI.6E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-vexpress/v2m.c between commit 465aac6d496a ("Fix build when
CONFIG_W1_MASTER_GPIO=3Dm b exporting "allnodes"") from the devicetree tree
and commit 0891642cf117 ("ARM: vexpress: Start using new Versatile
Express infrastructure") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-vexpress/v2m.c
index 359f782,4e168e8..0000000
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@@ -580,20 -420,13 +420,13 @@@ void __init v2m_dt_map_io(void
 =20
  void __init v2m_dt_init_early(void)
  {
- 	struct device_node *node;
  	u32 dt_hbi;
 =20
- 	node =3D of_find_compatible_node(NULL, NULL, "arm,vexpress-sysreg");
- 	v2m_sysreg_base =3D of_iomap(node, 0);
- 	if (WARN_ON(!v2m_sysreg_base))
- 		return;
+ 	vexpress_sysreg_of_early_init();
 =20
  	/* Confirm board type against DT property, if available */
 -	if (of_property_read_u32(allnodes, "arm,hbi", &dt_hbi) =3D=3D 0) {
 +	if (of_property_read_u32(of_allnodes, "arm,hbi", &dt_hbi) =3D=3D 0) {
- 		int site =3D v2m_get_master_site();
- 		u32 id =3D readl(v2m_sysreg_base + (site =3D=3D SYS_CFG_SITE_DB2 ?
- 				V2M_SYS_PROCID1 : V2M_SYS_PROCID0));
- 		u32 hbi =3D id & SYS_PROCIDx_HBI_MASK;
+ 		u32 hbi =3D vexpress_get_hbi(VEXPRESS_SITE_MASTER);
 =20
  		if (WARN_ON(dt_hbi !=3D hbi))
  			pr_warning("vexpress: DT HBI (%x) is not matching "

--Signature=_Mon__3_Dec_2012_16_57_17_+1100_lXSNSA=rpvrfI.6E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQvD89AAoJEECxmPOUX5FEHLsQAIjBfQiw57rclDrzxoe2xIE0
lE8zBQHBDGfqzFVgyRI8zNBLTT8SHn4t947AQ/BE9p9K573pP+wKcb1DTkgB9B4W
u7gDD9EVQV91jgNHHqnPsm3u/SciDU/aaMGztORTJs1R6xFv8vIuGr+styCX5hI5
x/TAmZZHPoICdP0nOt7ZsfTFpySE33BTdoCvrw1tk4r+obKhB2EPIHD/eOB9QWDm
UPlJeSFN9xE8N8/1QVkMlVGhF8DNdwJXGI+tF20E6Wcfq0KzctRQ4GBzFrTxWo/t
TQuqIFzBj7fRsu/aDCJTdzvf7C2wVqftd/00BoRI7dGKBFPTrIfaotEHXmSdjzoq
ugGSWyClHbhqLAxXDWTHxXhJzxJwykqaHHyI420VoYvUx4/oS8EZV8HXITPJ8/2P
2yHVtO8gIfFrfBUKZjIiJ8BVtHW26OFVC42K4lAJag+13LXrQ2V5dneuiYELyBhw
M5wYQPA3xbWPi4yI6ltp/PTaf8BgWDIYdII9A04pyL4IKzuTJkaXuS7g/DfgG0qN
uyZg/92MK15tJpdMiUmtLUozDV221DQhqOKdPgQFjJIM0AzzjWJuJ4HKDnlb+wr9
XqLeyJFl+96MDzlBS8IQKd0EUju0USEZJXZ9snbUgGJQwAJSYJlhgjX7RfHXvsMa
miYlnWfbdDU7XjNbnyAH
=2FmO
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Dec_2012_16_57_17_+1100_lXSNSA=rpvrfI.6E--
