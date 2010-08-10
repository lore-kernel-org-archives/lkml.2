Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab0HJHt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:49:28 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:8709 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0HJHtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:49:23 -0400
X-SpamScore: 4
X-BigFish: VPS4(z3cfcs329eqz1432N98dN936eMzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L6XEPZ-02-IZC-02
X-M-MSG: 
Date: Tue, 10 Aug 2010 09:42:00 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100810074200.GE26154@erda.amd.com>
References: <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100809200245.GF6056@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100809200245.GF6056@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.08.10 16:02:45, Cyrill Gorcunov wrote:

> > @@ -1222,14 +1245,12 @@ perf_event_nmi_handler(struct notifier_block *self,
> >  	regs = args->regs;
> >  
> >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 
> If only I'm not missing something this apic_write should go up to
> "case DIE_NMIUNKNOWN" site, no?

This seems to be code from the non-nmi implementation and can be
removed at all, which should be a separate patch. The vector is
already set up.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

