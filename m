Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856Ab0ITVpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:45:41 -0400
Received: from kroah.org ([198.145.64.141]:45341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805Ab0ITVpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:45:31 -0400
Date: Mon, 20 Sep 2010 14:41:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.22
Message-ID: <20100920214133.GC26264@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.22 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 arch/arm/kernel/entry-common.S          |    2 
 arch/ia64/include/asm/compat.h          |    2 
 arch/ia64/kernel/msi_ia64.c             |    2 
 arch/ia64/sn/kernel/msi_sn.c            |    2 
 arch/mips/include/asm/compat.h          |    2 
 arch/parisc/include/asm/compat.h        |    2 
 arch/powerpc/include/asm/compat.h       |    2 
 arch/s390/include/asm/compat.h          |    2 
 arch/sparc/include/asm/compat.h         |    2 
 arch/x86/ia32/ia32entry.S               |   22 -
 arch/x86/include/asm/compat.h           |    2 
 arch/x86/include/asm/tsc.h              |    2 
 arch/x86/kernel/apic/io_apic.c          |    2 
 arch/x86/kernel/tsc.c                   |   38 ++
 arch/x86/oprofile/nmi_int.c             |   22 +
 arch/x86/power/cpu.c                    |    2 
 drivers/ata/libata-core.c               |   14 
 drivers/ata/libata-eh.c                 |    4 
 drivers/ata/sata_mv.c                   |   44 ++
 drivers/gpu/drm/drm_crtc_helper.c       |    4 
 drivers/gpu/drm/i915/i915_dma.c         |   12 
 drivers/gpu/drm/i915/i915_gem.c         |    1 
 drivers/gpu/drm/i915/intel_display.c    |    5 
 drivers/hid/usbhid/hid-core.c           |   18 -
 drivers/hwmon/f75375s.c                 |    6 
 drivers/hwmon/k8temp.c                  |   35 ++
 drivers/input/serio/i8042.c             |    2 
 drivers/mmc/host/tmio_mmc.c             |    7 
 drivers/mmc/host/tmio_mmc.h             |   13 
 drivers/net/tun.c                       |    3 
 drivers/net/wireless/ath/ath5k/base.c   |    4 
 drivers/net/wireless/ath/ath9k/eeprom.h |    2 
 drivers/net/wireless/ath/regd.h         |    1 
 drivers/net/wireless/p54/txrx.c         |    2 
 drivers/oprofile/buffer_sync.c          |   27 -
 drivers/oprofile/cpu_buffer.c           |    2 
 drivers/pci/msi.c                       |   27 +
 drivers/power/apm_power.c               |    1 
 drivers/staging/hv/RingBuffer.c         |    2 
 drivers/staging/hv/StorVscApi.h         |    4 
 drivers/staging/hv/netvsc_drv.c         |    3 
 drivers/staging/hv/storvsc_drv.c        |    9 
 drivers/usb/class/cdc-acm.c             |   85 +++++
 drivers/usb/gadget/rndis.c              |   10 
 drivers/usb/host/ehci-ppc-of.c          |   12 
 drivers/usb/serial/cp210x.c             |   10 
 drivers/usb/serial/ftdi_sio.c           |    8 
 drivers/usb/serial/ftdi_sio_ids.h       |   12 
 drivers/usb/serial/mos7840.c            |   55 ++-
 drivers/xen/events.c                    |   21 +
 fs/binfmt_misc.c                        |    2 
 fs/fuse/dev.c                           |   16 -
 fs/nfs/client.c                         |    2 
 fs/ocfs2/inode.c                        |    6 
 fs/sysfs/file.c                         |    2 
 include/linux/compat.h                  |    2 
 include/linux/cpuset.h                  |   16 -
 include/linux/libata.h                  |    1 
 include/linux/msi.h                     |    2 
 include/linux/sched.h                   |   20 -
 include/linux/topology.h                |    2 
 kernel/compat.c                         |   22 +
 kernel/cpu.c                            |   44 --
 kernel/cpuset.c                         |   67 ++--
 kernel/fork.c                           |   15 
 kernel/gcov/fs.c                        |  244 +++++++++++-----
 kernel/groups.c                         |    5 
 kernel/sched.c                          |  485 ++++++++++++++++++--------------
 kernel/sched_debug.c                    |    2 
 kernel/sched_fair.c                     |  210 +++++++++----
 kernel/sched_idletask.c                 |    5 
 kernel/sched_rt.c                       |   33 +-
 kernel/trace/ftrace.c                   |   19 -
 mm/bounce.c                             |    2 
 mm/memory_hotplug.c                     |   16 -
 net/irda/irlan/irlan_common.c           |    2 
 net/sunrpc/auth_gss/auth_gss.c          |    9 
 net/sunrpc/rpc_pipe.c                   |    6 
 net/wireless/wext-compat.c              |    3 
 net/wireless/wext.c                     |   16 +
 sound/core/seq/oss/seq_oss_init.c       |    9 
 sound/pci/hda/patch_realtek.c           |    9 
 tools/perf/util/callchain.h             |    1 
 84 files changed, 1252 insertions(+), 618 deletions(-)

Adrian Taylor (1):
      USB: Exposing second ACM channel as tty for Nokia S60 phones.

Al Viro (1):
      arm: fix really nasty sigreturn bug

Alan Stern (1):
      HID: fix suspend crash by moving initializations earlier

Amit Arora (1):
      sched: kill migration thread in CPU_POST_DEAD instead of CPU_DEAD

Andreas Herrmann (1):
      hwmon: (k8temp) Differentiate between AM2 and ASB1

Anton Blanchard (1):
      sched: cpuacct: Use bigger percpu counter batch values for stats counters

Anton Vorontsov (1):
      apm_power: Add missing break statement

Ben Hutchings (3):
      PCI: MSI: Remove unsafe and unnecessary hardware access
      PCI: MSI: Restore read_msi_msg_desc(); add get_cached_msi_msg_desc()
      tun: Don't add sysfs attributes to devices without sysfs directories

Blaise Gassend (1):
      USB: serial: Extra device/vendor ID for mos7840 driver

Chris Wilson (2):
      drm/i915: Prevent double dpms on
      drm: Only decouple the old_fb from the crtc is we call mode_set*

Chris Wright (1):
      tracing: t_start: reset FTRACE_ITER_HASH in case of seek/pread

Christian Lamparter (1):
      p54: fix tx feedback status flag check

Craig Shelley (1):
      USB: CP210x Add new device ID

Dan Carpenter (5):
      USB: ehci-ppc-of: problems in unwind
      sysfs: checking for NULL instead of ERR_PTR
      irda: off by one
      i915: return -EFAULT if copy_to_user fails
      i915_gem: return -EFAULT if copy_to_user fails

Daniel J Blueman (1):
      sched: apply RCU protection to wake_affine()

Dave Ludlow (2):
      usb: serial: mos7840: Add USB ID to support the B&B Electronics USOPTL4-2P.
      usb: serial: mos7840: Add USB IDs to support more B&B USB/RS485 converters.

David Henningsson (1):
      ALSA: hda - Rename iMic to Int Mic on Lenovo NB0763

Dmitry Torokhov (1):
      Input: i8042 - fix device removal on unload

Frederic Weisbecker (1):
      perf: Initialize callchains roots's childen hits

Gary King (1):
      bounce: call flush_dcache_page() after bounce_copy_vec()

Greg Kroah-Hartman (1):
      Linux 2.6.32.22

Guennadi Liakhovetski (1):
      mmc: fix the use of kunmap_atomic() in tmio_mmc.h

Guillem Jover (2):
      hwmon: (f75375s) Shift control mode to the correct bit position
      hwmon: (f75375s) Do not overwrite values read from registers

H. Peter Anvin (2):
      x86-64, compat: Test %rax for the syscall number, not %eax
      compat: Make compat_alloc_user_space() incorporate the access_ok()

Haiyang Zhang (2):
      staging: hv: Fix missing functions for net_device_ops
      staging: hv: Fixed the value of the 64bit-hole inside ring buffer

Hank Janssen (3):
      staging: hv: Fixed bounce kmap problem by using correct index
      staging: hv: Increased storvsc ringbuffer and max_io_requests
      staging: hv: Fixed lockup problem with bounce_buffer scatter list

Hiroshi Shimamoto (1):
      sched: Remove unused cpu_nr_migrations()

Ingo Molnar (2):
      sched: Remove forced2_migrations stats
      sched: Make warning less noisy

Jan Sembera (1):
      binfmt_misc: fix binfmt_misc priority

Jason Detring (1):
      USB: cp210x: Add B&G H3000 link cable ID

Jeremy Fitzhardinge (2):
      xen: handle events as edge-triggered
      xen: use percpu interrupts for IPIs and VIRQs

Jerome Marchand (1):
      kernel/groups.c: fix integer overflow in groups_search

Jiri Kosina (1):
      HID: usbhid: initialize interface pointers early enough

Johan Hovold (1):
      USB: mos7840: fix DMA buffers on stack and endianess bugs

Johannes Berg (1):
      wireless extensions: fix kernel heap content leak

John W. Linville (1):
      ath5k: check return value of ieee80211_get_tx_rate

KAMEZAWA Hiroyuki (1):
      memory hotplug: fix next block calculation in is_removable

Kailang Yang (1):
      ALSA: hda - Fix auto-parser of ALC269vb for HP pin NID 0x21

Li Zefan (1):
      tracing: Fix a race in function profile

Luis R. Rodriguez (1):
      ath9k_hw: fix parsing of HT40 5 GHz CTLs

Luke Lowrey (1):
      USB: ftdi_sio: Added custom PIDs for ChamSys products

Mark Lord (1):
      sata_mv: fix broken DSM/TRIM support (v2)

Maxim Osipov (1):
      USB: Fix kernel oops with g_ether and Windows

Mike Galbraith (3):
      sched: revert stable c6fc81a sched: Fix a race between ttwu() and migrate_task()
      sched: Fix vmark regression on big machines
      sched: Fix select_idle_sibling()

Miklos Szeredi (1):
      fuse: flush background queue on connection close

Oleg Nesterov (7):
      sched: set_cpus_allowed_ptr(): Don't use rq->migration_thread after unlock
      sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code
      sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()
      sched: move_task_off_dead_cpu(): Remove retry logic
      sched: sched_exec(): Remove the select_fallback_rq() logic
      sched: _cpu_down(): Don't play with current->cpus_allowed
      sched: Make select_fallback_rq() cpuset friendly

Peter Oberparleiter (1):
      gcov: fix null-pointer dereference for certain module types

Peter Zijlstra (24):
      x86, tsc: Fix a preemption leak in restore_sched_clock_state()
      sched: Consolidate select_task_rq() callers
      sched: Remove rq->clock coupling from set_task_cpu()
      sched: Clean up ttwu() rq locking
      sched: Sanitize fork() handling
      sched: Use TASK_WAKING for fork wakups
      sched: Ensure set_task_cpu() is never called on blocked tasks
      sched: Fix broken assertion
      sched: Fix sched_exec() balancing
      sched: Fix select_task_rq() vs hotplug issues
      sched: Add pre and post wakeup hooks
      sched: Remove the cfs_rq dependency from set_task_cpu()
      sched: Fix hotplug hang
      sched: Fix fork vs hotplug vs cpuset namespaces
      sched: Fix incorrect sanity check
      sched: Fix race between ttwu() and task_rq_lock()
      sched: Fix TASK_WAKING vs fork deadlock
      sched: Optimize task_rq_lock()
      sched: Fix nr_uninterruptible count
      sched: Fix rq->clock synchronization when migrating tasks
      sched: Remove unnecessary RCU exclusion
      sched: Cleanup select_task_rq_fair()
      sched: More generic WAKE_AFFINE vs select_idle_sibling()
      sched: Pre-compute cpumask_weight(sched_domain_span(sd))

Philippe Corbes (1):
      USB: cdc-acm: Add pseudo modem without AT command capabilities

Przemo Firszt (1):
      USB: Expose vendor-specific ACM channel on Nokia 5230

Rafael J.Wysocki (1):
      sched: Make wakeup side and atomic variants of completion API irq safe

Robert Richter (3):
      oprofile: fix crash when accessing freed task structs
      oprofile, x86: fix init_sysfs error handling
      oprofile, x86: fix init_sysfs() function stub

Roland McGrath (1):
      x86-64, compat: Retruncate rax after ia32 syscall entry tracing

Russ Nelson (1):
      USB: cdc-acm: add another device quirk

Steven Rostedt (1):
      tracing: Do not allow llseek to set_ftrace_filter

Sunil Mushran (1):
      ocfs2: Fix incorrect checksum validation error

Suresh Siddha (2):
      x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep states
      sched: Fix select_idle_sibling() logic in select_task_rq_fair()

Takashi Iwai (3):
      ALSA: seq/oss - Fix double-free at error path of snd_seq_oss_open()
      ALSA: hda - Handle missing NID 0x1b on ALC259 codec
      ALSA: hda - Handle pin NID 0x1a on ALC259/269

Tejun Heo (1):
      libata: skip EH autopsy and recovery during suspend

Thomas Gleixner (8):
      sched: Protect task->cpus_allowed access in sched_getaffinity()
      sched: Protect sched_rr_get_param() access to task->sched_class
      sched: Use rcu in sys_sched_getscheduler/sys_sched_getparam()
      sched: Use rcu in sched_get/set_affinity()
      sched: Use rcu in sched_get_rr_param()
      sched: Extend enqueue_task to allow head queueing
      sched: Implement head queueing for sched_rt
      sched: Queue a deboosted task to the head of the RT prio queue

Toby Gray (2):
      USB: cdc-acm: Adding second ACM channel support for various Nokia and one Samsung phones
      USB: cdc-acm: Fixing crash when ACM probing interfaces with no endpoint descriptors.

Trond Myklebust (2):
      NFS: Fix a typo in nfs_sockaddr_match_ipaddr6
      SUNRPC: Fix race corrupting rpc upcall

Xiaotian Feng (1):
      sched: Fix set_cpu_active() in cpu_down()

Yusuke Goda (1):
      tmio_mmc: don't clear unhandled pending interrupts

