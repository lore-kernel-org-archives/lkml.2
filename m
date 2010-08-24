Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0HXUkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:40:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48402 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0HXUko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xAbuW9Rrg1AzKtC0ptcL34bv8TtULW1ei/owA3TfM7i5GkTC/Rc4ISUmZGryqLd5zQ
         A1Puc+d0LTY9H1v1irTZOXPuUHcxjUNHEWYiQQY3zgaO2+ieSHYxB8nq6mHCl31sSVLx
         g9jOKRD/mfsBTNzg/qxKnyUgDS2ORDuOOJmvU=
Date: Wed, 25 Aug 2010 00:40:38 +0400
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
Message-ID: <20100824204038.GC5281@lenovo>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100823085339.GA26713@elte.hu> <20100824171504.GI26154@erda.amd.com> <20100824172806.GF5723@lenovo> <20100824184658.GB4879@redhat.com> <20100824185458.GG5723@lenovo> <20100824195240.GA5281@lenovo> <20100824202718.GC4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824202718.GC4879@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 04:27:18PM -0400, Don Zickus wrote:
> On Tue, Aug 24, 2010 at 11:52:40PM +0400, Cyrill Gorcunov wrote:
> > > I use 2.6.34 atm. Letme try 2.6.36 (which might require some time to recompile).
> > > 
> > > 	-- Cyrill
> > 
> > Don, for me it fails with somehow unrelated page handling fault - in
> > reiserfs_evict_inode O_o Fails in __get_cpu_var I suspect might means
> > a problem either in per-cpu allocator itself or we screw pointer somehow.
> > Weird.
> 
> I just found out (with the help of the crash utility and Dave A.) that
> Robert's percpu struct nmi clashes with the exception entry point .nmi.
> I only see this problem in 2.6.36, so I am not sure what changed with
> regards to compiler flags to confuse variables with text segments.
> 

yeah, I suspect name clashes here but then I did grep over per-cpu variables
in whole kernel and didn't find match so I thought the assumption was wrong,
but eventually it happens to be true but via other way :) good to know, thanks!

> But renaming the percpu struct nmi to nmidon fixed the problem for me (I
> am open to other suggestions :-) ).

nmi_don_zickus ;) well, I think nmi_pmu or something like that
might be a bit modest ;)

> 
> Regarding your reiserfs, what was the variable's name?
> 

It seems to be different, it's pity that I had only 80x25 vga
mode and was unable to snap the whole log. But actually I didn't
even check precisely all .config options I had set since I was
more interested in early stage where per-cpu access should already
happen rather then real init'ed environmen. But I think I'll be
moving completely to .36 this week so we will see how it goes.

> Cheers,
> Don
> 
	-- Cyrill
