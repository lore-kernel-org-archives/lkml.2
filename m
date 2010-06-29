Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab0F2SHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 14:07:39 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44621 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab0F2SHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 14:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VpYXe1gWAVHD7ZMlpOj9dbYXa4/fYOQF8f6mJ6iwRaA16fy6X0ysxzDrAm1jYOL/cD
         9S1Rm7XQnhaWT15uQmXoexcd9lp/EGu8EV0HVbUD9O/egv0aUtu8Mh04fpri1+2f4Jf7
         iBaajcfdc7aVeEPxrkxgSUpFCHwsjzz/5dqGw=
Date: Tue, 29 Jun 2010 20:07:47 +0200
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
Message-ID: <20100629180745.GA11967@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143406.993794468@chello.nl> <20100629145806.GE5318@nowhere> <1277823591.1868.43.camel@laptop> <20100629150305.GG5318@nowhere> <1277829250.1868.46.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277829250.1868.46.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 06:34:10PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-06-29 at 17:03 +0200, Frederic Weisbecker wrote:
> > > You mean, if (!pmu->start_txn && pmu->pmu_enable) { /* install defaults
> > > */ } ?
> > 
> > 
> > Not really. pmu_*able and txn are there for different purposes.
> > A pmu implementation may want to provide enable/disable things
> > but not require any txn. Or one may just not need any of those,
> > like software events.
> > 
> > It should simply map to a nop if nothing is provided. 
> 
> Thing is, using at least the pmu_enable/disable fallback when no txn
> methods are provided can save bunch of hardware writes. So this trivial
> fallback makes sense.


In this case, archs should handle that by implementing their txn.

neglected pmu implementations shouldn't impact software pmus.

