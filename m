Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1GEIxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 04:53:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab1GEIxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 04:53:18 -0400
Date: Tue, 5 Jul 2011 10:52:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
Message-ID: <20110705085252.GA5274@elte.hu>
References: <20110621071649.862846205@google.com>
 <4E01BE6B.2090701@jp.fujitsu.com>
 <1308830816.1022.112.camel@twins>
 <20110623124310.GA15430@elte.hu>
 <4E041C6A.4000701@jp.fujitsu.com>
 <20110626103526.GA11093@elte.hu>
 <20110629040521.GG4186@localhost.localdomain>
 <20110701122824.GE28008@elte.hu>
 <20110705035813.GC4656@localhost.localdomain>
 <20110705085032.GA3169@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705085032.GA3169@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Hu Tao <hutao@cn.fujitsu.com> wrote:
> 
> > perf diff output:
> > 
> > # Baseline  Delta          Shared Object                       Symbol
> > # ........ ..........  .................  ...........................
> > #
> >      0.00%    +10.07%  [kernel.kallsyms]  [k] __lock_acquire
> >      0.00%     +5.90%  [kernel.kallsyms]  [k] lock_release
> >      0.00%     +4.86%  [kernel.kallsyms]  [k] trace_hardirqs_off_caller
> >      0.00%     +4.06%  [kernel.kallsyms]  [k] debug_smp_processor_id
> >      0.00%     +4.00%  [kernel.kallsyms]  [k] lock_acquire
> >      0.00%     +3.81%  [kernel.kallsyms]  [k] lock_acquired
> >      0.00%     +3.71%  [kernel.kallsyms]  [k] lock_is_held
> >      0.00%     +3.04%  [kernel.kallsyms]  [k] validate_chain
> >      0.00%     +2.68%  [kernel.kallsyms]  [k] check_chain_key
> >      0.00%     +2.41%  [kernel.kallsyms]  [k] trace_hardirqs_off
> >      0.00%     +2.01%  [kernel.kallsyms]  [k] trace_hardirqs_on_caller
> 
> Oh, please measure with lockdep (CONFIG_PROVE_LOCKING) turned off. No 
> production kernel has it enabled and it has quite some overhead (as 
> visible in the profile), skewing results.
> 
> >      2.04%     -0.09%  pipe-test-100k     [.] main
> >      0.00%     +1.79%  [kernel.kallsyms]  [k] add_preempt_count
> 
> I'd also suggest to turn off CONFIG_PREEMPT_DEBUG.

The best way to get a good 'reference config' to measure scheduler 
overhead on do something like:

	make defconfig
	make localyesconfig

The first step will configure a sane default kernel, the second one 
will enable all drivers that are needed on that box. You should be 
able to boot the resulting bzImage and all drivers should be built-in 
and are easily profilable.

Thanks,

	Ingo
