Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1LEXCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:02:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348Ab1LEXCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:02:50 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=GgUBDjBmGuMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=Dy9FSkG8L0gs_orUxm0A:9 a=PCDR28T0bxifjbdk2_IA:7 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=5fUO9EW1C2a7gfsVb7YA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111205230046.736851081@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 18:00:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 00/12 rc3] [ANNOUNCE] 3.0.12-rt30-rc3
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.12-rt30-rc3.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candida=
te).

The difference between rc2 and rc3, is the addition of Clark Williams patch:
ACPI: Convert embedded controller lock to raw spinlock

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the main release
next on Wednesday (12/7/2011).

Enjoy,

-- Steve


To build 3.0.12-rt30-rc3 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.12.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.12-rt30-=
rc3.patch.xz

You can also build from 3.0.12-rt29 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.12-rt=
29-rt30-rc3.patch.xz


Changes from 3.0.12-rt29:

---


Andre Przywara (1):
      KVM: fix XSAVE bit scanning (now properly)

Avi Kivity (1):
      KVM: Sanitize cpuid

Clark Williams (1):
      ACPI: Convert embedded controller lock to raw spinlock

Edward Donovan (1):
      genirq: fix regression in irqfixup, irqpoll

Ingo Molnar (1):
      tasklet/rt: Prevent tasklets from going into infinite spin in RT

Peter Zijlstra (2):
      slab, lockdep: Fix silly bug
      slab, lockdep: Annotate all slab caches

Roland Dreier (1):
      intel-iommu: Fix AB-BA lockdep report

Steven Rostedt (1):
      Linux v3.0.12-rt30-rc3

Thomas Gleixner (3):
      wait: Provide __wake_up_all_locked
      pci: Use __wake_up_all_locked pci_unblock_user_cfg_access()
      acpi: Make gbl_[hardware|gpe]_lock raw

----
 arch/x86/kvm/x86.c              |   44 +++++++-
 drivers/acpi/acpica/acglobal.h  |    4 +-
 drivers/acpi/acpica/evgpe.c     |    4 +-
 drivers/acpi/acpica/evgpeblk.c  |    8 +-
 drivers/acpi/acpica/evgpeutil.c |   12 +-
 drivers/acpi/acpica/evxface.c   |   10 +-
 drivers/acpi/acpica/evxfgpe.c   |   24 +++---
 drivers/acpi/acpica/hwregs.c    |    4 +-
 drivers/acpi/acpica/hwxface.c   |    4 +-
 drivers/acpi/acpica/utmutex.c   |   21 +----
 drivers/acpi/ec.c               |   22 ++--
 drivers/acpi/internal.h         |    2 +-
 drivers/pci/access.c            |    2 +-
 drivers/pci/intel-iommu.c       |    4 +-
 include/linux/interrupt.h       |   39 ++++----
 include/linux/wait.h            |    5 +-
 kernel/irq/spurious.c           |    4 +-
 kernel/sched.c                  |    4 +-
 kernel/softirq.c                |  208 ++++++++++++++++++++++++++++-------=
----
 localversion-rt                 |    2 +-
 mm/slab.c                       |   55 ++++++-----
 21 files changed, 302 insertions(+), 180 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3U2TAAoJEIy3vGnGbaoAXCAP/j3pSp78SpQt4UWi+s8MsoGJ
iag4pVU4UwjM8gvp/sUuSvS/JIgEubRa+FOsasqCz4cqtRv9/8Te++Mh+8lkmgjW
V5upxqxic1fJiSXNP8Kj33WoOa7umhOfYKiIe4xQovBHMJSSbjYB3HhPVT78i5Dj
id3F0LGHs/VrVZHAXx+UV8sOiFtaXy916XtwbfUdvZe9Zg8rVX4IpYfyCTAhfWrr
yyApBzixu+/rTA139Ygp5zBZndzLC4fmUPWx07KxiRnIPScFN0D3uIgEWgzLHCgY
im0kZYKyR9/DtpT5ndl6z+UlN2kRl6CiPvALZ/g5GkyHPrYRB2S3gmsFdCkDtQSY
N7dKsoWDW5OkOD82zCv6Vmh/WwUdHqsBjIsPkrO1SiCQGk6IKIuns+XLAmCjNGIj
oD1eDou8abbUtBTJopdoVXLJUQ4VFFocep4FEHM1EG0u7BNt51cST+chQyFlDNNG
MkYsaSGcOnv3SzePFSC1OguSfGA3ls+Ga0fNIOOIMqMFzMhXxNPOcjvbG4JOXE8G
jGwc2bQi34vBmbkgIjUBRXvYPIw+FgrRiWqZsJ3ALy6T1ybcGTdKeKYJOS5oFFw2
f2OEL21o58XEzyfK5Ifsk15yE4+lBehS1anB1odI3BbK8rs7Jst/kxAoKx4OJkcJ
Hgk0YdXoTFAVzRY1bdJL
=i5sq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
