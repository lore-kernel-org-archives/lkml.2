Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab1JMAHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:07:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:35217 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1JMAHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:07:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="62393771"
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        ak@linux.intel.com
In-Reply-To: <CADE8fzrdMOBF1RyyEpMVi8aKcgOVKRQSKi0=c1Qvh3p6hHcXRA@mail.gmail.com>
References: <20111012160202.GA18666@sgi.com>
	 <20111012120118.e948f40a.akpm@linux-foundation.org>
	 <CADE8fzrdMOBF1RyyEpMVi8aKcgOVKRQSKi0=c1Qvh3p6hHcXRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 17:07:17 -0700
Message-ID: <1318464437.6469.16.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> Yes, the global vm_stat[] array is a problem - I'm surprised it's hung
> around for this long.  Altering the sysctl_overcommit_memory mode will
> hide the problem, but that's no good.
> 
> I think we've discussed switching vm_stat[] to a contention-avoiding
> counter scheme.  Simply using <percpu_counter.h> would be the simplest
> approach.  They'll introduce inaccuracies but hopefully any problems
> from that will be minor for the global page counters.
> 
> otoh, I think we've been round this loop before and I don't recall why
> nothing happened.

Yeah, we have had this discussion on vm_enough_memory before.  

https://lkml.org/lkml/2011/1/26/473

The current version of per cpu counter was not really suitable because
the batch size is not appropriate.  I've tried to use per cpu counter
with batch size adjusted in my attempt.  Andrew has suggested having an
elastic batch size that's proportional to the size of the central
counter but I haven't gotten around to try that out.

Tim

