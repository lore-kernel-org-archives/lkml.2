Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0HXRMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:12:09 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:45168 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0HXRMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:12:07 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L7O2CM-02-3GP-02
X-M-MSG: 
Date: Tue, 24 Aug 2010 19:09:36 +0200
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100824170936.GH26154@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100823085339.GA26713@elte.hu>
 <20100824162252.GB5723@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100824162252.GB5723@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.08.10 12:22:52, Cyrill Gorcunov wrote:
> Btw, guys, I fail to see how new nmi_watchdog work, we have
> default_do_nmi
>   if (!(reason & 0xc0)) {
>     if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == == NOTIFY_STOP)
>       return
>     if (nmi_watchdog_tick(regs, reason))
>       return
> 
> but perf_event_nmi_handler returns NOTIFY_STOP when watchdog is perf event
> and nmi_watchdog_tick _never_ called, or (most probably) I miss something?

The watchdog is disabled during profiling (perf and oprofile) by
calling disable_lapic_nmi_watchdog().

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

