Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab0ESHYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:24:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab0ESHYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:24:07 -0400
Date: Wed, 19 May 2010 09:23:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, Lin Ming <ming.m.lin@intel.com>,
       Greg KH <greg@kroah.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
Message-ID: <20100519072332.GE9618@elte.hu>
References: <1274233602.3036.84.camel@localhost>
 <20100518200524.GA20223@kroah.com>
 <1274236496.3603.22.camel@minggr.sh.intel.com>
 <20100519070655.GB30320@aftab>
 <1274253427.5605.10131.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274253427.5605.10131.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-05-19 at 09:06 +0200, Borislav Petkov wrote:
> > 
> > have we considered the per-cpu granularity of MCEs 
> > here and if yes, how to represent that?
> 
> Uhm, by opening the MCE event on a particular cpu? 
> Remember that sys_perf_event_open() has a cpu target.
> 
> The thing is, CPUs are assumed symmetric, thus also all 
> MCE events are symmetric, one CPU cannot generate other 
> MCE than another. So the only thing that differs is 
> where you want to listen for them.

Note, this does not preclude Linux from supporting 
assymetric MP, should the need arise: if MP assymetry is 
supported then that can (and should) be expressed in the 
sysfs topology accordingly - and the moment the assymetric 
MP topology is enumerated in sysfs it gives a place for 
the different event_source's to live there as well.

Thanks,

	Ingo
