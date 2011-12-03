Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1LCBrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:47:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59391 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1LCBrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:47:40 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=MRl6tNtsfWYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=Dy9FSkG8L0gs_orUxm0A:9 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=kkAt2wmzNdCbEbRB_isA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203014641.165123482@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:46:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 00/10] [ANNOUNCE] 3.0.12-rt30-rc1
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[ Sorry for the duplicates, this one has the correct Cc's attached ]

Dear RT Folks,

This is the RT stable review cycle of patch 3.0.12-rt30-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candida=
te).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the main release
next on Wednesday (12/7/2011).

Enjoy,

-- Steve


To build 3.0.12-rt30-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.12.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.12-rt30-=
rc1.patch.xz

You can also build from 3.0.12-rt29 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.12-rt=
29-rt30-rc1.patch.xz


Changes from 3.0.12-rt29:

---

Avi Kivity (1):
      KVM: Sanitize cpuid

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
      Linux v3.0.12-rt30-rc1

Thomas Gleixner (3):
      wait: Provide __wake_up_all_locked
      pci: Use __wake_up_all_locked pci_unblock_user_cfg_access()
      acpi: Make gbl_[hardware|gpe]_lock raw

----
 arch/x86/kvm/x86.c              |   37 +++++++-
 drivers/acpi/acpica/acglobal.h  |    4 +-
 drivers/acpi/acpica/evgpe.c     |    4 +-
 drivers/acpi/acpica/evgpeblk.c  |    8 +-
 drivers/acpi/acpica/evgpeutil.c |   12 +-
 drivers/acpi/acpica/evxface.c   |   10 +-
 drivers/acpi/acpica/evxfgpe.c   |   24 +++---
 drivers/acpi/acpica/hwregs.c    |    4 +-
 drivers/acpi/acpica/hwxface.c   |    4 +-
 drivers/acpi/acpica/utmutex.c   |   21 +----
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
 19 files changed, 286 insertions(+), 165 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO2X+4AAoJEIy3vGnGbaoAAn0P/38/GUkfPZDs8YW3x+48jvFk
xb8wD4480TprCOkmkoBGs9nH9Kx05pMfE6slijIWehiQqgk6Z0u1I3jI8UpN8XJB
WwGalBRWghL7CjQYI3CTTdrqMbsCTziHKvnOXc6aduNqbGniIyvFbYYiCF+rwN+g
2t9CXyXsGP5doAFvfVjIGTBImq9kys5vwwtDUTE9hp91ey0osCJnRfKNGCP7oE9u
gE1TY3Qt+624eTKYfyydXTnsh/38SfU+e1WnM7BlfJ95jvm5sOY0PW/0oXLw101a
hPBCRRprqBKgF/7ypjvTzyEuMUVEilXZpbuhbZ5XTJh7IOPxwikjZNbEiq/S2CTS
3k8MpkPXFMlbHTIAXU/d3AKO+zBKVdc2hJlardqKkPNypCLTFxjtOxyKtWYMZYMk
DuNUYea/cZ+87gaSZm2fW+ol/YrSjlHPv0xQGRfFW96Th6fpll5wDkjIh8tp6X3w
hQEfCEXSMWRS8CGBALsn8rdzCiTjkmwKL6I8J1gOS6/bGCi3yI6fyRvSvEM7eB24
JmdzEmbmS3SfblI+Gy+gBtNEWke9Ohl9ZPlF2kTWaAEE0B2cut19Pt90r3qoq9n/
0zNUtMLBX5Qta9K5zd3rB3hGSwvdXkY/C0pulO3fh/xSrRaMo0eBjoUED/kBYxuX
GC6JytjB3u0OyN9Z0y0A
=DPWx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
