Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2BGAps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:45:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:12200 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab2BGApr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:45:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="107123089"
Subject: Re: [patch]block: fix ioc locking warning
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
In-Reply-To: <20120207003948.GE21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
	 <20120206151219.GC30752@redhat.com> <4F2FFB21.9000202@kernel.dk>
	 <20120206163721.GF30752@redhat.com> <20120206164428.GA21292@google.com>
	 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
	 <20120206172706.GB21292@google.com> <20120206203604.GC21292@google.com>
	 <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
	 <20120207003948.GE21292@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 08:43:50 +0800
Message-ID: <1328575430.21268.69.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 16:39 -0800, Tejun Heo wrote:
> Hello,
> 
> On Tue, Feb 07, 2012 at 08:31:22AM +0800, Shaohua Li wrote:
> > Since you are talking about performance, one of our microbenchmark (swap)
> > shows a regression. Alex bisect it to be b2efa05265d62bc2, which is related to
> > the ioc change. A little strange to me, don't expect such change can cause
> > performance issue. I haven't double check the issue, but if you have
> > ideas, please let me know.
> 
> Hmmm... I think the only thing which can be made slower by that patch
> is ioc release (ie. task exits).  What does the microbench do?
Quite simple, copy kernel source to tmpfs in tight memory environment.
This will trigger swap. The bisection result appears stable.

Thanks,
Shaohua

