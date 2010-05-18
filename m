Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab0ERGoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:44:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39119 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab0ERGoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:44:16 -0400
Date: Tue, 18 May 2010 16:44:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20100518164409.8b19c786.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_May_2010_16_44_09_+1000_CD41NQWC/Uw/8UHv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_May_2010_16_44_09_+1000_CD41NQWC/Uw/8UHv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

cc1: warnings being treated as errors
In file included from include/linux/kobject.h:21,
                 from include/linux/device.h:17,
                 from arch/powerpc/lib/devres.c:10:
include/linux/sysfs.h:97: error: 'struct file' declared inside parameter li=
st
include/linux/sysfs.h:97: error: its scope is only this definition or decla=
ration, which is probably not what you want
include/linux/sysfs.h:99: error: 'struct file' declared inside parameter li=
st
include/linux/sysfs.h:101: error: 'struct file' declared inside parameter l=
ist

and many more (arch/powerpc is built with -Werror (as do some other
architectures)) and lots of similar warnings ...

Caused by commit f8e898186196a22756b50b908ecd92123265f8a2 ("sysfs: add
struct file* to bin_attr callbacks").   See Rule 1 in
Documentation/SubmitChecklist.  The header file probably just needs
"struct file;" added in the right place.

I have reverted that commit for today (and commit
44e425ab9f887ec6d3a7a4481f3b0c99f120de19 ("pci: check caps from sysfs
file open to read device dependent config space") that depends on it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_May_2010_16_44_09_+1000_CD41NQWC/Uw/8UHv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvyNzkACgkQjjKRsyhoI8xHwQCgtEomCrJs3GaECrRT/MHSdwg+
YisAn1sSfTf/k+SN42x4N4qT1fxnF2DP
=iMXG
-----END PGP SIGNATURE-----

--Signature=_Tue__18_May_2010_16_44_09_+1000_CD41NQWC/Uw/8UHv--
