Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2GICEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 22:04:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34777 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2GICEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 22:04:52 -0400
Date: Mon, 9 Jul 2012 12:04:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Parav Pandit <parav.pandit@emulex.com>
Subject: linux-next: manual merge of the infiniband tree with Linus' tree
Message-Id: <20120709120438.e23688b14cab6f48fe551006@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jul_2012_12_04_38_+1000_XuOJnrmeD7WIW.7q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jul_2012_12_04_38_+1000_XuOJnrmeD7WIW.7q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/hw/ocrdma/ocrdma_main.c between commit 6ab6827ee999
("RDMA/ocrdma: Fixed GID table for vlan and events") from Linus' tree and
commit 898648347205 ("IB: Use IS_ENABLED(CONFIG_IPV6)") from the
infiniband tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/infiniband/hw/ocrdma/ocrdma_main.c
index b050e62,93c9462..0000000
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@@ -202,8 -197,7 +202,7 @@@ static int ocrdma_build_sgid_tbl(struc
  	return 0;
  }
 =20
- #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE) || \
- defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 -#if IS_ENABLED(CONFIG_IPV6)
++#if IS_ENABLED(CONFIG_IPV6) || IS_ENABLED(CONFIG_VLAN_8021Q)
 =20
  static int ocrdma_inet6addr_event(struct notifier_block *notifier,
  				  unsigned long event, void *ptr)

--Signature=_Mon__9_Jul_2012_12_04_38_+1000_XuOJnrmeD7WIW.7q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+jw2AAoJEECxmPOUX5FEFwQP/joHV9PJrp/I1gKMRdW1f33J
perBuirhRXH0agKQ94e75Ze6vIMRTEZY/CJqqVSou4IJvzJKHPRXdQ6jIZ75wmD6
6jrM7VSqsanHdH1JxL+ODIntJKGtRKY3zQkk5ccr3nJ2K1xW51dR4ZXLUeHnIfqt
XDM3tKaXT2MZAqwsYy5opfmqnuZCEZ04SSg+GzUclMhNjQ6tzrovuuFjvH6jubkN
Lrqjia1Nh+ecekyC3vGrJf78nBVxKvyxXHTqKcww7P03LWGDZ67iEAHeE5sRfe1U
fm1VnIZRnvUAugZHMwJaZxW+kDK+jN6qw6lSHMQ8RJlw+k402Zvz3N4JOK9CoN0h
huDRP5C/DZPN3isxi7fBzS9UTHQzEMaZIChpZ6DE3PmBwAni+pV4EPCmjNQ7VcN7
f4D7PpslVBYgLO4wWQ2aAhw1ucWeZDcFijV+Xugl5sBCKqL/B1NoRA/uM+jNscac
cR3OJFAF1qgFPE6U2i5qRFrlN2X4c0gz8n/P1htIjM5ZmO7G+eDl+BshxCyANPiz
SiWF5584vFl9ltV2HJsdZ09CaVpKGYHPhWSw5cFRipSkmM3vW2X9mkDTw6L4SluC
UlY+zp+C29xLeyKJiMpfP0jD2+xmAJMWyvDe1+GVxw82q+33M3gjPbPBpzcq2PsY
FKOzaXE/Sdwl28YWFcOw
=xPkZ
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jul_2012_12_04_38_+1000_XuOJnrmeD7WIW.7q--
