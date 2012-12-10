Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094Ab2LJSWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:22:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:39991 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2LJSWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:22:43 -0500
Date: Mon, 10 Dec 2012 19:22:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [GIT TREE] Unified NUMA balancing tree, v3
In-Reply-To: <1354839566-15697-1-git-send-email-mingo@kernel.org>
Message-ID: <alpine.LFD.2.02.1212101902050.4422@ionos>
References: <1354839566-15697-1-git-send-email-mingo@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2012, Ingo Molnar wrote:
> The SPECjbb 4x JVM numbers are still very close to the
> hard-binding results:
> 
>   Fri Dec  7 02:08:42 CET 2012
>   spec1.txt:           throughput =     188667.94 SPECjbb2005 bops
>   spec2.txt:           throughput =     190109.31 SPECjbb2005 bops
>   spec3.txt:           throughput =     191438.13 SPECjbb2005 bops
>   spec4.txt:           throughput =     192508.34 SPECjbb2005 bops
>                                       --------------------------
>         SUM:           throughput =     762723.72 SPECjbb2005 bops
> 
> And the same is true for !THP as well.

I could not resist to throw all relevant trees on my own 4node machine
and run a SPECjbb 4x JVM comparison. All results have been averaged
over 10 runs.

mainline:	v3.7-rc8
autonuma:	mm-autonuma-v28fastr4-mels-rebase
balancenuma:	mm-balancenuma-v10r3
numacore:	Unified NUMA balancing tree, v3

The config is based on a F16 config with CONFIG_PREEMPT_NONE=y and the
relevant NUMA options enabled for the 4 trees.

THP off: manual placement result:     125239

		Auto result	Man/Auto	Mainline/Auto	Variance
mainline    :	     93945	0.750		1.000		 5.91%
autonuma    :	    123651	0.987		1.316		 5.15%
balancenuma :	     97327	0.777		1.036		 5.19%
numacore    :	    123009	0.982		1.309		 5.73%


THP on: manual placement result:     143170

		Auto result	Auto/Manual	Auto/Mainline	Variance
mainline    :	    104462	0.730		1.000		 8.47%
autonuma    :	    137363	0.959		1.315		 5.81%
balancenuma :	    112183	0.784		1.074		11.58%
numacore    :	    142728	0.997		1.366		 2.94%

So autonuma and numacore are basically on the same page, with a slight
advantage for numacore in the THP enabled case. balancenuma is closer
to mainline than to autonuma/numacore.

Thanks,

	tglx


