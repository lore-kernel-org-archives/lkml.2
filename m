Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2D3Liv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 07:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab2D3Liu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 07:38:50 -0400
Message-ID: <4F9E7979.5080705@redhat.com>
Date: Mon, 30 Apr 2012 08:37:29 -0300
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
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com> <1335291342-14922-1-git-send-email-mchehab@redhat.com> <20120427133304.GE9626@aftab.osrc.amd.com> <4F9ABCEC.9090807@redhat.com> <20120428090523.GD26065@aftab.osrc.amd.com> <4F9D46F8.1020104@redhat.com> <20120430081513.GD8182@aftab.osrc.amd.com>
In-Reply-To: <20120430081513.GD8182@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 30-04-2012 05:15, Borislav Petkov escreveu:
> On Sun, Apr 29, 2012 at 10:49:44AM -0300, Mauro Carvalho Chehab wrote:
>>> [   10.486440] EDAC MC: DCT0 chip selects:
>>> [   10.486443] EDAC amd64: MC: 0:  2048MB 1:  2048MB
>>> [   10.486445] EDAC amd64: MC: 2:  2048MB 3:  2048MB
>>> [   10.486448] EDAC amd64: MC: 4:     0MB 5:     0MB
>>> [   10.486450] EDAC amd64: MC: 6:     0MB 7:     0MB
>>> [   10.486453] EDAC DEBUG: amd64_debug_display_dimm_sizes: F2x180 (DRAM Bank Address Mapping): 0x00000088
>>> [   10.486455] EDAC MC: DCT1 chip selects:
>>> [   10.486458] EDAC amd64: MC: 0:  2048MB 1:  2048MB
>>> [   10.486460] EDAC amd64: MC: 2:  2048MB 3:  2048MB
>>> [   10.486463] EDAC amd64: MC: 4:     0MB 5:     0MB
>>> [   10.486465] EDAC amd64: MC: 6:     0MB 7:     0MB
>>> [   10.486467] EDAC amd64: using x8 syndromes.
>>> [   10.486469] EDAC DEBUG: amd64_dump_dramcfg_low: F2x190 (DRAM Cfg Low): 0x00083100
>>> [   10.486472] EDAC DEBUG: amd64_dump_dramcfg_low:   DIMM type: buffered; all DIMMs support ECC: yes
>>> [   10.486475] EDAC DEBUG: amd64_dump_dramcfg_low:   PAR/ERR parity: enabled
>>> [   10.486478] EDAC DEBUG: amd64_dump_dramcfg_low:   DCT 128bit mode width: 64b
>>> [   10.486481] EDAC DEBUG: amd64_dump_dramcfg_low:   x4 logical DIMMs present: L0: yes L1: yes L2: no L3: no
>>> [   10.486485] EDAC DEBUG: f1x_early_channel_count: Data width is not 128 bits - need more decoding
>>> [   10.486488] EDAC amd64: MCT channel count: 2
>>> [   10.486493] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc(): allocating 3692 bytes for mci data (16 ranks, 16 csrows/channels)
>>> [   10.486501] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 0: rank0 (0:0:0): row 0, chan 0
>>> [   10.486506] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 1: rank1 (0:1:0): row 0, chan 1
>>> [   10.486510] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 2: rank2 (1:0:0): row 1, chan 0
>>> [   10.486514] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 3: rank3 (1:1:0): row 1, chan 1
>>> [   10.486518] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 4: rank4 (2:0:0): row 2, chan 0
>>> [   10.486522] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 5: rank5 (2:1:0): row 2, chan 1
>>> [   10.486526] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 6: rank6 (3:0:0): row 3, chan 0
>>> [   10.486530] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 7: rank7 (3:1:0): row 3, chan 1
>>> [   10.486534] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 8: rank8 (4:0:0): row 4, chan 0
>>> [   10.486538] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 9: rank9 (4:1:0): row 4, chan 1
>>> [   10.486542] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 10: rank10 (5:0:0): row 5, chan 0
>>> [   10.486546] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 11: rank11 (5:1:0): row 5, chan 1
>>> [   10.486550] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 12: rank12 (6:0:0): row 6, chan 0
>>> [   10.486554] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 13: rank13 (6:1:0): row 6, chan 1
>>> [   10.486558] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 14: rank14 (7:0:0): row 7, chan 0
>>> [   10.486562] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 15: rank15 (7:1:0): row 7, chan 1
>>>
>>> DCT0 has 4 ranks + DCT1 also 4 ranks = 8 ranks total.
>>>
>>> Now your change is showing 16 ranks. Still b0rked.
>>>
>> No, DCT0+DCT1 have 16 ranks, 8 filled and 8 empty. So, it is OK.
>>
>> As I said before when you've pointed this bug (likel at v3 review), edac_mc_alloc
>> doesn't know how many ranks are filled, as the driver logic first calls it to 
>> allocate for the max amount of ranks, and then fills the rank with their info 
>> (or let them untouched with 0 pages, if they're empty).
> 
> Basically you're saying you're generating dimm_info structs for all
> _possible_ dimms and the loop where this debug message comes from goes
> and marrily initializes them all although some of them are empty:
> 
> +       for (i = 0; i < tot_dimms; i++) {
> +               chan = &csi[row].channels[chn];
> +               dimm = EDAC_DIMM_PTR(lay, mci->dimms, n_layers,
> +                              pos[0], pos[1], pos[2]);
> +               dimm->mci = mci;
> +
> +               debugf2("%s: %d: dimm%zd (%d:%d:%d): row %d, chan %d\n", __func__,
> +                       i, (dimm - mci->dimms),
> +                       pos[0], pos[1], pos[2], row, chn);
> +
> +               /* Copy DIMM location */
> +               for (j = 0; j < n_layers; j++)
> +                       dimm->location[j] = pos[j];
> ...
> 
> definitely superfluous.

This is the way the EDAC core works: everything is allocated, on one shot, when this
function is called, and, on most drivers, before the code that probes how many DIMMS/ranks
got initialized. That happens because the edac_mc_alloc() arguments provide the total
amount of ranks/dimms, but doesn't say anything about what is used there.

Changing from this model to another model that would dynamically initialize the per-dimm/rank
data is possible, but that would require another set of patches that will touch on all
drivers, and to convert the edac_mc_alloc function into 3 or 4 function calls, with the
corresponding changes on all drivers. Also, the changes at the drivers won't likely be
trivial.

The patches that convert kobj into "struct device" does part of the job, as, after it,
each dimm/csrow will be allocated by a separate kmalloc.

After having this series fully applied, it would be possible to work on such solution.
I'll eventually do that, as this would simplify the code at i7core_edac and sb_edac.

Regards,
Mauro
