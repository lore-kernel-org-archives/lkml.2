Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab2EJI55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:57:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38160 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab2EJI5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:57:54 -0400
Date: Thu, 10 May 2012 18:57:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay@vrfy.org>, Greg KH <greg@kroah.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the scsi-post-merge tree with the
 driver-core tree
Message-Id: <20120510185746.1b7b8e582c0c968633b6e2f1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_18_57_46_+1000_5a9xWhWFxJoJS/VJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2012_18_57_46_+1000_5a9xWhWFxJoJS/VJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/page_alloc.c between commit 155cbfc802e4 ("mm: use KERN_CONT in printk()
continuation lines") from the driver-core tree and commit "mm: print
physical addresses consistently with other parts of kernel" from the akpm
tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/page_alloc.c
index d5a49b6,a98059a..0000000
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@@ -4819,14 -4819,15 +4819,15 @@@ void __init free_area_init_nodes(unsign
  	for (i =3D 0; i < MAX_NR_ZONES; i++) {
  		if (i =3D=3D ZONE_MOVABLE)
  			continue;
 -		printk("  %-8s ", zone_names[i]);
 +		printk(KERN_CONT "  %-8s ", zone_names[i]);
  		if (arch_zone_lowest_possible_pfn[i] =3D=3D
  				arch_zone_highest_possible_pfn[i])
 -			printk("empty\n");
 +			printk(KERN_CONT "empty\n");
  		else
- 			printk(KERN_CONT "%0#10lx -> %0#10lx\n",
- 				arch_zone_lowest_possible_pfn[i],
- 				arch_zone_highest_possible_pfn[i]);
 -			printk("[mem %0#10lx-%0#10lx]\n",
++			printk(KERN_CONT "[mem %0#10lx-%0#10lx]\n",
+ 				arch_zone_lowest_possible_pfn[i] << PAGE_SHIFT,
+ 				(arch_zone_highest_possible_pfn[i]
+ 					<< PAGE_SHIFT) - 1);
  	}
 =20
  	/* Print out the PFNs ZONE_MOVABLE begins at in each node */

--Signature=_Thu__10_May_2012_18_57_46_+1000_5a9xWhWFxJoJS/VJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPq4MKAAoJEECxmPOUX5FE9XIP/RaKxvtgzEPMkJlIWHXGWaSr
Av0QX+tsVoCZ9D+5kskaCxA6NqtCpwUdP5y4r4oIuIvU0iVssUABxpqBapjwVA7H
xY6evYw90+UBcunDgUylXhq4q60awhGQwvtkmYryQm8k4XbZTyTdvRhccpiVuLet
hmFdPtaXHCm/90IqmPWwTzvQEmFl1duMaaI46noM9rJvzQHox6OdIJAdchRWkrPX
fAoVyyre6/tAS/7mJ65weMFPqq43Eo1R+z8GjiNUJXMIYjJOgwMLgG75yB15zw3W
ejxVKyKRsDdNHNpuKhJ/zygqLRyYv8w6suq31cigaatb9Y4rHvnUnq1JU4C8Sgty
p/QCYM94CP+uSRGBOCYEgttzmkyIq90pVqMmX9bWezYJRMqEH38vckUPJkJqFNkO
ZJx4hZRwgH01iZxny6aaG01A59xD9OLPSbIAM5Zi1S1EWUw2Q9JWWBnyrJSWCINw
yk1KXazIQg90Un0xNpcDKfSUxPIL4G38dw13WxGfWYmQBWBFif0wINHRsCh/wr8p
kyCwmFeovUIk8xXBkzT38LRc6+6axe588sxyuySuR2olxL1jTzWgY7UnLYcueiHI
m2lv6QKk5edePcbti5lRB9u3miw5wVVdBxP3opFAIKtCXKXhzP9XHtfPBCABk6g6
fRHJlPDTms0KRY6e46wG
=3pRR
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_18_57_46_+1000_5a9xWhWFxJoJS/VJ--
