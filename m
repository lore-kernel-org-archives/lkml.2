Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab0ENRaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:30:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:24186 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0ENRaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YUCHg+e/DOdfNRzuZR4yS+Cbd0MP2WOn8Dc3KKCD1RBkgCO3xshoRZaX9XZlhDMoKN
         M+ClZajW8dybsHa2PlHGTVviVoFDuSSnRoTS0mD9R6iacIH/wJqsTZryhMP89FWNzgyi
         Ig0QnLALTDEmNG5hC8J9yFaCTNjHzgAPf+8yw=
Date: Fri, 14 May 2010 21:30:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
Message-ID: <20100514173012.GD13509@lenovo>
References: <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com> <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com> <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com> <1273834571.3530.82.camel@minggr.sh.intel.com> <20100514115655.GA18069@elte.hu> <20100514135240.GA4952@lenovo> <20100514145213.GA13509@lenovo> <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com> <20100514162813.GB13509@lenovo> <AANLkTinSAEATJbnj5MwhuKlBtXEGzpdeoktkzktrESvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinSAEATJbnj5MwhuKlBtXEGzpdeoktkzktrESvw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 10:06:44PM +0530, Jaswinder Singh Rajput wrote:
... 
> Ok, I added few more events and now I am able see few hardware events :
> 
> $ ./perf stat -e
> cycles,instructions,cache-references,cache-misses,branches,branch-misses,bus-cycles,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-dcache-prefetches,L1-dcache-prefetch-misses,L1-icache-loads,L1-icache-load-misses,L1-icache-prefetches,L1-icache-prefetch-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,LLC-prefetches,LLC-prefetch-misses,dTLB-loads,dTLB-load-misses,dTLB-stores,dTLB-store-misses,dTLB-prefetches,dTLB-prefetch-misses,iTLB-loads,iTLB-load-misses
> ls -lR /dev > /dev/null
> 

ok, they work as expected. Could you try only "cycles"? The things are
that different events may attempt to borrow same resources already allocated
for another event, ie they can't run simultaneously. And iirc we encode
only a subset of chache events. Though all "general" events should work.
(by "general" events I mean "cycles", "instructions", "cache-references",
 "cache-misses", "branch-instructions", "branch-misses", "bus-cycles").
Could you check them one-by-one?

	-- Cyrill
