Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab1KBOPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:15:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab1KBOPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:15:32 -0400
Message-ID: <4EB1507D.9060009@redhat.com>
Date: Wed, 02 Nov 2011 12:15:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [GIT PULL for 3.2-rc1] EDAC drivers updates
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Please pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

For:
	- edac core: Move edac main structs to include/linux/edac.h;
	- removal of edac_mce glue. Now, both AMD and Intel drivers with mce
	  will use the same glue to allow MCA error reports to go through the
	  edac API;
	- i7core edac: add scrub suport, pre-fill DIMM labels and a few fixes;
	- i7300 edac: a fix at the error cleanup logic;
	- sb edac: add an experimental EDAC driver for Sandy Bridge-EP family.

Thanks!
Mauro

- -

The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

Borislav Petkov (3):
      x86, MCE: Use notifier chain only for MCE decoding
      i7core_edac: Drop the edac_mce facility
      EDAC: Correct Kconfig dependencies

David Sterba (1):
      i7core_edac: fix misuse of logical operation in place of bitop

Mark A. Grondona (1):
      EDAC: Fix incorrect edac mode reporting in sb_edac

Mauro Carvalho Chehab (12):
      i7core_edac: Fix oops when trying to inject errors
      edac: Move edac main structs to include/linux/edac.h
      i7core_edac: Don't enable memory scrubbing for Xeon 35xx
      MAINTAINERS: remove dropped edac_mce.* from the file
      i7core_edac: use edac's own way to print errors
      i7core_edac: return -ENODEV if no MC is found
      i7core_edac: Initialize memory name with cpu, channel, bank
      i7300_edac: Fix error cleanup logic
      edac: Add an experimental new driver to support Sandy Bridge CPU's
      edac: sb_edac: Add it to the building system
      edac: tag sb_edac as EXPERIMENTAL, as it requires more testing
      MAINTAINERS: add an entry for Edac Sandy Bridge driver

Nils Carlson (1):
      i7core_edac: scrubbing fixups

Samuel Gabrielsson (1):
      i7core_edac: Add scrubbing support

Sedat Dilek (1):
      i7core_edac: Fix compilation on 32 bits arch

Thomas Renninger (1):
      EDAC i7core: Use mce socketid for better compatibility

 MAINTAINERS                      |    9 +-
 arch/x86/kernel/cpu/mcheck/mce.c |   18 +-
 drivers/edac/Kconfig             |   16 +-
 drivers/edac/Makefile            |    2 +-
 drivers/edac/edac_core.h         |  350 +-------
 drivers/edac/edac_mce.c          |   61 --
 drivers/edac/i7300_edac.c        |   51 +-
 drivers/edac/i7core_edac.c       |  415 ++++++++-
 drivers/edac/sb_edac.c           | 1893 ++++++++++++++++++++++++++++++++++++++
 include/linux/edac.h             |  350 +++++++
 include/linux/edac_mce.h         |   31 -
 11 files changed, 2671 insertions(+), 525 deletions(-)
 delete mode 100644 drivers/edac/edac_mce.c
 create mode 100644 drivers/edac/sb_edac.c
 delete mode 100644 include/linux/edac_mce.h

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOsVB0AAoJEGO08Bl/PELnXsIP/0htncPpL9Zc1hwzKa2T78Vm
2MKVilhyT6KRzpMyZt5D1stRgMFSd34A/KPx8bwwalj+Qtna1RxCPEPeRjbo3367
0sM9WmHXuDi3SXPFSYOjkn7NEuqpJwEq7wfIJI8OEdgx01nUK5w0BYJySURoo2n4
h3+grX3bK0rwZs+C4ynAQCF0IwYl4Ffgpy4PanxNfHpWb5u0G24laq/Mq1utwBps
fBlUdJxa85lskNmZ3FuPZFLelzlkbG6Zkhj2M//qe/my4bu8ybue0z+MqPoIX/Rf
wlX0YBK10rHr9BgAcYR45SstSTGc5tW+3uj86t9LSUw/TmnhraPDRUGeGUe3tx+R
XHEFbCjV9HJYOezzn62Kt1Wf55b7S88IMG4ECgmgDDcRpknjpDL5uVx1pMxr5Dbd
q6tiugpvbAaqkulxN0mRQhcsn1uFn2nHXKvZEHKntx7suQ6o2L25F4cBWUPJGiEm
rQpmU4fmlPOZsyZl+RUZ88Ct3+vEj62IVrM6IYCc7eS90xKgeU4Bxst2g9TfhMwo
SLY7Ji7JKezXUwg2jQaWeHFfY75hZpYWqf2tcWw4Fg0EJLRSYOhQ6UySGoSXjevx
w41dg53kE4BSzm1wJdwiGOcjIB+disLqY6LWBvWCCe3FljrpR9LDuUvtaAUTP3hJ
dJJVBxy6NJpZCqiNt6qr
=Oc4E
-----END PGP SIGNATURE-----
