Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab0HDQjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:39:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65380 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab0HDQje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SA8f+yde1rBLajjcQjZdg6IjD8BRovUZoUn9GibUYooGOv728PrB5s7nwZstWUxg+e
         adzIHzxptqggQxeLDj5uhn4pFbfREL/2f1SbgygkAI7OERAzwhlct0iUVQ7C1lNbvYOR
         GOItAMTOIqMNRqf9kiAerrb+J6/+uildi+A2k=
Date: Wed, 4 Aug 2010 20:39:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804163930.GE5130@lenovo>
References: <1280913670.20797.179.camel@minggr.sh.intel.com> <20100804100116.GH26154@erda.amd.com> <20100804140021.GN3353@redhat.com> <1280931093.1923.1194.camel@laptop> <20100804145203.GP3353@redhat.com> <1280934161.1923.1294.camel@laptop> <20100804151858.GB5130@lenovo> <20100804155002.GS3353@redhat.com> <20100804161046.GC5130@lenovo> <20100804162026.GU3353@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804162026.GU3353@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 12:20:26PM -0400, Don Zickus wrote:
...
> > > 
> > > Because the reason registers are never set.  If they were, then the code
> > > wouldn't have to walk the notify_chain. :-)
> > > 
> > 
> > maybe we're talking about different things. i meant that if there is nmi
> > with a reason (from 0x61) the handling of such nmi should be done before
> > notify_die I think (if only I not miss something behind).
> 
> No we are talking about the same thing. :-)  And that code is already

seems not actually ;)

> there.  The problem is the bits in register 0x61 are not always set
> correctly in the case of SERRs (well at least in all the cases I have
> dealt with).  So you can easily can a flood of unknown nmis from an SERR
> and register 0x61 would have the PERR/SERR bits set to 0.  Fun, huh?

if there is nothing in nmi_sc the code flows into another branch. And
it hits the problem of perf events eating all nmi giving no chance the
others. So we take if (!(reason & 0xc0)) case and hit DIE_NMI_IPI
(/me scratching the head why it's not under CONFIG_X86_LOCAL_APIC) and
drop all code, unpleasant.

> 
> Cheers,
> Don
> 
	-- Cyrill
