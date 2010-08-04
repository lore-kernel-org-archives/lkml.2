Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab0HDSva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:51:30 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:38016
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757946Ab0HDSv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:51:29 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L6N5K4-02-FSR-02
X-M-MSG: 
Date: Wed, 4 Aug 2010 20:48:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804184806.GL26154@erda.amd.com>
References: <20100804100116.GH26154@erda.amd.com>
 <20100804140021.GN3353@redhat.com>
 <1280931093.1923.1194.camel@laptop>
 <20100804145203.GP3353@redhat.com>
 <1280934161.1923.1294.camel@laptop>
 <20100804151858.GB5130@lenovo>
 <20100804155002.GS3353@redhat.com>
 <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100804163930.GE5130@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Andi)

On 04.08.10 12:39:30, Cyrill Gorcunov wrote:
> On Wed, Aug 04, 2010 at 12:20:26PM -0400, Don Zickus wrote:

> > there.  The problem is the bits in register 0x61 are not always set
> > correctly in the case of SERRs (well at least in all the cases I have
> > dealt with).  So you can easily can a flood of unknown nmis from an SERR
> > and register 0x61 would have the PERR/SERR bits set to 0.  Fun, huh?
> 
> if there is nothing in nmi_sc the code flows into another branch. And
> it hits the problem of perf events eating all nmi giving no chance the
> others. So we take if (!(reason & 0xc0)) case and hit DIE_NMI_IPI
> (/me scratching the head why it's not under CONFIG_X86_LOCAL_APIC) and
> drop all code, unpleasant.

Only the upper 2 bits in io_61h indicate the nmi reason, so in case of
(!(reason & 0xc0)) the source simply can not be determined and all nmi
handlers in the chain must be called (DIE_NMI/DIE_NMI_IPI). The
perfctr handler then stops it.

So you can decide to either get an unrecovered nmi panic triggered by
a perfctr or losing unknown nmis from other sources. Maybe this can be
fixed by implementing handlers for those sources.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

