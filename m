Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0DUJW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:22:26 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:6153 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753106Ab0DUJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:22:25 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz1432P98dN936eM4015L62a3L9371Pzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L17ZCY-02-4TF-02
X-M-MSG: 
Date: Wed, 21 Apr 2010 11:21:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
Message-ID: <20100421092145.GV11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
 <20100420160557.GT11907@erda.amd.com>
 <20100421084700.GU11907@erda.amd.com>
 <o2ibd4cb8901004210202i1ba91c3dlc775a9f7759ece68@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <o2ibd4cb8901004210202i1ba91c3dlc775a9f7759ece68@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Apr 2010 09:21:46.0094 (UTC) FILETIME=[104448E0:01CAE134]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.04.10 11:02:42, Stephane Eranian wrote:
> On Wed, Apr 21, 2010 at 10:47 AM, Robert Richter <robert.richter@amd.com> wrote:
> > On 20.04.10 18:05:57, Robert Richter wrote:
> >> > What is the problem with directly using the period here, rejecting
> >> > any value that is off range or with bottom 4 bits set?
> >>
> >> Yes, I will create an updated version of this patch.
> >
> > Stephane, do you think having the lower 4 bits set is worth an EINVAL?
> > I would rather ignore them since the accuracy is not really necessary
> > compared to a range lets say from 100000 cycles? Otherwise this will
> > make the setup of ibs much more complicated. The check could be moved
> > to userland and generate a waring or so.
> 
> Explain why you think it would be more complicated?
> If I recall there is already a function to validate the attrs:
> amd_pmu_hw_config().
> But may be you are talking about userland setup.
> 
> Here is one argument why this might be important. Some people like to
> know exactly
> the sampling period because they use a particular value, like a prime
> number. You
> chopping off the bottom 4 bits could break this logic silently.

Ok, I see your point. I was thinking of some decimal value used to set
the sample period. You will then have to check if the lower 4 bits are
set or not by doing a dec to hex conversion and so on. But I realized
that multiples of 10000 can be devided by 16 and thus all lower 4 bits
are always cleared.

So, I will check the lower 4 bits and return an error if they are set.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

