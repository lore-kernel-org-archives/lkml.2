Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0HDQUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:20:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab0HDQUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:20:52 -0400
Date: Wed, 4 Aug 2010 12:20:26 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804162026.GU3353@redhat.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
 <20100804100116.GH26154@erda.amd.com>
 <20100804140021.GN3353@redhat.com>
 <1280931093.1923.1194.camel@laptop>
 <20100804145203.GP3353@redhat.com>
 <1280934161.1923.1294.camel@laptop>
 <20100804151858.GB5130@lenovo>
 <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804161046.GC5130@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 08:10:46PM +0400, Cyrill Gorcunov wrote:
> On Wed, Aug 04, 2010 at 11:50:02AM -0400, Don Zickus wrote:
> ...
> > > 
> > > Well, first I guess having Yinghai CC'ed is a bonus ;)
> > > The second thing is that I don't get why perf handler can't be _last_
> > > call in default_do_nmi, if there were any nmi with reason (serr or parity)
> > > I think they should be calling first which of course don't eliminate
> > > the former issue but somewhat make it weaken.
> > 
> > Because the reason registers are never set.  If they were, then the code
> > wouldn't have to walk the notify_chain. :-)
> > 
> 
> maybe we're talking about different things. i meant that if there is nmi
> with a reason (from 0x61) the handling of such nmi should be done before
> notify_die I think (if only I not miss something behind).

No we are talking about the same thing. :-)  And that code is already
there.  The problem is the bits in register 0x61 are not always set
correctly in the case of SERRs (well at least in all the cases I have
dealt with).  So you can easily can a flood of unknown nmis from an SERR
and register 0x61 would have the PERR/SERR bits set to 0.  Fun, huh?

Cheers,
Don

