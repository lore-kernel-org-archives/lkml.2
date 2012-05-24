Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2EXBDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:03:13 -0400
Received: from linux-sh.org ([111.68.239.195]:48402 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab2EXBDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:03:12 -0400
Date: Thu, 24 May 2012 10:02:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Clock register in early init
Message-ID: <20120524010237.GC11860@linux-sh.org>
References: <1337227884.2066.9.camel@pgaikwad-dt2>
 <20120517062131.GA9305@gmail.com>
 <1337316517.22560.19.camel@pgaikwad-dt2>
 <20120518112104.GL20304@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zM_o1Nqw55xxFvw6KssM50Q+7yyo41rUSH2Aoo1neTMjg@mail.gmail.com>
 <20120521084642.GV20304@tbergstrom-lnx.Nvidia.com>
 <4FBB5A72.2080101@codethink.co.uk>
 <20120522120851.GI8730@tbergstrom-lnx.Nvidia.com>
 <CAJOA=zNic19Eyq-RJpj_pM94wpqY7co0dtKu1O+27B-wZMm=MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJOA=zNic19Eyq-RJpj_pM94wpqY7co0dtKu1O+27B-wZMm=MA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:37:15AM -0700, Turquette, Mike wrote:
> On Tue, May 22, 2012 at 5:08 AM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> >> We had at-least that on the older Samsung parts and they where still
> >> growing. I would suggest that in a multi-kernel image situation the
> >> more data that can be discarded after init-time the better.
> >>
> >> Also, __initdata gets gathered into one place so there's no possibility
> >> of page fragmentation there. If you mean fragmentation of the memory
> >> map, then allocate the size of all the clocks you know of at init time
> >> in one go.
> >>
> >
> > That would work, except that clocks are needed before kmalloc is available.
> >
> 
> Is static initialization the only way to solve this problem?  What
> about using the bootmem allocator for early init clocks?
> 
This is what sh does for its asm/clkdev.h __clkdev_alloc(), which is
really the only difference over the ARM version. It always seemed a bit
silly to me to make early allocation an arch-specific property.
