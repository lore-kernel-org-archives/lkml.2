Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1G1Cjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 22:39:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:2374 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1G1Cjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 22:39:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35337229"
Subject: Re: [perf] overflow/perf_count_sw_cpu_clock crashes recent kernels
From: Lin Ming <ming.m.lin@intel.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <CAF1ivSZkC71V+ownS+k0Qmi3S_HfETBkK3D+U4FYFZ=cojmoGg@mail.gmail.com>
References: <alpine.DEB.2.00.1107221210160.21367@cl320.eecs.utk.edu>
	 <alpine.DEB.2.00.1107271446460.406@cl320.eecs.utk.edu>
	 <CAF1ivSZkC71V+ownS+k0Qmi3S_HfETBkK3D+U4FYFZ=cojmoGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 10:39:47 +0800
Message-ID: <1311820787.3938.1551.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 09:54 +0800, Lin Ming wrote:
> On Thu, Jul 28, 2011 at 2:51 AM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> > Hello
> >
> >> With 3.0.0 the PAPI "overflow_allcounters" test reliably locks up my
> >> Nehalem system.
> >
> > I finally managed to narrow this down to a small test, which is attached.
> >
> > Basically measuring overflow on the perf::perf_count_sw_cpu_clock
> > event will potentially *lock up* your system from user-space.
> >
> > This seems to be a long standing bug.  It will quickly lock solid
> > my Nehalem test box on 3.0, 2.6.39 and 2.6.38.
> >
> > On a Core2 2.6.32 box the crash testing program will wedge and become
> > unkillable, but it doesn't actually kill the machine.

Hi, Vince

I re-tested current -tip tree(commit 0931941) and it works OK now.

$ ./oflo_sw_cpu_clock_crash 
Matrix multiply sum: s=27665734022509.746094
Total overflows: 3460

Could you also have a try the current -tip tree?

Lin Ming


