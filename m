Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0D3Qsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:48:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57484 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441Ab0D3Qre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:34 -0400
Date: Fri, 30 Apr 2010 16:05:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Heikki Krogerus <ext-heikki.krogerus@nokia.com>
Subject: linux-next: build failure after merge of the final tree (usb tree
 related)
Message-Id: <20100430160555.d58bd9aa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Apr_2010_16_05_55_+1000_s7wkyK8WnIp0hcN1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Apr_2010_16_05_55_+1000_s7wkyK8WnIp0hcN1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_set_bits':
drivers/usb/otg/twl4030-usb.c:238: error: implicit declaration of function =
'ULPI_SET'
drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_clear_bits':
drivers/usb/otg/twl4030-usb.c:244: error: implicit declaration of function =
'ULPI_CLR'
drivers/usb/otg/twl4030-usb.c: In function 'twl4030_usb_set_mode':
drivers/usb/otg/twl4030-usb.c:303: error: 'ULPI_IFC_CTRL' undeclared (first=
 use in this function)
drivers/usb/otg/twl4030-usb.c:304: error: 'ULPI_IFC_CTRL_CARKITMODE' undecl=
ared (first use in this function)
drivers/usb/otg/twl4030-usb.c:306: error: 'ULPI_FUNC_CTRL' undeclared (firs=
t use in this function)
drivers/usb/otg/twl4030-usb.c:307: error: 'ULPI_FUNC_CTRL_XCVRSEL_MASK' und=
eclared (first use in this function)
drivers/usb/otg/twl4030-usb.c:308: error: 'ULPI_FUNC_CTRL_OPMODE_MASK' unde=
clared (first use in this function)

Caused by commit 57983872ff14cba23d6404a40c89e52063c94854 ("usb: otg:
twl4030: use the global ULPI register definitions").  I have reverted
that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Apr_2010_16_05_55_+1000_s7wkyK8WnIp0hcN1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvac0MACgkQjjKRsyhoI8w8VgCeJzMCgVZDkDpFqaXcU6Eg0cbh
qFYAnRcxsiqRQ6adSRlFSxybZTw9sY/A
=fG9L
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Apr_2010_16_05_55_+1000_s7wkyK8WnIp0hcN1--
