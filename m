Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1DNBET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 21:04:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:65044 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab1DNBER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 21:04:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,208,1301900400"; 
   d="scan'208";a="628259756"
Subject: Re: [patch v2 0/4] percpu_counter: cleanup and fix
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1104130907480.16214@router.home>
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
	 <alpine.DEB.2.00.1104130907480.16214@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 09:04:13 +0800
Message-ID: <1302743053.3981.178.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 22:08 +0800, Christoph Lameter wrote:
> On Wed, 13 Apr 2011, shaohua.li@intel.com wrote:
> 
> > Cleanup percpu_counter code and fix some bugs. The main purpose is to convert
> > percpu_counter to use atomic64, which is useful for workloads which cause
> > percpu_counter->lock contented. In a workload I tested, the atomic method is
> > 50x faster (please see patch 4 for detail).
> 
> Could you post your test and the results please?
the test is very simple, 24 processes in 24 CPU, and each does:
while (1) {
	mmap(128M);
	munmap(128M)
}
we then measure how many loops the process can do.
I'll attach the test in next post.
Just found when I said 50x faster, I actually forgot one other patch's
effect, which is http://marc.info/?l=linux-kernel&m=130127782901127&w=2.
If only having the atomic change, it's about 7x faster. Sorry about
this. I'll add detail data in next post.

