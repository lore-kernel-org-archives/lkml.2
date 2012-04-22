Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab2DXSKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:10:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50413 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755782Ab2DXSK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:10:29 -0400
Message-ID: <1335076630.13194.6.camel@joe2Laptop>
Subject: Re: [EDAC ABI v13 24/25] edac: change the mem allocation scheme to
 make Documentation/kobject.txt happy
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <4F900FB3.6000607@redhat.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
	 <1334608729-30803-25-git-send-email-mchehab@redhat.com>
	 <1334697467.3920.5.camel@joe2Laptop> <4F900FB3.6000607@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Apr 2012 01:37:10 -0500
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 10:14 -0300, Mauro Carvalho Chehab wrote:
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
[]
> @@ -296,7 +296,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
>  	/*
>  	 * Alocate and fill the csrow/channels structs
>  	 */
> -	mci->csrows = kzalloc(sizeof(*mci->csrows) * tot_csrows, GFP_KERNEL);
> +	mci->csrows = kcalloc(sizeof(*mci->csrows), tot_csrows, GFP_KERNEL);

trivia:  the first 2 args to kcalloc should be swapped.

static inline void *kcalloc(size_t n, size_t size, gfp_t flags)

	kcalloc(tot_csrows, sizeof(*mci->csrows), GFP_KERNEL);
[]
> @@ -307,7 +307,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
>  		csr->csrow_idx = row;
>  		csr->mci = mci;
>  		csr->nr_channels = tot_cschannels;
> -		csr->channels = kzalloc(sizeof(*csr->channels) * tot_cschannels,
> +		csr->channels = kcalloc(sizeof(*csr->channels), tot_cschannels,

and here.

[]
> @@ -323,7 +323,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned edac_index,
>  	/*
>  	 * Allocate and fill the dimm structs
>  	 */
> -	mci->dimms  = kzalloc(sizeof(*mci->dimms) * tot_dimms, GFP_KERNEL);
> +	mci->dimms  = kcalloc(sizeof(*mci->dimms), tot_dimms, GFP_KERNEL);

and here too.


