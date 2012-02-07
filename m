Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2BGBfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:35:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:53806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab2BGBfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:35:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="104737722"
Subject: Re: [patch]block: fix ioc locking warning
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
In-Reply-To: <1328577020.21268.73.camel@sli10-conroe>
References: <20120206151219.GC30752@redhat.com> <4F2FFB21.9000202@kernel.dk>
	 <20120206163721.GF30752@redhat.com> <20120206164428.GA21292@google.com>
	 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
	 <20120206172706.GB21292@google.com> <20120206203604.GC21292@google.com>
	 <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
	 <20120207003948.GE21292@google.com>
	 <1328575430.21268.69.camel@sli10-conroe>
	 <20120207005900.GF21292@google.com>
	 <1328577020.21268.73.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 09:33:20 +0800
Message-ID: <1328578400.21268.76.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 09:10 +0800, Shaohua Li wrote:
> On Mon, 2012-02-06 at 16:59 -0800, Tejun Heo wrote:
> > On Tue, Feb 07, 2012 at 08:43:50AM +0800, Shaohua Li wrote:
> > > Quite simple, copy kernel source to tmpfs in tight memory environment.
> > > This will trigger swap. The bisection result appears stable.
> > 
> > Looked through the commit again but it really doesn't change fast
> > paths.  The only paths which can be slower are ioc and q exits.  Can
> > you please do the followings?
> > 
> > * Share the script used for microbench.  Maybe it somehow exposes
> >   slower exit path?  How much regression are we talking about?
> I need strip the script out from our test framework, but it essentially
> is a 'time copy -a tmpfs/kernelsource tmpfs/copy'. The time increased
> ~20% with 3.3-rc1.
oops, I get confused about our swap and swap-cp test. The workload with
regression is swap. which does 'time kernelbuild tmpfs/kernelsource'. we
run several such kernelbuild in the meantime to trigger swap. Very sorry
to give your wrong info before.

