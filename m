Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0HZQlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab0HZQlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:41:11 -0400
Date: Thu, 26 Aug 2010 12:40:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100826164031.GO4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100825094819.GB3198@erda.amd.com>
 <20100825104130.GA27891@elte.hu>
 <20100825110006.GB27891@elte.hu>
 <20100825201106.GH4879@redhat.com>
 <20100826090008.GA22783@erda.amd.com>
 <AANLkTim3+u-fV-RAC=Odede6BfGdYoXsN55Tqw6iSfVT@mail.gmail.com>
 <20100826152246.GN4879@redhat.com>
 <20100826153404.GA6306@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826153404.GA6306@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 07:34:04PM +0400, Cyrill Gorcunov wrote:
> > I'll keep looking for the race condition to better fix it.
> > 
> > Cheers,
> > Don
> > 
> 
> Sounds promising, mind to post new inter-diff? Ie what you have
> changed from Robert's patch.

It was really in Peter's patch, just a stupid hack for now.

Cheers,
Don


diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4539b4b..9e65a7b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -777,7 +777,9 @@ again:
 
 done:
 	intel_pmu_enable_all(0);
-	return handled;
+	if (!handled)
+		return handled;
+	return ++handled;
 }
 
 static struct event_constraint *
