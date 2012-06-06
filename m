Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2FFOVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:21:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:37319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2FFOVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:21:23 -0400
Message-ID: <1338992472.2749.116.camel@twins>
Subject: Re: [PATCH 5/5] perf, x86: Prefer RDPMC over RDMSR for reading
 counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com
Date: Wed, 06 Jun 2012 16:21:12 +0200
In-Reply-To: <20120606141644.GF28225@tassilo.jf.intel.com>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338944211-28275-5-git-send-email-andi@firstfloor.org>
	 <1338979579.2749.95.camel@twins>
	 <20120606141644.GF28225@tassilo.jf.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 07:16 -0700, Andi Kleen wrote:
> On Wed, Jun 06, 2012 at 12:46:19PM +0200, Peter Zijlstra wrote:
> > On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > RDPMC is much faster than RDMSR for reading performance counters,
> > > since it's not serializing.  Use it if possible in the perf handler.
> > > 
> > > Only tested on Sandy Bridge, so I only enabled it there so far.
> > 
> > That's just stupid.. I took Vince's patch from a while back.
> 
> What do you mean? It's significantly faster to read the counters this
> way, because it avoids serialization and other overhead. 

What I'm saying is you only enabling it for snb and being too lazy to
test anything else. Nor do I think its worth the conditional, all chips
we have PMU support for have rdpmc instructions.

> Vince's patch only enabled it for user space I believe, This is for lowering
> the kernel PMI handler overhead.

No, his patch did the kernel thing. Furthermore he actually tested it on
a bunch of machines.
