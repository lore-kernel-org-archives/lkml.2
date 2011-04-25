Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1DYU4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:56:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:6659 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192Ab1DYU41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:56:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,266,1301900400"; 
   d="scan'208";a="738252275"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: "Allyn, Mark A" <mark.a.allyn@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "Allyn, Mark A" <mark.a.allyn@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Date: Mon, 25 Apr 2011 13:56:23 -0700
Subject: RE: [PATCH 1/1] staging: sep: move to misc: sep: to move to mainline
Thread-Topic: [PATCH 1/1] staging: sep: move to misc: sep: to move to
 mainline
Thread-Index: AcwBL07us+OYE9xXR/SvKa5yh3h6vAACV7MQ
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D901B703E89F@orsmsx506.amr.corp.intel.com>
References: <1303505449-25111-1-git-send-email-mark.a.allyn@intel.com>
In-Reply-To: <1303505449-25111-1-git-send-email-mark.a.allyn@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
> Mark Allyn
> Sent: Friday, April 22, 2011 1:51 PM
>
> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> ---
>  drivers/misc/Kconfig                     |    1 +
>  drivers/misc/Makefile                    |    1 +
>  drivers/misc/sep/Kconfig                 |   10 +
>  drivers/misc/sep/Makefile                |    2 +
>  drivers/misc/sep/TODO                    |    4 +
>  drivers/misc/sep/sep_dev.h               |  131 ++
>  drivers/misc/sep/sep_driver.c            | 2928 ++++++++++++++++++++++++++++++
>  drivers/misc/sep/sep_driver_api.h        |  215 +++
>  drivers/misc/sep/sep_driver_config.h     |  243 +++
>  drivers/misc/sep/sep_driver_hw_defs.h    |  233 +++
>  drivers/staging/Kconfig                  |    2 -
>  drivers/staging/Makefile                 |    1 -
>  drivers/staging/sep/Kconfig              |   10 -
>  drivers/staging/sep/Makefile             |    2 -
>  drivers/staging/sep/TODO                 |    4 -
>  drivers/staging/sep/sep_dev.h            |  131 --
>  drivers/staging/sep/sep_driver.c         | 2928 ------------------------------
>  drivers/staging/sep/sep_driver_api.h     |  215 ---
>  drivers/staging/sep/sep_driver_config.h  |  243 ---
>  drivers/staging/sep/sep_driver_hw_defs.h |  233 ---
>  20 files changed, 3768 insertions(+), 3769 deletions(-)
>  create mode 100644 drivers/misc/sep/Kconfig
>  create mode 100644 drivers/misc/sep/Makefile
>  create mode 100644 drivers/misc/sep/TODO
>  create mode 100644 drivers/misc/sep/sep_dev.h
>  create mode 100644 drivers/misc/sep/sep_driver.c
>  create mode 100644 drivers/misc/sep/sep_driver_api.h
>  create mode 100644 drivers/misc/sep/sep_driver_config.h
>  create mode 100644 drivers/misc/sep/sep_driver_hw_defs.h
>  delete mode 100644 drivers/staging/sep/Kconfig
>  delete mode 100644 drivers/staging/sep/Makefile
>  delete mode 100644 drivers/staging/sep/TODO
>  delete mode 100644 drivers/staging/sep/sep_dev.h
>  delete mode 100644 drivers/staging/sep/sep_driver.c
>  delete mode 100644 drivers/staging/sep/sep_driver_api.h
>  delete mode 100644 drivers/staging/sep/sep_driver_config.h
>  delete mode 100644 drivers/staging/sep/sep_driver_hw_defs.h
>
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4e007c6..3dd9c88 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -481,5 +481,6 @@ source "drivers/misc/cb710/Kconfig"
>  source "drivers/misc/iwmc3200top/Kconfig"
>  source "drivers/misc/ti-st/Kconfig"
>  source "drivers/misc/lis3lv02d/Kconfig"
> +source "drivers/misc/sep/Kconfig"
>
>  endif # MISC_DEVICES
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index f546860..1acdc50 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -44,3 +44,4 @@ obj-$(CONFIG_PCH_PHUB)              += pch_phub.o
>  obj-y                                += ti-st/
>  obj-$(CONFIG_AB8500_PWM)     += ab8500-pwm.o
>  obj-y                                += lis3lv02d/
> +obj-$(CONFIG_DX_SEP)         += sep/
> diff --git a/drivers/misc/sep/Kconfig b/drivers/misc/sep/Kconfig
> new file mode 100644
> index 0000000..92bf166
> --- /dev/null
> +++ b/drivers/misc/sep/Kconfig
> @@ -0,0 +1,10 @@
> +config DX_SEP
> +     tristate "Discretix SEP driver"
> +     depends on PCI
> +     help
> +       Discretix SEP driver; used for the security processor subsystem
> +       on bard the Intel Mobile Internet Device.

"on bard" -> "onboard"

> +
> +       The driver's name is sep_driver.
> +
> +       If unsure, select N.
> diff --git a/drivers/misc/sep/Makefile b/drivers/misc/sep/Makefile
> new file mode 100644
> index 0000000..628d5f9
> --- /dev/null
> +++ b/drivers/misc/sep/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_DX_SEP) := sep_driver.o
> +
> diff --git a/drivers/misc/sep/TODO b/drivers/misc/sep/TODO
> new file mode 100644
> index 0000000..8f3b878
> --- /dev/null
> +++ b/drivers/misc/sep/TODO
> @@ -0,0 +1,4 @@
> +Todo's so far (from Alan Cox)
> +- Check whether it can be plugged into any of the kernel crypto API
> +  interfaces - Crypto API 'glue' is still not ready to submit
> +- Clean up un-needed debug prints - Started to work on this
> diff --git a/drivers/misc/sep/sep_dev.h b/drivers/misc/sep/sep_dev.h
> new file mode 100644
> index 0000000..696ab0d
> --- /dev/null
> +++ b/drivers/misc/sep/sep_dev.h
> @@ -0,0 +1,131 @@
> +#ifndef __SEP_DEV_H__
> +#define __SEP_DEV_H__
> +
> +/*
> + *
> + *  sep_dev.h - Security Processor Device Structures
> + *
> + *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.

2009-2011?

> + *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms of the GNU General Public License as published by the Free
> + *  Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but WITHOUT
> + *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + *  more details.
> + *
> + *  You should have received a copy of the GNU General Public License along with
> + *  this program; if not, write to the Free Software Foundation, Inc., 59
> + *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + *
> + *  CONTACTS:
> + *
> + *  Mark Allyn               mark.a.allyn@intel.com
> + *  Jayant Mangalampalli jayant.mangalampalli@intel.com

Wouldn't it be better to put yourselves in MAINTAINERS instead of in the source files (easier to change if someone else becomes the maintainer)?

> + *
> + *  CHANGES
> + *  2010.09.14  upgrade to Medfield
> + */
> +
> +struct sep_device {
> +     /* pointer to pci dev */
> +     struct pci_dev *pdev;
> +
> +     /* character device file */
> +     struct cdev sep_cdev;
> +     struct cdev sep_daemon_cdev;
> +     struct cdev sep_singleton_cdev;
> +
> +     /* devices (using misc dev) */
> +     struct miscdevice miscdev_sep;
> +     struct miscdevice miscdev_singleton;
> +     struct miscdevice miscdev_daemon;
> +
> +     /* major / minor numbers of device */
> +     dev_t sep_devno;
> +     dev_t sep_daemon_devno;
> +     dev_t sep_singleton_devno;
> +
> +     struct mutex sep_mutex;
> +     struct mutex ioctl_mutex;
> +     spinlock_t snd_rply_lck;
> +
> +     /* flags to indicate use and lock status of sep */
> +     u32 pid_doing_transaction;
> +     unsigned long in_use_flags;
> +
> +     /* request daemon alread open */
> +     unsigned long request_daemon_open;
> +
> +     /* 1 = Moorestown; 0 = Medfield */
> +     int mrst;
> +
> +     /* address of the shared memory allocated during init for SEP driver
> +        (coherent alloc) */
> +     dma_addr_t shared_bus;
> +     size_t shared_size;
> +     void *shared_addr;
> +
> +     /* start address of the access to the SEP registers from driver */
> +     dma_addr_t reg_physical_addr;
> +     dma_addr_t reg_physical_end;
> +     void __iomem *reg_addr;

reg_base might be more descriptive

> +
> +     /* wait queue head (event) of the driver */
> +     wait_queue_head_t event;
> +     wait_queue_head_t event_request_daemon;
> +     wait_queue_head_t event_mmap;
> +
> +     struct sep_caller_id_entry
> +             caller_id_table[SEP_CALLER_ID_TABLE_NUM_ENTRIES];
> +
> +     /* access flag for singleton device */
> +     unsigned long singleton_access_flag;
> +
> +     /* transaction counter that coordinates the
> +        transactions between SEP and HOST */
> +     unsigned long send_ct;
> +     /* counter for the messages from sep */
> +     unsigned long reply_ct;
> +     /* counter for the number of bytes allocated in the pool for the
> +        current transaction */
> +     long data_pool_bytes_allocated;

'unsigned long'?

> +
> +     u32 num_of_data_allocations;
> +
> +     /* number of the lli tables created in the current transaction */
> +     u32     num_lli_tables_created;
> +
> +     /* number of data control blocks */
> +     u32 nr_dcb_creat;
> +
> +     struct sep_dma_resource dma_res_arr[SEP_MAX_NUM_SYNC_DMA_OPS];
> +
> +};
> +
> +static inline void sep_write_reg(struct sep_device *dev, int reg, u32 value)

Presumably reg can't be negative, so why not 'unsigned int' or u32 (presumably it also can't be >4GB)?

> +{
> +     void __iomem *addr = dev->reg_addr + reg;
> +     writel(value, addr);
> +}
> +
> +static inline u32 sep_read_reg(struct sep_device *dev, int reg)

Ditto above.

> +{
> +     void __iomem *addr = dev->reg_addr + reg;
> +     return readl(addr);
> +}
> +
> +/* wait for SRAM write complete(indirect write */

Missing closing paren

> +static inline void sep_wait_sram_write(struct sep_device *dev)
> +{
> +     u32 reg_val;
> +     do {
> +             reg_val = sep_read_reg(dev, HW_SRAM_DATA_READY_REG_ADDR);
> +     } while (!(reg_val & 1));

IMHO, it would be clearer to define a bitfield for this reg and test the ready bit explicitly.

> +}
> +
> +
> +#endif
> diff --git a/drivers/misc/sep/sep_driver.c b/drivers/misc/sep/sep_driver.c
> new file mode 100644
> index 0000000..890eede
> --- /dev/null
> +++ b/drivers/misc/sep/sep_driver.c
> @@ -0,0 +1,2928 @@
> +/*
> + *
> + *  sep_driver.c - Security Processor Driver main group of functions
> + *
> + *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> + *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms of the GNU General Public License as published by the Free
> + *  Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but WITHOUT
> + *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + *  more details.
> + *
> + *  You should have received a copy of the GNU General Public License along with
> + *  this program; if not, write to the Free Software Foundation, Inc., 59
> + *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + *
> + *  CONTACTS:
> + *
> + *  Mark Allyn               mark.a.allyn@intel.com
> + *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> + *
> + *  CHANGES:
> + *
> + *  2009.06.26       Initial publish
> + *  2010.09.14  Upgrade to Medfield
> + *
> + */
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/fs.h>
> +#include <linux/cdev.h>
> +#include <linux/kdev_t.h>
> +#include <linux/mutex.h>
> +#include <linux/sched.h>
> +#include <linux/mm.h>
> +#include <linux/poll.h>
> +#include <linux/wait.h>
> +#include <linux/pci.h>
> +#include <linux/firmware.h>
> +#include <linux/slab.h>
> +#include <linux/ioctl.h>
> +#include <asm/current.h>
> +#include <linux/ioport.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/pagemap.h>
> +#include <asm/cacheflush.h>
> +#include <linux/sched.h>
> +#include <linux/delay.h>
> +#include <linux/jiffies.h>
> +#include <linux/rar_register.h>
> +
> +#include "sep_driver_hw_defs.h"
> +#include "sep_driver_config.h"
> +#include "sep_driver_api.h"
> +#include "sep_dev.h"
> +
> +/*----------------------------------------
> +     DEFINES
> +-----------------------------------------*/
> +
> +#define SEP_RAR_IO_MEM_REGION_SIZE 0x40000
> +
> +/*--------------------------------------------
> +     GLOBAL variables
> +--------------------------------------------*/
> +
> +/* Keep this a single static object for now to keep the conversion easy */
> +
> +static struct sep_device *sep_dev;
> +
> +/**
> + *   sep_dump_message - dump the message that is pending
> + *   @sep: SEP device
> + */
> +static void sep_dump_message(struct sep_device *sep)

'sep' -> 'dev' for consistency

> +{
> +     int count;
> +     u32 *p = sep->shared_addr;
> +     for (count = 0; count < 12 * 4; count += 4)

Magic # (12)
'4' -> sizeof(u32)

> +             dev_dbg(&sep->pdev->dev, "Word %d of the message is %x\n",
> +                                                             count, *p++);
> +}
> +
> +/**
> + *   sep_map_and_alloc_shared_area - allocate shared block
> + *   @sep: security processor
> + *   @size: size of shared area
> + */
> +static int sep_map_and_alloc_shared_area(struct sep_device *sep)
> +{
> +     sep->shared_addr = dma_alloc_coherent(&sep->pdev->dev,
> +             sep->shared_size,
> +             &sep->shared_bus, GFP_KERNEL);
> +
> +     if (!sep->shared_addr) {
> +             dev_warn(&sep->pdev->dev,
> +                     "shared memory dma_alloc_coherent failed\n");
> +             return -ENOMEM;
> +     }
> +     dev_dbg(&sep->pdev->dev,
> +             "shared_addr %zx bytes @%p (bus %llx)\n",
> +                             sep->shared_size, sep->shared_addr,
> +                             (unsigned long long)sep->shared_bus);
> +     return 0;
> +}
> +
> +/**
> + *   sep_unmap_and_free_shared_area - free shared block
> + *   @sep: security processor
> + */
> +static void sep_unmap_and_free_shared_area(struct sep_device *sep)
> +{
> +     dma_free_coherent(&sep->pdev->dev, sep->shared_size,
> +                             sep->shared_addr, sep->shared_bus);
> +}
> +
> +/**
> + *   sep_shared_bus_to_virt - convert bus/virt addresses
> + *   @sep: pointer to struct sep_device
> + *   @bus_address: address to convert
> + *
> + *   Returns virtual address inside the shared area according
> + *   to the bus address.
> + */
> +static void *sep_shared_bus_to_virt(struct sep_device *sep,
> +                                             dma_addr_t bus_address)
> +{
> +     return sep->shared_addr + (bus_address - sep->shared_bus);

It would be good to check that (bus_address - sep->shared_bus) < shared_size

> +}
> +
> +/**
> + *   open function for the singleton driver
> + *   @inode_ptr struct inode *
> + *   @file_ptr struct file *
> + *
> + *   Called when the user opens the singleton device interface
> + */
> +static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)

'file_ptr' -> 'filp' for consistency with other fns

> +{
> +     struct sep_device *sep;
> +
> +     /*
> +      * Get the SEP device structure and use it for the
> +      * private_data field in filp for other methods
> +      */
> +     sep = sep_dev;

Why do you need a local var (sep)?

> +
> +     file_ptr->private_data = sep;
> +
> +     if (test_and_set_bit(0, &sep->singleton_access_flag))
> +             return -EBUSY;

Shouldn't you test before you assign private_data?

> +     return 0;
> +}
> +
> +/**
> + *   sep_open - device open method
> + *   @inode: inode of SEP device
> + *   @filp: file handle to SEP device
> + *
> + *   Open method for the SEP device. Called when userspace opens
> + *   the SEP device node.
> + *
> + *   Returns zero on success otherwise an error code.
> + */
> +static int sep_open(struct inode *inode, struct file *filp)
> +{
> +     struct sep_device *sep;
> +
> +     /*
> +      * Get the SEP device structure and use it for the
> +      * private_data field in filp for other methods
> +      */
> +     sep = sep_dev;

Ditto above.

> +     filp->private_data = sep;
> +
> +     /* Anyone can open; locking takes place at transaction level */
> +     return 0;
> +}
> +
> +/**
> + *   sep_singleton_release - close a SEP singleton device
> + *   @inode: inode of SEP device
> + *   @filp: file handle being closed
> + *
> + *   Called on the final close of a SEP device. As the open protects against
> + *   multiple simultaenous opens that means this method is called when the
> + *   final reference to the open handle is dropped.
> + */
> +static int sep_singleton_release(struct inode *inode, struct file *filp)
> +{
> +     struct sep_device *sep = filp->private_data;
> +
> +     clear_bit(0, &sep->singleton_access_flag);
> +     return 0;
> +}
> +
> +/**
> + *   sep_request_daemonopen - request daemon open method
> + *   @inode: inode of SEP device
> + *   @filp: file handle to SEP device
> + *
> + *   Open method for the SEP request daemon. Called when
> + *   request daemon in userspace opens the SEP device node.
> + *
> + *   Returns zero on success otherwise an error code.
> + */
> +static int sep_request_daemon_open(struct inode *inode, struct file *filp)
> +{
> +     struct sep_device *sep = sep_dev;
> +     int error = 0;

'error' var not needed.

> +
> +     filp->private_data = sep;
> +
> +     /* There is supposed to be only one request daemon */
> +     if (test_and_set_bit(0, &sep->request_daemon_open))
> +             error = -EBUSY;

Test before assign

> +     return error;
> +}
> +
> +/**
> + *   sep_request_daemon_release - close a SEP daemon
> + *   @inode: inode of SEP device
> + *   @filp: file handle being closed
> + *
> + *   Called on the final close of a SEP daemon.
> + */
> +static int sep_request_daemon_release(struct inode *inode, struct file *filp)
> +{
> +     struct sep_device *sep = filp->private_data;

Test sep for NULL.

> +
> +     dev_dbg(&sep->pdev->dev, "Request daemon release for pid %d\n",
> +             current->pid);
> +
> +     /* Clear the request_daemon_open flag */
> +     clear_bit(0, &sep->request_daemon_open);
> +     return 0;
> +}
> +
> +/**
> + *   sep_req_daemon_send_reply_command_handler - poke the SEP
> + *   @sep: struct sep_device *
> + *
> + *   This function raises interrupt to SEPm that signals that is has a

"SEPm" -> "SEP"?

> + *   new command from HOST
> + */
> +static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
> +{
> +     unsigned long lck_flags;
> +
> +     sep_dump_message(sep);
> +
> +     /* Counters are lockable region */
> +     spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> +     sep->send_ct++;
> +     sep->reply_ct++;
> +
> +     /* Send the interrupt to SEP */
> +     sep_write_reg(sep, HW_HOST_HOST_SEP_GPR2_REG_ADDR, sep->send_ct);
> +     sep->send_ct++;

Why increment twice?

> +
> +     spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> +
> +     dev_dbg(&sep->pdev->dev,
> +             "sep_req_daemon_send_reply send_ct %lx reply_ct %lx\n",
> +             sep->send_ct, sep->reply_ct);
> +
> +     return 0;
> +}
> +
> +
> +/**
> + *   sep_free_dma_table_data_handler - free DMA table
> + *   @sep: pointere to struct sep_device
> + *
> + *   Handles the request to  free DMA table for synchronic actions

+ *     Handles the request to free DMA table for synchronous actions

> + */
> +static int sep_free_dma_table_data_handler(struct sep_device *sep)
> +{
> +     int count;
> +     int dcb_counter;

Both 'unsigned int'

> +     /* Pointer to the current dma_resource struct */
> +     struct sep_dma_resource *dma;
> +
> +     for (dcb_counter = 0; dcb_counter < sep->nr_dcb_creat; dcb_counter++) {
> +             dma = &sep->dma_res_arr[dcb_counter];
> +
> +             /* Unmap and free input map array */
> +             if (dma->in_map_array) {
> +                     for (count = 0; count < dma->in_num_pages; count++) {
> +                             dma_unmap_page(&sep->pdev->dev,
> +                                     dma->in_map_array[count].dma_addr,
> +                                     dma->in_map_array[count].size,
> +                                     DMA_TO_DEVICE);
> +                     }
> +                     kfree(dma->in_map_array);
> +             }
> +
> +             /* Unmap output map array, DON'T free it yet */

"DON'T free it yet" -- but you do

> +             if (dma->out_map_array) {
> +                     for (count = 0; count < dma->out_num_pages; count++) {
> +                             dma_unmap_page(&sep->pdev->dev,
> +                                     dma->out_map_array[count].dma_addr,
> +                                     dma->out_map_array[count].size,
> +                                     DMA_FROM_DEVICE);
> +                     }
> +                     kfree(dma->out_map_array);
> +             }
> +
> +             /* Free page cache for output */
> +             if (dma->in_page_array) {
> +                     for (count = 0; count < dma->in_num_pages; count++) {
> +                             flush_dcache_page(dma->in_page_array[count]);
> +                             page_cache_release(dma->in_page_array[count]);
> +                     }
> +                     kfree(dma->in_page_array);
> +             }
> +
> +             if (dma->out_page_array) {
> +                     for (count = 0; count < dma->out_num_pages; count++) {
> +                             if (!PageReserved(dma->out_page_array[count]))
> +                                     SetPageDirty(dma->out_page_array[count]);
> +                             flush_dcache_page(dma->out_page_array[count]);
> +                             page_cache_release(dma->out_page_array[count]);
> +                     }
> +                     kfree(dma->out_page_array);
> +             }
> +
> +             /* Reset all the values */
> +             dma->in_page_array = NULL;
> +             dma->out_page_array = NULL;
> +             dma->in_num_pages = 0;
> +             dma->out_num_pages = 0;
> +             dma->in_map_array = NULL;
> +             dma->out_map_array = NULL;
> +             dma->in_map_num_entries = 0;
> +             dma->out_map_num_entries = 0;
> +     }
> +
> +     sep->nr_dcb_creat = 0;
> +     sep->num_lli_tables_created = 0;
> +
> +     return 0;
> +}
> +
> +/**
> + *   sep_request_daemon_mmap - maps the shared area to user space
> + *   @filp: pointer to struct file
> + *   @vma: pointer to vm_area_struct
> + *
> + *   Called by the kernel when the daemon attempts an mmap() syscall
> + *   using our handle.
> + */
> +static int sep_request_daemon_mmap(struct file  *filp,
> +     struct vm_area_struct  *vma)
> +{
> +     struct sep_device *sep = filp->private_data;

Test for NULL

> +     dma_addr_t bus_address;
> +     int error = 0;

'error' not needed

> +
> +     if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
> +             error = -EINVAL;
> +             goto end_function;

Just 'return -EINVAL;'

> +     }
> +
> +     /* Get physical address */
> +     bus_address = sep->shared_bus;
> +
> +     if (remap_pfn_range(vma, vma->vm_start, bus_address >> PAGE_SHIFT,
> +             vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
> +
> +             dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
> +             error = -EAGAIN;
> +             goto end_function;

Ditto

> +     }
> +
> +end_function:
> +     return error;
> +}
> +
> +/**
> + *   sep_request_daemon_poll - poll implementation
> + *   @sep: struct sep_device * for current SEP device
> + *   @filp: struct file * for open file
> + *   @wait: poll_table * for poll
> + *
> + *   Called when our device is part of a poll() or select() syscall
> + */
> +static unsigned int sep_request_daemon_poll(struct file *filp,
> +     poll_table  *wait)
> +{
> +     u32     mask = 0;

'mask' not needed

> +     /* GPR2 register */
> +     u32     retval2;
> +     unsigned long lck_flags;
> +     struct sep_device *sep = filp->private_data;

Test for NULL

> +
> +     poll_wait(filp, &sep->event_request_daemon, wait);
> +
> +     dev_dbg(&sep->pdev->dev, "daemon poll: send_ct is %lx reply ct is %lx\n",
> +                                             sep->send_ct, sep->reply_ct);
> +
> +     spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> +     /* Check if the data is ready */
> +     if (sep->send_ct == sep->reply_ct) {
> +             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> +
> +             retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
> +             dev_dbg(&sep->pdev->dev,
> +                     "daemon poll: data check (GPR2) is %x\n", retval2);
> +
> +             /* Check if PRINT request */
> +             if ((retval2 >> 30) & 0x1) {

Magic #s (bitfield test would be better)

> +                     dev_dbg(&sep->pdev->dev, "daemon poll: PRINTF request in\n");
> +                     mask |= POLLIN;
> +                     goto end_function;

'return POLLIN;'

> +             }
> +             /* Check if NVS request */
> +             if (retval2 >> 31) {
> +                     dev_dbg(&sep->pdev->dev, "daemon poll: NVS request in\n");
> +                     mask |= POLLPRI | POLLWRNORM;

'return POLLPRI | POLLWRNORM;'

> +             }
> +     } else {
> +             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> +             dev_dbg(&sep->pdev->dev,
> +                     "daemon poll: no reply received; returning 0\n");
> +             mask = 0;

'return 0;'

> +     }
> +end_function:
> +     return mask;
> +}
> +
> +/**
> + *   sep_release - close a SEP device
> + *   @inode: inode of SEP device
> + *   @filp: file handle being closed
> + *
> + *   Called on the final close of a SEP device.
> + */
> +static int sep_release(struct inode *inode, struct file *filp)
> +{
> +     struct sep_device *sep = filp->private_data;

Test for NULL

> +
> +     dev_dbg(&sep->pdev->dev, "Release for pid %d\n", current->pid);
> +
> +     mutex_lock(&sep->sep_mutex);
> +     /* Is this the process that has a transaction open?
> +      * If so, lets reset pid_doing_transaction to 0 and
> +      * clear the in use flags, and then wake up sep_event
> +      * so that other processes can do transactions
> +      */
> +     if (sep->pid_doing_transaction == current->pid) {

How are you dealing with pid re-use?

> +             clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
> +             clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
> +             sep_free_dma_table_data_handler(sep);
> +             wake_up(&sep->event);
> +             sep->pid_doing_transaction = 0;
> +     }
> +
> +     mutex_unlock(&sep->sep_mutex);
> +     return 0;
> +}
> +
> +/**
> + *   sep_mmap -  maps the shared area to user space
> + *   @filp: pointer to struct file
> + *   @vma: pointer to vm_area_struct
> + *
> + *   Called on an mmap of our space via the normal SEP device
> + */
> +static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +     dma_addr_t bus_addr;
> +     struct sep_device *sep = filp->private_data;

Test for NULL--and ditto for all uses in rest of file

> +     unsigned long error = 0;
> +
> +     /* Set the transaction busy (own the device) */
> +     wait_event_interruptible(sep->event,
> +             test_and_set_bit(SEP_MMAP_LOCK_BIT,
> +             &sep->in_use_flags) == 0);
> +
> +     if (signal_pending(current)) {
> +             error = -EINTR;
> +             goto end_function_with_error;
> +     }
> +     /*
> +      * The pid_doing_transaction indicates that this process
> +      * now owns the facilities to performa a transaction with
> +      * the SEP. While this process is performing a transaction,
> +      * no other process who has the SEP device open can perform
> +      * any transactions. This method allows more than one process
> +      * to have the device open at any given time, which provides
> +      * finer granularity for device utilization by multiple
> +      * processes.
> +      */
> +     mutex_lock(&sep->sep_mutex);
> +     sep->pid_doing_transaction = current->pid;
> +     mutex_unlock(&sep->sep_mutex);
> +
> +     /* Zero the pools and the number of data pool alocation pointers */
> +     sep->data_pool_bytes_allocated = 0;
> +     sep->num_of_data_allocations = 0;
> +

Just call sep_request_daemon_mmap() instead of duplicating its code

> +     /*
> +      * Check that the size of the mapped range is as the size of the message
> +      * shared area
> +      */
> +     if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
> +             error = -EINVAL;
> +             goto end_function_with_error;
> +     }
> +
> +     dev_dbg(&sep->pdev->dev, "shared_addr is %p\n", sep->shared_addr);
> +
> +     /* Get bus address */
> +     bus_addr = sep->shared_bus;
> +
> +     if (remap_pfn_range(vma, vma->vm_start, bus_addr >> PAGE_SHIFT,
> +             vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
> +             dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
> +             error = -EAGAIN;
> +             goto end_function_with_error;
> +     }
> +     goto end_function;
> +
> +end_function_with_error:
> +     /* Clear the bit */
> +     clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
> +     mutex_lock(&sep->sep_mutex);
> +     sep->pid_doing_transaction = 0;
> +     mutex_unlock(&sep->sep_mutex);
> +
> +     /* Raise event for stuck contextes */
> +
> +     wake_up(&sep->event);
> +
> +end_function:
> +     return error;
> +}
> +
> +/**
> + *   sep_poll - poll handler
> + *   @filp: pointer to struct file
> + *   @wait: pointer to poll_table
> + *
> + *   Called by the OS when the kernel is asked to do a poll on
> + *   a SEP file handle.
> + */
> +static unsigned int sep_poll(struct file *filp, poll_table *wait)
> +{
> +     u32 mask = 0;

No need for 'mask' (and goto's)--just return the value

> +     u32 retval = 0;
> +     u32 retval2 = 0;
> +     unsigned long lck_flags;
> +
> +     struct sep_device *sep = filp->private_data;
> +
> +     /* Am I the process that owns the transaction? */
> +     mutex_lock(&sep->sep_mutex);
> +     if (current->pid != sep->pid_doing_transaction) {
> +             dev_dbg(&sep->pdev->dev, "poll; wrong pid\n");

Does this need to be w/in the mutex?

> +             mask = POLLERR;
> +             mutex_unlock(&sep->sep_mutex);
> +             goto end_function;
> +     }
> +     mutex_unlock(&sep->sep_mutex);
> +
> +     /* Check if send command or send_reply were activated previously */
> +     if (!test_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
> +             mask = POLLERR;
> +             goto end_function;
> +     }
> +
> +     /* Add the event to the polling wait table */
> +     dev_dbg(&sep->pdev->dev, "poll: calling wait sep_event\n");
> +
> +     poll_wait(filp, &sep->event, wait);
> +
> +     dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
> +             sep->send_ct, sep->reply_ct);
> +
> +     /* Check if error occurred during poll */
> +     retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
> +     if (retval2 != 0x0) {
> +             dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
> +             mask |= POLLERR;
> +             goto end_function;
> +     }
> +
> +     spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> +
> +     if (sep->send_ct == sep->reply_ct) {
> +             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> +             retval = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
> +             dev_dbg(&sep->pdev->dev, "poll: data ready check (GPR2)  %x\n",
> +                     retval);
> +
> +             /* Check if printf request  */
> +             if ((retval >> 30) & 0x1) {
> +                     dev_dbg(&sep->pdev->dev, "poll: SEP printf request\n");
> +                     wake_up(&sep->event_request_daemon);
> +                     goto end_function;
> +             }
> +
> +             /* Check if the this is SEP reply or request */
> +             if (retval >> 31) {
> +                     dev_dbg(&sep->pdev->dev, "poll: SEP request\n");
> +                     wake_up(&sep->event_request_daemon);
> +             } else {
> +                     dev_dbg(&sep->pdev->dev, "poll: normal return\n");
> +                     /* In case it is again by send_reply_comand */
> +                     clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
> +                     sep_dump_message(sep);
> +                     dev_dbg(&sep->pdev->dev,
> +                             "poll; SEP reply POLLIN | POLLRDNORM\n");
> +                     mask |= POLLIN | POLLRDNORM;
> +             }
> +     } else {
> +             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> +             dev_dbg(&sep->pdev->dev,
> +                     "poll; no reply received; returning mask of 0\n");
> +             mask = 0;
> +     }
> +
> +end_function:
> +     return mask;
> +}
> +
> +/**
> + *   sep_time_address - address in SEP memory of time
> + *   @sep: SEP device we want the address from
> + *
> + *   Return the address of the two dwords in memory used for time
> + *   setting.
> + */
> +static u32 *sep_time_address(struct sep_device *sep)
> +{
> +     return sep->shared_addr + SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES;
> +}
> +
> +/**
> + *   sep_set_time - set the SEP time
> + *   @sep: the SEP we are setting the time for
> + *
> + *   Calculates time and sets it at the predefined address.
> + *   Called with the SEP mutex held.
> + */
> +static unsigned long sep_set_time(struct sep_device *sep)
> +{
> +     struct timeval time;
> +     u32 *time_addr; /* Address of time as seen by the kernel */
> +
> +
> +     do_gettimeofday(&time);
> +
> +     /* Set value in the SYSTEM MEMORY offset */
> +     time_addr = sep_time_address(sep);
> +
> +     time_addr[0] = SEP_TIME_VAL_TOKEN;
> +     time_addr[1] = time.tv_sec;
> +
> +     dev_dbg(&sep->pdev->dev, "time.tv_sec is %lu\n", time.tv_sec);
> +     dev_dbg(&sep->pdev->dev, "time_addr is %p\n", time_addr);
> +     dev_dbg(&sep->pdev->dev, "sep->shared_addr is %p\n", sep->shared_addr);
> +
> +     return time.tv_sec;
> +}
> +
> +/**
> + *   sep_set_caller_id_handler - insert caller id entry
> + *   @sep: SEP device
> + *   @arg: pointer to struct caller_id_struct
> + *
> + *   Inserts the data into the caller id table. Note that this function
> + *   falls under the ioctl lock
> + */
> +static int sep_set_caller_id_handler(struct sep_device *sep, unsigned long arg)
> +{
> +     void __user *hash;
> +     int   error = 0;
> +     int   i;
> +     struct caller_id_struct command_args;
> +
> +     for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
> +             if (sep->caller_id_table[i].pid == 0)
> +                     break;
> +     }
> +
> +     if (i == SEP_CALLER_ID_TABLE_NUM_ENTRIES) {
> +             dev_dbg(&sep->pdev->dev, "no more caller id entries left\n");
> +             dev_dbg(&sep->pdev->dev, "maximum number is %d\n",
> +                                     SEP_CALLER_ID_TABLE_NUM_ENTRIES);
> +             error = -EUSERS;
> +             goto end_function;
> +     }
> +
> +     /* Copy the data */
> +     if (copy_from_user(&command_args, (void __user *)arg,
> +             sizeof(command_args))) {
> +             error = -EFAULT;
> +             goto end_function;
> +     }
> +
> +     hash = (void __user *)(unsigned long)command_args.callerIdAddress;
> +
> +     if (!command_args.pid || !command_args.callerIdSizeInBytes) {
> +             error = -EINVAL;
> +             goto end_function;
> +     }
> +
> +     dev_dbg(&sep->pdev->dev, "pid is %x\n", command_args.pid);
> +     dev_dbg(&sep->pdev->dev, "callerIdSizeInBytes is %x\n",
> +             command_args.callerIdSizeInBytes);
> +
> +     if (command_args.callerIdSizeInBytes >
> +                                     SEP_CALLER_ID_HASH_SIZE_IN_BYTES) {

Is it legal to have a smaller hash than SEP_CALLER_ID_HASH_SIZE_IN_BYTES?  If so, since you don't store the size, how will SEP know what the real size is?  If it is not legal, then you should enforce that command_args.callerIdSizeInBytes == SEP_CALLER_ID_HASH_SIZE_IN_BYTES.

> +             error = -EMSGSIZE;
> +             goto end_function;
> +     }
> +
> +     sep->caller_id_table[i].pid = command_args.pid;

Do you really trust the userspace caller to give you its pid?

> +
> +     if (copy_from_user(sep->caller_id_table[i].callerIdHash,
> +             hash, command_args.callerIdSizeInBytes))
> +             error = -EFAULT;

You should 0 sep->caller_id_table[i].pid when the copy fails (or better, don't set pid until after the copy succeeds).

Shouldn't you 0 the end of callerIdHash (SEP_CALLER_ID_HASH_SIZE_IN_BYTES - command_args.callerIdSizeInBytes)?

> +end_function:
> +     return error;
> +}
> +
> +/**
> + *   sep_set_current_caller_id - set the caller id
> + *   @sep: pointer to struct_sep_device
> + *
> + *   Set the caller ID (if it exists) to the SEP. Note that this
> + *   function falls under the ioctl lock
> + */
> +static int sep_set_current_caller_id(struct sep_device *sep)
> +{
> +     int i;
> +     u32 *hash_buf_ptr;
> +
> +     /* Zero the previous value */
> +     memset(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
> +                                     0, SEP_CALLER_ID_HASH_SIZE_IN_BYTES);

Why?

> +
> +     for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
> +             if (sep->caller_id_table[i].pid == current->pid) {
> +                     dev_dbg(&sep->pdev->dev, "Caller Id found\n");
> +
> +                     memcpy(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
> +                             (void *)(sep->caller_id_table[i].callerIdHash),
> +                             SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
> +                     break;
> +             }
> +     }

How are you guaranteeing that the current caller (current->pid) is always in the array?

> +     /* Ensure data is in little endian */
> +     hash_buf_ptr = (u32 *)sep->shared_addr +
> +             SEP_CALLER_ID_OFFSET_BYTES;
> +
> +     for (i = 0; i < SEP_CALLER_ID_HASH_SIZE_IN_WORDS; i++)
> +             hash_buf_ptr[i] = cpu_to_le32(hash_buf_ptr[i]);
> +
> +     return 0;
> +}

It would be more efficient to check the list first and do nothing if the pid isn't found in the list.

> +
> +/**
> + *   sep_send_command_handler - kick off a command
> + *   @sep: SEP being signalled
> + *
> + *   This function raises interrupt to SEP that signals that is has a new
> + *   command from the host
> + *
> + *      Note that this function does fall under the ioctl lock
> + */
> +static int sep_send_command_handler(struct sep_device *sep)
> +{
> +     unsigned long lck_flags;
> +     int error = 0;
> +
> +     if (test_and_set_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
> +             error = -EPROTO;
> +             goto end_function;

'return -EPROTO;'

> +     }
> +     sep_set_time(sep);

You need to set the time for each command?  What is the device doing with this?

> +
> +     sep_set_current_caller_id(sep);
> +
> +     sep_dump_message(sep);
> +
> +     /* Update counter */
> +     spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> +     sep->send_ct++;
> +     spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> +
> +     dev_dbg(&sep->pdev->dev,
> +             "sep_send_command_handler send_ct %lx reply_ct %lx\n",
> +                                             sep->send_ct, sep->reply_ct);
> +
> +     /* Send interrupt to SEP */
> +     sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
> +
> +end_function:
> +     return error;
> +}
> +
> +/**
> + *   sep_allocate_data_pool_memory_handler -allocate pool memory
> + *   @sep: pointer to struct sep_device
> + *   @arg: pointer to struct alloc_struct
> + *
> + *   This function handles the allocate data pool memory request
> + *   This function returns calculates the bus address of the
> + *   allocated memory, and the offset of this area from the mapped address.
> + *   Therefore, the FVOs in user space can calculate the exact virtual
> + *   address of this allocated memory
> + */
> +static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
> +     unsigned long arg)
> +{
> +     int error = 0;

Again, not needed.  I'm going to stop flagging this issue in the rest of the code, but you should remove the unnecessary error vars and remove the goto's--it is harder to read and less efficient.

> +     struct alloc_struct command_args;
> +
> +     /* Holds the allocated buffer address in the system memory pool */
> +     u32 *token_addr;
> +
> +     if (copy_from_user(&command_args, (void __user *)arg,
> +                                     sizeof(struct alloc_struct))) {
> +             error = -EFAULT;
> +             goto end_function;
> +     }
> +
> +     /* Allocate memory */
> +     if ((sep->data_pool_bytes_allocated + command_args.num_bytes) >
> +             SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
> +             error = -ENOMEM;
> +             goto end_function;
> +     }
> +
> +     dev_dbg(&sep->pdev->dev,
> +             "data pool bytes_allocated: %x\n", (int)sep->data_pool_bytes_allocated);
> +     dev_dbg(&sep->pdev->dev,
> +             "offset: %x\n", SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES);
> +     /* Set the virtual and bus address */
> +     command_args.offset = SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
> +             sep->data_pool_bytes_allocated;
> +
> +     /* Place in the shared area that is known by the SEP */
> +     token_addr = (u32 *)(sep->shared_addr +
> +             SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES +
> +             (sep->num_of_data_allocations)*2*sizeof(u32));
> +
> +     token_addr[0] = SEP_DATA_POOL_POINTERS_VAL_TOKEN;
> +     token_addr[1] = (u32)sep->shared_bus +
> +             SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
> +             sep->data_pool_bytes_allocated;
> +
> +     /* Write the memory back to the user space */
> +     error = copy_to_user((void *)arg, (void *)&command_args,

'(void __user *)arg'?
You should do this before writing to the SEP shared space, since this can fail.

> +             sizeof(struct alloc_struct));
> +     if (error) {
> +             error = -EFAULT;
> +             goto end_function;
> +     }
> +
> +     /* Update the allocation */
> +     sep->data_pool_bytes_allocated += command_args.num_bytes;
> +     sep->num_of_data_allocations += 1;
> +
> +end_function:
> +     return error;
> +}
> +
> +/**
> + *   sep_lock_kernel_pages - map kernel pages for DMA
> + *   @sep: pointer to struct sep_device
> + *   @kernel_virt_addr: address of data buffer in kernel
> + *   @data_size: size of data
> + *   @lli_array_ptr: lli array
> + *   @in_out_flag: input into device or output from device
> + *
> + *   This function locks all the physical pages of the kernel virtual buffer
> + *   and construct a basic lli  array, where each entry holds the physical

"lli  array," => "lli array,"

> + *   page address and the size that application data holds in this page
> + *   This function is used only during kernel crypto mod calls from within
> + *   the kernel (when ioctl is not used)
> + */
> +static int sep_lock_kernel_pages(struct sep_device *sep,
> +     unsigned long kernel_virt_addr,
> +     u32 data_size,
> +     struct sep_lli_entry **lli_array_ptr,
> +     int in_out_flag)
> +
> +{
> +     int error = 0;
> +     /* Array of lli */
> +     struct sep_lli_entry *lli_array;
> +     /* Map array */
> +     struct sep_dma_map *map_array;
> +
> +     dev_dbg(&sep->pdev->dev, "lock kernel pages kernel_virt_addr is %08lx\n",
> +                             (unsigned long)kernel_virt_addr);
> +     dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
> +
> +     lli_array = kmalloc(sizeof(struct sep_lli_entry), GFP_ATOMIC);
> +     if (!lli_array) {
> +             error = -ENOMEM;
> +             goto end_function;
> +     }
> +     map_array = kmalloc(sizeof(struct sep_dma_map), GFP_ATOMIC);
> +     if (!map_array) {
> +             error = -ENOMEM;
> +             goto end_function_with_error;
> +     }
> +
> +     map_array[0].dma_addr =
> +             dma_map_single(&sep->pdev->dev, (void *)kernel_virt_addr,
> +             data_size, DMA_BIDIRECTIONAL);

There is only one element in this, so just use 'map_array->' notation.
Why don't you check this for an error?

> +     map_array[0].size = data_size;
> +
> +
> +     /*
> +      * Set the start address of the first page - app data may start not at
> +      * the beginning of the page
> +      */
> +     lli_array[0].bus_address = (u32)map_array[0].dma_addr;

Ditto for using '->' syntax.

> +     lli_array[0].block_size = map_array[0].size;
> +
> +     dev_dbg(&sep->pdev->dev,
> +     "lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
> +             (unsigned long)lli_array[0].bus_address,
> +             lli_array[0].block_size);
> +
> +     /* Set the output parameters */
> +     if (in_out_flag == SEP_DRIVER_IN_FLAG) {
> +             *lli_array_ptr = lli_array;

Test lli_array_ptr for NULL.

> +             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 1;
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries = 1;
> +     } else {
> +             *lli_array_ptr = lli_array;

Ditto.

> +             sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = 1;
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_page_array = NULL;
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries = 1;
> +     }

You don't need to increment sep->nr_dcb_creat?

> +     goto end_function;
> +
> +end_function_with_error:
> +     kfree(lli_array);
> +
> +end_function:
> +     return error;
> +}
> +
> +/**
> + *   sep_lock_user_pages - lock and map user pages for DMA
> + *   @sep: pointer to struct sep_device
> + *   @app_virt_addr: user memory data buffer
> + *   @data_size: size of data buffer
> + *   @lli_array_ptr: lli array
> + *   @in_out_flag: input or output to device
> + *
> + *   This function locks all the physical pages of the application
> + *   virtual buffer and construct a basic lli  array, where each entry

"lli  array," => "lli array,"

> + *   holds the physical page address and the size that application
> + *   data holds in this physical pages
> + */
> +static int sep_lock_user_pages(struct sep_device *sep,
> +     u32 app_virt_addr,

Why not u64--how will you handle the max userspace VA?

> +     u32 data_size,
> +     struct sep_lli_entry **lli_array_ptr,
> +     int in_out_flag)
> +
> +{
> +     int error = 0;
> +     u32 count;
> +     int result;
> +     /* The the page of the end address of the user space buffer */

"The the" => "The"

> +     u32 end_page;
> +     /* The page of the start address of the user space buffer */
> +     u32 start_page;
> +     /* The range in pages */
> +     u32 num_pages;
> +     /* Array of pointers to page */
> +     struct page **page_array;
> +     /* Array of lli */
> +     struct sep_lli_entry *lli_array;
> +     /* Map array */
> +     struct sep_dma_map *map_array;
> +     /* Direction of the DMA mapping for locked pages */
> +     enum dma_data_direction dir;
> +
> +     /* Set start and end pages  and num pages */

"pages  and" => "pages and"

> +     end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
> +     start_page = app_virt_addr >> PAGE_SHIFT;
> +     num_pages = end_page - start_page + 1;
> +
> +     dev_dbg(&sep->pdev->dev, "lock user pages app_virt_addr is %x\n", app_virt_addr);
> +     dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
> +     dev_dbg(&sep->pdev->dev, "start_page is %x\n", start_page);
> +     dev_dbg(&sep->pdev->dev, "end_page is %x\n", end_page);
> +     dev_dbg(&sep->pdev->dev, "num_pages is %x\n", num_pages);
> +
> +     /* Allocate array of pages structure pointers */
> +     page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
> +     if (!page_array) {
> +             error = -ENOMEM;
> +             goto end_function;
> +     }
> +     map_array = kmalloc(sizeof(struct sep_dma_map) * num_pages, GFP_ATOMIC);
> +     if (!map_array) {
> +             dev_warn(&sep->pdev->dev, "kmalloc for map_array failed\n");
> +             error = -ENOMEM;
> +             goto end_function_with_error1;
> +     }
> +
> +     lli_array = kmalloc(sizeof(struct sep_lli_entry) * num_pages,
> +             GFP_ATOMIC);
> +
> +     if (!lli_array) {
> +             dev_warn(&sep->pdev->dev, "kmalloc for lli_array failed\n");
> +             error = -ENOMEM;
> +             goto end_function_with_error2;
> +     }
> +
> +     /* Convert the application virtual address into a set of physical */
> +     down_read(&current->mm->mmap_sem);
> +     result = get_user_pages(current, current->mm, app_virt_addr,
> +             num_pages,
> +             ((in_out_flag == SEP_DRIVER_IN_FLAG) ? 0 : 1),
> +             0, page_array, NULL);
> +
> +     up_read(&current->mm->mmap_sem);
> +
> +     /* Check the number of pages locked - if not all then exit with error */
> +     if (result != num_pages) {
> +             dev_warn(&sep->pdev->dev,
> +                     "not all pages locked by get_user_pages\n");
> +             error = -ENOMEM;
> +             goto end_function_with_error3;
> +     }
> +
> +     dev_dbg(&sep->pdev->dev, "get_user_pages succeeded\n");
> +
> +     /* Set direction */
> +     if (in_out_flag == SEP_DRIVER_IN_FLAG)
> +             dir = DMA_TO_DEVICE;
> +     else
> +             dir = DMA_FROM_DEVICE;
> +
> +     /*
> +      * Fill the array using page array data and
> +      * map the pages - this action will also flush the cache as needed
> +      */
> +     for (count = 0; count < num_pages; count++) {
> +             /* Fill the map array */
> +             map_array[count].dma_addr =
> +                     dma_map_page(&sep->pdev->dev, page_array[count],
> +                     0, PAGE_SIZE, /*dir*/DMA_BIDIRECTIONAL);

Why DMA_BIDIRECTIONAL and not dir?
Handle failure?

> +
> +             map_array[count].size = PAGE_SIZE;
> +
> +             /* Fill the lli array entry */
> +             lli_array[count].bus_address = (u32)map_array[count].dma_addr;
> +             lli_array[count].block_size = PAGE_SIZE;
> +
> +             dev_warn(&sep->pdev->dev, "lli_array[%x].bus_address is %08lx,
> lli_array[%x].block_size is %x\n",
> +                     count, (unsigned long)lli_array[count].bus_address,
> +                     count, lli_array[count].block_size);
> +     }
> +
> +     /* Check the offset for the first page */

This isn't a "check", it's a "set"/assignment.  And it needs a (better) explanation.

> +     lli_array[0].bus_address =
> +             lli_array[0].bus_address + (app_virt_addr & (~PAGE_MASK));
> +
> +     /* Check that not all the data is in the first page only */
> +     if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >= data_size)
> +             lli_array[0].block_size = data_size;
> +     else

Also needs an explanation.

> +             lli_array[0].block_size =
> +                     PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
> +
> +     dev_dbg(&sep->pdev->dev,
> +             "lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
> +             (unsigned long)lli_array[count].bus_address,
> +             lli_array[count].block_size);
> +
> +     /* Check the size of the last page */
> +     if (num_pages > 1) {
> +             lli_array[num_pages - 1].block_size =
> +                     (app_virt_addr + data_size) & (~PAGE_MASK);
> +
> +             dev_warn(&sep->pdev->dev,
> +                     "lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
> +                     num_pages - 1,
> +                     (unsigned long)lli_array[count].bus_address,
> +                     num_pages - 1,
> +                     lli_array[count].block_size);
> +     }
> +
> +     /* Set output params according to the in_out flag */
> +     if (in_out_flag == SEP_DRIVER_IN_FLAG) {
> +             *lli_array_ptr = lli_array;

NULL check

> +             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = num_pages;
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = page_array;
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries =
> +                                                             num_pages;
> +     } else {
> +             *lli_array_ptr = lli_array;
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = num_pages;
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_page_array =
> +                                                             page_array;
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries =
> +                                                             num_pages;
> +     }
> +     goto end_function;
> +
> +end_function_with_error3:
> +     /* Free lli array */
> +     kfree(lli_array);
> +
> +end_function_with_error2:
> +     kfree(map_array);
> +
> +end_function_with_error1:
> +     /* Free page array */
> +     kfree(page_array);

If you assign NULL to these initially then you can have a single error entry that free's all of them.

> +
> +end_function:
> +     return error;
> +}
> +
> +/**
> + *   u32 sep_calculate_lli_table_max_size - size the LLI table
> + *   @sep: pointer to struct sep_device
> + *   @lli_in_array_ptr
> + *   @num_array_entries
> + *   @last_table_flag
> + *
> + *   This function calculates the size of data that can be inserted into
> + *   the lli table from this array, such that either the table is full
> + *   (all entries are entered), or there are no more entries in the
> + *   lli array
> + */
> +static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
> +     struct sep_lli_entry *lli_in_array_ptr,
> +     u32 num_array_entries,
> +     u32 *last_table_flag)
> +{
> +     u32 counter;
> +     /* Table data size */
> +     u32 table_data_size = 0;
> +     /* Data size for the next table */
> +     u32 next_table_data_size;
> +
> +     *last_table_flag = 0;

NULL check.  Also the last time I'll flag this--it is best to check even internal calls unless there is no chance that current or future code could have bug which passes NULL.

> +
> +     /*
> +      * Calculate the data in the out lli table till we fill the whole
> +      * table or till the data has ended
> +      */
> +     for (counter = 0;
> +             (counter < (SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP - 1)) &&

Why 'SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP - 1'?

> +                     (counter < num_array_entries); counter++)
> +             table_data_size += lli_in_array_ptr[counter].block_size;

NULL check lli_in_array_ptr

> +
> +     /*
> +      * Check if we reached the last entry,
> +      * meaning this ia the last table to build,

"ia" => "is"

> +      * and no need to check the block alignment
> +      */
> +     if (counter == num_array_entries) {
> +             /* Set the last table flag */
> +             *last_table_flag = 1;
> +             goto end_function;
> +     }
> +
> +     /*
> +      * Calculate the data size of the next table.
> +      * Stop if no entries left or if data size is more the DMA restriction
> +      */
> +     next_table_data_size = 0;
> +     for (; counter < num_array_entries; counter++) {
> +             next_table_data_size += lli_in_array_ptr[counter].block_size;
> +             if (next_table_data_size >= SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
> +                     break;
> +     }
> +
> +     /*
> +      * Check if the next table data size is less then DMA rstriction.
> +      * if it is - recalculate the current table size, so that the next
> +      * table data size will be adaquete for DMA
> +      */
> +     if (next_table_data_size &&

How can next_table_data_size == 0?

> +             next_table_data_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
> +
> +             table_data_size -= (SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE -
> +                     next_table_data_size);
> +
> +end_function:
> +     return table_data_size;
> +}
> +
> +/**
> + *   sep_build_lli_table - build an lli array for the given table
> + *   @sep: pointer to struct sep_device
> + *   @lli_array_ptr: pointer to lli array
> + *   @lli_table_ptr: pointer to lli table
> + *   @num_processed_entries_ptr: pointer to number of entries
> + *   @num_table_entries_ptr: pointer to number of tables
> + *   @table_data_size: total data size
> + *
> + *   Builds ant lli table from the lli_array according to
> + *   the given size of data
> + */
> +static void sep_build_lli_table(struct sep_device *sep,
> +     struct sep_lli_entry    *lli_array_ptr,
> +     struct sep_lli_entry    *lli_table_ptr,
> +     u32 *num_processed_entries_ptr,
> +     u32 *num_table_entries_ptr,
> +     u32 table_data_size)
> +{
> +     /* Current table data size */
> +     u32 curr_table_data_size;
> +     /* Counter of lli array entry */
> +     u32 array_counter;
> +
> +     /* Init currrent table data size and lli array entry counter */
> +     curr_table_data_size = 0;
> +     array_counter = 0;
> +     *num_table_entries_ptr = 1;
> +
> +     dev_dbg(&sep->pdev->dev, "build lli table table_data_size is %x\n", table_data_size);
> +
> +     /* Fill the table till table size reaches the needed amount */
> +     while (curr_table_data_size < table_data_size) {

It seems risky not to be checking that you don't go past the end of lli_table_ptr's allocated memory.

> +             /* Update the number of entries in table */
> +             (*num_table_entries_ptr)++;
> +
> +             lli_table_ptr->bus_address =
> +                     cpu_to_le32(lli_array_ptr[array_counter].bus_address);
> +
> +             lli_table_ptr->block_size =
> +                     cpu_to_le32(lli_array_ptr[array_counter].block_size);
> +
> +             curr_table_data_size += lli_array_ptr[array_counter].block_size;
> +
> +             dev_dbg(&sep->pdev->dev, "lli_table_ptr is %p\n",
> +                                                             lli_table_ptr);
> +             dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address is %08lx\n",
> +                             (unsigned long)lli_table_ptr->bus_address);
> +             dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
> +                     lli_table_ptr->block_size);
> +
> +             /* Check for overflow of the table data */
> +             if (curr_table_data_size > table_data_size) {
> +                     dev_dbg(&sep->pdev->dev,
> +                             "curr_table_data_size too large\n");
> +
> +                     /* Update the size of block in the table */
> +                     lli_table_ptr->block_size -=
> +                     cpu_to_le32((curr_table_data_size - table_data_size));
> +
> +                     /* Update the physical address in the lli array */
> +                     lli_array_ptr[array_counter].bus_address +=
> +                     cpu_to_le32(lli_table_ptr->block_size);
> +
> +                     /* Update the block size left in the lli array */
> +                     lli_array_ptr[array_counter].block_size =
> +                             (curr_table_data_size - table_data_size);
> +             } else
> +                     /* Advance to the next entry in the lli_array */
> +                     array_counter++;
> +
> +             dev_dbg(&sep->pdev->dev,
> +                     "lli_table_ptr->bus_address is %08lx\n",
> +                             (unsigned long)lli_table_ptr->bus_address);
> +             dev_dbg(&sep->pdev->dev,
> +                     "lli_table_ptr->block_size is %x\n",
> +                     lli_table_ptr->block_size);
> +
> +             /* Move to the next entry in table */
> +             lli_table_ptr++;
> +     }
> +
> +     /* Set the info entry to default */
> +     lli_table_ptr->bus_address = 0xffffffff;
> +     lli_table_ptr->block_size = 0;
> +
> +     /* Set the output parameter */
> +     *num_processed_entries_ptr += array_counter;
> +
> +}
> +
> +/**
> + *   sep_shared_area_virt_to_bus - map shared area to bus address
> + *   @sep: pointer to struct sep_device
> + *   @virt_address: virtual address to convert
> + *
> + *   This functions returns the physical address inside shared area according
> + *   to the virtual address. It can be either on the externa RAM device

"externa" => "external"

> + *   (ioremapped), or on the system RAM
> + *   This implementation is for the external RAM
> + */
> +static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
> +     void *virt_address)
> +{
> +     dev_dbg(&sep->pdev->dev, "sh virt to phys v %p\n", virt_address);
> +     dev_dbg(&sep->pdev->dev, "sh virt to phys p %08lx\n",
> +             (unsigned long)
> +             sep->shared_bus + (virt_address - sep->shared_addr));
> +
> +     return sep->shared_bus + (size_t)(virt_address - sep->shared_addr);
> +}
> +
> +/**
> + *   sep_shared_area_bus_to_virt - map shared area bus address to kernel
> + *   @sep: pointer to struct sep_device
> + *   @bus_address: bus address to convert
> + *
> + *   This functions returns the virtual address inside shared area
> + *   according to the physical address. It can be either on the
> + *   externa RAM device (ioremapped), or on the system RAM

"externa" => "external"

> + *   This implementation is for the external RAM
> + */
> +static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
> +     dma_addr_t bus_address)
> +{
> +     dev_dbg(&sep->pdev->dev, "shared bus to virt b=%lx v=%lx\n",
> +             (unsigned long)bus_address, (unsigned long)(sep->shared_addr +
> +                     (size_t)(bus_address - sep->shared_bus)));
> +
> +     return sep->shared_addr + (size_t)(bus_address - sep->shared_bus);
> +}
> +
> +/**
> + *   sep_debug_print_lli_tables - dump LLI table
> + *   @sep: pointer to struct sep_device
> + *   @lli_table_ptr: pointer to sep_lli_entry
> + *   @num_table_entries: number of entries
> + *   @table_data_size: total data size
> + *
> + *   Walk the the list of the print created tables and print all the data
> + */
> +static void sep_debug_print_lli_tables(struct sep_device *sep,
> +     struct sep_lli_entry *lli_table_ptr,
> +     unsigned long num_table_entries,
> +     unsigned long table_data_size)
> +{
> +     unsigned long table_count = 1;
> +     unsigned long entries_count = 0;
> +
> +     dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables start\n");
> +
> +     while ((unsigned long) lli_table_ptr->bus_address != 0xffffffff) {
> +             dev_dbg(&sep->pdev->dev,
> +                     "lli table %08lx, table_data_size is %lu\n",
> +                     table_count, table_data_size);
> +             dev_dbg(&sep->pdev->dev, "num_table_entries is %lu\n",
> +                                                     num_table_entries);
> +
> +             /* Print entries of the table (without info entry) */
> +             for (entries_count = 0; entries_count < num_table_entries;
> +                     entries_count++, lli_table_ptr++) {
> +
> +                     dev_dbg(&sep->pdev->dev,
> +                             "lli_table_ptr address is %08lx\n",
> +                             (unsigned long) lli_table_ptr);
> +
> +                     dev_dbg(&sep->pdev->dev,
> +                             "phys address is %08lx block size is %x\n",
> +                             (unsigned long)lli_table_ptr->bus_address,
> +                             lli_table_ptr->block_size);
> +             }
> +             /* Point to the info entry */
> +             lli_table_ptr--;
> +
> +             dev_dbg(&sep->pdev->dev,
> +                     "phys lli_table_ptr->block_size is %x\n",
> +                     lli_table_ptr->block_size);
> +
> +             dev_dbg(&sep->pdev->dev,
> +                     "phys lli_table_ptr->physical_address is %08lu\n",
> +                     (unsigned long)lli_table_ptr->bus_address);
> +
> +
> +             table_data_size = lli_table_ptr->block_size & 0xffffff;
> +             num_table_entries = (lli_table_ptr->block_size >> 24) & 0xff;
> +
> +             dev_dbg(&sep->pdev->dev,
> +                     "phys table_data_size is %lu num_table_entries is"
> +                     " %lu bus_address is%lu\n", table_data_size,
> +                     num_table_entries, (unsigned long)lli_table_ptr->bus_address);
> +
> +             if ((unsigned long)lli_table_ptr->bus_address != 0xffffffff)
> +                     lli_table_ptr = (struct sep_lli_entry *)
> +                             sep_shared_bus_to_virt(sep,
> +                             (unsigned long)lli_table_ptr->bus_address);
> +
> +             table_count++;
> +     }
> +     dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables end\n");
> +}
> +
> +
> +/**
> + *   sep_prepare_empty_lli_table - create a blank LLI table
> + *   @sep: pointer to struct sep_device
> + *   @lli_table_addr_ptr: pointer to lli table
> + *   @num_entries_ptr: pointer to number of entries
> + *   @table_data_size_ptr: point to table data size
> + *
> + *   This function creates empty lli tables when there is no data
> + */
> +static void sep_prepare_empty_lli_table(struct sep_device *sep,
> +             dma_addr_t *lli_table_addr_ptr,
> +             u32 *num_entries_ptr,
> +             u32 *table_data_size_ptr)
> +{
> +     struct sep_lli_entry *lli_table_ptr;
> +
> +     /* Find the area for new table */
> +     lli_table_ptr =
> +             (struct sep_lli_entry *)(sep->shared_addr +
> +             SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> +             sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
> +                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
> +
> +     lli_table_ptr->bus_address = 0;
> +     lli_table_ptr->block_size = 0;
> +
> +     lli_table_ptr++;
> +     lli_table_ptr->bus_address = 0xFFFFFFFF;
> +     lli_table_ptr->block_size = 0;
> +
> +     /* Set the output parameter value */
> +     *lli_table_addr_ptr = sep->shared_bus +
> +             SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> +             sep->num_lli_tables_created *
> +             sizeof(struct sep_lli_entry) *
> +             SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
> +
> +     /* Set the num of entries and table data size for empty table */
> +     *num_entries_ptr = 2;
> +     *table_data_size_ptr = 0;
> +
> +     /* Update the number of created tables */
> +     sep->num_lli_tables_created++;
> +}
> +
> +/**
> + *   sep_prepare_input_dma_table - prepare input DMA mappings
> + *   @sep: pointer to struct sep_device
> + *   @data_size:
> + *   @block_size:
> + *   @lli_table_ptr:
> + *   @num_entries_ptr:
> + *   @table_data_size_ptr:
> + *   @is_kva: set for kernel data (kernel cryptio call)

"cryptio" => "crypto"

> + *
> + *   This function prepares only input DMA table for synhronic symmetric

"synhronic" => "synchronous"

> + *   operations (HASH)
> + *   Note that all bus addresses that are passed to the SEP
> + *   are in 32 bit format; the SEP is a 32 bit device
> + */
> +static int sep_prepare_input_dma_table(struct sep_device *sep,
> +     unsigned long app_virt_addr,
> +     u32 data_size,
> +     u32 block_size,
> +     dma_addr_t *lli_table_ptr,
> +     u32 *num_entries_ptr,
> +     u32 *table_data_size_ptr,
> +     bool is_kva)
> +{
> +     int error = 0;
> +     /* Pointer to the info entry of the table - the last entry */
> +     struct sep_lli_entry *info_entry_ptr;
> +     /* Array of pointers to page */
> +     struct sep_lli_entry *lli_array_ptr;
> +     /* Points to the first entry to be processed in the lli_in_array */
> +     u32 current_entry = 0;
> +     /* Num entries in the virtual buffer */
> +     u32 sep_lli_entries = 0;
> +     /* Lli table pointer */
> +     struct sep_lli_entry *in_lli_table_ptr;
> +     /* The total data in one table */
> +     u32 table_data_size = 0;
> +     /* Flag for last table */
> +     u32 last_table_flag = 0;
> +     /* Number of entries in lli table */
> +     u32 num_entries_in_table = 0;
> +     /* Next table address */
> +     void *lli_table_alloc_addr = 0;
> +
> +     dev_dbg(&sep->pdev->dev, "prepare intput dma table data_size is %x\n", data_size);
> +     dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
> +
> +     /* Initialize the pages pointers */
> +     sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
> +     sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 0;
> +
> +     /* Set the kernel address for first table to be allocated */
> +     lli_table_alloc_addr = (void *)(sep->shared_addr +
> +             SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> +             sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
> +             SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
> +
> +     if (data_size == 0) {
> +             /* Special case  - create meptu table - 2 entries, zero data */

"meptu"?

> +             sep_prepare_empty_lli_table(sep, lli_table_ptr,
> +                             num_entries_ptr, table_data_size_ptr);
> +             goto update_dcb_counter;
> +     }
> +
> +     /* Check if the pages are in Kernel Virtual Address layout */
> +     if (is_kva == true)

Just '(is_kva)'

> +             /* Lock the pages in the kernel */
> +             error = sep_lock_kernel_pages(sep, app_virt_addr,
> +                     data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
> +     else
> +             /*
> +              * Lock the pages of the user buffer
> +              * and translate them to pages
> +              */
> +             error = sep_lock_user_pages(sep, app_virt_addr,
> +                     data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
> +
> +     if (error)
> +             goto end_function;
> +
> +     dev_dbg(&sep->pdev->dev, "output sep_in_num_pages is %x\n",
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
> +
> +     current_entry = 0;
> +     info_entry_ptr = NULL;
> +
> +     sep_lli_entries = sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages;
> +
> +     /* Loop till all the entries in in array are not processed */
> +     while (current_entry < sep_lli_entries) {
> +
> +             /* Set the new input and output tables */
> +             in_lli_table_ptr =
> +                     (struct sep_lli_entry *)lli_table_alloc_addr;
> +
> +             lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
> +                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
> +
> +             if (lli_table_alloc_addr >
> +                     ((void *)sep->shared_addr +
> +                     SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> +                     SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
> +
> +                     error = -ENOMEM;
> +                     goto end_function_error;

You've already locked the pages--don't you need to unlock them?

> +
> +             }
> +
> +             /* Update the number of created tables */
> +             sep->num_lli_tables_created++;
> +
> +             /* Calculate the maximum size of data for input table */
> +             table_data_size = sep_calculate_lli_table_max_size(sep,
> +                     &lli_array_ptr[current_entry],
> +                     (sep_lli_entries - current_entry),
> +                     &last_table_flag);
> +
> +             /*
> +              * If this is not the last table -
> +              * then align it to the block size
> +              */
> +             if (!last_table_flag)
> +                     table_data_size =
> +                             (table_data_size / block_size) * block_size;
> +
> +             dev_dbg(&sep->pdev->dev, "output table_data_size is %x\n",
> +                                                     table_data_size);
> +
> +             /* Construct input lli table */
> +             sep_build_lli_table(sep, &lli_array_ptr[current_entry],
> +                     in_lli_table_ptr,
> +                     &current_entry, &num_entries_in_table, table_data_size);
> +
> +             if (info_entry_ptr == NULL) {
> +
> +                     /* Set the output parameters to physical addresses */
> +                     *lli_table_ptr = sep_shared_area_virt_to_bus(sep,
> +                             in_lli_table_ptr);
> +                     *num_entries_ptr = num_entries_in_table;
> +                     *table_data_size_ptr = table_data_size;
> +
> +                     dev_dbg(&sep->pdev->dev,
> +                             "output lli_table_in_ptr is %08lx\n",
> +                             (unsigned long)*lli_table_ptr);
> +
> +             } else {
> +                     /* Update the info entry of the previous in table */
> +                     info_entry_ptr->bus_address =
> +                             sep_shared_area_virt_to_bus(sep,
> +                                                     in_lli_table_ptr);
> +                     info_entry_ptr->block_size =
> +                             ((num_entries_in_table) << 24) |
> +                             (table_data_size);
> +             }
> +             /* Save the pointer to the info entry of the current tables */
> +             info_entry_ptr = in_lli_table_ptr + num_entries_in_table - 1;
> +     }
> +     /* Print input tables */
> +     sep_debug_print_lli_tables(sep, (struct sep_lli_entry *)
> +             sep_shared_area_bus_to_virt(sep, *lli_table_ptr),
> +             *num_entries_ptr, *table_data_size_ptr);
> +     /* The array of the pages */
> +     kfree(lli_array_ptr);
> +
> +update_dcb_counter:
> +     /* Update DCB counter */
> +     sep->nr_dcb_creat++;
> +     goto end_function;
> +
> +end_function_error:
> +     /* Free all the allocated resources */
> +     kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
> +     kfree(lli_array_ptr);
> +     kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
> +
> +end_function:
> +     return error;
> +
> +}
> +/**
> + *   sep_construct_dma_tables_from_lli - prepare AES/DES mappings
> + *   @sep: pointer to struct sep_device
> + *   @lli_in_array:
> + *   @sep_in_lli_entries:
> + *   @lli_out_array:
> + *   @sep_out_lli_entries
> + *   @block_size
> + *   @lli_table_in_ptr
> + *   @lli_table_out_ptr
> + *   @in_num_entries_ptr
> + *   @out_num_entries_ptr
> + *   @table_data_size_ptr
> + *
> + *   This function creates the input and output DMA tables for
> + *   symmetric operations (AES/DES) according to the block
> + *   size from LLI arays
> + *   Note that all bus addresses that are passed to the SEP
> + *   are in 32 bit format; the SEP is a 32 bit device
> + */
> +static int sep_construct_dma_tables_from_lli(
> +     struct sep_device *sep,
> +     struct sep_lli_entry *lli_in_array,
> +     u32     sep_in_lli_entries,
> +     struct sep_lli_entry *lli_out_array,
> +     u32     sep_out_lli_entries,
> +     u32     block_size,
> +     dma_addr_t *lli_table_in_ptr,
> +     dma_addr_t *lli_table_out_ptr,
> +     u32     *in_num_entries_ptr,
> +     u32     *out_num_entries_ptr,
> +     u32     *table_data_size_ptr)
> +{
> +     /* Points to the area where next lli table can be allocated */
> +     void *lli_table_alloc_addr = 0;
> +     /* Input lli table */
> +     struct sep_lli_entry *in_lli_table_ptr = NULL;
> +     /* Output lli table */
> +     struct sep_lli_entry *out_lli_table_ptr = NULL;
> +     /* Pointer to the info entry of the table - the last entry */
> +     struct sep_lli_entry *info_in_entry_ptr = NULL;
> +     /* Pointer to the info entry of the table - the last entry */
> +     struct sep_lli_entry *info_out_entry_ptr = NULL;
> +     /* Points to the first entry to be processed in the lli_in_array */
> +     u32 current_in_entry = 0;
> +     /* Points to the first entry to be processed in the lli_out_array */
> +     u32 current_out_entry = 0;
> +     /* Max size of the input table */
> +     u32 in_table_data_size = 0;
> +     /* Max size of the output table */
> +     u32 out_table_data_size = 0;
> +     /* Flag te signifies if this is the last tables build */
> +     u32 last_table_flag = 0;
> +     /* The data size that should be in table */
> +     u32 table_data_size = 0;
> +     /* Number of etnries in the input table */
> +     u32 num_entries_in_table = 0;
> +     /* Number of etnries in the output table */
> +     u32 num_entries_out_table = 0;
> +
> +     /* Initiate to point after the message area */

"Initiate" => "Initialize"

*** review stopped here ***

> +     lli_table_alloc_addr = (void *)(sep->shared_addr +
> +             SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> +             (sep->num_lli_tables_created *
> +             (sizeof(struct sep_lli_entry) *
> +             SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP)));
> +
> +     /* Loop till all the entries in in array are not processed */
> +     while (current_in_entry < sep_in_lli_entries) {
> +             /* Set the new input and output tables */
> +             in_lli_table_ptr =
> +                     (struct sep_lli_entry *)lli_table_alloc_addr;
> +
> +             lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
> +                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
> +
> +             /* Set the first output tables */
> +             out_lli_table_ptr =
> +                     (struct sep_lli_entry *)lli_table_alloc_addr;
> +
> +             /* Check if the DMA table area limit was overrun */
> +             if ((lli_table_alloc_addr + sizeof(struct sep_lli_entry) *
> +                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP) >
> +                     ((void *)sep->shared_addr +
> +                     SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> +                     SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
> +
> +                     dev_warn(&sep->pdev->dev, "dma table limit overrun\n");
> +                     return -ENOMEM;
> +             }
> +
> +             /* Update the number of the lli tables created */
> +             sep->num_lli_tables_created += 2;
> +
> +             lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
> +                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
> +
> +             /* Calculate the maximum size of data for input table */
> +             in_table_data_size =
> +                     sep_calculate_lli_table_max_size(sep,
> +                     &lli_in_array[current_in_entry],
> +                     (sep_in_lli_entries - current_in_entry),
> +                     &last_table_flag);
> +
> +             /* Calculate the maximum size of data for output table */
> +             out_table_data_size =
> +                     sep_calculate_lli_table_max_size(sep,
> +                     &lli_out_array[current_out_entry],
> +                     (sep_out_lli_entries - current_out_entry),
> +                     &last_table_flag);
> +
> +             dev_dbg(&sep->pdev->dev,
> +                     "construct tables from lli in_table_data_size is %x\n",
> +                     in_table_data_size);
> +
> +             dev_dbg(&sep->pdev->dev,
> +                     "construct tables from lli out_table_data_size is %x\n",
> +                     out_table_data_size);
> +
> +             table_data_size = in_table_data_size;
> +
> +             if (!last_table_flag) {
> +                     /*
> +                      * If this is not the last table,
> +                      * then must check where the data is smallest
> +                      * and then align it to the block size
> +                      */
> +                     if (table_data_size > out_table_data_size)
> +                             table_data_size = out_table_data_size;
> +
> +                     /*
> +                      * Now calculate the table size so that
> +                      * it will be module block size
> +                      */
> +                     table_data_size = (table_data_size / block_size) *
> +                             block_size;
> +             }
> +
> +             /* Construct input lli table */
> +             sep_build_lli_table(sep, &lli_in_array[current_in_entry],
> +                     in_lli_table_ptr,
> +                     &current_in_entry,
> +                     &num_entries_in_table,
> +                     table_data_size);
> +
> +             /* Construct output lli table */
> +             sep_build_lli_table(sep, &lli_out_array[current_out_entry],
> +                     out_lli_table_ptr,
> +                     &current_out_entry,
> +                     &num_entries_out_table,
> +                     table_data_size);
> +
> +             /* If info entry is null - this is the first table built */
> +             if (info_in_entry_ptr == NULL) {
> +                     /* Set the output parameters to physical addresses */
> +                     *lli_table_in_ptr =
> +                     sep_shared_area_virt_to_bus(sep, in_lli_table_ptr);
> +
> +                     *in_num_entries_ptr = num_entries_in_table;
> +
> +                     *lli_table_out_ptr =
> +                             sep_shared_area_virt_to_bus(sep,
> +                             out_lli_table_ptr);
> +
> +                     *out_num_entries_ptr = num_entries_out_table;
> +                     *table_data_size_ptr = table_data_size;
> +
> +                     dev_dbg(&sep->pdev->dev,
> +                     "output lli_table_in_ptr is %08lx\n",
> +                             (unsigned long)*lli_table_in_ptr);
> +                     dev_dbg(&sep->pdev->dev,
> +                     "output lli_table_out_ptr is %08lx\n",
> +                             (unsigned long)*lli_table_out_ptr);
> +             } else {
> +                     /* Update the info entry of the previous in table */
> +                     info_in_entry_ptr->bus_address =
> +                             sep_shared_area_virt_to_bus(sep,
> +                             in_lli_table_ptr);
> +
> +                     info_in_entry_ptr->block_size =
> +                             ((num_entries_in_table) << 24) |
> +                             (table_data_size);
> +
> +                     /* Update the info entry of the previous in table */
> +                     info_out_entry_ptr->bus_address =
> +                             sep_shared_area_virt_to_bus(sep,
> +                             out_lli_table_ptr);
> +
> +                     info_out_entry_ptr->block_size =
> +                             ((num_entries_out_table) << 24) |
> +                             (table_data_size);
> +
> +                     dev_dbg(&sep->pdev->dev,
> +                             "output lli_table_in_ptr:%08lx %08x\n",
> +                             (unsigned long)info_in_entry_ptr->bus_address,
> +                             info_in_entry_ptr->block_size);
> +
> +                     dev_dbg(&sep->pdev->dev,
> +                             "output lli_table_out_ptr:%08lx  %08x\n",
> +                             (unsigned long)info_out_entry_ptr->bus_address,
> +                             info_out_entry_ptr->block_size);
> +             }
> +
> +             /* Save the pointer to the info entry of the current tables */
> +             info_in_entry_ptr = in_lli_table_ptr +
> +                     num_entries_in_table - 1;
> +             info_out_entry_ptr = out_lli_table_ptr +
> +                     num_entries_out_table - 1;
> +
> +             dev_dbg(&sep->pdev->dev,
> +                     "output num_entries_out_table is %x\n",
> +                     (u32)num_entries_out_table);
> +             dev_dbg(&sep->pdev->dev,
> +                     "output info_in_entry_ptr is %lx\n",
> +                     (unsigned long)info_in_entry_ptr);
> +             dev_dbg(&sep->pdev->dev,
> +                     "output info_out_entry_ptr is %lx\n",
> +                     (unsigned long)info_out_entry_ptr);
> +     }
> +
> +     /* Print input tables */
> +     sep_debug_print_lli_tables(sep,
> +     (struct sep_lli_entry *)
> +     sep_shared_area_bus_to_virt(sep, *lli_table_in_ptr),
> +     *in_num_entries_ptr,
> +     *table_data_size_ptr);
> +
> +     /* Print output tables */
> +     sep_debug_print_lli_tables(sep,
> +     (struct sep_lli_entry *)
> +     sep_shared_area_bus_to_virt(sep, *lli_table_out_ptr),
> +     *out_num_entries_ptr,
> +     *table_data_size_ptr);
> +
> +     return 0;
> +}
> +
> +/**
> + *   sep_prepare_input_output_dma_table - prepare DMA I/O table
> + *   @app_virt_in_addr:
> + *   @app_virt_out_addr:
> + *   @data_size:
> + *   @block_size:
> + *   @lli_table_in_ptr:
> + *   @lli_table_out_ptr:
> + *   @in_num_entries_ptr:
> + *   @out_num_entries_ptr:
> + *   @table_data_size_ptr:
> + *   @is_kva: set for kernel data; used only for kernel crypto module
> + *
> + *   This function builds input and output DMA tables for synhronic
> + *   symmetric operations (AES, DES, HASH). It also checks that each table
> + *   is of the modular block size
> + *   Note that all bus addresses that are passed to the SEP
> + *   are in 32 bit format; the SEP is a 32 bit device
> + */
> +static int sep_prepare_input_output_dma_table(struct sep_device *sep,
> +     unsigned long app_virt_in_addr,
> +     unsigned long app_virt_out_addr,
> +     u32 data_size,
> +     u32 block_size,
> +     dma_addr_t *lli_table_in_ptr,
> +     dma_addr_t *lli_table_out_ptr,
> +     u32 *in_num_entries_ptr,
> +     u32 *out_num_entries_ptr,
> +     u32 *table_data_size_ptr,
> +     bool is_kva)
> +
> +{
> +     int error = 0;
> +     /* Array of pointers of page */
> +     struct sep_lli_entry *lli_in_array;
> +     /* Array of pointers of page */
> +     struct sep_lli_entry *lli_out_array;
> +
> +     if (data_size == 0) {
> +             /* Prepare empty table for input and output */
> +             sep_prepare_empty_lli_table(sep, lli_table_in_ptr,
> +                     in_num_entries_ptr, table_data_size_ptr);
> +
> +             sep_prepare_empty_lli_table(sep, lli_table_out_ptr,
> +                     out_num_entries_ptr, table_data_size_ptr);
> +
> +             goto update_dcb_counter;
> +     }
> +
> +     /* Initialize the pages pointers */
> +     sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
> +     sep->dma_res_arr[sep->nr_dcb_creat].out_page_array = NULL;
> +
> +     /* Lock the pages of the buffer and translate them to pages */
> +     if (is_kva == true) {
> +             error = sep_lock_kernel_pages(sep, app_virt_in_addr,
> +                     data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
> +
> +             if (error) {
> +                     dev_warn(&sep->pdev->dev,
> +                             "lock kernel for in failed\n");
> +                     goto end_function;
> +             }
> +
> +             error = sep_lock_kernel_pages(sep, app_virt_out_addr,
> +                     data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
> +
> +             if (error) {
> +                     dev_warn(&sep->pdev->dev,
> +                             "lock kernel for out failed\n");
> +                     goto end_function;
> +             }
> +     }
> +
> +     else {
> +             error = sep_lock_user_pages(sep, app_virt_in_addr,
> +                             data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
> +             if (error) {
> +                     dev_warn(&sep->pdev->dev,
> +                             "sep_lock_user_pages for input virtual buffer failed\n");
> +                     goto end_function;
> +             }
> +
> +             error = sep_lock_user_pages(sep, app_virt_out_addr,
> +                     data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
> +
> +             if (error) {
> +                     dev_warn(&sep->pdev->dev,
> +                             "sep_lock_user_pages for output virtual buffer failed\n");
> +                     goto end_function_free_lli_in;
> +             }
> +     }
> +
> +     dev_dbg(&sep->pdev->dev, "prep input output dma table sep_in_num_pages is %x\n",
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
> +     dev_dbg(&sep->pdev->dev, "sep_out_num_pages is %x\n",
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages);
> +     dev_dbg(&sep->pdev->dev, "SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
> +             SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
> +
> +     /* Call the function that creates table from the lli arrays */
> +     error = sep_construct_dma_tables_from_lli(sep, lli_in_array,
> +             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages,
> +             lli_out_array,
> +             sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages,
> +             block_size, lli_table_in_ptr, lli_table_out_ptr,
> +             in_num_entries_ptr, out_num_entries_ptr, table_data_size_ptr);
> +
> +     if (error) {
> +             dev_warn(&sep->pdev->dev,
> +                     "sep_construct_dma_tables_from_lli failed\n");
> +             goto end_function_with_error;
> +     }
> +
> +     kfree(lli_out_array);
> +     kfree(lli_in_array);
> +
> +update_dcb_counter:
> +     /* Update DCB counter */
> +     sep->nr_dcb_creat++;
> +
> +     goto end_function;
> +
> +end_function_with_error:
> +     kfree(sep->dma_res_arr[sep->nr_dcb_creat].out_map_array);
> +     kfree(sep->dma_res_arr[sep->nr_dcb_creat].out_page_array);
> +     kfree(lli_out_array);
> +
> +
> +end_function_free_lli_in:
> +     kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
> +     kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
> +     kfree(lli_in_array);
> +
> +end_function:
> +
> +     return error;
> +
> +}
> +
> +/**
> + *   sep_prepare_input_output_dma_table_in_dcb - prepare control blocks
> + *   @app_in_address: unsigned long; for data buffer in (user space)
> + *   @app_out_address: unsigned long; for data buffer out (user space)
> + *   @data_in_size: u32; for size of data
> + *   @block_size: u32; for block size
> + *   @tail_block_size: u32; for size of tail block
> + *   @isapplet: bool; to indicate external app
> + *   @is_kva: bool; kernel buffer; only used for kernel crypto module
> + *
> + *   This function prepares the linked DMA tables and puts the
> + *   address for the linked list of tables inta a DCB (data control
> + *   block) the address of which is known by the SEP hardware
> + *   Note that all bus addresses that are passed to the SEP
> + *   are in 32 bit format; the SEP is a 32 bit device
> + */
> +static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
> +     unsigned long  app_in_address,
> +     unsigned long  app_out_address,
> +     u32  data_in_size,
> +     u32  block_size,
> +     u32  tail_block_size,
> +     bool isapplet,
> +     bool    is_kva)
> +{
> +     int error = 0;
> +     /* Size of tail */
> +     u32 tail_size = 0;
> +     /* Address of the created DCB table */
> +     struct sep_dcblock *dcb_table_ptr = NULL;
> +     /* The physical address of the first input DMA table */
> +     dma_addr_t in_first_mlli_address = 0;
> +     /* Number of entries in the first input DMA table */
> +     u32  in_first_num_entries = 0;
> +     /* The physical address of the first output DMA table */
> +     dma_addr_t  out_first_mlli_address = 0;
> +     /* Number of entries in the first output DMA table */
> +     u32  out_first_num_entries = 0;
> +     /* Data in the first input/output table */
> +     u32  first_data_size = 0;
> +
> +     if (sep->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
> +             /* No more DCBs to allocate */
> +             dev_warn(&sep->pdev->dev, "no more DCBs available\n");
> +             error = -ENOSPC;
> +             goto end_function;
> +     }
> +
> +     /* Allocate new DCB */
> +     dcb_table_ptr = (struct sep_dcblock *)(sep->shared_addr +
> +             SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES +
> +             (sep->nr_dcb_creat * sizeof(struct sep_dcblock)));
> +
> +     /* Set the default values in the DCB */
> +     dcb_table_ptr->input_mlli_address = 0;
> +     dcb_table_ptr->input_mlli_num_entries = 0;
> +     dcb_table_ptr->input_mlli_data_size = 0;
> +     dcb_table_ptr->output_mlli_address = 0;
> +     dcb_table_ptr->output_mlli_num_entries = 0;
> +     dcb_table_ptr->output_mlli_data_size = 0;
> +     dcb_table_ptr->tail_data_size = 0;
> +     dcb_table_ptr->out_vr_tail_pt = 0;
> +
> +     if (isapplet == true) {
> +
> +             /* Check if there is enough data for DMA operation */
> +             if (data_in_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE) {
> +                     if (is_kva == true) {
> +                             memcpy(dcb_table_ptr->tail_data,
> +                                     (void *)app_in_address, data_in_size);
> +                     } else {
> +                             if (copy_from_user(dcb_table_ptr->tail_data,
> +                                     (void __user *)app_in_address,
> +                                     data_in_size)) {
> +                                     error = -EFAULT;
> +                                     goto end_function;
> +                             }
> +                     }
> +
> +                     dcb_table_ptr->tail_data_size = data_in_size;
> +
> +                     /* Set the output user-space address for mem2mem op */
> +                     if (app_out_address)
> +                             dcb_table_ptr->out_vr_tail_pt =
> +                                                     (aligned_u64)app_out_address;
> +
> +                     /*
> +                      * Update both data length parameters in order to avoid
> +                      * second data copy and allow building of empty mlli
> +                      * tables
> +                      */
> +                     tail_size = 0x0;
> +                     data_in_size = 0x0;
> +
> +             } else {
> +                     if (!app_out_address) {
> +                             tail_size = data_in_size % block_size;
> +                             if (!tail_size) {
> +                                     if (tail_block_size == block_size)
> +                                             tail_size = block_size;
> +                             }
> +                     } else {
> +                             tail_size = 0;
> +                     }
> +             }
> +             if (tail_size) {
> +                     if (is_kva == true) {
> +                             memcpy(dcb_table_ptr->tail_data,
> +                                     (void *)(app_in_address + data_in_size -
> +                                     tail_size), tail_size);
> +                     } else {
> +                             /* We have tail data - copy it to DCB */
> +                             if (copy_from_user(dcb_table_ptr->tail_data,
> +                                     (void *)(app_in_address +
> +                                     data_in_size - tail_size), tail_size)) {
> +                                     error = -EFAULT;
> +                                     goto end_function;
> +                             }
> +                     }
> +                     if (app_out_address)
> +                             /*
> +                              * Calculate the output address
> +                              * according to tail data size
> +                              */
> +                             dcb_table_ptr->out_vr_tail_pt =
> +                                     (aligned_u64)app_out_address + data_in_size
> +                                     - tail_size;
> +
> +                     /* Save the real tail data size */
> +                     dcb_table_ptr->tail_data_size = tail_size;
> +                     /*
> +                      * Update the data size without the tail
> +                      * data size AKA data for the dma
> +                      */
> +                     data_in_size = (data_in_size - tail_size);
> +             }
> +     }
> +     /* Check if we need to build only input table or input/output */
> +     if (app_out_address) {
> +             /* Prepare input/output tables */
> +             error = sep_prepare_input_output_dma_table(sep,
> +                     app_in_address,
> +                     app_out_address,
> +                     data_in_size,
> +                     block_size,
> +                     &in_first_mlli_address,
> +                     &out_first_mlli_address,
> +                     &in_first_num_entries,
> +                     &out_first_num_entries,
> +                     &first_data_size,
> +                     is_kva);
> +     } else {
> +             /* Prepare input tables */
> +             error = sep_prepare_input_dma_table(sep,
> +                     app_in_address,
> +                     data_in_size,
> +                     block_size,
> +                     &in_first_mlli_address,
> +                     &in_first_num_entries,
> +                     &first_data_size,
> +                     is_kva);
> +     }
> +
> +     if (error) {
> +             dev_warn(&sep->pdev->dev, "prepare DMA table call failed from prepare DCB call\n");
> +             goto end_function;
> +     }
> +
> +     /* Set the DCB values */
> +     dcb_table_ptr->input_mlli_address = in_first_mlli_address;
> +     dcb_table_ptr->input_mlli_num_entries = in_first_num_entries;
> +     dcb_table_ptr->input_mlli_data_size = first_data_size;
> +     dcb_table_ptr->output_mlli_address = out_first_mlli_address;
> +     dcb_table_ptr->output_mlli_num_entries = out_first_num_entries;
> +     dcb_table_ptr->output_mlli_data_size = first_data_size;
> +
> +end_function:
> +     return error;
> +
> +}
> +
> +/**
> + *   sep_free_dma_tables_and_dcb - free DMA tables and DCBs
> + *   @sep: pointer to struct sep_device
> + *   @isapplet: indicates external application (used for kernel access)
> + *   @is_kva: indicates kernel addresses (only used for kernel crypto)
> + *
> + *   This function frees the DMA tables and DCB
> + */
> +static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
> +     bool is_kva)
> +{
> +     int i = 0;
> +     int error = 0;
> +     int error_temp = 0;
> +     struct sep_dcblock *dcb_table_ptr;
> +     unsigned long pt_hold;
> +     void *tail_pt;
> +
> +     if (isapplet == true) {
> +             /* Set pointer to first DCB table */
> +             dcb_table_ptr = (struct sep_dcblock *)
> +                     (sep->shared_addr +
> +                     SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES);
> +
> +             /* Go over each DCB and see if tail pointer must be updated */
> +             for (i = 0; i < sep->nr_dcb_creat; i++, dcb_table_ptr++) {
> +                     if (dcb_table_ptr->out_vr_tail_pt) {
> +                             pt_hold = (unsigned long)dcb_table_ptr->out_vr_tail_pt;
> +                             tail_pt = (void *)pt_hold;
> +                             if (is_kva == true) {
> +                                     memcpy(tail_pt,
> +                                             dcb_table_ptr->tail_data,
> +                                             dcb_table_ptr->tail_data_size);
> +                             } else {
> +                                     error_temp = copy_to_user(
> +                                             tail_pt,
> +                                             dcb_table_ptr->tail_data,
> +                                             dcb_table_ptr->tail_data_size);
> +                             }
> +                             if (error_temp) {
> +                                     /* Release the DMA resource */
> +                                     error = -EFAULT;
> +                                     break;
> +                             }
> +                     }
> +             }
> +     }
> +     /* Free the output pages, if any */
> +     sep_free_dma_table_data_handler(sep);
> +
> +     return error;
> +}
> +
> +/**
> + *   sep_get_static_pool_addr_handler - get static pool address
> + *   @sep: pointer to struct sep_device
> + *
> + *   This function sets the bus and virtual addresses of the static pool
> + */
> +static int sep_get_static_pool_addr_handler(struct sep_device *sep)
> +{
> +     u32 *static_pool_addr = NULL;
> +
> +     static_pool_addr = (u32 *)(sep->shared_addr +
> +             SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
> +
> +     static_pool_addr[0] = SEP_STATIC_POOL_VAL_TOKEN;
> +     static_pool_addr[1] = (u32)sep->shared_bus +
> +             SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
> +
> +     dev_dbg(&sep->pdev->dev, "static pool segment: physical %x\n",
> +             (u32)static_pool_addr[1]);
> +
> +     return 0;
> +}
> +
> +/**
> + *   sep_end_transaction_handler - end transaction
> + *   @sep: pointer to struct sep_device
> + *
> + *   This API handles the end transaction request
> + */
> +static int sep_end_transaction_handler(struct sep_device *sep)
> +{
> +     /* Clear the data pool pointers Token */
> +     memset((void *)(sep->shared_addr +
> +             SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES),
> +             0, sep->num_of_data_allocations*2*sizeof(u32));
> +
> +     /* Check that all the DMA resources were freed */
> +     sep_free_dma_table_data_handler(sep);
> +
> +     clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
> +
> +     /*
> +      * We are now through with the transaction. Let's
> +      * allow other processes who have the device open
> +      * to perform transactions
> +      */
> +     mutex_lock(&sep->sep_mutex);
> +     sep->pid_doing_transaction = 0;
> +     mutex_unlock(&sep->sep_mutex);
> +     /* Raise event for stuck contextes */
> +     wake_up(&sep->event);
> +
> +     return 0;
> +}
> +
> +/**
> + *   sep_prepare_dcb_handler - prepare a control block
> + *   @sep: pointer to struct sep_device
> + *   @arg: pointer to user parameters
> + *
> + *   This function will retrieve the RAR buffer physical addresses, type
> + *   & size corresponding to the RAR handles provided in the buffers vector.
> + */
> +static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
> +{
> +     int error;
> +     /* Command arguments */
> +     struct build_dcb_struct command_args;
> +
> +     /* Get the command arguments */
> +     if (copy_from_user(&command_args, (void __user *)arg,
> +                                     sizeof(struct build_dcb_struct))) {
> +             error = -EFAULT;
> +             goto end_function;
> +     }
> +
> +     dev_dbg(&sep->pdev->dev, "prep dcb handler app_in_address is %08llx\n",
> +                                             command_args.app_in_address);
> +     dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
> +                                             command_args.app_out_address);
> +     dev_dbg(&sep->pdev->dev, "data_size is %x\n",
> +                                             command_args.data_in_size);
> +     dev_dbg(&sep->pdev->dev, "block_size is %x\n",
> +                                             command_args.block_size);
> +     dev_dbg(&sep->pdev->dev, "tail block_size is %x\n",
> +                                             command_args.tail_block_size);
> +
> +     error = sep_prepare_input_output_dma_table_in_dcb(sep,
> +             (unsigned long)command_args.app_in_address,
> +             (unsigned long)command_args.app_out_address,
> +             command_args.data_in_size, command_args.block_size,
> +             command_args.tail_block_size, true, false);
> +
> +end_function:
> +     return error;
> +
> +}
> +
> +/**
> + *   sep_free_dcb_handler - free control block resources
> + *   @sep: pointer to struct sep_device
> + *
> + *   This function frees the DCB resources and updates the needed
> + *   user-space buffers.
> + */
> +static int sep_free_dcb_handler(struct sep_device *sep)
> +{
> +     return sep_free_dma_tables_and_dcb(sep, false, false);
> +}
> +
> +/**
> + *   sep_rar_prepare_output_msg_handler - prepare an output message
> + *   @sep: pointer to struct sep_device
> + *   @arg: pointer to user parameters
> + *
> + *   This function will retrieve the RAR buffer physical addresses, type
> + *   & size corresponding to the RAR handles provided in the buffers vector.
> + */
> +static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
> +     unsigned long arg)
> +{
> +     int error = 0;
> +     /* Command args */
> +     struct rar_hndl_to_bus_struct command_args;
> +     /* Bus address */
> +     dma_addr_t  rar_bus = 0;
> +     /* Holds the RAR address in the system memory offset */
> +     u32 *rar_addr;
> +
> +     /* Copy the data */
> +     if (copy_from_user(&command_args, (void __user *)arg,
> +                                             sizeof(command_args))) {
> +             error = -EFAULT;
> +             goto end_function;
> +     }
> +
> +     /* Call to translation function only if user handle is not NULL */
> +     if (command_args.rar_handle)
> +             return -EOPNOTSUPP;
> +     dev_dbg(&sep->pdev->dev, "rar msg; rar_addr_bus = %x\n", (u32)rar_bus);
> +
> +     /* Set value in the SYSTEM MEMORY offset */
> +     rar_addr = (u32 *)(sep->shared_addr +
> +             SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
> +
> +     /* Copy the physical address to the System Area for the SEP */
> +     rar_addr[0] = SEP_RAR_VAL_TOKEN;
> +     rar_addr[1] = rar_bus;
> +
> +end_function:
> +     return error;
> +}
> +
> +/**
> + *   sep_ioctl - ioctl api
> + *   @filp: pointer to struct file
> + *   @cmd: command
> + *   @arg: pointer to argument structure
> + *
> + *   Implement the ioctl methods available on the SEP device.
> + */
> +static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +     int error = 0;
> +     struct sep_device *sep = filp->private_data;
> +
> +     /* Make sure we own this device */
> +     mutex_lock(&sep->sep_mutex);
> +     if ((current->pid != sep->pid_doing_transaction) &&
> +                             (sep->pid_doing_transaction != 0)) {
> +             dev_dbg(&sep->pdev->dev, "ioctl pid is not owner\n");
> +             error = -EACCES;
> +             goto end_function;
> +     }
> +
> +     mutex_unlock(&sep->sep_mutex);
> +
> +     if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
> +             return -ENOTTY;
> +
> +     /* Lock to prevent the daemon to interfere with operation */
> +     mutex_lock(&sep->ioctl_mutex);
> +
> +     switch (cmd) {
> +     case SEP_IOCSENDSEPCOMMAND:
> +             /* Send command to SEP */
> +             error = sep_send_command_handler(sep);
> +             break;
> +     case SEP_IOCALLOCDATAPOLL:
> +             /* Allocate data pool */
> +             error = sep_allocate_data_pool_memory_handler(sep, arg);
> +             break;
> +     case SEP_IOCGETSTATICPOOLADDR:
> +             /* Inform the SEP the bus address of the static pool */
> +             error = sep_get_static_pool_addr_handler(sep);
> +             break;
> +     case SEP_IOCENDTRANSACTION:
> +             error = sep_end_transaction_handler(sep);
> +             break;
> +     case SEP_IOCRARPREPAREMESSAGE:
> +             error = sep_rar_prepare_output_msg_handler(sep, arg);
> +             break;
> +     case SEP_IOCPREPAREDCB:
> +             error = sep_prepare_dcb_handler(sep, arg);
> +             break;
> +     case SEP_IOCFREEDCB:
> +             error = sep_free_dcb_handler(sep);
> +             break;
> +     default:
> +             error = -ENOTTY;
> +             break;
> +     }
> +
> +end_function:
> +     mutex_unlock(&sep->ioctl_mutex);
> +     return error;
> +}
> +
> +/**
> + *   sep_singleton_ioctl - ioctl api for singleton interface
> + *   @filp: pointer to struct file
> + *   @cmd: command
> + *   @arg: pointer to argument structure
> + *
> + *   Implement the additional ioctls for the singleton device
> + */
> +static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
> +{
> +     long error = 0;
> +     struct sep_device *sep = filp->private_data;
> +
> +     /* Check that the command is for the SEP device */
> +     if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
> +             return -ENOTTY;
> +
> +     /* Make sure we own this device */
> +     mutex_lock(&sep->sep_mutex);
> +     if ((current->pid != sep->pid_doing_transaction) &&
> +                             (sep->pid_doing_transaction != 0)) {
> +             dev_dbg(&sep->pdev->dev, "singleton ioctl pid is not owner\n");
> +             mutex_unlock(&sep->sep_mutex);
> +             return -EACCES;
> +     }
> +
> +     mutex_unlock(&sep->sep_mutex);
> +
> +     switch (cmd) {
> +     case SEP_IOCTLSETCALLERID:
> +             mutex_lock(&sep->ioctl_mutex);
> +             error = sep_set_caller_id_handler(sep, arg);
> +             mutex_unlock(&sep->ioctl_mutex);
> +             break;
> +     default:
> +             error = sep_ioctl(filp, cmd, arg);
> +             break;
> +     }
> +     return error;
> +}
> +
> +/**
> + *   sep_request_daemon_ioctl - ioctl for daemon
> + *   @filp: pointer to struct file
> + *   @cmd: command
> + *   @arg: pointer to argument structure
> + *
> + *   Called by the request daemon to perform ioctls on the daemon device
> + */
> +static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
> +     unsigned long arg)
> +{
> +
> +     long error;
> +     struct sep_device *sep = filp->private_data;
> +
> +     /* Check that the command is for SEP device */
> +     if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
> +             return -ENOTTY;
> +
> +     /* Only one process can access ioctl at any given time */
> +     mutex_lock(&sep->ioctl_mutex);
> +
> +     switch (cmd) {
> +     case SEP_IOCSENDSEPRPLYCOMMAND:
> +             /* Send reply command to SEP */
> +             error = sep_req_daemon_send_reply_command_handler(sep);
> +             break;
> +     case SEP_IOCENDTRANSACTION:
> +             /*
> +              * End req daemon transaction, do nothing
> +              * will be removed upon update in middleware
> +              * API library
> +              */
> +             error = 0;
> +             break;
> +     default:
> +             error = -ENOTTY;
> +     }
> +     mutex_unlock(&sep->ioctl_mutex);
> +     return error;
> +}
> +
> +/**
> + *   sep_inthandler - interrupt handler
> + *   @irq: interrupt
> + *   @dev_id: device id
> + */
> +static irqreturn_t sep_inthandler(int irq, void *dev_id)
> +{
> +     irqreturn_t int_error = IRQ_HANDLED;
> +     unsigned long lck_flags;
> +     u32 reg_val, reg_val2 = 0;
> +     struct sep_device *sep = dev_id;
> +
> +     /* Read the IRR register to check if this is SEP interrupt */
> +     reg_val = sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
> +
> +     if (reg_val & (0x1 << 13)) {
> +             /* Lock and update the counter of reply messages */
> +             spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> +             sep->reply_ct++;
> +             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> +
> +             dev_dbg(&sep->pdev->dev, "sep int: send_ct %lx reply_ct %lx\n",
> +                                     sep->send_ct, sep->reply_ct);
> +
> +             /* Is this printf or daemon request? */
> +             reg_val2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
> +             dev_dbg(&sep->pdev->dev,
> +                     "SEP Interrupt - reg2 is %08x\n", reg_val2);
> +
> +             if ((reg_val2 >> 30) & 0x1) {
> +                     dev_dbg(&sep->pdev->dev, "int: printf request\n");
> +                     wake_up(&sep->event_request_daemon);
> +             } else if (reg_val2 >> 31) {
> +                     dev_dbg(&sep->pdev->dev, "int: daemon request\n");
> +                     wake_up(&sep->event_request_daemon);
> +             } else {
> +                     dev_dbg(&sep->pdev->dev, "int: SEP reply\n");
> +                     wake_up(&sep->event);
> +             }
> +     } else {
> +             dev_dbg(&sep->pdev->dev, "int: not SEP interrupt\n");
> +             int_error = IRQ_NONE;
> +     }
> +     if (int_error == IRQ_HANDLED)
> +             sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, reg_val);
> +
> +     return int_error;
> +}
> +
> +/**
> + *   sep_reconfig_shared_area - reconfigure shared area
> + *   @sep: pointer to struct sep_device
> + *
> + *   Reconfig the shared area between HOST and SEP - needed in case
> + *   the DX_CC_Init function was called before OS loading.
> + */
> +static int sep_reconfig_shared_area(struct sep_device *sep)
> +{
> +     int ret_val;
> +
> +     /* use to limit waiting for SEP */
> +     unsigned long end_time;
> +
> +     /* Send the new SHARED MESSAGE AREA to the SEP */
> +     dev_dbg(&sep->pdev->dev, "reconfig shared; sending %08llx to sep\n",
> +                             (unsigned long long)sep->shared_bus);
> +
> +     sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
> +
> +     /* Poll for SEP response */
> +     ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
> +
> +     end_time = jiffies + (WAIT_TIME * HZ);
> +
> +     while ((time_before(jiffies, end_time)) && (ret_val != 0xffffffff) &&
> +             (ret_val != sep->shared_bus))
> +             ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
> +
> +     /* Check the return value (register) */
> +     if (ret_val != sep->shared_bus) {
> +             dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
> +             dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
> +             ret_val = -ENOMEM;
> +     } else
> +             ret_val = 0;
> +
> +     dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
> +     return ret_val;
> +}
> +
> +/* File operation for singleton SEP operations */
> +static const struct file_operations singleton_file_operations = {
> +     .owner = THIS_MODULE,
> +     .unlocked_ioctl = sep_singleton_ioctl,
> +     .poll = sep_poll,
> +     .open = sep_singleton_open,
> +     .release = sep_singleton_release,
> +     .mmap = sep_mmap,
> +};
> +
> +/* File operation for daemon operations */
> +static const struct file_operations daemon_file_operations = {
> +     .owner = THIS_MODULE,
> +     .unlocked_ioctl = sep_request_daemon_ioctl,
> +     .poll = sep_request_daemon_poll,
> +     .open = sep_request_daemon_open,
> +     .release = sep_request_daemon_release,
> +     .mmap = sep_request_daemon_mmap,
> +};
> +
> +/* The files operations structure of the driver */
> +static const struct file_operations sep_file_operations = {
> +     .owner = THIS_MODULE,
> +     .unlocked_ioctl = sep_ioctl,
> +     .poll = sep_poll,
> +     .open = sep_open,
> +     .release = sep_release,
> +     .mmap = sep_mmap,
> +};
> +
> +/**
> + *   sep_register_driver_with_fs - register misc devices
> + *   @sep: pointer to struct sep_device
> + *
> + *   This function registers the driver with the file system
> + */
> +static int sep_register_driver_with_fs(struct sep_device *sep)
> +{
> +     int ret_val;
> +
> +     sep->miscdev_sep.minor = MISC_DYNAMIC_MINOR;
> +     sep->miscdev_sep.name = SEP_DEV_NAME;
> +     sep->miscdev_sep.fops = &sep_file_operations;
> +
> +     sep->miscdev_singleton.minor = MISC_DYNAMIC_MINOR;
> +     sep->miscdev_singleton.name = SEP_DEV_SINGLETON;
> +     sep->miscdev_singleton.fops = &singleton_file_operations;
> +
> +     sep->miscdev_daemon.minor = MISC_DYNAMIC_MINOR;
> +     sep->miscdev_daemon.name = SEP_DEV_DAEMON;
> +     sep->miscdev_daemon.fops = &daemon_file_operations;
> +
> +     ret_val = misc_register(&sep->miscdev_sep);
> +     if (ret_val) {
> +             dev_warn(&sep->pdev->dev, "misc reg fails for SEP %x\n",
> +                     ret_val);
> +             return ret_val;
> +     }
> +
> +     ret_val = misc_register(&sep->miscdev_singleton);
> +     if (ret_val) {
> +             dev_warn(&sep->pdev->dev, "misc reg fails for sing %x\n",
> +                     ret_val);
> +             misc_deregister(&sep->miscdev_sep);
> +             return ret_val;
> +     }
> +
> +     ret_val = misc_register(&sep->miscdev_daemon);
> +     if (ret_val) {
> +             dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
> +                     ret_val);
> +             misc_deregister(&sep->miscdev_sep);
> +             misc_deregister(&sep->miscdev_singleton);
> +
> +             return ret_val;
> +     }
> +     return ret_val;
> +}
> +
> +
> +/**
> + *   sep_probe - probe a matching PCI device
> + *   @pdev: pci_device
> + *   @end: pci_device_id
> + *
> + *   Attempt to set up and configure a SEP device that has been
> + *   discovered by the PCI layer.
> + */
> +static int __devinit sep_probe(struct pci_dev *pdev,
> +     const struct pci_device_id *ent)
> +{
> +     int error = 0;
> +     struct sep_device *sep;
> +
> +     if (sep_dev != NULL) {
> +             dev_warn(&pdev->dev, "only one SEP supported.\n");
> +             return -EBUSY;
> +     }
> +
> +     /* Enable the device */
> +     error = pci_enable_device(pdev);
> +     if (error) {
> +             dev_warn(&pdev->dev, "error enabling pci device\n");
> +             goto end_function;
> +     }
> +
> +     /* Allocate the sep_device structure for this device */
> +     sep_dev = kzalloc(sizeof(struct sep_device), GFP_ATOMIC);
> +     if (sep_dev == NULL) {
> +             dev_warn(&pdev->dev,
> +                     "can't kmalloc the sep_device structure\n");
> +             error = -ENOMEM;
> +             goto end_function_disable_device;
> +     }
> +
> +     /*
> +      * We're going to use another variable for actually
> +      * working with the device; this way, if we have
> +      * multiple devices in the future, it would be easier
> +      * to make appropriate changes
> +      */
> +     sep = sep_dev;
> +
> +     sep->pdev = pci_dev_get(pdev);
> +
> +     init_waitqueue_head(&sep->event);
> +     init_waitqueue_head(&sep->event_request_daemon);
> +     spin_lock_init(&sep->snd_rply_lck);
> +     mutex_init(&sep->sep_mutex);
> +     mutex_init(&sep->ioctl_mutex);
> +
> +     dev_dbg(&sep->pdev->dev, "sep probe: PCI obtained, device being prepared\n");
> +     dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
> +
> +     /* Set up our register area */
> +     sep->reg_physical_addr = pci_resource_start(sep->pdev, 0);
> +     if (!sep->reg_physical_addr) {
> +             dev_warn(&sep->pdev->dev, "Error getting register start\n");
> +             error = -ENODEV;
> +             goto end_function_free_sep_dev;
> +     }
> +
> +     sep->reg_physical_end = pci_resource_end(sep->pdev, 0);
> +     if (!sep->reg_physical_end) {
> +             dev_warn(&sep->pdev->dev, "Error getting register end\n");
> +             error = -ENODEV;
> +             goto end_function_free_sep_dev;
> +     }
> +
> +     sep->reg_addr = ioremap_nocache(sep->reg_physical_addr,
> +             (size_t)(sep->reg_physical_end - sep->reg_physical_addr + 1));
> +     if (!sep->reg_addr) {
> +             dev_warn(&sep->pdev->dev, "Error getting register virtual\n");
> +             error = -ENODEV;
> +             goto end_function_free_sep_dev;
> +     }
> +
> +     dev_dbg(&sep->pdev->dev,
> +             "Register area start %llx end %llx virtual %p\n",
> +             (unsigned long long)sep->reg_physical_addr,
> +             (unsigned long long)sep->reg_physical_end,
> +             sep->reg_addr);
> +
> +     /* Allocate the shared area */
> +     sep->shared_size = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
> +             SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES +
> +             SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
> +             SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
> +             SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;
> +
> +     if (sep_map_and_alloc_shared_area(sep)) {
> +             error = -ENOMEM;
> +             /* Allocation failed */
> +             goto end_function_error;
> +     }
> +
> +     /* Clear ICR register */
> +     sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
> +
> +     /* Set the IMR register - open only GPR 2 */
> +     sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
> +
> +     /* Read send/receive counters from SEP */
> +     sep->reply_ct = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
> +     sep->reply_ct &= 0x3FFFFFFF;
> +     sep->send_ct = sep->reply_ct;
> +
> +     /* Get the interrupt line */
> +     error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
> +             "sep_driver", sep);
> +
> +     if (error)
> +             goto end_function_deallocate_sep_shared_area;
> +
> +     /* The new chip requires a shared area reconfigure */
> +     if (sep->pdev->revision == 4) { /* Only for new chip */
> +             error = sep_reconfig_shared_area(sep);
> +             if (error)
> +                     goto end_function_free_irq;
> +     }
> +     /* Finally magic up the device nodes */
> +     /* Register driver with the fs */
> +     error = sep_register_driver_with_fs(sep);
> +     if (error == 0)
> +             /* Success */
> +             return 0;
> +
> +end_function_free_irq:
> +     free_irq(pdev->irq, sep);
> +
> +end_function_deallocate_sep_shared_area:
> +     /* De-allocate shared area */
> +     sep_unmap_and_free_shared_area(sep);
> +
> +end_function_error:
> +     iounmap(sep->reg_addr);
> +
> +end_function_free_sep_dev:
> +     pci_dev_put(sep_dev->pdev);
> +     kfree(sep_dev);
> +     sep_dev = NULL;
> +
> +end_function_disable_device:
> +     pci_disable_device(pdev);
> +
> +end_function:
> +     return error;
> +}
> +
> +static void sep_remove(struct pci_dev *pdev)
> +{
> +     struct sep_device *sep = sep_dev;
> +
> +     /* Unregister from fs */
> +     misc_deregister(&sep->miscdev_sep);
> +     misc_deregister(&sep->miscdev_singleton);
> +     misc_deregister(&sep->miscdev_daemon);
> +
> +     /* Free the irq */
> +     free_irq(sep->pdev->irq, sep);
> +
> +     /* Free the shared area  */
> +     sep_unmap_and_free_shared_area(sep_dev);
> +     iounmap((void *) sep_dev->reg_addr);
> +}
> +
> +static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
> +     {PCI_DEVICE(PCI_VENDOR_ID_INTEL, MFLD_PCI_DEVICE_ID)},
> +     {0}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
> +
> +/* Field for registering driver to PCI device */
> +static struct pci_driver sep_pci_driver = {
> +     .name = "sep_sec_driver",
> +     .id_table = sep_pci_id_tbl,
> +     .probe = sep_probe,
> +     .remove = sep_remove
> +};
> +
> +
> +/**
> + *   sep_init - init function
> + *
> + *   Module load time. Register the PCI device driver.
> + */
> +static int __init sep_init(void)
> +{
> +     return pci_register_driver(&sep_pci_driver);
> +}
> +
> +
> +/**
> + *   sep_exit - called to unload driver
> + *
> + *   Drop the misc devices then remove and unmap the various resources
> + *   that are not released by the driver remove method.
> + */
> +static void __exit sep_exit(void)
> +{
> +     pci_unregister_driver(&sep_pci_driver);
> +}
> +
> +
> +module_init(sep_init);
> +module_exit(sep_exit);
> +
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/misc/sep/sep_driver_api.h b/drivers/misc/sep/sep_driver_api.h
> new file mode 100644
> index 0000000..c3aacfc
> --- /dev/null
> +++ b/drivers/misc/sep/sep_driver_api.h
> @@ -0,0 +1,215 @@
> +/*
> + *
> + *  sep_driver_api.h - Security Processor Driver api definitions
> + *
> + *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> + *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms of the GNU General Public License as published by the Free
> + *  Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but WITHOUT
> + *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + *  more details.
> + *
> + *  You should have received a copy of the GNU General Public License along with
> + *  this program; if not, write to the Free Software Foundation, Inc., 59
> + *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + *
> + *  CONTACTS:
> + *
> + *  Mark Allyn               mark.a.allyn@intel.com
> + *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> + *
> + *  CHANGES:
> + *
> + *  2010.09.14  Upgrade to Medfield
> + *
> + */
> +
> +#ifndef __SEP_DRIVER_API_H__
> +#define __SEP_DRIVER_API_H__
> +
> +/* Type of request from device */
> +#define SEP_DRIVER_SRC_REPLY         1
> +#define SEP_DRIVER_SRC_REQ           2
> +#define SEP_DRIVER_SRC_PRINTF                3
> +
> +
> +/*-------------------------------------------
> +    TYPEDEFS
> +----------------------------------------------*/
> +
> +struct alloc_struct {
> +     /* offset from start of shared pool area */
> +     u32  offset;
> +     /* number of bytes to allocate */
> +     u32  num_bytes;
> +};
> +
> +/* command struct for getting caller id value and address */
> +struct caller_id_struct {
> +     /* pid of the process */
> +     u32 pid;
> +     /* virtual address of the caller id hash */
> +     aligned_u64 callerIdAddress;
> +     /* caller id hash size in bytes */
> +     u32 callerIdSizeInBytes;
> +};
> +
> +/*
> +  structure that represents DCB
> +*/
> +struct sep_dcblock {
> +     /* physical address of the first input mlli */
> +     u32     input_mlli_address;
> +     /* num of entries in the first input mlli */
> +     u32     input_mlli_num_entries;
> +     /* size of data in the first input mlli */
> +     u32     input_mlli_data_size;
> +     /* physical address of the first output mlli */
> +     u32     output_mlli_address;
> +     /* num of entries in the first output mlli */
> +     u32     output_mlli_num_entries;
> +     /* size of data in the first output mlli */
> +     u32     output_mlli_data_size;
> +     /* pointer to the output virtual tail */
> +     aligned_u64 out_vr_tail_pt;
> +     /* size of tail data */
> +     u32     tail_data_size;
> +     /* input tail data array */
> +     u8      tail_data[68];
> +};
> +
> +struct sep_caller_id_entry {
> +     int pid;
> +     unsigned char callerIdHash[SEP_CALLER_ID_HASH_SIZE_IN_BYTES];
> +};
> +
> +/*
> +     command structure for building dcb block (currently for ext app only
> +*/
> +struct build_dcb_struct {
> +     /* address value of the data in */
> +     aligned_u64 app_in_address;
> +     /* size of data in */
> +     u32  data_in_size;
> +     /* address of the data out */
> +     aligned_u64 app_out_address;
> +     /* the size of the block of the operation - if needed,
> +     every table will be modulo this parameter */
> +     u32  block_size;
> +     /* the size of the block of the operation - if needed,
> +     every table will be modulo this parameter */
> +     u32  tail_block_size;
> +};
> +
> +/**
> + * @struct sep_dma_map
> + *
> + * Structure that contains all information needed for mapping the user pages
> + *        or kernel buffers for dma operations
> + *
> + *
> + */
> +struct sep_dma_map {
> +     /* mapped dma address */
> +     dma_addr_t    dma_addr;
> +     /* size of the mapped data */
> +     size_t        size;
> +};
> +
> +struct sep_dma_resource {
> +     /* array of pointers to the pages that represent
> +     input data for the synchronic DMA action */
> +     struct page **in_page_array;
> +
> +     /* array of pointers to the pages that represent out
> +     data for the synchronic DMA action */
> +     struct page **out_page_array;
> +
> +     /* number of pages in the sep_in_page_array */
> +     u32 in_num_pages;
> +
> +     /* number of pages in the sep_out_page_array */
> +     u32 out_num_pages;
> +
> +     /* map array of the input data */
> +     struct sep_dma_map *in_map_array;
> +
> +     /* map array of the output data */
> +     struct sep_dma_map *out_map_array;
> +
> +     /* number of entries of the input mapp array */
> +     u32 in_map_num_entries;
> +
> +     /* number of entries of the output mapp array */
> +     u32 out_map_num_entries;
> +};
> +
> +
> +/* command struct for translating rar handle to bus address
> +   and setting it at predefined location */
> +struct rar_hndl_to_bus_struct {
> +
> +     /* rar handle */
> +     aligned_u64 rar_handle;
> +};
> +
> +/*
> +  structure that represent one entry in the DMA LLI table
> +*/
> +struct sep_lli_entry {
> +     /* physical address */
> +     u32 bus_address;
> +
> +     /* block size */
> +     u32 block_size;
> +};
> +
> +/*----------------------------------------------------------------
> +     IOCTL command defines
> +     -----------------------------------------------------------------*/
> +
> +/* magic number 1 of the sep IOCTL command */
> +#define SEP_IOC_MAGIC_NUMBER                      's'
> +
> +/* sends interrupt to sep that message is ready */
> +#define SEP_IOCSENDSEPCOMMAND         \
> +     _IO(SEP_IOC_MAGIC_NUMBER, 0)
> +
> +/* sends interrupt to sep that message is ready */
> +#define SEP_IOCSENDSEPRPLYCOMMAND     \
> +     _IO(SEP_IOC_MAGIC_NUMBER, 1)
> +
> +/* allocate memory in data pool */
> +#define SEP_IOCALLOCDATAPOLL \
> +     _IOW(SEP_IOC_MAGIC_NUMBER, 2, struct alloc_struct)
> +
> +/* free dynamic data aalocated during table creation */
> +#define SEP_IOCFREEDMATABLEDATA       \
> +     _IO(SEP_IOC_MAGIC_NUMBER, 7)
> +
> +/* get the static pool area addersses (physical and virtual) */
> +#define SEP_IOCGETSTATICPOOLADDR     \
> +     _IO(SEP_IOC_MAGIC_NUMBER, 8)
> +
> +/* end transaction command */
> +#define SEP_IOCENDTRANSACTION         \
> +     _IO(SEP_IOC_MAGIC_NUMBER, 15)
> +
> +#define SEP_IOCRARPREPAREMESSAGE     \
> +     _IOW(SEP_IOC_MAGIC_NUMBER, 20, struct rar_hndl_to_bus_struct)
> +
> +#define SEP_IOCTLSETCALLERID \
> +     _IOW(SEP_IOC_MAGIC_NUMBER, 34, struct caller_id_struct)
> +
> +#define SEP_IOCPREPAREDCB                                    \
> +     _IOW(SEP_IOC_MAGIC_NUMBER, 35, struct build_dcb_struct)
> +
> +#define SEP_IOCFREEDCB                                       \
> +     _IO(SEP_IOC_MAGIC_NUMBER, 36)
> +
> +#endif
> diff --git a/drivers/misc/sep/sep_driver_config.h b/drivers/misc/sep/sep_driver_config.h
> new file mode 100644
> index 0000000..1033425
> --- /dev/null
> +++ b/drivers/misc/sep/sep_driver_config.h
> @@ -0,0 +1,243 @@
> +/*
> + *
> + *  sep_driver_config.h - Security Processor Driver configuration
> + *
> + *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> + *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms of the GNU General Public License as published by the Free
> + *  Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but WITHOUT
> + *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + *  more details.
> + *
> + *  You should have received a copy of the GNU General Public License along with
> + *  this program; if not, write to the Free Software Foundation, Inc., 59
> + *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + *
> + *  CONTACTS:
> + *
> + *  Mark Allyn               mark.a.allyn@intel.com
> + *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> + *
> + *  CHANGES:
> + *
> + *  2010.06.26       Upgrade to Medfield
> + *
> + */
> +
> +#ifndef __SEP_DRIVER_CONFIG_H__
> +#define __SEP_DRIVER_CONFIG_H__
> +
> +
> +/*--------------------------------------
> +  DRIVER CONFIGURATION FLAGS
> +  -------------------------------------*/
> +
> +/* if flag is on , then the driver is running in polling and
> +     not interrupt mode */
> +#define SEP_DRIVER_POLLING_MODE                         0
> +
> +/* flag which defines if the shared area address should be
> +     reconfiged (send to SEP anew) during init of the driver */
> +#define SEP_DRIVER_RECONFIG_MESSAGE_AREA                0
> +
> +/* the mode for running on the ARM1172 Evaluation platform (flag is 1) */
> +#define SEP_DRIVER_ARM_DEBUG_MODE                       0
> +
> +/*-------------------------------------------
> +     INTERNAL DATA CONFIGURATION
> +     -------------------------------------------*/
> +
> +/* flag for the input array */
> +#define SEP_DRIVER_IN_FLAG                              0
> +
> +/* flag for output array */
> +#define SEP_DRIVER_OUT_FLAG                             1
> +
> +/* maximum number of entries in one LLI tables */
> +#define SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP             31
> +
> +/* minimum data size of the MLLI table */
> +#define SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE           16
> +
> +/* flag that signifies tah the lock is
> +currently held by the process (struct file) */
> +#define SEP_DRIVER_OWN_LOCK_FLAG                        1
> +
> +/* flag that signifies tah the lock is currently NOT
> +held by the process (struct file) */
> +#define SEP_DRIVER_DISOWN_LOCK_FLAG                     0
> +
> +/* indicates whether driver has mapped/unmapped shared area */
> +#define SEP_REQUEST_DAEMON_MAPPED 1
> +#define SEP_REQUEST_DAEMON_UNMAPPED 0
> +
> +#define SEP_DEV_NAME "sep_sec_driver"
> +#define SEP_DEV_SINGLETON "sep_sec_singleton_driver"
> +#define SEP_DEV_DAEMON "sep_req_daemon_driver"
> +
> +/*--------------------------------------------------------
> +     SHARED AREA  memory total size is 36K
> +     it is divided is following:
> +
> +     SHARED_MESSAGE_AREA                     8K         }
> +                                                                     }
> +     STATIC_POOL_AREA                        4K         } MAPPED AREA ( 24 K)
> +                                                                     }
> +     DATA_POOL_AREA                          12K        }
> +
> +     SYNCHRONIC_DMA_TABLES_AREA              5K
> +
> +     placeholder until drver changes
> +     FLOW_DMA_TABLES_AREA                    4K
> +
> +     SYSTEM_MEMORY_AREA                      3k
> +
> +     SYSTEM_MEMORY total size is 3k
> +     it is divided as following:
> +
> +     TIME_MEMORY_AREA                     8B
> +-----------------------------------------------------------*/
> +
> +#define SEP_DEV_NAME "sep_sec_driver"
> +#define SEP_DEV_SINGLETON "sep_sec_singleton_driver"
> +#define SEP_DEV_DAEMON "sep_req_daemon_driver"
> +
> +
> +/*
> +     the maximum length of the message - the rest of the message shared
> +     area will be dedicated to the dma lli tables
> +*/
> +#define SEP_DRIVER_MAX_MESSAGE_SIZE_IN_BYTES                 (8 * 1024)
> +
> +/* the size of the message shared area in pages */
> +#define SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES         (8 * 1024)
> +
> +/* the size of the data pool static area in pages */
> +#define SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES                 (4 * 1024)
> +
> +/* the size of the data pool shared area size in pages */
> +#define SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES               (16 * 1024)
> +
> +/* the size of the message shared area in pages */
> +#define SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES        (1024 * 5)
> +
> +/* Placeholder until driver changes */
> +#define SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES                (1024 * 4)
> +
> +/* system data (time, caller id etc') pool */
> +#define SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES          (1024 * 3)
> +
> +/* the size in bytes of the time memory */
> +#define SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES                 8
> +
> +/* the size in bytes of the RAR parameters memory */
> +#define SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES           8
> +
> +/* area size that is mapped  - we map the MESSAGE AREA, STATIC POOL and
> +     DATA POOL areas. area must be module 4k */
> +#define SEP_DRIVER_MMMAP_AREA_SIZE                           (1024 * 28)
> +
> +/*-----------------------------------------------
> +     offsets of the areas starting from the shared area start address
> +*/
> +
> +/* message area offset */
> +#define SEP_DRIVER_MESSAGE_AREA_OFFSET_IN_BYTES                      0
> +
> +/* static pool area offset */
> +#define SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES \
> +     (SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES)
> +
> +/* data pool area offset */
> +#define SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES \
> +     (SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES + \
> +     SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES)
> +
> +/* synhronic dma tables area offset */
> +#define SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES \
> +     (SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES + \
> +     SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES)
> +
> +/* system memory offset in bytes */
> +#define SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES \
> +     (SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES + \
> +     SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)
> +
> +/* offset of the time area */
> +#define SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES \
> +     (SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES)
> +
> +/* offset of the RAR area */
> +#define SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES \
> +     (SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES + \
> +     SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES)
> +
> +/* offset of the caller id area */
> +#define SEP_CALLER_ID_OFFSET_BYTES \
> +     (SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES + \
> +    SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)
> +
> +/* offset of the DCB area */
> +#define SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES \
> +     (SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES + \
> +     0x400)
> +
> +/* offset of the ext cache area */
> +#define SEP_DRIVER_SYSTEM_EXT_CACHE_ADDR_OFFSET_IN_BYTES \
> +     SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES
> +
> +/* offset of the allocation data pointer area */
> +#define SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES \
> +     (SEP_CALLER_ID_OFFSET_BYTES + \
> +     SEP_CALLER_ID_HASH_SIZE_IN_BYTES)
> +
> +/* the token that defines the start of time address */
> +#define SEP_TIME_VAL_TOKEN                                    0x12345678
> +
> +#define FAKE_RAR_SIZE (1024*1024) /* used only for mfld */
> +/* DEBUG LEVEL MASKS */
> +
> +/* size of the caller id hash (sha2) */
> +#define SEP_CALLER_ID_HASH_SIZE_IN_BYTES                      32
> +
> +/* size of the caller id hash (sha2) in 32 bit words */
> +#define SEP_CALLER_ID_HASH_SIZE_IN_WORDS                8
> +
> +/* maximum number of entries in the caller id table */
> +#define SEP_CALLER_ID_TABLE_NUM_ENTRIES                       20
> +
> +/* maximum number of symetric operation (that require DMA resource)
> +     per one message */
> +#define SEP_MAX_NUM_SYNC_DMA_OPS                     16
> +
> +/* the token that defines the start of time address */
> +#define SEP_RAR_VAL_TOKEN                                     0xABABABAB
> +
> +/* ioctl error that should be returned when trying
> +   to realloc the cache/resident second time */
> +#define SEP_ALREADY_INITIALIZED_ERR                           12
> +
> +/* bit that locks access to the shared area */
> +#define SEP_MMAP_LOCK_BIT                                     0
> +
> +/* bit that lock access to the poll  - after send_command */
> +#define SEP_SEND_MSG_LOCK_BIT                                 1
> +
> +/* the token that defines the static pool address address */
> +#define SEP_STATIC_POOL_VAL_TOKEN                             0xABBAABBA
> +
> +/* the token that defines the data pool pointers address */
> +#define SEP_DATA_POOL_POINTERS_VAL_TOKEN                      0xEDDEEDDE
> +
> +/* the token that defines the data pool pointers address */
> +#define SEP_EXT_CACHE_ADDR_VAL_TOKEN                          0xBABABABA
> +
> +/* Time limit for SEP to finish */
> +#define WAIT_TIME 10
> +
> +#endif /* SEP DRIVER CONFIG */
> diff --git a/drivers/misc/sep/sep_driver_hw_defs.h b/drivers/misc/sep/sep_driver_hw_defs.h
> new file mode 100644
> index 0000000..300f909
> --- /dev/null
> +++ b/drivers/misc/sep/sep_driver_hw_defs.h
> @@ -0,0 +1,233 @@
> +/*
> + *
> + *  sep_driver_hw_defs.h - Security Processor Driver hardware definitions
> + *
> + *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> + *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms of the GNU General Public License as published by the Free
> + *  Software Foundation; version 2 of the License.
> + *
> + *  This program is distributed in the hope that it will be useful, but WITHOUT
> + *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + *  more details.
> + *
> + *  You should have received a copy of the GNU General Public License along with
> + *  this program; if not, write to the Free Software Foundation, Inc., 59
> + *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + *
> + *  CONTACTS:
> + *
> + *  Mark Allyn               mark.a.allyn@intel.com
> + *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> + *
> + *  CHANGES:
> + *
> + *  2010.09.20       Upgrade to Medfield
> + *
> + */
> +
> +#ifndef SEP_DRIVER_HW_DEFS__H
> +#define SEP_DRIVER_HW_DEFS__H
> +
> +/* PCI ID's */
> +#define MFLD_PCI_DEVICE_ID 0x0826
> +
> +/*----------------------- */
> +/* HW Registers Defines.  */
> +/*                        */
> +/*---------------------- -*/
> +
> +
> +/* cf registers */
> +#define              HW_R0B_ADDR_0_REG_ADDR                  0x0000UL
> +#define              HW_R0B_ADDR_1_REG_ADDR                  0x0004UL
> +#define              HW_R0B_ADDR_2_REG_ADDR                  0x0008UL
> +#define              HW_R0B_ADDR_3_REG_ADDR                  0x000cUL
> +#define              HW_R0B_ADDR_4_REG_ADDR                  0x0010UL
> +#define              HW_R0B_ADDR_5_REG_ADDR                  0x0014UL
> +#define              HW_R0B_ADDR_6_REG_ADDR                  0x0018UL
> +#define              HW_R0B_ADDR_7_REG_ADDR                  0x001cUL
> +#define              HW_R0B_ADDR_8_REG_ADDR                  0x0020UL
> +#define              HW_R2B_ADDR_0_REG_ADDR                  0x0080UL
> +#define              HW_R2B_ADDR_1_REG_ADDR                  0x0084UL
> +#define              HW_R2B_ADDR_2_REG_ADDR                  0x0088UL
> +#define              HW_R2B_ADDR_3_REG_ADDR                  0x008cUL
> +#define              HW_R2B_ADDR_4_REG_ADDR                  0x0090UL
> +#define              HW_R2B_ADDR_5_REG_ADDR                  0x0094UL
> +#define              HW_R2B_ADDR_6_REG_ADDR                  0x0098UL
> +#define              HW_R2B_ADDR_7_REG_ADDR                  0x009cUL
> +#define              HW_R2B_ADDR_8_REG_ADDR                  0x00a0UL
> +#define              HW_R3B_REG_ADDR                         0x00C0UL
> +#define              HW_R4B_REG_ADDR                         0x0100UL
> +#define              HW_CSA_ADDR_0_REG_ADDR                  0x0140UL
> +#define              HW_CSA_ADDR_1_REG_ADDR                  0x0144UL
> +#define              HW_CSA_ADDR_2_REG_ADDR                  0x0148UL
> +#define              HW_CSA_ADDR_3_REG_ADDR                  0x014cUL
> +#define              HW_CSA_ADDR_4_REG_ADDR                  0x0150UL
> +#define              HW_CSA_ADDR_5_REG_ADDR                  0x0154UL
> +#define              HW_CSA_ADDR_6_REG_ADDR                  0x0158UL
> +#define              HW_CSA_ADDR_7_REG_ADDR                  0x015cUL
> +#define              HW_CSA_ADDR_8_REG_ADDR                  0x0160UL
> +#define              HW_CSA_REG_ADDR                         0x0140UL
> +#define              HW_SINB_REG_ADDR                        0x0180UL
> +#define              HW_SOUTB_REG_ADDR                       0x0184UL
> +#define              HW_PKI_CONTROL_REG_ADDR                 0x01C0UL
> +#define              HW_PKI_STATUS_REG_ADDR                  0x01C4UL
> +#define              HW_PKI_BUSY_REG_ADDR                    0x01C8UL
> +#define              HW_PKI_A_1025_REG_ADDR                  0x01CCUL
> +#define              HW_PKI_SDMA_CTL_REG_ADDR                0x01D0UL
> +#define              HW_PKI_SDMA_OFFSET_REG_ADDR             0x01D4UL
> +#define              HW_PKI_SDMA_POINTERS_REG_ADDR           0x01D8UL
> +#define              HW_PKI_SDMA_DLENG_REG_ADDR              0x01DCUL
> +#define              HW_PKI_SDMA_EXP_POINTERS_REG_ADDR       0x01E0UL
> +#define              HW_PKI_SDMA_RES_POINTERS_REG_ADDR       0x01E4UL
> +#define              HW_PKI_CLR_REG_ADDR                     0x01E8UL
> +#define              HW_PKI_SDMA_BUSY_REG_ADDR               0x01E8UL
> +#define              HW_PKI_SDMA_FIRST_EXP_N_REG_ADDR        0x01ECUL
> +#define              HW_PKI_SDMA_MUL_BY1_REG_ADDR            0x01F0UL
> +#define              HW_PKI_SDMA_RMUL_SEL_REG_ADDR           0x01F4UL
> +#define              HW_DES_KEY_0_REG_ADDR                   0x0208UL
> +#define              HW_DES_KEY_1_REG_ADDR                   0x020CUL
> +#define              HW_DES_KEY_2_REG_ADDR                   0x0210UL
> +#define              HW_DES_KEY_3_REG_ADDR                   0x0214UL
> +#define              HW_DES_KEY_4_REG_ADDR                   0x0218UL
> +#define              HW_DES_KEY_5_REG_ADDR                   0x021CUL
> +#define              HW_DES_CONTROL_0_REG_ADDR               0x0220UL
> +#define              HW_DES_CONTROL_1_REG_ADDR               0x0224UL
> +#define              HW_DES_IV_0_REG_ADDR                    0x0228UL
> +#define              HW_DES_IV_1_REG_ADDR                    0x022CUL
> +#define              HW_AES_KEY_0_ADDR_0_REG_ADDR            0x0400UL
> +#define              HW_AES_KEY_0_ADDR_1_REG_ADDR            0x0404UL
> +#define              HW_AES_KEY_0_ADDR_2_REG_ADDR            0x0408UL
> +#define              HW_AES_KEY_0_ADDR_3_REG_ADDR            0x040cUL
> +#define              HW_AES_KEY_0_ADDR_4_REG_ADDR            0x0410UL
> +#define              HW_AES_KEY_0_ADDR_5_REG_ADDR            0x0414UL
> +#define              HW_AES_KEY_0_ADDR_6_REG_ADDR            0x0418UL
> +#define              HW_AES_KEY_0_ADDR_7_REG_ADDR            0x041cUL
> +#define              HW_AES_KEY_0_REG_ADDR                   0x0400UL
> +#define              HW_AES_IV_0_ADDR_0_REG_ADDR             0x0440UL
> +#define              HW_AES_IV_0_ADDR_1_REG_ADDR             0x0444UL
> +#define              HW_AES_IV_0_ADDR_2_REG_ADDR             0x0448UL
> +#define              HW_AES_IV_0_ADDR_3_REG_ADDR             0x044cUL
> +#define              HW_AES_IV_0_REG_ADDR                    0x0440UL
> +#define              HW_AES_CTR1_ADDR_0_REG_ADDR             0x0460UL
> +#define              HW_AES_CTR1_ADDR_1_REG_ADDR             0x0464UL
> +#define              HW_AES_CTR1_ADDR_2_REG_ADDR             0x0468UL
> +#define              HW_AES_CTR1_ADDR_3_REG_ADDR             0x046cUL
> +#define              HW_AES_CTR1_REG_ADDR                    0x0460UL
> +#define              HW_AES_SK_REG_ADDR                      0x0478UL
> +#define              HW_AES_MAC_OK_REG_ADDR                  0x0480UL
> +#define              HW_AES_PREV_IV_0_ADDR_0_REG_ADDR        0x0490UL
> +#define              HW_AES_PREV_IV_0_ADDR_1_REG_ADDR        0x0494UL
> +#define              HW_AES_PREV_IV_0_ADDR_2_REG_ADDR        0x0498UL
> +#define              HW_AES_PREV_IV_0_ADDR_3_REG_ADDR        0x049cUL
> +#define              HW_AES_PREV_IV_0_REG_ADDR               0x0490UL
> +#define              HW_AES_CONTROL_REG_ADDR                 0x04C0UL
> +#define              HW_HASH_H0_REG_ADDR                     0x0640UL
> +#define              HW_HASH_H1_REG_ADDR                     0x0644UL
> +#define              HW_HASH_H2_REG_ADDR                     0x0648UL
> +#define              HW_HASH_H3_REG_ADDR                     0x064CUL
> +#define              HW_HASH_H4_REG_ADDR                     0x0650UL
> +#define              HW_HASH_H5_REG_ADDR                     0x0654UL
> +#define              HW_HASH_H6_REG_ADDR                     0x0658UL
> +#define              HW_HASH_H7_REG_ADDR                     0x065CUL
> +#define              HW_HASH_H8_REG_ADDR                     0x0660UL
> +#define              HW_HASH_H9_REG_ADDR                     0x0664UL
> +#define              HW_HASH_H10_REG_ADDR                    0x0668UL
> +#define              HW_HASH_H11_REG_ADDR                    0x066CUL
> +#define              HW_HASH_H12_REG_ADDR                    0x0670UL
> +#define              HW_HASH_H13_REG_ADDR                    0x0674UL
> +#define              HW_HASH_H14_REG_ADDR                    0x0678UL
> +#define              HW_HASH_H15_REG_ADDR                    0x067CUL
> +#define              HW_HASH_CONTROL_REG_ADDR                0x07C0UL
> +#define              HW_HASH_PAD_EN_REG_ADDR                 0x07C4UL
> +#define              HW_HASH_PAD_CFG_REG_ADDR                0x07C8UL
> +#define              HW_HASH_CUR_LEN_0_REG_ADDR              0x07CCUL
> +#define              HW_HASH_CUR_LEN_1_REG_ADDR              0x07D0UL
> +#define              HW_HASH_CUR_LEN_2_REG_ADDR              0x07D4UL
> +#define              HW_HASH_CUR_LEN_3_REG_ADDR              0x07D8UL
> +#define              HW_HASH_PARAM_REG_ADDR                  0x07DCUL
> +#define              HW_HASH_INT_BUSY_REG_ADDR               0x07E0UL
> +#define              HW_HASH_SW_RESET_REG_ADDR               0x07E4UL
> +#define              HW_HASH_ENDIANESS_REG_ADDR              0x07E8UL
> +#define              HW_HASH_DATA_REG_ADDR                   0x07ECUL
> +#define              HW_DRNG_CONTROL_REG_ADDR                0x0800UL
> +#define              HW_DRNG_VALID_REG_ADDR                  0x0804UL
> +#define              HW_DRNG_DATA_REG_ADDR                   0x0808UL
> +#define              HW_RND_SRC_EN_REG_ADDR                  0x080CUL
> +#define              HW_AES_CLK_ENABLE_REG_ADDR              0x0810UL
> +#define              HW_DES_CLK_ENABLE_REG_ADDR              0x0814UL
> +#define              HW_HASH_CLK_ENABLE_REG_ADDR             0x0818UL
> +#define              HW_PKI_CLK_ENABLE_REG_ADDR              0x081CUL
> +#define              HW_CLK_STATUS_REG_ADDR                  0x0824UL
> +#define              HW_CLK_ENABLE_REG_ADDR                  0x0828UL
> +#define              HW_DRNG_SAMPLE_REG_ADDR                 0x0850UL
> +#define              HW_RND_SRC_CTL_REG_ADDR                 0x0858UL
> +#define              HW_CRYPTO_CTL_REG_ADDR                  0x0900UL
> +#define              HW_CRYPTO_STATUS_REG_ADDR               0x090CUL
> +#define              HW_CRYPTO_BUSY_REG_ADDR                 0x0910UL
> +#define              HW_AES_BUSY_REG_ADDR                    0x0914UL
> +#define              HW_DES_BUSY_REG_ADDR                    0x0918UL
> +#define              HW_HASH_BUSY_REG_ADDR                   0x091CUL
> +#define              HW_CONTENT_REG_ADDR                     0x0924UL
> +#define              HW_VERSION_REG_ADDR                     0x0928UL
> +#define              HW_CONTEXT_ID_REG_ADDR                  0x0930UL
> +#define              HW_DIN_BUFFER_REG_ADDR                  0x0C00UL
> +#define              HW_DIN_MEM_DMA_BUSY_REG_ADDR            0x0c20UL
> +#define              HW_SRC_LLI_MEM_ADDR_REG_ADDR            0x0c24UL
> +#define              HW_SRC_LLI_WORD0_REG_ADDR               0x0C28UL
> +#define              HW_SRC_LLI_WORD1_REG_ADDR               0x0C2CUL
> +#define              HW_SRAM_SRC_ADDR_REG_ADDR               0x0c30UL
> +#define              HW_DIN_SRAM_BYTES_LEN_REG_ADDR          0x0c34UL
> +#define              HW_DIN_SRAM_DMA_BUSY_REG_ADDR           0x0C38UL
> +#define              HW_WRITE_ALIGN_REG_ADDR                 0x0C3CUL
> +#define              HW_OLD_DATA_REG_ADDR                    0x0C48UL
> +#define              HW_WRITE_ALIGN_LAST_REG_ADDR            0x0C4CUL
> +#define              HW_DOUT_BUFFER_REG_ADDR                 0x0C00UL
> +#define              HW_DST_LLI_WORD0_REG_ADDR               0x0D28UL
> +#define              HW_DST_LLI_WORD1_REG_ADDR               0x0D2CUL
> +#define              HW_DST_LLI_MEM_ADDR_REG_ADDR            0x0D24UL
> +#define              HW_DOUT_MEM_DMA_BUSY_REG_ADDR           0x0D20UL
> +#define              HW_SRAM_DEST_ADDR_REG_ADDR              0x0D30UL
> +#define              HW_DOUT_SRAM_BYTES_LEN_REG_ADDR         0x0D34UL
> +#define              HW_DOUT_SRAM_DMA_BUSY_REG_ADDR          0x0D38UL
> +#define              HW_READ_ALIGN_REG_ADDR                  0x0D3CUL
> +#define              HW_READ_LAST_DATA_REG_ADDR              0x0D44UL
> +#define              HW_RC4_THRU_CPU_REG_ADDR                0x0D4CUL
> +#define              HW_AHB_SINGLE_REG_ADDR                  0x0E00UL
> +#define              HW_SRAM_DATA_REG_ADDR                   0x0F00UL
> +#define              HW_SRAM_ADDR_REG_ADDR                   0x0F04UL
> +#define              HW_SRAM_DATA_READY_REG_ADDR             0x0F08UL
> +#define              HW_HOST_IRR_REG_ADDR                    0x0A00UL
> +#define              HW_HOST_IMR_REG_ADDR                    0x0A04UL
> +#define              HW_HOST_ICR_REG_ADDR                    0x0A08UL
> +#define              HW_HOST_SEP_SRAM_THRESHOLD_REG_ADDR     0x0A10UL
> +#define              HW_HOST_SEP_BUSY_REG_ADDR               0x0A14UL
> +#define              HW_HOST_SEP_LCS_REG_ADDR                0x0A18UL
> +#define              HW_HOST_CC_SW_RST_REG_ADDR              0x0A40UL
> +#define              HW_HOST_SEP_SW_RST_REG_ADDR             0x0A44UL
> +#define              HW_HOST_FLOW_DMA_SW_INT0_REG_ADDR       0x0A80UL
> +#define              HW_HOST_FLOW_DMA_SW_INT1_REG_ADDR       0x0A84UL
> +#define              HW_HOST_FLOW_DMA_SW_INT2_REG_ADDR       0x0A88UL
> +#define              HW_HOST_FLOW_DMA_SW_INT3_REG_ADDR       0x0A8cUL
> +#define              HW_HOST_FLOW_DMA_SW_INT4_REG_ADDR       0x0A90UL
> +#define              HW_HOST_FLOW_DMA_SW_INT5_REG_ADDR       0x0A94UL
> +#define              HW_HOST_FLOW_DMA_SW_INT6_REG_ADDR       0x0A98UL
> +#define              HW_HOST_FLOW_DMA_SW_INT7_REG_ADDR       0x0A9cUL
> +#define              HW_HOST_SEP_HOST_GPR0_REG_ADDR          0x0B00UL
> +#define              HW_HOST_SEP_HOST_GPR1_REG_ADDR          0x0B04UL
> +#define              HW_HOST_SEP_HOST_GPR2_REG_ADDR          0x0B08UL
> +#define              HW_HOST_SEP_HOST_GPR3_REG_ADDR          0x0B0CUL
> +#define              HW_HOST_HOST_SEP_GPR0_REG_ADDR          0x0B80UL
> +#define              HW_HOST_HOST_SEP_GPR1_REG_ADDR          0x0B84UL
> +#define              HW_HOST_HOST_SEP_GPR2_REG_ADDR          0x0B88UL
> +#define              HW_HOST_HOST_SEP_GPR3_REG_ADDR          0x0B8CUL
> +#define              HW_HOST_HOST_ENDIAN_REG_ADDR            0x0B90UL
> +#define              HW_HOST_HOST_COMM_CLK_EN_REG_ADDR       0x0B94UL
> +#define              HW_CLR_SRAM_BUSY_REG_REG_ADDR           0x0F0CUL
> +#define              HW_CC_SRAM_BASE_ADDRESS                 0x5800UL
> +
> +#endif               /* ifndef HW_DEFS */
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index e3786f1..8fa8db2 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -117,8 +117,6 @@ source "drivers/staging/hv/Kconfig"
>
>  source "drivers/staging/vme/Kconfig"
>
> -source "drivers/staging/sep/Kconfig"
> -
>  source "drivers/staging/iio/Kconfig"
>
>  source "drivers/staging/cs5535_gpio/Kconfig"
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index 1d11306..29cfef3 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -41,7 +41,6 @@ obj-$(CONFIG_VT6655)                += vt6655/
>  obj-$(CONFIG_VT6656)         += vt6656/
>  obj-$(CONFIG_HYPERV)         += hv/
>  obj-$(CONFIG_VME_BUS)                += vme/
> -obj-$(CONFIG_DX_SEP)            += sep/
>  obj-$(CONFIG_IIO)            += iio/
>  obj-$(CONFIG_CS5535_GPIO)    += cs5535_gpio/
>  obj-$(CONFIG_ZRAM)           += zram/
> diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
> deleted file mode 100644
> index 92bf166..0000000
> --- a/drivers/staging/sep/Kconfig
> +++ /dev/null
> @@ -1,10 +0,0 @@
> -config DX_SEP
> -     tristate "Discretix SEP driver"
> -     depends on PCI
> -     help
> -       Discretix SEP driver; used for the security processor subsystem
> -       on bard the Intel Mobile Internet Device.
> -
> -       The driver's name is sep_driver.
> -
> -       If unsure, select N.
> diff --git a/drivers/staging/sep/Makefile b/drivers/staging/sep/Makefile
> deleted file mode 100644
> index 628d5f9..0000000
> --- a/drivers/staging/sep/Makefile
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -obj-$(CONFIG_DX_SEP) := sep_driver.o
> -
> diff --git a/drivers/staging/sep/TODO b/drivers/staging/sep/TODO
> deleted file mode 100644
> index 8f3b878..0000000
> --- a/drivers/staging/sep/TODO
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -Todo's so far (from Alan Cox)
> -- Check whether it can be plugged into any of the kernel crypto API
> -  interfaces - Crypto API 'glue' is still not ready to submit
> -- Clean up un-needed debug prints - Started to work on this
> diff --git a/drivers/staging/sep/sep_dev.h b/drivers/staging/sep/sep_dev.h
> deleted file mode 100644
> index 696ab0d..0000000
> --- a/drivers/staging/sep/sep_dev.h
> +++ /dev/null
> @@ -1,131 +0,0 @@
> -#ifndef __SEP_DEV_H__
> -#define __SEP_DEV_H__
> -
> -/*
> - *
> - *  sep_dev.h - Security Processor Device Structures
> - *
> - *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> - *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> - *
> - *  This program is free software; you can redistribute it and/or modify it
> - *  under the terms of the GNU General Public License as published by the Free
> - *  Software Foundation; version 2 of the License.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
> - *  CONTACTS:
> - *
> - *  Mark Allyn               mark.a.allyn@intel.com
> - *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> - *
> - *  CHANGES
> - *  2010.09.14  upgrade to Medfield
> - */
> -
> -struct sep_device {
> -     /* pointer to pci dev */
> -     struct pci_dev *pdev;
> -
> -     /* character device file */
> -     struct cdev sep_cdev;
> -     struct cdev sep_daemon_cdev;
> -     struct cdev sep_singleton_cdev;
> -
> -     /* devices (using misc dev) */
> -     struct miscdevice miscdev_sep;
> -     struct miscdevice miscdev_singleton;
> -     struct miscdevice miscdev_daemon;
> -
> -     /* major / minor numbers of device */
> -     dev_t sep_devno;
> -     dev_t sep_daemon_devno;
> -     dev_t sep_singleton_devno;
> -
> -     struct mutex sep_mutex;
> -     struct mutex ioctl_mutex;
> -     spinlock_t snd_rply_lck;
> -
> -     /* flags to indicate use and lock status of sep */
> -     u32 pid_doing_transaction;
> -     unsigned long in_use_flags;
> -
> -     /* request daemon alread open */
> -     unsigned long request_daemon_open;
> -
> -     /* 1 = Moorestown; 0 = Medfield */
> -     int mrst;
> -
> -     /* address of the shared memory allocated during init for SEP driver
> -        (coherent alloc) */
> -     dma_addr_t shared_bus;
> -     size_t shared_size;
> -     void *shared_addr;
> -
> -     /* start address of the access to the SEP registers from driver */
> -     dma_addr_t reg_physical_addr;
> -     dma_addr_t reg_physical_end;
> -     void __iomem *reg_addr;
> -
> -     /* wait queue head (event) of the driver */
> -     wait_queue_head_t event;
> -     wait_queue_head_t event_request_daemon;
> -     wait_queue_head_t event_mmap;
> -
> -     struct sep_caller_id_entry
> -             caller_id_table[SEP_CALLER_ID_TABLE_NUM_ENTRIES];
> -
> -     /* access flag for singleton device */
> -     unsigned long singleton_access_flag;
> -
> -     /* transaction counter that coordinates the
> -        transactions between SEP and HOST */
> -     unsigned long send_ct;
> -     /* counter for the messages from sep */
> -     unsigned long reply_ct;
> -     /* counter for the number of bytes allocated in the pool for the
> -        current transaction */
> -     long data_pool_bytes_allocated;
> -
> -     u32 num_of_data_allocations;
> -
> -     /* number of the lli tables created in the current transaction */
> -     u32     num_lli_tables_created;
> -
> -     /* number of data control blocks */
> -     u32 nr_dcb_creat;
> -
> -     struct sep_dma_resource dma_res_arr[SEP_MAX_NUM_SYNC_DMA_OPS];
> -
> -};
> -
> -static inline void sep_write_reg(struct sep_device *dev, int reg, u32 value)
> -{
> -     void __iomem *addr = dev->reg_addr + reg;
> -     writel(value, addr);
> -}
> -
> -static inline u32 sep_read_reg(struct sep_device *dev, int reg)
> -{
> -     void __iomem *addr = dev->reg_addr + reg;
> -     return readl(addr);
> -}
> -
> -/* wait for SRAM write complete(indirect write */
> -static inline void sep_wait_sram_write(struct sep_device *dev)
> -{
> -     u32 reg_val;
> -     do {
> -             reg_val = sep_read_reg(dev, HW_SRAM_DATA_READY_REG_ADDR);
> -     } while (!(reg_val & 1));
> -}
> -
> -
> -#endif
> diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
> deleted file mode 100644
> index 890eede..0000000
> --- a/drivers/staging/sep/sep_driver.c
> +++ /dev/null
> @@ -1,2928 +0,0 @@
> -/*
> - *
> - *  sep_driver.c - Security Processor Driver main group of functions
> - *
> - *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> - *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> - *
> - *  This program is free software; you can redistribute it and/or modify it
> - *  under the terms of the GNU General Public License as published by the Free
> - *  Software Foundation; version 2 of the License.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
> - *  CONTACTS:
> - *
> - *  Mark Allyn               mark.a.allyn@intel.com
> - *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> - *
> - *  CHANGES:
> - *
> - *  2009.06.26       Initial publish
> - *  2010.09.14  Upgrade to Medfield
> - *
> - */
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/miscdevice.h>
> -#include <linux/fs.h>
> -#include <linux/cdev.h>
> -#include <linux/kdev_t.h>
> -#include <linux/mutex.h>
> -#include <linux/sched.h>
> -#include <linux/mm.h>
> -#include <linux/poll.h>
> -#include <linux/wait.h>
> -#include <linux/pci.h>
> -#include <linux/firmware.h>
> -#include <linux/slab.h>
> -#include <linux/ioctl.h>
> -#include <asm/current.h>
> -#include <linux/ioport.h>
> -#include <linux/io.h>
> -#include <linux/interrupt.h>
> -#include <linux/pagemap.h>
> -#include <asm/cacheflush.h>
> -#include <linux/sched.h>
> -#include <linux/delay.h>
> -#include <linux/jiffies.h>
> -#include <linux/rar_register.h>
> -
> -#include "sep_driver_hw_defs.h"
> -#include "sep_driver_config.h"
> -#include "sep_driver_api.h"
> -#include "sep_dev.h"
> -
> -/*----------------------------------------
> -     DEFINES
> ------------------------------------------*/
> -
> -#define SEP_RAR_IO_MEM_REGION_SIZE 0x40000
> -
> -/*--------------------------------------------
> -     GLOBAL variables
> ---------------------------------------------*/
> -
> -/* Keep this a single static object for now to keep the conversion easy */
> -
> -static struct sep_device *sep_dev;
> -
> -/**
> - *   sep_dump_message - dump the message that is pending
> - *   @sep: SEP device
> - */
> -static void sep_dump_message(struct sep_device *sep)
> -{
> -     int count;
> -     u32 *p = sep->shared_addr;
> -     for (count = 0; count < 12 * 4; count += 4)
> -             dev_dbg(&sep->pdev->dev, "Word %d of the message is %x\n",
> -                                                             count, *p++);
> -}
> -
> -/**
> - *   sep_map_and_alloc_shared_area - allocate shared block
> - *   @sep: security processor
> - *   @size: size of shared area
> - */
> -static int sep_map_and_alloc_shared_area(struct sep_device *sep)
> -{
> -     sep->shared_addr = dma_alloc_coherent(&sep->pdev->dev,
> -             sep->shared_size,
> -             &sep->shared_bus, GFP_KERNEL);
> -
> -     if (!sep->shared_addr) {
> -             dev_warn(&sep->pdev->dev,
> -                     "shared memory dma_alloc_coherent failed\n");
> -             return -ENOMEM;
> -     }
> -     dev_dbg(&sep->pdev->dev,
> -             "shared_addr %zx bytes @%p (bus %llx)\n",
> -                             sep->shared_size, sep->shared_addr,
> -                             (unsigned long long)sep->shared_bus);
> -     return 0;
> -}
> -
> -/**
> - *   sep_unmap_and_free_shared_area - free shared block
> - *   @sep: security processor
> - */
> -static void sep_unmap_and_free_shared_area(struct sep_device *sep)
> -{
> -     dma_free_coherent(&sep->pdev->dev, sep->shared_size,
> -                             sep->shared_addr, sep->shared_bus);
> -}
> -
> -/**
> - *   sep_shared_bus_to_virt - convert bus/virt addresses
> - *   @sep: pointer to struct sep_device
> - *   @bus_address: address to convert
> - *
> - *   Returns virtual address inside the shared area according
> - *   to the bus address.
> - */
> -static void *sep_shared_bus_to_virt(struct sep_device *sep,
> -                                             dma_addr_t bus_address)
> -{
> -     return sep->shared_addr + (bus_address - sep->shared_bus);
> -}
> -
> -/**
> - *   open function for the singleton driver
> - *   @inode_ptr struct inode *
> - *   @file_ptr struct file *
> - *
> - *   Called when the user opens the singleton device interface
> - */
> -static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
> -{
> -     struct sep_device *sep;
> -
> -     /*
> -      * Get the SEP device structure and use it for the
> -      * private_data field in filp for other methods
> -      */
> -     sep = sep_dev;
> -
> -     file_ptr->private_data = sep;
> -
> -     if (test_and_set_bit(0, &sep->singleton_access_flag))
> -             return -EBUSY;
> -     return 0;
> -}
> -
> -/**
> - *   sep_open - device open method
> - *   @inode: inode of SEP device
> - *   @filp: file handle to SEP device
> - *
> - *   Open method for the SEP device. Called when userspace opens
> - *   the SEP device node.
> - *
> - *   Returns zero on success otherwise an error code.
> - */
> -static int sep_open(struct inode *inode, struct file *filp)
> -{
> -     struct sep_device *sep;
> -
> -     /*
> -      * Get the SEP device structure and use it for the
> -      * private_data field in filp for other methods
> -      */
> -     sep = sep_dev;
> -     filp->private_data = sep;
> -
> -     /* Anyone can open; locking takes place at transaction level */
> -     return 0;
> -}
> -
> -/**
> - *   sep_singleton_release - close a SEP singleton device
> - *   @inode: inode of SEP device
> - *   @filp: file handle being closed
> - *
> - *   Called on the final close of a SEP device. As the open protects against
> - *   multiple simultaenous opens that means this method is called when the
> - *   final reference to the open handle is dropped.
> - */
> -static int sep_singleton_release(struct inode *inode, struct file *filp)
> -{
> -     struct sep_device *sep = filp->private_data;
> -
> -     clear_bit(0, &sep->singleton_access_flag);
> -     return 0;
> -}
> -
> -/**
> - *   sep_request_daemonopen - request daemon open method
> - *   @inode: inode of SEP device
> - *   @filp: file handle to SEP device
> - *
> - *   Open method for the SEP request daemon. Called when
> - *   request daemon in userspace opens the SEP device node.
> - *
> - *   Returns zero on success otherwise an error code.
> - */
> -static int sep_request_daemon_open(struct inode *inode, struct file *filp)
> -{
> -     struct sep_device *sep = sep_dev;
> -     int error = 0;
> -
> -     filp->private_data = sep;
> -
> -     /* There is supposed to be only one request daemon */
> -     if (test_and_set_bit(0, &sep->request_daemon_open))
> -             error = -EBUSY;
> -     return error;
> -}
> -
> -/**
> - *   sep_request_daemon_release - close a SEP daemon
> - *   @inode: inode of SEP device
> - *   @filp: file handle being closed
> - *
> - *   Called on the final close of a SEP daemon.
> - */
> -static int sep_request_daemon_release(struct inode *inode, struct file *filp)
> -{
> -     struct sep_device *sep = filp->private_data;
> -
> -     dev_dbg(&sep->pdev->dev, "Request daemon release for pid %d\n",
> -             current->pid);
> -
> -     /* Clear the request_daemon_open flag */
> -     clear_bit(0, &sep->request_daemon_open);
> -     return 0;
> -}
> -
> -/**
> - *   sep_req_daemon_send_reply_command_handler - poke the SEP
> - *   @sep: struct sep_device *
> - *
> - *   This function raises interrupt to SEPm that signals that is has a
> - *   new command from HOST
> - */
> -static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
> -{
> -     unsigned long lck_flags;
> -
> -     sep_dump_message(sep);
> -
> -     /* Counters are lockable region */
> -     spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> -     sep->send_ct++;
> -     sep->reply_ct++;
> -
> -     /* Send the interrupt to SEP */
> -     sep_write_reg(sep, HW_HOST_HOST_SEP_GPR2_REG_ADDR, sep->send_ct);
> -     sep->send_ct++;
> -
> -     spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> -
> -     dev_dbg(&sep->pdev->dev,
> -             "sep_req_daemon_send_reply send_ct %lx reply_ct %lx\n",
> -             sep->send_ct, sep->reply_ct);
> -
> -     return 0;
> -}
> -
> -
> -/**
> - *   sep_free_dma_table_data_handler - free DMA table
> - *   @sep: pointere to struct sep_device
> - *
> - *   Handles the request to  free DMA table for synchronic actions
> - */
> -static int sep_free_dma_table_data_handler(struct sep_device *sep)
> -{
> -     int count;
> -     int dcb_counter;
> -     /* Pointer to the current dma_resource struct */
> -     struct sep_dma_resource *dma;
> -
> -     for (dcb_counter = 0; dcb_counter < sep->nr_dcb_creat; dcb_counter++) {
> -             dma = &sep->dma_res_arr[dcb_counter];
> -
> -             /* Unmap and free input map array */
> -             if (dma->in_map_array) {
> -                     for (count = 0; count < dma->in_num_pages; count++) {
> -                             dma_unmap_page(&sep->pdev->dev,
> -                                     dma->in_map_array[count].dma_addr,
> -                                     dma->in_map_array[count].size,
> -                                     DMA_TO_DEVICE);
> -                     }
> -                     kfree(dma->in_map_array);
> -             }
> -
> -             /* Unmap output map array, DON'T free it yet */
> -             if (dma->out_map_array) {
> -                     for (count = 0; count < dma->out_num_pages; count++) {
> -                             dma_unmap_page(&sep->pdev->dev,
> -                                     dma->out_map_array[count].dma_addr,
> -                                     dma->out_map_array[count].size,
> -                                     DMA_FROM_DEVICE);
> -                     }
> -                     kfree(dma->out_map_array);
> -             }
> -
> -             /* Free page cache for output */
> -             if (dma->in_page_array) {
> -                     for (count = 0; count < dma->in_num_pages; count++) {
> -                             flush_dcache_page(dma->in_page_array[count]);
> -                             page_cache_release(dma->in_page_array[count]);
> -                     }
> -                     kfree(dma->in_page_array);
> -             }
> -
> -             if (dma->out_page_array) {
> -                     for (count = 0; count < dma->out_num_pages; count++) {
> -                             if (!PageReserved(dma->out_page_array[count]))
> -                                     SetPageDirty(dma->out_page_array[count]);
> -                             flush_dcache_page(dma->out_page_array[count]);
> -                             page_cache_release(dma->out_page_array[count]);
> -                     }
> -                     kfree(dma->out_page_array);
> -             }
> -
> -             /* Reset all the values */
> -             dma->in_page_array = NULL;
> -             dma->out_page_array = NULL;
> -             dma->in_num_pages = 0;
> -             dma->out_num_pages = 0;
> -             dma->in_map_array = NULL;
> -             dma->out_map_array = NULL;
> -             dma->in_map_num_entries = 0;
> -             dma->out_map_num_entries = 0;
> -     }
> -
> -     sep->nr_dcb_creat = 0;
> -     sep->num_lli_tables_created = 0;
> -
> -     return 0;
> -}
> -
> -/**
> - *   sep_request_daemon_mmap - maps the shared area to user space
> - *   @filp: pointer to struct file
> - *   @vma: pointer to vm_area_struct
> - *
> - *   Called by the kernel when the daemon attempts an mmap() syscall
> - *   using our handle.
> - */
> -static int sep_request_daemon_mmap(struct file  *filp,
> -     struct vm_area_struct  *vma)
> -{
> -     struct sep_device *sep = filp->private_data;
> -     dma_addr_t bus_address;
> -     int error = 0;
> -
> -     if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
> -             error = -EINVAL;
> -             goto end_function;
> -     }
> -
> -     /* Get physical address */
> -     bus_address = sep->shared_bus;
> -
> -     if (remap_pfn_range(vma, vma->vm_start, bus_address >> PAGE_SHIFT,
> -             vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
> -
> -             dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
> -             error = -EAGAIN;
> -             goto end_function;
> -     }
> -
> -end_function:
> -     return error;
> -}
> -
> -/**
> - *   sep_request_daemon_poll - poll implementation
> - *   @sep: struct sep_device * for current SEP device
> - *   @filp: struct file * for open file
> - *   @wait: poll_table * for poll
> - *
> - *   Called when our device is part of a poll() or select() syscall
> - */
> -static unsigned int sep_request_daemon_poll(struct file *filp,
> -     poll_table  *wait)
> -{
> -     u32     mask = 0;
> -     /* GPR2 register */
> -     u32     retval2;
> -     unsigned long lck_flags;
> -     struct sep_device *sep = filp->private_data;
> -
> -     poll_wait(filp, &sep->event_request_daemon, wait);
> -
> -     dev_dbg(&sep->pdev->dev, "daemon poll: send_ct is %lx reply ct is %lx\n",
> -                                             sep->send_ct, sep->reply_ct);
> -
> -     spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> -     /* Check if the data is ready */
> -     if (sep->send_ct == sep->reply_ct) {
> -             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> -
> -             retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
> -             dev_dbg(&sep->pdev->dev,
> -                     "daemon poll: data check (GPR2) is %x\n", retval2);
> -
> -             /* Check if PRINT request */
> -             if ((retval2 >> 30) & 0x1) {
> -                     dev_dbg(&sep->pdev->dev, "daemon poll: PRINTF request in\n");
> -                     mask |= POLLIN;
> -                     goto end_function;
> -             }
> -             /* Check if NVS request */
> -             if (retval2 >> 31) {
> -                     dev_dbg(&sep->pdev->dev, "daemon poll: NVS request in\n");
> -                     mask |= POLLPRI | POLLWRNORM;
> -             }
> -     } else {
> -             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> -             dev_dbg(&sep->pdev->dev,
> -                     "daemon poll: no reply received; returning 0\n");
> -             mask = 0;
> -     }
> -end_function:
> -     return mask;
> -}
> -
> -/**
> - *   sep_release - close a SEP device
> - *   @inode: inode of SEP device
> - *   @filp: file handle being closed
> - *
> - *   Called on the final close of a SEP device.
> - */
> -static int sep_release(struct inode *inode, struct file *filp)
> -{
> -     struct sep_device *sep = filp->private_data;
> -
> -     dev_dbg(&sep->pdev->dev, "Release for pid %d\n", current->pid);
> -
> -     mutex_lock(&sep->sep_mutex);
> -     /* Is this the process that has a transaction open?
> -      * If so, lets reset pid_doing_transaction to 0 and
> -      * clear the in use flags, and then wake up sep_event
> -      * so that other processes can do transactions
> -      */
> -     if (sep->pid_doing_transaction == current->pid) {
> -             clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
> -             clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
> -             sep_free_dma_table_data_handler(sep);
> -             wake_up(&sep->event);
> -             sep->pid_doing_transaction = 0;
> -     }
> -
> -     mutex_unlock(&sep->sep_mutex);
> -     return 0;
> -}
> -
> -/**
> - *   sep_mmap -  maps the shared area to user space
> - *   @filp: pointer to struct file
> - *   @vma: pointer to vm_area_struct
> - *
> - *   Called on an mmap of our space via the normal SEP device
> - */
> -static int sep_mmap(struct file *filp, struct vm_area_struct *vma)
> -{
> -     dma_addr_t bus_addr;
> -     struct sep_device *sep = filp->private_data;
> -     unsigned long error = 0;
> -
> -     /* Set the transaction busy (own the device) */
> -     wait_event_interruptible(sep->event,
> -             test_and_set_bit(SEP_MMAP_LOCK_BIT,
> -             &sep->in_use_flags) == 0);
> -
> -     if (signal_pending(current)) {
> -             error = -EINTR;
> -             goto end_function_with_error;
> -     }
> -     /*
> -      * The pid_doing_transaction indicates that this process
> -      * now owns the facilities to performa a transaction with
> -      * the SEP. While this process is performing a transaction,
> -      * no other process who has the SEP device open can perform
> -      * any transactions. This method allows more than one process
> -      * to have the device open at any given time, which provides
> -      * finer granularity for device utilization by multiple
> -      * processes.
> -      */
> -     mutex_lock(&sep->sep_mutex);
> -     sep->pid_doing_transaction = current->pid;
> -     mutex_unlock(&sep->sep_mutex);
> -
> -     /* Zero the pools and the number of data pool alocation pointers */
> -     sep->data_pool_bytes_allocated = 0;
> -     sep->num_of_data_allocations = 0;
> -
> -     /*
> -      * Check that the size of the mapped range is as the size of the message
> -      * shared area
> -      */
> -     if ((vma->vm_end - vma->vm_start) > SEP_DRIVER_MMMAP_AREA_SIZE) {
> -             error = -EINVAL;
> -             goto end_function_with_error;
> -     }
> -
> -     dev_dbg(&sep->pdev->dev, "shared_addr is %p\n", sep->shared_addr);
> -
> -     /* Get bus address */
> -     bus_addr = sep->shared_bus;
> -
> -     if (remap_pfn_range(vma, vma->vm_start, bus_addr >> PAGE_SHIFT,
> -             vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
> -             dev_warn(&sep->pdev->dev, "remap_page_range failed\n");
> -             error = -EAGAIN;
> -             goto end_function_with_error;
> -     }
> -     goto end_function;
> -
> -end_function_with_error:
> -     /* Clear the bit */
> -     clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
> -     mutex_lock(&sep->sep_mutex);
> -     sep->pid_doing_transaction = 0;
> -     mutex_unlock(&sep->sep_mutex);
> -
> -     /* Raise event for stuck contextes */
> -
> -     wake_up(&sep->event);
> -
> -end_function:
> -     return error;
> -}
> -
> -/**
> - *   sep_poll - poll handler
> - *   @filp: pointer to struct file
> - *   @wait: pointer to poll_table
> - *
> - *   Called by the OS when the kernel is asked to do a poll on
> - *   a SEP file handle.
> - */
> -static unsigned int sep_poll(struct file *filp, poll_table *wait)
> -{
> -     u32 mask = 0;
> -     u32 retval = 0;
> -     u32 retval2 = 0;
> -     unsigned long lck_flags;
> -
> -     struct sep_device *sep = filp->private_data;
> -
> -     /* Am I the process that owns the transaction? */
> -     mutex_lock(&sep->sep_mutex);
> -     if (current->pid != sep->pid_doing_transaction) {
> -             dev_dbg(&sep->pdev->dev, "poll; wrong pid\n");
> -             mask = POLLERR;
> -             mutex_unlock(&sep->sep_mutex);
> -             goto end_function;
> -     }
> -     mutex_unlock(&sep->sep_mutex);
> -
> -     /* Check if send command or send_reply were activated previously */
> -     if (!test_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
> -             mask = POLLERR;
> -             goto end_function;
> -     }
> -
> -     /* Add the event to the polling wait table */
> -     dev_dbg(&sep->pdev->dev, "poll: calling wait sep_event\n");
> -
> -     poll_wait(filp, &sep->event, wait);
> -
> -     dev_dbg(&sep->pdev->dev, "poll: send_ct is %lx reply ct is %lx\n",
> -             sep->send_ct, sep->reply_ct);
> -
> -     /* Check if error occurred during poll */
> -     retval2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR3_REG_ADDR);
> -     if (retval2 != 0x0) {
> -             dev_warn(&sep->pdev->dev, "poll; poll error %x\n", retval2);
> -             mask |= POLLERR;
> -             goto end_function;
> -     }
> -
> -     spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> -
> -     if (sep->send_ct == sep->reply_ct) {
> -             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> -             retval = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
> -             dev_dbg(&sep->pdev->dev, "poll: data ready check (GPR2)  %x\n",
> -                     retval);
> -
> -             /* Check if printf request  */
> -             if ((retval >> 30) & 0x1) {
> -                     dev_dbg(&sep->pdev->dev, "poll: SEP printf request\n");
> -                     wake_up(&sep->event_request_daemon);
> -                     goto end_function;
> -             }
> -
> -             /* Check if the this is SEP reply or request */
> -             if (retval >> 31) {
> -                     dev_dbg(&sep->pdev->dev, "poll: SEP request\n");
> -                     wake_up(&sep->event_request_daemon);
> -             } else {
> -                     dev_dbg(&sep->pdev->dev, "poll: normal return\n");
> -                     /* In case it is again by send_reply_comand */
> -                     clear_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags);
> -                     sep_dump_message(sep);
> -                     dev_dbg(&sep->pdev->dev,
> -                             "poll; SEP reply POLLIN | POLLRDNORM\n");
> -                     mask |= POLLIN | POLLRDNORM;
> -             }
> -     } else {
> -             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> -             dev_dbg(&sep->pdev->dev,
> -                     "poll; no reply received; returning mask of 0\n");
> -             mask = 0;
> -     }
> -
> -end_function:
> -     return mask;
> -}
> -
> -/**
> - *   sep_time_address - address in SEP memory of time
> - *   @sep: SEP device we want the address from
> - *
> - *   Return the address of the two dwords in memory used for time
> - *   setting.
> - */
> -static u32 *sep_time_address(struct sep_device *sep)
> -{
> -     return sep->shared_addr + SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES;
> -}
> -
> -/**
> - *   sep_set_time - set the SEP time
> - *   @sep: the SEP we are setting the time for
> - *
> - *   Calculates time and sets it at the predefined address.
> - *   Called with the SEP mutex held.
> - */
> -static unsigned long sep_set_time(struct sep_device *sep)
> -{
> -     struct timeval time;
> -     u32 *time_addr; /* Address of time as seen by the kernel */
> -
> -
> -     do_gettimeofday(&time);
> -
> -     /* Set value in the SYSTEM MEMORY offset */
> -     time_addr = sep_time_address(sep);
> -
> -     time_addr[0] = SEP_TIME_VAL_TOKEN;
> -     time_addr[1] = time.tv_sec;
> -
> -     dev_dbg(&sep->pdev->dev, "time.tv_sec is %lu\n", time.tv_sec);
> -     dev_dbg(&sep->pdev->dev, "time_addr is %p\n", time_addr);
> -     dev_dbg(&sep->pdev->dev, "sep->shared_addr is %p\n", sep->shared_addr);
> -
> -     return time.tv_sec;
> -}
> -
> -/**
> - *   sep_set_caller_id_handler - insert caller id entry
> - *   @sep: SEP device
> - *   @arg: pointer to struct caller_id_struct
> - *
> - *   Inserts the data into the caller id table. Note that this function
> - *   falls under the ioctl lock
> - */
> -static int sep_set_caller_id_handler(struct sep_device *sep, unsigned long arg)
> -{
> -     void __user *hash;
> -     int   error = 0;
> -     int   i;
> -     struct caller_id_struct command_args;
> -
> -     for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
> -             if (sep->caller_id_table[i].pid == 0)
> -                     break;
> -     }
> -
> -     if (i == SEP_CALLER_ID_TABLE_NUM_ENTRIES) {
> -             dev_dbg(&sep->pdev->dev, "no more caller id entries left\n");
> -             dev_dbg(&sep->pdev->dev, "maximum number is %d\n",
> -                                     SEP_CALLER_ID_TABLE_NUM_ENTRIES);
> -             error = -EUSERS;
> -             goto end_function;
> -     }
> -
> -     /* Copy the data */
> -     if (copy_from_user(&command_args, (void __user *)arg,
> -             sizeof(command_args))) {
> -             error = -EFAULT;
> -             goto end_function;
> -     }
> -
> -     hash = (void __user *)(unsigned long)command_args.callerIdAddress;
> -
> -     if (!command_args.pid || !command_args.callerIdSizeInBytes) {
> -             error = -EINVAL;
> -             goto end_function;
> -     }
> -
> -     dev_dbg(&sep->pdev->dev, "pid is %x\n", command_args.pid);
> -     dev_dbg(&sep->pdev->dev, "callerIdSizeInBytes is %x\n",
> -             command_args.callerIdSizeInBytes);
> -
> -     if (command_args.callerIdSizeInBytes >
> -                                     SEP_CALLER_ID_HASH_SIZE_IN_BYTES) {
> -             error = -EMSGSIZE;
> -             goto end_function;
> -     }
> -
> -     sep->caller_id_table[i].pid = command_args.pid;
> -
> -     if (copy_from_user(sep->caller_id_table[i].callerIdHash,
> -             hash, command_args.callerIdSizeInBytes))
> -             error = -EFAULT;
> -end_function:
> -     return error;
> -}
> -
> -/**
> - *   sep_set_current_caller_id - set the caller id
> - *   @sep: pointer to struct_sep_device
> - *
> - *   Set the caller ID (if it exists) to the SEP. Note that this
> - *   function falls under the ioctl lock
> - */
> -static int sep_set_current_caller_id(struct sep_device *sep)
> -{
> -     int i;
> -     u32 *hash_buf_ptr;
> -
> -     /* Zero the previous value */
> -     memset(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
> -                                     0, SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
> -
> -     for (i = 0; i < SEP_CALLER_ID_TABLE_NUM_ENTRIES; i++) {
> -             if (sep->caller_id_table[i].pid == current->pid) {
> -                     dev_dbg(&sep->pdev->dev, "Caller Id found\n");
> -
> -                     memcpy(sep->shared_addr + SEP_CALLER_ID_OFFSET_BYTES,
> -                             (void *)(sep->caller_id_table[i].callerIdHash),
> -                             SEP_CALLER_ID_HASH_SIZE_IN_BYTES);
> -                     break;
> -             }
> -     }
> -     /* Ensure data is in little endian */
> -     hash_buf_ptr = (u32 *)sep->shared_addr +
> -             SEP_CALLER_ID_OFFSET_BYTES;
> -
> -     for (i = 0; i < SEP_CALLER_ID_HASH_SIZE_IN_WORDS; i++)
> -             hash_buf_ptr[i] = cpu_to_le32(hash_buf_ptr[i]);
> -
> -     return 0;
> -}
> -
> -/**
> - *   sep_send_command_handler - kick off a command
> - *   @sep: SEP being signalled
> - *
> - *   This function raises interrupt to SEP that signals that is has a new
> - *   command from the host
> - *
> - *      Note that this function does fall under the ioctl lock
> - */
> -static int sep_send_command_handler(struct sep_device *sep)
> -{
> -     unsigned long lck_flags;
> -     int error = 0;
> -
> -     if (test_and_set_bit(SEP_SEND_MSG_LOCK_BIT, &sep->in_use_flags)) {
> -             error = -EPROTO;
> -             goto end_function;
> -     }
> -     sep_set_time(sep);
> -
> -     sep_set_current_caller_id(sep);
> -
> -     sep_dump_message(sep);
> -
> -     /* Update counter */
> -     spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> -     sep->send_ct++;
> -     spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> -
> -     dev_dbg(&sep->pdev->dev,
> -             "sep_send_command_handler send_ct %lx reply_ct %lx\n",
> -                                             sep->send_ct, sep->reply_ct);
> -
> -     /* Send interrupt to SEP */
> -     sep_write_reg(sep, HW_HOST_HOST_SEP_GPR0_REG_ADDR, 0x2);
> -
> -end_function:
> -     return error;
> -}
> -
> -/**
> - *   sep_allocate_data_pool_memory_handler -allocate pool memory
> - *   @sep: pointer to struct sep_device
> - *   @arg: pointer to struct alloc_struct
> - *
> - *   This function handles the allocate data pool memory request
> - *   This function returns calculates the bus address of the
> - *   allocated memory, and the offset of this area from the mapped address.
> - *   Therefore, the FVOs in user space can calculate the exact virtual
> - *   address of this allocated memory
> - */
> -static int sep_allocate_data_pool_memory_handler(struct sep_device *sep,
> -     unsigned long arg)
> -{
> -     int error = 0;
> -     struct alloc_struct command_args;
> -
> -     /* Holds the allocated buffer address in the system memory pool */
> -     u32 *token_addr;
> -
> -     if (copy_from_user(&command_args, (void __user *)arg,
> -                                     sizeof(struct alloc_struct))) {
> -             error = -EFAULT;
> -             goto end_function;
> -     }
> -
> -     /* Allocate memory */
> -     if ((sep->data_pool_bytes_allocated + command_args.num_bytes) >
> -             SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES) {
> -             error = -ENOMEM;
> -             goto end_function;
> -     }
> -
> -     dev_dbg(&sep->pdev->dev,
> -             "data pool bytes_allocated: %x\n", (int)sep->data_pool_bytes_allocated);
> -     dev_dbg(&sep->pdev->dev,
> -             "offset: %x\n", SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES);
> -     /* Set the virtual and bus address */
> -     command_args.offset = SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
> -             sep->data_pool_bytes_allocated;
> -
> -     /* Place in the shared area that is known by the SEP */
> -     token_addr = (u32 *)(sep->shared_addr +
> -             SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES +
> -             (sep->num_of_data_allocations)*2*sizeof(u32));
> -
> -     token_addr[0] = SEP_DATA_POOL_POINTERS_VAL_TOKEN;
> -     token_addr[1] = (u32)sep->shared_bus +
> -             SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES +
> -             sep->data_pool_bytes_allocated;
> -
> -     /* Write the memory back to the user space */
> -     error = copy_to_user((void *)arg, (void *)&command_args,
> -             sizeof(struct alloc_struct));
> -     if (error) {
> -             error = -EFAULT;
> -             goto end_function;
> -     }
> -
> -     /* Update the allocation */
> -     sep->data_pool_bytes_allocated += command_args.num_bytes;
> -     sep->num_of_data_allocations += 1;
> -
> -end_function:
> -     return error;
> -}
> -
> -/**
> - *   sep_lock_kernel_pages - map kernel pages for DMA
> - *   @sep: pointer to struct sep_device
> - *   @kernel_virt_addr: address of data buffer in kernel
> - *   @data_size: size of data
> - *   @lli_array_ptr: lli array
> - *   @in_out_flag: input into device or output from device
> - *
> - *   This function locks all the physical pages of the kernel virtual buffer
> - *   and construct a basic lli  array, where each entry holds the physical
> - *   page address and the size that application data holds in this page
> - *   This function is used only during kernel crypto mod calls from within
> - *   the kernel (when ioctl is not used)
> - */
> -static int sep_lock_kernel_pages(struct sep_device *sep,
> -     unsigned long kernel_virt_addr,
> -     u32 data_size,
> -     struct sep_lli_entry **lli_array_ptr,
> -     int in_out_flag)
> -
> -{
> -     int error = 0;
> -     /* Array of lli */
> -     struct sep_lli_entry *lli_array;
> -     /* Map array */
> -     struct sep_dma_map *map_array;
> -
> -     dev_dbg(&sep->pdev->dev, "lock kernel pages kernel_virt_addr is %08lx\n",
> -                             (unsigned long)kernel_virt_addr);
> -     dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
> -
> -     lli_array = kmalloc(sizeof(struct sep_lli_entry), GFP_ATOMIC);
> -     if (!lli_array) {
> -             error = -ENOMEM;
> -             goto end_function;
> -     }
> -     map_array = kmalloc(sizeof(struct sep_dma_map), GFP_ATOMIC);
> -     if (!map_array) {
> -             error = -ENOMEM;
> -             goto end_function_with_error;
> -     }
> -
> -     map_array[0].dma_addr =
> -             dma_map_single(&sep->pdev->dev, (void *)kernel_virt_addr,
> -             data_size, DMA_BIDIRECTIONAL);
> -     map_array[0].size = data_size;
> -
> -
> -     /*
> -      * Set the start address of the first page - app data may start not at
> -      * the beginning of the page
> -      */
> -     lli_array[0].bus_address = (u32)map_array[0].dma_addr;
> -     lli_array[0].block_size = map_array[0].size;
> -
> -     dev_dbg(&sep->pdev->dev,
> -     "lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
> -             (unsigned long)lli_array[0].bus_address,
> -             lli_array[0].block_size);
> -
> -     /* Set the output parameters */
> -     if (in_out_flag == SEP_DRIVER_IN_FLAG) {
> -             *lli_array_ptr = lli_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 1;
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries = 1;
> -     } else {
> -             *lli_array_ptr = lli_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = 1;
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_page_array = NULL;
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries = 1;
> -     }
> -     goto end_function;
> -
> -end_function_with_error:
> -     kfree(lli_array);
> -
> -end_function:
> -     return error;
> -}
> -
> -/**
> - *   sep_lock_user_pages - lock and map user pages for DMA
> - *   @sep: pointer to struct sep_device
> - *   @app_virt_addr: user memory data buffer
> - *   @data_size: size of data buffer
> - *   @lli_array_ptr: lli array
> - *   @in_out_flag: input or output to device
> - *
> - *   This function locks all the physical pages of the application
> - *   virtual buffer and construct a basic lli  array, where each entry
> - *   holds the physical page address and the size that application
> - *   data holds in this physical pages
> - */
> -static int sep_lock_user_pages(struct sep_device *sep,
> -     u32 app_virt_addr,
> -     u32 data_size,
> -     struct sep_lli_entry **lli_array_ptr,
> -     int in_out_flag)
> -
> -{
> -     int error = 0;
> -     u32 count;
> -     int result;
> -     /* The the page of the end address of the user space buffer */
> -     u32 end_page;
> -     /* The page of the start address of the user space buffer */
> -     u32 start_page;
> -     /* The range in pages */
> -     u32 num_pages;
> -     /* Array of pointers to page */
> -     struct page **page_array;
> -     /* Array of lli */
> -     struct sep_lli_entry *lli_array;
> -     /* Map array */
> -     struct sep_dma_map *map_array;
> -     /* Direction of the DMA mapping for locked pages */
> -     enum dma_data_direction dir;
> -
> -     /* Set start and end pages  and num pages */
> -     end_page = (app_virt_addr + data_size - 1) >> PAGE_SHIFT;
> -     start_page = app_virt_addr >> PAGE_SHIFT;
> -     num_pages = end_page - start_page + 1;
> -
> -     dev_dbg(&sep->pdev->dev, "lock user pages app_virt_addr is %x\n", app_virt_addr);
> -     dev_dbg(&sep->pdev->dev, "data_size is %x\n", data_size);
> -     dev_dbg(&sep->pdev->dev, "start_page is %x\n", start_page);
> -     dev_dbg(&sep->pdev->dev, "end_page is %x\n", end_page);
> -     dev_dbg(&sep->pdev->dev, "num_pages is %x\n", num_pages);
> -
> -     /* Allocate array of pages structure pointers */
> -     page_array = kmalloc(sizeof(struct page *) * num_pages, GFP_ATOMIC);
> -     if (!page_array) {
> -             error = -ENOMEM;
> -             goto end_function;
> -     }
> -     map_array = kmalloc(sizeof(struct sep_dma_map) * num_pages, GFP_ATOMIC);
> -     if (!map_array) {
> -             dev_warn(&sep->pdev->dev, "kmalloc for map_array failed\n");
> -             error = -ENOMEM;
> -             goto end_function_with_error1;
> -     }
> -
> -     lli_array = kmalloc(sizeof(struct sep_lli_entry) * num_pages,
> -             GFP_ATOMIC);
> -
> -     if (!lli_array) {
> -             dev_warn(&sep->pdev->dev, "kmalloc for lli_array failed\n");
> -             error = -ENOMEM;
> -             goto end_function_with_error2;
> -     }
> -
> -     /* Convert the application virtual address into a set of physical */
> -     down_read(&current->mm->mmap_sem);
> -     result = get_user_pages(current, current->mm, app_virt_addr,
> -             num_pages,
> -             ((in_out_flag == SEP_DRIVER_IN_FLAG) ? 0 : 1),
> -             0, page_array, NULL);
> -
> -     up_read(&current->mm->mmap_sem);
> -
> -     /* Check the number of pages locked - if not all then exit with error */
> -     if (result != num_pages) {
> -             dev_warn(&sep->pdev->dev,
> -                     "not all pages locked by get_user_pages\n");
> -             error = -ENOMEM;
> -             goto end_function_with_error3;
> -     }
> -
> -     dev_dbg(&sep->pdev->dev, "get_user_pages succeeded\n");
> -
> -     /* Set direction */
> -     if (in_out_flag == SEP_DRIVER_IN_FLAG)
> -             dir = DMA_TO_DEVICE;
> -     else
> -             dir = DMA_FROM_DEVICE;
> -
> -     /*
> -      * Fill the array using page array data and
> -      * map the pages - this action will also flush the cache as needed
> -      */
> -     for (count = 0; count < num_pages; count++) {
> -             /* Fill the map array */
> -             map_array[count].dma_addr =
> -                     dma_map_page(&sep->pdev->dev, page_array[count],
> -                     0, PAGE_SIZE, /*dir*/DMA_BIDIRECTIONAL);
> -
> -             map_array[count].size = PAGE_SIZE;
> -
> -             /* Fill the lli array entry */
> -             lli_array[count].bus_address = (u32)map_array[count].dma_addr;
> -             lli_array[count].block_size = PAGE_SIZE;
> -
> -             dev_warn(&sep->pdev->dev, "lli_array[%x].bus_address is %08lx,
> lli_array[%x].block_size is %x\n",
> -                     count, (unsigned long)lli_array[count].bus_address,
> -                     count, lli_array[count].block_size);
> -     }
> -
> -     /* Check the offset for the first page */
> -     lli_array[0].bus_address =
> -             lli_array[0].bus_address + (app_virt_addr & (~PAGE_MASK));
> -
> -     /* Check that not all the data is in the first page only */
> -     if ((PAGE_SIZE - (app_virt_addr & (~PAGE_MASK))) >= data_size)
> -             lli_array[0].block_size = data_size;
> -     else
> -             lli_array[0].block_size =
> -                     PAGE_SIZE - (app_virt_addr & (~PAGE_MASK));
> -
> -     dev_dbg(&sep->pdev->dev,
> -             "lli_array[0].bus_address is %08lx, lli_array[0].block_size is %x\n",
> -             (unsigned long)lli_array[count].bus_address,
> -             lli_array[count].block_size);
> -
> -     /* Check the size of the last page */
> -     if (num_pages > 1) {
> -             lli_array[num_pages - 1].block_size =
> -                     (app_virt_addr + data_size) & (~PAGE_MASK);
> -
> -             dev_warn(&sep->pdev->dev,
> -                     "lli_array[%x].bus_address is %08lx, lli_array[%x].block_size is %x\n",
> -                     num_pages - 1,
> -                     (unsigned long)lli_array[count].bus_address,
> -                     num_pages - 1,
> -                     lli_array[count].block_size);
> -     }
> -
> -     /* Set output params according to the in_out flag */
> -     if (in_out_flag == SEP_DRIVER_IN_FLAG) {
> -             *lli_array_ptr = lli_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = num_pages;
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = page_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_map_array = map_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_map_num_entries =
> -                                                             num_pages;
> -     } else {
> -             *lli_array_ptr = lli_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages = num_pages;
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_page_array =
> -                                                             page_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_map_array = map_array;
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_map_num_entries =
> -                                                             num_pages;
> -     }
> -     goto end_function;
> -
> -end_function_with_error3:
> -     /* Free lli array */
> -     kfree(lli_array);
> -
> -end_function_with_error2:
> -     kfree(map_array);
> -
> -end_function_with_error1:
> -     /* Free page array */
> -     kfree(page_array);
> -
> -end_function:
> -     return error;
> -}
> -
> -/**
> - *   u32 sep_calculate_lli_table_max_size - size the LLI table
> - *   @sep: pointer to struct sep_device
> - *   @lli_in_array_ptr
> - *   @num_array_entries
> - *   @last_table_flag
> - *
> - *   This function calculates the size of data that can be inserted into
> - *   the lli table from this array, such that either the table is full
> - *   (all entries are entered), or there are no more entries in the
> - *   lli array
> - */
> -static u32 sep_calculate_lli_table_max_size(struct sep_device *sep,
> -     struct sep_lli_entry *lli_in_array_ptr,
> -     u32 num_array_entries,
> -     u32 *last_table_flag)
> -{
> -     u32 counter;
> -     /* Table data size */
> -     u32 table_data_size = 0;
> -     /* Data size for the next table */
> -     u32 next_table_data_size;
> -
> -     *last_table_flag = 0;
> -
> -     /*
> -      * Calculate the data in the out lli table till we fill the whole
> -      * table or till the data has ended
> -      */
> -     for (counter = 0;
> -             (counter < (SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP - 1)) &&
> -                     (counter < num_array_entries); counter++)
> -             table_data_size += lli_in_array_ptr[counter].block_size;
> -
> -     /*
> -      * Check if we reached the last entry,
> -      * meaning this ia the last table to build,
> -      * and no need to check the block alignment
> -      */
> -     if (counter == num_array_entries) {
> -             /* Set the last table flag */
> -             *last_table_flag = 1;
> -             goto end_function;
> -     }
> -
> -     /*
> -      * Calculate the data size of the next table.
> -      * Stop if no entries left or if data size is more the DMA restriction
> -      */
> -     next_table_data_size = 0;
> -     for (; counter < num_array_entries; counter++) {
> -             next_table_data_size += lli_in_array_ptr[counter].block_size;
> -             if (next_table_data_size >= SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
> -                     break;
> -     }
> -
> -     /*
> -      * Check if the next table data size is less then DMA rstriction.
> -      * if it is - recalculate the current table size, so that the next
> -      * table data size will be adaquete for DMA
> -      */
> -     if (next_table_data_size &&
> -             next_table_data_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE)
> -
> -             table_data_size -= (SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE -
> -                     next_table_data_size);
> -
> -end_function:
> -     return table_data_size;
> -}
> -
> -/**
> - *   sep_build_lli_table - build an lli array for the given table
> - *   @sep: pointer to struct sep_device
> - *   @lli_array_ptr: pointer to lli array
> - *   @lli_table_ptr: pointer to lli table
> - *   @num_processed_entries_ptr: pointer to number of entries
> - *   @num_table_entries_ptr: pointer to number of tables
> - *   @table_data_size: total data size
> - *
> - *   Builds ant lli table from the lli_array according to
> - *   the given size of data
> - */
> -static void sep_build_lli_table(struct sep_device *sep,
> -     struct sep_lli_entry    *lli_array_ptr,
> -     struct sep_lli_entry    *lli_table_ptr,
> -     u32 *num_processed_entries_ptr,
> -     u32 *num_table_entries_ptr,
> -     u32 table_data_size)
> -{
> -     /* Current table data size */
> -     u32 curr_table_data_size;
> -     /* Counter of lli array entry */
> -     u32 array_counter;
> -
> -     /* Init currrent table data size and lli array entry counter */
> -     curr_table_data_size = 0;
> -     array_counter = 0;
> -     *num_table_entries_ptr = 1;
> -
> -     dev_dbg(&sep->pdev->dev, "build lli table table_data_size is %x\n", table_data_size);
> -
> -     /* Fill the table till table size reaches the needed amount */
> -     while (curr_table_data_size < table_data_size) {
> -             /* Update the number of entries in table */
> -             (*num_table_entries_ptr)++;
> -
> -             lli_table_ptr->bus_address =
> -                     cpu_to_le32(lli_array_ptr[array_counter].bus_address);
> -
> -             lli_table_ptr->block_size =
> -                     cpu_to_le32(lli_array_ptr[array_counter].block_size);
> -
> -             curr_table_data_size += lli_array_ptr[array_counter].block_size;
> -
> -             dev_dbg(&sep->pdev->dev, "lli_table_ptr is %p\n",
> -                                                             lli_table_ptr);
> -             dev_dbg(&sep->pdev->dev, "lli_table_ptr->bus_address is %08lx\n",
> -                             (unsigned long)lli_table_ptr->bus_address);
> -             dev_dbg(&sep->pdev->dev, "lli_table_ptr->block_size is %x\n",
> -                     lli_table_ptr->block_size);
> -
> -             /* Check for overflow of the table data */
> -             if (curr_table_data_size > table_data_size) {
> -                     dev_dbg(&sep->pdev->dev,
> -                             "curr_table_data_size too large\n");
> -
> -                     /* Update the size of block in the table */
> -                     lli_table_ptr->block_size -=
> -                     cpu_to_le32((curr_table_data_size - table_data_size));
> -
> -                     /* Update the physical address in the lli array */
> -                     lli_array_ptr[array_counter].bus_address +=
> -                     cpu_to_le32(lli_table_ptr->block_size);
> -
> -                     /* Update the block size left in the lli array */
> -                     lli_array_ptr[array_counter].block_size =
> -                             (curr_table_data_size - table_data_size);
> -             } else
> -                     /* Advance to the next entry in the lli_array */
> -                     array_counter++;
> -
> -             dev_dbg(&sep->pdev->dev,
> -                     "lli_table_ptr->bus_address is %08lx\n",
> -                             (unsigned long)lli_table_ptr->bus_address);
> -             dev_dbg(&sep->pdev->dev,
> -                     "lli_table_ptr->block_size is %x\n",
> -                     lli_table_ptr->block_size);
> -
> -             /* Move to the next entry in table */
> -             lli_table_ptr++;
> -     }
> -
> -     /* Set the info entry to default */
> -     lli_table_ptr->bus_address = 0xffffffff;
> -     lli_table_ptr->block_size = 0;
> -
> -     /* Set the output parameter */
> -     *num_processed_entries_ptr += array_counter;
> -
> -}
> -
> -/**
> - *   sep_shared_area_virt_to_bus - map shared area to bus address
> - *   @sep: pointer to struct sep_device
> - *   @virt_address: virtual address to convert
> - *
> - *   This functions returns the physical address inside shared area according
> - *   to the virtual address. It can be either on the externa RAM device
> - *   (ioremapped), or on the system RAM
> - *   This implementation is for the external RAM
> - */
> -static dma_addr_t sep_shared_area_virt_to_bus(struct sep_device *sep,
> -     void *virt_address)
> -{
> -     dev_dbg(&sep->pdev->dev, "sh virt to phys v %p\n", virt_address);
> -     dev_dbg(&sep->pdev->dev, "sh virt to phys p %08lx\n",
> -             (unsigned long)
> -             sep->shared_bus + (virt_address - sep->shared_addr));
> -
> -     return sep->shared_bus + (size_t)(virt_address - sep->shared_addr);
> -}
> -
> -/**
> - *   sep_shared_area_bus_to_virt - map shared area bus address to kernel
> - *   @sep: pointer to struct sep_device
> - *   @bus_address: bus address to convert
> - *
> - *   This functions returns the virtual address inside shared area
> - *   according to the physical address. It can be either on the
> - *   externa RAM device (ioremapped), or on the system RAM
> - *   This implementation is for the external RAM
> - */
> -static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
> -     dma_addr_t bus_address)
> -{
> -     dev_dbg(&sep->pdev->dev, "shared bus to virt b=%lx v=%lx\n",
> -             (unsigned long)bus_address, (unsigned long)(sep->shared_addr +
> -                     (size_t)(bus_address - sep->shared_bus)));
> -
> -     return sep->shared_addr + (size_t)(bus_address - sep->shared_bus);
> -}
> -
> -/**
> - *   sep_debug_print_lli_tables - dump LLI table
> - *   @sep: pointer to struct sep_device
> - *   @lli_table_ptr: pointer to sep_lli_entry
> - *   @num_table_entries: number of entries
> - *   @table_data_size: total data size
> - *
> - *   Walk the the list of the print created tables and print all the data
> - */
> -static void sep_debug_print_lli_tables(struct sep_device *sep,
> -     struct sep_lli_entry *lli_table_ptr,
> -     unsigned long num_table_entries,
> -     unsigned long table_data_size)
> -{
> -     unsigned long table_count = 1;
> -     unsigned long entries_count = 0;
> -
> -     dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables start\n");
> -
> -     while ((unsigned long) lli_table_ptr->bus_address != 0xffffffff) {
> -             dev_dbg(&sep->pdev->dev,
> -                     "lli table %08lx, table_data_size is %lu\n",
> -                     table_count, table_data_size);
> -             dev_dbg(&sep->pdev->dev, "num_table_entries is %lu\n",
> -                                                     num_table_entries);
> -
> -             /* Print entries of the table (without info entry) */
> -             for (entries_count = 0; entries_count < num_table_entries;
> -                     entries_count++, lli_table_ptr++) {
> -
> -                     dev_dbg(&sep->pdev->dev,
> -                             "lli_table_ptr address is %08lx\n",
> -                             (unsigned long) lli_table_ptr);
> -
> -                     dev_dbg(&sep->pdev->dev,
> -                             "phys address is %08lx block size is %x\n",
> -                             (unsigned long)lli_table_ptr->bus_address,
> -                             lli_table_ptr->block_size);
> -             }
> -             /* Point to the info entry */
> -             lli_table_ptr--;
> -
> -             dev_dbg(&sep->pdev->dev,
> -                     "phys lli_table_ptr->block_size is %x\n",
> -                     lli_table_ptr->block_size);
> -
> -             dev_dbg(&sep->pdev->dev,
> -                     "phys lli_table_ptr->physical_address is %08lu\n",
> -                     (unsigned long)lli_table_ptr->bus_address);
> -
> -
> -             table_data_size = lli_table_ptr->block_size & 0xffffff;
> -             num_table_entries = (lli_table_ptr->block_size >> 24) & 0xff;
> -
> -             dev_dbg(&sep->pdev->dev,
> -                     "phys table_data_size is %lu num_table_entries is"
> -                     " %lu bus_address is%lu\n", table_data_size,
> -                     num_table_entries, (unsigned long)lli_table_ptr->bus_address);
> -
> -             if ((unsigned long)lli_table_ptr->bus_address != 0xffffffff)
> -                     lli_table_ptr = (struct sep_lli_entry *)
> -                             sep_shared_bus_to_virt(sep,
> -                             (unsigned long)lli_table_ptr->bus_address);
> -
> -             table_count++;
> -     }
> -     dev_dbg(&sep->pdev->dev, "sep_debug_print_lli_tables end\n");
> -}
> -
> -
> -/**
> - *   sep_prepare_empty_lli_table - create a blank LLI table
> - *   @sep: pointer to struct sep_device
> - *   @lli_table_addr_ptr: pointer to lli table
> - *   @num_entries_ptr: pointer to number of entries
> - *   @table_data_size_ptr: point to table data size
> - *
> - *   This function creates empty lli tables when there is no data
> - */
> -static void sep_prepare_empty_lli_table(struct sep_device *sep,
> -             dma_addr_t *lli_table_addr_ptr,
> -             u32 *num_entries_ptr,
> -             u32 *table_data_size_ptr)
> -{
> -     struct sep_lli_entry *lli_table_ptr;
> -
> -     /* Find the area for new table */
> -     lli_table_ptr =
> -             (struct sep_lli_entry *)(sep->shared_addr +
> -             SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> -             sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
> -                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
> -
> -     lli_table_ptr->bus_address = 0;
> -     lli_table_ptr->block_size = 0;
> -
> -     lli_table_ptr++;
> -     lli_table_ptr->bus_address = 0xFFFFFFFF;
> -     lli_table_ptr->block_size = 0;
> -
> -     /* Set the output parameter value */
> -     *lli_table_addr_ptr = sep->shared_bus +
> -             SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> -             sep->num_lli_tables_created *
> -             sizeof(struct sep_lli_entry) *
> -             SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
> -
> -     /* Set the num of entries and table data size for empty table */
> -     *num_entries_ptr = 2;
> -     *table_data_size_ptr = 0;
> -
> -     /* Update the number of created tables */
> -     sep->num_lli_tables_created++;
> -}
> -
> -/**
> - *   sep_prepare_input_dma_table - prepare input DMA mappings
> - *   @sep: pointer to struct sep_device
> - *   @data_size:
> - *   @block_size:
> - *   @lli_table_ptr:
> - *   @num_entries_ptr:
> - *   @table_data_size_ptr:
> - *   @is_kva: set for kernel data (kernel cryptio call)
> - *
> - *   This function prepares only input DMA table for synhronic symmetric
> - *   operations (HASH)
> - *   Note that all bus addresses that are passed to the SEP
> - *   are in 32 bit format; the SEP is a 32 bit device
> - */
> -static int sep_prepare_input_dma_table(struct sep_device *sep,
> -     unsigned long app_virt_addr,
> -     u32 data_size,
> -     u32 block_size,
> -     dma_addr_t *lli_table_ptr,
> -     u32 *num_entries_ptr,
> -     u32 *table_data_size_ptr,
> -     bool is_kva)
> -{
> -     int error = 0;
> -     /* Pointer to the info entry of the table - the last entry */
> -     struct sep_lli_entry *info_entry_ptr;
> -     /* Array of pointers to page */
> -     struct sep_lli_entry *lli_array_ptr;
> -     /* Points to the first entry to be processed in the lli_in_array */
> -     u32 current_entry = 0;
> -     /* Num entries in the virtual buffer */
> -     u32 sep_lli_entries = 0;
> -     /* Lli table pointer */
> -     struct sep_lli_entry *in_lli_table_ptr;
> -     /* The total data in one table */
> -     u32 table_data_size = 0;
> -     /* Flag for last table */
> -     u32 last_table_flag = 0;
> -     /* Number of entries in lli table */
> -     u32 num_entries_in_table = 0;
> -     /* Next table address */
> -     void *lli_table_alloc_addr = 0;
> -
> -     dev_dbg(&sep->pdev->dev, "prepare intput dma table data_size is %x\n", data_size);
> -     dev_dbg(&sep->pdev->dev, "block_size is %x\n", block_size);
> -
> -     /* Initialize the pages pointers */
> -     sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
> -     sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages = 0;
> -
> -     /* Set the kernel address for first table to be allocated */
> -     lli_table_alloc_addr = (void *)(sep->shared_addr +
> -             SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> -             sep->num_lli_tables_created * sizeof(struct sep_lli_entry) *
> -             SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
> -
> -     if (data_size == 0) {
> -             /* Special case  - create meptu table - 2 entries, zero data */
> -             sep_prepare_empty_lli_table(sep, lli_table_ptr,
> -                             num_entries_ptr, table_data_size_ptr);
> -             goto update_dcb_counter;
> -     }
> -
> -     /* Check if the pages are in Kernel Virtual Address layout */
> -     if (is_kva == true)
> -             /* Lock the pages in the kernel */
> -             error = sep_lock_kernel_pages(sep, app_virt_addr,
> -                     data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
> -     else
> -             /*
> -              * Lock the pages of the user buffer
> -              * and translate them to pages
> -              */
> -             error = sep_lock_user_pages(sep, app_virt_addr,
> -                     data_size, &lli_array_ptr, SEP_DRIVER_IN_FLAG);
> -
> -     if (error)
> -             goto end_function;
> -
> -     dev_dbg(&sep->pdev->dev, "output sep_in_num_pages is %x\n",
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
> -
> -     current_entry = 0;
> -     info_entry_ptr = NULL;
> -
> -     sep_lli_entries = sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages;
> -
> -     /* Loop till all the entries in in array are not processed */
> -     while (current_entry < sep_lli_entries) {
> -
> -             /* Set the new input and output tables */
> -             in_lli_table_ptr =
> -                     (struct sep_lli_entry *)lli_table_alloc_addr;
> -
> -             lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
> -                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
> -
> -             if (lli_table_alloc_addr >
> -                     ((void *)sep->shared_addr +
> -                     SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> -                     SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
> -
> -                     error = -ENOMEM;
> -                     goto end_function_error;
> -
> -             }
> -
> -             /* Update the number of created tables */
> -             sep->num_lli_tables_created++;
> -
> -             /* Calculate the maximum size of data for input table */
> -             table_data_size = sep_calculate_lli_table_max_size(sep,
> -                     &lli_array_ptr[current_entry],
> -                     (sep_lli_entries - current_entry),
> -                     &last_table_flag);
> -
> -             /*
> -              * If this is not the last table -
> -              * then align it to the block size
> -              */
> -             if (!last_table_flag)
> -                     table_data_size =
> -                             (table_data_size / block_size) * block_size;
> -
> -             dev_dbg(&sep->pdev->dev, "output table_data_size is %x\n",
> -                                                     table_data_size);
> -
> -             /* Construct input lli table */
> -             sep_build_lli_table(sep, &lli_array_ptr[current_entry],
> -                     in_lli_table_ptr,
> -                     &current_entry, &num_entries_in_table, table_data_size);
> -
> -             if (info_entry_ptr == NULL) {
> -
> -                     /* Set the output parameters to physical addresses */
> -                     *lli_table_ptr = sep_shared_area_virt_to_bus(sep,
> -                             in_lli_table_ptr);
> -                     *num_entries_ptr = num_entries_in_table;
> -                     *table_data_size_ptr = table_data_size;
> -
> -                     dev_dbg(&sep->pdev->dev,
> -                             "output lli_table_in_ptr is %08lx\n",
> -                             (unsigned long)*lli_table_ptr);
> -
> -             } else {
> -                     /* Update the info entry of the previous in table */
> -                     info_entry_ptr->bus_address =
> -                             sep_shared_area_virt_to_bus(sep,
> -                                                     in_lli_table_ptr);
> -                     info_entry_ptr->block_size =
> -                             ((num_entries_in_table) << 24) |
> -                             (table_data_size);
> -             }
> -             /* Save the pointer to the info entry of the current tables */
> -             info_entry_ptr = in_lli_table_ptr + num_entries_in_table - 1;
> -     }
> -     /* Print input tables */
> -     sep_debug_print_lli_tables(sep, (struct sep_lli_entry *)
> -             sep_shared_area_bus_to_virt(sep, *lli_table_ptr),
> -             *num_entries_ptr, *table_data_size_ptr);
> -     /* The array of the pages */
> -     kfree(lli_array_ptr);
> -
> -update_dcb_counter:
> -     /* Update DCB counter */
> -     sep->nr_dcb_creat++;
> -     goto end_function;
> -
> -end_function_error:
> -     /* Free all the allocated resources */
> -     kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
> -     kfree(lli_array_ptr);
> -     kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
> -
> -end_function:
> -     return error;
> -
> -}
> -/**
> - *   sep_construct_dma_tables_from_lli - prepare AES/DES mappings
> - *   @sep: pointer to struct sep_device
> - *   @lli_in_array:
> - *   @sep_in_lli_entries:
> - *   @lli_out_array:
> - *   @sep_out_lli_entries
> - *   @block_size
> - *   @lli_table_in_ptr
> - *   @lli_table_out_ptr
> - *   @in_num_entries_ptr
> - *   @out_num_entries_ptr
> - *   @table_data_size_ptr
> - *
> - *   This function creates the input and output DMA tables for
> - *   symmetric operations (AES/DES) according to the block
> - *   size from LLI arays
> - *   Note that all bus addresses that are passed to the SEP
> - *   are in 32 bit format; the SEP is a 32 bit device
> - */
> -static int sep_construct_dma_tables_from_lli(
> -     struct sep_device *sep,
> -     struct sep_lli_entry *lli_in_array,
> -     u32     sep_in_lli_entries,
> -     struct sep_lli_entry *lli_out_array,
> -     u32     sep_out_lli_entries,
> -     u32     block_size,
> -     dma_addr_t *lli_table_in_ptr,
> -     dma_addr_t *lli_table_out_ptr,
> -     u32     *in_num_entries_ptr,
> -     u32     *out_num_entries_ptr,
> -     u32     *table_data_size_ptr)
> -{
> -     /* Points to the area where next lli table can be allocated */
> -     void *lli_table_alloc_addr = 0;
> -     /* Input lli table */
> -     struct sep_lli_entry *in_lli_table_ptr = NULL;
> -     /* Output lli table */
> -     struct sep_lli_entry *out_lli_table_ptr = NULL;
> -     /* Pointer to the info entry of the table - the last entry */
> -     struct sep_lli_entry *info_in_entry_ptr = NULL;
> -     /* Pointer to the info entry of the table - the last entry */
> -     struct sep_lli_entry *info_out_entry_ptr = NULL;
> -     /* Points to the first entry to be processed in the lli_in_array */
> -     u32 current_in_entry = 0;
> -     /* Points to the first entry to be processed in the lli_out_array */
> -     u32 current_out_entry = 0;
> -     /* Max size of the input table */
> -     u32 in_table_data_size = 0;
> -     /* Max size of the output table */
> -     u32 out_table_data_size = 0;
> -     /* Flag te signifies if this is the last tables build */
> -     u32 last_table_flag = 0;
> -     /* The data size that should be in table */
> -     u32 table_data_size = 0;
> -     /* Number of etnries in the input table */
> -     u32 num_entries_in_table = 0;
> -     /* Number of etnries in the output table */
> -     u32 num_entries_out_table = 0;
> -
> -     /* Initiate to point after the message area */
> -     lli_table_alloc_addr = (void *)(sep->shared_addr +
> -             SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> -             (sep->num_lli_tables_created *
> -             (sizeof(struct sep_lli_entry) *
> -             SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP)));
> -
> -     /* Loop till all the entries in in array are not processed */
> -     while (current_in_entry < sep_in_lli_entries) {
> -             /* Set the new input and output tables */
> -             in_lli_table_ptr =
> -                     (struct sep_lli_entry *)lli_table_alloc_addr;
> -
> -             lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
> -                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
> -
> -             /* Set the first output tables */
> -             out_lli_table_ptr =
> -                     (struct sep_lli_entry *)lli_table_alloc_addr;
> -
> -             /* Check if the DMA table area limit was overrun */
> -             if ((lli_table_alloc_addr + sizeof(struct sep_lli_entry) *
> -                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP) >
> -                     ((void *)sep->shared_addr +
> -                     SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES +
> -                     SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)) {
> -
> -                     dev_warn(&sep->pdev->dev, "dma table limit overrun\n");
> -                     return -ENOMEM;
> -             }
> -
> -             /* Update the number of the lli tables created */
> -             sep->num_lli_tables_created += 2;
> -
> -             lli_table_alloc_addr += sizeof(struct sep_lli_entry) *
> -                     SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP;
> -
> -             /* Calculate the maximum size of data for input table */
> -             in_table_data_size =
> -                     sep_calculate_lli_table_max_size(sep,
> -                     &lli_in_array[current_in_entry],
> -                     (sep_in_lli_entries - current_in_entry),
> -                     &last_table_flag);
> -
> -             /* Calculate the maximum size of data for output table */
> -             out_table_data_size =
> -                     sep_calculate_lli_table_max_size(sep,
> -                     &lli_out_array[current_out_entry],
> -                     (sep_out_lli_entries - current_out_entry),
> -                     &last_table_flag);
> -
> -             dev_dbg(&sep->pdev->dev,
> -                     "construct tables from lli in_table_data_size is %x\n",
> -                     in_table_data_size);
> -
> -             dev_dbg(&sep->pdev->dev,
> -                     "construct tables from lli out_table_data_size is %x\n",
> -                     out_table_data_size);
> -
> -             table_data_size = in_table_data_size;
> -
> -             if (!last_table_flag) {
> -                     /*
> -                      * If this is not the last table,
> -                      * then must check where the data is smallest
> -                      * and then align it to the block size
> -                      */
> -                     if (table_data_size > out_table_data_size)
> -                             table_data_size = out_table_data_size;
> -
> -                     /*
> -                      * Now calculate the table size so that
> -                      * it will be module block size
> -                      */
> -                     table_data_size = (table_data_size / block_size) *
> -                             block_size;
> -             }
> -
> -             /* Construct input lli table */
> -             sep_build_lli_table(sep, &lli_in_array[current_in_entry],
> -                     in_lli_table_ptr,
> -                     &current_in_entry,
> -                     &num_entries_in_table,
> -                     table_data_size);
> -
> -             /* Construct output lli table */
> -             sep_build_lli_table(sep, &lli_out_array[current_out_entry],
> -                     out_lli_table_ptr,
> -                     &current_out_entry,
> -                     &num_entries_out_table,
> -                     table_data_size);
> -
> -             /* If info entry is null - this is the first table built */
> -             if (info_in_entry_ptr == NULL) {
> -                     /* Set the output parameters to physical addresses */
> -                     *lli_table_in_ptr =
> -                     sep_shared_area_virt_to_bus(sep, in_lli_table_ptr);
> -
> -                     *in_num_entries_ptr = num_entries_in_table;
> -
> -                     *lli_table_out_ptr =
> -                             sep_shared_area_virt_to_bus(sep,
> -                             out_lli_table_ptr);
> -
> -                     *out_num_entries_ptr = num_entries_out_table;
> -                     *table_data_size_ptr = table_data_size;
> -
> -                     dev_dbg(&sep->pdev->dev,
> -                     "output lli_table_in_ptr is %08lx\n",
> -                             (unsigned long)*lli_table_in_ptr);
> -                     dev_dbg(&sep->pdev->dev,
> -                     "output lli_table_out_ptr is %08lx\n",
> -                             (unsigned long)*lli_table_out_ptr);
> -             } else {
> -                     /* Update the info entry of the previous in table */
> -                     info_in_entry_ptr->bus_address =
> -                             sep_shared_area_virt_to_bus(sep,
> -                             in_lli_table_ptr);
> -
> -                     info_in_entry_ptr->block_size =
> -                             ((num_entries_in_table) << 24) |
> -                             (table_data_size);
> -
> -                     /* Update the info entry of the previous in table */
> -                     info_out_entry_ptr->bus_address =
> -                             sep_shared_area_virt_to_bus(sep,
> -                             out_lli_table_ptr);
> -
> -                     info_out_entry_ptr->block_size =
> -                             ((num_entries_out_table) << 24) |
> -                             (table_data_size);
> -
> -                     dev_dbg(&sep->pdev->dev,
> -                             "output lli_table_in_ptr:%08lx %08x\n",
> -                             (unsigned long)info_in_entry_ptr->bus_address,
> -                             info_in_entry_ptr->block_size);
> -
> -                     dev_dbg(&sep->pdev->dev,
> -                             "output lli_table_out_ptr:%08lx  %08x\n",
> -                             (unsigned long)info_out_entry_ptr->bus_address,
> -                             info_out_entry_ptr->block_size);
> -             }
> -
> -             /* Save the pointer to the info entry of the current tables */
> -             info_in_entry_ptr = in_lli_table_ptr +
> -                     num_entries_in_table - 1;
> -             info_out_entry_ptr = out_lli_table_ptr +
> -                     num_entries_out_table - 1;
> -
> -             dev_dbg(&sep->pdev->dev,
> -                     "output num_entries_out_table is %x\n",
> -                     (u32)num_entries_out_table);
> -             dev_dbg(&sep->pdev->dev,
> -                     "output info_in_entry_ptr is %lx\n",
> -                     (unsigned long)info_in_entry_ptr);
> -             dev_dbg(&sep->pdev->dev,
> -                     "output info_out_entry_ptr is %lx\n",
> -                     (unsigned long)info_out_entry_ptr);
> -     }
> -
> -     /* Print input tables */
> -     sep_debug_print_lli_tables(sep,
> -     (struct sep_lli_entry *)
> -     sep_shared_area_bus_to_virt(sep, *lli_table_in_ptr),
> -     *in_num_entries_ptr,
> -     *table_data_size_ptr);
> -
> -     /* Print output tables */
> -     sep_debug_print_lli_tables(sep,
> -     (struct sep_lli_entry *)
> -     sep_shared_area_bus_to_virt(sep, *lli_table_out_ptr),
> -     *out_num_entries_ptr,
> -     *table_data_size_ptr);
> -
> -     return 0;
> -}
> -
> -/**
> - *   sep_prepare_input_output_dma_table - prepare DMA I/O table
> - *   @app_virt_in_addr:
> - *   @app_virt_out_addr:
> - *   @data_size:
> - *   @block_size:
> - *   @lli_table_in_ptr:
> - *   @lli_table_out_ptr:
> - *   @in_num_entries_ptr:
> - *   @out_num_entries_ptr:
> - *   @table_data_size_ptr:
> - *   @is_kva: set for kernel data; used only for kernel crypto module
> - *
> - *   This function builds input and output DMA tables for synhronic
> - *   symmetric operations (AES, DES, HASH). It also checks that each table
> - *   is of the modular block size
> - *   Note that all bus addresses that are passed to the SEP
> - *   are in 32 bit format; the SEP is a 32 bit device
> - */
> -static int sep_prepare_input_output_dma_table(struct sep_device *sep,
> -     unsigned long app_virt_in_addr,
> -     unsigned long app_virt_out_addr,
> -     u32 data_size,
> -     u32 block_size,
> -     dma_addr_t *lli_table_in_ptr,
> -     dma_addr_t *lli_table_out_ptr,
> -     u32 *in_num_entries_ptr,
> -     u32 *out_num_entries_ptr,
> -     u32 *table_data_size_ptr,
> -     bool is_kva)
> -
> -{
> -     int error = 0;
> -     /* Array of pointers of page */
> -     struct sep_lli_entry *lli_in_array;
> -     /* Array of pointers of page */
> -     struct sep_lli_entry *lli_out_array;
> -
> -     if (data_size == 0) {
> -             /* Prepare empty table for input and output */
> -             sep_prepare_empty_lli_table(sep, lli_table_in_ptr,
> -                     in_num_entries_ptr, table_data_size_ptr);
> -
> -             sep_prepare_empty_lli_table(sep, lli_table_out_ptr,
> -                     out_num_entries_ptr, table_data_size_ptr);
> -
> -             goto update_dcb_counter;
> -     }
> -
> -     /* Initialize the pages pointers */
> -     sep->dma_res_arr[sep->nr_dcb_creat].in_page_array = NULL;
> -     sep->dma_res_arr[sep->nr_dcb_creat].out_page_array = NULL;
> -
> -     /* Lock the pages of the buffer and translate them to pages */
> -     if (is_kva == true) {
> -             error = sep_lock_kernel_pages(sep, app_virt_in_addr,
> -                     data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
> -
> -             if (error) {
> -                     dev_warn(&sep->pdev->dev,
> -                             "lock kernel for in failed\n");
> -                     goto end_function;
> -             }
> -
> -             error = sep_lock_kernel_pages(sep, app_virt_out_addr,
> -                     data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
> -
> -             if (error) {
> -                     dev_warn(&sep->pdev->dev,
> -                             "lock kernel for out failed\n");
> -                     goto end_function;
> -             }
> -     }
> -
> -     else {
> -             error = sep_lock_user_pages(sep, app_virt_in_addr,
> -                             data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
> -             if (error) {
> -                     dev_warn(&sep->pdev->dev,
> -                             "sep_lock_user_pages for input virtual buffer failed\n");
> -                     goto end_function;
> -             }
> -
> -             error = sep_lock_user_pages(sep, app_virt_out_addr,
> -                     data_size, &lli_out_array, SEP_DRIVER_OUT_FLAG);
> -
> -             if (error) {
> -                     dev_warn(&sep->pdev->dev,
> -                             "sep_lock_user_pages for output virtual buffer failed\n");
> -                     goto end_function_free_lli_in;
> -             }
> -     }
> -
> -     dev_dbg(&sep->pdev->dev, "prep input output dma table sep_in_num_pages is %x\n",
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages);
> -     dev_dbg(&sep->pdev->dev, "sep_out_num_pages is %x\n",
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages);
> -     dev_dbg(&sep->pdev->dev, "SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP is %x\n",
> -             SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP);
> -
> -     /* Call the function that creates table from the lli arrays */
> -     error = sep_construct_dma_tables_from_lli(sep, lli_in_array,
> -             sep->dma_res_arr[sep->nr_dcb_creat].in_num_pages,
> -             lli_out_array,
> -             sep->dma_res_arr[sep->nr_dcb_creat].out_num_pages,
> -             block_size, lli_table_in_ptr, lli_table_out_ptr,
> -             in_num_entries_ptr, out_num_entries_ptr, table_data_size_ptr);
> -
> -     if (error) {
> -             dev_warn(&sep->pdev->dev,
> -                     "sep_construct_dma_tables_from_lli failed\n");
> -             goto end_function_with_error;
> -     }
> -
> -     kfree(lli_out_array);
> -     kfree(lli_in_array);
> -
> -update_dcb_counter:
> -     /* Update DCB counter */
> -     sep->nr_dcb_creat++;
> -
> -     goto end_function;
> -
> -end_function_with_error:
> -     kfree(sep->dma_res_arr[sep->nr_dcb_creat].out_map_array);
> -     kfree(sep->dma_res_arr[sep->nr_dcb_creat].out_page_array);
> -     kfree(lli_out_array);
> -
> -
> -end_function_free_lli_in:
> -     kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_map_array);
> -     kfree(sep->dma_res_arr[sep->nr_dcb_creat].in_page_array);
> -     kfree(lli_in_array);
> -
> -end_function:
> -
> -     return error;
> -
> -}
> -
> -/**
> - *   sep_prepare_input_output_dma_table_in_dcb - prepare control blocks
> - *   @app_in_address: unsigned long; for data buffer in (user space)
> - *   @app_out_address: unsigned long; for data buffer out (user space)
> - *   @data_in_size: u32; for size of data
> - *   @block_size: u32; for block size
> - *   @tail_block_size: u32; for size of tail block
> - *   @isapplet: bool; to indicate external app
> - *   @is_kva: bool; kernel buffer; only used for kernel crypto module
> - *
> - *   This function prepares the linked DMA tables and puts the
> - *   address for the linked list of tables inta a DCB (data control
> - *   block) the address of which is known by the SEP hardware
> - *   Note that all bus addresses that are passed to the SEP
> - *   are in 32 bit format; the SEP is a 32 bit device
> - */
> -static int sep_prepare_input_output_dma_table_in_dcb(struct sep_device *sep,
> -     unsigned long  app_in_address,
> -     unsigned long  app_out_address,
> -     u32  data_in_size,
> -     u32  block_size,
> -     u32  tail_block_size,
> -     bool isapplet,
> -     bool    is_kva)
> -{
> -     int error = 0;
> -     /* Size of tail */
> -     u32 tail_size = 0;
> -     /* Address of the created DCB table */
> -     struct sep_dcblock *dcb_table_ptr = NULL;
> -     /* The physical address of the first input DMA table */
> -     dma_addr_t in_first_mlli_address = 0;
> -     /* Number of entries in the first input DMA table */
> -     u32  in_first_num_entries = 0;
> -     /* The physical address of the first output DMA table */
> -     dma_addr_t  out_first_mlli_address = 0;
> -     /* Number of entries in the first output DMA table */
> -     u32  out_first_num_entries = 0;
> -     /* Data in the first input/output table */
> -     u32  first_data_size = 0;
> -
> -     if (sep->nr_dcb_creat == SEP_MAX_NUM_SYNC_DMA_OPS) {
> -             /* No more DCBs to allocate */
> -             dev_warn(&sep->pdev->dev, "no more DCBs available\n");
> -             error = -ENOSPC;
> -             goto end_function;
> -     }
> -
> -     /* Allocate new DCB */
> -     dcb_table_ptr = (struct sep_dcblock *)(sep->shared_addr +
> -             SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES +
> -             (sep->nr_dcb_creat * sizeof(struct sep_dcblock)));
> -
> -     /* Set the default values in the DCB */
> -     dcb_table_ptr->input_mlli_address = 0;
> -     dcb_table_ptr->input_mlli_num_entries = 0;
> -     dcb_table_ptr->input_mlli_data_size = 0;
> -     dcb_table_ptr->output_mlli_address = 0;
> -     dcb_table_ptr->output_mlli_num_entries = 0;
> -     dcb_table_ptr->output_mlli_data_size = 0;
> -     dcb_table_ptr->tail_data_size = 0;
> -     dcb_table_ptr->out_vr_tail_pt = 0;
> -
> -     if (isapplet == true) {
> -
> -             /* Check if there is enough data for DMA operation */
> -             if (data_in_size < SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE) {
> -                     if (is_kva == true) {
> -                             memcpy(dcb_table_ptr->tail_data,
> -                                     (void *)app_in_address, data_in_size);
> -                     } else {
> -                             if (copy_from_user(dcb_table_ptr->tail_data,
> -                                     (void __user *)app_in_address,
> -                                     data_in_size)) {
> -                                     error = -EFAULT;
> -                                     goto end_function;
> -                             }
> -                     }
> -
> -                     dcb_table_ptr->tail_data_size = data_in_size;
> -
> -                     /* Set the output user-space address for mem2mem op */
> -                     if (app_out_address)
> -                             dcb_table_ptr->out_vr_tail_pt =
> -                                                     (aligned_u64)app_out_address;
> -
> -                     /*
> -                      * Update both data length parameters in order to avoid
> -                      * second data copy and allow building of empty mlli
> -                      * tables
> -                      */
> -                     tail_size = 0x0;
> -                     data_in_size = 0x0;
> -
> -             } else {
> -                     if (!app_out_address) {
> -                             tail_size = data_in_size % block_size;
> -                             if (!tail_size) {
> -                                     if (tail_block_size == block_size)
> -                                             tail_size = block_size;
> -                             }
> -                     } else {
> -                             tail_size = 0;
> -                     }
> -             }
> -             if (tail_size) {
> -                     if (is_kva == true) {
> -                             memcpy(dcb_table_ptr->tail_data,
> -                                     (void *)(app_in_address + data_in_size -
> -                                     tail_size), tail_size);
> -                     } else {
> -                             /* We have tail data - copy it to DCB */
> -                             if (copy_from_user(dcb_table_ptr->tail_data,
> -                                     (void *)(app_in_address +
> -                                     data_in_size - tail_size), tail_size)) {
> -                                     error = -EFAULT;
> -                                     goto end_function;
> -                             }
> -                     }
> -                     if (app_out_address)
> -                             /*
> -                              * Calculate the output address
> -                              * according to tail data size
> -                              */
> -                             dcb_table_ptr->out_vr_tail_pt =
> -                                     (aligned_u64)app_out_address + data_in_size
> -                                     - tail_size;
> -
> -                     /* Save the real tail data size */
> -                     dcb_table_ptr->tail_data_size = tail_size;
> -                     /*
> -                      * Update the data size without the tail
> -                      * data size AKA data for the dma
> -                      */
> -                     data_in_size = (data_in_size - tail_size);
> -             }
> -     }
> -     /* Check if we need to build only input table or input/output */
> -     if (app_out_address) {
> -             /* Prepare input/output tables */
> -             error = sep_prepare_input_output_dma_table(sep,
> -                     app_in_address,
> -                     app_out_address,
> -                     data_in_size,
> -                     block_size,
> -                     &in_first_mlli_address,
> -                     &out_first_mlli_address,
> -                     &in_first_num_entries,
> -                     &out_first_num_entries,
> -                     &first_data_size,
> -                     is_kva);
> -     } else {
> -             /* Prepare input tables */
> -             error = sep_prepare_input_dma_table(sep,
> -                     app_in_address,
> -                     data_in_size,
> -                     block_size,
> -                     &in_first_mlli_address,
> -                     &in_first_num_entries,
> -                     &first_data_size,
> -                     is_kva);
> -     }
> -
> -     if (error) {
> -             dev_warn(&sep->pdev->dev, "prepare DMA table call failed from prepare DCB call\n");
> -             goto end_function;
> -     }
> -
> -     /* Set the DCB values */
> -     dcb_table_ptr->input_mlli_address = in_first_mlli_address;
> -     dcb_table_ptr->input_mlli_num_entries = in_first_num_entries;
> -     dcb_table_ptr->input_mlli_data_size = first_data_size;
> -     dcb_table_ptr->output_mlli_address = out_first_mlli_address;
> -     dcb_table_ptr->output_mlli_num_entries = out_first_num_entries;
> -     dcb_table_ptr->output_mlli_data_size = first_data_size;
> -
> -end_function:
> -     return error;
> -
> -}
> -
> -/**
> - *   sep_free_dma_tables_and_dcb - free DMA tables and DCBs
> - *   @sep: pointer to struct sep_device
> - *   @isapplet: indicates external application (used for kernel access)
> - *   @is_kva: indicates kernel addresses (only used for kernel crypto)
> - *
> - *   This function frees the DMA tables and DCB
> - */
> -static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
> -     bool is_kva)
> -{
> -     int i = 0;
> -     int error = 0;
> -     int error_temp = 0;
> -     struct sep_dcblock *dcb_table_ptr;
> -     unsigned long pt_hold;
> -     void *tail_pt;
> -
> -     if (isapplet == true) {
> -             /* Set pointer to first DCB table */
> -             dcb_table_ptr = (struct sep_dcblock *)
> -                     (sep->shared_addr +
> -                     SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES);
> -
> -             /* Go over each DCB and see if tail pointer must be updated */
> -             for (i = 0; i < sep->nr_dcb_creat; i++, dcb_table_ptr++) {
> -                     if (dcb_table_ptr->out_vr_tail_pt) {
> -                             pt_hold = (unsigned long)dcb_table_ptr->out_vr_tail_pt;
> -                             tail_pt = (void *)pt_hold;
> -                             if (is_kva == true) {
> -                                     memcpy(tail_pt,
> -                                             dcb_table_ptr->tail_data,
> -                                             dcb_table_ptr->tail_data_size);
> -                             } else {
> -                                     error_temp = copy_to_user(
> -                                             tail_pt,
> -                                             dcb_table_ptr->tail_data,
> -                                             dcb_table_ptr->tail_data_size);
> -                             }
> -                             if (error_temp) {
> -                                     /* Release the DMA resource */
> -                                     error = -EFAULT;
> -                                     break;
> -                             }
> -                     }
> -             }
> -     }
> -     /* Free the output pages, if any */
> -     sep_free_dma_table_data_handler(sep);
> -
> -     return error;
> -}
> -
> -/**
> - *   sep_get_static_pool_addr_handler - get static pool address
> - *   @sep: pointer to struct sep_device
> - *
> - *   This function sets the bus and virtual addresses of the static pool
> - */
> -static int sep_get_static_pool_addr_handler(struct sep_device *sep)
> -{
> -     u32 *static_pool_addr = NULL;
> -
> -     static_pool_addr = (u32 *)(sep->shared_addr +
> -             SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
> -
> -     static_pool_addr[0] = SEP_STATIC_POOL_VAL_TOKEN;
> -     static_pool_addr[1] = (u32)sep->shared_bus +
> -             SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES;
> -
> -     dev_dbg(&sep->pdev->dev, "static pool segment: physical %x\n",
> -             (u32)static_pool_addr[1]);
> -
> -     return 0;
> -}
> -
> -/**
> - *   sep_end_transaction_handler - end transaction
> - *   @sep: pointer to struct sep_device
> - *
> - *   This API handles the end transaction request
> - */
> -static int sep_end_transaction_handler(struct sep_device *sep)
> -{
> -     /* Clear the data pool pointers Token */
> -     memset((void *)(sep->shared_addr +
> -             SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES),
> -             0, sep->num_of_data_allocations*2*sizeof(u32));
> -
> -     /* Check that all the DMA resources were freed */
> -     sep_free_dma_table_data_handler(sep);
> -
> -     clear_bit(SEP_MMAP_LOCK_BIT, &sep->in_use_flags);
> -
> -     /*
> -      * We are now through with the transaction. Let's
> -      * allow other processes who have the device open
> -      * to perform transactions
> -      */
> -     mutex_lock(&sep->sep_mutex);
> -     sep->pid_doing_transaction = 0;
> -     mutex_unlock(&sep->sep_mutex);
> -     /* Raise event for stuck contextes */
> -     wake_up(&sep->event);
> -
> -     return 0;
> -}
> -
> -/**
> - *   sep_prepare_dcb_handler - prepare a control block
> - *   @sep: pointer to struct sep_device
> - *   @arg: pointer to user parameters
> - *
> - *   This function will retrieve the RAR buffer physical addresses, type
> - *   & size corresponding to the RAR handles provided in the buffers vector.
> - */
> -static int sep_prepare_dcb_handler(struct sep_device *sep, unsigned long arg)
> -{
> -     int error;
> -     /* Command arguments */
> -     struct build_dcb_struct command_args;
> -
> -     /* Get the command arguments */
> -     if (copy_from_user(&command_args, (void __user *)arg,
> -                                     sizeof(struct build_dcb_struct))) {
> -             error = -EFAULT;
> -             goto end_function;
> -     }
> -
> -     dev_dbg(&sep->pdev->dev, "prep dcb handler app_in_address is %08llx\n",
> -                                             command_args.app_in_address);
> -     dev_dbg(&sep->pdev->dev, "app_out_address is %08llx\n",
> -                                             command_args.app_out_address);
> -     dev_dbg(&sep->pdev->dev, "data_size is %x\n",
> -                                             command_args.data_in_size);
> -     dev_dbg(&sep->pdev->dev, "block_size is %x\n",
> -                                             command_args.block_size);
> -     dev_dbg(&sep->pdev->dev, "tail block_size is %x\n",
> -                                             command_args.tail_block_size);
> -
> -     error = sep_prepare_input_output_dma_table_in_dcb(sep,
> -             (unsigned long)command_args.app_in_address,
> -             (unsigned long)command_args.app_out_address,
> -             command_args.data_in_size, command_args.block_size,
> -             command_args.tail_block_size, true, false);
> -
> -end_function:
> -     return error;
> -
> -}
> -
> -/**
> - *   sep_free_dcb_handler - free control block resources
> - *   @sep: pointer to struct sep_device
> - *
> - *   This function frees the DCB resources and updates the needed
> - *   user-space buffers.
> - */
> -static int sep_free_dcb_handler(struct sep_device *sep)
> -{
> -     return sep_free_dma_tables_and_dcb(sep, false, false);
> -}
> -
> -/**
> - *   sep_rar_prepare_output_msg_handler - prepare an output message
> - *   @sep: pointer to struct sep_device
> - *   @arg: pointer to user parameters
> - *
> - *   This function will retrieve the RAR buffer physical addresses, type
> - *   & size corresponding to the RAR handles provided in the buffers vector.
> - */
> -static int sep_rar_prepare_output_msg_handler(struct sep_device *sep,
> -     unsigned long arg)
> -{
> -     int error = 0;
> -     /* Command args */
> -     struct rar_hndl_to_bus_struct command_args;
> -     /* Bus address */
> -     dma_addr_t  rar_bus = 0;
> -     /* Holds the RAR address in the system memory offset */
> -     u32 *rar_addr;
> -
> -     /* Copy the data */
> -     if (copy_from_user(&command_args, (void __user *)arg,
> -                                             sizeof(command_args))) {
> -             error = -EFAULT;
> -             goto end_function;
> -     }
> -
> -     /* Call to translation function only if user handle is not NULL */
> -     if (command_args.rar_handle)
> -             return -EOPNOTSUPP;
> -     dev_dbg(&sep->pdev->dev, "rar msg; rar_addr_bus = %x\n", (u32)rar_bus);
> -
> -     /* Set value in the SYSTEM MEMORY offset */
> -     rar_addr = (u32 *)(sep->shared_addr +
> -             SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES);
> -
> -     /* Copy the physical address to the System Area for the SEP */
> -     rar_addr[0] = SEP_RAR_VAL_TOKEN;
> -     rar_addr[1] = rar_bus;
> -
> -end_function:
> -     return error;
> -}
> -
> -/**
> - *   sep_ioctl - ioctl api
> - *   @filp: pointer to struct file
> - *   @cmd: command
> - *   @arg: pointer to argument structure
> - *
> - *   Implement the ioctl methods available on the SEP device.
> - */
> -static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> -{
> -     int error = 0;
> -     struct sep_device *sep = filp->private_data;
> -
> -     /* Make sure we own this device */
> -     mutex_lock(&sep->sep_mutex);
> -     if ((current->pid != sep->pid_doing_transaction) &&
> -                             (sep->pid_doing_transaction != 0)) {
> -             dev_dbg(&sep->pdev->dev, "ioctl pid is not owner\n");
> -             error = -EACCES;
> -             goto end_function;
> -     }
> -
> -     mutex_unlock(&sep->sep_mutex);
> -
> -     if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
> -             return -ENOTTY;
> -
> -     /* Lock to prevent the daemon to interfere with operation */
> -     mutex_lock(&sep->ioctl_mutex);
> -
> -     switch (cmd) {
> -     case SEP_IOCSENDSEPCOMMAND:
> -             /* Send command to SEP */
> -             error = sep_send_command_handler(sep);
> -             break;
> -     case SEP_IOCALLOCDATAPOLL:
> -             /* Allocate data pool */
> -             error = sep_allocate_data_pool_memory_handler(sep, arg);
> -             break;
> -     case SEP_IOCGETSTATICPOOLADDR:
> -             /* Inform the SEP the bus address of the static pool */
> -             error = sep_get_static_pool_addr_handler(sep);
> -             break;
> -     case SEP_IOCENDTRANSACTION:
> -             error = sep_end_transaction_handler(sep);
> -             break;
> -     case SEP_IOCRARPREPAREMESSAGE:
> -             error = sep_rar_prepare_output_msg_handler(sep, arg);
> -             break;
> -     case SEP_IOCPREPAREDCB:
> -             error = sep_prepare_dcb_handler(sep, arg);
> -             break;
> -     case SEP_IOCFREEDCB:
> -             error = sep_free_dcb_handler(sep);
> -             break;
> -     default:
> -             error = -ENOTTY;
> -             break;
> -     }
> -
> -end_function:
> -     mutex_unlock(&sep->ioctl_mutex);
> -     return error;
> -}
> -
> -/**
> - *   sep_singleton_ioctl - ioctl api for singleton interface
> - *   @filp: pointer to struct file
> - *   @cmd: command
> - *   @arg: pointer to argument structure
> - *
> - *   Implement the additional ioctls for the singleton device
> - */
> -static long sep_singleton_ioctl(struct file  *filp, u32 cmd, unsigned long arg)
> -{
> -     long error = 0;
> -     struct sep_device *sep = filp->private_data;
> -
> -     /* Check that the command is for the SEP device */
> -     if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
> -             return -ENOTTY;
> -
> -     /* Make sure we own this device */
> -     mutex_lock(&sep->sep_mutex);
> -     if ((current->pid != sep->pid_doing_transaction) &&
> -                             (sep->pid_doing_transaction != 0)) {
> -             dev_dbg(&sep->pdev->dev, "singleton ioctl pid is not owner\n");
> -             mutex_unlock(&sep->sep_mutex);
> -             return -EACCES;
> -     }
> -
> -     mutex_unlock(&sep->sep_mutex);
> -
> -     switch (cmd) {
> -     case SEP_IOCTLSETCALLERID:
> -             mutex_lock(&sep->ioctl_mutex);
> -             error = sep_set_caller_id_handler(sep, arg);
> -             mutex_unlock(&sep->ioctl_mutex);
> -             break;
> -     default:
> -             error = sep_ioctl(filp, cmd, arg);
> -             break;
> -     }
> -     return error;
> -}
> -
> -/**
> - *   sep_request_daemon_ioctl - ioctl for daemon
> - *   @filp: pointer to struct file
> - *   @cmd: command
> - *   @arg: pointer to argument structure
> - *
> - *   Called by the request daemon to perform ioctls on the daemon device
> - */
> -static long sep_request_daemon_ioctl(struct file *filp, u32 cmd,
> -     unsigned long arg)
> -{
> -
> -     long error;
> -     struct sep_device *sep = filp->private_data;
> -
> -     /* Check that the command is for SEP device */
> -     if (_IOC_TYPE(cmd) != SEP_IOC_MAGIC_NUMBER)
> -             return -ENOTTY;
> -
> -     /* Only one process can access ioctl at any given time */
> -     mutex_lock(&sep->ioctl_mutex);
> -
> -     switch (cmd) {
> -     case SEP_IOCSENDSEPRPLYCOMMAND:
> -             /* Send reply command to SEP */
> -             error = sep_req_daemon_send_reply_command_handler(sep);
> -             break;
> -     case SEP_IOCENDTRANSACTION:
> -             /*
> -              * End req daemon transaction, do nothing
> -              * will be removed upon update in middleware
> -              * API library
> -              */
> -             error = 0;
> -             break;
> -     default:
> -             error = -ENOTTY;
> -     }
> -     mutex_unlock(&sep->ioctl_mutex);
> -     return error;
> -}
> -
> -/**
> - *   sep_inthandler - interrupt handler
> - *   @irq: interrupt
> - *   @dev_id: device id
> - */
> -static irqreturn_t sep_inthandler(int irq, void *dev_id)
> -{
> -     irqreturn_t int_error = IRQ_HANDLED;
> -     unsigned long lck_flags;
> -     u32 reg_val, reg_val2 = 0;
> -     struct sep_device *sep = dev_id;
> -
> -     /* Read the IRR register to check if this is SEP interrupt */
> -     reg_val = sep_read_reg(sep, HW_HOST_IRR_REG_ADDR);
> -
> -     if (reg_val & (0x1 << 13)) {
> -             /* Lock and update the counter of reply messages */
> -             spin_lock_irqsave(&sep->snd_rply_lck, lck_flags);
> -             sep->reply_ct++;
> -             spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
> -
> -             dev_dbg(&sep->pdev->dev, "sep int: send_ct %lx reply_ct %lx\n",
> -                                     sep->send_ct, sep->reply_ct);
> -
> -             /* Is this printf or daemon request? */
> -             reg_val2 = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
> -             dev_dbg(&sep->pdev->dev,
> -                     "SEP Interrupt - reg2 is %08x\n", reg_val2);
> -
> -             if ((reg_val2 >> 30) & 0x1) {
> -                     dev_dbg(&sep->pdev->dev, "int: printf request\n");
> -                     wake_up(&sep->event_request_daemon);
> -             } else if (reg_val2 >> 31) {
> -                     dev_dbg(&sep->pdev->dev, "int: daemon request\n");
> -                     wake_up(&sep->event_request_daemon);
> -             } else {
> -                     dev_dbg(&sep->pdev->dev, "int: SEP reply\n");
> -                     wake_up(&sep->event);
> -             }
> -     } else {
> -             dev_dbg(&sep->pdev->dev, "int: not SEP interrupt\n");
> -             int_error = IRQ_NONE;
> -     }
> -     if (int_error == IRQ_HANDLED)
> -             sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, reg_val);
> -
> -     return int_error;
> -}
> -
> -/**
> - *   sep_reconfig_shared_area - reconfigure shared area
> - *   @sep: pointer to struct sep_device
> - *
> - *   Reconfig the shared area between HOST and SEP - needed in case
> - *   the DX_CC_Init function was called before OS loading.
> - */
> -static int sep_reconfig_shared_area(struct sep_device *sep)
> -{
> -     int ret_val;
> -
> -     /* use to limit waiting for SEP */
> -     unsigned long end_time;
> -
> -     /* Send the new SHARED MESSAGE AREA to the SEP */
> -     dev_dbg(&sep->pdev->dev, "reconfig shared; sending %08llx to sep\n",
> -                             (unsigned long long)sep->shared_bus);
> -
> -     sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
> -
> -     /* Poll for SEP response */
> -     ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
> -
> -     end_time = jiffies + (WAIT_TIME * HZ);
> -
> -     while ((time_before(jiffies, end_time)) && (ret_val != 0xffffffff) &&
> -             (ret_val != sep->shared_bus))
> -             ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
> -
> -     /* Check the return value (register) */
> -     if (ret_val != sep->shared_bus) {
> -             dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
> -             dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
> -             ret_val = -ENOMEM;
> -     } else
> -             ret_val = 0;
> -
> -     dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
> -     return ret_val;
> -}
> -
> -/* File operation for singleton SEP operations */
> -static const struct file_operations singleton_file_operations = {
> -     .owner = THIS_MODULE,
> -     .unlocked_ioctl = sep_singleton_ioctl,
> -     .poll = sep_poll,
> -     .open = sep_singleton_open,
> -     .release = sep_singleton_release,
> -     .mmap = sep_mmap,
> -};
> -
> -/* File operation for daemon operations */
> -static const struct file_operations daemon_file_operations = {
> -     .owner = THIS_MODULE,
> -     .unlocked_ioctl = sep_request_daemon_ioctl,
> -     .poll = sep_request_daemon_poll,
> -     .open = sep_request_daemon_open,
> -     .release = sep_request_daemon_release,
> -     .mmap = sep_request_daemon_mmap,
> -};
> -
> -/* The files operations structure of the driver */
> -static const struct file_operations sep_file_operations = {
> -     .owner = THIS_MODULE,
> -     .unlocked_ioctl = sep_ioctl,
> -     .poll = sep_poll,
> -     .open = sep_open,
> -     .release = sep_release,
> -     .mmap = sep_mmap,
> -};
> -
> -/**
> - *   sep_register_driver_with_fs - register misc devices
> - *   @sep: pointer to struct sep_device
> - *
> - *   This function registers the driver with the file system
> - */
> -static int sep_register_driver_with_fs(struct sep_device *sep)
> -{
> -     int ret_val;
> -
> -     sep->miscdev_sep.minor = MISC_DYNAMIC_MINOR;
> -     sep->miscdev_sep.name = SEP_DEV_NAME;
> -     sep->miscdev_sep.fops = &sep_file_operations;
> -
> -     sep->miscdev_singleton.minor = MISC_DYNAMIC_MINOR;
> -     sep->miscdev_singleton.name = SEP_DEV_SINGLETON;
> -     sep->miscdev_singleton.fops = &singleton_file_operations;
> -
> -     sep->miscdev_daemon.minor = MISC_DYNAMIC_MINOR;
> -     sep->miscdev_daemon.name = SEP_DEV_DAEMON;
> -     sep->miscdev_daemon.fops = &daemon_file_operations;
> -
> -     ret_val = misc_register(&sep->miscdev_sep);
> -     if (ret_val) {
> -             dev_warn(&sep->pdev->dev, "misc reg fails for SEP %x\n",
> -                     ret_val);
> -             return ret_val;
> -     }
> -
> -     ret_val = misc_register(&sep->miscdev_singleton);
> -     if (ret_val) {
> -             dev_warn(&sep->pdev->dev, "misc reg fails for sing %x\n",
> -                     ret_val);
> -             misc_deregister(&sep->miscdev_sep);
> -             return ret_val;
> -     }
> -
> -     ret_val = misc_register(&sep->miscdev_daemon);
> -     if (ret_val) {
> -             dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
> -                     ret_val);
> -             misc_deregister(&sep->miscdev_sep);
> -             misc_deregister(&sep->miscdev_singleton);
> -
> -             return ret_val;
> -     }
> -     return ret_val;
> -}
> -
> -
> -/**
> - *   sep_probe - probe a matching PCI device
> - *   @pdev: pci_device
> - *   @end: pci_device_id
> - *
> - *   Attempt to set up and configure a SEP device that has been
> - *   discovered by the PCI layer.
> - */
> -static int __devinit sep_probe(struct pci_dev *pdev,
> -     const struct pci_device_id *ent)
> -{
> -     int error = 0;
> -     struct sep_device *sep;
> -
> -     if (sep_dev != NULL) {
> -             dev_warn(&pdev->dev, "only one SEP supported.\n");
> -             return -EBUSY;
> -     }
> -
> -     /* Enable the device */
> -     error = pci_enable_device(pdev);
> -     if (error) {
> -             dev_warn(&pdev->dev, "error enabling pci device\n");
> -             goto end_function;
> -     }
> -
> -     /* Allocate the sep_device structure for this device */
> -     sep_dev = kzalloc(sizeof(struct sep_device), GFP_ATOMIC);
> -     if (sep_dev == NULL) {
> -             dev_warn(&pdev->dev,
> -                     "can't kmalloc the sep_device structure\n");
> -             error = -ENOMEM;
> -             goto end_function_disable_device;
> -     }
> -
> -     /*
> -      * We're going to use another variable for actually
> -      * working with the device; this way, if we have
> -      * multiple devices in the future, it would be easier
> -      * to make appropriate changes
> -      */
> -     sep = sep_dev;
> -
> -     sep->pdev = pci_dev_get(pdev);
> -
> -     init_waitqueue_head(&sep->event);
> -     init_waitqueue_head(&sep->event_request_daemon);
> -     spin_lock_init(&sep->snd_rply_lck);
> -     mutex_init(&sep->sep_mutex);
> -     mutex_init(&sep->ioctl_mutex);
> -
> -     dev_dbg(&sep->pdev->dev, "sep probe: PCI obtained, device being prepared\n");
> -     dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
> -
> -     /* Set up our register area */
> -     sep->reg_physical_addr = pci_resource_start(sep->pdev, 0);
> -     if (!sep->reg_physical_addr) {
> -             dev_warn(&sep->pdev->dev, "Error getting register start\n");
> -             error = -ENODEV;
> -             goto end_function_free_sep_dev;
> -     }
> -
> -     sep->reg_physical_end = pci_resource_end(sep->pdev, 0);
> -     if (!sep->reg_physical_end) {
> -             dev_warn(&sep->pdev->dev, "Error getting register end\n");
> -             error = -ENODEV;
> -             goto end_function_free_sep_dev;
> -     }
> -
> -     sep->reg_addr = ioremap_nocache(sep->reg_physical_addr,
> -             (size_t)(sep->reg_physical_end - sep->reg_physical_addr + 1));
> -     if (!sep->reg_addr) {
> -             dev_warn(&sep->pdev->dev, "Error getting register virtual\n");
> -             error = -ENODEV;
> -             goto end_function_free_sep_dev;
> -     }
> -
> -     dev_dbg(&sep->pdev->dev,
> -             "Register area start %llx end %llx virtual %p\n",
> -             (unsigned long long)sep->reg_physical_addr,
> -             (unsigned long long)sep->reg_physical_end,
> -             sep->reg_addr);
> -
> -     /* Allocate the shared area */
> -     sep->shared_size = SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES +
> -             SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES +
> -             SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES +
> -             SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES +
> -             SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES;
> -
> -     if (sep_map_and_alloc_shared_area(sep)) {
> -             error = -ENOMEM;
> -             /* Allocation failed */
> -             goto end_function_error;
> -     }
> -
> -     /* Clear ICR register */
> -     sep_write_reg(sep, HW_HOST_ICR_REG_ADDR, 0xFFFFFFFF);
> -
> -     /* Set the IMR register - open only GPR 2 */
> -     sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
> -
> -     /* Read send/receive counters from SEP */
> -     sep->reply_ct = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
> -     sep->reply_ct &= 0x3FFFFFFF;
> -     sep->send_ct = sep->reply_ct;
> -
> -     /* Get the interrupt line */
> -     error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
> -             "sep_driver", sep);
> -
> -     if (error)
> -             goto end_function_deallocate_sep_shared_area;
> -
> -     /* The new chip requires a shared area reconfigure */
> -     if (sep->pdev->revision == 4) { /* Only for new chip */
> -             error = sep_reconfig_shared_area(sep);
> -             if (error)
> -                     goto end_function_free_irq;
> -     }
> -     /* Finally magic up the device nodes */
> -     /* Register driver with the fs */
> -     error = sep_register_driver_with_fs(sep);
> -     if (error == 0)
> -             /* Success */
> -             return 0;
> -
> -end_function_free_irq:
> -     free_irq(pdev->irq, sep);
> -
> -end_function_deallocate_sep_shared_area:
> -     /* De-allocate shared area */
> -     sep_unmap_and_free_shared_area(sep);
> -
> -end_function_error:
> -     iounmap(sep->reg_addr);
> -
> -end_function_free_sep_dev:
> -     pci_dev_put(sep_dev->pdev);
> -     kfree(sep_dev);
> -     sep_dev = NULL;
> -
> -end_function_disable_device:
> -     pci_disable_device(pdev);
> -
> -end_function:
> -     return error;
> -}
> -
> -static void sep_remove(struct pci_dev *pdev)
> -{
> -     struct sep_device *sep = sep_dev;
> -
> -     /* Unregister from fs */
> -     misc_deregister(&sep->miscdev_sep);
> -     misc_deregister(&sep->miscdev_singleton);
> -     misc_deregister(&sep->miscdev_daemon);
> -
> -     /* Free the irq */
> -     free_irq(sep->pdev->irq, sep);
> -
> -     /* Free the shared area  */
> -     sep_unmap_and_free_shared_area(sep_dev);
> -     iounmap((void *) sep_dev->reg_addr);
> -}
> -
> -static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
> -     {PCI_DEVICE(PCI_VENDOR_ID_INTEL, MFLD_PCI_DEVICE_ID)},
> -     {0}
> -};
> -
> -MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
> -
> -/* Field for registering driver to PCI device */
> -static struct pci_driver sep_pci_driver = {
> -     .name = "sep_sec_driver",
> -     .id_table = sep_pci_id_tbl,
> -     .probe = sep_probe,
> -     .remove = sep_remove
> -};
> -
> -
> -/**
> - *   sep_init - init function
> - *
> - *   Module load time. Register the PCI device driver.
> - */
> -static int __init sep_init(void)
> -{
> -     return pci_register_driver(&sep_pci_driver);
> -}
> -
> -
> -/**
> - *   sep_exit - called to unload driver
> - *
> - *   Drop the misc devices then remove and unmap the various resources
> - *   that are not released by the driver remove method.
> - */
> -static void __exit sep_exit(void)
> -{
> -     pci_unregister_driver(&sep_pci_driver);
> -}
> -
> -
> -module_init(sep_init);
> -module_exit(sep_exit);
> -
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
> deleted file mode 100644
> index c3aacfc..0000000
> --- a/drivers/staging/sep/sep_driver_api.h
> +++ /dev/null
> @@ -1,215 +0,0 @@
> -/*
> - *
> - *  sep_driver_api.h - Security Processor Driver api definitions
> - *
> - *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> - *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> - *
> - *  This program is free software; you can redistribute it and/or modify it
> - *  under the terms of the GNU General Public License as published by the Free
> - *  Software Foundation; version 2 of the License.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
> - *  CONTACTS:
> - *
> - *  Mark Allyn               mark.a.allyn@intel.com
> - *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> - *
> - *  CHANGES:
> - *
> - *  2010.09.14  Upgrade to Medfield
> - *
> - */
> -
> -#ifndef __SEP_DRIVER_API_H__
> -#define __SEP_DRIVER_API_H__
> -
> -/* Type of request from device */
> -#define SEP_DRIVER_SRC_REPLY         1
> -#define SEP_DRIVER_SRC_REQ           2
> -#define SEP_DRIVER_SRC_PRINTF                3
> -
> -
> -/*-------------------------------------------
> -    TYPEDEFS
> -----------------------------------------------*/
> -
> -struct alloc_struct {
> -     /* offset from start of shared pool area */
> -     u32  offset;
> -     /* number of bytes to allocate */
> -     u32  num_bytes;
> -};
> -
> -/* command struct for getting caller id value and address */
> -struct caller_id_struct {
> -     /* pid of the process */
> -     u32 pid;
> -     /* virtual address of the caller id hash */
> -     aligned_u64 callerIdAddress;
> -     /* caller id hash size in bytes */
> -     u32 callerIdSizeInBytes;
> -};
> -
> -/*
> -  structure that represents DCB
> -*/
> -struct sep_dcblock {
> -     /* physical address of the first input mlli */
> -     u32     input_mlli_address;
> -     /* num of entries in the first input mlli */
> -     u32     input_mlli_num_entries;
> -     /* size of data in the first input mlli */
> -     u32     input_mlli_data_size;
> -     /* physical address of the first output mlli */
> -     u32     output_mlli_address;
> -     /* num of entries in the first output mlli */
> -     u32     output_mlli_num_entries;
> -     /* size of data in the first output mlli */
> -     u32     output_mlli_data_size;
> -     /* pointer to the output virtual tail */
> -     aligned_u64 out_vr_tail_pt;
> -     /* size of tail data */
> -     u32     tail_data_size;
> -     /* input tail data array */
> -     u8      tail_data[68];
> -};
> -
> -struct sep_caller_id_entry {
> -     int pid;
> -     unsigned char callerIdHash[SEP_CALLER_ID_HASH_SIZE_IN_BYTES];
> -};
> -
> -/*
> -     command structure for building dcb block (currently for ext app only
> -*/
> -struct build_dcb_struct {
> -     /* address value of the data in */
> -     aligned_u64 app_in_address;
> -     /* size of data in */
> -     u32  data_in_size;
> -     /* address of the data out */
> -     aligned_u64 app_out_address;
> -     /* the size of the block of the operation - if needed,
> -     every table will be modulo this parameter */
> -     u32  block_size;
> -     /* the size of the block of the operation - if needed,
> -     every table will be modulo this parameter */
> -     u32  tail_block_size;
> -};
> -
> -/**
> - * @struct sep_dma_map
> - *
> - * Structure that contains all information needed for mapping the user pages
> - *        or kernel buffers for dma operations
> - *
> - *
> - */
> -struct sep_dma_map {
> -     /* mapped dma address */
> -     dma_addr_t    dma_addr;
> -     /* size of the mapped data */
> -     size_t        size;
> -};
> -
> -struct sep_dma_resource {
> -     /* array of pointers to the pages that represent
> -     input data for the synchronic DMA action */
> -     struct page **in_page_array;
> -
> -     /* array of pointers to the pages that represent out
> -     data for the synchronic DMA action */
> -     struct page **out_page_array;
> -
> -     /* number of pages in the sep_in_page_array */
> -     u32 in_num_pages;
> -
> -     /* number of pages in the sep_out_page_array */
> -     u32 out_num_pages;
> -
> -     /* map array of the input data */
> -     struct sep_dma_map *in_map_array;
> -
> -     /* map array of the output data */
> -     struct sep_dma_map *out_map_array;
> -
> -     /* number of entries of the input mapp array */
> -     u32 in_map_num_entries;
> -
> -     /* number of entries of the output mapp array */
> -     u32 out_map_num_entries;
> -};
> -
> -
> -/* command struct for translating rar handle to bus address
> -   and setting it at predefined location */
> -struct rar_hndl_to_bus_struct {
> -
> -     /* rar handle */
> -     aligned_u64 rar_handle;
> -};
> -
> -/*
> -  structure that represent one entry in the DMA LLI table
> -*/
> -struct sep_lli_entry {
> -     /* physical address */
> -     u32 bus_address;
> -
> -     /* block size */
> -     u32 block_size;
> -};
> -
> -/*----------------------------------------------------------------
> -     IOCTL command defines
> -     -----------------------------------------------------------------*/
> -
> -/* magic number 1 of the sep IOCTL command */
> -#define SEP_IOC_MAGIC_NUMBER                      's'
> -
> -/* sends interrupt to sep that message is ready */
> -#define SEP_IOCSENDSEPCOMMAND         \
> -     _IO(SEP_IOC_MAGIC_NUMBER, 0)
> -
> -/* sends interrupt to sep that message is ready */
> -#define SEP_IOCSENDSEPRPLYCOMMAND     \
> -     _IO(SEP_IOC_MAGIC_NUMBER, 1)
> -
> -/* allocate memory in data pool */
> -#define SEP_IOCALLOCDATAPOLL \
> -     _IOW(SEP_IOC_MAGIC_NUMBER, 2, struct alloc_struct)
> -
> -/* free dynamic data aalocated during table creation */
> -#define SEP_IOCFREEDMATABLEDATA       \
> -     _IO(SEP_IOC_MAGIC_NUMBER, 7)
> -
> -/* get the static pool area addersses (physical and virtual) */
> -#define SEP_IOCGETSTATICPOOLADDR     \
> -     _IO(SEP_IOC_MAGIC_NUMBER, 8)
> -
> -/* end transaction command */
> -#define SEP_IOCENDTRANSACTION         \
> -     _IO(SEP_IOC_MAGIC_NUMBER, 15)
> -
> -#define SEP_IOCRARPREPAREMESSAGE     \
> -     _IOW(SEP_IOC_MAGIC_NUMBER, 20, struct rar_hndl_to_bus_struct)
> -
> -#define SEP_IOCTLSETCALLERID \
> -     _IOW(SEP_IOC_MAGIC_NUMBER, 34, struct caller_id_struct)
> -
> -#define SEP_IOCPREPAREDCB                                    \
> -     _IOW(SEP_IOC_MAGIC_NUMBER, 35, struct build_dcb_struct)
> -
> -#define SEP_IOCFREEDCB                                       \
> -     _IO(SEP_IOC_MAGIC_NUMBER, 36)
> -
> -#endif
> diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
> deleted file mode 100644
> index 1033425..0000000
> --- a/drivers/staging/sep/sep_driver_config.h
> +++ /dev/null
> @@ -1,243 +0,0 @@
> -/*
> - *
> - *  sep_driver_config.h - Security Processor Driver configuration
> - *
> - *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> - *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> - *
> - *  This program is free software; you can redistribute it and/or modify it
> - *  under the terms of the GNU General Public License as published by the Free
> - *  Software Foundation; version 2 of the License.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
> - *  CONTACTS:
> - *
> - *  Mark Allyn               mark.a.allyn@intel.com
> - *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> - *
> - *  CHANGES:
> - *
> - *  2010.06.26       Upgrade to Medfield
> - *
> - */
> -
> -#ifndef __SEP_DRIVER_CONFIG_H__
> -#define __SEP_DRIVER_CONFIG_H__
> -
> -
> -/*--------------------------------------
> -  DRIVER CONFIGURATION FLAGS
> -  -------------------------------------*/
> -
> -/* if flag is on , then the driver is running in polling and
> -     not interrupt mode */
> -#define SEP_DRIVER_POLLING_MODE                         0
> -
> -/* flag which defines if the shared area address should be
> -     reconfiged (send to SEP anew) during init of the driver */
> -#define SEP_DRIVER_RECONFIG_MESSAGE_AREA                0
> -
> -/* the mode for running on the ARM1172 Evaluation platform (flag is 1) */
> -#define SEP_DRIVER_ARM_DEBUG_MODE                       0
> -
> -/*-------------------------------------------
> -     INTERNAL DATA CONFIGURATION
> -     -------------------------------------------*/
> -
> -/* flag for the input array */
> -#define SEP_DRIVER_IN_FLAG                              0
> -
> -/* flag for output array */
> -#define SEP_DRIVER_OUT_FLAG                             1
> -
> -/* maximum number of entries in one LLI tables */
> -#define SEP_DRIVER_ENTRIES_PER_TABLE_IN_SEP             31
> -
> -/* minimum data size of the MLLI table */
> -#define SEP_DRIVER_MIN_DATA_SIZE_PER_TABLE           16
> -
> -/* flag that signifies tah the lock is
> -currently held by the process (struct file) */
> -#define SEP_DRIVER_OWN_LOCK_FLAG                        1
> -
> -/* flag that signifies tah the lock is currently NOT
> -held by the process (struct file) */
> -#define SEP_DRIVER_DISOWN_LOCK_FLAG                     0
> -
> -/* indicates whether driver has mapped/unmapped shared area */
> -#define SEP_REQUEST_DAEMON_MAPPED 1
> -#define SEP_REQUEST_DAEMON_UNMAPPED 0
> -
> -#define SEP_DEV_NAME "sep_sec_driver"
> -#define SEP_DEV_SINGLETON "sep_sec_singleton_driver"
> -#define SEP_DEV_DAEMON "sep_req_daemon_driver"
> -
> -/*--------------------------------------------------------
> -     SHARED AREA  memory total size is 36K
> -     it is divided is following:
> -
> -     SHARED_MESSAGE_AREA                     8K         }
> -                                                                     }
> -     STATIC_POOL_AREA                        4K         } MAPPED AREA ( 24 K)
> -                                                                     }
> -     DATA_POOL_AREA                          12K        }
> -
> -     SYNCHRONIC_DMA_TABLES_AREA              5K
> -
> -     placeholder until drver changes
> -     FLOW_DMA_TABLES_AREA                    4K
> -
> -     SYSTEM_MEMORY_AREA                      3k
> -
> -     SYSTEM_MEMORY total size is 3k
> -     it is divided as following:
> -
> -     TIME_MEMORY_AREA                     8B
> ------------------------------------------------------------*/
> -
> -#define SEP_DEV_NAME "sep_sec_driver"
> -#define SEP_DEV_SINGLETON "sep_sec_singleton_driver"
> -#define SEP_DEV_DAEMON "sep_req_daemon_driver"
> -
> -
> -/*
> -     the maximum length of the message - the rest of the message shared
> -     area will be dedicated to the dma lli tables
> -*/
> -#define SEP_DRIVER_MAX_MESSAGE_SIZE_IN_BYTES                 (8 * 1024)
> -
> -/* the size of the message shared area in pages */
> -#define SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES         (8 * 1024)
> -
> -/* the size of the data pool static area in pages */
> -#define SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES                 (4 * 1024)
> -
> -/* the size of the data pool shared area size in pages */
> -#define SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES               (16 * 1024)
> -
> -/* the size of the message shared area in pages */
> -#define SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES        (1024 * 5)
> -
> -/* Placeholder until driver changes */
> -#define SEP_DRIVER_FLOW_DMA_TABLES_AREA_SIZE_IN_BYTES                (1024 * 4)
> -
> -/* system data (time, caller id etc') pool */
> -#define SEP_DRIVER_SYSTEM_DATA_MEMORY_SIZE_IN_BYTES          (1024 * 3)
> -
> -/* the size in bytes of the time memory */
> -#define SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES                 8
> -
> -/* the size in bytes of the RAR parameters memory */
> -#define SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES           8
> -
> -/* area size that is mapped  - we map the MESSAGE AREA, STATIC POOL and
> -     DATA POOL areas. area must be module 4k */
> -#define SEP_DRIVER_MMMAP_AREA_SIZE                           (1024 * 28)
> -
> -/*-----------------------------------------------
> -     offsets of the areas starting from the shared area start address
> -*/
> -
> -/* message area offset */
> -#define SEP_DRIVER_MESSAGE_AREA_OFFSET_IN_BYTES                      0
> -
> -/* static pool area offset */
> -#define SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES \
> -     (SEP_DRIVER_MESSAGE_SHARED_AREA_SIZE_IN_BYTES)
> -
> -/* data pool area offset */
> -#define SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES \
> -     (SEP_DRIVER_STATIC_AREA_OFFSET_IN_BYTES + \
> -     SEP_DRIVER_STATIC_AREA_SIZE_IN_BYTES)
> -
> -/* synhronic dma tables area offset */
> -#define SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES \
> -     (SEP_DRIVER_DATA_POOL_AREA_OFFSET_IN_BYTES + \
> -     SEP_DRIVER_DATA_POOL_SHARED_AREA_SIZE_IN_BYTES)
> -
> -/* system memory offset in bytes */
> -#define SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES \
> -     (SYNCHRONIC_DMA_TABLES_AREA_OFFSET_BYTES + \
> -     SYNCHRONIC_DMA_TABLES_AREA_SIZE_BYTES)
> -
> -/* offset of the time area */
> -#define SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES \
> -     (SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES)
> -
> -/* offset of the RAR area */
> -#define SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES \
> -     (SEP_DRIVER_SYSTEM_TIME_MEMORY_OFFSET_IN_BYTES + \
> -     SEP_DRIVER_TIME_MEMORY_SIZE_IN_BYTES)
> -
> -/* offset of the caller id area */
> -#define SEP_CALLER_ID_OFFSET_BYTES \
> -     (SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES + \
> -    SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)
> -
> -/* offset of the DCB area */
> -#define SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES \
> -     (SEP_DRIVER_SYSTEM_DATA_MEMORY_OFFSET_IN_BYTES + \
> -     0x400)
> -
> -/* offset of the ext cache area */
> -#define SEP_DRIVER_SYSTEM_EXT_CACHE_ADDR_OFFSET_IN_BYTES \
> -     SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES
> -
> -/* offset of the allocation data pointer area */
> -#define SEP_DRIVER_DATA_POOL_ALLOCATION_OFFSET_IN_BYTES \
> -     (SEP_CALLER_ID_OFFSET_BYTES + \
> -     SEP_CALLER_ID_HASH_SIZE_IN_BYTES)
> -
> -/* the token that defines the start of time address */
> -#define SEP_TIME_VAL_TOKEN                                    0x12345678
> -
> -#define FAKE_RAR_SIZE (1024*1024) /* used only for mfld */
> -/* DEBUG LEVEL MASKS */
> -
> -/* size of the caller id hash (sha2) */
> -#define SEP_CALLER_ID_HASH_SIZE_IN_BYTES                      32
> -
> -/* size of the caller id hash (sha2) in 32 bit words */
> -#define SEP_CALLER_ID_HASH_SIZE_IN_WORDS                8
> -
> -/* maximum number of entries in the caller id table */
> -#define SEP_CALLER_ID_TABLE_NUM_ENTRIES                       20
> -
> -/* maximum number of symetric operation (that require DMA resource)
> -     per one message */
> -#define SEP_MAX_NUM_SYNC_DMA_OPS                     16
> -
> -/* the token that defines the start of time address */
> -#define SEP_RAR_VAL_TOKEN                                     0xABABABAB
> -
> -/* ioctl error that should be returned when trying
> -   to realloc the cache/resident second time */
> -#define SEP_ALREADY_INITIALIZED_ERR                           12
> -
> -/* bit that locks access to the shared area */
> -#define SEP_MMAP_LOCK_BIT                                     0
> -
> -/* bit that lock access to the poll  - after send_command */
> -#define SEP_SEND_MSG_LOCK_BIT                                 1
> -
> -/* the token that defines the static pool address address */
> -#define SEP_STATIC_POOL_VAL_TOKEN                             0xABBAABBA
> -
> -/* the token that defines the data pool pointers address */
> -#define SEP_DATA_POOL_POINTERS_VAL_TOKEN                      0xEDDEEDDE
> -
> -/* the token that defines the data pool pointers address */
> -#define SEP_EXT_CACHE_ADDR_VAL_TOKEN                          0xBABABABA
> -
> -/* Time limit for SEP to finish */
> -#define WAIT_TIME 10
> -
> -#endif /* SEP DRIVER CONFIG */
> diff --git a/drivers/staging/sep/sep_driver_hw_defs.h b/drivers/staging/sep/sep_driver_hw_defs.h
> deleted file mode 100644
> index 300f909..0000000
> --- a/drivers/staging/sep/sep_driver_hw_defs.h
> +++ /dev/null
> @@ -1,233 +0,0 @@
> -/*
> - *
> - *  sep_driver_hw_defs.h - Security Processor Driver hardware definitions
> - *
> - *  Copyright(c) 2009,2010 Intel Corporation. All rights reserved.
> - *  Contributions(c) 2009,2010 Discretix. All rights reserved.
> - *
> - *  This program is free software; you can redistribute it and/or modify it
> - *  under the terms of the GNU General Public License as published by the Free
> - *  Software Foundation; version 2 of the License.
> - *
> - *  This program is distributed in the hope that it will be useful, but WITHOUT
> - *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - *  more details.
> - *
> - *  You should have received a copy of the GNU General Public License along with
> - *  this program; if not, write to the Free Software Foundation, Inc., 59
> - *  Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> - *
> - *  CONTACTS:
> - *
> - *  Mark Allyn               mark.a.allyn@intel.com
> - *  Jayant Mangalampalli jayant.mangalampalli@intel.com
> - *
> - *  CHANGES:
> - *
> - *  2010.09.20       Upgrade to Medfield
> - *
> - */
> -
> -#ifndef SEP_DRIVER_HW_DEFS__H
> -#define SEP_DRIVER_HW_DEFS__H
> -
> -/* PCI ID's */
> -#define MFLD_PCI_DEVICE_ID 0x0826
> -
> -/*----------------------- */
> -/* HW Registers Defines.  */
> -/*                        */
> -/*---------------------- -*/
> -
> -
> -/* cf registers */
> -#define              HW_R0B_ADDR_0_REG_ADDR                  0x0000UL
> -#define              HW_R0B_ADDR_1_REG_ADDR                  0x0004UL
> -#define              HW_R0B_ADDR_2_REG_ADDR                  0x0008UL
> -#define              HW_R0B_ADDR_3_REG_ADDR                  0x000cUL
> -#define              HW_R0B_ADDR_4_REG_ADDR                  0x0010UL
> -#define              HW_R0B_ADDR_5_REG_ADDR                  0x0014UL
> -#define              HW_R0B_ADDR_6_REG_ADDR                  0x0018UL
> -#define              HW_R0B_ADDR_7_REG_ADDR                  0x001cUL
> -#define              HW_R0B_ADDR_8_REG_ADDR                  0x0020UL
> -#define              HW_R2B_ADDR_0_REG_ADDR                  0x0080UL
> -#define              HW_R2B_ADDR_1_REG_ADDR                  0x0084UL
> -#define              HW_R2B_ADDR_2_REG_ADDR                  0x0088UL
> -#define              HW_R2B_ADDR_3_REG_ADDR                  0x008cUL
> -#define              HW_R2B_ADDR_4_REG_ADDR                  0x0090UL
> -#define              HW_R2B_ADDR_5_REG_ADDR                  0x0094UL
> -#define              HW_R2B_ADDR_6_REG_ADDR                  0x0098UL
> -#define              HW_R2B_ADDR_7_REG_ADDR                  0x009cUL
> -#define              HW_R2B_ADDR_8_REG_ADDR                  0x00a0UL
> -#define              HW_R3B_REG_ADDR                         0x00C0UL
> -#define              HW_R4B_REG_ADDR                         0x0100UL
> -#define              HW_CSA_ADDR_0_REG_ADDR                  0x0140UL
> -#define              HW_CSA_ADDR_1_REG_ADDR                  0x0144UL
> -#define              HW_CSA_ADDR_2_REG_ADDR                  0x0148UL
> -#define              HW_CSA_ADDR_3_REG_ADDR                  0x014cUL
> -#define              HW_CSA_ADDR_4_REG_ADDR                  0x0150UL
> -#define              HW_CSA_ADDR_5_REG_ADDR                  0x0154UL
> -#define              HW_CSA_ADDR_6_REG_ADDR                  0x0158UL
> -#define              HW_CSA_ADDR_7_REG_ADDR                  0x015cUL
> -#define              HW_CSA_ADDR_8_REG_ADDR                  0x0160UL
> -#define              HW_CSA_REG_ADDR                         0x0140UL
> -#define              HW_SINB_REG_ADDR                        0x0180UL
> -#define              HW_SOUTB_REG_ADDR                       0x0184UL
> -#define              HW_PKI_CONTROL_REG_ADDR                 0x01C0UL
> -#define              HW_PKI_STATUS_REG_ADDR                  0x01C4UL
> -#define              HW_PKI_BUSY_REG_ADDR                    0x01C8UL
> -#define              HW_PKI_A_1025_REG_ADDR                  0x01CCUL
> -#define              HW_PKI_SDMA_CTL_REG_ADDR                0x01D0UL
> -#define              HW_PKI_SDMA_OFFSET_REG_ADDR             0x01D4UL
> -#define              HW_PKI_SDMA_POINTERS_REG_ADDR           0x01D8UL
> -#define              HW_PKI_SDMA_DLENG_REG_ADDR              0x01DCUL
> -#define              HW_PKI_SDMA_EXP_POINTERS_REG_ADDR       0x01E0UL
> -#define              HW_PKI_SDMA_RES_POINTERS_REG_ADDR       0x01E4UL
> -#define              HW_PKI_CLR_REG_ADDR                     0x01E8UL
> -#define              HW_PKI_SDMA_BUSY_REG_ADDR               0x01E8UL
> -#define              HW_PKI_SDMA_FIRST_EXP_N_REG_ADDR        0x01ECUL
> -#define              HW_PKI_SDMA_MUL_BY1_REG_ADDR            0x01F0UL
> -#define              HW_PKI_SDMA_RMUL_SEL_REG_ADDR           0x01F4UL
> -#define              HW_DES_KEY_0_REG_ADDR                   0x0208UL
> -#define              HW_DES_KEY_1_REG_ADDR                   0x020CUL
> -#define              HW_DES_KEY_2_REG_ADDR                   0x0210UL
> -#define              HW_DES_KEY_3_REG_ADDR                   0x0214UL
> -#define              HW_DES_KEY_4_REG_ADDR                   0x0218UL
> -#define              HW_DES_KEY_5_REG_ADDR                   0x021CUL
> -#define              HW_DES_CONTROL_0_REG_ADDR               0x0220UL
> -#define              HW_DES_CONTROL_1_REG_ADDR               0x0224UL
> -#define              HW_DES_IV_0_REG_ADDR                    0x0228UL
> -#define              HW_DES_IV_1_REG_ADDR                    0x022CUL
> -#define              HW_AES_KEY_0_ADDR_0_REG_ADDR            0x0400UL
> -#define              HW_AES_KEY_0_ADDR_1_REG_ADDR            0x0404UL
> -#define              HW_AES_KEY_0_ADDR_2_REG_ADDR            0x0408UL
> -#define              HW_AES_KEY_0_ADDR_3_REG_ADDR            0x040cUL
> -#define              HW_AES_KEY_0_ADDR_4_REG_ADDR            0x0410UL
> -#define              HW_AES_KEY_0_ADDR_5_REG_ADDR            0x0414UL
> -#define              HW_AES_KEY_0_ADDR_6_REG_ADDR            0x0418UL
> -#define              HW_AES_KEY_0_ADDR_7_REG_ADDR            0x041cUL
> -#define              HW_AES_KEY_0_REG_ADDR                   0x0400UL
> -#define              HW_AES_IV_0_ADDR_0_REG_ADDR             0x0440UL
> -#define              HW_AES_IV_0_ADDR_1_REG_ADDR             0x0444UL
> -#define              HW_AES_IV_0_ADDR_2_REG_ADDR             0x0448UL
> -#define              HW_AES_IV_0_ADDR_3_REG_ADDR             0x044cUL
> -#define              HW_AES_IV_0_REG_ADDR                    0x0440UL
> -#define              HW_AES_CTR1_ADDR_0_REG_ADDR             0x0460UL
> -#define              HW_AES_CTR1_ADDR_1_REG_ADDR             0x0464UL
> -#define              HW_AES_CTR1_ADDR_2_REG_ADDR             0x0468UL
> -#define              HW_AES_CTR1_ADDR_3_REG_ADDR             0x046cUL
> -#define              HW_AES_CTR1_REG_ADDR                    0x0460UL
> -#define              HW_AES_SK_REG_ADDR                      0x0478UL
> -#define              HW_AES_MAC_OK_REG_ADDR                  0x0480UL
> -#define              HW_AES_PREV_IV_0_ADDR_0_REG_ADDR        0x0490UL
> -#define              HW_AES_PREV_IV_0_ADDR_1_REG_ADDR        0x0494UL
> -#define              HW_AES_PREV_IV_0_ADDR_2_REG_ADDR        0x0498UL
> -#define              HW_AES_PREV_IV_0_ADDR_3_REG_ADDR        0x049cUL
> -#define              HW_AES_PREV_IV_0_REG_ADDR               0x0490UL
> -#define              HW_AES_CONTROL_REG_ADDR                 0x04C0UL
> -#define              HW_HASH_H0_REG_ADDR                     0x0640UL
> -#define              HW_HASH_H1_REG_ADDR                     0x0644UL
> -#define              HW_HASH_H2_REG_ADDR                     0x0648UL
> -#define              HW_HASH_H3_REG_ADDR                     0x064CUL
> -#define              HW_HASH_H4_REG_ADDR                     0x0650UL
> -#define              HW_HASH_H5_REG_ADDR                     0x0654UL
> -#define              HW_HASH_H6_REG_ADDR                     0x0658UL
> -#define              HW_HASH_H7_REG_ADDR                     0x065CUL
> -#define              HW_HASH_H8_REG_ADDR                     0x0660UL
> -#define              HW_HASH_H9_REG_ADDR                     0x0664UL
> -#define              HW_HASH_H10_REG_ADDR                    0x0668UL
> -#define              HW_HASH_H11_REG_ADDR                    0x066CUL
> -#define              HW_HASH_H12_REG_ADDR                    0x0670UL
> -#define              HW_HASH_H13_REG_ADDR                    0x0674UL
> -#define              HW_HASH_H14_REG_ADDR                    0x0678UL
> -#define              HW_HASH_H15_REG_ADDR                    0x067CUL
> -#define              HW_HASH_CONTROL_REG_ADDR                0x07C0UL
> -#define              HW_HASH_PAD_EN_REG_ADDR                 0x07C4UL
> -#define              HW_HASH_PAD_CFG_REG_ADDR                0x07C8UL
> -#define              HW_HASH_CUR_LEN_0_REG_ADDR              0x07CCUL
> -#define              HW_HASH_CUR_LEN_1_REG_ADDR              0x07D0UL
> -#define              HW_HASH_CUR_LEN_2_REG_ADDR              0x07D4UL
> -#define              HW_HASH_CUR_LEN_3_REG_ADDR              0x07D8UL
> -#define              HW_HASH_PARAM_REG_ADDR                  0x07DCUL
> -#define              HW_HASH_INT_BUSY_REG_ADDR               0x07E0UL
> -#define              HW_HASH_SW_RESET_REG_ADDR               0x07E4UL
> -#define              HW_HASH_ENDIANESS_REG_ADDR              0x07E8UL
> -#define              HW_HASH_DATA_REG_ADDR                   0x07ECUL
> -#define              HW_DRNG_CONTROL_REG_ADDR                0x0800UL
> -#define              HW_DRNG_VALID_REG_ADDR                  0x0804UL
> -#define              HW_DRNG_DATA_REG_ADDR                   0x0808UL
> -#define              HW_RND_SRC_EN_REG_ADDR                  0x080CUL
> -#define              HW_AES_CLK_ENABLE_REG_ADDR              0x0810UL
> -#define              HW_DES_CLK_ENABLE_REG_ADDR              0x0814UL
> -#define              HW_HASH_CLK_ENABLE_REG_ADDR             0x0818UL
> -#define              HW_PKI_CLK_ENABLE_REG_ADDR              0x081CUL
> -#define              HW_CLK_STATUS_REG_ADDR                  0x0824UL
> -#define              HW_CLK_ENABLE_REG_ADDR                  0x0828UL
> -#define              HW_DRNG_SAMPLE_REG_ADDR                 0x0850UL
> -#define              HW_RND_SRC_CTL_REG_ADDR                 0x0858UL
> -#define              HW_CRYPTO_CTL_REG_ADDR                  0x0900UL
> -#define              HW_CRYPTO_STATUS_REG_ADDR               0x090CUL
> -#define              HW_CRYPTO_BUSY_REG_ADDR                 0x0910UL
> -#define              HW_AES_BUSY_REG_ADDR                    0x0914UL
> -#define              HW_DES_BUSY_REG_ADDR                    0x0918UL
> -#define              HW_HASH_BUSY_REG_ADDR                   0x091CUL
> -#define              HW_CONTENT_REG_ADDR                     0x0924UL
> -#define              HW_VERSION_REG_ADDR                     0x0928UL
> -#define              HW_CONTEXT_ID_REG_ADDR                  0x0930UL
> -#define              HW_DIN_BUFFER_REG_ADDR                  0x0C00UL
> -#define              HW_DIN_MEM_DMA_BUSY_REG_ADDR            0x0c20UL
> -#define              HW_SRC_LLI_MEM_ADDR_REG_ADDR            0x0c24UL
> -#define              HW_SRC_LLI_WORD0_REG_ADDR               0x0C28UL
> -#define              HW_SRC_LLI_WORD1_REG_ADDR               0x0C2CUL
> -#define              HW_SRAM_SRC_ADDR_REG_ADDR               0x0c30UL
> -#define              HW_DIN_SRAM_BYTES_LEN_REG_ADDR          0x0c34UL
> -#define              HW_DIN_SRAM_DMA_BUSY_REG_ADDR           0x0C38UL
> -#define              HW_WRITE_ALIGN_REG_ADDR                 0x0C3CUL
> -#define              HW_OLD_DATA_REG_ADDR                    0x0C48UL
> -#define              HW_WRITE_ALIGN_LAST_REG_ADDR            0x0C4CUL
> -#define              HW_DOUT_BUFFER_REG_ADDR                 0x0C00UL
> -#define              HW_DST_LLI_WORD0_REG_ADDR               0x0D28UL
> -#define              HW_DST_LLI_WORD1_REG_ADDR               0x0D2CUL
> -#define              HW_DST_LLI_MEM_ADDR_REG_ADDR            0x0D24UL
> -#define              HW_DOUT_MEM_DMA_BUSY_REG_ADDR           0x0D20UL
> -#define              HW_SRAM_DEST_ADDR_REG_ADDR              0x0D30UL
> -#define              HW_DOUT_SRAM_BYTES_LEN_REG_ADDR         0x0D34UL
> -#define              HW_DOUT_SRAM_DMA_BUSY_REG_ADDR          0x0D38UL
> -#define              HW_READ_ALIGN_REG_ADDR                  0x0D3CUL
> -#define              HW_READ_LAST_DATA_REG_ADDR              0x0D44UL
> -#define              HW_RC4_THRU_CPU_REG_ADDR                0x0D4CUL
> -#define              HW_AHB_SINGLE_REG_ADDR                  0x0E00UL
> -#define              HW_SRAM_DATA_REG_ADDR                   0x0F00UL
> -#define              HW_SRAM_ADDR_REG_ADDR                   0x0F04UL
> -#define              HW_SRAM_DATA_READY_REG_ADDR             0x0F08UL
> -#define              HW_HOST_IRR_REG_ADDR                    0x0A00UL
> -#define              HW_HOST_IMR_REG_ADDR                    0x0A04UL
> -#define              HW_HOST_ICR_REG_ADDR                    0x0A08UL
> -#define              HW_HOST_SEP_SRAM_THRESHOLD_REG_ADDR     0x0A10UL
> -#define              HW_HOST_SEP_BUSY_REG_ADDR               0x0A14UL
> -#define              HW_HOST_SEP_LCS_REG_ADDR                0x0A18UL
> -#define              HW_HOST_CC_SW_RST_REG_ADDR              0x0A40UL
> -#define              HW_HOST_SEP_SW_RST_REG_ADDR             0x0A44UL
> -#define              HW_HOST_FLOW_DMA_SW_INT0_REG_ADDR       0x0A80UL
> -#define              HW_HOST_FLOW_DMA_SW_INT1_REG_ADDR       0x0A84UL
> -#define              HW_HOST_FLOW_DMA_SW_INT2_REG_ADDR       0x0A88UL
> -#define              HW_HOST_FLOW_DMA_SW_INT3_REG_ADDR       0x0A8cUL
> -#define              HW_HOST_FLOW_DMA_SW_INT4_REG_ADDR       0x0A90UL
> -#define              HW_HOST_FLOW_DMA_SW_INT5_REG_ADDR       0x0A94UL
> -#define              HW_HOST_FLOW_DMA_SW_INT6_REG_ADDR       0x0A98UL
> -#define              HW_HOST_FLOW_DMA_SW_INT7_REG_ADDR       0x0A9cUL
> -#define              HW_HOST_SEP_HOST_GPR0_REG_ADDR          0x0B00UL
> -#define              HW_HOST_SEP_HOST_GPR1_REG_ADDR          0x0B04UL
> -#define              HW_HOST_SEP_HOST_GPR2_REG_ADDR          0x0B08UL
> -#define              HW_HOST_SEP_HOST_GPR3_REG_ADDR          0x0B0CUL
> -#define              HW_HOST_HOST_SEP_GPR0_REG_ADDR          0x0B80UL
> -#define              HW_HOST_HOST_SEP_GPR1_REG_ADDR          0x0B84UL
> -#define              HW_HOST_HOST_SEP_GPR2_REG_ADDR          0x0B88UL
> -#define              HW_HOST_HOST_SEP_GPR3_REG_ADDR          0x0B8CUL
> -#define              HW_HOST_HOST_ENDIAN_REG_ADDR            0x0B90UL
> -#define              HW_HOST_HOST_COMM_CLK_EN_REG_ADDR       0x0B94UL
> -#define              HW_CLR_SRAM_BUSY_REG_REG_ADDR           0x0F0CUL
> -#define              HW_CC_SRAM_BASE_ADDRESS                 0x5800UL
> -
> -#endif               /* ifndef HW_DEFS */
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
