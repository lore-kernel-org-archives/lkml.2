Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1B1OCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:02:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:27149 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab1B1OC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:02:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,239,1297065600"; 
   d="scan'208";a="714121612"
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110228090833.GA7439@elte.hu>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	 <AANLkTimAkCtPwEMzHM3A_=kWs+HbYMJ_OBvxcHo46RJg@mail.gmail.com>
	 <1298883087.4937.42.camel@minggr.sh.intel.com>
	 <20110228090833.GA7439@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 22:02:11 +0800
Message-Id: <1298901731.2169.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 17:08 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > > In other words, bit 0-3 of the umask cannot be zero.
> > 
> > I got the umask from "Table 30-20. PEBS Performance Events for Intel 
> > microarchitecture code name Sandy Bridge".
> > 
> > But from "Table A-2. Non-Architectural Performance Events In the Processor Core 
> > for Intel Core Processor 2xxx Series", the combinations are needed as you show 
> > above.
> > 
> > Which one is correct?
> 
> Since you have access to the hardware, could you please test and see it in practice 
> which one is correct?

Stephane is right, need the combination.
Sorry that I may made mistake when I tested 0xd0 pebs events.

Re-test all PEBS events, now only below 2 events need more support to
work.

PEBS_EVENT_CONSTRAINT(0x01cd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
PEBS_EVENT_CONSTRAINT(0x02cd, 0x8), /* MEM_TRANS_RETIRED.PRECISE_STORE*/

> 
> Thanks,
> 
> 	Ingo


