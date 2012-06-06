Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab2FFOtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:49:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:3122 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab2FFOtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:49:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175519937"
Date: Wed, 6 Jun 2012 07:49:52 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
Message-ID: <20120606144952.GK28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
 <1338979188.2749.92.camel@twins>
 <20120606141247.GD28225@tassilo.jf.intel.com>
 <1338992061.2749.111.camel@twins>
 <20120606142323.GG28225@tassilo.jf.intel.com>
 <1338992910.2749.121.camel@twins>
 <20120606143536.GH28225@tassilo.jf.intel.com>
 <1338993726.2749.125.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338993726.2749.125.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 04:42:06PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-06 at 07:35 -0700, Andi Kleen wrote:
> > > But simply disabling it for a model isn't how you do things. 
> > 
> > Do you want it enabled per model?  I can turn the flag around.
> > Anything else? 
> 
> The below is a refresh from a patch I did about a year ago when we ran
> into the SNB trainwreck. I never merged it because SNB.. but IVB seems
> to work.

Hmm, your line numbers do not fully match mine

Is this for the intel_pmu or for the core_pmu?

> +     .pebs_aliases           = intel_pebs_aliases_core2,

In any case since the code later does

        version = eax.split.version_id;
        if (version < 2)
                x86_pmu = core_pmu;
        else
                x86_pmu = intel_pmu;

so core_pmu would be active even without model check, which would
be still wrong.

So your patch would fix the problem iff you only fill in the pebs_aliases
in the model number switch for known Core model numbers.

If you fix that it would be a valid replacement for mine I believe.

-Andi
