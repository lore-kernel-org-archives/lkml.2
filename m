Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0H0H7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 03:59:49 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:51975 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0H0H7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 03:59:46 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqzbb2cK1432N98dNzz1202hzzz32i2a8h)
X-WSS-ID: 0L7SWS1-01-8BA-02
X-M-MSG: 
Date: Fri, 27 Aug 2010 09:57:37 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100827075737.GE22783@erda.amd.com>
References: <20100825094819.GB3198@erda.amd.com>
 <20100825104130.GA27891@elte.hu>
 <20100825110006.GB27891@elte.hu>
 <20100825201106.GH4879@redhat.com>
 <20100826090008.GA22783@erda.amd.com>
 <AANLkTim3+u-fV-RAC=Odede6BfGdYoXsN55Tqw6iSfVT@mail.gmail.com>
 <20100826152246.GN4879@redhat.com>
 <20100826153404.GA6306@lenovo>
 <20100826164031.GO4879@redhat.com>
 <20100826180250.GB6306@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100826180250.GB6306@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.10 14:02:50, Cyrill Gorcunov wrote:
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > index 4539b4b..9e65a7b 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -777,7 +777,9 @@ again:
> >  
> >  done:
> >  	intel_pmu_enable_all(0);
> > -	return handled;
> > +	if (!handled)
> > +		return handled;
> > +	return ++handled;
> >  }
> >  
> >  static struct event_constraint *
> > 
> 
> ok, it seems it just treat any unknown nmi as being came from PMU, no?

Yes, this just throws away all unknown nmis after a perf nmi. It
disables unknown nmi detection on this cpu type.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

