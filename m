Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab1JCXLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:11:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52988 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750733Ab1JCXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:11:50 -0400
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX1+MPNgS7rSMDKdg4o04PD0cGVrDx8HmJjpeWmWoPy
	g3FfTwBGcbhr78
Message-ID: <1317683499.5990.2.camel@LAPJFS>
Subject: [PATCH] Fix file references in the whole tree
From: Johann Felix Soden <johfel@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Oct 2011 01:11:39 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

There are a lot of file references to now moved or deleted files in the
whole tree, especially in documentation and Kconfig files. This patch
fixes most of them.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
---
 Documentation/PCI/pci.txt                          |    2 +-
 Documentation/block/biodoc.txt                     |    4 +-
 Documentation/bus-virt-phys-mapping.txt            |    2 +-
 Documentation/filesystems/locks.txt                |   11 +++++----
 Documentation/filesystems/nfs/idmapper.txt         |    2 +-
 .../filesystems/pohmelfs/design_notes.txt          |    5 ++-
 Documentation/input/input.txt                      |    2 +-
 Documentation/kernel-parameters.txt                |    8 +++---
 Documentation/laptops/00-INDEX                     |    2 -
 Documentation/laptops/thinkpad-acpi.txt            |    6 ++--
 Documentation/memory-barriers.txt                  |    2 +-
 Documentation/timers/highres.txt                   |    2 +-
 Documentation/usb/dma.txt                          |    8 +++---
 arch/arm/Kconfig                                   |    2 +-
 arch/arm/include/asm/io.h                          |    2 +-
 arch/cris/Kconfig                                  |    4 +-
 arch/cris/arch-v10/Kconfig                         |   12 +++++-----
 arch/ia64/hp/common/sba_iommu.c                    |   12 +++++-----
 arch/m68k/q40/README                               |    2 +-
 arch/microblaze/include/asm/dma-mapping.h          |    2 +-
 arch/mn10300/Kconfig                               |    2 +-
 arch/parisc/include/asm/dma-mapping.h              |    2 +-
 arch/parisc/kernel/pci-dma.c                       |    2 +-
 arch/powerpc/include/asm/qe.h                      |    2 +-
 arch/powerpc/sysdev/qe_lib/qe.c                    |    2 +-
 arch/unicore32/include/asm/io.h                    |    2 +-
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/Kconfig.debug                             |    2 +-
 arch/x86/boot/header.S                             |    2 +-
 arch/x86/include/asm/dma-mapping.h                 |    2 +-
 arch/x86/kernel/amd_gart_64.c                      |    2 +-
 arch/x86/kernel/pci-dma.c                          |    4 +-
 drivers/ide/Kconfig                                |   24 ++++++++++----------
 drivers/leds/Kconfig                               |    2 +-
 drivers/net/Kconfig                                |    4 +-
 drivers/net/irda/Kconfig                           |    2 +-
 drivers/parisc/sba_iommu.c                         |   16 ++++++------
 drivers/platform/x86/Kconfig                       |    3 --
 drivers/staging/cxt1e1/Kconfig                     |    2 +-
 drivers/video/igafb.c                              |    3 +-
 fs/squashfs/Kconfig                                |    6 ++--
 include/media/videobuf-dma-sg.h                    |    2 +-
 net/netfilter/Kconfig                              |    2 +-
 sound/oss/Kconfig                                  |    4 +--
 44 files changed, 92 insertions(+), 96 deletions(-)

diff --git a/Documentation/PCI/pci.txt b/Documentation/PCI/pci.txt
index 6148d40..ea80832 100644
--- a/Documentation/PCI/pci.txt
+++ b/Documentation/PCI/pci.txt
@@ -314,7 +314,7 @@ from the PCI device config space. Use the values in the pci_dev structure
 as the PCI "bus address" might have been remapped to a "host physical"
 address by the arch/chip-set specific kernel support.
 
-See Documentation/IO-mapping.txt for how to access device registers
+See Documentation/bus-virt-phys-mapping.txt for how to access device registers
 or device memory.
 
 The device driver needs to call pci_request_region() to verify
diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index c6d84cf..30692b3 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -186,8 +186,8 @@ a virtual address mapping (unlike the earlier scheme of virtual address
 do not have a corresponding kernel virtual address space mapping) and
 low-memory pages.
 
-Note: Please refer to Documentation/PCI/PCI-DMA-mapping.txt for a discussion
-on PCI high mem DMA aspects and mapping of scatter gather lists, and support
+Note: Please refer to Documentation/DMA-API-HOWTO.txt for a discussion on
+PCI high mem DMA aspects and mapping of scatter gather lists, and support
 for 64 bit PCI.
 
 Special handling is required only for cases where i/o needs to happen on
diff --git a/Documentation/bus-virt-phys-mapping.txt b/Documentation/bus-virt-phys-mapping.txt
index 1b5aa10..2bc55ff 100644
--- a/Documentation/bus-virt-phys-mapping.txt
+++ b/Documentation/bus-virt-phys-mapping.txt
@@ -1,6 +1,6 @@
 [ NOTE: The virt_to_bus() and bus_to_virt() functions have been
 	superseded by the functionality provided by the PCI DMA interface
-	(see Documentation/PCI/PCI-DMA-mapping.txt).  They continue
+	(see Documentation/DMA-API-HOWTO.txt).  They continue
 	to be documented below for historical purposes, but new code
 	must not use them. --davidm 00/12/12 ]
 
diff --git a/Documentation/filesystems/locks.txt b/Documentation/filesystems/locks.txt
index fab857a..2cf8108 100644
--- a/Documentation/filesystems/locks.txt
+++ b/Documentation/filesystems/locks.txt
@@ -53,11 +53,12 @@ fcntl(), with all the problems that implies.
 1.3 Mandatory Locking As A Mount Option
 ---------------------------------------
 
-Mandatory locking, as described in 'Documentation/filesystems/mandatory.txt'
-was prior to this release a general configuration option that was valid for
-all mounted filesystems.  This had a number of inherent dangers, not the
-least of which was the ability to freeze an NFS server by asking it to read
-a file for which a mandatory lock existed.
+Mandatory locking, as described in
+'Documentation/filesystems/mandatory-locking.txt' was prior to this release a
+general configuration option that was valid for all mounted filesystems.  This
+had a number of inherent dangers, not the least of which was the ability to
+freeze an NFS server by asking it to read a file for which a mandatory lock
+existed.
 
 From this release of the kernel, mandatory locking can be turned on and off
 on a per-filesystem basis, using the mount options 'mand' and 'nomand'.
diff --git a/Documentation/filesystems/nfs/idmapper.txt b/Documentation/filesystems/nfs/idmapper.txt
index 9c8fd61..120fd3c 100644
--- a/Documentation/filesystems/nfs/idmapper.txt
+++ b/Documentation/filesystems/nfs/idmapper.txt
@@ -47,7 +47,7 @@ request-key will find the first matching line and corresponding program.  In
 this case, /some/other/program will handle all uid lookups and
 /usr/sbin/nfs.idmap will handle gid, user, and group lookups.
 
-See <file:Documentation/security/keys-request-keys.txt> for more information
+See <file:Documentation/security/keys-request-key.txt> for more information
 about the request-key function.
 
 
diff --git a/Documentation/filesystems/pohmelfs/design_notes.txt b/Documentation/filesystems/pohmelfs/design_notes.txt
index dcf8335..8aef9133 100644
--- a/Documentation/filesystems/pohmelfs/design_notes.txt
+++ b/Documentation/filesystems/pohmelfs/design_notes.txt
@@ -58,8 +58,9 @@ data transfers.
 POHMELFS clients operate with a working set of servers and are capable of balancing read-only
 operations (like lookups or directory listings) between them according to IO priorities.
 Administrators can add or remove servers from the set at run-time via special commands (described
-in Documentation/pohmelfs/info.txt file). Writes are replicated to all servers, which are connected
-with write permission turned on. IO priority and permissions can be changed in run-time.
+in Documentation/filesystems/pohmelfs/info.txt file). Writes are replicated to all servers, which
+are connected with write permission turned on. IO priority and permissions can be changed in
+run-time.
 
 POHMELFS is capable of full data channel encryption and/or strong crypto hashing.
 One can select any kernel supported cipher, encryption mode, hash type and operation mode
diff --git a/Documentation/input/input.txt b/Documentation/input/input.txt
index b93c084..b3d6787 100644
--- a/Documentation/input/input.txt
+++ b/Documentation/input/input.txt
@@ -111,7 +111,7 @@ LCDs and many other purposes.
 
  The monitor and speaker controls should be easy to add to the hid/input
 interface, but for the UPSs and LCDs it doesn't make much sense. For this,
-the hiddev interface was designed. See Documentation/usb/hiddev.txt
+the hiddev interface was designed. See Documentation/hid/hiddev.txt
 for more information about it.
 
   The usage of the usbhid module is very simple, it takes no parameters,
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 854ed5ca..b054be7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -163,7 +163,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			rsdt -- prefer RSDT over (default) XSDT
 			copy_dsdt -- copy DSDT to memory
 
-			See also Documentation/power/pm.txt, pci=noacpi
+			See also Documentation/power/apm-acpi.txt, pci=noacpi
 
 	acpi_rsdp=	[ACPI,EFI,KEXEC]
 			Pass the RSDP address to the kernel, mostly used
@@ -319,7 +319,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
 			Format: <a>,<b>
-			See also Documentation/kernel/input/joystick.txt
+			See also Documentation/input/joystick.txt
 
 	analog.map=	[HW,JOY] Analog joystick and gamepad support
 			Specifies type or capabilities of an analog joystick
@@ -724,8 +724,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	elevator=	[IOSCHED]
 			Format: {"cfq" | "deadline" | "noop"}
-			See Documentation/block/as-iosched.txt and
-			Documentation/block/deadline-iosched.txt for details.
+			See Documentation/block/deadline-iosched.txt for
+			details.
 
 	elfcorehdr=	[IA-64,PPC,SH,X86]
 			Specifies physical address of start of kernel core
diff --git a/Documentation/laptops/00-INDEX b/Documentation/laptops/00-INDEX
index fa68853..08c4434 100644
--- a/Documentation/laptops/00-INDEX
+++ b/Documentation/laptops/00-INDEX
@@ -1,7 +1,5 @@
 00-INDEX
 	- This file
-acer-wmi.txt
-	- information on the Acer Laptop WMI Extras driver.
 asus-laptop.txt
 	- information on the Asus Laptop Extras driver.
 disk-shock-protection.txt
diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 6181548..1838996 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -736,8 +736,8 @@ status as "unknown". The available commands are:
 sysfs notes:
 
 The ThinkLight sysfs interface is documented by the LED class
-documentation, in Documentation/leds-class.txt.  The ThinkLight LED name
-is "tpacpi::thinklight".
+documentation, in Documentation/leds/leds-class.txt.  The ThinkLight LED
+name is "tpacpi::thinklight".
 
 Due to limitations in the sysfs LED class, if the status of the ThinkLight
 cannot be read or if it is unknown, thinkpad-acpi will report it as "off".
@@ -833,7 +833,7 @@ All of the above can be turned on and off and can be made to blink.
 sysfs notes:
 
 The ThinkPad LED sysfs interface is described in detail by the LED class
-documentation, in Documentation/leds-class.txt.
+documentation, in Documentation/leds/leds-class.txt.
 
 The LEDs are named (in LED ID order, from 0 to 12):
 "tpacpi::power", "tpacpi:orange:batt", "tpacpi:green:batt",
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f0d3a80..2759f7c 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -438,7 +438,7 @@ There are certain things that the Linux kernel memory barriers do not guarantee:
 	[*] For information on bus mastering DMA and coherency please read:
 
 	    Documentation/PCI/pci.txt
-	    Documentation/PCI/PCI-DMA-mapping.txt
+	    Documentation/DMA-API-HOWTO.txt
 	    Documentation/DMA-API.txt
 
 
diff --git a/Documentation/timers/highres.txt b/Documentation/timers/highres.txt
index 2133223..e878997 100644
--- a/Documentation/timers/highres.txt
+++ b/Documentation/timers/highres.txt
@@ -30,7 +30,7 @@ hrtimer base infrastructure
 ---------------------------
 
 The hrtimer base infrastructure was merged into the 2.6.16 kernel. Details of
-the base implementation are covered in Documentation/hrtimers/hrtimer.txt. See
+the base implementation are covered in Documentation/timers/hrtimers.txt. See
 also figure #2 (OLS slides p. 15)
 
 The main differences to the timer wheel, which holds the armed timer_list type
diff --git a/Documentation/usb/dma.txt b/Documentation/usb/dma.txt
index 84ef865..13a7315 100644
--- a/Documentation/usb/dma.txt
+++ b/Documentation/usb/dma.txt
@@ -7,8 +7,8 @@ API OVERVIEW
 
 The big picture is that USB drivers can continue to ignore most DMA issues,
 though they still must provide DMA-ready buffers (see
-Documentation/PCI/PCI-DMA-mapping.txt).  That's how they've worked through
-the 2.4 (and earlier) kernels.
+Documentation/DMA-API-HOWTO.txt).  That's how they've worked through the 2.4
+(and earlier) kernels.
 
 OR:  they can now be DMA-aware.
 
@@ -57,7 +57,7 @@ and effects like cache-trashing can impose subtle penalties.
   force a consistent memory access ordering by using memory barriers.  It's
   not using a streaming DMA mapping, so it's good for small transfers on
   systems where the I/O would otherwise thrash an IOMMU mapping.  (See
-  Documentation/PCI/PCI-DMA-mapping.txt for definitions of "coherent" and
+  Documentation/DMA-API-HOWTO.txt for definitions of "coherent" and
   "streaming" DMA mappings.)
 
   Asking for 1/Nth of a page (as well as asking for N pages) is reasonably
@@ -88,7 +88,7 @@ WORKING WITH EXISTING BUFFERS
 Existing buffers aren't usable for DMA without first being mapped into the
 DMA address space of the device.  However, most buffers passed to your
 driver can safely be used with such DMA mapping.  (See the first section
-of Documentation/PCI/PCI-DMA-mapping.txt, titled "What memory is DMA-able?")
+of Documentation/DMA-API-HOWTO.txt, titled "What memory is DMA-able?")
 
 - When you're using scatterlists, you can map everything at once.  On some
   systems, this kicks in an IOMMU and turns the scatterlists into single
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3146ed3..42ea778 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1388,7 +1388,7 @@ config SMP
 	  processor machines. On a single processor machine, the kernel will
 	  run faster if you say N here.
 
-	  See also <file:Documentation/i386/IO-APIC.txt>,
+	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
 	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index d66605d..dcd1960 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -238,7 +238,7 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
  * ioremap and friends.
  *
  * ioremap takes a PCI memory address, as specified in
- * Documentation/IO-mapping.txt.
+ * Documentation/bus-virt-phys-mapping.txt.
  *
  */
 #ifndef __arch_ioremap
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 17addac..408b055 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -282,8 +282,8 @@ config ETRAX_RTC
 	  Enables drivers for the Real-Time Clock battery-backed chips on
 	  some products. The kernel reads the time when booting, and
 	  the date can be set using ioctl(fd, RTC_SET_TIME, &rt) with rt a
-	  rtc_time struct (see <file:include/asm-cris/rtc.h>) on the /dev/rtc
-	  device.  You can check the time with cat /proc/rtc, but
+	  rtc_time struct (see <file:arch/cris/include/asm/rtc.h>) on the
+	  /dev/rtc device.  You can check the time with cat /proc/rtc, but
 	  normal time reading should be done using libc function time and
 	  friends.
 
diff --git a/arch/cris/arch-v10/Kconfig b/arch/cris/arch-v10/Kconfig
index adc164e..df9a38b 100644
--- a/arch/cris/arch-v10/Kconfig
+++ b/arch/cris/arch-v10/Kconfig
@@ -24,8 +24,8 @@ config ETRAX_PA_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent.  It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on port PA.  Some products
 	  put the leds on PB or a memory-mapped latch (CSP0) instead.
 
@@ -34,8 +34,8 @@ config ETRAX_PB_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent.  It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on port PB.  Some products
 	  put the leds on PA or a memory-mapped latch (CSP0) instead.
 
@@ -44,8 +44,8 @@ config ETRAX_CSP0_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent. It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on a memory-mapped latch
 	  using chip select CSP0, this is mapped at 0x90000000.
 	  Some products put the leds on PA or PB instead.
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 80241fe..f5f4ef1 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -915,7 +915,7 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static dma_addr_t sba_map_page(struct device *dev, struct page *page,
 			       unsigned long poff, size_t size,
@@ -1044,7 +1044,7 @@ sba_mark_clean(struct ioc *ioc, dma_addr_t iova, size_t size)
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static void sba_unmap_page(struct device *dev, dma_addr_t iova, size_t size,
 			   enum dma_data_direction dir, struct dma_attrs *attrs)
@@ -1127,7 +1127,7 @@ void sba_unmap_single_attrs(struct device *dev, dma_addr_t iova, size_t size,
  * @size:  number of bytes mapped in driver buffer.
  * @dma_handle:  IOVA of new buffer.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static void *
 sba_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t flags)
@@ -1190,7 +1190,7 @@ sba_alloc_coherent (struct device *dev, size_t size, dma_addr_t *dma_handle, gfp
  * @vaddr:  virtual address IOVA of "consistent" buffer.
  * @dma_handler:  IO virtual address of "consistent" buffer.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static void sba_free_coherent (struct device *dev, size_t size, void *vaddr,
 			       dma_addr_t dma_handle)
@@ -1453,7 +1453,7 @@ static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			    int nents, enum dma_data_direction dir,
@@ -1549,7 +1549,7 @@ static int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist,
  * @dir:  R/W or both.
  * @attrs: optional dma attributes
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static void sba_unmap_sg_attrs(struct device *dev, struct scatterlist *sglist,
 			       int nents, enum dma_data_direction dir,
diff --git a/arch/m68k/q40/README b/arch/m68k/q40/README
index b26d5f5..93f4c4c 100644
--- a/arch/m68k/q40/README
+++ b/arch/m68k/q40/README
@@ -31,7 +31,7 @@ drivers used by the Q40, apart from the very obvious (console etc.):
 		char/joystick/*		# most of this should work, not
 				        # in default config.in
 	        block/q40ide.c		# startup for ide
-		      ide*		# see Documentation/ide.txt
+		      ide*		# see Documentation/ide/ide.txt
 		      floppy.c		# normal PC driver, DMA emu in asm/floppy.h
 					# and arch/m68k/kernel/entry.S
 					# see drivers/block/README.fd
diff --git a/arch/microblaze/include/asm/dma-mapping.h b/arch/microblaze/include/asm/dma-mapping.h
index 8fbb0ec..a569514 100644
--- a/arch/microblaze/include/asm/dma-mapping.h
+++ b/arch/microblaze/include/asm/dma-mapping.h
@@ -16,7 +16,7 @@
 #define _ASM_MICROBLAZE_DMA_MAPPING_H
 
 /*
- * See Documentation/PCI/PCI-DMA-mapping.txt and
+ * See Documentation/DMA-API-HOWTO.txt and
  * Documentation/DMA-API.txt for documentation.
  */
 
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 1f87034..f093b3a 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -195,7 +195,7 @@ config SMP
 	  singleprocessor machines. On a singleprocessor machine, the kernel
 	  will run faster if you say N here.
 
-	  See also <file:Documentation/i386/IO-APIC.txt>,
+	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
 	  <http://www.tldp.org/docs.html#howto>.
 
diff --git a/arch/parisc/include/asm/dma-mapping.h b/arch/parisc/include/asm/dma-mapping.h
index 890531e..467bbd5 100644
--- a/arch/parisc/include/asm/dma-mapping.h
+++ b/arch/parisc/include/asm/dma-mapping.h
@@ -5,7 +5,7 @@
 #include <asm/cacheflush.h>
 #include <asm/scatterlist.h>
 
-/* See Documentation/PCI/PCI-DMA-mapping.txt */
+/* See Documentation/DMA-API-HOWTO.txt */
 struct hppa_dma_ops {
 	int  (*dma_supported)(struct device *dev, u64 mask);
 	void *(*alloc_consistent)(struct device *dev, size_t size, dma_addr_t *iova, gfp_t flag);
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index a029f74..d047ede 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -2,7 +2,7 @@
 ** PARISC 1.1 Dynamic DMA mapping support.
 ** This implementation is for PA-RISC platforms that do not support
 ** I/O TLBs (aka DMA address translation hardware).
-** See Documentation/PCI/PCI-DMA-mapping.txt for interface definitions.
+** See Documentation/DMA-API-HOWTO.txt for interface definitions.
 **
 **      (c) Copyright 1999,2000 Hewlett-Packard Company
 **      (c) Copyright 2000 Grant Grundler
diff --git a/arch/powerpc/include/asm/qe.h b/arch/powerpc/include/asm/qe.h
index 0947b36..5e0b6d5 100644
--- a/arch/powerpc/include/asm/qe.h
+++ b/arch/powerpc/include/asm/qe.h
@@ -196,7 +196,7 @@ static inline int qe_alive_during_sleep(void)
 
 /* Structure that defines QE firmware binary files.
  *
- * See Documentation/powerpc/qe-firmware.txt for a description of these
+ * See Documentation/powerpc/qe_firmware.txt for a description of these
  * fields.
  */
 struct qe_firmware {
diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
index 904c6cb..3363fbc 100644
--- a/arch/powerpc/sysdev/qe_lib/qe.c
+++ b/arch/powerpc/sysdev/qe_lib/qe.c
@@ -382,7 +382,7 @@ static void qe_upload_microcode(const void *base,
 /*
  * Upload a microcode to the I-RAM at a specific address.
  *
- * See Documentation/powerpc/qe-firmware.txt for information on QE microcode
+ * See Documentation/powerpc/qe_firmware.txt for information on QE microcode
  * uploading.
  *
  * Currently, only version 1 is supported, so the 'version' field must be
diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index 4bd87f3..44e6bc5 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -32,7 +32,7 @@ extern void __uc32_iounmap(volatile void __iomem *addr);
  * ioremap and friends.
  *
  * ioremap takes a PCI memory address, as specified in
- * Documentation/IO-mapping.txt.
+ * Documentation/bus-virt-phys-mapping.txt.
  *
  */
 #define ioremap(cookie, size)		__uc32_ioremap(cookie, size)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..9a4a267 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -279,7 +279,7 @@ config SMP
 	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
 	  Management" code will be disabled if you say Y here.
 
-	  See also <file:Documentation/i386/IO-APIC.txt>,
+	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
 	  <http://www.tldp.org/docs.html#howto>.
 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c0f8a5c..bf56e17 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -139,7 +139,7 @@ config IOMMU_DEBUG
 	  code. When you use it make sure you have a big enough
 	  IOMMU/AGP aperture.  Most of the options enabled by this can
 	  be set more finegrained using the iommu= command line
-	  options. See Documentation/x86_64/boot-options.txt for more
+	  options. See Documentation/x86/x86_64/boot-options.txt for more
 	  details.
 
 config IOMMU_STRESS
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 93e689f..bdb4d45 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -129,7 +129,7 @@ start_sys_seg:	.word	SYSSEG		# obsolete and meaningless, but just
 
 type_of_loader:	.byte	0		# 0 means ancient bootloader, newer
 					# bootloaders know to change this.
-					# See Documentation/i386/boot.txt for
+					# See Documentation/x86/boot.txt for
 					# assigned ids
 
 # flags, unused bits must be zero (RFU) bit within loadflags
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index d4c419f..ed3065f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_DMA_MAPPING_H
 
 /*
- * IOMMU interface. See Documentation/PCI/PCI-DMA-mapping.txt and
+ * IOMMU interface. See Documentation/DMA-API-HOWTO.txt and
  * Documentation/DMA-API.txt for documentation.
  */
 
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index 8a439d3..b1e7c7f 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -5,7 +5,7 @@
  * This allows to use PCI devices that only support 32bit addresses on systems
  * with more than 4GB.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt for the interface specification.
+ * See Documentation/DMA-API-HOWTO.txt for the interface specification.
  *
  * Copyright 2002 Andi Kleen, SuSE Labs.
  * Subject to the GNU General Public License v2 only.
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b49d00d..6228720 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -117,8 +117,8 @@ again:
 }
 
 /*
- * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
- * documentation.
+ * See <Documentation/x86/x86_64/boot-options.txt> for the iommu kernel
+ * parameter documentation.
  */
 static __init int iommu_setup(char *p)
 {
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 9827c5e..811dbbd 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -327,7 +327,7 @@ config BLK_DEV_OPTI621
 	select BLK_DEV_IDEPCI
 	help
 	  This is a driver for the OPTi 82C621 EIDE controller.
-	  Please read the comments at the top of <file:drivers/ide/pci/opti621.c>.
+	  Please read the comments at the top of <file:drivers/ide/opti621.c>.
 
 config BLK_DEV_RZ1000
 	tristate "RZ1000 chipset bugfix/support"
@@ -365,7 +365,7 @@ config BLK_DEV_ALI15X3
 	  normal dual channel support.
 
 	  Please read the comments at the top of
-	  <file:drivers/ide/pci/alim15x3.c>.
+	  <file:drivers/ide/alim15x3.c>.
 
 	  If unsure, say N.
 
@@ -528,7 +528,7 @@ config BLK_DEV_NS87415
 	  This driver adds detection and support for the NS87415 chip
 	  (used mainly on SPARC64 and PA-RISC machines).
 
-	  Please read the comments at the top of <file:drivers/ide/pci/ns87415.c>.
+	  Please read the comments at the top of <file:drivers/ide/ns87415.c>.
 
 config BLK_DEV_PDC202XX_OLD
 	tristate "PROMISE PDC202{46|62|65|67} support"
@@ -547,7 +547,7 @@ config BLK_DEV_PDC202XX_OLD
 	  for more than one card.
 
 	  Please read the comments at the top of
-	  <file:drivers/ide/pci/pdc202xx_old.c>.
+	  <file:drivers/ide/pdc202xx_old.c>.
 
 	  If unsure, say N.
 
@@ -593,7 +593,7 @@ config BLK_DEV_SIS5513
 	  ATA100: SiS635, SiS645, SiS650, SiS730, SiS735, SiS740,
 	  SiS745, SiS750
 
-	  Please read the comments at the top of <file:drivers/ide/pci/sis5513.c>.
+	  Please read the comments at the top of <file:drivers/ide/sis5513.c>.
 
 config BLK_DEV_SL82C105
 	tristate "Winbond SL82c105 support"
@@ -616,7 +616,7 @@ config BLK_DEV_SLC90E66
 	  look-a-like to the PIIX4 it should be a nice addition.
 
 	  Please read the comments at the top of
-	  <file:drivers/ide/pci/slc90e66.c>.
+	  <file:drivers/ide/slc90e66.c>.
 
 config BLK_DEV_TRM290
 	tristate "Tekram TRM290 chipset support"
@@ -625,7 +625,7 @@ config BLK_DEV_TRM290
 	  This driver adds support for bus master DMA transfers
 	  using the Tekram TRM290 PCI IDE chip. Volunteers are
 	  needed for further tweaking and development.
-	  Please read the comments at the top of <file:drivers/ide/pci/trm290.c>.
+	  Please read the comments at the top of <file:drivers/ide/trm290.c>.
 
 config BLK_DEV_VIA82CXXX
 	tristate "VIA82CXXX chipset support"
@@ -836,7 +836,7 @@ config BLK_DEV_ALI14XX
 	  of the ALI M1439/1443/1445/1487/1489 chipsets, and permits faster
 	  I/O speeds to be set as well.
 	  See the files <file:Documentation/ide/ide.txt> and
-	  <file:drivers/ide/legacy/ali14xx.c> for more info.
+	  <file:drivers/ide/ali14xx.c> for more info.
 
 config BLK_DEV_DTC2278
 	tristate "DTC-2278 support"
@@ -847,7 +847,7 @@ config BLK_DEV_DTC2278
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the DTC-2278 card, and permits faster I/O speeds to be set as
 	  well. See the <file:Documentation/ide/ide.txt> and
-	  <file:drivers/ide/legacy/dtc2278.c> files for more info.
+	  <file:drivers/ide/dtc2278.c> files for more info.
 
 config BLK_DEV_HT6560B
 	tristate "Holtek HT6560B support"
@@ -858,7 +858,7 @@ config BLK_DEV_HT6560B
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the Holtek card, and permits faster I/O speeds to be set as well.
 	  See the <file:Documentation/ide/ide.txt> and
-	  <file:drivers/ide/legacy/ht6560b.c> files for more info.
+	  <file:drivers/ide/ht6560b.c> files for more info.
 
 config BLK_DEV_QD65XX
 	tristate "QDI QD65xx support"
@@ -867,7 +867,7 @@ config BLK_DEV_QD65XX
 	help
 	  This driver is enabled at runtime using the "qd65xx.probe" kernel
 	  boot parameter.  It permits faster I/O speeds to be set.  See the
-	  <file:Documentation/ide/ide.txt> and <file:drivers/ide/legacy/qd65xx.c>
+	  <file:Documentation/ide/ide.txt> and <file:drivers/ide/qd65xx.c>
 	  for more info.
 
 config BLK_DEV_UMC8672
@@ -879,7 +879,7 @@ config BLK_DEV_UMC8672
 	  boot parameter. It enables support for the secondary IDE interface
 	  of the UMC-8672, and permits faster I/O speeds to be set as well.
 	  See the files <file:Documentation/ide/ide.txt> and
-	  <file:drivers/ide/legacy/umc8672.c> for more info.
+	  <file:drivers/ide/umc8672.c> for more info.
 
 endif
 
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index b591e72..807c875 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -400,7 +400,7 @@ config LEDS_TRIGGER_TIMER
 	  This allows LEDs to be controlled by a programmable timer
 	  via sysfs. Some LED hardware can be programmed to start
 	  blinking the LED without any further software interaction.
-	  For more details read Documentation/leds-class.txt.
+	  For more details read Documentation/leds/leds-class.txt.
 
 	  If unsure, say Y.
 
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index a44874e..53ed3f4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -1064,8 +1064,8 @@ config SMSC911X
 	  of ethernet controllers.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
-	  will be called smsc911x.
+	  <file:Documentation/kbuild/modules.txt>. The module will be
+	  called smsc911x.
 
 config SMSC911X_ARCH_HOOKS
 	def_bool n
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 25bb2a0..a40fab4 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -183,7 +183,7 @@ config OLD_BELKIN_DONGLE
 	  Say Y here if you want to build support for the Adaptec Airport 1000
 	  and 2000 dongles.  If you want to compile it as a module, choose
 	  M here. Some information is contained in the comments
-	  at the top of <file:drivers/net/irda/old_belkin.c>.
+	  at the top of <file:drivers/net/irda/old_belkin-sir.c>.
 
 config ACT200L_DONGLE
 	tristate "ACTiSYS IR-200L dongle"
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 57a6d19..a6f7621 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -668,7 +668,7 @@ sba_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
  * @dev: instance of PCI owned by the driver that's asking
  * @mask:  number of address bits this PCI device can handle
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static int sba_dma_supported( struct device *dev, u64 mask)
 {
@@ -680,7 +680,7 @@ static int sba_dma_supported( struct device *dev, u64 mask)
 		return(0);
 	}
 
-	/* Documentation/PCI/PCI-DMA-mapping.txt tells drivers to try 64-bit
+	/* Documentation/DMA-API-HOWTO.txt tells drivers to try 64-bit
 	 * first, then fall back to 32-bit if that fails.
 	 * We are just "encouraging" 32-bit DMA masks here since we can
 	 * never allow IOMMU bypass unless we add special support for ZX1.
@@ -706,7 +706,7 @@ static int sba_dma_supported( struct device *dev, u64 mask)
  * @size:  number of bytes to map in driver buffer.
  * @direction:  R/W or both.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static dma_addr_t
 sba_map_single(struct device *dev, void *addr, size_t size,
@@ -785,7 +785,7 @@ sba_map_single(struct device *dev, void *addr, size_t size,
  * @size:  number of bytes mapped in driver buffer.
  * @direction:  R/W or both.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static void
 sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size,
@@ -861,7 +861,7 @@ sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size,
  * @size:  number of bytes mapped in driver buffer.
  * @dma_handle:  IOVA of new buffer.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static void *sba_alloc_consistent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t gfp)
@@ -892,7 +892,7 @@ static void *sba_alloc_consistent(struct device *hwdev, size_t size,
  * @vaddr:  virtual address IOVA of "consistent" buffer.
  * @dma_handler:  IO virtual address of "consistent" buffer.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static void
 sba_free_consistent(struct device *hwdev, size_t size, void *vaddr,
@@ -927,7 +927,7 @@ int dump_run_sg = 0;
  * @nents:  number of entries in list
  * @direction:  R/W or both.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static int
 sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
@@ -1011,7 +1011,7 @@ sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
  * @nents:  number of entries in list
  * @direction:  R/W or both.
  *
- * See Documentation/PCI/PCI-DMA-mapping.txt
+ * See Documentation/DMA-API-HOWTO.txt
  */
 static void 
 sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 1e88d47..98da58b 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -31,9 +31,6 @@ config ACER_WMI
 	  wireless radio and bluetooth control, and on some laptops,
 	  exposes the mail LED and LCD backlight.
 
-	  For more information about this driver see
-	  <file:Documentation/laptops/acer-wmi.txt>
-
 	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
 	  here.
 
diff --git a/drivers/staging/cxt1e1/Kconfig b/drivers/staging/cxt1e1/Kconfig
index 73430ef..5a2741a 100644
--- a/drivers/staging/cxt1e1/Kconfig
+++ b/drivers/staging/cxt1e1/Kconfig
@@ -7,7 +7,7 @@ config CXT1E1
       mode controller.
 
       If you want to compile this driver as a module
-      say M here and read <file:Documentation/modules.txt>.
+      say M here and read <file:Documentation/kbuild/modules.txt>.
       The module will be called 'cxt1e1'.
 
       If unsure, say N.
diff --git a/drivers/video/igafb.c b/drivers/video/igafb.c
index d885c77..f79bf40 100644
--- a/drivers/video/igafb.c
+++ b/drivers/video/igafb.c
@@ -428,7 +428,8 @@ static int __init igafb_init(void)
 	 *
 	 * IGS2000 has its I/O memory mapped and we want
 	 * to generate memory cycles on PCI, e.g. do ioremap(),
-	 * then readb/writeb() as in Documentation/IO-mapping.txt.
+	 * then readb/writeb() as in
+	 * Documentation/bus-virt-phys-mapping.txt.
 	 *
 	 * IGS1682 is more traditional, it responds to PCI I/O
 	 * cycles, so we want to access it with inb()/outb().
diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 1360d4f..9093277 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -19,9 +19,9 @@ config SQUASHFS
 
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called squashfs.  Note that the root file system (the one
-	  containing the directory /) cannot be compiled as a module.
+	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
+	  module will be called squashfs.  Note that the root file system (the
+	  one containing the directory /) cannot be compiled as a module.
 
 	  If unsure, say N.
 
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index 1c647e8..d8fb601 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -34,7 +34,7 @@
  *	does memory allocation too using vmalloc_32().
  *
  * videobuf_dma_*()
- *	see Documentation/PCI/PCI-DMA-mapping.txt, these functions to
+ *	see Documentation/DMA-API-HOWTO.txt, these functions to
  *	basically the same.  The map function does also build a
  *	scatterlist for the buffer (and unmap frees it ...)
  *
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 32bff6d..8260b13 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -505,7 +505,7 @@ config NETFILTER_XT_TARGET_LED
 	    echo netfilter-ssh > /sys/class/leds/<ledname>/trigger
 
 	  For more information on the LEDs available on your system, see
-	  Documentation/leds-class.txt
+	  Documentation/leds/leds-class.txt
 
 config NETFILTER_XT_TARGET_MARK
 	tristate '"MARK" target support'
diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index 6c93e05..6c9e8e8 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -432,9 +432,7 @@ config SOUND_SB
 	  ALS-007 and ALS-1X0 chips (read <file:Documentation/sound/oss/ALS>) and
 	  for cards based on ESS chips (read
 	  <file:Documentation/sound/oss/ESS1868> and
-	  <file:Documentation/sound/oss/ESS>). If you have an SB AWE 32 or SB AWE
-	  64, say Y here and also to "AWE32 synth" below and read
-	  <file:Documentation/sound/oss/INSTALL.awe>. If you have an IBM Mwave
+	  <file:Documentation/sound/oss/ESS>). If you have an IBM Mwave
 	  card, say Y here and read <file:Documentation/sound/oss/mwave>.
 
 	  If you compile the driver into the kernel and don't want to use
-- 
1.7.6.3



