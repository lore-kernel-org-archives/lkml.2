Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab0HSIcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:32:20 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:36026 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab0HSIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:32:19 -0400
Date: Thu, 19 Aug 2010 09:32:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Lin, Ming M" <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
Message-ID: <20100819083218.GB25755@console-pimps.org>
References: <1282118350.5181.115.camel@rui> <1282134329.1926.3918.camel@laptop> <20100818124116.GA17957@console-pimps.org> <1282188497.11858.94.camel@minggr.sh.intel.com> <20100819075410.GA25755@console-pimps.org> <1282206714.5181.552.camel@rui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282206714.5181.552.camel@rui>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 04:31:54PM +0800, Zhang Rui wrote:
> On Thu, 2010-08-19 at 15:54 +0800, Matt Fleming wrote:
> > On Thu, Aug 19, 2010 at 11:28:17AM +0800, Lin Ming wrote:
> > > On Wed, 2010-08-18 at 20:41 +0800, Matt Fleming wrote:
> > > > 
> > > > I had a quick look over the patches and Peter is right - the group
> > > > events stuff would probably fit quite well here. Unfortunately, due to
> > > > holidays and things, I haven't been able to get them finished
> > > > yet. I'll get on that ASAP.
> > > 
> > > Hi, Matt
> > > 
> > > What's the "group events stuff"?
> > > Is there some discussion on LKML or elsewhere I can have a look at?
> > > 
> > > Thanks,
> > > Lin Ming
> > 
> > The relevant information can be found here in this thread,
> > http://lkml.org/lkml/2010/8/4/174. I'm working on some patches for
> > this but they're not finished yet. I can probably get something to
> > show by next week.
> > 
> > The discussion started because the performance counters on SH do not
> > generate an interrupt on overflow, so we need to periodically sample
> > them. Am I correct in thinking that the energy counters also do not
> > generate an interrupt on overflow and that's why you wrote the event
> > as a software event?
> 
> right.
> 
> BTW, I'm not quite familiar with perf tool, and now I'm wondering if the
> periodically sample is needed.
> because IMO, .start is invoked every time the process is scheduled in,
> and .stop is invoked when it's scheduled out. It seems that we just need
> to read the energy consumed in .start and .stop, and update the counter
> in .stop, right?

How big is the hardware counter? The problem comes when the process is
scheduled in and runs for a long time, e.g. so long that the energy
hardware counter wraps. This is why it's necessary to periodically
sample the counter.
