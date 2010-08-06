Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab0HFGwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 02:52:18 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:2831 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0HFGwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 02:52:13 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L6PXQQ-02-9UL-02
X-M-MSG: 
Date: Fri, 6 Aug 2010 08:52:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100806065203.GR26154@erda.amd.com>
References: <1280931093.1923.1194.camel@laptop>
 <20100804145203.GP3353@redhat.com>
 <1280934161.1923.1294.camel@laptop>
 <20100804151858.GB5130@lenovo>
 <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100804192634.GG5130@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.10 15:26:34, Cyrill Gorcunov wrote:

> yes, that is what I meant by nmi_sc register. I think we need to restucturize
> current default_do_nmi handler but how to be with perfs I don't know at moment
> if perf register gets overflowed (ie already has pedning nmi) but we handle
> it in early nmi cycle this would lead to strange results. Need to think.
> 
> > 
> > So you can decide to either get an unrecovered nmi panic triggered by
> > a perfctr or losing unknown nmis from other sources. Maybe this can be
> > fixed by implementing handlers for those sources.

I was playing around with it yesterday trying to fix this. My idea is
to skip an unkown nmi if the privious nmi was a *handled* perfctr
nmi. I will probably post an rfc patch early next week.

Another problem I encountered is that unknown nmis from the chipset
are not reenabled, thus when hitting the nmi button I only see one
unknown nmi message per boot, if I reenable it, I get an nmi
storm firing nmi_watchdog. Uhh....

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

