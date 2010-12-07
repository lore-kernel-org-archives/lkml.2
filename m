Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0LGBAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:00:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36882 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab0LGBAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:00:50 -0500
Date: Tue, 7 Dec 2010 12:00:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20101207120039.6ea1491e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Dec_2010_12_00_39_+1100_wKWHfWrMxxKJQ3v_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Dec_2010_12_00_39_+1100_wKWHfWrMxxKJQ3v_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/net/ehea/ehea_main.c: In function 'ehea_refill_rq1':
drivers/net/ehea/ehea_main.c:405: error: implicit declaration of function '=
ehea_info'
drivers/net/ehea/ehea_main.c: In function 'ehea_init_fill_rq1':
drivers/net/ehea/ehea_main.c:429: error: implicit declaration of function '=
ehea_error'
drivers/net/ehea/ehea_main.c: In function 'ehea_neq_tasklet':
drivers/net/ehea/ehea_main.c:1306: warning: format '%lx' expects type 'long=
 unsigned int', but argument 2 has type 'u64'

Caused by commit 539995d18649023199986424d140f1d620372ce5 ("ehea: Use the
standard logging functions") interacting with commit
5c7e57f7cddb83d81d83fefa5822dfe80891130e ("ehea: Add some info messages
and fix an issue") which went into Linus' tree before 2.6.37-rc4.

Presumably a merge of net-current into the net tree will need a fixup patch.

I have used the net tree from next-20101206 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Dec_2010_12_00_39_+1100_wKWHfWrMxxKJQ3v_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/Yc3AAoJEDMEi1NhKgbskQAH/A1Oco8rh1BwBvmKpGU0tfCX
DfIozyA7lkhMOggpZptCnpCgjgPHwC0OjV1vkfF6tSnnUUqPPq4xrsVE17Az0p+C
K8PfqtfnYGJg0gJeqoxiQFfFOXKJBgrqk0No6f0lh+oFpGtDamBVFiGFoos83Dil
NinJ8C9i5EbkDdlLYwrzS6v/+q0ev88BwpcX0AcIlVhvvzTzT8do8VS7JpYcSFdr
BE72PJ9F28FBwIrpFprXQNrOohDFM/f1PEmWVYtSo2f74gUeNVcgl/Nm3FxK+yVP
gDZDWkZnmo7EOfAo7eCnSKZIoQWFzMBXCW22T5x2DouYRyNcxwKWgs7vJAaMG8Y=
=SrfO
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Dec_2010_12_00_39_+1100_wKWHfWrMxxKJQ3v_--
