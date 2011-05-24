Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab1EXVhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:37:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57817 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1EXVhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:37:47 -0400
Date: Tue, 24 May 2011 23:37:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression -- missing /sys/devices/system/cpu/perf_events
Message-ID: <20110524213735.GM27634@elte.hu>
References: <alpine.DEB.2.00.1105240955050.9203@cl320.eecs.utk.edu>
 <1306246306.18455.36.camel@twins>
 <alpine.DEB.2.00.1105241341160.24062@cl320.eecs.utk.edu>
 <20110524194810.GB27634@elte.hu>
 <alpine.DEB.2.00.1105241610390.24062@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105241610390.24062@cl320.eecs.utk.edu>
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


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Tue, 24 May 2011, Ingo Molnar wrote:
> > 
> > So, what is wrong with the method Peter suggested: the presence of the perf 
> > syscall (it not returning -ENOSYS) is bona fide evidence that perf is 
> > available.
> 
> it's just hard to do that from a shell script.

Yeah.

> also, running the perf syscall can be tricky if you have a new kernel but an 
> older set of header files that doesn't have the syscall number defined.

I suspect you could add some quick band-aid like:

#ifndef __NR_perf_event_open
# ifdef __i386__
#  define __NR_perf_event_open 336
# endif
# ifdef __x86_64__ 
#  define __NR_perf_event_open 298
# endif
# ifdef __powerpc__
#  define __NR_perf_event_open 319
# endif
# ifdef __arm__
#  define __NR_perf_event_open 364
# endif
#endif

#ifndef __NR_perf_event_open
# error Please add the __NR_perf_event_open definition for this architecture!
#endif

This should cover 99% of the users - and fill in the table as people report 
build failures :)

Thanks,

	Ingo
