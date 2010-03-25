Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0CYOtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:49:49 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:59538 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab0CYOts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:49:48 -0400
Date: Thu, 25 Mar 2010 09:49:39 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Alex Shi <alex.shi@intel.com>
cc: linux-kernel@vger.kernel.org, ling.ma@intel.com,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
In-Reply-To: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1003250942080.2670@router.home>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Alex Shi wrote:

>     SLUB: Use this_cpu operations in slub
>
> The hackbench is prepared hundreds pair of processes/threads. And each
> of pair of processes consists of a receiver and a sender. After all
> pairs created and ready with a few memory block (by malloc), hackbench
> let the sender do appointed times sending to receiver via socket, then
> wait all pairs finished. The total sending running time is the indicator
> of this benchmark. The less the better.

> The socket send/receiver generate lots of slub alloc/free. slabinfo
> command show the following slub get huge increase from about 81412344 to
> 141412497, after command "backbench 150 thread 1000" running.

The number of frees is different? From 81 mio to 141 mio? Are you sure it
was the same load?

> Name                   Objects      Alloc       Free   %Fast Fallb O
> :t-0001024                 870  141412497  141412132  94   1     0 3
> :t-0000256                1607  141225312  141224177  94   1     0 1
>
>
> Via perf tool I collected the L1 data cache miss info of comamnd:
> "./hackbench 150 thread 100"
>
> On 33-rc1, about 1303976612 time L1 Dcache missing
>
> On 9dfc6, about 1360574760 times L1 Dcache missing

I hope this is the same load?

What debugging options did you use? We are now using per cpu operations in
the hot paths. Enabling debugging for per cpu ops could decrease your
performance now. Have a look at a dissassembly of kfree() to verify that
there is no instrumentation.


