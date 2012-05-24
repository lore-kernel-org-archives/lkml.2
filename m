Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2EXA63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:58:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49900 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab2EXA61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:58:27 -0400
Date: Wed, 23 May 2012 17:58:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
In-Reply-To: <1337788843.9783.14.camel@laptop>
Message-ID: <alpine.DEB.2.00.1205231757140.28167@chino.kir.corp.google.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org> <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com> <20120521084046.GB31407@gmail.com> <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com> <alpine.DEB.2.00.1205211932350.13682@chino.kir.corp.google.com>
 <1337688268.9698.29.camel@twins>  <1337698830.9698.37.camel@twins> <1337788843.9783.14.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Peter Zijlstra wrote:

> On Tue, 2012-05-22 at 17:00 +0200, Peter Zijlstra wrote:
> > /me goes kick his gray cells some more.
> 
> OK, does the below make your machine happy? If not, please share the
> completely topology setup of that thing (lscpu or similar).
> 

Same divide by zero.  I'd be happy to run a debugging patch if you can 
come up with one.

$ grep -E 'processor|core|sibling|physical id|apicid|cpuid' /proc/cpuinfo | sed 's/processor/\nprocessor/'
processor	: 0
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 4
initial apicid	: 0
cpuid level	: 5

processor	: 1
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 5
initial apicid	: 1
cpuid level	: 5

processor	: 2
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 6
initial apicid	: 2
cpuid level	: 5

processor	: 3
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 7
initial apicid	: 3
cpuid level	: 5

processor	: 4
physical id	: 1
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 8
initial apicid	: 4
cpuid level	: 5

processor	: 5
physical id	: 1
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 9
initial apicid	: 5
cpuid level	: 5

processor	: 6
physical id	: 1
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 10
initial apicid	: 6
cpuid level	: 5

processor	: 7
physical id	: 1
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 11
initial apicid	: 7
cpuid level	: 5

processor	: 8
physical id	: 2
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 12
initial apicid	: 8
cpuid level	: 5

processor	: 9
physical id	: 2
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 13
initial apicid	: 9
cpuid level	: 5

processor	: 10
physical id	: 2
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 14
initial apicid	: 10
cpuid level	: 5

processor	: 11
physical id	: 2
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 15
initial apicid	: 11
cpuid level	: 5

processor	: 12
physical id	: 3
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 16
initial apicid	: 12
cpuid level	: 5

processor	: 13
physical id	: 3
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 17
initial apicid	: 13
cpuid level	: 5

processor	: 14
physical id	: 3
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 18
initial apicid	: 14
cpuid level	: 5

processor	: 15
physical id	: 3
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 19
initial apicid	: 15
cpuid level	: 5
