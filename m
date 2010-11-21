Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0KUXUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 18:20:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62372 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0KUXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 18:20:53 -0500
MIME-Version: 1.0
In-Reply-To: <20101117162922.0f874a8e@kryten>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com> <20101117162922.0f874a8e@kryten>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 21 Nov 2010 16:20:32 -0700
X-Google-Sender-Auth: PUmzfJUPMCg-ybMY-FTZGTyBL9I
Message-ID: <AANLkTi=JGyYF9K3c_VSktNX+4htFHQpTJeM7i0hefKWw@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
To: Anton Blanchard <anton@au1.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
        tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 10:29 PM, Anton Blanchard <anton@au1.ibm.com> wrote:
> Hi Grant,
[...]
> There are two usage scenarios for C/R in this environment:
>
> 1. Resource management. Any large HPC cluster should be 100% busy and
> as such you will often fill in the gaps with low priority jobs which
> may need to be preempted. These low priority jobs need to give up their
> resources (memory, interconnect resources etc) whenever something
> important comes in.
>
> 2. Fault tolerance. Failures are a fact of life for any decent sized
> cluster. As the cluster gets larger these failures become very common.
> Speaking from an industry perspective, MTBF rates measured in the order
> of several hours for large commodity clusters are not surprising. We at
> IBM improve on that with hardware and system design, but there is only
> so much you can do. The failures also happen at the Linux kernel level
> so even if we had 100% reliable systems we would still have issues.
>
> Now this is the pointy end of HPC, but similar issues are happening in
> the meat of the HPC market. One area we are seeing a lot of C/R
> interest is the EDA space. As ICs become more and more complex the
> amount of cluster compute power it takes to route, check, create masks
> etc grows so large that system reliability becomes an issue. Some tool
> vendors write their own application C/R, but there are a multitude of
> in house applications that have no C/R capability today.

I agree, and I think this is exactly the place where the discussions
about c/r need to be focused (the pointy end).  I don't tend to swoon
at the idea of c/r'ing my desktop session because it doesn't represent
a real or interesting problem for me.  However, I do see the value in
the scenarios described above.  I have another for you; I peripherally
worked on a telephone switch system that used a form of C/R for the
call processing task to synchronise with a hot-standby node for
uninterrupted cut-over in the event of failure.  /my/ concerns are
more of the, "what is the impact on the kernel?" type.

> You could argue that we should just add C/R capability to every HPC
> application and library people care about or rework them to be
> fault tolerant in software. Unfortunately I don't see either as being
> viable. There are so many applications, libraries and even programming
> languages in use for HPC that it would be a losing battle. If we
> did go down this route we would also be unable to leverage C/R for
> anything else.

Fair enough, and I do somewhat agree with this.  However the question
remains, what are the constraints?  What are the limitations and
boundaries?  Oden describes the constrains on the current c/r patches.
 How well do those match up with the use cases discussed above?  How
does DMTCP match up with those use cases?

> I can understand the concern around finding a general
> purpose case, but I do believe many other solid uses for C/R outside of
> HPC will emerge.For example, there was interest from the embedded guys
> during the KS discussion and I can easily imagine using C/R to bring up
> firefox faster on a TV.

Heh, sounds like doing the initial-program-load (IPL) stage like I
used to do on telephone switch firmware.  :-)

>
> The problems found in HPC often turn into more general problems down
> the track. I think back to the heated discussions we had around SMP back
> in the early 2000s when we had 32 core POWER4s and SGI had similar sized
> machines. Now a 24 core machine fits in 1U and can be purchased for
> under $5k. NUMA support, CPU affinity and multi queue scheduling are
> other areas that initially had a very small user base but have since
> become important features for many users.
>
> Anton
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
