Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2DQSs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:48:28 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:43366 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2DQSs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:48:27 -0400
Date: Tue, 17 Apr 2012 20:48:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: [EDAC PATCH v13 4/7] edac: move nr_pages to dimm struct
Message-ID: <20120417184808.GD13989@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-5-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1334607133-30039-5-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 05:12:10PM -0300, Mauro Carvalho Chehab wrote:
> The number of pages is a dimm property. Move it to the dimm struct.
> 
> After this change, it is possible to add sysfs nodes for the DIMM's that

Minor nitpick:

                                                               DIMMs

Please go over the rest of the commit messages because they have similar
typos.

> will properly represent the DIMM stick properties, including its size.
> 
> A TODO fix here is to properly represent dual-rank/quad-rank DIMMs when
> the memory controller represents the memory via chip select rows.
> 
> Reviewed-by: Aristeu Rozanski <arozansk@redhat.com>
> Cc: Doug Thompson <norsk5@yahoo.com>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Cc: Mark Gross <mark.gross@intel.com>
> Cc: Jason Uhlenkott <juhlenko@akamai.com>
> Cc: Tim Small <tim@buttersideup.com>
> Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
> Cc: "Arvind R." <arvino55@gmail.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Egor Martovetsky <egor@pasemi.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Joe Perches <joe@perches.com>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Hitoshi Mitake <h.mitake@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Niklas Söderlund" <niklas.soderlund@ericsson.com>
> Cc: Shaohui Xie <Shaohui.Xie@freescale.com>
> Cc: Josh Boyer <jwboyer@gmail.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/amd64_edac.c      |   12 +++------
>  drivers/edac/amd76x_edac.c     |    6 ++--
>  drivers/edac/cell_edac.c       |    8 ++++--
>  drivers/edac/cpc925_edac.c     |    8 ++++--
>  drivers/edac/e752x_edac.c      |    6 +++-
>  drivers/edac/e7xxx_edac.c      |    5 ++-
>  drivers/edac/edac_mc.c         |   16 ++++++++-----
>  drivers/edac/edac_mc_sysfs.c   |   47 ++++++++++++++++++++++++++++------------
>  drivers/edac/i3000_edac.c      |    6 +++-
>  drivers/edac/i3200_edac.c      |    3 +-
>  drivers/edac/i5000_edac.c      |   14 ++++++-----
>  drivers/edac/i5100_edac.c      |   22 +++++++++++-------
>  drivers/edac/i5400_edac.c      |    9 ++-----
>  drivers/edac/i7300_edac.c      |   22 +++++-------------
>  drivers/edac/i7core_edac.c     |   10 ++------
>  drivers/edac/i82443bxgx_edac.c |    2 +-
>  drivers/edac/i82860_edac.c     |    2 +-
>  drivers/edac/i82875p_edac.c    |    5 ++-
>  drivers/edac/i82975x_edac.c    |   11 ++++++--
>  drivers/edac/mpc85xx_edac.c    |    3 +-
>  drivers/edac/mv64x60_edac.c    |    3 +-
>  drivers/edac/pasemi_edac.c     |   14 ++++++------
>  drivers/edac/ppc4xx_edac.c     |    5 ++-
>  drivers/edac/r82600_edac.c     |    3 +-
>  drivers/edac/sb_edac.c         |    8 +-----
>  drivers/edac/tile_edac.c       |    2 +-
>  drivers/edac/x38_edac.c        |    4 +-
>  include/linux/edac.h           |    8 ++++--
>  28 files changed, 144 insertions(+), 120 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 0be3f29..8804ac8 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2126,12 +2126,6 @@ static u32 amd64_csrow_nr_pages(struct amd64_pvt *pvt, u8 dct, int csrow_nr)
>  
>  	nr_pages = pvt->ops->dbam_to_cs(pvt, dct, cs_mode) << (20 - PAGE_SHIFT);
>  
> -	/*
> -	 * If dual channel then double the memory size of single channel.
> -	 * Channel count is 1 or 2
> -	 */
> -	nr_pages <<= (pvt->channel_count - 1);

This changes DEBUG output from:

EDAC DEBUG: init_csrows: ----CSROW 0 VALID for MC node 0
EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=0) DBAM map index= 8
EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 1048576  channel-count = 2
EDAC amd64: CS0: Registered DDR3 RAM
EDAC DEBUG: init_csrows:   for MC node 0 csrow 0:
EDAC DEBUG: init_csrows:     nr_pages: 1048576

to

EDAC DEBUG: init_csrows: ----CSROW 0 VALID for MC node 0
EDAC DEBUG: amd64_csrow_nr_pages:   (csrow=0) DBAM map index= 8
EDAC DEBUG: amd64_csrow_nr_pages:     nr_pages= 524288  channel-count = 2

which is only half the pages.

> -
>  	debugf0("  (csrow=%d) DBAM map index= %d\n", csrow_nr, cs_mode);
>  	debugf0("    nr_pages= %u  channel-count = %d\n",
>  		nr_pages, pvt->channel_count);
> @@ -2152,6 +2146,7 @@ static int init_csrows(struct mem_ctl_info *mci)
>  	int i, j, empty = 1;
>  	enum mem_type mtype;
>  	enum edac_type edac_mode;
> +	int nr_pages;
>  
>  	amd64_read_pci_cfg(pvt->F3, NBCFG, &val);
>  
> @@ -2174,14 +2169,14 @@ static int init_csrows(struct mem_ctl_info *mci)
>  			i, pvt->mc_node_id);
>  
>  		empty = 0;
> -		csrow->nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
> +		nr_pages = amd64_csrow_nr_pages(pvt, 0, i);
>  		get_cs_base_and_mask(pvt, i, 0, &base, &mask);
>  		/* 8 bytes of resolution */
>  
>  		mtype = amd64_determine_memory_type(pvt, i);
>  
>  		debugf1("  for MC node %d csrow %d:\n", pvt->mc_node_id, i);
> -		debugf1("    nr_pages: %u\n", csrow->nr_pages);
> +		debugf1("    nr_pages: %u\n", nr_pages);
>  
>  		/*
>  		 * determine whether CHIPKILL or JUST ECC or NO ECC is operating
> @@ -2195,6 +2190,7 @@ static int init_csrows(struct mem_ctl_info *mci)
>  		for (j = 0; j < pvt->channel_count; j++) {
>  			csrow->channels[j].dimm->mtype = mtype;
>  			csrow->channels[j].dimm->edac_mode = edac_mode;
> +			csrow->channels[j].dimm->nr_pages = nr_pages;

I'm guessing you want to accumulate the nr_pages for all channels here
and dump it properly?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
