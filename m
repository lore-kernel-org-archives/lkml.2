Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0KSDYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:24:51 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57664 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0KSDYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:24:50 -0500
Date: Fri, 19 Nov 2010 08:54:40 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pete@jasper.es
Subject: Re: [PATCH v3 0/7] CFS Bandwidth Control
Message-ID: <20101119032440.GA3666@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com> <4CE3931D.1000403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE3931D.1000403@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:32:29PM +0800, Lai Jiangshan wrote:
> On 10/12/2010 03:49 PM, Bharata B Rao wrote:
> > Hi,
> > 
> > Its been a while since we posted CPS hard limits (aka CFS bandwidth control
> > now) patches, hence a quick recap first:
> > 
> > - I have been working on CFS hard limits since last year and have posted
> >   a few versions of the same (last post: http://lkml.org/lkml/2010/1/5/44)
> > - Paul Turner and Nikhil Rao meanwhile started working on CFS bandwidth
> >   control and have posted a couple of versions.
> >   (last post v2: http://lwn.net/Articles/385055/)
> > 
> 
> Hi, All
> 
> 	I tried it, it works very good! It adds a very useful feature.
> It is very helpful for virtualization or cloud-computing I think.
> I hope the next version patchset of it will be sent and get merged soon.
> 
> When I tested it, my box became dead several times, infrequently, and
> I don't know how to reproduce it, but next steps may help to reproduce it:
> 
> # mount -t cgroup -o cpu xxx /mnt
> # cd /mnt
> # mkdir test
> # cd test
> # echo 5000000 > cpu.cfs_period_us
> # echo 1000000 > cpu.cfs_quota_us
> # cat /dev/zero > /dev/null &
> # echo $! > tasks
> # #make the system busy, browse websites and open many tabs in your browser etc
> # #but do NOT do things important.
> # #after some time, the system may dead. (can not respond even you type AltSysrqC)
> 

Hi Lai, Thanks for testing the patches. I haven't seen this behaviour still.
But will try out the steps you mention and see if I can reproduce it here.
Meanwhile if you find more information about the problem, do let us know.

Regards,
Bharata.
