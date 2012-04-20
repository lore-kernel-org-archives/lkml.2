Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2DTWio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:38:44 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:40017 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab2DTWim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:38:42 -0400
Date: Sat, 21 Apr 2012 00:38:33 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz, rob.herring@calxeda.com, minyard@acm.org
Subject: [BISECTED] ipmi_si not loading since 2.6.39
Message-ID: <20120420223833.GA7855@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7473883 records (last update: 20120420)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I was trying to find out why IPMI stopped working on new kernels. Since 2.6=
=2E39
module loading ends with following message:

 ipmi_si: Interface detection failed

Then ipmitool is unable to control IPMI device.=20

Works for 2.6.38, doesn't work for 2.6.39, 3.0.28, 3.4-rc1.

I got this bisected to following commit:

commit a1e9c9dd3383e6a1a762464ad604b1081774dbda
Author: Rob Herring <rob.herring@calxeda.com>
Date:   Wed Feb 23 15:37:59 2011 -0600

    ipmi: convert OF driver to platform driver
   =20
    of_bus is deprecated in favor of the plain platform bus. This patch
    merges the ipmi OF driver with the existing platform driver.
   =20
    CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
   =20
    Compile tested with and without CONFIG_OF. Tested OF probe and
    default probe cases.
   =20
    Signed-off-by: Rob Herring <rob.herring@calxeda.com>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

I wonder whether this is a bug, or I'm doing something wrong?

Thanks in advance!

with best regards

nik


--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+R5WkACgkQ3xdJJrLygV6omQCguOal4XzrBG4FLVe3SubC9Y8Q
KbsAn1M6bMvmncUNw7V6uZIiOv+j/mwX
=wcWm
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
