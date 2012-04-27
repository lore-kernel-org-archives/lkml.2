Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab2D0OLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:11:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42759 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759990Ab2D0OLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:11:48 -0400
Message-ID: <1335535895.25521.7.camel@joe2Laptop>
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to
 work with layers
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
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
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Date: Fri, 27 Apr 2012 10:11:35 -0400
In-Reply-To: <20120427133304.GE9626@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
	 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
	 <20120427133304.GE9626@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 15:33 +0200, Borislav Petkov wrote:
> this patch gives
> 
> [    8.278399] EDAC DEBUG: new_edac_mc_alloc: new_edac_mc_alloc: 0: dimm0 (0:0:0): row 0, chan 0

One too many __func__'s in some combination of the
pr_fmt and/or dbg call and/or the actual call site?

> > diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
[]
> > @@ -447,8 +447,13 @@ static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
> >  
> >  #endif				/* CONFIG_PCI */
> >  
> > -extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> > -					  unsigned nr_chans, int edac_index);
> > +struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
> > +				   unsigned nr_chans, int edac_index);
> 
> Why not "extern"?

Using extern function prototypes in .h files
isn't generally necessary nor is extern the
more common kernel style.

> > +static inline void edac_mc_handle_ce(struct mem_ctl_info *mci,
> >  			      unsigned long page_frame_number,
> >  			      unsigned long offset_in_page,
> >  			      unsigned long syndrome, int row, int channel,
> > -			      const char *msg);
> 
> Strange alignment, pls do
> 
> static inline void edac_mc_handle_ce(struct...,
> 				     unsigned...,
> 				     ...,
> 				     ...);
> 

or

static inline
void edac_mc_handle_ce(struct ..., etc)

or

static inline void
edac_mc_handle_ce(...)


