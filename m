Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0HKMgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 08:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab0HKMgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 08:36:38 -0400
Date: Wed, 11 Aug 2010 08:36:15 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100811123615.GA4879@redhat.com>
References: <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100810204856.GA16571@redhat.com>
 <1281496779.2744.1365.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281496779.2744.1365.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 11:19:39AM +0800, Huang Ying wrote:
> On Wed, 2010-08-11 at 04:48 +0800, Don Zickus wrote:
> > > From d2739578199d881ae6a9537c1b96a0efd1cdea43 Mon Sep 17 00:00:00 2001
> > > From: Robert Richter <robert.richter@amd.com>
> > > Date: Thu, 5 Aug 2010 16:19:59 +0200
> > > Subject: [PATCH] perf, x86: try to handle unknown nmis with running perfctrs
> > 
> > On top of Robert's patch:
> > (compiled tested only because I don't have a fancy button to trigger
> > unknown nmis)
> 
> You can trigger unknown NMIs via apic->send_IPI_mask(cpu_mask,
> NMI_VECTOR).
> 
> How about the algorithm as follow:

Heh, I thought about the following too, just couldn't figure out an easy
way to timestamp.  I forgot about the rdtsc(). :-)

The only thing that might screw this up would be an SMI which takes longer
than 1000 but that should be rare and would probably be related to the
unknown NMI anyway.  Also under virt that would probably break (due to
time jumping) but until they emulate the perfctr, it won't matter. :-)

Cheers,
Don
