Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab2JNW1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 18:27:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41540 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2JNW1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 18:27:36 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Oct 2012 15:27:14 -0700
X-Google-Sender-Auth: VIl9SVazF9q-7N-JxVhAVmwSQKM
Message-ID: <CA+55aFyt0KFNp5Binu-c3-XzF=MG+23EDOk1R6t4qqgW58ksAw@mail.gmail.com>
Subject: Linux 3.7-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two weeks are up, and I was merging during my trip, so no reason
for merge window extensions.

The 3.7-rc1 kernel is out there. There's a few big things worth noting here:

 - the "uapi" include file cleanups. The idea is that the stuff
exported to user space should now be found under include/uapi and
arch/$(ARCH)/include/uapi.

   Let's hope it actually works. Because otherwise this was just a
totally pointless pain in the *ss. And regardless, I'm definitely done
with these kinds of "let's do massive cleanup of the include files"
forever.

 - arm64 architecture inclusion. Let's see if it takes off..

   ... and let's see how many years we'll need before the arm people
do what every single other 64-bit arch has ever done: merge back with
the 32-bit code. As usual, people claimed that there were tons of
reasons why *this* time was different, and as usual it's almost
certainly going to be BS in the end, and a few years from now we'll
have big patches trying to merge it all back. But maybe it really
*was* different this time. Snicker.

 - arm multiplatform code.

   Finally. The ARM devicetree code stuff etc means that at least some
arm kernels can now be built to support multiple different platforms
in one single binary. I'm sure there's still tons to go, but it's a
big milestone nonetheless.

 - ARM virtualization and Xen support.

 - user namespaces are coming back in a workable form.

 - signed kernel modules

 - nice cleanups: workqueues (Tejun Heo) and generic
execve/kernel_thread (Al Viro)

There are tons of other updates, but those are the "big new features"
that came to mind. Maybe I missed some.

Of course, despite all the above changes, the bulk of the actual
patches are still the usual driver updates, which aren't even
mentioned above. So the "big changes" are actually in reality smaller
than the "normal changes we have all the time".

Anyway, the shortlog is much too big as usual for an -rc1 (with over
ten thousand commits), but appended is my "short mergelog" that gives
at least some high-level view of the merges I did.

                           Linus

---
Mergelog since 3.6:
  - GFS2 updates from Steven Whitehouse
  - regmap updates from Mark Brown
  - regulator updates from Mark Brown
  - the trivial tree from Jiri Kosina
  - HID updates from Jiri Kosina
  - localmodconfig fixes from Steven Rostedt
  - ktest fix from Steven Rostedt
  - RCU changes from Ingo Molnar
  - core kernel fixes from Ingo Molnar
  - core locking changes from Ingo Molnar
  - trivial irq core update from Ingo Molnar
  - perf update from Ingo Molnar
  - perf fix from Ingo Molnar
  - scheduler changes from Ingo Molnar
  - timer changes from Ingo Molnar
  - x86/apic changes from Ingo Molnar
  - x86/asm changes from Ingo Molnar
  - x86/build changes from Ingo Molnar
  - x86/cleanups from Ingo Molnar
  - x86/cpu and x86/cpufeature from Ingo Molnar
  - x86 debug update from Ingo Molnar
  - x86/EFI changes from Ingo Molnar
  - x86/fpu update from Ingo Molnar
  - x86/MCE update from Ingo Molnar
  - x86/mm changes from Ingo Molnar
  - x86/platform changes from Ingo Molnar
  - x86/microcode changes from Ingo Molnar
  - s390 updates from Martin Schwidefsky
  - arm64 support from Catalin Marinas
  - PCI changes from Bjorn Helgaas
  - clk framework update from Michael Turquette
  - char/misc driver merge from Greg Kroah-Hartman
  - driver core merge from Greg Kroah-Hartman
  - staging tree update from Greg Kroah-Hartman
  - TTY changes from Greg Kroah-Hartman
  - USB changes from Greg Kroah-Hartman
  - hwmon updates from Guenter Roeck
  - dlm updates from David Teigland
  - m68k updates from Geert Uytterhoeven
  - ia64 update from Tony Luck
  - x86/smap support from Ingo Molnar
  - CIFS updates from Steve French
  - non-critical ARM soc bug fixes from Olof Johansson
  - ARM soc general cleanups from Olof Johansson
  - ARM soc MAINTAINERS updates from Olof Johansson
  - ARM soc-specific updates from Olof Johansson
  - ARM soc device tree updates from Olof Johansson
  - ARM soc cleanups, part 2 from Olof Johansson
  - ARM soc-specific updates, take 2 from Olof Johansson
  - ARM soc driver specific changes from Olof Johansson
  - ARM soc board specific updates from Olof Johansson
  - ARM soc device tree updates, take 2 from Olof Johansson
  - ARM soc documentation updates from Olof Johansson
  - ARM soc multiplatform enablement from Olof Johansson
  - workqueue changes from Tejun Heo
  - cgroup updates from Tejun Heo
  - cgroup hierarchy update from Tejun Heo
  - user namespace changes from Eric Biederman
  - sparc updates from David Miller
  - networking changes from David Miller
  - GPIO changes from Linus Walleij
  - pinctrl changes from Linus Walleij
  - input updates from Dmitry Torokhov
  - infiniband updates from Roland Dreier
  - spi updates from Mark Brown
  - libata changes from Jeff Garzik
  - power management updates from Rafael J Wysocki
  - first round of SCSI updates from James Bottomley
  - CMA and DMA-mapping updates from Marek Szyprowski
  - vfs update from Al Viro
  - xfs update from Ben Myers
  - ubifs changes from Artem Bityutskiy
  - UBI changes from Artem Bityutskiy
  - security subsystem updates from James Morris
  - frontswap update from Konrad Rzeszutek Wilk
  - Xen update from Konrad Rzeszutek Wilk
  - sparc fixes from David Miller
  - CRIS changes from Jesper Nilsson
  - JFS update from Dave Kleikamp
  - devicetree updates from Rob Herring
  - preparatory patches for user API disintegration from David Howells
  - firewire updates from Stefan Richter
  - user namespace compile fix from Eric W Biederman
  - drm merge (part 1) from Dave Airlie
  - crypto update from Herbert Xu
  - remoteproc update from Ohad Ben-Cohen
  - ext3 & udf fixes from Jan Kara
  - KVM updates from Avi Kivity
  - MFD changes from Samuel Ortiz
  - misc patches from Andrew Morton
  - networking changes from David Miller
  - powerpc updates from Benjamin Herrenschmidt
  - ARM Xen support from Konrad Rzeszutek Wilk
  - SLAB changes from Pekka Enberg
  - UAPI disintegration fixes from David Howells
  - infiniband changes from Roland Dreier
  - battery updates from Anton Vorontsov
  - pstore changes from Anton Vorontsov
  - media updates from Mauro Carvalho Chehab
  - ARM soc defconfig updates from Olof Johansson
  - late ARM soc platform updates from Olof Johansson
  - virtio changes from Rusty Russell
  - m68knommu arch updates from Greg Ungerer
  - IMA bugfix (security subsystem) from James Morris
  - microblaze arch updates from Michal Simek
  - ARM updates from Russell King
  - IOMMU updates from Joerg Roedel
  - i2c updates from Jean Delvare
  - ext4 updates from Ted Ts'o
  - ceph updates from Sage Weil
  - kbuild fixes from Michal Marek
  - UBI fastmap changes from Artem Bityutskiy
  - sparc changes from David S Miller
  - arm64 changes from Catalin Marinas
  - sound updates from Takashi Iwai
  - exofs update from Boaz Harrosh
  - asm-generic updates from Arnd Bergmann
  - MIPS update from Ralf Baechle
  - blackfin update from Bob Liu
  - Xtensa patchset from Chris Zankel
  - patches from Andrew Morton
  - CIFS fixes from Steve French
  - btrfs update from Chris Mason
  - MTD updates from David Woodhouse
  - MMC updates from Chris Ball
  - slave-dmaengine updates from Vinod Koul
  - sparc update from David Miller
  - networking updates from David Miller
  - UML changes from Richard Weinberger
  - generic execve() changes from Al Viro
  - nouveau drm fixes from Dave Airlie
  - second s390 update from Martin Schwidefsky
  - scsi target updates from Nicholas Bellinger
  - LED subsystem update from Bryan Wu
  - pwm changes from Thierry Reding
  - NFS client updates from Trond Myklebust
  - hwmon updates from Jean Delvare
  - vfio fixes from Alex Williamson
  - a firewire fix from Stefan Richter
  - block IO update from Jens Axboe
  - misc fixes from Andrew Morton
  - branch 'akpm' (Fixups from Andrew)
  - ARM SoC fixes from Olof Johansson
  - i2c-embedded changes from Wolfram Sang
  - v9fs update from Eric Van Hensbergen
  - fbdev updates from Florian Tobias Schandinat
  - kbuild changes from Michal Marek
  - kconfig changes from Michal Marek
  - kbuild misc changes from Michal Marek
  - writeback fixes from Fengguang Wu
  - pile 2 of execve and kernel_thread unification work from Al Viro
  - pile 2 of vfs updates from Al Viro
  - sound updates #2 from Takashi Iwai
  - second set of ARM updates from Russell King
  - second set of pinctrl patches from Linus Walleij
  - second set of media updates from Mauro Carvalho Chehab
  - RCU fixes from Ingo Molnar
  - scheduler fixes from Ingo Molnar
  - timer core update from Thomas Gleixner
  - SLAB fix from Pekka Enberg
  - Xen fixes from Konrad Rzeszutek Wilk
  - third pile of VFS updates from Al Viro
  - third pile of kernel_execve() patches from Al Viro
  - perf updates from Ingo Molnar
  - ia64 UAPI changes from Tony Luck
  - tile arch update from Chris Metcalf
  - Sparc updates from David Miller
  - networking updates from David Miller
  - nfsd update from J Bruce Fields
  - input layer updates from Dmitry Torokhov
  - misc SCSI updates from James Bottomley
  - device-mapper changes from Alasdair G Kergon
  - two more mmc changes from Chris Ball
  - Xen UAPI disintegration from Konrad Rzeszutek Wilk
  - KGDB/KDB fixes and cleanups from Jason Wessel
  - C6X UAPI disintegration from Mark Salter
  - arm64 uapi disintegration from Catalin Marinas
  - powerpc uapi disintegration from Benjamin Herrenschmidt
  - UAPI disintegration for misc arches from David Howells
  - OpenRISC updates from Jonas Bonn
  - ACPI & Thermal updates from Len Brown
  - TPM bugfixes from James Morris
  - md updates from NeilBrown
  - user namespace compile fixes from Eric W Biederman
  - OpenRISC uapi disintegration from Jonas Bonn
  - spi UAPI disintegration from David Howells
  - UAPI disintegration for include/linux/{,byteorder/}*.h from David Howells
  - ARM update from Russell King
  - module signing support from Rusty Russell
  - MIPS update from Ralf Baechle
