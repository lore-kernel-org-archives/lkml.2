Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0F2Qe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:34:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:56806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab0F2QeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:34:25 -0400
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
In-Reply-To: <20100629150305.GG5318@nowhere>
References: <20100624142804.431553874@chello.nl>
	 <20100624143406.993794468@chello.nl> <20100629145806.GE5318@nowhere>
	 <1277823591.1868.43.camel@laptop>  <20100629150305.GG5318@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 18:34:10 +0200
Message-ID: <1277829250.1868.46.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 17:03 +0200, Frederic Weisbecker wrote:
> > You mean, if (!pmu->start_txn && pmu->pmu_enable) { /* install defaults
> > */ } ?
> 
> 
> Not really. pmu_*able and txn are there for different purposes.
> A pmu implementation may want to provide enable/disable things
> but not require any txn. Or one may just not need any of those,
> like software events.
> 
> It should simply map to a nop if nothing is provided. 

Thing is, using at least the pmu_enable/disable fallback when no txn
methods are provided can save bunch of hardware writes. So this trivial
fallback makes sense.


