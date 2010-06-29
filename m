Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab0F2Phr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:37:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46783 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab0F2Php (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:37:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M7w8oyHj0WzCxRoBKGrbnMWYVyqmfvaqE9E7DZ7RLxpgiMatsKeW95Ar1R6KHK/cre
         sNs8NmBFcqoX7ZR38fErHwnX2rS0T70TVu7UG56Yij8CvSWhCI6snrL8z5amZ/HPm1qa
         jVh+DS9kfvLNVOylb0/mn690nsOg8lro8W6X4=
Date: Tue, 29 Jun 2010 17:37:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/11] perf: Rework the PMU methods
Message-ID: <20100629153753.GI5318@nowhere>
References: <20100624142804.431553874@chello.nl> <20100624143407.106583261@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624143407.106583261@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 04:28:15PM +0200, Peter Zijlstra wrote:
> Replace pmu::{enable,disable,start,stop,unthrottle} with
> pmu::{add,del,start,stop}, all of which take a flags argument.
> 
> The new interface extends the capability to stop a counter while
> keeping it scheduled on the PMU. We replace the throttled state with
> the generic stopped state.
> 
> This also allows us to efficiently stop/start counters over certain
> code paths (like IRQ handlers).
> 
> It also allows scheduling a counter without it starting, allowing for
> a generic frozen state (useful for rotating stopped counters).
> 
> The stopped state is implemented in two different ways, depending on
> how the architecture implemented the throttled state:
> 
>  1) We disable the counter:
>     a) the pmu has per-counter enable bits, we flip that
>     b) we program a NOP event, preserving the counter state
> 
>  2) We store the counter state and ignore all read/overflow events
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

