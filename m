Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1FQGGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 02:06:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1FQGGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 02:06:01 -0400
Date: Fri, 17 Jun 2011 14:05:33 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.co>
Subject: Re: [patch 00/15] CFS Bandwidth Control V6
Message-ID: <20110617060533.GA2746@localhost.localdomain>
References: <20110503092846.022272244@google.com>
 <20110614065807.GA19111@localhost.localdomain>
 <4DF70DED.2030803@jp.fujitsu.com>
 <20110615083749.GA14200@localhost.localdomain>
 <4DF954E5.9060704@jp.fujitsu.com>
 <20110616094508.GA1961@localhost.localdomain>
 <4DFAAC6B.6060306@jp.fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <4DFAAC6B.6060306@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-17 14:05:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-17 14:05:37,
	Serialize complete at 2011-06-17 14:05:37
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 10:22:51AM +0900, Hidetoshi Seto wrote:
> (2011/06/16 18:45), Hu Tao wrote:
> > On Thu, Jun 16, 2011 at 09:57:09AM +0900, Hidetoshi Seto wrote:
> >> (2011/06/15 17:37), Hu Tao wrote:
> >>> On Tue, Jun 14, 2011 at 04:29:49PM +0900, Hidetoshi Seto wrote:
> >>>> (2011/06/14 15:58), Hu Tao wrote:
> >>>>> Hi,
> >>>>>
> >>>>> I've run several tests including hackbench, unixbench, massive-intr
> >>>>> and kernel building. CPU is Intel(R) Xeon(R) CPU X3430  @ 2.40GHz,
> >>>>> 4 cores, and 4G memory.
> >>>>>
> >>>>> Most of the time the results differ few, but there are problems:
> >>>>>
> >>>>> 1. unixbench: execl throughout has about 5% drop.
> >>>>> 2. unixbench: process creation has about 5% drop.
> >>>>> 3. massive-intr: when running 200 processes for 5mins, the number
> >>>>>    of loops each process runs differ more than before cfs-bandwidth-v6.
> >>>>>
> >>>>> The results are attached.
> >>>>
> >>>> I know the score of unixbench is not so stable that the problem might
> >>>> be noises ... but the result of massive-intr is interesting.
> >>>> Could you give a try to find which piece (xx/15) in the series cause
> >>>> the problems?
> >>>
> >>> After more tests, I found massive-intr data is not stable, too. Results
> >>> are attached. The third number in file name means which patchs are
> >>> applied, 0 means no patch applied. plot.sh is easy to generate png
> >>> files.
> >>
> >> (Though I don't know what the 16th patch of this series is, anyway)
> 
> I see.  It will be replaced by Paul's update.
> 
> > the 16th patch is this: https://lkml.org/lkml/2011/5/23/503
> > 
> >> I see that the results of 15, 15-1 and 15-2 are very different and that
> >> 15-2 is similar to without-patch.
> >>
> >> One concern is whether this unstable of data is really caused by the
> >> nature of your test (hardware, massive-intr itself and something running
> >> in background etc.) or by a hidden piece in the bandwidth patch set.
> >> Did you see "not stable" data when none of patches is applied?
> > 
> > Yes. 
> > 
> > But for a five-runs the result seems 'stable'(before patches and after
> > patches). I've also run the tests in single mode. results are attached.
> 
> (It will be appreciated greatly if you could provide not only raw results
> but also your current observation/speculation.)

Sorry I didn't make me clear.

> 
> Well, (to wrap it up,) do you still see the following problem?
> 
> >>>>> 3. massive-intr: when running 200 processes for 5mins, the number
> >>>>>    of loops each process runs differ more than before cfs-bandwidth-v6.

Even when before applying the patches, the numbers differ much between
several runs of massive_intr, this is the reason I say the data is not
stable. But treating the results of five runs as a whole, it shows some
stability. The results after the patches are similar, and the average
loops differ little comparing to the results before the patches(compare
0-1.png and 16-1.png in my last mail). so I would say the patches don't
bring too much impact on interactive processes.

> 
> I think that 5 samples are not enough to draw a conclusion, and that at the
> moment it is inconsiderable.  How do you think?

At least 5 samples reveal something, but if you'd like I can take more
samples.

> 
> Even though pointed problems are gone, I have to say thank you for taking
> your time to test this CFS bandwidth patch set.
> I'd appreciate it if you could continue your test, possibly against V7.
> (I'm waiting, Paul?)
> 
> 
> Thanks,
> H.Seto

Thanks,
-- 
Hu Tao
