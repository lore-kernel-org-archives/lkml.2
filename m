Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab1FWMnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:43:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45218 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab1FWMnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:43:42 -0400
Date: Thu, 23 Jun 2011 14:43:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
Message-ID: <20110623124310.GA15430@elte.hu>
References: <20110621071649.862846205@google.com>
 <4E01BE6B.2090701@jp.fujitsu.com>
 <1308830816.1022.112.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308830816.1022.112.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2011-06-22 at 19:05 +0900, Hidetoshi Seto wrote:
>
> > I'll continue my test/benchmark on this v7 for a while. Though I 
> > believe no more bug is there, I'll let you know if there is 
> > something.
> 
> Would that testing include performance of a kernel without these 
> patches vs one with these patches in a configuration where the new 
> feature is compiled in but not used?
> 
> It does add a number of if (!cfs_rq->runtime_enabled) return 
> branches all over the place, some possibly inside a function call 
> (depending on what the auto-inliner does). So while the impact 
> should be minimal, it would be very good to test it is indeed so.

Yeah, doing such performance tests is absolutely required. Branches 
and instructions impact should be measured as well, beyond the cycles 
impact.

The changelog of this recent commit:

  c8b281161dfa: sched: Increase SCHED_LOAD_SCALE resolution

gives an example of how to do such measurements.

Thanks,

	Ingo
