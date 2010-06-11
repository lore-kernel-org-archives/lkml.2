Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0FKQwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:52:33 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:28947 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab0FKQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:52:31 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432N98dN936eM62a3Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L3V07C-01-1LX-02
X-M-MSG: 
Date: Fri, 11 Jun 2010 18:52:23 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_disable()
Message-ID: <20100611165223.GO21799@erda.amd.com>
References: <1276273784.2077.2055.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1276273784.2077.2055.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.06.10 12:29:44, Peter Zijlstra wrote:
> I've been going over perf_disable() usage in kernel/perf_event.c and
> wondered if we actually need it at all.
> 
> Currently the only thing we seem to require it for is around pmu::enable
> calls (and for that powerpc at least does it itself, on x86 we rely on
> it to call ->enable_all and reprogram the pmu state).
> 
> But I can't really find any NMI races wrt data structures or the like as
> seems implied by some comments. 

Yes, it was originally used to disable nmis for some critical sections
in the non-arch code. I do not remember where this was exactly needed,
but my feeling is also this can be optimized and maybe reimplemented
as non-locking code.

We also should avoid the enable_all/disable_all() functions in the x86
implementation as it is expensive on some pmus (namely AMD). It looks
like these functions can be removed then too, or at least made model
specific only.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

