Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab1ELCsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:48:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:21084 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1ELCsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,356,1301900400"; 
   d="scan'208";a="1151879"
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <20110511092848.GE1661@htj.dyndns.org>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:48:13 +0800
Message-ID: <1305168493.2373.15.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 17:28 +0800, Tejun Heo wrote:
> Hey, Shaohua.
> 
> On Wed, May 11, 2011 at 04:10:12PM +0800, Shaohua Li wrote:
> > The new implementation uses lglock to protect percpu data. Each cpu has its
> > private lock while other cpu doesn't take. In this way _add doesn't need take
> > global lock anymore and remove the deviation. This still gives me about
> > about 5x ~ 6x faster (not that faster than the original 7x faster, but still
> > good) with the workload mentioned in patch 4.
> 
> I'm afraid I'm not too thrilled about lglock + atomic64 usage.  It is
> a very patchy approach which addresses a very specific use case which
> might just need a higher @batch. 
It's quite hard to get a higher @batch. Please my comments in
http://marc.info/?l=linux-kernel&m=130153302319613&w=2

And the atomic64 approach not just improved the performance (which is
always welcomed), but it also fixes a bug for 32-bit system. The usage
of lglock is actually quite straightforward and is standard usage of
lglock (the comments of lglock.h declare such usage), just lglock
doesn't work for dynamatically allocated structure currently, which
needs a convert.

Thanks,
Shaohua

