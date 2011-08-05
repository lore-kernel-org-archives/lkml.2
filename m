Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1HEPOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:14:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57993 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab1HEPOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:14:38 -0400
Subject: Re: [RFT][patch 17/18] sched: use jump labels to reduce overhead
 when bandwidth control is inactive
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Henderson <rth@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Date: Fri, 05 Aug 2011 17:14:14 +0200
In-Reply-To: <4E3C0813.5050303@redhat.com>
References: <20110722003211.GA2807@redhat.com>
	  <CAPM31R+UWijCCna5zYfn875h+KPmS4H0Lk8jW6+8JP-oDb72DA@mail.gmail.com>
	  <20110722011747.GB2807@redhat.com>
	  <CAPM31RKW+do-U8G8uL-y53BVWvr4oQbSf456A9u-SUV06tSfeg@mail.gmail.com>
	  <20110727215816.GA2515@redhat.com> <1312533036.10852.34.camel@twins>
	 <4E3C0813.5050303@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312557254.28695.12.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 08:11 -0700, Richard Henderson wrote:
> On 08/05/2011 01:30 AM, Peter Zijlstra wrote:
> > OK, so _WHY_ does that make a difference and will a next version of
> > gnu-binutils not mess that up?
> 
> The Why is micro-architectual, and I can't answer that.
> 
> But ld will never re-order the files as given on the command-line.
> There are too many functions and tables that are constructed 
> piece-wise from input sections; re-ordering them would change
> the semantics of the program.

Right, so I was wondering about things like whole-program-optimization
passes at link time. Since I've no clue why the proposed patch does what
it does, its hard to say what invariant is needed to be kept.


