Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab0KQP1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:27:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab0KQP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:27:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/7] BKL: remove extraneous #include <smp_lock.h>
Date: Wed, 17 Nov 2010 16:26:55 +0100
Message-Id: <1290007619-5787-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290007619-5787-1-git-send-email-arnd@arndb.de>
References: <1290007619-5787-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WvalZCwNKThbzM/px1zLtPK9B449VcqYv3GczfM71Kb
 8s9z7/mIsRtFhUB05+EqnNJLfStwMxUukfjsJDdDzZGKwJZlvC
 VqoCqtnBXSBZPzUgUMbgaJURBOLm8KHYvpLP2rgPwCOTHwll6c
 jB3v6jSHkyK59ZVvjpeRgIyNULEsEz0xkvOXWgCD2QJUBhtDiP
 i44RG5Rbi+sHojlc0d9gQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big kernel lock has been removed from all these
files at some point, leaving only the #include.
Remove this too as a cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/blackfin/kernel/process.c                     |    1 -
 arch/frv/kernel/process.c                          |    1 -
 arch/h8300/kernel/process.c                        |    1 -
 arch/m68k/kernel/process.c                         |    1 -
 arch/m68knommu/kernel/process.c                    |    1 -
 arch/mn10300/kernel/process.c                      |    1 -
 arch/parisc/hpux/sys_hpux.c                        |    1 -
 arch/parisc/kernel/sys_parisc32.c                  |    1 -
 arch/powerpc/kernel/sys_ppc32.c                    |    1 -
 arch/s390/kernel/compat_linux.c                    |    1 -
 arch/sparc/kernel/leon_smp.c                       |    1 -
 arch/sparc/kernel/sys_sparc32.c                    |    1 -
 arch/sparc/kernel/sys_sparc_32.c                   |    1 -
 arch/sparc/kernel/unaligned_32.c                   |    1 -
 arch/sparc/kernel/windows.c                        |    1 -
 arch/tile/kernel/compat.c                          |    1 -
 arch/tile/kernel/compat_signal.c                   |    1 -
 arch/tile/kernel/signal.c                          |    1 -
 arch/tile/kernel/smpboot.c                         |    1 -
 arch/tile/kernel/sys.c                             |    1 -
 arch/tile/mm/fault.c                               |    1 -
 arch/tile/mm/hugetlbpage.c                         |    1 -
 arch/um/kernel/exec.c                              |    1 -
 arch/x86/ia32/sys_ia32.c                           |    1 -
 arch/x86/kernel/cpuid.c                            |    1 -
 arch/x86/kernel/msr.c                              |    1 -
 block/compat_ioctl.c                               |    1 -
 block/ioctl.c                                      |    1 -
 drivers/block/drbd/drbd_receiver.c                 |    1 -
 drivers/block/drbd/drbd_worker.c                   |    1 -
 drivers/char/agp/frontend.c                        |    1 -
 drivers/char/amiserial.c                           |    1 -
 drivers/char/briq_panel.c                          |    1 -
 drivers/char/hpet.c                                |    1 -
 drivers/char/hw_random/core.c                      |    1 -
 drivers/char/istallion.c                           |    1 -
 drivers/char/serial167.c                           |    1 -
 drivers/char/specialix.c                           |    1 -
 drivers/char/stallion.c                            |    1 -
 drivers/char/sx.c                                  |    1 -
 drivers/char/uv_mmtimer.c                          |    1 -
 drivers/gpu/drm/drm_fops.c                         |    1 -
 drivers/hid/hidraw.c                               |    1 -
 drivers/hid/usbhid/hiddev.c                        |    1 -
 drivers/infiniband/hw/ipath/ipath_file_ops.c       |    1 -
 drivers/input/input.c                              |    1 -
 drivers/input/serio/serio_raw.c                    |    1 -
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c        |    1 -
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    1 -
 drivers/media/dvb/ngene/ngene-core.c               |    1 -
 drivers/media/dvb/ngene/ngene-dvb.c                |    1 -
 drivers/media/dvb/ngene/ngene-i2c.c                |    1 -
 drivers/media/radio/radio-mr800.c                  |    1 -
 drivers/media/radio/si470x/radio-si470x.h          |    1 -
 drivers/media/video/bt8xx/bttv-driver.c            |    1 -
 drivers/media/video/cx88/cx88-blackbird.c          |    1 -
 drivers/media/video/cx88/cx88-video.c              |    1 -
 drivers/media/video/pwc/pwc-if.c                   |    1 -
 drivers/media/video/s2255drv.c                     |    1 -
 drivers/media/video/saa7134/saa7134-empress.c      |    1 -
 drivers/media/video/saa7164/saa7164.h              |    1 -
 drivers/media/video/usbvision/usbvision-video.c    |    1 -
 drivers/media/video/v4l2-compat-ioctl32.c          |    1 -
 drivers/net/wireless/orinoco/orinoco_usb.c         |    1 -
 drivers/parisc/eisa_eeprom.c                       |    1 -
 drivers/pci/proc.c                                 |    1 -
 drivers/pnp/isapnp/proc.c                          |    1 -
 drivers/s390/block/dasd_eer.c                      |    1 -
 drivers/s390/char/fs3270.c                         |    1 -
 drivers/s390/char/tape_char.c                      |    1 -
 drivers/s390/char/vmlogrdr.c                       |    1 -
 drivers/s390/char/vmur.c                           |    1 -
 drivers/s390/crypto/zcrypt_api.c                   |    1 -
 drivers/scsi/hpsa.c                                |    1 -
 drivers/scsi/pm8001/pm8001_sas.h                   |    1 -
 drivers/scsi/sd.c                                  |    1 -
 drivers/serial/crisv10.c                           |    1 -
 drivers/serial/serial_core.c                       |    1 -
 drivers/staging/cx25821/cx25821.h                  |    1 -
 drivers/staging/easycap/easycap.h                  |    1 -
 .../staging/intel_sst/intel_sst_app_interface.c    |    1 -
 drivers/staging/rtl8712/osdep_service.h            |    1 -
 drivers/staging/speakup/buffers.c                  |    1 -
 drivers/usb/core/devices.c                         |    1 -
 drivers/usb/core/devio.c                           |    1 -
 drivers/usb/core/file.c                            |    1 -
 drivers/usb/core/inode.c                           |    1 -
 drivers/usb/gadget/f_fs.c                          |    1 -
 drivers/usb/gadget/f_hid.c                         |    1 -
 drivers/usb/host/isp1362-hcd.c                     |    1 -
 drivers/usb/host/uhci-debug.c                      |    1 -
 drivers/usb/mon/mon_bin.c                          |    1 -
 drivers/usb/mon/mon_stat.c                         |    1 -
 drivers/usb/serial/usb-serial.c                    |    1 -
 drivers/video/console/vgacon.c                     |    1 -
 drivers/xen/xenfs/privcmd.c                        |    1 -
 drivers/zorro/proc.c                               |    1 -
 fs/block_dev.c                                     |    1 -
 fs/ceph/inode.c                                    |    1 -
 fs/ceph/mds_client.c                               |    1 -
 fs/compat_ioctl.c                                  |    1 -
 fs/ecryptfs/super.c                                |    1 -
 fs/ext3/super.c                                    |    1 -
 fs/ioctl.c                                         |    1 -
 fs/lockd/clntlock.c                                |    1 -
 fs/lockd/clntproc.c                                |    1 -
 fs/lockd/svc4proc.c                                |    1 -
 fs/lockd/svclock.c                                 |    1 -
 fs/lockd/svcproc.c                                 |    1 -
 fs/locks.c                                         |    1 -
 fs/namespace.c                                     |    1 -
 fs/ncpfs/dir.c                                     |    1 -
 fs/ncpfs/file.c                                    |    1 -
 fs/ncpfs/inode.c                                   |    1 -
 fs/ncpfs/ioctl.c                                   |    1 -
 fs/nfs/callback.c                                  |    1 -
 fs/nfs/delegation.c                                |    1 -
 fs/nfs/super.c                                     |    1 -
 fs/ocfs2/super.c                                   |    1 -
 fs/proc/inode.c                                    |    1 -
 fs/read_write.c                                    |    1 -
 fs/reiserfs/inode.c                                |    1 -
 fs/reiserfs/ioctl.c                                |    1 -
 fs/reiserfs/journal.c                              |    1 -
 fs/reiserfs/super.c                                |    1 -
 include/linux/hardirq.h                            |    1 -
 include/linux/reiserfs_fs.h                        |    1 -
 include/linux/tty.h                                |    1 -
 init/main.c                                        |    1 -
 kernel/trace/trace.c                               |    1 -
 net/irda/af_irda.c                                 |    1 -
 net/irda/irnet/irnet_ppp.c                         |    1 -
 net/sunrpc/svc_xprt.c                              |    1 -
 sound/core/info.c                                  |    1 -
 sound/core/pcm_native.c                            |    1 -
 sound/core/sound.c                                 |    1 -
 sound/sound_core.c                                 |    1 -
 137 files changed, 0 insertions(+), 137 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index cd0c090..b407bc8 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/unistd.h>
 #include <linux/user.h>
 #include <linux/uaccess.h>
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 2b63b01..efad120 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 9747813..933bd38 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 18732ab..c2a1fc2 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 6d33905..e2a63af 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -19,7 +19,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 0d0f804..e1b14a6 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -14,7 +14,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/stddef.h>
 #include <linux/unistd.h>
 #include <linux/ptrace.h>
diff --git a/arch/parisc/hpux/sys_hpux.c b/arch/parisc/hpux/sys_hpux.c
index ba430a0..3039408 100644
--- a/arch/parisc/hpux/sys_hpux.c
+++ b/arch/parisc/hpux/sys_hpux.c
@@ -28,7 +28,6 @@
 #include <linux/namei.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/utsname.h>
 #include <linux/vfs.h>
diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index 9779ece..88a0ad1 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -20,7 +20,6 @@
 #include <linux/times.h>
 #include <linux/time.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index b1b6043..4e5bf1e 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -23,7 +23,6 @@
 #include <linux/resource.h>
 #include <linux/times.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 1e6449c..53acaa8 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -25,7 +25,6 @@
 #include <linux/resource.h>
 #include <linux/times.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index 7524689..16582d8 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -12,7 +12,6 @@
 #include <linux/sched.h>
 #include <linux/threads.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/init.h>
diff --git a/arch/sparc/kernel/sys_sparc32.c b/arch/sparc/kernel/sys_sparc32.c
index e6375a7..6db18c6 100644
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -17,7 +17,6 @@
 #include <linux/resource.h>
 #include <linux/times.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/sem.h>
 #include <linux/msg.h>
 #include <linux/shm.h>
diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index 675c9e1..42b282f 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -19,7 +19,6 @@
 #include <linux/mman.h>
 #include <linux/utsname.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/ipc.h>
 
 #include <asm/uaccess.h>
diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
index 12b9f35..4491f4c 100644
--- a/arch/sparc/kernel/unaligned_32.c
+++ b/arch/sparc/kernel/unaligned_32.c
@@ -16,7 +16,6 @@
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/perf_event.h>
 
 enum direction {
diff --git a/arch/sparc/kernel/windows.c b/arch/sparc/kernel/windows.c
index b351770..3107381 100644
--- a/arch/sparc/kernel/windows.c
+++ b/arch/sparc/kernel/windows.c
@@ -9,7 +9,6 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index 77739cd..773071f 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -21,7 +21,6 @@
 #include <linux/kdev_t.h>
 #include <linux/fs.h>
 #include <linux/fcntl.h>
-#include <linux/smp_lock.h>
 #include <linux/uaccess.h>
 #include <linux/signal.h>
 #include <asm/syscalls.h>
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index fb64b99..543d6a3 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index fb28e85..fccb75f 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
 #include <linux/errno.h>
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index 74d62d0..b949edc 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -18,7 +18,6 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/kernel_stat.h>
-#include <linux/smp_lock.h>
 #include <linux/bootmem.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index 7e76466..e2187d2 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index f295b4a..dcebfc8 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -24,7 +24,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/tty.h>
diff --git a/arch/tile/mm/hugetlbpage.c b/arch/tile/mm/hugetlbpage.c
index 24688b6..201a582 100644
--- a/arch/tile/mm/hugetlbpage.c
+++ b/arch/tile/mm/hugetlbpage.c
@@ -21,7 +21,6 @@
 #include <linux/mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/sysctl.h>
diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index 340268b..09bd7b5 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -5,7 +5,6 @@
 
 #include "linux/stddef.h"
 #include "linux/fs.h"
-#include "linux/smp_lock.h"
 #include "linux/ptrace.h"
 #include "linux/sched.h"
 #include "linux/slab.h"
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 849813f..5852519 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -28,7 +28,6 @@
 #include <linux/syscalls.h>
 #include <linux/times.h>
 #include <linux/utsname.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/poll.h>
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 1b7b31a..212a6a4 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -33,7 +33,6 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/device.h>
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7bf2dc4..12fcbe2 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -30,7 +30,6 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/device.h>
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 119f07b..cae88e3 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -8,7 +8,6 @@
 #include <linux/hdreg.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
 
diff --git a/block/ioctl.c b/block/ioctl.c
index d724ceb..706f519 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -5,7 +5,6 @@
 #include <linux/hdreg.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h>
 #include <linux/blktrace_api.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index efd6169..16ea0ea 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -36,7 +36,6 @@
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/pkt_sched.h>
 #define __KERNEL_SYSCALLS__
 #include <linux/unistd.h>
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 108d580..cb7a89c 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/drbd.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/memcontrol.h>
diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 43412c0..3cb4539 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -39,7 +39,6 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include "agp.h"
diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index b0a7046..3ec98c5 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -81,7 +81,6 @@ static char *serial_version = "4.30";
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
diff --git a/drivers/char/briq_panel.c b/drivers/char/briq_panel.c
index f6718f0..095ab90 100644
--- a/drivers/char/briq_panel.c
+++ b/drivers/char/briq_panel.c
@@ -6,7 +6,6 @@
 
 #include <linux/module.h>
 
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 55b8667..7066e80 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -14,7 +14,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
 #include <linux/major.h>
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 788da05..2016aad 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -37,7 +37,6 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 667abd2..7c6de4c 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -21,7 +21,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index f646725..748c3b0 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -52,7 +52,6 @@
 #include <linux/interrupt.h>
 #include <linux/serial.h>
 #include <linux/serialP.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/ptrace.h>
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 9f8495b..a7616d2 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -87,7 +87,6 @@
 #include <linux/tty_flip.h>
 #include <linux/mm.h>
 #include <linux/serial.h>
-#include <linux/smp_lock.h>
 #include <linux/fcntl.h>
 #include <linux/major.h>
 #include <linux/delay.h>
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 4bef6ab..461a5a0 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -40,7 +40,6 @@
 #include <linux/stallion.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index e53f168..a786326 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -216,7 +216,6 @@
 #include <linux/eisa.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/bitops.h>
diff --git a/drivers/char/uv_mmtimer.c b/drivers/char/uv_mmtimer.c
index 493b47a..956ebe2 100644
--- a/drivers/char/uv_mmtimer.c
+++ b/drivers/char/uv_mmtimer.c
@@ -23,7 +23,6 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/math64.h>
-#include <linux/smp_lock.h>
 
 #include <asm/genapic.h>
 #include <asm/uv/uv_hub.h>
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index b744dad..a39794b 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -37,7 +37,6 @@
 #include "drmP.h"
 #include <linux/poll.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 /* from BKL pushdown: note that nothing else serializes idr_find() */
 DEFINE_MUTEX(drm_global_mutex);
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 8a4b32d..e1f0748 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -32,7 +32,6 @@
 #include <linux/hid.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 
 #include <linux/hidraw.h>
 
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index fedd88d..984feb3 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/input.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 6078992..9292a15 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -40,7 +40,6 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
-#include <linux/smp_lock.h>
 #include <asm/pgtable.h>
 
 #include "ipath_kernel.h"
diff --git a/drivers/input/input.c b/drivers/input/input.c
index d092ef9..19c21c2 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -24,7 +24,6 @@
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
-#include <linux/smp_lock.h>
 #include "input-compat.h"
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index cd82bb1..b7ba459 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -11,7 +11,6 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/module.h>
 #include <linux/serio.h>
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index 4d0646d..7ea517b 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -36,7 +36,6 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 
 #include "dvb_ca_en50221.h"
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 1589d5a..cad6634 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -36,7 +36,6 @@
 #include <linux/list.h>
 #include <linux/freezer.h>
 #include <linux/jiffies.h>
-#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 #include <asm/processor.h>
 
diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index 4caeb16..3a7ef71 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -34,7 +34,6 @@
 #include <linux/io.h>
 #include <asm/div64.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/byteorder/generic.h>
 #include <linux/firmware.h>
diff --git a/drivers/media/dvb/ngene/ngene-dvb.c b/drivers/media/dvb/ngene/ngene-dvb.c
index 48f980b..3832e59 100644
--- a/drivers/media/dvb/ngene/ngene-dvb.c
+++ b/drivers/media/dvb/ngene/ngene-dvb.c
@@ -35,7 +35,6 @@
 #include <linux/io.h>
 #include <asm/div64.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/byteorder/generic.h>
 #include <linux/firmware.h>
diff --git a/drivers/media/dvb/ngene/ngene-i2c.c b/drivers/media/dvb/ngene/ngene-i2c.c
index c3ae956..d28554f 100644
--- a/drivers/media/dvb/ngene/ngene-i2c.c
+++ b/drivers/media/dvb/ngene/ngene-i2c.c
@@ -37,7 +37,6 @@
 #include <asm/div64.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
-#include <linux/smp_lock.h>
 #include <linux/timer.h>
 #include <linux/byteorder/generic.h>
 #include <linux/firmware.h>
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index b540e80..e6b2d08 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -58,7 +58,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/input.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index ea12782..b9914d7 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -31,7 +31,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/input.h>
 #include <linux/version.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 3da6e80..a529619 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -42,7 +42,6 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/kdev_t.h>
 #include "bttvp.h"
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 417d1d5..d7c9484 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -33,7 +33,6 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
-#include <linux/smp_lock.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/cx2341x.h>
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index d2f159d..88b5119 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -31,7 +31,6 @@
 #include <linux/kmod.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index e62beb4..f3dc89d 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -62,7 +62,6 @@
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #ifdef CONFIG_USB_PWC_INPUT_EVDEV
 #include <linux/usb/input.h>
 #endif
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index f5a46c4..a845753 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -49,7 +49,6 @@
 #include <linux/videodev2.h>
 #include <linux/version.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 1467a30..b890aaf 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -21,7 +21,6 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/delay.h>
 
 #include "saa7134-reg.h"
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index 1d9c5cb..041ae8e 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -58,7 +58,6 @@
 #include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/videobuf-dvb.h>
-#include <linux/smp_lock.h>
 #include <dvb_demux.h>
 #include <dvb_frontend.h>
 #include <dvb_net.h>
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index db6b828..011c0c3 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -50,7 +50,6 @@
 #include <linux/list.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 86294ed..e30e8df 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -18,7 +18,6 @@
 #include <linux/videodev.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <media/v4l2-ioctl.h>
 
 #ifdef CONFIG_COMPAT
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index a38a7bd..b9aedf1 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -57,7 +57,6 @@
 #include <linux/fcntl.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <linux/timer.h>
 
diff --git a/drivers/parisc/eisa_eeprom.c b/drivers/parisc/eisa_eeprom.c
index cce00ed..af212c6 100644
--- a/drivers/parisc/eisa_eeprom.c
+++ b/drivers/parisc/eisa_eeprom.c
@@ -24,7 +24,6 @@
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 297b72c..f21f15d 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/capability.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index e73ebef..315b311 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -21,7 +21,6 @@
 #include <linux/isapnp.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 extern struct pnp_protocol isapnp_protocol;
diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index c71d89d..83b4615 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -17,7 +17,6 @@
 #include <linux/device.h>
 #include <linux/poll.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index eb28fb0..f6489eb 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -14,7 +14,6 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 
 #include <asm/compat.h>
 #include <asm/ccwdev.h>
diff --git a/drivers/s390/char/tape_char.c b/drivers/s390/char/tape_char.c
index 883e2db..e090a30 100644
--- a/drivers/s390/char/tape_char.c
+++ b/drivers/s390/char/tape_char.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 #include <linux/mtio.h>
-#include <linux/smp_lock.h>
 #include <linux/compat.h>
 
 #include <asm/uaccess.h>
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index 9f66142..966e5df 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -30,7 +30,6 @@
 #include <linux/kmod.h>
 #include <linux/cdev.h>
 #include <linux/device.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 
 MODULE_AUTHOR
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index 1de672f..f7e4ae6 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -13,7 +13,6 @@
 
 #include <linux/cdev.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/cio.h>
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index f522174..7fca9c1 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -35,7 +35,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/compat.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c5d0606..7ed5e8e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -31,7 +31,6 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/compat.h>
 #include <linux/blktrace_api.h>
 #include <linux/uaccess.h>
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 8e38ca8..7f064f9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -50,7 +50,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
 #include <scsi/libsas.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b9ab3a5..9564961 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -46,7 +46,6 @@
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 #include <linux/async.h>
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index fa62578..bcc31f2 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -18,7 +18,6 @@ static char *serial_version = "$Revision: 1.25 $";
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/major.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index c4ea146..9ffa5be 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -29,7 +29,6 @@
 #include <linux/console.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/device.h>
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/serial_core.h>
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index c940001..acfd017 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -31,7 +31,6 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/kdev_t.h>
-#include <linux/smp_lock.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/staging/easycap/easycap.h b/drivers/staging/easycap/easycap.h
index f3c827e..25961c2 100644
--- a/drivers/staging/easycap/easycap.h
+++ b/drivers/staging/easycap/easycap.h
@@ -77,7 +77,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
-#include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <linux/uaccess.h>
 
diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index 463e5cb..b19da14 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -34,7 +34,6 @@
 #include <linux/uaccess.h>
 #include <linux/firmware.h>
 #include <linux/ioctl.h>
-#include <linux/smp_lock.h>
 #ifdef CONFIG_MRST_RAR_HANDLER
 #include <linux/rar_register.h>
 #include "../../../drivers/staging/memrar/memrar.h"
diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index d1674cd..831d81e 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/kref.h>
-#include <linux/smp_lock.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/speakup/buffers.c b/drivers/staging/speakup/buffers.c
index b7b60d5..a2db956 100644
--- a/drivers/staging/speakup/buffers.c
+++ b/drivers/staging/speakup/buffers.c
@@ -1,5 +1,4 @@
 #include <linux/console.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
 
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index ddb4dc9..a3d2e23 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -54,7 +54,6 @@
 #include <linux/gfp.h>
 #include <linux/poll.h>
 #include <linux/usb.h>
-#include <linux/smp_lock.h>
 #include <linux/usbdevice_fs.h>
 #include <linux/usb/hcd.h>
 #include <linux/mutex.h>
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index f1aaff6..f986852 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -37,7 +37,6 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/signal.h>
 #include <linux/poll.h>
 #include <linux/module.h>
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index 9fe34fb..cf6a542 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -19,7 +19,6 @@
 #include <linux/errno.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/usb.h>
 
 #include "usb.h"
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 9819a4c..b690aa3 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -39,7 +39,6 @@
 #include <linux/parser.h>
 #include <linux/notifier.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/usb/hcd.h>
 #include <asm/byteorder.h>
 #include "usb.h"
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 4a830df..484c5ba 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -30,7 +30,6 @@
 #include <linux/blkdev.h>
 #include <linux/pagemap.h>
 #include <asm/unaligned.h>
-#include <linux/smp_lock.h>
 
 #include <linux/usb/composite.h>
 #include <linux/usb/functionfs.h>
diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index 4f891ed..598e7e2 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -25,7 +25,6 @@
 #include <linux/cdev.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 #include <linux/uaccess.h>
 #include <linux/wait.h>
 #include <linux/usb/g_hid.h>
diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 8196fa1..6c4fb4e 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -70,7 +70,6 @@
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/list.h>
diff --git a/drivers/usb/host/uhci-debug.c b/drivers/usb/host/uhci-debug.c
index 6e7fb5f..ee60cd3 100644
--- a/drivers/usb/host/uhci-debug.c
+++ b/drivers/usb/host/uhci-debug.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
-#include <linux/smp_lock.h>
 #include <asm/io.h>
 
 #include "uhci-hcd.h"
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 44cb37b..c436e1e 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -15,7 +15,6 @@
 #include <linux/poll.h>
 #include <linux/compat.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 
diff --git a/drivers/usb/mon/mon_stat.c b/drivers/usb/mon/mon_stat.c
index 8ec94f1..e5ce42b 100644
--- a/drivers/usb/mon/mon_stat.c
+++ b/drivers/usb/mon/mon_stat.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 #include "usb_mon.h"
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index e64da74..861223f 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -21,7 +21,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 54e32c5..915448e 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -47,7 +47,6 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/screen_info.h>
-#include <linux/smp_lock.h>
 #include <video/vga.h>
 #include <asm/io.h>
 
diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
index f80be7f..0f5d416 100644
--- a/drivers/xen/xenfs/privcmd.c
+++ b/drivers/xen/xenfs/privcmd.c
@@ -15,7 +15,6 @@
 #include <linux/mman.h>
 #include <linux/uaccess.h>
 #include <linux/swap.h>
-#include <linux/smp_lock.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
diff --git a/drivers/zorro/proc.c b/drivers/zorro/proc.c
index cafc504..e0c8472 100644
--- a/drivers/zorro/proc.c
+++ b/drivers/zorro/proc.c
@@ -13,7 +13,6 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/amigahw.h>
 #include <asm/setup.h>
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 06e8ff1..4230252 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/kmod.h>
 #include <linux/major.h>
-#include <linux/smp_lock.h>
 #include <linux/device_cgroup.h>
 #include <linux/highmem.h>
 #include <linux/blkdev.h>
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 1d6a45b..524b80b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2,7 +2,6 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3142b15..7799cac 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -6,7 +6,6 @@
 #include <linux/sched.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 
 #include "super.h"
 #include "mds_client.h"
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 410ed18..a60579b 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -19,7 +19,6 @@
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
-#include <linux/smp_lock.h>
 #include <linux/ioctl.h>
 #include <linux/if.h>
 #include <linux/if_bridge.h>
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index 2537323..2720178 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -28,7 +28,6 @@
 #include <linux/key.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/file.h>
 #include <linux/crypto.h>
 #include "ecryptfs_kernel.h"
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 2fedaf8..acf8695 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/parser.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/exportfs.h>
 #include <linux/vfs.h>
diff --git a/fs/ioctl.c b/fs/ioctl.c
index e92fdbb..4f46752 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -6,7 +6,6 @@
 
 #include <linux/syscalls.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
 #include <linux/capability.h>
 #include <linux/file.h>
 #include <linux/fs.h>
diff --git a/fs/lockd/clntlock.c b/fs/lockd/clntlock.c
index d5bb868..25509eb 100644
--- a/fs/lockd/clntlock.c
+++ b/fs/lockd/clntlock.c
@@ -14,7 +14,6 @@
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/lockd.h>
-#include <linux/smp_lock.h>
 #include <linux/kthread.h>
 
 #define NLMDBG_FACILITY		NLMDBG_CLIENT
diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index 47ea1e1..332c54c 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/errno.h>
diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index a336e83..38d2611 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -9,7 +9,6 @@
 
 #include <linux/types.h>
 #include <linux/time.h>
-#include <linux/smp_lock.h>
 #include <linux/lockd/lockd.h>
 #include <linux/lockd/share.h>
 
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index c462d34..ef5659b 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -25,7 +25,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/lockd/nlm.h>
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index c3069f3..0caea53 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -9,7 +9,6 @@
 
 #include <linux/types.h>
 #include <linux/time.h>
-#include <linux/smp_lock.h>
 #include <linux/lockd/lockd.h>
 #include <linux/lockd/share.h>
 
diff --git a/fs/locks.c b/fs/locks.c
index 65765cb..cf96af0 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -122,7 +122,6 @@
 #include <linux/module.h>
 #include <linux/security.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/time.h>
 #include <linux/rcupdate.h>
diff --git a/fs/namespace.c b/fs/namespace.c
index 8a415c9..3dbfc07 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -13,7 +13,6 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/acct.h>
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index aac8832..f22b12e 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -19,7 +19,6 @@
 #include <linux/mm.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
-#include <linux/smp_lock.h>
 
 #include <linux/ncp_fs.h>
 
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 6c754f7..cb50aaf 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -17,7 +17,6 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 
 #include <linux/ncp_fs.h>
 #include "ncplib_kernel.h"
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index d290545..8fb93b6 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -26,7 +26,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index c2a1f9a..d40a547 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -17,7 +17,6 @@
 #include <linux/mount.h>
 #include <linux/slab.h>
 #include <linux/highuid.h>
-#include <linux/smp_lock.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
 
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index aeec017..93a8b3b 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -9,7 +9,6 @@
 #include <linux/completion.h>
 #include <linux/ip.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/svcsock.h>
 #include <linux/nfs_fs.h>
diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
index 232a7ee..1fd62fc 100644
--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 
 #include <linux/nfs4.h>
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 0a42e8f..489f73c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -39,7 +39,6 @@
 #include <linux/nfs_mount.h>
 #include <linux/nfs4_mount.h>
 #include <linux/lockd/bind.h>
-#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/mnt_namespace.h>
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index f02c0ef..cfeab7c 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -41,7 +41,6 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
-#include <linux/smp_lock.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 9c2b5f4..3ddb606 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -16,7 +16,6 @@
 #include <linux/limits.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/sysctl.h>
 #include <linux/slab.h>
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 431a0ed..5d431ba 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -9,7 +9,6 @@
 #include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/uio.h>
-#include <linux/smp_lock.h>
 #include <linux/fsnotify.h>
 #include <linux/security.h>
 #include <linux/module.h>
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 41656d4..0bae036 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -8,7 +8,6 @@
 #include <linux/reiserfs_acl.h>
 #include <linux/reiserfs_xattr.h>
 #include <linux/exportfs.h>
-#include <linux/smp_lock.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index adf22b4..bd9763e 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -9,7 +9,6 @@
 #include <linux/time.h>
 #include <asm/uaccess.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 #include <linux/compat.h>
 
 /*
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 076c8b1..d31bce1 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -43,7 +43,6 @@
 #include <linux/fcntl.h>
 #include <linux/stat.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/workqueue.h>
 #include <linux/writeback.h>
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 3bf7a64..b243117 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -28,7 +28,6 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/crc32.h>
-#include <linux/smp_lock.h>
 
 struct file_system_type reiserfs_fs_type;
 
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 8a389b6..df994d7 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -3,7 +3,6 @@
 
 #include <linux/preempt.h>
 #ifdef CONFIG_PREEMPT
-#include <linux/smp_lock.h>
 #endif
 #include <linux/lockdep.h>
 #include <linux/ftrace_irq.h>
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 5ca47e5..c21072a 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -22,7 +22,6 @@
 #include <asm/unaligned.h>
 #include <linux/bitops.h>
 #include <linux/proc_fs.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/reiserfs_fs_i.h>
 #include <linux/reiserfs_fs_sb.h>
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 2a75474..761ba35 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -13,7 +13,6 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 
 #include <asm/system.h>
 
diff --git a/init/main.c b/init/main.c
index e59af24..8646401 100644
--- a/init/main.c
+++ b/init/main.c
@@ -20,7 +20,6 @@
 #include <linux/delay.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/initrd.h>
 #include <linux/bootmem.h>
 #include <linux/acpi.h>
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 82d9b81..0420841 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -17,7 +17,6 @@
 #include <linux/writeback.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/irqflags.h>
 #include <linux/debugfs.h>
diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index 7f09798..a6de305 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -45,7 +45,6 @@
 #include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/socket.h>
 #include <linux/sockios.h>
 #include <linux/slab.h>
diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 7fa8637..7c567b8 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -15,7 +15,6 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include "irnet_ppp.h"		/* Private header */
 /* Please put other headers in irnet.h - Thanks */
 
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index c82fe73..ea2ff78 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
diff --git a/sound/core/info.c b/sound/core/info.c
index b70564e..7077f60 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -23,7 +23,6 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <sound/core.h>
 #include <sound/minors.h>
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 8bc7cb3..e82c1f9 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -22,7 +22,6 @@
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/pm_qos_params.h>
 #include <linux/uio.h>
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 62a093e..66691fe 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -21,7 +21,6 @@
 
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/device.h>
 #include <linux/moduleparam.h>
diff --git a/sound/sound_core.c b/sound/sound_core.c
index c03bbae..5580ace 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -104,7 +104,6 @@ module_exit(cleanup_soundcore);
 
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/sound.h>
-- 
1.7.1

