Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab1LMXMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 18:12:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:53527 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909Ab1LMXMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 18:12:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95837039"
Date: Tue, 13 Dec 2011 15:11:58 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs
 files v2
Message-ID: <20111213231158.GD7633@tassilo.jf.intel.com>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org>
 <20111213222256.GD2618@moon>
 <20111213222759.GB7633@tassilo.jf.intel.com>
 <alpine.LFD.2.02.1112132359430.3020@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1112132359430.3020@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 12:03:03AM +0100, Thomas Gleixner wrote:
> On Tue, 13 Dec 2011, Andi Kleen wrote:
> 
> > > Hi Andi, is it possible to do say kstrdup or something instead of
> > 
> > It's possible, just would add complexity with an additional
> > error path.
> > 
> > > variable-size array in fn[strlen(name) + 1] ? As far as I remember
> > > we already had some warnings with them at least in perf land (or
> > > trace land). Or I miss something?
> > 
> > Not aware of any problems with tracing or perf. I like them at least.
> 
> That does not make them better. We had wreckage before and you can
> just consult commit a84a79e4d3 and then find a good explanation why
> your usage is safe.

Ok. I must admit I sometimes forget with what substandard toolchains
some of the ports are afflicted with.

But fair enough. I'll just make the code longer, more complex,
more error prone and slower.

Should probably find some way to let gcc warn about them, I'm sure
I'm not the only one who likes them.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
