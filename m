Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab0KQLI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:08:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:39798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab0KQLI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:08:56 -0500
Message-ID: <4CE3B7B5.2020507@kernel.org>
Date: Wed, 17 Nov 2010 12:08:37 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Anton Blanchard <anton@au1.ibm.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com> <20101117162922.0f874a8e@kryten>
In-Reply-To: <20101117162922.0f874a8e@kryten>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 11:08:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/17/2010 06:29 AM, Anton Blanchard wrote:
> It seems like there are a number of questions around the utility of
> C/R so I'd like to take a step back from the technical discussion
> around implementation and hopefully convince you, Tejun (and anyone
> else interested) that C/R is something we want to solve in Linux.

I'm not arguing CR isn't that useful.  My argument was that it's a
solution for a fairly niche problems and that the implementation isn't
transparent at all for general use cases.

> Here at IBM we are working on the next generation of HPC systems. One
> example of this will be the NCSA Bluewaters supercomputer:

And, yeah, I agree that it is a very useful thing for HPC.

> You could argue that we should just add C/R capability to every HPC
> application and library people care about or rework them to be
> fault tolerant in software. Unfortunately I don't see either as being
> viable. There are so many applications, libraries and even programming
> languages in use for HPC that it would be a losing battle. If we
> did go down this route we would also be unable to leverage C/R for
> anything else. I can understand the concern around finding a general
> purpose case, but I do believe many other solid uses for C/R outside of
> HPC will emerge. For example, there was interest from the embedded guys
> during the KS discussion and I can easily imagine using C/R to bring up
> firefox faster on a TV.

Thanks for pointing out the use cases although for the last one it
would be much wiser to just use webkit.

> The problems found in HPC often turn into more general problems down
> the track. I think back to the heated discussions we had around SMP back
> in the early 2000s when we had 32 core POWER4s and SGI had similar sized
> machines. Now a 24 core machine fits in 1U and can be purchased for
> under $5k. NUMA support, CPU affinity and multi queue scheduling are
> other areas that initially had a very small user base but have since
> become important features for many users.

Sure, the pointy edges can discover general problems of future early.
At the same time, they also encounter problems which no one else would
care about ever, so in itself it isn't much of an argument.  I'm no
analyst and it is very difficult to foretell the future but comparing
CR to SMP and NUMA doesn't seem too valid to me.  In-kernel CR is
sandwiched between userland CR and virtualization.  Its problem space
is shrinking, not expanding.

Having a generally accepted standard CR implementation would certainly
be very nice and I understand that CR would be a much better fit for
HPC than virtualization, but I fail to see why it should be
implemented in kernel when userland implementation which doesn't
extend the kernel in any way already achieves most of what HPC
workload requires.  In this already sizeable thread, the only benefits
presented seem to be the ability to cover some more corner cases and
remote use cases in slightly more transparent manner.  Those are very
weak arguments for something as intrusive and backwards (in that it
dumps kernel states in binary blobs unrestrained by ABI) as in-kernel
CR and, as such, I don't really see the in-kernel CR surviving as a
mainline feature.

So, I think the best recourse would be identifying the specific
features which would help userland CR and improve them.  The in-kernel
CR people have been working on the problem for a long time now and
gotta know which parts are tricky and how to solve them.  In fact, I
don't think the work would be that widely different.  It would be
harder but those changes would benefit other use cases too instead of
only useful for in-kernel CR.

Thanks.

-- 
tejun
