Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134Ab1KJOxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:53:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab1KJOxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:53:44 -0500
Date: Thu, 10 Nov 2011 15:52:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>, Venki Pallipadi <venki@google.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf bench sched cpu-matrix benchmark
Message-ID: <20111110145201.GA29614@elte.hu>
References: <20111104115620.GA25704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104115620.GA25704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi,
> 
> During the discussion of the nohz load balancer fix 
> (https://lkml.org/lkml/2011/9/27/197), Ingo Molnar suggested
> to replace the simple while1 loop, used for publishing the 
> test results with cpu-matrix test. This patch adds cpu-matrix 
> benchmark under perf bench.
> 
> TODO:
> 	- Provide option to run main thread at real-time priority.
> 	- Provide option for changing scheduling priority/policy
> 	  of worker threads.
> 
> 
> perf bench: Add sched cpu-matrix benchmark
> 
> perf bench sched cpu-matrix benchmark is a matrix multiplication
> workload, which can be replaced with the traditional while1 
> cpu hog.
> 
> Example of usage:
> 
> % perf bench sched cpu-matrix 
> # Running sched/cpu-matrix benchmark...
> 
> Multiplication of [20] x [20] matrix, using [1] threads
>  Total time: 0.000170 [sec]
> 
> % perf bench sched cpu-matrix -s1k -t3 
> # Running sched/cpu-matrix benchmark...
> elapsed time = 0.100066 sec, progress = 27270868
> elapsed time = 0.100079 sec, progress = 27299841
> elapsed time = 0.100071 sec, progress = 27253513
> elapsed time = 0.100073 sec, progress = 27272693
> elapsed time = 0.100090 sec, progress = 10208415
> 
> Multiplication of [1024] x [1024] matrix, using [3] threads
>  Total time: 0.500495 [sec]

It would be nice to also print the *size* of the matrix, in MBs or 
so. 1024x1024 of int, long, float ... or double?

Looks pretty useful otherwise. Arnaldo, any objections?

Thanks,

	Ingo
