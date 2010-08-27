Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0H0Tfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:35:30 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:18821 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab0H0Tf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:35:26 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqzbb2cK1432N98dNzz1202hzz8275bhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7TT0E-02-BIV-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 21:33:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100827193349.GS22783@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100826211424.GQ4879@redhat.com>
 <20100827081038.GF22783@erda.amd.com>
 <20100827185744.GV4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100827185744.GV4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.10 14:57:44, Don Zickus wrote:
> From: Don Zickus <dzickus@redhat.com>
> Date: Fri, 27 Aug 2010 14:43:03 -0400
> Subject: [PATCH] [x86] perf: fix accidentally ack'ing a second event on intel perf counter
> 
> During testing of a patch to stop having the perf subsytem swallow nmis,
> it was uncovered that Nehalem boxes were randomly getting unknown nmis
> when using the perf tool.
> 
> Moving the ack'ing of the PMI closer to when we get the status allows
> the hardware to properly re-set the PMU bit signaling another PMI was
> triggered during the processing of the first PMI.  This allows the new
> logic for dealing with the shortcomings of multiple PMIs to handle the
> extra NMI by 'eat'ing it later.
> 
> Now one can wonder why are we getting a second PMI when we disable all
> the PMUs in the begining of the NMI handler to prevent such a case, for
> that I do not know.  But I know the fix below helps deal with this quirk.
> 
> Tested on multiple Nehalems where the problem was occuring.  With the
> patch, the code now loops a second time to handle the second PMI (whereas
> before it was not).
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Looks good to me. Thanks Don.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

