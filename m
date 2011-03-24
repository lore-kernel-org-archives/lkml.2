Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314Ab1CXUy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934283Ab1CXUyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:54:25 -0400
Date: Thu, 24 Mar 2011 17:54:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 1/2] edac: Move edac main structs to
 include/linux/edac.h
Message-ID: <20110324175418.6e358fd0@pedra>
In-Reply-To: <cover.1300996141.git.mchehab@redhat.com>
References: <cover.1300996141.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we'll need to use those structs for trace functions, they should
be on a more public place. So, move struct mem_ctl_info & friends
to edac.h.

No functional changes on this patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 3d96534..ef0738b 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -34,11 +34,10 @@
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/workqueue.h>
+#include <linux/edac.h>
 
-#define EDAC_MC_LABEL_LEN	31
 #define EDAC_DEVICE_NAME_LEN	31
 #define EDAC_ATTRIB_VALUE_LEN	15
-#define MC_PROC_NAME_MAX_LEN	7
 
 #if PAGE_SHIFT < 20
 #define PAGES_TO_MiB(pages)	((pages) >> (20 - PAGE_SHIFT))
@@ -101,357 +100,6 @@ extern int edac_debug_level;
 
 #define edac_dev_name(dev) (dev)->dev_name
 
-/* memory devices */
-enum dev_type {
-	DEV_UNKNOWN = 0,
-	DEV_X1,
-	DEV_X2,
-	DEV_X4,
-	DEV_X8,
-	DEV_X16,
-	DEV_X32,		/* Do these parts exist? */
-	DEV_X64			/* Do these parts exist? */
-};
-
-#define DEV_FLAG_UNKNOWN	BIT(DEV_UNKNOWN)
-#define DEV_FLAG_X1		BIT(DEV_X1)
-#define DEV_FLAG_X2		BIT(DEV_X2)
-#define DEV_FLAG_X4		BIT(DEV_X4)
-#define DEV_FLAG_X8		BIT(DEV_X8)
-#define DEV_FLAG_X16		BIT(DEV_X16)
-#define DEV_FLAG_X32		BIT(DEV_X32)
-#define DEV_FLAG_X64		BIT(DEV_X64)
-
-/* memory types */
-enum mem_type {
-	MEM_EMPTY = 0,		/* Empty csrow */
-	MEM_RESERVED,		/* Reserved csrow type */
-	MEM_UNKNOWN,		/* Unknown csrow type */
-	MEM_FPM,		/* Fast page mode */
-	MEM_EDO,		/* Extended data out */
-	MEM_BEDO,		/* Burst Extended data out */
-	MEM_SDR,		/* Single data rate SDRAM */
-	MEM_RDR,		/* Registered single data rate SDRAM */
-	MEM_DDR,		/* Double data rate SDRAM */
-	MEM_RDDR,		/* Registered Double data rate SDRAM */
-	MEM_RMBS,		/* Rambus DRAM */
-	MEM_DDR2,		/* DDR2 RAM */
-	MEM_FB_DDR2,		/* fully buffered DDR2 */
-	MEM_RDDR2,		/* Registered DDR2 RAM */
-	MEM_XDR,		/* Rambus XDR */
-	MEM_DDR3,		/* DDR3 RAM */
-	MEM_RDDR3,		/* Registered DDR3 RAM */
-};
-
-#define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
-#define MEM_FLAG_RESERVED	BIT(MEM_RESERVED)
-#define MEM_FLAG_UNKNOWN	BIT(MEM_UNKNOWN)
-#define MEM_FLAG_FPM		BIT(MEM_FPM)
-#define MEM_FLAG_EDO		BIT(MEM_EDO)
-#define MEM_FLAG_BEDO		BIT(MEM_BEDO)
-#define MEM_FLAG_SDR		BIT(MEM_SDR)
-#define MEM_FLAG_RDR		BIT(MEM_RDR)
-#define MEM_FLAG_DDR		BIT(MEM_DDR)
-#define MEM_FLAG_RDDR		BIT(MEM_RDDR)
-#define MEM_FLAG_RMBS		BIT(MEM_RMBS)
-#define MEM_FLAG_DDR2           BIT(MEM_DDR2)
-#define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
-#define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
-#define MEM_FLAG_XDR            BIT(MEM_XDR)
-#define MEM_FLAG_DDR3		 BIT(MEM_DDR3)
-#define MEM_FLAG_RDDR3		 BIT(MEM_RDDR3)
-
-/* chipset Error Detection and Correction capabilities and mode */
-enum edac_type {
-	EDAC_UNKNOWN = 0,	/* Unknown if ECC is available */
-	EDAC_NONE,		/* Doesnt support ECC */
-	EDAC_RESERVED,		/* Reserved ECC type */
-	EDAC_PARITY,		/* Detects parity errors */
-	EDAC_EC,		/* Error Checking - no correction */
-	EDAC_SECDED,		/* Single bit error correction, Double detection */
-	EDAC_S2ECD2ED,		/* Chipkill x2 devices - do these exist? */
-	EDAC_S4ECD4ED,		/* Chipkill x4 devices */
-	EDAC_S8ECD8ED,		/* Chipkill x8 devices */
-	EDAC_S16ECD16ED,	/* Chipkill x16 devices */
-};
-
-#define EDAC_FLAG_UNKNOWN	BIT(EDAC_UNKNOWN)
-#define EDAC_FLAG_NONE		BIT(EDAC_NONE)
-#define EDAC_FLAG_PARITY	BIT(EDAC_PARITY)
-#define EDAC_FLAG_EC		BIT(EDAC_EC)
-#define EDAC_FLAG_SECDED	BIT(EDAC_SECDED)
-#define EDAC_FLAG_S2ECD2ED	BIT(EDAC_S2ECD2ED)
-#define EDAC_FLAG_S4ECD4ED	BIT(EDAC_S4ECD4ED)
-#define EDAC_FLAG_S8ECD8ED	BIT(EDAC_S8ECD8ED)
-#define EDAC_FLAG_S16ECD16ED	BIT(EDAC_S16ECD16ED)
-
-/* scrubbing capabilities */
-enum scrub_type {
-	SCRUB_UNKNOWN = 0,	/* Unknown if scrubber is available */
-	SCRUB_NONE,		/* No scrubber */
-	SCRUB_SW_PROG,		/* SW progressive (sequential) scrubbing */
-	SCRUB_SW_SRC,		/* Software scrub only errors */
-	SCRUB_SW_PROG_SRC,	/* Progressive software scrub from an error */
-	SCRUB_SW_TUNABLE,	/* Software scrub frequency is tunable */
-	SCRUB_HW_PROG,		/* HW progressive (sequential) scrubbing */
-	SCRUB_HW_SRC,		/* Hardware scrub only errors */
-	SCRUB_HW_PROG_SRC,	/* Progressive hardware scrub from an error */
-	SCRUB_HW_TUNABLE	/* Hardware scrub frequency is tunable */
-};
-
-#define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
-#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC)
-#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC)
-#define SCRUB_FLAG_SW_TUN	BIT(SCRUB_SW_SCRUB_TUNABLE)
-#define SCRUB_FLAG_HW_PROG	BIT(SCRUB_HW_PROG)
-#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC)
-#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC)
-#define SCRUB_FLAG_HW_TUN	BIT(SCRUB_HW_TUNABLE)
-
-/* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */
-
-/* EDAC internal operation states */
-#define	OP_ALLOC		0x100
-#define OP_RUNNING_POLL		0x201
-#define OP_RUNNING_INTERRUPT	0x202
-#define OP_RUNNING_POLL_INTR	0x203
-#define OP_OFFLINE		0x300
-
-/*
- * There are several things to be aware of that aren't at all obvious:
- *
- *
- * SOCKETS, SOCKET SETS, BANKS, ROWS, CHIP-SELECT ROWS, CHANNELS, etc..
- *
- * These are some of the many terms that are thrown about that don't always
- * mean what people think they mean (Inconceivable!).  In the interest of
- * creating a common ground for discussion, terms and their definitions
- * will be established.
- *
- * Memory devices:	The individual chip on a memory stick.  These devices
- *			commonly output 4 and 8 bits each.  Grouping several
- *			of these in parallel provides 64 bits which is common
- *			for a memory stick.
- *
- * Memory Stick:	A printed circuit board that agregates multiple
- *			memory devices in parallel.  This is the atomic
- *			memory component that is purchaseable by Joe consumer
- *			and loaded into a memory socket.
- *
- * Socket:		A physical connector on the motherboard that accepts
- *			a single memory stick.
- *
- * Channel:		Set of memory devices on a memory stick that must be
- *			grouped in parallel with one or more additional
- *			channels from other memory sticks.  This parallel
- *			grouping of the output from multiple channels are
- *			necessary for the smallest granularity of memory access.
- *			Some memory controllers are capable of single channel -
- *			which means that memory sticks can be loaded
- *			individually.  Other memory controllers are only
- *			capable of dual channel - which means that memory
- *			sticks must be loaded as pairs (see "socket set").
- *
- * Chip-select row:	All of the memory devices that are selected together.
- *			for a single, minimum grain of memory access.
- *			This selects all of the parallel memory devices across
- *			all of the parallel channels.  Common chip-select rows
- *			for single channel are 64 bits, for dual channel 128
- *			bits.
- *
- * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memory.
- *			Motherboards commonly drive two chip-select pins to
- *			a memory stick. A single-ranked stick, will occupy
- *			only one of those rows. The other will be unused.
- *
- * Double-Ranked stick:	A double-ranked stick has two chip-select rows which
- *			access different sets of memory devices.  The two
- *			rows cannot be accessed concurrently.
- *
- * Double-sided stick:	DEPRECATED TERM, see Double-Ranked stick.
- *			A double-sided stick has two chip-select rows which
- *			access different sets of memory devices.  The two
- *			rows cannot be accessed concurrently.  "Double-sided"
- *			is irrespective of the memory devices being mounted
- *			on both sides of the memory stick.
- *
- * Socket set:		All of the memory sticks that are required for
- *			a single memory access or all of the memory sticks
- *			spanned by a chip-select row.  A single socket set
- *			has two chip-select rows and if double-sided sticks
- *			are used these will occupy those chip-select rows.
- *
- * Bank:		This term is avoided because it is unclear when
- *			needing to distinguish between chip-select rows and
- *			socket sets.
- *
- * Controller pages:
- *
- * Physical pages:
- *
- * Virtual pages:
- *
- *
- * STRUCTURE ORGANIZATION AND CHOICES
- *
- *
- *
- * PS - I enjoyed writing all that about as much as you enjoyed reading it.
- */
-
-struct channel_info {
-	int chan_idx;		/* channel index */
-	u32 ce_count;		/* Correctable Errors for this CHANNEL */
-	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
-	struct csrow_info *csrow;	/* the parent */
-};
-
-struct csrow_info {
-	unsigned long first_page;	/* first page number in dimm */
-	unsigned long last_page;	/* last page number in dimm */
-	unsigned long page_mask;	/* used for interleaving -
-					 * 0UL for non intlv
-					 */
-	u32 nr_pages;		/* number of pages in csrow */
-	u32 grain;		/* granularity of reported error in bytes */
-	int csrow_idx;		/* the chip-select row */
-	enum dev_type dtype;	/* memory device type */
-	u32 ue_count;		/* Uncorrectable Errors for this csrow */
-	u32 ce_count;		/* Correctable Errors for this csrow */
-	enum mem_type mtype;	/* memory csrow type */
-	enum edac_type edac_mode;	/* EDAC mode for this csrow */
-	struct mem_ctl_info *mci;	/* the parent */
-
-	struct kobject kobj;	/* sysfs kobject for this csrow */
-
-	/* channel information for this csrow */
-	u32 nr_channels;
-	struct channel_info *channels;
-};
-
-struct mcidev_sysfs_group {
-	const char *name;				/* group name */
-	const struct mcidev_sysfs_attribute *mcidev_attr; /* group attributes */
-};
-
-struct mcidev_sysfs_group_kobj {
-	struct list_head list;		/* list for all instances within a mc */
-
-	struct kobject kobj;		/* kobj for the group */
-
-	const struct mcidev_sysfs_group *grp;	/* group description table */
-	struct mem_ctl_info *mci;	/* the parent */
-};
-
-/* mcidev_sysfs_attribute structure
- *	used for driver sysfs attributes and in mem_ctl_info
- * 	sysfs top level entries
- */
-struct mcidev_sysfs_attribute {
-	/* It should use either attr or grp */
-	struct attribute attr;
-	const struct mcidev_sysfs_group *grp;	/* Points to a group of attributes */
-
-	/* Ops for show/store values at the attribute - not used on group */
-        ssize_t (*show)(struct mem_ctl_info *,char *);
-        ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
-};
-
-/* MEMORY controller information structure
- */
-struct mem_ctl_info {
-	struct list_head link;	/* for global list of mem_ctl_info structs */
-
-	struct module *owner;	/* Module owner of this control struct */
-
-	unsigned long mtype_cap;	/* memory types supported by mc */
-	unsigned long edac_ctl_cap;	/* Mem controller EDAC capabilities */
-	unsigned long edac_cap;	/* configuration capabilities - this is
-				 * closely related to edac_ctl_cap.  The
-				 * difference is that the controller may be
-				 * capable of s4ecd4ed which would be listed
-				 * in edac_ctl_cap, but if channels aren't
-				 * capable of s4ecd4ed then the edac_cap would
-				 * not have that capability.
-				 */
-	unsigned long scrub_cap;	/* chipset scrub capabilities */
-	enum scrub_type scrub_mode;	/* current scrub mode */
-
-	/* Translates sdram memory scrub rate given in bytes/sec to the
-	   internal representation and configures whatever else needs
-	   to be configured.
-	 */
-	int (*set_sdram_scrub_rate) (struct mem_ctl_info * mci, u32 bw);
-
-	/* Get the current sdram memory scrub rate from the internal
-	   representation and converts it to the closest matching
-	   bandwith in bytes/sec.
-	 */
-	int (*get_sdram_scrub_rate) (struct mem_ctl_info * mci);
-
-
-	/* pointer to edac checking routine */
-	void (*edac_check) (struct mem_ctl_info * mci);
-
-	/*
-	 * Remaps memory pages: controller pages to physical pages.
-	 * For most MC's, this will be NULL.
-	 */
-	/* FIXME - why not send the phys page to begin with? */
-	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
-					   unsigned long page);
-	int mc_idx;
-	int nr_csrows;
-	struct csrow_info *csrows;
-	/*
-	 * FIXME - what about controllers on other busses? - IDs must be
-	 * unique.  dev pointer should be sufficiently unique, but
-	 * BUS:SLOT.FUNC numbers may not be unique.
-	 */
-	struct device *dev;
-	const char *mod_name;
-	const char *mod_ver;
-	const char *ctl_name;
-	const char *dev_name;
-	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
-	void *pvt_info;
-	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
-	u32 ce_noinfo_count;	/* Correctable Errors w/o info */
-	u32 ue_count;		/* Total Uncorrectable Errors for this MC */
-	u32 ce_count;		/* Total Correctable Errors for this MC */
-	unsigned long start_time;	/* mci load start time (in jiffies) */
-
-	/* this stuff is for safe removal of mc devices from global list while
-	 * NMI handlers may be traversing list
-	 */
-	struct rcu_head rcu;
-	struct completion complete;
-
-	/* edac sysfs device control */
-	struct kobject edac_mci_kobj;
-
-	/* list for all grp instances within a mc */
-	struct list_head grp_kobj_list;
-
-	/* Additional top controller level attributes, but specified
-	 * by the low level driver.
-	 *
-	 * Set by the low level driver to provide attributes at the
-	 * controller level, same level as 'ue_count' and 'ce_count' above.
-	 * An array of structures, NULL terminated
-	 *
-	 * If attributes are desired, then set to array of attributes
-	 * If no attributes are desired, leave NULL
-	 */
-	const struct mcidev_sysfs_attribute *mc_driver_sysfs_attributes;
-
-	/* work struct for this MC */
-	struct delayed_work work;
-
-	/* the internal state of this controller instance */
-	int op_state;
-};
-
 /*
  * The following are the structures to provide for a generic
  * or abstract 'edac_device'. This set of structures and the
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 36c6644..12d0b45 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -42,4 +42,358 @@ static inline void opstate_init(void)
 	return;
 }
 
+#define EDAC_MC_LABEL_LEN	31
+#define MC_PROC_NAME_MAX_LEN	7
+
+/* memory devices */
+enum dev_type {
+	DEV_UNKNOWN = 0,
+	DEV_X1,
+	DEV_X2,
+	DEV_X4,
+	DEV_X8,
+	DEV_X16,
+	DEV_X32,		/* Do these parts exist? */
+	DEV_X64			/* Do these parts exist? */
+};
+
+#define DEV_FLAG_UNKNOWN	BIT(DEV_UNKNOWN)
+#define DEV_FLAG_X1		BIT(DEV_X1)
+#define DEV_FLAG_X2		BIT(DEV_X2)
+#define DEV_FLAG_X4		BIT(DEV_X4)
+#define DEV_FLAG_X8		BIT(DEV_X8)
+#define DEV_FLAG_X16		BIT(DEV_X16)
+#define DEV_FLAG_X32		BIT(DEV_X32)
+#define DEV_FLAG_X64		BIT(DEV_X64)
+
+/* memory types */
+enum mem_type {
+	MEM_EMPTY = 0,		/* Empty csrow */
+	MEM_RESERVED,		/* Reserved csrow type */
+	MEM_UNKNOWN,		/* Unknown csrow type */
+	MEM_FPM,		/* Fast page mode */
+	MEM_EDO,		/* Extended data out */
+	MEM_BEDO,		/* Burst Extended data out */
+	MEM_SDR,		/* Single data rate SDRAM */
+	MEM_RDR,		/* Registered single data rate SDRAM */
+	MEM_DDR,		/* Double data rate SDRAM */
+	MEM_RDDR,		/* Registered Double data rate SDRAM */
+	MEM_RMBS,		/* Rambus DRAM */
+	MEM_DDR2,		/* DDR2 RAM */
+	MEM_FB_DDR2,		/* fully buffered DDR2 */
+	MEM_RDDR2,		/* Registered DDR2 RAM */
+	MEM_XDR,		/* Rambus XDR */
+	MEM_DDR3,		/* DDR3 RAM */
+	MEM_RDDR3,		/* Registered DDR3 RAM */
+};
+
+#define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
+#define MEM_FLAG_RESERVED	BIT(MEM_RESERVED)
+#define MEM_FLAG_UNKNOWN	BIT(MEM_UNKNOWN)
+#define MEM_FLAG_FPM		BIT(MEM_FPM)
+#define MEM_FLAG_EDO		BIT(MEM_EDO)
+#define MEM_FLAG_BEDO		BIT(MEM_BEDO)
+#define MEM_FLAG_SDR		BIT(MEM_SDR)
+#define MEM_FLAG_RDR		BIT(MEM_RDR)
+#define MEM_FLAG_DDR		BIT(MEM_DDR)
+#define MEM_FLAG_RDDR		BIT(MEM_RDDR)
+#define MEM_FLAG_RMBS		BIT(MEM_RMBS)
+#define MEM_FLAG_DDR2           BIT(MEM_DDR2)
+#define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
+#define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
+#define MEM_FLAG_XDR            BIT(MEM_XDR)
+#define MEM_FLAG_DDR3		 BIT(MEM_DDR3)
+#define MEM_FLAG_RDDR3		 BIT(MEM_RDDR3)
+
+/* chipset Error Detection and Correction capabilities and mode */
+enum edac_type {
+	EDAC_UNKNOWN = 0,	/* Unknown if ECC is available */
+	EDAC_NONE,		/* Doesnt support ECC */
+	EDAC_RESERVED,		/* Reserved ECC type */
+	EDAC_PARITY,		/* Detects parity errors */
+	EDAC_EC,		/* Error Checking - no correction */
+	EDAC_SECDED,		/* Single bit error correction, Double detection */
+	EDAC_S2ECD2ED,		/* Chipkill x2 devices - do these exist? */
+	EDAC_S4ECD4ED,		/* Chipkill x4 devices */
+	EDAC_S8ECD8ED,		/* Chipkill x8 devices */
+	EDAC_S16ECD16ED,	/* Chipkill x16 devices */
+};
+
+#define EDAC_FLAG_UNKNOWN	BIT(EDAC_UNKNOWN)
+#define EDAC_FLAG_NONE		BIT(EDAC_NONE)
+#define EDAC_FLAG_PARITY	BIT(EDAC_PARITY)
+#define EDAC_FLAG_EC		BIT(EDAC_EC)
+#define EDAC_FLAG_SECDED	BIT(EDAC_SECDED)
+#define EDAC_FLAG_S2ECD2ED	BIT(EDAC_S2ECD2ED)
+#define EDAC_FLAG_S4ECD4ED	BIT(EDAC_S4ECD4ED)
+#define EDAC_FLAG_S8ECD8ED	BIT(EDAC_S8ECD8ED)
+#define EDAC_FLAG_S16ECD16ED	BIT(EDAC_S16ECD16ED)
+
+/* scrubbing capabilities */
+enum scrub_type {
+	SCRUB_UNKNOWN = 0,	/* Unknown if scrubber is available */
+	SCRUB_NONE,		/* No scrubber */
+	SCRUB_SW_PROG,		/* SW progressive (sequential) scrubbing */
+	SCRUB_SW_SRC,		/* Software scrub only errors */
+	SCRUB_SW_PROG_SRC,	/* Progressive software scrub from an error */
+	SCRUB_SW_TUNABLE,	/* Software scrub frequency is tunable */
+	SCRUB_HW_PROG,		/* HW progressive (sequential) scrubbing */
+	SCRUB_HW_SRC,		/* Hardware scrub only errors */
+	SCRUB_HW_PROG_SRC,	/* Progressive hardware scrub from an error */
+	SCRUB_HW_TUNABLE	/* Hardware scrub frequency is tunable */
+};
+
+#define SCRUB_FLAG_SW_PROG	BIT(SCRUB_SW_PROG)
+#define SCRUB_FLAG_SW_SRC	BIT(SCRUB_SW_SRC)
+#define SCRUB_FLAG_SW_PROG_SRC	BIT(SCRUB_SW_PROG_SRC)
+#define SCRUB_FLAG_SW_TUN	BIT(SCRUB_SW_SCRUB_TUNABLE)
+#define SCRUB_FLAG_HW_PROG	BIT(SCRUB_HW_PROG)
+#define SCRUB_FLAG_HW_SRC	BIT(SCRUB_HW_SRC)
+#define SCRUB_FLAG_HW_PROG_SRC	BIT(SCRUB_HW_PROG_SRC)
+#define SCRUB_FLAG_HW_TUN	BIT(SCRUB_HW_TUNABLE)
+
+/* FIXME - should have notify capabilities: NMI, LOG, PROC, etc */
+
+/* EDAC internal operation states */
+#define	OP_ALLOC		0x100
+#define OP_RUNNING_POLL		0x201
+#define OP_RUNNING_INTERRUPT	0x202
+#define OP_RUNNING_POLL_INTR	0x203
+#define OP_OFFLINE		0x300
+
+/*
+ * There are several things to be aware of that aren't at all obvious:
+ *
+ *
+ * SOCKETS, SOCKET SETS, BANKS, ROWS, CHIP-SELECT ROWS, CHANNELS, etc..
+ *
+ * These are some of the many terms that are thrown about that don't always
+ * mean what people think they mean (Inconceivable!).  In the interest of
+ * creating a common ground for discussion, terms and their definitions
+ * will be established.
+ *
+ * Memory devices:	The individual chip on a memory stick.  These devices
+ *			commonly output 4 and 8 bits each.  Grouping several
+ *			of these in parallel provides 64 bits which is common
+ *			for a memory stick.
+ *
+ * Memory Stick:	A printed circuit board that agregates multiple
+ *			memory devices in parallel.  This is the atomic
+ *			memory component that is purchaseable by Joe consumer
+ *			and loaded into a memory socket.
+ *
+ * Socket:		A physical connector on the motherboard that accepts
+ *			a single memory stick.
+ *
+ * Channel:		Set of memory devices on a memory stick that must be
+ *			grouped in parallel with one or more additional
+ *			channels from other memory sticks.  This parallel
+ *			grouping of the output from multiple channels are
+ *			necessary for the smallest granularity of memory access.
+ *			Some memory controllers are capable of single channel -
+ *			which means that memory sticks can be loaded
+ *			individually.  Other memory controllers are only
+ *			capable of dual channel - which means that memory
+ *			sticks must be loaded as pairs (see "socket set").
+ *
+ * Chip-select row:	All of the memory devices that are selected together.
+ *			for a single, minimum grain of memory access.
+ *			This selects all of the parallel memory devices across
+ *			all of the parallel channels.  Common chip-select rows
+ *			for single channel are 64 bits, for dual channel 128
+ *			bits.
+ *
+ * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memory.
+ *			Motherboards commonly drive two chip-select pins to
+ *			a memory stick. A single-ranked stick, will occupy
+ *			only one of those rows. The other will be unused.
+ *
+ * Double-Ranked stick:	A double-ranked stick has two chip-select rows which
+ *			access different sets of memory devices.  The two
+ *			rows cannot be accessed concurrently.
+ *
+ * Double-sided stick:	DEPRECATED TERM, see Double-Ranked stick.
+ *			A double-sided stick has two chip-select rows which
+ *			access different sets of memory devices.  The two
+ *			rows cannot be accessed concurrently.  "Double-sided"
+ *			is irrespective of the memory devices being mounted
+ *			on both sides of the memory stick.
+ *
+ * Socket set:		All of the memory sticks that are required for
+ *			a single memory access or all of the memory sticks
+ *			spanned by a chip-select row.  A single socket set
+ *			has two chip-select rows and if double-sided sticks
+ *			are used these will occupy those chip-select rows.
+ *
+ * Bank:		This term is avoided because it is unclear when
+ *			needing to distinguish between chip-select rows and
+ *			socket sets.
+ *
+ * Controller pages:
+ *
+ * Physical pages:
+ *
+ * Virtual pages:
+ *
+ *
+ * STRUCTURE ORGANIZATION AND CHOICES
+ *
+ *
+ *
+ * PS - I enjoyed writing all that about as much as you enjoyed reading it.
+ */
+
+struct channel_info {
+	int chan_idx;		/* channel index */
+	u32 ce_count;		/* Correctable Errors for this CHANNEL */
+	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
+	struct csrow_info *csrow;	/* the parent */
+};
+
+struct csrow_info {
+	unsigned long first_page;	/* first page number in dimm */
+	unsigned long last_page;	/* last page number in dimm */
+	unsigned long page_mask;	/* used for interleaving -
+					 * 0UL for non intlv
+					 */
+	u32 nr_pages;		/* number of pages in csrow */
+	u32 grain;		/* granularity of reported error in bytes */
+	int csrow_idx;		/* the chip-select row */
+	enum dev_type dtype;	/* memory device type */
+	u32 ue_count;		/* Uncorrectable Errors for this csrow */
+	u32 ce_count;		/* Correctable Errors for this csrow */
+	enum mem_type mtype;	/* memory csrow type */
+	enum edac_type edac_mode;	/* EDAC mode for this csrow */
+	struct mem_ctl_info *mci;	/* the parent */
+
+	struct kobject kobj;	/* sysfs kobject for this csrow */
+
+	/* channel information for this csrow */
+	u32 nr_channels;
+	struct channel_info *channels;
+};
+
+struct mcidev_sysfs_group {
+	const char *name;				/* group name */
+	const struct mcidev_sysfs_attribute *mcidev_attr; /* group attributes */
+};
+
+struct mcidev_sysfs_group_kobj {
+	struct list_head list;		/* list for all instances within a mc */
+
+	struct kobject kobj;		/* kobj for the group */
+
+	const struct mcidev_sysfs_group *grp;	/* group description table */
+	struct mem_ctl_info *mci;	/* the parent */
+};
+
+/* mcidev_sysfs_attribute structure
+ *	used for driver sysfs attributes and in mem_ctl_info
+ * 	sysfs top level entries
+ */
+struct mcidev_sysfs_attribute {
+	/* It should use either attr or grp */
+	struct attribute attr;
+	const struct mcidev_sysfs_group *grp;	/* Points to a group of attributes */
+
+	/* Ops for show/store values at the attribute - not used on group */
+        ssize_t (*show)(struct mem_ctl_info *,char *);
+        ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
+};
+
+/* MEMORY controller information structure
+ */
+struct mem_ctl_info {
+	struct list_head link;	/* for global list of mem_ctl_info structs */
+
+	struct module *owner;	/* Module owner of this control struct */
+
+	unsigned long mtype_cap;	/* memory types supported by mc */
+	unsigned long edac_ctl_cap;	/* Mem controller EDAC capabilities */
+	unsigned long edac_cap;	/* configuration capabilities - this is
+				 * closely related to edac_ctl_cap.  The
+				 * difference is that the controller may be
+				 * capable of s4ecd4ed which would be listed
+				 * in edac_ctl_cap, but if channels aren't
+				 * capable of s4ecd4ed then the edac_cap would
+				 * not have that capability.
+				 */
+	unsigned long scrub_cap;	/* chipset scrub capabilities */
+	enum scrub_type scrub_mode;	/* current scrub mode */
+
+	/* Translates sdram memory scrub rate given in bytes/sec to the
+	   internal representation and configures whatever else needs
+	   to be configured.
+	 */
+	int (*set_sdram_scrub_rate) (struct mem_ctl_info * mci, u32 bw);
+
+	/* Get the current sdram memory scrub rate from the internal
+	   representation and converts it to the closest matching
+	   bandwith in bytes/sec.
+	 */
+	int (*get_sdram_scrub_rate) (struct mem_ctl_info * mci);
+
+
+	/* pointer to edac checking routine */
+	void (*edac_check) (struct mem_ctl_info * mci);
+
+	/*
+	 * Remaps memory pages: controller pages to physical pages.
+	 * For most MC's, this will be NULL.
+	 */
+	/* FIXME - why not send the phys page to begin with? */
+	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
+					   unsigned long page);
+	int mc_idx;
+	int nr_csrows;
+	struct csrow_info *csrows;
+	/*
+	 * FIXME - what about controllers on other busses? - IDs must be
+	 * unique.  dev pointer should be sufficiently unique, but
+	 * BUS:SLOT.FUNC numbers may not be unique.
+	 */
+	struct device *dev;
+	const char *mod_name;
+	const char *mod_ver;
+	const char *ctl_name;
+	const char *dev_name;
+	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
+	void *pvt_info;
+	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
+	u32 ce_noinfo_count;	/* Correctable Errors w/o info */
+	u32 ue_count;		/* Total Uncorrectable Errors for this MC */
+	u32 ce_count;		/* Total Correctable Errors for this MC */
+	unsigned long start_time;	/* mci load start time (in jiffies) */
+
+	/* this stuff is for safe removal of mc devices from global list while
+	 * NMI handlers may be traversing list
+	 */
+	struct rcu_head rcu;
+	struct completion complete;
+
+	/* edac sysfs device control */
+	struct kobject edac_mci_kobj;
+
+	/* list for all grp instances within a mc */
+	struct list_head grp_kobj_list;
+
+	/* Additional top controller level attributes, but specified
+	 * by the low level driver.
+	 *
+	 * Set by the low level driver to provide attributes at the
+	 * controller level, same level as 'ue_count' and 'ce_count' above.
+	 * An array of structures, NULL terminated
+	 *
+	 * If attributes are desired, then set to array of attributes
+	 * If no attributes are desired, leave NULL
+	 */
+	const struct mcidev_sysfs_attribute *mc_driver_sysfs_attributes;
+
+	/* work struct for this MC */
+	struct delayed_work work;
+
+	/* the internal state of this controller instance */
+	int op_state;
+};
+
 #endif
-- 
1.7.1


