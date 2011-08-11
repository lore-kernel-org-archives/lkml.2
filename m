Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1HKSyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:54:06 -0400
Received: from masquerade.micron.com ([137.201.242.130]:39802 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1HKSyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:54:00 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
x-cr-hashedpuzzle: GyHP LXyh TYft TkQQ VwaF V/zi ezIB jH3l ogyd vDiN 0Mam 3nmu /Yg4 /oOG AAIObw== AAetGw==;7;YQBsAGEAbgBAAGwAeABvAHIAZwB1AGsALgB1AGsAdQB1AC4AbwByAGcALgB1AGsAOwBoAGMAaABAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBqAGEAeABiAG8AZQBAAGYAdQBzAGkAbwBuAGkAbwAuAGMAbwBtADsAagBnAGEAcgB6AGkAawBAAHAAbwBiAG8AeAAuAGMAbwBtADsAagBtAG8AeQBlAHIAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAbABpAG4AdQB4AC0AaQBkAGUAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{AC937EE9-AB4C-4E38-B4D9-2D220B1AC55E};YQBzAGEAbQB5AG0AdQB0AGgAdQBwAGEAQABtAGkAYwByAG8AbgAuAGMAbwBtAA==;Thu, 11 Aug 2011 18:52:43 GMT;WwBQAEEAVABDAEgAIAB2ADMAIAAxAC8AMwBdACAAZAByAGkAdgBlAHIAcwAvAGIAbABvAGMAawAvAG0AdABpAHAAMwAyAHgAeAA6ACAAQQBkAGQAaQBuAGcAIABoAGUAYQBkAGUAcgAgAGYAaQBsAGUAIABhAG4AZAAgAHMAbwB1AHIAYwBlACAAZgBvAHIAIABwAGMAaQAgAGEAbgBkACAAYgBsAG8AYwBrACAAcgBlAGwAYQB0AGUAZAAgAG8AcABlAHIAYQB0AGkAbwBuAA==
x-cr-puzzleid: {AC937EE9-AB4C-4E38-B4D9-2D220B1AC55E}
Content-class: urn:content-classes:message
Subject: [PATCH v3 1/3] drivers/block/mtip32xx: Adding header file and source for pci and block related operation
Date: Thu, 11 Aug 2011 12:52:43 -0600
Message-ID: <22A973199D2C2F46933448F6E7990A3002C80025@ntxboimbx31.micron.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v3 1/3] drivers/block/mtip32xx: Adding header file and source for pci and block related operation
Thread-Index: AcxYV9pOUYZ0YVkkQ/eJNByRv9CdlQ==
From: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Moyer" <jmoyer@redhat.com>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jeff Garzik" <jgarzik@pobox.com>,
        "Christoph Hellwig" <hch@infradead.org>,
        "Jens Axboe" <jaxboe@fusionio.com>
Reply-To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	  <asamymuthupa@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first part of the new block driver,mtip32xx, for Micron
PCIe SSD, which contains the header file and source for pci and
block related operations.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.h   |  465
+++++++++++++++++++++++++++++++++
 drivers/block/mtip32xx/mtip_block.c |  484
+++++++++++++++++++++++++++++++++++
 drivers/block/mtip32xx/mtip_pci.c   |  376 +++++++++++++++++++++++++++
 3 files changed, 1325 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/mtip32xx/mtip32xx.h
 create mode 100644 drivers/block/mtip32xx/mtip_block.c
 create mode 100644 drivers/block/mtip32xx/mtip_pci.c

diff --git a/drivers/block/mtip32xx/mtip32xx.h
b/drivers/block/mtip32xx/mtip32xx.h
new file mode 100644
index 0000000..3c45b05
--- /dev/null
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -0,0 +1,465 @@
+/*
+ * mtip32xx.h - Header file for the P320 SSD Block Driver
+ *   Copyright (C) 2011 Micron Technology, Inc.
+ *
+ * Portions of this code were derived from works subjected to the
+ * following copyright:
+ *    Copyright (C) 2009 Integrated Device Technology, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __MTIP32XX_H__
+#define __MTIP32XX_H__
+
+#include <linux/spinlock.h>
+#include <linux/rwsem.h>
+#include <linux/ata.h>
+#include <linux/interrupt.h>
+#include <linux/genhd.h>
+#include <linux/version.h>
+
+#ifndef WIN_SMART
+ #define WIN_SMART       0xB0
+#endif
+
+#ifndef TRUE
+ #define TRUE 1
+#endif
+
+#ifndef FALSE
+ #define FALSE 0
+#endif
+
+/* Offset of Subsystem Device ID in pci confoguration space */
+#define PCI_SUBSYSTEM_DEVICEID	0x2E
+
+/* offset of Device Control register in PCIe extended capabilites space
*/
+#define PCIE_CONFIG_EXT_DEVICE_CONTROL_OFFSET	0x48
+
+/* # of times to retry timed out IOs */
+#define MTIP_MAX_RETRIES	5
+
+/* Various timeout values in ms */
+#define MTIP_NCQ_COMMAND_TIMEOUT_MS       5000
+#define MTIP_IOCTL_COMMAND_TIMEOUT_MS     5000
+#define MTIP_INTERNAL_COMMAND_TIMEOUT_MS  5000
+
+/* check for timeouts every 500ms */
+#define MTIP_TIMEOUT_CHECK_PERIOD	500
+
+/* ftl rebuild */
+#define MTIP_FTL_REBUILD_OFFSET		142
+#define MTIP_FTL_REBUILD_MAGIC		0xed51
+#define MTIP_FTL_REBUILD_TIMEOUT_MS	2400000
+
+/*
+ * Use a tasklet for bottom half IRQ processing.
+ *
+ * Set to 1 to use a tasklet for bottom half IRQ processing.
+ */
+#define MTIP_USE_TASKLET	1
+
+/* Macro to extract the tag bit number from a tag value. */
+#define MTIP_TAG_BIT(tag)	(tag & 0x1f)
+
+/*
+ * Macro to extract the tag index from a tag value. The index
+ * is used to access the correct s_active/Command Issue register based
+ * on the tag value.
+ */
+#define MTIP_TAG_INDEX(tag)	(tag >> 5)
+
+/*
+ * Maximum number of scatter gather entries
+ * a single command may have.
+ */
+#define MTIP_MAX_SG		128
+
+/*
+ * Maximum number of slot groups (Command Issue & s_active registers)
+ * NOTE: This is the driver maximum; check dd->slot_groups for actual
value.
+ */
+#define MTIP_MAX_SLOT_GROUPS	8
+
+/* Internal command tag. */
+#define MTIP_TAG_INTERNAL	0
+
+/* Micron Vendor ID & P320x SSD Device ID */
+#define PCI_VENDOR_ID_MICRON    0x1344
+#define P320_DEVICE_ID		0x5150
+
+/* Driver name and version strings */
+#define MTIP_DRV_NAME		"mtip32xx"
+#define MTIP_DRV_VERSION	"1.2.6os1"
+
+/* Maximum number of minor device numbers per device. */
+#define MTIP_MAX_MINORS		16
+
+/* Maximum number of supported command slots. */
+#define MTIP_MAX_COMMAND_SLOTS	(MTIP_MAX_SLOT_GROUPS * 32)
+
+/*
+ * Per-tag bitfield size in longs.
+ * Linux bit manipulation functions
+ * (i.e. test_and_set_bit, find_next_zero_bit)
+ * manipulate memory in longs, so we try to make the math work.
+ * take the slot groups and find the number of longs, rounding up.
+ * Careful! i386 and x86_64 use different size longs!
+ */
+#define U32_PER_LONG	(sizeof(long) / sizeof(u32))
+#define SLOTBITS_IN_LONGS ((MTIP_MAX_SLOT_GROUPS +
\
+					(U32_PER_LONG-1))/U32_PER_LONG)
+
+/* BAR number used to access the HBA registers. */
+#define MTIP_ABAR		5
+
+/* Forced Unit Access Bit */
+#define FUA_BIT			0x80
+
+#ifdef DEBUG
+ #define dbg_printk(format, arg...)	\
+	printk(pr_fmt(format), ##arg);
+#else
+ #define dbg_printk(format, arg...)
+#endif
+
+/* Register Frame Information Structure (FIS), host to device. */
+struct host_to_dev_fis {
+	/*
+	 * FIS type.
+	 * - 27h Register FIS, host to device.
+	 * - 34h Register FIS, device to host.
+	 * - 39h DMA Activate FIS, device to host.
+	 * - 41h DMA Setup FIS, bi-directional.
+	 * - 46h Data FIS, bi-directional.
+	 * - 58h BIST Activate FIS, bi-directional.
+	 * - 5Fh PIO Setup FIS, device to host.
+	 * - A1h Set Device Bits FIS, device to host.
+	 */
+	unsigned char type;
+	unsigned char opts;
+	unsigned char command;
+	unsigned char features;
+
+	union {
+		unsigned char lba_low;
+		unsigned char sector;
+	};
+	union {
+		unsigned char lba_mid;
+		unsigned char cyl_low;
+	};
+	union {
+		unsigned char lba_hi;
+		unsigned char cyl_hi;
+	};
+	union {
+		unsigned char device;
+		unsigned char head;
+	};
+
+	union {
+		unsigned char lba_low_ex;
+		unsigned char sector_ex;
+	};
+	union {
+		unsigned char lba_mid_ex;
+		unsigned char cyl_low_ex;
+	};
+	union {
+		unsigned char lba_hi_ex;
+		unsigned char cyl_hi_ex;
+	};
+	unsigned char features_ex;
+
+	unsigned char sect_count;
+	unsigned char sect_cnt_ex;
+	unsigned char res2;
+	unsigned char control;
+
+	unsigned int res3;
+};
+
+/* Command header structure. */
+struct mtip_cmd_hdr {
+	/*
+	 * Command options.
+	 * - Bits 31:16 Number of PRD entries.
+	 * - Bits 15:8 Unused in this implementation.
+	 * - Bit 7 Prefetch bit, informs the drive to prefetch PRD
entries.
+	 * - Bit 6 Write bit, should be set when writing data to the
device.
+	 * - Bit 5 Unused in this implementation.
+	 * - Bits 4:0 Length of the command FIS in DWords (DWord = 4
bytes).
+	 */
+	unsigned int opts;
+	/* This field is unsed when using NCQ. */
+	union {
+		unsigned int byte_count;
+		unsigned int status;
+	};
+	/*
+	 * Lower 32 bits of the command table address associated with
this
+	 * header. The command table addresses must be 128 byte aligned.
+	 */
+	unsigned int ctba;
+	/*
+	 * If 64 bit addressing is used this field is the upper 32 bits
+	 * of the command table address associated with this command.
+	 */
+	unsigned int ctbau;
+	/* Reserved and unused. */
+	unsigned int res[4];
+};
+
+/* Command scatter gather structure (PRD). */
+struct mtip_cmd_sg {
+	/*
+	 * Low 32 bits of the data buffer address. For P320 this
+	 * address must be 8 byte aligned signified by bits 2:0 being
+	 * set to 0.
+	 */
+	unsigned int dba;
+	/*
+	 * When 64 bit addressing is used this field is the upper
+	 * 32 bits of the data buffer address.
+	 */
+	unsigned int dba_upper;
+	/* Unused. */
+	unsigned int reserved;
+	/*
+	 * Bit 31: interrupt when this data block has been transferred.
+	 * Bits 30..22: reserved
+	 * Bits 21..0: byte count (minus 1).  For P320 the byte count
must be
+	 * 8 byte aligned signified by bits 2:0 being set to 1.
+	 */
+	unsigned int info;
+};
+struct mtip_port;
+
+/* Structure used to describe a command. */
+struct mtip_cmd {
+
+	struct mtip_cmd_hdr *command_header; /* ptr to command header
entry */
+
+	dma_addr_t command_header_dma; /* corresponding physical address
*/
+
+	void *command; /* ptr to command table entry */
+
+	dma_addr_t command_dma; /* corresponding physical address */
+
+	void *comp_data; /* data passed to completion function
comp_func() */
+	/*
+	 * Completion function called by the ISR upon completion of
+	 * a command.
+	 */
+	void (*comp_func)(struct mtip_port *port,
+				int tag,
+				void *data,
+				int status);
+	/* Additional callback function that may be called by
comp_func() */
+	void (*async_callback)(void *data, int status);
+
+	void *async_data; /* Addl. data passed to async_callback() */
+
+	int scatter_ents; /* Number of scatter list entries used */
+
+	struct scatterlist sg[MTIP_MAX_SG]; /* Scatter list entries */
+
+	int retries; /* The number of retries left for this command. */
+
+	int direction; /* Data transfer direction */
+
+	unsigned long comp_time; /* command completion time, in jiffies
*/
+
+	atomic_t active; /* declares if this command sent to the drive.
*/
+};
+
+/* Structure used to describe a port. */
+struct mtip_port {
+	/* Pointer back to the driver data for this port. */
+	struct driver_data *dd;
+	/*
+	 * Used to determine if the data pointed to by the
+	 * identify field is valid.
+	 */
+	unsigned long identify_valid;
+	/* Base address of the memory mapped IO for the port. */
+	void __iomem *mmio;
+	/* Array of pointers to the memory mapped s_active registers. */
+	void __iomem *s_active[MTIP_MAX_SLOT_GROUPS];
+	/* Array of pointers to the memory mapped completed registers.
*/
+	void __iomem *completed[MTIP_MAX_SLOT_GROUPS];
+	/* Array of pointers to the memory mapped Command Issue
registers. */
+	void __iomem *cmd_issue[MTIP_MAX_SLOT_GROUPS];
+	/*
+	 * Pointer to the beginning of the command header memory as used
+	 * by the driver.
+	 */
+	void *command_list;
+	/*
+	 * Pointer to the beginning of the command header memory as used
+	 * by the DMA.
+	 */
+	dma_addr_t command_list_dma;
+	/*
+	 * Pointer to the beginning of the RX FIS memory as used
+	 * by the driver.
+	 */
+	void *rxfis;
+	/*
+	 * Pointer to the beginning of the RX FIS memory as used
+	 * by the DMA.
+	 */
+	dma_addr_t rxfis_dma;
+	/*
+	 * Pointer to the beginning of the command table memory as used
+	 * by the driver.
+	 */
+	void *command_table;
+	/*
+	 * Pointer to the beginning of the command table memory as used
+	 * by the DMA.
+	 */
+	dma_addr_t command_tbl_dma;
+	/*
+	 * Pointer to the beginning of the identify data memory as used
+	 * by the driver.
+	 */
+	u16 *identify;
+	/*
+	 * Pointer to the beginning of the identify data memory as used
+	 * by the DMA.
+	 */
+	dma_addr_t identify_dma;
+	/*
+	 * Pointer to the beginning of a sector buffer that is used
+	 * by the driver when issuing internal commands.
+	 */
+	u16 *sector_buffer;
+	/*
+	 * Pointer to the beginning of a sector buffer that is used
+	 * by the DMA when the driver issues internal commands.
+	 */
+	dma_addr_t sector_buffer_dma;
+	/*
+	 * Bit significant, used to determine if a command slot has
+	 * been allocated. i.e. the slot is in use.  Bits are cleared
+	 * when the command slot and all associated data structures
+	 * are no longer needed.
+	 */
+	unsigned long allocated[SLOTBITS_IN_LONGS];
+	/*
+	 * Array of command slots. Structure includes pointers to the
+	 * command header and command table, and completion function and
data
+	 * pointers.
+	 */
+	struct mtip_cmd commands[MTIP_MAX_COMMAND_SLOTS];
+	/* Non-zero if an internal command is in progress. */
+	int internal_cmd_in_progress;
+	/*
+	 * Timer used to complete commands that have been active for too
long.
+	 */
+	struct timer_list cmd_timer;
+	/*
+	 * Semaphore used to block threads if there are no
+	 * command slots available.
+	 */
+	struct semaphore cmd_slot;
+	/* Spinlock for working around command-issue bug. */
+	spinlock_t cmd_issue_lock;
+};
+
+/*
+ * Driver private data structure.
+ *
+ * One structure is allocated per probed device.
+ */
+struct driver_data {
+	void __iomem *mmio; /* Base address of the HBA registers. */
+
+	int major; /* Major device number. */
+
+	int instance; /* Instance number. First device probed is 0, ...
*/
+
+	int protocol; /* FIXME: Protocol ops array index. */
+
+	struct gendisk *disk; /* Pointer to our gendisk structure. */
+
+	struct pci_dev *pdev; /* Pointer to the PCI device structure. */
+
+	struct request_queue *queue; /* Our request queue. */
+	/*
+	 * Semaphore used to lock out read/write commands during the
+	 * execution of an internal command.
+	 */
+	struct rw_semaphore internal_sem;
+
+	struct mtip_port *port; /* Pointer to the port data structure.
*/
+#ifdef MTIP_USE_TASKLET
+	/* Tasklet used to process the bottom half of the ISR. */
+	struct tasklet_struct tasklet;
+#endif
+
+	unsigned product_type; /* magic value declaring the product type
*/
+
+	unsigned slot_groups; /* number of slot groups the product
supports */
+
+	atomic_t drv_cleanup_done; /* Atomic variable for SRSI */
+
+	unsigned long index; /* Index to determine the disk name */
+
+	unsigned int ftlrebuildflag; /* FTL rebuild flag */
+
+	atomic_t resumeflag; /* Atomic variable to track suspend/resume
*/
+
+	atomic_t eh_active; /* Flag for error handling tracking */
+};
+
+/* Function declarations */
+extern int mtip_block_initialize(struct driver_data *dd);
+extern int mtip_block_remove(struct driver_data *dd);
+extern int mtip_block_shutdown(struct driver_data *dd);
+extern int mtip_block_suspend(struct driver_data *dd);
+extern int mtip_block_resume(struct driver_data *dd);
+extern int mtip_hw_init(struct driver_data *dd);
+extern int mtip_hw_exit(struct driver_data *dd);
+extern int mtip_hw_shutdown(struct driver_data *dd);
+extern bool mtip_hw_get_capacity(struct driver_data *dd, sector_t
*sectors);
+extern void mtip_hw_release_scatterlist(
+			struct driver_data *dd,
+			int tag);
+extern struct scatterlist *mtip_hw_get_scatterlist(
+			struct driver_data *dd,
+			int *tag);
+extern void mtip_hw_submit_io(struct driver_data *dd,
+			sector_t start,
+			int nsect,
+			int nents,
+			int tag,
+			void *callback,
+			void *data,
+			int barrier,
+			int dir);
+extern int mtip_hw_ioctl(struct driver_data *dd,
+			unsigned int cmd,
+			unsigned long arg,
+			unsigned char compat);
+extern int mtip_hw_sysfs_init(struct driver_data *dd, struct kobject
*kobj);
+extern int mtip_hw_sysfs_exit(struct driver_data *dd, struct kobject
*kobj);
+extern int mtip_hw_resume(struct driver_data *dd);
+extern int mtip_hw_suspend(struct driver_data *dd);
+void mtip_command_cleanup(struct driver_data *dd);
+bool mtip_check_surprise_removal(struct pci_dev *pdev);
+void mtip_restart_port(struct mtip_port *port);
+
+#endif
diff --git a/drivers/block/mtip32xx/mtip_block.c
b/drivers/block/mtip32xx/mtip_block.c
new file mode 100644
index 0000000..8f198c4
--- /dev/null
+++ b/drivers/block/mtip32xx/mtip_block.c
@@ -0,0 +1,484 @@
+/*
+ *  Handle block layer interactions for the P320 SSD Block Driver
+ *   Copyright (C) 2011 Micron Technology, Inc.
+ *
+ * Portions of this code were derived from works subjected to the
+ * following copyright:
+ *    Copyright (C) 2009 Integrated Device Technology, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/hdreg.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/dma-mapping.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/idr.h>
+#include "mtip32xx.h"
+
+static DEFINE_SPINLOCK(rssd_index_lock);
+static DEFINE_IDA(rssd_index_ida);
+
+/*
+ * Helper function for reusing disk name
+ * upon hot insertion.
+ */
+static int rssd_disk_name_format(char *prefix,
+				 int index,
+				 char *buf,
+				 int buflen)
+{
+	const int base = 'z' - 'a' + 1;
+	char *begin = buf + strlen(prefix);
+	char *end = buf + buflen;
+	char *p;
+	int unit;
+
+	p = end - 1;
+	*p = '\0';
+	unit = base;
+	do {
+		if (p == begin)
+			return -EINVAL;
+		*--p = 'a' + (index % unit);
+		index = (index / unit) - 1;
+	} while (index >= 0);
+
+	memmove(begin, p, end - p);
+	memcpy(buf, prefix, strlen(prefix));
+
+	return 0;
+}
+
+/*
+ * Block layer IOCTL handler.
+ *
+ * @dev Pointer to the block_device structure.
+ * @mode ignored
+ * @cmd IOCTL command passed from the user application.
+ * @arg Argument passed from the user application.
+ *
+ * return value
+ *	0        IOCTL completed successfully.
+ *	-ENOTTY  IOCTL not supported or invalid driver data
+ *                 structure pointer.
+ */
+static int mtip_block_ioctl(struct block_device *dev,
+			    fmode_t mode,
+			    unsigned cmd,
+			    unsigned long arg)
+{
+	struct driver_data *dd = dev->bd_disk->private_data;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (!dd)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case BLKFLSBUF:
+		return 0;
+	default:
+		return mtip_hw_ioctl(dd, cmd, arg, 0);
+	}
+}
+
+/*
+ * Block layer compat IOCTL handler.
+ *
+ * @dev Pointer to the block_device structure.
+ * @mode ignored
+ * @cmd IOCTL command passed from the user application.
+ * @arg Argument passed from the user application.
+ *
+ * return value
+ *	0        IOCTL completed successfully.
+ *	-ENOTTY  IOCTL not supported or invalid driver data
+ *                 structure pointer.
+ */
+static int mtip_block_compat_ioctl(struct block_device *dev,
+			    fmode_t mode,
+			    unsigned cmd,
+			    unsigned long arg)
+{
+	struct driver_data *dd = dev->bd_disk->private_data;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (!dd)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case BLKFLSBUF:
+		return 0;
+	default:
+		return mtip_hw_ioctl(dd, cmd, arg, 1);
+	}
+}
+
+/*
+ * Obtain the geometry of the device.
+ *
+ * You may think that this function is obsolete, but some applications,
+ * fdisk for example still used CHS values. This function describes the
+ * device as having 224 heads and 56 sectors per cylinder. These values
are
+ * chosen so that each cylinder is aligned on a 4KB boundary. Since a
+ * partition is described in terms of a start and end cylinder this
means
+ * that each partition is also 4KB aligned. Non-aligned partitions
adversely
+ * affects performance.
+ *
+ * @dev Pointer to the block_device strucutre.
+ * @geo Pointer to a hd_geometry structure.
+ *
+ * return value
+ *	0       Operation completed successfully.
+ *	-ENOTTY An error occurred while reading the drive capacity.
+ */
+static int mtip_block_getgeo(struct block_device *dev,
+				struct hd_geometry *geo)
+{
+	struct driver_data *dd = dev->bd_disk->private_data;
+	sector_t capacity;
+
+	if (!dd)
+		return -ENOTTY;
+
+	if (!(mtip_hw_get_capacity(dd, &capacity))) {
+		dev_warn(&dd->pdev->dev,
+			"Could not get drive capacity.\n");
+		return -ENOTTY;
+	}
+
+	geo->heads = 224;
+	geo->sectors = 56;
+#if BITS_PER_LONG == 64
+	geo->cylinders = capacity / (geo->heads * geo->sectors);
+#else
+	do_div(capacity, (geo->heads * geo->sectors));
+	geo->cylinders = capacity;
+#endif
+	return 0;
+}
+
+/*
+ * Block device operation function.
+ *
+ * This structure contains pointers to the functions required by the
block
+ * layer.
+ */
+static const struct block_device_operations mtip_block_ops = {
+	.ioctl		= mtip_block_ioctl,
+	.compat_ioctl	= mtip_block_compat_ioctl,
+	.getgeo		= mtip_block_getgeo,
+	.owner		= THIS_MODULE
+};
+
+/*
+ * BIO completion function.
+ *
+ * @bio    Pointer to the BIO that has completed.
+ * @status Completion status, 0 = success, non-zero = error.
+ *
+ * return value
+ *	0
+ */
+static int mtip_complete_bio(struct bio *bio, int status)
+{
+	bio_endio(bio, status);
+	return 0;
+}
+
+/*
+ * Block layer make request function.
+ *
+ * This function is called by the kernel to process a BIO for
+ * the P320 device.
+ *
+ * @queue Pointer to the request queue. Unused other than to obtain
+ *              the driver data structure.
+ * @bio   Pointer to the BIO.
+ *
+ * return value
+ *	0
+ */
+static int mtip_make_request(struct request_queue *queue, struct bio
*bio)
+{
+	struct driver_data *dd = queue->queuedata;
+	struct scatterlist *sg;
+	struct bio_vec *bvec;
+	int nents = 0;
+	int tag = 0;
+
+	if (unlikely(!bio_has_data(bio))) {
+		blk_queue_flush(queue, 0);
+		bio_endio(bio, 0);
+		return 0;
+	}
+
+	if (unlikely(atomic_read(&dd->eh_active))) {
+		bio_endio(bio, -EBUSY);
+		return 0;
+	}
+
+	sg = mtip_hw_get_scatterlist(dd, &tag);
+	if (likely(sg != NULL)) {
+		blk_queue_bounce(queue, &bio);
+
+		if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
+			dev_warn(&dd->pdev->dev,
+				"Maximum number of SGL entries
exceeded");
+			bio_io_error(bio);
+			mtip_hw_release_scatterlist(dd, tag);
+			return 0;
+		}
+
+		/* Create the scatter list for this bio. */
+		bio_for_each_segment(bvec, bio, nents) {
+			sg_set_page(&sg[nents],
+					bvec->bv_page,
+					bvec->bv_len,
+					bvec->bv_offset);
+		}
+
+		/* Issue the read/write. */
+		mtip_hw_submit_io(dd,
+				bio->bi_sector,
+				bio_sectors(bio),
+				nents,
+				tag,
+				mtip_complete_bio,
+				bio,
+				bio->bi_rw & REQ_FLUSH,
+				bio_data_dir(bio));
+	} else {
+		bio_io_error(bio);
+	}
+
+	return 0;
+}
+
+/*
+ * Block layer initialization function.
+ *
+ * This function is called once by the PCI layer for each P320
+ * device that is connected to the system.
+ *
+ * @dd Pointer to the driver data structure.
+ *
+ * return value
+ *	0 on success else an error code.
+ */
+int mtip_block_initialize(struct driver_data *dd)
+{
+	int rv = 0;
+	sector_t capacity;
+	unsigned int index = 0;
+	struct kobject *kobj;
+
+	/* Initialize the protocol layer. */
+	rv = mtip_hw_init(dd);
+	if (rv < 0) {
+		dev_err(&dd->pdev->dev,
+			"Protocol layer initialization failed\n");
+		rv = -EINVAL;
+		goto protocol_init_error;
+	}
+
+	/* Allocate the request queue. */
+	dd->queue = blk_alloc_queue(GFP_KERNEL);
+	if (dd->queue == NULL) {
+		dev_err(&dd->pdev->dev,
+			"Unable to allocate request queue\n");
+		rv = -ENOMEM;
+		goto block_queue_alloc_init_error;
+	}
+
+	/* Attach our request function to the request queue. */
+	blk_queue_make_request(dd->queue, mtip_make_request);
+
+	/* Set device limits. */
+	set_bit(QUEUE_FLAG_NOMERGES, &dd->queue->queue_flags);
+	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
+	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
+	blk_queue_physical_block_size(dd->queue, 4096);
+	blk_queue_io_min(dd->queue, 4096);
+
+	dd->disk = alloc_disk(MTIP_MAX_MINORS);
+	if (dd->disk  == NULL) {
+		dev_err(&dd->pdev->dev,
+			"Unable to allocate gendisk structure\n");
+		rv = -EINVAL;
+		goto alloc_disk_error;
+	}
+
+	/* Generate the disk name, implemented same as in sd.c */
+	do {
+		if (!ida_pre_get(&rssd_index_ida, GFP_KERNEL))
+			goto ida_get_error;
+
+		spin_lock(&rssd_index_lock);
+		rv = ida_get_new(&rssd_index_ida, &index);
+		spin_unlock(&rssd_index_lock);
+	} while (rv == -EAGAIN);
+
+	if (rv)
+		goto ida_get_error;
+
+	rv = rssd_disk_name_format("rssd",
+				index,
+				dd->disk->disk_name,
+				DISK_NAME_LEN);
+	if (rv)
+		goto disk_index_error;
+
+	dd->disk->driverfs_dev	= &dd->pdev->dev;
+	dd->disk->major		= dd->major;
+	dd->disk->first_minor	= dd->instance * MTIP_MAX_MINORS;
+	dd->disk->fops		= &mtip_block_ops;
+	dd->disk->queue		= dd->queue;
+	dd->disk->private_data	= dd;
+	dd->queue->queuedata	= dd;
+	dd->index		= index;
+
+	/* Set the capacity of the device in 512 byte sectors. */
+	if (!(mtip_hw_get_capacity(dd, &capacity))) {
+		dev_warn(&dd->pdev->dev,
+			"Could not read drive capacity\n");
+		rv = -EIO;
+		goto read_capacity_error;
+	}
+	set_capacity(dd->disk, capacity);
+
+	/* Enable the block device and add it to /dev */
+	add_disk(dd->disk);
+
+	/*
+	 * Now that the disk is active, initialize any sysfs attributes
+	 * managed by the protocol layer.
+	 */
+	kobj = kobject_get(&disk_to_dev(dd->disk)->kobj);
+	if (kobj) {
+		mtip_hw_sysfs_init(dd, kobj);
+		kobject_put(kobj);
+	}
+
+	return rv;
+
+read_capacity_error:
+	/*
+	 * Delete our gendisk structure. This also removes the device
+	 * from /dev
+	 */
+	del_gendisk(dd->disk);
+
+disk_index_error:
+	spin_lock(&rssd_index_lock);
+	ida_remove(&rssd_index_ida, index);
+	spin_unlock(&rssd_index_lock);
+
+ida_get_error:
+	put_disk(dd->disk);
+
+alloc_disk_error:
+	blk_cleanup_queue(dd->queue);
+
+block_queue_alloc_init_error:
+	/* De-initialize the protocol layer. */
+	mtip_hw_exit(dd);
+
+protocol_init_error:
+	return rv;
+}
+
+/*
+ * Block layer deinitialization function.
+ *
+ * Called by the PCI layer as each P320 device is removed.
+ *
+ * @dd Pointer to the driver data structure.
+ *
+ * return value
+ *	0
+ */
+int mtip_block_remove(struct driver_data *dd)
+{
+	struct kobject *kobj;
+	/* Clean up the sysfs attributes managed by the protocol layer.
*/
+	kobj = kobject_get(&disk_to_dev(dd->disk)->kobj);
+	if (kobj) {
+		mtip_hw_sysfs_exit(dd, kobj);
+		kobject_put(kobj);
+	}
+
+	/*
+	 * Delete our gendisk structure. This also removes the device
+	 * from /dev
+	 */
+	del_gendisk(dd->disk);
+	blk_cleanup_queue(dd->queue);
+	dd->disk  = NULL;
+	dd->queue = NULL;
+
+	/* De-initialize the protocol layer. */
+	mtip_hw_exit(dd);
+
+	return 0;
+}
+
+/*
+ * Function called by the PCI layer when just before the
+ * machine shuts down.
+ *
+ * If a protocol layer shutdown function is present it will be called
+ * by this function.
+ *
+ * @dd Pointer to the driver data structure.
+ *
+ * return value
+ *	0
+ */
+int mtip_block_shutdown(struct driver_data *dd)
+{
+	dev_info(&dd->pdev->dev,
+		"Shutting down %s ...\n", dd->disk->disk_name);
+
+	/* Delete our gendisk structure, and cleanup the blk queue. */
+	del_gendisk(dd->disk);
+	blk_cleanup_queue(dd->queue);
+	dd->disk  = NULL;
+	dd->queue = NULL;
+
+	mtip_hw_shutdown(dd);
+	return 0;
+}
+
+int mtip_block_suspend(struct driver_data *dd)
+{
+	dev_info(&dd->pdev->dev,
+		"Suspending %s ...\n", dd->disk->disk_name);
+	mtip_hw_suspend(dd);
+	return 0;
+}
+
+int mtip_block_resume(struct driver_data *dd)
+{
+	dev_info(&dd->pdev->dev, "Resuming %s ...\n",
+		dd->disk->disk_name);
+	mtip_hw_resume(dd);
+	return 0;
+}
diff --git a/drivers/block/mtip32xx/mtip_pci.c
b/drivers/block/mtip32xx/mtip_pci.c
new file mode 100644
index 0000000..6f241c4
--- /dev/null
+++ b/drivers/block/mtip32xx/mtip_pci.c
@@ -0,0 +1,376 @@
+/*
+ * Handle PCI laye & Module initialization for the P320 SSD Block
Driver
+ *   Copyright (C) 2011 Micron Technology, Inc.
+ *
+ * Portions of this code were derived from works subjected to the
+ * following copyright:
+ *    Copyright (C) 2009 Integrated Device Technology, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include "mtip32xx.h"
+
+/* Device instance number, incremented each time a device is probed. */
+static int instance;
+
+/*
+ * Global variable used to hold the major block device number
+ * allocated in mtip_init().
+ */
+int mtip_major;
+
+/*
+ * Called for each supported PCI device detected.
+ *
+ * This function allocates the private data structure, enables the
+ * PCI device and then calls the block layer initialization function.
+ *
+ * return value
+ *	0 on success else an error code.
+ */
+static int mtip_pci_probe(struct pci_dev *pdev,
+			const struct pci_device_id *ent)
+{
+	int rv = 0;
+	struct driver_data *dd = NULL;
+
+	/* Allocate memory for this devices private data. */
+	dd = kzalloc(sizeof(struct driver_data), GFP_KERNEL);
+	if (dd == NULL) {
+		dev_err(&pdev->dev,
+			"Unable to allocate memory for driver data\n");
+		return -ENOMEM;
+	}
+
+	/* Set the atomic variable as 1 in case of SRSI */
+	atomic_set(&dd->drv_cleanup_done, TRUE);
+
+	atomic_set(&dd->resumeflag, FALSE);
+	atomic_set(&dd->eh_active, 0);
+
+	/* Attach the private data to this PCI device.  */
+	pci_set_drvdata(pdev, dd);
+
+	rv = pcim_enable_device(pdev);
+	if (rv < 0) {
+		dev_err(&pdev->dev, "Unable to enable device\n");
+		goto iomap_err;
+	}
+
+	/* Map BAR5 to memory. */
+	rv = pcim_iomap_regions(pdev, 1 << MTIP_ABAR, MTIP_DRV_NAME);
+	if (rv < 0) {
+		dev_err(&pdev->dev, "Unable to map regions\n");
+		goto iomap_err;
+	}
+
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		rv = pci_set_consistent_dma_mask(pdev,
DMA_BIT_MASK(64));
+
+		if (rv) {
+			rv = pci_set_consistent_dma_mask(pdev,
+						DMA_BIT_MASK(32));
+			if (rv) {
+				dev_warn(&pdev->dev,
+					"64-bit DMA enable failed\n");
+				goto setmask_err;
+			}
+		}
+	}
+
+	pci_set_master(pdev);
+
+#ifdef CONFIG_PCI_MSI
+	if (pci_enable_msi(pdev)) {
+		dev_warn(&pdev->dev,
+			"Unable to enable MSI interrupt.\n");
+		goto block_initialize_err;
+	}
+#endif
+
+	/* Copy the info we may need later into the private data
structure. */
+	dd->major	= mtip_major;
+	dd->protocol	= ent->driver_data;
+	dd->instance	= instance;
+	dd->pdev	= pdev;
+
+	/* Initialize the block layer. */
+	rv = mtip_block_initialize(dd);
+	if (rv < 0) {
+		dev_err(&pdev->dev,
+			"Unable to initialize block layer\n");
+		goto block_initialize_err;
+	}
+
+	/*
+	 * Increment the instance count so that each device has a unique
+	 * instance number.
+	 */
+	instance++;
+
+	goto done;
+
+block_initialize_err:
+#ifdef CONFIG_PCI_MSI
+	pci_disable_msi(pdev);
+#else
+	goto setmask_err;
+#endif
+
+setmask_err:
+	pcim_iounmap_regions(pdev, 1 << MTIP_ABAR);
+
+iomap_err:
+	kfree(dd);
+	pci_set_drvdata(pdev, NULL);
+	return rv;
+done:
+	/* Set the atomic variable as 0 in case of SRSI */
+	atomic_set(&dd->drv_cleanup_done, TRUE);
+
+	return rv;
+}
+
+/*
+ * Called for each probed device when the device is removed or the
+ * driver is unloaded.
+ *
+ * return value
+ *	None
+ */
+static void mtip_pci_remove(struct pci_dev *pdev)
+{
+	struct driver_data *dd = pci_get_drvdata(pdev);
+	int counter = 0;
+
+	if (mtip_check_surprise_removal(pdev)) {
+		while (atomic_read(&dd->drv_cleanup_done) == FALSE) {
+			counter++;
+			msleep(20);
+			if (counter == 10) {
+				/* Cleanup the outstanding commands */
+				mtip_command_cleanup(dd);
+				break;
+			}
+		}
+	}
+	/* Set the atomic variable as 1 in case of SRSI */
+	atomic_set(&dd->drv_cleanup_done, TRUE);
+
+	/* Clean up the block layer. */
+	mtip_block_remove(dd);
+
+#ifdef CONFIG_PCI_MSI
+	pci_disable_msi(pdev);
+#endif
+	kfree(dd);
+	pcim_iounmap_regions(pdev, 1 << MTIP_ABAR);
+}
+
+/*
+ * Called for each probed device when the device is suspended.
+ *
+ * return value
+ *	0  Success
+ *	<0 Error
+ */
+static int mtip_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
+{
+	int rv = 0;
+	struct driver_data *dd = pci_get_drvdata(pdev);
+
+	if (!dd) {
+		dev_err(&pdev->dev,
+			"Driver private datastructure is NULL\n");
+		return -EFAULT;
+	}
+
+	atomic_set(&dd->resumeflag, TRUE);
+
+	/* Disable ports & interrupts then send standby immediate */
+	rv = mtip_block_suspend(dd);
+	if (rv < 0) {
+		dev_err(&pdev->dev,
+			"Failed to suspend controller\n");
+		return rv;
+	}
+
+	/*
+	 * Save the pci config space to pdev structure &
+	 * disable the device
+	 */
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+
+	/* Move to Low power state*/
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return rv;
+}
+
+/*
+ * Called for each probed device when the device is resumed.
+ *
+ * return value
+ *      0  Success
+ *      <0 Error
+ */
+static int mtip_pci_resume(struct pci_dev *pdev)
+{
+	int rv = 0;
+	struct driver_data *dd;
+
+	dd = pci_get_drvdata(pdev);
+	if (!dd) {
+		dev_err(&pdev->dev,
+			"Driver private datastructure is NULL\n");
+		return -EFAULT;
+	}
+
+	/* Move the device to active State */
+	pci_set_power_state(pdev, PCI_D0);
+
+	/* Restore PCI configuration space */
+	pci_restore_state(pdev);
+
+	/* Enable the PCI device*/
+	rv = pcim_enable_device(pdev);
+	if (rv < 0) {
+		dev_err(&pdev->dev,
+			"Failed to enable card during resume\n");
+		goto err;
+	}
+	pci_set_master(pdev);
+
+	/*
+	 * Calls hbaReset, initPort, & startPort function
+	 * then enables interrupts
+	 */
+	rv = mtip_block_resume(dd);
+	if (rv < 0)
+		dev_err(&pdev->dev, "Unable to resume\n");
+
+err:
+	atomic_set(&dd->resumeflag, FALSE);
+
+	return rv;
+}
+
+/*
+ * Shutdown routine
+ *
+ * return value
+ *      None
+ */
+static void mtip_pci_shutdown(struct pci_dev *pdev)
+{
+	struct driver_data *dd = pci_get_drvdata(pdev);
+	if (dd)
+		mtip_block_shutdown(dd);
+}
+
+/*
+ * This function check_for_surprise_removal is called
+ * while card is removed from the system and it will
+ * read the vendor id from the configration space
+ *
+ * @pdev Pointer to the pci_dev structure.
+ *
+ * return value
+ *	 TRUE if device removed, else FALSE
+ */
+bool mtip_check_surprise_removal(struct pci_dev *pdev)
+{
+	u16 vendor_id = 0;
+
+       /* Read the vendorID from the configuration space */
+	pci_read_config_word(pdev, 0x00, &vendor_id);
+	if (vendor_id == 0xFFFF)
+		return TRUE; /* device removed */
+
+	return FALSE; /* device present */
+}
+
+/* Table of device ids supported by this driver. */
+static DEFINE_PCI_DEVICE_TABLE(mtip_pci_tbl) = {
+	{  PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320_DEVICE_ID) },
+	{ 0 }
+};
+
+/* Structure that describes the PCI driver functions. */
+struct pci_driver mtip_pci_driver = {
+	.name			= MTIP_DRV_NAME,
+	.id_table		= mtip_pci_tbl,
+	.probe			= mtip_pci_probe,
+	.remove			= mtip_pci_remove,
+	.suspend		= mtip_pci_suspend,
+	.resume			= mtip_pci_resume,
+	.shutdown		= mtip_pci_shutdown,
+};
+
+MODULE_DEVICE_TABLE(pci, mtip_pci_tbl);
+
+/*
+ * Module initialization function.
+ *
+ * Called once when the module is loaded. This function allocates a
major
+ * block device number to the Cyclone devices and registers the PCI
layer
+ * of the driver.
+ *
+ * Return value
+ *      0 on success else error code.
+ */
+static int __init mtip_init(void)
+{
+	printk(KERN_INFO MTIP_DRV_NAME " Version " MTIP_DRV_VERSION
"\n");
+
+	/* Allocate a major block device number to use with this driver.
*/
+	mtip_major = register_blkdev(0, MTIP_DRV_NAME);
+	if (mtip_major < 0) {
+		printk(KERN_ERR "Unable to register block device
(%d)\n",
+		mtip_major);
+		return -EBUSY;
+	}
+
+	/* Register our PCI operations. */
+	return pci_register_driver(&mtip_pci_driver);
+}
+
+/*
+ * Module de-initialization function.
+ *
+ * Called once when the module is unloaded. This function deallocates
+ * the major block device number allocated by mtip_init() and
+ * unregisters the PCI layer of the driver.
+ *
+ * Return value
+ *      none
+ */
+static void __exit mtip_exit(void)
+{
+	/* Release the allocated major block device number. */
+	unregister_blkdev(mtip_major, MTIP_DRV_NAME);
+
+	/* Unregister the PCI driver. */
+	pci_unregister_driver(&mtip_pci_driver);
+}
+
+MODULE_AUTHOR("Micron Technology, Inc");
+MODULE_DESCRIPTION("Micron RealSSD PCIe Block Driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(MTIP_DRV_VERSION);
+
+module_init(mtip_init);
+module_exit(mtip_exit);
-- 
1.7.1


-- 
Regards,
Asai Thambi
