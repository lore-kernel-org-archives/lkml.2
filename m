Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab0DFSJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:09:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47058 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274Ab0DFSJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:09:18 -0400
Date: Tue, 6 Apr 2010 11:09:14 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Jon D. Mason" <jdmason@kudzu.us>,
       discuss@x86-64.org, Corinna Schultz <coschult@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] calgary: Increase the maximum PHB bus number
Message-ID: <20100406180914.GN22820@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091209005901.GX10295@tux1.beaverton.ibm.com> <20091209090346.GN2452@tyrion.haifa.ibm.com> <20100218183750.GL29604@tux1.beaverton.ibm.com> <20100220071805.GJ9746@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100220071805.GJ9746@il.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 09:18:05AM +0200, Muli Ben-Yehuda wrote:
> On Thu, Feb 18, 2010 at 10:37:50AM -0800, Darrick J. Wong wrote:
> > On Wed, Dec 09, 2009 at 11:03:46AM +0200, Muli Ben-Yehuda wrote:
> > > On Tue, Dec 08, 2009 at 04:59:01PM -0800, Darrick J. Wong wrote:
> > > 
> > > > -#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
> > > > -#define MAX_NUM_CHASSIS		8 /* max number of chassis */
> > > > -/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
> > > > -#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
> > > > +/*
> > > > +   The maximum PHB bus number.
> > > > +   x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
> > > > +   x3950M2: 4 chassis, 48 PHBs per chassis        = 192
> > > > +   x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
> > > > +   x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
> > > > +*/
> > > > +#define MAX_PHB_BUS_NUM		384
> > > > +
> > > >  #define PHBS_PER_CALGARY	4
> > > 
> > > We'll end up wasting a few bytes on small systems, but I don't think
> > > it's enough to matter on these fairly large systems. As far as I'm
> > > concerned, patch is fine.
> > > 
> > > Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
> > 
> > Hmm... has this patch been queued up by anyone for the .34 merge
> > window?
> 
> I don't maintain a separate Calgary patchset anymore, hopefully Ingo
> or one of the other x86 maintainers have picked it up?

Still not in 2.6.34-rc3.  Are there any objections to this patch?  I've not
heard any complaints since my original posting... or did it simply get lost in
the noise?

--D
