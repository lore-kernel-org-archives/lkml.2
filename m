Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0HJQor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:44:47 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52444
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932202Ab0HJQon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:44:43 -0400
X-SpamScore: 4
X-BigFish: VPS4(z3cfcs329eqz1432N98dN936eMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L6Y3OZ-01-848-02
X-M-MSG: 
Date: Tue, 10 Aug 2010 18:41:24 +0200
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
Message-ID: <20100810164124.GK26154@erda.amd.com>
References: <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100809200245.GF6056@lenovo>
 <20100810074200.GE26154@erda.amd.com>
 <20100810161627.GB6893@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100810161627.GB6893@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.10 12:16:27, Cyrill Gorcunov wrote:
> On Tue, Aug 10, 2010 at 09:42:00AM +0200, Robert Richter wrote:
> > On 09.08.10 16:02:45, Cyrill Gorcunov wrote:
> > 
> > > > @@ -1222,14 +1245,12 @@ perf_event_nmi_handler(struct notifier_block *self,
> > > >  	regs = args->regs;
> > > >  
> > > >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > > 
> > > If only I'm not missing something this apic_write should go up to
> > > "case DIE_NMIUNKNOWN" site, no?
> > 
> > This seems to be code from the non-nmi implementation and can be
> > removed at all, which should be a separate patch. The vector is
> > already set up.
> > 
> > -Robert
> >
> 
> No, this is just a short way to unmask LVTPC (which is required for
> cpus). Actually lookig into this snippet I found that in p4 pmu
> I've made one redundant unmaksing operation. will update as only
> this area settle down.

The vector is setup in hw_perf_enable() and then never masked. The
perfctrs nmi is alwayes enabled since then. I still see no reason for
unmasking it again with every nmi. Once you handle the nmi it is also
enabled.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

