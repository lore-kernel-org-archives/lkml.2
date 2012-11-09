Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab2KIOLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:11:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24289 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:11:36 -0500
Date: Fri, 9 Nov 2012 09:11:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.7-rc5-tag
Message-ID: <20121109141127.GA16019@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.7-rc5-tag

which has bug-fixes. There are three ARM compile fixes (we forgot to export
certain functions and if the drivers are built as an module - we go belly-up).
There is also an mismatch of irq_enter() / exit_idle() calls sequence - which were
fixed some time ago in other piece of codes, but failed to appear in the Xen code.
Lastly a fix for to help in the field with troubleshooting in case we cannot get
the appropriate parameter and also fallback code when working with very old hypervisors.

Please pull!

 arch/arm/xen/enlighten.c             |   11 +++++
 arch/x86/include/asm/xen/hypercall.h |   21 +++------
 drivers/xen/Makefile                 |    1 +
 drivers/xen/events.c                 |    2 +-
 drivers/xen/fallback.c               |   80 ++++++++++++++++++++++++++++++++++
 include/xen/hvm.h                    |   34 +++++++++++++-
 6 files changed, 132 insertions(+), 17 deletions(-)

Jan Beulich (1):
      xen/hypercall: fix hypercall fallback code for very old hypervisors

Konrad Rzeszutek Wilk (3):
      xen/hvm: If we fail to fetch an HVM parameter print out which flag it is.
      xen/generic: Disable fallback build on ARM.
      xen/arm: Fix compile errors when drivers are compiled as modules.

Mojiong Qiu (1):
      xen/events: fix RCU warning, or Call idle notifier after irq_enter()

Stefano Stabellini (1):
      xen/arm: Fix compile errors when drivers are compiled as modules (export more).


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQnQ8LAAoJEFjIrFwIi8fJz3oH/1Ij7c2u0KlRYRvgipf6Gmv4
emorzbz+I1CRQHEE9idaHCEI1tH/7Eb46L0Cq/P8sXZOaS2MhLbh1LRbnprExw7q
6ur2Cms0acmxtnIvrz+l3ntAgfxO+D/a6lhd0rlNVGfa05BvP41xWdntrUdLgCI9
4aDB0ZtSU70bbgSyRnLRENtqisD9tulg+q+XseSEYnbOnik3z9jJaFWtOibRwFZN
udeFqbvji65KkpvvrjhvSx5MlMXx7oZRNdRmt9HP3wtTfSEhAxuXY/9nVv8NR6Xd
J5lWACZC14pLFiL0HILbQmy3HHRaQQnjeOoRdvvuJubQSk2p9R0IUdKm5rXBkdA=
=EBAd
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
