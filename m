Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2CaX7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 19:59:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33530 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2CaX65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 19:58:57 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Mar 2012 16:58:35 -0700
X-Google-Sender-Auth: ZZz1n_n_v1LrJXcp18ziuvfgqSY
Message-ID: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
Subject: Linux 3.4-rc1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, it's been two weeks, and the merge window is over. Linux 3.4-rc1
has been pushed out to the git servers, and the tar-ball and patches
are going out as I type this (probably done by the time I'm done).

And yes, if you actually counted, it has only been 13 days. And if
somebody delayed their pull request until the last day of the merge
window, I'm sure they'll be even happier to delay it another two
months until the next merge window. Yay!

That said, there are four pull requests in my mailbox that weren't
delayed, and that I will (probably) still pull, but that I wanted to
get extra confirmation from *other* maintainers from first. So they
were sent in time, I just decided that I can make the actual pull
choice a bit later.

The four remaining pull requests (and the people I want comments from) are:

 - HSI (High Speed Synchronous Serial Interface) framework. I'm
planning on pulling this into 3.4, it's in my queue, but I wanted to
bring it up one more time in case somebody has issues with it. Ping?

 - pohmelfs. The old pohmelfs got deleted from staging, there's an
all-new one waiting in the sidelines. Al was a bit unhappy about some
of it, Evgeniy fixed it up some, and then the discussion died. Again,
I'm likely to pull this, but I wanted more commentary on it.

 - drm dma-buf prime support. Dave Airlie sent me the pull request but
didn't push very hard for it, it's in my "ok, I can still pull it for
3.4 if individual DRM driver people tell me that it will make their
lives easier." So this is in limbo - I have nothing against it, but I
won't pull unless I get a few people say "yes, please".

 - DMA-mapping framework. The tree now has a few more acks from
people, and it's largely in the same situation as HSI is: I'll
probably pull, but I really wanted the users who are impacted to
actually talk to me about it.

And that's it. So there's four more pulls pending, and likely, but
other than that we're done (unless you can show that you actually did
email me, but because of some cosmic mistake - probably involving my
incompetence - I've overlooked it. Hey, it happens).

Anyway, enough about the "what's still possibly pending". If you want
to see what actually went in, one fairly readable approach is to do
this:

    git log --merges --author=Torvalds v3.3..

because I really tried pretty hard to make readable merge messages if
I got any information at all from the submaintainer. And a lot of you
did send that in - thanks.  I've tried to distill most of that into
the appended "shortmerge" format (which is just me grepping for my
one-liner "pull what from whom" details).

One thing worth pointing out is that the header file cleanups were
nice, but let's never do them again. Or at least not for a release or
two. They caused a lot of merge conflicts and small annoyances, and
while I'm ok with resolving merges, it was annoying enough that I
don't want to go through that immediately again. I know they also
annoyed some submaintainers that were complaining to me about the
pain.

That said, I do think they helped. The <asm/system.h> disintegration
(and to a smaller degree the bug.h cleanups) may have been painful,
but it definitely cleaned things up. So I guess we *will* do things
like this in the future again, I just want to forget about the pain
before we embark on this next time. Ok?

Anyway, please do test and report any regressions.

                                    Linus

---

Not necessarily exhaustive list of pulls I did during the merge window:

 - core/iommu changes for v3.4 from Ingo Molnar
 - core/locking changes for v3.4 from Ingo Molnar
 - RCU changes for v3.4 from Ingo Molnar.
 - irq/core changes for v3.4 from Ingo Molnar
 - perf events changes for v3.4 from Ingo Molnar
 - scheduler changes for v3.4 from Ingo Molnar
 - timer changes for v3.4 from Ingo Molnar
 - char and misc patches for 3.4-rc1 from Greg KH
 - driver core patches for 3.4-rc1 from Greg KH
 - big staging driver updates from Greg KH
 - TTY/serial patches from Greg KH
 - USB merge for 3.4-rc1 from Greg KH
 - cgroup changes from Tejun Heo
 - workqueue changes from Tejun Heo
 - networking merge from David Miller
 - HID updates from Jiri Kosina
 - trivial tree from Jiri Kosina
 - kmap_atomic cleanup from Cong Wang
 - power management updates for 3.4 from Rafael Wysocki
 - irq_domain support for all architectures from Grant Likely
 - core device tree changes for Linux v3.4 from Grant Likely
 - SPI changes for v3.4 from Grant Likely
 - InfiniBand/RDMA changes for the 3.4 merge window from Roland Dreier
 - regulator updates for 3.4 from Mark Brown
 - hwmon changes for v3.4 from Guenter Roeck
 - crypto update from Herbert Xu
 - security subsystem updates for 3.4 from James Morris
 - munmap/truncate race fixes from Al Viro
 - vfs pile 1 from Al Viro
 - dlm updates for 3.4 from David Teigland
 - gfs2 changes from Steven Whitehouse
 - m68knommu arch updates from Greg Ungerer
 - powerpc merge from Benjamin Herrenschmidt
 - x86/asm changes from Ingo Molnar
 - x86/atomic changes from Ingo Molnar
 - trivial x86 branches from Ingo Molnar
 - x86/debug changes from Ingo Molnar
 - x86/eficross (booting 32/64-bit kernel from 64/32-bit EFI) from Ingo Molnar
 - x86/build changes from Ingo Molnar
 - x86/fpu changes from Ingo Molnar
 - MCE changes from Ingo Molnar
 - x86 platform changes from Ingo Molnar
 - x86 "urgent" leftovers from Ingo Molnar
 - md updates for 3.4 from Neil Brown
 - SCSI target updates from Nicholas Bellinger
 - updates of sound stuff from Takashi Iwai
 - drm main changes from Dave Airlie
 - radeon southern islands / trinity support from Dave Airlie
 - nouveau destaging + Kelper modesetting support from Dave Airlie
 - s390 patches from Martin Schwidefsky
 - blackfin updates from Bob Liu
 - cleancache changes from Konrad Rzeszutek Wilk
 - xen updates from Konrad Rzeszutek Wilk
 - crypto fixes from Herbert Xu
 - input subsystem updates from Dmitry Torokhov
 - libata updates from Jeff Garzik
 - pinctrl updates for v3.4 from Linus Walleij
 - IEEE 1394 (FireWire) subsystem updates post v3.3 from Stefan Richter
 - regmap updates from Mark Brown
 - fbdev updates for 3.4 from Florian Tobias Schandinat
 - NFS client updates for Linux 3.4 from Trond Myklebust
 - CIFS fixes from Steve French
 - XFS updates from Ben Myers
 - one pstore patch from Tony Luck
 - UBI changes from Artem Bityutskiy
 - UBIFS changes from Artem Bityutskiy
 - ktest changes from Steven Rostedt
 - KGDB/KDB updates from Jason Wessel
 - networking fixes from David Miller
 - PCI changes (including maintainer change) from Jesse Barnes
 - i2c embedded updates from Wolfram Sang
 - IOMMU updates from Joerg Roedel
 - hwmon updates from Jean Delvare
 - media updates from Mauro Carvalho Chehab
 - additional x86 fixes from Peter Anvin
 - miscellaneous Itanium patches from Tony Luck
 - OpenRISC changes for 3.4 from Jonas Bonn
 - #1 ARM updates from Russell King
 - #2 ARM updates from Russell King
 - #3 ARM updates from Russell King
 - cpufreq fixes from Dave Jones
 - cpufreq updates for 3.4 from Dave Jones: new drivers and some fixes
 - AMD64 EDAC fixes from Borislav Petkov
 - sysctl updates from Eric Biederman
 - <linux/bug.h> cleanup from Paul Gortmaker
 - cleanup of fs/ and lib/ users of module.h from Paul Gortmaker
 - <linux/device.h> avoidance patches from Paul Gortmaker
 - more xen updates from Konrad Rzeszutek Wilk
 - "ARM: Non-critical bug fixes" from Ardn Bergmann
 - "ARM: subarch maintainer updates" from Arnd Bergmann
 - "ARM: global cleanups" from Arnd Bergmann
 - "ARM: timer cleanup work" from Arnd Bergmann
 - "ARM: SoC specific updates" from Arnd Bergmann
 - "ARM: board specific updates" from Arnd Bergmann/Olof Johansson
 - "remoteproc/rpmsg: new subsystem" from Arnd Bergmann
 - "ARM: driver specific updates" from Arnd Bergmann
 - "ARM: device tree work" from Arnd Bergmann
 - networking fixes from David Miller
 - ARM platform updates from Russell King
 - arch/microblaze fixes from Michal Simek
 - UML changes from Richard Weinberger
 - s390 patches part 2 from Martin Schwidefsky
 - 9p changes for the 3.4 merge window from Eric Van Hensbergen
 - ext3, UDF, and quota fixes from Jan Kara
 - Ceph updates for 3.4-rc1 from Sage Weil
 - ext4 updates for 3.4 from Ted Ts'o
 - trivial writeback fixes from Wu Fengguang
 - "ARM: More SoC driver updates" from Olof Johansson
 - "ARM: More SoC support updates" from Olof Johansson
 - "ARM: More device tree support updates" from Olof Johansson
 - "drivers/clk: common clock framework" from Olof Johansson
 - drm fixes from Dave Airlie
 - device-mapper changes for 3.4 from Alasdair Kergon
 - watchdog updates from Wim Van Sebroeck
 - MFD changes from Samuel Ortiz
 - GPIO changes for v3.4 from Grant Likely
 - i2c updates from Jean Delvare
 - x86 platform driver updates from Matthew Garrett
 - EDAC fixes from Mauro Carvalho Chehab
 - an Apparmor bugfix from James Morris
 - module and param updates from Rusty Russell
 - kvm updates from Avi Kivity
 - a few more things for powerpc by Benjamin Herrenschmidt
 - dma-buf updates from Sumit Semwal
 - SLAB changes from Pekka Enberg
 - XFS update (part 2) from Ben Myers
 - "Disintegrate and delete asm/system.h" from David Howells
 - squashfs updates from Phillip Lougher
 - NFS client bugfixes for Linux 3.4 from Trond Myklebust
 - trivial exofs changes from Boaz Harrosh
 - MMC updates from Chris Ball
 - the intel i915 hibernation memory corruption fix from Dave Airlie
 - the code to generalize the powerpc VIRQ_DEBUG code from Grant Likely
 - timer core updates from Thomas Gleixner
 - x86 updates from Ingo Molnar
 - scheduler fixes from Ingo Molnar
 - arch/tile (really asm-generic) update from Chris Metcalf
 - nfsd changes from Bruce Fields
 - slave-dmaengine update from Vinod Koul
 - a few PCMCIA updates from Dominik Brodowski
 - cpupower updates from Dominik Brodowski
 - more ARM updates from Russell King
 - "ARM: cleanups of io includes" from Olof Johansson
 - x32 support for x86-64 from Ingo Molnar
 - x86 cleanups from Peter Anvin
 - devicetree documentation update from Grant Likely
 - arm-soc fixes from Olof Johansson
 - urgent cgroup fix from Tejun Heo
 - 2nd round of input updates from Dmitry Torokhov
 - SuperH updates from Paul Mundt
 - minor Sparc fixes from David Miller
 - s390 build fixes from Martin Schwidefsky
 - sound fixes from Takashi Iwai
 - btrfs fixes and features from Chris Mason
 - battery updates from Anton Vorontsov
 - cifs fixes from Steve French
 - ACPI & Power Management changes from Len Brown
 - a few more ARM platform fixes from Olof Johansson
 - MTD changes from David Woodhouse
 - core locking updates from Thomas Gleixner
 - genirq updates from Thomas Gleixner
 - kconfig bits from Michal Marek
 - non-critical part of kbuild from Michal Marek
 - kbuild changes from Michal Marek
 - Sam Ravnborg's sparc32 build fixes from David Miller
 - SCSI updates from James Bottomley
 - PARISC misc updates from James Bottomley
 - perf updates and fixes from Ingo Molnar
 - scheduler fixes from Ingo Molnar
 - second try at vfs part d#2 from Al Viro
 - virtio S3 support patches from Amit Shah
