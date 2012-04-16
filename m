Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab2DPUOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab2DPUOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:14:03 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [EDAC PATCH v13 4/7] edac: move nr_pages to dimm struct
Date: Mon, 16 Apr 2012 17:12:10 -0300
Message-Id: <1334607133-30039-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of pages is a dimm property. Move it to the dimm struct.

After this change, it is possible to add sysfs nodes for the DIMM's that
will properly represent the DIMM stick properties, including its size.

A TODO fix here is to properly represent dual-rank/quad-rank DIMMs when
the memory controller represents the memory via chip select rows.

Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Mark Gross <mark.gross@intel.com>
Cc: Jason Uhlenkott <juhlenko@akamai.com>
Cc: Tim Small <tim@buttersideup.com>
Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
Cc: "Arvind R." <arvino55@gmail.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Egor Martovetsky <egor@pasemi.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hitoshi Mitake <h.mitake@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Niklas Söderlund" <niklas.soderlund@ericsson.com>
Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/amd64_edac.c      |   12 +++------
 drivers/edac/amd76x_edac.c     |    6 ++--
 drivers/edac/cell_edac.c       |    8 ++++--
 drivers/edac/cpc925_edac.c     |    8 ++++--
 drivers/edac/e752x_edac.c      |    6 +++-
 drivers/edac/e7xxx_edac.c      |    5 ++-
 drivers/edac/edac_mc.c         |   16 ++++++++-----
 drivers/edac/edac_mc_sysfs.c   |   47 ++++++++++++++++++++++++++++------------
 drivers/edac/i3000_edac.c      |    6 +++-
 drivers/edac/i3200_edac.c      |    3 +-
 drivers/edac/i5000_edac.c      |   14 ++++++-----
 drivers/edac/i5100_edac.c      |   22 +++++++++++-------
 drivers/edac/i5400_edac.c      |    9 ++-----
 drivers/edac/i7300_edac.c      |   22 +++++-------------
 drivers/edac/i7core_edac.c     |   10 ++------
 drivers/edac/i82443bxgx_edac.c |    2 +-
 drivers/edac/i82860_edac.c     |    2 +-
 drivers/edac/i82875p_edac.c    |    5 ++-
 drivers/edac/i82975x_edac.c    |   11 ++++++--
 drivers/edac/mpc85xx_edac.c    |    3 +-
 drivers/edac/mv64x60_edac.c    |    3 +-
 drivers/edac/pasemi_edac.c     |   14 ++++++------
 drivers/edac/ppc4xx_edac.c     |    5 ++-
 drivers/edac/r82600_edac.c     |    3 +-
 drivers/edac/sb_edac.c         |    8 +-----
 drivers/edac/tile_edac.c       |    2 +-
 drivers/edac/x38_edac.c        |    4 +-
 include/linux/edac.h           |    8 ++++--
 28 files changed, 144 insertions(+), 120 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 0be3f29..8804ac8 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2126,12 +2126,6 @@ static u32 amd64_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
 
 	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode) << (20 - PAGE_SHIFT);
 
-	/*
-	 * If dual channel then double the memory size of single channel.
-	 * Channel count is 1 or 2
-	 */
-	nr_pages <<= (pvt->channel_count - 1);
-
 	debugf0("  (csrow=%d) DBAM map index= %d\n", csrow_nr, cs_mode);
 	debugf0("    nr_pages= %u  channel-count = %d\n",
 		nr_pages, pvt->channel_count);
@@ -2152,6 +2146,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 	int i, j, empty = 1;
 	enum mem_type mtype;
 	enum edac_type edac_mode;
+	int nr_pages;
 
 	amd64_read_pci_cfg(pvt->F3, NBCFG, &val);
 
@@ -2174,14 +2169,14 @@ static int init_csrows(struct mem_ctl_info *mci)
 			i, pvt->mc_node_id);
 
 		empty = 0;
-		csrow->nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
+		nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
 		get_cs_base_and_mask(pvt, i, 0, &base, &mask);
 		/* 8 bytes of resolution */
 
 		mtype = amd64_determine_memory_type(pvt, i);
 
 		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
-		debugf1("    nr_pages: %u\n", csrow->nr_pages);
+		debugf1("    nr_pages: %u\n", nr_pages);
 
 		/*
 		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
@@ -2195,6 +2190,7 @@ static int init_csrows(struct mem_ctl_info *mci)
 		for (j = 0; j < pvt->channel_count; j++) {
 			csrow->channels[j].dimm->mtype = mtype;
 			csrow->channels[j].dimm->edac_mode = edac_mode;
+			csrow->channels[j].dimm->nr_pages = nr_pages;
 		}
 	}
 
diff --git a/drivers/edac/amd76x_edac.c b/drivers/edac/amd76x_edac.c
index 2a63ed0..1532750 100644
--- a/drivers/edac/amd76x_edac.c
+++ b/drivers/edac/amd76x_edac.c
@@ -205,10 +205,10 @@ static void amd76x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 		mba_mask = ((mba & 0xff80) << 16) | 0x7fffffUL;
 		pci_read_config_dword(pdev, AMD76X_DRAM_MODE_STATUS, &dms);
 		csrow->first_page = mba_base >> PAGE_SHIFT;
-		csrow->nr_pages = (mba_mask + 1) >> PAGE_SHIFT;
-		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
+		dimm->nr_pages = (mba_mask + 1) >> PAGE_SHIFT;
+		csrow->last_page = csrow->first_page + dimm->nr_pages - 1;
 		csrow->page_mask = mba_mask >> PAGE_SHIFT;
-		dimm->grain = csrow->nr_pages << PAGE_SHIFT;
+		dimm->grain = dimm->nr_pages << PAGE_SHIFT;
 		dimm->mtype = MEM_RDDR;
 		dimm->dtype = ((dms >> index) & 0x1) ? DEV_X4 : DEV_UNKNOWN;
 		dimm->edac_mode = edac_mode;
diff --git a/drivers/edac/cell_edac.c b/drivers/edac/cell_edac.c
index 94fbb12..09e1b5d 100644
--- a/drivers/edac/cell_edac.c
+++ b/drivers/edac/cell_edac.c
@@ -128,6 +128,7 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 	struct cell_edac_priv		*priv = mci->pvt_info;
 	struct device_node		*np;
 	int				j;
+	u32				nr_pages;
 
 	for (np = NULL;
 	     (np = of_find_node_by_name(np, "memory")) != NULL;) {
@@ -142,19 +143,20 @@ static void __devinit cell_edac_init_csrows(struct mem_ctl_info *mci)
 		if (of_node_to_nid(np) != priv->node)
 			continue;
 		csrow->first_page = r.start >> PAGE_SHIFT;
-		csrow->nr_pages = resource_size(&r) >> PAGE_SHIFT;
-		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
+		nr_pages = resource_size(&r) >> PAGE_SHIFT;
+		csrow->last_page = csrow->first_page + nr_pages - 1;
 
 		for (j = 0; j < csrow->nr_channels; j++) {
 			dimm = csrow->channels[j].dimm;
 			dimm->mtype = MEM_XDR;
 			dimm->edac_mode = EDAC_SECDED;
+			dimm->nr_pages = nr_pages / csrow->nr_channels;
 		}
 		dev_dbg(mci->dev,
 			"Initialized on node %d, chanmask=0x%x,"
 			" first_page=0x%lx, nr_pages=0x%x\n",
 			priv->node, priv->chanmask,
-			csrow->first_page, csrow->nr_pages);
+			csrow->first_page, dimm->nr_pages);
 		break;
 	}
 }
diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index ee90f3d..7b764a8 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -332,7 +332,7 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 	struct dimm_info *dimm;
 	int index, j;
 	u32 mbmr, mbbar, bba;
-	unsigned long row_size, last_nr_pages = 0;
+	unsigned long row_size, nr_pages, last_nr_pages = 0;
 
 	get_total_mem(pdata);
 
@@ -351,12 +351,14 @@ static void cpc925_init_csrows(struct mem_ctl_info *mci)
 
 		row_size = bba * (1UL << 28);	/* 256M */
 		csrow->first_page = last_nr_pages;
-		csrow->nr_pages = row_size >> PAGE_SHIFT;
-		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
+		nr_pages = row_size >> PAGE_SHIFT;
+		csrow->last_page = csrow->first_page + nr_pages - 1;
 		last_nr_pages = csrow->last_page + 1;
 
 		for (j = 0; j < csrow->nr_channels; j++) {
 			dimm = csrow->channels[j].dimm;
+
+			dimm->nr_pages = nr_pages / csrow->nr_channels;
 			dimm->mtype = MEM_RDDR;
 			dimm->edac_mode = EDAC_SECDED;
 
diff --git a/drivers/edac/e752x_edac.c b/drivers/edac/e752x_edac.c
index db291ea..6d81d3c 100644
--- a/drivers/edac/e752x_edac.c
+++ b/drivers/edac/e752x_edac.c
@@ -1044,7 +1044,7 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	int drc_drbg;		/* DRB granularity 0=64mb, 1=128mb */
 	int drc_ddim;		/* DRAM Data Integrity Mode 0=none, 2=edac */
 	u8 value;
-	u32 dra, drc, cumul_size, i;
+	u32 dra, drc, cumul_size, i, nr_pages;
 
 	dra = 0;
 	for (index = 0; index < 4; index++) {
@@ -1078,11 +1078,13 @@ static void e752x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
-		csrow->nr_pages = cumul_size - last_cumul_size;
+		nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 
 		for (i = 0; i < drc_chan + 1; i++) {
 			struct dimm_info *dimm = csrow->channels[i].dimm;
+
+			dimm->nr_pages = nr_pages / (drc_chan + 1);
 			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
 			dimm->mtype = MEM_RDDR;	/* only one type supported */
 			dimm->dtype = mem_dev ? DEV_X4 : DEV_X8;
diff --git a/drivers/edac/e7xxx_edac.c b/drivers/edac/e7xxx_edac.c
index 178d2af..aeb69f0 100644
--- a/drivers/edac/e7xxx_edac.c
+++ b/drivers/edac/e7xxx_edac.c
@@ -349,7 +349,7 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 	unsigned long last_cumul_size;
 	int index, j;
 	u8 value;
-	u32 dra, cumul_size;
+	u32 dra, cumul_size, nr_pages;
 	int drc_chan, drc_drbg, drc_ddim, mem_dev;
 	struct csrow_info *csrow;
 	struct dimm_info *dimm;
@@ -380,12 +380,13 @@ static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
-		csrow->nr_pages = cumul_size - last_cumul_size;
+		nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 
 		for (j = 0; j < drc_chan + 1; j++) {
 			dimm = csrow->channels[j].dimm;
 
+			dimm->nr_pages = nr_pages / (drc_chan + 1);
 			dimm->grain = 1 << 12;	/* 4KiB - resolution of CELOG */
 			dimm->mtype = MEM_RDDR;	/* only one type supported */
 			dimm->dtype = mem_dev ? DEV_X4 : DEV_X8;
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index f83e63d..ffedae9 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -43,9 +43,10 @@ static void edac_mc_dump_channel(struct rank_info *chan)
 {
 	debugf4("\tchannel = %p\n", chan);
 	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
-	debugf4("\tchannel->ce_count = %d\n", chan->dimm->ce_count);
-	debugf4("\tchannel->label = '%s'\n", chan->dimm->label);
 	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
+	debugf4("\tdimm->ce_count = %d\n", chan->dimm->ce_count);
+	debugf4("\tdimm->label = '%s'\n", chan->dimm->label);
+	debugf4("\tdimm->nr_pages = 0x%x\n", chan->dimm->nr_pages);
 }
 
 static void edac_mc_dump_csrow(struct csrow_info *csrow)
@@ -55,7 +56,6 @@ static void edac_mc_dump_csrow(struct csrow_info *csrow)
 	debugf4("\tcsrow->first_page = 0x%lx\n", csrow->first_page);
 	debugf4("\tcsrow->last_page = 0x%lx\n", csrow->last_page);
 	debugf4("\tcsrow->page_mask = 0x%lx\n", csrow->page_mask);
-	debugf4("\tcsrow->nr_pages = 0x%x\n", csrow->nr_pages);
 	debugf4("\tcsrow->nr_channels = %d\n", csrow->nr_channels);
 	debugf4("\tcsrow->channels = %p\n", csrow->channels);
 	debugf4("\tcsrow->mci = %p\n\n", csrow->mci);
@@ -652,15 +652,19 @@ static void edac_mc_scrub_block(unsigned long page, unsigned long offset,
 int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
 {
 	struct csrow_info *csrows = mci->csrows;
-	int row, i;
+	int row, i, j, n;
 
 	debugf1("MC%d: %s(): 0x%lx\n", mci->mc_idx, __func__, page);
 	row = -1;
 
 	for (i = 0; i < mci->nr_csrows; i++) {
 		struct csrow_info *csrow = &csrows[i];
-
-		if (csrow->nr_pages == 0)
+		n = 0;
+		for (j = 0; j < csrow->nr_channels; j++) {
+			struct dimm_info *dimm = csrow->channels[j].dimm;
+			n += dimm->nr_pages;
+		}
+		if (n == 0)
 			continue;
 
 		debugf3("MC%d: %s(): first(0x%lx) page(0x%lx) last(0x%lx) "
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index d63904e..c0275e6 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -144,7 +144,13 @@ static ssize_t csrow_ce_count_show(struct csrow_info *csrow, char *data,
 static ssize_t csrow_size_show(struct csrow_info *csrow, char *data,
 				int private)
 {
-	return sprintf(data, "%u\n", PAGES_TO_MiB(csrow->nr_pages));
+	int i;
+	u32 nr_pages = 0;
+
+	for (i = 0; i < csrow->nr_channels; i++)
+		nr_pages += csrow->channels[i].dimm->nr_pages;
+
+	return sprintf(data, "%u\n", PAGES_TO_MiB(nr_pages));
 }
 
 static ssize_t csrow_mem_type_show(struct csrow_info *csrow, char *data,
@@ -519,16 +525,16 @@ static ssize_t mci_ctl_name_show(struct mem_ctl_info *mci, char *data)
 
 static ssize_t mci_size_mb_show(struct mem_ctl_info *mci, char *data)
 {
-	int total_pages, csrow_idx;
+	int total_pages = 0, csrow_idx, j;
 
-	for (total_pages = csrow_idx = 0; csrow_idx < mci->nr_csrows;
-		csrow_idx++) {
+	for (csrow_idx = 0; csrow_idx < mci->nr_csrows; csrow_idx++) {
 		struct csrow_info *csrow = &mci->csrows[csrow_idx];
 
-		if (!csrow->nr_pages)
-			continue;
+		for (j = 0; j < csrow->nr_channels; j++) {
+			struct dimm_info *dimm = csrow->channels[j].dimm;
 
-		total_pages += csrow->nr_pages;
+			total_pages += dimm->nr_pages;
+		}
 	}
 
 	return sprintf(data, "%u\n", PAGES_TO_MiB(total_pages));
@@ -900,7 +906,7 @@ static void edac_remove_mci_instance_attributes(struct mem_ctl_info *mci,
  */
 int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 {
-	int i;
+	int i, j;
 	int err;
 	struct csrow_info *csrow;
 	struct kobject *kobj_mci = &mci->edac_mci_kobj;
@@ -934,10 +940,13 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	/* Make directories for each CSROW object under the mc<id> kobject
 	 */
 	for (i = 0; i < mci->nr_csrows; i++) {
+		int nr_pages = 0;
+
 		csrow = &mci->csrows[i];
+		for (j = 0; j < csrow->nr_channels; j++)
+			nr_pages += csrow->channels[j].dimm->nr_pages;
 
-		/* Only expose populated CSROWs */
-		if (csrow->nr_pages > 0) {
+		if (nr_pages > 0) {
 			err = edac_create_csrow_object(mci, csrow, i);
 			if (err) {
 				debugf1("%s() failure: create csrow %d obj\n",
@@ -949,10 +958,14 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	return 0;
 
-	/* CSROW error: backout what has already been registered,  */
 fail1:
 	for (i--; i >= 0; i--) {
-		if (mci->csrows[i].nr_pages > 0)
+		int nr_pages = 0;
+
+		csrow = &mci->csrows[i];
+		for (j = 0; j < csrow->nr_channels; j++)
+			nr_pages += csrow->channels[j].dimm->nr_pages;
+		if (nr_pages > 0)
 			kobject_put(&mci->csrows[i].kobj);
 	}
 
@@ -972,14 +985,20 @@ fail0:
  */
 void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 {
-	int i;
+	struct csrow_info *csrow;
+	int i, j;
 
 	debugf0("%s()\n", __func__);
 
 	/* remove all csrow kobjects */
 	debugf4("%s()  unregister this mci kobj\n", __func__);
 	for (i = 0; i < mci->nr_csrows; i++) {
-		if (mci->csrows[i].nr_pages > 0) {
+		int nr_pages = 0;
+
+		csrow = &mci->csrows[i];
+		for (j = 0; j < csrow->nr_channels; j++)
+			nr_pages += csrow->channels[j].dimm->nr_pages;
+		if (nr_pages > 0) {
 			debugf0("%s()  unreg csrow-%d\n", __func__, i);
 			kobject_put(&mci->csrows[i].kobj);
 		}
diff --git a/drivers/edac/i3000_edac.c b/drivers/edac/i3000_edac.c
index 1498c5f..bf8a230 100644
--- a/drivers/edac/i3000_edac.c
+++ b/drivers/edac/i3000_edac.c
@@ -306,7 +306,7 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 	int rc;
 	int i, j;
 	struct mem_ctl_info *mci = NULL;
-	unsigned long last_cumul_size;
+	unsigned long last_cumul_size, nr_pages;
 	int interleaved, nr_channels;
 	unsigned char dra[I3000_RANKS / 2], drb[I3000_RANKS];
 	unsigned char *c0dra = dra, *c1dra = &dra[I3000_RANKS_PER_CHANNEL / 2];
@@ -391,11 +391,13 @@ static int i3000_probe1(struct pci_dev *pdev, int dev_idx)
 
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
-		csrow->nr_pages = cumul_size - last_cumul_size;
+		nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 
 		for (j = 0; j < nr_channels; j++) {
 			struct dimm_info *dimm = csrow->channels[j].dimm;
+
+			dimm->nr_pages = nr_pages / nr_channels;
 			dimm->grain = I3000_DEAP_GRAIN;
 			dimm->mtype = MEM_DDR2;
 			dimm->dtype = DEV_UNKNOWN;
diff --git a/drivers/edac/i3200_edac.c b/drivers/edac/i3200_edac.c
index d8fa7f3..b82667f 100644
--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -376,11 +376,10 @@ static int i3200_probe1(struct pci_dev *pdev, int dev_idx)
 		if (nr_pages == 0)
 			continue;
 
-		csrow->nr_pages = nr_pages;
-
 		for (j = 0; j < nr_channels; j++) {
 			struct dimm_info *dimm = csrow->channels[j].dimm;
 
+			dimm->nr_pages = nr_pages / nr_channels;
 			dimm->grain = nr_pages << PAGE_SHIFT;
 			dimm->mtype = MEM_DDR2;
 			dimm->dtype = DEV_UNKNOWN;
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index f00f684..e8d32e8 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1236,6 +1236,7 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 {
 	struct i5000_pvt *pvt;
 	struct csrow_info *p_csrow;
+	struct dimm_info *dimm;
 	int empty, channel_count;
 	int max_csrows;
 	int mtr, mtr1;
@@ -1265,21 +1266,22 @@ static int i5000_init_csrows(struct mem_ctl_info *mci)
 
 		csrow_megs = 0;
 		for (channel = 0; channel < pvt->maxch; channel++) {
+			dimm = p_csrow->channels[channel].dimm;
 			csrow_megs += pvt->dimm_info[csrow][channel].megabytes;
-			p_csrow->channels[channel].dimm->grain = 8;
+			dimm->grain = 8;
 
 			/* Assume DDR2 for now */
-			p_csrow->channels[channel].dimm->mtype = MEM_FB_DDR2;
+			dimm->mtype = MEM_FB_DDR2;
 
 			/* ask what device type on this row */
 			if (MTR_DRAM_WIDTH(mtr))
-				p_csrow->channels[channel].dimm->dtype = DEV_X8;
+				dimm->dtype = DEV_X8;
 			else
-				p_csrow->channels[channel].dimm->dtype = DEV_X4;
+				dimm->dtype = DEV_X4;
 
-			p_csrow->channels[channel].dimm->edac_mode = EDAC_S8ECD8ED;
+			dimm->edac_mode = EDAC_S8ECD8ED;
+			dimm->nr_pages = (csrow_megs << 8) / pvt->maxch;
 		}
-		p_csrow->nr_pages = csrow_megs << 8;
 
 		empty = 0;
 	}
diff --git a/drivers/edac/i5100_edac.c b/drivers/edac/i5100_edac.c
index 8da7ce1..a0219a9 100644
--- a/drivers/edac/i5100_edac.c
+++ b/drivers/edac/i5100_edac.c
@@ -859,7 +859,6 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		 * FIXME: these two are totally bogus -- I don't see how to
 		 * map them correctly to this structure...
 		 */
-		mci->csrows[i].nr_pages = npages;
 		mci->csrows[i].csrow_idx = i;
 		mci->csrows[i].mci = mci;
 		mci->csrows[i].nr_channels = 1;
@@ -867,14 +866,19 @@ static void __devinit i5100_init_csrows(struct mem_ctl_info *mci)
 		total_pages += npages;
 
 		dimm = mci->csrows[i].channels[0].dimm;
-		dimm->grain = 32;
-		dimm->dtype = (priv->mtr[chan][rank].width == 4) ?
-			      DEV_X4 : DEV_X8;
-		dimm->mtype = MEM_RDDR2;
-		dimm->edac_mode = EDAC_SECDED;
-		snprintf(dimm->label, sizeof(dimm->label),
-			 "DIMM%u",
-			 i5100_rank_to_slot(mci, chan, rank));
+		dimm->nr_pages = npages;
+		if (npages) {
+			total_pages += npages;
+
+			dimm->grain = 32;
+			dimm->dtype = (priv->mtr[chan][rank].width == 4) ?
+				DEV_X4 : DEV_X8;
+			dimm->mtype = MEM_RDDR2;
+			dimm->edac_mode = EDAC_SECDED;
+			snprintf(dimm->label, sizeof(dimm->label),
+				"DIMM%u",
+				i5100_rank_to_slot(mci, chan, rank));
+		}
 	}
 }
 
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 4a23813..784d6dc 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1156,7 +1156,7 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 	int empty, channel_count;
 	int max_csrows;
 	int mtr;
-	int csrow_megs;
+	int size_mb;
 	int channel;
 	int csrow;
 	struct dimm_info *dimm;
@@ -1171,8 +1171,6 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 	for (csrow = 0; csrow < max_csrows; csrow++) {
 		p_csrow = &mci->csrows[csrow];
 
-		p_csrow->csrow_idx = csrow;
-
 		/* use branch 0 for the basis */
 		mtr = determine_mtr(pvt, csrow, 0);
 
@@ -1180,12 +1178,11 @@ static int i5400_init_csrows(struct mem_ctl_info *mci)
 		if (!MTR_DIMMS_PRESENT(mtr))
 			continue;
 
-		csrow_megs = 0;
 		for (channel = 0; channel < pvt->maxch; channel++) {
-			csrow_megs += pvt->dimm_info[csrow][channel].megabytes;
+			size_mb = pvt->dimm_info[csrow][channel].megabytes;
 
-			p_csrow->nr_pages = csrow_megs << 8;
 			dimm = p_csrow->channels[channel].dimm;
+			dimm->nr_pages = size_mb << 8;
 			dimm->grain = 8;
 			dimm->dtype = MTR_DRAM_WIDTH(mtr) ? DEV_X8 : DEV_X4;
 			dimm->mtype = MEM_RDDR2;
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index df6cd59..5e594ae 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -617,9 +617,7 @@ static void i7300_enable_error_reporting(struct mem_ctl_info *mci)
 static int decode_mtr(struct i7300_pvt *pvt,
 		      int slot, int ch, int branch,
 		      struct i7300_dimm_info *dinfo,
-		      struct csrow_info *p_csrow,
-		      struct dimm_info *dimm,
-		      u32 *nr_pages)
+		      struct dimm_info *dimm)
 {
 	int mtr, ans, addrBits, channel;
 
@@ -651,7 +649,6 @@ static int decode_mtr(struct i7300_pvt *pvt,
 	addrBits -= 3;	/* 8 bits per bytes */
 
 	dinfo->megabytes = 1 << addrBits;
-	*nr_pages = dinfo->megabytes << 8;
 
 	debugf2("\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
 
@@ -664,8 +661,6 @@ static int decode_mtr(struct i7300_pvt *pvt,
 	debugf2("\t\tNUMCOL: %s\n", numcol_toString[MTR_DIMM_COLS(mtr)]);
 	debugf2("\t\tSIZE: %d MB\n", dinfo->megabytes);
 
-	p_csrow->csrow_idx = slot;
-
 	/*
 	 * The type of error detection actually depends of the
 	 * mode of operation. When it is just one single memory chip, at
@@ -675,6 +670,7 @@ static int decode_mtr(struct i7300_pvt *pvt,
 	 * See datasheet Sections 7.3.6 to 7.3.8
 	 */
 
+	dimm->nr_pages = MiB_TO_PAGES(dinfo->megabytes);
 	dimm->grain = 8;
 	dimm->mtype = MEM_FB_DDR2;
 	if (IS_SINGLE_MODE(pvt->mc_settings_a)) {
@@ -774,11 +770,9 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 {
 	struct i7300_pvt *pvt;
 	struct i7300_dimm_info *dinfo;
-	struct csrow_info *p_csrow;
 	int rc = -ENODEV;
 	int mtr;
 	int ch, branch, slot, channel;
-	u32 nr_pages;
 	struct dimm_info *dimm;
 
 	pvt = mci->pvt_info;
@@ -804,7 +798,6 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 	}
 
 	/* Get the set of MTR[0-7] regs by each branch */
-	nr_pages = 0;
 	for (slot = 0; slot < MAX_SLOTS; slot++) {
 		int where = mtr_regs[slot];
 		for (branch = 0; branch < MAX_BRANCHES; branch++) {
@@ -815,21 +808,18 @@ static int i7300_init_csrows(struct mem_ctl_info *mci)
 				int channel = to_channel(ch, branch);
 
 				dinfo = &pvt->dimm_info[slot][channel];
-				p_csrow = &mci->csrows[slot];
 
-				dimm = p_csrow->channels[branch * MAX_CH_PER_BRANCH + ch].dimm;
+				dimm = mci->csrows[slot].channels[branch * MAX_CH_PER_BRANCH + ch].dimm;
 
 				mtr = decode_mtr(pvt, slot, ch, branch,
-						 dinfo, p_csrow, dimm,
-						 &nr_pages);
+						 dinfo, dimm);
+
 				/* if no DIMMS on this row, continue */
 				if (!MTR_DIMMS_PRESENT(mtr))
 					continue;
 
-				/* Update per_csrow memory count */
-				p_csrow->nr_pages += nr_pages;
-
 				rc = 0;
+
 			}
 		}
 	}
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 89ccec6..d566797 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -715,17 +715,12 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			npages = MiB_TO_PAGES(size);
 
 			csr = &mci->csrows[csrow];
-			csr->nr_pages = npages;
-
-			csr->csrow_idx = csrow;
-			csr->nr_channels = 1;
-
-			csr->channels[0].chan_idx = i;
-			csr->channels[0].ce_count = 0;
 
 			pvt->csrow_map[i][j] = csrow;
 
 			dimm = csr->channels[0].dimm;
+			dimm->nr_pages = npages;
+
 			switch (banks) {
 			case 4:
 				dimm->dtype = DEV_X4;
@@ -746,6 +741,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 			dimm->grain = 8;
 			dimm->edac_mode = mode;
 			dimm->mtype = mtype;
+			csrow++;
 		}
 
 		pci_read_config_dword(pdev, MC_SAG_CH_0, &value[0]);
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 1e19492..74166ae 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -220,7 +220,7 @@ static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
 		row_base = row_high_limit_last;
 		csrow->first_page = row_base >> PAGE_SHIFT;
 		csrow->last_page = (row_high_limit >> PAGE_SHIFT) - 1;
-		csrow->nr_pages = csrow->last_page - csrow->first_page + 1;
+		dimm->nr_pages = csrow->last_page - csrow->first_page + 1;
 		/* EAP reports in 4kilobyte granularity [61] */
 		dimm->grain = 1 << 12;
 		dimm->mtype = mtype;
diff --git a/drivers/edac/i82860_edac.c b/drivers/edac/i82860_edac.c
index acbd924..48e0ecd 100644
--- a/drivers/edac/i82860_edac.c
+++ b/drivers/edac/i82860_edac.c
@@ -167,7 +167,7 @@ static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
-		csrow->nr_pages = cumul_size - last_cumul_size;
+		dimm->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 		dimm->grain = 1 << 12;	/* I82860_EAP has 4KiB reolution */
 		dimm->mtype = MEM_RMBS;
diff --git a/drivers/edac/i82875p_edac.c b/drivers/edac/i82875p_edac.c
index 81f79e2..dc207dc 100644
--- a/drivers/edac/i82875p_edac.c
+++ b/drivers/edac/i82875p_edac.c
@@ -347,7 +347,7 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 	unsigned long last_cumul_size;
 	u8 value;
 	u32 drc_ddim;		/* DRAM Data Integrity Mode 0=none,2=edac */
-	u32 cumul_size;
+	u32 cumul_size, nr_pages;
 	int index, j;
 
 	drc_ddim = (drc >> 18) & 0x1;
@@ -371,12 +371,13 @@ static void i82875p_init_csrows(struct mem_ctl_info *mci,
 
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
-		csrow->nr_pages = cumul_size - last_cumul_size;
+		nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 
 		for (j = 0; j < nr_chans; j++) {
 			dimm = csrow->channels[j].dimm;
 
+			dimm->nr_pages = nr_pages / nr_chans;
 			dimm->grain = 1 << 12;	/* I82875P_EAP has 4KiB reolution */
 			dimm->mtype = MEM_DDR;
 			dimm->dtype = DEV_UNKNOWN;
diff --git a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
index 0b40e11..304af1d 100644
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -370,7 +370,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	u8 value;
-	u32 cumul_size;
+	u32 cumul_size, nr_pages;
 	int index, chan;
 	struct dimm_info *dimm;
 	enum dev_type dtype;
@@ -402,6 +402,7 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		debugf3("%s(): (%d) cumul_size 0x%x\n", __func__, index,
 			cumul_size);
 
+		nr_pages = cumul_size - last_cumul_size;
 		/*
 		 * Initialise dram labels
 		 * index values:
@@ -411,6 +412,11 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 		dtype = i82975x_dram_type(mch_window, index);
 		for (chan = 0; chan < csrow->nr_channels; chan++) {
 			dimm = mci->csrows[index].channels[chan].dimm;
+
+			if (!nr_pages)
+				continue;
+
+			dimm->nr_pages = nr_pages / csrow->nr_channels;
 			strncpy(csrow->channels[chan].dimm->label,
 					labels[(index >> 1) + (chan * 2)],
 					EDAC_MC_LABEL_LEN);
@@ -420,12 +426,11 @@ static void i82975x_init_csrows(struct mem_ctl_info *mci,
 			dimm->edac_mode = EDAC_SECDED; /* only supported */
 		}
 
-		if (cumul_size == last_cumul_size)
+		if (!nr_pages)
 			continue;	/* not populated */
 
 		csrow->first_page = last_cumul_size;
 		csrow->last_page = cumul_size - 1;
-		csrow->nr_pages = cumul_size - last_cumul_size;
 		last_cumul_size = cumul_size;
 	}
 }
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index fb92916..c1d9e15 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -947,7 +947,8 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 
 		csrow->first_page = start;
 		csrow->last_page = end;
-		csrow->nr_pages = end + 1 - start;
+
+		dimm->nr_pages = end + 1 - start;
 		dimm->grain = 8;
 		dimm->mtype = mtype;
 		dimm->dtype = DEV_UNKNOWN;
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index d2e3c39..281e245 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -667,7 +667,8 @@ static void mv64x60_init_csrows(struct mem_ctl_info *mci,
 
 	csrow = &mci->csrows[0];
 	dimm = csrow->channels[0].dimm;
-	csrow->nr_pages = pdata->total_mem >> PAGE_SHIFT;
+
+	dimm->nr_pages = pdata->total_mem >> PAGE_SHIFT;
 	dimm->grain = 8;
 
 	dimm->mtype = (ctl & MV64X60_SDRAM_REGISTERED) ? MEM_RDDR : MEM_DDR;
diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 4e53270..3fcefda 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -153,20 +153,20 @@ static int pasemi_edac_init_csrows(struct mem_ctl_info *mci,
 		switch ((rankcfg & MCDRAM_RANKCFG_TYPE_SIZE_M) >>
 			MCDRAM_RANKCFG_TYPE_SIZE_S) {
 		case 0:
-			csrow->nr_pages = 128 << (20 - PAGE_SHIFT);
+			dimm->nr_pages = 128 << (20 - PAGE_SHIFT);
 			break;
 		case 1:
-			csrow->nr_pages = 256 << (20 - PAGE_SHIFT);
+			dimm->nr_pages = 256 << (20 - PAGE_SHIFT);
 			break;
 		case 2:
 		case 3:
-			csrow->nr_pages = 512 << (20 - PAGE_SHIFT);
+			dimm->nr_pages = 512 << (20 - PAGE_SHIFT);
 			break;
 		case 4:
-			csrow->nr_pages = 1024 << (20 - PAGE_SHIFT);
+			dimm->nr_pages = 1024 << (20 - PAGE_SHIFT);
 			break;
 		case 5:
-			csrow->nr_pages = 2048 << (20 - PAGE_SHIFT);
+			dimm->nr_pages = 2048 << (20 - PAGE_SHIFT);
 			break;
 		default:
 			edac_mc_printk(mci, KERN_ERR,
@@ -176,8 +176,8 @@ static int pasemi_edac_init_csrows(struct mem_ctl_info *mci,
 		}
 
 		csrow->first_page = last_page_in_mmc;
-		csrow->last_page = csrow->first_page + csrow->nr_pages - 1;
-		last_page_in_mmc += csrow->nr_pages;
+		csrow->last_page = csrow->first_page + dimm->nr_pages - 1;
+		last_page_in_mmc += dimm->nr_pages;
 		csrow->page_mask = 0;
 		dimm->grain = PASEMI_EDAC_ERROR_GRAIN;
 		dimm->mtype = MEM_DDR;
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index ec5e529..95cfc0f 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -896,7 +896,7 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 	enum dev_type dtype;
 	enum edac_type edac_mode;
 	int row, j;
-	u32 mbxcf, size;
+	u32 mbxcf, size, nr_pages;
 
 	/* Establish the memory type and width */
 
@@ -947,7 +947,7 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 		case SDRAM_MBCF_SZ_2GB:
 		case SDRAM_MBCF_SZ_4GB:
 		case SDRAM_MBCF_SZ_8GB:
-			csi->nr_pages = SDRAM_MBCF_SZ_TO_PAGES(size);
+			nr_pages = SDRAM_MBCF_SZ_TO_PAGES(size);
 			break;
 		default:
 			ppc4xx_edac_mc_printk(KERN_ERR, mci,
@@ -973,6 +973,7 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 		for (j = 0; j < csi->nr_channels; j++) {
 			struct dimm_info *dimm = csi->channels[j].dimm;
 
+			dimm->nr_pages  = nr_pages / csi->nr_channels;
 			dimm->grain	= 1;
 
 			dimm->mtype	= mtype;
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
index 414a532..19f3a10 100644
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -249,7 +249,8 @@ static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
 
 		csrow->first_page = row_base >> PAGE_SHIFT;
 		csrow->last_page = (row_high_limit >> PAGE_SHIFT) - 1;
-		csrow->nr_pages = csrow->last_page - csrow->first_page + 1;
+
+		dimm->nr_pages = csrow->last_page - csrow->first_page + 1;
 		/* Error address is top 19 bits - so granularity is      *
 		 * 14 bits                                               */
 		dimm->grain = 1 << 14;
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index cf53007..ee1543d 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -561,7 +561,6 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	u32 reg;
 	enum edac_type mode;
 	enum mem_type mtype;
-	struct dimm_info *dimm;
 
 	pci_read_config_dword(pvt->pci_br, SAD_TARGET, &reg);
 	pvt->sbridge_dev->source_id = SOURCE_ID(reg);
@@ -613,11 +612,11 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	/* On all supported DDR3 DIMM types, there are 8 banks available */
 	banks = 8;
 
-	dimm = mci->dimms;
 	for (i = 0; i < NUM_CHANNELS; i++) {
 		u32 mtr;
 
 		for (j = 0; j < ARRAY_SIZE(mtr_regs); j++) {
+			struct dimm_info *dimm = &mci->dimms[j];
 			pci_read_config_dword(pvt->pci_tad[i],
 					      mtr_regs[j], &mtr);
 			debugf4("Channel #%d  MTR%d = %x\n", i, j, mtr);
@@ -642,15 +641,12 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 				 * csrows.
 				 */
 				csr = &mci->csrows[csrow];
-				csr->nr_pages = npages;
-				csr->csrow_idx = csrow;
-				csr->nr_channels = 1;
-				csr->channels[0].chan_idx = i;
 				pvt->csrow_map[i][j] = csrow;
 				last_page += npages;
 				csrow++;
 
 				csr->channels[0].dimm = dimm;
+				dimm->nr_pages = npages;
 				dimm->grain = 32;
 				dimm->dtype = (banks == 8) ? DEV_X8 : DEV_X4;
 				dimm->mtype = mtype;
diff --git a/drivers/edac/tile_edac.c b/drivers/edac/tile_edac.c
index ba0917b..6314ff9 100644
--- a/drivers/edac/tile_edac.c
+++ b/drivers/edac/tile_edac.c
@@ -110,7 +110,7 @@ static int __devinit tile_edac_init_csrows(struct mem_ctl_info *mci)
 		return -1;
 	}
 
-	csrow->nr_pages = mem_info.mem_size >> PAGE_SHIFT;
+	dimm->nr_pages = mem_info.mem_size >> PAGE_SHIFT;
 	dimm->grain = TILE_EDAC_ERROR_GRAIN;
 	dimm->dtype = DEV_UNKNOWN;
 
diff --git a/drivers/edac/x38_edac.c b/drivers/edac/x38_edac.c
index 7be10dd..0de288f 100644
--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -373,10 +373,10 @@ static int x38_probe1(struct pci_dev *pdev, int dev_idx)
 		if (nr_pages == 0)
 			continue;
 
-		csrow->nr_pages = nr_pages;
-
 		for (j = 0; j < x38_channel_num; j++) {
 			struct dimm_info *dimm = csrow->channels[j].dimm;
+
+			dimm->nr_pages = nr_pages / x38_channel_num;
 			dimm->grain = nr_pages << PAGE_SHIFT;
 			dimm->mtype = MEM_DDR2;
 			dimm->dtype = DEV_UNKNOWN;
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 5244193..8b78bd0 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -320,6 +320,8 @@ struct dimm_info {
 	enum mem_type mtype;	/* memory dimm type */
 	enum edac_type edac_mode;	/* EDAC mode for this dimm */
 
+	u32 nr_pages;			/* number of pages in csrow */
+
 	u32 ce_count;		/* Correctable Errors for this dimm */
 };
 
@@ -346,12 +348,12 @@ struct rank_info {
 };
 
 struct csrow_info {
+	/* Used only by edac_mc_find_csrow_by_page() */
 	unsigned long first_page;	/* first page number in csrow */
 	unsigned long last_page;	/* last page number in csrow */
-	u32 nr_pages;			/* number of pages in csrow */
 	unsigned long page_mask;	/* used for interleaving -
-					 * 0UL for non intlv
-					 */
+					 * 0UL for non intlv */
+
 	int csrow_idx;			/* the chip-select row */
 
 	u32 ue_count;		/* Uncorrectable Errors for this csrow */
-- 
1.7.8

