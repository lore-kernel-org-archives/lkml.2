Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2CNPB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:01:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:57847 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2CNPBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:01:25 -0400
Message-ID: <1331737268.18960.125.camel@twins>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 14 Mar 2012 16:01:08 +0100
In-Reply-To: <CAKfTPtAFT-GH2SzE1--XQVaay+bwATcLOqxFpH_z=byo=ix=uw@mail.gmail.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
	 <CAKfTPtAFT-GH2SzE1--XQVaay+bwATcLOqxFpH_z=byo=ix=uw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 17:57 +0100, Vincent Guittot wrote:
> >  struct sched_avg {
> >        u64 runnable_avg_sum, runnable_avg_period;
> >        u64 last_runnable_update, decay_count;
> > +       u32 usage_avg_sum;
> 
> Why usage_avg_sum is 32bits whereas runnable_avg_sum and
> runnable_avg_period are 64bits long ? You are doing the same
> computation on these 3 variables. Only the computation need to be done
> in 64bits but the result could be saved in 32bits ? 

Since you can never use more than 100% of cpu time, usage_avg_sum is
bound to 100% of the period, which (assuming your period < ~4s) should
thus still fit in the ~4s u32 provides.

Runnable otoh is not bound by that and thus we cannot guarantee the
value stays within the ~4s value range.
