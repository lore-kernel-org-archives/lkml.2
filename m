Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2CXODO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:03:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37426 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2CXODM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:03:12 -0400
Date: Sat, 24 Mar 2012 09:56:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.4-tag-two (or three depending on
 your taste) for v3.4-rc0
Message-ID: <20120324135647.GA5923@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F6DD41D.0035,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

I mentioned in the first git pull I would be sending another one after the cpu frequency
tree was pulled and here it is:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.4-tag-two

However, I might have messed up a bit. The reason for this delay was that one patch
("xen/cpufreq: Disable the cpu frequency scaling drivers from loading") in my tree depended on
("provide disable_cpufreq() function to disable the API.") which was in the cpufreq tree.
To not cause bisection issues (such as hitting on my patch without the dependency patch and
getting a compile failure), I cherry-picked that specific patch into my branch from the cpufreq
tree - and is part of the above mentioned tag.

So the problem is when I do the git pull against your latest, it doesn't apply  the "provide .."
but I still see it in the git shortlog!? Is that OK?

If that is not OK, I've done the unthinkable and created another branch (and yet another tag),
which is based on your yesterday tree and is based off cf821923ba9aa0917165a12573bdd6dc0a354421.
With that the shortlog does not include the "provide.." patch (obviously since that is the
merge of the cpufreq tree).

So if you prefer to pull that one instead, please pull:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.4-tag-three

Either way, the git diff looks exactly the same.

Igor Mammedov (1):
      xen: initialize platform-pci even if xen_emul_unplug=never

Jan Beulich (1):
      xen/tmem: cleanup

Konrad Rzeszutek Wilk (6):
      provide disable_cpufreq() function to disable the API.
      xen/cpufreq: Disable the cpu frequency scaling drivers from loading.
      xen/acpi-processor: Do not depend on CPU frequency scaling drivers.
      xen/acpi: Remove the WARN's as they just create noise.
      xen/smp: Fix bringup bug in AP code.
      xen/acpi: Fix Kconfig dependency on CPU_FREQ

Stefano Stabellini (1):
      xen: support pirq_eoi_map

 arch/x86/xen/setup.c             |    2 ++
 arch/x86/xen/smp.c               |    6 ++++++
 drivers/block/xen-blkfront.c     |    3 +++
 drivers/net/xen-netfront.c       |    4 ++++
 drivers/xen/Kconfig              |    5 ++---
 drivers/xen/events.c             |   26 +++++++++++++++++++++++---
 drivers/xen/platform-pci.c       |    5 -----
 drivers/xen/tmem.c               |   21 ++++++++-------------
 drivers/xen/xen-acpi-processor.c |    4 ++--
 include/xen/interface/physdev.h  |   21 +++++++++++++++++++++
 include/xen/tmem.h               |    6 +++++-
 11 files changed, 76 insertions(+), 27 deletions(-)

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPbdKaAAoJEFjIrFwIi8fJovUH/RPil07s0RQ4ZAHTENEIk6ri
HX4kFWfAAWV17x4TTcTZ5K4oI1mVaC6O9gRL8c5UpVdYMQVZPa41S1DpAja0BHtd
YlvZ837vpHI4rh7PEGGo2Q9A5nRHvAvudwAArSb0KCDRqV7BlES5fgMzFxkODuDS
aT9sfpwhmnizC5VwrHKg+5y2k7YHiwuC1KzcjcshbykLPsvGt4RSmUWJlHPWvxIY
vJeEmHV/D3l+hXj3VR4fLO9XvFV21BIP3oHnlme+Zm5yAhHm+YNJsRLHHV9pAHXF
dt5Eir/H7BZ+UwZZdCI8P3l+eDtM8+9WFY8fOvYOE2tlLl27MXvs/AyjeqFa/WQ=
=Bz46
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
