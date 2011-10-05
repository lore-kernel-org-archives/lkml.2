Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab1JEBkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 21:40:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64836 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab1JEBkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 21:40:35 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Oct 2011 18:40:14 -0700
X-Google-Sender-Auth: 4tzVuUAEuUQNJ1Pv7RwSNjIXGuU
Message-ID: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
Subject: Linux 3.1-rc9
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

On the kernel front, not a huge amount of changes. That said, by now,
there had better not be - and I definitely wouldn't have minded having
even fewer changes. But the fixes that are here are generally pretty
small, and the diffstat really doesn't look all that scary - there
really aren't *big* changes anywhere.

The things that do stand out a bit: some DRM fixes (radeon and i915),
various network drivers, some ceph fixes - and just lots of random
small stuff. The sparc updates are tiny (T4/T5 detection), but even so
are the bulk of the arch changes, things really have been that quiet.

The more noticeable change isn't actually to the code at all, it's
that kernel.org is starting to have parts of it come up again, so you
can now find the kernel sources back in the traditional location:

    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

(although I am also updating github in case you cloned from there, so
you don't *have* to change).

Also, since I now have a new stronger gpg key, and that new key
actually ends up being signed by more people than the old one ever was
(at least people I *know*), I decided I might as well switch to that
one. So if you are the kind of person who verifies tags, you may want
to do

   gpg --recv-keys 00411886

to get my new key, so that "git verify-tag" will work for you.

(Key fingerprint = ABAF 11C6 5A29 70B1 30AB  E3C4 79BE 3E43 0041 1886)

Obviously, in order to trust that that is actually really my key
rather than just blindly believe this email that could easily have
been faked by some Linux wannabe), you'd need to check it. But since
it's signed with my old tag signing key, you shouldn't have any more
trust issues with the new one than you should have with the old key.
Or you can try to follow the chain of trust of the other key signers -
some of them have way more signatures than I ever had and are pretty
well connected.

Anything else worth mentioning? Hopefully the PCIe issues with MPS
tuning are all behind us, for the simple reason that we just disabled
them for now, and will revisit it for 3.2. And the occasional oopses
with USB disk removal should now be fixed once and for all (knock
wood). Anything else should be really esoteric and device-specific,
you can get a feel for it in the shortlog.

Go forth and test,

                     Linus

---

Alex Deucher (4):
      drm/radeon/kms: fix regression in DP aux defer handling
      drm/radeon/kms: add retry limits for native DP aux defer
      drm/radeon/kms: Fix logic error in DP HPD handler
      drm/radeon/kms: fix channel_remap setup (v2)

Andy Gospodarek (1):
      bonding: properly stop queuing work when requested

Antonio Quartulli (1):
      batman-adv: do_bcast has to be true for broadcast packets only

Archit Taneja (1):
      [media] OMAP_VOUT: Fix build break caused by update_mode removal in DSS2

Arnd Bergmann (2):
      ASoC: use a valid device for dev_err() in Zylonite
      ASoC: omap_mcpdm_remove cannot be __devexit

Axel Lin (1):
      ASoC: Fix setting update bits for WM8753_LADC and WM8753_RADC

Ben Greear (2):
      ipv6-multicast: Fix memory leak in input path.
      ipv6-multicast: Fix memory leak in IPv6 multicast.

Benjamin Herrenschmidt (1):
      powerpc: Fix device-tree matching for Apple U4 bridge

Borislav Petkov (1):
      ide-disk: Fix request requeuing

Brian King (1):
      ibmveth: Fix oops on request_irq failure

Carsten Otte (1):
      [S390] gmap: always up mmap_sem properly

Dave Young (1):
      [media] v4l: Make sure we hold a reference to the v4l2_device
before using it

David S. Miller (3):
      sparc64: Future proof Niagara cpu detection.
      sparc: Make '-p' boot option meaningful again.
      sparc64: Force the execute bit in OpenFirmware's translation entries.

David Vrabel (1):
      net: xen-netback: correctly restart Tx after a VM restore/migrate

Divy Le Ray (1):
      cxgb4: Fix EEH on IBM P7IOC

Dmitry Kravkov (2):
      bnx2x: fix hw attention handling
      bnx2x: fix WOL by enablement PME in config space

Guenter Roeck (1):
      hwmon: (coretemp) Avoid leaving around dangling pointer

Hannes Reinecke (1):
      block: Free queue resources at blk_release_queue()

Hans Verkuil (1):
      [media] v4l: Fix use-after-free case in v4l2_device_release

Ian Campbell (1):
      MAINTAINERS: tehuti: Alexander Indenbaum's address bounces

James Bottomley (1):
      [SCSI] 3w-9xxx: fix iommu_iova leak

Jason Wang (1):
      net: fix a typo in Documentation/networking/scaling.txt

Jean Delvare (1):
      hwmon: (coretemp) Fixup platform device ID change

Jim Schutt (1):
      libceph: initialize ack_stamp to avoid unnecessary connection reset

Jiri Olsa (1):
      perf tools: Fix raw sample reading

Joerg Roedel (1):
      [media] omap3isp: Fix build error in ispccdc.c

Johannes Berg (1):
      iwlagn: fix dangling scan request

Jon Mason (1):
      PCI: Disable MPS configuration by default

Jonathan Lallinger (1):
      RDSRDMA: Fix cleanup of rds_iw_mr_pool

Josef Bacik (1):
      Btrfs: force a page fault if we have a shorty copy on a page boundary

Jouni Malinen (1):
      cfg80211: Fix validation of AKM suites

Keith Packard (2):
      drm/i915: Enable dither whenever display bpc < frame buffer bpc
      drm/i915: FBC off for ironlake and older, otherwise on by default

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix unitialized struct

Lars-Peter Clausen (1):
      mfd: Fix generic irq chip ack function name for jz4740-adc

Laurent Pinchart (1):
      [media] uvcvideo: Fix crash when linking entities

Linus Torvalds (2):
      bootup: move 'usermodehelper_enable()' to the end of do_basic_setup()
      Linux 3.1-rc9

Madalin Bucur (2):
      net: check return value for dst_alloc
      ipv6: check return value for dst_alloc

Mark Salyzyn (1):
      [SCSI] libsas: fix failure to revalidate domain for anything but
the first expander child.

Martin Schwidefsky (1):
      [S390] Do not clobber personality flags on exec

Mathias Krause (1):
      sparc, exec: remove redundant addr_limit assignment

Matt Fleming (1):
      x86/rtc: Don't recursively acquire rtc_lock

Michel Dänzer (3):
      drm/radeon: Simplify cursor x/yorigin calculation.
      drm/radeon: Update AVIVO cursor coordinate origin before
x/yorigin calculation.
      drm/radeon: Set cursor x/y to 0 when x/yorigin > 0.

Ming Lei (1):
      [media] uvcvideo: Set alternate setting 0 on resume if the bus
has been reset

Mohammed Shafi Shajakhan (1):
      ath9k: Fix a dma warning/memory leak

Neil Horman (1):
      [SCSI] cxgb3i: convert cdev->l2opt to use rcu to prevent NULL dereference

Nicholas Miell (1):
      drm/radeon/kms: fix cursor image off-by-one error

Noah Watkins (1):
      libceph: fix parse options memory leak

Oliver Hartkopp (2):
      can bcm: fix tx_setup off-by-one errors
      can bcm: fix incomplete tx_setup fix

Peter Oberparleiter (1):
      [S390] cio: fix cio_tpi ignoring adapter interrupts

Peter Zijlstra (1):
      posix-cpu-timers: Cure SMP wobbles

Rajkumar Manoharan (1):
      ath9k_hw: Fix Rx DMA stuck for AR9003 chips

Ram Pai (1):
      Resource: fix wrong resource window calculation

Randy Dunlap (1):
      [SCSI] scsi: qla4xxx needs libiscsi.o

Richard Cochran (2):
      ptp: fix L2 event message recognition
      dp83640: reduce driver noise

Rob Herring (2):
      irq: Add declaration of irq_domain_simple_ops to irqdomain.h
      irq: Fix check for already initialized irq_domain in irq_domain_add

Roy.Li (1):
      net: Documentation: Fix type of variables

Sage Weil (3):
      libceph: fix linger request requeuing
      libceph: fix pg_temp mapping calculation
      libceph: fix pg_temp mapping update

Shawn Bohrer (1):
      sched/rt: Migrate equal priority tasks to available CPUs

Shmulik Ravid (1):
      bnx2x: add missing break in bnx2x_dcbnl_get_cap

Simon Farnsworth (1):
      drm/i915: Enable SDVO hotplug interrupts for HDMI and DVI

Simon Kirby (1):
      sched: Fix up wchan borkage

Stanislaw Gruszka (2):
      iwlegacy: fix command queue timeout
      iwlegacy: do not use interruptible waits

Takashi Iwai (2):
      ALSA: hda - Fix a regression of the position-buffer check
      lis3: fix regression of HP DriveGuard with 8bit chip

Tomoya MORINAGA (5):
      spi-topcliff-pch: add tx-memory clear after complete transmitting
      spi-topcliff-pch: Fix SSN Control issue
      spi-topcliff-pch: Fix CPU read complete condition issue
      spi-topcliff-pch: Add recovery processing in case FIFO overrun
error occurs
      spi-topcliff-pch: Fix overrun issue

Toshiharu Okada (2):
      pch_gbe: Fixed the issue on which PC was frozen when link was downed.
      pch_gbe: Fixed the issue on which a network freezes

Vasily Averin (1):
      [SCSI] aacraid: reset should disable MSI interrupt

Willem de Bruijn (1):
      make PACKET_STATISTICS getsockopt report consistently between
ring and non-ring

Wu Fengguang (1):
      writeback: show raw dirtied_when in trace writeback_single_inode

Yan, Zheng (1):
      ipv6: nullify ipv6_ac_list and ipv6_fl_list when creating new socket

wangyanqing (1):
      bootup: move 'usermodehelper_enable()' a little earlier
