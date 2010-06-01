Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0FABL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:11:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51833 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0FABLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:11:55 -0400
Date: Tue, 1 Jun 2010 11:11:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the  shtree
Message-Id: <20100601111149.a809f097.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Jun_2010_11_11_49_+1000_Z.UIu83JnXe5K8w7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Jun_2010_11_11_49_+1000_Z.UIu83JnXe5K8w7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the sh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/usb/gadget/r8a66597-udc.c:35:
drivers/usb/gadget/r8a66597-udc.h: In function 'r8a66597_read_fifo':
drivers/usb/gadget/r8a66597-udc.h:147: error: implicit declaration of funct=
ion 'readsl'
drivers/usb/gadget/r8a66597-udc.h:164: error: implicit declaration of funct=
ion 'readsw'
drivers/usb/gadget/r8a66597-udc.h: In function 'r8a66597_write_fifo':
drivers/usb/gadget/r8a66597-udc.h:197: error: implicit declaration of funct=
ion 'writesl'
drivers/usb/gadget/r8a66597-udc.h:204: error: implicit declaration of funct=
ion 'writesw'
In file included from drivers/usb/host/r8a66597-hcd.c:44:
drivers/usb/host/r8a66597.h: In function 'r8a66597_read_fifo':
drivers/usb/host/r8a66597.h:185: error: implicit declaration of function 'r=
eadsl'
drivers/usb/host/r8a66597.h:194: error: implicit declaration of function 'r=
eadsw'
drivers/usb/host/r8a66597.h: In function 'r8a66597_write_fifo':
drivers/usb/host/r8a66597.h:215: error: implicit declaration of function 'w=
ritesl'
drivers/usb/host/r8a66597.h:230: error: implicit declaration of function 'w=
ritesw'

Caused by commits 920491717d4729844a6ebcd13c863e163d41ca6e ("usb: gadget:
r8a66597-udc pio to mmio accessor conversion") and
ae7cbc543c96c90d3b277a5370d77c08a047c396 ("usb: r8a66597-hcd pio to mmio
accessor conversion").

I have used the version of the sh tree form next-20100531 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Jun_2010_11_11_49_+1000_Z.UIu83JnXe5K8w7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwEXlUACgkQjjKRsyhoI8zJ2ACgs4dHahbIUwVHNcT6EILt1dA1
ekkAniQatgLKgRGMxRhCqhx76kWHqxst
=aTpH
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Jun_2010_11_11_49_+1000_Z.UIu83JnXe5K8w7--
