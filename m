Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab0D1XPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:15:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:44234 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434Ab0D1XPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:15:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,290,1270450800"; 
   d="scan'208,223";a="793769552"
From: "Epshteyn, Eugene" <eugene.epshteyn@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Apr 2010 16:10:46 -0700
Subject: [RFC PATCH 3/4] Mobile security processor driver
Thread-Topic: [RFC PATCH 3/4] Mobile security processor driver
Thread-Index: AcrnHTqnBuyRMjAzTu2GJu39K1aGxwACo6zQ
Message-ID: <753F67ADE6F5094C9F1DBA00D1BAA8D325518252AE@orsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {B4672A3D-2304-4B8F-844A-98CD9D0BCCCD}
x-cr-hashedpuzzle: BL+T BPSn B6i4 CRXQ CUZs CcF+ DBLM EEeA GFyN HjUR I3mk
 I8lF K0c5 K4Js LC07
 LVDl;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{B4672A3D-2304-4B8F-844A-98CD9D0BCCCD};ZQB1AGcAZQBuAGUALgBlAHAAcwBoAHQAZQB5AG4AQABpAG4AdABlAGwALgBjAG8AbQA=;Wed,
 28 Apr 2010 23:12:00
 GMT;WwBSAEYAQwAgAFAAQQBUAEMASAAgADMALwA0AF0AIABNAG8AYgBpAGwAZQAgAHMAZQBjAHUAcgBpAHQAeQAgAHAAcgBvAGMAZQBzAHMAbwByACAAZAByAGkAdgBlAHIA
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252AEorsmsx501amrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252AEorsmsx501amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

>From 14e6bd039387b507d67155cd5d7d0e2a78166987 Mon Sep 17 00:00:00 2001
From: Mark Allyn <mark.a.allyn@intel.com>
Date: Wed, 28 Apr 2010 14:39:30 -0700
Subject: RFC [PATCH 3/4] staging: sep: update program files for SEP Decembe=
r 2009 release

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
  drivers/staging/sep/sep_driver.c              | 2715 --------------------
  drivers/staging/sep/sep_ext_with_pci_driver.c |  548 ++++
  drivers/staging/sep/sep_main_mod.c            | 3330 ++++++++++++++++++++=
+++++
  3 files changed, 3878 insertions(+), 2715 deletions(-)
  delete mode 100644 drivers/staging/sep/sep_driver.c
  create mode 100644 drivers/staging/sep/sep_ext_with_pci_driver.c
  create mode 100644 drivers/staging/sep/sep_main_mod.c

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_dri=
ver.c
deleted file mode 100644
index 8888073..0000000
--- a/drivers/staging/sep/sep_driver.c
+++ /dev/null
@@ -1,2715 +0,0 @@
-/*
- *
- *  sep_driver.c - Security Processor Driver main group of functions
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *  Copyright(c) 2009 Discretix. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or modify i=
t
- *  under the terms of the GNU General Public License as published by the =
Free
- *  Software Foundation; either version 2 of the License, or (at your opti=
on)
- *  any later version.
- *
- *  This program is distributed in the hope that it will be useful, but WI=
THOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License =
for
- *  more details.
- *
- *  You should have received a copy of the GNU General Public License alon=
g with
- *  this program; if not, write to the Free Software Foundation, Inc., 59
- *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- *  CONTACTS:
- *
- *  Mark Allyn         mark.a.allyn@intel.com
- *
- *  CHANGES:
- *
- *  2009.06.26 Initial publish
- *
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/cdev.h>
-#include <linux/kdev_t.h>
-#include <linux/mutex.h>
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/poll.h>
-#include <linux/wait.h>
-#include <linux/sched.h>
-#include <linux/pci.h>
-#include <linux/firmware.h>
-#include <linux/slab.h>
-#include <asm/ioctl.h>
-#include <linux/ioport.h>
-#include <asm/io.h>
-#include <linux/interrupt.h>
-#include <linux/pagemap.h>
-#include <asm/cacheflush.h>
-#include "sep_driver_hw_defs.h"
-#include "sep_driver_config.h"
-#include "sep_driver_api.h"
-#include "sep_dev.h"
-
-#if SEP_DRIVER_ARM_DEBUG_MODE
-
-#define  CRYS_SEP_ROM_length                  0x4000
-#define  CRYS_SEP_ROM_start_address           0x8000C000UL
-#define  CRYS_SEP_ROM_start_address_offset    0xC000UL
-#define  SEP_ROM_BANK_register                0x80008420UL
-#define  SEP_ROM_BANK_register_offset         0x8420UL
-#define SEP_RAR_IO_MEM_REGION_START_ADDRESS   0x82000000
-
-/*
- * THESE 2 definitions are specific to the board - must be
- * defined during integration
- */
-#define SEP_RAR_IO_MEM_REGION_START_ADDRESS   0xFF0D0000
-
-/* 2M size */
-
-static void sep_load_rom_code(struct sep_device *sep)
-{
-       /* Index variables */
-       unsigned long i, k, j;
-       u32 reg;
-       u32 error;
-       u32 warning;
-
-       /* Loading ROM from SEP_ROM_image.h file */
-       k =3D sizeof(CRYS_SEP_ROM);
-
-       edbg("SEP Driver: DX_CC_TST_SepRomLoader start\n");
-
-       edbg("SEP Driver: k is %lu\n", k);
-       edbg("SEP Driver: sep->reg_addr is %p\n", sep->reg_addr);
-       edbg("SEP Driver: CRYS_SEP_ROM_start_address_offset is %p\n", CRYS_=
SEP_ROM_start_address_offset);
-
-       for (i =3D 0; i < 4; i++) {
-               /* write bank */
-               sep_write_reg(sep, SEP_ROM_BANK_register_offset, i);
-
-               for (j =3D 0; j < CRYS_SEP_ROM_length / 4; j++) {
-                       sep_write_reg(sep, CRYS_SEP_ROM_start_address_offse=
t + 4 * j, CRYS_SEP_ROM[i * 0x1000 + j]);
-
-                       k =3D k - 4;
-
-                       if (k =3D=3D 0) {
-                               j =3D CRYS_SEP_ROM_length;
-                               i =3D 4;
-                       }
-               }
-       }
-
-       /* reset the SEP */
-       sep_write_reg(sep, HW_HOST_SEP_SW_RST_REG_ADDR, 0x1);
-
-       /* poll for SEP ROM boot finish */
-       do
-               reg =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
-       while (!reg);
-
-       edbg("SEP Driver: ROM polling ended\n");
-
-       switch (reg) {
-       case 0x1:
-               /* fatal error - read erro status from GPRO */
-               error =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR0_REG_ADDR)=
;
-               edbg("SEP Driver: ROM polling case 1\n");
-               break;
-       case 0x4:
-               /* Cold boot ended successfully  */
-       case 0x8:
-               /* Warmboot ended successfully */
-       case 0x10:
-               /* ColdWarm boot ended successfully */
-               error =3D 0;
-       case 0x2:
-               /* Boot First Phase ended  */
-               warning =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR0_REG_ADD=
R);
-       case 0x20:
-               edbg("SEP Driver: ROM polling case %d\n", reg);
-               break;
-       }
-
-}
-
-#else
-static void sep_load_rom_code(struct sep_device *sep) { }
-#endif                         /* SEP_DRIVER_ARM_DEBUG_MODE */
-
-
-
-/*----------------------------------------
-       DEFINES
------------------------------------------*/
-
-#define BASE_ADDRESS_FOR_SYSTEM 0xfffc0000
-#define SEP_RAR_IO_MEM_REGION_SIZE 0x40000
-
-/*--------------------------------------------
-       GLOBAL variables
---------------------------------------------*/
-
-/* debug messages level */
-static int debug;
-module_param(debug, int , 0);
-MODULE_PARM_DESC(debug, "Flag to enable SEP debug messages");
-
-/* Keep this a single static object for now to keep the conversion easy */
-
-static struct sep_device sep_instance;
-static struct sep_device *sep_dev =3D &sep_instance;
-
-/*
-  mutex for the access to the internals of the sep driver
-*/
-static DEFINE_MUTEX(sep_mutex);
-
-
-/* wait queue head (event) of the driver */
-static DECLARE_WAIT_QUEUE_HEAD(sep_event);
-
-/**
- *     sep_load_firmware       -       copy firmware cache/resident
- *     @sep: device we are loading
- *
- *     This functions copies the cache and resident from their source
- *     location into destination shared memory.
- */
-
-static int sep_load_firmware(struct sep_device *sep)
-{
-       const struct firmware *fw;
-       char *cache_name =3D "sep/cache.image.bin";
-       char *res_name =3D "sep/resident.image.bin";
-       int error;
-
-       edbg("SEP Driver:rar_virtual is %p\n", sep->rar_addr);
-       edbg("SEP Driver:rar_bus is %08llx\n", (unsigned long long)sep->rar=
_bus);
-
-       /* load cache */
-       error =3D request_firmware(&fw, cache_name, &sep->pdev->dev);
-       if (error) {
-               edbg("SEP Driver:cant request cache fw\n");
-               return error;
-       }
-       edbg("SEP Driver:cache %08Zx@%p\n", fw->size, (void *) fw->data);
-
-       memcpy(sep->rar_addr, (void *)fw->data, fw->size);
-       sep->cache_size =3D fw->size;
-       release_firmware(fw);
-
-       sep->resident_bus =3D sep->rar_bus + sep->cache_size;
-       sep->resident_addr =3D sep->rar_addr + sep->cache_size;
-
-       /* load resident */
-       error =3D request_firmware(&fw, res_name, &sep->pdev->dev);
-       if (error) {
-               edbg("SEP Driver:cant request res fw\n");
-               return error;
-       }
-       edbg("sep: res %08Zx@%p\n", fw->size, (void *)fw->data);
-
-       memcpy(sep->resident_addr, (void *) fw->data, fw->size);
-       sep->resident_size =3D fw->size;
-       release_firmware(fw);
-
-       edbg("sep: resident v %p b %08llx cache v %p b %08llx\n",
-               sep->resident_addr, (unsigned long long)sep->resident_bus,
-               sep->rar_addr, (unsigned long long)sep->rar_bus);
-       return 0;
-}
-
-MODULE_FIRMWARE("sep/cache.image.bin");
-MODULE_FIRMWARE("sep/resident.image.bin");
-
-/**
- *     sep_map_and_alloc_shared_area   -       allocate shared block
- *     @sep: security processor
- *     @size: size of shared area
- *
- *     Allocate a shared buffer in host memory that can be used by both th=
e
- *     kernel and also the hardware interface via DMA.
- */
-
-static int sep_map_and_alloc_shared_area(struct sep_device *sep,
-                                                       unsigned long size)
-{
-       /* shared_addr =3D ioremap_nocache(0xda00000,shared_area_size); */
-       sep->shared_addr =3D dma_alloc_coherent(&sep->pdev->dev, size,
-                                       &sep->shared_bus, GFP_KERNEL);
-
-       if (!sep->shared_addr) {
-               edbg("sep_driver :shared memory dma_alloc_coherent failed\n=
");
-               return -ENOMEM;
-       }
-       /* set the bus address of the shared area */
-       edbg("sep: shared_addr %ld bytes @%p (bus %08llx)\n",
-               size, sep->shared_addr, (unsigned long long)sep->shared_bus=
);
-       return 0;
-}
-
-/**
- *     sep_unmap_and_free_shared_area  -       free shared block
- *     @sep: security processor
- *
- *     Free the shared area allocated to the security processor. The
- *     processor must have finished with this and any final posted
- *     writes cleared before we do so.
- */
-static void sep_unmap_and_free_shared_area(struct sep_device *sep, int siz=
e)
-{
-       dma_free_coherent(&sep->pdev->dev, size,
-                               sep->shared_addr, sep->shared_bus);
-}
-
-/**
- *     sep_shared_virt_to_bus  -       convert bus/virt addresses
- *
- *     Returns the bus address inside the shared area according
- *     to the virtual address.
- */
-
-static dma_addr_t sep_shared_virt_to_bus(struct sep_device *sep,
-                                               void *virt_address)
-{
-       dma_addr_t pa =3D sep->shared_bus + (virt_address - sep->shared_add=
r);
-       edbg("sep: virt to bus b %08llx v %p\n", (unsigned long long) pa,
-                                                               virt_addres=
s);
-       return pa;
-}
-
-/**
- *     sep_shared_bus_to_virt  -       convert bus/virt addresses
- *
- *     Returns virtual address inside the shared area according
- *     to the bus address.
- */
-
-static void *sep_shared_bus_to_virt(struct sep_device *sep,
-                                               dma_addr_t bus_address)
-{
-       return sep->shared_addr + (bus_address - sep->shared_bus);
-}
-
-
-/**
- *     sep_try_open            -       attempt to open a SEP device
- *     @sep: device to attempt to open
- *
- *     Atomically attempt to get ownership of a SEP device.
- *     Returns 1 if the device was opened, 0 on failure.
- */
-
-static int sep_try_open(struct sep_device *sep)
-{
-       if (!test_and_set_bit(0, &sep->in_use))
-               return 1;
-       return 0;
-}
-
-/**
- *     sep_open                -       device open method
- *     @inode: inode of sep device
- *     @filp: file handle to sep device
- *
- *     Open method for the SEP device. Called when userspace opens
- *     the SEP device node. Must also release the memory data pool
- *     allocations.
- *
- *     Returns zero on success otherwise an error code.
- */
-
-static int sep_open(struct inode *inode, struct file *filp)
-{
-       if (sep_dev =3D=3D NULL)
-               return -ENODEV;
-
-       /* check the blocking mode */
-       if (filp->f_flags & O_NDELAY) {
-               if (sep_try_open(sep_dev) =3D=3D 0)
-                       return -EAGAIN;
-       } else
-               if (wait_event_interruptible(sep_event, sep_try_open(sep_de=
v)) < 0)
-                       return -EINTR;
-
-       /* Bind to the device, we only have one which makes it easy */
-       filp->private_data =3D sep_dev;
-       /* release data pool allocations */
-       sep_dev->data_pool_bytes_allocated =3D 0;
-       return 0;
-}
-
-
-/**
- *     sep_release             -       close a SEP device
- *     @inode: inode of SEP device
- *     @filp: file handle being closed
- *
- *     Called on the final close of a SEP device. As the open protects aga=
inst
- *     multiple simultaenous opens that means this method is called when t=
he
- *     final reference to the open handle is dropped.
- */
-
-static int sep_release(struct inode *inode, struct file *filp)
-{
-       struct sep_device *sep =3D  filp->private_data;
-#if 0                          /*!SEP_DRIVER_POLLING_MODE */
-       /* close IMR */
-       sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, 0x7FFF);
-       /* release IRQ line */
-       free_irq(SEP_DIRVER_IRQ_NUM, sep);
-
-#endif
-       /* Ensure any blocked open progresses */
-       clear_bit(0, &sep->in_use);
-       wake_up(&sep_event);
-       return 0;
-}
-
-/*---------------------------------------------------------------
-  map function - this functions maps the message shared area
------------------------------------------------------------------*/
-static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-       dma_addr_t bus_addr;
-       struct sep_device *sep =3D filp->private_data;
-
-       dbg("-------->SEP Driver: mmap start\n");
-
-       /* check that the size of the mapped range is as the size of the me=
ssage
-          shared area */
-       if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
-               edbg("SEP Driver mmap requested size is more than allowed\n=
");
-               printk(KERN_WARNING "SEP Driver mmap requested size is more=
 than allowed\n");
-               printk(KERN_WARNING "SEP Driver vma->vm_end is %08lx\n", vm=
a->vm_end);
-               printk(KERN_WARNING "SEP Driver vma->vm_end is %08lx\n", vm=
a->vm_start);
-               return -EAGAIN;
-       }
-
-       edbg("SEP Driver:sep->shared_addr is %p\n", sep->shared_addr);
-
-       /* get bus address */
-       bus_addr =3D sep->shared_bus;
-
-       edbg("SEP Driver: phys_addr is %08llx\n", (unsigned long long)bus_a=
ddr);
-
-       if (remap_pfn_range(vma, vma->vm_start, bus_addr >> PAGE_SHIFT, vma=
->vm_end - vma->vm_start, vma->vm_page_prot)) {
-               edbg("SEP Driver remap_page_range failed\n");
-               printk(KERN_WARNING "SEP Driver remap_page_range failed\n")=
;
-               return -EAGAIN;
-       }
-
-       dbg("SEP Driver:<-------- mmap end\n");
-
-       return 0;
-}
-
-
-/*-----------------------------------------------
-  poll function
-*----------------------------------------------*/
-static unsigned int sep_poll(struct file *filp, poll_table * wait)
-{
-       unsigned long count;
-       unsigned int mask =3D 0;
-       unsigned long retval =3D 0;       /* flow id */
-       struct sep_device *sep =3D filp->private_data;
-
-       dbg("---------->SEP Driver poll: start\n");
-
-
-#if SEP_DRIVER_POLLING_MODE
-
-       while (sep->send_ct !=3D (retval & 0x7FFFFFFF)) {
-               retval =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR=
);
-
-               for (count =3D 0; count < 10 * 4; count +=3D 4)
-                       edbg("Poll Debug Word %lu of the message is %lu\n",=
 count, *((unsigned long *) (sep->shared_addr + SEP_DRIVER_MESSAGE_SHARED_A=
REA_SIZE_IN_BYTES + count)));
-       }
-
-       sep->reply_ct++;
-#else
-       /* add the event to the polling wait table */
-       poll_wait(filp, &sep_event, wait);
-
-#endif
-
-       edbg("sep->send_ct is %lu\n", sep->send_ct);
-       edbg("sep->reply_ct is %lu\n", sep->reply_ct);
-
-       /* check if the data is ready */
-       if (sep->send_ct =3D=3D sep->reply_ct) {
-               for (count =3D 0; count < 12 * 4; count +=3D 4)
-                       edbg("Sep Mesg Word %lu of the message is %lu\n", c=
ount, *((unsigned long *) (sep->shared_addr + count)));
-
-               for (count =3D 0; count < 10 * 4; count +=3D 4)
-                       edbg("Debug Data Word %lu of the message is %lu\n",=
 count, *((unsigned long *) (sep->shared_addr + 0x1800 + count)));
-
-               retval =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR=
);
-               edbg("retval is %lu\n", retval);
-               /* check if the this is sep reply or request */
-               if (retval >> 31) {
-                       edbg("SEP Driver: sep request in\n");
-                       /* request */
-                       mask |=3D POLLOUT | POLLWRNORM;
-               } else {
-                       edbg("SEP Driver: sep reply in\n");
-                       mask |=3D POLLIN | POLLRDNORM;
-               }
-       }
-       dbg("SEP Driver:<-------- poll exit\n");
-       return mask;
-}
-
-/**
- *     sep_time_address        -       address in SEP memory of time
- *     @sep: SEP device we want the address from
- *
- *     Return the address of the two dwords in memory used for time
- *     setting.
- */
-
-static u32 *sep_time_address(struct sep_device *sep)
-{
-       return sep->shared_addr + SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_B=
YTES;
-}
-
-/**
- *     sep_set_time            -       set the SEP time
- *     @sep: the SEP we are setting the time for
- *
- *     Calculates time and sets it at the predefined address.
- *     Called with the sep mutex held.
- */
-static unsigned long sep_set_time(struct sep_device *sep)
-{
-       struct timeval time;
-       u32 *time_addr; /* address of time as seen by the kernel */
-
-
-       dbg("sep:sep_set_time start\n");
-
-       do_gettimeofday(&time);
-
-       /* set value in the SYSTEM MEMORY offset */
-       time_addr =3D sep_time_address(sep);
-
-       time_addr[0] =3D SEP_TIME_VAL_TOKEN;
-       time_addr[1] =3D time.tv_sec;
-
-       edbg("SEP Driver:time.tv_sec is %lu\n", time.tv_sec);
-       edbg("SEP Driver:time_addr is %p\n", time_addr);
-       edbg("SEP Driver:sep->shared_addr is %p\n", sep->shared_addr);
-
-       return time.tv_sec;
-}
-
-/**
- *     sep_dump_message        - dump the message that is pending
- *     @sep: sep device
- *
- *     Dump out the message pending in the shared message area
- */
-
-static void sep_dump_message(struct sep_device *sep)
-{
-       int count;
-       for (count =3D 0; count < 12 * 4; count +=3D 4)
-               edbg("Word %d of the message is %u\n", count, *((u32 *) (se=
p->shared_addr + count)));
-}
-
-/**
- *     sep_send_command_handler        -       kick off a command
- *     @sep: sep being signalled
- *
- *     This function raises interrupt to SEP that signals that is has a ne=
w
- *     command from the host
- */
-
-static void sep_send_command_handler(struct sep_device *sep)
-{
-       dbg("sep:sep_send_command_handler start\n");
-
-       mutex_lock(&sep_mutex);
-       sep_set_time(sep);
-
-       /* FIXME: flush cache */
-       flush_cache_all();
-
-       sep_dump_message(sep);
-       /* update counter */
-       sep->send_ct++;
-       /* send interrupt to SEP */
-       sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
-       dbg("SEP Driver:<-------- sep_send_command_handler end\n");
-       mutex_unlock(&sep_mutex);
-       return;
-}
-
-/**
- *     sep_send_reply_command_handler  -       kick off a command reply
- *     @sep: sep being signalled
- *
- *     This function raises interrupt to SEP that signals that is has a ne=
w
- *     command from the host
- */
-
-static void sep_send_reply_command_handler(struct sep_device *sep)
-{
-       dbg("sep:sep_send_reply_command_handler start\n");
-
-       /* flash cache */
-       flush_cache_all();
-
-       sep_dump_message(sep);
-
-       mutex_lock(&sep_mutex);
-       sep->send_ct++;         /* update counter */
-       /* send the interrupt to SEP */
-       sep_write_reg(sep, HW_HOST_HOST_SEP_GPR2_REG_ADDR, sep->send_ct);
-       /* update both counters */
-       sep->send_ct++;
-       sep->reply_ct++;
-       mutex_unlock(&sep_mutex);
-       dbg("sep: sep_send_reply_command_handler end\n");
-}
-
-/*
-  This function handles the allocate data pool memory request
-  This function returns calculates the bus address of the
-  allocated memory, and the offset of this area from the mapped address.
-  Therefore, the FVOs in user space can calculate the exact virtual
-  address of this allocated memory
-*/
-static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
-                                                       unsigned long arg)
-{
-       int error;
-       struct sep_driver_alloc_t command_args;
-
-       dbg("SEP Driver:--------> sep_allocate_data_pool_memory_handler sta=
rt\n");
-
-       error =3D copy_from_user(&command_args, (void *) arg, sizeof(struct=
 sep_driver_alloc_t));
-       if (error)
-               goto end_function;
-
-       /* allocate memory */
-       if ((sep->data_pool_bytes_allocated + command_args.num_bytes) > SEP=
_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
-               error =3D -ENOMEM;
-               goto end_function;
-       }
-
-       /* set the virtual and bus address */
-       command_args.offset =3D SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +=
 sep->data_pool_bytes_allocated;
-       command_args.phys_address =3D sep->shared_bus + SEP_DRIVER_DATA_POO=
L_AREA_OFFSET_IN_BYTES + sep->data_pool_bytes_allocated;
-
-       /* write the memory back to the user space */
-       error =3D copy_to_user((void *) arg, (void *) &command_args, sizeof=
(struct sep_driver_alloc_t));
-       if (error)
-               goto end_function;
-
-       /* set the allocation */
-       sep->data_pool_bytes_allocated +=3D command_args.num_bytes;
-
-end_function:
-       dbg("SEP Driver:<-------- sep_allocate_data_pool_memory_handler end=
\n");
-       return error;
-}
-
-/*
-  This function  handles write into allocated data pool command
-*/
-static int sep_write_into_data_pool_handler(struct sep_device *sep, unsign=
ed long arg)
-{
-       int error;
-       void *virt_address;
-       unsigned long va;
-       unsigned long app_in_address;
-       unsigned long num_bytes;
-       void *data_pool_area_addr;
-
-       dbg("SEP Driver:--------> sep_write_into_data_pool_handler start\n"=
);
-
-       /* get the application address */
-       error =3D get_user(app_in_address, &(((struct sep_driver_write_t *)=
 arg)->app_address));
-       if (error)
-               goto end_function;
-
-       /* get the virtual kernel address address */
-       error =3D get_user(va, &(((struct sep_driver_write_t *) arg)->datap=
ool_address));
-       if (error)
-               goto end_function;
-       virt_address =3D (void *)va;
-
-       /* get the number of bytes */
-       error =3D get_user(num_bytes, &(((struct sep_driver_write_t *) arg)=
->num_bytes));
-       if (error)
-               goto end_function;
-
-       /* calculate the start of the data pool */
-       data_pool_area_addr =3D sep->shared_addr + SEP_DRIVER_DATA_POOL_ARE=
A_OFFSET_IN_BYTES;
-
-
-       /* check that the range of the virtual kernel address is correct */
-       if (virt_address < data_pool_area_addr || virt_address > (data_pool=
_area_addr + SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES)) {
-               error =3D -EINVAL;
-               goto end_function;
-       }
-       /* copy the application data */
-       error =3D copy_from_user(virt_address, (void *) app_in_address, num=
_bytes);
-end_function:
-       dbg("SEP Driver:<-------- sep_write_into_data_pool_handler end\n");
-       return error;
-}
-
-/*
-  this function handles the read from data pool command
-*/
-static int sep_read_from_data_pool_handler(struct sep_device *sep, unsigne=
d long arg)
-{
-       int error;
-       /* virtual address of dest application buffer */
-       unsigned long app_out_address;
-       /* virtual address of the data pool */
-       unsigned long va;
-       void *virt_address;
-       unsigned long num_bytes;
-       void *data_pool_area_addr;
-
-       dbg("SEP Driver:--------> sep_read_from_data_pool_handler start\n")=
;
-
-       /* get the application address */
-       error =3D get_user(app_out_address, &(((struct sep_driver_write_t *=
) arg)->app_address));
-       if (error)
-               goto end_function;
-
-       /* get the virtual kernel address address */
-       error =3D get_user(va, &(((struct sep_driver_write_t *) arg)->datap=
ool_address));
-       if (error)
-               goto end_function;
-       virt_address =3D (void *)va;
-
-       /* get the number of bytes */
-       error =3D get_user(num_bytes, &(((struct sep_driver_write_t *) arg)=
->num_bytes));
-       if (error)
-               goto end_function;
-
-       /* calculate the start of the data pool */
-       data_pool_area_addr =3D sep->shared_addr + SEP_DRIVER_DATA_POOL_ARE=
A_OFFSET_IN_BYTES;
-
-       /* FIXME: These are incomplete all over the driver: what about + le=
n
-          and when doing that also overflows */
-       /* check that the range of the virtual kernel address is correct */
-       if (virt_address < data_pool_area_addr || virt_address > data_pool_=
area_addr + SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
-               error =3D -EINVAL;
-               goto end_function;
-       }
-
-       /* copy the application data */
-       error =3D copy_to_user((void *) app_out_address, virt_address, num_=
bytes);
-end_function:
-       dbg("SEP Driver:<-------- sep_read_from_data_pool_handler end\n");
-       return error;
-}
-
-/*
-  This function releases all the application virtual buffer physical pages=
,
-       that were previously locked
-*/
-static int sep_free_dma_pages(struct page **page_array_ptr, unsigned long =
num_pages, unsigned long dirtyFlag)
-{
-       unsigned long count;
-
-       if (dirtyFlag) {
-               for (count =3D 0; count < num_pages; count++) {
-                       /* the out array was written, therefore the data wa=
s changed */
-                       if (!PageReserved(page_array_ptr[count]))
-                               SetPageDirty(page_array_ptr[count]);
-                       page_cache_release(page_array_ptr[count]);
-               }
-       } else {
-               /* free in pages - the data was only read, therefore no upd=
ate was done
-                  on those pages */
-               for (count =3D 0; count < num_pages; count++)
-                       page_cache_release(page_array_ptr[count]);
-       }
-
-       if (page_array_ptr)
-               /* free the array */
-               kfree(page_array_ptr);
-
-       return 0;
-}
-
-/*
-  This function locks all the physical pages of the kernel virtual buffer
-  and construct a basic lli  array, where each entry holds the physical
-  page address and the size that application data holds in this physical p=
ages
-*/
-static int sep_lock_kernel_pages(struct sep_device *sep,
-                                unsigned long kernel_virt_addr,
-                                unsigned long data_size,
-                                unsigned long *num_pages_ptr,
-                                struct sep_lli_entry_t **lli_array_ptr,
-                                struct page ***page_array_ptr)
-{
-       int error =3D 0;
-       /* the the page of the end address of the user space buffer */
-       unsigned long end_page;
-       /* the page of the start address of the user space buffer */
-       unsigned long start_page;
-       /* the range in pages */
-       unsigned long num_pages;
-       struct sep_lli_entry_t *lli_array;
-       /* next kernel address to map */
-       unsigned long next_kernel_address;
-       unsigned long count;
-
-       dbg("SEP Driver:--------> sep_lock_kernel_pages start\n");
-
-       /* set start and end pages  and num pages */
-       end_page =3D (kernel_virt_addr + data_size - 1) >> PAGE_SHIFT;
-       start_page =3D kernel_virt_addr >> PAGE_SHIFT;
-       num_pages =3D end_page - start_page + 1;
-
-       edbg("SEP Driver: kernel_virt_addr is %08lx\n", kernel_virt_addr);
-       edbg("SEP Driver: data_size is %lu\n", data_size);
-       edbg("SEP Driver: start_page is %lx\n", start_page);
-       edbg("SEP Driver: end_page is %lx\n", end_page);
-       edbg("SEP Driver: num_pages is %lu\n", num_pages);
-
-       lli_array =3D kmalloc(sizeof(struct sep_lli_entry_t) * num_pages, G=
FP_ATOMIC);
-       if (!lli_array) {
-               edbg("SEP Driver: kmalloc for lli_array failed\n");
-               error =3D -ENOMEM;
-               goto end_function;
-       }
-
-       /* set the start address of the first page - app data may start not=
 at
-          the beginning of the page */
-       lli_array[0].physical_address =3D (unsigned long) virt_to_phys((uns=
igned long *) kernel_virt_addr);
-
-       /* check that not all the data is in the first page only */
-       if ((PAGE_SIZE - (kernel_virt_addr & (~PAGE_MASK))) >=3D data_size)
-               lli_array[0].block_size =3D data_size;
-       else
-               lli_array[0].block_size =3D PAGE_SIZE - (kernel_virt_addr &=
 (~PAGE_MASK));
-
-       /* debug print */
-       dbg("lli_array[0].physical_address is %08lx, lli_array[0].block_siz=
e is %lu\n", lli_array[0].physical_address, lli_array[0].block_size);
-
-       /* advance the address to the start of the next page */
-       next_kernel_address =3D (kernel_virt_addr & PAGE_MASK) + PAGE_SIZE;
-
-       /* go from the second page to the prev before last */
-       for (count =3D 1; count < (num_pages - 1); count++) {
-               lli_array[count].physical_address =3D (unsigned long) virt_=
to_phys((unsigned long *) next_kernel_address);
-               lli_array[count].block_size =3D PAGE_SIZE;
-
-               edbg("lli_array[%lu].physical_address is %08lx, lli_array[%=
lu].block_size is %lu\n", count, lli_array[count].physical_address, count, =
lli_array[count].block_size);
-               next_kernel_address +=3D PAGE_SIZE;
-       }
-
-       /* if more then 1 pages locked - then update for the last page size=
 needed */
-       if (num_pages > 1) {
-               /* update the address of the last page */
-               lli_array[count].physical_address =3D (unsigned long) virt_=
to_phys((unsigned long *) next_kernel_address);
-
-               /* set the size of the last page */
-               lli_array[count].block_size =3D (kernel_virt_addr + data_si=
ze) & (~PAGE_MASK);
-
-               if (lli_array[count].block_size =3D=3D 0) {
-                       dbg("app_virt_addr is %08lx\n", kernel_virt_addr);
-                       dbg("data_size is %lu\n", data_size);
-                       while (1);
-               }
-
-               edbg("lli_array[%lu].physical_address is %08lx, lli_array[%=
lu].block_size is %lu\n", count, lli_array[count].physical_address, count, =
lli_array[count].block_size);
-       }
-       /* set output params */
-       *lli_array_ptr =3D lli_array;
-       *num_pages_ptr =3D num_pages;
-       *page_array_ptr =3D 0;
-end_function:
-       dbg("SEP Driver:<-------- sep_lock_kernel_pages end\n");
-       return 0;
-}
-
-/*
-  This function locks all the physical pages of the application virtual bu=
ffer
-  and construct a basic lli  array, where each entry holds the physical pa=
ge
-  address and the size that application data holds in this physical pages
-*/
-static int sep_lock_user_pages(struct sep_device *sep,
-                       unsigned long app_virt_addr,
-                       unsigned long data_size,
-                       unsigned long *num_pages_ptr,
-                       struct sep_lli_entry_t **lli_array_ptr,
-                       struct page ***page_array_ptr)
-{
-       int error =3D 0;
-       /* the the page of the end address of the user space buffer */
-       unsigned long end_page;
-       /* the page of the start address of the user space buffer */
-       unsigned long start_page;
-       /* the range in pages */
-       unsigned long num_pages;
-       struct page **page_array;
-       struct sep_lli_entry_t *lli_array;
-       unsigned long count;
-       int result;
-
-       dbg("SEP Driver:--------> sep_lock_user_pages start\n");
-
-       /* set start and end pages  and num pages */
-       end_page =3D (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
-       start_page =3D app_virt_addr >> PAGE_SHIFT;
-       num_pages =3D end_page - start_page + 1;
-
-       edbg("SEP Driver: app_virt_addr is %08lx\n", app_virt_addr);
-       edbg("SEP Driver: data_size is %lu\n", data_size);
-       edbg("SEP Driver: start_page is %lu\n", start_page);
-       edbg("SEP Driver: end_page is %lu\n", end_page);
-       edbg("SEP Driver: num_pages is %lu\n", num_pages);
-
-       /* allocate array of pages structure pointers */
-       page_array =3D kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMI=
C);
-       if (!page_array) {
-               edbg("SEP Driver: kmalloc for page_array failed\n");
-
-               error =3D -ENOMEM;
-               goto end_function;
-       }
-
-       lli_array =3D kmalloc(sizeof(struct sep_lli_entry_t) * num_pages, G=
FP_ATOMIC);
-       if (!lli_array) {
-               edbg("SEP Driver: kmalloc for lli_array failed\n");
-
-               error =3D -ENOMEM;
-               goto end_function_with_error1;
-       }
-
-       /* convert the application virtual address into a set of physical *=
/
-       down_read(&current->mm->mmap_sem);
-       result =3D get_user_pages(current, current->mm, app_virt_addr, num_=
pages, 1, 0, page_array, 0);
-       up_read(&current->mm->mmap_sem);
-
-       /* check the number of pages locked - if not all then exit with err=
or */
-       if (result !=3D num_pages) {
-               dbg("SEP Driver: not all pages locked by get_user_pages\n")=
;
-
-               error =3D -ENOMEM;
-               goto end_function_with_error2;
-       }
-
-       /* flush the cache */
-       for (count =3D 0; count < num_pages; count++)
-               flush_dcache_page(page_array[count]);
-
-       /* set the start address of the first page - app data may start not=
 at
-          the beginning of the page */
-       lli_array[0].physical_address =3D ((unsigned long) page_to_phys(pag=
e_array[0])) + (app_virt_addr & (~PAGE_MASK));
-
-       /* check that not all the data is in the first page only */
-       if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >=3D data_size)
-               lli_array[0].block_size =3D data_size;
-       else
-               lli_array[0].block_size =3D PAGE_SIZE - (app_virt_addr & (~=
PAGE_MASK));
-
-       /* debug print */
-       dbg("lli_array[0].physical_address is %08lx, lli_array[0].block_siz=
e is %lu\n", lli_array[0].physical_address, lli_array[0].block_size);
-
-       /* go from the second page to the prev before last */
-       for (count =3D 1; count < (num_pages - 1); count++) {
-               lli_array[count].physical_address =3D (unsigned long) page_=
to_phys(page_array[count]);
-               lli_array[count].block_size =3D PAGE_SIZE;
-
-               edbg("lli_array[%lu].physical_address is %08lx, lli_array[%=
lu].block_size is %lu\n", count, lli_array[count].physical_address, count, =
lli_array[count].block_size);
-       }
-
-       /* if more then 1 pages locked - then update for the last page size=
 needed */
-       if (num_pages > 1) {
-               /* update the address of the last page */
-               lli_array[count].physical_address =3D (unsigned long) page_=
to_phys(page_array[count]);
-
-               /* set the size of the last page */
-               lli_array[count].block_size =3D (app_virt_addr + data_size)=
 & (~PAGE_MASK);
-
-               if (lli_array[count].block_size =3D=3D 0) {
-                       dbg("app_virt_addr is %08lx\n", app_virt_addr);
-                       dbg("data_size is %lu\n", data_size);
-                       while (1);
-               }
-               edbg("lli_array[%lu].physical_address is %08lx, lli_array[%=
lu].block_size is %lu\n",
-                    count, lli_array[count].physical_address,
-                    count, lli_array[count].block_size);
-       }
-
-       /* set output params */
-       *lli_array_ptr =3D lli_array;
-       *num_pages_ptr =3D num_pages;
-       *page_array_ptr =3D page_array;
-       goto end_function;
-
-end_function_with_error2:
-       /* release the cache */
-       for (count =3D 0; count < num_pages; count++)
-               page_cache_release(page_array[count]);
-       kfree(lli_array);
-end_function_with_error1:
-       kfree(page_array);
-end_function:
-       dbg("SEP Driver:<-------- sep_lock_user_pages end\n");
-       return 0;
-}
-
-
-/*
-  this function calculates the size of data that can be inserted into the =
lli
-  table from this array the condition is that either the table is full
-  (all etnries are entered), or there are no more entries in the lli array
-*/
-static unsigned long sep_calculate_lli_table_max_size(struct sep_lli_entry=
_t *lli_in_array_ptr, unsigned long num_array_entries)
-{
-       unsigned long table_data_size =3D 0;
-       unsigned long counter;
-
-       /* calculate the data in the out lli table if till we fill the whol=
e
-          table or till the data has ended */
-       for (counter =3D 0; (counter < (SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP=
 - 1)) && (counter < num_array_entries); counter++)
-               table_data_size +=3D lli_in_array_ptr[counter].block_size;
-       return table_data_size;
-}
-
-/*
-  this functions builds ont lli table from the lli_array according to
-  the given size of data
-*/
-static void sep_build_lli_table(struct sep_lli_entry_t *lli_array_ptr, str=
uct sep_lli_entry_t *lli_table_ptr, unsigned long *num_processed_entries_pt=
r, unsigned long *num_table_entries_ptr, unsigned long table_data_size)
-{
-       unsigned long curr_table_data_size;
-       /* counter of lli array entry */
-       unsigned long array_counter;
-
-       dbg("SEP Driver:--------> sep_build_lli_table start\n");
-
-       /* init currrent table data size and lli array entry counter */
-       curr_table_data_size =3D 0;
-       array_counter =3D 0;
-       *num_table_entries_ptr =3D 1;
-
-       edbg("SEP Driver:table_data_size is %lu\n", table_data_size);
-
-       /* fill the table till table size reaches the needed amount */
-       while (curr_table_data_size < table_data_size) {
-               /* update the number of entries in table */
-               (*num_table_entries_ptr)++;
-
-               lli_table_ptr->physical_address =3D lli_array_ptr[array_cou=
nter].physical_address;
-               lli_table_ptr->block_size =3D lli_array_ptr[array_counter].=
block_size;
-               curr_table_data_size +=3D lli_table_ptr->block_size;
-
-               edbg("SEP Driver:lli_table_ptr is %08lx\n", (unsigned long)=
 lli_table_ptr);
-               edbg("SEP Driver:lli_table_ptr->physical_address is %08lx\n=
", lli_table_ptr->physical_address);
-               edbg("SEP Driver:lli_table_ptr->block_size is %lu\n", lli_t=
able_ptr->block_size);
-
-               /* check for overflow of the table data */
-               if (curr_table_data_size > table_data_size) {
-                       edbg("SEP Driver:curr_table_data_size > table_data_=
size\n");
-
-                       /* update the size of block in the table */
-                       lli_table_ptr->block_size -=3D (curr_table_data_siz=
e - table_data_size);
-
-                       /* update the physical address in the lli array */
-                       lli_array_ptr[array_counter].physical_address +=3D =
lli_table_ptr->block_size;
-
-                       /* update the block size left in the lli array */
-                       lli_array_ptr[array_counter].block_size =3D (curr_t=
able_data_size - table_data_size);
-               } else
-                       /* advance to the next entry in the lli_array */
-                       array_counter++;
-
-               edbg("SEP Driver:lli_table_ptr->physical_address is %08lx\n=
", lli_table_ptr->physical_address);
-               edbg("SEP Driver:lli_table_ptr->block_size is %lu\n", lli_t=
able_ptr->block_size);
-
-               /* move to the next entry in table */
-               lli_table_ptr++;
-       }
-
-       /* set the info entry to default */
-       lli_table_ptr->physical_address =3D 0xffffffff;
-       lli_table_ptr->block_size =3D 0;
-
-       edbg("SEP Driver:lli_table_ptr is %08lx\n", (unsigned long) lli_tab=
le_ptr);
-       edbg("SEP Driver:lli_table_ptr->physical_address is %08lx\n", lli_t=
able_ptr->physical_address);
-       edbg("SEP Driver:lli_table_ptr->block_size is %lu\n", lli_table_ptr=
->block_size);
-
-       /* set the output parameter */
-       *num_processed_entries_ptr +=3D array_counter;
-
-       edbg("SEP Driver:*num_processed_entries_ptr is %lu\n", *num_process=
ed_entries_ptr);
-       dbg("SEP Driver:<-------- sep_build_lli_table end\n");
-       return;
-}
-
-/*
-  this function goes over the list of the print created tables and
-  prints all the data
-*/
-static void sep_debug_print_lli_tables(struct sep_device *sep, struct sep_=
lli_entry_t *lli_table_ptr, unsigned long num_table_entries, unsigned long =
table_data_size)
-{
-       unsigned long table_count;
-       unsigned long entries_count;
-
-       dbg("SEP Driver:--------> sep_debug_print_lli_tables start\n");
-
-       table_count =3D 1;
-       while ((unsigned long) lli_table_ptr !=3D 0xffffffff) {
-               edbg("SEP Driver: lli table %08lx, table_data_size is %lu\n=
", table_count, table_data_size);
-               edbg("SEP Driver: num_table_entries is %lu\n", num_table_en=
tries);
-
-               /* print entries of the table (without info entry) */
-               for (entries_count =3D 0; entries_count < num_table_entries=
; entries_count++, lli_table_ptr++) {
-                       edbg("SEP Driver:lli_table_ptr address is %08lx\n",=
 (unsigned long) lli_table_ptr);
-                       edbg("SEP Driver:phys address is %08lx block size i=
s %lu\n", lli_table_ptr->physical_address, lli_table_ptr->block_size);
-               }
-
-               /* point to the info entry */
-               lli_table_ptr--;
-
-               edbg("SEP Driver:phys lli_table_ptr->block_size is %lu\n", =
lli_table_ptr->block_size);
-               edbg("SEP Driver:phys lli_table_ptr->physical_address is %0=
8lx\n", lli_table_ptr->physical_address);
-
-
-               table_data_size =3D lli_table_ptr->block_size & 0xffffff;
-               num_table_entries =3D (lli_table_ptr->block_size >> 24) & 0=
xff;
-               lli_table_ptr =3D (struct sep_lli_entry_t *)
-                   (lli_table_ptr->physical_address);
-
-               edbg("SEP Driver:phys table_data_size is %lu num_table_entr=
ies is %lu lli_table_ptr is%lu\n", table_data_size, num_table_entries, (uns=
igned long) lli_table_ptr);
-
-               if ((unsigned long) lli_table_ptr !=3D 0xffffffff)
-                       lli_table_ptr =3D (struct sep_lli_entry_t *) sep_sh=
ared_bus_to_virt(sep, (unsigned long) lli_table_ptr);
-
-               table_count++;
-       }
-       dbg("SEP Driver:<-------- sep_debug_print_lli_tables end\n");
-}
-
-
-/*
-  This function prepares only input DMA table for synhronic symmetric
-  operations (HASH)
-*/
-static int sep_prepare_input_dma_table(struct sep_device *sep,
-                               unsigned long app_virt_addr,
-                               unsigned long data_size,
-                               unsigned long block_size,
-                               unsigned long *lli_table_ptr,
-                               unsigned long *num_entries_ptr,
-                               unsigned long *table_data_size_ptr,
-                               bool isKernelVirtualAddress)
-{
-       /* pointer to the info entry of the table - the last entry */
-       struct sep_lli_entry_t *info_entry_ptr;
-       /* array of pointers ot page */
-       struct sep_lli_entry_t *lli_array_ptr;
-       /* points to the first entry to be processed in the lli_in_array */
-       unsigned long current_entry;
-       /* num entries in the virtual buffer */
-       unsigned long sep_lli_entries;
-       /* lli table pointer */
-       struct sep_lli_entry_t *in_lli_table_ptr;
-       /* the total data in one table */
-       unsigned long table_data_size;
-       /* number of entries in lli table */
-       unsigned long num_entries_in_table;
-       /* next table address */
-       void *lli_table_alloc_addr;
-       unsigned long result;
-
-       dbg("SEP Driver:--------> sep_prepare_input_dma_table start\n");
-
-       edbg("SEP Driver:data_size is %lu\n", data_size);
-       edbg("SEP Driver:block_size is %lu\n", block_size);
-
-       /* initialize the pages pointers */
-       sep->in_page_array =3D 0;
-       sep->in_num_pages =3D 0;
-
-       if (data_size =3D=3D 0) {
-               /* special case  - created 2 entries table with zero data *=
/
-               in_lli_table_ptr =3D (struct sep_lli_entry_t *) (sep->share=
d_addr + SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES);
-               /* FIXME: Should the entry below not be for _bus */
-               in_lli_table_ptr->physical_address =3D (unsigned long)sep->=
shared_addr + SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES;
-               in_lli_table_ptr->block_size =3D 0;
-
-               in_lli_table_ptr++;
-               in_lli_table_ptr->physical_address =3D 0xFFFFFFFF;
-               in_lli_table_ptr->block_size =3D 0;
-
-               *lli_table_ptr =3D sep->shared_bus + SEP_DRIVER_SYNCHRONIC_=
DMA_TABLES_AREA_OFFSET_IN_BYTES;
-               *num_entries_ptr =3D 2;
-               *table_data_size_ptr =3D 0;
-
-               goto end_function;
-       }
-
-       /* check if the pages are in Kernel Virtual Address layout */
-       if (isKernelVirtualAddress =3D=3D true)
-               /* lock the pages of the kernel buffer and translate them t=
o pages */
-               result =3D sep_lock_kernel_pages(sep, app_virt_addr, data_s=
ize, &sep->in_num_pages, &lli_array_ptr, &sep->in_page_array);
-       else
-               /* lock the pages of the user buffer and translate them to =
pages */
-               result =3D sep_lock_user_pages(sep, app_virt_addr, data_siz=
e, &sep->in_num_pages, &lli_array_ptr, &sep->in_page_array);
-
-       if (result)
-               return result;
-
-       edbg("SEP Driver:output sep->in_num_pages is %lu\n", sep->in_num_pa=
ges);
-
-       current_entry =3D 0;
-       info_entry_ptr =3D 0;
-       sep_lli_entries =3D sep->in_num_pages;
-
-       /* initiate to point after the message area */
-       lli_table_alloc_addr =3D sep->shared_addr + SEP_DRIVER_SYNCHRONIC_D=
MA_TABLES_AREA_OFFSET_IN_BYTES;
-
-       /* loop till all the entries in in array are not processed */
-       while (current_entry < sep_lli_entries) {
-               /* set the new input and output tables */
-               in_lli_table_ptr =3D (struct sep_lli_entry_t *) lli_table_a=
lloc_addr;
-
-               lli_table_alloc_addr +=3D sizeof(struct sep_lli_entry_t) * =
SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
-
-               /* calculate the maximum size of data for input table */
-               table_data_size =3D sep_calculate_lli_table_max_size(&lli_a=
rray_ptr[current_entry], (sep_lli_entries - current_entry));
-
-               /* now calculate the table size so that it will be module b=
lock size */
-               table_data_size =3D (table_data_size / block_size) * block_=
size;
-
-               edbg("SEP Driver:output table_data_size is %lu\n", table_da=
ta_size);
-
-               /* construct input lli table */
-               sep_build_lli_table(&lli_array_ptr[current_entry], in_lli_t=
able_ptr, &current_entry, &num_entries_in_table, table_data_size);
-
-               if (info_entry_ptr =3D=3D 0) {
-                       /* set the output parameters to physical addresses =
*/
-                       *lli_table_ptr =3D sep_shared_virt_to_bus(sep, in_l=
li_table_ptr);
-                       *num_entries_ptr =3D num_entries_in_table;
-                       *table_data_size_ptr =3D table_data_size;
-
-                       edbg("SEP Driver:output lli_table_in_ptr is %08lx\n=
", *lli_table_ptr);
-               } else {
-                       /* update the info entry of the previous in table *=
/
-                       info_entry_ptr->physical_address =3D sep_shared_vir=
t_to_bus(sep, in_lli_table_ptr);
-                       info_entry_ptr->block_size =3D ((num_entries_in_tab=
le) << 24) | (table_data_size);
-               }
-
-               /* save the pointer to the info entry of the current tables=
 */
-               info_entry_ptr =3D in_lli_table_ptr + num_entries_in_table =
- 1;
-       }
-
-       /* print input tables */
-       sep_debug_print_lli_tables(sep, (struct sep_lli_entry_t *)
-                                  sep_shared_bus_to_virt(sep, *lli_table_p=
tr), *num_entries_ptr, *table_data_size_ptr);
-
-       /* the array of the pages */
-       kfree(lli_array_ptr);
-end_function:
-       dbg("SEP Driver:<-------- sep_prepare_input_dma_table end\n");
-       return 0;
-
-}
-
-/*
- This function creates the input and output dma tables for
- symmetric operations (AES/DES) according to the block size from LLI arays
-*/
-static int sep_construct_dma_tables_from_lli(struct sep_device *sep,
-                                     struct sep_lli_entry_t *lli_in_array,
-                                     unsigned long sep_in_lli_entries,
-                                     struct sep_lli_entry_t *lli_out_array=
,
-                                     unsigned long sep_out_lli_entries,
-                                     unsigned long block_size, unsigned lo=
ng *lli_table_in_ptr, unsigned long *lli_table_out_ptr, unsigned long *in_n=
um_entries_ptr, unsigned long *out_num_entries_ptr, unsigned long *table_da=
ta_size_ptr)
-{
-       /* points to the area where next lli table can be allocated: keep v=
oid *
-          as there is pointer scaling to fix otherwise */
-       void *lli_table_alloc_addr;
-       /* input lli table */
-       struct sep_lli_entry_t *in_lli_table_ptr;
-       /* output lli table */
-       struct sep_lli_entry_t *out_lli_table_ptr;
-       /* pointer to the info entry of the table - the last entry */
-       struct sep_lli_entry_t *info_in_entry_ptr;
-       /* pointer to the info entry of the table - the last entry */
-       struct sep_lli_entry_t *info_out_entry_ptr;
-       /* points to the first entry to be processed in the lli_in_array */
-       unsigned long current_in_entry;
-       /* points to the first entry to be processed in the lli_out_array *=
/
-       unsigned long current_out_entry;
-       /* max size of the input table */
-       unsigned long in_table_data_size;
-       /* max size of the output table */
-       unsigned long out_table_data_size;
-       /* flag te signifies if this is the first tables build from the arr=
ays */
-       unsigned long first_table_flag;
-       /* the data size that should be in table */
-       unsigned long table_data_size;
-       /* number of etnries in the input table */
-       unsigned long num_entries_in_table;
-       /* number of etnries in the output table */
-       unsigned long num_entries_out_table;
-
-       dbg("SEP Driver:--------> sep_construct_dma_tables_from_lli start\n=
");
-
-       /* initiate to pint after the message area */
-       lli_table_alloc_addr =3D sep->shared_addr + SEP_DRIVER_SYNCHRONIC_D=
MA_TABLES_AREA_OFFSET_IN_BYTES;
-
-       current_in_entry =3D 0;
-       current_out_entry =3D 0;
-       first_table_flag =3D 1;
-       info_in_entry_ptr =3D 0;
-       info_out_entry_ptr =3D 0;
-
-       /* loop till all the entries in in array are not processed */
-       while (current_in_entry < sep_in_lli_entries) {
-               /* set the new input and output tables */
-               in_lli_table_ptr =3D (struct sep_lli_entry_t *) lli_table_a=
lloc_addr;
-
-               lli_table_alloc_addr +=3D sizeof(struct sep_lli_entry_t) * =
SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
-
-               /* set the first output tables */
-               out_lli_table_ptr =3D (struct sep_lli_entry_t *) lli_table_=
alloc_addr;
-
-               lli_table_alloc_addr +=3D sizeof(struct sep_lli_entry_t) * =
SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
-
-               /* calculate the maximum size of data for input table */
-               in_table_data_size =3D sep_calculate_lli_table_max_size(&ll=
i_in_array[current_in_entry], (sep_in_lli_entries - current_in_entry));
-
-               /* calculate the maximum size of data for output table */
-               out_table_data_size =3D sep_calculate_lli_table_max_size(&l=
li_out_array[current_out_entry], (sep_out_lli_entries - current_out_entry))=
;
-
-               edbg("SEP Driver:in_table_data_size is %lu\n", in_table_dat=
a_size);
-               edbg("SEP Driver:out_table_data_size is %lu\n", out_table_d=
ata_size);
-
-               /* check where the data is smallest */
-               table_data_size =3D in_table_data_size;
-               if (table_data_size > out_table_data_size)
-                       table_data_size =3D out_table_data_size;
-
-               /* now calculate the table size so that it will be module b=
lock size */
-               table_data_size =3D (table_data_size / block_size) * block_=
size;
-
-               dbg("SEP Driver:table_data_size is %lu\n", table_data_size)=
;
-
-               /* construct input lli table */
-               sep_build_lli_table(&lli_in_array[current_in_entry], in_lli=
_table_ptr, &current_in_entry, &num_entries_in_table, table_data_size);
-
-               /* construct output lli table */
-               sep_build_lli_table(&lli_out_array[current_out_entry], out_=
lli_table_ptr, &current_out_entry, &num_entries_out_table, table_data_size)=
;
-
-               /* if info entry is null - this is the first table built */
-               if (info_in_entry_ptr =3D=3D 0) {
-                       /* set the output parameters to physical addresses =
*/
-                       *lli_table_in_ptr =3D sep_shared_virt_to_bus(sep, i=
n_lli_table_ptr);
-                       *in_num_entries_ptr =3D num_entries_in_table;
-                       *lli_table_out_ptr =3D sep_shared_virt_to_bus(sep, =
out_lli_table_ptr);
-                       *out_num_entries_ptr =3D num_entries_out_table;
-                       *table_data_size_ptr =3D table_data_size;
-
-                       edbg("SEP Driver:output lli_table_in_ptr is %08lx\n=
", *lli_table_in_ptr);
-                       edbg("SEP Driver:output lli_table_out_ptr is %08lx\=
n", *lli_table_out_ptr);
-               } else {
-                       /* update the info entry of the previous in table *=
/
-                       info_in_entry_ptr->physical_address =3D sep_shared_=
virt_to_bus(sep, in_lli_table_ptr);
-                       info_in_entry_ptr->block_size =3D ((num_entries_in_=
table) << 24) | (table_data_size);
-
-                       /* update the info entry of the previous in table *=
/
-                       info_out_entry_ptr->physical_address =3D sep_shared=
_virt_to_bus(sep, out_lli_table_ptr);
-                       info_out_entry_ptr->block_size =3D ((num_entries_ou=
t_table) << 24) | (table_data_size);
-               }
-
-               /* save the pointer to the info entry of the current tables=
 */
-               info_in_entry_ptr =3D in_lli_table_ptr + num_entries_in_tab=
le - 1;
-               info_out_entry_ptr =3D out_lli_table_ptr + num_entries_out_=
table - 1;
-
-               edbg("SEP Driver:output num_entries_out_table is %lu\n", (u=
nsigned long) num_entries_out_table);
-               edbg("SEP Driver:output info_in_entry_ptr is %lu\n", (unsig=
ned long) info_in_entry_ptr);
-               edbg("SEP Driver:output info_out_entry_ptr is %lu\n", (unsi=
gned long) info_out_entry_ptr);
-       }
-
-       /* print input tables */
-       sep_debug_print_lli_tables(sep, (struct sep_lli_entry_t *)
-                                  sep_shared_bus_to_virt(sep, *lli_table_i=
n_ptr), *in_num_entries_ptr, *table_data_size_ptr);
-       /* print output tables */
-       sep_debug_print_lli_tables(sep, (struct sep_lli_entry_t *)
-                                  sep_shared_bus_to_virt(sep, *lli_table_o=
ut_ptr), *out_num_entries_ptr, *table_data_size_ptr);
-       dbg("SEP Driver:<-------- sep_construct_dma_tables_from_lli end\n")=
;
-       return 0;
-}
-
-
-/*
-  This function builds input and output DMA tables for synhronic
-  symmetric operations (AES, DES). It also checks that each table
-  is of the modular block size
-*/
-static int sep_prepare_input_output_dma_table(struct sep_device *sep,
-                                      unsigned long app_virt_in_addr,
-                                      unsigned long app_virt_out_addr,
-                                      unsigned long data_size,
-                                      unsigned long block_size,
-                                      unsigned long *lli_table_in_ptr, uns=
igned long *lli_table_out_ptr, unsigned long *in_num_entries_ptr, unsigned =
long *out_num_entries_ptr, unsigned long *table_data_size_ptr, bool isKerne=
lVirtualAddress)
-{
-       /* array of pointers of page */
-       struct sep_lli_entry_t *lli_in_array;
-       /* array of pointers of page */
-       struct sep_lli_entry_t *lli_out_array;
-       int result =3D 0;
-
-       dbg("SEP Driver:--------> sep_prepare_input_output_dma_table start\=
n");
-
-       /* initialize the pages pointers */
-       sep->in_page_array =3D 0;
-       sep->out_page_array =3D 0;
-
-       /* check if the pages are in Kernel Virtual Address layout */
-       if (isKernelVirtualAddress =3D=3D true) {
-               /* lock the pages of the kernel buffer and translate them t=
o pages */
-               result =3D sep_lock_kernel_pages(sep, app_virt_in_addr, dat=
a_size, &sep->in_num_pages, &lli_in_array, &sep->in_page_array);
-               if (result) {
-                       edbg("SEP Driver: sep_lock_kernel_pages for input v=
irtual buffer failed\n");
-                       goto end_function;
-               }
-       } else {
-               /* lock the pages of the user buffer and translate them to =
pages */
-               result =3D sep_lock_user_pages(sep, app_virt_in_addr, data_=
size, &sep->in_num_pages, &lli_in_array, &sep->in_page_array);
-               if (result) {
-                       edbg("SEP Driver: sep_lock_user_pages for input vir=
tual buffer failed\n");
-                       goto end_function;
-               }
-       }
-
-       if (isKernelVirtualAddress =3D=3D true) {
-               result =3D sep_lock_kernel_pages(sep, app_virt_out_addr, da=
ta_size, &sep->out_num_pages, &lli_out_array, &sep->out_page_array);
-               if (result) {
-                       edbg("SEP Driver: sep_lock_kernel_pages for output =
virtual buffer failed\n");
-                       goto end_function_with_error1;
-               }
-       } else {
-               result =3D sep_lock_user_pages(sep, app_virt_out_addr, data=
_size, &sep->out_num_pages, &lli_out_array, &sep->out_page_array);
-               if (result) {
-                       edbg("SEP Driver: sep_lock_user_pages for output vi=
rtual buffer failed\n");
-                       goto end_function_with_error1;
-               }
-       }
-       edbg("sep->in_num_pages is %lu\n", sep->in_num_pages);
-       edbg("sep->out_num_pages is %lu\n", sep->out_num_pages);
-       edbg("SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n", SEP_DRIVER_ENTR=
IES_PER_TABLE_IN_SEP);
-
-
-       /* call the fucntion that creates table from the lli arrays */
-       result =3D sep_construct_dma_tables_from_lli(sep, lli_in_array, sep=
->in_num_pages, lli_out_array, sep->out_num_pages, block_size, lli_table_in=
_ptr, lli_table_out_ptr, in_num_entries_ptr, out_num_entries_ptr, table_dat=
a_size_ptr);
-       if (result) {
-               edbg("SEP Driver: sep_construct_dma_tables_from_lli failed\=
n");
-               goto end_function_with_error2;
-       }
-
-       /* fall through - free the lli entry arrays */
-       dbg("in_num_entries_ptr is %08lx\n", *in_num_entries_ptr);
-       dbg("out_num_entries_ptr is %08lx\n", *out_num_entries_ptr);
-       dbg("table_data_size_ptr is %08lx\n", *table_data_size_ptr);
-end_function_with_error2:
-       kfree(lli_out_array);
-end_function_with_error1:
-       kfree(lli_in_array);
-end_function:
-       dbg("SEP Driver:<-------- sep_prepare_input_output_dma_table end re=
sult =3D %d\n", (int) result);
-       return result;
-
-}
-
-/*
-  this function handles tha request for creation of the DMA table
-  for the synchronic symmetric operations (AES,DES)
-*/
-static int sep_create_sync_dma_tables_handler(struct sep_device *sep,
-                                               unsigned long arg)
-{
-       int error;
-       /* command arguments */
-       struct sep_driver_build_sync_table_t command_args;
-
-       dbg("SEP Driver:--------> sep_create_sync_dma_tables_handler start\=
n");
-
-       error =3D copy_from_user(&command_args, (void *) arg, sizeof(struct=
 sep_driver_build_sync_table_t));
-       if (error)
-               goto end_function;
-
-       edbg("app_in_address is %08lx\n", command_args.app_in_address);
-       edbg("app_out_address is %08lx\n", command_args.app_out_address);
-       edbg("data_size is %lu\n", command_args.data_in_size);
-       edbg("block_size is %lu\n", command_args.block_size);
-
-       /* check if we need to build only input table or input/output */
-       if (command_args.app_out_address)
-               /* prepare input and output tables */
-               error =3D sep_prepare_input_output_dma_table(sep,
-                                                          command_args.app=
_in_address,
-                                                          command_args.app=
_out_address,
-                                                          command_args.dat=
a_in_size,
-                                                          command_args.blo=
ck_size,
-                                                          &command_args.in=
_table_address,
-                                                          &command_args.ou=
t_table_address, &command_args.in_table_num_entries, &command_args.out_tabl=
e_num_entries, &command_args.table_data_size, command_args.isKernelVirtualA=
ddress);
-       else
-               /* prepare input tables */
-               error =3D sep_prepare_input_dma_table(sep,
-                                                   command_args.app_in_add=
ress,
-                                                   command_args.data_in_si=
ze, command_args.block_size, &command_args.in_table_address, &command_args.=
in_table_num_entries, &command_args.table_data_size, command_args.isKernelV=
irtualAddress);
-
-       if (error)
-               goto end_function;
-       /* copy to user */
-       if (copy_to_user((void *) arg, (void *) &command_args, sizeof(struc=
t sep_driver_build_sync_table_t)))
-               error =3D -EFAULT;
-end_function:
-       dbg("SEP Driver:<-------- sep_create_sync_dma_tables_handler end\n"=
);
-       return error;
-}
-
-/*
-  this function handles the request for freeing dma table for synhronic ac=
tions
-*/
-static int sep_free_dma_table_data_handler(struct sep_device *sep)
-{
-       dbg("SEP Driver:--------> sep_free_dma_table_data_handler start\n")=
;
-
-       /* free input pages array */
-       sep_free_dma_pages(sep->in_page_array, sep->in_num_pages, 0);
-
-       /* free output pages array if needed */
-       if (sep->out_page_array)
-               sep_free_dma_pages(sep->out_page_array, sep->out_num_pages,=
 1);
-
-       /* reset all the values */
-       sep->in_page_array =3D 0;
-       sep->out_page_array =3D 0;
-       sep->in_num_pages =3D 0;
-       sep->out_num_pages =3D 0;
-       dbg("SEP Driver:<-------- sep_free_dma_table_data_handler end\n");
-       return 0;
-}
-
-/*
-  this function find a space for the new flow dma table
-*/
-static int sep_find_free_flow_dma_table_space(struct sep_device *sep,
-                                       unsigned long **table_address_ptr)
-{
-       int error =3D 0;
-       /* pointer to the id field of the flow dma table */
-       unsigned long *start_table_ptr;
-       /* Do not make start_addr unsigned long * unless fixing the offset
-          computations ! */
-       void *flow_dma_area_start_addr;
-       unsigned long *flow_dma_area_end_addr;
-       /* maximum table size in words */
-       unsigned long table_size_in_words;
-
-       /* find the start address of the flow DMA table area */
-       flow_dma_area_start_addr =3D sep->shared_addr + SEP_DRIVER_FLOW_DMA=
_TABLES_AREA_OFFSET_IN_BYTES;
-
-       /* set end address of the flow table area */
-       flow_dma_area_end_addr =3D flow_dma_area_start_addr + SEP_DRIVER_FL=
OW_DMA_TABLES_AREA_SIZE_IN_BYTES;
-
-       /* set table size in words */
-       table_size_in_words =3D SEP_DRIVER_MAX_FLOW_NUM_ENTRIES_IN_TABLE * =
(sizeof(struct sep_lli_entry_t) / sizeof(long)) + 2;
-
-       /* set the pointer to the start address of DMA area */
-       start_table_ptr =3D flow_dma_area_start_addr;
-
-       /* find the space for the next table */
-       while (((*start_table_ptr & 0x7FFFFFFF) !=3D 0) && start_table_ptr =
< flow_dma_area_end_addr)
-               start_table_ptr +=3D table_size_in_words;
-
-       /* check if we reached the end of floa tables area */
-       if (start_table_ptr >=3D flow_dma_area_end_addr)
-               error =3D -1;
-       else
-               *table_address_ptr =3D start_table_ptr;
-
-       return error;
-}
-
-/*
-  This function creates one DMA table for flow and returns its data,
-  and pointer to its info entry
-*/
-static int sep_prepare_one_flow_dma_table(struct sep_device *sep,
-                                       unsigned long virt_buff_addr,
-                                       unsigned long virt_buff_size,
-                                       struct sep_lli_entry_t *table_data,
-                                       struct sep_lli_entry_t **info_entry=
_ptr,
-                                       struct sep_flow_context_t *flow_dat=
a_ptr,
-                                       bool isKernelVirtualAddress)
-{
-       int error;
-       /* the range in pages */
-       unsigned long lli_array_size;
-       struct sep_lli_entry_t *lli_array;
-       struct sep_lli_entry_t *flow_dma_table_entry_ptr;
-       unsigned long *start_dma_table_ptr;
-       /* total table data counter */
-       unsigned long dma_table_data_count;
-       /* pointer that will keep the pointer to the pages of the virtual b=
uffer */
-       struct page **page_array_ptr;
-       unsigned long entry_count;
-
-       /* find the space for the new table */
-       error =3D sep_find_free_flow_dma_table_space(sep, &start_dma_table_=
ptr);
-       if (error)
-               goto end_function;
-
-       /* check if the pages are in Kernel Virtual Address layout */
-       if (isKernelVirtualAddress =3D=3D true)
-               /* lock kernel buffer in the memory */
-               error =3D sep_lock_kernel_pages(sep, virt_buff_addr, virt_b=
uff_size, &lli_array_size, &lli_array, &page_array_ptr);
-       else
-               /* lock user buffer in the memory */
-               error =3D sep_lock_user_pages(sep, virt_buff_addr, virt_buf=
f_size, &lli_array_size, &lli_array, &page_array_ptr);
-
-       if (error)
-               goto end_function;
-
-       /* set the pointer to page array at the beginning of table - this t=
able is
-          now considered taken */
-       *start_dma_table_ptr =3D lli_array_size;
-
-       /* point to the place of the pages pointers of the table */
-       start_dma_table_ptr++;
-
-       /* set the pages pointer */
-       *start_dma_table_ptr =3D (unsigned long) page_array_ptr;
-
-       /* set the pointer to the first entry */
-       flow_dma_table_entry_ptr =3D (struct sep_lli_entry_t *) (++start_dm=
a_table_ptr);
-
-       /* now create the entries for table */
-       for (dma_table_data_count =3D entry_count =3D 0; entry_count < lli_=
array_size; entry_count++) {
-               flow_dma_table_entry_ptr->physical_address =3D lli_array[en=
try_count].physical_address;
-
-               flow_dma_table_entry_ptr->block_size =3D lli_array[entry_co=
unt].block_size;
-
-               /* set the total data of a table */
-               dma_table_data_count +=3D lli_array[entry_count].block_size=
;
-
-               flow_dma_table_entry_ptr++;
-       }
-
-       /* set the physical address */
-       table_data->physical_address =3D virt_to_phys(start_dma_table_ptr);
-
-       /* set the num_entries and total data size */
-       table_data->block_size =3D ((lli_array_size + 1) << SEP_NUM_ENTRIES=
_OFFSET_IN_BITS) | (dma_table_data_count);
-
-       /* set the info entry */
-       flow_dma_table_entry_ptr->physical_address =3D 0xffffffff;
-       flow_dma_table_entry_ptr->block_size =3D 0;
-
-       /* set the pointer to info entry */
-       *info_entry_ptr =3D flow_dma_table_entry_ptr;
-
-       /* the array of the lli entries */
-       kfree(lli_array);
-end_function:
-       return error;
-}
-
-
-
-/*
-  This function creates a list of tables for flow and returns the data for
-       the first and last tables of the list
-*/
-static int sep_prepare_flow_dma_tables(struct sep_device *sep,
-                                       unsigned long num_virtual_buffers,
-                                       unsigned long first_buff_addr, stru=
ct sep_flow_context_t *flow_data_ptr, struct sep_lli_entry_t *first_table_d=
ata_ptr, struct sep_lli_entry_t *last_table_data_ptr, bool isKernelVirtualA=
ddress)
-{
-       int error;
-       unsigned long virt_buff_addr;
-       unsigned long virt_buff_size;
-       struct sep_lli_entry_t table_data;
-       struct sep_lli_entry_t *info_entry_ptr;
-       struct sep_lli_entry_t *prev_info_entry_ptr;
-       unsigned long i;
-
-       /* init vars */
-       error =3D 0;
-       prev_info_entry_ptr =3D 0;
-
-       /* init the first table to default */
-       table_data.physical_address =3D 0xffffffff;
-       first_table_data_ptr->physical_address =3D 0xffffffff;
-       table_data.block_size =3D 0;
-
-       for (i =3D 0; i < num_virtual_buffers; i++) {
-               /* get the virtual buffer address */
-               error =3D get_user(virt_buff_addr, &first_buff_addr);
-               if (error)
-                       goto end_function;
-
-               /* get the virtual buffer size */
-               first_buff_addr++;
-               error =3D get_user(virt_buff_size, &first_buff_addr);
-               if (error)
-                       goto end_function;
-
-               /* advance the address to point to the next pair of address=
|size */
-               first_buff_addr++;
-
-               /* now prepare the one flow LLI table from the data */
-               error =3D sep_prepare_one_flow_dma_table(sep, virt_buff_add=
r, virt_buff_size, &table_data, &info_entry_ptr, flow_data_ptr, isKernelVir=
tualAddress);
-               if (error)
-                       goto end_function;
-
-               if (i =3D=3D 0) {
-                       /* if this is the first table - save it to return t=
o the user
-                          application */
-                       *first_table_data_ptr =3D table_data;
-
-                       /* set the pointer to info entry */
-                       prev_info_entry_ptr =3D info_entry_ptr;
-               } else {
-                       /* not first table - the previous table info entry =
should
-                          be updated */
-                       prev_info_entry_ptr->block_size =3D (0x1 << SEP_INT=
_FLAG_OFFSET_IN_BITS) | (table_data.block_size);
-
-                       /* set the pointer to info entry */
-                       prev_info_entry_ptr =3D info_entry_ptr;
-               }
-       }
-
-       /* set the last table data */
-       *last_table_data_ptr =3D table_data;
-end_function:
-       return error;
-}
-
-/*
-  this function goes over all the flow tables connected to the given
-       table and deallocate them
-*/
-static void sep_deallocated_flow_tables(struct sep_lli_entry_t *first_tabl=
e_ptr)
-{
-       /* id pointer */
-       unsigned long *table_ptr;
-       /* end address of the flow dma area */
-       unsigned long num_entries;
-       unsigned long num_pages;
-       struct page **pages_ptr;
-       /* maximum table size in words */
-       struct sep_lli_entry_t *info_entry_ptr;
-
-       /* set the pointer to the first table */
-       table_ptr =3D (unsigned long *) first_table_ptr->physical_address;
-
-       /* set the num of entries */
-       num_entries =3D (first_table_ptr->block_size >> SEP_NUM_ENTRIES_OFF=
SET_IN_BITS)
-           & SEP_NUM_ENTRIES_MASK;
-
-       /* go over all the connected tables */
-       while (*table_ptr !=3D 0xffffffff) {
-               /* get number of pages */
-               num_pages =3D *(table_ptr - 2);
-
-               /* get the pointer to the pages */
-               pages_ptr =3D (struct page **) (*(table_ptr - 1));
-
-               /* free the pages */
-               sep_free_dma_pages(pages_ptr, num_pages, 1);
-
-               /* goto to the info entry */
-               info_entry_ptr =3D ((struct sep_lli_entry_t *) table_ptr) +=
 (num_entries - 1);
-
-               table_ptr =3D (unsigned long *) info_entry_ptr->physical_ad=
dress;
-               num_entries =3D (info_entry_ptr->block_size >> SEP_NUM_ENTR=
IES_OFFSET_IN_BITS) & SEP_NUM_ENTRIES_MASK;
-       }
-
-       return;
-}
-
-/**
- *     sep_find_flow_context   -       find a flow
- *     @sep: the SEP we are working with
- *     @flow_id: flow identifier
- *
- *     Returns a pointer the matching flow, or NULL if the flow does not
- *     exist.
- */
-
-static struct sep_flow_context_t *sep_find_flow_context(struct sep_device =
*sep,
-                               unsigned long flow_id)
-{
-       int count;
-       /*
-        *  always search for flow with id default first - in case we
-        *  already started working on the flow there can be no situation
-        *  when 2 flows are with default flag
-        */
-       for (count =3D 0; count < SEP_DRIVER_NUM_FLOWS; count++) {
-               if (sep->flows[count].flow_id =3D=3D flow_id)
-                       return &sep->flows[count];
-       }
-       return NULL;
-}
-
-
-/*
-  this function handles the request to create the DMA tables for flow
-*/
-static int sep_create_flow_dma_tables_handler(struct sep_device *sep,
-                                                       unsigned long arg)
-{
-       int error =3D -ENOENT;
-       struct sep_driver_build_flow_table_t command_args;
-       /* first table - output */
-       struct sep_lli_entry_t first_table_data;
-       /* dma table data */
-       struct sep_lli_entry_t last_table_data;
-       /* pointer to the info entry of the previuos DMA table */
-       struct sep_lli_entry_t *prev_info_entry_ptr;
-       /* pointer to the flow data strucutre */
-       struct sep_flow_context_t *flow_context_ptr;
-
-       dbg("SEP Driver:--------> sep_create_flow_dma_tables_handler start\=
n");
-
-       /* init variables */
-       prev_info_entry_ptr =3D 0;
-       first_table_data.physical_address =3D 0xffffffff;
-
-       /* find the free structure for flow data */
-       error =3D -EINVAL;
-       flow_context_ptr =3D sep_find_flow_context(sep, SEP_FREE_FLOW_ID);
-       if (flow_context_ptr =3D=3D NULL)
-               goto end_function;
-
-       error =3D copy_from_user(&command_args, (void *) arg, sizeof(struct=
 sep_driver_build_flow_table_t));
-       if (error)
-               goto end_function;
-
-       /* create flow tables */
-       error =3D sep_prepare_flow_dma_tables(sep, command_args.num_virtual=
_buffers, command_args.virt_buff_data_addr, flow_context_ptr, &first_table_=
data, &last_table_data, command_args.isKernelVirtualAddress);
-       if (error)
-               goto end_function_with_error;
-
-       /* check if flow is static */
-       if (!command_args.flow_type)
-               /* point the info entry of the last to the info entry of th=
e first */
-               last_table_data =3D first_table_data;
-
-       /* set output params */
-       command_args.first_table_addr =3D first_table_data.physical_address=
;
-       command_args.first_table_num_entries =3D ((first_table_data.block_s=
ize >> SEP_NUM_ENTRIES_OFFSET_IN_BITS) & SEP_NUM_ENTRIES_MASK);
-       command_args.first_table_data_size =3D (first_table_data.block_size=
 & SEP_TABLE_DATA_SIZE_MASK);
-
-       /* send the parameters to user application */
-       error =3D copy_to_user((void *) arg, &command_args, sizeof(struct s=
ep_driver_build_flow_table_t));
-       if (error)
-               goto end_function_with_error;
-
-       /* all the flow created  - update the flow entry with temp id */
-       flow_context_ptr->flow_id =3D SEP_TEMP_FLOW_ID;
-
-       /* set the processing tables data in the context */
-       if (command_args.input_output_flag =3D=3D SEP_DRIVER_IN_FLAG)
-               flow_context_ptr->input_tables_in_process =3D first_table_d=
ata;
-       else
-               flow_context_ptr->output_tables_in_process =3D first_table_=
data;
-
-       goto end_function;
-
-end_function_with_error:
-       /* free the allocated tables */
-       sep_deallocated_flow_tables(&first_table_data);
-end_function:
-       dbg("SEP Driver:<-------- sep_create_flow_dma_tables_handler end\n"=
);
-       return error;
-}
-
-/*
-  this function handles add tables to flow
-*/
-static int sep_add_flow_tables_handler(struct sep_device *sep, unsigned lo=
ng arg)
-{
-       int error;
-       unsigned long num_entries;
-       struct sep_driver_add_flow_table_t command_args;
-       struct sep_flow_context_t *flow_context_ptr;
-       /* first dma table data */
-       struct sep_lli_entry_t first_table_data;
-       /* last dma table data */
-       struct sep_lli_entry_t last_table_data;
-       /* pointer to the info entry of the current DMA table */
-       struct sep_lli_entry_t *info_entry_ptr;
-
-       dbg("SEP Driver:--------> sep_add_flow_tables_handler start\n");
-
-       /* get input parameters */
-       error =3D copy_from_user(&command_args, (void *) arg, sizeof(struct=
 sep_driver_add_flow_table_t));
-       if (error)
-               goto end_function;
-
-       /* find the flow structure for the flow id */
-       flow_context_ptr =3D sep_find_flow_context(sep, command_args.flow_i=
d);
-       if (flow_context_ptr =3D=3D NULL)
-               goto end_function;
-
-       /* prepare the flow dma tables */
-       error =3D sep_prepare_flow_dma_tables(sep, command_args.num_virtual=
_buffers, command_args.virt_buff_data_addr, flow_context_ptr, &first_table_=
data, &last_table_data, command_args.isKernelVirtualAddress);
-       if (error)
-               goto end_function_with_error;
-
-       /* now check if there is already an existing add table for this flo=
w */
-       if (command_args.inputOutputFlag =3D=3D SEP_DRIVER_IN_FLAG) {
-               /* this buffer was for input buffers */
-               if (flow_context_ptr->input_tables_flag) {
-                       /* add table already exists - add the new tables to=
 the end
-                          of the previous */
-                       num_entries =3D (flow_context_ptr->last_input_table=
.block_size >> SEP_NUM_ENTRIES_OFFSET_IN_BITS) & SEP_NUM_ENTRIES_MASK;
-
-                       info_entry_ptr =3D (struct sep_lli_entry_t *)
-                           (flow_context_ptr->last_input_table.physical_ad=
dress + (sizeof(struct sep_lli_entry_t) * (num_entries - 1)));
-
-                       /* connect to list of tables */
-                       *info_entry_ptr =3D first_table_data;
-
-                       /* set the first table data */
-                       first_table_data =3D flow_context_ptr->first_input_=
table;
-               } else {
-                       /* set the input flag */
-                       flow_context_ptr->input_tables_flag =3D 1;
-
-                       /* set the first table data */
-                       flow_context_ptr->first_input_table =3D first_table=
_data;
-               }
-               /* set the last table data */
-               flow_context_ptr->last_input_table =3D last_table_data;
-       } else {                /* this is output tables */
-
-               /* this buffer was for input buffers */
-               if (flow_context_ptr->output_tables_flag) {
-                       /* add table already exists - add the new tables to
-                          the end of the previous */
-                       num_entries =3D (flow_context_ptr->last_output_tabl=
e.block_size >> SEP_NUM_ENTRIES_OFFSET_IN_BITS) & SEP_NUM_ENTRIES_MASK;
-
-                       info_entry_ptr =3D (struct sep_lli_entry_t *)
-                           (flow_context_ptr->last_output_table.physical_a=
ddress + (sizeof(struct sep_lli_entry_t) * (num_entries - 1)));
-
-                       /* connect to list of tables */
-                       *info_entry_ptr =3D first_table_data;
-
-                       /* set the first table data */
-                       first_table_data =3D flow_context_ptr->first_output=
_table;
-               } else {
-                       /* set the input flag */
-                       flow_context_ptr->output_tables_flag =3D 1;
-
-                       /* set the first table data */
-                       flow_context_ptr->first_output_table =3D first_tabl=
e_data;
-               }
-               /* set the last table data */
-               flow_context_ptr->last_output_table =3D last_table_data;
-       }
-
-       /* set output params */
-       command_args.first_table_addr =3D first_table_data.physical_address=
;
-       command_args.first_table_num_entries =3D ((first_table_data.block_s=
ize >> SEP_NUM_ENTRIES_OFFSET_IN_BITS) & SEP_NUM_ENTRIES_MASK);
-       command_args.first_table_data_size =3D (first_table_data.block_size=
 & SEP_TABLE_DATA_SIZE_MASK);
-
-       /* send the parameters to user application */
-       error =3D copy_to_user((void *) arg, &command_args, sizeof(struct s=
ep_driver_add_flow_table_t));
-end_function_with_error:
-       /* free the allocated tables */
-       sep_deallocated_flow_tables(&first_table_data);
-end_function:
-       dbg("SEP Driver:<-------- sep_add_flow_tables_handler end\n");
-       return error;
-}
-
-/*
-  this function add the flow add message to the specific flow
-*/
-static int sep_add_flow_tables_message_handler(struct sep_device *sep, uns=
igned long arg)
-{
-       int error;
-       struct sep_driver_add_message_t command_args;
-       struct sep_flow_context_t *flow_context_ptr;
-
-       dbg("SEP Driver:--------> sep_add_flow_tables_message_handler start=
\n");
-
-       error =3D copy_from_user(&command_args, (void *) arg, sizeof(struct=
 sep_driver_add_message_t));
-       if (error)
-               goto end_function;
-
-       /* check input */
-       if (command_args.message_size_in_bytes > SEP_MAX_ADD_MESSAGE_LENGTH=
_IN_BYTES) {
-               error =3D -ENOMEM;
-               goto end_function;
-       }
-
-       /* find the flow context */
-       flow_context_ptr =3D sep_find_flow_context(sep, command_args.flow_i=
d);
-       if (flow_context_ptr =3D=3D NULL)
-               goto end_function;
-
-       /* copy the message into context */
-       flow_context_ptr->message_size_in_bytes =3D command_args.message_si=
ze_in_bytes;
-       error =3D copy_from_user(flow_context_ptr->message, (void *) comman=
d_args.message_address, command_args.message_size_in_bytes);
-end_function:
-       dbg("SEP Driver:<-------- sep_add_flow_tables_message_handler end\n=
");
-       return error;
-}
-
-
-/*
-  this function returns the bus and virtual addresses of the static pool
-*/
-static int sep_get_static_pool_addr_handler(struct sep_device *sep, unsign=
ed long arg)
-{
-       int error;
-       struct sep_driver_static_pool_addr_t command_args;
-
-       dbg("SEP Driver:--------> sep_get_static_pool_addr_handler start\n"=
);
-
-       /*prepare the output parameters in the struct */
-       command_args.physical_static_address =3D sep->shared_bus + SEP_DRIV=
ER_STATIC_AREA_OFFSET_IN_BYTES;
-       command_args.virtual_static_address =3D (unsigned long)sep->shared_=
addr + SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
-
-       edbg("SEP Driver:bus_static_address is %08lx, virtual_static_addres=
s %08lx\n", command_args.physical_static_address, command_args.virtual_stat=
ic_address);
-
-       /* send the parameters to user application */
-       error =3D copy_to_user((void *) arg, &command_args, sizeof(struct s=
ep_driver_static_pool_addr_t));
-       dbg("SEP Driver:<-------- sep_get_static_pool_addr_handler end\n");
-       return error;
-}
-
-/*
-  this address gets the offset of the physical address from the start
-  of the mapped area
-*/
-static int sep_get_physical_mapped_offset_handler(struct sep_device *sep, =
unsigned long arg)
-{
-       int error;
-       struct sep_driver_get_mapped_offset_t command_args;
-
-       dbg("SEP Driver:--------> sep_get_physical_mapped_offset_handler st=
art\n");
-
-       error =3D copy_from_user(&command_args, (void *) arg, sizeof(struct=
 sep_driver_get_mapped_offset_t));
-       if (error)
-               goto end_function;
-
-       if (command_args.physical_address < sep->shared_bus) {
-               error =3D -EINVAL;
-               goto end_function;
-       }
-
-       /*prepare the output parameters in the struct */
-       command_args.offset =3D command_args.physical_address - sep->shared=
_bus;
-
-       edbg("SEP Driver:bus_address is %08lx, offset is %lu\n", command_ar=
gs.physical_address, command_args.offset);
-
-       /* send the parameters to user application */
-       error =3D copy_to_user((void *) arg, &command_args, sizeof(struct s=
ep_driver_get_mapped_offset_t));
-end_function:
-       dbg("SEP Driver:<-------- sep_get_physical_mapped_offset_handler en=
d\n");
-       return error;
-}
-
-
-/*
-  ?
-*/
-static int sep_start_handler(struct sep_device *sep)
-{
-       unsigned long reg_val;
-       unsigned long error =3D 0;
-
-       dbg("SEP Driver:--------> sep_start_handler start\n");
-
-       /* wait in polling for message from SEP */
-       do
-               reg_val =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADD=
R);
-       while (!reg_val);
-
-       /* check the value */
-       if (reg_val =3D=3D 0x1)
-               /* fatal error - read error status from GPRO */
-               error =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR0_REG_ADDR)=
;
-       dbg("SEP Driver:<-------- sep_start_handler end\n");
-       return error;
-}
-
-/*
-  this function handles the request for SEP initialization
-*/
-static int sep_init_handler(struct sep_device *sep, unsigned long arg)
-{
-       unsigned long message_word;
-       unsigned long *message_ptr;
-       struct sep_driver_init_t command_args;
-       unsigned long counter;
-       unsigned long error;
-       unsigned long reg_val;
-
-       dbg("SEP Driver:--------> sep_init_handler start\n");
-       error =3D 0;
-
-       error =3D copy_from_user(&command_args, (void *) arg, sizeof(struct=
 sep_driver_init_t));
-
-       dbg("SEP Driver:--------> sep_init_handler - finished copy_from_use=
r \n");
-
-       if (error)
-               goto end_function;
-
-       /* PATCH - configure the DMA to single -burst instead of multi-burs=
t */
-       /*sep_configure_dma_burst(); */
-
-       dbg("SEP Driver:--------> sep_init_handler - finished sep_configure=
_dma_burst \n");
-
-       message_ptr =3D (unsigned long *) command_args.message_addr;
-
-       /* set the base address of the SRAM  */
-       sep_write_reg(sep, HW_SRAM_ADDR_REG_ADDR, HW_CC_SRAM_BASE_ADDRESS);
-
-       for (counter =3D 0; counter < command_args.message_size_in_words; c=
ounter++, message_ptr++) {
-               get_user(message_word, message_ptr);
-               /* write data to SRAM */
-               sep_write_reg(sep, HW_SRAM_DATA_REG_ADDR, message_word);
-               edbg("SEP Driver:message_word is %lu\n", message_word);
-               /* wait for write complete */
-               sep_wait_sram_write(sep);
-       }
-       dbg("SEP Driver:--------> sep_init_handler - finished getting messa=
ges from user space\n");
-       /* signal SEP */
-       sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x1);
-
-       do
-               reg_val =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADD=
R);
-       while (!(reg_val & 0xFFFFFFFD));
-
-       dbg("SEP Driver:--------> sep_init_handler - finished waiting for r=
eg_val & 0xFFFFFFFD \n");
-
-       /* check the value */
-       if (reg_val =3D=3D 0x1) {
-               edbg("SEP Driver:init failed\n");
-
-               error =3D sep_read_reg(sep, 0x8060);
-               edbg("SEP Driver:sw monitor is %lu\n", error);
-
-               /* fatal error - read erro status from GPRO */
-               error =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR0_REG_ADDR)=
;
-               edbg("SEP Driver:error is %lu\n", error);
-       }
-end_function:
-       dbg("SEP Driver:<-------- sep_init_handler end\n");
-       return error;
-
-}
-
-/*
-  this function handles the request cache and resident reallocation
-*/
-static int sep_realloc_cache_resident_handler(struct sep_device *sep,
-                                               unsigned long arg)
-{
-       struct sep_driver_realloc_cache_resident_t command_args;
-       int error;
-
-       /* copy cache and resident to the their intended locations */
-       error =3D sep_load_firmware(sep);
-       if (error)
-               return error;
-
-       command_args.new_base_addr =3D sep->shared_bus;
-
-       /* find the new base address according to the lowest address betwee=
n
-          cache, resident and shared area */
-       if (sep->resident_bus < command_args.new_base_addr)
-               command_args.new_base_addr =3D sep->resident_bus;
-       if (sep->rar_bus < command_args.new_base_addr)
-               command_args.new_base_addr =3D sep->rar_bus;
-
-       /* set the return parameters */
-       command_args.new_cache_addr =3D sep->rar_bus;
-       command_args.new_resident_addr =3D sep->resident_bus;
-
-       /* set the new shared area */
-       command_args.new_shared_area_addr =3D sep->shared_bus;
-
-       edbg("SEP Driver:command_args.new_shared_addr is %08llx\n", command=
_args.new_shared_area_addr);
-       edbg("SEP Driver:command_args.new_base_addr is %08llx\n", command_a=
rgs.new_base_addr);
-       edbg("SEP Driver:command_args.new_resident_addr is %08llx\n", comma=
nd_args.new_resident_addr);
-       edbg("SEP Driver:command_args.new_rar_addr is %08llx\n", command_ar=
gs.new_cache_addr);
-
-       /* return to user */
-       if (copy_to_user((void *) arg, &command_args, sizeof(struct sep_dri=
ver_realloc_cache_resident_t)))
-               return -EFAULT;
-       return 0;
-}
-
-/**
- *     sep_get_time_handler    -       time request from user space
- *     @sep: sep we are to set the time for
- *     @arg: pointer to user space arg buffer
- *
- *     This function reports back the time and the address in the SEP
- *     shared buffer at which it has been placed. (Do we really need this!=
!!)
- */
-
-static int sep_get_time_handler(struct sep_device *sep, unsigned long arg)
-{
-       struct sep_driver_get_time_t command_args;
-
-       mutex_lock(&sep_mutex);
-       command_args.time_value =3D sep_set_time(sep);
-       command_args.time_physical_address =3D (unsigned long)sep_time_addr=
ess(sep);
-       mutex_unlock(&sep_mutex);
-       if (copy_to_user((void __user *)arg,
-                       &command_args, sizeof(struct sep_driver_get_time_t)=
))
-                       return -EFAULT;
-       return 0;
-
-}
-
-/*
-  This API handles the end transaction request
-*/
-static int sep_end_transaction_handler(struct sep_device *sep, unsigned lo=
ng arg)
-{
-       dbg("SEP Driver:--------> sep_end_transaction_handler start\n");
-
-#if 0                          /*!SEP_DRIVER_POLLING_MODE */
-       /* close IMR */
-       sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, 0x7FFF);
-
-       /* release IRQ line */
-       free_irq(SEP_DIRVER_IRQ_NUM, sep);
-
-       /* lock the sep mutex */
-       mutex_unlock(&sep_mutex);
-#endif
-
-       dbg("SEP Driver:<-------- sep_end_transaction_handler end\n");
-
-       return 0;
-}
-
-
-/**
- *     sep_set_flow_id_handler -       handle flow setting
- *     @sep: the SEP we are configuring
- *     @flow_id: the flow we are setting
- *
- * This function handler the set flow id command
- */
-static int sep_set_flow_id_handler(struct sep_device *sep,
-                                               unsigned long flow_id)
-{
-       int error =3D 0;
-       struct sep_flow_context_t *flow_data_ptr;
-
-       /* find the flow data structure that was just used for creating new=
 flow
-          - its id should be default */
-
-       mutex_lock(&sep_mutex);
-       flow_data_ptr =3D sep_find_flow_context(sep, SEP_TEMP_FLOW_ID);
-       if (flow_data_ptr)
-               flow_data_ptr->flow_id =3D flow_id;       /* set flow id */
-       else
-               error =3D -EINVAL;
-       mutex_unlock(&sep_mutex);
-       return error;
-}
-
-static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long a=
rg)
-{
-       int error =3D 0;
-       struct sep_device *sep =3D filp->private_data;
-
-       dbg("------------>SEP Driver: ioctl start\n");
-
-       edbg("SEP Driver: cmd is %x\n", cmd);
-
-       switch (cmd) {
-       case SEP_IOCSENDSEPCOMMAND:
-               /* send command to SEP */
-               sep_send_command_handler(sep);
-               edbg("SEP Driver: after sep_send_command_handler\n");
-               break;
-       case SEP_IOCSENDSEPRPLYCOMMAND:
-               /* send reply command to SEP */
-               sep_send_reply_command_handler(sep);
-               break;
-       case SEP_IOCALLOCDATAPOLL:
-               /* allocate data pool */
-               error =3D sep_allocate_data_pool_memory_handler(sep, arg);
-               break;
-       case SEP_IOCWRITEDATAPOLL:
-               /* write data into memory pool */
-               error =3D sep_write_into_data_pool_handler(sep, arg);
-               break;
-       case SEP_IOCREADDATAPOLL:
-               /* read data from data pool into application memory */
-               error =3D sep_read_from_data_pool_handler(sep, arg);
-               break;
-       case SEP_IOCCREATESYMDMATABLE:
-               /* create dma table for synhronic operation */
-               error =3D sep_create_sync_dma_tables_handler(sep, arg);
-               break;
-       case SEP_IOCCREATEFLOWDMATABLE:
-               /* create flow dma tables */
-               error =3D sep_create_flow_dma_tables_handler(sep, arg);
-               break;
-       case SEP_IOCFREEDMATABLEDATA:
-               /* free the pages */
-               error =3D sep_free_dma_table_data_handler(sep);
-               break;
-       case SEP_IOCSETFLOWID:
-               /* set flow id */
-               error =3D sep_set_flow_id_handler(sep, (unsigned long)arg);
-               break;
-       case SEP_IOCADDFLOWTABLE:
-               /* add tables to the dynamic flow */
-               error =3D sep_add_flow_tables_handler(sep, arg);
-               break;
-       case SEP_IOCADDFLOWMESSAGE:
-               /* add message of add tables to flow */
-               error =3D sep_add_flow_tables_message_handler(sep, arg);
-               break;
-       case SEP_IOCSEPSTART:
-               /* start command to sep */
-               error =3D sep_start_handler(sep);
-               break;
-       case SEP_IOCSEPINIT:
-               /* init command to sep */
-               error =3D sep_init_handler(sep, arg);
-               break;
-       case SEP_IOCGETSTATICPOOLADDR:
-               /* get the physical and virtual addresses of the static poo=
l */
-               error =3D sep_get_static_pool_addr_handler(sep, arg);
-               break;
-       case SEP_IOCENDTRANSACTION:
-               error =3D sep_end_transaction_handler(sep, arg);
-               break;
-       case SEP_IOCREALLOCCACHERES:
-               error =3D sep_realloc_cache_resident_handler(sep, arg);
-               break;
-       case SEP_IOCGETMAPPEDADDROFFSET:
-               error =3D sep_get_physical_mapped_offset_handler(sep, arg);
-               break;
-       case SEP_IOCGETIME:
-               error =3D sep_get_time_handler(sep, arg);
-               break;
-       default:
-               error =3D -ENOTTY;
-               break;
-       }
-       dbg("SEP Driver:<-------- ioctl end\n");
-       return error;
-}
-
-
-
-#if !SEP_DRIVER_POLLING_MODE
-
-/* handler for flow done interrupt */
-
-static void sep_flow_done_handler(struct work_struct *work)
-{
-       struct sep_flow_context_t *flow_data_ptr;
-
-       /* obtain the mutex */
-       mutex_lock(&sep_mutex);
-
-       /* get the pointer to context */
-       flow_data_ptr =3D (struct sep_flow_context_t *) work;
-
-       /* free all the current input tables in sep */
-       sep_deallocated_flow_tables(&flow_data_ptr->input_tables_in_process=
);
-
-       /* free all the current tables output tables in SEP (if needed) */
-       if (flow_data_ptr->output_tables_in_process.physical_address !=3D 0=
xffffffff)
-               sep_deallocated_flow_tables(&flow_data_ptr->output_tables_i=
n_process);
-
-       /* check if we have additional tables to be sent to SEP only input
-          flag may be checked */
-       if (flow_data_ptr->input_tables_flag) {
-               /* copy the message to the shared RAM and signal SEP */
-               memcpy((void *) flow_data_ptr->message, (void *) sep->share=
d_addr, flow_data_ptr->message_size_in_bytes);
-
-               sep_write_reg(sep, HW_HOST_HOST_SEP_GPR2_REG_ADDR, 0x2);
-       }
-       mutex_unlock(&sep_mutex);
-}
-/*
-  interrupt handler function
-*/
-static irqreturn_t sep_inthandler(int irq, void *dev_id)
-{
-       irqreturn_t int_error;
-       unsigned long reg_val;
-       unsigned long flow_id;
-       struct sep_flow_context_t *flow_context_ptr;
-       struct sep_device *sep =3D dev_id;
-
-       int_error =3D IRQ_HANDLED;
-
-       /* read the IRR register to check if this is SEP interrupt */
-       reg_val =3D sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
-       edbg("SEP Interrupt - reg is %08lx\n", reg_val);
-
-       /* check if this is the flow interrupt */
-       if (0 /*reg_val & (0x1 << 11) */ ) {
-               /* read GPRO to find out the which flow is done */
-               flow_id =3D sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
-
-               /* find the contex of the flow */
-               flow_context_ptr =3D sep_find_flow_context(sep, flow_id >> =
28);
-               if (flow_context_ptr =3D=3D NULL)
-                       goto end_function_with_error;
-
-               /* queue the work */
-               INIT_WORK(&flow_context_ptr->flow_wq, sep_flow_done_handler=
);
-               queue_work(sep->flow_wq, &flow_context_ptr->flow_wq);
-
-       } else {
-               /* check if this is reply interrupt from SEP */
-               if (reg_val & (0x1 << 13)) {
-                       /* update the counter of reply messages */
-                       sep->reply_ct++;
-                       /* wake up the waiting process */
-                       wake_up(&sep_event);
-               } else {
-                       int_error =3D IRQ_NONE;
-                       goto end_function;
-               }
-       }
-end_function_with_error:
-       /* clear the interrupt */
-       sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, reg_val);
-end_function:
-       return int_error;
-}
-
-#endif
-
-
-
-#if 0
-
-static void sep_wait_busy(struct sep_device *sep)
-{
-       u32 reg;
-
-       do {
-               reg =3D sep_read_reg(sep, HW_HOST_SEP_BUSY_REG_ADDR);
-       } while (reg);
-}
-
-/*
-  PATCH for configuring the DMA to single burst instead of multi-burst
-*/
-static void sep_configure_dma_burst(struct sep_device *sep)
-{
-#define         HW_AHB_RD_WR_BURSTS_REG_ADDR            0x0E10UL
-
-       dbg("SEP Driver:<-------- sep_configure_dma_burst start \n");
-
-       /* request access to registers from SEP */
-       sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
-
-       dbg("SEP Driver:<-------- sep_configure_dma_burst finished request =
access to registers from SEP (write reg)  \n");
-
-       sep_wait_busy(sep);
-
-       dbg("SEP Driver:<-------- sep_configure_dma_burst finished request =
access to registers from SEP (while(revVal) wait loop)  \n");
-
-       /* set the DMA burst register to single burst */
-       sep_write_reg(sep, HW_AHB_RD_WR_BURSTS_REG_ADDR, 0x0UL);
-
-       /* release the sep busy */
-       sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x0UL);
-       sep_wait_busy(sep);
-
-       dbg("SEP Driver:<-------- sep_configure_dma_burst done  \n");
-
-}
-
-#endif
-
-/*
-  Function that is activated on the successful probe of the SEP device
-*/
-static int __devinit sep_probe(struct pci_dev *pdev, const struct pci_devi=
ce_id *ent)
-{
-       int error =3D 0;
-       struct sep_device *sep;
-       int counter;
-       int size;               /* size of memory for allocation */
-
-       edbg("Sep pci probe starting\n");
-       if (sep_dev !=3D NULL) {
-               dev_warn(&pdev->dev, "only one SEP supported.\n");
-               return -EBUSY;
-       }
-
-       /* enable the device */
-       error =3D pci_enable_device(pdev);
-       if (error) {
-               edbg("error enabling pci device\n");
-               goto end_function;
-       }
-
-       /* set the pci dev pointer */
-       sep_dev =3D &sep_instance;
-       sep =3D &sep_instance;
-
-       edbg("sep->shared_addr =3D %p\n", sep->shared_addr);
-       /* transaction counter that coordinates the transactions between SE=
P
-       and HOST */
-       sep->send_ct =3D 0;
-       /* counter for the messages from sep */
-       sep->reply_ct =3D 0;
-       /* counter for the number of bytes allocated in the pool
-       for the current transaction */
-       sep->data_pool_bytes_allocated =3D 0;
-
-       /* calculate the total size for allocation */
-       size =3D SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
-           SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_SIZE_IN_BYTES + SEP_DRIVE=
R_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES + SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZ=
E_IN_BYTES + SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES + SEP_DRIVER_SYSTEM_DATA_=
MEMORY_SIZE_IN_BYTES;
-
-       /* allocate the shared area */
-       if (sep_map_and_alloc_shared_area(sep, size)) {
-               error =3D -ENOMEM;
-               /* allocation failed */
-               goto end_function_error;
-       }
-       /* now set the memory regions */
-#if (SEP_DRIVER_RECONFIG_MESSAGE_AREA =3D=3D 1)
-       /* Note: this test section will need moving before it could ever
-          work as the registers are not yet mapped ! */
-       /* send the new SHARED MESSAGE AREA to the SEP */
-       sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus)=
;
-
-       /* poll for SEP response */
-       retval =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
-       while (retval !=3D 0xffffffff && retval !=3D sep->shared_bus)
-               retval =3D sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR=
);
-
-       /* check the return value (register) */
-       if (retval !=3D sep->shared_bus) {
-               error =3D -ENOMEM;
-               goto end_function_deallocate_sep_shared_area;
-       }
-#endif
-       /* init the flow contextes */
-       for (counter =3D 0; counter < SEP_DRIVER_NUM_FLOWS; counter++)
-               sep->flows[counter].flow_id =3D SEP_FREE_FLOW_ID;
-
-       sep->flow_wq =3D create_singlethread_workqueue("sepflowwq");
-       if (sep->flow_wq =3D=3D NULL) {
-               error =3D -ENOMEM;
-               edbg("sep_driver:flow queue creation failed\n");
-               goto end_function_deallocate_sep_shared_area;
-       }
-       edbg("SEP Driver: create flow workqueue \n");
-       sep->pdev =3D pci_dev_get(pdev);
-
-       sep->reg_addr =3D pci_ioremap_bar(pdev, 0);
-       if (!sep->reg_addr) {
-               edbg("sep: ioremap of registers failed.\n");
-               goto end_function_deallocate_sep_shared_area;
-       }
-       edbg("SEP Driver:reg_addr is %p\n", sep->reg_addr);
-
-       /* load the rom code */
-       sep_load_rom_code(sep);
-
-       /* set up system base address and shared memory location */
-       sep->rar_addr =3D dma_alloc_coherent(&sep->pdev->dev,
-                       2 * SEP_RAR_IO_MEM_REGION_SIZE,
-                       &sep->rar_bus, GFP_KERNEL);
-
-       if (!sep->rar_addr) {
-               edbg("SEP Driver:can't allocate rar\n");
-               goto end_function_uniomap;
-       }
-
-
-       edbg("SEP Driver:rar_bus is %08llx\n", (unsigned long long)sep->rar=
_bus);
-       edbg("SEP Driver:rar_virtual is %p\n", sep->rar_addr);
-
-#if !SEP_DRIVER_POLLING_MODE
-
-       edbg("SEP Driver: about to write IMR and ICR REG_ADDR\n");
-
-       /* clear ICR register */
-       sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
-
-       /* set the IMR register - open only GPR 2 */
-       sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
-
-       edbg("SEP Driver: about to call request_irq\n");
-       /* get the interrupt line */
-       error =3D request_irq(pdev->irq, sep_inthandler, IRQF_SHARED, "sep_=
driver", sep);
-       if (error)
-               goto end_function_free_res;
-       return 0;
-       edbg("SEP Driver: about to write IMR REG_ADDR");
-
-       /* set the IMR register - open only GPR 2 */
-       sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
-
-end_function_free_res:
-       dma_free_coherent(&sep->pdev->dev, 2 * SEP_RAR_IO_MEM_REGION_SIZE,
-                       sep->rar_addr, sep->rar_bus);
-#endif                         /* SEP_DRIVER_POLLING_MODE */
-end_function_uniomap:
-       iounmap(sep->reg_addr);
-end_function_deallocate_sep_shared_area:
-       /* de-allocate shared area */
-       sep_unmap_and_free_shared_area(sep, size);
-end_function_error:
-       sep_dev =3D NULL;
-end_function:
-       return error;
-}
-
-static const struct pci_device_id sep_pci_id_tbl[] =3D {
-       {PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080c)},
-       {0}
-};
-
-MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
-
-/* field for registering driver to PCI device */
-static struct pci_driver sep_pci_driver =3D {
-       .name =3D "sep_sec_driver",
-       .id_table =3D sep_pci_id_tbl,
-       .probe =3D sep_probe
-       /* FIXME: remove handler */
-};
-
-/* major and minor device numbers */
-static dev_t sep_devno;
-
-/* the files operations structure of the driver */
-static struct file_operations sep_file_operations =3D {
-       .owner =3D THIS_MODULE,
-       .unlocked_ioctl =3D sep_ioctl,
-       .poll =3D sep_poll,
-       .open =3D sep_open,
-       .release =3D sep_release,
-       .mmap =3D sep_mmap,
-};
-
-
-/* cdev struct of the driver */
-static struct cdev sep_cdev;
-
-/*
-  this function registers the driver to the file system
-*/
-static int sep_register_driver_to_fs(void)
-{
-       int ret_val =3D alloc_chrdev_region(&sep_devno, 0, 1, "sep_sec_driv=
er");
-       if (ret_val) {
-               edbg("sep: major number allocation failed, retval is %d\n",
-                                                               ret_val);
-               return ret_val;
-       }
-       /* init cdev */
-       cdev_init(&sep_cdev, &sep_file_operations);
-       sep_cdev.owner =3D THIS_MODULE;
-
-       /* register the driver with the kernel */
-       ret_val =3D cdev_add(&sep_cdev, sep_devno, 1);
-       if (ret_val) {
-               edbg("sep_driver:cdev_add failed, retval is %d\n", ret_val)=
;
-               /* unregister dev numbers */
-               unregister_chrdev_region(sep_devno, 1);
-       }
-       return ret_val;
-}
-
-
-/*--------------------------------------------------------------
-  init function
-----------------------------------------------------------------*/
-static int __init sep_init(void)
-{
-       int ret_val =3D 0;
-       dbg("SEP Driver:-------->Init start\n");
-       /* FIXME: Probe can occur before we are ready to survive a probe */
-       ret_val =3D pci_register_driver(&sep_pci_driver);
-       if (ret_val) {
-               edbg("sep_driver:sep_driver_to_device failed, ret_val is %d=
\n", ret_val);
-               goto end_function_unregister_from_fs;
-       }
-       /* register driver to fs */
-       ret_val =3D sep_register_driver_to_fs();
-       if (ret_val)
-               goto end_function_unregister_pci;
-       goto end_function;
-end_function_unregister_pci:
-       pci_unregister_driver(&sep_pci_driver);
-end_function_unregister_from_fs:
-       /* unregister from fs */
-       cdev_del(&sep_cdev);
-       /* unregister dev numbers */
-       unregister_chrdev_region(sep_devno, 1);
-end_function:
-       dbg("SEP Driver:<-------- Init end\n");
-       return ret_val;
-}
-
-
-/*-------------------------------------------------------------
-  exit function
---------------------------------------------------------------*/
-static void __exit sep_exit(void)
-{
-       int size;
-
-       dbg("SEP Driver:--------> Exit start\n");
-
-       /* unregister from fs */
-       cdev_del(&sep_cdev);
-       /* unregister dev numbers */
-       unregister_chrdev_region(sep_devno, 1);
-       /* calculate the total size for de-allocation */
-       size =3D SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
-           SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_SIZE_IN_BYTES + SEP_DRIVE=
R_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES + SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZ=
E_IN_BYTES + SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES + SEP_DRIVER_SYSTEM_DATA_=
MEMORY_SIZE_IN_BYTES;
-       /* FIXME: We need to do this in the unload for the device */
-       /* free shared area  */
-       if (sep_dev) {
-               sep_unmap_and_free_shared_area(sep_dev, size);
-               edbg("SEP Driver: free pages SEP SHARED AREA \n");
-               iounmap((void *) sep_dev->reg_addr);
-               edbg("SEP Driver: iounmap \n");
-       }
-       edbg("SEP Driver: release_mem_region \n");
-       dbg("SEP Driver:<-------- Exit end\n");
-}
-
-
-module_init(sep_init);
-module_exit(sep_exit);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/staging/sep/sep_ext_with_pci_driver.c b/drivers/stagin=
g/sep/sep_ext_with_pci_driver.c
new file mode 100644
index 0000000..68da00e
--- /dev/null
+++ b/drivers/staging/sep/sep_ext_with_pci_driver.c
@@ -0,0 +1,548 @@
+/*
+ *
+ *  sep_ext_with_pci_driver.c - Security Processor Driver
+ *  pci initialization functions
+ *
+ *
+ *************************************************************************=
*
+ *   Copyright 2009 (c) Discretix Technologies Ltd.                       =
   *
+ *   Copyright 2009 (c) Intel Corporation                                 =
   *
+ *                                                                        =
 *
+ *   This software is protected by copyright, international treaties and  =
 *
+ *   various patents. Any copy or reproduction of this Software as        =
 *
+ *   permitted below, must include this Copyright Notice as well as any   =
 *
+ *   other notices provided under such license.                           =
 *
+ *                                                                        =
 *
+ *   This program shall be governed by, and may be used and redistributed =
 *
+ *   under the terms and conditions of the GNU General Public License,    =
 *
+ *   version 2, as published by the Free Software Foundation.             =
 *
+ *                                                                        =
 *
+ *   This program is distributed in the hope that it will be useful,      =
 *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied     =
 *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     =
 *
+ *   See the GNU General Public License for more details.                 =
 *
+ *                                                                        =
 *
+ *   You should have received a copy of the GNU General Public License    =
 *
+ *   along with this program; if not, please write to the Free Software   =
 *
+ *   Foundation, Inc.,                                                    =
 *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            =
 *
+ *************************************************************************=
*
+ *
+ *  CONTACTS:
+ *
+ *  Mark Allyn         mark.a.allyn@intel.com
+ *
+ *  CHANGES:
+ *
+ *  2010.01.08 Initial publish
+ *
+ */
+
+#define DEBUG
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/kdev_t.h>
+#include <linux/semaphore.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <linux/ioctl.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/pagemap.h>
+#include <linux/pci.h>
+#include <linux/firmware.h>
+#include <linux/sched.h>
+
+#include <linux/rar/memrar.h>
+#include <linux/rar/rar_register.h>
+
+#include "sep_driver_hw_defs.h"
+#include "sep_driver_config.h"
+#include "sep_driver_api.h"
+#include "sep_driver_ext_api.h"
+
+/* NOTE - must be defined specific to the board */
+#define VENDOR_ID      PCI_VENDOR_ID_INTEL
+
+/*-----------------------------
+    private functions
+--------------------------------*/
+
+/*
+  This functions locks the area of the resdent and cache sep code
+*/
+int sep_lock_cache_resident_area(void)
+{
+       int error;
+       error =3D rar_lock(RAR_TYPE_IMAGE);
+       if (error) {
+               pr_debug("SEP Driver:cant lock RAR region %d\n",
+                 error);
+               return error;
+       }
+       return 0;
+}
+
+
+/*
+  This functions copies the cache and resident from their source location =
into
+  destination memory, which is external to Linux VM and is given as
+   physical address
+*/
+int sep_copy_cache_resident_to_area(struct device_context *sep_context_ptr=
,
+      dma_addr_t  *dst_new_cache_addr_ptr,
+      dma_addr_t  *dst_new_resident_addr_ptr,
+      dma_addr_t  *dst_new_dcache_addr_ptr)
+
+{
+       const struct firmware *fw;
+
+       /* firmware regions */
+       size_t cache_size;
+       void *cache_virtual_address;
+
+       size_t resident_size;
+       void *resident_virtual_address;
+
+       char *cache_name =3D "cache.image.bin";
+       char *res_name =3D  "resident.image.bin";
+
+       /* error */
+       int error;
+
+       /*--------------------------------
+           CODE
+       -------------------------------------*/
+       error =3D 0;
+
+       pr_debug("SEP Driver:rar_virtual is %p\n",
+         sep_context_ptr->rar_virtual_address);
+       pr_debug("SEP Driver:rar_physical is %08lx\n",
+         (unsigned long)sep_context_ptr->rar_physical_address);
+
+       *dst_new_cache_addr_ptr =3D sep_context_ptr->rar_physical_address;
+       cache_virtual_address =3D sep_context_ptr->rar_virtual_address;
+
+       /* load cache */
+       error =3D request_firmware(&fw, cache_name, &sep_context_ptr->pdev-=
>dev);
+       if (error) {
+               pr_debug("SEP Driver:cant request cache fw\n");
+               goto end_function;
+       }
+
+       pr_debug("SEP Driver:cache data loc is %p\n",
+         (void *)fw->data);
+       pr_debug("SEP Driver:cache data size is %08lx\n",
+         (unsigned long)fw->size);
+
+       memcpy(cache_virtual_address, fw->data, fw->size);
+
+       cache_size =3D fw->size;
+
+       release_firmware(fw);
+
+       *dst_new_resident_addr_ptr =3D *dst_new_cache_addr_ptr+cache_size;
+       resident_virtual_address =3D cache_virtual_address+cache_size;
+
+       /* load resident */
+       error =3D request_firmware(&fw, res_name, &sep_context_ptr->pdev->d=
ev);
+       if (error) {
+               pr_debug("SEP Driver:cant request res fw\n");
+               goto end_function;
+       }
+
+       pr_debug("SEP Driver:res data loc is %p\n",
+         (void *)fw->data);
+       pr_debug("SEP Driver:res data size is %08x\n",
+         fw->size);
+
+       memcpy(resident_virtual_address, fw->data, fw->size);
+
+       resident_size =3D fw->size;
+
+       release_firmware(fw);
+
+       *dst_new_dcache_addr_ptr =3D *dst_new_resident_addr_ptr+resident_si=
ze;
+
+       pr_debug("SEP Driver:resident_addr (physical )is %08lx\n",
+         (unsigned long)*dst_new_resident_addr_ptr);
+       pr_debug("SEP Driver:cache_addr (physical) is %08lx\n",
+         (unsigned long)*dst_new_cache_addr_ptr);
+
+       pr_debug("SEP Driver:resident_addr (logical )is %08lx\n",
+         (unsigned long)resident_virtual_address);
+       pr_debug("SEP Driver:cache_addr (logical) is %08lx\n",
+         (unsigned long)cache_virtual_address);
+
+       pr_debug("SEP Driver:resident_size is %08lx\n",
+         (unsigned long)resident_size);
+       pr_debug("SEP Driver:cache_size is %08lx\n",
+         (unsigned long)cache_size);
+
+end_function:
+
+       return error;
+}
+
+/*
+  This functions maps and allocates the
+  shared area on the  external RAM (device)
+  The input is shared_area_size - the size of the memory to
+  allocate. The outputs
+  are kernel_shared_area_addr_ptr - the kerenl
+  address of the mapped and allocated
+  shared area, and phys_shared_area_addr_ptr
+  - the physical address of the shared area
+*/
+int sep_map_and_alloc_shared_area(struct device_context *sep_context_ptr)
+
+{
+
+       if (!sep_context_ptr) {
+               pr_debug(
+                 "sep_driver:alloc_shared_area invalid parameter\n");
+               WARN_ON(!sep_context_ptr);
+               return -1;
+       }
+
+       sep_context_ptr->shared_area_virt_addr =3D
+         dma_alloc_coherent(&sep_context_ptr->pdev->dev,
+         sep_context_ptr->shared_area_size,
+         &sep_context_ptr->shared_area_bus_addr,
+         GFP_KERNEL);
+
+       if (!sep_context_ptr->shared_area_virt_addr) {
+               pr_debug(
+                 "sep_driver:shared memory kmalloc failed\n");
+               return -1;
+       }
+
+       pr_debug(
+         "SEP Driver:sep_context_ptr->shared_area_virt_addr is %p\n",
+       sep_context_ptr->shared_area_virt_addr);
+       pr_debug(
+         "SEP Driver:sep_context_ptr->shared_region_size is %08lx\n",
+       (unsigned long)sep_context_ptr->shared_area_size);
+       pr_debug(
+         "SEP Driver:sep_context_ptr->shared_area_bus_addr is %08lx\n",
+       (unsigned long)sep_context_ptr->shared_area_bus_addr);
+
+       return 0;
+}
+
+/*
+  This functions unmaps and deallocates the shared area
+  on the  external RAM (device) Input parameter is pointer to
+  device context
+*/
+void sep_unmap_and_free_shared_area(struct device_context *sep_context_ptr=
)
+{
+       dma_free_coherent(&sep_context_ptr->pdev->dev,
+         sep_context_ptr->shared_area_size,
+         sep_context_ptr->shared_area_virt_addr,
+         sep_context_ptr->shared_area_bus_addr);
+}
+
+
+/*
+  This functions returns the physical address inside shared area according
+  to the virtual address. It can be either on the externa RAM device
+  (ioremapped), or on the system RAM
+  This implementation is for the external RAM
+*/
+dma_addr_t sep_shared_area_virt_to_bus(struct device_context *sep_context_=
ptr,
+  void *virt_address)
+{
+       pr_debug("SEP Driver:sh virt to phys v %08lx\n",
+         (unsigned long)virt_address);
+       pr_debug("SEP Driver:sh virt to phys p %08lx\n",
+         (unsigned long)(sep_context_ptr->shared_area_bus_addr
+         + (virt_address - sep_context_ptr->shared_area_virt_addr)));
+
+       return sep_context_ptr->shared_area_bus_addr
+         + (size_t)(virt_address - sep_context_ptr->shared_area_virt_addr)=
;
+}
+
+/*
+  This functions returns the virtual address inside shared area
+  according to the physical address. It can be either on the
+  externa RAM device (ioremapped), or on the system RAM This implementatio=
n
+  is for the external RAM
+*/
+
+void *sep_shared_area_bus_to_virt(struct device_context *sep_context_ptr,
+  dma_addr_t bus_address)
+{
+       return sep_context_ptr->shared_area_virt_addr
+         + (size_t)(bus_address - sep_context_ptr->shared_area_bus_addr);
+}
+
+/*
+ * This function translates the RAR handle into the bus address
+ * */
+int sep_rar_handle_to_bus(void *rar_handle , dma_addr_t *rar_bus)
+{
+       struct RAR_buffer buf;
+       static size_t const BUF_COUNT =3D 1;
+
+       pr_debug("SEP Driver - sep_rar_handle_to_bus %08lx\n",
+         (unsigned long)rar_handle);
+
+       if (rar_bus =3D=3D NULL)
+               return -EINVAL;
+
+       buf.info.handle =3D (unsigned long)rar_handle;
+
+       if (rar_handle_to_bus(&buf, BUF_COUNT) !=3D BUF_COUNT)
+               return -1;
+
+       *rar_bus =3D buf.bus_address;
+
+       return 0;
+}
+
+/*
+  function that is activaed on the succesfull probe of the SEP device
+*/
+static int __devinit sep_probe(struct pci_dev *pdev,
+                       const struct pci_device_id *ent)
+{
+       /* error */
+       int error;
+
+       /* io memory (register area) */
+       static dma_addr_t iomem_start_physical;
+       static dma_addr_t iomem_end_physcal;
+       size_t io_memory_size;
+       void __iomem *iomem_start_virtual;
+
+       /*------------------------
+       CODE
+       ---------------------------*/
+
+       pr_debug("Sep pci probe starting\n");
+       error =3D 0;
+
+       if (sep_context.pdev !=3D NULL) {
+               pr_debug("Only one device supported\n");
+               return -EBUSY;
+       }
+
+       /* enable the device */
+       error =3D pci_enable_device(pdev);
+       if (error) {
+               pr_debug("error enabling pci device\n");
+               return -ENODEV;
+       }
+
+       /* set the pci dev pointer */
+       sep_context.pdev =3D pdev;
+
+       /* get the io memory start address */
+       iomem_start_physical =3D pci_resource_start(pdev, 0);
+       if (!iomem_start_physical) {
+               pr_debug("SEP Driver error pci resource start\n");
+               goto end_function;
+       }
+
+       /* get the io memory end address */
+       iomem_end_physcal =3D pci_resource_end(pdev, 0);
+       if (!iomem_end_physcal) {
+               pr_debug("SEP Driver error pci resource end\n");
+               goto end_function;
+       }
+
+       io_memory_size =3D iomem_end_physcal -
+         iomem_start_physical + 1;
+
+       pr_debug("SEP Driver:iomem_start_physical is %08lx\n",
+       (unsigned long)iomem_start_physical);
+
+       pr_debug("SEP Driver:io_memory_end_phyaical_address is %08lx\n",
+       (unsigned long)iomem_end_physcal);
+
+       pr_debug("SEP Driver:io_memory_size is %08lx\n",
+       (unsigned long)io_memory_size);
+
+       iomem_start_virtual =3D pci_ioremap_bar(pdev, 0);
+       if (!iomem_start_virtual) {
+               pr_debug("SEP Driver pci_iomem failed\n");
+               goto end_function;
+       }
+
+       pr_debug("SEP Driver:iomem_start_virtual is %p\n",
+       iomem_start_virtual);
+
+       sep_context.reg_addr =3D iomem_start_virtual;
+
+       /* call the register_rar function (this will use the sep_callback
+ *         function to perform the rar related activities; this callback
+ *         is used in case we are running now prior to the rar register
+ *         driver running. */
+       error =3D register_rar(&sep_callback, (void *)&sep_context);
+
+               if (error) {
+                       pr_debug("SEP Driver: register_rar failed\n");
+                       WARN_ON(error);
+                       goto end_function;
+               }
+
+#if !SEP_DRIVER_POLLING_MODE
+
+       /* clear ICR register */
+       SEP_WRITE_REGISTER(&sep_context, HW_HOST_ICR_REG_ADDR,
+         0xFFFFFFFF);
+
+       /* set the IMR register - open only GPR 2 */
+       SEP_WRITE_REGISTER(&sep_context, HW_HOST_IMR_REG_ADDR,
+         (~(0x1 << 13)));
+
+       sep_context.sep_irq =3D pdev->irq;
+
+       pr_debug("SEP Driver: my irq is %d\n", sep_context.sep_irq);
+
+       error =3D request_irq(sep_context.sep_irq, sep_inthandler, IRQF_SHA=
RED,
+         "sep_driver", &sep_context.reg_addr);
+
+       if (error) {
+               pr_debug("SEP Driver: Unable to request_irq\n");
+               goto end_function;
+       }
+
+       /* set the IMR register - open only GPR 2 */
+       SEP_WRITE_REGISTER(&sep_context, HW_HOST_IMR_REG_ADDR,
+         (~(0x1 << 13)));
+
+#endif /* Interrupt mode (!POLLING) */
+
+goto end_ok_function;
+
+end_function:
+
+       if (sep_context.reg_addr) {
+               iounmap(sep_context.reg_addr);
+               sep_context.reg_addr =3D NULL;
+       }
+
+       if (sep_context.pdev) {
+               pci_disable_device(sep_context.pdev);
+               sep_context.pdev =3D NULL;
+       }
+
+end_ok_function:
+
+       return error;
+}
+
+/* following is the callback for the rar_driver to call in case we attempt
+ * to register too soon
+ */
+
+int sep_callback(void *sep_context_pointer)
+{
+       int error;
+       struct device_context *my_sep_context;
+
+       my_sep_context =3D (struct device_context *)sep_context_pointer;
+
+       /* set up rar base address from rar_register driver*/
+       error =3D rar_get_address(RAR_TYPE_IMAGE,
+         &my_sep_context->rar_start_address,
+         &my_sep_context->rar_end_address);
+
+       if (error) {
+               pr_debug(
+                 "SEP Driver:cant get RAR region - error is %d\n",
+                 error);
+               goto end_function;
+       }
+
+       pr_debug("SEP Driver:retrieved RAR start is %08lx\n",
+         (unsigned long)my_sep_context->rar_start_address);
+       pr_debug("SEP Driver:retrieved RAR end is %08lx\n",
+         (unsigned long)my_sep_context->rar_end_address);
+
+       /* now make sure we 'own' this address range */
+       my_sep_context->rar_size =3D
+         (size_t)(my_sep_context->rar_end_address -
+         my_sep_context->rar_start_address + 1);
+
+       if (!request_mem_region(my_sep_context->rar_start_address,
+         my_sep_context->rar_size, "sep_sec_driver")) {
+               pr_debug(
+                 "SEP Driver:request mem region failed for rar\n");
+               error =3D -ENOMEM;
+               goto end_function;
+       }
+
+       my_sep_context->rar_virtual_address =3D ioremap_nocache(
+         my_sep_context->rar_start_address, my_sep_context->rar_size);
+       if (!my_sep_context->rar_virtual_address) {
+               pr_debug(
+                 "SEP Driver:cant ioremap_nocache rar\n");
+               error =3D -ENOMEM;
+               goto end_function;
+       }
+
+       my_sep_context->rar_physical_address =3D
+         my_sep_context->rar_start_address;
+
+       pr_debug("SEP Driver:rar_physical is %08lx\n",
+       (unsigned long)my_sep_context->rar_physical_address);
+
+       pr_debug("SEP Driver:rar_virtual is %p\n",
+       my_sep_context->rar_virtual_address);
+
+       goto end_ok_function;
+
+end_function:
+
+       if (my_sep_context->rar_virtual_address) {
+               iounmap(my_sep_context->rar_virtual_address);
+               my_sep_context->rar_virtual_address =3D NULL;
+       }
+
+       if (my_sep_context->reg_addr) {
+               iounmap(my_sep_context->reg_addr);
+               my_sep_context->reg_addr =3D NULL;
+       }
+
+       if (my_sep_context->pdev) {
+               pci_disable_device(my_sep_context->pdev);
+               my_sep_context->pdev =3D NULL;
+       }
+
+end_ok_function:
+
+       return error;
+}
+
+static struct pci_device_id sep_pci_id_tbl[] =3D {
+       { PCI_DEVICE(VENDOR_ID, 0x080c) },
+       { 0 }
+};
+
+MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
+
+/* field for registering driver to PCI device */
+static struct pci_driver sep_pci_driver =3D {
+       .name =3D "sep_sec_driver",
+       .id_table =3D sep_pci_id_tbl,
+       .probe =3D sep_probe
+};
+
+
+/*
+  this function registers th driver to
+  the device subsystem( either PCI, USB, etc)
+*/
+int sep_register_driver_to_device(void)
+{
+       return pci_register_driver(&sep_pci_driver);
+}
+
diff --git a/drivers/staging/sep/sep_main_mod.c b/drivers/staging/sep/sep_m=
ain_mod.c
new file mode 100644
index 0000000..744e287
--- /dev/null
+++ b/drivers/staging/sep/sep_main_mod.c
@@ -0,0 +1,3330 @@
+ /*
+ * sep_main_mod.c
+ *
+ *************************************************************************=
*
+ *   Copyright 2009 (c) Discretix Technologies Ltd.                       =
   *
+ *   Copyright 2009 (c) Intel Corporation                                 =
   *
+ *                                                                        =
 *
+ *   This software is protected by copyright, international treaties and  =
 *
+ *   various patents. Any copy or reproduction of this Software as        =
 *
+ *   permitted below, must include this Copyright Notice as well as any   =
 *
+ *   other notices provided under such license.                           =
 *
+ *                                                                        =
 *
+ *   This program shall be governed by, and may be used and redistributed =
 *
+ *   under the terms and conditions of the GNU General Public License,    =
 *
+ *   version 2, as published by the Free Software Foundation.             =
 *
+ *                                                                        =
 *
+ *   This program is distributed in the hope that it will be useful,      =
 *
+ *   but WITHOUT ANY liability and WARRANTY; without even the implied     =
 *
+ *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     =
 *
+ *   See the GNU General Public License for more details.                 =
 *
+ *                                                                        =
 *
+ *   You should have received a copy of the GNU General Public License    =
 *
+ *   along with this program; if not, please write to the Free Software   =
 *
+ *   Foundation, Inc.,                                                    =
 *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.            =
 *
+ *************************************************************************=
*
+ *
+ *  CONTACTS:
+ *
+ *  Mark Allyn         mark.a.allyn@intel.com
+ *
+ *  CHANGES:
+ *
+ *  2010.01.08 Initial publish
+ *
+ */
+
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/kdev_t.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <linux/ioctl.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/pagemap.h>
+#include <linux/dma-mapping.h>
+#include <asm/cacheflush.h>
+#include <linux/sched.h>
+
+#ifdef DX_CC52_SUPPORT
+#include <linux/netlink.h>
+#include <linux/connector.h>
+#include <linux/cn_proc.h>
+#endif
+
+#include "sep_driver_hw_defs.h"
+#include "sep_driver_config.h"
+#include "sep_driver_api.h"
+#include "sep_driver_ext_api.h"
+
+/*----------------------------------------
+       DEFINES
+-----------------------------------------*/
+
+
+
+/*--------------------------------------------
+       GLOBAL variables
+--------------------------------------------*/
+
+/* debug messages level */
+static int sep_debug =3D 0x0;
+module_param(sep_debug, int, 0);
+MODULE_PARM_DESC(sep_debug, "Flag to enable SEP debug messages");
+
+/* context of the device */
+struct device_context   sep_context;
+
+
+/*---------------------------------------------
+       FUNCTIONS
+-----------------------------------------------*/
+/*
+  this function locks SEP by locking the semaphore
+*/
+int sep_lock(void)
+{
+  /* get the lock */
+  wait_event_interruptible(sep_context.event ,
+      test_and_set_bit(SEP_MMAP_LOCK_BIT, &sep_context.in_use_flag) =3D=3D=
 0);
+       if (signal_pending(current))
+               return -EINTR;
+
+  return 0;
+}
+
+/*
+  this function unlocks SEP
+*/
+void sep_unlock(void)
+{
+       /* check if mappings must be freed */
+       if (sep_context.shared_area_dma_addr)
+               dma_unmap_single(sep_context.dev_ptr,
+                       sep_context.shared_area_dma_addr,
+                       sep_context.shared_area_size,
+                       DMA_BIDIRECTIONAL);
+
+       /* zero the shared area mapping */
+       sep_context.shared_area_dma_addr =3D 0;
+
+  /* release lock */
+  clear_bit(SEP_MMAP_LOCK_BIT, &sep_context.in_use_flag);
+  wake_up(&sep_context.event);
+}
+
+/*
+  this function returns the address of the message shared area
+*/
+void *sep_map_shared_area(void)
+{
+  return sep_context.shared_area_virt_addr;
+}
+
+/*
+  calculates time and sets it at the predefined address
+*/
+static int sep_set_time(dma_addr_t     *bus_ptr,
+                                               u32     *time_in_sec_ptr)
+{
+  /*  time struct */
+  struct timeval  time;
+
+  /* address of time in the kernel */
+  u32   *time_addr;
+
+
+  /*------------------------
+       CODE
+  --------------------------*/
+
+  dbg("SEP Driver:--------> sep_set_time start\n");
+
+
+  do_gettimeofday(&time);
+
+  /* set value in the SYSTEM MEMORY offset */
+  time_addr =3D sep_context.shared_area_virt_addr +
+                       SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES;
+
+  time_addr[0] =3D SEP_TIME_VAL_TOKEN;
+  time_addr[1] =3D time.tv_sec;
+
+  edbg("SEP Driver:time.tv_sec is %x\n",
+                       (u32)time.tv_sec);
+  edbg("SEP Driver:time_addr is %p\n",
+                       time_addr);
+  edbg("SEP Driver:g_sep_shared_area_virt_addr is %p\n",
+                       sep_context.shared_area_virt_addr);
+
+  /* set the output parameters if needed */
+  if (bus_ptr)
+       *bus_ptr =3D sep_shared_area_virt_to_bus(&sep_context,
+      time_addr);
+
+       if (time_in_sec_ptr)
+               *time_in_sec_ptr =3D time.tv_sec;
+
+  dbg("SEP Driver:<-------- sep_set_time end\n");
+
+  return 0;
+}
+
+
+#ifdef DX_CC52_SUPPORT
+/*
+   open function for the singleton driver
+*/
+static int sep_singleton_open(struct inode *inode_ptr , struct file *file_=
ptr)
+{
+  /* return value */
+  int             error;
+
+  /*-----------------
+    CODE
+  ---------------------*/
+
+  error =3D 0;
+
+  dbg("SEP Driver:--------> sep_singleton_open start\n");
+
+       if (test_and_set_bit(0, &sep_context.singleton_access_flag))
+               error =3D -EBUSY;
+
+  dbg("SEP Driver:<-------- sep_singleton_open end\n");
+
+  return error;
+}
+
+/*
+  inserts the data into the caller id table
+*/
+static int sep_set_caller_id_handler(u32 arg)
+{
+  /* error */
+  int   error;
+
+  /* counter */
+  int   i;
+
+  /* command arguments */
+  struct sep_driver_set_caller_id_t  command_args;
+
+  /*----------------------------
+      CODE
+  ------------------------------*/
+
+  dbg("SEP Driver:--------> sep_set_caller_id_handler start\n");
+
+  error =3D 0;
+
+       for (i =3D 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
+               if (sep_context.caller_id_table[i].pid =3D=3D 0)
+                       break;
+  }
+
+       if (i =3D=3D SEP_CALLER_ID_TABLE_NUM_ENTRIES) {
+               edbg("SEP Driver:i =3D=3D SEP_CALLER_ID_TABLE_NUM_ENTRIES\n=
");
+               error =3D -ENOMEM;
+               goto end_function;
+  }
+
+  /* copy the data */
+       if (copy_from_user(&command_args ,
+                       (void *)arg ,
+                       sizeof(struct sep_driver_set_caller_id_t))) {
+               edbg("SEP Driver:copy_from_user failed\n");
+               error =3D -EFAULT;
+               goto end_function;
+  }
+
+       if (!command_args.pid ||
+                       !command_args.callerIdAddress ||
+                       !command_args.callerIdSizeInBytes) {
+
+               edbg("SEP Driver: params validation error\n");
+
+               error =3D -EINVAL;
+               goto end_function;
+  }
+
+  edbg("SEP Driver:pid is %x\n" ,
+                               command_args.pid);
+  edbg("SEP Driver:callerIdSizeInBytes is %x\n" ,
+                               command_args.callerIdSizeInBytes);
+
+       if (command_args.callerIdSizeInBytes >
+                       SEP_CALLER_ID_HASH_SIZE_IN_BYTES) {
+               error =3D -EINVAL;
+               goto end_function;
+  }
+
+  sep_context.caller_id_table[i].pid =3D command_args.pid;
+
+       if (copy_from_user(sep_context.caller_id_table[i].callerIdHash,
+                       command_args.callerIdAddress ,
+                       command_args.callerIdSizeInBytes))
+               error =3D -EFAULT;
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_set_caller_id_handler end\n");
+
+  return error;
+}
+
+/*
+  set the caller id (if exists) of the current process that send request t=
o SeP
+*/
+static int sep_set_current_caller_id(void)
+{
+ int i;
+
+  dbg("SEP Driver:--------> sep_set_current_caller_id start\n");
+
+ edbg("current process is %d\n", current->pid);
+
+ /* zero the previous value */
+ memset((void *)(sep_context.shared_area_virt_addr +
+                       (SEP_DRIVER_SYSTEM_CALLER_ID_MEMORY_OFFSET_IN_BYTES=
)),
+                       0,
+                       SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
+
+ for (i =3D 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
+       if (sep_context.caller_id_table[i].pid =3D=3D current->pid) {
+               edbg("Caller Id found\n");
+
+               memcpy((void *)(sep_context.shared_area_virt_addr +
+                       (SEP_DRIVER_SYSTEM_CALLER_ID_MEMORY_OFFSET_IN_BYTES=
)),
+                       (void *)(sep_context.caller_id_table[i].callerIdHas=
h),
+                       SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
+    break;
+  }
+ }
+
+ dbg("SEP Driver:<-------- sep_set_current_caller_id end\n");
+
+ return 0;
+}
+
+
+/*
+  callback for the netlink connector registration
+*/
+static void sep_cn_callback(void *data)
+{
+  /* counter */
+  int                 counter;
+
+  /* message */
+  struct cn_msg        *msg;
+
+  /* event */
+  struct proc_event    *ev;
+
+  /* process id */
+  int                 pid;
+
+  /*--------------------
+      CODE
+  ----------------------*/
+
+  msg =3D data;
+
+  /* get the proc event pointer */
+  ev =3D (struct proc_event *)msg->data;
+
+  /* check the event */
+       switch (ev->what) {
+       case PROC_EVENT_EXEC:
+
+      /* get the pid */
+      pid =3D ev->event_data.exec.process_pid;
+
+      break;
+
+       case PROC_EVENT_EXIT:
+
+      /* get the pid */
+      pid =3D ev->event_data.exit.process_pid;
+
+      break;
+
+       default:
+      /* not interested in the rest of the events */
+      goto end_function;
+  }
+
+  /* check if the pid is relevant */
+       for (counter =3D 0;
+                               counter < SEP_CALLER_ID_TABLE_NUM_ENTRIES;
+                               counter++) {
+               /* if the pid is found - remove it from the table */
+               if (sep_context.caller_id_table[counter].pid =3D=3D pid)
+                       sep_context.caller_id_table[counter].pid =3D 0;
+  }
+
+
+end_function:
+
+  return;
+}
+
+/*
+  initializes the caller id functionality
+*/
+static int sep_init_caller_id(void)
+{
+  /* return value */
+  int   ret_val;
+
+  /* counter */
+  int   counter;
+
+  struct cb_id caller_id;
+
+
+  /*----------------------------
+      CODE
+  ---------------------------------*/
+
+  ret_val =3D 0;
+
+  /* init cb_id struct */
+  caller_id.idx =3D CN_IDX_PROC;
+  caller_id.val =3D CN_VAL_PROC;
+
+  /* init caller id table */
+  for (counter =3D 0; counter < SEP_CALLER_ID_TABLE_NUM_ENTRIES; counter++=
)
+       sep_context.caller_id_table[counter].pid =3D 0;
+
+
+  /* init access flag */
+  sep_context.singleton_access_flag =3D 0;
+
+  edbg("SEP Driver: caller id table init finished\n");
+
+  /* register to netlink connector */
+  /*ret_val =3D cn_add_callback(&caller_id, "sep_caller_id", &sep_cn_callb=
ack);*/
+
+
+  return ret_val;
+}
+
+#endif /*DX_CC52_SUPPORT*/
+
+
+/*
+  This function raises interrupt to SEP that signals that is has a new
+       command from HOST
+*/
+static int sep_send_command_handler(void)
+{
+  int error;
+
+  u32 count;
+
+  dbg("SEP Driver:--------> sep_send_command_handler start\n");
+
+  error =3D 0;
+
+  /* check if message was already sent without poll */
+  if (test_bit(SEP_SEND_MSG_LOCK_BIT, &sep_context.in_use_flag)) {
+               error =3D -EACCES;
+               goto end_function;
+  }
+
+  /* set bit that allows poll */
+  set_bit(SEP_SEND_MSG_LOCK_BIT, &sep_context.in_use_flag);
+
+  sep_set_time(0, 0);
+
+#ifdef DX_CC52_SUPPORT
+  /* set the current caller if  - if exists */
+  sep_set_current_caller_id();
+#endif
+
+  for (count =3D 0; count < 12 * 4; count +=3D 4)
+               edbg("Word %x of the message is %x\n",
+                       count,
+                       *((u32 *)(sep_context.shared_area_virt_addr + count=
)));
+
+  /* update counter */
+  sep_context.host_to_sep_send_counter++;
+
+       sep_context.shared_area_dma_addr =3D
+               dma_map_single(sep_context.dev_ptr,
+               (void *)sep_context.shared_area_virt_addr,
+               sep_context.shared_area_size,
+               DMA_BIDIRECTIONAL);
+
+  /* send interrupt to SEP */
+  SEP_WRITE_REGISTER(&sep_context, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
+
+  dbg("SEP Driver:<-------- sep_send_command_handler end\n");
+
+end_function:
+
+  return error;
+}
+
+/*
+  this function notifies the SeP of the incoming message
+*/
+int sep_send_msg_rdy_cmd(void)
+{
+  return sep_send_command_handler();
+}
+
+
+/* poll(suspend), until reply from sep */
+int sep_driver_poll(u32 *source_ptr)
+{
+  /* error */
+  int error;
+
+  /* gpr3 register value */
+  u32  retVal2;
+
+  /* gp3 register value */
+  u32 retVal3;
+
+  /*-----------------
+      CODE
+  -------------------*/
+
+  error =3D 0;
+
+  /* check if send command or send_reply were activated previously */
+       if (!test_bit(SEP_SEND_MSG_LOCK_BIT, &sep_context.in_use_flag)) {
+               error =3D -EIO;
+               goto end_function;
+  }
+
+#if SEP_DRIVER_POLLING_MODE
+       do {
+               /* read gp2 */
+               retVal2 =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+
+               /* read gp3 */
+               retVal3 =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+
+               /* sleep between loops */
+               set_current_state(TASK_INTERRUPTIBLE);
+               schedule_timeout(50);
+
+       } while ((retVal3  =3D=3D 0x0) &&
+      sep_context.host_to_sep_send_counter !=3D (retVal2 & 0x7FFFFFFF));
+
+  sep_context.sep_to_host_reply_counter++;
+#else
+  /* poll, until reply from sep */
+  wait_event(sep_context.event,
+                       (sep_context.host_to_sep_send_counter =3D=3D
+                       sep_context.sep_to_host_reply_counter));
+
+#endif
+
+  /* check if error occured during poll */
+  retVal3 =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+       if (retVal3 !=3D 0x0) {
+               edbg("SEP Driver: error during poll\n");
+               error =3D -EIO;
+               goto end_function;
+  }
+
+       if (sep_context.host_to_sep_send_counter =3D=3D
+                       sep_context.sep_to_host_reply_counter) {
+
+               dma_unmap_single(sep_context.dev_ptr,
+                       sep_context.shared_area_dma_addr,
+                       sep_context.shared_area_size,
+                       DMA_BIDIRECTIONAL);
+
+               /* zero the shared area mapping */
+               sep_context.shared_area_dma_addr =3D 0;
+
+               retVal2 =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+
+               edbg("retVal2 is %x\n", retVal2);
+
+               /* clear the bit-in case it must be set
+               again by send_reply_comand */
+               clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep_context.in_use_flag);
+
+               /* check printf request from sep */
+               if ((retVal2 >> 30) & 0x1) {
+
+                       edbg("SEP Driver: sep printf request in\n");
+                       *source_ptr =3D SEP_DRIVER_SRC_PRINTF;
+                       goto end_function;
+               }
+
+               /* check if the this is sep reply or request */
+               if (retVal2 >> 31) {
+                       edbg("SEP Driver: sep request in\n");
+                       *source_ptr =3D SEP_DRIVER_SRC_REQ;
+           /* request */
+               } else {
+                       edbg("SEP Driver: sep reply in\n");
+                       *source_ptr =3D SEP_DRIVER_SRC_REPLY;
+               }
+       }
+
+end_function:
+
+  return error;
+}
+
+/*----------------------------------------------------------------------
+  open function of the character driver - initializes the private data
+------------------------------------------------------------------------*/
+static int sep_open(struct inode *inode_ptr, struct file *file_ptr)
+{
+  /* return value */
+  int                  error;
+
+  /*-----------------
+       CODE
+  ---------------------*/
+
+  error =3D 0;
+
+  dbg("SEP Driver:--------> open start\n");
+
+  /* init the private data flag */
+  file_ptr->private_data =3D (void *)SEP_DRIVER_DISOWN_LOCK_FLAG;
+
+  dbg("SEP Driver:<-------- open end\n");
+
+  return error;
+}
+
+
+/*------------------------------------------------------------
+       release function
+-------------------------------------------------------------*/
+static int sep_release(struct inode *inode_ptr, struct file *file_ptr)
+{
+  /*-----------------
+       CODE
+  ---------------------*/
+
+  dbg("SEP Driver:--------> sep_release start\n");
+
+       /* check that all the dma resources were freed */
+       sep_free_dma_table_data_handler();
+
+  /* unlock on release only if file pointer still holds the lock flag */
+       if ((u32)file_ptr->private_data =3D=3D SEP_DRIVER_OWN_LOCK_FLAG) {
+
+               /* check if mappings must be freed */
+               if (sep_context.shared_area_dma_addr)
+                       dma_unmap_single(sep_context.dev_ptr,
+                       sep_context.shared_area_dma_addr,
+                       sep_context.shared_area_size,
+                       DMA_BIDIRECTIONAL);
+
+               /* zero the shared area mapping */
+               sep_context.shared_area_dma_addr =3D 0;
+
+               /* check that all the dma resources were freed */
+               sep_free_dma_table_data_handler();
+
+               /* release lock */
+               clear_bit(SEP_MMAP_LOCK_BIT, &sep_context.in_use_flag);
+
+               /* raise event for stuck contextes */
+               wake_up(&sep_context.event);
+       }
+
+       dbg("SEP Driver:<-------- sep_release end\n");
+
+       return 0;
+}
+
+
+
+
+/*---------------------------------------------------------------
+  map function - this functions maps the message shared area
+-----------------------------------------------------------------*/
+static int sep_mmap(struct file  *filp, struct vm_area_struct  *vma)
+{
+  /* physical addr */
+  dma_addr_t phys_addr;
+
+  /* error */
+  int error;
+
+  /*-----------------------
+       CODE
+  -------------------------*/
+
+  dbg("SEP Driver:--------> mmap start\n");
+
+  /* lock the access to SeP */
+  wait_event_interruptible(sep_context.event ,
+      test_and_set_bit(SEP_MMAP_LOCK_BIT, &sep_context.in_use_flag) =3D=3D=
 0);
+       if (signal_pending(current)) {
+               error =3D -EINTR;
+               goto end_function;
+  }
+
+  /* set the flag for LOCK */
+  filp->private_data =3D (void *)SEP_DRIVER_OWN_LOCK_FLAG;
+
+  /* zero the pools */
+  sep_context.data_pool_bytes_allocated =3D 0;
+
+  /* check that the size of the mapped range is as the size of the message
+  shared area */
+       if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
+               edbg("SEP Driver mmap requested size is more than allowed\n=
");
+               error =3D -EAGAIN;
+
+               goto end_function_with_error;
+       }
+
+  edbg("SEP Driver:g_sep_shared_area_virt_addr is %p\n",
+      sep_context.shared_area_virt_addr);
+
+  /* get physical address */
+  phys_addr  =3D sep_context.shared_area_bus_addr;
+
+  edbg("SEP Driver: phys_addr is %08x\n", (u32)phys_addr);
+
+       if (remap_pfn_range(vma,
+               vma->vm_start,
+               phys_addr >> PAGE_SHIFT,
+               vma->vm_end - vma->vm_start,
+               vma->vm_page_prot)) {
+               edbg("SEP Driver remap_page_range failed\n");
+               error =3D -EAGAIN;
+
+               goto end_function_with_error;
+       }
+
+       goto end_function;
+
+end_function_with_error:
+
+  /* clear the bit */
+  clear_bit(SEP_MMAP_LOCK_BIT , &sep_context.in_use_flag);
+
+  /* raise event for stuck contextes */
+  wake_up(&sep_context.event);
+
+end_function:
+
+  dbg("SEP Driver:<-------- mmap end\n");
+
+  return 0;
+}
+
+
+/*-----------------------------------------------
+  poll function
+*----------------------------------------------*/
+static u32 sep_poll(struct file  *filp, poll_table  *wait)
+{
+  u32 count;
+
+  u32  mask =3D 0;
+
+  /* GPR2 register */
+  u32  retVal2;
+
+  /* GPR3 register */
+  u32  retVal3;
+
+  /*----------------------------------------------
+       CODE
+  -------------------------------------------------*/
+
+  dbg("SEP Driver:--------> poll start\n");
+
+  retVal2 =3D retVal3 =3D 0;
+
+  /* check that only process that lock the driver may call the poll  */
+  if ((u32)filp->private_data !=3D SEP_DRIVER_OWN_LOCK_FLAG) {
+               mask =3D POLLERR;
+               goto end_function;
+  }
+
+       /* check if send command or send_reply were activated previously */
+       if (!test_bit(SEP_SEND_MSG_LOCK_BIT, &sep_context.in_use_flag)) {
+               mask =3D POLLERR;
+               goto end_function;
+  }
+
+#if SEP_DRIVER_POLLING_MODE
+
+       while ((retVal3  =3D=3D 0x0) &&
+       (sep_context.host_to_sep_send_counter !=3D (retVal2 & 0x3FFFFFFF)))=
 {
+               retVal2 =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+
+               retVal3 =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+       }
+
+  sep_context.sep_to_host_reply_counter++;
+#else
+  /* add the event to the polling wait table */
+  poll_wait(filp, &sep_context.event, wait);
+
+#endif
+
+  edbg("sep_host_to_sep_send_counter is %x\n",
+      sep_context.host_to_sep_send_counter);
+  edbg("sep_sep_to_host_reply_counter is %x\n",
+      sep_context.sep_to_host_reply_counter);
+
+  /* check if error occured during poll */
+  retVal3 =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+       if (retVal3 !=3D 0x0) {
+               edbg("SEP Driver: error during poll\n");
+               mask |=3D POLLERR;
+
+               goto end_function;
+  }
+
+  /* check if the data is ready */
+       if (sep_context.host_to_sep_send_counter =3D=3D
+                       sep_context.sep_to_host_reply_counter) {
+
+               dma_unmap_single(sep_context.dev_ptr,
+                       sep_context.shared_area_dma_addr,
+                       sep_context.shared_area_size,
+                       DMA_BIDIRECTIONAL);
+
+               /* zero the shared area mapping */
+               sep_context.shared_area_dma_addr =3D 0;
+
+               for (count =3D 0; count < 12 * 4; count +=3D 4)
+                       edbg("Sep Mesg Word %x of the message is %x\n",
+                       count,
+                       *((u32 *)(sep_context.shared_area_virt_addr + count=
)));
+
+               for (count =3D 0; count < 10 * 4; count +=3D 4)
+                       edbg("Debug Data Word %x of the message is %x\n",
+                       count,
+                       *((u32 *)(sep_context.shared_area_virt_addr +
+                               0x1800 +
+                               count)));
+
+               retVal2 =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+
+               edbg("retVal2 is %x\n", retVal2);
+
+               /* clear the bit-in case it must be set
+               again by send_reply_comand */
+               clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep_context.in_use_flag);
+
+               /* check printf request from sep */
+               if ((retVal2 >> 30) & 0x1) {
+                       edbg("SEP Driver: sep printf request in\n");
+                       mask |=3D POLLHUP;
+
+                       goto end_function;
+    }
+
+               /* check if the this is sep reply or request */
+               if (retVal2 >> 31) {
+                       edbg("SEP Driver: sep request in\n");
+                       /* request */
+                       mask |=3D POLLOUT | POLLWRNORM;
+               } else {
+                       edbg("SEP Driver: sep reply in\n");
+                       mask |=3D POLLIN | POLLRDNORM;
+               }
+
+       }
+
+end_function:
+
+  dbg("SEP Driver:<-------- poll exit\n");
+  return mask;
+}
+
+/*
+  This function raises interrupt to SEPm that signals that is has a
+  new command from HOST
+*/
+static int sep_send_reply_command_handler(void)
+{
+       /* count */
+  u32 count;
+
+  /* error */
+  int error;
+
+
+  dbg("SEP Driver:--------> sep_send_reply_command_handler start\n");
+
+  error =3D 0;
+
+  /* check if message was already sent without poll */
+  if (test_bit(SEP_SEND_MSG_LOCK_BIT, &sep_context.in_use_flag)) {
+               error =3D -EACCES;
+               goto end_function;
+  }
+
+       for (count =3D 0; count < 12 * 4; count +=3D 4)
+               edbg("Word %x of the message is %x\n",
+                       count,
+                       *((u32 *)(sep_context.shared_area_virt_addr + count=
)));
+
+  /* set bit that allows poll */
+  set_bit(SEP_SEND_MSG_LOCK_BIT, &sep_context.in_use_flag);
+
+  /* update both counters counter */
+  sep_context.host_to_sep_send_counter++;
+
+  sep_context.sep_to_host_reply_counter++;
+
+  /* flush shared area */
+       sep_context.shared_area_dma_addr =3D
+               dma_map_single(sep_context.dev_ptr,
+               (void *)sep_context.shared_area_virt_addr,
+               sep_context.shared_area_size,
+               DMA_BIDIRECTIONAL);
+
+  /* send the interrupt to SEP */
+  SEP_WRITE_REGISTER(&sep_context,
+                               HW_HOST_HOST_SEP_GPR2_REG_ADDR,
+                               sep_context.host_to_sep_send_counter);
+
+  /* update host to sep counter */
+  sep_context.host_to_sep_send_counter++;
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_send_reply_command_handler end\n");
+
+  return error;
+}
+
+/*
+  This function handles the allocate data pool memory request
+  This function returns calculates the physical address of the
+  allocated memory, and the offset of this area from the mapped address.
+  Therefore, the FVOs in user space can calculate the exact virtual
+  address of this allocated memory
+*/
+static int sep_allocate_data_pool_memory_handler(void *arg)
+{
+  /* error */
+  int   error;
+
+  /* command paramaters */
+  struct sep_driver_alloc_t  command_args;
+
+  /*-------------------------
+       CODE
+  ----------------------------*/
+
+  dbg("SEP Driver:--------> sep_allocate_data_pool_memory_handler start\n"=
);
+
+  error =3D 0;
+
+       if (copy_from_user(&command_args,
+                       arg,
+                       sizeof(struct sep_driver_alloc_t))) {
+
+                       error =3D -EFAULT;
+                       goto end_function;
+  }
+
+  /* allocate memory */
+       if (
+               (SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES -
+               sep_context.data_pool_bytes_allocated) <
+               command_args.num_bytes) {
+               error =3D -ENOMEM;
+               goto end_function;
+  }
+
+  /* set the virtual and physical address */
+  command_args.offset =3D SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
+                       sep_context.data_pool_bytes_allocated;
+  command_args.bus_address =3D sep_context.shared_area_bus_addr +
+                       SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
+                       sep_context.data_pool_bytes_allocated;
+
+  /* write the memory back to the user space */
+       if (copy_to_user((void *)arg,
+                       (void *)&command_args,
+                       sizeof(struct sep_driver_alloc_t))) {
+
+               error =3D -EFAULT;
+               goto end_function;
+  }
+
+  /* set the allocation */
+  sep_context.data_pool_bytes_allocated +=3D command_args.num_bytes;
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_allocate_data_pool_memory_handler end\n");
+
+  return error;
+}
+
+
+
+
+
+/*
+  this function handles the request for creation of the DMA table
+  for the synchronic symmetric operations (AES,DES,HASH).
+  it returns the physical addresses of the created DMA table to the
+  user space which insert them as a parameters to the HOST-SEP message.
+  this pointers are NOT being treated by the user application in any case.
+*/
+static int sep_create_sync_dma_tables_handler(void *arg)
+{
+  /* error */
+  int   error;
+
+  /* command arguments */
+  struct sep_driver_build_sync_table_t command_args;
+
+  /*------------------------
+       CODE
+  --------------------------*/
+
+  dbg("SEP Driver:--------> sep_create_sync_dma_tables_handler start\n");
+
+       if (copy_from_user(&command_args,
+                       arg,
+                       sizeof(struct sep_driver_build_sync_table_t))) {
+
+                       error =3D -EFAULT;
+                       goto end_function;
+  }
+
+  edbg("app_in_address is %08lx\n", command_args.app_in_address);
+  edbg("app_out_address is %08lx\n", command_args.app_out_address);
+  edbg("data_size is %x\n", command_args.data_in_size);
+  edbg("block_size is %x\n", command_args.block_size);
+
+  /* validate user parameters */
+       if (!command_args.app_in_address) {
+
+               edbg("SEP Driver: params validation error\n");
+
+               error =3D -EINVAL;
+               goto end_function;
+  }
+
+  /* check if we need to build only input table or input/output */
+  if (command_args.app_out_address) {
+
+       /* prepare input/output tables. */
+       error =3D sep_prepare_input_output_dma_table(
+      command_args.app_in_address,
+      command_args.app_out_address,
+      command_args.data_in_size,
+      command_args.block_size,
+      &command_args.in_table_address,
+      &command_args.out_table_address,
+      &command_args.in_table_num_entries,
+      &command_args.out_table_num_entries,
+      &command_args.table_data_size,
+      command_args.isKernelVirtualAddress);
+
+  } else {
+       /* prepare input tables */
+       error =3D sep_prepare_input_dma_table(
+                                       command_args.app_in_address,
+                                       command_args.data_in_size,
+                                       command_args.block_size,
+                                       &command_args.in_table_address,
+                                       &command_args.in_table_num_entries,
+                                       &command_args.table_data_size,
+                                       command_args.isKernelVirtualAddress=
);
+  }
+
+       if (error)
+               goto end_function;
+
+  /* copy to user */
+       if (copy_to_user(arg,
+                       (void *)&command_args,
+                       sizeof(struct sep_driver_build_sync_table_t)))
+               error =3D -EFAULT;
+
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_create_sync_dma_tables_handler end\n");
+
+  return error;
+}
+
+/*
+  This API handles the end transaction request
+*/
+static int sep_end_transaction_handler(struct file *file_ptr)
+{
+  /*----------------------------
+       CODE
+  -----------------------------*/
+
+  dbg("SEP Driver:--------> sep_end_transaction_handler start\n");
+
+       /* check that poll was called before */
+  if (sep_context.shared_area_dma_addr)
+                       dma_unmap_single(sep_context.dev_ptr,
+                       sep_context.shared_area_dma_addr,
+                       sep_context.shared_area_size,
+                       DMA_BIDIRECTIONAL);
+
+       /* zero the shared area mapping */
+       sep_context.shared_area_dma_addr =3D 0;
+
+       /* check that all the dma resources were freed */
+       sep_free_dma_table_data_handler();
+
+  clear_bit(SEP_MMAP_LOCK_BIT , &sep_context.in_use_flag);
+
+  /* raise event for stuck contextes */
+  wake_up(&sep_context.event);
+
+  file_ptr->private_data =3D (void *)SEP_DRIVER_DISOWN_LOCK_FLAG;
+
+  dbg("SEP Driver:<-------- sep_end_transaction_handler end\n");
+
+  return 0;
+}
+
+static int sep_start_handler(void)
+{
+  /* reg val */
+  u32 reg_val;
+
+  /* error */
+  u32 error;
+
+  /*-----------------------------
+       CODE
+  ------------------------------*/
+
+  dbg("SEP Driver:--------> sep_start_handler start\n");
+
+  error =3D 0;
+
+  /* wait in polling for message from SEP */
+       do {
+               reg_val =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+       } while (!reg_val);
+
+  /* check the value */
+       if (reg_val =3D=3D 0x1) {
+               /* fatal error - read erro status from GPRO */
+               error =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR0_REG_ADDR);
+               goto end_function;
+  }
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_start_handler end\n");
+
+  return error;
+}
+
+
+/*
+  this function handles the request for SEP initialization
+*/
+static int sep_init_handler(void *arg)
+{
+  /* word from message */
+  u32   message_word;
+
+  /* message ptr */
+  u32          *message_ptr;
+
+  /* command arguments */
+  struct sep_driver_init_t command_args;
+
+  /* counter */
+  u32   counter;
+
+  /* error */
+  int   error;
+
+  /* reg val */
+  u32   reg_val;
+
+  /*-------------------
+       CODE
+  ---------------------*/
+
+  dbg("SEP Driver:--------> sep_init_handler start\n");
+
+  error =3D 0;
+
+  /* this API may be run only by root */
+       if (!capable(CAP_SYS_ADMIN)) {
+               error =3D -EACCES;
+               goto end_function;
+  }
+
+       if (copy_from_user(&command_args, arg,
+                       sizeof(struct sep_driver_init_t))) {
+
+               error =3D -EFAULT;
+               goto end_function;
+  }
+
+  /* validate user parameters */
+       if (!command_args.message_addr || !command_args.sep_sram_addr) {
+               edbg("SEP Driver: params validation error\n");
+
+               error =3D -EINVAL;
+               goto end_function;
+  }
+
+  message_ptr =3D command_args.message_addr;
+
+  edbg("SEP Driver: before write1\n");
+  /* set the base address of the SRAM  */
+  SEP_WRITE_REGISTER(&sep_context,
+                                       HW_SRAM_ADDR_REG_ADDR,
+                                       command_args.sep_sram_addr);
+
+  for (counter =3D 0 ;
+               counter < command_args.message_size_in_words;
+               counter++, message_ptr++) {
+       get_user(message_word, message_ptr);
+
+  edbg("SEP Driver: before write2\n")
+       /* write data to SRAM */
+       SEP_WRITE_REGISTER(&sep_context, HW_SRAM_DATA_REG_ADDR,
+                                               message_word);
+
+       edbg("SEP Driver:message_word is %x\n", message_word);
+
+       /* wait for write complete */
+       SEP_WAIT_SRAM_WRITE_COMPLETE(&sep_context);
+  }
+
+  /* signal SEP */
+  SEP_WRITE_REGISTER(&sep_context, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x1);
+
+       do {
+               reg_val =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+       } while (!(reg_val & 0xFFFFFFFD));
+
+  /* check the value */
+       if (reg_val =3D=3D 0x1) {
+               edbg("SEP Driver:init failed\n");
+
+               error =3D SEP_READ_REGISTER(&sep_context, 0x8060);
+               edbg("SEP Driver:sw monitor is %x\n", error);
+
+               /* fatal error - read erro status from GPRO */
+               error =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR0_REG_ADDR);
+               edbg("SEP Driver:error is %x\n", error);
+               goto end_function;
+  }
+
+  edbg("SEP Driver: signal end CC_INIT, reg_val is %d\n", reg_val);
+
+  /* signal sep to zero the GPR3 */
+  SEP_WRITE_REGISTER(&sep_context, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x10);
+       /* poll gpr3 till it is 0 */
+       do {
+               reg_val =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+       } while (reg_val !=3D 0);
+
+  #ifndef __LITTLE_ENDIAN
+    SEP_WRITE_REGISTER(&sep_context, HW_HOST_HOST_ENDIAN_REG_ADDR, 0x1/*BE=
*/);
+  #endif
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_init_handler end\n");
+
+  return error;
+
+}
+
+/*
+  this function handles the request cache and resident reallocation
+*/
+static int sep_realloc_cache_resident_handler(void *arg)
+{
+  /* error */
+  int   error;
+
+  /* reg val */
+  u32   reg_val;
+
+  /* physical cache addr */
+  dma_addr_t           cache_bus_address;
+
+  /* physical resident addr */
+  dma_addr_t           resident_bus_address;
+
+  /* physical d-cache addr */
+  dma_addr_t   dcache_bus_address;
+
+  /* command arguments */
+  struct sep_driver_realloc_cache_resident_t command_args;
+
+  /*------------------
+       CODE
+  ---------------------*/
+
+  /* check if SEP already initialized */
+  reg_val =3D SEP_READ_REGISTER(&sep_context,
+                                       HW_HOST_SEP_HOST_GPR3_REG_ADDR);
+
+  /* check old boot finished or warm boot finished or cold-warm boot finis=
hed */
+       if (reg_val !=3D 0x2) {
+               error =3D  SEP_ALREADY_INITIALIZED_ERR;
+               goto end_function;
+  }
+
+  /* this API may be run only by root */
+       if (!capable(CAP_SYS_ADMIN)) {
+               error =3D -EACCES;
+               goto end_function;
+  }
+
+  /* copy the data */
+       if (copy_from_user(&command_args,
+                       arg,
+                       sizeof(struct sep_driver_realloc_cache_resident_t))=
) {
+
+               error =3D -EFAULT;
+               goto end_function;
+  }
+
+
+  /* copy cache and resident to the their intended locations */
+  error =3D sep_copy_cache_resident_to_area(&sep_context,
+      &cache_bus_address,
+      &resident_bus_address,
+      &dcache_bus_address);
+
+  if (error)
+       goto end_function;
+
+#if SEP_DRIVER_LOCK_RAR_MODE
+
+  error =3D sep_copy_ext_cache_to_area(command_args.extcache_addr,
+                               command_args.extcache_size_in_bytes,
+                               0);
+
+       if (error)
+               goto end_function;
+
+
+#endif
+
+  /* lock the area (if needed) */
+  error =3D sep_lock_cache_resident_area();
+       if (error)
+               goto end_function;
+
+  command_args.new_base_addr =3D sep_context.shared_area_bus_addr;
+
+  /* find the new base address according to the lowest address between
+       cache, resident and shared area */
+       if (resident_bus_address < command_args.new_base_addr)
+               command_args.new_base_addr =3D resident_bus_address;
+
+       if (cache_bus_address < command_args.new_base_addr)
+               command_args.new_base_addr =3D cache_bus_address;
+
+       if (dcache_bus_address < command_args.new_base_addr)
+               command_args.new_base_addr =3D dcache_bus_address;
+
+  /* set the return parameters */
+  command_args.new_cache_addr =3D cache_bus_address;
+  command_args.new_resident_addr =3D resident_bus_address;
+  command_args.new_dcache_addr =3D dcache_bus_address;
+
+
+  /* set the new shared area */
+  command_args.new_shared_area_addr =3D sep_context.shared_area_bus_addr;
+
+  edbg("SEP Driver:command_args.new_shared_area_addr is %08x\n",
+       (u32)command_args.new_shared_area_addr);
+  edbg("SEP Driver:command_args.new_base_addr is %08x\n",
+       (u32)command_args.new_base_addr);
+  edbg("SEP Driver:command_args.new_resident_addr is %08x\n",
+       (u32)command_args.new_resident_addr);
+  edbg("SEP Driver:command_args.new_cache_addr is %08x\n",
+       (u32)command_args.new_cache_addr);
+
+  /* return to user */
+       if (copy_to_user(arg,
+                       (void *)&command_args,
+                       sizeof(struct sep_driver_realloc_cache_resident_t))=
)
+               error =3D -EFAULT;
+
+
+end_function:
+
+  return error;
+}
+
+/*
+  This function will retrieve the RAR buffer physical addresses, type
+  and size corresponding to the RAR handles provided in the buffers vector=
.
+*/
+static int sep_rar_prepare_output_msg_handler(void *arg)
+{
+  /* error return code */
+  int   error;
+
+  /* command args */
+  struct sep_driver_rar_handle_to_bus command_args;
+
+  /* bus address */
+  dma_addr_t  rar_bus;
+
+  /* holds the RAR address in the system memory offset */
+  u32   *rar_addr;
+
+  /*------------------
+       CODE
+  ---------------------*/
+
+  dbg("SEP Driver:--------> sep_rar_prepare_output_msg_handler start\n");
+
+  error =3D 0;
+  rar_bus =3D 0;
+
+  /* copy the data */
+       if (copy_from_user(&command_args,
+                       arg,
+                       sizeof(struct sep_driver_rar_handle_to_bus))) {
+               error =3D -EFAULT;
+               goto end_function;
+  }
+
+  /* call to translation function only if user handle is not NULL */
+  if (command_args.rar_handle) {
+       error =3D sep_rar_handle_to_bus(command_args.rar_handle, &rar_bus);
+       if (error)
+               goto end_function;
+  }
+
+  edbg("SEP Driver: rar_addr_bus =3D %x\n", (u32)rar_bus);
+
+  /* set value in the SYSTEM MEMORY offset */
+  rar_addr =3D (u32 *)(sep_context.shared_area_virt_addr +
+                        SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
+
+  /* copy the physical address to the System Area.
+     The SEP will follow this address */
+  rar_addr[0] =3D SEP_RAR_VAL_TOKEN;
+  rar_addr[1] =3D rar_bus;
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_rar_prepare_output_msg_handler end\n");
+
+  return error;
+}
+
+/*
+  this function returns the physical and virtual addresses of the static p=
ool
+*/
+static int sep_get_static_pool_addr_handler(void *arg)
+{
+  /* error */
+  int   error;
+
+  /* command arguments */
+  struct sep_driver_static_pool_addr_t command_args;
+
+  /*-----------------------------
+       CODE
+  ------------------------------*/
+
+  dbg("SEP Driver:--------> sep_get_static_pool_addr_handler start\n");
+
+  error =3D 0;
+
+  /*prepare the output parameters in the struct */
+  command_args.static_bus_address =3D sep_context.shared_area_bus_addr +
+                               SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
+  command_args.static_virt_address =3D sep_context.shared_area_virt_addr +
+                               SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
+
+  edbg(
+  "SEP Driver:physical_static_address is %08x, virtual_static_address %p\n=
",
+       (u32)command_args.static_bus_address,
+       command_args.static_virt_address);
+
+  /* send the parameters to user application */
+       if (copy_to_user(arg,
+                       &command_args,
+                       sizeof(struct sep_driver_static_pool_addr_t)))
+               error =3D -EFAULT;
+
+
+  dbg("SEP Driver:<-------- sep_get_static_pool_addr_handler end\n");
+
+  return error;
+}
+
+/*
+  this address gets the offset of the bus address from the start
+  of the mapped area
+*/
+static int sep_get_physical_mapped_offset_handler(void *arg)
+{
+  /* error */
+  int   error;
+
+  /* command arguments */
+  struct sep_driver_get_mapped_offset_t        command_args;
+
+  /*-----------------------------
+       CODE
+  ------------------------------*/
+
+  dbg("SEP Driver:--------> sep_get_physical_mapped_offset_handler start\n=
");
+
+  error =3D 0;
+
+       if (copy_from_user(&command_args,
+                       arg,
+                       sizeof(struct sep_driver_get_mapped_offset_t))) {
+
+               error =3D -EFAULT;
+               goto end_function;
+  }
+
+       if (!command_args.bus_address) {
+               edbg("SEP Driver: params validation error\n");
+
+               error =3D -EINVAL;
+               goto end_function;
+  }
+
+       if (command_args.bus_address < sep_context.shared_area_bus_addr) {
+               error =3D -EINVAL;
+               goto end_function;
+  }
+
+  /*prepare the output parameters in the struct */
+  command_args.offset =3D command_args.bus_address -
+                                       sep_context.shared_area_bus_addr;
+
+  edbg("SEP Driver:physical_address is %08x, offset is %x\n",
+    (u32)command_args.bus_address,
+    command_args.offset);
+
+  /* send the parameters to user application */
+       if (copy_to_user(arg,
+                       &command_args,
+                       sizeof(struct sep_driver_get_mapped_offset_t)))
+               error =3D -EFAULT;
+
+
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_get_physical_mapped_offset_handler end\n")=
;
+
+  return error;
+}
+
+/*
+  this function handles the request for get time
+*/
+static int sep_get_time_handler(void *arg)
+{
+  /* error */
+  int   error;
+
+  /* command arguments */
+  struct sep_driver_get_time_t command_args;
+
+  /*------------------------
+       CODE
+  --------------------------*/
+
+  error =3D sep_set_time(&command_args.time_bus_address,
+                       &command_args.time_value);
+       if (error)
+               goto end_function;
+
+  /* return to user */
+       if (copy_to_user(arg,
+                       (void *)&command_args,
+                       sizeof(struct sep_driver_get_time_t)))
+               error =3D -EFAULT;
+
+
+end_function:
+
+  return error;
+}
+
+#ifdef DX_CC52_SUPPORT
+/*
+  this function handles the request for ext(3rd party)cache reallocation
+*/
+static int sep_realloc_ext_cache_handler(void *arg)
+{
+  /* error */
+  int   error;
+
+  /* physical ext cache addr */
+  dma_addr_t   ext_cache_bus_address;
+
+  /* command arguments */
+  struct sep_driver_realloc_ext_cache_t   command_args;
+
+  /*------------------
+      CODE
+  ---------------------*/
+
+  /* copy the data */
+       if (copy_from_user(&command_args,
+                       arg ,
+                       sizeof(struct sep_driver_realloc_ext_cache_t))) {
+
+               error =3D -EFAULT;
+               goto end_function;
+  }
+
+#if SEP_DRIVER_LOCK_RAR_MODE
+
+  /* if we are in RAR mode - then the ext cache was already copied
+  and we just need to receive back its' physical address */
+  command_args.ext_cache_size_in_bytes =3D 0;
+
+#endif
+  /* copy cache and resident to the their intended locations */
+  error =3D sep_copy_ext_cache_to_area(command_args.ext_cache_addr,
+                                       command_args.ext_cache_size_in_byte=
s,
+                                       &ext_cache_bus_address);
+  if (error)
+       goto end_function;
+
+
+
+  command_args.new_ext_cache_addr =3D ext_cache_bus_address;
+
+  edbg("SEP Driver:command_args.new_ext_cache_addr is %x\n",
+               command_args.new_ext_cache_addr);
+
+  /* return to user */
+       if (copy_to_user(arg ,
+                       (void *)&command_args ,
+                       sizeof(struct sep_driver_realloc_ext_cache_t)))
+               error =3D -EFAULT;
+
+
+end_function:
+
+  return error;
+}
+#endif /*#ifdef DX_CC52_SUPPORT*/
+
+static long sep_ioctl(
+                                       struct file                     *fi=
lp,
+                                       u32             cmd,
+                                       unsigned long           arg)
+{
+
+  /* error */
+  long                 error;
+
+  /*------------------------
+       CODE
+  ------------------------*/
+  error =3D 0;
+
+  dbg("SEP Driver:--------> ioctl start\n");
+
+
+  edbg("SEP Driver: cmd is %x\n", cmd);
+
+  /* check the lock flag - does not allow any other process
+  to call ioctl on the driver */
+       if ((u32)filp->private_data !=3D SEP_DRIVER_OWN_LOCK_FLAG) {
+               error =3D -EACCES;
+               goto end_function;
+  }
+
+  /* lock access to ioctl */
+  mutex_lock(&sep_context.ioctl_mutex);
+
+  /* check that the command is for sep device */
+       if (_IOC_TYPE(cmd) !=3D SEP_IOC_MAGIC_NUMBER) {
+               error =3D -EFAULT;
+               goto end_function_unlock;
+  }
+
+       switch (cmd) {
+       case SEP_IOCSENDSEPCOMMAND:
+
+         /* send command to SEP */
+       error =3D sep_send_command_handler();
+
+       edbg("SEP Driver: after sep_send_command_handler\n");
+
+         break;
+
+       case SEP_IOCSENDSEPRPLYCOMMAND:
+
+         /* send reply command to SEP */
+       error =3D sep_send_reply_command_handler();
+
+         break;
+
+       case SEP_IOCALLOCDATAPOLL:
+
+         /* allocate data pool */
+       error =3D sep_allocate_data_pool_memory_handler((void *)arg);
+
+         break;
+
+       case SEP_IOCCREATESYMDMATABLE:
+
+         /* create dma table for synhronic operation */
+       error =3D sep_create_sync_dma_tables_handler((void *)arg);
+
+         break;
+
+       case SEP_IOCFREEDMATABLEDATA:
+
+         /* free the pages */
+       error =3D sep_free_dma_table_data_handler();
+
+         break;
+
+       case SEP_IOCSEPSTART:
+
+         /* start command to sep */
+       error =3D sep_start_handler();
+         break;
+
+       case SEP_IOCSEPINIT:
+
+         /* init command to sep */
+       error =3D sep_init_handler((void *)arg);
+
+         break;
+
+       case SEP_IOCGETSTATICPOOLADDR:
+
+               /* get the physical and virtual addresses of the static poo=
l */
+               error =3D sep_get_static_pool_addr_handler((void *)arg);
+
+               break;
+
+       case SEP_IOCENDTRANSACTION:
+
+       error =3D sep_end_transaction_handler(filp);
+
+               break;
+
+       case SEP_IOCREALLOCCACHERES:
+
+       error =3D sep_realloc_cache_resident_handler((void *)arg);
+
+         break;
+
+       case SEP_IOCGETMAPPEDADDROFFSET:
+
+       error =3D sep_get_physical_mapped_offset_handler((void *)arg);
+
+         break;
+
+#ifdef DX_CC52_SUPPORT
+       case SEP_IOCREALLOCEXTCACHE:
+
+      error =3D sep_realloc_ext_cache_handler((void *)arg);
+
+      break;
+#endif
+
+       case SEP_IOCGETIME:
+
+       error =3D sep_get_time_handler((void *)arg);
+
+         break;
+
+       case SEP_IOCRARPREPAREMESSAGE:
+
+       error =3D sep_rar_prepare_output_msg_handler((void *)arg);
+
+         break;
+
+       default:
+               edbg("SEP Driver: **** NO COMMAND ****\n");
+
+    error =3D -ENOTTY;
+         break;
+  }
+
+end_function_unlock:
+
+       mutex_unlock(&sep_context.ioctl_mutex);
+
+end_function:
+
+  dbg("SEP Driver:<-------- ioctl end\n");
+
+  return error;
+}
+
+#ifdef DX_CC52_SUPPORT
+
+
+/*
+  singleton ioctl
+*/
+static long sep_singleton_ioctl(/*struct inode *inode,*/
+                                                       struct file  *filp,
+                                                       u32    cmd,
+                                                       unsigned long   arg=
)
+{
+
+  /* error */
+  long             error;
+
+  /*------------------------
+    CODE
+  ------------------------*/
+  error =3D 0;
+
+  dbg("SEP Driver:--------> sep_singleton_ioctl start\n");
+
+  edbg("SEP Driver: cmd is %x\n", cmd);
+
+  /* check that the command is for sep device */
+       if (_IOC_TYPE(cmd) !=3D SEP_IOC_MAGIC_NUMBER) {
+               error =3D  -ENOTTY;
+               goto end_function;
+  }
+
+  switch (cmd) {
+  case SEP_IOCTLSETCALLERID:
+    error =3D sep_set_caller_id_handler(arg);
+    break;
+
+  default:
+    error =3D sep_ioctl(filp, cmd, arg);
+    break;
+  }
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_singleton_ioctl end\n");
+
+  return error;
+}
+
+/* file operation for singleton sep operations */
+static const struct file_operations singleton_file_operations =3D {
+       .owner =3D THIS_MODULE,
+       .unlocked_ioctl =3D sep_singleton_ioctl,
+       .poll =3D sep_poll,
+       .open =3D sep_singleton_open,
+       .release =3D sep_release,
+       .mmap =3D sep_mmap,
+};
+
+#endif /*DX_CC52_SUPPORT*/
+
+
+/* file operation for normal sep operations */
+static const struct file_operations sep_file_operarions =3D {
+  .owner =3D THIS_MODULE,
+  .unlocked_ioctl =3D sep_ioctl,
+  .poll =3D sep_poll,
+  .open =3D sep_open,
+  .release =3D sep_release,
+  .mmap =3D sep_mmap,
+
+};
+
+/*
+  this function registers the driver to the file system
+*/
+static int  sep_register_driver_to_fs(void)
+{
+  /* return value */
+  int                  ret_val;
+
+  /* major number */
+  int          major;
+
+  /*---------------------
+       CODE
+  -----------------------*/
+
+#ifdef DX_CC52_SUPPORT
+  ret_val =3D alloc_chrdev_region(&sep_context.device_number,
+                                                       0,
+                                                       2,
+                                                       DRIVER_NAME);
+#else
+  ret_val =3D alloc_chrdev_region(&sep_context.device_number,
+                                                       0,
+                                                       1,
+                                                       DRIVER_NAME);
+#endif
+       if (ret_val) {
+               edbg("sep_driver:major number allocation failed,\
+                       retval is %d\n",
+                       ret_val);
+         goto end_function;
+  }
+
+  /* get the major number */
+  major =3D MAJOR(sep_context.device_number);
+
+  /* init cdev */
+  cdev_init(&sep_context.cdev, &sep_file_operarions);
+  sep_context.cdev.owner =3D THIS_MODULE;
+
+  /* register the driver with the kernel */
+  ret_val =3D cdev_add(&sep_context.cdev, sep_context.device_number, 1);
+
+       if (ret_val) {
+               edbg("sep_driver:cdev_add failed, retval is %d\n",
+      ret_val);
+         goto end_function_unregister_devnum;
+  }
+
+goto end_function;
+#ifdef DX_CC52_SUPPORT
+
+  sep_context.singleton_device_number =3D MKDEV(major, 1);
+
+  /* init singleton cdev */
+  cdev_init(&sep_context.singleton_cdev , &singleton_file_operations);
+  sep_context.singleton_cdev.owner =3D THIS_MODULE;
+
+  /* register the driver with the kernel fs */
+  ret_val =3D cdev_add(&sep_context.singleton_cdev ,
+                               sep_context.singleton_device_number ,
+                               1);
+       if (ret_val) {
+               edbg("sep_driver:cdev_add 2 failed, retval is %d\n" ,
+      ret_val);
+    goto end_function_unregister_first_dev;
+  }
+
+  goto end_function;
+
+end_function_unregister_first_dev:
+
+  /* delete the first device */
+  cdev_del(&sep_context.cdev);
+
+#endif
+
+end_function_unregister_devnum:
+
+#ifdef DX_CC52_SUPPORT
+  /* unregister dev numbers */
+  unregister_chrdev_region(sep_context.device_number, 2);
+#else
+  unregister_chrdev_region(sep_context.device_number, 1);
+#endif
+
+end_function:
+
+  return ret_val;
+}
+
+/*
+  this function unregisters driver from fs
+*/
+static void sep_unregister_driver_from_fs(void)
+{
+  /*-------------------
+       CODE
+  ---------------------*/
+
+  cdev_del(&sep_context.cdev);
+
+#ifdef DX_CC52_SUPPORT
+  cdev_del(&sep_context.singleton_cdev);
+
+  /* unregister dev numbers */
+  unregister_chrdev_region(sep_context.device_number, 2);
+#else
+  unregister_chrdev_region(sep_context.device_number, 1);
+#endif
+
+}
+
+/*
+  reconfig the shared area between HOST and SEP - needed in case
+  the DX_CC_Init function was called before OS loading
+*/
+static int sep_reconfig_shared_area(void)
+{
+  int ret_val;
+
+  /*----------------------
+      CODE
+  --------------------------*/
+
+  ret_val =3D 0;
+
+#if SEP_DRIVER_RECONFIG_MESSAGE_AREA
+
+  /* send the new SHARED MESSAGE AREA to the SEP */
+  SEP_WRITE_REGISTER(&sep_context, HW_HOST_HOST_SEP_GPR1_REG_ADDR ,
+                                       sep_context.phys_shared_area_addr);
+
+  /* poll for SEP response */
+  ret_val =3D SEP_READ_REGISTER(&sep_context,
+                                       HW_HOST_SEP_HOST_GPR1_REG_ADDR);
+       while (ret_val !=3D 0xffffffff &&
+                       ret_val !=3D sep_context.phys_shared_area_addr) {
+               ret_val =3D SEP_READ_REGISTER(&sep_context,
+                       HW_HOST_SEP_HOST_GPR1_REG_ADDR);
+  }
+
+  /* check the return value (register) */
+  if (ret_val !=3D sep_context.phys_shared_area_addr)
+               ret_val =3D -ENOMEM;
+
+
+#endif
+
+  return ret_val;
+}
+
+static void sep_init_context(void)
+{
+  /*-------------
+      CODE
+  ----------------*/
+
+  /* zero fields */
+  sep_context.num_lli_tables_created =3D 0;
+  sep_context.in_page_array =3D 0;
+  sep_context.out_page_array =3D 0;
+  sep_context.in_num_pages =3D 0;
+  sep_context.out_num_pages =3D 0;
+  sep_context.in_map_array =3D 0;
+  sep_context.out_map_array =3D 0;
+  sep_context.in_map_num_entries =3D 0;
+  sep_context.out_map_num_entries =3D 0;
+  sep_context.shared_area_dma_addr =3D 0;
+
+
+  /* init ioctl mutex */
+  mutex_init(&sep_context.ioctl_mutex);
+
+  /* calculate the shared_area_size */
+  sep_context.shared_area_size =3D
+    SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;
+}
+
+
+/*--------------------------------------------------------------
+  init function
+----------------------------------------------------------------*/
+static int __init sep_init(void)
+{
+  /* return value */
+  int                  ret_val;
+
+  /*------------------------
+       CODE
+  ------------------------*/
+
+  dbg("SEP Driver:-------->Init start\n");
+
+  ret_val =3D 0;
+
+  ret_val =3D sep_register_driver_to_device();
+       if (ret_val) {
+               edbg("sep_driver:sep_driver_to_device failed, ret_val is %d=
\n",
+      ret_val);
+    goto end_function_unregister_from_fs;
+  }
+
+  /* initialize the context fields */
+  sep_init_context();
+
+  /* allocate the shared area */
+       if (sep_map_and_alloc_shared_area(&sep_context)) {
+               ret_val =3D -ENOMEM;
+               /* allocation failed */
+               goto end_function;
+  }
+
+  /* initialize wait queue */
+  init_waitqueue_head(&sep_context.event);
+
+#ifdef DX_CC52_SUPPORT
+  /* init the caller id */
+  ret_val =3D sep_init_caller_id();
+       if (ret_val)
+               goto end_function_deallocate_sep_shared_area;
+
+#endif
+
+  /* reconfig the shared area - needed in case that OS
+       was initialized after the DX_CC_Init */
+  ret_val =3D sep_reconfig_shared_area();
+       if (ret_val)
+               goto end_function_unregister_from_fs;
+
+  /* register driver to fs */
+  ret_val =3D sep_register_driver_to_fs();
+       if (ret_val)
+               goto end_function_deallocate_sep_shared_area;
+
+  goto end_function;
+
+end_function_unregister_from_fs:
+
+  /* unregister from fs */
+  sep_unregister_driver_from_fs();
+
+end_function_deallocate_sep_shared_area:
+
+  /* de-allocate shared area */
+  sep_unmap_and_free_shared_area(&sep_context);
+
+end_function:
+
+  dbg("SEP Driver:<-------- Init end\n");
+
+  return ret_val;
+}
+
+
+
+
+/*-------------------------------------------------------------
+  exit function
+--------------------------------------------------------------*/
+static void __exit sep_exit(void)
+{
+  /* size */
+  int                  size;
+
+  /*-----------------------------
+       CODE
+  --------------------------------*/
+
+  dbg("SEP Driver:--------> Exit start\n");
+
+  /* unregister from fs */
+  sep_unregister_driver_from_fs();
+
+  /* calculate the total size for de-allocation */
+  size =3D SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
+               SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;
+
+
+  /* free shared area  */
+  sep_unmap_and_free_shared_area(&sep_context);
+
+  iounmap(sep_context.rar_virtual_address);
+  iounmap((void *)sep_context.reg_addr);
+
+  sep_context.rar_virtual_address =3D NULL;
+  sep_context.reg_addr =3D NULL;
+
+  dbg("SEP Driver:<-------- Exit end\n");
+}
+
+
+/*
+  interrupt handler function
+*/
+irqreturn_t sep_inthandler(int irq, void *dev_id)
+{
+  /* int error */
+  irqreturn_t          int_error;
+
+  /* reg value */
+  u32          reg_val;
+
+  /*-----------------------------
+       CODE
+  -----------------------------*/
+
+  int_error =3D IRQ_HANDLED;
+
+  /* read the IRR register to check if this is SEP interrupt */
+  reg_val =3D SEP_READ_REGISTER(&sep_context, HW_HOST_IRR_REG_ADDR);
+  edbg("SEP Interrupt - reg is %08x\n", reg_val);
+
+
+  /* check if this is reply interrupt from SEP */
+       if (reg_val & (0x1 << 13)) {
+               /* update the counter of reply messages */
+               sep_context.sep_to_host_reply_counter++;
+
+               /* wake up the waiting process */
+               wake_up(&sep_context.event);
+       } else {
+               int_error =3D IRQ_NONE;
+               goto end_function;
+  }
+
+  /* clear the interrupt */
+  SEP_WRITE_REGISTER(&sep_context, HW_HOST_ICR_REG_ADDR, reg_val);
+
+end_function:
+
+  return int_error;
+}
+
+/*
+  this function calculates the size of data that can be inserted into the =
lli
+  table from this array the condition is that either the table is full
+  (all etnries are entered), or there are no more entries in the lli array
+*/
+u32 sep_calculate_lli_table_max_size(
+                       struct sep_lli_entry_t  *lli_in_array_ptr,
+                       u32     num_array_entries)
+{
+  /* table data size */
+  u32 table_data_size;
+
+  /* counter */
+  u32 counter;
+
+  /*---------------------
+       CODE
+  ----------------------*/
+
+  table_data_size =3D 0;
+
+  /* calculate the data in the out lli table if till we fill the whole
+  table or till the data has ended */
+  for (counter =3D 0;
+       (counter < (SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP - 1)) &&
+       (counter < num_array_entries); counter++)
+       table_data_size +=3D lli_in_array_ptr[counter].block_size;
+
+  return table_data_size;
+}
+
+/*
+  this functions builds ont lli table from the lli_array according to
+  the given size of data
+*/
+static void sep_build_lli_table(struct sep_lli_entry_t *lli_array_ptr,
+                               struct sep_lli_entry_t  *lli_table_ptr,
+                               u32     *num_processed_entries_ptr,
+                               u32     *num_table_entries_ptr,
+                               u32     table_data_size)
+{
+  /* current table data size */
+  u32 curr_table_data_size;
+
+  /* counter of lli array entry */
+  u32 array_counter;
+
+  /*-----------------------
+       CODE
+  ---------------------------*/
+
+  dbg("SEP Driver:--------> sep_build_lli_table start\n");
+
+  /* init currrent table data size and lli array entry counter */
+  curr_table_data_size =3D 0;
+  array_counter =3D 0;
+  *num_table_entries_ptr =3D 1;
+
+  edbg("SEP Driver:table_data_size is %x\n", table_data_size);
+
+  /* fill the table till table size reaches the needed amount */
+  while (curr_table_data_size < table_data_size) {
+       /* update the number of entries in table */
+       (*num_table_entries_ptr)++;
+
+       lli_table_ptr->bus_address =3D
+  SEP_CHANGE_ENDIANNESS(lli_array_ptr[array_counter].bus_address);
+
+       lli_table_ptr->block_size =3D
+       SEP_CHANGE_ENDIANNESS(lli_array_ptr[array_counter].block_size);
+
+       curr_table_data_size +=3D lli_array_ptr[array_counter].block_size;
+
+       edbg("SEP Driver:lli_table_ptr is %08x\n", (u32)lli_table_ptr);
+       edbg("SEP Driver:lli_table_ptr->bus_address is %08x\n",
+      lli_table_ptr->bus_address);
+       edbg("SEP Driver:lli_table_ptr->block_size is %x\n",
+      lli_table_ptr->block_size);
+
+       /* check for overflow of the table data */
+       if (curr_table_data_size > table_data_size) {
+               edbg("SEP Driver:curr_table_data_size > table_data_size\n")=
;
+
+               /* update the size of block in the table */
+               lli_table_ptr->block_size -=3D
+               SEP_CHANGE_ENDIANNESS((curr_table_data_size - table_data_si=
ze));
+
+               /* update the physical address in the lli array */
+               lli_array_ptr[array_counter].bus_address +=3D
+                       SEP_CHANGE_ENDIANNESS(lli_table_ptr->block_size);
+
+               /* update the block size left in the lli array */
+               lli_array_ptr[array_counter].block_size =3D
+                       (curr_table_data_size - table_data_size);
+       } else
+               /* advance to the next entry in the lli_array */
+               array_counter++;
+
+               edbg("SEP Driver:lli_table_ptr->bus_address is %08x\n",
+                       lli_table_ptr->bus_address);
+               edbg("SEP Driver:lli_table_ptr->block_size is %x\n",
+                       lli_table_ptr->block_size);
+
+               /* move to the next entry in table */
+               lli_table_ptr++;
+  }
+
+  /* set the info entry to default */
+  lli_table_ptr->bus_address =3D 0xffffffff;
+  lli_table_ptr->block_size =3D 0;
+
+  edbg("SEP Driver:lli_table_ptr is %08x\n", (u32)lli_table_ptr);
+  edbg("SEP Driver:lli_table_ptr->bus_address is %08x\n",
+    lli_table_ptr->bus_address);
+  edbg("SEP Driver:lli_table_ptr->block_size is %x\n",
+    lli_table_ptr->block_size);
+
+
+  /* set the output parameter */
+  *num_processed_entries_ptr +=3D array_counter;
+
+  edbg("SEP Driver:*num_processed_entries_ptr is %x\n",
+    *num_processed_entries_ptr);
+
+
+  dbg("SEP Driver:<-------- sep_build_lli_table end\n");
+
+  return;
+}
+
+/*
+  this function goes over the list of the print created tables and
+  prints all the data
+*/
+static void sep_debug_print_lli_tables(struct sep_lli_entry_t  *lli_table_=
ptr,
+                                       u32     num_table_entries,
+                                       u32     table_data_size)
+{
+  u32 table_count;
+
+  u32 entries_count;
+  /*-----------------------------
+       CODE
+  -------------------------------*/
+
+  dbg("SEP Driver:--------> sep_debug_print_lli_tables start\n");
+
+  table_count =3D 1;
+       while ((u32)lli_table_ptr !=3D 0xffffffff) {
+               edbg("SEP Driver: lli table %08x, table_data_size is %x\n",
+                       table_count,
+                       table_data_size);
+               edbg("SEP Driver: num_table_entries is %x\n",
+                       num_table_entries);
+
+               /* print entries of the table (without info entry) */
+               for (entries_count =3D 0;
+                       entries_count < num_table_entries;
+                       entries_count++, lli_table_ptr++) {
+
+                       edbg("SEP Driver:lli_table_ptr address is %08x\n",
+                       (u32)lli_table_ptr);
+                       edbg("SEP Driver:phys address is %08x\
+                               block size is %x\n",
+                               lli_table_ptr->bus_address,
+                               lli_table_ptr->block_size);
+               }
+
+               /* point to the info entry */
+               lli_table_ptr--;
+
+               edbg("SEP Driver:phys lli_table_ptr->block_size is %x\n",
+                       lli_table_ptr->block_size);
+               edbg("SEP Driver:phys lli_table_ptr->physical_address\
+                       is %08x\n",
+                       lli_table_ptr->bus_address);
+
+
+               table_data_size =3D
+               SEP_CHANGE_ENDIANNESS(lli_table_ptr->block_size) & 0xffffff=
;
+
+               num_table_entries =3D
+               (SEP_CHANGE_ENDIANNESS(lli_table_ptr->block_size) >> 24) & =
0xff;
+
+               lli_table_ptr =3D (struct sep_lli_entry_t *)
+               (SEP_CHANGE_ENDIANNESS(lli_table_ptr->bus_address));
+
+               edbg("SEP Driver:phys table_data_size is %x\
+                       num_table_entries is %x lli_table_ptr is%x\n",
+               table_data_size, num_table_entries, (u32)lli_table_ptr);
+
+               if ((u32)lli_table_ptr !=3D 0xffffffff)
+                       lli_table_ptr =3D (struct sep_lli_entry_t *)
+                               sep_shared_area_bus_to_virt(&sep_context,
+                                       (u32)lli_table_ptr);
+                       table_count++;
+       }
+
+       dbg("SEP Driver:<-------- sep_debug_print_lli_tables end\n");
+}
+
+
+static void sep_prepare_empty_lli_table(dma_addr_t *lli_table_addr_ptr,
+      u32      *num_entries_ptr,
+      u32      *table_data_size_ptr)
+{
+  /* lli table pointer */
+  struct sep_lli_entry_t               *lli_table_ptr;
+
+  /*---------------------
+      CODE
+  ------------------------*/
+
+       /* find the area for new table */
+       lli_table_ptr =3D
+         (struct sep_lli_entry_t *)(sep_context.shared_area_virt_addr +
+    SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES +
+    sep_context.num_lli_tables_created *
+    sizeof(struct sep_lli_entry_t) * SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
+
+       lli_table_ptr->bus_address =3D 0;
+       lli_table_ptr->block_size =3D 0;
+
+       lli_table_ptr++;
+       lli_table_ptr->bus_address =3D 0xFFFFFFFF;
+       lli_table_ptr->block_size =3D 0;
+
+       /* set the output parameter value */
+       *lli_table_addr_ptr =3D sep_context.shared_area_bus_addr +
+                       SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYT=
ES +
+                       sep_context.num_lli_tables_created *
+                       sizeof(struct sep_lli_entry_t) *
+                       SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+       /* set the num of entries and table data size for empty table */
+       *num_entries_ptr =3D 2;
+       *table_data_size_ptr =3D 0;
+
+       /* update the number of created tables */
+       sep_context.num_lli_tables_created++;
+
+}
+
+/*
+ This function creates the input and output dma tables for
+ symmetric operations (AES/DES) according to the block size from LLI arays
+*/
+static int sep_construct_dma_tables_from_lli(
+      struct sep_lli_entry_t   *lli_in_array,
+      u32      sep_in_lli_entries,
+      struct sep_lli_entry_t   *lli_out_array,
+      u32      sep_out_lli_entries,
+      u32      block_size,
+      dma_addr_t       *lli_table_in_ptr,
+      dma_addr_t       *lli_table_out_ptr,
+      u32      *in_num_entries_ptr,
+      u32      *out_num_entries_ptr,
+      u32      *table_data_size_ptr)
+{
+  /* points to the area where next lli table can be allocated */
+  u32  lli_table_alloc_addr;
+
+  /* input lli table */
+  struct sep_lli_entry_t               *in_lli_table_ptr;
+
+  /* output lli table */
+  struct sep_lli_entry_t               *out_lli_table_ptr;
+
+  /* pointer to the info entry of the table - the last entry */
+  struct sep_lli_entry_t               *info_in_entry_ptr;
+
+  /* pointer to the info entry of the table - the last entry */
+  struct sep_lli_entry_t               *info_out_entry_ptr;
+
+  /* points to the first entry to be processed in the lli_in_array */
+  u32  current_in_entry;
+
+  /* points to the first entry to be processed in the lli_out_array */
+  u32  current_out_entry;
+
+  /* max size of the input table */
+  u32  in_table_data_size;
+
+  /* max size of the output table */
+  u32  out_table_data_size;
+
+  /* flag te signifies if this is the first tables build from the arrays *=
/
+  u32    first_table_flag;
+
+  /* the data size that should be in table */
+  u32  table_data_size;
+
+  /* number of etnries in the input table */
+  u32  num_entries_in_table;
+
+  /* number of etnries in the output table */
+  u32  num_entries_out_table;
+
+  /*---------------------
+       CODE
+  ------------------------*/
+
+  dbg("SEP Driver:--------> sep_construct_dma_tables_from_lli start\n");
+
+  /* initiate to point after the message area */
+  lli_table_alloc_addr =3D (u32)(sep_context.shared_area_virt_addr +
+  SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYTES +
+  (sep_context.num_lli_tables_created *
+  (sizeof(struct sep_lli_entry_t) * SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP)))=
;
+
+  current_in_entry =3D 0;
+  current_out_entry =3D 0;
+  first_table_flag =3D 1;
+  info_in_entry_ptr =3D 0;
+  info_out_entry_ptr =3D 0;
+
+  /* loop till all the entries in in array are not processed */
+  while (current_in_entry < sep_in_lli_entries) {
+       /* set the new input and output tables */
+       in_lli_table_ptr =3D (struct sep_lli_entry_t *)lli_table_alloc_addr=
;
+
+       lli_table_alloc_addr +=3D sizeof(struct sep_lli_entry_t) *
+                       SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+       /* set the first output tables */
+       out_lli_table_ptr =3D (struct sep_lli_entry_t *)lli_table_alloc_add=
r;
+
+       /* update the number of the lli tables created */
+       sep_context.num_lli_tables_created +=3D 2;
+
+       lli_table_alloc_addr +=3D sizeof(struct sep_lli_entry_t) *
+                               SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+       /* calculate the maximum size of data for input table */
+       in_table_data_size =3D
+                       sep_calculate_lli_table_max_size(
+                       &lli_in_array[current_in_entry],
+                       (sep_in_lli_entries - current_in_entry));
+
+       /* calculate the maximum size of data for output table */
+       out_table_data_size =3D
+                       sep_calculate_lli_table_max_size(
+                       &lli_out_array[current_out_entry],
+                       (sep_out_lli_entries - current_out_entry));
+
+       edbg("SEP Driver:in_table_data_size is %x\n", in_table_data_size);
+       edbg("SEP Driver:out_table_data_size is %x\n", out_table_data_size)=
;
+
+       /* check where the data is smallest */
+       table_data_size =3D in_table_data_size;
+       if (table_data_size > out_table_data_size)
+               table_data_size =3D out_table_data_size;
+
+       /* now calculate the table size so that it will be module block siz=
e */
+       table_data_size =3D (table_data_size / block_size) * block_size;
+
+       edbg("SEP Driver:table_data_size is %x\n", table_data_size);
+
+       /* construct input lli table */
+       sep_build_lli_table(&lli_in_array[current_in_entry],
+                                               in_lli_table_ptr,
+                                               &current_in_entry,
+                                               &num_entries_in_table,
+                                               table_data_size);
+
+       /* construct output lli table */
+       sep_build_lli_table(&lli_out_array[current_out_entry],
+                                               out_lli_table_ptr,
+                                               &current_out_entry,
+                                               &num_entries_out_table,
+                                               table_data_size);
+
+       /* if info entry is null - this is the first table built */
+       if (info_in_entry_ptr =3D=3D 0) {
+               /* set the output parameters to physical addresses */
+               *lli_table_in_ptr =3D
+               sep_shared_area_virt_to_bus(&sep_context, in_lli_table_ptr)=
;
+
+               *in_num_entries_ptr =3D num_entries_in_table;
+
+               *lli_table_out_ptr =3D
+               sep_shared_area_virt_to_bus(&sep_context , out_lli_table_pt=
r);
+
+               *out_num_entries_ptr =3D num_entries_out_table;
+               *table_data_size_ptr =3D table_data_size;
+
+               edbg("SEP Driver:output lli_table_in_ptr is %08x\n",
+                       (u32)*lli_table_in_ptr);
+               edbg("SEP Driver:output lli_table_out_ptr is %08x\n",
+                       (u32)*lli_table_out_ptr);
+       } else {
+               /* update the info entry of the previous in table */
+               info_in_entry_ptr->bus_address =3D
+                       sep_shared_area_virt_to_bus(&sep_context,
+                               in_lli_table_ptr);
+               info_in_entry_ptr->block_size =3D
+                       ((num_entries_in_table) << 24) | (table_data_size);
+
+               /* update the info entry of the previous in table */
+               info_out_entry_ptr->bus_address =3D
+                       sep_shared_area_virt_to_bus(&sep_context,
+                               out_lli_table_ptr);
+               info_out_entry_ptr->block_size =3D
+                       ((num_entries_out_table) << 24) | (table_data_size)=
;
+       }
+
+       /* save the pointer to the info entry of the current tables */
+       info_in_entry_ptr =3D in_lli_table_ptr + num_entries_in_table - 1;
+       info_out_entry_ptr =3D out_lli_table_ptr + num_entries_out_table - =
1;
+
+       edbg("SEP Driver:output num_entries_out_table is %x\n",
+               (u32)num_entries_out_table);
+       edbg("SEP Driver:output info_in_entry_ptr is %x\n",
+               (u32)info_in_entry_ptr);
+       edbg("SEP Driver:output info_out_entry_ptr is %x\n",
+               (u32)info_out_entry_ptr);
+  }
+
+  /* print input tables */
+  sep_debug_print_lli_tables(
+       (struct sep_lli_entry_t *)
+       sep_shared_area_bus_to_virt(&sep_context , *lli_table_in_ptr),
+       *in_num_entries_ptr,
+       *table_data_size_ptr);
+
+  /* print output tables */
+  sep_debug_print_lli_tables(
+       (struct sep_lli_entry_t *)
+       sep_shared_area_bus_to_virt(&sep_context , *lli_table_out_ptr),
+       *out_num_entries_ptr,
+       *table_data_size_ptr);
+
+  dbg("SEP Driver:<-------- sep_construct_dma_tables_from_lli end\n");
+
+  return 0;
+}
+
+
+/*
+  This function locks all the physical pages of the kernel virtual buffer
+  and construct a basic lli  array, where each entry holds the physical
+  page address and the size that application data holds in this physical p=
ages
+*/
+int sep_lock_kernel_pages(u32          kernel_virt_addr,
+                       u32             data_size,
+                       struct sep_lli_entry_t          **lli_array_ptr,
+                       int in_out_flag)
+
+{
+  /* error */
+  int                          error;
+
+  /* array of lli */
+  struct sep_lli_entry_t               *lli_array;
+
+  /* map array */
+  struct sep_dma_map  *map_array;
+
+
+  /*------------------------
+       CODE
+  --------------------------*/
+
+  dbg("SEP Driver:--------> sep_lock_kernel_pages start\n");
+
+  error =3D 0;
+
+  edbg("SEP Driver: kernel_virt_addr is %08x\n", kernel_virt_addr);
+  edbg("SEP Driver: data_size is %x\n", data_size);
+
+  lli_array =3D kmalloc(sizeof(struct sep_lli_entry_t) * 1, GFP_ATOMIC);
+       if (!lli_array) {
+               edbg("SEP Driver: kmalloc for lli_array failed\n");
+
+               error =3D -ENOMEM;
+               goto end_function;
+  }
+
+  map_array =3D kmalloc(sizeof(struct sep_dma_map) * 1 , GFP_ATOMIC);
+       if (!map_array) {
+               edbg("SEP Driver: kmalloc for map_array failed\n");
+               error =3D -ENOMEM;
+               goto end_function_with_error;
+  }
+
+  map_array[0].dma_addr =3D
+      dma_map_single(sep_context.dev_ptr ,
+      (void *)kernel_virt_addr,
+      data_size,
+      DMA_BIDIRECTIONAL);
+  map_array[0].size =3D data_size;
+
+
+  /* set the start address of the first page - app data may start not at
+  the beginning of the page */
+  lli_array[0].bus_address =3D (u32)map_array[0].dma_addr;
+       lli_array[0].block_size =3D map_array[0].size;
+
+  /* debug print */
+  edbg("lli_array[0].bus_address is %08x, \
+      lli_array[0].block_size is %x\n",
+    lli_array[0].bus_address,
+    lli_array[0].block_size);
+
+  /* set the output parameters */
+       if (in_out_flag =3D=3D SEP_DRIVER_IN_FLAG) {
+               *lli_array_ptr =3D lli_array;
+               sep_context.in_num_pages =3D 1;
+               sep_context.in_page_array =3D 0;
+               sep_context.in_map_array =3D map_array;
+               sep_context.in_map_num_entries =3D 1;
+       } else {
+               *lli_array_ptr =3D lli_array;
+               sep_context.out_num_pages =3D 1;
+               sep_context.out_page_array =3D 0;
+               sep_context.out_map_array =3D map_array;
+               sep_context.out_map_num_entries =3D 1;
+  }
+
+  goto end_function;
+
+end_function_with_error:
+
+  kfree(lli_array);
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_lock_kernel_pages end\n");
+
+  return 0;
+}
+
+/*
+  This function locks all the physical pages of the application virtual bu=
ffer
+  and construct a basic lli  array, where each entry holds the physical pa=
ge
+  address and the size that application data holds in this physical pages
+*/
+int sep_lock_user_pages(u32            app_virt_addr,
+                       u32             data_size,
+                       struct sep_lli_entry_t          **lli_array_ptr,
+                       int in_out_flag)
+
+{
+  /* error */
+  int                          error;
+
+  /* the the page of the end address of the user space buffer */
+  u32          end_page;
+
+  /* the page of the start address of the user space buffer */
+  u32          start_page;
+
+  /* the range in pages */
+  u32          num_pages;
+
+  /* array of pointers ot page */
+  struct page          **page_array;
+
+  /* array of lli */
+  struct sep_lli_entry_t               *lli_array;
+
+  /* map array */
+  struct sep_dma_map  *map_array;
+
+  /* count */
+  u32          count;
+
+  /* result */
+  int                          result;
+
+  /*------------------------
+       CODE
+  --------------------------*/
+
+  dbg("SEP Driver:--------> sep_lock_user_pages start\n");
+
+  error =3D 0;
+
+  /* set start and end pages  and num pages */
+  end_page =3D (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
+  start_page =3D app_virt_addr >> PAGE_SHIFT;
+  num_pages =3D end_page - start_page + 1;
+
+  edbg("SEP Driver: app_virt_addr is %08x\n", app_virt_addr);
+  edbg("SEP Driver: data_size is %x\n", data_size);
+  edbg("SEP Driver: start_page is %x\n", start_page);
+  edbg("SEP Driver: end_page is %x\n", end_page);
+  edbg("SEP Driver: num_pages is %x\n", num_pages);
+
+  edbg("SEP Driver: starting page_array malloc\n");
+
+  /* allocate array of pages structure pointers */
+  page_array =3D kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
+       if (!page_array) {
+               edbg("SEP Driver: kmalloc for page_array failed\n");
+
+               error =3D -ENOMEM;
+               goto end_function;
+  }
+
+       map_array =3D kmalloc(sizeof(struct sep_dma_map) * num_pages, GFP_A=
TOMIC);
+       if (!map_array) {
+               edbg("SEP Driver: kmalloc for map_array failed\n");
+               error =3D -ENOMEM;
+               goto end_function_with_error1;
+  }
+
+       lli_array =3D kmalloc(sizeof(struct sep_lli_entry_t) * num_pages,
+                               GFP_ATOMIC);
+       if (!lli_array) {
+               edbg("SEP Driver: kmalloc for lli_array failed\n");
+
+               error =3D -ENOMEM;
+               goto end_function_with_error2;
+  }
+
+       edbg("SEP Driver: starting get_user_pages\n");
+
+       /* convert the application virtual address into a set of physical *=
/
+       down_read(&current->mm->mmap_sem);
+       result =3D get_user_pages(current,
+                                               current->mm,
+                                               app_virt_addr,
+                                               num_pages,
+                                               1,
+                                               0,
+                                               page_array,
+                                               0);
+  up_read(&current->mm->mmap_sem);
+
+  /* check the number of pages locked - if not all then exit with error */
+       if (result !=3D num_pages) {
+               edbg("SEP Driver: not all pages locked by get_user_pages\n"=
);
+
+               error =3D -ENOMEM;
+               goto end_function_with_error3;
+  }
+
+  edbg("SEP Driver: get_user_pages succeeded\n");
+
+  /* fill the array using page array data and map the pages - this action
+      will also flush the cache as needed */
+       for (count =3D 0; count < num_pages; count++) {
+               /* fill the map array */
+               map_array[count].dma_addr =3D
+                       dma_map_page(sep_context.dev_ptr, page_array[count]=
,
+                       0,
+                       PAGE_SIZE,
+                       DMA_BIDIRECTIONAL);
+               map_array[count].size =3D PAGE_SIZE;
+
+               /* fill the lli array entry */
+               lli_array[count].bus_address =3D (u32)map_array[count].dma_=
addr;
+               lli_array[count].block_size =3D PAGE_SIZE;
+
+               edbg("lli_array[%x].bus_address is %08x, \
+                       lli_array[%x].block_size is %x\n",
+                       count, lli_array[count].bus_address,
+                       count,
+                       lli_array[count].block_size);
+  }
+
+  /* check the offset for the first page -
+      data may start not at the beginning of the page */
+  lli_array[0].bus_address =3D
+      lli_array[0].bus_address + (app_virt_addr & (~PAGE_MASK));
+  /* check that not all the data is in the first page only */
+       if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >=3D data_size)
+               lli_array[0].block_size =3D data_size;
+       else
+               lli_array[0].block_size =3D
+                       PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
+
+  edbg("lli_array[0].bus_address is %08x, \
+    lli_array[0].block_size is %x\n",
+    lli_array[count].bus_address,
+    lli_array[count].block_size);
+
+  /* check the size of the last page */
+       if (num_pages > 1) {
+               lli_array[num_pages - 1].block_size =3D
+                       (app_virt_addr + data_size) & (~PAGE_MASK);
+               edbg("lli_array[%x].bus_address is %08x, \
+                       lli_array[%x].block_size is %x\n",
+                       num_pages - 1, lli_array[count].bus_address,
+                       num_pages - 1,
+                       lli_array[count].block_size);
+  }
+
+  /* set output params acording to the in_out flag */
+       if (in_out_flag =3D=3D SEP_DRIVER_IN_FLAG) {
+               *lli_array_ptr =3D lli_array;
+               sep_context.in_num_pages =3D num_pages;
+               sep_context.in_page_array =3D page_array;
+               sep_context.in_map_array =3D map_array;
+               sep_context.in_map_num_entries =3D num_pages;
+       } else {
+               *lli_array_ptr =3D lli_array;
+               sep_context.out_num_pages =3D num_pages;
+               sep_context.out_page_array =3D page_array;
+               sep_context.out_map_array =3D map_array;
+               sep_context.out_map_num_entries =3D num_pages;
+  }
+
+  goto end_function;
+
+end_function_with_error3:
+
+  /* free lli array */
+  kfree(lli_array);
+
+end_function_with_error2:
+
+  kfree(map_array);
+
+end_function_with_error1:
+
+  /* free page array */
+  kfree(page_array);
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_lock_user_pages end\n");
+
+  return 0;
+}
+
+/*
+  This function prepares only input DMA table for synhronic symmetric
+  operations (HASH)
+*/
+int sep_prepare_input_dma_table(unsigned long  app_virt_addr,
+                               u32     data_size,
+                               u32     block_size,
+                               dma_addr_t      *lli_table_ptr,
+                               u32     *num_entries_ptr,
+                               u32     *table_data_size_ptr,
+                               bool isKernelVirtualAddress)
+
+{
+  /* pointer to the info entry of the table - the last entry */
+  struct sep_lli_entry_t               *info_entry_ptr;
+
+  /* array of pointers ot page */
+  struct sep_lli_entry_t               *lli_array_ptr;
+
+  /* points to the first entry to be processed in the lli_in_array */
+  u32          current_entry;
+
+  /* num entries in the virtual buffer */
+  u32          sep_lli_entries;
+
+  /* lli table pointer */
+  struct sep_lli_entry_t               *in_lli_table_ptr;
+
+  /* the total data in one table */
+  u32          table_data_size;
+
+  /* number of entries in lli table */
+  u32          num_entries_in_table;
+
+  /* next table address */
+  u32          lli_table_alloc_addr;
+
+  /* result */
+  u32          result;
+
+  /*------------------------
+       CODE
+  --------------------------*/
+
+  dbg("SEP Driver:--------> sep_prepare_input_dma_table start\n");
+
+  edbg("SEP Driver:data_size is %x\n", data_size);
+  edbg("SEP Driver:block_size is %x\n", block_size);
+
+  /* initialize the pages pointers */
+  sep_context.in_page_array =3D 0;
+  sep_context.in_num_pages =3D 0;
+
+  /* set the kernel address for first table to be allocated */
+  lli_table_alloc_addr =3D (u32)(sep_context.shared_area_virt_addr +
+                       SEP_DRIVER_SYNCHRONIC_DMA_TABLES_AREA_OFFSET_IN_BYT=
ES +
+                       sep_context.num_lli_tables_created *
+                       sizeof(struct sep_lli_entry_t) *
+      SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
+
+  if (data_size =3D=3D 0) {
+
+       /* special case  - create meptu table - 2 entries, zero data */
+       sep_prepare_empty_lli_table(lli_table_ptr,
+      num_entries_ptr,
+      table_data_size_ptr);
+
+       goto end_function;
+  }
+
+  /* check if the pages are in Kernel Virtual Address layout */
+  if (isKernelVirtualAddress =3D=3D true)
+       /* lock the pages of the kernel buffer and translate them to pages =
*/
+       result =3D sep_lock_kernel_pages(app_virt_addr,
+                                       data_size,
+                                       &lli_array_ptr,
+                                       SEP_DRIVER_IN_FLAG);
+  else
+       /* lock the pages of the user buffer and translate them to pages */
+       result =3D sep_lock_user_pages(app_virt_addr,
+                               data_size,
+                               &lli_array_ptr,
+                               SEP_DRIVER_IN_FLAG);
+
+  if (result)
+       return result;
+
+  edbg("SEP Driver:output sep_in_num_pages is %x\n",
+    sep_context.in_num_pages);
+
+  current_entry =3D 0;
+  info_entry_ptr =3D 0;
+  sep_lli_entries =3D sep_context.in_num_pages;
+
+  /* loop till all the entries in in array are not processed */
+  while (current_entry < sep_lli_entries) {
+       /* set the new input and output tables */
+       in_lli_table_ptr =3D (struct sep_lli_entry_t *)lli_table_alloc_addr=
;
+
+       lli_table_alloc_addr +=3D sizeof(struct sep_lli_entry_t) *
+                               SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
+
+       /* update the number of created tables */
+       sep_context.num_lli_tables_created++;
+
+       /* calculate the maximum size of data for input table */
+       table_data_size =3D sep_calculate_lli_table_max_size(
+               &lli_array_ptr[current_entry],
+               (sep_lli_entries - current_entry));
+
+       /* now calculate the table size so that it will be module block siz=
e */
+       table_data_size =3D (table_data_size / block_size) * block_size;
+
+       edbg("SEP Driver:output table_data_size is %x\n", table_data_size);
+
+       /* construct input lli table */
+       sep_build_lli_table(&lli_array_ptr[current_entry],
+                                               in_lli_table_ptr,
+                                               &current_entry,
+                                               &num_entries_in_table,
+                                               table_data_size);
+
+       if (info_entry_ptr =3D=3D 0) {
+               /* set the output parameters to physical addresses */
+               *lli_table_ptr =3D sep_shared_area_virt_to_bus(&sep_context=
,
+                       in_lli_table_ptr);
+               *num_entries_ptr =3D num_entries_in_table;
+               *table_data_size_ptr =3D table_data_size;
+
+       edbg("SEP Driver:output lli_table_in_ptr is %08x\n",
+               (u32)*lli_table_ptr);
+       } else {
+         /* update the info entry of the previous in table */
+    info_entry_ptr->bus_address =3D sep_shared_area_virt_to_bus(&sep_conte=
xt,
+                               in_lli_table_ptr);
+    info_entry_ptr->block_size =3D ((num_entries_in_table) << 24) |
+                               (table_data_size);
+       }
+
+       /* save the pointer to the info entry of the current tables */
+       info_entry_ptr =3D in_lli_table_ptr + num_entries_in_table - 1;
+  }
+
+  /* print input tables */
+  sep_debug_print_lli_tables((struct sep_lli_entry_t *)
+    sep_shared_area_bus_to_virt(&sep_context, *lli_table_ptr),
+    *num_entries_ptr,
+    *table_data_size_ptr);
+
+  /* the array of the pages */
+  kfree(lli_array_ptr);
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_prepare_input_dma_table end\n");
+
+  return 0;
+
+}
+
+/*
+  This function builds input and output DMA tables for synhronic
+  symmetric operations (AES, DES, HASH). It also checks that each table
+  is of the modular block size
+*/
+int sep_prepare_input_output_dma_table(unsigned long app_virt_in_addr,
+                                       unsigned long   app_virt_out_addr,
+                                       u32     data_size,
+                                       u32     block_size,
+                                       dma_addr_t      *lli_table_in_ptr,
+                                       dma_addr_t      *lli_table_out_ptr,
+                                       u32     *in_num_entries_ptr,
+                                       u32     *out_num_entries_ptr,
+                                       u32     *table_data_size_ptr,
+                                       bool    isKernelVirtualAddress)
+
+{
+  /* array of pointers of page */
+  struct sep_lli_entry_t               *lli_in_array;
+
+  /* array of pointers of page */
+  struct sep_lli_entry_t               *lli_out_array;
+
+  /* result */
+  int                          result;
+
+
+  /*------------------------
+       CODE
+  --------------------------*/
+
+  dbg("SEP Driver:--------> sep_prepare_input_output_dma_table start\n");
+
+  result =3D 0;
+
+       if (data_size =3D=3D 0) {
+               /* prepare empty table for input and output */
+               sep_prepare_empty_lli_table(lli_table_in_ptr,
+                       in_num_entries_ptr,
+                       table_data_size_ptr);
+
+
+               sep_prepare_empty_lli_table(lli_table_out_ptr,
+                       out_num_entries_ptr,
+                       table_data_size_ptr);
+
+               goto end_function;
+  }
+
+  /* initialize the pages pointers */
+  sep_context.in_page_array =3D 0;
+  sep_context.out_page_array =3D 0;
+
+  /* check if the pages are in Kernel Virtual Address layout */
+  if (isKernelVirtualAddress =3D=3D true) {
+               /* lock the pages of the kernel buffer and
+               translate them to pages */
+               result =3D sep_lock_kernel_pages(app_virt_in_addr,
+                       data_size,
+                       &lli_in_array,
+                       SEP_DRIVER_IN_FLAG);
+               if (result) {
+                       edbg("SEP Driver: sep_lock_kernel_pages for input \
+                               virtual buffer failed\n");
+                       goto end_function;
+               }
+       } else {
+               /* lock the pages of the user buffer and
+               translate them to pages */
+               result =3D sep_lock_user_pages(app_virt_in_addr,
+                       data_size,
+                       &lli_in_array,
+                       SEP_DRIVER_IN_FLAG);
+               if (result) {
+                       edbg("SEP Driver: sep_lock_user_pages for input vir=
tual\
+                               buffer failed\n");
+                       goto end_function;
+               }
+       }
+
+       if (isKernelVirtualAddress =3D=3D true) {
+               result =3D sep_lock_kernel_pages(app_virt_out_addr,
+                       data_size,
+                       &lli_out_array,
+                       SEP_DRIVER_OUT_FLAG);
+               if (result) {
+                       edbg("SEP Driver: sep_lock_kernel_pages \
+                               for output virtual buffer failed\n");
+                       goto end_function_with_error1;
+               }
+       } else {
+               result =3D sep_lock_user_pages(app_virt_out_addr,
+                       data_size,
+                       &lli_out_array,
+                       SEP_DRIVER_OUT_FLAG);
+               if (result) {
+                       edbg("SEP Driver: sep_lock_user_pages \
+                               for output virtual buffer failed\n");
+                       goto end_function_with_error1;
+               }
+  }
+
+
+  edbg("sep_in_num_pages is %x\n", sep_context.in_num_pages);
+       edbg("sep_out_num_pages is %x\n", sep_context.out_num_pages);
+       edbg("SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
+    SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
+
+
+  /* call the fucntion that creates table from the lli arrays */
+  result =3D sep_construct_dma_tables_from_lli(lli_in_array,
+                                       sep_context.in_num_pages,
+                                       lli_out_array,
+                                       sep_context.out_num_pages,
+                                        block_size,
+                                       lli_table_in_ptr,
+                                       lli_table_out_ptr,
+                                       in_num_entries_ptr,
+                                       out_num_entries_ptr,
+                                       table_data_size_ptr);
+       if (result) {
+               edbg("SEP Driver: sep_construct_dma_tables_from_lli failed\=
n");
+               goto end_function_with_error2;
+  }
+
+  /* fall through - free the lli entry arrays */
+
+  edbg("in_num_entries_ptr is %08x\n", *in_num_entries_ptr);
+  edbg("out_num_entries_ptr is %08x\n", *out_num_entries_ptr);
+  edbg("table_data_size_ptr is %08x\n", *table_data_size_ptr);
+
+
+end_function_with_error2:
+
+  kfree(lli_out_array);
+
+end_function_with_error1:
+
+  kfree(lli_in_array);
+
+end_function:
+
+  dbg("SEP Driver:<-------- sep_prepare_input_output_dma_table\
+    end result =3D %d\n", (int)result);
+
+  return result;
+
+}
+
+
+/* this function frees all preallocated dma resources */
+int sep_free_dma_table_data_handler(void)
+{
+       int count;
+
+  /*-------------------------
+       CODE
+  -----------------------------*/
+
+  dbg("SEP Driver:--------> sep_free_dma_table_data_handler start\n");
+
+  /* free input map array */
+  if (sep_context.in_map_array) {
+               for (count =3D 0; count < sep_context.in_num_pages; count++=
) {
+                       dma_unmap_page(sep_context.dev_ptr ,
+                               sep_context.in_map_array[count].dma_addr,
+                               sep_context.in_map_array[count].size,
+                               DMA_BIDIRECTIONAL);
+               }
+
+               kfree(sep_context.in_map_array);
+  }
+
+  /* free output map array */
+  if (sep_context.out_map_array) {
+               for (count =3D 0; count < sep_context.out_num_pages; count+=
+) {
+                       dma_unmap_page(sep_context.dev_ptr ,
+                               sep_context.out_map_array[count].dma_addr,
+                               sep_context.out_map_array[count].size,
+                               DMA_BIDIRECTIONAL);
+               }
+
+               kfree(sep_context.out_map_array);
+  }
+
+  /* free page cache for output */
+  if (sep_context.in_page_array) {
+               for (count =3D 0; count < sep_context.in_num_pages; count++=
)
+                       page_cache_release(sep_context.in_page_array[count]=
);
+
+               kfree(sep_context.in_page_array);
+
+  }
+
+  if (sep_context.out_page_array) {
+               for (count =3D 0; count < sep_context.out_num_pages; count+=
+) {
+                       if (!PageReserved(sep_context.out_page_array[count]=
))
+                               SetPageDirty(sep_context.out_page_array[cou=
nt]);
+                       page_cache_release(sep_context.out_page_array[count=
]);
+               }
+
+               kfree(sep_context.out_page_array);
+  }
+
+  /* reset all the values */
+  sep_context.in_page_array =3D 0;
+  sep_context.out_page_array =3D 0;
+  sep_context.in_num_pages =3D 0;
+  sep_context.out_num_pages =3D 0;
+       sep_context.num_lli_tables_created =3D 0;
+       sep_context.in_map_array =3D 0;
+  sep_context.out_map_array =3D 0;
+  sep_context.in_map_num_entries =3D 0;
+  sep_context.out_map_num_entries =3D 0;
+
+
+  dbg("SEP Driver:<-------- sep_free_dma_table_data_handler end\n");
+
+  return 0;
+}
+
+module_init(sep_init);
+module_exit(sep_exit);
+
+MODULE_LICENSE("GPL");
--
1.6.0.4

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252AEorsmsx501amrc_
Content-Type: text/x-diff;
	name="0003-staging-sep-update-program-files-for-SEP-December.patch"
Content-Description: 0003-staging-sep-update-program-files-for-SEP-December.patch
Content-Disposition: attachment;
	filename="0003-staging-sep-update-program-files-for-SEP-December.patch";
	size=200175; creation-date="Wed, 28 Apr 2010 14:53:25 GMT";
	modification-date="Wed, 28 Apr 2010 14:53:25 GMT"
Content-ID: <alpine.DEB.2.00.1004281451400.24448@localhost.localdomain>
Content-Transfer-Encoding: base64

RnJvbSAxNGU2YmQwMzkzODdiNTA3ZDY3MTU1Y2Q1ZDdkMGUyYTc4MTY2OTg3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogTWFyayBBbGx5biA8bWFyay5hLmFsbHluQGludGVsLmNvbT4N
CkRhdGU6IFdlZCwgMjggQXByIDIwMTAgMTQ6Mzk6MzAgLTA3MDANClN1YmplY3Q6IFJGQyBbUEFU
Q0ggMy80XSBzdGFnaW5nOiBzZXA6IHVwZGF0ZSBwcm9ncmFtIGZpbGVzIGZvciBTRVAgRGVjZW1i
ZXIgMjAwOSByZWxlYXNlDQoNClNpZ25lZC1vZmYtYnk6IE1hcmsgQS4gQWxseW4gPG1hcmsuYS5h
bGx5bkBpbnRlbC5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvc2VwL3NlcF9kcml2ZXIuYyAg
ICAgICAgICAgICAgfCAyNzE1IC0tLS0tLS0tLS0tLS0tLS0tLS0tDQogZHJpdmVycy9zdGFnaW5n
L3NlcC9zZXBfZXh0X3dpdGhfcGNpX2RyaXZlci5jIHwgIDU0OCArKysrDQogZHJpdmVycy9zdGFn
aW5nL3NlcC9zZXBfbWFpbl9tb2QuYyAgICAgICAgICAgIHwgMzMzMCArKysrKysrKysrKysrKysr
KysrKysrKysrDQogMyBmaWxlcyBjaGFuZ2VkLCAzODc4IGluc2VydGlvbnMoKyksIDI3MTUgZGVs
ZXRpb25zKC0pDQogZGVsZXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvc3RhZ2luZy9zZXAvc2VwX2Ry
aXZlci5jDQogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvc3RhZ2luZy9zZXAvc2VwX2V4dF93
aXRoX3BjaV9kcml2ZXIuYw0KIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL3N0YWdpbmcvc2Vw
L3NlcF9tYWluX21vZC5jDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvc2VwL3NlcF9k
cml2ZXIuYyBiL2RyaXZlcnMvc3RhZ2luZy9zZXAvc2VwX2RyaXZlci5jDQpkZWxldGVkIGZpbGUg
bW9kZSAxMDA2NDQNCmluZGV4IDg4ODgwNzMuLjAwMDAwMDANCi0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy9zZXAvc2VwX2RyaXZlci5jDQorKysgL2Rldi9udWxsDQpAQCAtMSwyNzE1ICswLDAgQEANCi0v
Kg0KLSAqDQotICogIHNlcF9kcml2ZXIuYyAtIFNlY3VyaXR5IFByb2Nlc3NvciBEcml2ZXIgbWFp
biBncm91cCBvZiBmdW5jdGlvbnMNCi0gKg0KLSAqICBDb3B5cmlnaHQoYykgMjAwOSBJbnRlbCBD
b3Jwb3JhdGlvbi4gQWxsIHJpZ2h0cyByZXNlcnZlZC4NCi0gKiAgQ29weXJpZ2h0KGMpIDIwMDkg
RGlzY3JldGl4LiBBbGwgcmlnaHRzIHJlc2VydmVkLg0KLSAqDQotICogIFRoaXMgcHJvZ3JhbSBp
cyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0
DQotICogIHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2Ug
YXMgcHVibGlzaGVkIGJ5IHRoZSBGcmVlDQotICogIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhl
ciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlvbikNCi0gKiAgYW55
IGxhdGVyIHZlcnNpb24uDQotICoNCi0gKiAgVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGlu
IHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsIGJ1dCBXSVRIT1VUDQotICogIEFOWSBX
QVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mIE1FUkNIQU5UQUJJ
TElUWSBvcg0KLSAqICBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUg
R05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yDQotICogIG1vcmUgZGV0YWlscy4NCi0gKg0K
LSAqICBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQ
dWJsaWMgTGljZW5zZSBhbG9uZyB3aXRoDQotICogIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0
ZSB0byB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBJbmMuLCA1OQ0KLSAqICBUZW1wbGUg
UGxhY2UgLSBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgIDAyMTExLTEzMDcsIFVTQS4NCi0gKg0KLSAq
ICBDT05UQUNUUzoNCi0gKg0KLSAqICBNYXJrIEFsbHluCQltYXJrLmEuYWxseW5AaW50ZWwuY29t
DQotICoNCi0gKiAgQ0hBTkdFUzoNCi0gKg0KLSAqICAyMDA5LjA2LjI2CUluaXRpYWwgcHVibGlz
aA0KLSAqDQotICovDQotDQotI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4NCi0jaW5jbHVkZSA8bGlu
dXgvbW9kdWxlLmg+DQotI2luY2x1ZGUgPGxpbnV4L2ZzLmg+DQotI2luY2x1ZGUgPGxpbnV4L2Nk
ZXYuaD4NCi0jaW5jbHVkZSA8bGludXgva2Rldl90Lmg+DQotI2luY2x1ZGUgPGxpbnV4L211dGV4
Lmg+DQotI2luY2x1ZGUgPGxpbnV4L3NjaGVkLmg+DQotI2luY2x1ZGUgPGxpbnV4L21tLmg+DQot
I2luY2x1ZGUgPGxpbnV4L3BvbGwuaD4NCi0jaW5jbHVkZSA8bGludXgvd2FpdC5oPg0KLSNpbmNs
dWRlIDxsaW51eC9zY2hlZC5oPg0KLSNpbmNsdWRlIDxsaW51eC9wY2kuaD4NCi0jaW5jbHVkZSA8
bGludXgvZmlybXdhcmUuaD4NCi0jaW5jbHVkZSA8bGludXgvc2xhYi5oPg0KLSNpbmNsdWRlIDxh
c20vaW9jdGwuaD4NCi0jaW5jbHVkZSA8bGludXgvaW9wb3J0Lmg+DQotI2luY2x1ZGUgPGFzbS9p
by5oPg0KLSNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4NCi0jaW5jbHVkZSA8bGludXgvcGFn
ZW1hcC5oPg0KLSNpbmNsdWRlIDxhc20vY2FjaGVmbHVzaC5oPg0KLSNpbmNsdWRlICJzZXBfZHJp
dmVyX2h3X2RlZnMuaCINCi0jaW5jbHVkZSAic2VwX2RyaXZlcl9jb25maWcuaCINCi0jaW5jbHVk
ZSAic2VwX2RyaXZlcl9hcGkuaCINCi0jaW5jbHVkZSAic2VwX2Rldi5oIg0KLQ0KLSNpZiBTRVBf
RFJJVkVSX0FSTV9ERUJVR19NT0RFDQotDQotI2RlZmluZSAgQ1JZU19TRVBfUk9NX2xlbmd0aCAg
ICAgICAgICAgICAgICAgIDB4NDAwMA0KLSNkZWZpbmUgIENSWVNfU0VQX1JPTV9zdGFydF9hZGRy
ZXNzICAgICAgICAgICAweDgwMDBDMDAwVUwNCi0jZGVmaW5lICBDUllTX1NFUF9ST01fc3RhcnRf
YWRkcmVzc19vZmZzZXQgICAgMHhDMDAwVUwNCi0jZGVmaW5lICBTRVBfUk9NX0JBTktfcmVnaXN0
ZXIgICAgICAgICAgICAgICAgMHg4MDAwODQyMFVMDQotI2RlZmluZSAgU0VQX1JPTV9CQU5LX3Jl
Z2lzdGVyX29mZnNldCAgICAgICAgIDB4ODQyMFVMDQotI2RlZmluZSBTRVBfUkFSX0lPX01FTV9S
RUdJT05fU1RBUlRfQUREUkVTUyAgIDB4ODIwMDAwMDANCi0NCi0vKg0KLSAqIFRIRVNFIDIgZGVm
aW5pdGlvbnMgYXJlIHNwZWNpZmljIHRvIHRoZSBib2FyZCAtIG11c3QgYmUNCi0gKiBkZWZpbmVk
IGR1cmluZyBpbnRlZ3JhdGlvbg0KLSAqLw0KLSNkZWZpbmUgU0VQX1JBUl9JT19NRU1fUkVHSU9O
X1NUQVJUX0FERFJFU1MgICAweEZGMEQwMDAwDQotDQotLyogMk0gc2l6ZSAqLw0KLQ0KLXN0YXRp
YyB2b2lkIHNlcF9sb2FkX3JvbV9jb2RlKHN0cnVjdCBzZXBfZGV2aWNlICpzZXApDQotew0KLQkv
KiBJbmRleCB2YXJpYWJsZXMgKi8NCi0JdW5zaWduZWQgbG9uZyBpLCBrLCBqOw0KLQl1MzIgcmVn
Ow0KLQl1MzIgZXJyb3I7DQotCXUzMiB3YXJuaW5nOw0KLQ0KLQkvKiBMb2FkaW5nIFJPTSBmcm9t
IFNFUF9ST01faW1hZ2UuaCBmaWxlICovDQotCWsgPSBzaXplb2YoQ1JZU19TRVBfUk9NKTsNCi0N
Ci0JZWRiZygiU0VQIERyaXZlcjogRFhfQ0NfVFNUX1NlcFJvbUxvYWRlciBzdGFydFxuIik7DQot
DQotCWVkYmcoIlNFUCBEcml2ZXI6IGsgaXMgJWx1XG4iLCBrKTsNCi0JZWRiZygiU0VQIERyaXZl
cjogc2VwLT5yZWdfYWRkciBpcyAlcFxuIiwgc2VwLT5yZWdfYWRkcik7DQotCWVkYmcoIlNFUCBE
cml2ZXI6IENSWVNfU0VQX1JPTV9zdGFydF9hZGRyZXNzX29mZnNldCBpcyAlcFxuIiwgQ1JZU19T
RVBfUk9NX3N0YXJ0X2FkZHJlc3Nfb2Zmc2V0KTsNCi0NCi0JZm9yIChpID0gMDsgaSA8IDQ7IGkr
Kykgew0KLQkJLyogd3JpdGUgYmFuayAqLw0KLQkJc2VwX3dyaXRlX3JlZyhzZXAsIFNFUF9ST01f
QkFOS19yZWdpc3Rlcl9vZmZzZXQsIGkpOw0KLQ0KLQkJZm9yIChqID0gMDsgaiA8IENSWVNfU0VQ
X1JPTV9sZW5ndGggLyA0OyBqKyspIHsNCi0JCQlzZXBfd3JpdGVfcmVnKHNlcCwgQ1JZU19TRVBf
Uk9NX3N0YXJ0X2FkZHJlc3Nfb2Zmc2V0ICsgNCAqIGosIENSWVNfU0VQX1JPTVtpICogMHgxMDAw
ICsgal0pOw0KLQ0KLQkJCWsgPSBrIC0gNDsNCi0NCi0JCQlpZiAoayA9PSAwKSB7DQotCQkJCWog
PSBDUllTX1NFUF9ST01fbGVuZ3RoOw0KLQkJCQlpID0gNDsNCi0JCQl9DQotCQl9DQotCX0NCi0N
Ci0JLyogcmVzZXQgdGhlIFNFUCAqLw0KLQlzZXBfd3JpdGVfcmVnKHNlcCwgSFdfSE9TVF9TRVBf
U1dfUlNUX1JFR19BRERSLCAweDEpOw0KLQ0KLQkvKiBwb2xsIGZvciBTRVAgUk9NIGJvb3QgZmlu
aXNoICovDQotCWRvDQotCQlyZWcgPSBzZXBfcmVhZF9yZWcoc2VwLCBIV19IT1NUX1NFUF9IT1NU
X0dQUjNfUkVHX0FERFIpOw0KLQl3aGlsZSAoIXJlZyk7DQotDQotCWVkYmcoIlNFUCBEcml2ZXI6
IFJPTSBwb2xsaW5nIGVuZGVkXG4iKTsNCi0NCi0Jc3dpdGNoIChyZWcpIHsNCi0JY2FzZSAweDE6
DQotCQkvKiBmYXRhbCBlcnJvciAtIHJlYWQgZXJybyBzdGF0dXMgZnJvbSBHUFJPICovDQotCQll
cnJvciA9IHNlcF9yZWFkX3JlZyhzZXAsIEhXX0hPU1RfU0VQX0hPU1RfR1BSMF9SRUdfQUREUik7
DQotCQllZGJnKCJTRVAgRHJpdmVyOiBST00gcG9sbGluZyBjYXNlIDFcbiIpOw0KLQkJYnJlYWs7
DQotCWNhc2UgMHg0Og0KLQkJLyogQ29sZCBib290IGVuZGVkIHN1Y2Nlc3NmdWxseSAgKi8NCi0J
Y2FzZSAweDg6DQotCQkvKiBXYXJtYm9vdCBlbmRlZCBzdWNjZXNzZnVsbHkgKi8NCi0JY2FzZSAw
eDEwOg0KLQkJLyogQ29sZFdhcm0gYm9vdCBlbmRlZCBzdWNjZXNzZnVsbHkgKi8NCi0JCWVycm9y
ID0gMDsNCi0JY2FzZSAweDI6DQotCQkvKiBCb290IEZpcnN0IFBoYXNlIGVuZGVkICAqLw0KLQkJ
d2FybmluZyA9IHNlcF9yZWFkX3JlZyhzZXAsIEhXX0hPU1RfU0VQX0hPU1RfR1BSMF9SRUdfQURE
Uik7DQotCWNhc2UgMHgyMDoNCi0JCWVkYmcoIlNFUCBEcml2ZXI6IFJPTSBwb2xsaW5nIGNhc2Ug
JWRcbiIsIHJlZyk7DQotCQlicmVhazsNCi0JfQ0KLQ0KLX0NCi0NCi0jZWxzZQ0KLXN0YXRpYyB2
b2lkIHNlcF9sb2FkX3JvbV9jb2RlKHN0cnVjdCBzZXBfZGV2aWNlICpzZXApIHsgfQ0KLSNlbmRp
ZgkJCQkvKiBTRVBfRFJJVkVSX0FSTV9ERUJVR19NT0RFICovDQotDQotDQotDQotLyotLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQotCURFRklORVMNCi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQotDQotI2RlZmluZSBCQVNFX0FERFJF
U1NfRk9SX1NZU1RFTSAweGZmZmMwMDAwDQotI2RlZmluZSBTRVBfUkFSX0lPX01FTV9SRUdJT05f
U0laRSAweDQwMDAwDQotDQotLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLQ0KLQlHTE9CQUwgdmFyaWFibGVzDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0qLw0KLQ0KLS8qIGRlYnVnIG1lc3NhZ2VzIGxldmVsICovDQotc3Rh
dGljIGludCBkZWJ1ZzsNCi1tb2R1bGVfcGFyYW0oZGVidWcsIGludCAsIDApOw0KLU1PRFVMRV9Q
QVJNX0RFU0MoZGVidWcsICJGbGFnIHRvIGVuYWJsZSBTRVAgZGVidWcgbWVzc2FnZXMiKTsNCi0N
Ci0vKiBLZWVwIHRoaXMgYSBzaW5nbGUgc3RhdGljIG9iamVjdCBmb3Igbm93IHRvIGtlZXAgdGhl
IGNvbnZlcnNpb24gZWFzeSAqLw0KLQ0KLXN0YXRpYyBzdHJ1Y3Qgc2VwX2RldmljZSBzZXBfaW5z
dGFuY2U7DQotc3RhdGljIHN0cnVjdCBzZXBfZGV2aWNlICpzZXBfZGV2ID0gJnNlcF9pbnN0YW5j
ZTsNCi0NCi0vKg0KLSAgbXV0ZXggZm9yIHRoZSBhY2Nlc3MgdG8gdGhlIGludGVybmFscyBvZiB0
aGUgc2VwIGRyaXZlcg0KLSovDQotc3RhdGljIERFRklORV9NVVRFWChzZXBfbXV0ZXgpOw0KLQ0K
LQ0KLS8qIHdhaXQgcXVldWUgaGVhZCAoZXZlbnQpIG9mIHRoZSBkcml2ZXIgKi8NCi1zdGF0aWMg
REVDTEFSRV9XQUlUX1FVRVVFX0hFQUQoc2VwX2V2ZW50KTsNCi0NCi0vKioNCi0gKglzZXBfbG9h
ZF9maXJtd2FyZQktCWNvcHkgZmlybXdhcmUgY2FjaGUvcmVzaWRlbnQNCi0gKglAc2VwOiBkZXZp
Y2Ugd2UgYXJlIGxvYWRpbmcNCi0gKg0KLSAqCVRoaXMgZnVuY3Rpb25zIGNvcGllcyB0aGUgY2Fj
aGUgYW5kIHJlc2lkZW50IGZyb20gdGhlaXIgc291cmNlDQotICoJbG9jYXRpb24gaW50byBkZXN0
aW5hdGlvbiBzaGFyZWQgbWVtb3J5Lg0KLSAqLw0KLQ0KLXN0YXRpYyBpbnQgc2VwX2xvYWRfZmly
bXdhcmUoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCkNCi17DQotCWNvbnN0IHN0cnVjdCBmaXJtd2Fy
ZSAqZnc7DQotCWNoYXIgKmNhY2hlX25hbWUgPSAic2VwL2NhY2hlLmltYWdlLmJpbiI7DQotCWNo
YXIgKnJlc19uYW1lID0gInNlcC9yZXNpZGVudC5pbWFnZS5iaW4iOw0KLQlpbnQgZXJyb3I7DQot
DQotCWVkYmcoIlNFUCBEcml2ZXI6cmFyX3ZpcnR1YWwgaXMgJXBcbiIsIHNlcC0+cmFyX2FkZHIp
Ow0KLQllZGJnKCJTRVAgRHJpdmVyOnJhcl9idXMgaXMgJTA4bGx4XG4iLCAodW5zaWduZWQgbG9u
ZyBsb25nKXNlcC0+cmFyX2J1cyk7DQotDQotCS8qIGxvYWQgY2FjaGUgKi8NCi0JZXJyb3IgPSBy
ZXF1ZXN0X2Zpcm13YXJlKCZmdywgY2FjaGVfbmFtZSwgJnNlcC0+cGRldi0+ZGV2KTsNCi0JaWYg
KGVycm9yKSB7DQotCQllZGJnKCJTRVAgRHJpdmVyOmNhbnQgcmVxdWVzdCBjYWNoZSBmd1xuIik7
DQotCQlyZXR1cm4gZXJyb3I7DQotCX0NCi0JZWRiZygiU0VQIERyaXZlcjpjYWNoZSAlMDhaeEAl
cFxuIiwgZnctPnNpemUsICh2b2lkICopIGZ3LT5kYXRhKTsNCi0NCi0JbWVtY3B5KHNlcC0+cmFy
X2FkZHIsICh2b2lkICopZnctPmRhdGEsIGZ3LT5zaXplKTsNCi0Jc2VwLT5jYWNoZV9zaXplID0g
ZnctPnNpemU7DQotCXJlbGVhc2VfZmlybXdhcmUoZncpOw0KLQ0KLQlzZXAtPnJlc2lkZW50X2J1
cyA9IHNlcC0+cmFyX2J1cyArIHNlcC0+Y2FjaGVfc2l6ZTsNCi0Jc2VwLT5yZXNpZGVudF9hZGRy
ID0gc2VwLT5yYXJfYWRkciArIHNlcC0+Y2FjaGVfc2l6ZTsNCi0NCi0JLyogbG9hZCByZXNpZGVu
dCAqLw0KLQllcnJvciA9IHJlcXVlc3RfZmlybXdhcmUoJmZ3LCByZXNfbmFtZSwgJnNlcC0+cGRl
di0+ZGV2KTsNCi0JaWYgKGVycm9yKSB7DQotCQllZGJnKCJTRVAgRHJpdmVyOmNhbnQgcmVxdWVz
dCByZXMgZndcbiIpOw0KLQkJcmV0dXJuIGVycm9yOw0KLQl9DQotCWVkYmcoInNlcDogcmVzICUw
OFp4QCVwXG4iLCBmdy0+c2l6ZSwgKHZvaWQgKilmdy0+ZGF0YSk7DQotDQotCW1lbWNweShzZXAt
PnJlc2lkZW50X2FkZHIsICh2b2lkICopIGZ3LT5kYXRhLCBmdy0+c2l6ZSk7DQotCXNlcC0+cmVz
aWRlbnRfc2l6ZSA9IGZ3LT5zaXplOw0KLQlyZWxlYXNlX2Zpcm13YXJlKGZ3KTsNCi0NCi0JZWRi
Zygic2VwOiByZXNpZGVudCB2ICVwIGIgJTA4bGx4IGNhY2hlIHYgJXAgYiAlMDhsbHhcbiIsDQot
CQlzZXAtPnJlc2lkZW50X2FkZHIsICh1bnNpZ25lZCBsb25nIGxvbmcpc2VwLT5yZXNpZGVudF9i
dXMsDQotCQlzZXAtPnJhcl9hZGRyLCAodW5zaWduZWQgbG9uZyBsb25nKXNlcC0+cmFyX2J1cyk7
DQotCXJldHVybiAwOw0KLX0NCi0NCi1NT0RVTEVfRklSTVdBUkUoInNlcC9jYWNoZS5pbWFnZS5i
aW4iKTsNCi1NT0RVTEVfRklSTVdBUkUoInNlcC9yZXNpZGVudC5pbWFnZS5iaW4iKTsNCi0NCi0v
KioNCi0gKglzZXBfbWFwX2FuZF9hbGxvY19zaGFyZWRfYXJlYQktCWFsbG9jYXRlIHNoYXJlZCBi
bG9jaw0KLSAqCUBzZXA6IHNlY3VyaXR5IHByb2Nlc3Nvcg0KLSAqCUBzaXplOiBzaXplIG9mIHNo
YXJlZCBhcmVhDQotICoNCi0gKglBbGxvY2F0ZSBhIHNoYXJlZCBidWZmZXIgaW4gaG9zdCBtZW1v
cnkgdGhhdCBjYW4gYmUgdXNlZCBieSBib3RoIHRoZQ0KLSAqCWtlcm5lbCBhbmQgYWxzbyB0aGUg
aGFyZHdhcmUgaW50ZXJmYWNlIHZpYSBETUEuDQotICovDQotDQotc3RhdGljIGludCBzZXBfbWFw
X2FuZF9hbGxvY19zaGFyZWRfYXJlYShzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwLA0KLQkJCQkJCQl1
bnNpZ25lZCBsb25nIHNpemUpDQotew0KLQkvKiBzaGFyZWRfYWRkciA9IGlvcmVtYXBfbm9jYWNo
ZSgweGRhMDAwMDAsc2hhcmVkX2FyZWFfc2l6ZSk7ICovDQotCXNlcC0+c2hhcmVkX2FkZHIgPSBk
bWFfYWxsb2NfY29oZXJlbnQoJnNlcC0+cGRldi0+ZGV2LCBzaXplLA0KLQkJCQkJJnNlcC0+c2hh
cmVkX2J1cywgR0ZQX0tFUk5FTCk7DQotDQotCWlmICghc2VwLT5zaGFyZWRfYWRkcikgew0KLQkJ
ZWRiZygic2VwX2RyaXZlciA6c2hhcmVkIG1lbW9yeSBkbWFfYWxsb2NfY29oZXJlbnQgZmFpbGVk
XG4iKTsNCi0JCXJldHVybiAtRU5PTUVNOw0KLQl9DQotCS8qIHNldCB0aGUgYnVzIGFkZHJlc3Mg
b2YgdGhlIHNoYXJlZCBhcmVhICovDQotCWVkYmcoInNlcDogc2hhcmVkX2FkZHIgJWxkIGJ5dGVz
IEAlcCAoYnVzICUwOGxseClcbiIsDQotCQlzaXplLCBzZXAtPnNoYXJlZF9hZGRyLCAodW5zaWdu
ZWQgbG9uZyBsb25nKXNlcC0+c2hhcmVkX2J1cyk7DQotCXJldHVybiAwOw0KLX0NCi0NCi0vKioN
Ci0gKglzZXBfdW5tYXBfYW5kX2ZyZWVfc2hhcmVkX2FyZWEJLQlmcmVlIHNoYXJlZCBibG9jaw0K
LSAqCUBzZXA6IHNlY3VyaXR5IHByb2Nlc3Nvcg0KLSAqDQotICoJRnJlZSB0aGUgc2hhcmVkIGFy
ZWEgYWxsb2NhdGVkIHRvIHRoZSBzZWN1cml0eSBwcm9jZXNzb3IuIFRoZQ0KLSAqCXByb2Nlc3Nv
ciBtdXN0IGhhdmUgZmluaXNoZWQgd2l0aCB0aGlzIGFuZCBhbnkgZmluYWwgcG9zdGVkDQotICoJ
d3JpdGVzIGNsZWFyZWQgYmVmb3JlIHdlIGRvIHNvLg0KLSAqLw0KLXN0YXRpYyB2b2lkIHNlcF91
bm1hcF9hbmRfZnJlZV9zaGFyZWRfYXJlYShzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwLCBpbnQgc2l6
ZSkNCi17DQotCWRtYV9mcmVlX2NvaGVyZW50KCZzZXAtPnBkZXYtPmRldiwgc2l6ZSwNCi0JCQkJ
c2VwLT5zaGFyZWRfYWRkciwgc2VwLT5zaGFyZWRfYnVzKTsNCi19DQotDQotLyoqDQotICoJc2Vw
X3NoYXJlZF92aXJ0X3RvX2J1cwktCWNvbnZlcnQgYnVzL3ZpcnQgYWRkcmVzc2VzDQotICoNCi0g
KglSZXR1cm5zIHRoZSBidXMgYWRkcmVzcyBpbnNpZGUgdGhlIHNoYXJlZCBhcmVhIGFjY29yZGlu
Zw0KLSAqCXRvIHRoZSB2aXJ0dWFsIGFkZHJlc3MuDQotICovDQotDQotc3RhdGljIGRtYV9hZGRy
X3Qgc2VwX3NoYXJlZF92aXJ0X3RvX2J1cyhzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwLA0KLQkJCQkJ
CXZvaWQgKnZpcnRfYWRkcmVzcykNCi17DQotCWRtYV9hZGRyX3QgcGEgPSBzZXAtPnNoYXJlZF9i
dXMgKyAodmlydF9hZGRyZXNzIC0gc2VwLT5zaGFyZWRfYWRkcik7DQotCWVkYmcoInNlcDogdmly
dCB0byBidXMgYiAlMDhsbHggdiAlcFxuIiwgKHVuc2lnbmVkIGxvbmcgbG9uZykgcGEsDQotCQkJ
CQkJCQl2aXJ0X2FkZHJlc3MpOw0KLQlyZXR1cm4gcGE7DQotfQ0KLQ0KLS8qKg0KLSAqCXNlcF9z
aGFyZWRfYnVzX3RvX3ZpcnQJLQljb252ZXJ0IGJ1cy92aXJ0IGFkZHJlc3Nlcw0KLSAqDQotICoJ
UmV0dXJucyB2aXJ0dWFsIGFkZHJlc3MgaW5zaWRlIHRoZSBzaGFyZWQgYXJlYSBhY2NvcmRpbmcN
Ci0gKgl0byB0aGUgYnVzIGFkZHJlc3MuDQotICovDQotDQotc3RhdGljIHZvaWQgKnNlcF9zaGFy
ZWRfYnVzX3RvX3ZpcnQoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCwNCi0JCQkJCQlkbWFfYWRkcl90
IGJ1c19hZGRyZXNzKQ0KLXsNCi0JcmV0dXJuIHNlcC0+c2hhcmVkX2FkZHIgKyAoYnVzX2FkZHJl
c3MgLSBzZXAtPnNoYXJlZF9idXMpOw0KLX0NCi0NCi0NCi0vKioNCi0gKglzZXBfdHJ5X29wZW4J
CS0JYXR0ZW1wdCB0byBvcGVuIGEgU0VQIGRldmljZQ0KLSAqCUBzZXA6IGRldmljZSB0byBhdHRl
bXB0IHRvIG9wZW4NCi0gKg0KLSAqCUF0b21pY2FsbHkgYXR0ZW1wdCB0byBnZXQgb3duZXJzaGlw
IG9mIGEgU0VQIGRldmljZS4NCi0gKglSZXR1cm5zIDEgaWYgdGhlIGRldmljZSB3YXMgb3BlbmVk
LCAwIG9uIGZhaWx1cmUuDQotICovDQotDQotc3RhdGljIGludCBzZXBfdHJ5X29wZW4oc3RydWN0
IHNlcF9kZXZpY2UgKnNlcCkNCi17DQotCWlmICghdGVzdF9hbmRfc2V0X2JpdCgwLCAmc2VwLT5p
bl91c2UpKQ0KLQkJcmV0dXJuIDE7DQotCXJldHVybiAwOw0KLX0NCi0NCi0vKioNCi0gKglzZXBf
b3BlbgkJLQlkZXZpY2Ugb3BlbiBtZXRob2QNCi0gKglAaW5vZGU6IGlub2RlIG9mIHNlcCBkZXZp
Y2UNCi0gKglAZmlscDogZmlsZSBoYW5kbGUgdG8gc2VwIGRldmljZQ0KLSAqDQotICoJT3BlbiBt
ZXRob2QgZm9yIHRoZSBTRVAgZGV2aWNlLiBDYWxsZWQgd2hlbiB1c2Vyc3BhY2Ugb3BlbnMNCi0g
Kgl0aGUgU0VQIGRldmljZSBub2RlLiBNdXN0IGFsc28gcmVsZWFzZSB0aGUgbWVtb3J5IGRhdGEg
cG9vbA0KLSAqCWFsbG9jYXRpb25zLg0KLSAqDQotICoJUmV0dXJucyB6ZXJvIG9uIHN1Y2Nlc3Mg
b3RoZXJ3aXNlIGFuIGVycm9yIGNvZGUuDQotICovDQotDQotc3RhdGljIGludCBzZXBfb3Blbihz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkNCi17DQotCWlmIChzZXBfZGV2
ID09IE5VTEwpDQotCQlyZXR1cm4gLUVOT0RFVjsNCi0NCi0JLyogY2hlY2sgdGhlIGJsb2NraW5n
IG1vZGUgKi8NCi0JaWYgKGZpbHAtPmZfZmxhZ3MgJiBPX05ERUxBWSkgew0KLQkJaWYgKHNlcF90
cnlfb3BlbihzZXBfZGV2KSA9PSAwKQ0KLQkJCXJldHVybiAtRUFHQUlOOw0KLQl9IGVsc2UNCi0J
CWlmICh3YWl0X2V2ZW50X2ludGVycnVwdGlibGUoc2VwX2V2ZW50LCBzZXBfdHJ5X29wZW4oc2Vw
X2RldikpIDwgMCkNCi0JCQlyZXR1cm4gLUVJTlRSOw0KLQ0KLQkvKiBCaW5kIHRvIHRoZSBkZXZp
Y2UsIHdlIG9ubHkgaGF2ZSBvbmUgd2hpY2ggbWFrZXMgaXQgZWFzeSAqLw0KLQlmaWxwLT5wcml2
YXRlX2RhdGEgPSBzZXBfZGV2Ow0KLQkvKiByZWxlYXNlIGRhdGEgcG9vbCBhbGxvY2F0aW9ucyAq
Lw0KLQlzZXBfZGV2LT5kYXRhX3Bvb2xfYnl0ZXNfYWxsb2NhdGVkID0gMDsNCi0JcmV0dXJuIDA7
DQotfQ0KLQ0KLQ0KLS8qKg0KLSAqCXNlcF9yZWxlYXNlCQktCWNsb3NlIGEgU0VQIGRldmljZQ0K
LSAqCUBpbm9kZTogaW5vZGUgb2YgU0VQIGRldmljZQ0KLSAqCUBmaWxwOiBmaWxlIGhhbmRsZSBi
ZWluZyBjbG9zZWQNCi0gKg0KLSAqCUNhbGxlZCBvbiB0aGUgZmluYWwgY2xvc2Ugb2YgYSBTRVAg
ZGV2aWNlLiBBcyB0aGUgb3BlbiBwcm90ZWN0cyBhZ2FpbnN0DQotICoJbXVsdGlwbGUgc2ltdWx0
YWVub3VzIG9wZW5zIHRoYXQgbWVhbnMgdGhpcyBtZXRob2QgaXMgY2FsbGVkIHdoZW4gdGhlDQot
ICoJZmluYWwgcmVmZXJlbmNlIHRvIHRoZSBvcGVuIGhhbmRsZSBpcyBkcm9wcGVkLg0KLSAqLw0K
LQ0KLXN0YXRpYyBpbnQgc2VwX3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZp
bGUgKmZpbHApDQotew0KLQlzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwID0gIGZpbHAtPnByaXZhdGVf
ZGF0YTsNCi0jaWYgMAkJCQkvKiFTRVBfRFJJVkVSX1BPTExJTkdfTU9ERSAqLw0KLQkvKiBjbG9z
ZSBJTVIgKi8NCi0Jc2VwX3dyaXRlX3JlZyhzZXAsIEhXX0hPU1RfSU1SX1JFR19BRERSLCAweDdG
RkYpOw0KLQkvKiByZWxlYXNlIElSUSBsaW5lICovDQotCWZyZWVfaXJxKFNFUF9ESVJWRVJfSVJR
X05VTSwgc2VwKTsNCi0NCi0jZW5kaWYNCi0JLyogRW5zdXJlIGFueSBibG9ja2VkIG9wZW4gcHJv
Z3Jlc3NlcyAqLw0KLQljbGVhcl9iaXQoMCwgJnNlcC0+aW5fdXNlKTsNCi0Jd2FrZV91cCgmc2Vw
X2V2ZW50KTsNCi0JcmV0dXJuIDA7DQotfQ0KLQ0KLS8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQotICBtYXAgZnVuY3Rpb24g
LSB0aGlzIGZ1bmN0aW9ucyBtYXBzIHRoZSBtZXNzYWdlIHNoYXJlZCBhcmVhDQotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0q
Lw0KLXN0YXRpYyBpbnQgc2VwX21tYXAoc3RydWN0IGZpbGUgKmZpbHAsIHN0cnVjdCB2bV9hcmVh
X3N0cnVjdCAqdm1hKQ0KLXsNCi0JZG1hX2FkZHJfdCBidXNfYWRkcjsNCi0Jc3RydWN0IHNlcF9k
ZXZpY2UgKnNlcCA9IGZpbHAtPnByaXZhdGVfZGF0YTsNCi0NCi0JZGJnKCItLS0tLS0tLT5TRVAg
RHJpdmVyOiBtbWFwIHN0YXJ0XG4iKTsNCi0NCi0JLyogY2hlY2sgdGhhdCB0aGUgc2l6ZSBvZiB0
aGUgbWFwcGVkIHJhbmdlIGlzIGFzIHRoZSBzaXplIG9mIHRoZSBtZXNzYWdlDQotCSAgIHNoYXJl
ZCBhcmVhICovDQotCWlmICgodm1hLT52bV9lbmQgLSB2bWEtPnZtX3N0YXJ0KSA+IFNFUF9EUklW
RVJfTU1NQVBfQVJFQV9TSVpFKSB7DQotCQllZGJnKCJTRVAgRHJpdmVyIG1tYXAgcmVxdWVzdGVk
IHNpemUgaXMgbW9yZSB0aGFuIGFsbG93ZWRcbiIpOw0KLQkJcHJpbnRrKEtFUk5fV0FSTklORyAi
U0VQIERyaXZlciBtbWFwIHJlcXVlc3RlZCBzaXplIGlzIG1vcmUgdGhhbiBhbGxvd2VkXG4iKTsN
Ci0JCXByaW50ayhLRVJOX1dBUk5JTkcgIlNFUCBEcml2ZXIgdm1hLT52bV9lbmQgaXMgJTA4bHhc
biIsIHZtYS0+dm1fZW5kKTsNCi0JCXByaW50ayhLRVJOX1dBUk5JTkcgIlNFUCBEcml2ZXIgdm1h
LT52bV9lbmQgaXMgJTA4bHhcbiIsIHZtYS0+dm1fc3RhcnQpOw0KLQkJcmV0dXJuIC1FQUdBSU47
DQotCX0NCi0NCi0JZWRiZygiU0VQIERyaXZlcjpzZXAtPnNoYXJlZF9hZGRyIGlzICVwXG4iLCBz
ZXAtPnNoYXJlZF9hZGRyKTsNCi0NCi0JLyogZ2V0IGJ1cyBhZGRyZXNzICovDQotCWJ1c19hZGRy
ID0gc2VwLT5zaGFyZWRfYnVzOw0KLQ0KLQllZGJnKCJTRVAgRHJpdmVyOiBwaHlzX2FkZHIgaXMg
JTA4bGx4XG4iLCAodW5zaWduZWQgbG9uZyBsb25nKWJ1c19hZGRyKTsNCi0NCi0JaWYgKHJlbWFw
X3Bmbl9yYW5nZSh2bWEsIHZtYS0+dm1fc3RhcnQsIGJ1c19hZGRyID4+IFBBR0VfU0hJRlQsIHZt
YS0+dm1fZW5kIC0gdm1hLT52bV9zdGFydCwgdm1hLT52bV9wYWdlX3Byb3QpKSB7DQotCQllZGJn
KCJTRVAgRHJpdmVyIHJlbWFwX3BhZ2VfcmFuZ2UgZmFpbGVkXG4iKTsNCi0JCXByaW50ayhLRVJO
X1dBUk5JTkcgIlNFUCBEcml2ZXIgcmVtYXBfcGFnZV9yYW5nZSBmYWlsZWRcbiIpOw0KLQkJcmV0
dXJuIC1FQUdBSU47DQotCX0NCi0NCi0JZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBtbWFwIGVu
ZFxuIik7DQotDQotCXJldHVybiAwOw0KLX0NCi0NCi0NCi0vKi0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQotICBwb2xsIGZ1bmN0aW9uDQotKi0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KLXN0YXRpYyB1bnNpZ25l
ZCBpbnQgc2VwX3BvbGwoc3RydWN0IGZpbGUgKmZpbHAsIHBvbGxfdGFibGUgKiB3YWl0KQ0KLXsN
Ci0JdW5zaWduZWQgbG9uZyBjb3VudDsNCi0JdW5zaWduZWQgaW50IG1hc2sgPSAwOw0KLQl1bnNp
Z25lZCBsb25nIHJldHZhbCA9IDA7CS8qIGZsb3cgaWQgKi8NCi0Jc3RydWN0IHNlcF9kZXZpY2Ug
KnNlcCA9IGZpbHAtPnByaXZhdGVfZGF0YTsNCi0NCi0JZGJnKCItLS0tLS0tLS0tPlNFUCBEcml2
ZXIgcG9sbDogc3RhcnRcbiIpOw0KLQ0KLQ0KLSNpZiBTRVBfRFJJVkVSX1BPTExJTkdfTU9ERQ0K
LQ0KLQl3aGlsZSAoc2VwLT5zZW5kX2N0ICE9IChyZXR2YWwgJiAweDdGRkZGRkZGKSkgew0KLQkJ
cmV0dmFsID0gc2VwX3JlYWRfcmVnKHNlcCwgSFdfSE9TVF9TRVBfSE9TVF9HUFIyX1JFR19BRERS
KTsNCi0NCi0JCWZvciAoY291bnQgPSAwOyBjb3VudCA8IDEwICogNDsgY291bnQgKz0gNCkNCi0J
CQllZGJnKCJQb2xsIERlYnVnIFdvcmQgJWx1IG9mIHRoZSBtZXNzYWdlIGlzICVsdVxuIiwgY291
bnQsICooKHVuc2lnbmVkIGxvbmcgKikgKHNlcC0+c2hhcmVkX2FkZHIgKyBTRVBfRFJJVkVSX01F
U1NBR0VfU0hBUkVEX0FSRUFfU0laRV9JTl9CWVRFUyArIGNvdW50KSkpOw0KLQl9DQotDQotCXNl
cC0+cmVwbHlfY3QrKzsNCi0jZWxzZQ0KLQkvKiBhZGQgdGhlIGV2ZW50IHRvIHRoZSBwb2xsaW5n
IHdhaXQgdGFibGUgKi8NCi0JcG9sbF93YWl0KGZpbHAsICZzZXBfZXZlbnQsIHdhaXQpOw0KLQ0K
LSNlbmRpZg0KLQ0KLQllZGJnKCJzZXAtPnNlbmRfY3QgaXMgJWx1XG4iLCBzZXAtPnNlbmRfY3Qp
Ow0KLQllZGJnKCJzZXAtPnJlcGx5X2N0IGlzICVsdVxuIiwgc2VwLT5yZXBseV9jdCk7DQotDQot
CS8qIGNoZWNrIGlmIHRoZSBkYXRhIGlzIHJlYWR5ICovDQotCWlmIChzZXAtPnNlbmRfY3QgPT0g
c2VwLT5yZXBseV9jdCkgew0KLQkJZm9yIChjb3VudCA9IDA7IGNvdW50IDwgMTIgKiA0OyBjb3Vu
dCArPSA0KQ0KLQkJCWVkYmcoIlNlcCBNZXNnIFdvcmQgJWx1IG9mIHRoZSBtZXNzYWdlIGlzICVs
dVxuIiwgY291bnQsICooKHVuc2lnbmVkIGxvbmcgKikgKHNlcC0+c2hhcmVkX2FkZHIgKyBjb3Vu
dCkpKTsNCi0NCi0JCWZvciAoY291bnQgPSAwOyBjb3VudCA8IDEwICogNDsgY291bnQgKz0gNCkN
Ci0JCQllZGJnKCJEZWJ1ZyBEYXRhIFdvcmQgJWx1IG9mIHRoZSBtZXNzYWdlIGlzICVsdVxuIiwg
Y291bnQsICooKHVuc2lnbmVkIGxvbmcgKikgKHNlcC0+c2hhcmVkX2FkZHIgKyAweDE4MDAgKyBj
b3VudCkpKTsNCi0NCi0JCXJldHZhbCA9IHNlcF9yZWFkX3JlZyhzZXAsIEhXX0hPU1RfU0VQX0hP
U1RfR1BSMl9SRUdfQUREUik7DQotCQllZGJnKCJyZXR2YWwgaXMgJWx1XG4iLCByZXR2YWwpOw0K
LQkJLyogY2hlY2sgaWYgdGhlIHRoaXMgaXMgc2VwIHJlcGx5IG9yIHJlcXVlc3QgKi8NCi0JCWlm
IChyZXR2YWwgPj4gMzEpIHsNCi0JCQllZGJnKCJTRVAgRHJpdmVyOiBzZXAgcmVxdWVzdCBpblxu
Iik7DQotCQkJLyogcmVxdWVzdCAqLw0KLQkJCW1hc2sgfD0gUE9MTE9VVCB8IFBPTExXUk5PUk07
DQotCQl9IGVsc2Ugew0KLQkJCWVkYmcoIlNFUCBEcml2ZXI6IHNlcCByZXBseSBpblxuIik7DQot
CQkJbWFzayB8PSBQT0xMSU4gfCBQT0xMUkROT1JNOw0KLQkJfQ0KLQl9DQotCWRiZygiU0VQIERy
aXZlcjo8LS0tLS0tLS0gcG9sbCBleGl0XG4iKTsNCi0JcmV0dXJuIG1hc2s7DQotfQ0KLQ0KLS8q
Kg0KLSAqCXNlcF90aW1lX2FkZHJlc3MJLQlhZGRyZXNzIGluIFNFUCBtZW1vcnkgb2YgdGltZQ0K
LSAqCUBzZXA6IFNFUCBkZXZpY2Ugd2Ugd2FudCB0aGUgYWRkcmVzcyBmcm9tDQotICoNCi0gKglS
ZXR1cm4gdGhlIGFkZHJlc3Mgb2YgdGhlIHR3byBkd29yZHMgaW4gbWVtb3J5IHVzZWQgZm9yIHRp
bWUNCi0gKglzZXR0aW5nLg0KLSAqLw0KLQ0KLXN0YXRpYyB1MzIgKnNlcF90aW1lX2FkZHJlc3Mo
c3RydWN0IHNlcF9kZXZpY2UgKnNlcCkNCi17DQotCXJldHVybiBzZXAtPnNoYXJlZF9hZGRyICsg
U0VQX0RSSVZFUl9TWVNURU1fVElNRV9NRU1PUllfT0ZGU0VUX0lOX0JZVEVTOw0KLX0NCi0NCi0v
KioNCi0gKglzZXBfc2V0X3RpbWUJCS0Jc2V0IHRoZSBTRVAgdGltZQ0KLSAqCUBzZXA6IHRoZSBT
RVAgd2UgYXJlIHNldHRpbmcgdGhlIHRpbWUgZm9yDQotICoNCi0gKglDYWxjdWxhdGVzIHRpbWUg
YW5kIHNldHMgaXQgYXQgdGhlIHByZWRlZmluZWQgYWRkcmVzcy4NCi0gKglDYWxsZWQgd2l0aCB0
aGUgc2VwIG11dGV4IGhlbGQuDQotICovDQotc3RhdGljIHVuc2lnbmVkIGxvbmcgc2VwX3NldF90
aW1lKHN0cnVjdCBzZXBfZGV2aWNlICpzZXApDQotew0KLQlzdHJ1Y3QgdGltZXZhbCB0aW1lOw0K
LQl1MzIgKnRpbWVfYWRkcjsJLyogYWRkcmVzcyBvZiB0aW1lIGFzIHNlZW4gYnkgdGhlIGtlcm5l
bCAqLw0KLQ0KLQ0KLQlkYmcoInNlcDpzZXBfc2V0X3RpbWUgc3RhcnRcbiIpOw0KLQ0KLQlkb19n
ZXR0aW1lb2ZkYXkoJnRpbWUpOw0KLQ0KLQkvKiBzZXQgdmFsdWUgaW4gdGhlIFNZU1RFTSBNRU1P
Ulkgb2Zmc2V0ICovDQotCXRpbWVfYWRkciA9IHNlcF90aW1lX2FkZHJlc3Moc2VwKTsNCi0NCi0J
dGltZV9hZGRyWzBdID0gU0VQX1RJTUVfVkFMX1RPS0VOOw0KLQl0aW1lX2FkZHJbMV0gPSB0aW1l
LnR2X3NlYzsNCi0NCi0JZWRiZygiU0VQIERyaXZlcjp0aW1lLnR2X3NlYyBpcyAlbHVcbiIsIHRp
bWUudHZfc2VjKTsNCi0JZWRiZygiU0VQIERyaXZlcjp0aW1lX2FkZHIgaXMgJXBcbiIsIHRpbWVf
YWRkcik7DQotCWVkYmcoIlNFUCBEcml2ZXI6c2VwLT5zaGFyZWRfYWRkciBpcyAlcFxuIiwgc2Vw
LT5zaGFyZWRfYWRkcik7DQotDQotCXJldHVybiB0aW1lLnR2X3NlYzsNCi19DQotDQotLyoqDQot
ICoJc2VwX2R1bXBfbWVzc2FnZQktIGR1bXAgdGhlIG1lc3NhZ2UgdGhhdCBpcyBwZW5kaW5nDQot
ICoJQHNlcDogc2VwIGRldmljZQ0KLSAqDQotICoJRHVtcCBvdXQgdGhlIG1lc3NhZ2UgcGVuZGlu
ZyBpbiB0aGUgc2hhcmVkIG1lc3NhZ2UgYXJlYQ0KLSAqLw0KLQ0KLXN0YXRpYyB2b2lkIHNlcF9k
dW1wX21lc3NhZ2Uoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCkNCi17DQotCWludCBjb3VudDsNCi0J
Zm9yIChjb3VudCA9IDA7IGNvdW50IDwgMTIgKiA0OyBjb3VudCArPSA0KQ0KLQkJZWRiZygiV29y
ZCAlZCBvZiB0aGUgbWVzc2FnZSBpcyAldVxuIiwgY291bnQsICooKHUzMiAqKSAoc2VwLT5zaGFy
ZWRfYWRkciArIGNvdW50KSkpOw0KLX0NCi0NCi0vKioNCi0gKglzZXBfc2VuZF9jb21tYW5kX2hh
bmRsZXIJLQlraWNrIG9mZiBhIGNvbW1hbmQNCi0gKglAc2VwOiBzZXAgYmVpbmcgc2lnbmFsbGVk
DQotICoNCi0gKglUaGlzIGZ1bmN0aW9uIHJhaXNlcyBpbnRlcnJ1cHQgdG8gU0VQIHRoYXQgc2ln
bmFscyB0aGF0IGlzIGhhcyBhIG5ldw0KLSAqCWNvbW1hbmQgZnJvbSB0aGUgaG9zdA0KLSAqLw0K
LQ0KLXN0YXRpYyB2b2lkIHNlcF9zZW5kX2NvbW1hbmRfaGFuZGxlcihzdHJ1Y3Qgc2VwX2Rldmlj
ZSAqc2VwKQ0KLXsNCi0JZGJnKCJzZXA6c2VwX3NlbmRfY29tbWFuZF9oYW5kbGVyIHN0YXJ0XG4i
KTsNCi0NCi0JbXV0ZXhfbG9jaygmc2VwX211dGV4KTsNCi0Jc2VwX3NldF90aW1lKHNlcCk7DQot
DQotCS8qIEZJWE1FOiBmbHVzaCBjYWNoZSAqLw0KLQlmbHVzaF9jYWNoZV9hbGwoKTsNCi0NCi0J
c2VwX2R1bXBfbWVzc2FnZShzZXApOw0KLQkvKiB1cGRhdGUgY291bnRlciAqLw0KLQlzZXAtPnNl
bmRfY3QrKzsNCi0JLyogc2VuZCBpbnRlcnJ1cHQgdG8gU0VQICovDQotCXNlcF93cml0ZV9yZWco
c2VwLCBIV19IT1NUX0hPU1RfU0VQX0dQUjBfUkVHX0FERFIsIDB4Mik7DQotCWRiZygiU0VQIERy
aXZlcjo8LS0tLS0tLS0gc2VwX3NlbmRfY29tbWFuZF9oYW5kbGVyIGVuZFxuIik7DQotCW11dGV4
X3VubG9jaygmc2VwX211dGV4KTsNCi0JcmV0dXJuOw0KLX0NCi0NCi0vKioNCi0gKglzZXBfc2Vu
ZF9yZXBseV9jb21tYW5kX2hhbmRsZXIJLQlraWNrIG9mZiBhIGNvbW1hbmQgcmVwbHkNCi0gKglA
c2VwOiBzZXAgYmVpbmcgc2lnbmFsbGVkDQotICoNCi0gKglUaGlzIGZ1bmN0aW9uIHJhaXNlcyBp
bnRlcnJ1cHQgdG8gU0VQIHRoYXQgc2lnbmFscyB0aGF0IGlzIGhhcyBhIG5ldw0KLSAqCWNvbW1h
bmQgZnJvbSB0aGUgaG9zdA0KLSAqLw0KLQ0KLXN0YXRpYyB2b2lkIHNlcF9zZW5kX3JlcGx5X2Nv
bW1hbmRfaGFuZGxlcihzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwKQ0KLXsNCi0JZGJnKCJzZXA6c2Vw
X3NlbmRfcmVwbHlfY29tbWFuZF9oYW5kbGVyIHN0YXJ0XG4iKTsNCi0NCi0JLyogZmxhc2ggY2Fj
aGUgKi8NCi0JZmx1c2hfY2FjaGVfYWxsKCk7DQotDQotCXNlcF9kdW1wX21lc3NhZ2Uoc2VwKTsN
Ci0NCi0JbXV0ZXhfbG9jaygmc2VwX211dGV4KTsNCi0Jc2VwLT5zZW5kX2N0Kys7ICAJLyogdXBk
YXRlIGNvdW50ZXIgKi8NCi0JLyogc2VuZCB0aGUgaW50ZXJydXB0IHRvIFNFUCAqLw0KLQlzZXBf
d3JpdGVfcmVnKHNlcCwgSFdfSE9TVF9IT1NUX1NFUF9HUFIyX1JFR19BRERSLCBzZXAtPnNlbmRf
Y3QpOw0KLQkvKiB1cGRhdGUgYm90aCBjb3VudGVycyAqLw0KLQlzZXAtPnNlbmRfY3QrKzsNCi0J
c2VwLT5yZXBseV9jdCsrOw0KLQltdXRleF91bmxvY2soJnNlcF9tdXRleCk7DQotCWRiZygic2Vw
OiBzZXBfc2VuZF9yZXBseV9jb21tYW5kX2hhbmRsZXIgZW5kXG4iKTsNCi19DQotDQotLyoNCi0g
IFRoaXMgZnVuY3Rpb24gaGFuZGxlcyB0aGUgYWxsb2NhdGUgZGF0YSBwb29sIG1lbW9yeSByZXF1
ZXN0DQotICBUaGlzIGZ1bmN0aW9uIHJldHVybnMgY2FsY3VsYXRlcyB0aGUgYnVzIGFkZHJlc3Mg
b2YgdGhlDQotICBhbGxvY2F0ZWQgbWVtb3J5LCBhbmQgdGhlIG9mZnNldCBvZiB0aGlzIGFyZWEg
ZnJvbSB0aGUgbWFwcGVkIGFkZHJlc3MuDQotICBUaGVyZWZvcmUsIHRoZSBGVk9zIGluIHVzZXIg
c3BhY2UgY2FuIGNhbGN1bGF0ZSB0aGUgZXhhY3QgdmlydHVhbA0KLSAgYWRkcmVzcyBvZiB0aGlz
IGFsbG9jYXRlZCBtZW1vcnkNCi0qLw0KLXN0YXRpYyBpbnQgc2VwX2FsbG9jYXRlX2RhdGFfcG9v
bF9tZW1vcnlfaGFuZGxlcihzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwLA0KLQkJCQkJCQl1bnNpZ25l
ZCBsb25nIGFyZykNCi17DQotCWludCBlcnJvcjsNCi0Jc3RydWN0IHNlcF9kcml2ZXJfYWxsb2Nf
dCBjb21tYW5kX2FyZ3M7DQotDQotCWRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX2FsbG9j
YXRlX2RhdGFfcG9vbF9tZW1vcnlfaGFuZGxlciBzdGFydFxuIik7DQotDQotCWVycm9yID0gY29w
eV9mcm9tX3VzZXIoJmNvbW1hbmRfYXJncywgKHZvaWQgKikgYXJnLCBzaXplb2Yoc3RydWN0IHNl
cF9kcml2ZXJfYWxsb2NfdCkpOw0KLQlpZiAoZXJyb3IpDQotCQlnb3RvIGVuZF9mdW5jdGlvbjsN
Ci0NCi0JLyogYWxsb2NhdGUgbWVtb3J5ICovDQotCWlmICgoc2VwLT5kYXRhX3Bvb2xfYnl0ZXNf
YWxsb2NhdGVkICsgY29tbWFuZF9hcmdzLm51bV9ieXRlcykgPiBTRVBfRFJJVkVSX0RBVEFfUE9P
TF9TSEFSRURfQVJFQV9TSVpFX0lOX0JZVEVTKSB7DQotCQllcnJvciA9IC1FTk9NRU07DQotCQln
b3RvIGVuZF9mdW5jdGlvbjsNCi0JfQ0KLQ0KLQkvKiBzZXQgdGhlIHZpcnR1YWwgYW5kIGJ1cyBh
ZGRyZXNzICovDQotCWNvbW1hbmRfYXJncy5vZmZzZXQgPSBTRVBfRFJJVkVSX0RBVEFfUE9PTF9B
UkVBX09GRlNFVF9JTl9CWVRFUyArIHNlcC0+ZGF0YV9wb29sX2J5dGVzX2FsbG9jYXRlZDsNCi0J
Y29tbWFuZF9hcmdzLnBoeXNfYWRkcmVzcyA9IHNlcC0+c2hhcmVkX2J1cyArIFNFUF9EUklWRVJf
REFUQV9QT09MX0FSRUFfT0ZGU0VUX0lOX0JZVEVTICsgc2VwLT5kYXRhX3Bvb2xfYnl0ZXNfYWxs
b2NhdGVkOw0KLQ0KLQkvKiB3cml0ZSB0aGUgbWVtb3J5IGJhY2sgdG8gdGhlIHVzZXIgc3BhY2Ug
Ki8NCi0JZXJyb3IgPSBjb3B5X3RvX3VzZXIoKHZvaWQgKikgYXJnLCAodm9pZCAqKSAmY29tbWFu
ZF9hcmdzLCBzaXplb2Yoc3RydWN0IHNlcF9kcml2ZXJfYWxsb2NfdCkpOw0KLQlpZiAoZXJyb3Ip
DQotCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0NCi0JLyogc2V0IHRoZSBhbGxvY2F0aW9uICovDQot
CXNlcC0+ZGF0YV9wb29sX2J5dGVzX2FsbG9jYXRlZCArPSBjb21tYW5kX2FyZ3MubnVtX2J5dGVz
Ow0KLQ0KLWVuZF9mdW5jdGlvbjoNCi0JZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBfYWxs
b2NhdGVfZGF0YV9wb29sX21lbW9yeV9oYW5kbGVyIGVuZFxuIik7DQotCXJldHVybiBlcnJvcjsN
Ci19DQotDQotLyoNCi0gIFRoaXMgZnVuY3Rpb24gIGhhbmRsZXMgd3JpdGUgaW50byBhbGxvY2F0
ZWQgZGF0YSBwb29sIGNvbW1hbmQNCi0qLw0KLXN0YXRpYyBpbnQgc2VwX3dyaXRlX2ludG9fZGF0
YV9wb29sX2hhbmRsZXIoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCwgdW5zaWduZWQgbG9uZyBhcmcp
DQotew0KLQlpbnQgZXJyb3I7DQotCXZvaWQgKnZpcnRfYWRkcmVzczsNCi0JdW5zaWduZWQgbG9u
ZyB2YTsNCi0JdW5zaWduZWQgbG9uZyBhcHBfaW5fYWRkcmVzczsNCi0JdW5zaWduZWQgbG9uZyBu
dW1fYnl0ZXM7DQotCXZvaWQgKmRhdGFfcG9vbF9hcmVhX2FkZHI7DQotDQotCWRiZygiU0VQIERy
aXZlcjotLS0tLS0tLT4gc2VwX3dyaXRlX2ludG9fZGF0YV9wb29sX2hhbmRsZXIgc3RhcnRcbiIp
Ow0KLQ0KLQkvKiBnZXQgdGhlIGFwcGxpY2F0aW9uIGFkZHJlc3MgKi8NCi0JZXJyb3IgPSBnZXRf
dXNlcihhcHBfaW5fYWRkcmVzcywgJigoKHN0cnVjdCBzZXBfZHJpdmVyX3dyaXRlX3QgKikgYXJn
KS0+YXBwX2FkZHJlc3MpKTsNCi0JaWYgKGVycm9yKQ0KLQkJZ290byBlbmRfZnVuY3Rpb247DQot
DQotCS8qIGdldCB0aGUgdmlydHVhbCBrZXJuZWwgYWRkcmVzcyBhZGRyZXNzICovDQotCWVycm9y
ID0gZ2V0X3VzZXIodmEsICYoKChzdHJ1Y3Qgc2VwX2RyaXZlcl93cml0ZV90ICopIGFyZyktPmRh
dGFwb29sX2FkZHJlc3MpKTsNCi0JaWYgKGVycm9yKQ0KLQkJZ290byBlbmRfZnVuY3Rpb247DQot
CXZpcnRfYWRkcmVzcyA9ICh2b2lkICopdmE7DQotDQotCS8qIGdldCB0aGUgbnVtYmVyIG9mIGJ5
dGVzICovDQotCWVycm9yID0gZ2V0X3VzZXIobnVtX2J5dGVzLCAmKCgoc3RydWN0IHNlcF9kcml2
ZXJfd3JpdGVfdCAqKSBhcmcpLT5udW1fYnl0ZXMpKTsNCi0JaWYgKGVycm9yKQ0KLQkJZ290byBl
bmRfZnVuY3Rpb247DQotDQotCS8qIGNhbGN1bGF0ZSB0aGUgc3RhcnQgb2YgdGhlIGRhdGEgcG9v
bCAqLw0KLQlkYXRhX3Bvb2xfYXJlYV9hZGRyID0gc2VwLT5zaGFyZWRfYWRkciArIFNFUF9EUklW
RVJfREFUQV9QT09MX0FSRUFfT0ZGU0VUX0lOX0JZVEVTOw0KLQ0KLQ0KLQkvKiBjaGVjayB0aGF0
IHRoZSByYW5nZSBvZiB0aGUgdmlydHVhbCBrZXJuZWwgYWRkcmVzcyBpcyBjb3JyZWN0ICovDQot
CWlmICh2aXJ0X2FkZHJlc3MgPCBkYXRhX3Bvb2xfYXJlYV9hZGRyIHx8IHZpcnRfYWRkcmVzcyA+
IChkYXRhX3Bvb2xfYXJlYV9hZGRyICsgU0VQX0RSSVZFUl9EQVRBX1BPT0xfU0hBUkVEX0FSRUFf
U0laRV9JTl9CWVRFUykpIHsNCi0JCWVycm9yID0gLUVJTlZBTDsNCi0JCWdvdG8gZW5kX2Z1bmN0
aW9uOw0KLQl9DQotCS8qIGNvcHkgdGhlIGFwcGxpY2F0aW9uIGRhdGEgKi8NCi0JZXJyb3IgPSBj
b3B5X2Zyb21fdXNlcih2aXJ0X2FkZHJlc3MsICh2b2lkICopIGFwcF9pbl9hZGRyZXNzLCBudW1f
Ynl0ZXMpOw0KLWVuZF9mdW5jdGlvbjoNCi0JZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBf
d3JpdGVfaW50b19kYXRhX3Bvb2xfaGFuZGxlciBlbmRcbiIpOw0KLQlyZXR1cm4gZXJyb3I7DQot
fQ0KLQ0KLS8qDQotICB0aGlzIGZ1bmN0aW9uIGhhbmRsZXMgdGhlIHJlYWQgZnJvbSBkYXRhIHBv
b2wgY29tbWFuZA0KLSovDQotc3RhdGljIGludCBzZXBfcmVhZF9mcm9tX2RhdGFfcG9vbF9oYW5k
bGVyKHN0cnVjdCBzZXBfZGV2aWNlICpzZXAsIHVuc2lnbmVkIGxvbmcgYXJnKQ0KLXsNCi0JaW50
IGVycm9yOw0KLQkvKiB2aXJ0dWFsIGFkZHJlc3Mgb2YgZGVzdCBhcHBsaWNhdGlvbiBidWZmZXIg
Ki8NCi0JdW5zaWduZWQgbG9uZyBhcHBfb3V0X2FkZHJlc3M7DQotCS8qIHZpcnR1YWwgYWRkcmVz
cyBvZiB0aGUgZGF0YSBwb29sICovDQotCXVuc2lnbmVkIGxvbmcgdmE7DQotCXZvaWQgKnZpcnRf
YWRkcmVzczsNCi0JdW5zaWduZWQgbG9uZyBudW1fYnl0ZXM7DQotCXZvaWQgKmRhdGFfcG9vbF9h
cmVhX2FkZHI7DQotDQotCWRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX3JlYWRfZnJvbV9k
YXRhX3Bvb2xfaGFuZGxlciBzdGFydFxuIik7DQotDQotCS8qIGdldCB0aGUgYXBwbGljYXRpb24g
YWRkcmVzcyAqLw0KLQllcnJvciA9IGdldF91c2VyKGFwcF9vdXRfYWRkcmVzcywgJigoKHN0cnVj
dCBzZXBfZHJpdmVyX3dyaXRlX3QgKikgYXJnKS0+YXBwX2FkZHJlc3MpKTsNCi0JaWYgKGVycm9y
KQ0KLQkJZ290byBlbmRfZnVuY3Rpb247DQotDQotCS8qIGdldCB0aGUgdmlydHVhbCBrZXJuZWwg
YWRkcmVzcyBhZGRyZXNzICovDQotCWVycm9yID0gZ2V0X3VzZXIodmEsICYoKChzdHJ1Y3Qgc2Vw
X2RyaXZlcl93cml0ZV90ICopIGFyZyktPmRhdGFwb29sX2FkZHJlc3MpKTsNCi0JaWYgKGVycm9y
KQ0KLQkJZ290byBlbmRfZnVuY3Rpb247DQotCXZpcnRfYWRkcmVzcyA9ICh2b2lkICopdmE7DQot
DQotCS8qIGdldCB0aGUgbnVtYmVyIG9mIGJ5dGVzICovDQotCWVycm9yID0gZ2V0X3VzZXIobnVt
X2J5dGVzLCAmKCgoc3RydWN0IHNlcF9kcml2ZXJfd3JpdGVfdCAqKSBhcmcpLT5udW1fYnl0ZXMp
KTsNCi0JaWYgKGVycm9yKQ0KLQkJZ290byBlbmRfZnVuY3Rpb247DQotDQotCS8qIGNhbGN1bGF0
ZSB0aGUgc3RhcnQgb2YgdGhlIGRhdGEgcG9vbCAqLw0KLQlkYXRhX3Bvb2xfYXJlYV9hZGRyID0g
c2VwLT5zaGFyZWRfYWRkciArIFNFUF9EUklWRVJfREFUQV9QT09MX0FSRUFfT0ZGU0VUX0lOX0JZ
VEVTOw0KLQ0KLQkvKiBGSVhNRTogVGhlc2UgYXJlIGluY29tcGxldGUgYWxsIG92ZXIgdGhlIGRy
aXZlcjogd2hhdCBhYm91dCArIGxlbg0KLQkgICBhbmQgd2hlbiBkb2luZyB0aGF0IGFsc28gb3Zl
cmZsb3dzICovDQotCS8qIGNoZWNrIHRoYXQgdGhlIHJhbmdlIG9mIHRoZSB2aXJ0dWFsIGtlcm5l
bCBhZGRyZXNzIGlzIGNvcnJlY3QgKi8NCi0JaWYgKHZpcnRfYWRkcmVzcyA8IGRhdGFfcG9vbF9h
cmVhX2FkZHIgfHwgdmlydF9hZGRyZXNzID4gZGF0YV9wb29sX2FyZWFfYWRkciArIFNFUF9EUklW
RVJfREFUQV9QT09MX1NIQVJFRF9BUkVBX1NJWkVfSU5fQllURVMpIHsNCi0JCWVycm9yID0gLUVJ
TlZBTDsNCi0JCWdvdG8gZW5kX2Z1bmN0aW9uOw0KLQl9DQotDQotCS8qIGNvcHkgdGhlIGFwcGxp
Y2F0aW9uIGRhdGEgKi8NCi0JZXJyb3IgPSBjb3B5X3RvX3VzZXIoKHZvaWQgKikgYXBwX291dF9h
ZGRyZXNzLCB2aXJ0X2FkZHJlc3MsIG51bV9ieXRlcyk7DQotZW5kX2Z1bmN0aW9uOg0KLQlkYmco
IlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9yZWFkX2Zyb21fZGF0YV9wb29sX2hhbmRsZXIgZW5k
XG4iKTsNCi0JcmV0dXJuIGVycm9yOw0KLX0NCi0NCi0vKg0KLSAgVGhpcyBmdW5jdGlvbiByZWxl
YXNlcyBhbGwgdGhlIGFwcGxpY2F0aW9uIHZpcnR1YWwgYnVmZmVyIHBoeXNpY2FsIHBhZ2VzLA0K
LQl0aGF0IHdlcmUgcHJldmlvdXNseSBsb2NrZWQNCi0qLw0KLXN0YXRpYyBpbnQgc2VwX2ZyZWVf
ZG1hX3BhZ2VzKHN0cnVjdCBwYWdlICoqcGFnZV9hcnJheV9wdHIsIHVuc2lnbmVkIGxvbmcgbnVt
X3BhZ2VzLCB1bnNpZ25lZCBsb25nIGRpcnR5RmxhZykNCi17DQotCXVuc2lnbmVkIGxvbmcgY291
bnQ7DQotDQotCWlmIChkaXJ0eUZsYWcpIHsNCi0JCWZvciAoY291bnQgPSAwOyBjb3VudCA8IG51
bV9wYWdlczsgY291bnQrKykgew0KLQkJCS8qIHRoZSBvdXQgYXJyYXkgd2FzIHdyaXR0ZW4sIHRo
ZXJlZm9yZSB0aGUgZGF0YSB3YXMgY2hhbmdlZCAqLw0KLQkJCWlmICghUGFnZVJlc2VydmVkKHBh
Z2VfYXJyYXlfcHRyW2NvdW50XSkpDQotCQkJCVNldFBhZ2VEaXJ0eShwYWdlX2FycmF5X3B0cltj
b3VudF0pOw0KLQkJCXBhZ2VfY2FjaGVfcmVsZWFzZShwYWdlX2FycmF5X3B0cltjb3VudF0pOw0K
LQkJfQ0KLQl9IGVsc2Ugew0KLQkJLyogZnJlZSBpbiBwYWdlcyAtIHRoZSBkYXRhIHdhcyBvbmx5
IHJlYWQsIHRoZXJlZm9yZSBubyB1cGRhdGUgd2FzIGRvbmUNCi0JCSAgIG9uIHRob3NlIHBhZ2Vz
ICovDQotCQlmb3IgKGNvdW50ID0gMDsgY291bnQgPCBudW1fcGFnZXM7IGNvdW50KyspDQotCQkJ
cGFnZV9jYWNoZV9yZWxlYXNlKHBhZ2VfYXJyYXlfcHRyW2NvdW50XSk7DQotCX0NCi0NCi0JaWYg
KHBhZ2VfYXJyYXlfcHRyKQ0KLQkJLyogZnJlZSB0aGUgYXJyYXkgKi8NCi0JCWtmcmVlKHBhZ2Vf
YXJyYXlfcHRyKTsNCi0NCi0JcmV0dXJuIDA7DQotfQ0KLQ0KLS8qDQotICBUaGlzIGZ1bmN0aW9u
IGxvY2tzIGFsbCB0aGUgcGh5c2ljYWwgcGFnZXMgb2YgdGhlIGtlcm5lbCB2aXJ0dWFsIGJ1ZmZl
cg0KLSAgYW5kIGNvbnN0cnVjdCBhIGJhc2ljIGxsaSAgYXJyYXksIHdoZXJlIGVhY2ggZW50cnkg
aG9sZHMgdGhlIHBoeXNpY2FsDQotICBwYWdlIGFkZHJlc3MgYW5kIHRoZSBzaXplIHRoYXQgYXBw
bGljYXRpb24gZGF0YSBob2xkcyBpbiB0aGlzIHBoeXNpY2FsIHBhZ2VzDQotKi8NCi1zdGF0aWMg
aW50IHNlcF9sb2NrX2tlcm5lbF9wYWdlcyhzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwLA0KLQkJCQkg
dW5zaWduZWQgbG9uZyBrZXJuZWxfdmlydF9hZGRyLA0KLQkJCQkgdW5zaWduZWQgbG9uZyBkYXRh
X3NpemUsDQotCQkJCSB1bnNpZ25lZCBsb25nICpudW1fcGFnZXNfcHRyLA0KLQkJCQkgc3RydWN0
IHNlcF9sbGlfZW50cnlfdCAqKmxsaV9hcnJheV9wdHIsDQotCQkJCSBzdHJ1Y3QgcGFnZSAqKipw
YWdlX2FycmF5X3B0cikNCi17DQotCWludCBlcnJvciA9IDA7DQotCS8qIHRoZSB0aGUgcGFnZSBv
ZiB0aGUgZW5kIGFkZHJlc3Mgb2YgdGhlIHVzZXIgc3BhY2UgYnVmZmVyICovDQotCXVuc2lnbmVk
IGxvbmcgZW5kX3BhZ2U7DQotCS8qIHRoZSBwYWdlIG9mIHRoZSBzdGFydCBhZGRyZXNzIG9mIHRo
ZSB1c2VyIHNwYWNlIGJ1ZmZlciAqLw0KLQl1bnNpZ25lZCBsb25nIHN0YXJ0X3BhZ2U7DQotCS8q
IHRoZSByYW5nZSBpbiBwYWdlcyAqLw0KLQl1bnNpZ25lZCBsb25nIG51bV9wYWdlczsNCi0Jc3Ry
dWN0IHNlcF9sbGlfZW50cnlfdCAqbGxpX2FycmF5Ow0KLQkvKiBuZXh0IGtlcm5lbCBhZGRyZXNz
IHRvIG1hcCAqLw0KLQl1bnNpZ25lZCBsb25nIG5leHRfa2VybmVsX2FkZHJlc3M7DQotCXVuc2ln
bmVkIGxvbmcgY291bnQ7DQotDQotCWRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX2xvY2tf
a2VybmVsX3BhZ2VzIHN0YXJ0XG4iKTsNCi0NCi0JLyogc2V0IHN0YXJ0IGFuZCBlbmQgcGFnZXMg
IGFuZCBudW0gcGFnZXMgKi8NCi0JZW5kX3BhZ2UgPSAoa2VybmVsX3ZpcnRfYWRkciArIGRhdGFf
c2l6ZSAtIDEpID4+IFBBR0VfU0hJRlQ7DQotCXN0YXJ0X3BhZ2UgPSBrZXJuZWxfdmlydF9hZGRy
ID4+IFBBR0VfU0hJRlQ7DQotCW51bV9wYWdlcyA9IGVuZF9wYWdlIC0gc3RhcnRfcGFnZSArIDE7
DQotDQotCWVkYmcoIlNFUCBEcml2ZXI6IGtlcm5lbF92aXJ0X2FkZHIgaXMgJTA4bHhcbiIsIGtl
cm5lbF92aXJ0X2FkZHIpOw0KLQllZGJnKCJTRVAgRHJpdmVyOiBkYXRhX3NpemUgaXMgJWx1XG4i
LCBkYXRhX3NpemUpOw0KLQllZGJnKCJTRVAgRHJpdmVyOiBzdGFydF9wYWdlIGlzICVseFxuIiwg
c3RhcnRfcGFnZSk7DQotCWVkYmcoIlNFUCBEcml2ZXI6IGVuZF9wYWdlIGlzICVseFxuIiwgZW5k
X3BhZ2UpOw0KLQllZGJnKCJTRVAgRHJpdmVyOiBudW1fcGFnZXMgaXMgJWx1XG4iLCBudW1fcGFn
ZXMpOw0KLQ0KLQlsbGlfYXJyYXkgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3Qgc2VwX2xsaV9lbnRy
eV90KSAqIG51bV9wYWdlcywgR0ZQX0FUT01JQyk7DQotCWlmICghbGxpX2FycmF5KSB7DQotCQll
ZGJnKCJTRVAgRHJpdmVyOiBrbWFsbG9jIGZvciBsbGlfYXJyYXkgZmFpbGVkXG4iKTsNCi0JCWVy
cm9yID0gLUVOT01FTTsNCi0JCWdvdG8gZW5kX2Z1bmN0aW9uOw0KLQl9DQotDQotCS8qIHNldCB0
aGUgc3RhcnQgYWRkcmVzcyBvZiB0aGUgZmlyc3QgcGFnZSAtIGFwcCBkYXRhIG1heSBzdGFydCBu
b3QgYXQNCi0JICAgdGhlIGJlZ2lubmluZyBvZiB0aGUgcGFnZSAqLw0KLQlsbGlfYXJyYXlbMF0u
cGh5c2ljYWxfYWRkcmVzcyA9ICh1bnNpZ25lZCBsb25nKSB2aXJ0X3RvX3BoeXMoKHVuc2lnbmVk
IGxvbmcgKikga2VybmVsX3ZpcnRfYWRkcik7DQotDQotCS8qIGNoZWNrIHRoYXQgbm90IGFsbCB0
aGUgZGF0YSBpcyBpbiB0aGUgZmlyc3QgcGFnZSBvbmx5ICovDQotCWlmICgoUEFHRV9TSVpFIC0g
KGtlcm5lbF92aXJ0X2FkZHIgJiAoflBBR0VfTUFTSykpKSA+PSBkYXRhX3NpemUpDQotCQlsbGlf
YXJyYXlbMF0uYmxvY2tfc2l6ZSA9IGRhdGFfc2l6ZTsNCi0JZWxzZQ0KLQkJbGxpX2FycmF5WzBd
LmJsb2NrX3NpemUgPSBQQUdFX1NJWkUgLSAoa2VybmVsX3ZpcnRfYWRkciAmICh+UEFHRV9NQVNL
KSk7DQotDQotCS8qIGRlYnVnIHByaW50ICovDQotCWRiZygibGxpX2FycmF5WzBdLnBoeXNpY2Fs
X2FkZHJlc3MgaXMgJTA4bHgsIGxsaV9hcnJheVswXS5ibG9ja19zaXplIGlzICVsdVxuIiwgbGxp
X2FycmF5WzBdLnBoeXNpY2FsX2FkZHJlc3MsIGxsaV9hcnJheVswXS5ibG9ja19zaXplKTsNCi0N
Ci0JLyogYWR2YW5jZSB0aGUgYWRkcmVzcyB0byB0aGUgc3RhcnQgb2YgdGhlIG5leHQgcGFnZSAq
Lw0KLQluZXh0X2tlcm5lbF9hZGRyZXNzID0gKGtlcm5lbF92aXJ0X2FkZHIgJiBQQUdFX01BU0sp
ICsgUEFHRV9TSVpFOw0KLQ0KLQkvKiBnbyBmcm9tIHRoZSBzZWNvbmQgcGFnZSB0byB0aGUgcHJl
diBiZWZvcmUgbGFzdCAqLw0KLQlmb3IgKGNvdW50ID0gMTsgY291bnQgPCAobnVtX3BhZ2VzIC0g
MSk7IGNvdW50KyspIHsNCi0JCWxsaV9hcnJheVtjb3VudF0ucGh5c2ljYWxfYWRkcmVzcyA9ICh1
bnNpZ25lZCBsb25nKSB2aXJ0X3RvX3BoeXMoKHVuc2lnbmVkIGxvbmcgKikgbmV4dF9rZXJuZWxf
YWRkcmVzcyk7DQotCQlsbGlfYXJyYXlbY291bnRdLmJsb2NrX3NpemUgPSBQQUdFX1NJWkU7DQot
DQotCQllZGJnKCJsbGlfYXJyYXlbJWx1XS5waHlzaWNhbF9hZGRyZXNzIGlzICUwOGx4LCBsbGlf
YXJyYXlbJWx1XS5ibG9ja19zaXplIGlzICVsdVxuIiwgY291bnQsIGxsaV9hcnJheVtjb3VudF0u
cGh5c2ljYWxfYWRkcmVzcywgY291bnQsIGxsaV9hcnJheVtjb3VudF0uYmxvY2tfc2l6ZSk7DQot
CQluZXh0X2tlcm5lbF9hZGRyZXNzICs9IFBBR0VfU0laRTsNCi0JfQ0KLQ0KLQkvKiBpZiBtb3Jl
IHRoZW4gMSBwYWdlcyBsb2NrZWQgLSB0aGVuIHVwZGF0ZSBmb3IgdGhlIGxhc3QgcGFnZSBzaXpl
IG5lZWRlZCAqLw0KLQlpZiAobnVtX3BhZ2VzID4gMSkgew0KLQkJLyogdXBkYXRlIHRoZSBhZGRy
ZXNzIG9mIHRoZSBsYXN0IHBhZ2UgKi8NCi0JCWxsaV9hcnJheVtjb3VudF0ucGh5c2ljYWxfYWRk
cmVzcyA9ICh1bnNpZ25lZCBsb25nKSB2aXJ0X3RvX3BoeXMoKHVuc2lnbmVkIGxvbmcgKikgbmV4
dF9rZXJuZWxfYWRkcmVzcyk7DQotDQotCQkvKiBzZXQgdGhlIHNpemUgb2YgdGhlIGxhc3QgcGFn
ZSAqLw0KLQkJbGxpX2FycmF5W2NvdW50XS5ibG9ja19zaXplID0gKGtlcm5lbF92aXJ0X2FkZHIg
KyBkYXRhX3NpemUpICYgKH5QQUdFX01BU0spOw0KLQ0KLQkJaWYgKGxsaV9hcnJheVtjb3VudF0u
YmxvY2tfc2l6ZSA9PSAwKSB7DQotCQkJZGJnKCJhcHBfdmlydF9hZGRyIGlzICUwOGx4XG4iLCBr
ZXJuZWxfdmlydF9hZGRyKTsNCi0JCQlkYmcoImRhdGFfc2l6ZSBpcyAlbHVcbiIsIGRhdGFfc2l6
ZSk7DQotCQkJd2hpbGUgKDEpOw0KLQkJfQ0KLQ0KLQkJZWRiZygibGxpX2FycmF5WyVsdV0ucGh5
c2ljYWxfYWRkcmVzcyBpcyAlMDhseCwgbGxpX2FycmF5WyVsdV0uYmxvY2tfc2l6ZSBpcyAlbHVc
biIsIGNvdW50LCBsbGlfYXJyYXlbY291bnRdLnBoeXNpY2FsX2FkZHJlc3MsIGNvdW50LCBsbGlf
YXJyYXlbY291bnRdLmJsb2NrX3NpemUpOw0KLQl9DQotCS8qIHNldCBvdXRwdXQgcGFyYW1zICov
DQotCSpsbGlfYXJyYXlfcHRyID0gbGxpX2FycmF5Ow0KLQkqbnVtX3BhZ2VzX3B0ciA9IG51bV9w
YWdlczsNCi0JKnBhZ2VfYXJyYXlfcHRyID0gMDsNCi1lbmRfZnVuY3Rpb246DQotCWRiZygiU0VQ
IERyaXZlcjo8LS0tLS0tLS0gc2VwX2xvY2tfa2VybmVsX3BhZ2VzIGVuZFxuIik7DQotCXJldHVy
biAwOw0KLX0NCi0NCi0vKg0KLSAgVGhpcyBmdW5jdGlvbiBsb2NrcyBhbGwgdGhlIHBoeXNpY2Fs
IHBhZ2VzIG9mIHRoZSBhcHBsaWNhdGlvbiB2aXJ0dWFsIGJ1ZmZlcg0KLSAgYW5kIGNvbnN0cnVj
dCBhIGJhc2ljIGxsaSAgYXJyYXksIHdoZXJlIGVhY2ggZW50cnkgaG9sZHMgdGhlIHBoeXNpY2Fs
IHBhZ2UNCi0gIGFkZHJlc3MgYW5kIHRoZSBzaXplIHRoYXQgYXBwbGljYXRpb24gZGF0YSBob2xk
cyBpbiB0aGlzIHBoeXNpY2FsIHBhZ2VzDQotKi8NCi1zdGF0aWMgaW50IHNlcF9sb2NrX3VzZXJf
cGFnZXMoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCwNCi0JCQl1bnNpZ25lZCBsb25nIGFwcF92aXJ0
X2FkZHIsDQotCQkJdW5zaWduZWQgbG9uZyBkYXRhX3NpemUsDQotCQkJdW5zaWduZWQgbG9uZyAq
bnVtX3BhZ2VzX3B0ciwNCi0JCQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90ICoqbGxpX2FycmF5X3B0
ciwNCi0JCQlzdHJ1Y3QgcGFnZSAqKipwYWdlX2FycmF5X3B0cikNCi17DQotCWludCBlcnJvciA9
IDA7DQotCS8qIHRoZSB0aGUgcGFnZSBvZiB0aGUgZW5kIGFkZHJlc3Mgb2YgdGhlIHVzZXIgc3Bh
Y2UgYnVmZmVyICovDQotCXVuc2lnbmVkIGxvbmcgZW5kX3BhZ2U7DQotCS8qIHRoZSBwYWdlIG9m
IHRoZSBzdGFydCBhZGRyZXNzIG9mIHRoZSB1c2VyIHNwYWNlIGJ1ZmZlciAqLw0KLQl1bnNpZ25l
ZCBsb25nIHN0YXJ0X3BhZ2U7DQotCS8qIHRoZSByYW5nZSBpbiBwYWdlcyAqLw0KLQl1bnNpZ25l
ZCBsb25nIG51bV9wYWdlczsNCi0Jc3RydWN0IHBhZ2UgKipwYWdlX2FycmF5Ow0KLQlzdHJ1Y3Qg
c2VwX2xsaV9lbnRyeV90ICpsbGlfYXJyYXk7DQotCXVuc2lnbmVkIGxvbmcgY291bnQ7DQotCWlu
dCByZXN1bHQ7DQotDQotCWRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX2xvY2tfdXNlcl9w
YWdlcyBzdGFydFxuIik7DQotDQotCS8qIHNldCBzdGFydCBhbmQgZW5kIHBhZ2VzICBhbmQgbnVt
IHBhZ2VzICovDQotCWVuZF9wYWdlID0gKGFwcF92aXJ0X2FkZHIgKyBkYXRhX3NpemUgLSAxKSA+
PiBQQUdFX1NISUZUOw0KLQlzdGFydF9wYWdlID0gYXBwX3ZpcnRfYWRkciA+PiBQQUdFX1NISUZU
Ow0KLQludW1fcGFnZXMgPSBlbmRfcGFnZSAtIHN0YXJ0X3BhZ2UgKyAxOw0KLQ0KLQllZGJnKCJT
RVAgRHJpdmVyOiBhcHBfdmlydF9hZGRyIGlzICUwOGx4XG4iLCBhcHBfdmlydF9hZGRyKTsNCi0J
ZWRiZygiU0VQIERyaXZlcjogZGF0YV9zaXplIGlzICVsdVxuIiwgZGF0YV9zaXplKTsNCi0JZWRi
ZygiU0VQIERyaXZlcjogc3RhcnRfcGFnZSBpcyAlbHVcbiIsIHN0YXJ0X3BhZ2UpOw0KLQllZGJn
KCJTRVAgRHJpdmVyOiBlbmRfcGFnZSBpcyAlbHVcbiIsIGVuZF9wYWdlKTsNCi0JZWRiZygiU0VQ
IERyaXZlcjogbnVtX3BhZ2VzIGlzICVsdVxuIiwgbnVtX3BhZ2VzKTsNCi0NCi0JLyogYWxsb2Nh
dGUgYXJyYXkgb2YgcGFnZXMgc3RydWN0dXJlIHBvaW50ZXJzICovDQotCXBhZ2VfYXJyYXkgPSBr
bWFsbG9jKHNpemVvZihzdHJ1Y3QgcGFnZSAqKSAqIG51bV9wYWdlcywgR0ZQX0FUT01JQyk7DQot
CWlmICghcGFnZV9hcnJheSkgew0KLQkJZWRiZygiU0VQIERyaXZlcjoga21hbGxvYyBmb3IgcGFn
ZV9hcnJheSBmYWlsZWRcbiIpOw0KLQ0KLQkJZXJyb3IgPSAtRU5PTUVNOw0KLQkJZ290byBlbmRf
ZnVuY3Rpb247DQotCX0NCi0NCi0JbGxpX2FycmF5ID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IHNl
cF9sbGlfZW50cnlfdCkgKiBudW1fcGFnZXMsIEdGUF9BVE9NSUMpOw0KLQlpZiAoIWxsaV9hcnJh
eSkgew0KLQkJZWRiZygiU0VQIERyaXZlcjoga21hbGxvYyBmb3IgbGxpX2FycmF5IGZhaWxlZFxu
Iik7DQotDQotCQllcnJvciA9IC1FTk9NRU07DQotCQlnb3RvIGVuZF9mdW5jdGlvbl93aXRoX2Vy
cm9yMTsNCi0JfQ0KLQ0KLQkvKiBjb252ZXJ0IHRoZSBhcHBsaWNhdGlvbiB2aXJ0dWFsIGFkZHJl
c3MgaW50byBhIHNldCBvZiBwaHlzaWNhbCAqLw0KLQlkb3duX3JlYWQoJmN1cnJlbnQtPm1tLT5t
bWFwX3NlbSk7DQotCXJlc3VsdCA9IGdldF91c2VyX3BhZ2VzKGN1cnJlbnQsIGN1cnJlbnQtPm1t
LCBhcHBfdmlydF9hZGRyLCBudW1fcGFnZXMsIDEsIDAsIHBhZ2VfYXJyYXksIDApOw0KLQl1cF9y
ZWFkKCZjdXJyZW50LT5tbS0+bW1hcF9zZW0pOw0KLQ0KLQkvKiBjaGVjayB0aGUgbnVtYmVyIG9m
IHBhZ2VzIGxvY2tlZCAtIGlmIG5vdCBhbGwgdGhlbiBleGl0IHdpdGggZXJyb3IgKi8NCi0JaWYg
KHJlc3VsdCAhPSBudW1fcGFnZXMpIHsNCi0JCWRiZygiU0VQIERyaXZlcjogbm90IGFsbCBwYWdl
cyBsb2NrZWQgYnkgZ2V0X3VzZXJfcGFnZXNcbiIpOw0KLQ0KLQkJZXJyb3IgPSAtRU5PTUVNOw0K
LQkJZ290byBlbmRfZnVuY3Rpb25fd2l0aF9lcnJvcjI7DQotCX0NCi0NCi0JLyogZmx1c2ggdGhl
IGNhY2hlICovDQotCWZvciAoY291bnQgPSAwOyBjb3VudCA8IG51bV9wYWdlczsgY291bnQrKykN
Ci0JCWZsdXNoX2RjYWNoZV9wYWdlKHBhZ2VfYXJyYXlbY291bnRdKTsNCi0NCi0JLyogc2V0IHRo
ZSBzdGFydCBhZGRyZXNzIG9mIHRoZSBmaXJzdCBwYWdlIC0gYXBwIGRhdGEgbWF5IHN0YXJ0IG5v
dCBhdA0KLQkgICB0aGUgYmVnaW5uaW5nIG9mIHRoZSBwYWdlICovDQotCWxsaV9hcnJheVswXS5w
aHlzaWNhbF9hZGRyZXNzID0gKCh1bnNpZ25lZCBsb25nKSBwYWdlX3RvX3BoeXMocGFnZV9hcnJh
eVswXSkpICsgKGFwcF92aXJ0X2FkZHIgJiAoflBBR0VfTUFTSykpOw0KLQ0KLQkvKiBjaGVjayB0
aGF0IG5vdCBhbGwgdGhlIGRhdGEgaXMgaW4gdGhlIGZpcnN0IHBhZ2Ugb25seSAqLw0KLQlpZiAo
KFBBR0VfU0laRSAtIChhcHBfdmlydF9hZGRyICYgKH5QQUdFX01BU0spKSkgPj0gZGF0YV9zaXpl
KQ0KLQkJbGxpX2FycmF5WzBdLmJsb2NrX3NpemUgPSBkYXRhX3NpemU7DQotCWVsc2UNCi0JCWxs
aV9hcnJheVswXS5ibG9ja19zaXplID0gUEFHRV9TSVpFIC0gKGFwcF92aXJ0X2FkZHIgJiAoflBB
R0VfTUFTSykpOw0KLQ0KLQkvKiBkZWJ1ZyBwcmludCAqLw0KLQlkYmcoImxsaV9hcnJheVswXS5w
aHlzaWNhbF9hZGRyZXNzIGlzICUwOGx4LCBsbGlfYXJyYXlbMF0uYmxvY2tfc2l6ZSBpcyAlbHVc
biIsIGxsaV9hcnJheVswXS5waHlzaWNhbF9hZGRyZXNzLCBsbGlfYXJyYXlbMF0uYmxvY2tfc2l6
ZSk7DQotDQotCS8qIGdvIGZyb20gdGhlIHNlY29uZCBwYWdlIHRvIHRoZSBwcmV2IGJlZm9yZSBs
YXN0ICovDQotCWZvciAoY291bnQgPSAxOyBjb3VudCA8IChudW1fcGFnZXMgLSAxKTsgY291bnQr
Kykgew0KLQkJbGxpX2FycmF5W2NvdW50XS5waHlzaWNhbF9hZGRyZXNzID0gKHVuc2lnbmVkIGxv
bmcpIHBhZ2VfdG9fcGh5cyhwYWdlX2FycmF5W2NvdW50XSk7DQotCQlsbGlfYXJyYXlbY291bnRd
LmJsb2NrX3NpemUgPSBQQUdFX1NJWkU7DQotDQotCQllZGJnKCJsbGlfYXJyYXlbJWx1XS5waHlz
aWNhbF9hZGRyZXNzIGlzICUwOGx4LCBsbGlfYXJyYXlbJWx1XS5ibG9ja19zaXplIGlzICVsdVxu
IiwgY291bnQsIGxsaV9hcnJheVtjb3VudF0ucGh5c2ljYWxfYWRkcmVzcywgY291bnQsIGxsaV9h
cnJheVtjb3VudF0uYmxvY2tfc2l6ZSk7DQotCX0NCi0NCi0JLyogaWYgbW9yZSB0aGVuIDEgcGFn
ZXMgbG9ja2VkIC0gdGhlbiB1cGRhdGUgZm9yIHRoZSBsYXN0IHBhZ2Ugc2l6ZSBuZWVkZWQgKi8N
Ci0JaWYgKG51bV9wYWdlcyA+IDEpIHsNCi0JCS8qIHVwZGF0ZSB0aGUgYWRkcmVzcyBvZiB0aGUg
bGFzdCBwYWdlICovDQotCQlsbGlfYXJyYXlbY291bnRdLnBoeXNpY2FsX2FkZHJlc3MgPSAodW5z
aWduZWQgbG9uZykgcGFnZV90b19waHlzKHBhZ2VfYXJyYXlbY291bnRdKTsNCi0NCi0JCS8qIHNl
dCB0aGUgc2l6ZSBvZiB0aGUgbGFzdCBwYWdlICovDQotCQlsbGlfYXJyYXlbY291bnRdLmJsb2Nr
X3NpemUgPSAoYXBwX3ZpcnRfYWRkciArIGRhdGFfc2l6ZSkgJiAoflBBR0VfTUFTSyk7DQotDQot
CQlpZiAobGxpX2FycmF5W2NvdW50XS5ibG9ja19zaXplID09IDApIHsNCi0JCQlkYmcoImFwcF92
aXJ0X2FkZHIgaXMgJTA4bHhcbiIsIGFwcF92aXJ0X2FkZHIpOw0KLQkJCWRiZygiZGF0YV9zaXpl
IGlzICVsdVxuIiwgZGF0YV9zaXplKTsNCi0JCQl3aGlsZSAoMSk7DQotCQl9DQotCQllZGJnKCJs
bGlfYXJyYXlbJWx1XS5waHlzaWNhbF9hZGRyZXNzIGlzICUwOGx4LCBsbGlfYXJyYXlbJWx1XS5i
bG9ja19zaXplIGlzICVsdVxuIiwNCi0JCSAgICAgY291bnQsIGxsaV9hcnJheVtjb3VudF0ucGh5
c2ljYWxfYWRkcmVzcywNCi0JCSAgICAgY291bnQsIGxsaV9hcnJheVtjb3VudF0uYmxvY2tfc2l6
ZSk7DQotCX0NCi0NCi0JLyogc2V0IG91dHB1dCBwYXJhbXMgKi8NCi0JKmxsaV9hcnJheV9wdHIg
PSBsbGlfYXJyYXk7DQotCSpudW1fcGFnZXNfcHRyID0gbnVtX3BhZ2VzOw0KLQkqcGFnZV9hcnJh
eV9wdHIgPSBwYWdlX2FycmF5Ow0KLQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0NCi1lbmRfZnVuY3Rp
b25fd2l0aF9lcnJvcjI6DQotCS8qIHJlbGVhc2UgdGhlIGNhY2hlICovDQotCWZvciAoY291bnQg
PSAwOyBjb3VudCA8IG51bV9wYWdlczsgY291bnQrKykNCi0JCXBhZ2VfY2FjaGVfcmVsZWFzZShw
YWdlX2FycmF5W2NvdW50XSk7DQotCWtmcmVlKGxsaV9hcnJheSk7DQotZW5kX2Z1bmN0aW9uX3dp
dGhfZXJyb3IxOg0KLQlrZnJlZShwYWdlX2FycmF5KTsNCi1lbmRfZnVuY3Rpb246DQotCWRiZygi
U0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX2xvY2tfdXNlcl9wYWdlcyBlbmRcbiIpOw0KLQlyZXR1
cm4gMDsNCi19DQotDQotDQotLyoNCi0gIHRoaXMgZnVuY3Rpb24gY2FsY3VsYXRlcyB0aGUgc2l6
ZSBvZiBkYXRhIHRoYXQgY2FuIGJlIGluc2VydGVkIGludG8gdGhlIGxsaQ0KLSAgdGFibGUgZnJv
bSB0aGlzIGFycmF5IHRoZSBjb25kaXRpb24gaXMgdGhhdCBlaXRoZXIgdGhlIHRhYmxlIGlzIGZ1
bGwNCi0gIChhbGwgZXRucmllcyBhcmUgZW50ZXJlZCksIG9yIHRoZXJlIGFyZSBubyBtb3JlIGVu
dHJpZXMgaW4gdGhlIGxsaSBhcnJheQ0KLSovDQotc3RhdGljIHVuc2lnbmVkIGxvbmcgc2VwX2Nh
bGN1bGF0ZV9sbGlfdGFibGVfbWF4X3NpemUoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqbGxpX2lu
X2FycmF5X3B0ciwgdW5zaWduZWQgbG9uZyBudW1fYXJyYXlfZW50cmllcykNCi17DQotCXVuc2ln
bmVkIGxvbmcgdGFibGVfZGF0YV9zaXplID0gMDsNCi0JdW5zaWduZWQgbG9uZyBjb3VudGVyOw0K
LQ0KLQkvKiBjYWxjdWxhdGUgdGhlIGRhdGEgaW4gdGhlIG91dCBsbGkgdGFibGUgaWYgdGlsbCB3
ZSBmaWxsIHRoZSB3aG9sZQ0KLQkgICB0YWJsZSBvciB0aWxsIHRoZSBkYXRhIGhhcyBlbmRlZCAq
Lw0KLQlmb3IgKGNvdW50ZXIgPSAwOyAoY291bnRlciA8IChTRVBfRFJJVkVSX0VOVFJJRVNfUEVS
X1RBQkxFX0lOX1NFUCAtIDEpKSAmJiAoY291bnRlciA8IG51bV9hcnJheV9lbnRyaWVzKTsgY291
bnRlcisrKQ0KLQkJdGFibGVfZGF0YV9zaXplICs9IGxsaV9pbl9hcnJheV9wdHJbY291bnRlcl0u
YmxvY2tfc2l6ZTsNCi0JcmV0dXJuIHRhYmxlX2RhdGFfc2l6ZTsNCi19DQotDQotLyoNCi0gIHRo
aXMgZnVuY3Rpb25zIGJ1aWxkcyBvbnQgbGxpIHRhYmxlIGZyb20gdGhlIGxsaV9hcnJheSBhY2Nv
cmRpbmcgdG8NCi0gIHRoZSBnaXZlbiBzaXplIG9mIGRhdGENCi0qLw0KLXN0YXRpYyB2b2lkIHNl
cF9idWlsZF9sbGlfdGFibGUoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqbGxpX2FycmF5X3B0ciwg
c3RydWN0IHNlcF9sbGlfZW50cnlfdCAqbGxpX3RhYmxlX3B0ciwgdW5zaWduZWQgbG9uZyAqbnVt
X3Byb2Nlc3NlZF9lbnRyaWVzX3B0ciwgdW5zaWduZWQgbG9uZyAqbnVtX3RhYmxlX2VudHJpZXNf
cHRyLCB1bnNpZ25lZCBsb25nIHRhYmxlX2RhdGFfc2l6ZSkNCi17DQotCXVuc2lnbmVkIGxvbmcg
Y3Vycl90YWJsZV9kYXRhX3NpemU7DQotCS8qIGNvdW50ZXIgb2YgbGxpIGFycmF5IGVudHJ5ICov
DQotCXVuc2lnbmVkIGxvbmcgYXJyYXlfY291bnRlcjsNCi0NCi0JZGJnKCJTRVAgRHJpdmVyOi0t
LS0tLS0tPiBzZXBfYnVpbGRfbGxpX3RhYmxlIHN0YXJ0XG4iKTsNCi0NCi0JLyogaW5pdCBjdXJy
cmVudCB0YWJsZSBkYXRhIHNpemUgYW5kIGxsaSBhcnJheSBlbnRyeSBjb3VudGVyICovDQotCWN1
cnJfdGFibGVfZGF0YV9zaXplID0gMDsNCi0JYXJyYXlfY291bnRlciA9IDA7DQotCSpudW1fdGFi
bGVfZW50cmllc19wdHIgPSAxOw0KLQ0KLQllZGJnKCJTRVAgRHJpdmVyOnRhYmxlX2RhdGFfc2l6
ZSBpcyAlbHVcbiIsIHRhYmxlX2RhdGFfc2l6ZSk7DQotDQotCS8qIGZpbGwgdGhlIHRhYmxlIHRp
bGwgdGFibGUgc2l6ZSByZWFjaGVzIHRoZSBuZWVkZWQgYW1vdW50ICovDQotCXdoaWxlIChjdXJy
X3RhYmxlX2RhdGFfc2l6ZSA8IHRhYmxlX2RhdGFfc2l6ZSkgew0KLQkJLyogdXBkYXRlIHRoZSBu
dW1iZXIgb2YgZW50cmllcyBpbiB0YWJsZSAqLw0KLQkJKCpudW1fdGFibGVfZW50cmllc19wdHIp
Kys7DQotDQotCQlsbGlfdGFibGVfcHRyLT5waHlzaWNhbF9hZGRyZXNzID0gbGxpX2FycmF5X3B0
clthcnJheV9jb3VudGVyXS5waHlzaWNhbF9hZGRyZXNzOw0KLQkJbGxpX3RhYmxlX3B0ci0+Ymxv
Y2tfc2l6ZSA9IGxsaV9hcnJheV9wdHJbYXJyYXlfY291bnRlcl0uYmxvY2tfc2l6ZTsNCi0JCWN1
cnJfdGFibGVfZGF0YV9zaXplICs9IGxsaV90YWJsZV9wdHItPmJsb2NrX3NpemU7DQotDQotCQll
ZGJnKCJTRVAgRHJpdmVyOmxsaV90YWJsZV9wdHIgaXMgJTA4bHhcbiIsICh1bnNpZ25lZCBsb25n
KSBsbGlfdGFibGVfcHRyKTsNCi0JCWVkYmcoIlNFUCBEcml2ZXI6bGxpX3RhYmxlX3B0ci0+cGh5
c2ljYWxfYWRkcmVzcyBpcyAlMDhseFxuIiwgbGxpX3RhYmxlX3B0ci0+cGh5c2ljYWxfYWRkcmVz
cyk7DQotCQllZGJnKCJTRVAgRHJpdmVyOmxsaV90YWJsZV9wdHItPmJsb2NrX3NpemUgaXMgJWx1
XG4iLCBsbGlfdGFibGVfcHRyLT5ibG9ja19zaXplKTsNCi0NCi0JCS8qIGNoZWNrIGZvciBvdmVy
ZmxvdyBvZiB0aGUgdGFibGUgZGF0YSAqLw0KLQkJaWYgKGN1cnJfdGFibGVfZGF0YV9zaXplID4g
dGFibGVfZGF0YV9zaXplKSB7DQotCQkJZWRiZygiU0VQIERyaXZlcjpjdXJyX3RhYmxlX2RhdGFf
c2l6ZSA+IHRhYmxlX2RhdGFfc2l6ZVxuIik7DQotDQotCQkJLyogdXBkYXRlIHRoZSBzaXplIG9m
IGJsb2NrIGluIHRoZSB0YWJsZSAqLw0KLQkJCWxsaV90YWJsZV9wdHItPmJsb2NrX3NpemUgLT0g
KGN1cnJfdGFibGVfZGF0YV9zaXplIC0gdGFibGVfZGF0YV9zaXplKTsNCi0NCi0JCQkvKiB1cGRh
dGUgdGhlIHBoeXNpY2FsIGFkZHJlc3MgaW4gdGhlIGxsaSBhcnJheSAqLw0KLQkJCWxsaV9hcnJh
eV9wdHJbYXJyYXlfY291bnRlcl0ucGh5c2ljYWxfYWRkcmVzcyArPSBsbGlfdGFibGVfcHRyLT5i
bG9ja19zaXplOw0KLQ0KLQkJCS8qIHVwZGF0ZSB0aGUgYmxvY2sgc2l6ZSBsZWZ0IGluIHRoZSBs
bGkgYXJyYXkgKi8NCi0JCQlsbGlfYXJyYXlfcHRyW2FycmF5X2NvdW50ZXJdLmJsb2NrX3NpemUg
PSAoY3Vycl90YWJsZV9kYXRhX3NpemUgLSB0YWJsZV9kYXRhX3NpemUpOw0KLQkJfSBlbHNlDQot
CQkJLyogYWR2YW5jZSB0byB0aGUgbmV4dCBlbnRyeSBpbiB0aGUgbGxpX2FycmF5ICovDQotCQkJ
YXJyYXlfY291bnRlcisrOw0KLQ0KLQkJZWRiZygiU0VQIERyaXZlcjpsbGlfdGFibGVfcHRyLT5w
aHlzaWNhbF9hZGRyZXNzIGlzICUwOGx4XG4iLCBsbGlfdGFibGVfcHRyLT5waHlzaWNhbF9hZGRy
ZXNzKTsNCi0JCWVkYmcoIlNFUCBEcml2ZXI6bGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSBpcyAl
bHVcbiIsIGxsaV90YWJsZV9wdHItPmJsb2NrX3NpemUpOw0KLQ0KLQkJLyogbW92ZSB0byB0aGUg
bmV4dCBlbnRyeSBpbiB0YWJsZSAqLw0KLQkJbGxpX3RhYmxlX3B0cisrOw0KLQl9DQotDQotCS8q
IHNldCB0aGUgaW5mbyBlbnRyeSB0byBkZWZhdWx0ICovDQotCWxsaV90YWJsZV9wdHItPnBoeXNp
Y2FsX2FkZHJlc3MgPSAweGZmZmZmZmZmOw0KLQlsbGlfdGFibGVfcHRyLT5ibG9ja19zaXplID0g
MDsNCi0NCi0JZWRiZygiU0VQIERyaXZlcjpsbGlfdGFibGVfcHRyIGlzICUwOGx4XG4iLCAodW5z
aWduZWQgbG9uZykgbGxpX3RhYmxlX3B0cik7DQotCWVkYmcoIlNFUCBEcml2ZXI6bGxpX3RhYmxl
X3B0ci0+cGh5c2ljYWxfYWRkcmVzcyBpcyAlMDhseFxuIiwgbGxpX3RhYmxlX3B0ci0+cGh5c2lj
YWxfYWRkcmVzcyk7DQotCWVkYmcoIlNFUCBEcml2ZXI6bGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6
ZSBpcyAlbHVcbiIsIGxsaV90YWJsZV9wdHItPmJsb2NrX3NpemUpOw0KLQ0KLQkvKiBzZXQgdGhl
IG91dHB1dCBwYXJhbWV0ZXIgKi8NCi0JKm51bV9wcm9jZXNzZWRfZW50cmllc19wdHIgKz0gYXJy
YXlfY291bnRlcjsNCi0NCi0JZWRiZygiU0VQIERyaXZlcjoqbnVtX3Byb2Nlc3NlZF9lbnRyaWVz
X3B0ciBpcyAlbHVcbiIsICpudW1fcHJvY2Vzc2VkX2VudHJpZXNfcHRyKTsNCi0JZGJnKCJTRVAg
RHJpdmVyOjwtLS0tLS0tLSBzZXBfYnVpbGRfbGxpX3RhYmxlIGVuZFxuIik7DQotCXJldHVybjsN
Ci19DQotDQotLyoNCi0gIHRoaXMgZnVuY3Rpb24gZ29lcyBvdmVyIHRoZSBsaXN0IG9mIHRoZSBw
cmludCBjcmVhdGVkIHRhYmxlcyBhbmQNCi0gIHByaW50cyBhbGwgdGhlIGRhdGENCi0qLw0KLXN0
YXRpYyB2b2lkIHNlcF9kZWJ1Z19wcmludF9sbGlfdGFibGVzKHN0cnVjdCBzZXBfZGV2aWNlICpz
ZXAsIHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKmxsaV90YWJsZV9wdHIsIHVuc2lnbmVkIGxvbmcg
bnVtX3RhYmxlX2VudHJpZXMsIHVuc2lnbmVkIGxvbmcgdGFibGVfZGF0YV9zaXplKQ0KLXsNCi0J
dW5zaWduZWQgbG9uZyB0YWJsZV9jb3VudDsNCi0JdW5zaWduZWQgbG9uZyBlbnRyaWVzX2NvdW50
Ow0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9kZWJ1Z19wcmludF9sbGlfdGFi
bGVzIHN0YXJ0XG4iKTsNCi0NCi0JdGFibGVfY291bnQgPSAxOw0KLQl3aGlsZSAoKHVuc2lnbmVk
IGxvbmcpIGxsaV90YWJsZV9wdHIgIT0gMHhmZmZmZmZmZikgew0KLQkJZWRiZygiU0VQIERyaXZl
cjogbGxpIHRhYmxlICUwOGx4LCB0YWJsZV9kYXRhX3NpemUgaXMgJWx1XG4iLCB0YWJsZV9jb3Vu
dCwgdGFibGVfZGF0YV9zaXplKTsNCi0JCWVkYmcoIlNFUCBEcml2ZXI6IG51bV90YWJsZV9lbnRy
aWVzIGlzICVsdVxuIiwgbnVtX3RhYmxlX2VudHJpZXMpOw0KLQ0KLQkJLyogcHJpbnQgZW50cmll
cyBvZiB0aGUgdGFibGUgKHdpdGhvdXQgaW5mbyBlbnRyeSkgKi8NCi0JCWZvciAoZW50cmllc19j
b3VudCA9IDA7IGVudHJpZXNfY291bnQgPCBudW1fdGFibGVfZW50cmllczsgZW50cmllc19jb3Vu
dCsrLCBsbGlfdGFibGVfcHRyKyspIHsNCi0JCQllZGJnKCJTRVAgRHJpdmVyOmxsaV90YWJsZV9w
dHIgYWRkcmVzcyBpcyAlMDhseFxuIiwgKHVuc2lnbmVkIGxvbmcpIGxsaV90YWJsZV9wdHIpOw0K
LQkJCWVkYmcoIlNFUCBEcml2ZXI6cGh5cyBhZGRyZXNzIGlzICUwOGx4IGJsb2NrIHNpemUgaXMg
JWx1XG4iLCBsbGlfdGFibGVfcHRyLT5waHlzaWNhbF9hZGRyZXNzLCBsbGlfdGFibGVfcHRyLT5i
bG9ja19zaXplKTsNCi0JCX0NCi0NCi0JCS8qIHBvaW50IHRvIHRoZSBpbmZvIGVudHJ5ICovDQot
CQlsbGlfdGFibGVfcHRyLS07DQotDQotCQllZGJnKCJTRVAgRHJpdmVyOnBoeXMgbGxpX3RhYmxl
X3B0ci0+YmxvY2tfc2l6ZSBpcyAlbHVcbiIsIGxsaV90YWJsZV9wdHItPmJsb2NrX3NpemUpOw0K
LQkJZWRiZygiU0VQIERyaXZlcjpwaHlzIGxsaV90YWJsZV9wdHItPnBoeXNpY2FsX2FkZHJlc3Mg
aXMgJTA4bHhcbiIsIGxsaV90YWJsZV9wdHItPnBoeXNpY2FsX2FkZHJlc3MpOw0KLQ0KLQ0KLQkJ
dGFibGVfZGF0YV9zaXplID0gbGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSAmIDB4ZmZmZmZmOw0K
LQkJbnVtX3RhYmxlX2VudHJpZXMgPSAobGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSA+PiAyNCkg
JiAweGZmOw0KLQkJbGxpX3RhYmxlX3B0ciA9IChzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90ICopDQot
CQkgICAgKGxsaV90YWJsZV9wdHItPnBoeXNpY2FsX2FkZHJlc3MpOw0KLQ0KLQkJZWRiZygiU0VQ
IERyaXZlcjpwaHlzIHRhYmxlX2RhdGFfc2l6ZSBpcyAlbHUgbnVtX3RhYmxlX2VudHJpZXMgaXMg
JWx1IGxsaV90YWJsZV9wdHIgaXMlbHVcbiIsIHRhYmxlX2RhdGFfc2l6ZSwgbnVtX3RhYmxlX2Vu
dHJpZXMsICh1bnNpZ25lZCBsb25nKSBsbGlfdGFibGVfcHRyKTsNCi0NCi0JCWlmICgodW5zaWdu
ZWQgbG9uZykgbGxpX3RhYmxlX3B0ciAhPSAweGZmZmZmZmZmKQ0KLQkJCWxsaV90YWJsZV9wdHIg
PSAoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqKSBzZXBfc2hhcmVkX2J1c190b192aXJ0KHNlcCwg
KHVuc2lnbmVkIGxvbmcpIGxsaV90YWJsZV9wdHIpOw0KLQ0KLQkJdGFibGVfY291bnQrKzsNCi0J
fQ0KLQlkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9kZWJ1Z19wcmludF9sbGlfdGFibGVz
IGVuZFxuIik7DQotfQ0KLQ0KLQ0KLS8qDQotICBUaGlzIGZ1bmN0aW9uIHByZXBhcmVzIG9ubHkg
aW5wdXQgRE1BIHRhYmxlIGZvciBzeW5ocm9uaWMgc3ltbWV0cmljDQotICBvcGVyYXRpb25zIChI
QVNIKQ0KLSovDQotc3RhdGljIGludCBzZXBfcHJlcGFyZV9pbnB1dF9kbWFfdGFibGUoc3RydWN0
IHNlcF9kZXZpY2UgKnNlcCwNCi0JCQkJdW5zaWduZWQgbG9uZyBhcHBfdmlydF9hZGRyLA0KLQkJ
CQl1bnNpZ25lZCBsb25nIGRhdGFfc2l6ZSwNCi0JCQkJdW5zaWduZWQgbG9uZyBibG9ja19zaXpl
LA0KLQkJCQl1bnNpZ25lZCBsb25nICpsbGlfdGFibGVfcHRyLA0KLQkJCQl1bnNpZ25lZCBsb25n
ICpudW1fZW50cmllc19wdHIsDQotCQkJCXVuc2lnbmVkIGxvbmcgKnRhYmxlX2RhdGFfc2l6ZV9w
dHIsDQotCQkJCWJvb2wgaXNLZXJuZWxWaXJ0dWFsQWRkcmVzcykNCi17DQotCS8qIHBvaW50ZXIg
dG8gdGhlIGluZm8gZW50cnkgb2YgdGhlIHRhYmxlIC0gdGhlIGxhc3QgZW50cnkgKi8NCi0Jc3Ry
dWN0IHNlcF9sbGlfZW50cnlfdCAqaW5mb19lbnRyeV9wdHI7DQotCS8qIGFycmF5IG9mIHBvaW50
ZXJzIG90IHBhZ2UgKi8NCi0Jc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqbGxpX2FycmF5X3B0cjsN
Ci0JLyogcG9pbnRzIHRvIHRoZSBmaXJzdCBlbnRyeSB0byBiZSBwcm9jZXNzZWQgaW4gdGhlIGxs
aV9pbl9hcnJheSAqLw0KLQl1bnNpZ25lZCBsb25nIGN1cnJlbnRfZW50cnk7DQotCS8qIG51bSBl
bnRyaWVzIGluIHRoZSB2aXJ0dWFsIGJ1ZmZlciAqLw0KLQl1bnNpZ25lZCBsb25nIHNlcF9sbGlf
ZW50cmllczsNCi0JLyogbGxpIHRhYmxlIHBvaW50ZXIgKi8NCi0Jc3RydWN0IHNlcF9sbGlfZW50
cnlfdCAqaW5fbGxpX3RhYmxlX3B0cjsNCi0JLyogdGhlIHRvdGFsIGRhdGEgaW4gb25lIHRhYmxl
ICovDQotCXVuc2lnbmVkIGxvbmcgdGFibGVfZGF0YV9zaXplOw0KLQkvKiBudW1iZXIgb2YgZW50
cmllcyBpbiBsbGkgdGFibGUgKi8NCi0JdW5zaWduZWQgbG9uZyBudW1fZW50cmllc19pbl90YWJs
ZTsNCi0JLyogbmV4dCB0YWJsZSBhZGRyZXNzICovDQotCXZvaWQgKmxsaV90YWJsZV9hbGxvY19h
ZGRyOw0KLQl1bnNpZ25lZCBsb25nIHJlc3VsdDsNCi0NCi0JZGJnKCJTRVAgRHJpdmVyOi0tLS0t
LS0tPiBzZXBfcHJlcGFyZV9pbnB1dF9kbWFfdGFibGUgc3RhcnRcbiIpOw0KLQ0KLQllZGJnKCJT
RVAgRHJpdmVyOmRhdGFfc2l6ZSBpcyAlbHVcbiIsIGRhdGFfc2l6ZSk7DQotCWVkYmcoIlNFUCBE
cml2ZXI6YmxvY2tfc2l6ZSBpcyAlbHVcbiIsIGJsb2NrX3NpemUpOw0KLQ0KLQkvKiBpbml0aWFs
aXplIHRoZSBwYWdlcyBwb2ludGVycyAqLw0KLQlzZXAtPmluX3BhZ2VfYXJyYXkgPSAwOw0KLQlz
ZXAtPmluX251bV9wYWdlcyA9IDA7DQotDQotCWlmIChkYXRhX3NpemUgPT0gMCkgew0KLQkJLyog
c3BlY2lhbCBjYXNlICAtIGNyZWF0ZWQgMiBlbnRyaWVzIHRhYmxlIHdpdGggemVybyBkYXRhICov
DQotCQlpbl9sbGlfdGFibGVfcHRyID0gKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKikgKHNlcC0+
c2hhcmVkX2FkZHIgKyBTRVBfRFJJVkVSX1NZTkNIUk9OSUNfRE1BX1RBQkxFU19BUkVBX09GRlNF
VF9JTl9CWVRFUyk7DQotCQkvKiBGSVhNRTogU2hvdWxkIHRoZSBlbnRyeSBiZWxvdyBub3QgYmUg
Zm9yIF9idXMgKi8NCi0JCWluX2xsaV90YWJsZV9wdHItPnBoeXNpY2FsX2FkZHJlc3MgPSAodW5z
aWduZWQgbG9uZylzZXAtPnNoYXJlZF9hZGRyICsgU0VQX0RSSVZFUl9TWU5DSFJPTklDX0RNQV9U
QUJMRVNfQVJFQV9PRkZTRVRfSU5fQllURVM7DQotCQlpbl9sbGlfdGFibGVfcHRyLT5ibG9ja19z
aXplID0gMDsNCi0NCi0JCWluX2xsaV90YWJsZV9wdHIrKzsNCi0JCWluX2xsaV90YWJsZV9wdHIt
PnBoeXNpY2FsX2FkZHJlc3MgPSAweEZGRkZGRkZGOw0KLQkJaW5fbGxpX3RhYmxlX3B0ci0+Ymxv
Y2tfc2l6ZSA9IDA7DQotDQotCQkqbGxpX3RhYmxlX3B0ciA9IHNlcC0+c2hhcmVkX2J1cyArIFNF
UF9EUklWRVJfU1lOQ0hST05JQ19ETUFfVEFCTEVTX0FSRUFfT0ZGU0VUX0lOX0JZVEVTOw0KLQkJ
Km51bV9lbnRyaWVzX3B0ciA9IDI7DQotCQkqdGFibGVfZGF0YV9zaXplX3B0ciA9IDA7DQotDQot
CQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0JfQ0KLQ0KLQkvKiBjaGVjayBpZiB0aGUgcGFnZXMgYXJl
IGluIEtlcm5lbCBWaXJ0dWFsIEFkZHJlc3MgbGF5b3V0ICovDQotCWlmIChpc0tlcm5lbFZpcnR1
YWxBZGRyZXNzID09IHRydWUpDQotCQkvKiBsb2NrIHRoZSBwYWdlcyBvZiB0aGUga2VybmVsIGJ1
ZmZlciBhbmQgdHJhbnNsYXRlIHRoZW0gdG8gcGFnZXMgKi8NCi0JCXJlc3VsdCA9IHNlcF9sb2Nr
X2tlcm5lbF9wYWdlcyhzZXAsIGFwcF92aXJ0X2FkZHIsIGRhdGFfc2l6ZSwgJnNlcC0+aW5fbnVt
X3BhZ2VzLCAmbGxpX2FycmF5X3B0ciwgJnNlcC0+aW5fcGFnZV9hcnJheSk7DQotCWVsc2UNCi0J
CS8qIGxvY2sgdGhlIHBhZ2VzIG9mIHRoZSB1c2VyIGJ1ZmZlciBhbmQgdHJhbnNsYXRlIHRoZW0g
dG8gcGFnZXMgKi8NCi0JCXJlc3VsdCA9IHNlcF9sb2NrX3VzZXJfcGFnZXMoc2VwLCBhcHBfdmly
dF9hZGRyLCBkYXRhX3NpemUsICZzZXAtPmluX251bV9wYWdlcywgJmxsaV9hcnJheV9wdHIsICZz
ZXAtPmluX3BhZ2VfYXJyYXkpOw0KLQ0KLQlpZiAocmVzdWx0KQ0KLQkJcmV0dXJuIHJlc3VsdDsN
Ci0NCi0JZWRiZygiU0VQIERyaXZlcjpvdXRwdXQgc2VwLT5pbl9udW1fcGFnZXMgaXMgJWx1XG4i
LCBzZXAtPmluX251bV9wYWdlcyk7DQotDQotCWN1cnJlbnRfZW50cnkgPSAwOw0KLQlpbmZvX2Vu
dHJ5X3B0ciA9IDA7DQotCXNlcF9sbGlfZW50cmllcyA9IHNlcC0+aW5fbnVtX3BhZ2VzOw0KLQ0K
LQkvKiBpbml0aWF0ZSB0byBwb2ludCBhZnRlciB0aGUgbWVzc2FnZSBhcmVhICovDQotCWxsaV90
YWJsZV9hbGxvY19hZGRyID0gc2VwLT5zaGFyZWRfYWRkciArIFNFUF9EUklWRVJfU1lOQ0hST05J
Q19ETUFfVEFCTEVTX0FSRUFfT0ZGU0VUX0lOX0JZVEVTOw0KLQ0KLQkvKiBsb29wIHRpbGwgYWxs
IHRoZSBlbnRyaWVzIGluIGluIGFycmF5IGFyZSBub3QgcHJvY2Vzc2VkICovDQotCXdoaWxlIChj
dXJyZW50X2VudHJ5IDwgc2VwX2xsaV9lbnRyaWVzKSB7DQotCQkvKiBzZXQgdGhlIG5ldyBpbnB1
dCBhbmQgb3V0cHV0IHRhYmxlcyAqLw0KLQkJaW5fbGxpX3RhYmxlX3B0ciA9IChzdHJ1Y3Qgc2Vw
X2xsaV9lbnRyeV90ICopIGxsaV90YWJsZV9hbGxvY19hZGRyOw0KLQ0KLQkJbGxpX3RhYmxlX2Fs
bG9jX2FkZHIgKz0gc2l6ZW9mKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QpICogU0VQX0RSSVZFUl9F
TlRSSUVTX1BFUl9UQUJMRV9JTl9TRVA7DQotDQotCQkvKiBjYWxjdWxhdGUgdGhlIG1heGltdW0g
c2l6ZSBvZiBkYXRhIGZvciBpbnB1dCB0YWJsZSAqLw0KLQkJdGFibGVfZGF0YV9zaXplID0gc2Vw
X2NhbGN1bGF0ZV9sbGlfdGFibGVfbWF4X3NpemUoJmxsaV9hcnJheV9wdHJbY3VycmVudF9lbnRy
eV0sIChzZXBfbGxpX2VudHJpZXMgLSBjdXJyZW50X2VudHJ5KSk7DQotDQotCQkvKiBub3cgY2Fs
Y3VsYXRlIHRoZSB0YWJsZSBzaXplIHNvIHRoYXQgaXQgd2lsbCBiZSBtb2R1bGUgYmxvY2sgc2l6
ZSAqLw0KLQkJdGFibGVfZGF0YV9zaXplID0gKHRhYmxlX2RhdGFfc2l6ZSAvIGJsb2NrX3NpemUp
ICogYmxvY2tfc2l6ZTsNCi0NCi0JCWVkYmcoIlNFUCBEcml2ZXI6b3V0cHV0IHRhYmxlX2RhdGFf
c2l6ZSBpcyAlbHVcbiIsIHRhYmxlX2RhdGFfc2l6ZSk7DQotDQotCQkvKiBjb25zdHJ1Y3QgaW5w
dXQgbGxpIHRhYmxlICovDQotCQlzZXBfYnVpbGRfbGxpX3RhYmxlKCZsbGlfYXJyYXlfcHRyW2N1
cnJlbnRfZW50cnldLCBpbl9sbGlfdGFibGVfcHRyLCAmY3VycmVudF9lbnRyeSwgJm51bV9lbnRy
aWVzX2luX3RhYmxlLCB0YWJsZV9kYXRhX3NpemUpOw0KLQ0KLQkJaWYgKGluZm9fZW50cnlfcHRy
ID09IDApIHsNCi0JCQkvKiBzZXQgdGhlIG91dHB1dCBwYXJhbWV0ZXJzIHRvIHBoeXNpY2FsIGFk
ZHJlc3NlcyAqLw0KLQkJCSpsbGlfdGFibGVfcHRyID0gc2VwX3NoYXJlZF92aXJ0X3RvX2J1cyhz
ZXAsIGluX2xsaV90YWJsZV9wdHIpOw0KLQkJCSpudW1fZW50cmllc19wdHIgPSBudW1fZW50cmll
c19pbl90YWJsZTsNCi0JCQkqdGFibGVfZGF0YV9zaXplX3B0ciA9IHRhYmxlX2RhdGFfc2l6ZTsN
Ci0NCi0JCQllZGJnKCJTRVAgRHJpdmVyOm91dHB1dCBsbGlfdGFibGVfaW5fcHRyIGlzICUwOGx4
XG4iLCAqbGxpX3RhYmxlX3B0cik7DQotCQl9IGVsc2Ugew0KLQkJCS8qIHVwZGF0ZSB0aGUgaW5m
byBlbnRyeSBvZiB0aGUgcHJldmlvdXMgaW4gdGFibGUgKi8NCi0JCQlpbmZvX2VudHJ5X3B0ci0+
cGh5c2ljYWxfYWRkcmVzcyA9IHNlcF9zaGFyZWRfdmlydF90b19idXMoc2VwLCBpbl9sbGlfdGFi
bGVfcHRyKTsNCi0JCQlpbmZvX2VudHJ5X3B0ci0+YmxvY2tfc2l6ZSA9ICgobnVtX2VudHJpZXNf
aW5fdGFibGUpIDw8IDI0KSB8ICh0YWJsZV9kYXRhX3NpemUpOw0KLQkJfQ0KLQ0KLQkJLyogc2F2
ZSB0aGUgcG9pbnRlciB0byB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgY3VycmVudCB0YWJsZXMgKi8N
Ci0JCWluZm9fZW50cnlfcHRyID0gaW5fbGxpX3RhYmxlX3B0ciArIG51bV9lbnRyaWVzX2luX3Rh
YmxlIC0gMTsNCi0JfQ0KLQ0KLQkvKiBwcmludCBpbnB1dCB0YWJsZXMgKi8NCi0Jc2VwX2RlYnVn
X3ByaW50X2xsaV90YWJsZXMoc2VwLCAoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqKQ0KLQkJCQkg
ICBzZXBfc2hhcmVkX2J1c190b192aXJ0KHNlcCwgKmxsaV90YWJsZV9wdHIpLCAqbnVtX2VudHJp
ZXNfcHRyLCAqdGFibGVfZGF0YV9zaXplX3B0cik7DQotDQotCS8qIHRoZSBhcnJheSBvZiB0aGUg
cGFnZXMgKi8NCi0Ja2ZyZWUobGxpX2FycmF5X3B0cik7DQotZW5kX2Z1bmN0aW9uOg0KLQlkYmco
IlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9wcmVwYXJlX2lucHV0X2RtYV90YWJsZSBlbmRcbiIp
Ow0KLQlyZXR1cm4gMDsNCi0NCi19DQotDQotLyoNCi0gVGhpcyBmdW5jdGlvbiBjcmVhdGVzIHRo
ZSBpbnB1dCBhbmQgb3V0cHV0IGRtYSB0YWJsZXMgZm9yDQotIHN5bW1ldHJpYyBvcGVyYXRpb25z
IChBRVMvREVTKSBhY2NvcmRpbmcgdG8gdGhlIGJsb2NrIHNpemUgZnJvbSBMTEkgYXJheXMNCi0q
Lw0KLXN0YXRpYyBpbnQgc2VwX2NvbnN0cnVjdF9kbWFfdGFibGVzX2Zyb21fbGxpKHN0cnVjdCBz
ZXBfZGV2aWNlICpzZXAsDQotCQkJCSAgICAgIHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKmxsaV9p
bl9hcnJheSwNCi0JCQkJICAgICAgdW5zaWduZWQgbG9uZyBzZXBfaW5fbGxpX2VudHJpZXMsDQot
CQkJCSAgICAgIHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKmxsaV9vdXRfYXJyYXksDQotCQkJCSAg
ICAgIHVuc2lnbmVkIGxvbmcgc2VwX291dF9sbGlfZW50cmllcywNCi0JCQkJICAgICAgdW5zaWdu
ZWQgbG9uZyBibG9ja19zaXplLCB1bnNpZ25lZCBsb25nICpsbGlfdGFibGVfaW5fcHRyLCB1bnNp
Z25lZCBsb25nICpsbGlfdGFibGVfb3V0X3B0ciwgdW5zaWduZWQgbG9uZyAqaW5fbnVtX2VudHJp
ZXNfcHRyLCB1bnNpZ25lZCBsb25nICpvdXRfbnVtX2VudHJpZXNfcHRyLCB1bnNpZ25lZCBsb25n
ICp0YWJsZV9kYXRhX3NpemVfcHRyKQ0KLXsNCi0JLyogcG9pbnRzIHRvIHRoZSBhcmVhIHdoZXJl
IG5leHQgbGxpIHRhYmxlIGNhbiBiZSBhbGxvY2F0ZWQ6IGtlZXAgdm9pZCAqDQotCSAgIGFzIHRo
ZXJlIGlzIHBvaW50ZXIgc2NhbGluZyB0byBmaXggb3RoZXJ3aXNlICovDQotCXZvaWQgKmxsaV90
YWJsZV9hbGxvY19hZGRyOw0KLQkvKiBpbnB1dCBsbGkgdGFibGUgKi8NCi0Jc3RydWN0IHNlcF9s
bGlfZW50cnlfdCAqaW5fbGxpX3RhYmxlX3B0cjsNCi0JLyogb3V0cHV0IGxsaSB0YWJsZSAqLw0K
LQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90ICpvdXRfbGxpX3RhYmxlX3B0cjsNCi0JLyogcG9pbnRl
ciB0byB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgdGFibGUgLSB0aGUgbGFzdCBlbnRyeSAqLw0KLQlz
dHJ1Y3Qgc2VwX2xsaV9lbnRyeV90ICppbmZvX2luX2VudHJ5X3B0cjsNCi0JLyogcG9pbnRlciB0
byB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgdGFibGUgLSB0aGUgbGFzdCBlbnRyeSAqLw0KLQlzdHJ1
Y3Qgc2VwX2xsaV9lbnRyeV90ICppbmZvX291dF9lbnRyeV9wdHI7DQotCS8qIHBvaW50cyB0byB0
aGUgZmlyc3QgZW50cnkgdG8gYmUgcHJvY2Vzc2VkIGluIHRoZSBsbGlfaW5fYXJyYXkgKi8NCi0J
dW5zaWduZWQgbG9uZyBjdXJyZW50X2luX2VudHJ5Ow0KLQkvKiBwb2ludHMgdG8gdGhlIGZpcnN0
IGVudHJ5IHRvIGJlIHByb2Nlc3NlZCBpbiB0aGUgbGxpX291dF9hcnJheSAqLw0KLQl1bnNpZ25l
ZCBsb25nIGN1cnJlbnRfb3V0X2VudHJ5Ow0KLQkvKiBtYXggc2l6ZSBvZiB0aGUgaW5wdXQgdGFi
bGUgKi8NCi0JdW5zaWduZWQgbG9uZyBpbl90YWJsZV9kYXRhX3NpemU7DQotCS8qIG1heCBzaXpl
IG9mIHRoZSBvdXRwdXQgdGFibGUgKi8NCi0JdW5zaWduZWQgbG9uZyBvdXRfdGFibGVfZGF0YV9z
aXplOw0KLQkvKiBmbGFnIHRlIHNpZ25pZmllcyBpZiB0aGlzIGlzIHRoZSBmaXJzdCB0YWJsZXMg
YnVpbGQgZnJvbSB0aGUgYXJyYXlzICovDQotCXVuc2lnbmVkIGxvbmcgZmlyc3RfdGFibGVfZmxh
ZzsNCi0JLyogdGhlIGRhdGEgc2l6ZSB0aGF0IHNob3VsZCBiZSBpbiB0YWJsZSAqLw0KLQl1bnNp
Z25lZCBsb25nIHRhYmxlX2RhdGFfc2l6ZTsNCi0JLyogbnVtYmVyIG9mIGV0bnJpZXMgaW4gdGhl
IGlucHV0IHRhYmxlICovDQotCXVuc2lnbmVkIGxvbmcgbnVtX2VudHJpZXNfaW5fdGFibGU7DQot
CS8qIG51bWJlciBvZiBldG5yaWVzIGluIHRoZSBvdXRwdXQgdGFibGUgKi8NCi0JdW5zaWduZWQg
bG9uZyBudW1fZW50cmllc19vdXRfdGFibGU7DQotDQotCWRiZygiU0VQIERyaXZlcjotLS0tLS0t
LT4gc2VwX2NvbnN0cnVjdF9kbWFfdGFibGVzX2Zyb21fbGxpIHN0YXJ0XG4iKTsNCi0NCi0JLyog
aW5pdGlhdGUgdG8gcGludCBhZnRlciB0aGUgbWVzc2FnZSBhcmVhICovDQotCWxsaV90YWJsZV9h
bGxvY19hZGRyID0gc2VwLT5zaGFyZWRfYWRkciArIFNFUF9EUklWRVJfU1lOQ0hST05JQ19ETUFf
VEFCTEVTX0FSRUFfT0ZGU0VUX0lOX0JZVEVTOw0KLQ0KLQljdXJyZW50X2luX2VudHJ5ID0gMDsN
Ci0JY3VycmVudF9vdXRfZW50cnkgPSAwOw0KLQlmaXJzdF90YWJsZV9mbGFnID0gMTsNCi0JaW5m
b19pbl9lbnRyeV9wdHIgPSAwOw0KLQlpbmZvX291dF9lbnRyeV9wdHIgPSAwOw0KLQ0KLQkvKiBs
b29wIHRpbGwgYWxsIHRoZSBlbnRyaWVzIGluIGluIGFycmF5IGFyZSBub3QgcHJvY2Vzc2VkICov
DQotCXdoaWxlIChjdXJyZW50X2luX2VudHJ5IDwgc2VwX2luX2xsaV9lbnRyaWVzKSB7DQotCQkv
KiBzZXQgdGhlIG5ldyBpbnB1dCBhbmQgb3V0cHV0IHRhYmxlcyAqLw0KLQkJaW5fbGxpX3RhYmxl
X3B0ciA9IChzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90ICopIGxsaV90YWJsZV9hbGxvY19hZGRyOw0K
LQ0KLQkJbGxpX3RhYmxlX2FsbG9jX2FkZHIgKz0gc2l6ZW9mKHN0cnVjdCBzZXBfbGxpX2VudHJ5
X3QpICogU0VQX0RSSVZFUl9FTlRSSUVTX1BFUl9UQUJMRV9JTl9TRVA7DQotDQotCQkvKiBzZXQg
dGhlIGZpcnN0IG91dHB1dCB0YWJsZXMgKi8NCi0JCW91dF9sbGlfdGFibGVfcHRyID0gKHN0cnVj
dCBzZXBfbGxpX2VudHJ5X3QgKikgbGxpX3RhYmxlX2FsbG9jX2FkZHI7DQotDQotCQlsbGlfdGFi
bGVfYWxsb2NfYWRkciArPSBzaXplb2Yoc3RydWN0IHNlcF9sbGlfZW50cnlfdCkgKiBTRVBfRFJJ
VkVSX0VOVFJJRVNfUEVSX1RBQkxFX0lOX1NFUDsNCi0NCi0JCS8qIGNhbGN1bGF0ZSB0aGUgbWF4
aW11bSBzaXplIG9mIGRhdGEgZm9yIGlucHV0IHRhYmxlICovDQotCQlpbl90YWJsZV9kYXRhX3Np
emUgPSBzZXBfY2FsY3VsYXRlX2xsaV90YWJsZV9tYXhfc2l6ZSgmbGxpX2luX2FycmF5W2N1cnJl
bnRfaW5fZW50cnldLCAoc2VwX2luX2xsaV9lbnRyaWVzIC0gY3VycmVudF9pbl9lbnRyeSkpOw0K
LQ0KLQkJLyogY2FsY3VsYXRlIHRoZSBtYXhpbXVtIHNpemUgb2YgZGF0YSBmb3Igb3V0cHV0IHRh
YmxlICovDQotCQlvdXRfdGFibGVfZGF0YV9zaXplID0gc2VwX2NhbGN1bGF0ZV9sbGlfdGFibGVf
bWF4X3NpemUoJmxsaV9vdXRfYXJyYXlbY3VycmVudF9vdXRfZW50cnldLCAoc2VwX291dF9sbGlf
ZW50cmllcyAtIGN1cnJlbnRfb3V0X2VudHJ5KSk7DQotDQotCQllZGJnKCJTRVAgRHJpdmVyOmlu
X3RhYmxlX2RhdGFfc2l6ZSBpcyAlbHVcbiIsIGluX3RhYmxlX2RhdGFfc2l6ZSk7DQotCQllZGJn
KCJTRVAgRHJpdmVyOm91dF90YWJsZV9kYXRhX3NpemUgaXMgJWx1XG4iLCBvdXRfdGFibGVfZGF0
YV9zaXplKTsNCi0NCi0JCS8qIGNoZWNrIHdoZXJlIHRoZSBkYXRhIGlzIHNtYWxsZXN0ICovDQot
CQl0YWJsZV9kYXRhX3NpemUgPSBpbl90YWJsZV9kYXRhX3NpemU7DQotCQlpZiAodGFibGVfZGF0
YV9zaXplID4gb3V0X3RhYmxlX2RhdGFfc2l6ZSkNCi0JCQl0YWJsZV9kYXRhX3NpemUgPSBvdXRf
dGFibGVfZGF0YV9zaXplOw0KLQ0KLQkJLyogbm93IGNhbGN1bGF0ZSB0aGUgdGFibGUgc2l6ZSBz
byB0aGF0IGl0IHdpbGwgYmUgbW9kdWxlIGJsb2NrIHNpemUgKi8NCi0JCXRhYmxlX2RhdGFfc2l6
ZSA9ICh0YWJsZV9kYXRhX3NpemUgLyBibG9ja19zaXplKSAqIGJsb2NrX3NpemU7DQotDQotCQlk
YmcoIlNFUCBEcml2ZXI6dGFibGVfZGF0YV9zaXplIGlzICVsdVxuIiwgdGFibGVfZGF0YV9zaXpl
KTsNCi0NCi0JCS8qIGNvbnN0cnVjdCBpbnB1dCBsbGkgdGFibGUgKi8NCi0JCXNlcF9idWlsZF9s
bGlfdGFibGUoJmxsaV9pbl9hcnJheVtjdXJyZW50X2luX2VudHJ5XSwgaW5fbGxpX3RhYmxlX3B0
ciwgJmN1cnJlbnRfaW5fZW50cnksICZudW1fZW50cmllc19pbl90YWJsZSwgdGFibGVfZGF0YV9z
aXplKTsNCi0NCi0JCS8qIGNvbnN0cnVjdCBvdXRwdXQgbGxpIHRhYmxlICovDQotCQlzZXBfYnVp
bGRfbGxpX3RhYmxlKCZsbGlfb3V0X2FycmF5W2N1cnJlbnRfb3V0X2VudHJ5XSwgb3V0X2xsaV90
YWJsZV9wdHIsICZjdXJyZW50X291dF9lbnRyeSwgJm51bV9lbnRyaWVzX291dF90YWJsZSwgdGFi
bGVfZGF0YV9zaXplKTsNCi0NCi0JCS8qIGlmIGluZm8gZW50cnkgaXMgbnVsbCAtIHRoaXMgaXMg
dGhlIGZpcnN0IHRhYmxlIGJ1aWx0ICovDQotCQlpZiAoaW5mb19pbl9lbnRyeV9wdHIgPT0gMCkg
ew0KLQkJCS8qIHNldCB0aGUgb3V0cHV0IHBhcmFtZXRlcnMgdG8gcGh5c2ljYWwgYWRkcmVzc2Vz
ICovDQotCQkJKmxsaV90YWJsZV9pbl9wdHIgPSBzZXBfc2hhcmVkX3ZpcnRfdG9fYnVzKHNlcCwg
aW5fbGxpX3RhYmxlX3B0cik7DQotCQkJKmluX251bV9lbnRyaWVzX3B0ciA9IG51bV9lbnRyaWVz
X2luX3RhYmxlOw0KLQkJCSpsbGlfdGFibGVfb3V0X3B0ciA9IHNlcF9zaGFyZWRfdmlydF90b19i
dXMoc2VwLCBvdXRfbGxpX3RhYmxlX3B0cik7DQotCQkJKm91dF9udW1fZW50cmllc19wdHIgPSBu
dW1fZW50cmllc19vdXRfdGFibGU7DQotCQkJKnRhYmxlX2RhdGFfc2l6ZV9wdHIgPSB0YWJsZV9k
YXRhX3NpemU7DQotDQotCQkJZWRiZygiU0VQIERyaXZlcjpvdXRwdXQgbGxpX3RhYmxlX2luX3B0
ciBpcyAlMDhseFxuIiwgKmxsaV90YWJsZV9pbl9wdHIpOw0KLQkJCWVkYmcoIlNFUCBEcml2ZXI6
b3V0cHV0IGxsaV90YWJsZV9vdXRfcHRyIGlzICUwOGx4XG4iLCAqbGxpX3RhYmxlX291dF9wdHIp
Ow0KLQkJfSBlbHNlIHsNCi0JCQkvKiB1cGRhdGUgdGhlIGluZm8gZW50cnkgb2YgdGhlIHByZXZp
b3VzIGluIHRhYmxlICovDQotCQkJaW5mb19pbl9lbnRyeV9wdHItPnBoeXNpY2FsX2FkZHJlc3Mg
PSBzZXBfc2hhcmVkX3ZpcnRfdG9fYnVzKHNlcCwgaW5fbGxpX3RhYmxlX3B0cik7DQotCQkJaW5m
b19pbl9lbnRyeV9wdHItPmJsb2NrX3NpemUgPSAoKG51bV9lbnRyaWVzX2luX3RhYmxlKSA8PCAy
NCkgfCAodGFibGVfZGF0YV9zaXplKTsNCi0NCi0JCQkvKiB1cGRhdGUgdGhlIGluZm8gZW50cnkg
b2YgdGhlIHByZXZpb3VzIGluIHRhYmxlICovDQotCQkJaW5mb19vdXRfZW50cnlfcHRyLT5waHlz
aWNhbF9hZGRyZXNzID0gc2VwX3NoYXJlZF92aXJ0X3RvX2J1cyhzZXAsIG91dF9sbGlfdGFibGVf
cHRyKTsNCi0JCQlpbmZvX291dF9lbnRyeV9wdHItPmJsb2NrX3NpemUgPSAoKG51bV9lbnRyaWVz
X291dF90YWJsZSkgPDwgMjQpIHwgKHRhYmxlX2RhdGFfc2l6ZSk7DQotCQl9DQotDQotCQkvKiBz
YXZlIHRoZSBwb2ludGVyIHRvIHRoZSBpbmZvIGVudHJ5IG9mIHRoZSBjdXJyZW50IHRhYmxlcyAq
Lw0KLQkJaW5mb19pbl9lbnRyeV9wdHIgPSBpbl9sbGlfdGFibGVfcHRyICsgbnVtX2VudHJpZXNf
aW5fdGFibGUgLSAxOw0KLQkJaW5mb19vdXRfZW50cnlfcHRyID0gb3V0X2xsaV90YWJsZV9wdHIg
KyBudW1fZW50cmllc19vdXRfdGFibGUgLSAxOw0KLQ0KLQkJZWRiZygiU0VQIERyaXZlcjpvdXRw
dXQgbnVtX2VudHJpZXNfb3V0X3RhYmxlIGlzICVsdVxuIiwgKHVuc2lnbmVkIGxvbmcpIG51bV9l
bnRyaWVzX291dF90YWJsZSk7DQotCQllZGJnKCJTRVAgRHJpdmVyOm91dHB1dCBpbmZvX2luX2Vu
dHJ5X3B0ciBpcyAlbHVcbiIsICh1bnNpZ25lZCBsb25nKSBpbmZvX2luX2VudHJ5X3B0cik7DQot
CQllZGJnKCJTRVAgRHJpdmVyOm91dHB1dCBpbmZvX291dF9lbnRyeV9wdHIgaXMgJWx1XG4iLCAo
dW5zaWduZWQgbG9uZykgaW5mb19vdXRfZW50cnlfcHRyKTsNCi0JfQ0KLQ0KLQkvKiBwcmludCBp
bnB1dCB0YWJsZXMgKi8NCi0Jc2VwX2RlYnVnX3ByaW50X2xsaV90YWJsZXMoc2VwLCAoc3RydWN0
IHNlcF9sbGlfZW50cnlfdCAqKQ0KLQkJCQkgICBzZXBfc2hhcmVkX2J1c190b192aXJ0KHNlcCwg
KmxsaV90YWJsZV9pbl9wdHIpLCAqaW5fbnVtX2VudHJpZXNfcHRyLCAqdGFibGVfZGF0YV9zaXpl
X3B0cik7DQotCS8qIHByaW50IG91dHB1dCB0YWJsZXMgKi8NCi0Jc2VwX2RlYnVnX3ByaW50X2xs
aV90YWJsZXMoc2VwLCAoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqKQ0KLQkJCQkgICBzZXBfc2hh
cmVkX2J1c190b192aXJ0KHNlcCwgKmxsaV90YWJsZV9vdXRfcHRyKSwgKm91dF9udW1fZW50cmll
c19wdHIsICp0YWJsZV9kYXRhX3NpemVfcHRyKTsNCi0JZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0t
LSBzZXBfY29uc3RydWN0X2RtYV90YWJsZXNfZnJvbV9sbGkgZW5kXG4iKTsNCi0JcmV0dXJuIDA7
DQotfQ0KLQ0KLQ0KLS8qDQotICBUaGlzIGZ1bmN0aW9uIGJ1aWxkcyBpbnB1dCBhbmQgb3V0cHV0
IERNQSB0YWJsZXMgZm9yIHN5bmhyb25pYw0KLSAgc3ltbWV0cmljIG9wZXJhdGlvbnMgKEFFUywg
REVTKS4gSXQgYWxzbyBjaGVja3MgdGhhdCBlYWNoIHRhYmxlDQotICBpcyBvZiB0aGUgbW9kdWxh
ciBibG9jayBzaXplDQotKi8NCi1zdGF0aWMgaW50IHNlcF9wcmVwYXJlX2lucHV0X291dHB1dF9k
bWFfdGFibGUoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCwNCi0JCQkJICAgICAgIHVuc2lnbmVkIGxv
bmcgYXBwX3ZpcnRfaW5fYWRkciwNCi0JCQkJICAgICAgIHVuc2lnbmVkIGxvbmcgYXBwX3ZpcnRf
b3V0X2FkZHIsDQotCQkJCSAgICAgICB1bnNpZ25lZCBsb25nIGRhdGFfc2l6ZSwNCi0JCQkJICAg
ICAgIHVuc2lnbmVkIGxvbmcgYmxvY2tfc2l6ZSwNCi0JCQkJICAgICAgIHVuc2lnbmVkIGxvbmcg
KmxsaV90YWJsZV9pbl9wdHIsIHVuc2lnbmVkIGxvbmcgKmxsaV90YWJsZV9vdXRfcHRyLCB1bnNp
Z25lZCBsb25nICppbl9udW1fZW50cmllc19wdHIsIHVuc2lnbmVkIGxvbmcgKm91dF9udW1fZW50
cmllc19wdHIsIHVuc2lnbmVkIGxvbmcgKnRhYmxlX2RhdGFfc2l6ZV9wdHIsIGJvb2wgaXNLZXJu
ZWxWaXJ0dWFsQWRkcmVzcykNCi17DQotCS8qIGFycmF5IG9mIHBvaW50ZXJzIG9mIHBhZ2UgKi8N
Ci0Jc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqbGxpX2luX2FycmF5Ow0KLQkvKiBhcnJheSBvZiBw
b2ludGVycyBvZiBwYWdlICovDQotCXN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKmxsaV9vdXRfYXJy
YXk7DQotCWludCByZXN1bHQgPSAwOw0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNl
cF9wcmVwYXJlX2lucHV0X291dHB1dF9kbWFfdGFibGUgc3RhcnRcbiIpOw0KLQ0KLQkvKiBpbml0
aWFsaXplIHRoZSBwYWdlcyBwb2ludGVycyAqLw0KLQlzZXAtPmluX3BhZ2VfYXJyYXkgPSAwOw0K
LQlzZXAtPm91dF9wYWdlX2FycmF5ID0gMDsNCi0NCi0JLyogY2hlY2sgaWYgdGhlIHBhZ2VzIGFy
ZSBpbiBLZXJuZWwgVmlydHVhbCBBZGRyZXNzIGxheW91dCAqLw0KLQlpZiAoaXNLZXJuZWxWaXJ0
dWFsQWRkcmVzcyA9PSB0cnVlKSB7DQotCQkvKiBsb2NrIHRoZSBwYWdlcyBvZiB0aGUga2VybmVs
IGJ1ZmZlciBhbmQgdHJhbnNsYXRlIHRoZW0gdG8gcGFnZXMgKi8NCi0JCXJlc3VsdCA9IHNlcF9s
b2NrX2tlcm5lbF9wYWdlcyhzZXAsIGFwcF92aXJ0X2luX2FkZHIsIGRhdGFfc2l6ZSwgJnNlcC0+
aW5fbnVtX3BhZ2VzLCAmbGxpX2luX2FycmF5LCAmc2VwLT5pbl9wYWdlX2FycmF5KTsNCi0JCWlm
IChyZXN1bHQpIHsNCi0JCQllZGJnKCJTRVAgRHJpdmVyOiBzZXBfbG9ja19rZXJuZWxfcGFnZXMg
Zm9yIGlucHV0IHZpcnR1YWwgYnVmZmVyIGZhaWxlZFxuIik7DQotCQkJZ290byBlbmRfZnVuY3Rp
b247DQotCQl9DQotCX0gZWxzZSB7DQotCQkvKiBsb2NrIHRoZSBwYWdlcyBvZiB0aGUgdXNlciBi
dWZmZXIgYW5kIHRyYW5zbGF0ZSB0aGVtIHRvIHBhZ2VzICovDQotCQlyZXN1bHQgPSBzZXBfbG9j
a191c2VyX3BhZ2VzKHNlcCwgYXBwX3ZpcnRfaW5fYWRkciwgZGF0YV9zaXplLCAmc2VwLT5pbl9u
dW1fcGFnZXMsICZsbGlfaW5fYXJyYXksICZzZXAtPmluX3BhZ2VfYXJyYXkpOw0KLQkJaWYgKHJl
c3VsdCkgew0KLQkJCWVkYmcoIlNFUCBEcml2ZXI6IHNlcF9sb2NrX3VzZXJfcGFnZXMgZm9yIGlu
cHV0IHZpcnR1YWwgYnVmZmVyIGZhaWxlZFxuIik7DQotCQkJZ290byBlbmRfZnVuY3Rpb247DQot
CQl9DQotCX0NCi0NCi0JaWYgKGlzS2VybmVsVmlydHVhbEFkZHJlc3MgPT0gdHJ1ZSkgew0KLQkJ
cmVzdWx0ID0gc2VwX2xvY2tfa2VybmVsX3BhZ2VzKHNlcCwgYXBwX3ZpcnRfb3V0X2FkZHIsIGRh
dGFfc2l6ZSwgJnNlcC0+b3V0X251bV9wYWdlcywgJmxsaV9vdXRfYXJyYXksICZzZXAtPm91dF9w
YWdlX2FycmF5KTsNCi0JCWlmIChyZXN1bHQpIHsNCi0JCQllZGJnKCJTRVAgRHJpdmVyOiBzZXBf
bG9ja19rZXJuZWxfcGFnZXMgZm9yIG91dHB1dCB2aXJ0dWFsIGJ1ZmZlciBmYWlsZWRcbiIpOw0K
LQkJCWdvdG8gZW5kX2Z1bmN0aW9uX3dpdGhfZXJyb3IxOw0KLQkJfQ0KLQl9IGVsc2Ugew0KLQkJ
cmVzdWx0ID0gc2VwX2xvY2tfdXNlcl9wYWdlcyhzZXAsIGFwcF92aXJ0X291dF9hZGRyLCBkYXRh
X3NpemUsICZzZXAtPm91dF9udW1fcGFnZXMsICZsbGlfb3V0X2FycmF5LCAmc2VwLT5vdXRfcGFn
ZV9hcnJheSk7DQotCQlpZiAocmVzdWx0KSB7DQotCQkJZWRiZygiU0VQIERyaXZlcjogc2VwX2xv
Y2tfdXNlcl9wYWdlcyBmb3Igb3V0cHV0IHZpcnR1YWwgYnVmZmVyIGZhaWxlZFxuIik7DQotCQkJ
Z290byBlbmRfZnVuY3Rpb25fd2l0aF9lcnJvcjE7DQotCQl9DQotCX0NCi0JZWRiZygic2VwLT5p
bl9udW1fcGFnZXMgaXMgJWx1XG4iLCBzZXAtPmluX251bV9wYWdlcyk7DQotCWVkYmcoInNlcC0+
b3V0X251bV9wYWdlcyBpcyAlbHVcbiIsIHNlcC0+b3V0X251bV9wYWdlcyk7DQotCWVkYmcoIlNF
UF9EUklWRVJfRU5UUklFU19QRVJfVEFCTEVfSU5fU0VQIGlzICV4XG4iLCBTRVBfRFJJVkVSX0VO
VFJJRVNfUEVSX1RBQkxFX0lOX1NFUCk7DQotDQotDQotCS8qIGNhbGwgdGhlIGZ1Y250aW9uIHRo
YXQgY3JlYXRlcyB0YWJsZSBmcm9tIHRoZSBsbGkgYXJyYXlzICovDQotCXJlc3VsdCA9IHNlcF9j
b25zdHJ1Y3RfZG1hX3RhYmxlc19mcm9tX2xsaShzZXAsIGxsaV9pbl9hcnJheSwgc2VwLT5pbl9u
dW1fcGFnZXMsIGxsaV9vdXRfYXJyYXksIHNlcC0+b3V0X251bV9wYWdlcywgYmxvY2tfc2l6ZSwg
bGxpX3RhYmxlX2luX3B0ciwgbGxpX3RhYmxlX291dF9wdHIsIGluX251bV9lbnRyaWVzX3B0ciwg
b3V0X251bV9lbnRyaWVzX3B0ciwgdGFibGVfZGF0YV9zaXplX3B0cik7DQotCWlmIChyZXN1bHQp
IHsNCi0JCWVkYmcoIlNFUCBEcml2ZXI6IHNlcF9jb25zdHJ1Y3RfZG1hX3RhYmxlc19mcm9tX2xs
aSBmYWlsZWRcbiIpOw0KLQkJZ290byBlbmRfZnVuY3Rpb25fd2l0aF9lcnJvcjI7DQotCX0NCi0N
Ci0JLyogZmFsbCB0aHJvdWdoIC0gZnJlZSB0aGUgbGxpIGVudHJ5IGFycmF5cyAqLw0KLQlkYmco
ImluX251bV9lbnRyaWVzX3B0ciBpcyAlMDhseFxuIiwgKmluX251bV9lbnRyaWVzX3B0cik7DQot
CWRiZygib3V0X251bV9lbnRyaWVzX3B0ciBpcyAlMDhseFxuIiwgKm91dF9udW1fZW50cmllc19w
dHIpOw0KLQlkYmcoInRhYmxlX2RhdGFfc2l6ZV9wdHIgaXMgJTA4bHhcbiIsICp0YWJsZV9kYXRh
X3NpemVfcHRyKTsNCi1lbmRfZnVuY3Rpb25fd2l0aF9lcnJvcjI6DQotCWtmcmVlKGxsaV9vdXRf
YXJyYXkpOw0KLWVuZF9mdW5jdGlvbl93aXRoX2Vycm9yMToNCi0Ja2ZyZWUobGxpX2luX2FycmF5
KTsNCi1lbmRfZnVuY3Rpb246DQotCWRiZygiU0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX3ByZXBh
cmVfaW5wdXRfb3V0cHV0X2RtYV90YWJsZSBlbmQgcmVzdWx0ID0gJWRcbiIsIChpbnQpIHJlc3Vs
dCk7DQotCXJldHVybiByZXN1bHQ7DQotDQotfQ0KLQ0KLS8qDQotICB0aGlzIGZ1bmN0aW9uIGhh
bmRsZXMgdGhhIHJlcXVlc3QgZm9yIGNyZWF0aW9uIG9mIHRoZSBETUEgdGFibGUNCi0gIGZvciB0
aGUgc3luY2hyb25pYyBzeW1tZXRyaWMgb3BlcmF0aW9ucyAoQUVTLERFUykNCi0qLw0KLXN0YXRp
YyBpbnQgc2VwX2NyZWF0ZV9zeW5jX2RtYV90YWJsZXNfaGFuZGxlcihzdHJ1Y3Qgc2VwX2Rldmlj
ZSAqc2VwLA0KLQkJCQkJCXVuc2lnbmVkIGxvbmcgYXJnKQ0KLXsNCi0JaW50IGVycm9yOw0KLQkv
KiBjb21tYW5kIGFyZ3VtZW50cyAqLw0KLQlzdHJ1Y3Qgc2VwX2RyaXZlcl9idWlsZF9zeW5jX3Rh
YmxlX3QgY29tbWFuZF9hcmdzOw0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9j
cmVhdGVfc3luY19kbWFfdGFibGVzX2hhbmRsZXIgc3RhcnRcbiIpOw0KLQ0KLQllcnJvciA9IGNv
cHlfZnJvbV91c2VyKCZjb21tYW5kX2FyZ3MsICh2b2lkICopIGFyZywgc2l6ZW9mKHN0cnVjdCBz
ZXBfZHJpdmVyX2J1aWxkX3N5bmNfdGFibGVfdCkpOw0KLQlpZiAoZXJyb3IpDQotCQlnb3RvIGVu
ZF9mdW5jdGlvbjsNCi0NCi0JZWRiZygiYXBwX2luX2FkZHJlc3MgaXMgJTA4bHhcbiIsIGNvbW1h
bmRfYXJncy5hcHBfaW5fYWRkcmVzcyk7DQotCWVkYmcoImFwcF9vdXRfYWRkcmVzcyBpcyAlMDhs
eFxuIiwgY29tbWFuZF9hcmdzLmFwcF9vdXRfYWRkcmVzcyk7DQotCWVkYmcoImRhdGFfc2l6ZSBp
cyAlbHVcbiIsIGNvbW1hbmRfYXJncy5kYXRhX2luX3NpemUpOw0KLQllZGJnKCJibG9ja19zaXpl
IGlzICVsdVxuIiwgY29tbWFuZF9hcmdzLmJsb2NrX3NpemUpOw0KLQ0KLQkvKiBjaGVjayBpZiB3
ZSBuZWVkIHRvIGJ1aWxkIG9ubHkgaW5wdXQgdGFibGUgb3IgaW5wdXQvb3V0cHV0ICovDQotCWlm
IChjb21tYW5kX2FyZ3MuYXBwX291dF9hZGRyZXNzKQ0KLQkJLyogcHJlcGFyZSBpbnB1dCBhbmQg
b3V0cHV0IHRhYmxlcyAqLw0KLQkJZXJyb3IgPSBzZXBfcHJlcGFyZV9pbnB1dF9vdXRwdXRfZG1h
X3RhYmxlKHNlcCwNCi0JCQkJCQkJICAgY29tbWFuZF9hcmdzLmFwcF9pbl9hZGRyZXNzLA0KLQkJ
CQkJCQkgICBjb21tYW5kX2FyZ3MuYXBwX291dF9hZGRyZXNzLA0KLQkJCQkJCQkgICBjb21tYW5k
X2FyZ3MuZGF0YV9pbl9zaXplLA0KLQkJCQkJCQkgICBjb21tYW5kX2FyZ3MuYmxvY2tfc2l6ZSwN
Ci0JCQkJCQkJICAgJmNvbW1hbmRfYXJncy5pbl90YWJsZV9hZGRyZXNzLA0KLQkJCQkJCQkgICAm
Y29tbWFuZF9hcmdzLm91dF90YWJsZV9hZGRyZXNzLCAmY29tbWFuZF9hcmdzLmluX3RhYmxlX251
bV9lbnRyaWVzLCAmY29tbWFuZF9hcmdzLm91dF90YWJsZV9udW1fZW50cmllcywgJmNvbW1hbmRf
YXJncy50YWJsZV9kYXRhX3NpemUsIGNvbW1hbmRfYXJncy5pc0tlcm5lbFZpcnR1YWxBZGRyZXNz
KTsNCi0JZWxzZQ0KLQkJLyogcHJlcGFyZSBpbnB1dCB0YWJsZXMgKi8NCi0JCWVycm9yID0gc2Vw
X3ByZXBhcmVfaW5wdXRfZG1hX3RhYmxlKHNlcCwNCi0JCQkJCQkgICAgY29tbWFuZF9hcmdzLmFw
cF9pbl9hZGRyZXNzLA0KLQkJCQkJCSAgICBjb21tYW5kX2FyZ3MuZGF0YV9pbl9zaXplLCBjb21t
YW5kX2FyZ3MuYmxvY2tfc2l6ZSwgJmNvbW1hbmRfYXJncy5pbl90YWJsZV9hZGRyZXNzLCAmY29t
bWFuZF9hcmdzLmluX3RhYmxlX251bV9lbnRyaWVzLCAmY29tbWFuZF9hcmdzLnRhYmxlX2RhdGFf
c2l6ZSwgY29tbWFuZF9hcmdzLmlzS2VybmVsVmlydHVhbEFkZHJlc3MpOw0KLQ0KLQlpZiAoZXJy
b3IpDQotCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0JLyogY29weSB0byB1c2VyICovDQotCWlmIChj
b3B5X3RvX3VzZXIoKHZvaWQgKikgYXJnLCAodm9pZCAqKSAmY29tbWFuZF9hcmdzLCBzaXplb2Yo
c3RydWN0IHNlcF9kcml2ZXJfYnVpbGRfc3luY190YWJsZV90KSkpDQotCQllcnJvciA9IC1FRkFV
TFQ7DQotZW5kX2Z1bmN0aW9uOg0KLQlkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9jcmVh
dGVfc3luY19kbWFfdGFibGVzX2hhbmRsZXIgZW5kXG4iKTsNCi0JcmV0dXJuIGVycm9yOw0KLX0N
Ci0NCi0vKg0KLSAgdGhpcyBmdW5jdGlvbiBoYW5kbGVzIHRoZSByZXF1ZXN0IGZvciBmcmVlaW5n
IGRtYSB0YWJsZSBmb3Igc3luaHJvbmljIGFjdGlvbnMNCi0qLw0KLXN0YXRpYyBpbnQgc2VwX2Zy
ZWVfZG1hX3RhYmxlX2RhdGFfaGFuZGxlcihzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwKQ0KLXsNCi0J
ZGJnKCJTRVAgRHJpdmVyOi0tLS0tLS0tPiBzZXBfZnJlZV9kbWFfdGFibGVfZGF0YV9oYW5kbGVy
IHN0YXJ0XG4iKTsNCi0NCi0JLyogZnJlZSBpbnB1dCBwYWdlcyBhcnJheSAqLw0KLQlzZXBfZnJl
ZV9kbWFfcGFnZXMoc2VwLT5pbl9wYWdlX2FycmF5LCBzZXAtPmluX251bV9wYWdlcywgMCk7DQot
DQotCS8qIGZyZWUgb3V0cHV0IHBhZ2VzIGFycmF5IGlmIG5lZWRlZCAqLw0KLQlpZiAoc2VwLT5v
dXRfcGFnZV9hcnJheSkNCi0JCXNlcF9mcmVlX2RtYV9wYWdlcyhzZXAtPm91dF9wYWdlX2FycmF5
LCBzZXAtPm91dF9udW1fcGFnZXMsIDEpOw0KLQ0KLQkvKiByZXNldCBhbGwgdGhlIHZhbHVlcyAq
Lw0KLQlzZXAtPmluX3BhZ2VfYXJyYXkgPSAwOw0KLQlzZXAtPm91dF9wYWdlX2FycmF5ID0gMDsN
Ci0Jc2VwLT5pbl9udW1fcGFnZXMgPSAwOw0KLQlzZXAtPm91dF9udW1fcGFnZXMgPSAwOw0KLQlk
YmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9mcmVlX2RtYV90YWJsZV9kYXRhX2hhbmRsZXIg
ZW5kXG4iKTsNCi0JcmV0dXJuIDA7DQotfQ0KLQ0KLS8qDQotICB0aGlzIGZ1bmN0aW9uIGZpbmQg
YSBzcGFjZSBmb3IgdGhlIG5ldyBmbG93IGRtYSB0YWJsZQ0KLSovDQotc3RhdGljIGludCBzZXBf
ZmluZF9mcmVlX2Zsb3dfZG1hX3RhYmxlX3NwYWNlKHN0cnVjdCBzZXBfZGV2aWNlICpzZXAsDQot
CQkJCQl1bnNpZ25lZCBsb25nICoqdGFibGVfYWRkcmVzc19wdHIpDQotew0KLQlpbnQgZXJyb3Ig
PSAwOw0KLQkvKiBwb2ludGVyIHRvIHRoZSBpZCBmaWVsZCBvZiB0aGUgZmxvdyBkbWEgdGFibGUg
Ki8NCi0JdW5zaWduZWQgbG9uZyAqc3RhcnRfdGFibGVfcHRyOw0KLQkvKiBEbyBub3QgbWFrZSBz
dGFydF9hZGRyIHVuc2lnbmVkIGxvbmcgKiB1bmxlc3MgZml4aW5nIHRoZSBvZmZzZXQNCi0JICAg
Y29tcHV0YXRpb25zICEgKi8NCi0Jdm9pZCAqZmxvd19kbWFfYXJlYV9zdGFydF9hZGRyOw0KLQl1
bnNpZ25lZCBsb25nICpmbG93X2RtYV9hcmVhX2VuZF9hZGRyOw0KLQkvKiBtYXhpbXVtIHRhYmxl
IHNpemUgaW4gd29yZHMgKi8NCi0JdW5zaWduZWQgbG9uZyB0YWJsZV9zaXplX2luX3dvcmRzOw0K
LQ0KLQkvKiBmaW5kIHRoZSBzdGFydCBhZGRyZXNzIG9mIHRoZSBmbG93IERNQSB0YWJsZSBhcmVh
ICovDQotCWZsb3dfZG1hX2FyZWFfc3RhcnRfYWRkciA9IHNlcC0+c2hhcmVkX2FkZHIgKyBTRVBf
RFJJVkVSX0ZMT1dfRE1BX1RBQkxFU19BUkVBX09GRlNFVF9JTl9CWVRFUzsNCi0NCi0JLyogc2V0
IGVuZCBhZGRyZXNzIG9mIHRoZSBmbG93IHRhYmxlIGFyZWEgKi8NCi0JZmxvd19kbWFfYXJlYV9l
bmRfYWRkciA9IGZsb3dfZG1hX2FyZWFfc3RhcnRfYWRkciArIFNFUF9EUklWRVJfRkxPV19ETUFf
VEFCTEVTX0FSRUFfU0laRV9JTl9CWVRFUzsNCi0NCi0JLyogc2V0IHRhYmxlIHNpemUgaW4gd29y
ZHMgKi8NCi0JdGFibGVfc2l6ZV9pbl93b3JkcyA9IFNFUF9EUklWRVJfTUFYX0ZMT1dfTlVNX0VO
VFJJRVNfSU5fVEFCTEUgKiAoc2l6ZW9mKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QpIC8gc2l6ZW9m
KGxvbmcpKSArIDI7DQotDQotCS8qIHNldCB0aGUgcG9pbnRlciB0byB0aGUgc3RhcnQgYWRkcmVz
cyBvZiBETUEgYXJlYSAqLw0KLQlzdGFydF90YWJsZV9wdHIgPSBmbG93X2RtYV9hcmVhX3N0YXJ0
X2FkZHI7DQotDQotCS8qIGZpbmQgdGhlIHNwYWNlIGZvciB0aGUgbmV4dCB0YWJsZSAqLw0KLQl3
aGlsZSAoKCgqc3RhcnRfdGFibGVfcHRyICYgMHg3RkZGRkZGRikgIT0gMCkgJiYgc3RhcnRfdGFi
bGVfcHRyIDwgZmxvd19kbWFfYXJlYV9lbmRfYWRkcikNCi0JCXN0YXJ0X3RhYmxlX3B0ciArPSB0
YWJsZV9zaXplX2luX3dvcmRzOw0KLQ0KLQkvKiBjaGVjayBpZiB3ZSByZWFjaGVkIHRoZSBlbmQg
b2YgZmxvYSB0YWJsZXMgYXJlYSAqLw0KLQlpZiAoc3RhcnRfdGFibGVfcHRyID49IGZsb3dfZG1h
X2FyZWFfZW5kX2FkZHIpDQotCQllcnJvciA9IC0xOw0KLQllbHNlDQotCQkqdGFibGVfYWRkcmVz
c19wdHIgPSBzdGFydF90YWJsZV9wdHI7DQotDQotCXJldHVybiBlcnJvcjsNCi19DQotDQotLyoN
Ci0gIFRoaXMgZnVuY3Rpb24gY3JlYXRlcyBvbmUgRE1BIHRhYmxlIGZvciBmbG93IGFuZCByZXR1
cm5zIGl0cyBkYXRhLA0KLSAgYW5kIHBvaW50ZXIgdG8gaXRzIGluZm8gZW50cnkNCi0qLw0KLXN0
YXRpYyBpbnQgc2VwX3ByZXBhcmVfb25lX2Zsb3dfZG1hX3RhYmxlKHN0cnVjdCBzZXBfZGV2aWNl
ICpzZXAsDQotCQkJCQl1bnNpZ25lZCBsb25nIHZpcnRfYnVmZl9hZGRyLA0KLQkJCQkJdW5zaWdu
ZWQgbG9uZyB2aXJ0X2J1ZmZfc2l6ZSwNCi0JCQkJCXN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKnRh
YmxlX2RhdGEsDQotCQkJCQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90ICoqaW5mb19lbnRyeV9wdHIs
DQotCQkJCQlzdHJ1Y3Qgc2VwX2Zsb3dfY29udGV4dF90ICpmbG93X2RhdGFfcHRyLA0KLQkJCQkJ
Ym9vbCBpc0tlcm5lbFZpcnR1YWxBZGRyZXNzKQ0KLXsNCi0JaW50IGVycm9yOw0KLQkvKiB0aGUg
cmFuZ2UgaW4gcGFnZXMgKi8NCi0JdW5zaWduZWQgbG9uZyBsbGlfYXJyYXlfc2l6ZTsNCi0Jc3Ry
dWN0IHNlcF9sbGlfZW50cnlfdCAqbGxpX2FycmF5Ow0KLQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90
ICpmbG93X2RtYV90YWJsZV9lbnRyeV9wdHI7DQotCXVuc2lnbmVkIGxvbmcgKnN0YXJ0X2RtYV90
YWJsZV9wdHI7DQotCS8qIHRvdGFsIHRhYmxlIGRhdGEgY291bnRlciAqLw0KLQl1bnNpZ25lZCBs
b25nIGRtYV90YWJsZV9kYXRhX2NvdW50Ow0KLQkvKiBwb2ludGVyIHRoYXQgd2lsbCBrZWVwIHRo
ZSBwb2ludGVyIHRvIHRoZSBwYWdlcyBvZiB0aGUgdmlydHVhbCBidWZmZXIgKi8NCi0Jc3RydWN0
IHBhZ2UgKipwYWdlX2FycmF5X3B0cjsNCi0JdW5zaWduZWQgbG9uZyBlbnRyeV9jb3VudDsNCi0N
Ci0JLyogZmluZCB0aGUgc3BhY2UgZm9yIHRoZSBuZXcgdGFibGUgKi8NCi0JZXJyb3IgPSBzZXBf
ZmluZF9mcmVlX2Zsb3dfZG1hX3RhYmxlX3NwYWNlKHNlcCwgJnN0YXJ0X2RtYV90YWJsZV9wdHIp
Ow0KLQlpZiAoZXJyb3IpDQotCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0NCi0JLyogY2hlY2sgaWYg
dGhlIHBhZ2VzIGFyZSBpbiBLZXJuZWwgVmlydHVhbCBBZGRyZXNzIGxheW91dCAqLw0KLQlpZiAo
aXNLZXJuZWxWaXJ0dWFsQWRkcmVzcyA9PSB0cnVlKQ0KLQkJLyogbG9jayBrZXJuZWwgYnVmZmVy
IGluIHRoZSBtZW1vcnkgKi8NCi0JCWVycm9yID0gc2VwX2xvY2tfa2VybmVsX3BhZ2VzKHNlcCwg
dmlydF9idWZmX2FkZHIsIHZpcnRfYnVmZl9zaXplLCAmbGxpX2FycmF5X3NpemUsICZsbGlfYXJy
YXksICZwYWdlX2FycmF5X3B0cik7DQotCWVsc2UNCi0JCS8qIGxvY2sgdXNlciBidWZmZXIgaW4g
dGhlIG1lbW9yeSAqLw0KLQkJZXJyb3IgPSBzZXBfbG9ja191c2VyX3BhZ2VzKHNlcCwgdmlydF9i
dWZmX2FkZHIsIHZpcnRfYnVmZl9zaXplLCAmbGxpX2FycmF5X3NpemUsICZsbGlfYXJyYXksICZw
YWdlX2FycmF5X3B0cik7DQotDQotCWlmIChlcnJvcikNCi0JCWdvdG8gZW5kX2Z1bmN0aW9uOw0K
LQ0KLQkvKiBzZXQgdGhlIHBvaW50ZXIgdG8gcGFnZSBhcnJheSBhdCB0aGUgYmVnaW5uaW5nIG9m
IHRhYmxlIC0gdGhpcyB0YWJsZSBpcw0KLQkgICBub3cgY29uc2lkZXJlZCB0YWtlbiAqLw0KLQkq
c3RhcnRfZG1hX3RhYmxlX3B0ciA9IGxsaV9hcnJheV9zaXplOw0KLQ0KLQkvKiBwb2ludCB0byB0
aGUgcGxhY2Ugb2YgdGhlIHBhZ2VzIHBvaW50ZXJzIG9mIHRoZSB0YWJsZSAqLw0KLQlzdGFydF9k
bWFfdGFibGVfcHRyKys7DQotDQotCS8qIHNldCB0aGUgcGFnZXMgcG9pbnRlciAqLw0KLQkqc3Rh
cnRfZG1hX3RhYmxlX3B0ciA9ICh1bnNpZ25lZCBsb25nKSBwYWdlX2FycmF5X3B0cjsNCi0NCi0J
Lyogc2V0IHRoZSBwb2ludGVyIHRvIHRoZSBmaXJzdCBlbnRyeSAqLw0KLQlmbG93X2RtYV90YWJs
ZV9lbnRyeV9wdHIgPSAoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqKSAoKytzdGFydF9kbWFfdGFi
bGVfcHRyKTsNCi0NCi0JLyogbm93IGNyZWF0ZSB0aGUgZW50cmllcyBmb3IgdGFibGUgKi8NCi0J
Zm9yIChkbWFfdGFibGVfZGF0YV9jb3VudCA9IGVudHJ5X2NvdW50ID0gMDsgZW50cnlfY291bnQg
PCBsbGlfYXJyYXlfc2l6ZTsgZW50cnlfY291bnQrKykgew0KLQkJZmxvd19kbWFfdGFibGVfZW50
cnlfcHRyLT5waHlzaWNhbF9hZGRyZXNzID0gbGxpX2FycmF5W2VudHJ5X2NvdW50XS5waHlzaWNh
bF9hZGRyZXNzOw0KLQ0KLQkJZmxvd19kbWFfdGFibGVfZW50cnlfcHRyLT5ibG9ja19zaXplID0g
bGxpX2FycmF5W2VudHJ5X2NvdW50XS5ibG9ja19zaXplOw0KLQ0KLQkJLyogc2V0IHRoZSB0b3Rh
bCBkYXRhIG9mIGEgdGFibGUgKi8NCi0JCWRtYV90YWJsZV9kYXRhX2NvdW50ICs9IGxsaV9hcnJh
eVtlbnRyeV9jb3VudF0uYmxvY2tfc2l6ZTsNCi0NCi0JCWZsb3dfZG1hX3RhYmxlX2VudHJ5X3B0
cisrOw0KLQl9DQotDQotCS8qIHNldCB0aGUgcGh5c2ljYWwgYWRkcmVzcyAqLw0KLQl0YWJsZV9k
YXRhLT5waHlzaWNhbF9hZGRyZXNzID0gdmlydF90b19waHlzKHN0YXJ0X2RtYV90YWJsZV9wdHIp
Ow0KLQ0KLQkvKiBzZXQgdGhlIG51bV9lbnRyaWVzIGFuZCB0b3RhbCBkYXRhIHNpemUgKi8NCi0J
dGFibGVfZGF0YS0+YmxvY2tfc2l6ZSA9ICgobGxpX2FycmF5X3NpemUgKyAxKSA8PCBTRVBfTlVN
X0VOVFJJRVNfT0ZGU0VUX0lOX0JJVFMpIHwgKGRtYV90YWJsZV9kYXRhX2NvdW50KTsNCi0NCi0J
Lyogc2V0IHRoZSBpbmZvIGVudHJ5ICovDQotCWZsb3dfZG1hX3RhYmxlX2VudHJ5X3B0ci0+cGh5
c2ljYWxfYWRkcmVzcyA9IDB4ZmZmZmZmZmY7DQotCWZsb3dfZG1hX3RhYmxlX2VudHJ5X3B0ci0+
YmxvY2tfc2l6ZSA9IDA7DQotDQotCS8qIHNldCB0aGUgcG9pbnRlciB0byBpbmZvIGVudHJ5ICov
DQotCSppbmZvX2VudHJ5X3B0ciA9IGZsb3dfZG1hX3RhYmxlX2VudHJ5X3B0cjsNCi0NCi0JLyog
dGhlIGFycmF5IG9mIHRoZSBsbGkgZW50cmllcyAqLw0KLQlrZnJlZShsbGlfYXJyYXkpOw0KLWVu
ZF9mdW5jdGlvbjoNCi0JcmV0dXJuIGVycm9yOw0KLX0NCi0NCi0NCi0NCi0vKg0KLSAgVGhpcyBm
dW5jdGlvbiBjcmVhdGVzIGEgbGlzdCBvZiB0YWJsZXMgZm9yIGZsb3cgYW5kIHJldHVybnMgdGhl
IGRhdGEgZm9yDQotCXRoZSBmaXJzdCBhbmQgbGFzdCB0YWJsZXMgb2YgdGhlIGxpc3QNCi0qLw0K
LXN0YXRpYyBpbnQgc2VwX3ByZXBhcmVfZmxvd19kbWFfdGFibGVzKHN0cnVjdCBzZXBfZGV2aWNl
ICpzZXAsDQotCQkJCQl1bnNpZ25lZCBsb25nIG51bV92aXJ0dWFsX2J1ZmZlcnMsDQotCQkJCSAg
ICAgICAgdW5zaWduZWQgbG9uZyBmaXJzdF9idWZmX2FkZHIsIHN0cnVjdCBzZXBfZmxvd19jb250
ZXh0X3QgKmZsb3dfZGF0YV9wdHIsIHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKmZpcnN0X3RhYmxl
X2RhdGFfcHRyLCBzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90ICpsYXN0X3RhYmxlX2RhdGFfcHRyLCBi
b29sIGlzS2VybmVsVmlydHVhbEFkZHJlc3MpDQotew0KLQlpbnQgZXJyb3I7DQotCXVuc2lnbmVk
IGxvbmcgdmlydF9idWZmX2FkZHI7DQotCXVuc2lnbmVkIGxvbmcgdmlydF9idWZmX3NpemU7DQot
CXN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgdGFibGVfZGF0YTsNCi0Jc3RydWN0IHNlcF9sbGlfZW50
cnlfdCAqaW5mb19lbnRyeV9wdHI7DQotCXN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKnByZXZfaW5m
b19lbnRyeV9wdHI7DQotCXVuc2lnbmVkIGxvbmcgaTsNCi0NCi0JLyogaW5pdCB2YXJzICovDQot
CWVycm9yID0gMDsNCi0JcHJldl9pbmZvX2VudHJ5X3B0ciA9IDA7DQotDQotCS8qIGluaXQgdGhl
IGZpcnN0IHRhYmxlIHRvIGRlZmF1bHQgKi8NCi0JdGFibGVfZGF0YS5waHlzaWNhbF9hZGRyZXNz
ID0gMHhmZmZmZmZmZjsNCi0JZmlyc3RfdGFibGVfZGF0YV9wdHItPnBoeXNpY2FsX2FkZHJlc3Mg
PSAweGZmZmZmZmZmOw0KLQl0YWJsZV9kYXRhLmJsb2NrX3NpemUgPSAwOw0KLQ0KLQlmb3IgKGkg
PSAwOyBpIDwgbnVtX3ZpcnR1YWxfYnVmZmVyczsgaSsrKSB7DQotCQkvKiBnZXQgdGhlIHZpcnR1
YWwgYnVmZmVyIGFkZHJlc3MgKi8NCi0JCWVycm9yID0gZ2V0X3VzZXIodmlydF9idWZmX2FkZHIs
ICZmaXJzdF9idWZmX2FkZHIpOw0KLQkJaWYgKGVycm9yKQ0KLQkJCWdvdG8gZW5kX2Z1bmN0aW9u
Ow0KLQ0KLQkJLyogZ2V0IHRoZSB2aXJ0dWFsIGJ1ZmZlciBzaXplICovDQotCQlmaXJzdF9idWZm
X2FkZHIrKzsNCi0JCWVycm9yID0gZ2V0X3VzZXIodmlydF9idWZmX3NpemUsICZmaXJzdF9idWZm
X2FkZHIpOw0KLQkJaWYgKGVycm9yKQ0KLQkJCWdvdG8gZW5kX2Z1bmN0aW9uOw0KLQ0KLQkJLyog
YWR2YW5jZSB0aGUgYWRkcmVzcyB0byBwb2ludCB0byB0aGUgbmV4dCBwYWlyIG9mIGFkZHJlc3N8
c2l6ZSAqLw0KLQkJZmlyc3RfYnVmZl9hZGRyKys7DQotDQotCQkvKiBub3cgcHJlcGFyZSB0aGUg
b25lIGZsb3cgTExJIHRhYmxlIGZyb20gdGhlIGRhdGEgKi8NCi0JCWVycm9yID0gc2VwX3ByZXBh
cmVfb25lX2Zsb3dfZG1hX3RhYmxlKHNlcCwgdmlydF9idWZmX2FkZHIsIHZpcnRfYnVmZl9zaXpl
LCAmdGFibGVfZGF0YSwgJmluZm9fZW50cnlfcHRyLCBmbG93X2RhdGFfcHRyLCBpc0tlcm5lbFZp
cnR1YWxBZGRyZXNzKTsNCi0JCWlmIChlcnJvcikNCi0JCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0N
Ci0JCWlmIChpID09IDApIHsNCi0JCQkvKiBpZiB0aGlzIGlzIHRoZSBmaXJzdCB0YWJsZSAtIHNh
dmUgaXQgdG8gcmV0dXJuIHRvIHRoZSB1c2VyDQotCQkJICAgYXBwbGljYXRpb24gKi8NCi0JCQkq
Zmlyc3RfdGFibGVfZGF0YV9wdHIgPSB0YWJsZV9kYXRhOw0KLQ0KLQkJCS8qIHNldCB0aGUgcG9p
bnRlciB0byBpbmZvIGVudHJ5ICovDQotCQkJcHJldl9pbmZvX2VudHJ5X3B0ciA9IGluZm9fZW50
cnlfcHRyOw0KLQkJfSBlbHNlIHsNCi0JCQkvKiBub3QgZmlyc3QgdGFibGUgLSB0aGUgcHJldmlv
dXMgdGFibGUgaW5mbyBlbnRyeSBzaG91bGQNCi0JCQkgICBiZSB1cGRhdGVkICovDQotCQkJcHJl
dl9pbmZvX2VudHJ5X3B0ci0+YmxvY2tfc2l6ZSA9ICgweDEgPDwgU0VQX0lOVF9GTEFHX09GRlNF
VF9JTl9CSVRTKSB8ICh0YWJsZV9kYXRhLmJsb2NrX3NpemUpOw0KLQ0KLQkJCS8qIHNldCB0aGUg
cG9pbnRlciB0byBpbmZvIGVudHJ5ICovDQotCQkJcHJldl9pbmZvX2VudHJ5X3B0ciA9IGluZm9f
ZW50cnlfcHRyOw0KLQkJfQ0KLQl9DQotDQotCS8qIHNldCB0aGUgbGFzdCB0YWJsZSBkYXRhICov
DQotCSpsYXN0X3RhYmxlX2RhdGFfcHRyID0gdGFibGVfZGF0YTsNCi1lbmRfZnVuY3Rpb246DQot
CXJldHVybiBlcnJvcjsNCi19DQotDQotLyoNCi0gIHRoaXMgZnVuY3Rpb24gZ29lcyBvdmVyIGFs
bCB0aGUgZmxvdyB0YWJsZXMgY29ubmVjdGVkIHRvIHRoZSBnaXZlbg0KLQl0YWJsZSBhbmQgZGVh
bGxvY2F0ZSB0aGVtDQotKi8NCi1zdGF0aWMgdm9pZCBzZXBfZGVhbGxvY2F0ZWRfZmxvd190YWJs
ZXMoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqZmlyc3RfdGFibGVfcHRyKQ0KLXsNCi0JLyogaWQg
cG9pbnRlciAqLw0KLQl1bnNpZ25lZCBsb25nICp0YWJsZV9wdHI7DQotCS8qIGVuZCBhZGRyZXNz
IG9mIHRoZSBmbG93IGRtYSBhcmVhICovDQotCXVuc2lnbmVkIGxvbmcgbnVtX2VudHJpZXM7DQot
CXVuc2lnbmVkIGxvbmcgbnVtX3BhZ2VzOw0KLQlzdHJ1Y3QgcGFnZSAqKnBhZ2VzX3B0cjsNCi0J
LyogbWF4aW11bSB0YWJsZSBzaXplIGluIHdvcmRzICovDQotCXN0cnVjdCBzZXBfbGxpX2VudHJ5
X3QgKmluZm9fZW50cnlfcHRyOw0KLQ0KLQkvKiBzZXQgdGhlIHBvaW50ZXIgdG8gdGhlIGZpcnN0
IHRhYmxlICovDQotCXRhYmxlX3B0ciA9ICh1bnNpZ25lZCBsb25nICopIGZpcnN0X3RhYmxlX3B0
ci0+cGh5c2ljYWxfYWRkcmVzczsNCi0NCi0JLyogc2V0IHRoZSBudW0gb2YgZW50cmllcyAqLw0K
LQludW1fZW50cmllcyA9IChmaXJzdF90YWJsZV9wdHItPmJsb2NrX3NpemUgPj4gU0VQX05VTV9F
TlRSSUVTX09GRlNFVF9JTl9CSVRTKQ0KLQkgICAgJiBTRVBfTlVNX0VOVFJJRVNfTUFTSzsNCi0N
Ci0JLyogZ28gb3ZlciBhbGwgdGhlIGNvbm5lY3RlZCB0YWJsZXMgKi8NCi0Jd2hpbGUgKCp0YWJs
ZV9wdHIgIT0gMHhmZmZmZmZmZikgew0KLQkJLyogZ2V0IG51bWJlciBvZiBwYWdlcyAqLw0KLQkJ
bnVtX3BhZ2VzID0gKih0YWJsZV9wdHIgLSAyKTsNCi0NCi0JCS8qIGdldCB0aGUgcG9pbnRlciB0
byB0aGUgcGFnZXMgKi8NCi0JCXBhZ2VzX3B0ciA9IChzdHJ1Y3QgcGFnZSAqKikgKCoodGFibGVf
cHRyIC0gMSkpOw0KLQ0KLQkJLyogZnJlZSB0aGUgcGFnZXMgKi8NCi0JCXNlcF9mcmVlX2RtYV9w
YWdlcyhwYWdlc19wdHIsIG51bV9wYWdlcywgMSk7DQotDQotCQkvKiBnb3RvIHRvIHRoZSBpbmZv
IGVudHJ5ICovDQotCQlpbmZvX2VudHJ5X3B0ciA9ICgoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAq
KSB0YWJsZV9wdHIpICsgKG51bV9lbnRyaWVzIC0gMSk7DQotDQotCQl0YWJsZV9wdHIgPSAodW5z
aWduZWQgbG9uZyAqKSBpbmZvX2VudHJ5X3B0ci0+cGh5c2ljYWxfYWRkcmVzczsNCi0JCW51bV9l
bnRyaWVzID0gKGluZm9fZW50cnlfcHRyLT5ibG9ja19zaXplID4+IFNFUF9OVU1fRU5UUklFU19P
RkZTRVRfSU5fQklUUykgJiBTRVBfTlVNX0VOVFJJRVNfTUFTSzsNCi0JfQ0KLQ0KLQlyZXR1cm47
DQotfQ0KLQ0KLS8qKg0KLSAqCXNlcF9maW5kX2Zsb3dfY29udGV4dAktCWZpbmQgYSBmbG93DQot
ICoJQHNlcDogdGhlIFNFUCB3ZSBhcmUgd29ya2luZyB3aXRoDQotICoJQGZsb3dfaWQ6IGZsb3cg
aWRlbnRpZmllcg0KLSAqDQotICoJUmV0dXJucyBhIHBvaW50ZXIgdGhlIG1hdGNoaW5nIGZsb3cs
IG9yIE5VTEwgaWYgdGhlIGZsb3cgZG9lcyBub3QNCi0gKglleGlzdC4NCi0gKi8NCi0NCi1zdGF0
aWMgc3RydWN0IHNlcF9mbG93X2NvbnRleHRfdCAqc2VwX2ZpbmRfZmxvd19jb250ZXh0KHN0cnVj
dCBzZXBfZGV2aWNlICpzZXAsDQotCQkJCXVuc2lnbmVkIGxvbmcgZmxvd19pZCkNCi17DQotCWlu
dCBjb3VudDsNCi0JLyoNCi0JICogIGFsd2F5cyBzZWFyY2ggZm9yIGZsb3cgd2l0aCBpZCBkZWZh
dWx0IGZpcnN0IC0gaW4gY2FzZSB3ZQ0KLQkgKiAgYWxyZWFkeSBzdGFydGVkIHdvcmtpbmcgb24g
dGhlIGZsb3cgdGhlcmUgY2FuIGJlIG5vIHNpdHVhdGlvbg0KLQkgKiAgd2hlbiAyIGZsb3dzIGFy
ZSB3aXRoIGRlZmF1bHQgZmxhZw0KLQkgKi8NCi0JZm9yIChjb3VudCA9IDA7IGNvdW50IDwgU0VQ
X0RSSVZFUl9OVU1fRkxPV1M7IGNvdW50KyspIHsNCi0JCWlmIChzZXAtPmZsb3dzW2NvdW50XS5m
bG93X2lkID09IGZsb3dfaWQpDQotCQkJcmV0dXJuICZzZXAtPmZsb3dzW2NvdW50XTsNCi0JfQ0K
LQlyZXR1cm4gTlVMTDsNCi19DQotDQotDQotLyoNCi0gIHRoaXMgZnVuY3Rpb24gaGFuZGxlcyB0
aGUgcmVxdWVzdCB0byBjcmVhdGUgdGhlIERNQSB0YWJsZXMgZm9yIGZsb3cNCi0qLw0KLXN0YXRp
YyBpbnQgc2VwX2NyZWF0ZV9mbG93X2RtYV90YWJsZXNfaGFuZGxlcihzdHJ1Y3Qgc2VwX2Rldmlj
ZSAqc2VwLA0KLQkJCQkJCQl1bnNpZ25lZCBsb25nIGFyZykNCi17DQotCWludCBlcnJvciA9IC1F
Tk9FTlQ7DQotCXN0cnVjdCBzZXBfZHJpdmVyX2J1aWxkX2Zsb3dfdGFibGVfdCBjb21tYW5kX2Fy
Z3M7DQotCS8qIGZpcnN0IHRhYmxlIC0gb3V0cHV0ICovDQotCXN0cnVjdCBzZXBfbGxpX2VudHJ5
X3QgZmlyc3RfdGFibGVfZGF0YTsNCi0JLyogZG1hIHRhYmxlIGRhdGEgKi8NCi0Jc3RydWN0IHNl
cF9sbGlfZW50cnlfdCBsYXN0X3RhYmxlX2RhdGE7DQotCS8qIHBvaW50ZXIgdG8gdGhlIGluZm8g
ZW50cnkgb2YgdGhlIHByZXZpdW9zIERNQSB0YWJsZSAqLw0KLQlzdHJ1Y3Qgc2VwX2xsaV9lbnRy
eV90ICpwcmV2X2luZm9fZW50cnlfcHRyOw0KLQkvKiBwb2ludGVyIHRvIHRoZSBmbG93IGRhdGEg
c3RydWN1dHJlICovDQotCXN0cnVjdCBzZXBfZmxvd19jb250ZXh0X3QgKmZsb3dfY29udGV4dF9w
dHI7DQotDQotCWRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX2NyZWF0ZV9mbG93X2RtYV90
YWJsZXNfaGFuZGxlciBzdGFydFxuIik7DQotDQotCS8qIGluaXQgdmFyaWFibGVzICovDQotCXBy
ZXZfaW5mb19lbnRyeV9wdHIgPSAwOw0KLQlmaXJzdF90YWJsZV9kYXRhLnBoeXNpY2FsX2FkZHJl
c3MgPSAweGZmZmZmZmZmOw0KLQ0KLQkvKiBmaW5kIHRoZSBmcmVlIHN0cnVjdHVyZSBmb3IgZmxv
dyBkYXRhICovDQotCWVycm9yID0gLUVJTlZBTDsNCi0JZmxvd19jb250ZXh0X3B0ciA9IHNlcF9m
aW5kX2Zsb3dfY29udGV4dChzZXAsIFNFUF9GUkVFX0ZMT1dfSUQpOw0KLQlpZiAoZmxvd19jb250
ZXh0X3B0ciA9PSBOVUxMKQ0KLQkJZ290byBlbmRfZnVuY3Rpb247DQotDQotCWVycm9yID0gY29w
eV9mcm9tX3VzZXIoJmNvbW1hbmRfYXJncywgKHZvaWQgKikgYXJnLCBzaXplb2Yoc3RydWN0IHNl
cF9kcml2ZXJfYnVpbGRfZmxvd190YWJsZV90KSk7DQotCWlmIChlcnJvcikNCi0JCWdvdG8gZW5k
X2Z1bmN0aW9uOw0KLQ0KLQkvKiBjcmVhdGUgZmxvdyB0YWJsZXMgKi8NCi0JZXJyb3IgPSBzZXBf
cHJlcGFyZV9mbG93X2RtYV90YWJsZXMoc2VwLCBjb21tYW5kX2FyZ3MubnVtX3ZpcnR1YWxfYnVm
ZmVycywgY29tbWFuZF9hcmdzLnZpcnRfYnVmZl9kYXRhX2FkZHIsIGZsb3dfY29udGV4dF9wdHIs
ICZmaXJzdF90YWJsZV9kYXRhLCAmbGFzdF90YWJsZV9kYXRhLCBjb21tYW5kX2FyZ3MuaXNLZXJu
ZWxWaXJ0dWFsQWRkcmVzcyk7DQotCWlmIChlcnJvcikNCi0JCWdvdG8gZW5kX2Z1bmN0aW9uX3dp
dGhfZXJyb3I7DQotDQotCS8qIGNoZWNrIGlmIGZsb3cgaXMgc3RhdGljICovDQotCWlmICghY29t
bWFuZF9hcmdzLmZsb3dfdHlwZSkNCi0JCS8qIHBvaW50IHRoZSBpbmZvIGVudHJ5IG9mIHRoZSBs
YXN0IHRvIHRoZSBpbmZvIGVudHJ5IG9mIHRoZSBmaXJzdCAqLw0KLQkJbGFzdF90YWJsZV9kYXRh
ID0gZmlyc3RfdGFibGVfZGF0YTsNCi0NCi0JLyogc2V0IG91dHB1dCBwYXJhbXMgKi8NCi0JY29t
bWFuZF9hcmdzLmZpcnN0X3RhYmxlX2FkZHIgPSBmaXJzdF90YWJsZV9kYXRhLnBoeXNpY2FsX2Fk
ZHJlc3M7DQotCWNvbW1hbmRfYXJncy5maXJzdF90YWJsZV9udW1fZW50cmllcyA9ICgoZmlyc3Rf
dGFibGVfZGF0YS5ibG9ja19zaXplID4+IFNFUF9OVU1fRU5UUklFU19PRkZTRVRfSU5fQklUUykg
JiBTRVBfTlVNX0VOVFJJRVNfTUFTSyk7DQotCWNvbW1hbmRfYXJncy5maXJzdF90YWJsZV9kYXRh
X3NpemUgPSAoZmlyc3RfdGFibGVfZGF0YS5ibG9ja19zaXplICYgU0VQX1RBQkxFX0RBVEFfU0la
RV9NQVNLKTsNCi0NCi0JLyogc2VuZCB0aGUgcGFyYW1ldGVycyB0byB1c2VyIGFwcGxpY2F0aW9u
ICovDQotCWVycm9yID0gY29weV90b191c2VyKCh2b2lkICopIGFyZywgJmNvbW1hbmRfYXJncywg
c2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVyX2J1aWxkX2Zsb3dfdGFibGVfdCkpOw0KLQlpZiAoZXJy
b3IpDQotCQlnb3RvIGVuZF9mdW5jdGlvbl93aXRoX2Vycm9yOw0KLQ0KLQkvKiBhbGwgdGhlIGZs
b3cgY3JlYXRlZCAgLSB1cGRhdGUgdGhlIGZsb3cgZW50cnkgd2l0aCB0ZW1wIGlkICovDQotCWZs
b3dfY29udGV4dF9wdHItPmZsb3dfaWQgPSBTRVBfVEVNUF9GTE9XX0lEOw0KLQ0KLQkvKiBzZXQg
dGhlIHByb2Nlc3NpbmcgdGFibGVzIGRhdGEgaW4gdGhlIGNvbnRleHQgKi8NCi0JaWYgKGNvbW1h
bmRfYXJncy5pbnB1dF9vdXRwdXRfZmxhZyA9PSBTRVBfRFJJVkVSX0lOX0ZMQUcpDQotCQlmbG93
X2NvbnRleHRfcHRyLT5pbnB1dF90YWJsZXNfaW5fcHJvY2VzcyA9IGZpcnN0X3RhYmxlX2RhdGE7
DQotCWVsc2UNCi0JCWZsb3dfY29udGV4dF9wdHItPm91dHB1dF90YWJsZXNfaW5fcHJvY2VzcyA9
IGZpcnN0X3RhYmxlX2RhdGE7DQotDQotCWdvdG8gZW5kX2Z1bmN0aW9uOw0KLQ0KLWVuZF9mdW5j
dGlvbl93aXRoX2Vycm9yOg0KLQkvKiBmcmVlIHRoZSBhbGxvY2F0ZWQgdGFibGVzICovDQotCXNl
cF9kZWFsbG9jYXRlZF9mbG93X3RhYmxlcygmZmlyc3RfdGFibGVfZGF0YSk7DQotZW5kX2Z1bmN0
aW9uOg0KLQlkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9jcmVhdGVfZmxvd19kbWFfdGFi
bGVzX2hhbmRsZXIgZW5kXG4iKTsNCi0JcmV0dXJuIGVycm9yOw0KLX0NCi0NCi0vKg0KLSAgdGhp
cyBmdW5jdGlvbiBoYW5kbGVzIGFkZCB0YWJsZXMgdG8gZmxvdw0KLSovDQotc3RhdGljIGludCBz
ZXBfYWRkX2Zsb3dfdGFibGVzX2hhbmRsZXIoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCwgdW5zaWdu
ZWQgbG9uZyBhcmcpDQotew0KLQlpbnQgZXJyb3I7DQotCXVuc2lnbmVkIGxvbmcgbnVtX2VudHJp
ZXM7DQotCXN0cnVjdCBzZXBfZHJpdmVyX2FkZF9mbG93X3RhYmxlX3QgY29tbWFuZF9hcmdzOw0K
LQlzdHJ1Y3Qgc2VwX2Zsb3dfY29udGV4dF90ICpmbG93X2NvbnRleHRfcHRyOw0KLQkvKiBmaXJz
dCBkbWEgdGFibGUgZGF0YSAqLw0KLQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90IGZpcnN0X3RhYmxl
X2RhdGE7DQotCS8qIGxhc3QgZG1hIHRhYmxlIGRhdGEgKi8NCi0Jc3RydWN0IHNlcF9sbGlfZW50
cnlfdCBsYXN0X3RhYmxlX2RhdGE7DQotCS8qIHBvaW50ZXIgdG8gdGhlIGluZm8gZW50cnkgb2Yg
dGhlIGN1cnJlbnQgRE1BIHRhYmxlICovDQotCXN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKmluZm9f
ZW50cnlfcHRyOw0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9hZGRfZmxvd190
YWJsZXNfaGFuZGxlciBzdGFydFxuIik7DQotDQotCS8qIGdldCBpbnB1dCBwYXJhbWV0ZXJzICov
DQotCWVycm9yID0gY29weV9mcm9tX3VzZXIoJmNvbW1hbmRfYXJncywgKHZvaWQgKikgYXJnLCBz
aXplb2Yoc3RydWN0IHNlcF9kcml2ZXJfYWRkX2Zsb3dfdGFibGVfdCkpOw0KLQlpZiAoZXJyb3Ip
DQotCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0NCi0JLyogZmluZCB0aGUgZmxvdyBzdHJ1Y3R1cmUg
Zm9yIHRoZSBmbG93IGlkICovDQotCWZsb3dfY29udGV4dF9wdHIgPSBzZXBfZmluZF9mbG93X2Nv
bnRleHQoc2VwLCBjb21tYW5kX2FyZ3MuZmxvd19pZCk7DQotCWlmIChmbG93X2NvbnRleHRfcHRy
ID09IE5VTEwpDQotCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0NCi0JLyogcHJlcGFyZSB0aGUgZmxv
dyBkbWEgdGFibGVzICovDQotCWVycm9yID0gc2VwX3ByZXBhcmVfZmxvd19kbWFfdGFibGVzKHNl
cCwgY29tbWFuZF9hcmdzLm51bV92aXJ0dWFsX2J1ZmZlcnMsIGNvbW1hbmRfYXJncy52aXJ0X2J1
ZmZfZGF0YV9hZGRyLCBmbG93X2NvbnRleHRfcHRyLCAmZmlyc3RfdGFibGVfZGF0YSwgJmxhc3Rf
dGFibGVfZGF0YSwgY29tbWFuZF9hcmdzLmlzS2VybmVsVmlydHVhbEFkZHJlc3MpOw0KLQlpZiAo
ZXJyb3IpDQotCQlnb3RvIGVuZF9mdW5jdGlvbl93aXRoX2Vycm9yOw0KLQ0KLQkvKiBub3cgY2hl
Y2sgaWYgdGhlcmUgaXMgYWxyZWFkeSBhbiBleGlzdGluZyBhZGQgdGFibGUgZm9yIHRoaXMgZmxv
dyAqLw0KLQlpZiAoY29tbWFuZF9hcmdzLmlucHV0T3V0cHV0RmxhZyA9PSBTRVBfRFJJVkVSX0lO
X0ZMQUcpIHsNCi0JCS8qIHRoaXMgYnVmZmVyIHdhcyBmb3IgaW5wdXQgYnVmZmVycyAqLw0KLQkJ
aWYgKGZsb3dfY29udGV4dF9wdHItPmlucHV0X3RhYmxlc19mbGFnKSB7DQotCQkJLyogYWRkIHRh
YmxlIGFscmVhZHkgZXhpc3RzIC0gYWRkIHRoZSBuZXcgdGFibGVzIHRvIHRoZSBlbmQNCi0JCQkg
ICBvZiB0aGUgcHJldmlvdXMgKi8NCi0JCQludW1fZW50cmllcyA9IChmbG93X2NvbnRleHRfcHRy
LT5sYXN0X2lucHV0X3RhYmxlLmJsb2NrX3NpemUgPj4gU0VQX05VTV9FTlRSSUVTX09GRlNFVF9J
Tl9CSVRTKSAmIFNFUF9OVU1fRU5UUklFU19NQVNLOw0KLQ0KLQkJCWluZm9fZW50cnlfcHRyID0g
KHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKikNCi0JCQkgICAgKGZsb3dfY29udGV4dF9wdHItPmxh
c3RfaW5wdXRfdGFibGUucGh5c2ljYWxfYWRkcmVzcyArIChzaXplb2Yoc3RydWN0IHNlcF9sbGlf
ZW50cnlfdCkgKiAobnVtX2VudHJpZXMgLSAxKSkpOw0KLQ0KLQkJCS8qIGNvbm5lY3QgdG8gbGlz
dCBvZiB0YWJsZXMgKi8NCi0JCQkqaW5mb19lbnRyeV9wdHIgPSBmaXJzdF90YWJsZV9kYXRhOw0K
LQ0KLQkJCS8qIHNldCB0aGUgZmlyc3QgdGFibGUgZGF0YSAqLw0KLQkJCWZpcnN0X3RhYmxlX2Rh
dGEgPSBmbG93X2NvbnRleHRfcHRyLT5maXJzdF9pbnB1dF90YWJsZTsNCi0JCX0gZWxzZSB7DQot
CQkJLyogc2V0IHRoZSBpbnB1dCBmbGFnICovDQotCQkJZmxvd19jb250ZXh0X3B0ci0+aW5wdXRf
dGFibGVzX2ZsYWcgPSAxOw0KLQ0KLQkJCS8qIHNldCB0aGUgZmlyc3QgdGFibGUgZGF0YSAqLw0K
LQkJCWZsb3dfY29udGV4dF9wdHItPmZpcnN0X2lucHV0X3RhYmxlID0gZmlyc3RfdGFibGVfZGF0
YTsNCi0JCX0NCi0JCS8qIHNldCB0aGUgbGFzdCB0YWJsZSBkYXRhICovDQotCQlmbG93X2NvbnRl
eHRfcHRyLT5sYXN0X2lucHV0X3RhYmxlID0gbGFzdF90YWJsZV9kYXRhOw0KLQl9IGVsc2UgewkJ
LyogdGhpcyBpcyBvdXRwdXQgdGFibGVzICovDQotDQotCQkvKiB0aGlzIGJ1ZmZlciB3YXMgZm9y
IGlucHV0IGJ1ZmZlcnMgKi8NCi0JCWlmIChmbG93X2NvbnRleHRfcHRyLT5vdXRwdXRfdGFibGVz
X2ZsYWcpIHsNCi0JCQkvKiBhZGQgdGFibGUgYWxyZWFkeSBleGlzdHMgLSBhZGQgdGhlIG5ldyB0
YWJsZXMgdG8NCi0JCQkgICB0aGUgZW5kIG9mIHRoZSBwcmV2aW91cyAqLw0KLQkJCW51bV9lbnRy
aWVzID0gKGZsb3dfY29udGV4dF9wdHItPmxhc3Rfb3V0cHV0X3RhYmxlLmJsb2NrX3NpemUgPj4g
U0VQX05VTV9FTlRSSUVTX09GRlNFVF9JTl9CSVRTKSAmIFNFUF9OVU1fRU5UUklFU19NQVNLOw0K
LQ0KLQkJCWluZm9fZW50cnlfcHRyID0gKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKikNCi0JCQkg
ICAgKGZsb3dfY29udGV4dF9wdHItPmxhc3Rfb3V0cHV0X3RhYmxlLnBoeXNpY2FsX2FkZHJlc3Mg
KyAoc2l6ZW9mKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QpICogKG51bV9lbnRyaWVzIC0gMSkpKTsN
Ci0NCi0JCQkvKiBjb25uZWN0IHRvIGxpc3Qgb2YgdGFibGVzICovDQotCQkJKmluZm9fZW50cnlf
cHRyID0gZmlyc3RfdGFibGVfZGF0YTsNCi0NCi0JCQkvKiBzZXQgdGhlIGZpcnN0IHRhYmxlIGRh
dGEgKi8NCi0JCQlmaXJzdF90YWJsZV9kYXRhID0gZmxvd19jb250ZXh0X3B0ci0+Zmlyc3Rfb3V0
cHV0X3RhYmxlOw0KLQkJfSBlbHNlIHsNCi0JCQkvKiBzZXQgdGhlIGlucHV0IGZsYWcgKi8NCi0J
CQlmbG93X2NvbnRleHRfcHRyLT5vdXRwdXRfdGFibGVzX2ZsYWcgPSAxOw0KLQ0KLQkJCS8qIHNl
dCB0aGUgZmlyc3QgdGFibGUgZGF0YSAqLw0KLQkJCWZsb3dfY29udGV4dF9wdHItPmZpcnN0X291
dHB1dF90YWJsZSA9IGZpcnN0X3RhYmxlX2RhdGE7DQotCQl9DQotCQkvKiBzZXQgdGhlIGxhc3Qg
dGFibGUgZGF0YSAqLw0KLQkJZmxvd19jb250ZXh0X3B0ci0+bGFzdF9vdXRwdXRfdGFibGUgPSBs
YXN0X3RhYmxlX2RhdGE7DQotCX0NCi0NCi0JLyogc2V0IG91dHB1dCBwYXJhbXMgKi8NCi0JY29t
bWFuZF9hcmdzLmZpcnN0X3RhYmxlX2FkZHIgPSBmaXJzdF90YWJsZV9kYXRhLnBoeXNpY2FsX2Fk
ZHJlc3M7DQotCWNvbW1hbmRfYXJncy5maXJzdF90YWJsZV9udW1fZW50cmllcyA9ICgoZmlyc3Rf
dGFibGVfZGF0YS5ibG9ja19zaXplID4+IFNFUF9OVU1fRU5UUklFU19PRkZTRVRfSU5fQklUUykg
JiBTRVBfTlVNX0VOVFJJRVNfTUFTSyk7DQotCWNvbW1hbmRfYXJncy5maXJzdF90YWJsZV9kYXRh
X3NpemUgPSAoZmlyc3RfdGFibGVfZGF0YS5ibG9ja19zaXplICYgU0VQX1RBQkxFX0RBVEFfU0la
RV9NQVNLKTsNCi0NCi0JLyogc2VuZCB0aGUgcGFyYW1ldGVycyB0byB1c2VyIGFwcGxpY2F0aW9u
ICovDQotCWVycm9yID0gY29weV90b191c2VyKCh2b2lkICopIGFyZywgJmNvbW1hbmRfYXJncywg
c2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVyX2FkZF9mbG93X3RhYmxlX3QpKTsNCi1lbmRfZnVuY3Rp
b25fd2l0aF9lcnJvcjoNCi0JLyogZnJlZSB0aGUgYWxsb2NhdGVkIHRhYmxlcyAqLw0KLQlzZXBf
ZGVhbGxvY2F0ZWRfZmxvd190YWJsZXMoJmZpcnN0X3RhYmxlX2RhdGEpOw0KLWVuZF9mdW5jdGlv
bjoNCi0JZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBfYWRkX2Zsb3dfdGFibGVzX2hhbmRs
ZXIgZW5kXG4iKTsNCi0JcmV0dXJuIGVycm9yOw0KLX0NCi0NCi0vKg0KLSAgdGhpcyBmdW5jdGlv
biBhZGQgdGhlIGZsb3cgYWRkIG1lc3NhZ2UgdG8gdGhlIHNwZWNpZmljIGZsb3cNCi0qLw0KLXN0
YXRpYyBpbnQgc2VwX2FkZF9mbG93X3RhYmxlc19tZXNzYWdlX2hhbmRsZXIoc3RydWN0IHNlcF9k
ZXZpY2UgKnNlcCwgdW5zaWduZWQgbG9uZyBhcmcpDQotew0KLQlpbnQgZXJyb3I7DQotCXN0cnVj
dCBzZXBfZHJpdmVyX2FkZF9tZXNzYWdlX3QgY29tbWFuZF9hcmdzOw0KLQlzdHJ1Y3Qgc2VwX2Zs
b3dfY29udGV4dF90ICpmbG93X2NvbnRleHRfcHRyOw0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6LS0t
LS0tLS0+IHNlcF9hZGRfZmxvd190YWJsZXNfbWVzc2FnZV9oYW5kbGVyIHN0YXJ0XG4iKTsNCi0N
Ci0JZXJyb3IgPSBjb3B5X2Zyb21fdXNlcigmY29tbWFuZF9hcmdzLCAodm9pZCAqKSBhcmcsIHNp
emVvZihzdHJ1Y3Qgc2VwX2RyaXZlcl9hZGRfbWVzc2FnZV90KSk7DQotCWlmIChlcnJvcikNCi0J
CWdvdG8gZW5kX2Z1bmN0aW9uOw0KLQ0KLQkvKiBjaGVjayBpbnB1dCAqLw0KLQlpZiAoY29tbWFu
ZF9hcmdzLm1lc3NhZ2Vfc2l6ZV9pbl9ieXRlcyA+IFNFUF9NQVhfQUREX01FU1NBR0VfTEVOR1RI
X0lOX0JZVEVTKSB7DQotCQllcnJvciA9IC1FTk9NRU07DQotCQlnb3RvIGVuZF9mdW5jdGlvbjsN
Ci0JfQ0KLQ0KLQkvKiBmaW5kIHRoZSBmbG93IGNvbnRleHQgKi8NCi0JZmxvd19jb250ZXh0X3B0
ciA9IHNlcF9maW5kX2Zsb3dfY29udGV4dChzZXAsIGNvbW1hbmRfYXJncy5mbG93X2lkKTsNCi0J
aWYgKGZsb3dfY29udGV4dF9wdHIgPT0gTlVMTCkNCi0JCWdvdG8gZW5kX2Z1bmN0aW9uOw0KLQ0K
LQkvKiBjb3B5IHRoZSBtZXNzYWdlIGludG8gY29udGV4dCAqLw0KLQlmbG93X2NvbnRleHRfcHRy
LT5tZXNzYWdlX3NpemVfaW5fYnl0ZXMgPSBjb21tYW5kX2FyZ3MubWVzc2FnZV9zaXplX2luX2J5
dGVzOw0KLQllcnJvciA9IGNvcHlfZnJvbV91c2VyKGZsb3dfY29udGV4dF9wdHItPm1lc3NhZ2Us
ICh2b2lkICopIGNvbW1hbmRfYXJncy5tZXNzYWdlX2FkZHJlc3MsIGNvbW1hbmRfYXJncy5tZXNz
YWdlX3NpemVfaW5fYnl0ZXMpOw0KLWVuZF9mdW5jdGlvbjoNCi0JZGJnKCJTRVAgRHJpdmVyOjwt
LS0tLS0tLSBzZXBfYWRkX2Zsb3dfdGFibGVzX21lc3NhZ2VfaGFuZGxlciBlbmRcbiIpOw0KLQly
ZXR1cm4gZXJyb3I7DQotfQ0KLQ0KLQ0KLS8qDQotICB0aGlzIGZ1bmN0aW9uIHJldHVybnMgdGhl
IGJ1cyBhbmQgdmlydHVhbCBhZGRyZXNzZXMgb2YgdGhlIHN0YXRpYyBwb29sDQotKi8NCi1zdGF0
aWMgaW50IHNlcF9nZXRfc3RhdGljX3Bvb2xfYWRkcl9oYW5kbGVyKHN0cnVjdCBzZXBfZGV2aWNl
ICpzZXAsIHVuc2lnbmVkIGxvbmcgYXJnKQ0KLXsNCi0JaW50IGVycm9yOw0KLQlzdHJ1Y3Qgc2Vw
X2RyaXZlcl9zdGF0aWNfcG9vbF9hZGRyX3QgY29tbWFuZF9hcmdzOw0KLQ0KLQlkYmcoIlNFUCBE
cml2ZXI6LS0tLS0tLS0+IHNlcF9nZXRfc3RhdGljX3Bvb2xfYWRkcl9oYW5kbGVyIHN0YXJ0XG4i
KTsNCi0NCi0JLypwcmVwYXJlIHRoZSBvdXRwdXQgcGFyYW1ldGVycyBpbiB0aGUgc3RydWN0ICov
DQotCWNvbW1hbmRfYXJncy5waHlzaWNhbF9zdGF0aWNfYWRkcmVzcyA9IHNlcC0+c2hhcmVkX2J1
cyArIFNFUF9EUklWRVJfU1RBVElDX0FSRUFfT0ZGU0VUX0lOX0JZVEVTOw0KLQljb21tYW5kX2Fy
Z3MudmlydHVhbF9zdGF0aWNfYWRkcmVzcyA9ICh1bnNpZ25lZCBsb25nKXNlcC0+c2hhcmVkX2Fk
ZHIgKyBTRVBfRFJJVkVSX1NUQVRJQ19BUkVBX09GRlNFVF9JTl9CWVRFUzsNCi0NCi0JZWRiZygi
U0VQIERyaXZlcjpidXNfc3RhdGljX2FkZHJlc3MgaXMgJTA4bHgsIHZpcnR1YWxfc3RhdGljX2Fk
ZHJlc3MgJTA4bHhcbiIsIGNvbW1hbmRfYXJncy5waHlzaWNhbF9zdGF0aWNfYWRkcmVzcywgY29t
bWFuZF9hcmdzLnZpcnR1YWxfc3RhdGljX2FkZHJlc3MpOw0KLQ0KLQkvKiBzZW5kIHRoZSBwYXJh
bWV0ZXJzIHRvIHVzZXIgYXBwbGljYXRpb24gKi8NCi0JZXJyb3IgPSBjb3B5X3RvX3VzZXIoKHZv
aWQgKikgYXJnLCAmY29tbWFuZF9hcmdzLCBzaXplb2Yoc3RydWN0IHNlcF9kcml2ZXJfc3RhdGlj
X3Bvb2xfYWRkcl90KSk7DQotCWRiZygiU0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX2dldF9zdGF0
aWNfcG9vbF9hZGRyX2hhbmRsZXIgZW5kXG4iKTsNCi0JcmV0dXJuIGVycm9yOw0KLX0NCi0NCi0v
Kg0KLSAgdGhpcyBhZGRyZXNzIGdldHMgdGhlIG9mZnNldCBvZiB0aGUgcGh5c2ljYWwgYWRkcmVz
cyBmcm9tIHRoZSBzdGFydA0KLSAgb2YgdGhlIG1hcHBlZCBhcmVhDQotKi8NCi1zdGF0aWMgaW50
IHNlcF9nZXRfcGh5c2ljYWxfbWFwcGVkX29mZnNldF9oYW5kbGVyKHN0cnVjdCBzZXBfZGV2aWNl
ICpzZXAsIHVuc2lnbmVkIGxvbmcgYXJnKQ0KLXsNCi0JaW50IGVycm9yOw0KLQlzdHJ1Y3Qgc2Vw
X2RyaXZlcl9nZXRfbWFwcGVkX29mZnNldF90IGNvbW1hbmRfYXJnczsNCi0NCi0JZGJnKCJTRVAg
RHJpdmVyOi0tLS0tLS0tPiBzZXBfZ2V0X3BoeXNpY2FsX21hcHBlZF9vZmZzZXRfaGFuZGxlciBz
dGFydFxuIik7DQotDQotCWVycm9yID0gY29weV9mcm9tX3VzZXIoJmNvbW1hbmRfYXJncywgKHZv
aWQgKikgYXJnLCBzaXplb2Yoc3RydWN0IHNlcF9kcml2ZXJfZ2V0X21hcHBlZF9vZmZzZXRfdCkp
Ow0KLQlpZiAoZXJyb3IpDQotCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0NCi0JaWYgKGNvbW1hbmRf
YXJncy5waHlzaWNhbF9hZGRyZXNzIDwgc2VwLT5zaGFyZWRfYnVzKSB7DQotCQllcnJvciA9IC1F
SU5WQUw7DQotCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0JfQ0KLQ0KLQkvKnByZXBhcmUgdGhlIG91
dHB1dCBwYXJhbWV0ZXJzIGluIHRoZSBzdHJ1Y3QgKi8NCi0JY29tbWFuZF9hcmdzLm9mZnNldCA9
IGNvbW1hbmRfYXJncy5waHlzaWNhbF9hZGRyZXNzIC0gc2VwLT5zaGFyZWRfYnVzOw0KLQ0KLQll
ZGJnKCJTRVAgRHJpdmVyOmJ1c19hZGRyZXNzIGlzICUwOGx4LCBvZmZzZXQgaXMgJWx1XG4iLCBj
b21tYW5kX2FyZ3MucGh5c2ljYWxfYWRkcmVzcywgY29tbWFuZF9hcmdzLm9mZnNldCk7DQotDQot
CS8qIHNlbmQgdGhlIHBhcmFtZXRlcnMgdG8gdXNlciBhcHBsaWNhdGlvbiAqLw0KLQllcnJvciA9
IGNvcHlfdG9fdXNlcigodm9pZCAqKSBhcmcsICZjb21tYW5kX2FyZ3MsIHNpemVvZihzdHJ1Y3Qg
c2VwX2RyaXZlcl9nZXRfbWFwcGVkX29mZnNldF90KSk7DQotZW5kX2Z1bmN0aW9uOg0KLQlkYmco
IlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9nZXRfcGh5c2ljYWxfbWFwcGVkX29mZnNldF9oYW5k
bGVyIGVuZFxuIik7DQotCXJldHVybiBlcnJvcjsNCi19DQotDQotDQotLyoNCi0gID8NCi0qLw0K
LXN0YXRpYyBpbnQgc2VwX3N0YXJ0X2hhbmRsZXIoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCkNCi17
DQotCXVuc2lnbmVkIGxvbmcgcmVnX3ZhbDsNCi0JdW5zaWduZWQgbG9uZyBlcnJvciA9IDA7DQot
DQotCWRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX3N0YXJ0X2hhbmRsZXIgc3RhcnRcbiIp
Ow0KLQ0KLQkvKiB3YWl0IGluIHBvbGxpbmcgZm9yIG1lc3NhZ2UgZnJvbSBTRVAgKi8NCi0JZG8N
Ci0JCXJlZ192YWwgPSBzZXBfcmVhZF9yZWcoc2VwLCBIV19IT1NUX1NFUF9IT1NUX0dQUjNfUkVH
X0FERFIpOw0KLQl3aGlsZSAoIXJlZ192YWwpOw0KLQ0KLQkvKiBjaGVjayB0aGUgdmFsdWUgKi8N
Ci0JaWYgKHJlZ192YWwgPT0gMHgxKQ0KLQkJLyogZmF0YWwgZXJyb3IgLSByZWFkIGVycm9yIHN0
YXR1cyBmcm9tIEdQUk8gKi8NCi0JCWVycm9yID0gc2VwX3JlYWRfcmVnKHNlcCwgSFdfSE9TVF9T
RVBfSE9TVF9HUFIwX1JFR19BRERSKTsNCi0JZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBf
c3RhcnRfaGFuZGxlciBlbmRcbiIpOw0KLQlyZXR1cm4gZXJyb3I7DQotfQ0KLQ0KLS8qDQotICB0
aGlzIGZ1bmN0aW9uIGhhbmRsZXMgdGhlIHJlcXVlc3QgZm9yIFNFUCBpbml0aWFsaXphdGlvbg0K
LSovDQotc3RhdGljIGludCBzZXBfaW5pdF9oYW5kbGVyKHN0cnVjdCBzZXBfZGV2aWNlICpzZXAs
IHVuc2lnbmVkIGxvbmcgYXJnKQ0KLXsNCi0JdW5zaWduZWQgbG9uZyBtZXNzYWdlX3dvcmQ7DQot
CXVuc2lnbmVkIGxvbmcgKm1lc3NhZ2VfcHRyOw0KLQlzdHJ1Y3Qgc2VwX2RyaXZlcl9pbml0X3Qg
Y29tbWFuZF9hcmdzOw0KLQl1bnNpZ25lZCBsb25nIGNvdW50ZXI7DQotCXVuc2lnbmVkIGxvbmcg
ZXJyb3I7DQotCXVuc2lnbmVkIGxvbmcgcmVnX3ZhbDsNCi0NCi0JZGJnKCJTRVAgRHJpdmVyOi0t
LS0tLS0tPiBzZXBfaW5pdF9oYW5kbGVyIHN0YXJ0XG4iKTsNCi0JZXJyb3IgPSAwOw0KLQ0KLQll
cnJvciA9IGNvcHlfZnJvbV91c2VyKCZjb21tYW5kX2FyZ3MsICh2b2lkICopIGFyZywgc2l6ZW9m
KHN0cnVjdCBzZXBfZHJpdmVyX2luaXRfdCkpOw0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6LS0tLS0t
LS0+IHNlcF9pbml0X2hhbmRsZXIgLSBmaW5pc2hlZCBjb3B5X2Zyb21fdXNlciBcbiIpOw0KLQ0K
LQlpZiAoZXJyb3IpDQotCQlnb3RvIGVuZF9mdW5jdGlvbjsNCi0NCi0JLyogUEFUQ0ggLSBjb25m
aWd1cmUgdGhlIERNQSB0byBzaW5nbGUgLWJ1cnN0IGluc3RlYWQgb2YgbXVsdGktYnVyc3QgKi8N
Ci0JLypzZXBfY29uZmlndXJlX2RtYV9idXJzdCgpOyAqLw0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6
LS0tLS0tLS0+IHNlcF9pbml0X2hhbmRsZXIgLSBmaW5pc2hlZCBzZXBfY29uZmlndXJlX2RtYV9i
dXJzdCBcbiIpOw0KLQ0KLQltZXNzYWdlX3B0ciA9ICh1bnNpZ25lZCBsb25nICopIGNvbW1hbmRf
YXJncy5tZXNzYWdlX2FkZHI7DQotDQotCS8qIHNldCB0aGUgYmFzZSBhZGRyZXNzIG9mIHRoZSBT
UkFNICAqLw0KLQlzZXBfd3JpdGVfcmVnKHNlcCwgSFdfU1JBTV9BRERSX1JFR19BRERSLCBIV19D
Q19TUkFNX0JBU0VfQUREUkVTUyk7DQotDQotCWZvciAoY291bnRlciA9IDA7IGNvdW50ZXIgPCBj
b21tYW5kX2FyZ3MubWVzc2FnZV9zaXplX2luX3dvcmRzOyBjb3VudGVyKyssIG1lc3NhZ2VfcHRy
KyspIHsNCi0JCWdldF91c2VyKG1lc3NhZ2Vfd29yZCwgbWVzc2FnZV9wdHIpOw0KLQkJLyogd3Jp
dGUgZGF0YSB0byBTUkFNICovDQotCQlzZXBfd3JpdGVfcmVnKHNlcCwgSFdfU1JBTV9EQVRBX1JF
R19BRERSLCBtZXNzYWdlX3dvcmQpOw0KLQkJZWRiZygiU0VQIERyaXZlcjptZXNzYWdlX3dvcmQg
aXMgJWx1XG4iLCBtZXNzYWdlX3dvcmQpOw0KLQkJLyogd2FpdCBmb3Igd3JpdGUgY29tcGxldGUg
Ki8NCi0JCXNlcF93YWl0X3NyYW1fd3JpdGUoc2VwKTsNCi0JfQ0KLQlkYmcoIlNFUCBEcml2ZXI6
LS0tLS0tLS0+IHNlcF9pbml0X2hhbmRsZXIgLSBmaW5pc2hlZCBnZXR0aW5nIG1lc3NhZ2VzIGZy
b20gdXNlciBzcGFjZVxuIik7DQotCS8qIHNpZ25hbCBTRVAgKi8NCi0Jc2VwX3dyaXRlX3JlZyhz
ZXAsIEhXX0hPU1RfSE9TVF9TRVBfR1BSMF9SRUdfQUREUiwgMHgxKTsNCi0NCi0JZG8NCi0JCXJl
Z192YWwgPSBzZXBfcmVhZF9yZWcoc2VwLCBIV19IT1NUX1NFUF9IT1NUX0dQUjNfUkVHX0FERFIp
Ow0KLQl3aGlsZSAoIShyZWdfdmFsICYgMHhGRkZGRkZGRCkpOw0KLQ0KLQlkYmcoIlNFUCBEcml2
ZXI6LS0tLS0tLS0+IHNlcF9pbml0X2hhbmRsZXIgLSBmaW5pc2hlZCB3YWl0aW5nIGZvciByZWdf
dmFsICYgMHhGRkZGRkZGRCBcbiIpOw0KLQ0KLQkvKiBjaGVjayB0aGUgdmFsdWUgKi8NCi0JaWYg
KHJlZ192YWwgPT0gMHgxKSB7DQotCQllZGJnKCJTRVAgRHJpdmVyOmluaXQgZmFpbGVkXG4iKTsN
Ci0NCi0JCWVycm9yID0gc2VwX3JlYWRfcmVnKHNlcCwgMHg4MDYwKTsNCi0JCWVkYmcoIlNFUCBE
cml2ZXI6c3cgbW9uaXRvciBpcyAlbHVcbiIsIGVycm9yKTsNCi0NCi0JCS8qIGZhdGFsIGVycm9y
IC0gcmVhZCBlcnJvIHN0YXR1cyBmcm9tIEdQUk8gKi8NCi0JCWVycm9yID0gc2VwX3JlYWRfcmVn
KHNlcCwgSFdfSE9TVF9TRVBfSE9TVF9HUFIwX1JFR19BRERSKTsNCi0JCWVkYmcoIlNFUCBEcml2
ZXI6ZXJyb3IgaXMgJWx1XG4iLCBlcnJvcik7DQotCX0NCi1lbmRfZnVuY3Rpb246DQotCWRiZygi
U0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX2luaXRfaGFuZGxlciBlbmRcbiIpOw0KLQlyZXR1cm4g
ZXJyb3I7DQotDQotfQ0KLQ0KLS8qDQotICB0aGlzIGZ1bmN0aW9uIGhhbmRsZXMgdGhlIHJlcXVl
c3QgY2FjaGUgYW5kIHJlc2lkZW50IHJlYWxsb2NhdGlvbg0KLSovDQotc3RhdGljIGludCBzZXBf
cmVhbGxvY19jYWNoZV9yZXNpZGVudF9oYW5kbGVyKHN0cnVjdCBzZXBfZGV2aWNlICpzZXAsDQot
CQkJCQkJdW5zaWduZWQgbG9uZyBhcmcpDQotew0KLQlzdHJ1Y3Qgc2VwX2RyaXZlcl9yZWFsbG9j
X2NhY2hlX3Jlc2lkZW50X3QgY29tbWFuZF9hcmdzOw0KLQlpbnQgZXJyb3I7DQotDQotCS8qIGNv
cHkgY2FjaGUgYW5kIHJlc2lkZW50IHRvIHRoZSB0aGVpciBpbnRlbmRlZCBsb2NhdGlvbnMgKi8N
Ci0JZXJyb3IgPSBzZXBfbG9hZF9maXJtd2FyZShzZXApOw0KLQlpZiAoZXJyb3IpDQotCQlyZXR1
cm4gZXJyb3I7DQotDQotCWNvbW1hbmRfYXJncy5uZXdfYmFzZV9hZGRyID0gc2VwLT5zaGFyZWRf
YnVzOw0KLQ0KLQkvKiBmaW5kIHRoZSBuZXcgYmFzZSBhZGRyZXNzIGFjY29yZGluZyB0byB0aGUg
bG93ZXN0IGFkZHJlc3MgYmV0d2Vlbg0KLQkgICBjYWNoZSwgcmVzaWRlbnQgYW5kIHNoYXJlZCBh
cmVhICovDQotCWlmIChzZXAtPnJlc2lkZW50X2J1cyA8IGNvbW1hbmRfYXJncy5uZXdfYmFzZV9h
ZGRyKQ0KLQkJY29tbWFuZF9hcmdzLm5ld19iYXNlX2FkZHIgPSBzZXAtPnJlc2lkZW50X2J1czsN
Ci0JaWYgKHNlcC0+cmFyX2J1cyA8IGNvbW1hbmRfYXJncy5uZXdfYmFzZV9hZGRyKQ0KLQkJY29t
bWFuZF9hcmdzLm5ld19iYXNlX2FkZHIgPSBzZXAtPnJhcl9idXM7DQotDQotCS8qIHNldCB0aGUg
cmV0dXJuIHBhcmFtZXRlcnMgKi8NCi0JY29tbWFuZF9hcmdzLm5ld19jYWNoZV9hZGRyID0gc2Vw
LT5yYXJfYnVzOw0KLQljb21tYW5kX2FyZ3MubmV3X3Jlc2lkZW50X2FkZHIgPSBzZXAtPnJlc2lk
ZW50X2J1czsNCi0NCi0JLyogc2V0IHRoZSBuZXcgc2hhcmVkIGFyZWEgKi8NCi0JY29tbWFuZF9h
cmdzLm5ld19zaGFyZWRfYXJlYV9hZGRyID0gc2VwLT5zaGFyZWRfYnVzOw0KLQ0KLQllZGJnKCJT
RVAgRHJpdmVyOmNvbW1hbmRfYXJncy5uZXdfc2hhcmVkX2FkZHIgaXMgJTA4bGx4XG4iLCBjb21t
YW5kX2FyZ3MubmV3X3NoYXJlZF9hcmVhX2FkZHIpOw0KLQllZGJnKCJTRVAgRHJpdmVyOmNvbW1h
bmRfYXJncy5uZXdfYmFzZV9hZGRyIGlzICUwOGxseFxuIiwgY29tbWFuZF9hcmdzLm5ld19iYXNl
X2FkZHIpOw0KLQllZGJnKCJTRVAgRHJpdmVyOmNvbW1hbmRfYXJncy5uZXdfcmVzaWRlbnRfYWRk
ciBpcyAlMDhsbHhcbiIsIGNvbW1hbmRfYXJncy5uZXdfcmVzaWRlbnRfYWRkcik7DQotCWVkYmco
IlNFUCBEcml2ZXI6Y29tbWFuZF9hcmdzLm5ld19yYXJfYWRkciBpcyAlMDhsbHhcbiIsIGNvbW1h
bmRfYXJncy5uZXdfY2FjaGVfYWRkcik7DQotDQotCS8qIHJldHVybiB0byB1c2VyICovDQotCWlm
IChjb3B5X3RvX3VzZXIoKHZvaWQgKikgYXJnLCAmY29tbWFuZF9hcmdzLCBzaXplb2Yoc3RydWN0
IHNlcF9kcml2ZXJfcmVhbGxvY19jYWNoZV9yZXNpZGVudF90KSkpDQotCQlyZXR1cm4gLUVGQVVM
VDsNCi0JcmV0dXJuIDA7DQotfQ0KLQ0KLS8qKg0KLSAqCXNlcF9nZXRfdGltZV9oYW5kbGVyCS0J
dGltZSByZXF1ZXN0IGZyb20gdXNlciBzcGFjZQ0KLSAqCUBzZXA6IHNlcCB3ZSBhcmUgdG8gc2V0
IHRoZSB0aW1lIGZvcg0KLSAqCUBhcmc6IHBvaW50ZXIgdG8gdXNlciBzcGFjZSBhcmcgYnVmZmVy
DQotICoNCi0gKglUaGlzIGZ1bmN0aW9uIHJlcG9ydHMgYmFjayB0aGUgdGltZSBhbmQgdGhlIGFk
ZHJlc3MgaW4gdGhlIFNFUA0KLSAqCXNoYXJlZCBidWZmZXIgYXQgd2hpY2ggaXQgaGFzIGJlZW4g
cGxhY2VkLiAoRG8gd2UgcmVhbGx5IG5lZWQgdGhpcyEhISkNCi0gKi8NCi0NCi1zdGF0aWMgaW50
IHNlcF9nZXRfdGltZV9oYW5kbGVyKHN0cnVjdCBzZXBfZGV2aWNlICpzZXAsIHVuc2lnbmVkIGxv
bmcgYXJnKQ0KLXsNCi0Jc3RydWN0IHNlcF9kcml2ZXJfZ2V0X3RpbWVfdCBjb21tYW5kX2FyZ3M7
DQotDQotCW11dGV4X2xvY2soJnNlcF9tdXRleCk7DQotCWNvbW1hbmRfYXJncy50aW1lX3ZhbHVl
ID0gc2VwX3NldF90aW1lKHNlcCk7DQotCWNvbW1hbmRfYXJncy50aW1lX3BoeXNpY2FsX2FkZHJl
c3MgPSAodW5zaWduZWQgbG9uZylzZXBfdGltZV9hZGRyZXNzKHNlcCk7DQotCW11dGV4X3VubG9j
aygmc2VwX211dGV4KTsNCi0JaWYgKGNvcHlfdG9fdXNlcigodm9pZCBfX3VzZXIgKilhcmcsDQot
CQkJJmNvbW1hbmRfYXJncywgc2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVyX2dldF90aW1lX3QpKSkN
Ci0JCQlyZXR1cm4gLUVGQVVMVDsNCi0JcmV0dXJuIDA7DQotDQotfQ0KLQ0KLS8qDQotICBUaGlz
IEFQSSBoYW5kbGVzIHRoZSBlbmQgdHJhbnNhY3Rpb24gcmVxdWVzdA0KLSovDQotc3RhdGljIGlu
dCBzZXBfZW5kX3RyYW5zYWN0aW9uX2hhbmRsZXIoc3RydWN0IHNlcF9kZXZpY2UgKnNlcCwgdW5z
aWduZWQgbG9uZyBhcmcpDQotew0KLQlkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9lbmRf
dHJhbnNhY3Rpb25faGFuZGxlciBzdGFydFxuIik7DQotDQotI2lmIDAJCQkJLyohU0VQX0RSSVZF
Ul9QT0xMSU5HX01PREUgKi8NCi0JLyogY2xvc2UgSU1SICovDQotCXNlcF93cml0ZV9yZWcoc2Vw
LCBIV19IT1NUX0lNUl9SRUdfQUREUiwgMHg3RkZGKTsNCi0NCi0JLyogcmVsZWFzZSBJUlEgbGlu
ZSAqLw0KLQlmcmVlX2lycShTRVBfRElSVkVSX0lSUV9OVU0sIHNlcCk7DQotDQotCS8qIGxvY2sg
dGhlIHNlcCBtdXRleCAqLw0KLQltdXRleF91bmxvY2soJnNlcF9tdXRleCk7DQotI2VuZGlmDQot
DQotCWRiZygiU0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX2VuZF90cmFuc2FjdGlvbl9oYW5kbGVy
IGVuZFxuIik7DQotDQotCXJldHVybiAwOw0KLX0NCi0NCi0NCi0vKioNCi0gKglzZXBfc2V0X2Zs
b3dfaWRfaGFuZGxlcgktCWhhbmRsZSBmbG93IHNldHRpbmcNCi0gKglAc2VwOiB0aGUgU0VQIHdl
IGFyZSBjb25maWd1cmluZw0KLSAqCUBmbG93X2lkOiB0aGUgZmxvdyB3ZSBhcmUgc2V0dGluZw0K
LSAqDQotICogVGhpcyBmdW5jdGlvbiBoYW5kbGVyIHRoZSBzZXQgZmxvdyBpZCBjb21tYW5kDQot
ICovDQotc3RhdGljIGludCBzZXBfc2V0X2Zsb3dfaWRfaGFuZGxlcihzdHJ1Y3Qgc2VwX2Rldmlj
ZSAqc2VwLA0KLQkJCQkJCXVuc2lnbmVkIGxvbmcgZmxvd19pZCkNCi17DQotCWludCBlcnJvciA9
IDA7DQotCXN0cnVjdCBzZXBfZmxvd19jb250ZXh0X3QgKmZsb3dfZGF0YV9wdHI7DQotDQotCS8q
IGZpbmQgdGhlIGZsb3cgZGF0YSBzdHJ1Y3R1cmUgdGhhdCB3YXMganVzdCB1c2VkIGZvciBjcmVh
dGluZyBuZXcgZmxvdw0KLQkgICAtIGl0cyBpZCBzaG91bGQgYmUgZGVmYXVsdCAqLw0KLQ0KLQlt
dXRleF9sb2NrKCZzZXBfbXV0ZXgpOw0KLQlmbG93X2RhdGFfcHRyID0gc2VwX2ZpbmRfZmxvd19j
b250ZXh0KHNlcCwgU0VQX1RFTVBfRkxPV19JRCk7DQotCWlmIChmbG93X2RhdGFfcHRyKQ0KLQkJ
Zmxvd19kYXRhX3B0ci0+Zmxvd19pZCA9IGZsb3dfaWQ7CS8qIHNldCBmbG93IGlkICovDQotCWVs
c2UNCi0JCWVycm9yID0gLUVJTlZBTDsNCi0JbXV0ZXhfdW5sb2NrKCZzZXBfbXV0ZXgpOw0KLQly
ZXR1cm4gZXJyb3I7DQotfQ0KLQ0KLXN0YXRpYyBsb25nIHNlcF9pb2N0bChzdHJ1Y3QgZmlsZSAq
ZmlscCwgdW5zaWduZWQgaW50IGNtZCwgdW5zaWduZWQgbG9uZyBhcmcpDQotew0KLQlpbnQgZXJy
b3IgPSAwOw0KLQlzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwID0gZmlscC0+cHJpdmF0ZV9kYXRhOw0K
LQ0KLQlkYmcoIi0tLS0tLS0tLS0tLT5TRVAgRHJpdmVyOiBpb2N0bCBzdGFydFxuIik7DQotDQot
CWVkYmcoIlNFUCBEcml2ZXI6IGNtZCBpcyAleFxuIiwgY21kKTsNCi0NCi0Jc3dpdGNoIChjbWQp
IHsNCi0JY2FzZSBTRVBfSU9DU0VORFNFUENPTU1BTkQ6DQotCQkvKiBzZW5kIGNvbW1hbmQgdG8g
U0VQICovDQotCQlzZXBfc2VuZF9jb21tYW5kX2hhbmRsZXIoc2VwKTsNCi0JCWVkYmcoIlNFUCBE
cml2ZXI6IGFmdGVyIHNlcF9zZW5kX2NvbW1hbmRfaGFuZGxlclxuIik7DQotCQlicmVhazsNCi0J
Y2FzZSBTRVBfSU9DU0VORFNFUFJQTFlDT01NQU5EOg0KLQkJLyogc2VuZCByZXBseSBjb21tYW5k
IHRvIFNFUCAqLw0KLQkJc2VwX3NlbmRfcmVwbHlfY29tbWFuZF9oYW5kbGVyKHNlcCk7DQotCQli
cmVhazsNCi0JY2FzZSBTRVBfSU9DQUxMT0NEQVRBUE9MTDoNCi0JCS8qIGFsbG9jYXRlIGRhdGEg
cG9vbCAqLw0KLQkJZXJyb3IgPSBzZXBfYWxsb2NhdGVfZGF0YV9wb29sX21lbW9yeV9oYW5kbGVy
KHNlcCwgYXJnKTsNCi0JCWJyZWFrOw0KLQljYXNlIFNFUF9JT0NXUklURURBVEFQT0xMOg0KLQkJ
Lyogd3JpdGUgZGF0YSBpbnRvIG1lbW9yeSBwb29sICovDQotCQllcnJvciA9IHNlcF93cml0ZV9p
bnRvX2RhdGFfcG9vbF9oYW5kbGVyKHNlcCwgYXJnKTsNCi0JCWJyZWFrOw0KLQljYXNlIFNFUF9J
T0NSRUFEREFUQVBPTEw6DQotCQkvKiByZWFkIGRhdGEgZnJvbSBkYXRhIHBvb2wgaW50byBhcHBs
aWNhdGlvbiBtZW1vcnkgKi8NCi0JCWVycm9yID0gc2VwX3JlYWRfZnJvbV9kYXRhX3Bvb2xfaGFu
ZGxlcihzZXAsIGFyZyk7DQotCQlicmVhazsNCi0JY2FzZSBTRVBfSU9DQ1JFQVRFU1lNRE1BVEFC
TEU6DQotCQkvKiBjcmVhdGUgZG1hIHRhYmxlIGZvciBzeW5ocm9uaWMgb3BlcmF0aW9uICovDQot
CQllcnJvciA9IHNlcF9jcmVhdGVfc3luY19kbWFfdGFibGVzX2hhbmRsZXIoc2VwLCBhcmcpOw0K
LQkJYnJlYWs7DQotCWNhc2UgU0VQX0lPQ0NSRUFURUZMT1dETUFUQUJMRToNCi0JCS8qIGNyZWF0
ZSBmbG93IGRtYSB0YWJsZXMgKi8NCi0JCWVycm9yID0gc2VwX2NyZWF0ZV9mbG93X2RtYV90YWJs
ZXNfaGFuZGxlcihzZXAsIGFyZyk7DQotCQlicmVhazsNCi0JY2FzZSBTRVBfSU9DRlJFRURNQVRB
QkxFREFUQToNCi0JCS8qIGZyZWUgdGhlIHBhZ2VzICovDQotCQllcnJvciA9IHNlcF9mcmVlX2Rt
YV90YWJsZV9kYXRhX2hhbmRsZXIoc2VwKTsNCi0JCWJyZWFrOw0KLQljYXNlIFNFUF9JT0NTRVRG
TE9XSUQ6DQotCQkvKiBzZXQgZmxvdyBpZCAqLw0KLQkJZXJyb3IgPSBzZXBfc2V0X2Zsb3dfaWRf
aGFuZGxlcihzZXAsICh1bnNpZ25lZCBsb25nKWFyZyk7DQotCQlicmVhazsNCi0JY2FzZSBTRVBf
SU9DQURERkxPV1RBQkxFOg0KLQkJLyogYWRkIHRhYmxlcyB0byB0aGUgZHluYW1pYyBmbG93ICov
DQotCQllcnJvciA9IHNlcF9hZGRfZmxvd190YWJsZXNfaGFuZGxlcihzZXAsIGFyZyk7DQotCQli
cmVhazsNCi0JY2FzZSBTRVBfSU9DQURERkxPV01FU1NBR0U6DQotCQkvKiBhZGQgbWVzc2FnZSBv
ZiBhZGQgdGFibGVzIHRvIGZsb3cgKi8NCi0JCWVycm9yID0gc2VwX2FkZF9mbG93X3RhYmxlc19t
ZXNzYWdlX2hhbmRsZXIoc2VwLCBhcmcpOw0KLQkJYnJlYWs7DQotCWNhc2UgU0VQX0lPQ1NFUFNU
QVJUOg0KLQkJLyogc3RhcnQgY29tbWFuZCB0byBzZXAgKi8NCi0JCWVycm9yID0gc2VwX3N0YXJ0
X2hhbmRsZXIoc2VwKTsNCi0JCWJyZWFrOw0KLQljYXNlIFNFUF9JT0NTRVBJTklUOg0KLQkJLyog
aW5pdCBjb21tYW5kIHRvIHNlcCAqLw0KLQkJZXJyb3IgPSBzZXBfaW5pdF9oYW5kbGVyKHNlcCwg
YXJnKTsNCi0JCWJyZWFrOw0KLQljYXNlIFNFUF9JT0NHRVRTVEFUSUNQT09MQUREUjoNCi0JCS8q
IGdldCB0aGUgcGh5c2ljYWwgYW5kIHZpcnR1YWwgYWRkcmVzc2VzIG9mIHRoZSBzdGF0aWMgcG9v
bCAqLw0KLQkJZXJyb3IgPSBzZXBfZ2V0X3N0YXRpY19wb29sX2FkZHJfaGFuZGxlcihzZXAsIGFy
Zyk7DQotCQlicmVhazsNCi0JY2FzZSBTRVBfSU9DRU5EVFJBTlNBQ1RJT046DQotCQllcnJvciA9
IHNlcF9lbmRfdHJhbnNhY3Rpb25faGFuZGxlcihzZXAsIGFyZyk7DQotCQlicmVhazsNCi0JY2Fz
ZSBTRVBfSU9DUkVBTExPQ0NBQ0hFUkVTOg0KLQkJZXJyb3IgPSBzZXBfcmVhbGxvY19jYWNoZV9y
ZXNpZGVudF9oYW5kbGVyKHNlcCwgYXJnKTsNCi0JCWJyZWFrOw0KLQljYXNlIFNFUF9JT0NHRVRN
QVBQRURBRERST0ZGU0VUOg0KLQkJZXJyb3IgPSBzZXBfZ2V0X3BoeXNpY2FsX21hcHBlZF9vZmZz
ZXRfaGFuZGxlcihzZXAsIGFyZyk7DQotCQlicmVhazsNCi0JY2FzZSBTRVBfSU9DR0VUSU1FOg0K
LQkJZXJyb3IgPSBzZXBfZ2V0X3RpbWVfaGFuZGxlcihzZXAsIGFyZyk7DQotCQlicmVhazsNCi0J
ZGVmYXVsdDoNCi0JCWVycm9yID0gLUVOT1RUWTsNCi0JCWJyZWFrOw0KLQl9DQotCWRiZygiU0VQ
IERyaXZlcjo8LS0tLS0tLS0gaW9jdGwgZW5kXG4iKTsNCi0JcmV0dXJuIGVycm9yOw0KLX0NCi0N
Ci0NCi0NCi0jaWYgIVNFUF9EUklWRVJfUE9MTElOR19NT0RFDQotDQotLyogaGFuZGxlciBmb3Ig
ZmxvdyBkb25lIGludGVycnVwdCAqLw0KLQ0KLXN0YXRpYyB2b2lkIHNlcF9mbG93X2RvbmVfaGFu
ZGxlcihzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQotew0KLQlzdHJ1Y3Qgc2VwX2Zsb3dfY29u
dGV4dF90ICpmbG93X2RhdGFfcHRyOw0KLQ0KLQkvKiBvYnRhaW4gdGhlIG11dGV4ICovDQotCW11
dGV4X2xvY2soJnNlcF9tdXRleCk7DQotDQotCS8qIGdldCB0aGUgcG9pbnRlciB0byBjb250ZXh0
ICovDQotCWZsb3dfZGF0YV9wdHIgPSAoc3RydWN0IHNlcF9mbG93X2NvbnRleHRfdCAqKSB3b3Jr
Ow0KLQ0KLQkvKiBmcmVlIGFsbCB0aGUgY3VycmVudCBpbnB1dCB0YWJsZXMgaW4gc2VwICovDQot
CXNlcF9kZWFsbG9jYXRlZF9mbG93X3RhYmxlcygmZmxvd19kYXRhX3B0ci0+aW5wdXRfdGFibGVz
X2luX3Byb2Nlc3MpOw0KLQ0KLQkvKiBmcmVlIGFsbCB0aGUgY3VycmVudCB0YWJsZXMgb3V0cHV0
IHRhYmxlcyBpbiBTRVAgKGlmIG5lZWRlZCkgKi8NCi0JaWYgKGZsb3dfZGF0YV9wdHItPm91dHB1
dF90YWJsZXNfaW5fcHJvY2Vzcy5waHlzaWNhbF9hZGRyZXNzICE9IDB4ZmZmZmZmZmYpDQotCQlz
ZXBfZGVhbGxvY2F0ZWRfZmxvd190YWJsZXMoJmZsb3dfZGF0YV9wdHItPm91dHB1dF90YWJsZXNf
aW5fcHJvY2Vzcyk7DQotDQotCS8qIGNoZWNrIGlmIHdlIGhhdmUgYWRkaXRpb25hbCB0YWJsZXMg
dG8gYmUgc2VudCB0byBTRVAgb25seSBpbnB1dA0KLQkgICBmbGFnIG1heSBiZSBjaGVja2VkICov
DQotCWlmIChmbG93X2RhdGFfcHRyLT5pbnB1dF90YWJsZXNfZmxhZykgew0KLQkJLyogY29weSB0
aGUgbWVzc2FnZSB0byB0aGUgc2hhcmVkIFJBTSBhbmQgc2lnbmFsIFNFUCAqLw0KLQkJbWVtY3B5
KCh2b2lkICopIGZsb3dfZGF0YV9wdHItPm1lc3NhZ2UsICh2b2lkICopIHNlcC0+c2hhcmVkX2Fk
ZHIsIGZsb3dfZGF0YV9wdHItPm1lc3NhZ2Vfc2l6ZV9pbl9ieXRlcyk7DQotDQotCQlzZXBfd3Jp
dGVfcmVnKHNlcCwgSFdfSE9TVF9IT1NUX1NFUF9HUFIyX1JFR19BRERSLCAweDIpOw0KLQl9DQot
CW11dGV4X3VubG9jaygmc2VwX211dGV4KTsNCi19DQotLyoNCi0gIGludGVycnVwdCBoYW5kbGVy
IGZ1bmN0aW9uDQotKi8NCi1zdGF0aWMgaXJxcmV0dXJuX3Qgc2VwX2ludGhhbmRsZXIoaW50IGly
cSwgdm9pZCAqZGV2X2lkKQ0KLXsNCi0JaXJxcmV0dXJuX3QgaW50X2Vycm9yOw0KLQl1bnNpZ25l
ZCBsb25nIHJlZ192YWw7DQotCXVuc2lnbmVkIGxvbmcgZmxvd19pZDsNCi0Jc3RydWN0IHNlcF9m
bG93X2NvbnRleHRfdCAqZmxvd19jb250ZXh0X3B0cjsNCi0Jc3RydWN0IHNlcF9kZXZpY2UgKnNl
cCA9IGRldl9pZDsNCi0NCi0JaW50X2Vycm9yID0gSVJRX0hBTkRMRUQ7DQotDQotCS8qIHJlYWQg
dGhlIElSUiByZWdpc3RlciB0byBjaGVjayBpZiB0aGlzIGlzIFNFUCBpbnRlcnJ1cHQgKi8NCi0J
cmVnX3ZhbCA9IHNlcF9yZWFkX3JlZyhzZXAsIEhXX0hPU1RfSVJSX1JFR19BRERSKTsNCi0JZWRi
ZygiU0VQIEludGVycnVwdCAtIHJlZyBpcyAlMDhseFxuIiwgcmVnX3ZhbCk7DQotDQotCS8qIGNo
ZWNrIGlmIHRoaXMgaXMgdGhlIGZsb3cgaW50ZXJydXB0ICovDQotCWlmICgwIC8qcmVnX3ZhbCAm
ICgweDEgPDwgMTEpICovICkgew0KLQkJLyogcmVhZCBHUFJPIHRvIGZpbmQgb3V0IHRoZSB3aGlj
aCBmbG93IGlzIGRvbmUgKi8NCi0JCWZsb3dfaWQgPSBzZXBfcmVhZF9yZWcoc2VwLCBIV19IT1NU
X0lSUl9SRUdfQUREUik7DQotDQotCQkvKiBmaW5kIHRoZSBjb250ZXggb2YgdGhlIGZsb3cgKi8N
Ci0JCWZsb3dfY29udGV4dF9wdHIgPSBzZXBfZmluZF9mbG93X2NvbnRleHQoc2VwLCBmbG93X2lk
ID4+IDI4KTsNCi0JCWlmIChmbG93X2NvbnRleHRfcHRyID09IE5VTEwpDQotCQkJZ290byBlbmRf
ZnVuY3Rpb25fd2l0aF9lcnJvcjsNCi0NCi0JCS8qIHF1ZXVlIHRoZSB3b3JrICovDQotCQlJTklU
X1dPUksoJmZsb3dfY29udGV4dF9wdHItPmZsb3dfd3EsIHNlcF9mbG93X2RvbmVfaGFuZGxlcik7
DQotCQlxdWV1ZV93b3JrKHNlcC0+Zmxvd193cSwgJmZsb3dfY29udGV4dF9wdHItPmZsb3dfd3Ep
Ow0KLQ0KLQl9IGVsc2Ugew0KLQkJLyogY2hlY2sgaWYgdGhpcyBpcyByZXBseSBpbnRlcnJ1cHQg
ZnJvbSBTRVAgKi8NCi0JCWlmIChyZWdfdmFsICYgKDB4MSA8PCAxMykpIHsNCi0JCQkvKiB1cGRh
dGUgdGhlIGNvdW50ZXIgb2YgcmVwbHkgbWVzc2FnZXMgKi8NCi0JCQlzZXAtPnJlcGx5X2N0Kys7
DQotCQkJLyogd2FrZSB1cCB0aGUgd2FpdGluZyBwcm9jZXNzICovDQotCQkJd2FrZV91cCgmc2Vw
X2V2ZW50KTsNCi0JCX0gZWxzZSB7DQotCQkJaW50X2Vycm9yID0gSVJRX05PTkU7DQotCQkJZ290
byBlbmRfZnVuY3Rpb247DQotCQl9DQotCX0NCi1lbmRfZnVuY3Rpb25fd2l0aF9lcnJvcjoNCi0J
LyogY2xlYXIgdGhlIGludGVycnVwdCAqLw0KLQlzZXBfd3JpdGVfcmVnKHNlcCwgSFdfSE9TVF9J
Q1JfUkVHX0FERFIsIHJlZ192YWwpOw0KLWVuZF9mdW5jdGlvbjoNCi0JcmV0dXJuIGludF9lcnJv
cjsNCi19DQotDQotI2VuZGlmDQotDQotDQotDQotI2lmIDANCi0NCi1zdGF0aWMgdm9pZCBzZXBf
d2FpdF9idXN5KHN0cnVjdCBzZXBfZGV2aWNlICpzZXApDQotew0KLQl1MzIgcmVnOw0KLQ0KLQlk
byB7DQotCQlyZWcgPSBzZXBfcmVhZF9yZWcoc2VwLCBIV19IT1NUX1NFUF9CVVNZX1JFR19BRERS
KTsNCi0JfSB3aGlsZSAocmVnKTsNCi19DQotDQotLyoNCi0gIFBBVENIIGZvciBjb25maWd1cmlu
ZyB0aGUgRE1BIHRvIHNpbmdsZSBidXJzdCBpbnN0ZWFkIG9mIG11bHRpLWJ1cnN0DQotKi8NCi1z
dGF0aWMgdm9pZCBzZXBfY29uZmlndXJlX2RtYV9idXJzdChzdHJ1Y3Qgc2VwX2RldmljZSAqc2Vw
KQ0KLXsNCi0jZGVmaW5lIAkgSFdfQUhCX1JEX1dSX0JVUlNUU19SRUdfQUREUiAJCSAweDBFMTBV
TA0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9jb25maWd1cmVfZG1hX2J1cnN0
IHN0YXJ0IFxuIik7DQotDQotCS8qIHJlcXVlc3QgYWNjZXNzIHRvIHJlZ2lzdGVycyBmcm9tIFNF
UCAqLw0KLQlzZXBfd3JpdGVfcmVnKHNlcCwgSFdfSE9TVF9IT1NUX1NFUF9HUFIwX1JFR19BRERS
LCAweDIpOw0KLQ0KLQlkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9jb25maWd1cmVfZG1h
X2J1cnN0IGZpbmlzaGVkIHJlcXVlc3QgYWNjZXNzIHRvIHJlZ2lzdGVycyBmcm9tIFNFUCAod3Jp
dGUgcmVnKSAgXG4iKTsNCi0NCi0Jc2VwX3dhaXRfYnVzeShzZXApOw0KLQ0KLQlkYmcoIlNFUCBE
cml2ZXI6PC0tLS0tLS0tIHNlcF9jb25maWd1cmVfZG1hX2J1cnN0IGZpbmlzaGVkIHJlcXVlc3Qg
YWNjZXNzIHRvIHJlZ2lzdGVycyBmcm9tIFNFUCAod2hpbGUocmV2VmFsKSB3YWl0IGxvb3ApICBc
biIpOw0KLQ0KLQkvKiBzZXQgdGhlIERNQSBidXJzdCByZWdpc3RlciB0byBzaW5nbGUgYnVyc3Qg
Ki8NCi0Jc2VwX3dyaXRlX3JlZyhzZXAsIEhXX0FIQl9SRF9XUl9CVVJTVFNfUkVHX0FERFIsIDB4
MFVMKTsNCi0NCi0JLyogcmVsZWFzZSB0aGUgc2VwIGJ1c3kgKi8NCi0Jc2VwX3dyaXRlX3JlZyhz
ZXAsIEhXX0hPU1RfSE9TVF9TRVBfR1BSMF9SRUdfQUREUiwgMHgwVUwpOw0KLQlzZXBfd2FpdF9i
dXN5KHNlcCk7DQotDQotCWRiZygiU0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX2NvbmZpZ3VyZV9k
bWFfYnVyc3QgZG9uZSAgXG4iKTsNCi0NCi19DQotDQotI2VuZGlmDQotDQotLyoNCi0gIEZ1bmN0
aW9uIHRoYXQgaXMgYWN0aXZhdGVkIG9uIHRoZSBzdWNjZXNzZnVsIHByb2JlIG9mIHRoZSBTRVAg
ZGV2aWNlDQotKi8NCi1zdGF0aWMgaW50IF9fZGV2aW5pdCBzZXBfcHJvYmUoc3RydWN0IHBjaV9k
ZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICplbnQpDQotew0KLQlpbnQgZXJy
b3IgPSAwOw0KLQlzdHJ1Y3Qgc2VwX2RldmljZSAqc2VwOw0KLQlpbnQgY291bnRlcjsNCi0JaW50
IHNpemU7CQkvKiBzaXplIG9mIG1lbW9yeSBmb3IgYWxsb2NhdGlvbiAqLw0KLQ0KLQllZGJnKCJT
ZXAgcGNpIHByb2JlIHN0YXJ0aW5nXG4iKTsNCi0JaWYgKHNlcF9kZXYgIT0gTlVMTCkgew0KLQkJ
ZGV2X3dhcm4oJnBkZXYtPmRldiwgIm9ubHkgb25lIFNFUCBzdXBwb3J0ZWQuXG4iKTsNCi0JCXJl
dHVybiAtRUJVU1k7DQotCX0NCi0NCi0JLyogZW5hYmxlIHRoZSBkZXZpY2UgKi8NCi0JZXJyb3Ig
PSBwY2lfZW5hYmxlX2RldmljZShwZGV2KTsNCi0JaWYgKGVycm9yKSB7DQotCQllZGJnKCJlcnJv
ciBlbmFibGluZyBwY2kgZGV2aWNlXG4iKTsNCi0JCWdvdG8gZW5kX2Z1bmN0aW9uOw0KLQl9DQot
DQotCS8qIHNldCB0aGUgcGNpIGRldiBwb2ludGVyICovDQotCXNlcF9kZXYgPSAmc2VwX2luc3Rh
bmNlOw0KLQlzZXAgPSAmc2VwX2luc3RhbmNlOw0KLQ0KLQllZGJnKCJzZXAtPnNoYXJlZF9hZGRy
ID0gJXBcbiIsIHNlcC0+c2hhcmVkX2FkZHIpOw0KLQkvKiB0cmFuc2FjdGlvbiBjb3VudGVyIHRo
YXQgY29vcmRpbmF0ZXMgdGhlIHRyYW5zYWN0aW9ucyBiZXR3ZWVuIFNFUA0KLQlhbmQgSE9TVCAq
Lw0KLQlzZXAtPnNlbmRfY3QgPSAwOw0KLQkvKiBjb3VudGVyIGZvciB0aGUgbWVzc2FnZXMgZnJv
bSBzZXAgKi8NCi0Jc2VwLT5yZXBseV9jdCA9IDA7DQotCS8qIGNvdW50ZXIgZm9yIHRoZSBudW1i
ZXIgb2YgYnl0ZXMgYWxsb2NhdGVkIGluIHRoZSBwb29sDQotCWZvciB0aGUgY3VycmVudCB0cmFu
c2FjdGlvbiAqLw0KLQlzZXAtPmRhdGFfcG9vbF9ieXRlc19hbGxvY2F0ZWQgPSAwOw0KLQ0KLQkv
KiBjYWxjdWxhdGUgdGhlIHRvdGFsIHNpemUgZm9yIGFsbG9jYXRpb24gKi8NCi0Jc2l6ZSA9IFNF
UF9EUklWRVJfTUVTU0FHRV9TSEFSRURfQVJFQV9TSVpFX0lOX0JZVEVTICsNCi0JICAgIFNFUF9E
UklWRVJfU1lOQ0hST05JQ19ETUFfVEFCTEVTX0FSRUFfU0laRV9JTl9CWVRFUyArIFNFUF9EUklW
RVJfREFUQV9QT09MX1NIQVJFRF9BUkVBX1NJWkVfSU5fQllURVMgKyBTRVBfRFJJVkVSX0ZMT1df
RE1BX1RBQkxFU19BUkVBX1NJWkVfSU5fQllURVMgKyBTRVBfRFJJVkVSX1NUQVRJQ19BUkVBX1NJ
WkVfSU5fQllURVMgKyBTRVBfRFJJVkVSX1NZU1RFTV9EQVRBX01FTU9SWV9TSVpFX0lOX0JZVEVT
Ow0KLQ0KLQkvKiBhbGxvY2F0ZSB0aGUgc2hhcmVkIGFyZWEgKi8NCi0JaWYgKHNlcF9tYXBfYW5k
X2FsbG9jX3NoYXJlZF9hcmVhKHNlcCwgc2l6ZSkpIHsNCi0JCWVycm9yID0gLUVOT01FTTsNCi0J
CS8qIGFsbG9jYXRpb24gZmFpbGVkICovDQotCQlnb3RvIGVuZF9mdW5jdGlvbl9lcnJvcjsNCi0J
fQ0KLQkvKiBub3cgc2V0IHRoZSBtZW1vcnkgcmVnaW9ucyAqLw0KLSNpZiAoU0VQX0RSSVZFUl9S
RUNPTkZJR19NRVNTQUdFX0FSRUEgPT0gMSkNCi0JLyogTm90ZTogdGhpcyB0ZXN0IHNlY3Rpb24g
d2lsbCBuZWVkIG1vdmluZyBiZWZvcmUgaXQgY291bGQgZXZlcg0KLQkgICB3b3JrIGFzIHRoZSBy
ZWdpc3RlcnMgYXJlIG5vdCB5ZXQgbWFwcGVkICEgKi8NCi0JLyogc2VuZCB0aGUgbmV3IFNIQVJF
RCBNRVNTQUdFIEFSRUEgdG8gdGhlIFNFUCAqLw0KLQlzZXBfd3JpdGVfcmVnKHNlcCwgSFdfSE9T
VF9IT1NUX1NFUF9HUFIxX1JFR19BRERSLCBzZXAtPnNoYXJlZF9idXMpOw0KLQ0KLQkvKiBwb2xs
IGZvciBTRVAgcmVzcG9uc2UgKi8NCi0JcmV0dmFsID0gc2VwX3JlYWRfcmVnKHNlcCwgSFdfSE9T
VF9TRVBfSE9TVF9HUFIxX1JFR19BRERSKTsNCi0Jd2hpbGUgKHJldHZhbCAhPSAweGZmZmZmZmZm
ICYmIHJldHZhbCAhPSBzZXAtPnNoYXJlZF9idXMpDQotCQlyZXR2YWwgPSBzZXBfcmVhZF9yZWco
c2VwLCBIV19IT1NUX1NFUF9IT1NUX0dQUjFfUkVHX0FERFIpOw0KLQ0KLQkvKiBjaGVjayB0aGUg
cmV0dXJuIHZhbHVlIChyZWdpc3RlcikgKi8NCi0JaWYgKHJldHZhbCAhPSBzZXAtPnNoYXJlZF9i
dXMpIHsNCi0JCWVycm9yID0gLUVOT01FTTsNCi0JCWdvdG8gZW5kX2Z1bmN0aW9uX2RlYWxsb2Nh
dGVfc2VwX3NoYXJlZF9hcmVhOw0KLQl9DQotI2VuZGlmDQotCS8qIGluaXQgdGhlIGZsb3cgY29u
dGV4dGVzICovDQotCWZvciAoY291bnRlciA9IDA7IGNvdW50ZXIgPCBTRVBfRFJJVkVSX05VTV9G
TE9XUzsgY291bnRlcisrKQ0KLQkJc2VwLT5mbG93c1tjb3VudGVyXS5mbG93X2lkID0gU0VQX0ZS
RUVfRkxPV19JRDsNCi0NCi0Jc2VwLT5mbG93X3dxID0gY3JlYXRlX3NpbmdsZXRocmVhZF93b3Jr
cXVldWUoInNlcGZsb3d3cSIpOw0KLQlpZiAoc2VwLT5mbG93X3dxID09IE5VTEwpIHsNCi0JCWVy
cm9yID0gLUVOT01FTTsNCi0JCWVkYmcoInNlcF9kcml2ZXI6ZmxvdyBxdWV1ZSBjcmVhdGlvbiBm
YWlsZWRcbiIpOw0KLQkJZ290byBlbmRfZnVuY3Rpb25fZGVhbGxvY2F0ZV9zZXBfc2hhcmVkX2Fy
ZWE7DQotCX0NCi0JZWRiZygiU0VQIERyaXZlcjogY3JlYXRlIGZsb3cgd29ya3F1ZXVlIFxuIik7
DQotCXNlcC0+cGRldiA9IHBjaV9kZXZfZ2V0KHBkZXYpOw0KLQ0KLQlzZXAtPnJlZ19hZGRyID0g
cGNpX2lvcmVtYXBfYmFyKHBkZXYsIDApOw0KLQlpZiAoIXNlcC0+cmVnX2FkZHIpIHsNCi0JCWVk
YmcoInNlcDogaW9yZW1hcCBvZiByZWdpc3RlcnMgZmFpbGVkLlxuIik7DQotCQlnb3RvIGVuZF9m
dW5jdGlvbl9kZWFsbG9jYXRlX3NlcF9zaGFyZWRfYXJlYTsNCi0JfQ0KLQllZGJnKCJTRVAgRHJp
dmVyOnJlZ19hZGRyIGlzICVwXG4iLCBzZXAtPnJlZ19hZGRyKTsNCi0NCi0JLyogbG9hZCB0aGUg
cm9tIGNvZGUgKi8NCi0Jc2VwX2xvYWRfcm9tX2NvZGUoc2VwKTsNCi0NCi0JLyogc2V0IHVwIHN5
c3RlbSBiYXNlIGFkZHJlc3MgYW5kIHNoYXJlZCBtZW1vcnkgbG9jYXRpb24gKi8NCi0Jc2VwLT5y
YXJfYWRkciA9IGRtYV9hbGxvY19jb2hlcmVudCgmc2VwLT5wZGV2LT5kZXYsDQotCQkJMiAqIFNF
UF9SQVJfSU9fTUVNX1JFR0lPTl9TSVpFLA0KLQkJCSZzZXAtPnJhcl9idXMsIEdGUF9LRVJORUwp
Ow0KLQ0KLQlpZiAoIXNlcC0+cmFyX2FkZHIpIHsNCi0JCWVkYmcoIlNFUCBEcml2ZXI6Y2FuJ3Qg
YWxsb2NhdGUgcmFyXG4iKTsNCi0JCWdvdG8gZW5kX2Z1bmN0aW9uX3VuaW9tYXA7DQotCX0NCi0N
Ci0NCi0JZWRiZygiU0VQIERyaXZlcjpyYXJfYnVzIGlzICUwOGxseFxuIiwgKHVuc2lnbmVkIGxv
bmcgbG9uZylzZXAtPnJhcl9idXMpOw0KLQllZGJnKCJTRVAgRHJpdmVyOnJhcl92aXJ0dWFsIGlz
ICVwXG4iLCBzZXAtPnJhcl9hZGRyKTsNCi0NCi0jaWYgIVNFUF9EUklWRVJfUE9MTElOR19NT0RF
DQotDQotCWVkYmcoIlNFUCBEcml2ZXI6IGFib3V0IHRvIHdyaXRlIElNUiBhbmQgSUNSIFJFR19B
RERSXG4iKTsNCi0NCi0JLyogY2xlYXIgSUNSIHJlZ2lzdGVyICovDQotCXNlcF93cml0ZV9yZWco
c2VwLCBIV19IT1NUX0lDUl9SRUdfQUREUiwgMHhGRkZGRkZGRik7DQotDQotCS8qIHNldCB0aGUg
SU1SIHJlZ2lzdGVyIC0gb3BlbiBvbmx5IEdQUiAyICovDQotCXNlcF93cml0ZV9yZWcoc2VwLCBI
V19IT1NUX0lNUl9SRUdfQUREUiwgKH4oMHgxIDw8IDEzKSkpOw0KLQ0KLQllZGJnKCJTRVAgRHJp
dmVyOiBhYm91dCB0byBjYWxsIHJlcXVlc3RfaXJxXG4iKTsNCi0JLyogZ2V0IHRoZSBpbnRlcnJ1
cHQgbGluZSAqLw0KLQllcnJvciA9IHJlcXVlc3RfaXJxKHBkZXYtPmlycSwgc2VwX2ludGhhbmRs
ZXIsIElSUUZfU0hBUkVELCAic2VwX2RyaXZlciIsIHNlcCk7DQotCWlmIChlcnJvcikNCi0JCWdv
dG8gZW5kX2Z1bmN0aW9uX2ZyZWVfcmVzOw0KLQlyZXR1cm4gMDsNCi0JZWRiZygiU0VQIERyaXZl
cjogYWJvdXQgdG8gd3JpdGUgSU1SIFJFR19BRERSIik7DQotDQotCS8qIHNldCB0aGUgSU1SIHJl
Z2lzdGVyIC0gb3BlbiBvbmx5IEdQUiAyICovDQotCXNlcF93cml0ZV9yZWcoc2VwLCBIV19IT1NU
X0lNUl9SRUdfQUREUiwgKH4oMHgxIDw8IDEzKSkpOw0KLQ0KLWVuZF9mdW5jdGlvbl9mcmVlX3Jl
czoNCi0JZG1hX2ZyZWVfY29oZXJlbnQoJnNlcC0+cGRldi0+ZGV2LCAyICogU0VQX1JBUl9JT19N
RU1fUkVHSU9OX1NJWkUsDQotCQkJc2VwLT5yYXJfYWRkciwgc2VwLT5yYXJfYnVzKTsNCi0jZW5k
aWYJCQkJLyogU0VQX0RSSVZFUl9QT0xMSU5HX01PREUgKi8NCi1lbmRfZnVuY3Rpb25fdW5pb21h
cDoNCi0JaW91bm1hcChzZXAtPnJlZ19hZGRyKTsNCi1lbmRfZnVuY3Rpb25fZGVhbGxvY2F0ZV9z
ZXBfc2hhcmVkX2FyZWE6DQotCS8qIGRlLWFsbG9jYXRlIHNoYXJlZCBhcmVhICovDQotCXNlcF91
bm1hcF9hbmRfZnJlZV9zaGFyZWRfYXJlYShzZXAsIHNpemUpOw0KLWVuZF9mdW5jdGlvbl9lcnJv
cjoNCi0Jc2VwX2RldiA9IE5VTEw7DQotZW5kX2Z1bmN0aW9uOg0KLQlyZXR1cm4gZXJyb3I7DQot
fQ0KLQ0KLXN0YXRpYyBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCBzZXBfcGNpX2lkX3RibFtd
ID0gew0KLQl7UENJX0RFVklDRShQQ0lfVkVORE9SX0lEX0lOVEVMLCAweDA4MGMpfSwNCi0JezB9
DQotfTsNCi0NCi1NT0RVTEVfREVWSUNFX1RBQkxFKHBjaSwgc2VwX3BjaV9pZF90YmwpOw0KLQ0K
LS8qIGZpZWxkIGZvciByZWdpc3RlcmluZyBkcml2ZXIgdG8gUENJIGRldmljZSAqLw0KLXN0YXRp
YyBzdHJ1Y3QgcGNpX2RyaXZlciBzZXBfcGNpX2RyaXZlciA9IHsNCi0JLm5hbWUgPSAic2VwX3Nl
Y19kcml2ZXIiLA0KLQkuaWRfdGFibGUgPSBzZXBfcGNpX2lkX3RibCwNCi0JLnByb2JlID0gc2Vw
X3Byb2JlDQotCS8qIEZJWE1FOiByZW1vdmUgaGFuZGxlciAqLw0KLX07DQotDQotLyogbWFqb3Ig
YW5kIG1pbm9yIGRldmljZSBudW1iZXJzICovDQotc3RhdGljIGRldl90IHNlcF9kZXZubzsNCi0N
Ci0vKiB0aGUgZmlsZXMgb3BlcmF0aW9ucyBzdHJ1Y3R1cmUgb2YgdGhlIGRyaXZlciAqLw0KLXN0
YXRpYyBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHNlcF9maWxlX29wZXJhdGlvbnMgPSB7DQotCS5v
d25lciA9IFRISVNfTU9EVUxFLA0KLQkudW5sb2NrZWRfaW9jdGwgPSBzZXBfaW9jdGwsDQotCS5w
b2xsID0gc2VwX3BvbGwsDQotCS5vcGVuID0gc2VwX29wZW4sDQotCS5yZWxlYXNlID0gc2VwX3Jl
bGVhc2UsDQotCS5tbWFwID0gc2VwX21tYXAsDQotfTsNCi0NCi0NCi0vKiBjZGV2IHN0cnVjdCBv
ZiB0aGUgZHJpdmVyICovDQotc3RhdGljIHN0cnVjdCBjZGV2IHNlcF9jZGV2Ow0KLQ0KLS8qDQot
ICB0aGlzIGZ1bmN0aW9uIHJlZ2lzdGVycyB0aGUgZHJpdmVyIHRvIHRoZSBmaWxlIHN5c3RlbQ0K
LSovDQotc3RhdGljIGludCBzZXBfcmVnaXN0ZXJfZHJpdmVyX3RvX2ZzKHZvaWQpDQotew0KLQlp
bnQgcmV0X3ZhbCA9IGFsbG9jX2NocmRldl9yZWdpb24oJnNlcF9kZXZubywgMCwgMSwgInNlcF9z
ZWNfZHJpdmVyIik7DQotCWlmIChyZXRfdmFsKSB7DQotCQllZGJnKCJzZXA6IG1ham9yIG51bWJl
ciBhbGxvY2F0aW9uIGZhaWxlZCwgcmV0dmFsIGlzICVkXG4iLA0KLQkJCQkJCQkJcmV0X3ZhbCk7
DQotCQlyZXR1cm4gcmV0X3ZhbDsNCi0JfQ0KLQkvKiBpbml0IGNkZXYgKi8NCi0JY2Rldl9pbml0
KCZzZXBfY2RldiwgJnNlcF9maWxlX29wZXJhdGlvbnMpOw0KLQlzZXBfY2Rldi5vd25lciA9IFRI
SVNfTU9EVUxFOw0KLQ0KLQkvKiByZWdpc3RlciB0aGUgZHJpdmVyIHdpdGggdGhlIGtlcm5lbCAq
Lw0KLQlyZXRfdmFsID0gY2Rldl9hZGQoJnNlcF9jZGV2LCBzZXBfZGV2bm8sIDEpOw0KLQlpZiAo
cmV0X3ZhbCkgew0KLQkJZWRiZygic2VwX2RyaXZlcjpjZGV2X2FkZCBmYWlsZWQsIHJldHZhbCBp
cyAlZFxuIiwgcmV0X3ZhbCk7DQotCQkvKiB1bnJlZ2lzdGVyIGRldiBudW1iZXJzICovDQotCQl1
bnJlZ2lzdGVyX2NocmRldl9yZWdpb24oc2VwX2Rldm5vLCAxKTsNCi0JfQ0KLQlyZXR1cm4gcmV0
X3ZhbDsNCi19DQotDQotDQotLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KLSAgaW5pdCBmdW5jdGlvbg0KLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0K
LXN0YXRpYyBpbnQgX19pbml0IHNlcF9pbml0KHZvaWQpDQotew0KLQlpbnQgcmV0X3ZhbCA9IDA7
DQotCWRiZygiU0VQIERyaXZlcjotLS0tLS0tLT5Jbml0IHN0YXJ0XG4iKTsNCi0JLyogRklYTUU6
IFByb2JlIGNhbiBvY2N1ciBiZWZvcmUgd2UgYXJlIHJlYWR5IHRvIHN1cnZpdmUgYSBwcm9iZSAq
Lw0KLQlyZXRfdmFsID0gcGNpX3JlZ2lzdGVyX2RyaXZlcigmc2VwX3BjaV9kcml2ZXIpOw0KLQlp
ZiAocmV0X3ZhbCkgew0KLQkJZWRiZygic2VwX2RyaXZlcjpzZXBfZHJpdmVyX3RvX2RldmljZSBm
YWlsZWQsIHJldF92YWwgaXMgJWRcbiIsIHJldF92YWwpOw0KLQkJZ290byBlbmRfZnVuY3Rpb25f
dW5yZWdpc3Rlcl9mcm9tX2ZzOw0KLQl9DQotCS8qIHJlZ2lzdGVyIGRyaXZlciB0byBmcyAqLw0K
LQlyZXRfdmFsID0gc2VwX3JlZ2lzdGVyX2RyaXZlcl90b19mcygpOw0KLQlpZiAocmV0X3ZhbCkN
Ci0JCWdvdG8gZW5kX2Z1bmN0aW9uX3VucmVnaXN0ZXJfcGNpOw0KLQlnb3RvIGVuZF9mdW5jdGlv
bjsNCi1lbmRfZnVuY3Rpb25fdW5yZWdpc3Rlcl9wY2k6DQotCXBjaV91bnJlZ2lzdGVyX2RyaXZl
cigmc2VwX3BjaV9kcml2ZXIpOw0KLWVuZF9mdW5jdGlvbl91bnJlZ2lzdGVyX2Zyb21fZnM6DQot
CS8qIHVucmVnaXN0ZXIgZnJvbSBmcyAqLw0KLQljZGV2X2RlbCgmc2VwX2NkZXYpOw0KLQkvKiB1
bnJlZ2lzdGVyIGRldiBudW1iZXJzICovDQotCXVucmVnaXN0ZXJfY2hyZGV2X3JlZ2lvbihzZXBf
ZGV2bm8sIDEpOw0KLWVuZF9mdW5jdGlvbjoNCi0JZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBJ
bml0IGVuZFxuIik7DQotCXJldHVybiByZXRfdmFsOw0KLX0NCi0NCi0NCi0vKi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCi0gIGV4
aXQgZnVuY3Rpb24NCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLSovDQotc3RhdGljIHZvaWQgX19leGl0IHNlcF9leGl0KHZvaWQp
DQotew0KLQlpbnQgc2l6ZTsNCi0NCi0JZGJnKCJTRVAgRHJpdmVyOi0tLS0tLS0tPiBFeGl0IHN0
YXJ0XG4iKTsNCi0NCi0JLyogdW5yZWdpc3RlciBmcm9tIGZzICovDQotCWNkZXZfZGVsKCZzZXBf
Y2Rldik7DQotCS8qIHVucmVnaXN0ZXIgZGV2IG51bWJlcnMgKi8NCi0JdW5yZWdpc3Rlcl9jaHJk
ZXZfcmVnaW9uKHNlcF9kZXZubywgMSk7DQotCS8qIGNhbGN1bGF0ZSB0aGUgdG90YWwgc2l6ZSBm
b3IgZGUtYWxsb2NhdGlvbiAqLw0KLQlzaXplID0gU0VQX0RSSVZFUl9NRVNTQUdFX1NIQVJFRF9B
UkVBX1NJWkVfSU5fQllURVMgKw0KLQkgICAgU0VQX0RSSVZFUl9TWU5DSFJPTklDX0RNQV9UQUJM
RVNfQVJFQV9TSVpFX0lOX0JZVEVTICsgU0VQX0RSSVZFUl9EQVRBX1BPT0xfU0hBUkVEX0FSRUFf
U0laRV9JTl9CWVRFUyArIFNFUF9EUklWRVJfRkxPV19ETUFfVEFCTEVTX0FSRUFfU0laRV9JTl9C
WVRFUyArIFNFUF9EUklWRVJfU1RBVElDX0FSRUFfU0laRV9JTl9CWVRFUyArIFNFUF9EUklWRVJf
U1lTVEVNX0RBVEFfTUVNT1JZX1NJWkVfSU5fQllURVM7DQotCS8qIEZJWE1FOiBXZSBuZWVkIHRv
IGRvIHRoaXMgaW4gdGhlIHVubG9hZCBmb3IgdGhlIGRldmljZSAqLw0KLQkvKiBmcmVlIHNoYXJl
ZCBhcmVhICAqLw0KLQlpZiAoc2VwX2Rldikgew0KLQkJc2VwX3VubWFwX2FuZF9mcmVlX3NoYXJl
ZF9hcmVhKHNlcF9kZXYsIHNpemUpOw0KLQkJZWRiZygiU0VQIERyaXZlcjogZnJlZSBwYWdlcyBT
RVAgU0hBUkVEIEFSRUEgXG4iKTsNCi0JCWlvdW5tYXAoKHZvaWQgKikgc2VwX2Rldi0+cmVnX2Fk
ZHIpOw0KLQkJZWRiZygiU0VQIERyaXZlcjogaW91bm1hcCBcbiIpOw0KLQl9DQotCWVkYmcoIlNF
UCBEcml2ZXI6IHJlbGVhc2VfbWVtX3JlZ2lvbiBcbiIpOw0KLQlkYmcoIlNFUCBEcml2ZXI6PC0t
LS0tLS0tIEV4aXQgZW5kXG4iKTsNCi19DQotDQotDQotbW9kdWxlX2luaXQoc2VwX2luaXQpOw0K
LW1vZHVsZV9leGl0KHNlcF9leGl0KTsNCi0NCi1NT0RVTEVfTElDRU5TRSgiR1BMIik7DQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3NlcC9zZXBfZXh0X3dpdGhfcGNpX2RyaXZlci5jIGIv
ZHJpdmVycy9zdGFnaW5nL3NlcC9zZXBfZXh0X3dpdGhfcGNpX2RyaXZlci5jDQpuZXcgZmlsZSBt
b2RlIDEwMDY0NA0KaW5kZXggMDAwMDAwMC4uNjhkYTAwZQ0KLS0tIC9kZXYvbnVsbA0KKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3NlcC9zZXBfZXh0X3dpdGhfcGNpX2RyaXZlci5jDQpAQCAtMCwwICsx
LDU0OCBAQA0KKy8qDQorICoNCisgKiAgc2VwX2V4dF93aXRoX3BjaV9kcml2ZXIuYyAtIFNlY3Vy
aXR5IFByb2Nlc3NvciBEcml2ZXINCisgKiAgcGNpIGluaXRpYWxpemF0aW9uIGZ1bmN0aW9ucw0K
KyAqDQorICoNCisgKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioNCisgKiAgIENvcHlyaWdodCAyMDA5IMKpIERp
c2NyZXRpeCBUZWNobm9sb2dpZXMgTHRkLiAgICAgICAgICAgICAgICAgICAgICAgICAgKg0KKyAq
ICAgQ29weXJpZ2h0IDIwMDkgwqkgSW50ZWwgQ29ycG9yYXRpb24gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqDQorICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKg0KKyAqICAgVGhpcyBzb2Z0
d2FyZSBpcyBwcm90ZWN0ZWQgYnkgY29weXJpZ2h0LCBpbnRlcm5hdGlvbmFsIHRyZWF0aWVzIGFu
ZCAgICoNCisgKiAgIHZhcmlvdXMgcGF0ZW50cy4gQW55IGNvcHkgb3IgcmVwcm9kdWN0aW9uIG9m
IHRoaXMgU29mdHdhcmUgYXMgICAgICAgICAqDQorICogICBwZXJtaXR0ZWQgYmVsb3csIG11c3Qg
aW5jbHVkZSB0aGlzIENvcHlyaWdodCBOb3RpY2UgYXMgd2VsbCBhcyBhbnkgICAgKg0KKyAqICAg
b3RoZXIgbm90aWNlcyBwcm92aWRlZCB1bmRlciBzdWNoIGxpY2Vuc2UuICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICoNCisgKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqDQorICogICBUaGlzIHByb2dyYW0g
c2hhbGwgYmUgZ292ZXJuZWQgYnksIGFuZCBtYXkgYmUgdXNlZCBhbmQgcmVkaXN0cmlidXRlZCAg
Kg0KKyAqICAgdW5kZXIgdGhlIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHRoZSBHTlUgR2VuZXJh
bCBQdWJsaWMgTGljZW5zZSwgICAgICoNCisgKiAgIHZlcnNpb24gMiwgYXMgcHVibGlzaGVkIGJ5
IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24uICAgICAgICAgICAgICAqDQorICogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKg0KKyAqICAgVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3Bl
IHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsICAgICAgICoNCisgKiAgIGJ1dCBXSVRIT1VUIEFOWSBs
aWFiaWxpdHkgYW5kIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgICAgICAqDQor
ICogICB3YXJyYW50eSBvZiBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNV
TEFSIFBVUlBPU0UuICAgICAgKg0KKyAqICAgU2VlIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGlj
ZW5zZSBmb3IgbW9yZSBkZXRhaWxzLiAgICAgICAgICAgICAgICAgICoNCisgKiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAqDQorICogICBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUg
R2VuZXJhbCBQdWJsaWMgTGljZW5zZSAgICAgKg0KKyAqICAgYWxvbmcgd2l0aCB0aGlzIHByb2dy
YW07IGlmIG5vdCwgcGxlYXNlIHdyaXRlIHRvIHRoZSBGcmVlIFNvZnR3YXJlICAgICoNCisgKiAg
IEZvdW5kYXRpb24sIEluYy4sICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAqDQorICogICA1OSBUZW1wbGUgUGxhY2UgLSBTdWl0ZSAzMzAsIEJvc3Rv
biwgTUEgIDAyMTExLTEzMDcsIFVTQS4gICAgICAgICAgICAgKg0KKyAqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
Kg0KKyAqDQorICogIENPTlRBQ1RTOg0KKyAqDQorICogIE1hcmsgQWxseW4JCW1hcmsuYS5hbGx5
bkBpbnRlbC5jb20NCisgKg0KKyAqICBDSEFOR0VTOg0KKyAqDQorICogIDIwMTAuMDEuMDgJSW5p
dGlhbCBwdWJsaXNoDQorICoNCisgKi8NCisNCisjZGVmaW5lIERFQlVHDQorDQorI2luY2x1ZGUg
PGxpbnV4L2luaXQuaD4NCisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQorI2luY2x1ZGUgPGxp
bnV4L2ZzLmg+DQorI2luY2x1ZGUgPGxpbnV4L2NkZXYuaD4NCisjaW5jbHVkZSA8bGludXgva2Rl
dl90Lmg+DQorI2luY2x1ZGUgPGxpbnV4L3NlbWFwaG9yZS5oPg0KKyNpbmNsdWRlIDxsaW51eC9t
bS5oPg0KKyNpbmNsdWRlIDxsaW51eC9wb2xsLmg+DQorI2luY2x1ZGUgPGxpbnV4L3dhaXQuaD4N
CisjaW5jbHVkZSA8bGludXgvaW9jdGwuaD4NCisjaW5jbHVkZSA8bGludXgvaW9wb3J0Lmg+DQor
I2luY2x1ZGUgPGxpbnV4L2lvLmg+DQorI2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPg0KKyNp
bmNsdWRlIDxsaW51eC9wYWdlbWFwLmg+DQorI2luY2x1ZGUgPGxpbnV4L3BjaS5oPg0KKyNpbmNs
dWRlIDxsaW51eC9maXJtd2FyZS5oPg0KKyNpbmNsdWRlIDxsaW51eC9zY2hlZC5oPg0KKw0KKyNp
bmNsdWRlIDxsaW51eC9yYXIvbWVtcmFyLmg+DQorI2luY2x1ZGUgPGxpbnV4L3Jhci9yYXJfcmVn
aXN0ZXIuaD4NCisNCisjaW5jbHVkZSAic2VwX2RyaXZlcl9od19kZWZzLmgiDQorI2luY2x1ZGUg
InNlcF9kcml2ZXJfY29uZmlnLmgiDQorI2luY2x1ZGUgInNlcF9kcml2ZXJfYXBpLmgiDQorI2lu
Y2x1ZGUgInNlcF9kcml2ZXJfZXh0X2FwaS5oIg0KKw0KKy8qIE5PVEUgLSBtdXN0IGJlIGRlZmlu
ZWQgc3BlY2lmaWMgdG8gdGhlIGJvYXJkICovDQorI2RlZmluZSBWRU5ET1JfSUQJUENJX1ZFTkRP
Ul9JRF9JTlRFTA0KKw0KKy8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCisgICAgcHJp
dmF0ZSBmdW5jdGlvbnMNCistLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQor
LyoNCisgIFRoaXMgZnVuY3Rpb25zIGxvY2tzIHRoZSBhcmVhIG9mIHRoZSByZXNkZW50IGFuZCBj
YWNoZSBzZXAgY29kZQ0KKyovDQoraW50IHNlcF9sb2NrX2NhY2hlX3Jlc2lkZW50X2FyZWEodm9p
ZCkNCit7DQorCWludCBlcnJvcjsNCisJZXJyb3IgPSByYXJfbG9jayhSQVJfVFlQRV9JTUFHRSk7
DQorCWlmIChlcnJvcikgew0KKwkJcHJfZGVidWcoIlNFUCBEcml2ZXI6Y2FudCBsb2NrIFJBUiBy
ZWdpb24gJWRcbiIsDQorCQkgIGVycm9yKTsNCisJCXJldHVybiBlcnJvcjsNCisJfQ0KKwlyZXR1
cm4gMDsNCit9DQorDQorDQorLyoNCisgIFRoaXMgZnVuY3Rpb25zIGNvcGllcyB0aGUgY2FjaGUg
YW5kIHJlc2lkZW50IGZyb20gdGhlaXIgc291cmNlIGxvY2F0aW9uIGludG8NCisgIGRlc3RpbmF0
aW9uIG1lbW9yeSwgd2hpY2ggaXMgZXh0ZXJuYWwgdG8gTGludXggVk0gYW5kIGlzIGdpdmVuIGFz
DQorICAgcGh5c2ljYWwgYWRkcmVzcw0KKyovDQoraW50IHNlcF9jb3B5X2NhY2hlX3Jlc2lkZW50
X3RvX2FyZWEoc3RydWN0IGRldmljZV9jb250ZXh0ICpzZXBfY29udGV4dF9wdHIsDQorICAgICAg
ZG1hX2FkZHJfdCAgKmRzdF9uZXdfY2FjaGVfYWRkcl9wdHIsDQorICAgICAgZG1hX2FkZHJfdCAg
KmRzdF9uZXdfcmVzaWRlbnRfYWRkcl9wdHIsDQorICAgICAgZG1hX2FkZHJfdCAgKmRzdF9uZXdf
ZGNhY2hlX2FkZHJfcHRyKQ0KKw0KK3sNCisJY29uc3Qgc3RydWN0IGZpcm13YXJlICpmdzsNCisN
CisJLyogZmlybXdhcmUgcmVnaW9ucyAqLw0KKwlzaXplX3QgY2FjaGVfc2l6ZTsNCisJdm9pZCAq
Y2FjaGVfdmlydHVhbF9hZGRyZXNzOw0KKw0KKwlzaXplX3QgcmVzaWRlbnRfc2l6ZTsNCisJdm9p
ZCAqcmVzaWRlbnRfdmlydHVhbF9hZGRyZXNzOw0KKw0KKwljaGFyICpjYWNoZV9uYW1lID0gImNh
Y2hlLmltYWdlLmJpbiI7DQorCWNoYXIgKnJlc19uYW1lID0gICJyZXNpZGVudC5pbWFnZS5iaW4i
Ow0KKw0KKwkvKiBlcnJvciAqLw0KKwlpbnQgZXJyb3I7DQorDQorCS8qLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCisJICAgIENPREUNCisJLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLSovDQorCWVycm9yID0gMDsNCisNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6
cmFyX3ZpcnR1YWwgaXMgJXBcbiIsDQorCSAgc2VwX2NvbnRleHRfcHRyLT5yYXJfdmlydHVhbF9h
ZGRyZXNzKTsNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6cmFyX3BoeXNpY2FsIGlzICUwOGx4XG4i
LA0KKwkgICh1bnNpZ25lZCBsb25nKXNlcF9jb250ZXh0X3B0ci0+cmFyX3BoeXNpY2FsX2FkZHJl
c3MpOw0KKw0KKwkqZHN0X25ld19jYWNoZV9hZGRyX3B0ciA9IHNlcF9jb250ZXh0X3B0ci0+cmFy
X3BoeXNpY2FsX2FkZHJlc3M7DQorCWNhY2hlX3ZpcnR1YWxfYWRkcmVzcyA9IHNlcF9jb250ZXh0
X3B0ci0+cmFyX3ZpcnR1YWxfYWRkcmVzczsNCisNCisJLyogbG9hZCBjYWNoZSAqLw0KKwllcnJv
ciA9IHJlcXVlc3RfZmlybXdhcmUoJmZ3LCBjYWNoZV9uYW1lLCAmc2VwX2NvbnRleHRfcHRyLT5w
ZGV2LT5kZXYpOw0KKwlpZiAoZXJyb3IpIHsNCisJCXByX2RlYnVnKCJTRVAgRHJpdmVyOmNhbnQg
cmVxdWVzdCBjYWNoZSBmd1xuIik7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisJfQ0KKw0KKwlw
cl9kZWJ1ZygiU0VQIERyaXZlcjpjYWNoZSBkYXRhIGxvYyBpcyAlcFxuIiwNCisJICAodm9pZCAq
KWZ3LT5kYXRhKTsNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6Y2FjaGUgZGF0YSBzaXplIGlzICUw
OGx4XG4iLA0KKwkgICh1bnNpZ25lZCBsb25nKWZ3LT5zaXplKTsNCisNCisJbWVtY3B5KGNhY2hl
X3ZpcnR1YWxfYWRkcmVzcywgZnctPmRhdGEsIGZ3LT5zaXplKTsNCisNCisJY2FjaGVfc2l6ZSA9
IGZ3LT5zaXplOw0KKw0KKwlyZWxlYXNlX2Zpcm13YXJlKGZ3KTsNCisNCisJKmRzdF9uZXdfcmVz
aWRlbnRfYWRkcl9wdHIgPSAqZHN0X25ld19jYWNoZV9hZGRyX3B0citjYWNoZV9zaXplOw0KKwly
ZXNpZGVudF92aXJ0dWFsX2FkZHJlc3MgPSBjYWNoZV92aXJ0dWFsX2FkZHJlc3MrY2FjaGVfc2l6
ZTsNCisNCisJLyogbG9hZCByZXNpZGVudCAqLw0KKwllcnJvciA9IHJlcXVlc3RfZmlybXdhcmUo
JmZ3LCByZXNfbmFtZSwgJnNlcF9jb250ZXh0X3B0ci0+cGRldi0+ZGV2KTsNCisJaWYgKGVycm9y
KSB7DQorCQlwcl9kZWJ1ZygiU0VQIERyaXZlcjpjYW50IHJlcXVlc3QgcmVzIGZ3XG4iKTsNCisJ
CWdvdG8gZW5kX2Z1bmN0aW9uOw0KKwl9DQorDQorCXByX2RlYnVnKCJTRVAgRHJpdmVyOnJlcyBk
YXRhIGxvYyBpcyAlcFxuIiwNCisJICAodm9pZCAqKWZ3LT5kYXRhKTsNCisJcHJfZGVidWcoIlNF
UCBEcml2ZXI6cmVzIGRhdGEgc2l6ZSBpcyAlMDh4XG4iLA0KKwkgIGZ3LT5zaXplKTsNCisNCisJ
bWVtY3B5KHJlc2lkZW50X3ZpcnR1YWxfYWRkcmVzcywgZnctPmRhdGEsIGZ3LT5zaXplKTsNCisN
CisJcmVzaWRlbnRfc2l6ZSA9IGZ3LT5zaXplOw0KKw0KKwlyZWxlYXNlX2Zpcm13YXJlKGZ3KTsN
CisNCisJKmRzdF9uZXdfZGNhY2hlX2FkZHJfcHRyID0gKmRzdF9uZXdfcmVzaWRlbnRfYWRkcl9w
dHIrcmVzaWRlbnRfc2l6ZTsNCisNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6cmVzaWRlbnRfYWRk
ciAocGh5c2ljYWwgKWlzICUwOGx4XG4iLA0KKwkgICh1bnNpZ25lZCBsb25nKSpkc3RfbmV3X3Jl
c2lkZW50X2FkZHJfcHRyKTsNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6Y2FjaGVfYWRkciAocGh5
c2ljYWwpIGlzICUwOGx4XG4iLA0KKwkgICh1bnNpZ25lZCBsb25nKSpkc3RfbmV3X2NhY2hlX2Fk
ZHJfcHRyKTsNCisNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6cmVzaWRlbnRfYWRkciAobG9naWNh
bCApaXMgJTA4bHhcbiIsDQorCSAgKHVuc2lnbmVkIGxvbmcpcmVzaWRlbnRfdmlydHVhbF9hZGRy
ZXNzKTsNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6Y2FjaGVfYWRkciAobG9naWNhbCkgaXMgJTA4
bHhcbiIsDQorCSAgKHVuc2lnbmVkIGxvbmcpY2FjaGVfdmlydHVhbF9hZGRyZXNzKTsNCisNCisJ
cHJfZGVidWcoIlNFUCBEcml2ZXI6cmVzaWRlbnRfc2l6ZSBpcyAlMDhseFxuIiwNCisJICAodW5z
aWduZWQgbG9uZylyZXNpZGVudF9zaXplKTsNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6Y2FjaGVf
c2l6ZSBpcyAlMDhseFxuIiwNCisJICAodW5zaWduZWQgbG9uZyljYWNoZV9zaXplKTsNCisNCitl
bmRfZnVuY3Rpb246DQorDQorCXJldHVybiBlcnJvcjsNCit9DQorDQorLyoNCisgIFRoaXMgZnVu
Y3Rpb25zIG1hcHMgYW5kIGFsbG9jYXRlcyB0aGUNCisgIHNoYXJlZCBhcmVhIG9uIHRoZSAgZXh0
ZXJuYWwgUkFNIChkZXZpY2UpDQorICBUaGUgaW5wdXQgaXMgc2hhcmVkX2FyZWFfc2l6ZSAtIHRo
ZSBzaXplIG9mIHRoZSBtZW1vcnkgdG8NCisgIGFsbG9jYXRlLiBUaGUgb3V0cHV0cw0KKyAgYXJl
IGtlcm5lbF9zaGFyZWRfYXJlYV9hZGRyX3B0ciAtIHRoZSBrZXJlbmwNCisgIGFkZHJlc3Mgb2Yg
dGhlIG1hcHBlZCBhbmQgYWxsb2NhdGVkDQorICBzaGFyZWQgYXJlYSwgYW5kIHBoeXNfc2hhcmVk
X2FyZWFfYWRkcl9wdHINCisgIC0gdGhlIHBoeXNpY2FsIGFkZHJlc3Mgb2YgdGhlIHNoYXJlZCBh
cmVhDQorKi8NCitpbnQgc2VwX21hcF9hbmRfYWxsb2Nfc2hhcmVkX2FyZWEoc3RydWN0IGRldmlj
ZV9jb250ZXh0ICpzZXBfY29udGV4dF9wdHIpDQorDQorew0KKw0KKwlpZiAoIXNlcF9jb250ZXh0
X3B0cikgew0KKwkJcHJfZGVidWcoDQorCQkgICJzZXBfZHJpdmVyOmFsbG9jX3NoYXJlZF9hcmVh
IGludmFsaWQgcGFyYW1ldGVyXG4iKTsNCisJCVdBUk5fT04oIXNlcF9jb250ZXh0X3B0cik7DQor
CQlyZXR1cm4gLTE7DQorCX0NCisNCisJc2VwX2NvbnRleHRfcHRyLT5zaGFyZWRfYXJlYV92aXJ0
X2FkZHIgPQ0KKwkgIGRtYV9hbGxvY19jb2hlcmVudCgmc2VwX2NvbnRleHRfcHRyLT5wZGV2LT5k
ZXYsDQorCSAgc2VwX2NvbnRleHRfcHRyLT5zaGFyZWRfYXJlYV9zaXplLA0KKwkgICZzZXBfY29u
dGV4dF9wdHItPnNoYXJlZF9hcmVhX2J1c19hZGRyLA0KKwkgIEdGUF9LRVJORUwpOw0KKw0KKwlp
ZiAoIXNlcF9jb250ZXh0X3B0ci0+c2hhcmVkX2FyZWFfdmlydF9hZGRyKSB7DQorCQlwcl9kZWJ1
ZygNCisJCSAgInNlcF9kcml2ZXI6c2hhcmVkIG1lbW9yeSBrbWFsbG9jIGZhaWxlZFxuIik7DQor
CQlyZXR1cm4gLTE7DQorCX0NCisNCisJcHJfZGVidWcoDQorCSAgIlNFUCBEcml2ZXI6c2VwX2Nv
bnRleHRfcHRyLT5zaGFyZWRfYXJlYV92aXJ0X2FkZHIgaXMgJXBcbiIsDQorCXNlcF9jb250ZXh0
X3B0ci0+c2hhcmVkX2FyZWFfdmlydF9hZGRyKTsNCisJcHJfZGVidWcoDQorCSAgIlNFUCBEcml2
ZXI6c2VwX2NvbnRleHRfcHRyLT5zaGFyZWRfcmVnaW9uX3NpemUgaXMgJTA4bHhcbiIsDQorCSh1
bnNpZ25lZCBsb25nKXNlcF9jb250ZXh0X3B0ci0+c2hhcmVkX2FyZWFfc2l6ZSk7DQorCXByX2Rl
YnVnKA0KKwkgICJTRVAgRHJpdmVyOnNlcF9jb250ZXh0X3B0ci0+c2hhcmVkX2FyZWFfYnVzX2Fk
ZHIgaXMgJTA4bHhcbiIsDQorCSh1bnNpZ25lZCBsb25nKXNlcF9jb250ZXh0X3B0ci0+c2hhcmVk
X2FyZWFfYnVzX2FkZHIpOw0KKw0KKwlyZXR1cm4gMDsNCit9DQorDQorLyoNCisgIFRoaXMgZnVu
Y3Rpb25zIHVubWFwcyBhbmQgZGVhbGxvY2F0ZXMgdGhlIHNoYXJlZCBhcmVhDQorICBvbiB0aGUg
IGV4dGVybmFsIFJBTSAoZGV2aWNlKSBJbnB1dCBwYXJhbWV0ZXIgaXMgcG9pbnRlciB0bw0KKyAg
ZGV2aWNlIGNvbnRleHQNCisqLw0KK3ZvaWQgc2VwX3VubWFwX2FuZF9mcmVlX3NoYXJlZF9hcmVh
KHN0cnVjdCBkZXZpY2VfY29udGV4dCAqc2VwX2NvbnRleHRfcHRyKQ0KK3sNCisJZG1hX2ZyZWVf
Y29oZXJlbnQoJnNlcF9jb250ZXh0X3B0ci0+cGRldi0+ZGV2LA0KKwkgIHNlcF9jb250ZXh0X3B0
ci0+c2hhcmVkX2FyZWFfc2l6ZSwNCisJICBzZXBfY29udGV4dF9wdHItPnNoYXJlZF9hcmVhX3Zp
cnRfYWRkciwNCisJICBzZXBfY29udGV4dF9wdHItPnNoYXJlZF9hcmVhX2J1c19hZGRyKTsNCit9
DQorDQorDQorLyoNCisgIFRoaXMgZnVuY3Rpb25zIHJldHVybnMgdGhlIHBoeXNpY2FsIGFkZHJl
c3MgaW5zaWRlIHNoYXJlZCBhcmVhIGFjY29yZGluZw0KKyAgdG8gdGhlIHZpcnR1YWwgYWRkcmVz
cy4gSXQgY2FuIGJlIGVpdGhlciBvbiB0aGUgZXh0ZXJuYSBSQU0gZGV2aWNlDQorICAoaW9yZW1h
cHBlZCksIG9yIG9uIHRoZSBzeXN0ZW0gUkFNDQorICBUaGlzIGltcGxlbWVudGF0aW9uIGlzIGZv
ciB0aGUgZXh0ZXJuYWwgUkFNDQorKi8NCitkbWFfYWRkcl90IHNlcF9zaGFyZWRfYXJlYV92aXJ0
X3RvX2J1cyhzdHJ1Y3QgZGV2aWNlX2NvbnRleHQgKnNlcF9jb250ZXh0X3B0ciwNCisgIHZvaWQg
KnZpcnRfYWRkcmVzcykNCit7DQorCXByX2RlYnVnKCJTRVAgRHJpdmVyOnNoIHZpcnQgdG8gcGh5
cyB2ICUwOGx4XG4iLA0KKwkgICh1bnNpZ25lZCBsb25nKXZpcnRfYWRkcmVzcyk7DQorCXByX2Rl
YnVnKCJTRVAgRHJpdmVyOnNoIHZpcnQgdG8gcGh5cyBwICUwOGx4XG4iLA0KKwkgICh1bnNpZ25l
ZCBsb25nKShzZXBfY29udGV4dF9wdHItPnNoYXJlZF9hcmVhX2J1c19hZGRyDQorCSAgKyAodmly
dF9hZGRyZXNzIC0gc2VwX2NvbnRleHRfcHRyLT5zaGFyZWRfYXJlYV92aXJ0X2FkZHIpKSk7DQor
DQorCXJldHVybiBzZXBfY29udGV4dF9wdHItPnNoYXJlZF9hcmVhX2J1c19hZGRyDQorCSAgKyAo
c2l6ZV90KSh2aXJ0X2FkZHJlc3MgLSBzZXBfY29udGV4dF9wdHItPnNoYXJlZF9hcmVhX3ZpcnRf
YWRkcik7DQorfQ0KKw0KKy8qDQorICBUaGlzIGZ1bmN0aW9ucyByZXR1cm5zIHRoZSB2aXJ0dWFs
IGFkZHJlc3MgaW5zaWRlIHNoYXJlZCBhcmVhDQorICBhY2NvcmRpbmcgdG8gdGhlIHBoeXNpY2Fs
IGFkZHJlc3MuIEl0IGNhbiBiZSBlaXRoZXIgb24gdGhlDQorICBleHRlcm5hIFJBTSBkZXZpY2Ug
KGlvcmVtYXBwZWQpLCBvciBvbiB0aGUgc3lzdGVtIFJBTSBUaGlzIGltcGxlbWVudGF0aW9uDQor
ICBpcyBmb3IgdGhlIGV4dGVybmFsIFJBTQ0KKyovDQorDQordm9pZCAqc2VwX3NoYXJlZF9hcmVh
X2J1c190b192aXJ0KHN0cnVjdCBkZXZpY2VfY29udGV4dCAqc2VwX2NvbnRleHRfcHRyLA0KKyAg
ZG1hX2FkZHJfdCBidXNfYWRkcmVzcykNCit7DQorCXJldHVybiBzZXBfY29udGV4dF9wdHItPnNo
YXJlZF9hcmVhX3ZpcnRfYWRkcg0KKwkgICsgKHNpemVfdCkoYnVzX2FkZHJlc3MgLSBzZXBfY29u
dGV4dF9wdHItPnNoYXJlZF9hcmVhX2J1c19hZGRyKTsNCit9DQorDQorLyoNCisgKiBUaGlzIGZ1
bmN0aW9uIHRyYW5zbGF0ZXMgdGhlIFJBUiBoYW5kbGUgaW50byB0aGUgYnVzIGFkZHJlc3MNCisg
KiAqLw0KK2ludCBzZXBfcmFyX2hhbmRsZV90b19idXModm9pZCAqcmFyX2hhbmRsZSAsIGRtYV9h
ZGRyX3QgKnJhcl9idXMpDQorew0KKwlzdHJ1Y3QgUkFSX2J1ZmZlciBidWY7DQorCXN0YXRpYyBz
aXplX3QgY29uc3QgQlVGX0NPVU5UID0gMTsNCisNCisJcHJfZGVidWcoIlNFUCBEcml2ZXIgLSBz
ZXBfcmFyX2hhbmRsZV90b19idXMgJTA4bHhcbiIsDQorCSAgKHVuc2lnbmVkIGxvbmcpcmFyX2hh
bmRsZSk7DQorDQorCWlmIChyYXJfYnVzID09IE5VTEwpDQorCQlyZXR1cm4gLUVJTlZBTDsNCisN
CisJYnVmLmluZm8uaGFuZGxlID0gKHVuc2lnbmVkIGxvbmcpcmFyX2hhbmRsZTsNCisNCisJaWYg
KHJhcl9oYW5kbGVfdG9fYnVzKCZidWYsIEJVRl9DT1VOVCkgIT0gQlVGX0NPVU5UKQ0KKwkJcmV0
dXJuIC0xOw0KKw0KKwkqcmFyX2J1cyA9IGJ1Zi5idXNfYWRkcmVzczsNCisNCisJcmV0dXJuIDA7
DQorfQ0KKw0KKy8qDQorICBmdW5jdGlvbiB0aGF0IGlzIGFjdGl2YWVkIG9uIHRoZSBzdWNjZXNm
dWxsIHByb2JlIG9mIHRoZSBTRVAgZGV2aWNlDQorKi8NCitzdGF0aWMgaW50IF9fZGV2aW5pdCBz
ZXBfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsDQorCQkJY29uc3Qgc3RydWN0IHBjaV9kZXZp
Y2VfaWQgKmVudCkNCit7DQorCS8qIGVycm9yICovDQorCWludCBlcnJvcjsNCisNCisJLyogaW8g
bWVtb3J5IChyZWdpc3RlciBhcmVhKSAqLw0KKwlzdGF0aWMgZG1hX2FkZHJfdCBpb21lbV9zdGFy
dF9waHlzaWNhbDsNCisJc3RhdGljIGRtYV9hZGRyX3QgaW9tZW1fZW5kX3BoeXNjYWw7DQorCXNp
emVfdCBpb19tZW1vcnlfc2l6ZTsNCisJdm9pZCBfX2lvbWVtICppb21lbV9zdGFydF92aXJ0dWFs
Ow0KKw0KKwkvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorCS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLSovDQorDQorCXByX2RlYnVnKCJTZXAgcGNpIHByb2JlIHN0YXJ0aW5n
XG4iKTsNCisJZXJyb3IgPSAwOw0KKw0KKwlpZiAoc2VwX2NvbnRleHQucGRldiAhPSBOVUxMKSB7
DQorCQlwcl9kZWJ1ZygiT25seSBvbmUgZGV2aWNlIHN1cHBvcnRlZFxuIik7DQorCQlyZXR1cm4g
LUVCVVNZOw0KKwl9DQorDQorCS8qIGVuYWJsZSB0aGUgZGV2aWNlICovDQorCWVycm9yID0gcGNp
X2VuYWJsZV9kZXZpY2UocGRldik7DQorCWlmIChlcnJvcikgew0KKwkJcHJfZGVidWcoImVycm9y
IGVuYWJsaW5nIHBjaSBkZXZpY2VcbiIpOw0KKwkJcmV0dXJuIC1FTk9ERVY7DQorCX0NCisNCisJ
Lyogc2V0IHRoZSBwY2kgZGV2IHBvaW50ZXIgKi8NCisJc2VwX2NvbnRleHQucGRldiA9IHBkZXY7
DQorDQorCS8qIGdldCB0aGUgaW8gbWVtb3J5IHN0YXJ0IGFkZHJlc3MgKi8NCisJaW9tZW1fc3Rh
cnRfcGh5c2ljYWwgPSBwY2lfcmVzb3VyY2Vfc3RhcnQocGRldiwgMCk7DQorCWlmICghaW9tZW1f
c3RhcnRfcGh5c2ljYWwpIHsNCisJCXByX2RlYnVnKCJTRVAgRHJpdmVyIGVycm9yIHBjaSByZXNv
dXJjZSBzdGFydFxuIik7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisJfQ0KKw0KKwkvKiBnZXQg
dGhlIGlvIG1lbW9yeSBlbmQgYWRkcmVzcyAqLw0KKwlpb21lbV9lbmRfcGh5c2NhbCA9IHBjaV9y
ZXNvdXJjZV9lbmQocGRldiwgMCk7DQorCWlmICghaW9tZW1fZW5kX3BoeXNjYWwpIHsNCisJCXBy
X2RlYnVnKCJTRVAgRHJpdmVyIGVycm9yIHBjaSByZXNvdXJjZSBlbmRcbiIpOw0KKwkJZ290byBl
bmRfZnVuY3Rpb247DQorCX0NCisNCisJaW9fbWVtb3J5X3NpemUgPSBpb21lbV9lbmRfcGh5c2Nh
bCAtDQorCSAgaW9tZW1fc3RhcnRfcGh5c2ljYWwgKyAxOw0KKw0KKwlwcl9kZWJ1ZygiU0VQIERy
aXZlcjppb21lbV9zdGFydF9waHlzaWNhbCBpcyAlMDhseFxuIiwNCisJKHVuc2lnbmVkIGxvbmcp
aW9tZW1fc3RhcnRfcGh5c2ljYWwpOw0KKw0KKwlwcl9kZWJ1ZygiU0VQIERyaXZlcjppb19tZW1v
cnlfZW5kX3BoeWFpY2FsX2FkZHJlc3MgaXMgJTA4bHhcbiIsDQorCSh1bnNpZ25lZCBsb25nKWlv
bWVtX2VuZF9waHlzY2FsKTsNCisNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6aW9fbWVtb3J5X3Np
emUgaXMgJTA4bHhcbiIsDQorCSh1bnNpZ25lZCBsb25nKWlvX21lbW9yeV9zaXplKTsNCisNCisJ
aW9tZW1fc3RhcnRfdmlydHVhbCA9IHBjaV9pb3JlbWFwX2JhcihwZGV2LCAwKTsNCisJaWYgKCFp
b21lbV9zdGFydF92aXJ0dWFsKSB7DQorCQlwcl9kZWJ1ZygiU0VQIERyaXZlciBwY2lfaW9tZW0g
ZmFpbGVkXG4iKTsNCisJCWdvdG8gZW5kX2Z1bmN0aW9uOw0KKwl9DQorDQorCXByX2RlYnVnKCJT
RVAgRHJpdmVyOmlvbWVtX3N0YXJ0X3ZpcnR1YWwgaXMgJXBcbiIsDQorCWlvbWVtX3N0YXJ0X3Zp
cnR1YWwpOw0KKw0KKwlzZXBfY29udGV4dC5yZWdfYWRkciA9IGlvbWVtX3N0YXJ0X3ZpcnR1YWw7
DQorDQorCS8qIGNhbGwgdGhlIHJlZ2lzdGVyX3JhciBmdW5jdGlvbiAodGhpcyB3aWxsIHVzZSB0
aGUgc2VwX2NhbGxiYWNrDQorICogICAgICAgICBmdW5jdGlvbiB0byBwZXJmb3JtIHRoZSByYXIg
cmVsYXRlZCBhY3Rpdml0aWVzOyB0aGlzIGNhbGxiYWNrDQorICogICAgICAgICBpcyB1c2VkIGlu
IGNhc2Ugd2UgYXJlIHJ1bm5pbmcgbm93IHByaW9yIHRvIHRoZSByYXIgcmVnaXN0ZXINCisgKiAg
ICAgICAgIGRyaXZlciBydW5uaW5nLiAqLw0KKwllcnJvciA9IHJlZ2lzdGVyX3Jhcigmc2VwX2Nh
bGxiYWNrLCAodm9pZCAqKSZzZXBfY29udGV4dCk7DQorDQorCQlpZiAoZXJyb3IpIHsNCisJCQlw
cl9kZWJ1ZygiU0VQIERyaXZlcjogcmVnaXN0ZXJfcmFyIGZhaWxlZFxuIik7DQorCQkJV0FSTl9P
TihlcnJvcik7DQorCQkJZ290byBlbmRfZnVuY3Rpb247DQorCQl9DQorDQorI2lmICFTRVBfRFJJ
VkVSX1BPTExJTkdfTU9ERQ0KKw0KKwkvKiBjbGVhciBJQ1IgcmVnaXN0ZXIgKi8NCisJU0VQX1dS
SVRFX1JFR0lTVEVSKCZzZXBfY29udGV4dCwgSFdfSE9TVF9JQ1JfUkVHX0FERFIsDQorCSAgMHhG
RkZGRkZGRik7DQorDQorCS8qIHNldCB0aGUgSU1SIHJlZ2lzdGVyIC0gb3BlbiBvbmx5IEdQUiAy
ICovDQorCVNFUF9XUklURV9SRUdJU1RFUigmc2VwX2NvbnRleHQsIEhXX0hPU1RfSU1SX1JFR19B
RERSLA0KKwkgICh+KDB4MSA8PCAxMykpKTsNCisNCisJc2VwX2NvbnRleHQuc2VwX2lycSA9IHBk
ZXYtPmlycTsNCisNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6IG15IGlycSBpcyAlZFxuIiwgc2Vw
X2NvbnRleHQuc2VwX2lycSk7DQorDQorCWVycm9yID0gcmVxdWVzdF9pcnEoc2VwX2NvbnRleHQu
c2VwX2lycSwgc2VwX2ludGhhbmRsZXIsIElSUUZfU0hBUkVELA0KKwkgICJzZXBfZHJpdmVyIiwg
JnNlcF9jb250ZXh0LnJlZ19hZGRyKTsNCisNCisJaWYgKGVycm9yKSB7DQorCQlwcl9kZWJ1Zygi
U0VQIERyaXZlcjogVW5hYmxlIHRvIHJlcXVlc3RfaXJxXG4iKTsNCisJCWdvdG8gZW5kX2Z1bmN0
aW9uOw0KKwl9DQorDQorCS8qIHNldCB0aGUgSU1SIHJlZ2lzdGVyIC0gb3BlbiBvbmx5IEdQUiAy
ICovDQorCVNFUF9XUklURV9SRUdJU1RFUigmc2VwX2NvbnRleHQsIEhXX0hPU1RfSU1SX1JFR19B
RERSLA0KKwkgICh+KDB4MSA8PCAxMykpKTsNCisNCisjZW5kaWYgLyogSW50ZXJydXB0IG1vZGUg
KCFQT0xMSU5HKSAqLw0KKw0KK2dvdG8gZW5kX29rX2Z1bmN0aW9uOw0KKw0KK2VuZF9mdW5jdGlv
bjoNCisNCisJaWYgKHNlcF9jb250ZXh0LnJlZ19hZGRyKSB7DQorCQlpb3VubWFwKHNlcF9jb250
ZXh0LnJlZ19hZGRyKTsNCisJCXNlcF9jb250ZXh0LnJlZ19hZGRyID0gTlVMTDsNCisJfQ0KKw0K
KwlpZiAoc2VwX2NvbnRleHQucGRldikgew0KKwkJcGNpX2Rpc2FibGVfZGV2aWNlKHNlcF9jb250
ZXh0LnBkZXYpOw0KKwkJc2VwX2NvbnRleHQucGRldiA9IE5VTEw7DQorCX0NCisNCitlbmRfb2tf
ZnVuY3Rpb246DQorDQorCXJldHVybiBlcnJvcjsNCit9DQorDQorLyogZm9sbG93aW5nIGlzIHRo
ZSBjYWxsYmFjayBmb3IgdGhlIHJhcl9kcml2ZXIgdG8gY2FsbCBpbiBjYXNlIHdlIGF0dGVtcHQN
CisgKiB0byByZWdpc3RlciB0b28gc29vbg0KKyAqLw0KKw0KK2ludCBzZXBfY2FsbGJhY2sodm9p
ZCAqc2VwX2NvbnRleHRfcG9pbnRlcikNCit7DQorCWludCBlcnJvcjsNCisJc3RydWN0IGRldmlj
ZV9jb250ZXh0ICpteV9zZXBfY29udGV4dDsNCisNCisJbXlfc2VwX2NvbnRleHQgPSAoc3RydWN0
IGRldmljZV9jb250ZXh0ICopc2VwX2NvbnRleHRfcG9pbnRlcjsNCisNCisJLyogc2V0IHVwIHJh
ciBiYXNlIGFkZHJlc3MgZnJvbSByYXJfcmVnaXN0ZXIgZHJpdmVyKi8NCisJZXJyb3IgPSByYXJf
Z2V0X2FkZHJlc3MoUkFSX1RZUEVfSU1BR0UsDQorCSAgJm15X3NlcF9jb250ZXh0LT5yYXJfc3Rh
cnRfYWRkcmVzcywNCisJICAmbXlfc2VwX2NvbnRleHQtPnJhcl9lbmRfYWRkcmVzcyk7DQorDQor
CWlmIChlcnJvcikgew0KKwkJcHJfZGVidWcoDQorCQkgICJTRVAgRHJpdmVyOmNhbnQgZ2V0IFJB
UiByZWdpb24gLSBlcnJvciBpcyAlZFxuIiwNCisJCSAgZXJyb3IpOw0KKwkJZ290byBlbmRfZnVu
Y3Rpb247DQorCX0NCisNCisJcHJfZGVidWcoIlNFUCBEcml2ZXI6cmV0cmlldmVkIFJBUiBzdGFy
dCBpcyAlMDhseFxuIiwNCisJICAodW5zaWduZWQgbG9uZylteV9zZXBfY29udGV4dC0+cmFyX3N0
YXJ0X2FkZHJlc3MpOw0KKwlwcl9kZWJ1ZygiU0VQIERyaXZlcjpyZXRyaWV2ZWQgUkFSIGVuZCBp
cyAlMDhseFxuIiwNCisJICAodW5zaWduZWQgbG9uZylteV9zZXBfY29udGV4dC0+cmFyX2VuZF9h
ZGRyZXNzKTsNCisNCisJLyogbm93IG1ha2Ugc3VyZSB3ZSAnb3duJyB0aGlzIGFkZHJlc3MgcmFu
Z2UgKi8NCisJbXlfc2VwX2NvbnRleHQtPnJhcl9zaXplID0NCisJICAoc2l6ZV90KShteV9zZXBf
Y29udGV4dC0+cmFyX2VuZF9hZGRyZXNzIC0NCisJICBteV9zZXBfY29udGV4dC0+cmFyX3N0YXJ0
X2FkZHJlc3MgKyAxKTsNCisNCisJaWYgKCFyZXF1ZXN0X21lbV9yZWdpb24obXlfc2VwX2NvbnRl
eHQtPnJhcl9zdGFydF9hZGRyZXNzLA0KKwkgIG15X3NlcF9jb250ZXh0LT5yYXJfc2l6ZSwgInNl
cF9zZWNfZHJpdmVyIikpIHsNCisJCXByX2RlYnVnKA0KKwkJICAiU0VQIERyaXZlcjpyZXF1ZXN0
IG1lbSByZWdpb24gZmFpbGVkIGZvciByYXJcbiIpOw0KKwkJZXJyb3IgPSAtRU5PTUVNOw0KKwkJ
Z290byBlbmRfZnVuY3Rpb247DQorCX0NCisNCisJbXlfc2VwX2NvbnRleHQtPnJhcl92aXJ0dWFs
X2FkZHJlc3MgPSBpb3JlbWFwX25vY2FjaGUoDQorCSAgbXlfc2VwX2NvbnRleHQtPnJhcl9zdGFy
dF9hZGRyZXNzLCBteV9zZXBfY29udGV4dC0+cmFyX3NpemUpOw0KKwlpZiAoIW15X3NlcF9jb250
ZXh0LT5yYXJfdmlydHVhbF9hZGRyZXNzKSB7DQorCQlwcl9kZWJ1ZygNCisJCSAgIlNFUCBEcml2
ZXI6Y2FudCBpb3JlbWFwX25vY2FjaGUgcmFyXG4iKTsNCisJCWVycm9yID0gLUVOT01FTTsNCisJ
CWdvdG8gZW5kX2Z1bmN0aW9uOw0KKwl9DQorDQorCW15X3NlcF9jb250ZXh0LT5yYXJfcGh5c2lj
YWxfYWRkcmVzcyA9DQorCSAgbXlfc2VwX2NvbnRleHQtPnJhcl9zdGFydF9hZGRyZXNzOw0KKw0K
Kwlwcl9kZWJ1ZygiU0VQIERyaXZlcjpyYXJfcGh5c2ljYWwgaXMgJTA4bHhcbiIsDQorCSh1bnNp
Z25lZCBsb25nKW15X3NlcF9jb250ZXh0LT5yYXJfcGh5c2ljYWxfYWRkcmVzcyk7DQorDQorCXBy
X2RlYnVnKCJTRVAgRHJpdmVyOnJhcl92aXJ0dWFsIGlzICVwXG4iLA0KKwlteV9zZXBfY29udGV4
dC0+cmFyX3ZpcnR1YWxfYWRkcmVzcyk7DQorDQorCWdvdG8gZW5kX29rX2Z1bmN0aW9uOw0KKw0K
K2VuZF9mdW5jdGlvbjoNCisNCisJaWYgKG15X3NlcF9jb250ZXh0LT5yYXJfdmlydHVhbF9hZGRy
ZXNzKSB7DQorCQlpb3VubWFwKG15X3NlcF9jb250ZXh0LT5yYXJfdmlydHVhbF9hZGRyZXNzKTsN
CisJCW15X3NlcF9jb250ZXh0LT5yYXJfdmlydHVhbF9hZGRyZXNzID0gTlVMTDsNCisJfQ0KKw0K
KwlpZiAobXlfc2VwX2NvbnRleHQtPnJlZ19hZGRyKSB7DQorCQlpb3VubWFwKG15X3NlcF9jb250
ZXh0LT5yZWdfYWRkcik7DQorCQlteV9zZXBfY29udGV4dC0+cmVnX2FkZHIgPSBOVUxMOw0KKwl9
DQorDQorCWlmIChteV9zZXBfY29udGV4dC0+cGRldikgew0KKwkJcGNpX2Rpc2FibGVfZGV2aWNl
KG15X3NlcF9jb250ZXh0LT5wZGV2KTsNCisJCW15X3NlcF9jb250ZXh0LT5wZGV2ID0gTlVMTDsN
CisJfQ0KKw0KK2VuZF9va19mdW5jdGlvbjoNCisNCisJcmV0dXJuIGVycm9yOw0KK30NCisNCitz
dGF0aWMgc3RydWN0IHBjaV9kZXZpY2VfaWQgc2VwX3BjaV9pZF90YmxbXSA9IHsNCisJeyBQQ0lf
REVWSUNFKFZFTkRPUl9JRCwgMHgwODBjKSB9LA0KKwl7IDAgfQ0KK307DQorDQorTU9EVUxFX0RF
VklDRV9UQUJMRShwY2ksIHNlcF9wY2lfaWRfdGJsKTsNCisNCisvKiBmaWVsZCBmb3IgcmVnaXN0
ZXJpbmcgZHJpdmVyIHRvIFBDSSBkZXZpY2UgKi8NCitzdGF0aWMgc3RydWN0IHBjaV9kcml2ZXIg
c2VwX3BjaV9kcml2ZXIgPSB7DQorCS5uYW1lID0gInNlcF9zZWNfZHJpdmVyIiwNCisJLmlkX3Rh
YmxlID0gc2VwX3BjaV9pZF90YmwsDQorCS5wcm9iZSA9IHNlcF9wcm9iZQ0KK307DQorDQorDQor
LyoNCisgIHRoaXMgZnVuY3Rpb24gcmVnaXN0ZXJzIHRoIGRyaXZlciB0bw0KKyAgdGhlIGRldmlj
ZSBzdWJzeXN0ZW0oIGVpdGhlciBQQ0ksIFVTQiwgZXRjKQ0KKyovDQoraW50IHNlcF9yZWdpc3Rl
cl9kcml2ZXJfdG9fZGV2aWNlKHZvaWQpDQorew0KKwlyZXR1cm4gcGNpX3JlZ2lzdGVyX2RyaXZl
cigmc2VwX3BjaV9kcml2ZXIpOw0KK30NCisNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
c2VwL3NlcF9tYWluX21vZC5jIGIvZHJpdmVycy9zdGFnaW5nL3NlcC9zZXBfbWFpbl9tb2QuYw0K
bmV3IGZpbGUgbW9kZSAxMDA2NDQNCmluZGV4IDAwMDAwMDAuLjc0NGUyODcNCi0tLSAvZGV2L251
bGwNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy9zZXAvc2VwX21haW5fbW9kLmMNCkBAIC0wLDAgKzEs
MzMzMCBAQA0KKyAvKg0KKyAqIHNlcF9tYWluX21vZC5jDQorICoNCisgKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioNCisgKiAgIENvcHlyaWdodCAyMDA5IMKpIERpc2NyZXRpeCBUZWNobm9sb2dpZXMgTHRkLiAg
ICAgICAgICAgICAgICAgICAgICAgICAgKg0KKyAqICAgQ29weXJpZ2h0IDIwMDkgwqkgSW50ZWwg
Q29ycG9yYXRpb24gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqDQorICogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgKg0KKyAqICAgVGhpcyBzb2Z0d2FyZSBpcyBwcm90ZWN0ZWQgYnkgY29weXJp
Z2h0LCBpbnRlcm5hdGlvbmFsIHRyZWF0aWVzIGFuZCAgICoNCisgKiAgIHZhcmlvdXMgcGF0ZW50
cy4gQW55IGNvcHkgb3IgcmVwcm9kdWN0aW9uIG9mIHRoaXMgU29mdHdhcmUgYXMgICAgICAgICAq
DQorICogICBwZXJtaXR0ZWQgYmVsb3csIG11c3QgaW5jbHVkZSB0aGlzIENvcHlyaWdodCBOb3Rp
Y2UgYXMgd2VsbCBhcyBhbnkgICAgKg0KKyAqICAgb3RoZXIgbm90aWNlcyBwcm92aWRlZCB1bmRl
ciBzdWNoIGxpY2Vuc2UuICAgICAgICAgICAgICAgICAgICAgICAgICAgICoNCisgKiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAqDQorICogICBUaGlzIHByb2dyYW0gc2hhbGwgYmUgZ292ZXJuZWQgYnksIGFuZCBt
YXkgYmUgdXNlZCBhbmQgcmVkaXN0cmlidXRlZCAgKg0KKyAqICAgdW5kZXIgdGhlIHRlcm1zIGFu
ZCBjb25kaXRpb25zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSwgICAgICoNCisg
KiAgIHZlcnNpb24gMiwgYXMgcHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRp
b24uICAgICAgICAgICAgICAqDQorICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKg0KKyAqICAgVGhpcyBwcm9n
cmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsICAg
ICAgICoNCisgKiAgIGJ1dCBXSVRIT1VUIEFOWSBsaWFiaWxpdHkgYW5kIFdBUlJBTlRZOyB3aXRo
b3V0IGV2ZW4gdGhlIGltcGxpZWQgICAgICAqDQorICogICB3YXJyYW50eSBvZiBNRVJDSEFOVEFC
SUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICAgICAgKg0KKyAqICAg
U2VlIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLiAgICAg
ICAgICAgICAgICAgICoNCisgKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqDQorICogICBZb3Ugc2hvdWxkIGhh
dmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSAgICAg
Kg0KKyAqICAgYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgcGxlYXNlIHdyaXRlIHRv
IHRoZSBGcmVlIFNvZnR3YXJlICAgICoNCisgKiAgIEZvdW5kYXRpb24sIEluYy4sICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqDQorICogICA1OSBU
ZW1wbGUgUGxhY2UgLSBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgIDAyMTExLTEzMDcsIFVTQS4gICAg
ICAgICAgICAgKg0KKyAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KKyAqDQorICogIENPTlRBQ1RTOg0KKyAq
DQorICogIE1hcmsgQWxseW4JCW1hcmsuYS5hbGx5bkBpbnRlbC5jb20NCisgKg0KKyAqICBDSEFO
R0VTOg0KKyAqDQorICogIDIwMTAuMDEuMDgJSW5pdGlhbCBwdWJsaXNoDQorICoNCisgKi8NCisN
CisNCisjaW5jbHVkZSA8bGludXgvaW5pdC5oPg0KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4N
CisjaW5jbHVkZSA8bGludXgvZnMuaD4NCisjaW5jbHVkZSA8bGludXgvY2Rldi5oPg0KKyNpbmNs
dWRlIDxsaW51eC9rZGV2X3QuaD4NCisjaW5jbHVkZSA8bGludXgvbXV0ZXguaD4NCisjaW5jbHVk
ZSA8bGludXgvbW0uaD4NCisjaW5jbHVkZSA8bGludXgvcG9sbC5oPg0KKyNpbmNsdWRlIDxsaW51
eC93YWl0Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lvY3RsLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lv
cG9ydC5oPg0KKyNpbmNsdWRlIDxsaW51eC9pby5oPg0KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1
cHQuaD4NCisjaW5jbHVkZSA8bGludXgvcGFnZW1hcC5oPg0KKyNpbmNsdWRlIDxsaW51eC9kbWEt
bWFwcGluZy5oPg0KKyNpbmNsdWRlIDxhc20vY2FjaGVmbHVzaC5oPg0KKyNpbmNsdWRlIDxsaW51
eC9zY2hlZC5oPg0KKw0KKyNpZmRlZiBEWF9DQzUyX1NVUFBPUlQNCisjaW5jbHVkZSA8bGludXgv
bmV0bGluay5oPg0KKyNpbmNsdWRlIDxsaW51eC9jb25uZWN0b3IuaD4NCisjaW5jbHVkZSA8bGlu
dXgvY25fcHJvYy5oPg0KKyNlbmRpZg0KKw0KKyNpbmNsdWRlICJzZXBfZHJpdmVyX2h3X2RlZnMu
aCINCisjaW5jbHVkZSAic2VwX2RyaXZlcl9jb25maWcuaCINCisjaW5jbHVkZSAic2VwX2RyaXZl
cl9hcGkuaCINCisjaW5jbHVkZSAic2VwX2RyaXZlcl9leHRfYXBpLmgiDQorDQorLyotLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQorCURFRklORVMNCistLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQorDQorDQorLyotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlHTE9CQUwgdmFyaWFibGVzDQor
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKw0KKy8qIGRl
YnVnIG1lc3NhZ2VzIGxldmVsICovDQorc3RhdGljIGludCBzZXBfZGVidWcgPSAweDA7DQorbW9k
dWxlX3BhcmFtKHNlcF9kZWJ1ZywgaW50LCAwKTsNCitNT0RVTEVfUEFSTV9ERVNDKHNlcF9kZWJ1
ZywgIkZsYWcgdG8gZW5hYmxlIFNFUCBkZWJ1ZyBtZXNzYWdlcyIpOw0KKw0KKy8qIGNvbnRleHQg
b2YgdGhlIGRldmljZSAqLw0KK3N0cnVjdCBkZXZpY2VfY29udGV4dCAgIHNlcF9jb250ZXh0Ow0K
Kw0KKw0KKy8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQor
CUZVTkNUSU9OUw0KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tKi8NCisvKg0KKyAgdGhpcyBmdW5jdGlvbiBsb2NrcyBTRVAgYnkgbG9ja2luZyB0aGUgc2Vt
YXBob3JlDQorKi8NCitpbnQgc2VwX2xvY2sodm9pZCkNCit7DQorICAvKiBnZXQgdGhlIGxvY2sg
Ki8NCisgIHdhaXRfZXZlbnRfaW50ZXJydXB0aWJsZShzZXBfY29udGV4dC5ldmVudCAsDQorICAg
ICAgdGVzdF9hbmRfc2V0X2JpdChTRVBfTU1BUF9MT0NLX0JJVCwgJnNlcF9jb250ZXh0LmluX3Vz
ZV9mbGFnKSA9PSAwKTsNCisJaWYgKHNpZ25hbF9wZW5kaW5nKGN1cnJlbnQpKQ0KKwkJcmV0dXJu
IC1FSU5UUjsNCisNCisgIHJldHVybiAwOw0KK30NCisNCisvKg0KKyAgdGhpcyBmdW5jdGlvbiB1
bmxvY2tzIFNFUA0KKyovDQordm9pZCBzZXBfdW5sb2NrKHZvaWQpDQorew0KKwkvKiBjaGVjayBp
ZiBtYXBwaW5ncyBtdXN0IGJlIGZyZWVkICovDQorCWlmIChzZXBfY29udGV4dC5zaGFyZWRfYXJl
YV9kbWFfYWRkcikNCisJCWRtYV91bm1hcF9zaW5nbGUoc2VwX2NvbnRleHQuZGV2X3B0ciwNCisJ
CQlzZXBfY29udGV4dC5zaGFyZWRfYXJlYV9kbWFfYWRkciwNCisJCQlzZXBfY29udGV4dC5zaGFy
ZWRfYXJlYV9zaXplLA0KKwkJCURNQV9CSURJUkVDVElPTkFMKTsNCisNCisJLyogemVybyB0aGUg
c2hhcmVkIGFyZWEgbWFwcGluZyAqLw0KKwlzZXBfY29udGV4dC5zaGFyZWRfYXJlYV9kbWFfYWRk
ciA9IDA7DQorDQorICAvKiByZWxlYXNlIGxvY2sgKi8NCisgIGNsZWFyX2JpdChTRVBfTU1BUF9M
T0NLX0JJVCwgJnNlcF9jb250ZXh0LmluX3VzZV9mbGFnKTsNCisgIHdha2VfdXAoJnNlcF9jb250
ZXh0LmV2ZW50KTsNCit9DQorDQorLyoNCisgIHRoaXMgZnVuY3Rpb24gcmV0dXJucyB0aGUgYWRk
cmVzcyBvZiB0aGUgbWVzc2FnZSBzaGFyZWQgYXJlYQ0KKyovDQordm9pZCAqc2VwX21hcF9zaGFy
ZWRfYXJlYSh2b2lkKQ0KK3sNCisgIHJldHVybiBzZXBfY29udGV4dC5zaGFyZWRfYXJlYV92aXJ0
X2FkZHI7DQorfQ0KKw0KKy8qDQorICBjYWxjdWxhdGVzIHRpbWUgYW5kIHNldHMgaXQgYXQgdGhl
IHByZWRlZmluZWQgYWRkcmVzcw0KKyovDQorc3RhdGljIGludCBzZXBfc2V0X3RpbWUoZG1hX2Fk
ZHJfdAkqYnVzX3B0ciwNCisJCQkJCQl1MzIJKnRpbWVfaW5fc2VjX3B0cikNCit7DQorICAvKiAg
dGltZSBzdHJ1Y3QgKi8NCisgIHN0cnVjdCB0aW1ldmFsICB0aW1lOw0KKw0KKyAgLyogYWRkcmVz
cyBvZiB0aW1lIGluIHRoZSBrZXJuZWwgKi8NCisgIHUzMiAgICp0aW1lX2FkZHI7DQorDQorDQor
ICAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLSovDQorDQorICBkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9zZXRfdGlt
ZSBzdGFydFxuIik7DQorDQorDQorICBkb19nZXR0aW1lb2ZkYXkoJnRpbWUpOw0KKw0KKyAgLyog
c2V0IHZhbHVlIGluIHRoZSBTWVNURU0gTUVNT1JZIG9mZnNldCAqLw0KKyAgdGltZV9hZGRyID0g
c2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfdmlydF9hZGRyICsNCisJCQlTRVBfRFJJVkVSX1NZU1RF
TV9USU1FX01FTU9SWV9PRkZTRVRfSU5fQllURVM7DQorDQorICB0aW1lX2FkZHJbMF0gPSBTRVBf
VElNRV9WQUxfVE9LRU47DQorICB0aW1lX2FkZHJbMV0gPSB0aW1lLnR2X3NlYzsNCisNCisgIGVk
YmcoIlNFUCBEcml2ZXI6dGltZS50dl9zZWMgaXMgJXhcbiIsDQorCQkJKHUzMil0aW1lLnR2X3Nl
Yyk7DQorICBlZGJnKCJTRVAgRHJpdmVyOnRpbWVfYWRkciBpcyAlcFxuIiwNCisJCQl0aW1lX2Fk
ZHIpOw0KKyAgZWRiZygiU0VQIERyaXZlcjpnX3NlcF9zaGFyZWRfYXJlYV92aXJ0X2FkZHIgaXMg
JXBcbiIsDQorCQkJc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfdmlydF9hZGRyKTsNCisNCisgIC8q
IHNldCB0aGUgb3V0cHV0IHBhcmFtZXRlcnMgaWYgbmVlZGVkICovDQorICBpZiAoYnVzX3B0cikN
CisJKmJ1c19wdHIgPSBzZXBfc2hhcmVkX2FyZWFfdmlydF90b19idXMoJnNlcF9jb250ZXh0LA0K
KyAgICAgIHRpbWVfYWRkcik7DQorDQorCWlmICh0aW1lX2luX3NlY19wdHIpDQorCQkqdGltZV9p
bl9zZWNfcHRyID0gdGltZS50dl9zZWM7DQorDQorICBkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0t
IHNlcF9zZXRfdGltZSBlbmRcbiIpOw0KKw0KKyAgcmV0dXJuIDA7DQorfQ0KKw0KKw0KKyNpZmRl
ZiBEWF9DQzUyX1NVUFBPUlQNCisvKg0KKyAgIG9wZW4gZnVuY3Rpb24gZm9yIHRoZSBzaW5nbGV0
b24gZHJpdmVyDQorKi8NCitzdGF0aWMgaW50IHNlcF9zaW5nbGV0b25fb3BlbihzdHJ1Y3QgaW5v
ZGUgKmlub2RlX3B0ciAsIHN0cnVjdCBmaWxlICpmaWxlX3B0cikNCit7DQorICAvKiByZXR1cm4g
dmFsdWUgKi8NCisgIGludCAgICAgICAgICAgICBlcnJvcjsNCisNCisgIC8qLS0tLS0tLS0tLS0t
LS0tLS0NCisgICAgQ09ERQ0KKyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCisNCisgIGVycm9y
ID0gMDsNCisNCisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX3NpbmdsZXRvbl9vcGVu
IHN0YXJ0XG4iKTsNCisNCisJaWYgKHRlc3RfYW5kX3NldF9iaXQoMCwgJnNlcF9jb250ZXh0LnNp
bmdsZXRvbl9hY2Nlc3NfZmxhZykpDQorCQllcnJvciA9IC1FQlVTWTsNCisNCisgIGRiZygiU0VQ
IERyaXZlcjo8LS0tLS0tLS0gc2VwX3NpbmdsZXRvbl9vcGVuIGVuZFxuIik7DQorDQorICByZXR1
cm4gZXJyb3I7DQorfQ0KKw0KKy8qDQorICBpbnNlcnRzIHRoZSBkYXRhIGludG8gdGhlIGNhbGxl
ciBpZCB0YWJsZQ0KKyovDQorc3RhdGljIGludCBzZXBfc2V0X2NhbGxlcl9pZF9oYW5kbGVyKHUz
MiBhcmcpDQorew0KKyAgLyogZXJyb3IgKi8NCisgIGludCAgIGVycm9yOw0KKw0KKyAgLyogY291
bnRlciAqLw0KKyAgaW50ICAgaTsNCisNCisgIC8qIGNvbW1hbmQgYXJndW1lbnRzICovDQorICBz
dHJ1Y3Qgc2VwX2RyaXZlcl9zZXRfY2FsbGVyX2lkX3QgIGNvbW1hbmRfYXJnczsNCisNCisgIC8q
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKyAgICAgIENPREUNCisgIC0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQorICBkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNl
cF9zZXRfY2FsbGVyX2lkX2hhbmRsZXIgc3RhcnRcbiIpOw0KKw0KKyAgZXJyb3IgPSAwOw0KKw0K
Kwlmb3IgKGkgPSAwOyBpIDwgU0VQX0NBTExFUl9JRF9UQUJMRV9OVU1fRU5UUklFUzsgaSsrKSB7
DQorCQlpZiAoc2VwX2NvbnRleHQuY2FsbGVyX2lkX3RhYmxlW2ldLnBpZCA9PSAwKQ0KKwkJCWJy
ZWFrOw0KKyAgfQ0KKw0KKwlpZiAoaSA9PSBTRVBfQ0FMTEVSX0lEX1RBQkxFX05VTV9FTlRSSUVT
KSB7DQorCQllZGJnKCJTRVAgRHJpdmVyOmkgPT0gU0VQX0NBTExFUl9JRF9UQUJMRV9OVU1fRU5U
UklFU1xuIik7DQorCQllcnJvciA9IC1FTk9NRU07DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisg
IH0NCisNCisgIC8qIGNvcHkgdGhlIGRhdGEgKi8NCisJaWYgKGNvcHlfZnJvbV91c2VyKCZjb21t
YW5kX2FyZ3MgLA0KKwkJCSh2b2lkICopYXJnICwNCisJCQlzaXplb2Yoc3RydWN0IHNlcF9kcml2
ZXJfc2V0X2NhbGxlcl9pZF90KSkpIHsNCisJCWVkYmcoIlNFUCBEcml2ZXI6Y29weV9mcm9tX3Vz
ZXIgZmFpbGVkXG4iKTsNCisJCWVycm9yID0gLUVGQVVMVDsNCisJCWdvdG8gZW5kX2Z1bmN0aW9u
Ow0KKyAgfQ0KKw0KKwlpZiAoIWNvbW1hbmRfYXJncy5waWQgfHwNCisJCQkhY29tbWFuZF9hcmdz
LmNhbGxlcklkQWRkcmVzcyB8fA0KKwkJCSFjb21tYW5kX2FyZ3MuY2FsbGVySWRTaXplSW5CeXRl
cykgew0KKw0KKwkJZWRiZygiU0VQIERyaXZlcjogcGFyYW1zIHZhbGlkYXRpb24gZXJyb3JcbiIp
Ow0KKw0KKwkJZXJyb3IgPSAtRUlOVkFMOw0KKwkJZ290byBlbmRfZnVuY3Rpb247DQorICB9DQor
DQorICBlZGJnKCJTRVAgRHJpdmVyOnBpZCBpcyAleFxuIiAsDQorCQkJCWNvbW1hbmRfYXJncy5w
aWQpOw0KKyAgZWRiZygiU0VQIERyaXZlcjpjYWxsZXJJZFNpemVJbkJ5dGVzIGlzICV4XG4iICwN
CisJCQkJY29tbWFuZF9hcmdzLmNhbGxlcklkU2l6ZUluQnl0ZXMpOw0KKw0KKwlpZiAoY29tbWFu
ZF9hcmdzLmNhbGxlcklkU2l6ZUluQnl0ZXMgPg0KKwkJCVNFUF9DQUxMRVJfSURfSEFTSF9TSVpF
X0lOX0JZVEVTKSB7DQorCQllcnJvciA9IC1FSU5WQUw7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsN
CisgIH0NCisNCisgIHNlcF9jb250ZXh0LmNhbGxlcl9pZF90YWJsZVtpXS5waWQgPSBjb21tYW5k
X2FyZ3MucGlkOw0KKw0KKwlpZiAoY29weV9mcm9tX3VzZXIoc2VwX2NvbnRleHQuY2FsbGVyX2lk
X3RhYmxlW2ldLmNhbGxlcklkSGFzaCwNCisJCQljb21tYW5kX2FyZ3MuY2FsbGVySWRBZGRyZXNz
ICwNCisJCQljb21tYW5kX2FyZ3MuY2FsbGVySWRTaXplSW5CeXRlcykpDQorCQllcnJvciA9IC1F
RkFVTFQ7DQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0t
LSBzZXBfc2V0X2NhbGxlcl9pZF9oYW5kbGVyIGVuZFxuIik7DQorDQorICByZXR1cm4gZXJyb3I7
DQorfQ0KKw0KKy8qDQorICBzZXQgdGhlIGNhbGxlciBpZCAoaWYgZXhpc3RzKSBvZiB0aGUgY3Vy
cmVudCBwcm9jZXNzIHRoYXQgc2VuZCByZXF1ZXN0IHRvIFNlUA0KKyovDQorc3RhdGljIGludCBz
ZXBfc2V0X2N1cnJlbnRfY2FsbGVyX2lkKHZvaWQpDQorew0KKyBpbnQgaTsNCisNCisgIGRiZygi
U0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX3NldF9jdXJyZW50X2NhbGxlcl9pZCBzdGFydFxuIik7
DQorDQorIGVkYmcoImN1cnJlbnQgcHJvY2VzcyBpcyAlZFxuIiwgY3VycmVudC0+cGlkKTsNCisN
CisgLyogemVybyB0aGUgcHJldmlvdXMgdmFsdWUgKi8NCisgbWVtc2V0KCh2b2lkICopKHNlcF9j
b250ZXh0LnNoYXJlZF9hcmVhX3ZpcnRfYWRkciArDQorCQkJKFNFUF9EUklWRVJfU1lTVEVNX0NB
TExFUl9JRF9NRU1PUllfT0ZGU0VUX0lOX0JZVEVTKSksDQorCQkJMCwNCisJCQlTRVBfQ0FMTEVS
X0lEX0hBU0hfU0laRV9JTl9CWVRFUyk7DQorDQorIGZvciAoaSA9IDA7IGkgPCBTRVBfQ0FMTEVS
X0lEX1RBQkxFX05VTV9FTlRSSUVTOyBpKyspIHsNCisJaWYgKHNlcF9jb250ZXh0LmNhbGxlcl9p
ZF90YWJsZVtpXS5waWQgPT0gY3VycmVudC0+cGlkKSB7DQorCQllZGJnKCJDYWxsZXIgSWQgZm91
bmRcbiIpOw0KKw0KKwkJbWVtY3B5KCh2b2lkICopKHNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX3Zp
cnRfYWRkciArDQorCQkJKFNFUF9EUklWRVJfU1lTVEVNX0NBTExFUl9JRF9NRU1PUllfT0ZGU0VU
X0lOX0JZVEVTKSksDQorCQkJKHZvaWQgKikoc2VwX2NvbnRleHQuY2FsbGVyX2lkX3RhYmxlW2ld
LmNhbGxlcklkSGFzaCksDQorCQkJU0VQX0NBTExFUl9JRF9IQVNIX1NJWkVfSU5fQllURVMpOw0K
KyAgICBicmVhazsNCisgIH0NCisgfQ0KKw0KKyBkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNl
cF9zZXRfY3VycmVudF9jYWxsZXJfaWQgZW5kXG4iKTsNCisNCisgcmV0dXJuIDA7DQorfQ0KKw0K
Kw0KKy8qDQorICBjYWxsYmFjayBmb3IgdGhlIG5ldGxpbmsgY29ubmVjdG9yIHJlZ2lzdHJhdGlv
bg0KKyovDQorc3RhdGljIHZvaWQgc2VwX2NuX2NhbGxiYWNrKHZvaWQgKmRhdGEpDQorew0KKyAg
LyogY291bnRlciAqLw0KKyAgaW50ICAgICAgICAgICAgICAgICBjb3VudGVyOw0KKw0KKyAgLyog
bWVzc2FnZSAqLw0KKyAgc3RydWN0IGNuX21zZwkqbXNnOw0KKw0KKyAgLyogZXZlbnQgKi8NCisg
IHN0cnVjdCBwcm9jX2V2ZW50CSpldjsNCisNCisgIC8qIHByb2Nlc3MgaWQgKi8NCisgIGludCAg
ICAgICAgICAgICAgICAgcGlkOw0KKw0KKyAgLyotLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKyAgICAg
IENPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKw0KKyAgbXNnID0gZGF0YTsNCisN
CisgIC8qIGdldCB0aGUgcHJvYyBldmVudCBwb2ludGVyICovDQorICBldiA9IChzdHJ1Y3QgcHJv
Y19ldmVudCAqKW1zZy0+ZGF0YTsNCisNCisgIC8qIGNoZWNrIHRoZSBldmVudCAqLw0KKwlzd2l0
Y2ggKGV2LT53aGF0KSB7DQorCWNhc2UgUFJPQ19FVkVOVF9FWEVDOg0KKw0KKyAgICAgIC8qIGdl
dCB0aGUgcGlkICovDQorICAgICAgcGlkID0gZXYtPmV2ZW50X2RhdGEuZXhlYy5wcm9jZXNzX3Bp
ZDsNCisNCisgICAgICBicmVhazsNCisNCisJY2FzZSBQUk9DX0VWRU5UX0VYSVQ6DQorDQorICAg
ICAgLyogZ2V0IHRoZSBwaWQgKi8NCisgICAgICBwaWQgPSBldi0+ZXZlbnRfZGF0YS5leGl0LnBy
b2Nlc3NfcGlkOw0KKw0KKyAgICAgIGJyZWFrOw0KKw0KKwlkZWZhdWx0Og0KKyAgICAgIC8qIG5v
dCBpbnRlcmVzdGVkIGluIHRoZSByZXN0IG9mIHRoZSBldmVudHMgKi8NCisgICAgICBnb3RvIGVu
ZF9mdW5jdGlvbjsNCisgIH0NCisNCisgIC8qIGNoZWNrIGlmIHRoZSBwaWQgaXMgcmVsZXZhbnQg
Ki8NCisJZm9yIChjb3VudGVyID0gMDsNCisJCQkJY291bnRlciA8IFNFUF9DQUxMRVJfSURfVEFC
TEVfTlVNX0VOVFJJRVM7DQorCQkJCWNvdW50ZXIrKykgew0KKwkJLyogaWYgdGhlIHBpZCBpcyBm
b3VuZCAtIHJlbW92ZSBpdCBmcm9tIHRoZSB0YWJsZSAqLw0KKwkJaWYgKHNlcF9jb250ZXh0LmNh
bGxlcl9pZF90YWJsZVtjb3VudGVyXS5waWQgPT0gcGlkKQ0KKwkJCXNlcF9jb250ZXh0LmNhbGxl
cl9pZF90YWJsZVtjb3VudGVyXS5waWQgPSAwOw0KKyAgfQ0KKw0KKw0KK2VuZF9mdW5jdGlvbjoN
CisNCisgIHJldHVybjsNCit9DQorDQorLyoNCisgIGluaXRpYWxpemVzIHRoZSBjYWxsZXIgaWQg
ZnVuY3Rpb25hbGl0eQ0KKyovDQorc3RhdGljIGludCBzZXBfaW5pdF9jYWxsZXJfaWQodm9pZCkN
Cit7DQorICAvKiByZXR1cm4gdmFsdWUgKi8NCisgIGludCAgIHJldF92YWw7DQorDQorICAvKiBj
b3VudGVyICovDQorICBpbnQgICBjb3VudGVyOw0KKw0KKyAgc3RydWN0IGNiX2lkIGNhbGxlcl9p
ZDsNCisNCisNCisgIC8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKyAgICAgIENPREUN
CisgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQorICByZXRfdmFsID0g
MDsNCisNCisgIC8qIGluaXQgY2JfaWQgc3RydWN0ICovDQorICBjYWxsZXJfaWQuaWR4ID0gQ05f
SURYX1BST0M7DQorICBjYWxsZXJfaWQudmFsID0gQ05fVkFMX1BST0M7DQorDQorICAvKiBpbml0
IGNhbGxlciBpZCB0YWJsZSAqLw0KKyAgZm9yIChjb3VudGVyID0gMDsgY291bnRlciA8IFNFUF9D
QUxMRVJfSURfVEFCTEVfTlVNX0VOVFJJRVM7IGNvdW50ZXIrKykNCisJc2VwX2NvbnRleHQuY2Fs
bGVyX2lkX3RhYmxlW2NvdW50ZXJdLnBpZCA9IDA7DQorDQorDQorICAvKiBpbml0IGFjY2VzcyBm
bGFnICovDQorICBzZXBfY29udGV4dC5zaW5nbGV0b25fYWNjZXNzX2ZsYWcgPSAwOw0KKw0KKyAg
ZWRiZygiU0VQIERyaXZlcjogY2FsbGVyIGlkIHRhYmxlIGluaXQgZmluaXNoZWRcbiIpOw0KKw0K
KyAgLyogcmVnaXN0ZXIgdG8gbmV0bGluayBjb25uZWN0b3IgKi8NCisgIC8qcmV0X3ZhbCA9IGNu
X2FkZF9jYWxsYmFjaygmY2FsbGVyX2lkLCAic2VwX2NhbGxlcl9pZCIsICZzZXBfY25fY2FsbGJh
Y2spOyovDQorDQorDQorICByZXR1cm4gcmV0X3ZhbDsNCit9DQorDQorI2VuZGlmIC8qRFhfQ0M1
Ml9TVVBQT1JUKi8NCisNCisNCisvKg0KKyAgVGhpcyBmdW5jdGlvbiByYWlzZXMgaW50ZXJydXB0
IHRvIFNFUCB0aGF0IHNpZ25hbHMgdGhhdCBpcyBoYXMgYSBuZXcNCisJY29tbWFuZCBmcm9tIEhP
U1QNCisqLw0KK3N0YXRpYyBpbnQgc2VwX3NlbmRfY29tbWFuZF9oYW5kbGVyKHZvaWQpDQorew0K
KyAgaW50IGVycm9yOw0KKw0KKyAgdTMyIGNvdW50Ow0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOi0t
LS0tLS0tPiBzZXBfc2VuZF9jb21tYW5kX2hhbmRsZXIgc3RhcnRcbiIpOw0KKw0KKyAgZXJyb3Ig
PSAwOw0KKw0KKyAgLyogY2hlY2sgaWYgbWVzc2FnZSB3YXMgYWxyZWFkeSBzZW50IHdpdGhvdXQg
cG9sbCAqLw0KKyAgaWYgKHRlc3RfYml0KFNFUF9TRU5EX01TR19MT0NLX0JJVCwgJnNlcF9jb250
ZXh0LmluX3VzZV9mbGFnKSkgew0KKwkJZXJyb3IgPSAtRUFDQ0VTOw0KKwkJZ290byBlbmRfZnVu
Y3Rpb247DQorICB9DQorDQorICAvKiBzZXQgYml0IHRoYXQgYWxsb3dzIHBvbGwgKi8NCisgIHNl
dF9iaXQoU0VQX1NFTkRfTVNHX0xPQ0tfQklULCAmc2VwX2NvbnRleHQuaW5fdXNlX2ZsYWcpOw0K
Kw0KKyAgc2VwX3NldF90aW1lKDAsIDApOw0KKw0KKyNpZmRlZiBEWF9DQzUyX1NVUFBPUlQNCisg
IC8qIHNldCB0aGUgY3VycmVudCBjYWxsZXIgaWYgIC0gaWYgZXhpc3RzICovDQorICBzZXBfc2V0
X2N1cnJlbnRfY2FsbGVyX2lkKCk7DQorI2VuZGlmDQorDQorICBmb3IgKGNvdW50ID0gMDsgY291
bnQgPCAxMiAqIDQ7IGNvdW50ICs9IDQpDQorCQllZGJnKCJXb3JkICV4IG9mIHRoZSBtZXNzYWdl
IGlzICV4XG4iLA0KKwkJCWNvdW50LA0KKwkJCSooKHUzMiAqKShzZXBfY29udGV4dC5zaGFyZWRf
YXJlYV92aXJ0X2FkZHIgKyBjb3VudCkpKTsNCisNCisgIC8qIHVwZGF0ZSBjb3VudGVyICovDQor
ICBzZXBfY29udGV4dC5ob3N0X3RvX3NlcF9zZW5kX2NvdW50ZXIrKzsNCisNCisJc2VwX2NvbnRl
eHQuc2hhcmVkX2FyZWFfZG1hX2FkZHIgPQ0KKwkJZG1hX21hcF9zaW5nbGUoc2VwX2NvbnRleHQu
ZGV2X3B0ciwNCisJCSh2b2lkICopc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfdmlydF9hZGRyLA0K
KwkJc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfc2l6ZSwNCisJCURNQV9CSURJUkVDVElPTkFMKTsN
CisNCisgIC8qIHNlbmQgaW50ZXJydXB0IHRvIFNFUCAqLw0KKyAgU0VQX1dSSVRFX1JFR0lTVEVS
KCZzZXBfY29udGV4dCwgSFdfSE9TVF9IT1NUX1NFUF9HUFIwX1JFR19BRERSLCAweDIpOw0KKw0K
KyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBfc2VuZF9jb21tYW5kX2hhbmRsZXIgZW5k
XG4iKTsNCisNCitlbmRfZnVuY3Rpb246DQorDQorICByZXR1cm4gZXJyb3I7DQorfQ0KKw0KKy8q
DQorICB0aGlzIGZ1bmN0aW9uIG5vdGlmaWVzIHRoZSBTZVAgb2YgdGhlIGluY29taW5nIG1lc3Nh
Z2UNCisqLw0KK2ludCBzZXBfc2VuZF9tc2dfcmR5X2NtZCh2b2lkKQ0KK3sNCisgIHJldHVybiBz
ZXBfc2VuZF9jb21tYW5kX2hhbmRsZXIoKTsNCit9DQorDQorDQorLyogcG9sbChzdXNwZW5kKSwg
dW50aWwgcmVwbHkgZnJvbSBzZXAgKi8NCitpbnQgc2VwX2RyaXZlcl9wb2xsKHUzMiAqc291cmNl
X3B0cikNCit7DQorICAvKiBlcnJvciAqLw0KKyAgaW50IGVycm9yOw0KKw0KKyAgLyogZ3ByMyBy
ZWdpc3RlciB2YWx1ZSAqLw0KKyAgdTMyCXJldFZhbDI7DQorDQorICAvKiBncDMgcmVnaXN0ZXIg
dmFsdWUgKi8NCisgIHUzMiByZXRWYWwzOw0KKw0KKyAgLyotLS0tLS0tLS0tLS0tLS0tLQ0KKyAg
ICAgIENPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKw0KKyAgZXJyb3IgPSAwOw0KKw0K
KyAgLyogY2hlY2sgaWYgc2VuZCBjb21tYW5kIG9yIHNlbmRfcmVwbHkgd2VyZSBhY3RpdmF0ZWQg
cHJldmlvdXNseSAqLw0KKwlpZiAoIXRlc3RfYml0KFNFUF9TRU5EX01TR19MT0NLX0JJVCwgJnNl
cF9jb250ZXh0LmluX3VzZV9mbGFnKSkgew0KKwkJZXJyb3IgPSAtRUlPOw0KKwkJZ290byBlbmRf
ZnVuY3Rpb247DQorICB9DQorDQorI2lmIFNFUF9EUklWRVJfUE9MTElOR19NT0RFDQorCWRvIHsN
CisJCS8qIHJlYWQgZ3AyICovDQorCQlyZXRWYWwyID0gU0VQX1JFQURfUkVHSVNURVIoJnNlcF9j
b250ZXh0LA0KKwkJCUhXX0hPU1RfU0VQX0hPU1RfR1BSMl9SRUdfQUREUik7DQorDQorCQkvKiBy
ZWFkIGdwMyAqLw0KKwkJcmV0VmFsMyA9IFNFUF9SRUFEX1JFR0lTVEVSKCZzZXBfY29udGV4dCwN
CisJCQlIV19IT1NUX1NFUF9IT1NUX0dQUjNfUkVHX0FERFIpOw0KKw0KKwkJLyogc2xlZXAgYmV0
d2VlbiBsb29wcyAqLw0KKwkJc2V0X2N1cnJlbnRfc3RhdGUoVEFTS19JTlRFUlJVUFRJQkxFKTsN
CisJCXNjaGVkdWxlX3RpbWVvdXQoNTApOw0KKw0KKwl9IHdoaWxlICgocmV0VmFsMyAgPT0gMHgw
KSAmJg0KKyAgICAgIHNlcF9jb250ZXh0Lmhvc3RfdG9fc2VwX3NlbmRfY291bnRlciAhPSAocmV0
VmFsMiAmIDB4N0ZGRkZGRkYpKTsNCisNCisgIHNlcF9jb250ZXh0LnNlcF90b19ob3N0X3JlcGx5
X2NvdW50ZXIrKzsNCisjZWxzZQ0KKyAgLyogcG9sbCwgdW50aWwgcmVwbHkgZnJvbSBzZXAgKi8N
CisgIHdhaXRfZXZlbnQoc2VwX2NvbnRleHQuZXZlbnQsDQorCQkJKHNlcF9jb250ZXh0Lmhvc3Rf
dG9fc2VwX3NlbmRfY291bnRlciA9PQ0KKwkJCXNlcF9jb250ZXh0LnNlcF90b19ob3N0X3JlcGx5
X2NvdW50ZXIpKTsNCisNCisjZW5kaWYNCisNCisgIC8qIGNoZWNrIGlmIGVycm9yIG9jY3VyZWQg
ZHVyaW5nIHBvbGwgKi8NCisgIHJldFZhbDMgPSBTRVBfUkVBRF9SRUdJU1RFUigmc2VwX2NvbnRl
eHQsDQorCQkJSFdfSE9TVF9TRVBfSE9TVF9HUFIzX1JFR19BRERSKTsNCisJaWYgKHJldFZhbDMg
IT0gMHgwKSB7DQorCQllZGJnKCJTRVAgRHJpdmVyOiBlcnJvciBkdXJpbmcgcG9sbFxuIik7DQor
CQllcnJvciA9IC1FSU87DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisJaWYgKHNl
cF9jb250ZXh0Lmhvc3RfdG9fc2VwX3NlbmRfY291bnRlciA9PQ0KKwkJCXNlcF9jb250ZXh0LnNl
cF90b19ob3N0X3JlcGx5X2NvdW50ZXIpIHsNCisNCisJCWRtYV91bm1hcF9zaW5nbGUoc2VwX2Nv
bnRleHQuZGV2X3B0ciwNCisJCQlzZXBfY29udGV4dC5zaGFyZWRfYXJlYV9kbWFfYWRkciwNCisJ
CQlzZXBfY29udGV4dC5zaGFyZWRfYXJlYV9zaXplLA0KKwkJCURNQV9CSURJUkVDVElPTkFMKTsN
CisNCisJCS8qIHplcm8gdGhlIHNoYXJlZCBhcmVhIG1hcHBpbmcgKi8NCisJCXNlcF9jb250ZXh0
LnNoYXJlZF9hcmVhX2RtYV9hZGRyID0gMDsNCisNCisJCXJldFZhbDIgPSBTRVBfUkVBRF9SRUdJ
U1RFUigmc2VwX2NvbnRleHQsDQorCQkJSFdfSE9TVF9TRVBfSE9TVF9HUFIyX1JFR19BRERSKTsN
CisNCisJCWVkYmcoInJldFZhbDIgaXMgJXhcbiIsIHJldFZhbDIpOw0KKw0KKwkJLyogY2xlYXIg
dGhlIGJpdC1pbiBjYXNlIGl0IG11c3QgYmUgc2V0DQorCQlhZ2FpbiBieSBzZW5kX3JlcGx5X2Nv
bWFuZCAqLw0KKwkJY2xlYXJfYml0KFNFUF9TRU5EX01TR19MT0NLX0JJVCwgJnNlcF9jb250ZXh0
LmluX3VzZV9mbGFnKTsNCisNCisJCS8qIGNoZWNrIHByaW50ZiByZXF1ZXN0IGZyb20gc2VwICov
DQorCQlpZiAoKHJldFZhbDIgPj4gMzApICYgMHgxKSB7DQorDQorCQkJZWRiZygiU0VQIERyaXZl
cjogc2VwIHByaW50ZiByZXF1ZXN0IGluXG4iKTsNCisJCQkqc291cmNlX3B0ciA9IFNFUF9EUklW
RVJfU1JDX1BSSU5URjsNCisJCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisJCX0NCisNCisJCS8qIGNo
ZWNrIGlmIHRoZSB0aGlzIGlzIHNlcCByZXBseSBvciByZXF1ZXN0ICovDQorCQlpZiAocmV0VmFs
MiA+PiAzMSkgew0KKwkJCWVkYmcoIlNFUCBEcml2ZXI6IHNlcCByZXF1ZXN0IGluXG4iKTsNCisJ
CQkqc291cmNlX3B0ciA9IFNFUF9EUklWRVJfU1JDX1JFUTsNCisJICAgIC8qIHJlcXVlc3QgKi8N
CisJCX0gZWxzZSB7DQorCQkJZWRiZygiU0VQIERyaXZlcjogc2VwIHJlcGx5IGluXG4iKTsNCisJ
CQkqc291cmNlX3B0ciA9IFNFUF9EUklWRVJfU1JDX1JFUExZOw0KKwkJfQ0KKwl9DQorDQorZW5k
X2Z1bmN0aW9uOg0KKw0KKyAgcmV0dXJuIGVycm9yOw0KK30NCisNCisvKi0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0N
CisgIG9wZW4gZnVuY3Rpb24gb2YgdGhlIGNoYXJhY3RlciBkcml2ZXIgLSBpbml0aWFsaXplcyB0
aGUgcHJpdmF0ZSBkYXRhDQorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCitzdGF0aWMgaW50IHNlcF9vcGVu
KHN0cnVjdCBpbm9kZSAqaW5vZGVfcHRyLCBzdHJ1Y3QgZmlsZSAqZmlsZV9wdHIpDQorew0KKyAg
LyogcmV0dXJuIHZhbHVlICovDQorICBpbnQJCQllcnJvcjsNCisNCisgIC8qLS0tLS0tLS0tLS0t
LS0tLS0NCisJQ09ERQ0KKyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCisNCisgIGVycm9yID0g
MDsNCisNCisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gb3BlbiBzdGFydFxuIik7DQorDQor
ICAvKiBpbml0IHRoZSBwcml2YXRlIGRhdGEgZmxhZyAqLw0KKyAgZmlsZV9wdHItPnByaXZhdGVf
ZGF0YSA9ICh2b2lkICopU0VQX0RSSVZFUl9ESVNPV05fTE9DS19GTEFHOw0KKw0KKyAgZGJnKCJT
RVAgRHJpdmVyOjwtLS0tLS0tLSBvcGVuIGVuZFxuIik7DQorDQorICByZXR1cm4gZXJyb3I7DQor
fQ0KKw0KKw0KKy8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQorCXJlbGVhc2UgZnVuY3Rpb24NCistLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCitzdGF0aWMgaW50
IHNlcF9yZWxlYXNlKHN0cnVjdCBpbm9kZSAqaW5vZGVfcHRyLCBzdHJ1Y3QgZmlsZSAqZmlsZV9w
dHIpDQorew0KKyAgLyotLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0t
LS0tLS0tLS0qLw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOi0tLS0tLS0tPiBzZXBfcmVsZWFzZSBz
dGFydFxuIik7DQorDQorCS8qIGNoZWNrIHRoYXQgYWxsIHRoZSBkbWEgcmVzb3VyY2VzIHdlcmUg
ZnJlZWQgKi8NCisJc2VwX2ZyZWVfZG1hX3RhYmxlX2RhdGFfaGFuZGxlcigpOw0KKw0KKyAgLyog
dW5sb2NrIG9uIHJlbGVhc2Ugb25seSBpZiBmaWxlIHBvaW50ZXIgc3RpbGwgaG9sZHMgdGhlIGxv
Y2sgZmxhZyAqLw0KKwlpZiAoKHUzMilmaWxlX3B0ci0+cHJpdmF0ZV9kYXRhID09IFNFUF9EUklW
RVJfT1dOX0xPQ0tfRkxBRykgew0KKw0KKwkJLyogY2hlY2sgaWYgbWFwcGluZ3MgbXVzdCBiZSBm
cmVlZCAqLw0KKwkJaWYgKHNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX2RtYV9hZGRyKQ0KKwkJCWRt
YV91bm1hcF9zaW5nbGUoc2VwX2NvbnRleHQuZGV2X3B0ciwNCisJCQlzZXBfY29udGV4dC5zaGFy
ZWRfYXJlYV9kbWFfYWRkciwNCisJCQlzZXBfY29udGV4dC5zaGFyZWRfYXJlYV9zaXplLA0KKwkJ
CURNQV9CSURJUkVDVElPTkFMKTsNCisNCisJCS8qIHplcm8gdGhlIHNoYXJlZCBhcmVhIG1hcHBp
bmcgKi8NCisJCXNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX2RtYV9hZGRyID0gMDsNCisNCisJCS8q
IGNoZWNrIHRoYXQgYWxsIHRoZSBkbWEgcmVzb3VyY2VzIHdlcmUgZnJlZWQgKi8NCisJCXNlcF9m
cmVlX2RtYV90YWJsZV9kYXRhX2hhbmRsZXIoKTsNCisNCisJCS8qIHJlbGVhc2UgbG9jayAqLw0K
KwkJY2xlYXJfYml0KFNFUF9NTUFQX0xPQ0tfQklULCAmc2VwX2NvbnRleHQuaW5fdXNlX2ZsYWcp
Ow0KKw0KKwkJLyogcmFpc2UgZXZlbnQgZm9yIHN0dWNrIGNvbnRleHRlcyAqLw0KKwkJd2FrZV91
cCgmc2VwX2NvbnRleHQuZXZlbnQpOw0KKwl9DQorDQorCWRiZygiU0VQIERyaXZlcjo8LS0tLS0t
LS0gc2VwX3JlbGVhc2UgZW5kXG4iKTsNCisNCisJcmV0dXJuIDA7DQorfQ0KKw0KKw0KKw0KKw0K
Ky8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQorICBtYXAgZnVuY3Rpb24gLSB0aGlzIGZ1bmN0aW9ucyBtYXBzIHRoZSBtZXNz
YWdlIHNoYXJlZCBhcmVhDQorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KK3N0YXRpYyBpbnQgc2VwX21tYXAoc3RydWN0
IGZpbGUgICpmaWxwLCBzdHJ1Y3Qgdm1fYXJlYV9zdHJ1Y3QgICp2bWEpDQorew0KKyAgLyogcGh5
c2ljYWwgYWRkciAqLw0KKyAgZG1hX2FkZHJfdCBwaHlzX2FkZHI7DQorDQorICAvKiBlcnJvciAq
Lw0KKyAgaW50IGVycm9yOw0KKw0KKyAgLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RF
DQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCisNCisgIGRiZygiU0VQIERyaXZlcjot
LS0tLS0tLT4gbW1hcCBzdGFydFxuIik7DQorDQorICAvKiBsb2NrIHRoZSBhY2Nlc3MgdG8gU2VQ
ICovDQorICB3YWl0X2V2ZW50X2ludGVycnVwdGlibGUoc2VwX2NvbnRleHQuZXZlbnQgLA0KKyAg
ICAgIHRlc3RfYW5kX3NldF9iaXQoU0VQX01NQVBfTE9DS19CSVQsICZzZXBfY29udGV4dC5pbl91
c2VfZmxhZykgPT0gMCk7DQorCWlmIChzaWduYWxfcGVuZGluZyhjdXJyZW50KSkgew0KKwkJZXJy
b3IgPSAtRUlOVFI7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisgIC8qIHNldCB0
aGUgZmxhZyBmb3IgTE9DSyAqLw0KKyAgZmlscC0+cHJpdmF0ZV9kYXRhID0gKHZvaWQgKilTRVBf
RFJJVkVSX09XTl9MT0NLX0ZMQUc7DQorDQorICAvKiB6ZXJvIHRoZSBwb29scyAqLw0KKyAgc2Vw
X2NvbnRleHQuZGF0YV9wb29sX2J5dGVzX2FsbG9jYXRlZCA9IDA7DQorDQorICAvKiBjaGVjayB0
aGF0IHRoZSBzaXplIG9mIHRoZSBtYXBwZWQgcmFuZ2UgaXMgYXMgdGhlIHNpemUgb2YgdGhlIG1l
c3NhZ2UNCisgIHNoYXJlZCBhcmVhICovDQorCWlmICgodm1hLT52bV9lbmQgLSB2bWEtPnZtX3N0
YXJ0KSA+IFNFUF9EUklWRVJfTU1NQVBfQVJFQV9TSVpFKSB7DQorCQllZGJnKCJTRVAgRHJpdmVy
IG1tYXAgcmVxdWVzdGVkIHNpemUgaXMgbW9yZSB0aGFuIGFsbG93ZWRcbiIpOw0KKwkJZXJyb3Ig
PSAtRUFHQUlOOw0KKw0KKwkJZ290byBlbmRfZnVuY3Rpb25fd2l0aF9lcnJvcjsNCisJfQ0KKw0K
KyAgZWRiZygiU0VQIERyaXZlcjpnX3NlcF9zaGFyZWRfYXJlYV92aXJ0X2FkZHIgaXMgJXBcbiIs
DQorICAgICAgc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfdmlydF9hZGRyKTsNCisNCisgIC8qIGdl
dCBwaHlzaWNhbCBhZGRyZXNzICovDQorICBwaHlzX2FkZHIgID0gc2VwX2NvbnRleHQuc2hhcmVk
X2FyZWFfYnVzX2FkZHI7DQorDQorICBlZGJnKCJTRVAgRHJpdmVyOiBwaHlzX2FkZHIgaXMgJTA4
eFxuIiwgKHUzMilwaHlzX2FkZHIpOw0KKw0KKwlpZiAocmVtYXBfcGZuX3JhbmdlKHZtYSwNCisJ
CXZtYS0+dm1fc3RhcnQsDQorCQlwaHlzX2FkZHIgPj4gUEFHRV9TSElGVCwNCisJCXZtYS0+dm1f
ZW5kIC0gdm1hLT52bV9zdGFydCwNCisJCXZtYS0+dm1fcGFnZV9wcm90KSkgew0KKwkJZWRiZygi
U0VQIERyaXZlciByZW1hcF9wYWdlX3JhbmdlIGZhaWxlZFxuIik7DQorCQllcnJvciA9IC1FQUdB
SU47DQorDQorCQlnb3RvIGVuZF9mdW5jdGlvbl93aXRoX2Vycm9yOw0KKwl9DQorDQorCWdvdG8g
ZW5kX2Z1bmN0aW9uOw0KKw0KK2VuZF9mdW5jdGlvbl93aXRoX2Vycm9yOg0KKw0KKyAgLyogY2xl
YXIgdGhlIGJpdCAqLw0KKyAgY2xlYXJfYml0KFNFUF9NTUFQX0xPQ0tfQklUICwgJnNlcF9jb250
ZXh0LmluX3VzZV9mbGFnKTsNCisNCisgIC8qIHJhaXNlIGV2ZW50IGZvciBzdHVjayBjb250ZXh0
ZXMgKi8NCisgIHdha2VfdXAoJnNlcF9jb250ZXh0LmV2ZW50KTsNCisNCitlbmRfZnVuY3Rpb246
DQorDQorICBkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIG1tYXAgZW5kXG4iKTsNCisNCisgIHJl
dHVybiAwOw0KK30NCisNCisNCisvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQorICBwb2xsIGZ1bmN0aW9uDQorKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KK3N0YXRpYyB1MzIgc2VwX3BvbGwoc3RydWN0IGZp
bGUgICpmaWxwLCBwb2xsX3RhYmxlICAqd2FpdCkNCit7DQorICB1MzIgY291bnQ7DQorDQorICB1
MzIJbWFzayA9IDA7DQorDQorICAvKiBHUFIyIHJlZ2lzdGVyICovDQorICB1MzIJcmV0VmFsMjsN
CisNCisgIC8qIEdQUjMgcmVnaXN0ZXIgKi8NCisgIHUzMglyZXRWYWwzOw0KKw0KKyAgLyotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQorCUNPREUNCisgIC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKw0KKyAg
ZGJnKCJTRVAgRHJpdmVyOi0tLS0tLS0tPiBwb2xsIHN0YXJ0XG4iKTsNCisNCisgIHJldFZhbDIg
PSByZXRWYWwzID0gMDsNCisNCisgIC8qIGNoZWNrIHRoYXQgb25seSBwcm9jZXNzIHRoYXQgbG9j
ayB0aGUgZHJpdmVyIG1heSBjYWxsIHRoZSBwb2xsICAqLw0KKyAgaWYgKCh1MzIpZmlscC0+cHJp
dmF0ZV9kYXRhICE9IFNFUF9EUklWRVJfT1dOX0xPQ0tfRkxBRykgew0KKwkJbWFzayA9IFBPTExF
UlI7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisJLyogY2hlY2sgaWYgc2VuZCBj
b21tYW5kIG9yIHNlbmRfcmVwbHkgd2VyZSBhY3RpdmF0ZWQgcHJldmlvdXNseSAqLw0KKwlpZiAo
IXRlc3RfYml0KFNFUF9TRU5EX01TR19MT0NLX0JJVCwgJnNlcF9jb250ZXh0LmluX3VzZV9mbGFn
KSkgew0KKwkJbWFzayA9IFBPTExFUlI7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisN
CisjaWYgU0VQX0RSSVZFUl9QT0xMSU5HX01PREUNCisNCisJd2hpbGUgKChyZXRWYWwzICA9PSAw
eDApICYmDQorCShzZXBfY29udGV4dC5ob3N0X3RvX3NlcF9zZW5kX2NvdW50ZXIgIT0gKHJldFZh
bDIgJiAweDNGRkZGRkZGKSkpIHsNCisJCXJldFZhbDIgPSBTRVBfUkVBRF9SRUdJU1RFUigmc2Vw
X2NvbnRleHQsDQorCQkJSFdfSE9TVF9TRVBfSE9TVF9HUFIyX1JFR19BRERSKTsNCisNCisJCXJl
dFZhbDMgPSBTRVBfUkVBRF9SRUdJU1RFUigmc2VwX2NvbnRleHQsDQorCQkJSFdfSE9TVF9TRVBf
SE9TVF9HUFIzX1JFR19BRERSKTsNCisJfQ0KKw0KKyAgc2VwX2NvbnRleHQuc2VwX3RvX2hvc3Rf
cmVwbHlfY291bnRlcisrOw0KKyNlbHNlDQorICAvKiBhZGQgdGhlIGV2ZW50IHRvIHRoZSBwb2xs
aW5nIHdhaXQgdGFibGUgKi8NCisgIHBvbGxfd2FpdChmaWxwLCAmc2VwX2NvbnRleHQuZXZlbnQs
IHdhaXQpOw0KKw0KKyNlbmRpZg0KKw0KKyAgZWRiZygic2VwX2hvc3RfdG9fc2VwX3NlbmRfY291
bnRlciBpcyAleFxuIiwNCisgICAgICBzZXBfY29udGV4dC5ob3N0X3RvX3NlcF9zZW5kX2NvdW50
ZXIpOw0KKyAgZWRiZygic2VwX3NlcF90b19ob3N0X3JlcGx5X2NvdW50ZXIgaXMgJXhcbiIsDQor
ICAgICAgc2VwX2NvbnRleHQuc2VwX3RvX2hvc3RfcmVwbHlfY291bnRlcik7DQorDQorICAvKiBj
aGVjayBpZiBlcnJvciBvY2N1cmVkIGR1cmluZyBwb2xsICovDQorICByZXRWYWwzID0gU0VQX1JF
QURfUkVHSVNURVIoJnNlcF9jb250ZXh0LA0KKwkJCUhXX0hPU1RfU0VQX0hPU1RfR1BSM19SRUdf
QUREUik7DQorCWlmIChyZXRWYWwzICE9IDB4MCkgew0KKwkJZWRiZygiU0VQIERyaXZlcjogZXJy
b3IgZHVyaW5nIHBvbGxcbiIpOw0KKwkJbWFzayB8PSBQT0xMRVJSOw0KKw0KKwkJZ290byBlbmRf
ZnVuY3Rpb247DQorICB9DQorDQorICAvKiBjaGVjayBpZiB0aGUgZGF0YSBpcyByZWFkeSAqLw0K
KwlpZiAoc2VwX2NvbnRleHQuaG9zdF90b19zZXBfc2VuZF9jb3VudGVyID09DQorCQkJc2VwX2Nv
bnRleHQuc2VwX3RvX2hvc3RfcmVwbHlfY291bnRlcikgew0KKw0KKwkJZG1hX3VubWFwX3Npbmds
ZShzZXBfY29udGV4dC5kZXZfcHRyLA0KKwkJCXNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX2RtYV9h
ZGRyLA0KKwkJCXNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX3NpemUsDQorCQkJRE1BX0JJRElSRUNU
SU9OQUwpOw0KKw0KKwkJLyogemVybyB0aGUgc2hhcmVkIGFyZWEgbWFwcGluZyAqLw0KKwkJc2Vw
X2NvbnRleHQuc2hhcmVkX2FyZWFfZG1hX2FkZHIgPSAwOw0KKw0KKwkJZm9yIChjb3VudCA9IDA7
IGNvdW50IDwgMTIgKiA0OyBjb3VudCArPSA0KQ0KKwkJCWVkYmcoIlNlcCBNZXNnIFdvcmQgJXgg
b2YgdGhlIG1lc3NhZ2UgaXMgJXhcbiIsDQorCQkJY291bnQsDQorCQkJKigodTMyICopKHNlcF9j
b250ZXh0LnNoYXJlZF9hcmVhX3ZpcnRfYWRkciArIGNvdW50KSkpOw0KKw0KKwkJZm9yIChjb3Vu
dCA9IDA7IGNvdW50IDwgMTAgKiA0OyBjb3VudCArPSA0KQ0KKwkJCWVkYmcoIkRlYnVnIERhdGEg
V29yZCAleCBvZiB0aGUgbWVzc2FnZSBpcyAleFxuIiwNCisJCQljb3VudCwNCisJCQkqKCh1MzIg
Kikoc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfdmlydF9hZGRyICsNCisJCQkJMHgxODAwICsNCisJ
CQkJY291bnQpKSk7DQorDQorCQlyZXRWYWwyID0gU0VQX1JFQURfUkVHSVNURVIoJnNlcF9jb250
ZXh0LA0KKwkJCUhXX0hPU1RfU0VQX0hPU1RfR1BSMl9SRUdfQUREUik7DQorDQorCQllZGJnKCJy
ZXRWYWwyIGlzICV4XG4iLCByZXRWYWwyKTsNCisNCisJCS8qIGNsZWFyIHRoZSBiaXQtaW4gY2Fz
ZSBpdCBtdXN0IGJlIHNldA0KKwkJYWdhaW4gYnkgc2VuZF9yZXBseV9jb21hbmQgKi8NCisJCWNs
ZWFyX2JpdChTRVBfU0VORF9NU0dfTE9DS19CSVQsICZzZXBfY29udGV4dC5pbl91c2VfZmxhZyk7
DQorDQorCQkvKiBjaGVjayBwcmludGYgcmVxdWVzdCBmcm9tIHNlcCAqLw0KKwkJaWYgKChyZXRW
YWwyID4+IDMwKSAmIDB4MSkgew0KKwkJCWVkYmcoIlNFUCBEcml2ZXI6IHNlcCBwcmludGYgcmVx
dWVzdCBpblxuIik7DQorCQkJbWFzayB8PSBQT0xMSFVQOw0KKw0KKwkJCWdvdG8gZW5kX2Z1bmN0
aW9uOw0KKyAgICB9DQorDQorCQkvKiBjaGVjayBpZiB0aGUgdGhpcyBpcyBzZXAgcmVwbHkgb3Ig
cmVxdWVzdCAqLw0KKwkJaWYgKHJldFZhbDIgPj4gMzEpIHsNCisJCQllZGJnKCJTRVAgRHJpdmVy
OiBzZXAgcmVxdWVzdCBpblxuIik7DQorCQkJLyogcmVxdWVzdCAqLw0KKwkJCW1hc2sgfD0gUE9M
TE9VVCB8IFBPTExXUk5PUk07DQorCQl9IGVsc2Ugew0KKwkJCWVkYmcoIlNFUCBEcml2ZXI6IHNl
cCByZXBseSBpblxuIik7DQorCQkJbWFzayB8PSBQT0xMSU4gfCBQT0xMUkROT1JNOw0KKwkJfQ0K
Kw0KKwl9DQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0t
LSBwb2xsIGV4aXRcbiIpOw0KKyAgcmV0dXJuIG1hc2s7DQorfQ0KKw0KKy8qDQorICBUaGlzIGZ1
bmN0aW9uIHJhaXNlcyBpbnRlcnJ1cHQgdG8gU0VQbSB0aGF0IHNpZ25hbHMgdGhhdCBpcyBoYXMg
YQ0KKyAgbmV3IGNvbW1hbmQgZnJvbSBIT1NUDQorKi8NCitzdGF0aWMgaW50IHNlcF9zZW5kX3Jl
cGx5X2NvbW1hbmRfaGFuZGxlcih2b2lkKQ0KK3sNCisJLyogY291bnQgKi8NCisgIHUzMiBjb3Vu
dDsNCisNCisgIC8qIGVycm9yICovDQorICBpbnQgZXJyb3I7DQorDQorDQorICBkYmcoIlNFUCBE
cml2ZXI6LS0tLS0tLS0+IHNlcF9zZW5kX3JlcGx5X2NvbW1hbmRfaGFuZGxlciBzdGFydFxuIik7
DQorDQorICBlcnJvciA9IDA7DQorDQorICAvKiBjaGVjayBpZiBtZXNzYWdlIHdhcyBhbHJlYWR5
IHNlbnQgd2l0aG91dCBwb2xsICovDQorICBpZiAodGVzdF9iaXQoU0VQX1NFTkRfTVNHX0xPQ0tf
QklULCAmc2VwX2NvbnRleHQuaW5fdXNlX2ZsYWcpKSB7DQorCQllcnJvciA9IC1FQUNDRVM7DQor
CQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisJZm9yIChjb3VudCA9IDA7IGNvdW50IDwg
MTIgKiA0OyBjb3VudCArPSA0KQ0KKwkJZWRiZygiV29yZCAleCBvZiB0aGUgbWVzc2FnZSBpcyAl
eFxuIiwNCisJCQljb3VudCwNCisJCQkqKCh1MzIgKikoc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFf
dmlydF9hZGRyICsgY291bnQpKSk7DQorDQorICAvKiBzZXQgYml0IHRoYXQgYWxsb3dzIHBvbGwg
Ki8NCisgIHNldF9iaXQoU0VQX1NFTkRfTVNHX0xPQ0tfQklULCAmc2VwX2NvbnRleHQuaW5fdXNl
X2ZsYWcpOw0KKw0KKyAgLyogdXBkYXRlIGJvdGggY291bnRlcnMgY291bnRlciAqLw0KKyAgc2Vw
X2NvbnRleHQuaG9zdF90b19zZXBfc2VuZF9jb3VudGVyKys7DQorDQorICBzZXBfY29udGV4dC5z
ZXBfdG9faG9zdF9yZXBseV9jb3VudGVyKys7DQorDQorICAvKiBmbHVzaCBzaGFyZWQgYXJlYSAq
Lw0KKwlzZXBfY29udGV4dC5zaGFyZWRfYXJlYV9kbWFfYWRkciA9DQorCQlkbWFfbWFwX3Npbmds
ZShzZXBfY29udGV4dC5kZXZfcHRyLA0KKwkJKHZvaWQgKilzZXBfY29udGV4dC5zaGFyZWRfYXJl
YV92aXJ0X2FkZHIsDQorCQlzZXBfY29udGV4dC5zaGFyZWRfYXJlYV9zaXplLA0KKwkJRE1BX0JJ
RElSRUNUSU9OQUwpOw0KKw0KKyAgLyogc2VuZCB0aGUgaW50ZXJydXB0IHRvIFNFUCAqLw0KKyAg
U0VQX1dSSVRFX1JFR0lTVEVSKCZzZXBfY29udGV4dCwNCisJCQkJSFdfSE9TVF9IT1NUX1NFUF9H
UFIyX1JFR19BRERSLA0KKwkJCQlzZXBfY29udGV4dC5ob3N0X3RvX3NlcF9zZW5kX2NvdW50ZXIp
Ow0KKw0KKyAgLyogdXBkYXRlIGhvc3QgdG8gc2VwIGNvdW50ZXIgKi8NCisgIHNlcF9jb250ZXh0
Lmhvc3RfdG9fc2VwX3NlbmRfY291bnRlcisrOw0KKw0KK2VuZF9mdW5jdGlvbjoNCisNCisgIGRi
ZygiU0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX3NlbmRfcmVwbHlfY29tbWFuZF9oYW5kbGVyIGVu
ZFxuIik7DQorDQorICByZXR1cm4gZXJyb3I7DQorfQ0KKw0KKy8qDQorICBUaGlzIGZ1bmN0aW9u
IGhhbmRsZXMgdGhlIGFsbG9jYXRlIGRhdGEgcG9vbCBtZW1vcnkgcmVxdWVzdA0KKyAgVGhpcyBm
dW5jdGlvbiByZXR1cm5zIGNhbGN1bGF0ZXMgdGhlIHBoeXNpY2FsIGFkZHJlc3Mgb2YgdGhlDQor
ICBhbGxvY2F0ZWQgbWVtb3J5LCBhbmQgdGhlIG9mZnNldCBvZiB0aGlzIGFyZWEgZnJvbSB0aGUg
bWFwcGVkIGFkZHJlc3MuDQorICBUaGVyZWZvcmUsIHRoZSBGVk9zIGluIHVzZXIgc3BhY2UgY2Fu
IGNhbGN1bGF0ZSB0aGUgZXhhY3QgdmlydHVhbA0KKyAgYWRkcmVzcyBvZiB0aGlzIGFsbG9jYXRl
ZCBtZW1vcnkNCisqLw0KK3N0YXRpYyBpbnQgc2VwX2FsbG9jYXRlX2RhdGFfcG9vbF9tZW1vcnlf
aGFuZGxlcih2b2lkICphcmcpDQorew0KKyAgLyogZXJyb3IgKi8NCisgIGludCAgIGVycm9yOw0K
Kw0KKyAgLyogY29tbWFuZCBwYXJhbWF0ZXJzICovDQorICBzdHJ1Y3Qgc2VwX2RyaXZlcl9hbGxv
Y190ICBjb21tYW5kX2FyZ3M7DQorDQorICAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCisJ
Q09ERQ0KKyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQorICBkYmcoIlNFUCBE
cml2ZXI6LS0tLS0tLS0+IHNlcF9hbGxvY2F0ZV9kYXRhX3Bvb2xfbWVtb3J5X2hhbmRsZXIgc3Rh
cnRcbiIpOw0KKw0KKyAgZXJyb3IgPSAwOw0KKw0KKwlpZiAoY29weV9mcm9tX3VzZXIoJmNvbW1h
bmRfYXJncywNCisJCQlhcmcsDQorCQkJc2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVyX2FsbG9jX3Qp
KSkgew0KKw0KKwkJCWVycm9yID0gLUVGQVVMVDsNCisJCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisg
IH0NCisNCisgIC8qIGFsbG9jYXRlIG1lbW9yeSAqLw0KKwlpZiAoDQorCQkoU0VQX0RSSVZFUl9E
QVRBX1BPT0xfU0hBUkVEX0FSRUFfU0laRV9JTl9CWVRFUyAtDQorCQlzZXBfY29udGV4dC5kYXRh
X3Bvb2xfYnl0ZXNfYWxsb2NhdGVkKSA8DQorCQljb21tYW5kX2FyZ3MubnVtX2J5dGVzKSB7DQor
CQllcnJvciA9IC1FTk9NRU07DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisgIC8q
IHNldCB0aGUgdmlydHVhbCBhbmQgcGh5c2ljYWwgYWRkcmVzcyAqLw0KKyAgY29tbWFuZF9hcmdz
Lm9mZnNldCA9IFNFUF9EUklWRVJfREFUQV9QT09MX0FSRUFfT0ZGU0VUX0lOX0JZVEVTICsNCisJ
CQlzZXBfY29udGV4dC5kYXRhX3Bvb2xfYnl0ZXNfYWxsb2NhdGVkOw0KKyAgY29tbWFuZF9hcmdz
LmJ1c19hZGRyZXNzID0gc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfYnVzX2FkZHIgKw0KKwkJCVNF
UF9EUklWRVJfREFUQV9QT09MX0FSRUFfT0ZGU0VUX0lOX0JZVEVTICsNCisJCQlzZXBfY29udGV4
dC5kYXRhX3Bvb2xfYnl0ZXNfYWxsb2NhdGVkOw0KKw0KKyAgLyogd3JpdGUgdGhlIG1lbW9yeSBi
YWNrIHRvIHRoZSB1c2VyIHNwYWNlICovDQorCWlmIChjb3B5X3RvX3VzZXIoKHZvaWQgKilhcmcs
DQorCQkJKHZvaWQgKikmY29tbWFuZF9hcmdzLA0KKwkJCXNpemVvZihzdHJ1Y3Qgc2VwX2RyaXZl
cl9hbGxvY190KSkpIHsNCisNCisJCWVycm9yID0gLUVGQVVMVDsNCisJCWdvdG8gZW5kX2Z1bmN0
aW9uOw0KKyAgfQ0KKw0KKyAgLyogc2V0IHRoZSBhbGxvY2F0aW9uICovDQorICBzZXBfY29udGV4
dC5kYXRhX3Bvb2xfYnl0ZXNfYWxsb2NhdGVkICs9IGNvbW1hbmRfYXJncy5udW1fYnl0ZXM7DQor
DQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBfYWxs
b2NhdGVfZGF0YV9wb29sX21lbW9yeV9oYW5kbGVyIGVuZFxuIik7DQorDQorICByZXR1cm4gZXJy
b3I7DQorfQ0KKw0KKw0KKw0KKw0KKw0KKy8qDQorICB0aGlzIGZ1bmN0aW9uIGhhbmRsZXMgdGhl
IHJlcXVlc3QgZm9yIGNyZWF0aW9uIG9mIHRoZSBETUEgdGFibGUNCisgIGZvciB0aGUgc3luY2hy
b25pYyBzeW1tZXRyaWMgb3BlcmF0aW9ucyAoQUVTLERFUyxIQVNIKS4NCisgIGl0IHJldHVybnMg
dGhlIHBoeXNpY2FsIGFkZHJlc3NlcyBvZiB0aGUgY3JlYXRlZCBETUEgdGFibGUgdG8gdGhlDQor
ICB1c2VyIHNwYWNlIHdoaWNoIGluc2VydCB0aGVtIGFzIGEgcGFyYW1ldGVycyB0byB0aGUgSE9T
VC1TRVAgbWVzc2FnZS4NCisgIHRoaXMgcG9pbnRlcnMgYXJlIE5PVCBiZWluZyB0cmVhdGVkIGJ5
IHRoZSB1c2VyIGFwcGxpY2F0aW9uIGluIGFueSBjYXNlLg0KKyovDQorc3RhdGljIGludCBzZXBf
Y3JlYXRlX3N5bmNfZG1hX3RhYmxlc19oYW5kbGVyKHZvaWQgKmFyZykNCit7DQorICAvKiBlcnJv
ciAqLw0KKyAgaW50ICAgZXJyb3I7DQorDQorICAvKiBjb21tYW5kIGFyZ3VtZW50cyAqLw0KKyAg
c3RydWN0IHNlcF9kcml2ZXJfYnVpbGRfc3luY190YWJsZV90IGNvbW1hbmRfYXJnczsNCisNCisg
IC8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQorCUNPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tKi8NCisNCisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX2NyZWF0ZV9z
eW5jX2RtYV90YWJsZXNfaGFuZGxlciBzdGFydFxuIik7DQorDQorCWlmIChjb3B5X2Zyb21fdXNl
cigmY29tbWFuZF9hcmdzLA0KKwkJCWFyZywNCisJCQlzaXplb2Yoc3RydWN0IHNlcF9kcml2ZXJf
YnVpbGRfc3luY190YWJsZV90KSkpIHsNCisNCisJCQllcnJvciA9IC1FRkFVTFQ7DQorCQkJZ290
byBlbmRfZnVuY3Rpb247DQorICB9DQorDQorICBlZGJnKCJhcHBfaW5fYWRkcmVzcyBpcyAlMDhs
eFxuIiwgY29tbWFuZF9hcmdzLmFwcF9pbl9hZGRyZXNzKTsNCisgIGVkYmcoImFwcF9vdXRfYWRk
cmVzcyBpcyAlMDhseFxuIiwgY29tbWFuZF9hcmdzLmFwcF9vdXRfYWRkcmVzcyk7DQorICBlZGJn
KCJkYXRhX3NpemUgaXMgJXhcbiIsIGNvbW1hbmRfYXJncy5kYXRhX2luX3NpemUpOw0KKyAgZWRi
ZygiYmxvY2tfc2l6ZSBpcyAleFxuIiwgY29tbWFuZF9hcmdzLmJsb2NrX3NpemUpOw0KKw0KKyAg
LyogdmFsaWRhdGUgdXNlciBwYXJhbWV0ZXJzICovDQorCWlmICghY29tbWFuZF9hcmdzLmFwcF9p
bl9hZGRyZXNzKSB7DQorDQorCQllZGJnKCJTRVAgRHJpdmVyOiBwYXJhbXMgdmFsaWRhdGlvbiBl
cnJvclxuIik7DQorDQorCQllcnJvciA9IC1FSU5WQUw7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsN
CisgIH0NCisNCisgIC8qIGNoZWNrIGlmIHdlIG5lZWQgdG8gYnVpbGQgb25seSBpbnB1dCB0YWJs
ZSBvciBpbnB1dC9vdXRwdXQgKi8NCisgIGlmIChjb21tYW5kX2FyZ3MuYXBwX291dF9hZGRyZXNz
KSB7DQorDQorCS8qIHByZXBhcmUgaW5wdXQvb3V0cHV0IHRhYmxlcy4gKi8NCisJZXJyb3IgPSBz
ZXBfcHJlcGFyZV9pbnB1dF9vdXRwdXRfZG1hX3RhYmxlKA0KKyAgICAgIGNvbW1hbmRfYXJncy5h
cHBfaW5fYWRkcmVzcywNCisgICAgICBjb21tYW5kX2FyZ3MuYXBwX291dF9hZGRyZXNzLA0KKyAg
ICAgIGNvbW1hbmRfYXJncy5kYXRhX2luX3NpemUsDQorICAgICAgY29tbWFuZF9hcmdzLmJsb2Nr
X3NpemUsDQorICAgICAgJmNvbW1hbmRfYXJncy5pbl90YWJsZV9hZGRyZXNzLA0KKyAgICAgICZj
b21tYW5kX2FyZ3Mub3V0X3RhYmxlX2FkZHJlc3MsDQorICAgICAgJmNvbW1hbmRfYXJncy5pbl90
YWJsZV9udW1fZW50cmllcywNCisgICAgICAmY29tbWFuZF9hcmdzLm91dF90YWJsZV9udW1fZW50
cmllcywNCisgICAgICAmY29tbWFuZF9hcmdzLnRhYmxlX2RhdGFfc2l6ZSwNCisgICAgICBjb21t
YW5kX2FyZ3MuaXNLZXJuZWxWaXJ0dWFsQWRkcmVzcyk7DQorDQorICB9IGVsc2Ugew0KKwkvKiBw
cmVwYXJlIGlucHV0IHRhYmxlcyAqLw0KKwllcnJvciA9IHNlcF9wcmVwYXJlX2lucHV0X2RtYV90
YWJsZSgNCisJCQkJCWNvbW1hbmRfYXJncy5hcHBfaW5fYWRkcmVzcywNCisJCQkJCWNvbW1hbmRf
YXJncy5kYXRhX2luX3NpemUsDQorCQkJCQljb21tYW5kX2FyZ3MuYmxvY2tfc2l6ZSwNCisJCQkJ
CSZjb21tYW5kX2FyZ3MuaW5fdGFibGVfYWRkcmVzcywNCisJCQkJCSZjb21tYW5kX2FyZ3MuaW5f
dGFibGVfbnVtX2VudHJpZXMsDQorCQkJCQkmY29tbWFuZF9hcmdzLnRhYmxlX2RhdGFfc2l6ZSwN
CisJCQkJCWNvbW1hbmRfYXJncy5pc0tlcm5lbFZpcnR1YWxBZGRyZXNzKTsNCisgIH0NCisNCisJ
aWYgKGVycm9yKQ0KKwkJZ290byBlbmRfZnVuY3Rpb247DQorDQorICAvKiBjb3B5IHRvIHVzZXIg
Ki8NCisJaWYgKGNvcHlfdG9fdXNlcihhcmcsDQorCQkJKHZvaWQgKikmY29tbWFuZF9hcmdzLA0K
KwkJCXNpemVvZihzdHJ1Y3Qgc2VwX2RyaXZlcl9idWlsZF9zeW5jX3RhYmxlX3QpKSkNCisJCWVy
cm9yID0gLUVGQVVMVDsNCisNCisNCitlbmRfZnVuY3Rpb246DQorDQorICBkYmcoIlNFUCBEcml2
ZXI6PC0tLS0tLS0tIHNlcF9jcmVhdGVfc3luY19kbWFfdGFibGVzX2hhbmRsZXIgZW5kXG4iKTsN
CisNCisgIHJldHVybiBlcnJvcjsNCit9DQorDQorLyoNCisgIFRoaXMgQVBJIGhhbmRsZXMgdGhl
IGVuZCB0cmFuc2FjdGlvbiByZXF1ZXN0DQorKi8NCitzdGF0aWMgaW50IHNlcF9lbmRfdHJhbnNh
Y3Rpb25faGFuZGxlcihzdHJ1Y3QgZmlsZSAqZmlsZV9wdHIpDQorew0KKyAgLyotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQorCUNPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tKi8NCisNCisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX2VuZF90cmFuc2FjdGlv
bl9oYW5kbGVyIHN0YXJ0XG4iKTsNCisNCisJLyogY2hlY2sgdGhhdCBwb2xsIHdhcyBjYWxsZWQg
YmVmb3JlICovDQorICBpZiAoc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfZG1hX2FkZHIpDQorCQkJ
ZG1hX3VubWFwX3NpbmdsZShzZXBfY29udGV4dC5kZXZfcHRyLA0KKwkJCXNlcF9jb250ZXh0LnNo
YXJlZF9hcmVhX2RtYV9hZGRyLA0KKwkJCXNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX3NpemUsDQor
CQkJRE1BX0JJRElSRUNUSU9OQUwpOw0KKw0KKwkvKiB6ZXJvIHRoZSBzaGFyZWQgYXJlYSBtYXBw
aW5nICovDQorCXNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX2RtYV9hZGRyID0gMDsNCisNCisJLyog
Y2hlY2sgdGhhdCBhbGwgdGhlIGRtYSByZXNvdXJjZXMgd2VyZSBmcmVlZCAqLw0KKwlzZXBfZnJl
ZV9kbWFfdGFibGVfZGF0YV9oYW5kbGVyKCk7DQorDQorICBjbGVhcl9iaXQoU0VQX01NQVBfTE9D
S19CSVQgLCAmc2VwX2NvbnRleHQuaW5fdXNlX2ZsYWcpOw0KKw0KKyAgLyogcmFpc2UgZXZlbnQg
Zm9yIHN0dWNrIGNvbnRleHRlcyAqLw0KKyAgd2FrZV91cCgmc2VwX2NvbnRleHQuZXZlbnQpOw0K
Kw0KKyAgZmlsZV9wdHItPnByaXZhdGVfZGF0YSA9ICh2b2lkICopU0VQX0RSSVZFUl9ESVNPV05f
TE9DS19GTEFHOw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBfZW5kX3RyYW5z
YWN0aW9uX2hhbmRsZXIgZW5kXG4iKTsNCisNCisgIHJldHVybiAwOw0KK30NCisNCitzdGF0aWMg
aW50IHNlcF9zdGFydF9oYW5kbGVyKHZvaWQpDQorew0KKyAgLyogcmVnIHZhbCAqLw0KKyAgdTMy
IHJlZ192YWw7DQorDQorICAvKiBlcnJvciAqLw0KKyAgdTMyIGVycm9yOw0KKw0KKyAgLyotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0qLw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOi0tLS0tLS0tPiBzZXBfc3RhcnRf
aGFuZGxlciBzdGFydFxuIik7DQorDQorICBlcnJvciA9IDA7DQorDQorICAvKiB3YWl0IGluIHBv
bGxpbmcgZm9yIG1lc3NhZ2UgZnJvbSBTRVAgKi8NCisJZG8gew0KKwkJcmVnX3ZhbCA9IFNFUF9S
RUFEX1JFR0lTVEVSKCZzZXBfY29udGV4dCwNCisJCQlIV19IT1NUX1NFUF9IT1NUX0dQUjNfUkVH
X0FERFIpOw0KKwl9IHdoaWxlICghcmVnX3ZhbCk7DQorDQorICAvKiBjaGVjayB0aGUgdmFsdWUg
Ki8NCisJaWYgKHJlZ192YWwgPT0gMHgxKSB7DQorCQkvKiBmYXRhbCBlcnJvciAtIHJlYWQgZXJy
byBzdGF0dXMgZnJvbSBHUFJPICovDQorCQllcnJvciA9IFNFUF9SRUFEX1JFR0lTVEVSKCZzZXBf
Y29udGV4dCwNCisJCQlIV19IT1NUX1NFUF9IT1NUX0dQUjBfUkVHX0FERFIpOw0KKwkJZ290byBl
bmRfZnVuY3Rpb247DQorICB9DQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgZGJnKCJTRVAgRHJp
dmVyOjwtLS0tLS0tLSBzZXBfc3RhcnRfaGFuZGxlciBlbmRcbiIpOw0KKw0KKyAgcmV0dXJuIGVy
cm9yOw0KK30NCisNCisNCisvKg0KKyAgdGhpcyBmdW5jdGlvbiBoYW5kbGVzIHRoZSByZXF1ZXN0
IGZvciBTRVAgaW5pdGlhbGl6YXRpb24NCisqLw0KK3N0YXRpYyBpbnQgc2VwX2luaXRfaGFuZGxl
cih2b2lkICphcmcpDQorew0KKyAgLyogd29yZCBmcm9tIG1lc3NhZ2UgKi8NCisgIHUzMgkgbWVz
c2FnZV93b3JkOw0KKw0KKyAgLyogbWVzc2FnZSBwdHIgKi8NCisgIHUzMgkJKm1lc3NhZ2VfcHRy
Ow0KKw0KKyAgLyogY29tbWFuZCBhcmd1bWVudHMgKi8NCisgIHN0cnVjdCBzZXBfZHJpdmVyX2lu
aXRfdCBjb21tYW5kX2FyZ3M7DQorDQorICAvKiBjb3VudGVyICovDQorICB1MzIgICBjb3VudGVy
Ow0KKw0KKyAgLyogZXJyb3IgKi8NCisgIGludCAgIGVycm9yOw0KKw0KKyAgLyogcmVnIHZhbCAq
Lw0KKyAgdTMyICAgcmVnX3ZhbDsNCisNCisgIC8qLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RF
DQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOi0tLS0t
LS0tPiBzZXBfaW5pdF9oYW5kbGVyIHN0YXJ0XG4iKTsNCisNCisgIGVycm9yID0gMDsNCisNCisg
IC8qIHRoaXMgQVBJIG1heSBiZSBydW4gb25seSBieSByb290ICovDQorCWlmICghY2FwYWJsZShD
QVBfU1lTX0FETUlOKSkgew0KKwkJZXJyb3IgPSAtRUFDQ0VTOw0KKwkJZ290byBlbmRfZnVuY3Rp
b247DQorICB9DQorDQorCWlmIChjb3B5X2Zyb21fdXNlcigmY29tbWFuZF9hcmdzLCBhcmcsDQor
CQkJc2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVyX2luaXRfdCkpKSB7DQorDQorCQllcnJvciA9IC1F
RkFVTFQ7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisgIC8qIHZhbGlkYXRlIHVz
ZXIgcGFyYW1ldGVycyAqLw0KKwlpZiAoIWNvbW1hbmRfYXJncy5tZXNzYWdlX2FkZHIgfHwgIWNv
bW1hbmRfYXJncy5zZXBfc3JhbV9hZGRyKSB7DQorCQllZGJnKCJTRVAgRHJpdmVyOiBwYXJhbXMg
dmFsaWRhdGlvbiBlcnJvclxuIik7DQorDQorCQllcnJvciA9IC1FSU5WQUw7DQorCQlnb3RvIGVu
ZF9mdW5jdGlvbjsNCisgIH0NCisNCisgIG1lc3NhZ2VfcHRyID0gY29tbWFuZF9hcmdzLm1lc3Nh
Z2VfYWRkcjsNCisNCisgIGVkYmcoIlNFUCBEcml2ZXI6IGJlZm9yZSB3cml0ZTFcbiIpOw0KKyAg
Lyogc2V0IHRoZSBiYXNlIGFkZHJlc3Mgb2YgdGhlIFNSQU0gICovDQorICBTRVBfV1JJVEVfUkVH
SVNURVIoJnNlcF9jb250ZXh0LA0KKwkJCQkJSFdfU1JBTV9BRERSX1JFR19BRERSLA0KKwkJCQkJ
Y29tbWFuZF9hcmdzLnNlcF9zcmFtX2FkZHIpOw0KKw0KKyAgZm9yIChjb3VudGVyID0gMCA7DQor
CQljb3VudGVyIDwgY29tbWFuZF9hcmdzLm1lc3NhZ2Vfc2l6ZV9pbl93b3JkczsNCisJCWNvdW50
ZXIrKywgbWVzc2FnZV9wdHIrKykgew0KKwlnZXRfdXNlcihtZXNzYWdlX3dvcmQsIG1lc3NhZ2Vf
cHRyKTsNCisNCisgIGVkYmcoIlNFUCBEcml2ZXI6IGJlZm9yZSB3cml0ZTJcbiIpDQorCS8qIHdy
aXRlIGRhdGEgdG8gU1JBTSAqLw0KKwlTRVBfV1JJVEVfUkVHSVNURVIoJnNlcF9jb250ZXh0LCBI
V19TUkFNX0RBVEFfUkVHX0FERFIsDQorCQkJCQkJbWVzc2FnZV93b3JkKTsNCisNCisJZWRiZygi
U0VQIERyaXZlcjptZXNzYWdlX3dvcmQgaXMgJXhcbiIsIG1lc3NhZ2Vfd29yZCk7DQorDQorCS8q
IHdhaXQgZm9yIHdyaXRlIGNvbXBsZXRlICovDQorCVNFUF9XQUlUX1NSQU1fV1JJVEVfQ09NUExF
VEUoJnNlcF9jb250ZXh0KTsNCisgIH0NCisNCisgIC8qIHNpZ25hbCBTRVAgKi8NCisgIFNFUF9X
UklURV9SRUdJU1RFUigmc2VwX2NvbnRleHQsIEhXX0hPU1RfSE9TVF9TRVBfR1BSMF9SRUdfQURE
UiwgMHgxKTsNCisNCisJZG8gew0KKwkJcmVnX3ZhbCA9IFNFUF9SRUFEX1JFR0lTVEVSKCZzZXBf
Y29udGV4dCwNCisJCQlIV19IT1NUX1NFUF9IT1NUX0dQUjNfUkVHX0FERFIpOw0KKwl9IHdoaWxl
ICghKHJlZ192YWwgJiAweEZGRkZGRkZEKSk7DQorDQorICAvKiBjaGVjayB0aGUgdmFsdWUgKi8N
CisJaWYgKHJlZ192YWwgPT0gMHgxKSB7DQorCQllZGJnKCJTRVAgRHJpdmVyOmluaXQgZmFpbGVk
XG4iKTsNCisNCisJCWVycm9yID0gU0VQX1JFQURfUkVHSVNURVIoJnNlcF9jb250ZXh0LCAweDgw
NjApOw0KKwkJZWRiZygiU0VQIERyaXZlcjpzdyBtb25pdG9yIGlzICV4XG4iLCBlcnJvcik7DQor
DQorCQkvKiBmYXRhbCBlcnJvciAtIHJlYWQgZXJybyBzdGF0dXMgZnJvbSBHUFJPICovDQorCQll
cnJvciA9IFNFUF9SRUFEX1JFR0lTVEVSKCZzZXBfY29udGV4dCwNCisJCQlIV19IT1NUX1NFUF9I
T1NUX0dQUjBfUkVHX0FERFIpOw0KKwkJZWRiZygiU0VQIERyaXZlcjplcnJvciBpcyAleFxuIiwg
ZXJyb3IpOw0KKwkJZ290byBlbmRfZnVuY3Rpb247DQorICB9DQorDQorICBlZGJnKCJTRVAgRHJp
dmVyOiBzaWduYWwgZW5kIENDX0lOSVQsIHJlZ192YWwgaXMgJWRcbiIsIHJlZ192YWwpOw0KKw0K
KyAgLyogc2lnbmFsIHNlcCB0byB6ZXJvIHRoZSBHUFIzICovDQorICBTRVBfV1JJVEVfUkVHSVNU
RVIoJnNlcF9jb250ZXh0LCBIV19IT1NUX0hPU1RfU0VQX0dQUjBfUkVHX0FERFIsIDB4MTApOw0K
KwkvKiBwb2xsIGdwcjMgdGlsbCBpdCBpcyAwICovDQorCWRvIHsNCisJCXJlZ192YWwgPSBTRVBf
UkVBRF9SRUdJU1RFUigmc2VwX2NvbnRleHQsDQorCQkJSFdfSE9TVF9TRVBfSE9TVF9HUFIzX1JF
R19BRERSKTsNCisJfSB3aGlsZSAocmVnX3ZhbCAhPSAwKTsNCisNCisgICNpZm5kZWYgX19MSVRU
TEVfRU5ESUFODQorICAgIFNFUF9XUklURV9SRUdJU1RFUigmc2VwX2NvbnRleHQsIEhXX0hPU1Rf
SE9TVF9FTkRJQU5fUkVHX0FERFIsIDB4MS8qQkUqLyk7DQorICAjZW5kaWYNCisNCitlbmRfZnVu
Y3Rpb246DQorDQorICBkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9pbml0X2hhbmRsZXIg
ZW5kXG4iKTsNCisNCisgIHJldHVybiBlcnJvcjsNCisNCit9DQorDQorLyoNCisgIHRoaXMgZnVu
Y3Rpb24gaGFuZGxlcyB0aGUgcmVxdWVzdCBjYWNoZSBhbmQgcmVzaWRlbnQgcmVhbGxvY2F0aW9u
DQorKi8NCitzdGF0aWMgaW50IHNlcF9yZWFsbG9jX2NhY2hlX3Jlc2lkZW50X2hhbmRsZXIodm9p
ZCAqYXJnKQ0KK3sNCisgIC8qIGVycm9yICovDQorICBpbnQgICBlcnJvcjsNCisNCisgIC8qIHJl
ZyB2YWwgKi8NCisgIHUzMiAgIHJlZ192YWw7DQorDQorICAvKiBwaHlzaWNhbCBjYWNoZSBhZGRy
ICovDQorICBkbWFfYWRkcl90CQljYWNoZV9idXNfYWRkcmVzczsNCisNCisgIC8qIHBoeXNpY2Fs
IHJlc2lkZW50IGFkZHIgKi8NCisgIGRtYV9hZGRyX3QJCXJlc2lkZW50X2J1c19hZGRyZXNzOw0K
Kw0KKyAgLyogcGh5c2ljYWwgZC1jYWNoZSBhZGRyICovDQorICBkbWFfYWRkcl90ICAgZGNhY2hl
X2J1c19hZGRyZXNzOw0KKw0KKyAgLyogY29tbWFuZCBhcmd1bWVudHMgKi8NCisgIHN0cnVjdCBz
ZXBfZHJpdmVyX3JlYWxsb2NfY2FjaGVfcmVzaWRlbnRfdCBjb21tYW5kX2FyZ3M7DQorDQorICAv
Ki0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0K
Kw0KKyAgLyogY2hlY2sgaWYgU0VQIGFscmVhZHkgaW5pdGlhbGl6ZWQgKi8NCisgIHJlZ192YWwg
PSBTRVBfUkVBRF9SRUdJU1RFUigmc2VwX2NvbnRleHQsDQorCQkJCQlIV19IT1NUX1NFUF9IT1NU
X0dQUjNfUkVHX0FERFIpOw0KKw0KKyAgLyogY2hlY2sgb2xkIGJvb3QgZmluaXNoZWQgb3Igd2Fy
bSBib290IGZpbmlzaGVkIG9yIGNvbGQtd2FybSBib290IGZpbmlzaGVkICovDQorCWlmIChyZWdf
dmFsICE9IDB4Mikgew0KKwkJZXJyb3IgPSAgU0VQX0FMUkVBRFlfSU5JVElBTElaRURfRVJSOw0K
KwkJZ290byBlbmRfZnVuY3Rpb247DQorICB9DQorDQorICAvKiB0aGlzIEFQSSBtYXkgYmUgcnVu
IG9ubHkgYnkgcm9vdCAqLw0KKwlpZiAoIWNhcGFibGUoQ0FQX1NZU19BRE1JTikpIHsNCisJCWVy
cm9yID0gLUVBQ0NFUzsNCisJCWdvdG8gZW5kX2Z1bmN0aW9uOw0KKyAgfQ0KKw0KKyAgLyogY29w
eSB0aGUgZGF0YSAqLw0KKwlpZiAoY29weV9mcm9tX3VzZXIoJmNvbW1hbmRfYXJncywNCisJCQlh
cmcsDQorCQkJc2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVyX3JlYWxsb2NfY2FjaGVfcmVzaWRlbnRf
dCkpKSB7DQorDQorCQllcnJvciA9IC1FRkFVTFQ7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisg
IH0NCisNCisNCisgIC8qIGNvcHkgY2FjaGUgYW5kIHJlc2lkZW50IHRvIHRoZSB0aGVpciBpbnRl
bmRlZCBsb2NhdGlvbnMgKi8NCisgIGVycm9yID0gc2VwX2NvcHlfY2FjaGVfcmVzaWRlbnRfdG9f
YXJlYSgmc2VwX2NvbnRleHQsDQorICAgICAgJmNhY2hlX2J1c19hZGRyZXNzLA0KKyAgICAgICZy
ZXNpZGVudF9idXNfYWRkcmVzcywNCisgICAgICAmZGNhY2hlX2J1c19hZGRyZXNzKTsNCisNCisg
IGlmIChlcnJvcikNCisJZ290byBlbmRfZnVuY3Rpb247DQorDQorI2lmIFNFUF9EUklWRVJfTE9D
S19SQVJfTU9ERQ0KKw0KKyAgZXJyb3IgPSBzZXBfY29weV9leHRfY2FjaGVfdG9fYXJlYShjb21t
YW5kX2FyZ3MuZXh0Y2FjaGVfYWRkciwNCisJCQkJY29tbWFuZF9hcmdzLmV4dGNhY2hlX3NpemVf
aW5fYnl0ZXMsDQorCQkJCTApOw0KKw0KKwlpZiAoZXJyb3IpDQorCQlnb3RvIGVuZF9mdW5jdGlv
bjsNCisNCisNCisjZW5kaWYNCisNCisgIC8qIGxvY2sgdGhlIGFyZWEgKGlmIG5lZWRlZCkgKi8N
CisgIGVycm9yID0gc2VwX2xvY2tfY2FjaGVfcmVzaWRlbnRfYXJlYSgpOw0KKwlpZiAoZXJyb3Ip
DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisNCisgIGNvbW1hbmRfYXJncy5uZXdfYmFzZV9hZGRy
ID0gc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfYnVzX2FkZHI7DQorDQorICAvKiBmaW5kIHRoZSBu
ZXcgYmFzZSBhZGRyZXNzIGFjY29yZGluZyB0byB0aGUgbG93ZXN0IGFkZHJlc3MgYmV0d2Vlbg0K
KwljYWNoZSwgcmVzaWRlbnQgYW5kIHNoYXJlZCBhcmVhICovDQorCWlmIChyZXNpZGVudF9idXNf
YWRkcmVzcyA8IGNvbW1hbmRfYXJncy5uZXdfYmFzZV9hZGRyKQ0KKwkJY29tbWFuZF9hcmdzLm5l
d19iYXNlX2FkZHIgPSByZXNpZGVudF9idXNfYWRkcmVzczsNCisNCisJaWYgKGNhY2hlX2J1c19h
ZGRyZXNzIDwgY29tbWFuZF9hcmdzLm5ld19iYXNlX2FkZHIpDQorCQljb21tYW5kX2FyZ3MubmV3
X2Jhc2VfYWRkciA9IGNhY2hlX2J1c19hZGRyZXNzOw0KKw0KKwlpZiAoZGNhY2hlX2J1c19hZGRy
ZXNzIDwgY29tbWFuZF9hcmdzLm5ld19iYXNlX2FkZHIpDQorCQljb21tYW5kX2FyZ3MubmV3X2Jh
c2VfYWRkciA9IGRjYWNoZV9idXNfYWRkcmVzczsNCisNCisgIC8qIHNldCB0aGUgcmV0dXJuIHBh
cmFtZXRlcnMgKi8NCisgIGNvbW1hbmRfYXJncy5uZXdfY2FjaGVfYWRkciA9IGNhY2hlX2J1c19h
ZGRyZXNzOw0KKyAgY29tbWFuZF9hcmdzLm5ld19yZXNpZGVudF9hZGRyID0gcmVzaWRlbnRfYnVz
X2FkZHJlc3M7DQorICBjb21tYW5kX2FyZ3MubmV3X2RjYWNoZV9hZGRyID0gZGNhY2hlX2J1c19h
ZGRyZXNzOw0KKw0KKw0KKyAgLyogc2V0IHRoZSBuZXcgc2hhcmVkIGFyZWEgKi8NCisgIGNvbW1h
bmRfYXJncy5uZXdfc2hhcmVkX2FyZWFfYWRkciA9IHNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX2J1
c19hZGRyOw0KKw0KKyAgZWRiZygiU0VQIERyaXZlcjpjb21tYW5kX2FyZ3MubmV3X3NoYXJlZF9h
cmVhX2FkZHIgaXMgJTA4eFxuIiwNCisJKHUzMiljb21tYW5kX2FyZ3MubmV3X3NoYXJlZF9hcmVh
X2FkZHIpOw0KKyAgZWRiZygiU0VQIERyaXZlcjpjb21tYW5kX2FyZ3MubmV3X2Jhc2VfYWRkciBp
cyAlMDh4XG4iLA0KKwkodTMyKWNvbW1hbmRfYXJncy5uZXdfYmFzZV9hZGRyKTsNCisgIGVkYmco
IlNFUCBEcml2ZXI6Y29tbWFuZF9hcmdzLm5ld19yZXNpZGVudF9hZGRyIGlzICUwOHhcbiIsDQor
CSh1MzIpY29tbWFuZF9hcmdzLm5ld19yZXNpZGVudF9hZGRyKTsNCisgIGVkYmcoIlNFUCBEcml2
ZXI6Y29tbWFuZF9hcmdzLm5ld19jYWNoZV9hZGRyIGlzICUwOHhcbiIsDQorCSh1MzIpY29tbWFu
ZF9hcmdzLm5ld19jYWNoZV9hZGRyKTsNCisNCisgIC8qIHJldHVybiB0byB1c2VyICovDQorCWlm
IChjb3B5X3RvX3VzZXIoYXJnLA0KKwkJCSh2b2lkICopJmNvbW1hbmRfYXJncywNCisJCQlzaXpl
b2Yoc3RydWN0IHNlcF9kcml2ZXJfcmVhbGxvY19jYWNoZV9yZXNpZGVudF90KSkpDQorCQllcnJv
ciA9IC1FRkFVTFQ7DQorDQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgcmV0dXJuIGVycm9yOw0K
K30NCisNCisvKg0KKyAgVGhpcyBmdW5jdGlvbiB3aWxsIHJldHJpZXZlIHRoZSBSQVIgYnVmZmVy
IHBoeXNpY2FsIGFkZHJlc3NlcywgdHlwZQ0KKyAgYW5kIHNpemUgY29ycmVzcG9uZGluZyB0byB0
aGUgUkFSIGhhbmRsZXMgcHJvdmlkZWQgaW4gdGhlIGJ1ZmZlcnMgdmVjdG9yLg0KKyovDQorc3Rh
dGljIGludCBzZXBfcmFyX3ByZXBhcmVfb3V0cHV0X21zZ19oYW5kbGVyKHZvaWQgKmFyZykNCit7
DQorICAvKiBlcnJvciByZXR1cm4gY29kZSAqLw0KKyAgaW50ICAgZXJyb3I7DQorDQorICAvKiBj
b21tYW5kIGFyZ3MgKi8NCisgIHN0cnVjdCBzZXBfZHJpdmVyX3Jhcl9oYW5kbGVfdG9fYnVzIGNv
bW1hbmRfYXJnczsNCisNCisgIC8qIGJ1cyBhZGRyZXNzICovDQorICBkbWFfYWRkcl90ICByYXJf
YnVzOw0KKw0KKyAgLyogaG9sZHMgdGhlIFJBUiBhZGRyZXNzIGluIHRoZSBzeXN0ZW0gbWVtb3J5
IG9mZnNldCAqLw0KKyAgdTMyICAgKnJhcl9hZGRyOw0KKw0KKyAgLyotLS0tLS0tLS0tLS0tLS0t
LS0NCisJQ09ERQ0KKyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCisNCisgIGRiZygiU0VQIERy
aXZlcjotLS0tLS0tLT4gc2VwX3Jhcl9wcmVwYXJlX291dHB1dF9tc2dfaGFuZGxlciBzdGFydFxu
Iik7DQorDQorICBlcnJvciA9IDA7DQorICByYXJfYnVzID0gMDsNCisNCisgIC8qIGNvcHkgdGhl
IGRhdGEgKi8NCisJaWYgKGNvcHlfZnJvbV91c2VyKCZjb21tYW5kX2FyZ3MsDQorCQkJYXJnLA0K
KwkJCXNpemVvZihzdHJ1Y3Qgc2VwX2RyaXZlcl9yYXJfaGFuZGxlX3RvX2J1cykpKSB7DQorCQll
cnJvciA9IC1FRkFVTFQ7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisgIC8qIGNh
bGwgdG8gdHJhbnNsYXRpb24gZnVuY3Rpb24gb25seSBpZiB1c2VyIGhhbmRsZSBpcyBub3QgTlVM
TCAqLw0KKyAgaWYgKGNvbW1hbmRfYXJncy5yYXJfaGFuZGxlKSB7DQorCWVycm9yID0gc2VwX3Jh
cl9oYW5kbGVfdG9fYnVzKGNvbW1hbmRfYXJncy5yYXJfaGFuZGxlLCAmcmFyX2J1cyk7DQorCWlm
IChlcnJvcikNCisJCWdvdG8gZW5kX2Z1bmN0aW9uOw0KKyAgfQ0KKw0KKyAgZWRiZygiU0VQIERy
aXZlcjogcmFyX2FkZHJfYnVzID0gJXhcbiIsICh1MzIpcmFyX2J1cyk7DQorDQorICAvKiBzZXQg
dmFsdWUgaW4gdGhlIFNZU1RFTSBNRU1PUlkgb2Zmc2V0ICovDQorICByYXJfYWRkciA9ICh1MzIg
Kikoc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfdmlydF9hZGRyICsNCisJCQkgU0VQX0RSSVZFUl9T
WVNURU1fUkFSX01FTU9SWV9PRkZTRVRfSU5fQllURVMpOw0KKw0KKyAgLyogY29weSB0aGUgcGh5
c2ljYWwgYWRkcmVzcyB0byB0aGUgU3lzdGVtIEFyZWEuDQorICAgICBUaGUgU0VQIHdpbGwgZm9s
bG93IHRoaXMgYWRkcmVzcyAqLw0KKyAgcmFyX2FkZHJbMF0gPSBTRVBfUkFSX1ZBTF9UT0tFTjsN
CisgIHJhcl9hZGRyWzFdID0gcmFyX2J1czsNCisNCitlbmRfZnVuY3Rpb246DQorDQorICBkYmco
IlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9yYXJfcHJlcGFyZV9vdXRwdXRfbXNnX2hhbmRsZXIg
ZW5kXG4iKTsNCisNCisgIHJldHVybiBlcnJvcjsNCit9DQorDQorLyoNCisgIHRoaXMgZnVuY3Rp
b24gcmV0dXJucyB0aGUgcGh5c2ljYWwgYW5kIHZpcnR1YWwgYWRkcmVzc2VzIG9mIHRoZSBzdGF0
aWMgcG9vbA0KKyovDQorc3RhdGljIGludCBzZXBfZ2V0X3N0YXRpY19wb29sX2FkZHJfaGFuZGxl
cih2b2lkICphcmcpDQorew0KKyAgLyogZXJyb3IgKi8NCisgIGludCAgIGVycm9yOw0KKw0KKyAg
LyogY29tbWFuZCBhcmd1bWVudHMgKi8NCisgIHN0cnVjdCBzZXBfZHJpdmVyX3N0YXRpY19wb29s
X2FkZHJfdAljb21tYW5kX2FyZ3M7DQorDQorICAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tDQorCUNPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQorICBk
YmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9nZXRfc3RhdGljX3Bvb2xfYWRkcl9oYW5kbGVy
IHN0YXJ0XG4iKTsNCisNCisgIGVycm9yID0gMDsNCisNCisgIC8qcHJlcGFyZSB0aGUgb3V0cHV0
IHBhcmFtZXRlcnMgaW4gdGhlIHN0cnVjdCAqLw0KKyAgY29tbWFuZF9hcmdzLnN0YXRpY19idXNf
YWRkcmVzcyA9IHNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX2J1c19hZGRyICsNCisJCQkJU0VQX0RS
SVZFUl9TVEFUSUNfQVJFQV9PRkZTRVRfSU5fQllURVM7DQorICBjb21tYW5kX2FyZ3Muc3RhdGlj
X3ZpcnRfYWRkcmVzcyA9IHNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX3ZpcnRfYWRkciArDQorCQkJ
CVNFUF9EUklWRVJfU1RBVElDX0FSRUFfT0ZGU0VUX0lOX0JZVEVTOw0KKw0KKyAgZWRiZygNCisg
ICJTRVAgRHJpdmVyOnBoeXNpY2FsX3N0YXRpY19hZGRyZXNzIGlzICUwOHgsIHZpcnR1YWxfc3Rh
dGljX2FkZHJlc3MgJXBcbiIsDQorCSh1MzIpY29tbWFuZF9hcmdzLnN0YXRpY19idXNfYWRkcmVz
cywNCisJY29tbWFuZF9hcmdzLnN0YXRpY192aXJ0X2FkZHJlc3MpOw0KKw0KKyAgLyogc2VuZCB0
aGUgcGFyYW1ldGVycyB0byB1c2VyIGFwcGxpY2F0aW9uICovDQorCWlmIChjb3B5X3RvX3VzZXIo
YXJnLA0KKwkJCSZjb21tYW5kX2FyZ3MsDQorCQkJc2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVyX3N0
YXRpY19wb29sX2FkZHJfdCkpKQ0KKwkJZXJyb3IgPSAtRUZBVUxUOw0KKw0KKw0KKyAgZGJnKCJT
RVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBfZ2V0X3N0YXRpY19wb29sX2FkZHJfaGFuZGxlciBlbmRc
biIpOw0KKw0KKyAgcmV0dXJuIGVycm9yOw0KK30NCisNCisvKg0KKyAgdGhpcyBhZGRyZXNzIGdl
dHMgdGhlIG9mZnNldCBvZiB0aGUgYnVzIGFkZHJlc3MgZnJvbSB0aGUgc3RhcnQNCisgIG9mIHRo
ZSBtYXBwZWQgYXJlYQ0KKyovDQorc3RhdGljIGludCBzZXBfZ2V0X3BoeXNpY2FsX21hcHBlZF9v
ZmZzZXRfaGFuZGxlcih2b2lkICphcmcpDQorew0KKyAgLyogZXJyb3IgKi8NCisgIGludCAgIGVy
cm9yOw0KKw0KKyAgLyogY29tbWFuZCBhcmd1bWVudHMgKi8NCisgIHN0cnVjdCBzZXBfZHJpdmVy
X2dldF9tYXBwZWRfb2Zmc2V0X3QJY29tbWFuZF9hcmdzOw0KKw0KKyAgLyotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0qLw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOi0tLS0tLS0tPiBzZXBfZ2V0X3BoeXNpY2FsX21h
cHBlZF9vZmZzZXRfaGFuZGxlciBzdGFydFxuIik7DQorDQorICBlcnJvciA9IDA7DQorDQorCWlm
IChjb3B5X2Zyb21fdXNlcigmY29tbWFuZF9hcmdzLA0KKwkJCWFyZywNCisJCQlzaXplb2Yoc3Ry
dWN0IHNlcF9kcml2ZXJfZ2V0X21hcHBlZF9vZmZzZXRfdCkpKSB7DQorDQorCQllcnJvciA9IC1F
RkFVTFQ7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisJaWYgKCFjb21tYW5kX2Fy
Z3MuYnVzX2FkZHJlc3MpIHsNCisJCWVkYmcoIlNFUCBEcml2ZXI6IHBhcmFtcyB2YWxpZGF0aW9u
IGVycm9yXG4iKTsNCisNCisJCWVycm9yID0gLUVJTlZBTDsNCisJCWdvdG8gZW5kX2Z1bmN0aW9u
Ow0KKyAgfQ0KKw0KKwlpZiAoY29tbWFuZF9hcmdzLmJ1c19hZGRyZXNzIDwgc2VwX2NvbnRleHQu
c2hhcmVkX2FyZWFfYnVzX2FkZHIpIHsNCisJCWVycm9yID0gLUVJTlZBTDsNCisJCWdvdG8gZW5k
X2Z1bmN0aW9uOw0KKyAgfQ0KKw0KKyAgLypwcmVwYXJlIHRoZSBvdXRwdXQgcGFyYW1ldGVycyBp
biB0aGUgc3RydWN0ICovDQorICBjb21tYW5kX2FyZ3Mub2Zmc2V0ID0gY29tbWFuZF9hcmdzLmJ1
c19hZGRyZXNzIC0NCisJCQkJCXNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX2J1c19hZGRyOw0KKw0K
KyAgZWRiZygiU0VQIERyaXZlcjpwaHlzaWNhbF9hZGRyZXNzIGlzICUwOHgsIG9mZnNldCBpcyAl
eFxuIiwNCisgICAgKHUzMiljb21tYW5kX2FyZ3MuYnVzX2FkZHJlc3MsDQorICAgIGNvbW1hbmRf
YXJncy5vZmZzZXQpOw0KKw0KKyAgLyogc2VuZCB0aGUgcGFyYW1ldGVycyB0byB1c2VyIGFwcGxp
Y2F0aW9uICovDQorCWlmIChjb3B5X3RvX3VzZXIoYXJnLA0KKwkJCSZjb21tYW5kX2FyZ3MsDQor
CQkJc2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVyX2dldF9tYXBwZWRfb2Zmc2V0X3QpKSkNCisJCWVy
cm9yID0gLUVGQVVMVDsNCisNCisNCisNCitlbmRfZnVuY3Rpb246DQorDQorICBkYmcoIlNFUCBE
cml2ZXI6PC0tLS0tLS0tIHNlcF9nZXRfcGh5c2ljYWxfbWFwcGVkX29mZnNldF9oYW5kbGVyIGVu
ZFxuIik7DQorDQorICByZXR1cm4gZXJyb3I7DQorfQ0KKw0KKy8qDQorICB0aGlzIGZ1bmN0aW9u
IGhhbmRsZXMgdGhlIHJlcXVlc3QgZm9yIGdldCB0aW1lDQorKi8NCitzdGF0aWMgaW50IHNlcF9n
ZXRfdGltZV9oYW5kbGVyKHZvaWQgKmFyZykNCit7DQorICAvKiBlcnJvciAqLw0KKyAgaW50ICAg
ZXJyb3I7DQorDQorICAvKiBjb21tYW5kIGFyZ3VtZW50cyAqLw0KKyAgc3RydWN0IHNlcF9kcml2
ZXJfZ2V0X3RpbWVfdAljb21tYW5kX2FyZ3M7DQorDQorICAvKi0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQorICBlcnJv
ciA9IHNlcF9zZXRfdGltZSgmY29tbWFuZF9hcmdzLnRpbWVfYnVzX2FkZHJlc3MsDQorCQkJJmNv
bW1hbmRfYXJncy50aW1lX3ZhbHVlKTsNCisJaWYgKGVycm9yKQ0KKwkJZ290byBlbmRfZnVuY3Rp
b247DQorDQorICAvKiByZXR1cm4gdG8gdXNlciAqLw0KKwlpZiAoY29weV90b191c2VyKGFyZywN
CisJCQkodm9pZCAqKSZjb21tYW5kX2FyZ3MsDQorCQkJc2l6ZW9mKHN0cnVjdCBzZXBfZHJpdmVy
X2dldF90aW1lX3QpKSkNCisJCWVycm9yID0gLUVGQVVMVDsNCisNCisNCitlbmRfZnVuY3Rpb246
DQorDQorICByZXR1cm4gZXJyb3I7DQorfQ0KKw0KKyNpZmRlZiBEWF9DQzUyX1NVUFBPUlQNCisv
Kg0KKyAgdGhpcyBmdW5jdGlvbiBoYW5kbGVzIHRoZSByZXF1ZXN0IGZvciBleHQoM3JkIHBhcnR5
KWNhY2hlIHJlYWxsb2NhdGlvbg0KKyovDQorc3RhdGljIGludCBzZXBfcmVhbGxvY19leHRfY2Fj
aGVfaGFuZGxlcih2b2lkICphcmcpDQorew0KKyAgLyogZXJyb3IgKi8NCisgIGludCAgIGVycm9y
Ow0KKw0KKyAgLyogcGh5c2ljYWwgZXh0IGNhY2hlIGFkZHIgKi8NCisgIGRtYV9hZGRyX3QgICBl
eHRfY2FjaGVfYnVzX2FkZHJlc3M7DQorDQorICAvKiBjb21tYW5kIGFyZ3VtZW50cyAqLw0KKyAg
c3RydWN0IHNlcF9kcml2ZXJfcmVhbGxvY19leHRfY2FjaGVfdCAgIGNvbW1hbmRfYXJnczsNCisN
CisgIC8qLS0tLS0tLS0tLS0tLS0tLS0tDQorICAgICAgQ09ERQ0KKyAgLS0tLS0tLS0tLS0tLS0t
LS0tLS0tKi8NCisNCisgIC8qIGNvcHkgdGhlIGRhdGEgKi8NCisJaWYgKGNvcHlfZnJvbV91c2Vy
KCZjb21tYW5kX2FyZ3MsDQorCQkJYXJnICwNCisJCQlzaXplb2Yoc3RydWN0IHNlcF9kcml2ZXJf
cmVhbGxvY19leHRfY2FjaGVfdCkpKSB7DQorDQorCQllcnJvciA9IC1FRkFVTFQ7DQorCQlnb3Rv
IGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisjaWYgU0VQX0RSSVZFUl9MT0NLX1JBUl9NT0RFDQor
DQorICAvKiBpZiB3ZSBhcmUgaW4gUkFSIG1vZGUgLSB0aGVuIHRoZSBleHQgY2FjaGUgd2FzIGFs
cmVhZHkgY29waWVkDQorICBhbmQgd2UganVzdCBuZWVkIHRvIHJlY2VpdmUgYmFjayBpdHMnIHBo
eXNpY2FsIGFkZHJlc3MgKi8NCisgIGNvbW1hbmRfYXJncy5leHRfY2FjaGVfc2l6ZV9pbl9ieXRl
cyA9IDA7DQorDQorI2VuZGlmDQorICAvKiBjb3B5IGNhY2hlIGFuZCByZXNpZGVudCB0byB0aGUg
dGhlaXIgaW50ZW5kZWQgbG9jYXRpb25zICovDQorICBlcnJvciA9IHNlcF9jb3B5X2V4dF9jYWNo
ZV90b19hcmVhKGNvbW1hbmRfYXJncy5leHRfY2FjaGVfYWRkciwNCisJCQkJCWNvbW1hbmRfYXJn
cy5leHRfY2FjaGVfc2l6ZV9pbl9ieXRlcywNCisJCQkJCSZleHRfY2FjaGVfYnVzX2FkZHJlc3Mp
Ow0KKyAgaWYgKGVycm9yKQ0KKwlnb3RvIGVuZF9mdW5jdGlvbjsNCisNCisNCisNCisgIGNvbW1h
bmRfYXJncy5uZXdfZXh0X2NhY2hlX2FkZHIgPSBleHRfY2FjaGVfYnVzX2FkZHJlc3M7DQorDQor
ICBlZGJnKCJTRVAgRHJpdmVyOmNvbW1hbmRfYXJncy5uZXdfZXh0X2NhY2hlX2FkZHIgaXMgJXhc
biIsDQorCQljb21tYW5kX2FyZ3MubmV3X2V4dF9jYWNoZV9hZGRyKTsNCisNCisgIC8qIHJldHVy
biB0byB1c2VyICovDQorCWlmIChjb3B5X3RvX3VzZXIoYXJnICwNCisJCQkodm9pZCAqKSZjb21t
YW5kX2FyZ3MgLA0KKwkJCXNpemVvZihzdHJ1Y3Qgc2VwX2RyaXZlcl9yZWFsbG9jX2V4dF9jYWNo
ZV90KSkpDQorCQllcnJvciA9IC1FRkFVTFQ7DQorDQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAg
cmV0dXJuIGVycm9yOw0KK30NCisjZW5kaWYgLyojaWZkZWYgRFhfQ0M1Ml9TVVBQT1JUKi8NCisN
CitzdGF0aWMgbG9uZyBzZXBfaW9jdGwoDQorCQkJCQlzdHJ1Y3QgZmlsZQkJCSpmaWxwLA0KKwkJ
CQkJdTMyCQljbWQsDQorCQkJCQl1bnNpZ25lZCBsb25nCQlhcmcpDQorew0KKw0KKyAgLyogZXJy
b3IgKi8NCisgIGxvbmcJCQllcnJvcjsNCisNCisgIC8qLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQorCUNPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorICBlcnJvciA9IDA7DQor
DQorICBkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IGlvY3RsIHN0YXJ0XG4iKTsNCisNCisNCisg
IGVkYmcoIlNFUCBEcml2ZXI6IGNtZCBpcyAleFxuIiwgY21kKTsNCisNCisgIC8qIGNoZWNrIHRo
ZSBsb2NrIGZsYWcgLSBkb2VzIG5vdCBhbGxvdyBhbnkgb3RoZXIgcHJvY2Vzcw0KKyAgdG8gY2Fs
bCBpb2N0bCBvbiB0aGUgZHJpdmVyICovDQorCWlmICgodTMyKWZpbHAtPnByaXZhdGVfZGF0YSAh
PSBTRVBfRFJJVkVSX09XTl9MT0NLX0ZMQUcpIHsNCisJCWVycm9yID0gLUVBQ0NFUzsNCisJCWdv
dG8gZW5kX2Z1bmN0aW9uOw0KKyAgfQ0KKw0KKyAgLyogbG9jayBhY2Nlc3MgdG8gaW9jdGwgKi8N
CisgIG11dGV4X2xvY2soJnNlcF9jb250ZXh0LmlvY3RsX211dGV4KTsNCisNCisgIC8qIGNoZWNr
IHRoYXQgdGhlIGNvbW1hbmQgaXMgZm9yIHNlcCBkZXZpY2UgKi8NCisJaWYgKF9JT0NfVFlQRShj
bWQpICE9IFNFUF9JT0NfTUFHSUNfTlVNQkVSKSB7DQorCQllcnJvciA9IC1FRkFVTFQ7DQorCQln
b3RvIGVuZF9mdW5jdGlvbl91bmxvY2s7DQorICB9DQorDQorCXN3aXRjaCAoY21kKSB7DQorCWNh
c2UgU0VQX0lPQ1NFTkRTRVBDT01NQU5EOg0KKw0KKwkgIC8qIHNlbmQgY29tbWFuZCB0byBTRVAg
Ki8NCisJZXJyb3IgPSBzZXBfc2VuZF9jb21tYW5kX2hhbmRsZXIoKTsNCisNCisJZWRiZygiU0VQ
IERyaXZlcjogYWZ0ZXIgc2VwX3NlbmRfY29tbWFuZF9oYW5kbGVyXG4iKTsNCisNCisJICBicmVh
azsNCisNCisJY2FzZSBTRVBfSU9DU0VORFNFUFJQTFlDT01NQU5EOg0KKw0KKwkgIC8qIHNlbmQg
cmVwbHkgY29tbWFuZCB0byBTRVAgKi8NCisJZXJyb3IgPSBzZXBfc2VuZF9yZXBseV9jb21tYW5k
X2hhbmRsZXIoKTsNCisNCisJICBicmVhazsNCisNCisJY2FzZSBTRVBfSU9DQUxMT0NEQVRBUE9M
TDoNCisNCisJICAvKiBhbGxvY2F0ZSBkYXRhIHBvb2wgKi8NCisJZXJyb3IgPSBzZXBfYWxsb2Nh
dGVfZGF0YV9wb29sX21lbW9yeV9oYW5kbGVyKCh2b2lkICopYXJnKTsNCisNCisJICBicmVhazsN
CisNCisJY2FzZSBTRVBfSU9DQ1JFQVRFU1lNRE1BVEFCTEU6DQorDQorCSAgLyogY3JlYXRlIGRt
YSB0YWJsZSBmb3Igc3luaHJvbmljIG9wZXJhdGlvbiAqLw0KKwllcnJvciA9IHNlcF9jcmVhdGVf
c3luY19kbWFfdGFibGVzX2hhbmRsZXIoKHZvaWQgKilhcmcpOw0KKw0KKwkgIGJyZWFrOw0KKw0K
KwljYXNlIFNFUF9JT0NGUkVFRE1BVEFCTEVEQVRBOg0KKw0KKwkgIC8qIGZyZWUgdGhlIHBhZ2Vz
ICovDQorCWVycm9yID0gc2VwX2ZyZWVfZG1hX3RhYmxlX2RhdGFfaGFuZGxlcigpOw0KKw0KKwkg
IGJyZWFrOw0KKw0KKwljYXNlIFNFUF9JT0NTRVBTVEFSVDoNCisNCisJICAvKiBzdGFydCBjb21t
YW5kIHRvIHNlcCAqLw0KKwllcnJvciA9IHNlcF9zdGFydF9oYW5kbGVyKCk7DQorCSAgYnJlYWs7
DQorDQorCWNhc2UgU0VQX0lPQ1NFUElOSVQ6DQorDQorCSAgLyogaW5pdCBjb21tYW5kIHRvIHNl
cCAqLw0KKwllcnJvciA9IHNlcF9pbml0X2hhbmRsZXIoKHZvaWQgKilhcmcpOw0KKw0KKwkgIGJy
ZWFrOw0KKw0KKwljYXNlIFNFUF9JT0NHRVRTVEFUSUNQT09MQUREUjoNCisNCisJCS8qIGdldCB0
aGUgcGh5c2ljYWwgYW5kIHZpcnR1YWwgYWRkcmVzc2VzIG9mIHRoZSBzdGF0aWMgcG9vbCAqLw0K
KwkJZXJyb3IgPSBzZXBfZ2V0X3N0YXRpY19wb29sX2FkZHJfaGFuZGxlcigodm9pZCAqKWFyZyk7
DQorDQorCQlicmVhazsNCisNCisJY2FzZSBTRVBfSU9DRU5EVFJBTlNBQ1RJT046DQorDQorCWVy
cm9yID0gc2VwX2VuZF90cmFuc2FjdGlvbl9oYW5kbGVyKGZpbHApOw0KKw0KKwkJYnJlYWs7DQor
DQorCWNhc2UgU0VQX0lPQ1JFQUxMT0NDQUNIRVJFUzoNCisNCisJZXJyb3IgPSBzZXBfcmVhbGxv
Y19jYWNoZV9yZXNpZGVudF9oYW5kbGVyKCh2b2lkICopYXJnKTsNCisNCisJICBicmVhazsNCisN
CisJY2FzZSBTRVBfSU9DR0VUTUFQUEVEQUREUk9GRlNFVDoNCisNCisJZXJyb3IgPSBzZXBfZ2V0
X3BoeXNpY2FsX21hcHBlZF9vZmZzZXRfaGFuZGxlcigodm9pZCAqKWFyZyk7DQorDQorCSAgYnJl
YWs7DQorDQorI2lmZGVmIERYX0NDNTJfU1VQUE9SVA0KKwljYXNlIFNFUF9JT0NSRUFMTE9DRVhU
Q0FDSEU6DQorDQorICAgICAgZXJyb3IgPSBzZXBfcmVhbGxvY19leHRfY2FjaGVfaGFuZGxlcigo
dm9pZCAqKWFyZyk7DQorDQorICAgICAgYnJlYWs7DQorI2VuZGlmDQorDQorCWNhc2UgU0VQX0lP
Q0dFVElNRToNCisNCisJZXJyb3IgPSBzZXBfZ2V0X3RpbWVfaGFuZGxlcigodm9pZCAqKWFyZyk7
DQorDQorCSAgYnJlYWs7DQorDQorCWNhc2UgU0VQX0lPQ1JBUlBSRVBBUkVNRVNTQUdFOg0KKw0K
KwllcnJvciA9IHNlcF9yYXJfcHJlcGFyZV9vdXRwdXRfbXNnX2hhbmRsZXIoKHZvaWQgKilhcmcp
Ow0KKw0KKwkgIGJyZWFrOw0KKw0KKwlkZWZhdWx0Og0KKwkJZWRiZygiU0VQIERyaXZlcjogKioq
KiBOTyBDT01NQU5EICoqKipcbiIpOw0KKw0KKyAgICBlcnJvciA9IC1FTk9UVFk7DQorCSAgYnJl
YWs7DQorICB9DQorDQorZW5kX2Z1bmN0aW9uX3VubG9jazoNCisNCisJbXV0ZXhfdW5sb2NrKCZz
ZXBfY29udGV4dC5pb2N0bF9tdXRleCk7DQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgZGJnKCJT
RVAgRHJpdmVyOjwtLS0tLS0tLSBpb2N0bCBlbmRcbiIpOw0KKw0KKyAgcmV0dXJuIGVycm9yOw0K
K30NCisNCisjaWZkZWYgRFhfQ0M1Ml9TVVBQT1JUDQorDQorDQorLyoNCisgIHNpbmdsZXRvbiBp
b2N0bA0KKyovDQorc3RhdGljIGxvbmcgc2VwX3NpbmdsZXRvbl9pb2N0bCgvKnN0cnVjdCBpbm9k
ZSAqaW5vZGUsKi8NCisJCQkJCQkJc3RydWN0IGZpbGUgICpmaWxwLA0KKwkJCQkJCQl1MzIgICAg
Y21kLA0KKwkJCQkJCQl1bnNpZ25lZCBsb25nICAgYXJnKQ0KK3sNCisNCisgIC8qIGVycm9yICov
DQorICBsb25nICAgICAgICAgICAgIGVycm9yOw0KKw0KKyAgLyotLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCisgICAgQ09ERQ0KKyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCisgIGVycm9y
ID0gMDsNCisNCisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX3NpbmdsZXRvbl9pb2N0
bCBzdGFydFxuIik7DQorDQorICBlZGJnKCJTRVAgRHJpdmVyOiBjbWQgaXMgJXhcbiIsIGNtZCk7
DQorDQorICAvKiBjaGVjayB0aGF0IHRoZSBjb21tYW5kIGlzIGZvciBzZXAgZGV2aWNlICovDQor
CWlmIChfSU9DX1RZUEUoY21kKSAhPSBTRVBfSU9DX01BR0lDX05VTUJFUikgew0KKwkJZXJyb3Ig
PSAgLUVOT1RUWTsNCisJCWdvdG8gZW5kX2Z1bmN0aW9uOw0KKyAgfQ0KKw0KKyAgc3dpdGNoIChj
bWQpIHsNCisgIGNhc2UgU0VQX0lPQ1RMU0VUQ0FMTEVSSUQ6DQorICAgIGVycm9yID0gc2VwX3Nl
dF9jYWxsZXJfaWRfaGFuZGxlcihhcmcpOw0KKyAgICBicmVhazsNCisNCisgIGRlZmF1bHQ6DQor
ICAgIGVycm9yID0gc2VwX2lvY3RsKGZpbHAsIGNtZCwgYXJnKTsNCisgICAgYnJlYWs7DQorICB9
DQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBf
c2luZ2xldG9uX2lvY3RsIGVuZFxuIik7DQorDQorICByZXR1cm4gZXJyb3I7DQorfQ0KKw0KKy8q
IGZpbGUgb3BlcmF0aW9uIGZvciBzaW5nbGV0b24gc2VwIG9wZXJhdGlvbnMgKi8NCitzdGF0aWMg
Y29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBzaW5nbGV0b25fZmlsZV9vcGVyYXRpb25zID0g
ew0KKwkub3duZXIgPSBUSElTX01PRFVMRSwNCisJLnVubG9ja2VkX2lvY3RsID0gc2VwX3Npbmds
ZXRvbl9pb2N0bCwNCisJLnBvbGwgPSBzZXBfcG9sbCwNCisJLm9wZW4gPSBzZXBfc2luZ2xldG9u
X29wZW4sDQorCS5yZWxlYXNlID0gc2VwX3JlbGVhc2UsDQorCS5tbWFwID0gc2VwX21tYXAsDQor
fTsNCisNCisjZW5kaWYgLypEWF9DQzUyX1NVUFBPUlQqLw0KKw0KKw0KKy8qIGZpbGUgb3BlcmF0
aW9uIGZvciBub3JtYWwgc2VwIG9wZXJhdGlvbnMgKi8NCitzdGF0aWMgY29uc3Qgc3RydWN0IGZp
bGVfb3BlcmF0aW9ucyBzZXBfZmlsZV9vcGVyYXJpb25zID0gew0KKyAgLm93bmVyID0gVEhJU19N
T0RVTEUsDQorICAudW5sb2NrZWRfaW9jdGwgPSBzZXBfaW9jdGwsDQorICAucG9sbCA9IHNlcF9w
b2xsLA0KKyAgLm9wZW4gPSBzZXBfb3BlbiwNCisgIC5yZWxlYXNlID0gc2VwX3JlbGVhc2UsDQor
ICAubW1hcCA9IHNlcF9tbWFwLA0KKw0KK307DQorDQorLyoNCisgIHRoaXMgZnVuY3Rpb24gcmVn
aXN0ZXJzIHRoZSBkcml2ZXIgdG8gdGhlIGZpbGUgc3lzdGVtDQorKi8NCitzdGF0aWMgaW50ICBz
ZXBfcmVnaXN0ZXJfZHJpdmVyX3RvX2ZzKHZvaWQpDQorew0KKyAgLyogcmV0dXJuIHZhbHVlICov
DQorICBpbnQJCQlyZXRfdmFsOw0KKw0KKyAgLyogbWFqb3IgbnVtYmVyICovDQorICBpbnQgICAg
ICAgICAgbWFqb3I7DQorDQorICAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQorI2lmZGVmIERYX0NDNTJfU1VQUE9SVA0KKyAg
cmV0X3ZhbCA9IGFsbG9jX2NocmRldl9yZWdpb24oJnNlcF9jb250ZXh0LmRldmljZV9udW1iZXIs
DQorCQkJCQkJCTAsDQorCQkJCQkJCTIsDQorCQkJCQkJCURSSVZFUl9OQU1FKTsNCisjZWxzZQ0K
KyAgcmV0X3ZhbCA9IGFsbG9jX2NocmRldl9yZWdpb24oJnNlcF9jb250ZXh0LmRldmljZV9udW1i
ZXIsDQorCQkJCQkJCTAsDQorCQkJCQkJCTEsDQorCQkJCQkJCURSSVZFUl9OQU1FKTsNCisjZW5k
aWYNCisJaWYgKHJldF92YWwpIHsNCisJCWVkYmcoInNlcF9kcml2ZXI6bWFqb3IgbnVtYmVyIGFs
bG9jYXRpb24gZmFpbGVkLFwNCisJCQlyZXR2YWwgaXMgJWRcbiIsDQorCQkJcmV0X3ZhbCk7DQor
CSAgZ290byBlbmRfZnVuY3Rpb247DQorICB9DQorDQorICAvKiBnZXQgdGhlIG1ham9yIG51bWJl
ciAqLw0KKyAgbWFqb3IgPSBNQUpPUihzZXBfY29udGV4dC5kZXZpY2VfbnVtYmVyKTsNCisNCisg
IC8qIGluaXQgY2RldiAqLw0KKyAgY2Rldl9pbml0KCZzZXBfY29udGV4dC5jZGV2LCAmc2VwX2Zp
bGVfb3BlcmFyaW9ucyk7DQorICBzZXBfY29udGV4dC5jZGV2Lm93bmVyID0gVEhJU19NT0RVTEU7
DQorDQorICAvKiByZWdpc3RlciB0aGUgZHJpdmVyIHdpdGggdGhlIGtlcm5lbCAqLw0KKyAgcmV0
X3ZhbCA9IGNkZXZfYWRkKCZzZXBfY29udGV4dC5jZGV2LCBzZXBfY29udGV4dC5kZXZpY2VfbnVt
YmVyLCAxKTsNCisNCisJaWYgKHJldF92YWwpIHsNCisJCWVkYmcoInNlcF9kcml2ZXI6Y2Rldl9h
ZGQgZmFpbGVkLCByZXR2YWwgaXMgJWRcbiIsDQorICAgICAgcmV0X3ZhbCk7DQorCSAgZ290byBl
bmRfZnVuY3Rpb25fdW5yZWdpc3Rlcl9kZXZudW07DQorICB9DQorDQorZ290byBlbmRfZnVuY3Rp
b247DQorI2lmZGVmIERYX0NDNTJfU1VQUE9SVA0KKw0KKyAgc2VwX2NvbnRleHQuc2luZ2xldG9u
X2RldmljZV9udW1iZXIgPSBNS0RFVihtYWpvciwgMSk7DQorDQorICAvKiBpbml0IHNpbmdsZXRv
biBjZGV2ICovDQorICBjZGV2X2luaXQoJnNlcF9jb250ZXh0LnNpbmdsZXRvbl9jZGV2ICwgJnNp
bmdsZXRvbl9maWxlX29wZXJhdGlvbnMpOw0KKyAgc2VwX2NvbnRleHQuc2luZ2xldG9uX2NkZXYu
b3duZXIgPSBUSElTX01PRFVMRTsNCisNCisgIC8qIHJlZ2lzdGVyIHRoZSBkcml2ZXIgd2l0aCB0
aGUga2VybmVsIGZzICovDQorICByZXRfdmFsID0gY2Rldl9hZGQoJnNlcF9jb250ZXh0LnNpbmds
ZXRvbl9jZGV2ICwNCisJCQkJc2VwX2NvbnRleHQuc2luZ2xldG9uX2RldmljZV9udW1iZXIgLA0K
KwkJCQkxKTsNCisJaWYgKHJldF92YWwpIHsNCisJCWVkYmcoInNlcF9kcml2ZXI6Y2Rldl9hZGQg
MiBmYWlsZWQsIHJldHZhbCBpcyAlZFxuIiAsDQorICAgICAgcmV0X3ZhbCk7DQorICAgIGdvdG8g
ZW5kX2Z1bmN0aW9uX3VucmVnaXN0ZXJfZmlyc3RfZGV2Ow0KKyAgfQ0KKw0KKyAgZ290byBlbmRf
ZnVuY3Rpb247DQorDQorZW5kX2Z1bmN0aW9uX3VucmVnaXN0ZXJfZmlyc3RfZGV2Og0KKw0KKyAg
LyogZGVsZXRlIHRoZSBmaXJzdCBkZXZpY2UgKi8NCisgIGNkZXZfZGVsKCZzZXBfY29udGV4dC5j
ZGV2KTsNCisNCisjZW5kaWYNCisNCitlbmRfZnVuY3Rpb25fdW5yZWdpc3Rlcl9kZXZudW06DQor
DQorI2lmZGVmIERYX0NDNTJfU1VQUE9SVA0KKyAgLyogdW5yZWdpc3RlciBkZXYgbnVtYmVycyAq
Lw0KKyAgdW5yZWdpc3Rlcl9jaHJkZXZfcmVnaW9uKHNlcF9jb250ZXh0LmRldmljZV9udW1iZXIs
IDIpOw0KKyNlbHNlDQorICB1bnJlZ2lzdGVyX2NocmRldl9yZWdpb24oc2VwX2NvbnRleHQuZGV2
aWNlX251bWJlciwgMSk7DQorI2VuZGlmDQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgcmV0dXJu
IHJldF92YWw7DQorfQ0KKw0KKy8qDQorICB0aGlzIGZ1bmN0aW9uIHVucmVnaXN0ZXJzIGRyaXZl
ciBmcm9tIGZzDQorKi8NCitzdGF0aWMgdm9pZCBzZXBfdW5yZWdpc3Rlcl9kcml2ZXJfZnJvbV9m
cyh2b2lkKQ0KK3sNCisgIC8qLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0t
LS0tLS0tLS0tLS0tLS0qLw0KKw0KKyAgY2Rldl9kZWwoJnNlcF9jb250ZXh0LmNkZXYpOw0KKw0K
KyNpZmRlZiBEWF9DQzUyX1NVUFBPUlQNCisgIGNkZXZfZGVsKCZzZXBfY29udGV4dC5zaW5nbGV0
b25fY2Rldik7DQorDQorICAvKiB1bnJlZ2lzdGVyIGRldiBudW1iZXJzICovDQorICB1bnJlZ2lz
dGVyX2NocmRldl9yZWdpb24oc2VwX2NvbnRleHQuZGV2aWNlX251bWJlciwgMik7DQorI2Vsc2UN
CisgIHVucmVnaXN0ZXJfY2hyZGV2X3JlZ2lvbihzZXBfY29udGV4dC5kZXZpY2VfbnVtYmVyLCAx
KTsNCisjZW5kaWYNCisNCit9DQorDQorLyoNCisgIHJlY29uZmlnIHRoZSBzaGFyZWQgYXJlYSBi
ZXR3ZWVuIEhPU1QgYW5kIFNFUCAtIG5lZWRlZCBpbiBjYXNlDQorICB0aGUgRFhfQ0NfSW5pdCBm
dW5jdGlvbiB3YXMgY2FsbGVkIGJlZm9yZSBPUyBsb2FkaW5nDQorKi8NCitzdGF0aWMgaW50IHNl
cF9yZWNvbmZpZ19zaGFyZWRfYXJlYSh2b2lkKQ0KK3sNCisgIGludCByZXRfdmFsOw0KKw0KKyAg
LyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQorICAgICAgQ09ERQ0KKyAgLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0qLw0KKw0KKyAgcmV0X3ZhbCA9IDA7DQorDQorI2lmIFNFUF9EUklWRVJfUkVD
T05GSUdfTUVTU0FHRV9BUkVBDQorDQorICAvKiBzZW5kIHRoZSBuZXcgU0hBUkVEIE1FU1NBR0Ug
QVJFQSB0byB0aGUgU0VQICovDQorICBTRVBfV1JJVEVfUkVHSVNURVIoJnNlcF9jb250ZXh0LCBI
V19IT1NUX0hPU1RfU0VQX0dQUjFfUkVHX0FERFIgLA0KKwkJCQkJc2VwX2NvbnRleHQucGh5c19z
aGFyZWRfYXJlYV9hZGRyKTsNCisNCisgIC8qIHBvbGwgZm9yIFNFUCByZXNwb25zZSAqLw0KKyAg
cmV0X3ZhbCA9IFNFUF9SRUFEX1JFR0lTVEVSKCZzZXBfY29udGV4dCwNCisJCQkJCUhXX0hPU1Rf
U0VQX0hPU1RfR1BSMV9SRUdfQUREUik7DQorCXdoaWxlIChyZXRfdmFsICE9IDB4ZmZmZmZmZmYg
JiYNCisJCQlyZXRfdmFsICE9IHNlcF9jb250ZXh0LnBoeXNfc2hhcmVkX2FyZWFfYWRkcikgew0K
KwkJcmV0X3ZhbCA9IFNFUF9SRUFEX1JFR0lTVEVSKCZzZXBfY29udGV4dCwNCisJCQlIV19IT1NU
X1NFUF9IT1NUX0dQUjFfUkVHX0FERFIpOw0KKyAgfQ0KKw0KKyAgLyogY2hlY2sgdGhlIHJldHVy
biB2YWx1ZSAocmVnaXN0ZXIpICovDQorICBpZiAocmV0X3ZhbCAhPSBzZXBfY29udGV4dC5waHlz
X3NoYXJlZF9hcmVhX2FkZHIpDQorCQlyZXRfdmFsID0gLUVOT01FTTsNCisNCisNCisjZW5kaWYN
CisNCisgIHJldHVybiByZXRfdmFsOw0KK30NCisNCitzdGF0aWMgdm9pZCBzZXBfaW5pdF9jb250
ZXh0KHZvaWQpDQorew0KKyAgLyotLS0tLS0tLS0tLS0tDQorICAgICAgQ09ERQ0KKyAgLS0tLS0t
LS0tLS0tLS0tLSovDQorDQorICAvKiB6ZXJvIGZpZWxkcyAqLw0KKyAgc2VwX2NvbnRleHQubnVt
X2xsaV90YWJsZXNfY3JlYXRlZCA9IDA7DQorICBzZXBfY29udGV4dC5pbl9wYWdlX2FycmF5ID0g
MDsNCisgIHNlcF9jb250ZXh0Lm91dF9wYWdlX2FycmF5ID0gMDsNCisgIHNlcF9jb250ZXh0Lmlu
X251bV9wYWdlcyA9IDA7DQorICBzZXBfY29udGV4dC5vdXRfbnVtX3BhZ2VzID0gMDsNCisgIHNl
cF9jb250ZXh0LmluX21hcF9hcnJheSA9IDA7DQorICBzZXBfY29udGV4dC5vdXRfbWFwX2FycmF5
ID0gMDsNCisgIHNlcF9jb250ZXh0LmluX21hcF9udW1fZW50cmllcyA9IDA7DQorICBzZXBfY29u
dGV4dC5vdXRfbWFwX251bV9lbnRyaWVzID0gMDsNCisgIHNlcF9jb250ZXh0LnNoYXJlZF9hcmVh
X2RtYV9hZGRyID0gMDsNCisNCisNCisgIC8qIGluaXQgaW9jdGwgbXV0ZXggKi8NCisgIG11dGV4
X2luaXQoJnNlcF9jb250ZXh0LmlvY3RsX211dGV4KTsNCisNCisgIC8qIGNhbGN1bGF0ZSB0aGUg
c2hhcmVkX2FyZWFfc2l6ZSAqLw0KKyAgc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfc2l6ZSA9DQor
ICAgIFNFUF9EUklWRVJfTUVTU0FHRV9TSEFSRURfQVJFQV9TSVpFX0lOX0JZVEVTICsNCisJCVNF
UF9EUklWRVJfU1lOQ0hST05JQ19ETUFfVEFCTEVTX0FSRUFfU0laRV9JTl9CWVRFUyArDQorCQlT
RVBfRFJJVkVSX0RBVEFfUE9PTF9TSEFSRURfQVJFQV9TSVpFX0lOX0JZVEVTICsNCisJCVNFUF9E
UklWRVJfRkxPV19ETUFfVEFCTEVTX0FSRUFfU0laRV9JTl9CWVRFUyArDQorCQlTRVBfRFJJVkVS
X1NUQVRJQ19BUkVBX1NJWkVfSU5fQllURVMgKw0KKwkJU0VQX0RSSVZFUl9TWVNURU1fREFUQV9N
RU1PUllfU0laRV9JTl9CWVRFUzsNCit9DQorDQorDQorLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKyAgaW5pdCBmdW5jdGlv
bg0KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0qLw0KK3N0YXRpYyBpbnQgX19pbml0IHNlcF9pbml0KHZvaWQpDQorew0KKyAg
LyogcmV0dXJuIHZhbHVlICovDQorICBpbnQJCQlyZXRfdmFsOw0KKw0KKyAgLyotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCisJQ09ERQ0KKyAgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKi8NCisN
CisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT5Jbml0IHN0YXJ0XG4iKTsNCisNCisgIHJldF92
YWwgPSAwOw0KKw0KKyAgcmV0X3ZhbCA9IHNlcF9yZWdpc3Rlcl9kcml2ZXJfdG9fZGV2aWNlKCk7
DQorCWlmIChyZXRfdmFsKSB7DQorCQllZGJnKCJzZXBfZHJpdmVyOnNlcF9kcml2ZXJfdG9fZGV2
aWNlIGZhaWxlZCwgcmV0X3ZhbCBpcyAlZFxuIiwNCisgICAgICByZXRfdmFsKTsNCisgICAgZ290
byBlbmRfZnVuY3Rpb25fdW5yZWdpc3Rlcl9mcm9tX2ZzOw0KKyAgfQ0KKw0KKyAgLyogaW5pdGlh
bGl6ZSB0aGUgY29udGV4dCBmaWVsZHMgKi8NCisgIHNlcF9pbml0X2NvbnRleHQoKTsNCisNCisg
IC8qIGFsbG9jYXRlIHRoZSBzaGFyZWQgYXJlYSAqLw0KKwlpZiAoc2VwX21hcF9hbmRfYWxsb2Nf
c2hhcmVkX2FyZWEoJnNlcF9jb250ZXh0KSkgew0KKwkJcmV0X3ZhbCA9IC1FTk9NRU07DQorCQkv
KiBhbGxvY2F0aW9uIGZhaWxlZCAqLw0KKwkJZ290byBlbmRfZnVuY3Rpb247DQorICB9DQorDQor
ICAvKiBpbml0aWFsaXplIHdhaXQgcXVldWUgKi8NCisgIGluaXRfd2FpdHF1ZXVlX2hlYWQoJnNl
cF9jb250ZXh0LmV2ZW50KTsNCisNCisjaWZkZWYgRFhfQ0M1Ml9TVVBQT1JUDQorICAvKiBpbml0
IHRoZSBjYWxsZXIgaWQgKi8NCisgIHJldF92YWwgPSBzZXBfaW5pdF9jYWxsZXJfaWQoKTsNCisJ
aWYgKHJldF92YWwpDQorCQlnb3RvIGVuZF9mdW5jdGlvbl9kZWFsbG9jYXRlX3NlcF9zaGFyZWRf
YXJlYTsNCisNCisjZW5kaWYNCisNCisgIC8qIHJlY29uZmlnIHRoZSBzaGFyZWQgYXJlYSAtIG5l
ZWRlZCBpbiBjYXNlIHRoYXQgT1MNCisJd2FzIGluaXRpYWxpemVkIGFmdGVyIHRoZSBEWF9DQ19J
bml0ICovDQorICByZXRfdmFsID0gc2VwX3JlY29uZmlnX3NoYXJlZF9hcmVhKCk7DQorCWlmIChy
ZXRfdmFsKQ0KKwkJZ290byBlbmRfZnVuY3Rpb25fdW5yZWdpc3Rlcl9mcm9tX2ZzOw0KKw0KKyAg
LyogcmVnaXN0ZXIgZHJpdmVyIHRvIGZzICovDQorICByZXRfdmFsID0gc2VwX3JlZ2lzdGVyX2Ry
aXZlcl90b19mcygpOw0KKwlpZiAocmV0X3ZhbCkNCisJCWdvdG8gZW5kX2Z1bmN0aW9uX2RlYWxs
b2NhdGVfc2VwX3NoYXJlZF9hcmVhOw0KKw0KKyAgZ290byBlbmRfZnVuY3Rpb247DQorDQorZW5k
X2Z1bmN0aW9uX3VucmVnaXN0ZXJfZnJvbV9mczoNCisNCisgIC8qIHVucmVnaXN0ZXIgZnJvbSBm
cyAqLw0KKyAgc2VwX3VucmVnaXN0ZXJfZHJpdmVyX2Zyb21fZnMoKTsNCisNCitlbmRfZnVuY3Rp
b25fZGVhbGxvY2F0ZV9zZXBfc2hhcmVkX2FyZWE6DQorDQorICAvKiBkZS1hbGxvY2F0ZSBzaGFy
ZWQgYXJlYSAqLw0KKyAgc2VwX3VubWFwX2FuZF9mcmVlX3NoYXJlZF9hcmVhKCZzZXBfY29udGV4
dCk7DQorDQorZW5kX2Z1bmN0aW9uOg0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBJ
bml0IGVuZFxuIik7DQorDQorICByZXR1cm4gcmV0X3ZhbDsNCit9DQorDQorDQorDQorDQorLyot
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tDQorICBleGl0IGZ1bmN0aW9uDQorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KK3N0YXRpYyB2b2lkIF9fZXhpdCBzZXBf
ZXhpdCh2b2lkKQ0KK3sNCisgIC8qIHNpemUgKi8NCisgIGludAkJCXNpemU7DQorDQorICAvKi0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQorCUNPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tKi8NCisNCisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gRXhpdCBz
dGFydFxuIik7DQorDQorICAvKiB1bnJlZ2lzdGVyIGZyb20gZnMgKi8NCisgIHNlcF91bnJlZ2lz
dGVyX2RyaXZlcl9mcm9tX2ZzKCk7DQorDQorICAvKiBjYWxjdWxhdGUgdGhlIHRvdGFsIHNpemUg
Zm9yIGRlLWFsbG9jYXRpb24gKi8NCisgIHNpemUgPSBTRVBfRFJJVkVSX01FU1NBR0VfU0hBUkVE
X0FSRUFfU0laRV9JTl9CWVRFUyArDQorCQlTRVBfRFJJVkVSX1NZTkNIUk9OSUNfRE1BX1RBQkxF
U19BUkVBX1NJWkVfSU5fQllURVMgKw0KKwkJU0VQX0RSSVZFUl9EQVRBX1BPT0xfU0hBUkVEX0FS
RUFfU0laRV9JTl9CWVRFUyArDQorCQlTRVBfRFJJVkVSX0ZMT1dfRE1BX1RBQkxFU19BUkVBX1NJ
WkVfSU5fQllURVMgKw0KKwkJU0VQX0RSSVZFUl9TVEFUSUNfQVJFQV9TSVpFX0lOX0JZVEVTICsN
CisJCVNFUF9EUklWRVJfU1lTVEVNX0RBVEFfTUVNT1JZX1NJWkVfSU5fQllURVM7DQorDQorDQor
ICAvKiBmcmVlIHNoYXJlZCBhcmVhICAqLw0KKyAgc2VwX3VubWFwX2FuZF9mcmVlX3NoYXJlZF9h
cmVhKCZzZXBfY29udGV4dCk7DQorDQorICBpb3VubWFwKHNlcF9jb250ZXh0LnJhcl92aXJ0dWFs
X2FkZHJlc3MpOw0KKyAgaW91bm1hcCgodm9pZCAqKXNlcF9jb250ZXh0LnJlZ19hZGRyKTsNCisN
CisgIHNlcF9jb250ZXh0LnJhcl92aXJ0dWFsX2FkZHJlc3MgPSBOVUxMOw0KKyAgc2VwX2NvbnRl
eHQucmVnX2FkZHIgPSBOVUxMOw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBFeGl0
IGVuZFxuIik7DQorfQ0KKw0KKw0KKy8qDQorICBpbnRlcnJ1cHQgaGFuZGxlciBmdW5jdGlvbg0K
KyovDQoraXJxcmV0dXJuX3Qgc2VwX2ludGhhbmRsZXIoaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0K
K3sNCisgIC8qIGludCBlcnJvciAqLw0KKyAgaXJxcmV0dXJuX3QJCWludF9lcnJvcjsNCisNCisg
IC8qIHJlZyB2YWx1ZSAqLw0KKyAgdTMyCQlyZWdfdmFsOw0KKw0KKyAgLyotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LSovDQorDQorICBpbnRfZXJyb3IgPSBJUlFfSEFORExFRDsNCisNCisgIC8qIHJlYWQgdGhlIElS
UiByZWdpc3RlciB0byBjaGVjayBpZiB0aGlzIGlzIFNFUCBpbnRlcnJ1cHQgKi8NCisgIHJlZ192
YWwgPSBTRVBfUkVBRF9SRUdJU1RFUigmc2VwX2NvbnRleHQsIEhXX0hPU1RfSVJSX1JFR19BRERS
KTsNCisgIGVkYmcoIlNFUCBJbnRlcnJ1cHQgLSByZWcgaXMgJTA4eFxuIiwgcmVnX3ZhbCk7DQor
DQorDQorICAvKiBjaGVjayBpZiB0aGlzIGlzIHJlcGx5IGludGVycnVwdCBmcm9tIFNFUCAqLw0K
KwlpZiAocmVnX3ZhbCAmICgweDEgPDwgMTMpKSB7DQorCQkvKiB1cGRhdGUgdGhlIGNvdW50ZXIg
b2YgcmVwbHkgbWVzc2FnZXMgKi8NCisJCXNlcF9jb250ZXh0LnNlcF90b19ob3N0X3JlcGx5X2Nv
dW50ZXIrKzsNCisNCisJCS8qIHdha2UgdXAgdGhlIHdhaXRpbmcgcHJvY2VzcyAqLw0KKwkJd2Fr
ZV91cCgmc2VwX2NvbnRleHQuZXZlbnQpOw0KKwl9IGVsc2Ugew0KKwkJaW50X2Vycm9yID0gSVJR
X05PTkU7DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisgIC8qIGNsZWFyIHRoZSBp
bnRlcnJ1cHQgKi8NCisgIFNFUF9XUklURV9SRUdJU1RFUigmc2VwX2NvbnRleHQsIEhXX0hPU1Rf
SUNSX1JFR19BRERSLCByZWdfdmFsKTsNCisNCitlbmRfZnVuY3Rpb246DQorDQorICByZXR1cm4g
aW50X2Vycm9yOw0KK30NCisNCisvKg0KKyAgdGhpcyBmdW5jdGlvbiBjYWxjdWxhdGVzIHRoZSBz
aXplIG9mIGRhdGEgdGhhdCBjYW4gYmUgaW5zZXJ0ZWQgaW50byB0aGUgbGxpDQorICB0YWJsZSBm
cm9tIHRoaXMgYXJyYXkgdGhlIGNvbmRpdGlvbiBpcyB0aGF0IGVpdGhlciB0aGUgdGFibGUgaXMg
ZnVsbA0KKyAgKGFsbCBldG5yaWVzIGFyZSBlbnRlcmVkKSwgb3IgdGhlcmUgYXJlIG5vIG1vcmUg
ZW50cmllcyBpbiB0aGUgbGxpIGFycmF5DQorKi8NCit1MzIgc2VwX2NhbGN1bGF0ZV9sbGlfdGFi
bGVfbWF4X3NpemUoDQorCQkJc3RydWN0IHNlcF9sbGlfZW50cnlfdAkqbGxpX2luX2FycmF5X3B0
ciwNCisJCQl1MzIJbnVtX2FycmF5X2VudHJpZXMpDQorew0KKyAgLyogdGFibGUgZGF0YSBzaXpl
ICovDQorICB1MzIgdGFibGVfZGF0YV9zaXplOw0KKw0KKyAgLyogY291bnRlciAqLw0KKyAgdTMy
IGNvdW50ZXI7DQorDQorICAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tKi8NCisNCisgIHRhYmxlX2RhdGFfc2l6ZSA9IDA7DQorDQorICAv
KiBjYWxjdWxhdGUgdGhlIGRhdGEgaW4gdGhlIG91dCBsbGkgdGFibGUgaWYgdGlsbCB3ZSBmaWxs
IHRoZSB3aG9sZQ0KKyAgdGFibGUgb3IgdGlsbCB0aGUgZGF0YSBoYXMgZW5kZWQgKi8NCisgIGZv
ciAoY291bnRlciA9IDA7DQorCShjb3VudGVyIDwgKFNFUF9EUklWRVJfRU5UUklFU19QRVJfVEFC
TEVfSU5fU0VQIC0gMSkpICYmDQorCShjb3VudGVyIDwgbnVtX2FycmF5X2VudHJpZXMpOyBjb3Vu
dGVyKyspDQorCXRhYmxlX2RhdGFfc2l6ZSArPSBsbGlfaW5fYXJyYXlfcHRyW2NvdW50ZXJdLmJs
b2NrX3NpemU7DQorDQorICByZXR1cm4gdGFibGVfZGF0YV9zaXplOw0KK30NCisNCisvKg0KKyAg
dGhpcyBmdW5jdGlvbnMgYnVpbGRzIG9udCBsbGkgdGFibGUgZnJvbSB0aGUgbGxpX2FycmF5IGFj
Y29yZGluZyB0bw0KKyAgdGhlIGdpdmVuIHNpemUgb2YgZGF0YQ0KKyovDQorc3RhdGljIHZvaWQg
c2VwX2J1aWxkX2xsaV90YWJsZShzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90CSpsbGlfYXJyYXlfcHRy
LA0KKwkJCQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90CSpsbGlfdGFibGVfcHRyLA0KKwkJCQl1MzIJ
Km51bV9wcm9jZXNzZWRfZW50cmllc19wdHIsDQorCQkJCXUzMgkqbnVtX3RhYmxlX2VudHJpZXNf
cHRyLA0KKwkJCQl1MzIJdGFibGVfZGF0YV9zaXplKQ0KK3sNCisgIC8qIGN1cnJlbnQgdGFibGUg
ZGF0YSBzaXplICovDQorICB1MzIgY3Vycl90YWJsZV9kYXRhX3NpemU7DQorDQorICAvKiBjb3Vu
dGVyIG9mIGxsaSBhcnJheSBlbnRyeSAqLw0KKyAgdTMyIGFycmF5X2NvdW50ZXI7DQorDQorICAv
Ki0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQorCUNPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLSovDQorDQorICBkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9idWlsZF9sbGlf
dGFibGUgc3RhcnRcbiIpOw0KKw0KKyAgLyogaW5pdCBjdXJycmVudCB0YWJsZSBkYXRhIHNpemUg
YW5kIGxsaSBhcnJheSBlbnRyeSBjb3VudGVyICovDQorICBjdXJyX3RhYmxlX2RhdGFfc2l6ZSA9
IDA7DQorICBhcnJheV9jb3VudGVyID0gMDsNCisgICpudW1fdGFibGVfZW50cmllc19wdHIgPSAx
Ow0KKw0KKyAgZWRiZygiU0VQIERyaXZlcjp0YWJsZV9kYXRhX3NpemUgaXMgJXhcbiIsIHRhYmxl
X2RhdGFfc2l6ZSk7DQorDQorICAvKiBmaWxsIHRoZSB0YWJsZSB0aWxsIHRhYmxlIHNpemUgcmVh
Y2hlcyB0aGUgbmVlZGVkIGFtb3VudCAqLw0KKyAgd2hpbGUgKGN1cnJfdGFibGVfZGF0YV9zaXpl
IDwgdGFibGVfZGF0YV9zaXplKSB7DQorCS8qIHVwZGF0ZSB0aGUgbnVtYmVyIG9mIGVudHJpZXMg
aW4gdGFibGUgKi8NCisJKCpudW1fdGFibGVfZW50cmllc19wdHIpKys7DQorDQorCWxsaV90YWJs
ZV9wdHItPmJ1c19hZGRyZXNzID0NCisgIFNFUF9DSEFOR0VfRU5ESUFOTkVTUyhsbGlfYXJyYXlf
cHRyW2FycmF5X2NvdW50ZXJdLmJ1c19hZGRyZXNzKTsNCisNCisJbGxpX3RhYmxlX3B0ci0+Ymxv
Y2tfc2l6ZSA9DQorCVNFUF9DSEFOR0VfRU5ESUFOTkVTUyhsbGlfYXJyYXlfcHRyW2FycmF5X2Nv
dW50ZXJdLmJsb2NrX3NpemUpOw0KKw0KKwljdXJyX3RhYmxlX2RhdGFfc2l6ZSArPSBsbGlfYXJy
YXlfcHRyW2FycmF5X2NvdW50ZXJdLmJsb2NrX3NpemU7DQorDQorCWVkYmcoIlNFUCBEcml2ZXI6
bGxpX3RhYmxlX3B0ciBpcyAlMDh4XG4iLCAodTMyKWxsaV90YWJsZV9wdHIpOw0KKwllZGJnKCJT
RVAgRHJpdmVyOmxsaV90YWJsZV9wdHItPmJ1c19hZGRyZXNzIGlzICUwOHhcbiIsDQorICAgICAg
bGxpX3RhYmxlX3B0ci0+YnVzX2FkZHJlc3MpOw0KKwllZGJnKCJTRVAgRHJpdmVyOmxsaV90YWJs
ZV9wdHItPmJsb2NrX3NpemUgaXMgJXhcbiIsDQorICAgICAgbGxpX3RhYmxlX3B0ci0+YmxvY2tf
c2l6ZSk7DQorDQorCS8qIGNoZWNrIGZvciBvdmVyZmxvdyBvZiB0aGUgdGFibGUgZGF0YSAqLw0K
KwlpZiAoY3Vycl90YWJsZV9kYXRhX3NpemUgPiB0YWJsZV9kYXRhX3NpemUpIHsNCisJCWVkYmco
IlNFUCBEcml2ZXI6Y3Vycl90YWJsZV9kYXRhX3NpemUgPiB0YWJsZV9kYXRhX3NpemVcbiIpOw0K
Kw0KKwkJLyogdXBkYXRlIHRoZSBzaXplIG9mIGJsb2NrIGluIHRoZSB0YWJsZSAqLw0KKwkJbGxp
X3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSAtPQ0KKwkJU0VQX0NIQU5HRV9FTkRJQU5ORVNTKChjdXJy
X3RhYmxlX2RhdGFfc2l6ZSAtIHRhYmxlX2RhdGFfc2l6ZSkpOw0KKw0KKwkJLyogdXBkYXRlIHRo
ZSBwaHlzaWNhbCBhZGRyZXNzIGluIHRoZSBsbGkgYXJyYXkgKi8NCisJCWxsaV9hcnJheV9wdHJb
YXJyYXlfY291bnRlcl0uYnVzX2FkZHJlc3MgKz0NCisJCQlTRVBfQ0hBTkdFX0VORElBTk5FU1Mo
bGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSk7DQorDQorCQkvKiB1cGRhdGUgdGhlIGJsb2NrIHNp
emUgbGVmdCBpbiB0aGUgbGxpIGFycmF5ICovDQorCQlsbGlfYXJyYXlfcHRyW2FycmF5X2NvdW50
ZXJdLmJsb2NrX3NpemUgPQ0KKwkJCShjdXJyX3RhYmxlX2RhdGFfc2l6ZSAtIHRhYmxlX2RhdGFf
c2l6ZSk7DQorCX0gZWxzZQ0KKwkJLyogYWR2YW5jZSB0byB0aGUgbmV4dCBlbnRyeSBpbiB0aGUg
bGxpX2FycmF5ICovDQorCQlhcnJheV9jb3VudGVyKys7DQorDQorCQllZGJnKCJTRVAgRHJpdmVy
OmxsaV90YWJsZV9wdHItPmJ1c19hZGRyZXNzIGlzICUwOHhcbiIsDQorCQkJbGxpX3RhYmxlX3B0
ci0+YnVzX2FkZHJlc3MpOw0KKwkJZWRiZygiU0VQIERyaXZlcjpsbGlfdGFibGVfcHRyLT5ibG9j
a19zaXplIGlzICV4XG4iLA0KKwkJCWxsaV90YWJsZV9wdHItPmJsb2NrX3NpemUpOw0KKw0KKwkJ
LyogbW92ZSB0byB0aGUgbmV4dCBlbnRyeSBpbiB0YWJsZSAqLw0KKwkJbGxpX3RhYmxlX3B0cisr
Ow0KKyAgfQ0KKw0KKyAgLyogc2V0IHRoZSBpbmZvIGVudHJ5IHRvIGRlZmF1bHQgKi8NCisgIGxs
aV90YWJsZV9wdHItPmJ1c19hZGRyZXNzID0gMHhmZmZmZmZmZjsNCisgIGxsaV90YWJsZV9wdHIt
PmJsb2NrX3NpemUgPSAwOw0KKw0KKyAgZWRiZygiU0VQIERyaXZlcjpsbGlfdGFibGVfcHRyIGlz
ICUwOHhcbiIsICh1MzIpbGxpX3RhYmxlX3B0cik7DQorICBlZGJnKCJTRVAgRHJpdmVyOmxsaV90
YWJsZV9wdHItPmJ1c19hZGRyZXNzIGlzICUwOHhcbiIsDQorICAgIGxsaV90YWJsZV9wdHItPmJ1
c19hZGRyZXNzKTsNCisgIGVkYmcoIlNFUCBEcml2ZXI6bGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6
ZSBpcyAleFxuIiwNCisgICAgbGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSk7DQorDQorDQorICAv
KiBzZXQgdGhlIG91dHB1dCBwYXJhbWV0ZXIgKi8NCisgICpudW1fcHJvY2Vzc2VkX2VudHJpZXNf
cHRyICs9IGFycmF5X2NvdW50ZXI7DQorDQorICBlZGJnKCJTRVAgRHJpdmVyOipudW1fcHJvY2Vz
c2VkX2VudHJpZXNfcHRyIGlzICV4XG4iLA0KKyAgICAqbnVtX3Byb2Nlc3NlZF9lbnRyaWVzX3B0
cik7DQorDQorDQorICBkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9idWlsZF9sbGlfdGFi
bGUgZW5kXG4iKTsNCisNCisgIHJldHVybjsNCit9DQorDQorLyoNCisgIHRoaXMgZnVuY3Rpb24g
Z29lcyBvdmVyIHRoZSBsaXN0IG9mIHRoZSBwcmludCBjcmVhdGVkIHRhYmxlcyBhbmQNCisgIHBy
aW50cyBhbGwgdGhlIGRhdGENCisqLw0KK3N0YXRpYyB2b2lkIHNlcF9kZWJ1Z19wcmludF9sbGlf
dGFibGVzKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QJKmxsaV90YWJsZV9wdHIsDQorCQkJCQl1MzIJ
bnVtX3RhYmxlX2VudHJpZXMsDQorCQkJCQl1MzIJdGFibGVfZGF0YV9zaXplKQ0KK3sNCisgIHUz
MiB0YWJsZV9jb3VudDsNCisNCisgIHUzMiBlbnRyaWVzX2NvdW50Ow0KKyAgLyotLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tKi8NCisNCisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX2RlYnVnX3ByaW50
X2xsaV90YWJsZXMgc3RhcnRcbiIpOw0KKw0KKyAgdGFibGVfY291bnQgPSAxOw0KKwl3aGlsZSAo
KHUzMilsbGlfdGFibGVfcHRyICE9IDB4ZmZmZmZmZmYpIHsNCisJCWVkYmcoIlNFUCBEcml2ZXI6
IGxsaSB0YWJsZSAlMDh4LCB0YWJsZV9kYXRhX3NpemUgaXMgJXhcbiIsDQorCQkJdGFibGVfY291
bnQsDQorCQkJdGFibGVfZGF0YV9zaXplKTsNCisJCWVkYmcoIlNFUCBEcml2ZXI6IG51bV90YWJs
ZV9lbnRyaWVzIGlzICV4XG4iLA0KKwkJCW51bV90YWJsZV9lbnRyaWVzKTsNCisNCisJCS8qIHBy
aW50IGVudHJpZXMgb2YgdGhlIHRhYmxlICh3aXRob3V0IGluZm8gZW50cnkpICovDQorCQlmb3Ig
KGVudHJpZXNfY291bnQgPSAwOw0KKwkJCWVudHJpZXNfY291bnQgPCBudW1fdGFibGVfZW50cmll
czsNCisJCQllbnRyaWVzX2NvdW50KyssIGxsaV90YWJsZV9wdHIrKykgew0KKw0KKwkJCWVkYmco
IlNFUCBEcml2ZXI6bGxpX3RhYmxlX3B0ciBhZGRyZXNzIGlzICUwOHhcbiIsDQorCQkJKHUzMils
bGlfdGFibGVfcHRyKTsNCisJCQllZGJnKCJTRVAgRHJpdmVyOnBoeXMgYWRkcmVzcyBpcyAlMDh4
XA0KKwkJCQlibG9jayBzaXplIGlzICV4XG4iLA0KKwkJCQlsbGlfdGFibGVfcHRyLT5idXNfYWRk
cmVzcywNCisJCQkJbGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSk7DQorCQl9DQorDQorCQkvKiBw
b2ludCB0byB0aGUgaW5mbyBlbnRyeSAqLw0KKwkJbGxpX3RhYmxlX3B0ci0tOw0KKw0KKwkJZWRi
ZygiU0VQIERyaXZlcjpwaHlzIGxsaV90YWJsZV9wdHItPmJsb2NrX3NpemUgaXMgJXhcbiIsDQor
CQkJbGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSk7DQorCQllZGJnKCJTRVAgRHJpdmVyOnBoeXMg
bGxpX3RhYmxlX3B0ci0+cGh5c2ljYWxfYWRkcmVzc1wNCisJCQlpcyAlMDh4XG4iLA0KKwkJCWxs
aV90YWJsZV9wdHItPmJ1c19hZGRyZXNzKTsNCisNCisNCisJCXRhYmxlX2RhdGFfc2l6ZSA9DQor
CQlTRVBfQ0hBTkdFX0VORElBTk5FU1MobGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSkgJiAweGZm
ZmZmZjsNCisNCisJCW51bV90YWJsZV9lbnRyaWVzID0NCisJCShTRVBfQ0hBTkdFX0VORElBTk5F
U1MobGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSkgPj4gMjQpICYgMHhmZjsNCisNCisJCWxsaV90
YWJsZV9wdHIgPSAoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqKQ0KKwkJKFNFUF9DSEFOR0VfRU5E
SUFOTkVTUyhsbGlfdGFibGVfcHRyLT5idXNfYWRkcmVzcykpOw0KKw0KKwkJZWRiZygiU0VQIERy
aXZlcjpwaHlzIHRhYmxlX2RhdGFfc2l6ZSBpcyAleFwNCisJCQludW1fdGFibGVfZW50cmllcyBp
cyAleCBsbGlfdGFibGVfcHRyIGlzJXhcbiIsDQorCQl0YWJsZV9kYXRhX3NpemUsIG51bV90YWJs
ZV9lbnRyaWVzLCAodTMyKWxsaV90YWJsZV9wdHIpOw0KKw0KKwkJaWYgKCh1MzIpbGxpX3RhYmxl
X3B0ciAhPSAweGZmZmZmZmZmKQ0KKwkJCWxsaV90YWJsZV9wdHIgPSAoc3RydWN0IHNlcF9sbGlf
ZW50cnlfdCAqKQ0KKwkJCQlzZXBfc2hhcmVkX2FyZWFfYnVzX3RvX3ZpcnQoJnNlcF9jb250ZXh0
LA0KKwkJCQkJKHUzMilsbGlfdGFibGVfcHRyKTsNCisJCQl0YWJsZV9jb3VudCsrOw0KKwl9DQor
DQorCWRiZygiU0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX2RlYnVnX3ByaW50X2xsaV90YWJsZXMg
ZW5kXG4iKTsNCit9DQorDQorDQorc3RhdGljIHZvaWQgc2VwX3ByZXBhcmVfZW1wdHlfbGxpX3Rh
YmxlKGRtYV9hZGRyX3QgKmxsaV90YWJsZV9hZGRyX3B0ciwNCisgICAgICB1MzIJKm51bV9lbnRy
aWVzX3B0ciwNCisgICAgICB1MzIJKnRhYmxlX2RhdGFfc2l6ZV9wdHIpDQorew0KKyAgLyogbGxp
IHRhYmxlIHBvaW50ZXIgKi8NCisgIHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QJCSpsbGlfdGFibGVf
cHRyOw0KKw0KKyAgLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0NCisgICAgICBDT0RFDQorICAtLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKw0KKwkvKiBmaW5kIHRoZSBhcmVhIGZvciBuZXcgdGFi
bGUgKi8NCisJbGxpX3RhYmxlX3B0ciA9DQorCSAgKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QgKiko
c2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfdmlydF9hZGRyICsNCisgICAgU0VQX0RSSVZFUl9TWU5D
SFJPTklDX0RNQV9UQUJMRVNfQVJFQV9PRkZTRVRfSU5fQllURVMgKw0KKyAgICBzZXBfY29udGV4
dC5udW1fbGxpX3RhYmxlc19jcmVhdGVkICoNCisgICAgc2l6ZW9mKHN0cnVjdCBzZXBfbGxpX2Vu
dHJ5X3QpICogU0VQX0RSSVZFUl9FTlRSSUVTX1BFUl9UQUJMRV9JTl9TRVApOw0KKw0KKwlsbGlf
dGFibGVfcHRyLT5idXNfYWRkcmVzcyA9IDA7DQorCWxsaV90YWJsZV9wdHItPmJsb2NrX3NpemUg
PSAwOw0KKw0KKwlsbGlfdGFibGVfcHRyKys7DQorCWxsaV90YWJsZV9wdHItPmJ1c19hZGRyZXNz
ID0gMHhGRkZGRkZGRjsNCisJbGxpX3RhYmxlX3B0ci0+YmxvY2tfc2l6ZSA9IDA7DQorDQorCS8q
IHNldCB0aGUgb3V0cHV0IHBhcmFtZXRlciB2YWx1ZSAqLw0KKwkqbGxpX3RhYmxlX2FkZHJfcHRy
ID0gc2VwX2NvbnRleHQuc2hhcmVkX2FyZWFfYnVzX2FkZHIgKw0KKwkJCVNFUF9EUklWRVJfU1lO
Q0hST05JQ19ETUFfVEFCTEVTX0FSRUFfT0ZGU0VUX0lOX0JZVEVTICsNCisJCQlzZXBfY29udGV4
dC5udW1fbGxpX3RhYmxlc19jcmVhdGVkICoNCisJCQlzaXplb2Yoc3RydWN0IHNlcF9sbGlfZW50
cnlfdCkgKg0KKwkJCVNFUF9EUklWRVJfRU5UUklFU19QRVJfVEFCTEVfSU5fU0VQOw0KKw0KKwkv
KiBzZXQgdGhlIG51bSBvZiBlbnRyaWVzIGFuZCB0YWJsZSBkYXRhIHNpemUgZm9yIGVtcHR5IHRh
YmxlICovDQorCSpudW1fZW50cmllc19wdHIgPSAyOw0KKwkqdGFibGVfZGF0YV9zaXplX3B0ciA9
IDA7DQorDQorCS8qIHVwZGF0ZSB0aGUgbnVtYmVyIG9mIGNyZWF0ZWQgdGFibGVzICovDQorCXNl
cF9jb250ZXh0Lm51bV9sbGlfdGFibGVzX2NyZWF0ZWQrKzsNCisNCit9DQorDQorLyoNCisgVGhp
cyBmdW5jdGlvbiBjcmVhdGVzIHRoZSBpbnB1dCBhbmQgb3V0cHV0IGRtYSB0YWJsZXMgZm9yDQor
IHN5bW1ldHJpYyBvcGVyYXRpb25zIChBRVMvREVTKSBhY2NvcmRpbmcgdG8gdGhlIGJsb2NrIHNp
emUgZnJvbSBMTEkgYXJheXMNCisqLw0KK3N0YXRpYyBpbnQgc2VwX2NvbnN0cnVjdF9kbWFfdGFi
bGVzX2Zyb21fbGxpKA0KKyAgICAgIHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QJKmxsaV9pbl9hcnJh
eSwNCisgICAgICB1MzIJc2VwX2luX2xsaV9lbnRyaWVzLA0KKyAgICAgIHN0cnVjdCBzZXBfbGxp
X2VudHJ5X3QJKmxsaV9vdXRfYXJyYXksDQorICAgICAgdTMyCXNlcF9vdXRfbGxpX2VudHJpZXMs
DQorICAgICAgdTMyCWJsb2NrX3NpemUsDQorICAgICAgZG1hX2FkZHJfdAkqbGxpX3RhYmxlX2lu
X3B0ciwNCisgICAgICBkbWFfYWRkcl90CSpsbGlfdGFibGVfb3V0X3B0ciwNCisgICAgICB1MzIJ
KmluX251bV9lbnRyaWVzX3B0ciwNCisgICAgICB1MzIJKm91dF9udW1fZW50cmllc19wdHIsDQor
ICAgICAgdTMyCSp0YWJsZV9kYXRhX3NpemVfcHRyKQ0KK3sNCisgIC8qIHBvaW50cyB0byB0aGUg
YXJlYSB3aGVyZSBuZXh0IGxsaSB0YWJsZSBjYW4gYmUgYWxsb2NhdGVkICovDQorICB1MzIJbGxp
X3RhYmxlX2FsbG9jX2FkZHI7DQorDQorICAvKiBpbnB1dCBsbGkgdGFibGUgKi8NCisgIHN0cnVj
dCBzZXBfbGxpX2VudHJ5X3QJCSppbl9sbGlfdGFibGVfcHRyOw0KKw0KKyAgLyogb3V0cHV0IGxs
aSB0YWJsZSAqLw0KKyAgc3RydWN0IHNlcF9sbGlfZW50cnlfdAkJKm91dF9sbGlfdGFibGVfcHRy
Ow0KKw0KKyAgLyogcG9pbnRlciB0byB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgdGFibGUgLSB0aGUg
bGFzdCBlbnRyeSAqLw0KKyAgc3RydWN0IHNlcF9sbGlfZW50cnlfdAkJKmluZm9faW5fZW50cnlf
cHRyOw0KKw0KKyAgLyogcG9pbnRlciB0byB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgdGFibGUgLSB0
aGUgbGFzdCBlbnRyeSAqLw0KKyAgc3RydWN0IHNlcF9sbGlfZW50cnlfdAkJKmluZm9fb3V0X2Vu
dHJ5X3B0cjsNCisNCisgIC8qIHBvaW50cyB0byB0aGUgZmlyc3QgZW50cnkgdG8gYmUgcHJvY2Vz
c2VkIGluIHRoZSBsbGlfaW5fYXJyYXkgKi8NCisgIHUzMgljdXJyZW50X2luX2VudHJ5Ow0KKw0K
KyAgLyogcG9pbnRzIHRvIHRoZSBmaXJzdCBlbnRyeSB0byBiZSBwcm9jZXNzZWQgaW4gdGhlIGxs
aV9vdXRfYXJyYXkgKi8NCisgIHUzMgljdXJyZW50X291dF9lbnRyeTsNCisNCisgIC8qIG1heCBz
aXplIG9mIHRoZSBpbnB1dCB0YWJsZSAqLw0KKyAgdTMyCWluX3RhYmxlX2RhdGFfc2l6ZTsNCisN
CisgIC8qIG1heCBzaXplIG9mIHRoZSBvdXRwdXQgdGFibGUgKi8NCisgIHUzMglvdXRfdGFibGVf
ZGF0YV9zaXplOw0KKw0KKyAgLyogZmxhZyB0ZSBzaWduaWZpZXMgaWYgdGhpcyBpcyB0aGUgZmly
c3QgdGFibGVzIGJ1aWxkIGZyb20gdGhlIGFycmF5cyAqLw0KKyAgdTMyCSAgZmlyc3RfdGFibGVf
ZmxhZzsNCisNCisgIC8qIHRoZSBkYXRhIHNpemUgdGhhdCBzaG91bGQgYmUgaW4gdGFibGUgKi8N
CisgIHUzMgl0YWJsZV9kYXRhX3NpemU7DQorDQorICAvKiBudW1iZXIgb2YgZXRucmllcyBpbiB0
aGUgaW5wdXQgdGFibGUgKi8NCisgIHUzMgludW1fZW50cmllc19pbl90YWJsZTsNCisNCisgIC8q
IG51bWJlciBvZiBldG5yaWVzIGluIHRoZSBvdXRwdXQgdGFibGUgKi8NCisgIHUzMgludW1fZW50
cmllc19vdXRfdGFibGU7DQorDQorICAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQor
ICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOi0tLS0t
LS0tPiBzZXBfY29uc3RydWN0X2RtYV90YWJsZXNfZnJvbV9sbGkgc3RhcnRcbiIpOw0KKw0KKyAg
LyogaW5pdGlhdGUgdG8gcG9pbnQgYWZ0ZXIgdGhlIG1lc3NhZ2UgYXJlYSAqLw0KKyAgbGxpX3Rh
YmxlX2FsbG9jX2FkZHIgPSAodTMyKShzZXBfY29udGV4dC5zaGFyZWRfYXJlYV92aXJ0X2FkZHIg
Kw0KKyAgU0VQX0RSSVZFUl9TWU5DSFJPTklDX0RNQV9UQUJMRVNfQVJFQV9PRkZTRVRfSU5fQllU
RVMgKw0KKyAgKHNlcF9jb250ZXh0Lm51bV9sbGlfdGFibGVzX2NyZWF0ZWQgKg0KKyAgKHNpemVv
ZihzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90KSAqIFNFUF9EUklWRVJfRU5UUklFU19QRVJfVEFCTEVf
SU5fU0VQKSkpOw0KKw0KKyAgY3VycmVudF9pbl9lbnRyeSA9IDA7DQorICBjdXJyZW50X291dF9l
bnRyeSA9IDA7DQorICBmaXJzdF90YWJsZV9mbGFnID0gMTsNCisgIGluZm9faW5fZW50cnlfcHRy
ID0gMDsNCisgIGluZm9fb3V0X2VudHJ5X3B0ciA9IDA7DQorDQorICAvKiBsb29wIHRpbGwgYWxs
IHRoZSBlbnRyaWVzIGluIGluIGFycmF5IGFyZSBub3QgcHJvY2Vzc2VkICovDQorICB3aGlsZSAo
Y3VycmVudF9pbl9lbnRyeSA8IHNlcF9pbl9sbGlfZW50cmllcykgew0KKwkvKiBzZXQgdGhlIG5l
dyBpbnB1dCBhbmQgb3V0cHV0IHRhYmxlcyAqLw0KKwlpbl9sbGlfdGFibGVfcHRyID0gKHN0cnVj
dCBzZXBfbGxpX2VudHJ5X3QgKilsbGlfdGFibGVfYWxsb2NfYWRkcjsNCisNCisJbGxpX3RhYmxl
X2FsbG9jX2FkZHIgKz0gc2l6ZW9mKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QpICoNCisJCQlTRVBf
RFJJVkVSX0VOVFJJRVNfUEVSX1RBQkxFX0lOX1NFUDsNCisNCisJLyogc2V0IHRoZSBmaXJzdCBv
dXRwdXQgdGFibGVzICovDQorCW91dF9sbGlfdGFibGVfcHRyID0gKHN0cnVjdCBzZXBfbGxpX2Vu
dHJ5X3QgKilsbGlfdGFibGVfYWxsb2NfYWRkcjsNCisNCisJLyogdXBkYXRlIHRoZSBudW1iZXIg
b2YgdGhlIGxsaSB0YWJsZXMgY3JlYXRlZCAqLw0KKwlzZXBfY29udGV4dC5udW1fbGxpX3RhYmxl
c19jcmVhdGVkICs9IDI7DQorDQorCWxsaV90YWJsZV9hbGxvY19hZGRyICs9IHNpemVvZihzdHJ1
Y3Qgc2VwX2xsaV9lbnRyeV90KSAqDQorCQkJCVNFUF9EUklWRVJfRU5UUklFU19QRVJfVEFCTEVf
SU5fU0VQOw0KKw0KKwkvKiBjYWxjdWxhdGUgdGhlIG1heGltdW0gc2l6ZSBvZiBkYXRhIGZvciBp
bnB1dCB0YWJsZSAqLw0KKwlpbl90YWJsZV9kYXRhX3NpemUgPQ0KKwkJCXNlcF9jYWxjdWxhdGVf
bGxpX3RhYmxlX21heF9zaXplKA0KKwkJCSZsbGlfaW5fYXJyYXlbY3VycmVudF9pbl9lbnRyeV0s
DQorCQkJKHNlcF9pbl9sbGlfZW50cmllcyAtIGN1cnJlbnRfaW5fZW50cnkpKTsNCisNCisJLyog
Y2FsY3VsYXRlIHRoZSBtYXhpbXVtIHNpemUgb2YgZGF0YSBmb3Igb3V0cHV0IHRhYmxlICovDQor
CW91dF90YWJsZV9kYXRhX3NpemUgPQ0KKwkJCXNlcF9jYWxjdWxhdGVfbGxpX3RhYmxlX21heF9z
aXplKA0KKwkJCSZsbGlfb3V0X2FycmF5W2N1cnJlbnRfb3V0X2VudHJ5XSwNCisJCQkoc2VwX291
dF9sbGlfZW50cmllcyAtIGN1cnJlbnRfb3V0X2VudHJ5KSk7DQorDQorCWVkYmcoIlNFUCBEcml2
ZXI6aW5fdGFibGVfZGF0YV9zaXplIGlzICV4XG4iLCBpbl90YWJsZV9kYXRhX3NpemUpOw0KKwll
ZGJnKCJTRVAgRHJpdmVyOm91dF90YWJsZV9kYXRhX3NpemUgaXMgJXhcbiIsIG91dF90YWJsZV9k
YXRhX3NpemUpOw0KKw0KKwkvKiBjaGVjayB3aGVyZSB0aGUgZGF0YSBpcyBzbWFsbGVzdCAqLw0K
Kwl0YWJsZV9kYXRhX3NpemUgPSBpbl90YWJsZV9kYXRhX3NpemU7DQorCWlmICh0YWJsZV9kYXRh
X3NpemUgPiBvdXRfdGFibGVfZGF0YV9zaXplKQ0KKwkJdGFibGVfZGF0YV9zaXplID0gb3V0X3Rh
YmxlX2RhdGFfc2l6ZTsNCisNCisJLyogbm93IGNhbGN1bGF0ZSB0aGUgdGFibGUgc2l6ZSBzbyB0
aGF0IGl0IHdpbGwgYmUgbW9kdWxlIGJsb2NrIHNpemUgKi8NCisJdGFibGVfZGF0YV9zaXplID0g
KHRhYmxlX2RhdGFfc2l6ZSAvIGJsb2NrX3NpemUpICogYmxvY2tfc2l6ZTsNCisNCisJZWRiZygi
U0VQIERyaXZlcjp0YWJsZV9kYXRhX3NpemUgaXMgJXhcbiIsIHRhYmxlX2RhdGFfc2l6ZSk7DQor
DQorCS8qIGNvbnN0cnVjdCBpbnB1dCBsbGkgdGFibGUgKi8NCisJc2VwX2J1aWxkX2xsaV90YWJs
ZSgmbGxpX2luX2FycmF5W2N1cnJlbnRfaW5fZW50cnldLA0KKwkJCQkJCWluX2xsaV90YWJsZV9w
dHIsDQorCQkJCQkJJmN1cnJlbnRfaW5fZW50cnksDQorCQkJCQkJJm51bV9lbnRyaWVzX2luX3Rh
YmxlLA0KKwkJCQkJCXRhYmxlX2RhdGFfc2l6ZSk7DQorDQorCS8qIGNvbnN0cnVjdCBvdXRwdXQg
bGxpIHRhYmxlICovDQorCXNlcF9idWlsZF9sbGlfdGFibGUoJmxsaV9vdXRfYXJyYXlbY3VycmVu
dF9vdXRfZW50cnldLA0KKwkJCQkJCW91dF9sbGlfdGFibGVfcHRyLA0KKwkJCQkJCSZjdXJyZW50
X291dF9lbnRyeSwNCisJCQkJCQkmbnVtX2VudHJpZXNfb3V0X3RhYmxlLA0KKwkJCQkJCXRhYmxl
X2RhdGFfc2l6ZSk7DQorDQorCS8qIGlmIGluZm8gZW50cnkgaXMgbnVsbCAtIHRoaXMgaXMgdGhl
IGZpcnN0IHRhYmxlIGJ1aWx0ICovDQorCWlmIChpbmZvX2luX2VudHJ5X3B0ciA9PSAwKSB7DQor
CQkvKiBzZXQgdGhlIG91dHB1dCBwYXJhbWV0ZXJzIHRvIHBoeXNpY2FsIGFkZHJlc3NlcyAqLw0K
KwkJKmxsaV90YWJsZV9pbl9wdHIgPQ0KKwkJc2VwX3NoYXJlZF9hcmVhX3ZpcnRfdG9fYnVzKCZz
ZXBfY29udGV4dCwgaW5fbGxpX3RhYmxlX3B0cik7DQorDQorCQkqaW5fbnVtX2VudHJpZXNfcHRy
ID0gbnVtX2VudHJpZXNfaW5fdGFibGU7DQorDQorCQkqbGxpX3RhYmxlX291dF9wdHIgPQ0KKwkJ
c2VwX3NoYXJlZF9hcmVhX3ZpcnRfdG9fYnVzKCZzZXBfY29udGV4dCAsIG91dF9sbGlfdGFibGVf
cHRyKTsNCisNCisJCSpvdXRfbnVtX2VudHJpZXNfcHRyID0gbnVtX2VudHJpZXNfb3V0X3RhYmxl
Ow0KKwkJKnRhYmxlX2RhdGFfc2l6ZV9wdHIgPSB0YWJsZV9kYXRhX3NpemU7DQorDQorCQllZGJn
KCJTRVAgRHJpdmVyOm91dHB1dCBsbGlfdGFibGVfaW5fcHRyIGlzICUwOHhcbiIsDQorCQkJKHUz
MikqbGxpX3RhYmxlX2luX3B0cik7DQorCQllZGJnKCJTRVAgRHJpdmVyOm91dHB1dCBsbGlfdGFi
bGVfb3V0X3B0ciBpcyAlMDh4XG4iLA0KKwkJCSh1MzIpKmxsaV90YWJsZV9vdXRfcHRyKTsNCisJ
fSBlbHNlIHsNCisJCS8qIHVwZGF0ZSB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgcHJldmlvdXMgaW4g
dGFibGUgKi8NCisJCWluZm9faW5fZW50cnlfcHRyLT5idXNfYWRkcmVzcyA9DQorCQkJc2VwX3No
YXJlZF9hcmVhX3ZpcnRfdG9fYnVzKCZzZXBfY29udGV4dCwNCisJCQkJaW5fbGxpX3RhYmxlX3B0
cik7DQorCQlpbmZvX2luX2VudHJ5X3B0ci0+YmxvY2tfc2l6ZSA9DQorCQkJKChudW1fZW50cmll
c19pbl90YWJsZSkgPDwgMjQpIHwgKHRhYmxlX2RhdGFfc2l6ZSk7DQorDQorCQkvKiB1cGRhdGUg
dGhlIGluZm8gZW50cnkgb2YgdGhlIHByZXZpb3VzIGluIHRhYmxlICovDQorCQlpbmZvX291dF9l
bnRyeV9wdHItPmJ1c19hZGRyZXNzID0NCisJCQlzZXBfc2hhcmVkX2FyZWFfdmlydF90b19idXMo
JnNlcF9jb250ZXh0LA0KKwkJCQlvdXRfbGxpX3RhYmxlX3B0cik7DQorCQlpbmZvX291dF9lbnRy
eV9wdHItPmJsb2NrX3NpemUgPQ0KKwkJCSgobnVtX2VudHJpZXNfb3V0X3RhYmxlKSA8PCAyNCkg
fCAodGFibGVfZGF0YV9zaXplKTsNCisJfQ0KKw0KKwkvKiBzYXZlIHRoZSBwb2ludGVyIHRvIHRo
ZSBpbmZvIGVudHJ5IG9mIHRoZSBjdXJyZW50IHRhYmxlcyAqLw0KKwlpbmZvX2luX2VudHJ5X3B0
ciA9IGluX2xsaV90YWJsZV9wdHIgKyBudW1fZW50cmllc19pbl90YWJsZSAtIDE7DQorCWluZm9f
b3V0X2VudHJ5X3B0ciA9IG91dF9sbGlfdGFibGVfcHRyICsgbnVtX2VudHJpZXNfb3V0X3RhYmxl
IC0gMTsNCisNCisJZWRiZygiU0VQIERyaXZlcjpvdXRwdXQgbnVtX2VudHJpZXNfb3V0X3RhYmxl
IGlzICV4XG4iLA0KKwkJKHUzMiludW1fZW50cmllc19vdXRfdGFibGUpOw0KKwllZGJnKCJTRVAg
RHJpdmVyOm91dHB1dCBpbmZvX2luX2VudHJ5X3B0ciBpcyAleFxuIiwNCisJCSh1MzIpaW5mb19p
bl9lbnRyeV9wdHIpOw0KKwllZGJnKCJTRVAgRHJpdmVyOm91dHB1dCBpbmZvX291dF9lbnRyeV9w
dHIgaXMgJXhcbiIsDQorCQkodTMyKWluZm9fb3V0X2VudHJ5X3B0cik7DQorICB9DQorDQorICAv
KiBwcmludCBpbnB1dCB0YWJsZXMgKi8NCisgIHNlcF9kZWJ1Z19wcmludF9sbGlfdGFibGVzKA0K
Kwkoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqKQ0KKwlzZXBfc2hhcmVkX2FyZWFfYnVzX3RvX3Zp
cnQoJnNlcF9jb250ZXh0ICwgKmxsaV90YWJsZV9pbl9wdHIpLA0KKwkqaW5fbnVtX2VudHJpZXNf
cHRyLA0KKwkqdGFibGVfZGF0YV9zaXplX3B0cik7DQorDQorICAvKiBwcmludCBvdXRwdXQgdGFi
bGVzICovDQorICBzZXBfZGVidWdfcHJpbnRfbGxpX3RhYmxlcygNCisJKHN0cnVjdCBzZXBfbGxp
X2VudHJ5X3QgKikNCisJc2VwX3NoYXJlZF9hcmVhX2J1c190b192aXJ0KCZzZXBfY29udGV4dCAs
ICpsbGlfdGFibGVfb3V0X3B0ciksDQorCSpvdXRfbnVtX2VudHJpZXNfcHRyLA0KKwkqdGFibGVf
ZGF0YV9zaXplX3B0cik7DQorDQorICBkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0tIHNlcF9jb25z
dHJ1Y3RfZG1hX3RhYmxlc19mcm9tX2xsaSBlbmRcbiIpOw0KKw0KKyAgcmV0dXJuIDA7DQorfQ0K
Kw0KKw0KKy8qDQorICBUaGlzIGZ1bmN0aW9uIGxvY2tzIGFsbCB0aGUgcGh5c2ljYWwgcGFnZXMg
b2YgdGhlIGtlcm5lbCB2aXJ0dWFsIGJ1ZmZlcg0KKyAgYW5kIGNvbnN0cnVjdCBhIGJhc2ljIGxs
aSAgYXJyYXksIHdoZXJlIGVhY2ggZW50cnkgaG9sZHMgdGhlIHBoeXNpY2FsDQorICBwYWdlIGFk
ZHJlc3MgYW5kIHRoZSBzaXplIHRoYXQgYXBwbGljYXRpb24gZGF0YSBob2xkcyBpbiB0aGlzIHBo
eXNpY2FsIHBhZ2VzDQorKi8NCitpbnQgc2VwX2xvY2tfa2VybmVsX3BhZ2VzKHUzMgkJa2VybmVs
X3ZpcnRfYWRkciwNCisJCQl1MzIJCWRhdGFfc2l6ZSwNCisJCQlzdHJ1Y3Qgc2VwX2xsaV9lbnRy
eV90CQkqKmxsaV9hcnJheV9wdHIsDQorCQkJaW50IGluX291dF9mbGFnKQ0KKw0KK3sNCisgIC8q
IGVycm9yICovDQorICBpbnQJCQkJZXJyb3I7DQorDQorICAvKiBhcnJheSBvZiBsbGkgKi8NCisg
IHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QJCSpsbGlfYXJyYXk7DQorDQorICAvKiBtYXAgYXJyYXkg
Ki8NCisgIHN0cnVjdCBzZXBfZG1hX21hcCAgKm1hcF9hcnJheTsNCisNCisNCisgIC8qLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tDQorCUNPREUNCisgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
Ki8NCisNCisgIGRiZygiU0VQIERyaXZlcjotLS0tLS0tLT4gc2VwX2xvY2tfa2VybmVsX3BhZ2Vz
IHN0YXJ0XG4iKTsNCisNCisgIGVycm9yID0gMDsNCisNCisgIGVkYmcoIlNFUCBEcml2ZXI6IGtl
cm5lbF92aXJ0X2FkZHIgaXMgJTA4eFxuIiwga2VybmVsX3ZpcnRfYWRkcik7DQorICBlZGJnKCJT
RVAgRHJpdmVyOiBkYXRhX3NpemUgaXMgJXhcbiIsIGRhdGFfc2l6ZSk7DQorDQorICBsbGlfYXJy
YXkgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90KSAqIDEsIEdGUF9BVE9N
SUMpOw0KKwlpZiAoIWxsaV9hcnJheSkgew0KKwkJZWRiZygiU0VQIERyaXZlcjoga21hbGxvYyBm
b3IgbGxpX2FycmF5IGZhaWxlZFxuIik7DQorDQorCQllcnJvciA9IC1FTk9NRU07DQorCQlnb3Rv
IGVuZF9mdW5jdGlvbjsNCisgIH0NCisNCisgIG1hcF9hcnJheSA9IGttYWxsb2Moc2l6ZW9mKHN0
cnVjdCBzZXBfZG1hX21hcCkgKiAxICwgR0ZQX0FUT01JQyk7DQorCWlmICghbWFwX2FycmF5KSB7
DQorCQllZGJnKCJTRVAgRHJpdmVyOiBrbWFsbG9jIGZvciBtYXBfYXJyYXkgZmFpbGVkXG4iKTsN
CisJCWVycm9yID0gLUVOT01FTTsNCisJCWdvdG8gZW5kX2Z1bmN0aW9uX3dpdGhfZXJyb3I7DQor
ICB9DQorDQorICBtYXBfYXJyYXlbMF0uZG1hX2FkZHIgPQ0KKyAgICAgIGRtYV9tYXBfc2luZ2xl
KHNlcF9jb250ZXh0LmRldl9wdHIgLA0KKyAgICAgICh2b2lkICopa2VybmVsX3ZpcnRfYWRkciwN
CisgICAgICBkYXRhX3NpemUsDQorICAgICAgRE1BX0JJRElSRUNUSU9OQUwpOw0KKyAgbWFwX2Fy
cmF5WzBdLnNpemUgPSBkYXRhX3NpemU7DQorDQorDQorICAvKiBzZXQgdGhlIHN0YXJ0IGFkZHJl
c3Mgb2YgdGhlIGZpcnN0IHBhZ2UgLSBhcHAgZGF0YSBtYXkgc3RhcnQgbm90IGF0DQorICB0aGUg
YmVnaW5uaW5nIG9mIHRoZSBwYWdlICovDQorICBsbGlfYXJyYXlbMF0uYnVzX2FkZHJlc3MgPSAo
dTMyKW1hcF9hcnJheVswXS5kbWFfYWRkcjsNCisJbGxpX2FycmF5WzBdLmJsb2NrX3NpemUgPSBt
YXBfYXJyYXlbMF0uc2l6ZTsNCisNCisgIC8qIGRlYnVnIHByaW50ICovDQorICBlZGJnKCJsbGlf
YXJyYXlbMF0uYnVzX2FkZHJlc3MgaXMgJTA4eCwgXA0KKyAgICAgIGxsaV9hcnJheVswXS5ibG9j
a19zaXplIGlzICV4XG4iLA0KKyAgICBsbGlfYXJyYXlbMF0uYnVzX2FkZHJlc3MsDQorICAgIGxs
aV9hcnJheVswXS5ibG9ja19zaXplKTsNCisNCisgIC8qIHNldCB0aGUgb3V0cHV0IHBhcmFtZXRl
cnMgKi8NCisJaWYgKGluX291dF9mbGFnID09IFNFUF9EUklWRVJfSU5fRkxBRykgew0KKwkJKmxs
aV9hcnJheV9wdHIgPSBsbGlfYXJyYXk7DQorCQlzZXBfY29udGV4dC5pbl9udW1fcGFnZXMgPSAx
Ow0KKwkJc2VwX2NvbnRleHQuaW5fcGFnZV9hcnJheSA9IDA7DQorCQlzZXBfY29udGV4dC5pbl9t
YXBfYXJyYXkgPSBtYXBfYXJyYXk7DQorCQlzZXBfY29udGV4dC5pbl9tYXBfbnVtX2VudHJpZXMg
PSAxOw0KKwl9IGVsc2Ugew0KKwkJKmxsaV9hcnJheV9wdHIgPSBsbGlfYXJyYXk7DQorCQlzZXBf
Y29udGV4dC5vdXRfbnVtX3BhZ2VzID0gMTsNCisJCXNlcF9jb250ZXh0Lm91dF9wYWdlX2FycmF5
ID0gMDsNCisJCXNlcF9jb250ZXh0Lm91dF9tYXBfYXJyYXkgPSBtYXBfYXJyYXk7DQorCQlzZXBf
Y29udGV4dC5vdXRfbWFwX251bV9lbnRyaWVzID0gMTsNCisgIH0NCisNCisgIGdvdG8gZW5kX2Z1
bmN0aW9uOw0KKw0KK2VuZF9mdW5jdGlvbl93aXRoX2Vycm9yOg0KKw0KKyAga2ZyZWUobGxpX2Fy
cmF5KTsNCisNCitlbmRfZnVuY3Rpb246DQorDQorICBkYmcoIlNFUCBEcml2ZXI6PC0tLS0tLS0t
IHNlcF9sb2NrX2tlcm5lbF9wYWdlcyBlbmRcbiIpOw0KKw0KKyAgcmV0dXJuIDA7DQorfQ0KKw0K
Ky8qDQorICBUaGlzIGZ1bmN0aW9uIGxvY2tzIGFsbCB0aGUgcGh5c2ljYWwgcGFnZXMgb2YgdGhl
IGFwcGxpY2F0aW9uIHZpcnR1YWwgYnVmZmVyDQorICBhbmQgY29uc3RydWN0IGEgYmFzaWMgbGxp
ICBhcnJheSwgd2hlcmUgZWFjaCBlbnRyeSBob2xkcyB0aGUgcGh5c2ljYWwgcGFnZQ0KKyAgYWRk
cmVzcyBhbmQgdGhlIHNpemUgdGhhdCBhcHBsaWNhdGlvbiBkYXRhIGhvbGRzIGluIHRoaXMgcGh5
c2ljYWwgcGFnZXMNCisqLw0KK2ludCBzZXBfbG9ja191c2VyX3BhZ2VzKHUzMgkJYXBwX3ZpcnRf
YWRkciwNCisJCQl1MzIJCWRhdGFfc2l6ZSwNCisJCQlzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90CQkq
KmxsaV9hcnJheV9wdHIsDQorCQkJaW50IGluX291dF9mbGFnKQ0KKw0KK3sNCisgIC8qIGVycm9y
ICovDQorICBpbnQJCQkJZXJyb3I7DQorDQorICAvKiB0aGUgdGhlIHBhZ2Ugb2YgdGhlIGVuZCBh
ZGRyZXNzIG9mIHRoZSB1c2VyIHNwYWNlIGJ1ZmZlciAqLw0KKyAgdTMyCQllbmRfcGFnZTsNCisN
CisgIC8qIHRoZSBwYWdlIG9mIHRoZSBzdGFydCBhZGRyZXNzIG9mIHRoZSB1c2VyIHNwYWNlIGJ1
ZmZlciAqLw0KKyAgdTMyCQlzdGFydF9wYWdlOw0KKw0KKyAgLyogdGhlIHJhbmdlIGluIHBhZ2Vz
ICovDQorICB1MzIJCW51bV9wYWdlczsNCisNCisgIC8qIGFycmF5IG9mIHBvaW50ZXJzIG90IHBh
Z2UgKi8NCisgIHN0cnVjdCBwYWdlCQkqKnBhZ2VfYXJyYXk7DQorDQorICAvKiBhcnJheSBvZiBs
bGkgKi8NCisgIHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QJCSpsbGlfYXJyYXk7DQorDQorICAvKiBt
YXAgYXJyYXkgKi8NCisgIHN0cnVjdCBzZXBfZG1hX21hcCAgKm1hcF9hcnJheTsNCisNCisgIC8q
IGNvdW50ICovDQorICB1MzIJCWNvdW50Ow0KKw0KKyAgLyogcmVzdWx0ICovDQorICBpbnQJCQkJ
cmVzdWx0Ow0KKw0KKyAgLyotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCisJQ09ERQ0KKyAgLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0qLw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOi0tLS0tLS0t
PiBzZXBfbG9ja191c2VyX3BhZ2VzIHN0YXJ0XG4iKTsNCisNCisgIGVycm9yID0gMDsNCisNCisg
IC8qIHNldCBzdGFydCBhbmQgZW5kIHBhZ2VzICBhbmQgbnVtIHBhZ2VzICovDQorICBlbmRfcGFn
ZSA9IChhcHBfdmlydF9hZGRyICsgZGF0YV9zaXplIC0gMSkgPj4gUEFHRV9TSElGVDsNCisgIHN0
YXJ0X3BhZ2UgPSBhcHBfdmlydF9hZGRyID4+IFBBR0VfU0hJRlQ7DQorICBudW1fcGFnZXMgPSBl
bmRfcGFnZSAtIHN0YXJ0X3BhZ2UgKyAxOw0KKw0KKyAgZWRiZygiU0VQIERyaXZlcjogYXBwX3Zp
cnRfYWRkciBpcyAlMDh4XG4iLCBhcHBfdmlydF9hZGRyKTsNCisgIGVkYmcoIlNFUCBEcml2ZXI6
IGRhdGFfc2l6ZSBpcyAleFxuIiwgZGF0YV9zaXplKTsNCisgIGVkYmcoIlNFUCBEcml2ZXI6IHN0
YXJ0X3BhZ2UgaXMgJXhcbiIsIHN0YXJ0X3BhZ2UpOw0KKyAgZWRiZygiU0VQIERyaXZlcjogZW5k
X3BhZ2UgaXMgJXhcbiIsIGVuZF9wYWdlKTsNCisgIGVkYmcoIlNFUCBEcml2ZXI6IG51bV9wYWdl
cyBpcyAleFxuIiwgbnVtX3BhZ2VzKTsNCisNCisgIGVkYmcoIlNFUCBEcml2ZXI6IHN0YXJ0aW5n
IHBhZ2VfYXJyYXkgbWFsbG9jXG4iKTsNCisNCisgIC8qIGFsbG9jYXRlIGFycmF5IG9mIHBhZ2Vz
IHN0cnVjdHVyZSBwb2ludGVycyAqLw0KKyAgcGFnZV9hcnJheSA9IGttYWxsb2Moc2l6ZW9mKHN0
cnVjdCBwYWdlICopICogbnVtX3BhZ2VzLCBHRlBfQVRPTUlDKTsNCisJaWYgKCFwYWdlX2FycmF5
KSB7DQorCQllZGJnKCJTRVAgRHJpdmVyOiBrbWFsbG9jIGZvciBwYWdlX2FycmF5IGZhaWxlZFxu
Iik7DQorDQorCQllcnJvciA9IC1FTk9NRU07DQorCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisgIH0N
CisNCisJbWFwX2FycmF5ID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IHNlcF9kbWFfbWFwKSAqIG51
bV9wYWdlcywgR0ZQX0FUT01JQyk7DQorCWlmICghbWFwX2FycmF5KSB7DQorCQllZGJnKCJTRVAg
RHJpdmVyOiBrbWFsbG9jIGZvciBtYXBfYXJyYXkgZmFpbGVkXG4iKTsNCisJCWVycm9yID0gLUVO
T01FTTsNCisJCWdvdG8gZW5kX2Z1bmN0aW9uX3dpdGhfZXJyb3IxOw0KKyAgfQ0KKw0KKwlsbGlf
YXJyYXkgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90KSAqIG51bV9wYWdl
cywNCisJCQkJR0ZQX0FUT01JQyk7DQorCWlmICghbGxpX2FycmF5KSB7DQorCQllZGJnKCJTRVAg
RHJpdmVyOiBrbWFsbG9jIGZvciBsbGlfYXJyYXkgZmFpbGVkXG4iKTsNCisNCisJCWVycm9yID0g
LUVOT01FTTsNCisJCWdvdG8gZW5kX2Z1bmN0aW9uX3dpdGhfZXJyb3IyOw0KKyAgfQ0KKw0KKwll
ZGJnKCJTRVAgRHJpdmVyOiBzdGFydGluZyBnZXRfdXNlcl9wYWdlc1xuIik7DQorDQorCS8qIGNv
bnZlcnQgdGhlIGFwcGxpY2F0aW9uIHZpcnR1YWwgYWRkcmVzcyBpbnRvIGEgc2V0IG9mIHBoeXNp
Y2FsICovDQorCWRvd25fcmVhZCgmY3VycmVudC0+bW0tPm1tYXBfc2VtKTsNCisJcmVzdWx0ID0g
Z2V0X3VzZXJfcGFnZXMoY3VycmVudCwNCisJCQkJCQljdXJyZW50LT5tbSwNCisJCQkJCQlhcHBf
dmlydF9hZGRyLA0KKwkJCQkJCW51bV9wYWdlcywNCisJCQkJCQkxLA0KKwkJCQkJCTAsDQorCQkJ
CQkJcGFnZV9hcnJheSwNCisJCQkJCQkwKTsNCisgIHVwX3JlYWQoJmN1cnJlbnQtPm1tLT5tbWFw
X3NlbSk7DQorDQorICAvKiBjaGVjayB0aGUgbnVtYmVyIG9mIHBhZ2VzIGxvY2tlZCAtIGlmIG5v
dCBhbGwgdGhlbiBleGl0IHdpdGggZXJyb3IgKi8NCisJaWYgKHJlc3VsdCAhPSBudW1fcGFnZXMp
IHsNCisJCWVkYmcoIlNFUCBEcml2ZXI6IG5vdCBhbGwgcGFnZXMgbG9ja2VkIGJ5IGdldF91c2Vy
X3BhZ2VzXG4iKTsNCisNCisJCWVycm9yID0gLUVOT01FTTsNCisJCWdvdG8gZW5kX2Z1bmN0aW9u
X3dpdGhfZXJyb3IzOw0KKyAgfQ0KKw0KKyAgZWRiZygiU0VQIERyaXZlcjogZ2V0X3VzZXJfcGFn
ZXMgc3VjY2VlZGVkXG4iKTsNCisNCisgIC8qIGZpbGwgdGhlIGFycmF5IHVzaW5nIHBhZ2UgYXJy
YXkgZGF0YSBhbmQgbWFwIHRoZSBwYWdlcyAtIHRoaXMgYWN0aW9uDQorICAgICAgd2lsbCBhbHNv
IGZsdXNoIHRoZSBjYWNoZSBhcyBuZWVkZWQgKi8NCisJZm9yIChjb3VudCA9IDA7IGNvdW50IDwg
bnVtX3BhZ2VzOyBjb3VudCsrKSB7DQorCQkvKiBmaWxsIHRoZSBtYXAgYXJyYXkgKi8NCisJCW1h
cF9hcnJheVtjb3VudF0uZG1hX2FkZHIgPQ0KKwkJCWRtYV9tYXBfcGFnZShzZXBfY29udGV4dC5k
ZXZfcHRyLCBwYWdlX2FycmF5W2NvdW50XSwNCisJCQkwLA0KKwkJCVBBR0VfU0laRSwNCisJCQlE
TUFfQklESVJFQ1RJT05BTCk7DQorCQltYXBfYXJyYXlbY291bnRdLnNpemUgPSBQQUdFX1NJWkU7
DQorDQorCQkvKiBmaWxsIHRoZSBsbGkgYXJyYXkgZW50cnkgKi8NCisJCWxsaV9hcnJheVtjb3Vu
dF0uYnVzX2FkZHJlc3MgPSAodTMyKW1hcF9hcnJheVtjb3VudF0uZG1hX2FkZHI7DQorCQlsbGlf
YXJyYXlbY291bnRdLmJsb2NrX3NpemUgPSBQQUdFX1NJWkU7DQorDQorCQllZGJnKCJsbGlfYXJy
YXlbJXhdLmJ1c19hZGRyZXNzIGlzICUwOHgsIFwNCisJCQlsbGlfYXJyYXlbJXhdLmJsb2NrX3Np
emUgaXMgJXhcbiIsDQorCQkJY291bnQsIGxsaV9hcnJheVtjb3VudF0uYnVzX2FkZHJlc3MsDQor
CQkJY291bnQsDQorCQkJbGxpX2FycmF5W2NvdW50XS5ibG9ja19zaXplKTsNCisgIH0NCisNCisg
IC8qIGNoZWNrIHRoZSBvZmZzZXQgZm9yIHRoZSBmaXJzdCBwYWdlIC0NCisgICAgICBkYXRhIG1h
eSBzdGFydCBub3QgYXQgdGhlIGJlZ2lubmluZyBvZiB0aGUgcGFnZSAqLw0KKyAgbGxpX2FycmF5
WzBdLmJ1c19hZGRyZXNzID0NCisgICAgICBsbGlfYXJyYXlbMF0uYnVzX2FkZHJlc3MgKyAoYXBw
X3ZpcnRfYWRkciAmICh+UEFHRV9NQVNLKSk7DQorICAvKiBjaGVjayB0aGF0IG5vdCBhbGwgdGhl
IGRhdGEgaXMgaW4gdGhlIGZpcnN0IHBhZ2Ugb25seSAqLw0KKwlpZiAoKFBBR0VfU0laRSAtIChh
cHBfdmlydF9hZGRyICYgKH5QQUdFX01BU0spKSkgPj0gZGF0YV9zaXplKQ0KKwkJbGxpX2FycmF5
WzBdLmJsb2NrX3NpemUgPSBkYXRhX3NpemU7DQorCWVsc2UNCisJCWxsaV9hcnJheVswXS5ibG9j
a19zaXplID0NCisJCQlQQUdFX1NJWkUgLSAoYXBwX3ZpcnRfYWRkciAmICh+UEFHRV9NQVNLKSk7
DQorDQorICBlZGJnKCJsbGlfYXJyYXlbMF0uYnVzX2FkZHJlc3MgaXMgJTA4eCwgXA0KKyAgICBs
bGlfYXJyYXlbMF0uYmxvY2tfc2l6ZSBpcyAleFxuIiwNCisgICAgbGxpX2FycmF5W2NvdW50XS5i
dXNfYWRkcmVzcywNCisgICAgbGxpX2FycmF5W2NvdW50XS5ibG9ja19zaXplKTsNCisNCisgIC8q
IGNoZWNrIHRoZSBzaXplIG9mIHRoZSBsYXN0IHBhZ2UgKi8NCisJaWYgKG51bV9wYWdlcyA+IDEp
IHsNCisJCWxsaV9hcnJheVtudW1fcGFnZXMgLSAxXS5ibG9ja19zaXplID0NCisJCQkoYXBwX3Zp
cnRfYWRkciArIGRhdGFfc2l6ZSkgJiAoflBBR0VfTUFTSyk7DQorCQllZGJnKCJsbGlfYXJyYXlb
JXhdLmJ1c19hZGRyZXNzIGlzICUwOHgsIFwNCisJCQlsbGlfYXJyYXlbJXhdLmJsb2NrX3NpemUg
aXMgJXhcbiIsDQorCQkJbnVtX3BhZ2VzIC0gMSwgbGxpX2FycmF5W2NvdW50XS5idXNfYWRkcmVz
cywNCisJCQludW1fcGFnZXMgLSAxLA0KKwkJCWxsaV9hcnJheVtjb3VudF0uYmxvY2tfc2l6ZSk7
DQorICB9DQorDQorICAvKiBzZXQgb3V0cHV0IHBhcmFtcyBhY29yZGluZyB0byB0aGUgaW5fb3V0
IGZsYWcgKi8NCisJaWYgKGluX291dF9mbGFnID09IFNFUF9EUklWRVJfSU5fRkxBRykgew0KKwkJ
KmxsaV9hcnJheV9wdHIgPSBsbGlfYXJyYXk7DQorCQlzZXBfY29udGV4dC5pbl9udW1fcGFnZXMg
PSBudW1fcGFnZXM7DQorCQlzZXBfY29udGV4dC5pbl9wYWdlX2FycmF5ID0gcGFnZV9hcnJheTsN
CisJCXNlcF9jb250ZXh0LmluX21hcF9hcnJheSA9IG1hcF9hcnJheTsNCisJCXNlcF9jb250ZXh0
LmluX21hcF9udW1fZW50cmllcyA9IG51bV9wYWdlczsNCisJfSBlbHNlIHsNCisJCSpsbGlfYXJy
YXlfcHRyID0gbGxpX2FycmF5Ow0KKwkJc2VwX2NvbnRleHQub3V0X251bV9wYWdlcyA9IG51bV9w
YWdlczsNCisJCXNlcF9jb250ZXh0Lm91dF9wYWdlX2FycmF5ID0gcGFnZV9hcnJheTsNCisJCXNl
cF9jb250ZXh0Lm91dF9tYXBfYXJyYXkgPSBtYXBfYXJyYXk7DQorCQlzZXBfY29udGV4dC5vdXRf
bWFwX251bV9lbnRyaWVzID0gbnVtX3BhZ2VzOw0KKyAgfQ0KKw0KKyAgZ290byBlbmRfZnVuY3Rp
b247DQorDQorZW5kX2Z1bmN0aW9uX3dpdGhfZXJyb3IzOg0KKw0KKyAgLyogZnJlZSBsbGkgYXJy
YXkgKi8NCisgIGtmcmVlKGxsaV9hcnJheSk7DQorDQorZW5kX2Z1bmN0aW9uX3dpdGhfZXJyb3Iy
Og0KKw0KKyAga2ZyZWUobWFwX2FycmF5KTsNCisNCitlbmRfZnVuY3Rpb25fd2l0aF9lcnJvcjE6
DQorDQorICAvKiBmcmVlIHBhZ2UgYXJyYXkgKi8NCisgIGtmcmVlKHBhZ2VfYXJyYXkpOw0KKw0K
K2VuZF9mdW5jdGlvbjoNCisNCisgIGRiZygiU0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX2xvY2tf
dXNlcl9wYWdlcyBlbmRcbiIpOw0KKw0KKyAgcmV0dXJuIDA7DQorfQ0KKw0KKy8qDQorICBUaGlz
IGZ1bmN0aW9uIHByZXBhcmVzIG9ubHkgaW5wdXQgRE1BIHRhYmxlIGZvciBzeW5ocm9uaWMgc3lt
bWV0cmljDQorICBvcGVyYXRpb25zIChIQVNIKQ0KKyovDQoraW50IHNlcF9wcmVwYXJlX2lucHV0
X2RtYV90YWJsZSh1bnNpZ25lZCBsb25nCWFwcF92aXJ0X2FkZHIsDQorCQkJCXUzMglkYXRhX3Np
emUsDQorCQkJCXUzMglibG9ja19zaXplLA0KKwkJCQlkbWFfYWRkcl90CSpsbGlfdGFibGVfcHRy
LA0KKwkJCQl1MzIJKm51bV9lbnRyaWVzX3B0ciwNCisJCQkJdTMyCSp0YWJsZV9kYXRhX3NpemVf
cHRyLA0KKwkJCQlib29sIGlzS2VybmVsVmlydHVhbEFkZHJlc3MpDQorDQorew0KKyAgLyogcG9p
bnRlciB0byB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgdGFibGUgLSB0aGUgbGFzdCBlbnRyeSAqLw0K
KyAgc3RydWN0IHNlcF9sbGlfZW50cnlfdAkJKmluZm9fZW50cnlfcHRyOw0KKw0KKyAgLyogYXJy
YXkgb2YgcG9pbnRlcnMgb3QgcGFnZSAqLw0KKyAgc3RydWN0IHNlcF9sbGlfZW50cnlfdAkJKmxs
aV9hcnJheV9wdHI7DQorDQorICAvKiBwb2ludHMgdG8gdGhlIGZpcnN0IGVudHJ5IHRvIGJlIHBy
b2Nlc3NlZCBpbiB0aGUgbGxpX2luX2FycmF5ICovDQorICB1MzIJCWN1cnJlbnRfZW50cnk7DQor
DQorICAvKiBudW0gZW50cmllcyBpbiB0aGUgdmlydHVhbCBidWZmZXIgKi8NCisgIHUzMgkJc2Vw
X2xsaV9lbnRyaWVzOw0KKw0KKyAgLyogbGxpIHRhYmxlIHBvaW50ZXIgKi8NCisgIHN0cnVjdCBz
ZXBfbGxpX2VudHJ5X3QJCSppbl9sbGlfdGFibGVfcHRyOw0KKw0KKyAgLyogdGhlIHRvdGFsIGRh
dGEgaW4gb25lIHRhYmxlICovDQorICB1MzIJCXRhYmxlX2RhdGFfc2l6ZTsNCisNCisgIC8qIG51
bWJlciBvZiBlbnRyaWVzIGluIGxsaSB0YWJsZSAqLw0KKyAgdTMyCQludW1fZW50cmllc19pbl90
YWJsZTsNCisNCisgIC8qIG5leHQgdGFibGUgYWRkcmVzcyAqLw0KKyAgdTMyCQlsbGlfdGFibGVf
YWxsb2NfYWRkcjsNCisNCisgIC8qIHJlc3VsdCAqLw0KKyAgdTMyCQlyZXN1bHQ7DQorDQorICAv
Ki0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLSovDQorDQorICBkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9wcmVwYXJlX2lu
cHV0X2RtYV90YWJsZSBzdGFydFxuIik7DQorDQorICBlZGJnKCJTRVAgRHJpdmVyOmRhdGFfc2l6
ZSBpcyAleFxuIiwgZGF0YV9zaXplKTsNCisgIGVkYmcoIlNFUCBEcml2ZXI6YmxvY2tfc2l6ZSBp
cyAleFxuIiwgYmxvY2tfc2l6ZSk7DQorDQorICAvKiBpbml0aWFsaXplIHRoZSBwYWdlcyBwb2lu
dGVycyAqLw0KKyAgc2VwX2NvbnRleHQuaW5fcGFnZV9hcnJheSA9IDA7DQorICBzZXBfY29udGV4
dC5pbl9udW1fcGFnZXMgPSAwOw0KKw0KKyAgLyogc2V0IHRoZSBrZXJuZWwgYWRkcmVzcyBmb3Ig
Zmlyc3QgdGFibGUgdG8gYmUgYWxsb2NhdGVkICovDQorICBsbGlfdGFibGVfYWxsb2NfYWRkciA9
ICh1MzIpKHNlcF9jb250ZXh0LnNoYXJlZF9hcmVhX3ZpcnRfYWRkciArDQorCQkJU0VQX0RSSVZF
Ul9TWU5DSFJPTklDX0RNQV9UQUJMRVNfQVJFQV9PRkZTRVRfSU5fQllURVMgKw0KKwkJCXNlcF9j
b250ZXh0Lm51bV9sbGlfdGFibGVzX2NyZWF0ZWQgKg0KKwkJCXNpemVvZihzdHJ1Y3Qgc2VwX2xs
aV9lbnRyeV90KSAqDQorICAgICAgU0VQX0RSSVZFUl9FTlRSSUVTX1BFUl9UQUJMRV9JTl9TRVAp
Ow0KKw0KKyAgaWYgKGRhdGFfc2l6ZSA9PSAwKSB7DQorDQorCS8qIHNwZWNpYWwgY2FzZSAgLSBj
cmVhdGUgbWVwdHUgdGFibGUgLSAyIGVudHJpZXMsIHplcm8gZGF0YSAqLw0KKwlzZXBfcHJlcGFy
ZV9lbXB0eV9sbGlfdGFibGUobGxpX3RhYmxlX3B0ciwNCisgICAgICBudW1fZW50cmllc19wdHIs
DQorICAgICAgdGFibGVfZGF0YV9zaXplX3B0cik7DQorDQorCWdvdG8gZW5kX2Z1bmN0aW9uOw0K
KyAgfQ0KKw0KKyAgLyogY2hlY2sgaWYgdGhlIHBhZ2VzIGFyZSBpbiBLZXJuZWwgVmlydHVhbCBB
ZGRyZXNzIGxheW91dCAqLw0KKyAgaWYgKGlzS2VybmVsVmlydHVhbEFkZHJlc3MgPT0gdHJ1ZSkN
CisJLyogbG9jayB0aGUgcGFnZXMgb2YgdGhlIGtlcm5lbCBidWZmZXIgYW5kIHRyYW5zbGF0ZSB0
aGVtIHRvIHBhZ2VzICovDQorCXJlc3VsdCA9IHNlcF9sb2NrX2tlcm5lbF9wYWdlcyhhcHBfdmly
dF9hZGRyLA0KKwkJCQkJZGF0YV9zaXplLA0KKwkJCQkJJmxsaV9hcnJheV9wdHIsDQorCQkJCQlT
RVBfRFJJVkVSX0lOX0ZMQUcpOw0KKyAgZWxzZQ0KKwkvKiBsb2NrIHRoZSBwYWdlcyBvZiB0aGUg
dXNlciBidWZmZXIgYW5kIHRyYW5zbGF0ZSB0aGVtIHRvIHBhZ2VzICovDQorCXJlc3VsdCA9IHNl
cF9sb2NrX3VzZXJfcGFnZXMoYXBwX3ZpcnRfYWRkciwNCisJCQkJZGF0YV9zaXplLA0KKwkJCQkm
bGxpX2FycmF5X3B0ciwNCisJCQkJU0VQX0RSSVZFUl9JTl9GTEFHKTsNCisNCisgIGlmIChyZXN1
bHQpDQorCXJldHVybiByZXN1bHQ7DQorDQorICBlZGJnKCJTRVAgRHJpdmVyOm91dHB1dCBzZXBf
aW5fbnVtX3BhZ2VzIGlzICV4XG4iLA0KKyAgICBzZXBfY29udGV4dC5pbl9udW1fcGFnZXMpOw0K
Kw0KKyAgY3VycmVudF9lbnRyeSA9IDA7DQorICBpbmZvX2VudHJ5X3B0ciA9IDA7DQorICBzZXBf
bGxpX2VudHJpZXMgPSBzZXBfY29udGV4dC5pbl9udW1fcGFnZXM7DQorDQorICAvKiBsb29wIHRp
bGwgYWxsIHRoZSBlbnRyaWVzIGluIGluIGFycmF5IGFyZSBub3QgcHJvY2Vzc2VkICovDQorICB3
aGlsZSAoY3VycmVudF9lbnRyeSA8IHNlcF9sbGlfZW50cmllcykgew0KKwkvKiBzZXQgdGhlIG5l
dyBpbnB1dCBhbmQgb3V0cHV0IHRhYmxlcyAqLw0KKwlpbl9sbGlfdGFibGVfcHRyID0gKHN0cnVj
dCBzZXBfbGxpX2VudHJ5X3QgKilsbGlfdGFibGVfYWxsb2NfYWRkcjsNCisNCisJbGxpX3RhYmxl
X2FsbG9jX2FkZHIgKz0gc2l6ZW9mKHN0cnVjdCBzZXBfbGxpX2VudHJ5X3QpICoNCisJCQkJU0VQ
X0RSSVZFUl9FTlRSSUVTX1BFUl9UQUJMRV9JTl9TRVA7DQorDQorCS8qIHVwZGF0ZSB0aGUgbnVt
YmVyIG9mIGNyZWF0ZWQgdGFibGVzICovDQorCXNlcF9jb250ZXh0Lm51bV9sbGlfdGFibGVzX2Ny
ZWF0ZWQrKzsNCisNCisJLyogY2FsY3VsYXRlIHRoZSBtYXhpbXVtIHNpemUgb2YgZGF0YSBmb3Ig
aW5wdXQgdGFibGUgKi8NCisJdGFibGVfZGF0YV9zaXplID0gc2VwX2NhbGN1bGF0ZV9sbGlfdGFi
bGVfbWF4X3NpemUoDQorCQkmbGxpX2FycmF5X3B0cltjdXJyZW50X2VudHJ5XSwNCisJCShzZXBf
bGxpX2VudHJpZXMgLSBjdXJyZW50X2VudHJ5KSk7DQorDQorCS8qIG5vdyBjYWxjdWxhdGUgdGhl
IHRhYmxlIHNpemUgc28gdGhhdCBpdCB3aWxsIGJlIG1vZHVsZSBibG9jayBzaXplICovDQorCXRh
YmxlX2RhdGFfc2l6ZSA9ICh0YWJsZV9kYXRhX3NpemUgLyBibG9ja19zaXplKSAqIGJsb2NrX3Np
emU7DQorDQorCWVkYmcoIlNFUCBEcml2ZXI6b3V0cHV0IHRhYmxlX2RhdGFfc2l6ZSBpcyAleFxu
IiwgdGFibGVfZGF0YV9zaXplKTsNCisNCisJLyogY29uc3RydWN0IGlucHV0IGxsaSB0YWJsZSAq
Lw0KKwlzZXBfYnVpbGRfbGxpX3RhYmxlKCZsbGlfYXJyYXlfcHRyW2N1cnJlbnRfZW50cnldLA0K
KwkJCQkJCWluX2xsaV90YWJsZV9wdHIsDQorCQkJCQkJJmN1cnJlbnRfZW50cnksDQorCQkJCQkJ
Jm51bV9lbnRyaWVzX2luX3RhYmxlLA0KKwkJCQkJCXRhYmxlX2RhdGFfc2l6ZSk7DQorDQorCWlm
IChpbmZvX2VudHJ5X3B0ciA9PSAwKSB7DQorCQkvKiBzZXQgdGhlIG91dHB1dCBwYXJhbWV0ZXJz
IHRvIHBoeXNpY2FsIGFkZHJlc3NlcyAqLw0KKwkJKmxsaV90YWJsZV9wdHIgPSBzZXBfc2hhcmVk
X2FyZWFfdmlydF90b19idXMoJnNlcF9jb250ZXh0LA0KKwkJCWluX2xsaV90YWJsZV9wdHIpOw0K
KwkJKm51bV9lbnRyaWVzX3B0ciA9IG51bV9lbnRyaWVzX2luX3RhYmxlOw0KKwkJKnRhYmxlX2Rh
dGFfc2l6ZV9wdHIgPSB0YWJsZV9kYXRhX3NpemU7DQorDQorCWVkYmcoIlNFUCBEcml2ZXI6b3V0
cHV0IGxsaV90YWJsZV9pbl9wdHIgaXMgJTA4eFxuIiwNCisJCSh1MzIpKmxsaV90YWJsZV9wdHIp
Ow0KKwl9IGVsc2Ugew0KKwkgIC8qIHVwZGF0ZSB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgcHJldmlv
dXMgaW4gdGFibGUgKi8NCisgICAgaW5mb19lbnRyeV9wdHItPmJ1c19hZGRyZXNzID0gc2VwX3No
YXJlZF9hcmVhX3ZpcnRfdG9fYnVzKCZzZXBfY29udGV4dCwNCisJCQkJaW5fbGxpX3RhYmxlX3B0
cik7DQorICAgIGluZm9fZW50cnlfcHRyLT5ibG9ja19zaXplID0gKChudW1fZW50cmllc19pbl90
YWJsZSkgPDwgMjQpIHwNCisJCQkJKHRhYmxlX2RhdGFfc2l6ZSk7DQorCX0NCisNCisJLyogc2F2
ZSB0aGUgcG9pbnRlciB0byB0aGUgaW5mbyBlbnRyeSBvZiB0aGUgY3VycmVudCB0YWJsZXMgKi8N
CisJaW5mb19lbnRyeV9wdHIgPSBpbl9sbGlfdGFibGVfcHRyICsgbnVtX2VudHJpZXNfaW5fdGFi
bGUgLSAxOw0KKyAgfQ0KKw0KKyAgLyogcHJpbnQgaW5wdXQgdGFibGVzICovDQorICBzZXBfZGVi
dWdfcHJpbnRfbGxpX3RhYmxlcygoc3RydWN0IHNlcF9sbGlfZW50cnlfdCAqKQ0KKyAgICBzZXBf
c2hhcmVkX2FyZWFfYnVzX3RvX3ZpcnQoJnNlcF9jb250ZXh0LCAqbGxpX3RhYmxlX3B0ciksDQor
ICAgICpudW1fZW50cmllc19wdHIsDQorICAgICp0YWJsZV9kYXRhX3NpemVfcHRyKTsNCisNCisg
IC8qIHRoZSBhcnJheSBvZiB0aGUgcGFnZXMgKi8NCisgIGtmcmVlKGxsaV9hcnJheV9wdHIpOw0K
Kw0KK2VuZF9mdW5jdGlvbjoNCisNCisgIGRiZygiU0VQIERyaXZlcjo8LS0tLS0tLS0gc2VwX3By
ZXBhcmVfaW5wdXRfZG1hX3RhYmxlIGVuZFxuIik7DQorDQorICByZXR1cm4gMDsNCisNCit9DQor
DQorLyoNCisgIFRoaXMgZnVuY3Rpb24gYnVpbGRzIGlucHV0IGFuZCBvdXRwdXQgRE1BIHRhYmxl
cyBmb3Igc3luaHJvbmljDQorICBzeW1tZXRyaWMgb3BlcmF0aW9ucyAoQUVTLCBERVMsIEhBU0gp
LiBJdCBhbHNvIGNoZWNrcyB0aGF0IGVhY2ggdGFibGUNCisgIGlzIG9mIHRoZSBtb2R1bGFyIGJs
b2NrIHNpemUNCisqLw0KK2ludCBzZXBfcHJlcGFyZV9pbnB1dF9vdXRwdXRfZG1hX3RhYmxlKHVu
c2lnbmVkIGxvbmcgYXBwX3ZpcnRfaW5fYWRkciwNCisJCQkJCXVuc2lnbmVkIGxvbmcJYXBwX3Zp
cnRfb3V0X2FkZHIsDQorCQkJCQl1MzIJZGF0YV9zaXplLA0KKwkJCQkJdTMyCWJsb2NrX3NpemUs
DQorCQkJCQlkbWFfYWRkcl90CSpsbGlfdGFibGVfaW5fcHRyLA0KKwkJCQkJZG1hX2FkZHJfdAkq
bGxpX3RhYmxlX291dF9wdHIsDQorCQkJCQl1MzIJKmluX251bV9lbnRyaWVzX3B0ciwNCisJCQkJ
CXUzMgkqb3V0X251bV9lbnRyaWVzX3B0ciwNCisJCQkJCXUzMgkqdGFibGVfZGF0YV9zaXplX3B0
ciwNCisJCQkJCWJvb2wJaXNLZXJuZWxWaXJ0dWFsQWRkcmVzcykNCisNCit7DQorICAvKiBhcnJh
eSBvZiBwb2ludGVycyBvZiBwYWdlICovDQorICBzdHJ1Y3Qgc2VwX2xsaV9lbnRyeV90CQkqbGxp
X2luX2FycmF5Ow0KKw0KKyAgLyogYXJyYXkgb2YgcG9pbnRlcnMgb2YgcGFnZSAqLw0KKyAgc3Ry
dWN0IHNlcF9sbGlfZW50cnlfdAkJKmxsaV9vdXRfYXJyYXk7DQorDQorICAvKiByZXN1bHQgKi8N
CisgIGludAkJCQlyZXN1bHQ7DQorDQorDQorICAvKi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
KwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovDQorDQorICBkYmcoIlNFUCBE
cml2ZXI6LS0tLS0tLS0+IHNlcF9wcmVwYXJlX2lucHV0X291dHB1dF9kbWFfdGFibGUgc3RhcnRc
biIpOw0KKw0KKyAgcmVzdWx0ID0gMDsNCisNCisJaWYgKGRhdGFfc2l6ZSA9PSAwKSB7DQorCQkv
KiBwcmVwYXJlIGVtcHR5IHRhYmxlIGZvciBpbnB1dCBhbmQgb3V0cHV0ICovDQorCQlzZXBfcHJl
cGFyZV9lbXB0eV9sbGlfdGFibGUobGxpX3RhYmxlX2luX3B0ciwNCisJCQlpbl9udW1fZW50cmll
c19wdHIsDQorCQkJdGFibGVfZGF0YV9zaXplX3B0cik7DQorDQorDQorCQlzZXBfcHJlcGFyZV9l
bXB0eV9sbGlfdGFibGUobGxpX3RhYmxlX291dF9wdHIsDQorCQkJb3V0X251bV9lbnRyaWVzX3B0
ciwNCisJCQl0YWJsZV9kYXRhX3NpemVfcHRyKTsNCisNCisJCWdvdG8gZW5kX2Z1bmN0aW9uOw0K
KyAgfQ0KKw0KKyAgLyogaW5pdGlhbGl6ZSB0aGUgcGFnZXMgcG9pbnRlcnMgKi8NCisgIHNlcF9j
b250ZXh0LmluX3BhZ2VfYXJyYXkgPSAwOw0KKyAgc2VwX2NvbnRleHQub3V0X3BhZ2VfYXJyYXkg
PSAwOw0KKw0KKyAgLyogY2hlY2sgaWYgdGhlIHBhZ2VzIGFyZSBpbiBLZXJuZWwgVmlydHVhbCBB
ZGRyZXNzIGxheW91dCAqLw0KKyAgaWYgKGlzS2VybmVsVmlydHVhbEFkZHJlc3MgPT0gdHJ1ZSkg
ew0KKwkJLyogbG9jayB0aGUgcGFnZXMgb2YgdGhlIGtlcm5lbCBidWZmZXIgYW5kDQorCQl0cmFu
c2xhdGUgdGhlbSB0byBwYWdlcyAqLw0KKwkJcmVzdWx0ID0gc2VwX2xvY2tfa2VybmVsX3BhZ2Vz
KGFwcF92aXJ0X2luX2FkZHIsDQorCQkJZGF0YV9zaXplLA0KKwkJCSZsbGlfaW5fYXJyYXksDQor
CQkJU0VQX0RSSVZFUl9JTl9GTEFHKTsNCisJCWlmIChyZXN1bHQpIHsNCisJCQllZGJnKCJTRVAg
RHJpdmVyOiBzZXBfbG9ja19rZXJuZWxfcGFnZXMgZm9yIGlucHV0IFwNCisJCQkJdmlydHVhbCBi
dWZmZXIgZmFpbGVkXG4iKTsNCisJCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisJCX0NCisJfSBlbHNl
IHsNCisJCS8qIGxvY2sgdGhlIHBhZ2VzIG9mIHRoZSB1c2VyIGJ1ZmZlciBhbmQNCisJCXRyYW5z
bGF0ZSB0aGVtIHRvIHBhZ2VzICovDQorCQlyZXN1bHQgPSBzZXBfbG9ja191c2VyX3BhZ2VzKGFw
cF92aXJ0X2luX2FkZHIsDQorCQkJZGF0YV9zaXplLA0KKwkJCSZsbGlfaW5fYXJyYXksDQorCQkJ
U0VQX0RSSVZFUl9JTl9GTEFHKTsNCisJCWlmIChyZXN1bHQpIHsNCisJCQllZGJnKCJTRVAgRHJp
dmVyOiBzZXBfbG9ja191c2VyX3BhZ2VzIGZvciBpbnB1dCB2aXJ0dWFsXA0KKwkJCQlidWZmZXIg
ZmFpbGVkXG4iKTsNCisJCQlnb3RvIGVuZF9mdW5jdGlvbjsNCisJCX0NCisJfQ0KKw0KKwlpZiAo
aXNLZXJuZWxWaXJ0dWFsQWRkcmVzcyA9PSB0cnVlKSB7DQorCQlyZXN1bHQgPSBzZXBfbG9ja19r
ZXJuZWxfcGFnZXMoYXBwX3ZpcnRfb3V0X2FkZHIsDQorCQkJZGF0YV9zaXplLA0KKwkJCSZsbGlf
b3V0X2FycmF5LA0KKwkJCVNFUF9EUklWRVJfT1VUX0ZMQUcpOw0KKwkJaWYgKHJlc3VsdCkgew0K
KwkJCWVkYmcoIlNFUCBEcml2ZXI6IHNlcF9sb2NrX2tlcm5lbF9wYWdlcyBcDQorCQkJCWZvciBv
dXRwdXQgdmlydHVhbCBidWZmZXIgZmFpbGVkXG4iKTsNCisJCQlnb3RvIGVuZF9mdW5jdGlvbl93
aXRoX2Vycm9yMTsNCisJCX0NCisJfSBlbHNlIHsNCisJCXJlc3VsdCA9IHNlcF9sb2NrX3VzZXJf
cGFnZXMoYXBwX3ZpcnRfb3V0X2FkZHIsDQorCQkJZGF0YV9zaXplLA0KKwkJCSZsbGlfb3V0X2Fy
cmF5LA0KKwkJCVNFUF9EUklWRVJfT1VUX0ZMQUcpOw0KKwkJaWYgKHJlc3VsdCkgew0KKwkJCWVk
YmcoIlNFUCBEcml2ZXI6IHNlcF9sb2NrX3VzZXJfcGFnZXMgXA0KKwkJCQlmb3Igb3V0cHV0IHZp
cnR1YWwgYnVmZmVyIGZhaWxlZFxuIik7DQorCQkJZ290byBlbmRfZnVuY3Rpb25fd2l0aF9lcnJv
cjE7DQorCQl9DQorICB9DQorDQorDQorICBlZGJnKCJzZXBfaW5fbnVtX3BhZ2VzIGlzICV4XG4i
LCBzZXBfY29udGV4dC5pbl9udW1fcGFnZXMpOw0KKwllZGJnKCJzZXBfb3V0X251bV9wYWdlcyBp
cyAleFxuIiwgc2VwX2NvbnRleHQub3V0X251bV9wYWdlcyk7DQorCWVkYmcoIlNFUF9EUklWRVJf
RU5UUklFU19QRVJfVEFCTEVfSU5fU0VQIGlzICV4XG4iLA0KKyAgICBTRVBfRFJJVkVSX0VOVFJJ
RVNfUEVSX1RBQkxFX0lOX1NFUCk7DQorDQorDQorICAvKiBjYWxsIHRoZSBmdWNudGlvbiB0aGF0
IGNyZWF0ZXMgdGFibGUgZnJvbSB0aGUgbGxpIGFycmF5cyAqLw0KKyAgcmVzdWx0ID0gc2VwX2Nv
bnN0cnVjdF9kbWFfdGFibGVzX2Zyb21fbGxpKGxsaV9pbl9hcnJheSwNCisJCQkJCXNlcF9jb250
ZXh0LmluX251bV9wYWdlcywNCisJCQkJCWxsaV9vdXRfYXJyYXksDQorCQkJCQlzZXBfY29udGV4
dC5vdXRfbnVtX3BhZ2VzLA0KKwkJCQkJIGJsb2NrX3NpemUsDQorCQkJCQlsbGlfdGFibGVfaW5f
cHRyLA0KKwkJCQkJbGxpX3RhYmxlX291dF9wdHIsDQorCQkJCQlpbl9udW1fZW50cmllc19wdHIs
DQorCQkJCQlvdXRfbnVtX2VudHJpZXNfcHRyLA0KKwkJCQkJdGFibGVfZGF0YV9zaXplX3B0cik7
DQorCWlmIChyZXN1bHQpIHsNCisJCWVkYmcoIlNFUCBEcml2ZXI6IHNlcF9jb25zdHJ1Y3RfZG1h
X3RhYmxlc19mcm9tX2xsaSBmYWlsZWRcbiIpOw0KKwkJZ290byBlbmRfZnVuY3Rpb25fd2l0aF9l
cnJvcjI7DQorICB9DQorDQorICAvKiBmYWxsIHRocm91Z2ggLSBmcmVlIHRoZSBsbGkgZW50cnkg
YXJyYXlzICovDQorDQorICBlZGJnKCJpbl9udW1fZW50cmllc19wdHIgaXMgJTA4eFxuIiwgKmlu
X251bV9lbnRyaWVzX3B0cik7DQorICBlZGJnKCJvdXRfbnVtX2VudHJpZXNfcHRyIGlzICUwOHhc
biIsICpvdXRfbnVtX2VudHJpZXNfcHRyKTsNCisgIGVkYmcoInRhYmxlX2RhdGFfc2l6ZV9wdHIg
aXMgJTA4eFxuIiwgKnRhYmxlX2RhdGFfc2l6ZV9wdHIpOw0KKw0KKw0KK2VuZF9mdW5jdGlvbl93
aXRoX2Vycm9yMjoNCisNCisgIGtmcmVlKGxsaV9vdXRfYXJyYXkpOw0KKw0KK2VuZF9mdW5jdGlv
bl93aXRoX2Vycm9yMToNCisNCisgIGtmcmVlKGxsaV9pbl9hcnJheSk7DQorDQorZW5kX2Z1bmN0
aW9uOg0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0tLSBzZXBfcHJlcGFyZV9pbnB1dF9v
dXRwdXRfZG1hX3RhYmxlXA0KKyAgICBlbmQgcmVzdWx0ID0gJWRcbiIsIChpbnQpcmVzdWx0KTsN
CisNCisgIHJldHVybiByZXN1bHQ7DQorDQorfQ0KKw0KKw0KKy8qIHRoaXMgZnVuY3Rpb24gZnJl
ZXMgYWxsIHByZWFsbG9jYXRlZCBkbWEgcmVzb3VyY2VzICovDQoraW50IHNlcF9mcmVlX2RtYV90
YWJsZV9kYXRhX2hhbmRsZXIodm9pZCkNCit7DQorCWludCBjb3VudDsNCisNCisgIC8qLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KKwlDT0RFDQorICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLSovDQorDQorICBkYmcoIlNFUCBEcml2ZXI6LS0tLS0tLS0+IHNlcF9mcmVlX2RtYV90YWJs
ZV9kYXRhX2hhbmRsZXIgc3RhcnRcbiIpOw0KKw0KKyAgLyogZnJlZSBpbnB1dCBtYXAgYXJyYXkg
Ki8NCisgIGlmIChzZXBfY29udGV4dC5pbl9tYXBfYXJyYXkpIHsNCisJCWZvciAoY291bnQgPSAw
OyBjb3VudCA8IHNlcF9jb250ZXh0LmluX251bV9wYWdlczsgY291bnQrKykgew0KKwkJCWRtYV91
bm1hcF9wYWdlKHNlcF9jb250ZXh0LmRldl9wdHIgLA0KKwkJCQlzZXBfY29udGV4dC5pbl9tYXBf
YXJyYXlbY291bnRdLmRtYV9hZGRyLA0KKwkJCQlzZXBfY29udGV4dC5pbl9tYXBfYXJyYXlbY291
bnRdLnNpemUsDQorCQkJCURNQV9CSURJUkVDVElPTkFMKTsNCisJCX0NCisNCisJCWtmcmVlKHNl
cF9jb250ZXh0LmluX21hcF9hcnJheSk7DQorICB9DQorDQorICAvKiBmcmVlIG91dHB1dCBtYXAg
YXJyYXkgKi8NCisgIGlmIChzZXBfY29udGV4dC5vdXRfbWFwX2FycmF5KSB7DQorCQlmb3IgKGNv
dW50ID0gMDsgY291bnQgPCBzZXBfY29udGV4dC5vdXRfbnVtX3BhZ2VzOyBjb3VudCsrKSB7DQor
CQkJZG1hX3VubWFwX3BhZ2Uoc2VwX2NvbnRleHQuZGV2X3B0ciAsDQorCQkJCXNlcF9jb250ZXh0
Lm91dF9tYXBfYXJyYXlbY291bnRdLmRtYV9hZGRyLA0KKwkJCQlzZXBfY29udGV4dC5vdXRfbWFw
X2FycmF5W2NvdW50XS5zaXplLA0KKwkJCQlETUFfQklESVJFQ1RJT05BTCk7DQorCQl9DQorDQor
CQlrZnJlZShzZXBfY29udGV4dC5vdXRfbWFwX2FycmF5KTsNCisgIH0NCisNCisgIC8qIGZyZWUg
cGFnZSBjYWNoZSBmb3Igb3V0cHV0ICovDQorICBpZiAoc2VwX2NvbnRleHQuaW5fcGFnZV9hcnJh
eSkgew0KKwkJZm9yIChjb3VudCA9IDA7IGNvdW50IDwgc2VwX2NvbnRleHQuaW5fbnVtX3BhZ2Vz
OyBjb3VudCsrKQ0KKwkJCXBhZ2VfY2FjaGVfcmVsZWFzZShzZXBfY29udGV4dC5pbl9wYWdlX2Fy
cmF5W2NvdW50XSk7DQorDQorCQlrZnJlZShzZXBfY29udGV4dC5pbl9wYWdlX2FycmF5KTsNCisN
CisgIH0NCisNCisgIGlmIChzZXBfY29udGV4dC5vdXRfcGFnZV9hcnJheSkgew0KKwkJZm9yIChj
b3VudCA9IDA7IGNvdW50IDwgc2VwX2NvbnRleHQub3V0X251bV9wYWdlczsgY291bnQrKykgew0K
KwkJCWlmICghUGFnZVJlc2VydmVkKHNlcF9jb250ZXh0Lm91dF9wYWdlX2FycmF5W2NvdW50XSkp
DQorCQkJCVNldFBhZ2VEaXJ0eShzZXBfY29udGV4dC5vdXRfcGFnZV9hcnJheVtjb3VudF0pOw0K
KwkJCXBhZ2VfY2FjaGVfcmVsZWFzZShzZXBfY29udGV4dC5vdXRfcGFnZV9hcnJheVtjb3VudF0p
Ow0KKwkJfQ0KKw0KKwkJa2ZyZWUoc2VwX2NvbnRleHQub3V0X3BhZ2VfYXJyYXkpOw0KKyAgfQ0K
Kw0KKyAgLyogcmVzZXQgYWxsIHRoZSB2YWx1ZXMgKi8NCisgIHNlcF9jb250ZXh0LmluX3BhZ2Vf
YXJyYXkgPSAwOw0KKyAgc2VwX2NvbnRleHQub3V0X3BhZ2VfYXJyYXkgPSAwOw0KKyAgc2VwX2Nv
bnRleHQuaW5fbnVtX3BhZ2VzID0gMDsNCisgIHNlcF9jb250ZXh0Lm91dF9udW1fcGFnZXMgPSAw
Ow0KKwlzZXBfY29udGV4dC5udW1fbGxpX3RhYmxlc19jcmVhdGVkID0gMDsNCisJc2VwX2NvbnRl
eHQuaW5fbWFwX2FycmF5ID0gMDsNCisgIHNlcF9jb250ZXh0Lm91dF9tYXBfYXJyYXkgPSAwOw0K
KyAgc2VwX2NvbnRleHQuaW5fbWFwX251bV9lbnRyaWVzID0gMDsNCisgIHNlcF9jb250ZXh0Lm91
dF9tYXBfbnVtX2VudHJpZXMgPSAwOw0KKw0KKw0KKyAgZGJnKCJTRVAgRHJpdmVyOjwtLS0tLS0t
LSBzZXBfZnJlZV9kbWFfdGFibGVfZGF0YV9oYW5kbGVyIGVuZFxuIik7DQorDQorICByZXR1cm4g
MDsNCit9DQorDQorbW9kdWxlX2luaXQoc2VwX2luaXQpOw0KK21vZHVsZV9leGl0KHNlcF9leGl0
KTsNCisNCitNT0RVTEVfTElDRU5TRSgiR1BMIik7DQotLSANCjEuNi4wLjQNCg0K

--_002_753F67ADE6F5094C9F1DBA00D1BAA8D325518252AEorsmsx501amrc_--
