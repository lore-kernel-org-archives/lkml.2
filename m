Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509Ab1D1U1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:27:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:41302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab1D1U1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:27:06 -0400
Date: Thu, 28 Apr 2011 21:27:01 +0100
From: Mel Gorman <mgorman@suse.de>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jan Kara <jack@suse.cz>, colin.king@canonical.com,
        Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>, mgorman@novell.com
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback related.
Message-ID: <20110428202701.GB4658@suse.de>
References: <20110428140725.GX4658@suse.de>
 <1304000714.2598.0.camel@mulgrave.site>
 <20110428150827.GY4658@suse.de>
 <1304006499.2598.5.camel@mulgrave.site>
 <1304009438.2598.9.camel@mulgrave.site>
 <1304009778.2598.10.camel@mulgrave.site>
 <20110428171826.GZ4658@suse.de>
 <1304015436.2598.19.camel@mulgrave.site>
 <20110428192104.GA4658@suse.de>
 <1304020767.2598.21.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1304020767.2598.21.camel@mulgrave.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 02:59:27PM -0500, James Bottomley wrote:
> On Thu, 2011-04-28 at 20:21 +0100, Mel Gorman wrote:
> > On Thu, Apr 28, 2011 at 01:30:36PM -0500, James Bottomley wrote:
> > > > Way hey, cgroups are also in the mix. How jolly.
> > > > 
> > > > Is systemd a common element of the machines hitting this bug by any
> > > > chance?
> > > 
> > > Well, yes, the bug report is against FC15, which needs cgroups for
> > > systemd.
> > > 
> > 
> > Ok although we do not have direct evidence that it's the problem yet. A
> > broken shrinker could just mean we are also trying to aggressively
> > reclaim in cgroups.
> > 
> > > > The remaining traces seem to be follow-on damage related to the three
> > > > issues of "shrinkers are bust in some manner" causing "we are not
> > > > getting over the min watermark" and as a side-show "we are spending lots
> > > > of time doing something unspecified but unhelpful in cgroups".
> > > 
> > > Heh, well find a way for me to verify this: I can't turn off cgroups
> > > because systemd then won't work and the machine won't boot ...
> > > 
> > 
> > Same testcase, same kernel but a distro that is not using systemd to
> > verify if cgroups are the problem. Not ideal I know. When I'm back
> > online Tuesday, I'll try reproducing this on a !Fedora distribution. In
> > the meantime, the following untested hatchet job might spit out
> > which shrinker we are getting stuck in. It is also breaking out of
> > the shrink_slab loop so it'd even be interesting to see if the bug
> > is mitigated in any way.
> 
> Actually, talking to Chris, I think I can get the system up using
> init=/bin/bash without systemd, so I can try the no cgroup config.
> 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index c74a501..ed99104 100644
> 
> In the mean time, this patch produces:
> 
> (that's nothing ... apparently the trace doesn't activate when kswapd
> goes mad).
> 

Or is looping there for shorter than we expect. HZ/10?

-- 
Mel Gorman
SUSE Labs
