Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0ETWqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 18:46:34 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:28252
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754699Ab0ETWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 18:46:33 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h43h64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0L2QPX8-02-4FT-02
X-M-MSG: 
Date: Fri, 21 May 2010 00:46:25 +0200
From: Robert Richter <robert.richter@amd.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520224625.GW21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <4BF46000.20203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BF46000.20203@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.05.10 18:02:40, Corey Ashford wrote:

> >  perf record -e r186A:IBS_FETCH ...
> >  perf record -e r0:IBS_FETCH -c 100000 ...
> 
> Should this raw value have been 186A0 instead of 186A?

This is the 20 bit value of the cycle count, but only bits 19:4 are
encoded in bits 15:0 of the raw ibs register. Lower 4 bits of the
cycle count must be null and thus not pushed to the register. The raw
register setup is correct.

> Where is the named type translation coming from?  Is this something
> that needs to be hard-coded into perf?

I was thinking of an enum or macro definition for the values in the
kernel. A name mapping table could be implemented at least in the
userspace, if needed maybe also in the kernel.

> Have you looked at Lin Ming's patch series?  I think it offers
> another way to support IBS and other arch-specific and off-chip PMUs
> in a more general way, though it's not quite fully-baked yet.

Yes, this could be an option too. The proposal was some days ago and a
little hidden in its subject, so I missed it first. But the concept of
registering a pmu feature looks good and could be an alternative to
the raw_value approach.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

