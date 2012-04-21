Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2DUSdm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 14:33:42 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:44672 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab2DUSdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:33:40 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-parisc@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: [PATCH 0/6] PA-RISC: fix compile
Date: Sat, 21 Apr 2012 19:52:11 +0200
Message-ID: <3154414.psmJh6J2U2@donald.sf-tec.de>
User-Agent: KMail/4.8.2 (Linux/3.2.9-13-desktop; KDE/4.8.2; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3040971.EC0xUtAzTX"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Date: Sat, 21 Apr 2012 20:33:24 +0200
From: <eike-kernel@sf-tec.de>
Message-Id: <1335033204.933033@mail.sf-mail.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3040971.EC0xUtAzTX
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Since d66acc39c7cee323733c8503b9de1821a56dff7e (bitops: Optimise get_order())
getorder.h includes log2.h which leads to an include loop on PA-RISC, bringing 
a bunch of other breakage to light. This patchset fixes the compilation of the 
current state of 3.4 on HPPA.

Rolf Eike Beer (6):
  use linux/bitops.h instead of linux/log2.h to get fls()
  parisc: add missing includes in asm/spinlock.h
  parisc: add missing forward declarations in asm/hardware.h
  parisc: drop include of asm/pdc.h from asm/hardware.h
  parisc: add missing include of asm/page.h to asm/pgtable.h
  parisc: move definition of PAGE0 to asm/page.h

 arch/parisc/include/asm/hardware.h |    3 ++-
 arch/parisc/include/asm/page.h     |    6 ++++++
 arch/parisc/include/asm/pdc.h      |    7 -------
 arch/parisc/include/asm/pgtable.h  |    2 ++
 arch/parisc/include/asm/spinlock.h |    2 ++
 arch/parisc/kernel/pdc_cons.c      |    1 +
 arch/parisc/kernel/time.c          |    1 +
 drivers/parisc/sba_iommu.c         |    1 +
 drivers/video/console/sticore.c    |    2 ++
 include/asm-generic/getorder.h     |    2 +-
 10 files changed, 18 insertions(+), 9 deletions(-)

-- 
1.7.9.2

--nextPart3040971.EC0xUtAzTX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+S88sACgkQXKSJPmm5/E46PACcC4xO4NmD1P7Qv2zPs5DWJZ7T
J0IAniLqkD7WIaecEVJSlMJcI2e6yF9o
=udKg
-----END PGP SIGNATURE-----

--nextPart3040971.EC0xUtAzTX--

