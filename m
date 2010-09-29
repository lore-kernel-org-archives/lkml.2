Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0I2Qba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:31:30 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:55854 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0I2Qb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:31:28 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0L9IOK4-01-D5H-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 18:31:18 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929163118.GN13563@erda.amd.com>
References: <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org>
 <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com>
 <20100929125301.GG13563@erda.amd.com>
 <20100929125453.GH13563@erda.amd.com>
 <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com>
 <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
 <20100929150140.GK13563@erda.amd.com>
 <20100929151253.GL13563@erda.amd.com>
 <20100929152745.GC9440@lenovo>
 <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 11:33:07, Stephane Eranian wrote:
> There is something else bothering me with cpuc->running.
> 
> It is not reset outside of the interrupt handler. So what if
> event scheduling shuffles things around and an event is
> moved somewhere else. Don't you need to clear the
> cpuc->running[idx] for the old counter index?

We can clear it only in the NMI handler, because the next NMI after
stopping a counter must mark the counter as handled. This may cause
some false positives, but it is the best we can get.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

