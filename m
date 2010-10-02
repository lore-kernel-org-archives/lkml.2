Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0JBJv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 05:51:56 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:37715
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823Ab0JBJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 05:51:55 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zzbb2cK1dbaL1418M1432N98dNzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-WSS-ID: 0L9NPZY-01-1TJ-02
X-M-MSG: 
Date: Sat, 2 Oct 2010 11:50:22 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20101002095022.GK13563@erda.amd.com>
References: <20100915162034.GO13563@erda.amd.com>
 <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
 <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
 <20100929125301.GG13563@erda.amd.com>
 <20100929125453.GH13563@erda.amd.com>
 <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
 <20100929133923.GI13563@erda.amd.com>
 <AANLkTin2QnqsfxdZa2D07DKCM0n5bX43Ch6KqumaDW=O@mail.gmail.com>
 <AANLkTimPUmFuoGNurgW3cQm41biT5y-Gpmob-mqC=rD8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTimPUmFuoGNurgW3cQm41biT5y-Gpmob-mqC=rD8@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 10:00:54, Stephane Eranian wrote:

> > Here is another difference I noticed in x86_handle_irq() vs.
> > intel_pmu_handle_irq().
> > For Intel, handled is incremented even if there is no 64-bit overflow.
> >
> > With generic X86, it is incremented only when you have a 64-bit
> > overflow. I think that's wrong. You don't hit that condition very often
> > on AMD because counters are 47 bits wide, but this is generic code
> > and on P6 you definitively will. I believe you need to hoist handled++
> > just after the check on active_mask.
> >
> >
> > What do you think?
> >
> In other words, I think handled is there to track interrupts, i.e., hw
> counter overflows, and not 64-bit software counter overflows (which
> do trigger sample recording).

Stephane, the code looks good. We must first read the counter msr, its
raw value is returned by x86_perf_event_update(). Then we check we MSB
of the *counter* value and if it is zero, we detected a counter
overflow (not a 64 bit overflow) and increment 'handled'.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

