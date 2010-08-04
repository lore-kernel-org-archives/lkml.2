Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0HDPqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab0HDPqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:46:18 -0400
Date: Wed, 4 Aug 2010 11:45:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804154552.GR3353@redhat.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
 <20100804100116.GH26154@erda.amd.com>
 <20100804140021.GN3353@redhat.com>
 <1280931093.1923.1194.camel@laptop>
 <20100804145203.GP3353@redhat.com>
 <1280934161.1923.1294.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280934161.1923.1294.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 05:02:41PM +0200, Peter Zijlstra wrote:
> So then the first interrupt will see 3+ overflows, return 3+, and will
> thus eat 2+ NMIs, only one of which will be the pending interrupt,
> leaving 1+ NMIs from other sources to consume unhandled.
> 
> In which case Yinghai will have to press his NMI button 2+ times before
> it registers.
> 
> That said, that might be a better situation than always consuming
> unknown NMIs.. 

Well if the worse case scenario is only one extra NMI, then I can change
the logic in my patch to eat a max of 1 possible NMI instead of 2 as in the
example you gave above.

It still won't be 100% accurate but how often are people running perf
where they need 4 counters, have to hit an external nmi button or run into
broken firmware all at the same time? :-)

Cheers,
Don

