Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2ENMs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:48:26 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44263 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab2ENMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:48:25 -0400
Date: Mon, 14 May 2012 14:48:08 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC ABI v13 01/25] edac: Initialize the dimm label with the
 known information
Message-ID: <20120514124808.GC4231@aftab.osrc.amd.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
 <1334608729-30803-2-git-send-email-mchehab@redhat.com>
 <20120507155226.GE11462@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120507155226.GE11462@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Review comments to the one below are still not addressed, maybe slipped
through the cracks?

On Mon, May 07, 2012 at 05:52:26PM +0200, Borislav Petkov wrote:
> Adding latest version here:
> 
> > From 50e9a89aad7045909780d635d73ab2893f8c1f90 Mon Sep 17 00:00:00 2001
> > From: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Date: Thu, 9 Feb 2012 11:05:20 -0300
> > Subject: [PATCH] edac: Initialize the dimm label with the known information
> > 
> > While userspace doesn't fill the dimm labels, add there the dimm location,
> > as described by the used memory model. This could eventually match what
> > is described at the dmidecode, making easier for people to identify the
> 
> 	       in		 making it easier
> 
> > memory.
> 
> 	 stick in error.
> 
> > For example, on an Intel motherboard, the memory is described as:
> > 
> > Memory Device
> > 	Array Handle: 0x0029
> > 	Error Information Handle: Not Provided
> > 	Total Width: 64 bits
> > 	Data Width: 64 bits
> > 	Size: 2048 MB
> > 	Form Factor: DIMM
> > 	Set: 1
> > 	Locator: A1_DIMM0
> > 	Bank Locator: A1_Node0_Channel0_Dimm0
> > 	Type: <OUT OF SPEC>
> > 	Type Detail: Synchronous
> > 	Speed: 800 MHz
> > 	Manufacturer: A1_Manufacturer0
> > 	Serial Number: A1_SerNum0
> > 	Asset Tag: A1_AssetTagNum0
> > 	Part Number: A1_PartNum0
> > 
> > After this patch, the memory label will be filled with:
> > 	/sys/devices/system/edac/mc/mc0/dimm0/dimm_label:mc#0channel#0slot#0
> 
> This is only with the Intel-MCs, right, I still have the csrows here:
> 
> tree /sys/devices/system/edac/mc/
> /sys/devices/system/edac/mc/
> |-- mc0
> |   |-- ce_count
> |   |-- ce_noinfo_count
> |   |-- csrow0
> |   |   |-- ce_count
> |   |   |-- ch0_ce_count
> |   |   |-- ch0_dimm_label
> |   |   |-- ch1_ce_count
> |   |   |-- ch1_dimm_label
> |   |   |-- dev_type
> |   |   |-- edac_mode
> |   |   |-- mem_type
> |   |   |-- size_mb
> |   |   `-- ue_count
> |   |-- csrow1
> |   |   |-- ce_count
> |   |   |-- ch0_ce_count
> |   |   |-- ch0_dimm_label
> |   |   |-- ch1_ce_count
> |   |   |-- ch1_dimm_label
> |   |   |-- dev_type
> |   |   |-- edac_mode
> |   |   |-- mem_type
> |   |   |-- size_mb
> |   |   `-- ue_count
> |   |-- csrow2
> |   |   |-- ce_count
> |   |   |-- ch0_ce_count
> |   |   |-- ch0_dimm_label
> |   |   |-- ch1_ce_count
> |   |   |-- ch1_dimm_label
> |   |   |-- dev_type
> |   |   |-- edac_mode
> |   |   |-- mem_type
> |   |   |-- size_mb
> |   |   `-- ue_count
>  …
> 
> 
> > With somewhat matches what it is at the Bank Locator DMI information.
> 
> I wouldn't say that - DMI is notoriously unreliable, let's look at some
> boxes:
> 
> 1st box:
> 
> Handle 0x0038, DMI type 17, 28 bytes
> Memory Device
>         Array Handle: 0x0036
>         Error Information Handle: Not Provided
>         Total Width: 72 bits
>         Data Width: 64 bits
>         Size: 2048 MB
>         Form Factor: DIMM
>         Set: None
>         Locator: DIMM0
> 
> 2nd box:
> 
> Memory Device
>         Array Handle: 0x0014
>         Error Information Handle: Not Provided
>         Total Width: 64 bits
>         Data Width: 4096 bits
>         Size: 9 MB
>         Form Factor: <OUT OF SPEC>
>         Set: 73
>         Locator: P0_DIMM_A1
>         Bank Locator: CHANNEL A
> 
> 3rd box:
> 
> Handle 0x0033, DMI type 17, 28 bytes
> Memory Device
>         Array Handle: 0x0031
>         Error Information Handle: Not Provided
>         Total Width: 64 bits
>         Data Width: 64 bits
>         Size: 4096 MB
>         Form Factor: SODIMM
>         Set: 2
>         Locator: J401
>         Bank Locator: Channel B
> 
> and so on.
> 
> IOW, DMI fields are almost random permutations of [a-zA-Z0-9].
> 
> > So, it is easier to associate the dimm labels, of course assuming that
> > the DMI has the Bank Locator filled, and the BIOS doesn't have any bugs.
> > 
> > Yet, even without it, several motherboards are provided with enough
> > info to map from channel/slot (or branch/channel/slot) into the DIMM
> > label. So, letting the EDAC core fill it, by default is a good thing.
> > 
> > It should noticed that, as the label filling happens at the
> > edac_mc_alloc(), drivers can override it to better describe the memories
> > (and some actually do it).
> 
> But I guess having the info is still fine, simply remove the DMI
> references in the commit message pls.
> 
> > Cc: Aristeu Rozanski <arozansk@redhat.com>
> > Cc: Doug Thompson <norsk5@yahoo.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/edac/edac_mc.c       |   25 +++++++++++++++++++------
> >  drivers/edac/edac_mc_sysfs.c |    8 ++++----
> >  include/linux/edac.h         |    2 +-
> >  3 files changed, 24 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> > index 4c44cd298c0b..77263b33b7f0 100644
> > --- a/drivers/edac/edac_mc.c
> > +++ b/drivers/edac/edac_mc.c
> > @@ -210,10 +210,10 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
> >  	struct dimm_info *dimm;
> >  	u32 *ce_per_layer[EDAC_MAX_LAYERS], *ue_per_layer[EDAC_MAX_LAYERS];
> >  	unsigned pos[EDAC_MAX_LAYERS];
> > -	void *pvt, *ptr = NULL;
> >  	unsigned size, tot_dimms = 1, count = 1;
> >  	unsigned tot_csrows = 1, tot_channels = 1, tot_errcount = 0;
> > -	int i, j, err, row, chn;
> > +	void *pvt, *p, *ptr = NULL;
> > +	int i, j, err, row, chn, n, len;
> >  	bool per_rank = false;
> >  
> >  	BUG_ON(n_layers > EDAC_MAX_LAYERS || n_layers == 0);
> > @@ -325,9 +325,22 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
> >  			i, per_rank ? "rank" : "dimm", (dimm - mci->dimms),
> >  			pos[0], pos[1], pos[2], row, chn);
> >  
> > -		/* Copy DIMM location */
> > -		for (j = 0; j < n_layers; j++)
> > +		/*
> > +		 * Copy DIMM location and initialize the memory location
> 
> 					 initialize it.
> 
> or do you mean two different locations?
> 
> > +		 */
> > +		len = sizeof(dimm->label);
> > +		p = dimm->label;
> > +		n = snprintf(p, len, "mc#%u", mc_num);
> > +		p += n;
> > +		len -= n;
> > +		for (j = 0; j < n_layers; j++) {
> > +			n = snprintf(p, len, "%s#%u",
> > +				     edac_layer_name[layers[j].type],
> > +				     pos[j]);
> > +			p += n;
> > +			len -= n;
> 
> Err, you're not checking how much len is left here, i.e.
> EDAC_MC_LABEL_LEN. Or even better, each time before you do snprintf.
> 
> >  			dimm->location[j] = pos[j];
> > +		}
> >  
> >  		/* Link it to the csrows old API data */
> >  		chan->dimm = dimm;
> > @@ -837,7 +850,7 @@ static void edac_inc_ce_error(struct mem_ctl_info *mci,
> >  {
> >  	int i, index = 0;
> >  
> > -	mci->ce_count++;
> > +	mci->ce_mc++;
> 
> Oh, renaming them back, ok.
> 
> <rest snipped>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
