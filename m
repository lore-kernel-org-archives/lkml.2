Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0I2Mxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:53:43 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:17111
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753728Ab0I2Mxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:53:41 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zzbb2cK98dNzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0L9IEGC-01-97U-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 14:53:01 +0200
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
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929125301.GG13563@erda.amd.com>
References: <20100915162034.GO13563@erda.amd.com>
 <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
 <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On 29.09.10 08:26:41, Stephane Eranian wrote:
> You've applied the fix only to the generic X86 interrupt handler
> which is currently used by AMD64 processors.

(... and P4).

> It seems to me that this "in-flight interrupt after disable" problem
> may also happen on Intel and should therefore also be added
> to intel_pmu_handle_irq(). Don't you think so?

It only happens if the active_mask is used for checking single
counters for overflows.

Systems with Intel Architectural Perfmon use the status mask msr to
determine which counter overflowed. In intel_pmu_handle_irq() the
handled counter is incremented in this case even if the counter is not
active, so everything should be fine here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

