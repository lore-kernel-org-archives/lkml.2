Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab0HSI2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:28:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:5291 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab0HSI2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:28:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,232,1280732400"; 
   d="scan'208";a="546729699"
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Zhang Rui <rui.zhang@intel.com>
To: Matt Fleming <matt@console-pimps.org>
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
In-Reply-To: <20100819075410.GA25755@console-pimps.org>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
	 <20100818124116.GA17957@console-pimps.org>
	 <1282188497.11858.94.camel@minggr.sh.intel.com>
	 <20100819075410.GA25755@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 16:31:54 +0800
Message-ID: <1282206714.5181.552.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 15:54 +0800, Matt Fleming wrote:
> On Thu, Aug 19, 2010 at 11:28:17AM +0800, Lin Ming wrote:
> > On Wed, 2010-08-18 at 20:41 +0800, Matt Fleming wrote:
> > > 
> > > I had a quick look over the patches and Peter is right - the group
> > > events stuff would probably fit quite well here. Unfortunately, due to
> > > holidays and things, I haven't been able to get them finished
> > > yet. I'll get on that ASAP.
> > 
> > Hi, Matt
> > 
> > What's the "group events stuff"?
> > Is there some discussion on LKML or elsewhere I can have a look at?
> > 
> > Thanks,
> > Lin Ming
> 
> The relevant information can be found here in this thread,
> http://lkml.org/lkml/2010/8/4/174. I'm working on some patches for
> this but they're not finished yet. I can probably get something to
> show by next week.
> 
> The discussion started because the performance counters on SH do not
> generate an interrupt on overflow, so we need to periodically sample
> them. Am I correct in thinking that the energy counters also do not
> generate an interrupt on overflow and that's why you wrote the event
> as a software event?

right.

BTW, I'm not quite familiar with perf tool, and now I'm wondering if the
periodically sample is needed.
because IMO, .start is invoked every time the process is scheduled in,
and .stop is invoked when it's scheduled out. It seems that we just need
to read the energy consumed in .start and .stop, and update the counter
in .stop, right?

thanks,
rui

