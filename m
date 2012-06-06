Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab2FFOxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:53:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:38276 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2FFOxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:53:13 -0400
Message-ID: <1338994385.2749.130.camel@twins>
Subject: Re: [PATCH 1/5] perf, x86: Don't assume the alternative cycles
 encoding is architectural
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Date: Wed, 06 Jun 2012 16:53:05 +0200
In-Reply-To: <20120606144952.GK28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338979188.2749.92.camel@twins>
	 <20120606141247.GD28225@tassilo.jf.intel.com>
	 <1338992061.2749.111.camel@twins>
	 <20120606142323.GG28225@tassilo.jf.intel.com>
	 <1338992910.2749.121.camel@twins>
	 <20120606143536.GH28225@tassilo.jf.intel.com>
	 <1338993726.2749.125.camel@twins>
	 <20120606144952.GK28225@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:49 -0700, Andi Kleen wrote:

> Is this for the intel_pmu or for the core_pmu?
> 
> > +     .pebs_aliases           = intel_pebs_aliases_core2,

intel_pmu, we don't actually support PEBS on first gen. core I think.

> In any case since the code later does
> 
>         version = eax.split.version_id;
>         if (version < 2)
>                 x86_pmu = core_pmu;
>         else
>                 x86_pmu = intel_pmu;
> 
> so core_pmu would be active even without model check, which would
> be still wrong.

By not setting pebs_aliases for core_pmu,

> So your patch would fix the problem iff you only fill in the pebs_aliases
> in the model number switch for known Core model numbers.

+       if (event->attr.precise_ip && x86_pmu.pebs_aliases)
+               x86_pmu.pebs_aliases(event);

Never happens, and we're happy again.
