Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab1FPRVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:21:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:31612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab1FPRVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:21:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,376,1304319600"; 
   d="scan'208";a="14393037"
Subject: Re: [PATCHSET] stop_machine: implement
 stop_machine_from_offline_cpu()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110616121505.GB2611@htj.dyndns.org>
References: <1308071218-5912-1-git-send-email-tj@kernel.org>
	 <1308226219.13240.41.camel@twins>  <20110616121505.GB2611@htj.dyndns.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 16 Jun 2011 10:21:04 -0700
Message-Id: <1308244864.2682.361.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 05:15 -0700, Tejun Heo wrote:
> Hello, Peter.
> 
> On Thu, Jun 16, 2011 at 02:10:19PM +0200, Peter Zijlstra wrote:
> > Maybe a silly question, but why does mtrr need all this? Surely mtrr can
> > serialize state by other means than stopping all cpus. A simple mutex
> > around the shared state blocking other cpus from updating the mtrr state
> > while we're copying the state to our newly born cpu should cure things.
> 
> Hmmm... good question.  I don't know mtrr too well either but the
> stop-machine requirement seems to directly come from intel's
> specification.  I suppose Suresh can fill us in better.

Yes, It is coming from SDM guidelines of updating MTRR's. MTRR/PAT
change the memory attributes and to ensure that no one else is
simultaneously accessing memory while a cpu is changing the attributes
of that memory, we need system wide rendezvous. MTRR/PAT is not only
updated during cpu online, we allow MTRR's to be changed (and all the
cpu's need to be in sync) at runtime too.

For example, change log for the commit
d0af9eed5aa91b6b7b5049cae69e5ea956fd85c3 explains a recent issue we
encountered.

thanks,
suresh

