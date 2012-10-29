Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab2J2LCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:02:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:24740 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886Ab2J2LCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:02:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,671,1344236400"; 
   d="scan'208";a="161844559"
Date: Mon, 29 Oct 2012 04:02:00 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org
Subject: Re: [PATCH 16/33] perf, tools: Add support for weight v2
Message-ID: <20121029110200.GH2266@tassilo.jf.intel.com>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
 <1351283415-13170-17-git-send-email-andi@firstfloor.org>
 <87vcdt7e2m.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcdt7e2m.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 07:44:17PM +0900, Namhyung Kim wrote:
> On Fri, 26 Oct 2012 13:29:58 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > perf record has a new option -W that enables weightened sampling.
> >
> > Add sorting support in top/report for the average weight per sample and the
> > total weight sum. This allows to both compare relative cost per event
> > and the total cost over the measurement period.
> 
> I expected the weight is used for scaling a sample period somehow - and
> wondered the *somehow* part - when reading previous patch descriptions
> but you just added sort keys.  Is it what you intended originally?

I originally simply multiplied, but then I changed over to separate sort 
keys which give the same result and are more flexible and easier to understand

You're right the manpage is stale, will fix.

> 
> 
> >
> > Add the necessary glue to perf report, record and the library.
> >
> > v2: Merge with new hist refactoring.
> > Rename global_weight to weight and weight to local_weight.
> 
> But I think (total_)weight and avg_weight looks more natural.

Frankly I think your names as as arbitary as mine, so I'll stay
with mine for now.

> >  			 * become out-of-date due to an exec() or
> > @@ -314,6 +322,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
> >  
> >  	rb_link_node(&he->rb_node_in, parent, p);
> >  	rb_insert_color(&he->rb_node_in, hists->entries_in);
> > +	he->stat.weight += weight;
> 
> I'd suggest that the weight should be set to the 'entry' so that it can
> be added when hist_entry__new() called.

I did that originally, but ran into some problem, so I moved to this way

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
