Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1LDTAD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:00:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54551 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab1LDTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:01 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=wJETTmP6vHAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=Dy9FSkG8L0gs_orUxm0A:9 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=LeyVkSjZZunYyKKo8o8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111204185444.411298317@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sun, 04 Dec 2011 13:54:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 00/11] [ANNOUNCE] 3.0.12-rt30-rc2
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.12-rt30-rc2.

Please scream at me if I messed something up. Please test the patches too.

The difference between this and -rc1 was I fixed up the patches to
add the changes, instead of removing them :)

I also added the missing commit:=20
KVM: fix XSAVE bit scanning (now properly)
That Thomas pointed out was missing.


The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candida=
te).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the main release
next on Wednesday (11/7/2011).

Enjoy,

-- Steve


To build 3.0.12-rt30-rc2 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.12.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.12-rt30-=
rc2.patch.xz

You can also build from 3.0.12-rt29 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.12-rt=
29-rt30-rc2.patch.xz


Changes from 3.0.12-rt29:

---


Andre Przywara (1):
      KVM: fix XSAVE bit scanning (now properly)

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
      Linux v3.0.12-rt30-rc2

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
 19 files changed, 290 insertions(+), 168 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO28MqAAoJEIy3vGnGbaoAlP0P/jCSo/gaYv1wmSwoS8vr8YzU
i0fU5QQ145Tpd6v+0kbUIr18T74pX+lKmkO8gEkoCQgV31NTNdPjmiDGOazVgX/R
dRdmjmOUFokje+yWFd6WiskO7oOuVZtaRlIipQA9TQxoEJJyjKrtzEfvxskKTpL1
JEoR6RrzUww5JKXw6nQQF/+HUwm4RJVBoRtrGyRF8L6NUSuPHd+A+V+2kyQzXO9V
phCc2zpolhi+78sxI9TiqPs2UghCHpUTFmc0ALAjiw+QwWv/nIPYs2L/03ReG2Cn
26HgyswPwreSoGghn0qUFNi6f54JX8V/6JC50fXseZtxrckgikWHthzL8a0a+axJ
4M1qN1+E9y58e5tEwTYNum8F8QuVlUwfUA/r+NuBl52rTxlSGKNgWrHB2ns0WzIH
j5AMlXoMxM+NmXkmxeQ1fygkb/hxlWqniKhF87gjdualR2isBguFw0FXYOCfaObY
cLXYr3+IJyM2AXbb5uliXjw6dwVfml5rQfQGfsT+muv1IufKrBKZKErmllxG4UM9
9jffFhP1kwDHvzc/QCoYUCjV+dCDeXcJYDkL48PVT9rSIa9oeAuVZxkVXHglfftq
vcJ142rGklC3fH/5NZqgpufoEaGVpPgu4YUnnm3feWCR56/lqiCNtYSadM2Vq27g
JaecrOAJMRFi6s9vMZ5x
=BKWX
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
