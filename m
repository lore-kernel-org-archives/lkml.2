Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0F2PAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:00:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57904 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab0F2PAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:00:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H9gUWed3MU6YtVWv7WwSO5fLLn61KyZdXItLkzjvyT6QXBbWzPvp8Ko8+BlmBzJhWu
         V8dZVWAiN3OxmtOmWQqp9XwnGvMNrHpySofGTohhVihzrYE4a4YoFDjPaeU+hmRjCfdF
         JgykUl4tnDnTIho8WQSWHcIFyxsn1DZj5s0Rc=
Date: Tue, 29 Jun 2010 17:00:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/11] perf: Default PMU ops
Message-ID: <20100629150005.GF5318@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143406.993794468@chello.nl> <20100629144920.GD5318@nowhere> <1277823473.1868.42.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277823473.1868.42.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 04:57:53PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-29 at 16:49 +0200, Frederic Weisbecker wrote:
> > > +static void perf_pmu_start_txn(struct pmu *pmu)
> > > +{
> > > +     perf_pmu_disable(pmu);
> > > +}
> > > +
> > > +static int perf_pmu_commit_txn(struct pmu *pmu)
> > > +{
> > > +     perf_pmu_enable(pmu);
> > > +     return 0;
> > > +}
> > > +
> > > +static void perf_pmu_cancel_txn(struct pmu *pmu)
> > > +{
> > > +     perf_pmu_enable(pmu);
> > 
> > 
> > Did you mean disable here? 
> 
> Nope, start_txn() will disable the pmu, both commit_txn and cancel_txn
> can be used to close the transaction and should thus enable the pmu
> again.


Looks like I read that while walking on my arms, sorry.

