Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564Ab2D0Phj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:37:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760450Ab2D0Phi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:37:38 -0400
Message-ID: <4F9ABCEC.9090807@redhat.com>
Date: Fri, 27 Apr 2012 12:36:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
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
        =?ISO-8859-1?Q?Niklas_S=F6d?= =?ISO-8859-1?Q?erlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com> <1335291342-14922-1-git-send-email-mchehab@redhat.com> <20120427133304.GE9626@aftab.osrc.amd.com>
In-Reply-To: <20120427133304.GE9626@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-04-2012 10:33, Borislav Petkov escreveu:
> Btw,
> 
> this patch gives
> 
> [    8.278399] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
> [    8.287594] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 1: dimm1 (0:1:0): row 0, chan 1
> [    8.296784] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 2: dimm2 (1:0:0): row 1, chan 0
> [    8.305968] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 3: dimm3 (1:1:0): row 1, chan 1
> [    8.315144] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 4: dimm4 (2:0:0): row 2, chan 0
> [    8.324326] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 5: dimm5 (2:1:0): row 2, chan 1
> [    8.333502] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 6: dimm6 (3:0:0): row 3, chan 0
> [    8.342684] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 7: dimm7 (3:1:0): row 3, chan 1
> [    8.351860] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 8: dimm8 (4:0:0): row 4, chan 0
> [    8.361049] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 9: dimm9 (4:1:0): row 4, chan 1
> [    8.370227] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 10: dimm10 (5:0:0): row 5, chan 0
> [    8.379582] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 11: dimm11 (5:1:0): row 5, chan 1
> [    8.388941] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 12: dimm12 (6:0:0): row 6, chan 0
> [    8.398315] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 13: dimm13 (6:1:0): row 6, chan 1
> [    8.407680] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 14: dimm14 (7:0:0): row 7, chan 0
> [    8.417047] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 15: dimm15 (7:1:0): row 7, chan 1
> 
> and the memory controller has the following chip selects
> 
> [    8.137662] EDAC MC: DCT0 chip selects:
> [    8.150291] EDAC amd64: MC: 0:  2048MB 1:  2048MB
> [    8.155349] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [    8.160408] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    8.165475] EDAC amd64: MC: 6:     0MB 7:     0MB
> [    8.180499] EDAC MC: DCT1 chip selects:
> [    8.184693] EDAC amd64: MC: 0:  2048MB 1:  2048MB
> [    8.189753] EDAC amd64: MC: 2:  2048MB 3:  2048MB
> [    8.194812] EDAC amd64: MC: 4:     0MB 5:     0MB
> [    8.199875] EDAC amd64: MC: 6:     0MB 7:     0MB
> 
> Those are 4 dual-ranked DIMMs on this node, DCT0 is one channel and DCT1
> is another and I have 4 ranks per channel. Having dimm0-dimm15 is very
> misleading and has nothing to do with the reality. So, if this is to use
> your nomenclature with layers, I'll have dimm0-dimm7 where each dimm is
> a rank.
> 
> Or, the most correct thing to do would be to have dimm0-dimm3, each
> dual-ranked.
> 
> So either tot_dimms is computed wrongly or there's a more serious error
> somewhere.
> 
> I've reviewed almost the half patch, will review the rest when/if we
> sort out the above issue first.
> 
> Thanks.


The fix for it were in another patch[1], as calling them as "rank" is needed
also at the sysfs API.

[1] http://lists-archives.com/linux-kernel/27623222-edac-add-a-new-per-dimm-api-and-make-the-old-per-virtual-rank-api-obsolete.html

I can just merge the fix on this patch, with the enclosed diff.

Regards,
Mauro

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 4d4d8b7..e0d9481 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -86,7 +86,7 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 	debugf4("\tmci->edac_check = %p\n", mci->edac_check);
 	debugf3("\tmci->nr_csrows = %d, csrows = %p\n",
 		mci->nr_csrows, mci->csrows);
-	debugf3("\tmci->nr_dimms = %d, dimns = %p\n",
+	debugf3("\tmci->nr_dimms = %d, dimms = %p\n",
 		mci->tot_dimms, mci->dimms);
 	debugf3("\tdev = %p\n", mci->dev);
 	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
@@ -183,10 +183,6 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
  * @size_pvt:		size of private storage needed
  *
  *
- * FIXME: drivers handle multi-rank memories on different ways: on some
- * drivers, one multi-rank memory is mapped as one DIMM, while, on others,
- * a single multi-rank DIMM would be mapped into several "dimms".
- *
  * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
  * such DIMMS properly, but the CSROWS-based ones will likely do the wrong
  * thing, as two chip select values are used for dual-rank memories (and 4, for
@@ -201,6 +197,12 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
  *
  * Use edac_mc_free() to free mc structures allocated by this function.
  *
+ * NOTE: drivers handle multi-rank memories on different ways: on some
+ * drivers, one multi-rank memory is mapped as one entry, while, on others,
+ * a single multi-rank DIMM would be mapped into several entries. Currently,
+ * this function will allocate multiple struct dimm_info on such scenarios,
+ * as grouping the multiple ranks require drivers change.
+ *
  * Returns:
  *	NULL allocation failed
  *	struct mem_ctl_info pointer
@@ -220,10 +222,11 @@ struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
 	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
 	void *pvt;
 	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
-	unsigned tot_csrows, tot_cschannels;
+	unsigned tot_csrows, tot_cschannels, tot_errcount = 0;
 	int i, j;
 	int err;
 	int row, chn;
+	bool per_rank = false;
 
 	BUG_ON(n_layers > EDAC_MAX_LAYERS);
 	/*
@@ -239,6 +242,9 @@ struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
 			tot_csrows *= layers[i].size;
 		else
 			tot_cschannels *= layers[i].size;
+
+		if (layers[i].type == EDAC_MC_LAYER_CHIP_SELECT)
+			per_rank = true;
 	}
 
 	/* Figure out the offsets of the various items from the start of an mc
@@ -254,14 +260,21 @@ struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
 	count = 1;
 	for (i = 0; i < n_layers; i++) {
 		count *= layers[i].size;
+		debugf4("%s: errcount layer %d size %d\n", __func__, i, count);
 		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
 		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
+		tot_errcount += 2 * count;
 	}
+
+	debugf4("%s: allocating %d error counters\n", __func__, tot_errcount);
 	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
 	size = ((unsigned long)pvt) + sz_pvt;
 
-	debugf1("%s(): allocating %u bytes for mci data (%d dimms, %d csrows/channels)\n",
-		__func__, size, tot_dimms, tot_csrows * tot_cschannels);
+	debugf1("%s(): allocating %u bytes for mci data (%d %s, %d csrows/channels)\n",
+		__func__, size,
+		tot_dimms,
+		per_rank ? "ranks" : "dimms",
+		tot_csrows * tot_cschannels);
 	mci = kzalloc(size, GFP_KERNEL);
 	if (mci == NULL)
 		return NULL;
@@ -290,6 +303,7 @@ struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
 	memcpy(mci->layers, layers, sizeof(*lay) * n_layers);
 	mci->nr_csrows = tot_csrows;
 	mci->num_cschannel = tot_cschannels;
+	mci->mem_is_per_rank = per_rank;
 
 	/*
 	 * Fills the csrow struct
@@ -315,15 +329,16 @@ struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
 	memset(&pos, 0, sizeof(pos));
 	row = 0;
 	chn = 0;
-	debugf4("%s: initializing %d dimms\n", __func__, tot_dimms);
+	debugf4("%s: initializing %d %s\n", __func__, tot_dimms,
+		per_rank ? "ranks" : "dimms");
 	for (i = 0; i < tot_dimms; i++) {
 		chan = &csi[row].channels[chn];
 		dimm = EDAC_DIMM_PTR(lay, mci->dimms, n_layers,
 			       pos[0], pos[1], pos[2]);
 		dimm->mci = mci;
 
-		debugf2("%s: %d: dimm%zd (%d:%d:%d): row %d, chan %d\n", __func__,
-			i, (dimm - mci->dimms),
+		debugf2("%s: %d: %s%zd (%d:%d:%d): row %d, chan %d\n", __func__,
+			i, per_rank ? "rank" : "dimm", (dimm - mci->dimms),
 			pos[0], pos[1], pos[2], row, chn);
 
 		/* Copy DIMM location */
@@ -1040,8 +1055,10 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			 * get csrow/channel of the dimm, in order to allow
 			 * incrementing the compat API counters
 			 */
-			debugf4("%s: dimm csrows (%d,%d)\n",
-				__func__, dimm->csrow, dimm->cschannel);
+			debugf4("%s: %s csrows map: (%d,%d)\n",
+				__func__,
+				mci->mem_is_per_rank ? "rank" : "dimm",
+				dimm->csrow, dimm->cschannel);
 			if (row == -1)
 				row = dimm->csrow;
 			else if (row >= 0 && row != dimm->csrow)
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 412d5cd..2b66109 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -555,6 +555,8 @@ struct mem_ctl_info {
 	/* Memory Controller hierarchy */
 	unsigned n_layers;
 	struct edac_mc_layer *layers;
+	bool mem_is_per_rank;
+
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
 	 */
