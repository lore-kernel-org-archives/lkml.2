Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab2D0NdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 09:33:15 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59240 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2D0NdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 09:33:13 -0400
Date: Fri, 27 Apr 2012 15:33:04 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
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
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to work
 with layers
Message-ID: <20120427133304.GE9626@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335291342-14922-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw,

this patch gives

[    8.278399] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0
[    8.287594] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 1: dimm1 (0:1:0): row 0, chan 1
[    8.296784] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 2: dimm2 (1:0:0): row 1, chan 0
[    8.305968] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 3: dimm3 (1:1:0): row 1, chan 1
[    8.315144] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 4: dimm4 (2:0:0): row 2, chan 0
[    8.324326] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 5: dimm5 (2:1:0): row 2, chan 1
[    8.333502] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 6: dimm6 (3:0:0): row 3, chan 0
[    8.342684] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 7: dimm7 (3:1:0): row 3, chan 1
[    8.351860] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 8: dimm8 (4:0:0): row 4, chan 0
[    8.361049] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 9: dimm9 (4:1:0): row 4, chan 1
[    8.370227] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 10: dimm10 (5:0:0): row 5, chan 0
[    8.379582] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 11: dimm11 (5:1:0): row 5, chan 1
[    8.388941] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 12: dimm12 (6:0:0): row 6, chan 0
[    8.398315] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 13: dimm13 (6:1:0): row 6, chan 1
[    8.407680] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 14: dimm14 (7:0:0): row 7, chan 0
[    8.417047] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 15: dimm15 (7:1:0): row 7, chan 1

and the memory controller has the following chip selects

[    8.137662] EDAC MC: DCT0 chip selects:
[    8.150291] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[    8.155349] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[    8.160408] EDAC amd64: MC: 4:     0MB 5:     0MB
[    8.165475] EDAC amd64: MC: 6:     0MB 7:     0MB
[    8.180499] EDAC MC: DCT1 chip selects:
[    8.184693] EDAC amd64: MC: 0:  2048MB 1:  2048MB
[    8.189753] EDAC amd64: MC: 2:  2048MB 3:  2048MB
[    8.194812] EDAC amd64: MC: 4:     0MB 5:     0MB
[    8.199875] EDAC amd64: MC: 6:     0MB 7:     0MB

Those are 4 dual-ranked DIMMs on this node, DCT0 is one channel and DCT1
is another and I have 4 ranks per channel. Having dimm0-dimm15 is very
misleading and has nothing to do with the reality. So, if this is to use
your nomenclature with layers, I'll have dimm0-dimm7 where each dimm is
a rank.

Or, the most correct thing to do would be to have dimm0-dimm3, each
dual-ranked.

So either tot_dimms is computed wrongly or there's a more serious error
somewhere.

I've reviewed almost the half patch, will review the rest when/if we
sort out the above issue first.

Thanks.

On Tue, Apr 24, 2012 at 03:15:41PM -0300, Mauro Carvalho Chehab wrote:
> Change the EDAC internal representation to work with non-csrow
> based memory controllers.
> 
> There are lots of those memory controllers nowadays, and more
> are coming. So, the EDAC internal representation needs to be
> changed, in order to work with those memory controllers, while
> preserving backward compatibility with the old ones.
> 
> The edac core were written with the idea that memory controllers

		was

> are able to directly access csrows, and that the channels are
> used inside a csrows select.

This sounds funny, simply remove that second part about the channels.

> This is not true for FB-DIMM and RAMBUS memory controllers.
> 
> Also, some recent advanced memory controllers don't present a per-csrows
> view. Instead, they view memories as DIMM's, instead of ranks, accessed

					DIMMs instead of ranks."

Remove the rest.

> via csrow/channel.
> 
> So, change the allocation and error report routines to allow
> them to work with all types of architectures.
> 
> This will allow the removal of several hacks on FB-DIMM and RAMBUS

					       with

> memory controllers on the next patches.

		    . Remove the rest.

> 
> Also, several tests were done on different platforms using different
> x86 drivers.
> 
> TODO: a multi-rank DIMM's are currently represented by multiple DIMM

	Multi-rank DIMMs

> entries at struct dimm_info. That means that changing a label for one

	  in

> rank won't change the same label for the other ranks at the same dimm.

						       of the same DIMM.

> Such bug is there since the beginning of the EDAC, so it is not a big

  This bug is present ..

> deal. However, on several drivers, it is possible to fix this issue, but

		remove "on"

> it should be a per-driver fix, as the csrow => DIMM arrangement may not
> be equal for all. So, don't try to fix it here yet.
> 
> PS.: I tried to make this patch as short as possible, preceding it with

Remove "PS."

> several other patches that simplified the logic here. Yet, as the
> internal API changes, all drivers need changes. The changes are
> generally bigger on the drivers for FB-DIMM's.

		   in 		   for FB-DIMMs.

> 
> FIXME: while the FB-DIMMs are not converted to use the new
> design, uncorrected errors will show just one channel. In
> the past, all changes were on a big patch with about 150K.
> As it needed to be split, in order to be accepted by the
> EDAC ML at vger, we've opted to have this small drawback.
> As an advantage, it is now easier to review the patch series.

This whole paragraph above doesn't have anything to do with what the
patch does, so it can go.

[..]

> ---
> 
> v16: Only context changes
> 
>  drivers/edac/edac_core.h |   92 ++++++-
>  drivers/edac/edac_mc.c   |  682 ++++++++++++++++++++++++++++------------------
>  include/linux/edac.h     |   40 ++-
>  3 files changed, 526 insertions(+), 288 deletions(-)
> 
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index e48ab31..7201bb1 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -447,8 +447,13 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
>  
>  #endif				/* CONFIG_PCI */
>  
> -extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> -					  unsigned nr_chans, int edac_index);
> +struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> +				   unsigned nr_chans, int edac_index);

Why not "extern"?

> +struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
> +				   unsigned n_layers,
> +				   struct edac_mc_layer *layers,
> +				   bool rev_order,
> +				   unsigned sz_pvt);

ditto.

>  extern int edac_mc_add_mc(struct mem_ctl_info *mci);
>  extern void edac_mc_free(struct mem_ctl_info *mci);
>  extern struct mem_ctl_info *edac_mc_find(int idx);
> @@ -467,24 +472,80 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
>   * reporting logic and function interface - reduces conditional
>   * statement clutter and extra function arguments.
>   */
> -extern void edac_mc_handle_ce(struct mem_ctl_info *mci,
> +
> +void edac_mc_handle_error(const enum hw_event_mc_err_type type,
> +			  struct mem_ctl_info *mci,
> +			  const unsigned long page_frame_number,
> +			  const unsigned long offset_in_page,
> +			  const unsigned long syndrome,
> +			  const int layer0,
> +			  const int layer1,
> +			  const int layer2,
> +			  const char *msg,
> +			  const char *other_detail,
> +			  const void *mcelog);

Why isn't this one "extern" either?

> +
> +static inline void edac_mc_handle_ce(struct mem_ctl_info *mci,
>  			      unsigned long page_frame_number,
>  			      unsigned long offset_in_page,
>  			      unsigned long syndrome, int row, int channel,
> -			      const char *msg);

Strange alignment, pls do

static inline void edac_mc_handle_ce(struct...,
				     unsigned...,
				     ...,
				     ...);


> -extern void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
> -				      const char *msg);
> -extern void edac_mc_handle_ue(struct mem_ctl_info *mci,
> +			      const char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> +			      page_frame_number, offset_in_page, syndrome,
> +		              row, channel, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci,
> +				      const char *msg)

ditto.

> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> +			      0, 0, 0, -1, -1, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_ue(struct mem_ctl_info *mci,
>  			      unsigned long page_frame_number,
>  			      unsigned long offset_in_page, int row,
> -			      const char *msg);

ditto.

> -extern void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
> -				      const char *msg);
> -extern void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci, unsigned int csrow,
> -				  unsigned int channel0, unsigned int channel1,
> -				  char *msg);
> -extern void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci, unsigned int csrow,
> -				  unsigned int channel, char *msg);
> +			      const char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> +			      page_frame_number, offset_in_page, 0,
> +		              row, -1, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci,
> +				      const char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> +			      0, 0, 0, -1, -1, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
> +					 unsigned int csrow,
> +					 unsigned int channel0,
> +					 unsigned int channel1,
> +					 char *msg)

Now this alignment looks correct.

> +{
> +	/*
> +	 *FIXME: The error can also be at channel1 (e. g. at the second
> +	 *	  channel of the same branch). The fix is to push
> +	 *	  edac_mc_handle_error() call into each driver
> +	 */
> +	 edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
> +			      0, 0, 0,
> +		              csrow, channel0, -1, msg, NULL, NULL);
> +}
> +
> +static inline void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
> +					 unsigned int csrow,
> +					 unsigned int channel, char *msg)
> +{
> +	 edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> +			      0, 0, 0,
> +		              csrow, channel, -1, msg, NULL, NULL);
> +}
> +
> +

Two superfluous newlines.

>  
>  /*
>   * edac_device APIs
> @@ -496,6 +557,7 @@ extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
>  extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
>  				int inst_nr, int block_nr, const char *msg);
>  extern int edac_device_alloc_index(void);
> +extern const char *edac_layer_name[];
>  
>  /*
>   * edac_pci APIs
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 6ec967a..4d4d8b7 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -44,9 +44,25 @@ static void edac_mc_dump_channel(struct rank_info *chan)
>  	debugf4("\tchannel = %p\n", chan);
>  	debugf4("\tchannel->chan_idx = %d\n", chan->chan_idx);
>  	debugf4("\tchannel->csrow = %p\n\n", chan->csrow);
> -	debugf4("\tdimm->ce_count = %d\n", chan->dimm->ce_count);
> -	debugf4("\tdimm->label = '%s'\n", chan->dimm->label);
> -	debugf4("\tdimm->nr_pages = 0x%x\n", chan->dimm->nr_pages);
> +	debugf4("\tchannel->dimm = %p\n", chan->dimm);
> +}
> +
> +static void edac_mc_dump_dimm(struct dimm_info *dimm)
> +{
> +	int i;
> +
> +	debugf4("\tdimm = %p\n", dimm);
> +	debugf4("\tdimm->label = '%s'\n", dimm->label);
> +	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
> +	debugf4("\tdimm location ");
> +	for (i = 0; i < dimm->mci->n_layers; i++) {
> +		printk(KERN_CONT "%d", dimm->location[i]);
> +		if (i < dimm->mci->n_layers - 1)
> +			printk(KERN_CONT ".");
> +	}
> +	printk(KERN_CONT "\n");

This looks hacky but I don't have a good suggestion what to do instead
here. Maybe snprintf into a complete string which you can issue with
debugf4()...

> +	debugf4("\tdimm->grain = %d\n", dimm->grain);
> +	debugf4("\tdimm->nr_pages = 0x%x\n", dimm->nr_pages);
>  }
>  
>  static void edac_mc_dump_csrow(struct csrow_info *csrow)
> @@ -70,6 +86,8 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
>  	debugf4("\tmci->edac_check = %p\n", mci->edac_check);
>  	debugf3("\tmci->nr_csrows = %d, csrows = %p\n",
>  		mci->nr_csrows, mci->csrows);
> +	debugf3("\tmci->nr_dimms = %d, dimns = %p\n",

		      ->tot_dimms      dimms

> +		mci->tot_dimms, mci->dimms);
>  	debugf3("\tdev = %p\n", mci->dev);
>  	debugf3("\tmod_name:ctl_name = %s:%s\n", mci->mod_name, mci->ctl_name);
>  	debugf3("\tpvt_info = %p\n\n", mci->pvt_info);
> @@ -157,10 +175,25 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
>  }
>  
>  /**
> - * edac_mc_alloc: Allocate a struct mem_ctl_info structure
> - * @size_pvt:	size of private storage needed
> - * @nr_csrows:	Number of CWROWS needed for this MC
> - * @nr_chans:	Number of channels for the MC
> + * edac_mc_alloc: Allocate and partially fills a struct mem_ctl_info structure

					    fill

> + * @edac_index:		Memory controller number
> + * @n_layers:		Number of layers at the MC hierarchy

				Number of MC hierarchy layers

> + * layers:		Describes each layer as seen by the Memory Controller
> + * @rev_order:		Fills csrows/cs channels at the reverse order

				      csrows/channels in reverse order

> + * @size_pvt:		size of private storage needed
> + *
> + *
> + * FIXME: drivers handle multi-rank memories on different ways: on some

						in		   in

> + * drivers, one multi-rank memory is mapped as one DIMM, while, on others,

			      memory stick			   in

> + * a single multi-rank DIMM would be mapped into several "dimms".

			  memory stick

> + *
> + * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
> + * such DIMMS properly, but the CSROWS-based ones will likely do the wrong

				   csrow-based

> + * thing, as two chip select values are used for dual-rank memories (and 4, for
> + * quad-rank ones). I suspect that this issue could be solved inside the EDAC
> + * core for SDRAM memories, but it requires further study at JEDEC JESD 21C.
> + *
> + * In summary, solving this issue is not easy, as it requires a lot of testing.
>   *
>   * Everything is kmalloc'ed as one big chunk - more efficient.
>   * Only can be used if all structures have the same lifetime - otherwise
> @@ -172,18 +205,41 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
>   *	NULL allocation failed
>   *	struct mem_ctl_info pointer
>   */
> -struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> -				unsigned nr_chans, int edac_index)
> +struct mem_ctl_info *new_edac_mc_alloc(unsigned edac_index,
> +				   unsigned n_layers,
> +				   struct edac_mc_layer *layers,
> +				   bool rev_order,
> +				   unsigned sz_pvt)

strange function argument vertical alignment

>  {
>  	void *ptr = NULL;
>  	struct mem_ctl_info *mci;
> -	struct csrow_info *csi, *csrow;
> +	struct edac_mc_layer *lay;

As before, call this "layers" pls.

> +	struct csrow_info *csi, *csr;
>  	struct rank_info *chi, *chp, *chan;
>  	struct dimm_info *dimm;
> +	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
>  	void *pvt;
> -	unsigned size;
> -	int row, chn;
> +	unsigned size, tot_dimms, count, pos[EDAC_MAX_LAYERS];
> +	unsigned tot_csrows, tot_cschannels;

No need to call this "tot_cschannels" - "tot_channels" should be enough.

> +	int i, j;
>  	int err;
> +	int row, chn;

All those local variables should be sorted in a reverse christmas tree
order:

	u32 this_is_the_longest_array_name[LENGTH];
	void *shorter_named_variable;
	unsigned long size;
	int i;

	...

> +
> +	BUG_ON(n_layers > EDAC_MAX_LAYERS);


Push this BUG_ON up into edac_mc_alloc as the first thing this function
does. Also, is it valid to have n_layers == 0? The memcpy call below
will do nothing.


> +	/*
> +	 * Calculate the total amount of dimms and csrows/cschannels while
> +	 * in the old API emulation mode
> +	 */
> +	tot_dimms = 1;
> +	tot_cschannels = 1;
> +	tot_csrows = 1;

Those initializations can be done above at variable declaration time.

> +	for (i = 0; i < n_layers; i++) {
> +		tot_dimms *= layers[i].size;
> +		if (layers[i].is_virt_csrow)
> +			tot_csrows *= layers[i].size;
> +		else
> +			tot_cschannels *= layers[i].size;
> +	}
>  
>  	/* Figure out the offsets of the various items from the start of an mc
>  	 * structure.  We want the alignment of each item to be at least as
> @@ -191,12 +247,21 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>  	 * hardcode everything into a single struct.
>  	 */
>  	mci = edac_align_ptr(&ptr, sizeof(*mci), 1);
> -	csi = edac_align_ptr(&ptr, sizeof(*csi), nr_csrows);
> -	chi = edac_align_ptr(&ptr, sizeof(*chi), nr_csrows * nr_chans);
> -	dimm = edac_align_ptr(&ptr, sizeof(*dimm), nr_csrows * nr_chans);
> +	lay = edac_align_ptr(&ptr, sizeof(*lay), n_layers);
> +	csi = edac_align_ptr(&ptr, sizeof(*csi), tot_csrows);
> +	chi = edac_align_ptr(&ptr, sizeof(*chi), tot_csrows * tot_cschannels);
> +	dimm = edac_align_ptr(&ptr, sizeof(*dimm), tot_dimms);
> +	count = 1;

ditto.

> +	for (i = 0; i < n_layers; i++) {
> +		count *= layers[i].size;
> +		ce_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
> +		ue_per_layer[i] = edac_align_ptr(&ptr, sizeof(u32), count);
> +	}
>  	pvt = edac_align_ptr(&ptr, sz_pvt, 1);
>  	size = ((unsigned long)pvt) + sz_pvt;
>  
> +	debugf1("%s(): allocating %u bytes for mci data (%d dimms, %d csrows/channels)\n",
> +		__func__, size, tot_dimms, tot_csrows * tot_cschannels);
>  	mci = kzalloc(size, GFP_KERNEL);
>  	if (mci == NULL)
>  		return NULL;
> @@ -204,42 +269,99 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>  	/* Adjust pointers so they point within the memory we just allocated
>  	 * rather than an imaginary chunk of memory located at address 0.
>  	 */
> +	lay = (struct edac_mc_layer *)(((char *)mci) + ((unsigned long)lay));
>  	csi = (struct csrow_info *)(((char *)mci) + ((unsigned long)csi));
>  	chi = (struct rank_info *)(((char *)mci) + ((unsigned long)chi));
>  	dimm = (struct dimm_info *)(((char *)mci) + ((unsigned long)dimm));
> +	for (i = 0; i < n_layers; i++) {
> +		mci->ce_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ce_per_layer[i]));
> +		mci->ue_per_layer[i] = (u32 *)((char *)mci + ((unsigned long)ue_per_layer[i]));
> +	}
>  	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
>  
>  	/* setup index and various internal pointers */
>  	mci->mc_idx = edac_index;
>  	mci->csrows = csi;
>  	mci->dimms  = dimm;
> +	mci->tot_dimms = tot_dimms;
>  	mci->pvt_info = pvt;
> -	mci->nr_csrows = nr_csrows;
> +	mci->n_layers = n_layers;
> +	mci->layers = lay;
> +	memcpy(mci->layers, layers, sizeof(*lay) * n_layers);
> +	mci->nr_csrows = tot_csrows;
> +	mci->num_cschannel = tot_cschannels;
>  
>  	/*
> -	 * For now, assumes that a per-csrow arrangement for dimms.
> -	 * This will be latter changed.
> +	 * Fills the csrow struct
>  	 */
> -	dimm = mci->dimms;
> -
> -	for (row = 0; row < nr_csrows; row++) {
> -		csrow = &csi[row];
> -		csrow->csrow_idx = row;
> -		csrow->mci = mci;
> -		csrow->nr_channels = nr_chans;
> -		chp = &chi[row * nr_chans];
> -		csrow->channels = chp;
> -
> -		for (chn = 0; chn < nr_chans; chn++) {
> +	for (row = 0; row < tot_csrows; row++) {
> +		csr = &csi[row];
> +		csr->csrow_idx = row;
> +		csr->mci = mci;
> +		csr->nr_channels = tot_cschannels;
> +		chp = &chi[row * tot_cschannels];
> +		csr->channels = chp;
> +
> +		for (chn = 0; chn < tot_cschannels; chn++) {
>  			chan = &chp[chn];
>  			chan->chan_idx = chn;
> -			chan->csrow = csrow;
> +			chan->csrow = csr;
> +		}
> +	}
>  
> -			mci->csrows[row].channels[chn].dimm = dimm;
> -			dimm->csrow = row;
> -			dimm->csrow_channel = chn;
> -			dimm++;
> -			mci->nr_dimms++;
> +	/*
> +	 * Fills the dimm struct
> +	 */
> +	memset(&pos, 0, sizeof(pos));
> +	row = 0;
> +	chn = 0;
> +	debugf4("%s: initializing %d dimms\n", __func__, tot_dimms);
> +	for (i = 0; i < tot_dimms; i++) {
> +		chan = &csi[row].channels[chn];
> +		dimm = EDAC_DIMM_PTR(lay, mci->dimms, n_layers,
> +			       pos[0], pos[1], pos[2]);
> +		dimm->mci = mci;
> +
> +		debugf2("%s: %d: dimm%zd (%d:%d:%d): row %d, chan %d\n", __func__,
> +			i, (dimm - mci->dimms),
> +			pos[0], pos[1], pos[2], row, chn);
> +
> +		/* Copy DIMM location */
> +		for (j = 0; j < n_layers; j++)
> +			dimm->location[j] = pos[j];
> +
> +		/* Link it to the csrows old API data */
> +		chan->dimm = dimm;
> +		dimm->csrow = row;
> +		dimm->cschannel = chn;
> +
> +		/* Increment csrow location */
> +		if (!rev_order) {
> +			for (j = n_layers - 1; j >= 0; j--)
> +				if (!layers[j].is_virt_csrow)
> +					break;
> +			chn++;
> +			if (chn == tot_cschannels) {
> +				chn = 0;
> +				row++;
> +			}
> +		} else {
> +			for (j = n_layers - 1; j >= 0; j--)
> +				if (layers[j].is_virt_csrow)
> +					break;
> +			row++;
> +			if (row == tot_csrows) {
> +				row = 0;
> +				chn++;
> +			}
> +		}
> +
> +		/* Increment dimm location */
> +		for (j = n_layers - 1; j >= 0; j--) {
> +			pos[j]++;
> +			if (pos[j] < layers[j].size)
> +				break;
> +			pos[j] = 0;
>  		}
>  	}
>  
> @@ -263,6 +385,57 @@ struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
>  	 */
>  	return mci;
>  }
> +EXPORT_SYMBOL_GPL(new_edac_mc_alloc);
> +
> +/**
> + * edac_mc_alloc: Allocate and partially fills a struct mem_ctl_info structure
> + * @edac_index:		Memory controller number
> + * @n_layers:		Nu
> +mber of layers at the MC hierarchy
> + * layers:		Describes each layer as seen by the Memory Controller
> + * @rev_order:		Fills csrows/cs channels at the reverse order
> + * @size_pvt:		size of private storage needed
> + *
> + *
> + * FIXME: drivers handle multi-rank memories on different ways: on some
> + * drivers, one multi-rank memory is mapped as one DIMM, while, on others,
> + * a single multi-rank DIMM would be mapped into several "dimms".
> + *
> + * Non-csrow based drivers (like FB-DIMM and RAMBUS ones) will likely report
> + * such DIMMS properly, but the CSROWS-based ones will likely do the wrong
> + * thing, as two chip select values are used for dual-rank memories (and 4, for
> + * quad-rank ones). I suspect that this issue could be solved inside the EDAC
> + * core for SDRAM memories, but it requires further study at JEDEC JESD 21C.
> + *
> + * In summary, solving this issue is not easy, as it requires a lot of testing.
> + *
> + * Everything is kmalloc'ed as one big chunk - more efficient.
> + * Only can be used if all structures have the same lifetime - otherwise
> + * you have to allocate and initialize your own structures.
> + *
> + * Use edac_mc_free() to free mc structures allocated by this function.
> + *
> + * Returns:
> + *	NULL allocation failed
> + *	struct mem_ctl_info pointer
> + */
> +
> +struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> +				   unsigned nr_chans, int edac_index)
> +{
> +	unsigned n_layers = 2;
> +	struct edac_mc_layer layers[n_layers];
> +
> +	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
> +	layers[0].size = nr_csrows;
> +	layers[0].is_virt_csrow = true;
> +	layers[1].type = EDAC_MC_LAYER_CHANNEL;
> +	layers[1].size = nr_chans;
> +	layers[1].is_virt_csrow = false;
> +
> +	return new_edac_mc_alloc(edac_index, ARRAY_SIZE(layers), layers,
> +			  false, sz_pvt);
> +}
>  EXPORT_SYMBOL_GPL(edac_mc_alloc);
>  
>  /**
> @@ -528,7 +701,6 @@ EXPORT_SYMBOL(edac_mc_find);
>   * edac_mc_add_mc: Insert the 'mci' structure into the mci global list and
>   *                 create sysfs entries associated with mci structure
>   * @mci: pointer to the mci structure to be added to the list
> - * @mc_idx: A unique numeric identifier to be assigned to the 'mci' structure.
>   *
>   * Return:
>   *	0	Success
> @@ -555,6 +727,8 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
>  				edac_mc_dump_channel(&mci->csrows[i].
>  						channels[j]);
>  		}
> +		for (i = 0; i < mci->tot_dimms; i++)
> +			edac_mc_dump_dimm(&mci->dimms[i]);
>  	}
>  #endif
>  	mutex_lock(&mem_ctls_mutex);
> @@ -712,261 +886,249 @@ int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci, unsigned long page)
>  }
>  EXPORT_SYMBOL_GPL(edac_mc_find_csrow_by_page);
>  
> -/* FIXME - setable log (warning/emerg) levels */
> -/* FIXME - integrate with evlog: http://evlog.sourceforge.net/ */
> -void edac_mc_handle_ce(struct mem_ctl_info *mci,
> -		unsigned long page_frame_number,
> -		unsigned long offset_in_page, unsigned long syndrome,
> -		int row, int channel, const char *msg)
> +const char *edac_layer_name[] = {
> +	[EDAC_MC_LAYER_BRANCH] = "branch",
> +	[EDAC_MC_LAYER_CHANNEL] = "channel",
> +	[EDAC_MC_LAYER_SLOT] = "slot",
> +	[EDAC_MC_LAYER_CHIP_SELECT] = "csrow",
> +};
> +EXPORT_SYMBOL_GPL(edac_layer_name);
> +
> +static void edac_increment_ce_error(struct mem_ctl_info *mci,
> +				    bool enable_filter,
> +				    unsigned pos[EDAC_MAX_LAYERS])
>  {
> -	unsigned long remapped_page;
> -	char *label = NULL;
> -	u32 grain;
> +	int i, index = 0;
>  
> -	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
> +	mci->ce_mc++;
>  
> -	/* FIXME - maybe make panic on INTERNAL ERROR an option */
> -	if (row >= mci->nr_csrows || row < 0) {
> -		/* something is wrong */
> -		edac_mc_printk(mci, KERN_ERR,
> -			"INTERNAL ERROR: row out of range "
> -			"(%d >= %d)\n", row, mci->nr_csrows);
> -		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
> +	if (!enable_filter) {
> +		mci->ce_noinfo_count++;
>  		return;
>  	}
>  
> -	if (channel >= mci->csrows[row].nr_channels || channel < 0) {
> -		/* something is wrong */
> -		edac_mc_printk(mci, KERN_ERR,
> -			"INTERNAL ERROR: channel out of range "
> -			"(%d >= %d)\n", channel,
> -			mci->csrows[row].nr_channels);
> -		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
> -		return;
> -	}
> -
> -	label = mci->csrows[row].channels[channel].dimm->label;
> -	grain = mci->csrows[row].channels[channel].dimm->grain;
> +	for (i = 0; i < mci->n_layers; i++) {
> +		if (pos[i] < 0)
> +			break;
> +		index += pos[i];
> +		mci->ce_per_layer[i][index]++;
>  
> -	if (edac_mc_get_log_ce())
> -		/* FIXME - put in DIMM location */
> -		edac_mc_printk(mci, KERN_WARNING,
> -			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
> -			"0x%lx, row %d, channel %d, label \"%s\": %s\n",
> -			page_frame_number, offset_in_page,
> -			grain, syndrome, row, channel,
> -			label, msg);
> +		if (i < mci->n_layers - 1)
> +			index *= mci->layers[i + 1].size;
> +	}
> +}
>  
> -	mci->ce_count++;
> -	mci->csrows[row].ce_count++;
> -	mci->csrows[row].channels[channel].dimm->ce_count++;
> -	mci->csrows[row].channels[channel].ce_count++;
> +static void edac_increment_ue_error(struct mem_ctl_info *mci,
> +				    bool enable_filter,
> +				    unsigned pos[EDAC_MAX_LAYERS])
> +{
> +	int i, index = 0;
>  
> -	if (mci->scrub_mode & SCRUB_SW_SRC) {
> -		/*
> -		 * Some MC's can remap memory so that it is still available
> -		 * at a different address when PCI devices map into memory.
> -		 * MC's that can't do this lose the memory where PCI devices
> -		 * are mapped.  This mapping is MC dependent and so we call
> -		 * back into the MC driver for it to map the MC page to
> -		 * a physical (CPU) page which can then be mapped to a virtual
> -		 * page - which can then be scrubbed.
> -		 */
> -		remapped_page = mci->ctl_page_to_phys ?
> -			mci->ctl_page_to_phys(mci, page_frame_number) :
> -			page_frame_number;
> +	mci->ue_mc++;
>  
> -		edac_mc_scrub_block(remapped_page, offset_in_page, grain);
> +	if (!enable_filter) {
> +		mci->ce_noinfo_count++;
> +		return;
>  	}
> -}
> -EXPORT_SYMBOL_GPL(edac_mc_handle_ce);
>  
> -void edac_mc_handle_ce_no_info(struct mem_ctl_info *mci, const char *msg)
> -{
> -	if (edac_mc_get_log_ce())
> -		edac_mc_printk(mci, KERN_WARNING,
> -			"CE - no information available: %s\n", msg);
> +	for (i = 0; i < mci->n_layers; i++) {
> +		if (pos[i] < 0)
> +			break;
> +		index += pos[i];
> +		mci->ue_per_layer[i][index]++;
>  
> -	mci->ce_noinfo_count++;
> -	mci->ce_count++;
> +		if (i < mci->n_layers - 1)
> +			index *= mci->layers[i + 1].size;
> +	}
>  }
> -EXPORT_SYMBOL_GPL(edac_mc_handle_ce_no_info);
>  
> -void edac_mc_handle_ue(struct mem_ctl_info *mci,
> -		unsigned long page_frame_number,
> -		unsigned long offset_in_page, int row, const char *msg)
> +#define OTHER_LABEL " or "
> +void edac_mc_handle_error(const enum hw_event_mc_err_type type,
> +			  struct mem_ctl_info *mci,
> +			  const unsigned long page_frame_number,
> +			  const unsigned long offset_in_page,
> +			  const unsigned long syndrome,
> +			  const int layer0,
> +			  const int layer1,
> +			  const int layer2,
> +			  const char *msg,
> +			  const char *other_detail,
> +			  const void *mcelog)
>  {
> -	int len = EDAC_MC_LABEL_LEN * 4;
> -	char labels[len + 1];
> -	char *pos = labels;
> -	int chan;
> -	int chars;
> -	char *label = NULL;
> +	unsigned long remapped_page;
> +	/* FIXME: too much for stack: move it to some pre-alocated area */
> +	char detail[80], location[80];
> +	char label[(EDAC_MC_LABEL_LEN + 1 + sizeof(OTHER_LABEL)) * mci->tot_dimms];
> +	char *p;
> +	int row = -1, chan = -1;
> +	int pos[EDAC_MAX_LAYERS] = { layer0, layer1, layer2 };
> +	int i;
>  	u32 grain;
> +	bool enable_filter = false;
>  
>  	debugf3("MC%d: %s()\n", mci->mc_idx, __func__);
>  
> -	/* FIXME - maybe make panic on INTERNAL ERROR an option */
> -	if (row >= mci->nr_csrows || row < 0) {
> -		/* something is wrong */
> -		edac_mc_printk(mci, KERN_ERR,
> -			"INTERNAL ERROR: row out of range "
> -			"(%d >= %d)\n", row, mci->nr_csrows);
> -		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
> -		return;
> -	}
> -
> -	grain = mci->csrows[row].channels[0].dimm->grain;
> -	label = mci->csrows[row].channels[0].dimm->label;
> -	chars = snprintf(pos, len + 1, "%s", label);
> -	len -= chars;
> -	pos += chars;
> -
> -	for (chan = 1; (chan < mci->csrows[row].nr_channels) && (len > 0);
> -		chan++) {
> -		label = mci->csrows[row].channels[chan].dimm->label;
> -		chars = snprintf(pos, len + 1, ":%s", label);
> -		len -= chars;
> -		pos += chars;
> +	/* Check if the event report is consistent */
> +	for (i = 0; i < mci->n_layers; i++) {
> +		if (pos[i] >= (int)mci->layers[i].size) {
> +			if (type == HW_EVENT_ERR_CORRECTED) {
> +				p = "CE";
> +				mci->ce_mc++;
> +			} else {
> +				p = "UE";
> +				mci->ue_mc++;
> +			}
> +			edac_mc_printk(mci, KERN_ERR,
> +				       "INTERNAL ERROR: %s value is out of range (%d >= %d)\n",
> +				       edac_layer_name[mci->layers[i].type],
> +				       pos[i], mci->layers[i].size);
> +			/*
> +			 * Instead of just returning it, let's use what's
> +			 * known about the error. The increment routines and
> +			 * the DIMM filter logic will do the right thing by
> +			 * pointing the likely damaged DIMMs.
> +			 */
> +			pos[i] = -1;
> +		}
> +		if (pos[i] >= 0)
> +			enable_filter = true;
>  	}
>  
> -	if (edac_mc_get_log_ue())
> -		edac_mc_printk(mci, KERN_EMERG,
> -			"UE page 0x%lx, offset 0x%lx, grain %d, row %d, "
> -			"labels \"%s\": %s\n", page_frame_number,
> -			offset_in_page, grain, row, labels, msg);
> -
> -	if (edac_mc_get_panic_on_ue())
> -		panic("EDAC MC%d: UE page 0x%lx, offset 0x%lx, grain %d, "
> -			"row %d, labels \"%s\": %s\n", mci->mc_idx,
> -			page_frame_number, offset_in_page,
> -			grain, row, labels, msg);
> -
> -	mci->ue_count++;
> -	mci->csrows[row].ue_count++;
> -}
> -EXPORT_SYMBOL_GPL(edac_mc_handle_ue);
> +	/*
> +	 * Get the dimm label/grain that applies to the match criteria.
> +	 * As the error algorithm may not be able to point to just one memory,
> +	 * the logic here will get all possible labels that could pottentially
> +	 * be affected by the error.
> +	 * On FB-DIMM memory controllers, for uncorrected errors, it is common
> +	 * to have only the MC channel and the MC dimm (also called as "rank")
> +	 * but the channel is not known, as the memory is arranged in pairs,
> +	 * where each memory belongs to a separate channel within the same
> +	 * branch.
> +	 * It will also get the max grain, over the error match range
> +	 */
> +	grain = 0;
> +	p = label;
> +	*p = '\0';
> +	for (i = 0; i < mci->tot_dimms; i++) {
> +		struct dimm_info *dimm = &mci->dimms[i];
>  
> -void edac_mc_handle_ue_no_info(struct mem_ctl_info *mci, const char *msg)
> -{
> -	if (edac_mc_get_panic_on_ue())
> -		panic("EDAC MC%d: Uncorrected Error", mci->mc_idx);
> +		if (layer0 >= 0 && layer0 != dimm->location[0])
> +			continue;
> +		if (layer1 >= 0 && layer1 != dimm->location[1])
> +			continue;
> +		if (layer2 >= 0 && layer2 != dimm->location[2])
> +			continue;
>  
> -	if (edac_mc_get_log_ue())
> -		edac_mc_printk(mci, KERN_WARNING,
> -			"UE - no information available: %s\n", msg);
> -	mci->ue_noinfo_count++;
> -	mci->ue_count++;
> -}
> -EXPORT_SYMBOL_GPL(edac_mc_handle_ue_no_info);
> +		if (dimm->grain > grain)
> +			grain = dimm->grain;
>  
> -/*************************************************************
> - * On Fully Buffered DIMM modules, this help function is
> - * called to process UE events
> - */
> -void edac_mc_handle_fbd_ue(struct mem_ctl_info *mci,
> -			unsigned int csrow,
> -			unsigned int channela,
> -			unsigned int channelb, char *msg)
> -{
> -	int len = EDAC_MC_LABEL_LEN * 4;
> -	char labels[len + 1];
> -	char *pos = labels;
> -	int chars;
> -	char *label;
> -
> -	if (csrow >= mci->nr_csrows) {
> -		/* something is wrong */
> -		edac_mc_printk(mci, KERN_ERR,
> -			"INTERNAL ERROR: row out of range (%d >= %d)\n",
> -			csrow, mci->nr_csrows);
> -		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
> -		return;
> +		/*
> +		 * If the error is memory-controller wide, there's no sense
> +		 * on seeking for the affected DIMMs, as everything may be
> +		 * affected. Also, don't show errors for non-filled dimm's.
> +		 */
> +		if (enable_filter && dimm->nr_pages) {
> +			if (p != label) {
> +				strcpy(p, OTHER_LABEL);
> +				p += strlen(OTHER_LABEL);
> +			}
> +			strcpy(p, dimm->label);
> +			p += strlen(p);
> +			*p = '\0';
> +
> +			/*
> +			 * get csrow/channel of the dimm, in order to allow
> +			 * incrementing the compat API counters
> +			 */
> +			debugf4("%s: dimm csrows (%d,%d)\n",
> +				__func__, dimm->csrow, dimm->cschannel);
> +			if (row == -1)
> +				row = dimm->csrow;
> +			else if (row >= 0 && row != dimm->csrow)
> +				row = -2;
> +			if (chan == -1)
> +				chan = dimm->cschannel;
> +			else if (chan >= 0 && chan != dimm->cschannel)
> +				chan = -2;
> +		}
>  	}
> -
> -	if (channela >= mci->csrows[csrow].nr_channels) {
> -		/* something is wrong */
> -		edac_mc_printk(mci, KERN_ERR,
> -			"INTERNAL ERROR: channel-a out of range "
> -			"(%d >= %d)\n",
> -			channela, mci->csrows[csrow].nr_channels);
> -		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
> -		return;
> +	if (!enable_filter) {
> +		strcpy(label, "any memory");
> +	} else {
> +		debugf4("%s: csrow/channel to increment: (%d,%d)\n",
> +			__func__, row, chan);
> +		if (p == label)
> +			strcpy(label, "unknown memory");
> +		if (type == HW_EVENT_ERR_CORRECTED) {
> +			if (row >= 0) {
> +				mci->csrows[row].ce_count++;
> +				if (chan >= 0)
> +					mci->csrows[row].channels[chan].ce_count++;
> +			}
> +		} else
> +			if (row >= 0)
> +				mci->csrows[row].ue_count++;
>  	}
>  
> -	if (channelb >= mci->csrows[csrow].nr_channels) {
> -		/* something is wrong */
> -		edac_mc_printk(mci, KERN_ERR,
> -			"INTERNAL ERROR: channel-b out of range "
> -			"(%d >= %d)\n",
> -			channelb, mci->csrows[csrow].nr_channels);
> -		edac_mc_handle_ue_no_info(mci, "INTERNAL ERROR");
> -		return;
> +	/* Fill the RAM location data */
> +	p = location;
> +	for (i = 0; i < mci->n_layers; i++) {
> +		if (pos[i] < 0)
> +			continue;
> +		p += sprintf(p, "%s %d ",
> +			     edac_layer_name[mci->layers[i].type],
> +			     pos[i]);
>  	}
>  
> -	mci->ue_count++;
> -	mci->csrows[csrow].ue_count++;
> -
> -	/* Generate the DIMM labels from the specified channels */
> -	label = mci->csrows[csrow].channels[channela].dimm->label;
> -	chars = snprintf(pos, len + 1, "%s", label);
> -	len -= chars;
> -	pos += chars;
> -
> -	chars = snprintf(pos, len + 1, "-%s",
> -			mci->csrows[csrow].channels[channelb].dimm->label);
> -
> -	if (edac_mc_get_log_ue())
> -		edac_mc_printk(mci, KERN_EMERG,
> -			"UE row %d, channel-a= %d channel-b= %d "
> -			"labels \"%s\": %s\n", csrow, channela, channelb,
> -			labels, msg);
> -
> -	if (edac_mc_get_panic_on_ue())
> -		panic("UE row %d, channel-a= %d channel-b= %d "
> -			"labels \"%s\": %s\n", csrow, channela,
> -			channelb, labels, msg);
> -}
> -EXPORT_SYMBOL(edac_mc_handle_fbd_ue);
> +	/* Memory type dependent details about the error */
> +	if (type == HW_EVENT_ERR_CORRECTED)
> +		snprintf(detail, sizeof(detail),
> +			"page 0x%lx offset 0x%lx grain %d syndrome 0x%lx",
> +			page_frame_number, offset_in_page,
> +			grain, syndrome);
> +	else
> +		snprintf(detail, sizeof(detail),
> +			"page 0x%lx offset 0x%lx grain %d",
> +			page_frame_number, offset_in_page, grain);
> +
> +	if (type == HW_EVENT_ERR_CORRECTED) {
> +		if (edac_mc_get_log_ce())
> +			edac_mc_printk(mci, KERN_WARNING,
> +				       "CE %s on %s (%s%s %s)\n",
> +				       msg, label, location,
> +				       detail, other_detail);
> +		edac_increment_ce_error(mci, enable_filter, pos);
> +
> +		if (mci->scrub_mode & SCRUB_SW_SRC) {
> +			/*
> +			 * Some MC's can remap memory so that it is still
> +			 * available at a different address when PCI devices
> +			 * map into memory.
> +			 * MC's that can't do this lose the memory where PCI
> +			 * devices are mapped. This mapping is MC dependent
> +			 * and so we call back into the MC driver for it to
> +			 * map the MC page to a physical (CPU) page which can
> +			 * then be mapped to a virtual page - which can then
> +			 * be scrubbed.
> +			 */
> +			remapped_page = mci->ctl_page_to_phys ?
> +				mci->ctl_page_to_phys(mci, page_frame_number) :
> +				page_frame_number;
> +
> +			edac_mc_scrub_block(remapped_page,
> +					    offset_in_page, grain);
> +		}
> +	} else {
> +		if (edac_mc_get_log_ue())
> +			edac_mc_printk(mci, KERN_WARNING,
> +				"UE %s on %s (%s%s %s)\n",
> +				msg, label, location, detail, other_detail);
>  
> -/*************************************************************
> - * On Fully Buffered DIMM modules, this help function is
> - * called to process CE events
> - */
> -void edac_mc_handle_fbd_ce(struct mem_ctl_info *mci,
> -			unsigned int csrow, unsigned int channel, char *msg)
> -{
> -	char *label = NULL;
> +		if (edac_mc_get_panic_on_ue())
> +			panic("UE %s on %s (%s%s %s)\n",
> +			      msg, label, location, detail, other_detail);
>  
> -	/* Ensure boundary values */
> -	if (csrow >= mci->nr_csrows) {
> -		/* something is wrong */
> -		edac_mc_printk(mci, KERN_ERR,
> -			"INTERNAL ERROR: row out of range (%d >= %d)\n",
> -			csrow, mci->nr_csrows);
> -		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
> -		return;
> +		edac_increment_ue_error(mci, enable_filter, pos);
>  	}
> -	if (channel >= mci->csrows[csrow].nr_channels) {
> -		/* something is wrong */
> -		edac_mc_printk(mci, KERN_ERR,
> -			"INTERNAL ERROR: channel out of range (%d >= %d)\n",
> -			channel, mci->csrows[csrow].nr_channels);
> -		edac_mc_handle_ce_no_info(mci, "INTERNAL ERROR");
> -		return;
> -	}
> -
> -	label = mci->csrows[csrow].channels[channel].dimm->label;
> -
> -	if (edac_mc_get_log_ce())
> -		/* FIXME - put in DIMM location */
> -		edac_mc_printk(mci, KERN_WARNING,
> -			"CE row %d, channel %d, label \"%s\": %s\n",
> -			csrow, channel, label, msg);
> -
> -	mci->ce_count++;
> -	mci->csrows[csrow].ce_count++;
> -	mci->csrows[csrow].channels[channel].dimm->ce_count++;
> -	mci->csrows[csrow].channels[channel].ce_count++;
>  }
> -EXPORT_SYMBOL(edac_mc_handle_fbd_ce);
> +EXPORT_SYMBOL_GPL(edac_mc_handle_error);
> diff --git a/include/linux/edac.h b/include/linux/edac.h
> index 3b8798d..412d5cd 100644
> --- a/include/linux/edac.h
> +++ b/include/linux/edac.h
> @@ -412,18 +412,20 @@ struct edac_mc_layer {
>  /* FIXME: add the proper per-location error counts */
>  struct dimm_info {
>  	char label[EDAC_MC_LABEL_LEN + 1];	/* DIMM label on motherboard */
> -	unsigned memory_controller;
> -	unsigned csrow;
> -	unsigned csrow_channel;
> +
> +	/* Memory location data */
> +	unsigned location[EDAC_MAX_LAYERS];
> +
> +	struct mem_ctl_info *mci;	/* the parent */
>  
>  	u32 grain;		/* granularity of reported error in bytes */
>  	enum dev_type dtype;	/* memory device type */
>  	enum mem_type mtype;	/* memory dimm type */
>  	enum edac_type edac_mode;	/* EDAC mode for this dimm */
>  
> -	u32 nr_pages;			/* number of pages in csrow */
> +	u32 nr_pages;			/* number of pages on this dimm */
>  
> -	u32 ce_count;		/* Correctable Errors for this dimm */
> +	unsigned csrow, cschannel;	/* Points to the old API data */
>  };
>  
>  /**
> @@ -443,9 +445,10 @@ struct dimm_info {
>   */
>  struct rank_info {
>  	int chan_idx;
> -	u32 ce_count;
>  	struct csrow_info *csrow;
>  	struct dimm_info *dimm;
> +
> +	u32 ce_count;		/* Correctable Errors for this csrow */
>  };
>  
>  struct csrow_info {
> @@ -497,6 +500,11 @@ struct mcidev_sysfs_attribute {
>          ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
>  };
>  
> +struct edac_hierarchy {
> +	char		*name;
> +	unsigned	nr;
> +};
> +
>  /* MEMORY controller information structure
>   */
>  struct mem_ctl_info {
> @@ -541,13 +549,16 @@ struct mem_ctl_info {
>  	unsigned long (*ctl_page_to_phys) (struct mem_ctl_info * mci,
>  					   unsigned long page);
>  	int mc_idx;
> -	int nr_csrows;
>  	struct csrow_info *csrows;
> +	unsigned nr_csrows, num_cschannel;
>  
> +	/* Memory Controller hierarchy */
> +	unsigned n_layers;
> +	struct edac_mc_layer *layers;
>  	/*
>  	 * DIMM info. Will eventually remove the entire csrows_info some day
>  	 */
> -	unsigned nr_dimms;
> +	unsigned tot_dimms;
>  	struct dimm_info *dimms;
>  
>  	/*
> @@ -562,12 +573,15 @@ struct mem_ctl_info {
>  	const char *dev_name;
>  	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
>  	void *pvt_info;
> -	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
> -	u32 ce_noinfo_count;	/* Correctable Errors w/o info */
> -	u32 ue_count;		/* Total Uncorrectable Errors for this MC */
> -	u32 ce_count;		/* Total Correctable Errors for this MC */
> +	u32 ue_count;           /* Total Uncorrectable Errors for this MC */
> +	u32 ce_count;           /* Total Correctable Errors for this MC */
>  	unsigned long start_time;	/* mci load start time (in jiffies) */
>  
> +	/* drivers shouldn't access this struct directly */
> +	unsigned ce_noinfo_count, ue_noinfo_count;
> +	unsigned ce_mc, ue_mc;
> +	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
> +
>  	struct completion complete;
>  
>  	/* edac sysfs device control */
> @@ -580,7 +594,7 @@ struct mem_ctl_info {
>  	 * by the low level driver.
>  	 *
>  	 * Set by the low level driver to provide attributes at the
> -	 * controller level, same level as 'ue_count' and 'ce_count' above.
> +	 * controller level.
>  	 * An array of structures, NULL terminated
>  	 *
>  	 * If attributes are desired, then set to array of attributes
> -- 
> 1.7.8
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
