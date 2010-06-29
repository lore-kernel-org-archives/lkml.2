Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0F2O6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:58:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:37263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab0F2O6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:58:12 -0400
Subject: Re: [RFC][PATCH 09/11] perf: Default PMU ops
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100629144920.GD5318@nowhere>
References: <20100624142804.431553874@chello.nl>
	 <20100624143406.993794468@chello.nl>  <20100629144920.GD5318@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 16:57:53 +0200
Message-ID: <1277823473.1868.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 16:49 +0200, Frederic Weisbecker wrote:
> > +static void perf_pmu_start_txn(struct pmu *pmu)
> > +{
> > +     perf_pmu_disable(pmu);
> > +}
> > +
> > +static int perf_pmu_commit_txn(struct pmu *pmu)
> > +{
> > +     perf_pmu_enable(pmu);
> > +     return 0;
> > +}
> > +
> > +static void perf_pmu_cancel_txn(struct pmu *pmu)
> > +{
> > +     perf_pmu_enable(pmu);
> 
> 
> Did you mean disable here? 

Nope, start_txn() will disable the pmu, both commit_txn and cancel_txn
can be used to close the transaction and should thus enable the pmu
again.


