Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1EYTOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:14:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:41275 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab1EYTOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:14:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,268,1304319600"; 
   d="scan'208";a="8699583"
Date: Wed, 25 May 2011 12:13:21 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525191321.GB14151@tassilo.jf.intel.com>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525065451.GC429@elte.hu>
 <20110525165436.GA14958@tassilo.jf.intel.com>
 <20110525185912.GB17864@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525185912.GB17864@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 08:59:12PM +0200, Ingo Molnar wrote:
> Look at the context diff above, it has 'cpu_index', so no, there was no
> consistent convention to follow.

Well all the CPU specific fields. Anyways I renamed it now.

> attention to that lack of means of testing? :-)
> 
> > > > -	/* see notes above for revision 1.07.  Apparent chip bug */
> > 
> > This particular code pattern has no chip bug. The CPUID is required 
> > by the documentation! So whoever wrote it didn't read the 
> > documentation. So yes I dropped that obviously bogus comment.
> 
> And you thus 'obviously' forked away the reading of the microcode 
> version into another file, with the same 'obviously wrong' comment 
> left behind in another place?

I just wrote new code with correct comments.

> > It always was documented this way.
> 
> FYI, the x86 microcode driver actually predates official public 

Are you sure you're not confusing that with the AMD driver?
AFAIK Intel was always documented.


> No, it's not a problem to add /proc/cpuinfo fields in the middle - 
> please add this new field to the logical place.

Ok.

> > 
> > Huh? There's only a single one now.
> 
> That's not actually true. With your patches applied a trivial git 
> grep shows the two places reading the microcode version:

Ok you count the re-reading. Fair enough. I guess I can remove
the comment there too.

BTW before my patches there were four places, I collapsed it down
to two if you count that.

-Andi
