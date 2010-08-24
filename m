Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0HXTwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:52:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47590 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab0HXTwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XD0D3BX69NoWjjqPiIUfN2gNiqTFlJTfOSh8/6MQDvRpUsLGQJZ4DSvjGAwBgzXJSO
         /xQ4ErX9gCdv6H9V0NblymK74K3v98JHr7kxCj645j6aIVDp+0STdwqNfAQRY17fTkPY
         OmrIyjo0a/SKYFcphFn/EI4j3XzhFhBf1DY28=
Date: Tue, 24 Aug 2010 23:52:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100824195240.GA5281@lenovo>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100823085339.GA26713@elte.hu> <20100824171504.GI26154@erda.amd.com> <20100824172806.GF5723@lenovo> <20100824184658.GB4879@redhat.com> <20100824185458.GG5723@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824185458.GG5723@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 10:54:58PM +0400, Cyrill Gorcunov wrote:
...
> > > | commit 4a31bebe71ab2e4f6ecd6e5f9f2ac9f0ff38ff76
> > > | Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > | Date:   Thu Aug 19 16:28:00 2010 +0200
> > > |
> > > |    perf, x86: Fix handle_irq return values
> > 
> > Has anyone else seen kernel panics when enabling the LOCKUP_DETECTOR or
> > apply Robert's patch?  I keep getting a panic with unable to handle paging
> > request everytime either Robert's patch or the lockup detector uses
> > __get_cpu_var().  And only on 2.6.36 code.
> > 
> > Cheers,
> > Don
> > 
> 
> I use 2.6.34 atm. Letme try 2.6.36 (which might require some time to recompile).
> 
> 	-- Cyrill

Don, for me it fails with somehow unrelated page handling fault - in
reiserfs_evict_inode O_o Fails in __get_cpu_var I suspect might means
a problem either in per-cpu allocator itself or we screw pointer somehow.
Weird.

	-- Cyrill
