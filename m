Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0IBNQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:16:30 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:31623 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab0IBNQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:16:29 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L84FAN-02-S76-02
X-M-MSG: 
Date: Thu, 2 Sep 2010 15:11:12 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second
 event on intel perf counter
Message-ID: <20100902131112.GR22783@erda.amd.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
 <20100901145728.GM22783@erda.amd.com>
 <AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.09.10 04:13:19, Stephane Eranian wrote:
> Robert,
> 
> Do you have the test program you used to test this?
> I believe the NHM hack does not solve the problem, it
> just makes it harder to appear.

For testing back-to-back nmis I have used:

 perf record -e cycles -e instructions -e cache-references
       -e cache-misses -e branch-misses -a -- sleep 10

with load on all cpus. But I couldn't reproduce this particular
problem as I do not have such a system available. I think it might
trigger also with only one counter running. What the observed from the
status bits, only one counter was involved.

> 
> I suspect the real issue is that the GLOBAL_STATUS
> bitmask cannot be trusted. I'd like to verify this.

So yes, it looks like it is a cpu bug with a race then clearing the
status. I didn't check the errata list, maybe it is already known.

> 
> Has the problem appear only on Nehalem or also on
> Westmere?

I don't know.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

